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
	for _, v in ipairs( ents.FindByName( self.VMF.Blade1 ) ) do
		table.insert( self.TrackSwitches, v )
	end

	for _, v in ipairs( ents.FindByName( self.VMF.Blade2 ) ) do
		table.insert( self.TrackSwitches, v )
	end

	self.TrackPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
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
	self.Paths = self:GetBranchingPaths()
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

	if #self.Queue == 0 and self.SecondaryQueue == 0 and not self.IronOverride then
		self.AlternateTrack = false
	else
		self:TriggerSwitch()
	end

	-- Process logic
	self:NextThink( CurTime() + 1.0 )
end

function ENT:Switching()
	if self.AlternateTrack then
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Open", "", 0, self, self )
		end
	elseif not self.AlternateTrack then
		for _, v in ipairs( self.TrackSwitches ) do
			v:Fire( "Close", "", 0, self, self )
		end
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
	local pos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )
	local current_path = pos[ 1 ].path.id
	local adjacent_paths = {}
	local paths = {}
	-- Extract adjacent paths from branches
	local function collectBranchPaths( node )
		if node.branches then
			for _, branch in pairs( node.branches ) do
				local branch_path = branch[ 2 ] and branch[ 2 ].path
				if branch_path and branch_path ~= current_path then table.insert( adjacent_paths, branch_path ) end
			end
		end
	end

	-- Add current path and branches from node1 and node2
	collectBranchPaths( pos[ 1 ].node1 )
	collectBranchPaths( pos[ 1 ].node2 )
	-- Output results
	print( "Current Path:", current_path )
	print( "Adjacent Paths:" )
	paths[ current_path ] = true
	for i, adj_path in ipairs( adjacent_paths ) do
		paths[ adj_path.id ] = true
	end
	return paths
end