AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/lilly/uf/tram/sgauge/switch_motor.mdl" )
	Metrostroi.DropToFloor( self )
	self.ID = self.VMF.ID
	self.Queue = {}
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false
	self.InhibitSwitching = false
	self.SignalCaller = {}
	self.LastSignalTime = 0
	self.Left = self.VMF.PositionCorrespondance or "alt"
	self.TrackSwitches = {}
	table.insert( self.TrackSwitches, ents.FindByName( self.VMF.Blade1 ) )
	table.insert( self.TrackSwitches, ents.FindByName( self.VMF.Blade2 ) )
	self.TrackPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.PairedControllers = {}
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

function ENT:Occupied()
	-- Check if the blades are still occupied by one node length
	local pos = self.TrackPos
	if not pos then return end
	local trackOccupied = UF.IsTrackOccupied( pos.node1, pos.x, pos.forward, "switch" )
	self.InhibitSwitching = false
end

function ENT:Think()
	self.TrackPos = self.TrackPos or Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	if not self.ID then self.ID = self.VMF.ID end
	if not next( self.TrackSwitches ) then return end
	self:Switching()
	if #self.Queue == 0 then
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

function ENT:TriggerSwitch()
	-- Check if there's a command in the queue
	if #self.Queue == 0 then
		self.AlternateTrack = false
		print( "Empty queue. Bailing to default." )
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
	-- Check if the entity is already in the queue
	if not self.Queue then self.Queue = {} end
	if next( self.Queue ) then
		for i, entry in ipairs( self.Queue ) do
			if entry[ 2 ] == ent then
				-- Entity is in the queue, check if it's still on track
				local TargetX = Metrostroi.GetPositionOnTrack( ent:GetPos() )[ 1 ].x
				local trainStillHere = UF.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, self.TrackPos.x < TargetX, "light", TargetX )
				print( trainStillHere )
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