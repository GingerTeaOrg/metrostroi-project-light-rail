AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/props_interiors/airportdeparturerampcontrol01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self.ControllerID = self.VMF and self.VMF.ControllerID or self:GetNW2Int( "ControllerID", self.ControllerID )
	self.Data = self.Data or {}
	self.PairedEntities = self.PairedEntities or {}
	self.PairedTramSignals = self.PairedTramSignals or {}
	self.PriorityRequests = self.PriorityRequests or {}
	self.PriorityRequested = false
	self.StateCounter = 0
	self.CurrentState = 0
	self.CurrentStateTab = {}
	self.CurrentStateDuration = 0
	self.LastStateSwitch = 0
	self.NextState = 0
	self.NextStateTab = {}
	if MPLR.TrafficLightControllers then MPLR.TrafficLightControllers[ self.ControllerID ] = self end
end

local exampleStates = {
	[ 1 ] = {
		lane1 = "red",
		lane2 = "green",
		lane3 = "green",
		duration = 10
	},
	[ 2 ] = {
		lane1 = "green",
		lane2 = "red",
		lane3 = "red",
		duration = 10
	},
}

function ENT:KeyValue( key, value )
	if not self.VMF then self.VMF = {} end
	self.VMF[ key ] = value
end

function ENT:Think()
	self:NextThink( CurTime() + 1 )
	if not self.Data or not self.Data or table.IsEmpty( self.Data ) then return true end
	if self.Frozen then return true end
	self:CheckPriorityRequests()
	self:ConstructLocalStates()
	self:StateTicker()
	return true
end

function ENT:StateTicker()
	local stateDuration = 0
	if self.CurrentState == 0 then -- if we've just spawned, generate our starting state, and then the next state
		self.CurrentState = 1
		self:ConstructLocalStates()
		self.CurrentStateTab = self.NextStateTab
		self.NextStateTab = {} -- we've constructed our current state, so now we start over
		self:ConstructLocalStates()
		self.LastStateSwitch = CurTime()
		return
	end

	if self.PriorityRequested and CurTime() - self.LastStateSwitch > 60 then --shorten the current phase if a train is registered
		stateDuration = 20
	else
		stateDuration = self.CurrentStateTab.duration
	end

	if CurTime() - self.LastStateSwitch > stateDuration and self.CurrentState + 1 <= #self.Data then
		self.CurrentState = self.CurrentState + 1
	elseif CurTime() - self.LastStateSwitch >= stateDuration and self.CurrentState + 1 > #self.Data then
		self.CurrentState = 1
	elseif CurTime() - self.LastStateSwitch >= stateDuration - 3 and CurTime() - self.LastStateSwitch < stateDuration then
		for k, state in pairs( self.NextStateTab ) do
			if string.find( k, "lane" ) and state == "green" then self.PairedEntities[ k ]:SetState( "red_yellow" ) end
		end
		return true
	end

	for k, state in pairs( self.CurrentStateTab ) do
		if string.find( k, "lane" ) then self.PairedEntities[ k ]:SetState( state ) end
	end
end

function ENT:ConstructLocalStates()
	self.PriorityRequested = table.IsEmpty( self.PriorityRequests )
	local nextBaseTab = self.Data[ self.CurrentState + 1 ] or self.Data[ 1 ]
	local function preparePriority()
		if table.IsEmpty( self.PriorityRequests ) then -- don't run if there is no priority requested by any signal
			return
		end

		if not self.NextStateTab.SignalEntitities then self.NextStateTab.SignalEntities = {} end
		for i = 1, #self.PriorityRequests do
			for k, v in pairs( self.PriorityRequests[ i ] ) do
				if k == "entity" and IsValid( v ) then table.insert( self.NextStateTab.SignalEntities, k ) end
				if k == "tab" then
					for lane in pairs( k ) do
						self.NextStateTab[ lane ] = "red"
					end
				end
			end
		end
	end

	preparePriority()
	for k, v in pairs( nextBaseTab ) do
		if k == "duration" then self.NextStateTab[ k ] = v end
		if not self.NextStateTab[ k ] then -- preparePriority() has not already set the state for this so we set it here
			self.NextStateTab[ k ] = v
		end
	end
end

function ENT:CheckPriorityRequests()
	for _, ent in ipairs( self.PairedTramSignals ) do
		if ent.TrainRegistered then
			table.insert( self.PriorityRequests, {
				entity = ent,
				tab = ent.PriorityParameters.IncompatibleLanes
			} )
		elseif not ent.TrainRegistered then
			for k in ipairs( self.PriorityRequests ) do
				if self.PriorityRequests[ k ].entity == ent then table.remove( self.PriorityRequests, k ) end
			end
		end
	end
end