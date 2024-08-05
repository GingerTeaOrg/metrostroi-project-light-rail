AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/metrostroi/signals/box.mdl" )
	Metrostroi.DropToFloor( self )
	self.ID = self.VMF.ID
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false
	self.InhibitSwitching = false
	self.SignalCaller = {}
	self.LastSignalTime = 0
	self.Left = self.VMF.PositionCorrespondance or "alt"
	local list = ents.FindInSphere( self:GetPos(), 128 )
	self.TrackSwitches = {}
	for k, v in pairs( list ) do
		if ( v:GetClass() == "prop_door_rotating" ) and ( string.find( v:GetName(), "blade" ) or string.find( v:GetName(), "switch" ) or string.find( v:GetName(), "swh" ) or string.find( v:GetName(), "swit" ) ) then
			table.insert( self.TrackSwitches, v )
			timer.Simple( 0.05, function() debugoverlay.Line( v:GetPos(), self:GetPos(), 10, Color( 255, 255, 0 ), true ) end )
		end
	end

	self.Queue = {}
	self.QueueSet = {}
	UF.UpdateSignalEntities()
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end

function ENT:Occupied()
	local pos = self.TrackPositionition
	if not pos then return end
	local trackOccupied = Metrostroi.IsTrackOccupied( pos.node1, pos.x, pos.forward, "switch" )
	self.InhibitSwitching = false
end

function ENT:Think()
	self.TrackPositionition = self.TrackPositionition or Metrostroi.GetPositionOnTrack( self:GetPos() )[ 1 ]
	if not next( self.TrackSwitches ) then return end
	self:Occupied()
	self:Switching()
	-- Process logic
	self:NextThink( CurTime() + 1.0 )
	return true
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

function ENT:TriggerSwitch( direction, ent )
	self:SwitchingQueue( direction, ent )
	if ent.IBIS then
		print( Format( "Switching to direction %s by service %s %s", direction, ent.IBIS.LineCourse, ent.IBIS.Route ) )
	else
		print( Format( "Switching to direction %s", direction ) )
	end

	direction = string.lower( direction )
	if self.InhibitSwitching then
		print( "switching blocked" )
		return false
	end

	if not self.Queue[ ent ] then
		self.AlternateTrack = false
		return
	end

	if self.Queue[ ent ] and self.Queue[ ent ][ 1 ] > 1 then
		return
	else
		direction = self.Queue[ ent ][ 2 ]
	end

	if direction == "left" and self.Left == "alt" then
		self.AlternateTrack = true
	elseif direction == "left" and self.Left == "main" then
		self.AlternateTrack = false
	elseif direction == "right" and self.Left == "alt" then
		self.AlternateTrack = false
	elseif direction == "right" and self.Left == "main" then
		self.AlternateTrack = true
	elseif direction == "main" then
		self.AlternateTrack = false
	elseif direction == "alt" then
		self.AlternateTrack = true
	end
end

function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:SwitchingQueue( direction, ent )
	if self.Queue[ ent ] then
		local TargetX = Metrostroi.GetPositionOnTrack( ent:GetPos() )[ 1 ].x
		local trainStillHere = UF.IsTrackOccupied( self.TrackPosition.node1, self.TrackPosition.x, self.TrackPosition.x < TargetX, "light", TargetX )
		-- if the train isn't between the trigger and the switch motor anymore, remove it from the queue
		if not trainStillHere then self.Queue[ ent ] = nil end
		return
	else
		self.Queue[ ent ] = { #self.Queue + 1, direction }
	end
end