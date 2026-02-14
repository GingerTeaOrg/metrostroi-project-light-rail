AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self.ControllerID = self.ControllerID or self:GetNW2Int( "ControllerID" )
	self.Data = self.Data or {}
	self.LightsToGreen = {}
	self.Time = 0
	self.PairedTramSignals = self.PairedTramSignals or {}
	self.PairedTrafficLights = self.PairedTrafficLights or {}
	self.Frozen = true
	self.PriorityRequested = {}
	self.PreviousState = 0
	self.State = 0
	self.PreviousStateDuration = 0
	self.StateDuration = 0
	self.LastSwitchTime = 0
	self.YellowDuration = 2
end

local exampleStates = {
	[ 1 ] = {
		north = {
			lane1 = 10, --straight
			lane3 = 10, --turn right
		},
		south = {
			lane2 = 10, --straight
			lane4 = 10, --turn right
		},
	},
	[ 2 ] = {
		east = {
			lane5 = 10, --straight
			lane7 = 10 --turn right
		},
		west = {
			lane6 = 10, --straight
			lane8 = 10, --turn right
		}
	},
	[ 3 ] = {
		north = {
			lane9 = 10, --turn left
		},
		south = {
			lane10 = 10, --turn left
		}
	},
	[ 4 ] = {
		east = {
			lane11 = 10 --turn left
		},
		west = {
			lane12 = 10 -- turn left
		}
	}
}

function ENT:Think()
	self:NextThink( CurTime() + 1 )
	if not self.Data or not self.Data.States or #self.Data.States < 1 then return true end
	if self.Frozen then return true end
	self:StateTicker()
	self:CheckPriorityRequests()
	self:UpdateState()
	return true
end

function ENT:LoadBehaviour( data )
	self.Data = data
	self:SetStatesDuration( 0 )
	self.StatesTime = {}
	for k, v in ipairs( data.States ) do
		self.StatesTime[ k ] = self:GetStatesDuration()
		self:SetStatesDuration( self:GetStatesDuration() + v.Time )
	end

	self.Frozen = false
end

function ENT:LoadPriorityParameters( ent )
	self.PriorityList = self.PriorityList or {}
	local entPriority = { ent, ent.PriorityParameters }
	table.insert( self.PriorityList, entPriority )
end

function ENT:StateTicker()
	self.Time = CurTime()
	if self.Time - self.LastSwitchTime < self.StateDuration then return end
	self.PreviousState = self.State
	if ( self.State + 1 ) > #self.Data.States then
		self.State = 1
		self.LastSwitchTime = self.Time
		self:SetState()
		return
	end

	self.State = self.State + 1
	self.LastSwitchTime = self.Time
	self:SetState()
end

function ENT:UpdateState()
	local state = self.Data.States[ self.State ]
	if not state then return end
	self.LightsToGreen = {}
	self.StateDuration = 0
	local directions = { "north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest" }
	for _, dir in ipairs( directions ) do
		if state[ dir ] then
			for lane, duration in pairs( state[ dir ] ) do
				if duration > self.StateDuration then self.StateDuration = duration end
				table.insert( self.LightsToGreen, {
					lane = lane,
					duration = duration
				} )
			end
		end
	end
end

local examplePriority = {
	lane1 = true,
	lane6 = true
}

function ENT:SetState()
	local elapsed = self.Time - self.LastSwitchTime
	local timeRemaining = self.StateDuration - elapsed
	local preGreen = timeRemaining <= self.YellowDuration
	-- Determine next state lanes
	local nextStateIndex = self.State + 1
	if nextStateIndex > #self.Data.States then nextStateIndex = 1 end
	local nextState = self.Data.States[ nextStateIndex ]
	local nextGreenLanes = {}
	local directions = { "north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest" }
	local function checkRequestsAgainstLane( lane )
		for k in ipairs( self.PriorityRequested ) do
			if self.PriorityRequested[ k ].tab[ lane ] then return true end
		end
	end

	local laneBlockedByPriority
	for _, dir in ipairs( directions ) do
		if nextState[ dir ] then
			for lane in pairs( nextState[ dir ] ) do
				laneBlockedByPriority = checkRequestsAgainstLane( lane )
				if not laneBlockedByPriority then nextGreenLanes[ lane ] = true end
			end
		end
	end

	for _, ent in ipairs( self.PairedTrafficLights ) do
		-- Default safe state
		ent.Red = true
		ent.Yellow = false
		ent.Green = false
		-- Per-lane timing for current state
		for _, laneData in ipairs( self.LightsToGreen ) do
			if ent.Lane == laneData.lane then
				if elapsed < laneData.duration then
					ent.Green = true
					ent.Red = false
				elseif elapsed < ( laneData.duration + self.YellowDuration ) then
					ent.Yellow = true
					ent.Red = false
				end
			end
		end

		-- Red + Yellow before next state
		if preGreen and nextGreenLanes[ ent.Lane ] then
			ent.Red = true
			ent.Yellow = true
			ent.Green = false
		end
	end
end

function ENT:CheckPriorityRequests()
	for _, ent in ipairs( self.PairedTramSignals ) do
		if ent.TrainRegistered then
			table.insert( self.PriorityRequested, {
				entity = ent,
				tab = ent.PriorityParameters.IncompatibleLanes
			} )
		elseif not ent.TrainRegistered then
			for k in ipairs( self.PriorityRequested ) do
				if self.PriorityRequested[ k ].entity == ent then table.remove( self.PriorityRequest, k ) end
			end
		end
	end
end