--[[
************************************************************************************************************
************************************************************************************************************
*** This file is licensed under the CreativeCommons-NonCommercial-Attribution-ShareAlike License.        ***
*** You may freely modify and redistribute this file, as long as it is for non-commercial purposes,      *** 
*** and you must give credit to the original author and contributors that have come before,              ***
*** and share the resulting work under the same license.                                                 ***
*** On top of these terms, training AI systems with this file is prohibited!                             ***
*** Thank you!                                                                                           ***
************************************************************************************************************
************************************************************************************************************
]]
---------------------------
Metrostroi.DefineSystem( "Resistorbank" )
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	self.CamshaftMoveTimer = 0
	self.CamshaftFinishedMoving = true
	self.CamshaftMoved = false
	self.switchingMomentRegistered = false
	self.SwitchingMoment = 0
	self.ResistorCount = 20
	self.MaxResistorCurrent = 12.5
	self.EngagedResistors = 20
	self.RequestedResistors = 20
	self.PreviousTraction = 0
	self.Resistors = 20
	self.BrakingResistors = 20
	self.PreviousResistors = 20
	self.LastTick = 0
	self.Amps = 0
end

function TRAIN_SYSTEM:Think()
	if not self.Train.CoreSys.ReverserA == 4 or self.Train.CoreSys.ReverserB == 4 then self:Camshaft() end
end

function TRAIN_SYSTEM:TriggerInput( key, val )
	if self[ key ] then
		self[ key ] = val
	else
		return false
	end
end

function TRAIN_SYSTEM:Camshaft()
	if self.Train.CoreSys.ReverserA == 4 or self.Train.CoreSys.ReverserB == 4 then return self:EmergencyControl() end
	local ZE = self.Train.CoreSys.ReverserA == 3 or self.Train.CoreSys.ReverserB == 3
	local ZV = self.Train.CoreSys.ReverserA == 2 or self.Train.CoreSys.ReverserB == 2
	local cabA = self.Train.CoreSys.ReverserA ~= 0
	local cabB = self.Train.CoreSys.ReverserB ~= 0
	local throttleA = self.Train.CoreSys.ThrottleStateA
	local throttleB = self.Train.CoreSys.ThrottleStateB
	local wire = self.Train:ReadTrainWire( 1 )
	local throttle = cabA and ZE and throttleA * 0.01 or cabB and ZE and throttleB * 0.01 or ZV and wire or 0
	local speed = self.Train.CoreSys.Speed
	local function ilerp( value, inMin, inMax, outMin, outMax )
		-- Validate input range
		if inMin == inMax then errorNoHalt( "Input range cannot have zero length." ) end
		-- Clamp value to input range
		local clampedValue = math.max( inMin, math.min( value, inMax ) )
		-- Perform inverse linear interpolation
		local t = ( clampedValue - inMin ) / ( inMax - inMin )
		-- Scale to output range
		return math.Round( outMin + t * ( outMax - outMin ), 0 )
	end

	local speedQuotient = ( Lerp( throttle, 0, 1 ) / Lerp( speed, 0, 80 ) ) * 100
	if throttle == 0 then
		self.RequestedResistors = 0
		self.EngagedResistors = 0
	end

	if speed < 20 then
		if speed < 3 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 6 )
			elseif throttle <= 0 and speed > 5 then
				self.RequestedResistors = Lerp( throttle, 15, 20 )
			elseif throttle <= 0 and speed < 5 then
				self.BrakingResistors = 20
				self.RequestedResistors = 0
				self.EngagedResistors = 0
			end
		elseif speed <= 4 and speed > 3 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 7 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 18, 19 )
			end
		elseif speed <= 20 and speed > 15 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 7 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 16, 17 )
			end
		end
	elseif speed > 20 and speed <= 40 then
		if speed < 25 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 9 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 15, 16 )
			end
		elseif speed <= 30 and speed > 25 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 11 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 14, 15 )
			end
		elseif speed <= 35 and speed > 30 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 13 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 13, 14 )
			end
		elseif speed <= 40 and speed > 35 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 15 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 12, 13 )
			end
		end
	elseif speed > 40 and speed <= 60 then
		if speed < 45 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 17 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 11, 12 )
			end
		elseif speed <= 50 and speed > 45 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 18 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 10, 11 )
			end
		elseif speed <= 55 and speed > 50 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 19 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 9, 10 )
			end
		elseif speed <= 60 and speed > 55 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 20 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 8, 9 )
			end
		end
	elseif speed > 60 and speed <= 80 then
		if speed < 65 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 20 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 7, 8 )
			end
		elseif speed <= 70 and speed > 65 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 20 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 6, 7 )
			end
		elseif speed <= 75 and speed > 70 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 20 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 5, 6 )
			end
		elseif speed <= 80 and speed > 75 then
			if throttle > 0 then
				self.RequestedResistors = ilerp( throttle, 0, 1, 0, 20 )
			elseif throttle <= 0 then
				self.BrakingResistors = Lerp( throttle, 0, 5 )
			end
		end
	end

	self:Engine()
	--PrintMessage( HUD_PRINTTALK, self.RequestedResistors .. " " .. self.EngagedResistors .. " " .. speedQuotient )
	return self.EngagedResistors, self.BrakingResistors
end

function TRAIN_SYSTEM:Engine()
	local sys = self.Train.CoreSys
	-- 250A per motor, 2x250A, 600V, 20 resistors, 12.5A per resistor
	-- camshaft only moves when you're actually in gear
	local prevGear = prevGear or false
	local inGear = ( self.ReverserLeverStateA ~= 0 and self.ReverserLeverStateA ~= 1 ) or ( self.ReverserLeverStateB ~= 0 and self.ReverserLeverStateB ~= 1 ) or ( self.Train:ReadTrainWire( 3 ) > 0 or self.Train:ReadTrainWire( 4 ) > 0 )
	local isMoving = sys.Speed > 3
	local isTractionApplied = sys.Traction ~= 0
	local latency = 0.4
	if ( self.PreviousResistors ~= self.EngagedResistors or self.RequestedResistors ~= self.EngagedResistors ) and inGear and CurTime() - self.SwitchingMoment > latency then
		self.CamshaftMoved = true
		if self.RequestedResistors > self.EngagedResistors and self.EngagedResistors < 20 then
			self.EngagedResistors = self.EngagedResistors + 1
		elseif self.RequestedResistors < self.EngagedResistors and self.EngagedResistors > 0 then
			self.EngagedResistors = self.EngagedResistors - 1
		end

		self.PreviousResistors = self.EngagedResistors
		self.SwitchingMoment = CurTime()
	elseif self.PreviousResistors == self.EngagedResistors and inGear then
		self.CamshaftMoved = false
	end

	--self.Train:SetNW2Bool( "CamshaftMoved", self.CamshaftMoved )
	self.Train:SetNW2Bool( "CamshaftMoved", self.CamshaftMoved )
end

function TRAIN_SYSTEM:EmergencyControl()
	local function ilerp( value, inMin, inMax, outMin, outMax )
		-- Validate input range
		if inMin == inMax then error( "Input range cannot have zero length." ) end
		-- Clamp value to input range
		local clampedValue = math.max( inMin, math.min( value, inMax ) )
		-- Perform inverse linear interpolation
		local t = ( clampedValue - inMin ) / ( inMax - inMin )
		-- Scale to output range
		return outMin + t * ( outMax - outMin )
	end

	local throttleSignal = self.Train:ReadTrainWire( 1 )
	local requiredResistor = 20 % ilerp( throttleSignal, 0, 1, 0, 20 )
	requiredResistor = tostring( requiredResistor ) == "nan" and 20 or requiredResistor
	requiredResistor = math.Clamp( requiredResistor, 1, 20 )
	if requiredResistor ~= self.PreviousResistors then
		if requiredResistor > self.PreviousResistors and self.Resistors < 20 then
			if CurTime() - self.LastTick > 5 then
				self.LastTick = CurTime()
				self.Resistors = self.Resistors + 1
				self.PreviousResistors = self.Resistors
			end
		elseif requiredResistor < self.PreviousResistors and self.Resistors > 0 then
			if CurTime() - self.LastTick > 5 then
				self.LastTick = CurTime()
				self.Resistors = self.Resistors - 1
				self.PreviousResistors = self.Resistors
			end
		end
	end
	--print( requiredResistor, throttleSignal, self.PreviousResistors )
	return resistors
end