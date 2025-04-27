AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/lilly/uf/tram/sgauge/switch_motor.mdl" )
	--Metrostroi.DropToFloor( self )
	self.TrackSwitches = {}
	self.ID = self.VMF.ID
	self.Queue = {}
	self.SecondaryQueue = {}
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false
	self.InhibitSwitching = false
	self.SignalCaller = {}
	self.LastSignalTime = 0
	self.Left = self.VMF.PositionCorrespondance or "alt"
	self.AllowSwitchingIron = tonumber( self.VMF.AllowSwitchingIron, 10 ) > 0
	self.IronOverride = false
	self.IronOverrideTime = 0
	self.Locked = true
	self.PreviousState = self.AlternateTrack
	for _, v in ipairs( ents.FindByName( self.VMF.Blade1 ) ) do
		table.insert( self.TrackSwitches, v )
	end

	for _, v in ipairs( ents.FindByName( self.VMF.Blade2 ) ) do
		table.insert( self.TrackSwitches, v )
	end

	self.TrackPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	timer.Simple( 15, function()
		self.TrackPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
		local reversePosition = self.VMF.ReverseTrackOrientationLogic and tonumber( self.VMF.ReverseTrackOrientationLogic, 10 ) > 0 or true
		self.Forward = self.TrackPos.forward and reversePosition and false or not self.TrackPos.forward and reversePosition and true or self.TrackPos.forward and not reversePosition and true or not self.TrackPos.forward and not reversePosition and false
	end )

	self.PairedControllers = {}
	self.ControllerHierarchy = {}
	self.AllowSwitchingIron = tonumber( self.VMF.AllowSwitchingIron, 10 ) > 0
	UF.UpdateSignalEntities()
	hook.Add( "EntityRemoved", "Switching" .. self:EntIndex(), function( ent )
		for i, entry in ipairs( self.Queue ) do
			if entry[ 2 ] == ent then
				table.remove( self.Queue, i )
				return
			end
		end
	end )

	self.Paths = {}
	if next( Metrostroi.Paths ) then
		self.Paths = self:GetBranchingPaths()
	else
		timer.Simple( 20, function()
			print( "Searching branching paths for switch:", self )
			self.Paths = self:GetBranchingPaths()
		end )

		timer.Simple( 15, function()
			if next( self.Paths ) then
				if not UF.SwitchBranches then UF.SwitchBranches = {} end
				UF.SwitchBranches[ self ] = self.Paths
			end
		end )
	end
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end

function ENT:Think()
	self.TrackPos = self.TrackPos or Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	if not self.ID then self.ID = self.VMF.ID end
	if not next( self.TrackSwitches ) then return end
	self:Switching()
	if self.IronOverride and CurTime() - self.IronOverrideTime < 60 then
		return
	else
		self.IronOverride = false
		self.IronOverrideTime = 0
	end

	if #self.Queue > 0 then self:TriggerSwitch() end
	-- Process logic
	self:NextThink( CurTime() + 1.0 )
	return true
end

function ENT:Switching()
	if self.PreviousState ~= self.AlternateTrack then self.Locked = false end
	if self.Locked then
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Lock", "", 0, self, self )
		end
	else
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Unlock", "", 0, self, self )
		end
	end

	if self.AlternateTrack and not self.Locked then
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Open", "", 0, self, self )
		end

		self.Locked = true
		self.PreviousState = self.AlternateTrack
	elseif not self.AlternateTrack and not self.Locked then
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Close", "", 0, self, self )
		end

		self.Locked = true
		self.PreviousState = self.AlternateTrack
	end
end

function ENT:ManualSwitching( dir, ply )
	self.IronOverride = true
	self.AlternateTrack = dir
	self.IronOverrideTime = CurTime()
	ply:PrintMessage( HUD_PRINTTALK, "Selected switch now manually switched and locked for 60 seconds. Switching back manually is also possible." )
end

function ENT:TriggerSwitch()
	-- Check if there's a command in the queue
	if #self.Queue == 0 then
		if not self.IronOverride then self.AlternateTrack = false end
		--print( "Empty queue. Bailing to default." )
		return
	end

	local ent, direction = unpack( self.Queue[ 1 ] )
	if not IsValid( ent ) then
		self.AlternateTrack = false
		for i, entry in ipairs( self.Queue ) do
			if entry[ 2 ] == ent then
				table.remove( self.Queue, i )
				return
			end
		end
		return
	end

	if ent.IBIS and not ent.IBIS.Override then
		print( Format( "Switching to direction %s by service %s %s", direction, ent.IBIS.Course, ent.IBIS.Route ) )
	elseif IsValid( ent ) then
		print( Format( "Switching to direction %s", direction ) )
	end

	if self.InhibitSwitching then
		print( "switching blocked" )
		return false
	end

	-- Determine if we need to switch the track based on the direction
	direction = string.lower( direction )
	if direction == "main" then
		self.AlternateTrack = false
	elseif direction == "alt" then
		self.AlternateTrack = true
	elseif direction == "left" then
		self.AlternateTrack = self.Left == "alt"
	elseif direction == "right" then
		self.AlternateTrack = self.Left == "main"
	end

	self:SwitchingQueue( nil, ent )
end

function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:SwitchingQueue( direction, ent )
	local function iterateForward( node )
		if node.next then
			return iterateForward( node.next )
		else
			return node
		end
	end

	local function iterateBackward( node )
		if node.prev then
			return iterateBackward( node.prev )
		else
			return node
		end
	end

	local function checkInRange()
		local inRange
		for k in pairs( self.PairedControllers ) do
			local targetPos = Metrostroi.GetPositionOnTrack( k:GetPos() )[ 1 ]
			local TargetX = targetPos.x
			local targetNode = targetPos.node1
			local dir = targetPos.forward
			local path = targetPos.path
			if self.TrackPos.path == path then
				inRange = UF.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, self.TrackPos.x < TargetX, "light", TargetX )
			else
				if dir then
					local lastNode = iterateForward( self.TrackPos.node1 )
					inRange = UF.IsTrackOccupied( targetNode, TargetX, dir, "light", lastNode.x )
				else
					local lastNode = iterateBackward( self.TrackPos.node1 )
					inRange = UF.IsTrackOccupied( targetNode, TargetX, dir, "light", lastNode.x )
				end
			end

			if inRange then return true end
		end
		return false
	end

	-- Check if the entity is already in the queue
	if not self.Queue then self.Queue = {} end
	if next( self.Queue ) then
		for i, entry in ipairs( self.Queue ) do
			if entry[ 1 ] == ent then
				-- Entity is in the queue, check if it's still on track
				local trainStillHere = checkInRange()
				-- If train is no longer here, remove it from the queue
				if not trainStillHere then table.remove( self.Queue, i ) end
				return
			end
		end
	elseif not next( self.Queue ) and next( self.SecondaryQueue ) then
		for i, entry in ipairs( self.SecondaryQueue ) do
			if entry[ 1 ] == ent then
				-- Entity is in the queue, check if it's still on track
				local trainStillHere = checkInRange()
				-- If train is no longer here, remove it from the queue
				if not trainStillHere then table.remove( self.Queue, i ) end
				return
			end
		end
	else
		-- If the entity wasn't found in the queue, add it
		if IsValid( ent ) and direction then table.insert( self.Queue, { ent, direction } ) end
	end
end

function ENT:SecondarySwitchingQueue( direction, ent )
	local tempEnt
	if IsValid( ent ) then
		for i in ipairs( self.SecondaryQueue ) do
			tempEnt = self.SecondaryQueue[ i ][ 1 ]
		end

		if IsValid( tempEnt ) and tempEnt ~= ent then table.insert( self.SecondaryQueue, { ent, direction } ) end
	end
end

function ENT:GetBranchingPaths()
	if not next( Metrostroi.Paths ) then -- if the paths table isn't populated yet, just start a timer to call this function again and exit
		timer.Simple( 10, self:GetBranchingPaths() )
		return
	end

	local pos = UF.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ] -- query our position on the pathing system
	local current_path = pos.path.id --this is our main path
	local adjacent_paths = {} -- initialise the paths next to us
	local paths = {}
	local forward = self.Forward -- are we facing upward or downward on the x coordinate?
	local function traverseNodesToBranch( node, forwards, limit ) -- got forward or backward a few nodes to see if there's a branching path to be found
		local nodesTraversed = 0 -- initialise how many nodes we've been through so that we don't continue on forever
		while node and nodesTraversed < limit do
			if node.branches then
				print( "Switch entity:", self, "found branch! Exiting!" )
				return node
			end

			node = forwards and node.next or node.prev
			print( "Found no branch. Continuing on. Next node:", node )
			if not node then return end
			for k, v in pairs( node ) do
				print( k, v )
			end

			nodesTraversed = nodesTraversed + 1
		end
		return node
	end

	-- pos.node1.branches[1][2].path
	local function collectBranchPaths( node ) --
		if not node then return end
		local branchingPath = node.branches and node.branches[ 1 ][ 2 ].path.id
		local branchingNode = node.branches and node.branches[ 1 ][ 2 ]
		if node.branches then
			for k, v in pairs( node.branches[ 1 ][ 2 ] ) do
				print( k, v )
			end
		end

		local myPath = pos.path.id
		if branchingPath then
			adjacent_paths = {
				[ myPath ] = pos.node1,
				[ branchingPath ] = branchingNode
			}
		else
			local traversedNode = traverseNodesToBranch( node, forward, 3 )
			if traversedNode then collectBranchPaths( traversedNode ) end
		end
	end

	-- Add current path and branches from node1 and node2
	collectBranchPaths( pos.node1 )
	-- collectBranchPaths(pos.node2)
	-- Output results
	print( "Current Path:", current_path )
	print( "Adjacent Paths:" )
	for id, node in pairs( adjacent_paths ) do
		print( id, node.id )
	end
	return adjacent_paths
end