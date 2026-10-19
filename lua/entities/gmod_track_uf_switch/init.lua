AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/lilly/uf/tram/sgauge/switch_motor.mdl" )
	--Metrostroi.DropToFloor( self )
	self.TrackSwitches = self.TrackSwitches or {}
	self.ID = self.ID or self:GetNW2Int( "ID", self.VMF and tonumber( self.VMF.SwitchID, 10 ) and tonumber( self.VMF.SwitchID, 10 ) or 000 )
	self.Queue = {}
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false
	self.InhibitSwitching = false
	self.LastSignalTime = 0
	self.Left = self.Left or self:GetNW2String( "PositionCorrespondence", self.VMF and self.VMF.PositionCorrespondance or "alt" )
	self.AllowSwitchingIron = self.AllowSwitchingIron or self:GetNW2Bool( "AllowSwitchingIron", ( self.VMF and self.VMF.AllowSwitchingIron ) and tonumber( self.VMF.AllowSwitchingIron, 10 ) > 0 or true )
	self.IronOverride = false
	self.IronOverrideTime = 0
	self.Locked = true
	self.PreviousState = self.AlternateTrack
	self.DefaultState = self.AlternateTrack
	self.Forward = false
	timer.Simple( 10, function()
		local entList = ents.GetAll()
		for i, ent in ipairs( entList ) do
			if ent:GetClass() == "gmod_track_uf_switch" then
				ent.TrackPos = Metrostroi.GetPositionOnTrack( ent:GetPos(), ent:GetAngles() )[ 1 ]
				local reversePosition = ent.VMF and ( ent.VMF.ReverseTrackOrientationLogic and tonumber( ent.VMF.ReverseTrackOrientationLogic, 10 ) > 0 ) or true
				ent.Forward = ent.TrackPos.forward and reversePosition and false or not ent.TrackPos.forward and reversePosition and false or ent.TrackPos.forward and not reversePosition and false or not ent.TrackPos.forward and not reversePosition and false
			end
		end
	end )

	self.PairedControllers = {}
	self.ControllerHierarchy = {}
	self.AllowSwitchingIron = self:GetNW2Bool( "AllowSwitchingIron", self.VMF and self.VMF.AllowSwitchingIron and tonumber( self.VMF.AllowSwitchingIron, 10 ) > 0 or false )
	MPLR.UpdateSignalEntities()
	hook.Add( "EntityRemoved", "Switching" .. self:EntIndex(), function( ent )
		if ent.BaseClass ~= "gmod_subway_mplr_base" then return end
		local entList = ents.GetAll()
		for _, entEntry in ipairs( entList ) do
			if entEntry:GetClass() == "gmod_track_uf_switch" then
				for i, entry in ipairs( entEntry.Queue ) do
					if entry[ 2 ] == ent and ent.BaseClass == "gmod_subway_mplr_base" then
						table.remove( entEntry.Queue, i )
						return
					end
				end
			end
		end
	end )

	self.Paths = {}
	self.DirectionsToPaths = {
		[ "left" ] = -1,
		[ "right" ] = -1
	}
end

function ENT:OnRemove()
	MPLR.UpdateSignalEntities()
end

function ENT:BladeNamesToEnts()
	if not self.VMF then
		if type( self.TrackSwitches[ 1 ] ) == "string" then self.TrackSwitches[ 1 ] = ents.FindByName( self.TrackSwitches[ 1 ] )[ 1 ] end
		if type( self.TrackSwitches[ 2 ] ) == "string" then self.TrackSwitches[ 2 ] = ents.FindByName( self.TrackSwitches[ 2 ] )[ 1 ] end
		return
	end

	local blade1 = ents.FindByName( self.VMF.Blade1 )
	local blade2 = ents.FindByName( self.VMF.Blade2 )
	self.TrackSwitches[ 1 ] = blade1[ 1 ]
	self.TrackSwitches[ 2 ] = blade2[ 1 ]
end

function ENT:Think()
	self:NextThink( CurTime() + 1.0 )
	self.TrackPos = self.TrackPos or Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	if table.IsEmpty( self.TrackSwitches ) or type( self.TrackSwitches[ 1 ] ) ~= "Entity" then
		self:BladeNamesToEnts()
		return true
	end

	if not self.TrackPos then
		self:NextThink( CurTime() + 1.0 )
		return true
	end

	--print( self.AlternateTrack, self.PreviousState )
	if not MPLR.SwitchEntitiesByNode[ self.TrackPos.node1 ] then MPLR.SwitchEntitiesByNode[ self.TrackPos.node1 ] = self end
	if not self.ID then self.ID = self.VMF.SwitchID end
	self:Switching()
	if #self.Queue > 0 then self:TriggerSwitch() end
	self:SwitchingQueue()
	if self.IronOverride and CurTime() - self.IronOverrideTime > 60 then
		self.IronOverride = false
		self.IronOverrideTime = 0
	end
	return true
end

function ENT:Switching()
	if self.PreviousState == self.AlternateTrack then return end
	if self.Locked then --and self.PreviousState ~= self.AlternateTrack then
		print( "unlocking before switching" )
		self.Locked = false
		self:LockUnlockBlades( false )
	end

	for _, v in ipairs( self.TrackSwitches ) do
		print( self.AlternateTrack and "Open" or "Close" )
		if IsValid( v ) then v:Fire( self.AlternateTrack and "Open" or "Close", "", 0, self, self ) end
	end

	self:LockUnlockBlades( true )
	self.Locked = true
	self.PreviousState = self.AlternateTrack
end

function ENT:LockUnlockBlades( lock )
	--print( self.Locked and "locked" or "unlocked" )
	for _, v in ipairs( self.TrackSwitches ) do
		if IsValid( v ) then v:Fire( lock and "Lock" or "Unlock", "", 0, self, self ) end
	end
end

function ENT:ManualSwitching( dir, ply )
	self.IronOverride = true
	self.AlternateTrack = dir
	self.IronOverrideTime = CurTime()
	ply:PrintMessage( HUD_PRINTTALK, "Selected switch now manually switched and locked for 60 seconds. Switching back manually is also possible." )
end

function ENT:TestTrackOccupation( train )
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	local startpos = self:GetPos() + Vector( 0, 0, 5 ) -- Origin point for the trace
	local dir = self:GetUp() -- Direction for the trace, as a unit vector
	local len = 100 -- Maximum length of the trace
	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = self
	} )

	local traceClass = ( tr.Hit and not tr.HitWorld ) and tr.GetClass and tr:GetClass() or nil
	local occupied
	--format: multiline
	if traceClass and tr.Hit and not tr.HitWorld then
		if string.find( traceClass, "gmod_subway_" ) or string.find( traceClass, "gmod_train_uf_bogey" ) or string.find( traceClass, "gmod_train_uf_wheels" ) then occupied = true end
	end

	local function checkInRange()
		local inRange
		for k in pairs( self.PairedControllers ) do
			inRange, _, whichTrain = k:checkInRange()
			if inRange then return inRange end
		end
		return false
	end

	local inTrackRange = checkInRange()
	return occupied or inTrackRange
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
		--self.AlternateTrack = false
		for i, entry in ipairs( self.Queue ) do
			if entry[ 1 ] == ent then
				table.remove( self.Queue, i )
				return
			end
		end
		return
	end

	if self.InhibitSwitching or self.Locked then
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
end

function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
	PrintTable( self.VMF )
end

function ENT:SwitchingQueue( direction, ent )
	-- Check if the entity is already in the queue
	if not self.Queue then self.Queue = {} end
	if self.Queue[ 1 ] then
		for i, entry in ipairs( self.Queue ) do
			--PrintTable( entry )
			if type( entry[ 1 ] ) == "Entity" then
				-- Entity is in the queue, check if it's still on track
				local trainStillHere = self:TestTrackOccupation()
				print( trainStillHere )
				-- If train is no longer here, remove it from the queue
				if not trainStillHere then table.remove( self.Queue, i ) end
				continue
			end
		end
	else
		-- If the entity wasn't found in the queue, add it
		if ( type( ent ) == "entity" and IsValid( ent ) and direction ) or ( type( ent ) == "table" and direction ) then
			--
			table.insert( self.Queue, { ent, direction } )
		end
	end

	if #self.Queue == 0 and not self.IronOverride then self.AlternateTrack = false end
end

function ENT:TriggerRouteSwitching( direction, route )
	if not self.Queue then self.Queue = {} end
	print( "Responding to route command", route, direction )
	self:SwitchingQueue( direction, route )
end