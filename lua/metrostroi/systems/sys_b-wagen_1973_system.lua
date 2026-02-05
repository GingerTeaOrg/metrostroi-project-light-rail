Metrostroi.DefineSystem( "duewag_b_1973" )
function TRAIN_SYSTEM:Initialize()
	self.ReverserStates = {
		[ "RH" ] = -1,
		[ "0" ] = 0,
		[ "*" ] = 1,
		[ "VH" ] = 2,
		[ "A" ] = 3,
		[ "Nf" ] = 4,
		[ "NF" ] = 4
	}

	self.BlinkersLeft = {
		[ 8 ] = true,
		[ 9 ] = true,
	}

	self.BlinkersRight = {
		[ 10 ] = true,
		[ 11 ] = true
	}

	self.BrakeLightLeft = {
		[ 4 ] = true
	}

	self.BrakeLightRight = {
		[ 5 ] = true
	}

	self.CircuitBreakerUnlocked = false
	self.CircuitOn = 0
	self.IgnitionKeyA = false
	self.IgnitionKeyAIn = false
	self.UncoupleKeyA = false
	self.IgnitionKeyB = false
	self.IgnitionKeyBIn = false
	self.UncoupleKeyB = false
	self.ReverserA = 0 -- -1 = RH, 0 = 0, 1 = *, 2 = VH, 3 = A, 4 = Nf
	self.ReverserB = 0
	self.ThrottleStateA = 0
	self.ThrottleRateA = 0
	self.ThrottleStateB = 0
	self.ThrottleRateB = 0
	self.BatteryActivated = false
	self.CircuitBreakerOn = false
	self.PreviousCircuitBreaker = false
	self.PantographRaised = false
	self.MirrorLeft = false
	self.MirrorRight = false
	self.WiperState = 0
	self.StepStates = {
		[ "High" ] = 1,
		[ "Low" ] = 2,
		[ "Lowest" ] = 3
	}

	self.StepState = 0
	self.DoorUnlockStates = {
		[ "None" ] = 0,
		[ "Left" ] = 1,
		[ "Right" ] = 2
	}

	self.DoorUnlockState = 0
	self.DoorStatesRight = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.DoorStatesLeft = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.StepStatesMediumRight = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.StepStatesMediumLeft = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.StepStatesLowestRight = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.StepStatesLowestLeft = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.StepMode = 0
	self.DoorOpenMoments = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.DoorCloseMoments = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0
	}

	self.DoorCloseMomentsCalculated = false
	self.StopRequest = {
		[ 1 ] = false,
		[ 2 ] = false,
		[ 3 ] = false,
		[ 4 ] = false,
		[ 5 ] = false,
		[ 6 ] = false
	}

	self.DoorRandomness = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0,
	}

	self.RandomnessCalculated = false
	self.DoorCloseMomentsCaptured = false
	self.DoorLockMoment = 0
	self.StepSetting = 1
	self.BlinkerStates = {
		[ "Off" ] = 0,
		[ "Left" ] = 1,
		[ "Right" ] = 2,
		[ "Hazard" ] = 3
	}

	self.BlinkerState = 0
	self.BrakesAreApplied = false
	self.AIsCoupled = false
	self.BIsCoupled = false
	----blinker variables
	self.LastTriggerTime = 0
	self.BlinkerOn = false
	self.ConflictingHeads = false -- more than one head is not reverser at "0"
	self.CoupledSections = {
		[ "A" ] = false,
		[ "B" ] = false
	}

	self.BatteryActivated = false
	self.PreviousBatteryState = false
	self.Speed = 0
	self.BrakesAppliedFullSound = false
end

-- ==============================================================================================
function TRAIN_SYSTEM:Think( dT )
	self.SectionB = self.Train.SectionB
	self.FrontCoupler = self.Train.FrontCouple or nil
	self.RearCoupler = self.Train.RearCouple or nil
	self.Lights = self.Train and self.Train.Lights or nil
	self.Panto = self.Train.Panto or nil
	self.Panel = self.Train.Panel
	self.PanelB = IsValid( self.Train.SectionB ) and self.Train.SectionB.Panel
	self:ReverserParameters()
	self:ThrottleParameters()
	self:BlinkerHandler()
	self:BrakesApplied()
	self:BrakeLights()
	self:Headlights()
	self:Coupled()
	self:EnableTrainHead()
	self:ChargeBattery()
	self:BatteryOffForceLightsDark()
	self:StopRequestLoop()
	self:Traction()
	self:ReverserSystem()
	self:PantoFunction()
	self:BellHorn()
	self:MUHandler()
	--self:BrakeSounds()
	--self:MotorSounds()
	self:Mirrors()
	self:IsLVPowerAvailable()
	self.Speed = math.abs( self.Train:GetVelocity():Dot( self.Train:GetAngles():Forward() ) * 0.06858 )
end

-- ==============================================================================================
function TRAIN_SYSTEM:IgnitionKeyInOutA()
	local t = self.Train
	local function consistKey()
		local consist = t.WagonList
		if #consist > 1 then
			for j in ipairs( consist ) do
				if consist[ j ] ~= t and consist[ j ].CoreSys.IgnitionKeyA or consist[ j ].CoreSys.IgnitionKeyB then
					t:GetDriverPly():PrintMessage( HUD_PRINTTALK, "You left your ignition key in another cab. Go fetch it!" )
					return false
				end
			end
		else
			return true
		end
	end

	local keyOkay = consistKey()
	if keyOkay then
		if self.IgnitionKeyAIn and not self.IgnitionKeyA then
			self.IgnitionKeyAIn = false
		elseif not self.IgnitionKeyAIn then
			self.IgnitionKeyAIn = true
		end
	end

	t:SetNW2Bool( "IgnitionKeyIn", self.IgnitionKeyAIn )
end

function TRAIN_SYSTEM:IgnitionKeyOnA()
	local t = self.Train
	self.IgnitionKeyA = true
	t:SetNW2Bool( "IgnitionTurned", self.IgnitionKeyA )
end

function TRAIN_SYSTEM:IgnitionKeyOffA()
	local t = self.Train
	self.IgnitionKeyA = false
	t:SetNW2Bool( "IgnitionTurned", self.IgnitionKeyA )
end

function TRAIN_SYSTEM:IgnitionKeyInOutB()
	local t = self.Train
	local consist = t.WagonList
	for j = 1, #consist do
		if j == t then continue end
		if consist[ j ].CoreSys.IgnitionKeyA or consist[ j ].CoreSys.IgnitionKeyB then
			local driver = t:GetDriver()
			driver:PrintMessage( HUD_PRINTTALK, "You left your ignition key in another cab. Go fetch it!" )
			return
		else
			consist[ j ].CoreSys.IgnitionKeyAIn = false
			consist[ j ].CoreSys.IgnitionKeyBIn = false
		end
	end

	if self.IgnitionKeyBIn and not self.IgnitionKeyB then
		self.IgnitionKeyBIn = false
	elseif not self.IgnitionKeyBIn then
		self.IgnitionKeyBIn = true
	end

	self:SetSectionBNW2Bool( "IgnitionKeyIn", self.IgnitionKeyBIn )
	self.PanelB.IgnitionKeyInserted = self.IgnitionKeyBIn and 1 or 0
end

function TRAIN_SYSTEM:Coupled()
	self.CoupledSections[ "A" ] = IsValid( self.FrontCoupler.CoupledEnt )
	self.CoupledSections[ "B" ] = IsValid( self.RearCoupler ) and IsValid( self.RearCoupler.CoupledEnt )
end

function TRAIN_SYSTEM:Mirrors()
	local p = self.Train.Panel
	local t = self.Train
	t:SetNW2Int( "MirrorLeftStatus", self.BatteryActivated and p.MirrorLeft or 0 )
	t:SetNW2Int( "MirrorRightStatus", self.BatteryActivated and p.MirrorRight or 0 )
end

function TRAIN_SYSTEM:AllReversersInConsistZero()
	-- check that only one reverser is ever non-zero. There must not be
	local reverserCount = 0
	if #self.Train.WagonList < 2 then
		if self.ReverserA ~= 0 and self.ReverserB ~= 0 then --if two reversers on the same train are on then we don't even need to check the rest of the consist
			self.Train:SetNW2Bool( "ReverserConflictAlarm", false )
			return false
		else
			self.Train:SetNW2Bool( "ReverserConflictAlarm", true )
			return true
		end
	end

	for _, v in pairs( self.Train.WagonList ) do
		if v.CoreSys.ReverserA ~= 0 or v.CoreSys.ReverserB ~= 0 then reverserCount = reverserCount + 1 end
	end
	return reverserCount <= 1
end

function TRAIN_SYSTEM:EnableTrainHead()
	self.ConflictingHeads = not self:AllReversersInConsistZero()
	self.Train:SetNW2Bool( "ConflictingHeadsAlarm", self.ConflictingHeads )
	if not self.ConflictingHeads and ( self.ReverserA == 1 or self.ReverserB == 1 ) then self.BatteryUnlocked = true end
end

function TRAIN_SYSTEM:HVCircuitOn()
	if self.BatteryActivated and ( self.ReverserA == 1 or self.ReverserB == 1 ) then self.HVCircuit = true end
end

function TRAIN_SYSTEM:HVCircuitOff()
	if self.BatteryActivated and ( self.ReverserA == 1 or self.ReverserB == 1 ) then self.HVCircuit = false end
end

function TRAIN_SYSTEM:BatteryOn()
	if self.BatteryUnlocked then self.BatteryActivated = true end
	self.Train:SetNW2Bool( "BatteryOn", self.BatteryActivated )
end

function TRAIN_SYSTEM:BatteryOff()
	if self.BatteryUnlocked then self.BatteryActivated = false end
	self.Train:SetNW2Bool( "BatteryOn", self.BatteryActivated )
end

function TRAIN_SYSTEM:ReverserParameters()
	local train = self.Train
	local SectionB = train.SectionB
	if not IsValid( SectionB ) then return end
	train:SetNW2Int( "ReverserLever", self.ReverserA + 1 ) -- set the networked int for the reverser anim. We use a table clientside that starts at 0 so just +1 to current variable value
	SectionB:SetNW2Int( "ReverserLever", self.ReverserB + 1 )
end

function TRAIN_SYSTEM:ThrottleParameters()
	-- map the -100 to 100 range to 0 to 100 on the pose parameter
	local function lerp( x, x0, x1, y0, y1 )
		return y0 + ( y1 - y0 ) * ( ( x - x0 ) / ( x1 - x0 ) )
	end

	local train = self.Train
	local SectionB = train.SectionB
	if not IsValid( SectionB ) then return end
	self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 ) -- clamp the values in order to avoid some weirdness. We're only looking for -100% and 100%
	self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
	local poseParam = lerp( self.ThrottleStateA, -100, 100, 0, 100 )
	poseParam = math.Clamp( poseParam, 0, 100 )
	train:SetNW2Int( "ThrottleLever", poseParam )
	local poseParam2 = lerp( self.ThrottleStateB, -100, 100, 0, 100 )
	poseParam2 = math.Clamp( poseParam2, 0, 100 )
	SectionB:SetNW2Int( "ThrottleLever", poseParam2 )
	self.ThrottleStateA = math.Clamp( self.ThrottleStateA + self.ThrottleRateA, -100, 100 )
	self.ThrottleStateB = math.Clamp( self.ThrottleStateB + self.ThrottleRateB, -100, 100 )
end

---------------------------------------
function TRAIN_SYSTEM:ReverserDownA()
	if self.ReverserA == -1 or not self.IgnitionKeyA then return end
	self.ReverserA = self.ReverserA - 1
end

function TRAIN_SYSTEM:ReverserUpA()
	if self.ReverserA == 4 or not self.IgnitionKeyA then return end
	self.ReverserA = self.ReverserA + 1
end

function TRAIN_SYSTEM:ReverserDownB()
	if self.ReverserB == -1 or not self.IgnitionKeyB then return end
	self.ReverserB = self.ReverserB - 1
end

function TRAIN_SYSTEM:ReverserUpB()
	if self.ReverserB == 4 or not self.IgnitionKeyB then return end
	self.ReverserB = self.ReverserB + 1
end

----------------------------------------
function TRAIN_SYSTEM:MUHandler()
	local wL = self.Train.WagonList
	local t = self.Train
	if #wL > 1 and t:ReadTrainWire( 7 ) > 0 then
		self.CircuitBreakerOn = true
	elseif #wL > 1 and self.CircuitBreakerOn then
		t:WriteTrainWire( 7, 1 )
	end
end

function TRAIN_SYSTEM:BlinkerHandler()
	local t = self.Train
	local MU = #self.Train.WagonList > 1
	local MULead = ( self.ReverserA ~= 0 or self.ReverserB ~= 0 ) and #self.Train.WagonList > 1 or false
	local blinkerLeft = blinkerLeft or false
	local blinkerRight = blinkerRight or false
	if ( MU and MULead and self.Panel.BlinkerLeft > 0 ) or ( not MU and self.Panel.BlinkerLeft > 0 ) or MU and ( t:ReadTrainWire( 20 ) > 0 or t:ReadTrainWire( 22 ) > 0 ) then
		blinkerLeft = true
	elseif blinkerRight then
		blinkerLeft = false
	else
		blinkerLeft = false
	end

	if ( MU and MULead and self.Panel.BlinkerRight > 0 ) or ( not MU and self.Panel.BlinkerRight > 0 ) or MU and ( t:ReadTrainWire( 21 ) > 0 or t:ReadTrainWire( 22 ) > 0 ) then
		blinkerRight = true
	elseif blinkerLeft then
		blinkerRight = false
	else
		blinkerRight = false
	end

	local hazard = self.Panel.HazardBlink > 0 or t:ReadTrainWire( 22 ) > 0
	local enable = blinkerLeft or blinkerRight or hazard or t:ReadTrainWire( 20 ) > 0 or t:ReadTrainWire( 21 ) > 0
	local power = self.BatteryActivated -- The blinker only requires battery power, not HV
	self:Blink( enable and power, blinkerLeft or hazard, blinkerRight or hazard )
	if MULead and enable and ( t:ReadTrainWire( 20 ) < 1 or t:ReadTrainWire( 22 ) < 1 ) then
		if blinkerLeft then t:WriteTrainWire( 20, 1 ) end
		if blinkerRight then t:WriteTrainWire( 21, 1 ) end
	elseif MULead and not enable and ( t:ReadTrainWire( 20 ) > 0 or t:ReadTrainWire( 21 ) > 0 ) then
		t:WriteTrainWire( 20, 0 )
		t:WriteTrainWire( 21, 0 )
	end
end

function TRAIN_SYSTEM:Blink( enable, left, right )
	if not IsValid( self.Train.SectionB ) then return end
	if not enable then
		self.BlinkerOn = false
		self.LastTriggerTime = CurTime()
	elseif CurTime() - self.LastTriggerTime > 0.4 then
		self.BlinkerOn = not self.BlinkerOn
		self.LastTriggerTime = CurTime()
	end

	self.Train:SetLightPower( 8, self.BlinkerOn and left )
	self.Train:SetLightPower( 10, self.BlinkerOn and left )
	self.Train:SetLightPower( 9, self.BlinkerOn and right )
	self.Train:SetLightPower( 11, self.BlinkerOn and right )
	self.Train:SetLightPower( 6, self.BlinkerOn and left and right )
	self.Train:SetLightPower( 7, self.BlinkerOn and left and right )
	if self.BrakesAreApplied == true and left and right and not self.BIsCoupled then
		-- if the brakes are applied and the blinkers are on
		self.Train.SectionB:SetLightPower( 66, self.BlinkerOn and left and right )
		self.Train.SectionB:SetLightPower( 67, self.BlinkerOn and left and right )
	elseif self.BrakesAreApplied == true and left and right and self.BIsCoupled then
		-- if the brakes are applied and the blinkers are not on
		-- self.Train.SectionB:SetLightPower(66,true)
		-- self.Train.SectionB:SetLightPower(67,true)
		-- if the brakes are applied and the blinkers are on
		self.Train.SectionB:SetLightPower( 66, false )
		self.Train.SectionB:SetLightPower( 67, false )
	elseif self.BrakesAreApplied == false and left and right and not self.BIsCoupled then
		-- if the brakes are not applied and the blinkers are on
		self.Train.SectionB:SetLightPower( 66, self.BlinkerOn and left and right )
		self.Train.SectionB:SetLightPower( 67, self.BlinkerOn and left and right )
		self.Train.SectionB:SetLightPower( 66, false )
		self.Train.SectionB:SetLightPower( 67, false )
	end

	self.Train.SectionB:SetLightPower( 8, self.BlinkerOn and left )
	self.Train.SectionB:SetLightPower( 10, self.BlinkerOn and left )
	self.Train.SectionB:SetLightPower( 9, self.BlinkerOn and right )
	self.Train.SectionB:SetLightPower( 11, self.BlinkerOn and right )
	self.Train:SetNW2Bool( "BlinkerTick", self.BlinkerOn ) -- one tick sound for the blinker relay
end

function TRAIN_SYSTEM:BrakesApplied()
	self.BrakesAreApplied = ( self.ReverserA ~= 0 and self.ReverserA ~= 1 and self.ThrottleStateA < 0 ) or ( self.ReverserB ~= 0 and self.ReverserB ~= 1 and self.ThrottleStateB < 0 ) or false
end

function TRAIN_SYSTEM:Headlights()
	if self.Panel.Headlights < 1 or self.PanelB.Headlights < 1 then return end
	if self.ReverserA > 1 then
		self.Train:SetLightPower( 1, true )
		self.Train:SetLightPower( 2, true )
		self.Train:SetLightPower( 3, true )
		self.Train:SetLightPower( 4, false )
		self.Train:SetLightPower( 5, false )
		self.Train.SectionB:SetLightPower( 1, false )
		self.Train.SectionB:SetLightPower( 2, false )
		self.Train.SectionB:SetLightPower( 3, false )
		self.Train.SectionB:SetLightPower( 4, true )
		self.Train:SetLightPower( 5, true )
	else
		self.Train:SetLightPower( 1, false )
		self.Train:SetLightPower( 2, false )
		self.Train:SetLightPower( 3, false )
		self.Train:SetLightPower( 4, true )
		self.Train:SetLightPower( 5, true )
		self.Train.SectionB:SetLightPower( 1, true )
		self.Train.SectionB:SetLightPower( 2, true )
		self.Train.SectionB:SetLightPower( 3, true )
		self.Train.SectionB:SetLightPower( 4, false )
		self.Train.SectionB:SetLightPower( 5, false )
	end
end

function TRAIN_SYSTEM:BrakeLights()
	if not IsValid( self.Train.SectionB ) then return end
	if not self.Train.Battery then return end
	if self.Train.Battery.Voltage < 5 then
		self.Train:SetLightPower( 6, false )
		self.Train:SetLightPower( 7, false )
		self.Train.SectionB:SetLightPower( 6, false )
		self.Train.SectionB:SetLightPower( 7, false )
		return
	end

	self.Train:SetLightPower( 6, self.CoupledSections[ "A" ] and self.BrakesAreApplied )
	self.Train:SetLightPower( 7, self.CoupledSections[ "A" ] and self.BrakesAreApplied )
	self.Train.SectionB:SetLightPower( 6, self.CoupledSections[ "B" ] and self.BrakesAreApplied )
	self.Train.SectionB:SetLightPower( 7, self.CoupledSections[ "B" ] and self.BrakesAreApplied )
end

function TRAIN_SYSTEM:ChargeBattery()
	if not self.CircuitBreakerOn and not self.LVPowerOn then return end
	self.Train.Battery:TriggerInput( "Charge", self.PantographRaised and 2000 or 0 )
end

function TRAIN_SYSTEM:BatteryOffForceLightsDark() -- just so we don't have to do it anywhere else, if the battery state is off, make sure any light is off
	if not self.Lights then -- guard against race condition while the train is loading
		return
	end

	if self.CircuitBreakerOn then self.PreviousCircuitBreaker = self.CircuitBreakerOn end
	if self.PreviousCircuitBreaker ~= self.CircuitBreakerOn and not self.CircuitBreakerOn then
		self.PreviousCircuitBreaker = false
		for k, _ in ipairs( self.Lights ) do
			self.Train:SetLightPower( k, false )
		end
	end
end

function TRAIN_SYSTEM:StopRequestLoop()
	for _, v in ipairs( self.StopRequest ) do
		if v then
			self.StopRequestDetected = true
			break
		end
	end
end

function TRAIN_SYSTEM:Traction()
	local t = self.Train
	local doorsOpened = self.Train.DoorHandler.DoorUnlockState > 0
	local consistTooLong = self:MaximumConsistLength()
	self.Train:SetNW2Bool( "TrainTooLong", consistTooLong )
	local tractionUnlocked = ( not consistTooLong and not doorsOpened ) and ( ( self.ReverserA > 1 or self.ReverserA < 0 ) or ( self.ReverserB > 1 or self.ReverserB < 0 ) or ( t:ReadTrainWire( 3 ) > 0 or t:ReadTrainWire( 4 ) > 0 ) )
	if self.ReverserA ~= 0 and self.ReverserA ~= 1 and not self.ConflictingHeads and self.IgnitionKeyA and tractionUnlocked then
		t:WriteTrainWire( 1, self.ThrottleStateA )
	elseif self.ReverserB ~= 0 and self.ReverserB ~= 1 and not self.ConflictingHeads and self.IgnitionKeyB and tractionUnlocked then
		t:WriteTrainWire( 1, self.ThrottleStateB )
	end
end

function TRAIN_SYSTEM:ReverserSystem()
	local t = self.Train
	-- Determine if the train is in gear
	local inGear = self.ReverserA >= 2 or self.ReverserA < 0 or self.ReverserB < 0 or self.ReverserB > 1
	-- Determine the forward direction based on which cab is being used
	local forward
	if self.ReverserA >= 2 then
		forward = self.ReverserB > -1 -- Cab A
	else
		forward = self.ReverserB < 0 -- Cab B (Reversed logic)
	end

	--print( forward, "forward" )
	-- Write to train wires if the train is in gear and there are no conflicting heads
	if inGear and not self.ConflictingHeads then
		t:WriteTrainWire( 3, forward and 1 or 0 )
		t:WriteTrainWire( 4, not forward and 1 or 0 )
	end
end

function TRAIN_SYSTEM:PantoFunction()
	local p = self.Train.Panel
	local b = self.Train.Battery
	if not b then return end
	if p.PantographOn > 0 and not self.PantographRaised then
		self.Train.PantoUp = true
		self.PantographRaised = true
	elseif p.PantographOff > 0 and self.PantographRaised then
		self.Train.PantoUp = false
		self.PantographRaised = false
	end

	self.Train:SetNW2Bool( "PantoUp", self.PantographRaised )
end

function TRAIN_SYSTEM:BellHorn()
	if true then return end
	local p = self.Train.Panel
	local t = self.Train
	local b = t.Battery
	if b.Voltage < 5 then return end
	t:SetNW2Bool( "Bell", p.Bell > 0 )
	t:SetNW2Bool( "Horn", p.Horn > 0 )
end

function TRAIN_SYSTEM:MaximumConsistLength()
	local consist = #self.Train.WagonList
	self.Train:SetNW2Bool( "ConsistTooLongAlarm", consist > 4 )
	return consist > 4
end

function TRAIN_SYSTEM:IsLVPowerAvailable()
	print( self.Train.Battery.Voltage, self.BatteryActivated )
	self.LVPowerOn = self.BatteryActivated --and self.Train.Battery.Voltage > 20
end