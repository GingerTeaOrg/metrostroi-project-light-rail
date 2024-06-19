Metrostroi.DefineSystem("Duewag_U2")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.PrevTime = 0
    self.DeltaTime = 0
    self.Speed = 0
    self.ThrottleState = 0
    self.ThrottleNotchTraction = false
    self.ThrottleNotchBraking = false
    self.ThrottleNotchEmergency = false
    self.ActualThrottleState = 0
    self.Voltage = 0
    self.ResistorBank = 0
    self.CurrentResistor = 0
    self.PrevResistorBank = nil
    self.ResistorChangeRegistered = false

    self.LeadingCabA = 0
    self.LeadingCabB = 0
    self.ResetTrainWires = false
    self.Traction = 0
    self.Drive = 0
    self.Brake = 0
    self.Reverse = 0
    self.Bell = 0
    self.BitteZuruecktreten = 0
    self.Horn = 0
    self.PantoUp = false
    self.BatteryStartUnlock = false
    self.BatteryOn = false
    self.CabLights = 0
    self.HeadLights = 0
    self.StopLights = 0
    self.FanTimer = 0
    self.ReverserInserted = false
    self.ReverserInsertedA = false
    self.ReverserInsertedB = false
    self.ReverserLeverStateA = 0 -- for the reverser lever setting. -1 is reverse, 0 is neutral, 1 is startup, 2 is single unit, 3 is multiple unit
    self.ReverserLeverStateB = 0
    self.ReverserState = 0 -- internal registry for forwards, neutral, backwards
    self.VZ = false -- multiple unit mode
    self.VE = false -- single unit mode
    self.BlinkerOnL = 0
    self.BlinkerOnR = 0
    self.BlinkerOnWarn = 0
    self.ThrottleEngaged = false
    self.TractionConditionFulfilled = false
    self.BrakePressure = 2.7
    self.TractionCutOut = false
    self.ThrottleStateAnim = 0 -- whether to stop listening to the throttle input
    self.ThrottleStateAnimB = 0
    self.ThrottleStateA = 0
    self.ThrottleStateB = 0
    self.ThrottleRateA = 0
    self.ThrottleRateB = 0
    self.ThrottleCutOut = 0
    self.DynamicBraking = false -- First stage of braking
    self.TrackBrake = false -- Electromagnetic brake
    self.DiscBrake = false -- physical friction brake
    self.EmergencyBrake = false
    self.CloseDoorsButton = false
    self.DoorsOpenButton = false
    self.Percentage = 0
    self.Amps = 0
    self.HeadlightsSwitch = false
    self.ManualRetainerBrake = false
    self.CamshaftMoveTimer = 0
    self.CamshaftFinishedMoving = true
    self.LeadingUnit = false
    self.PrevResistorBank = 0
    self.TractionJerk = 0
    self.Orientation = 0
    self.ReverseOrientation = 0
    self.IBISKeyA = false
    self.IBISKeyATurned = false
    self.IBISKeyB = false
    self.IBISKeyBTurned = false
    self.ibisKeyRequired = true
    
    self.CurrentResistors = 0
    self.PreviousResistors = 0
    self.switchingMomentRegistered = false
    self.SwitchingMoment = 0

    self.CurrentTraction = 0
    self.PreviousTraction = 0
    
    self.DoorStatesRight = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
    }
    
    self.DoorStatesLeft = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
    }
    
    self.DoorOpenMoments = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
    }
    self.DoorRandomness = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
    }
end

if CLIENT then return end

function TRAIN_SYSTEM:Inputs()
    return {"HeadlightsSwitch", "BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure", "ReverserState", "ReverserLeverState", "ReverserInserted", "BellEngage", "Horn", "BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse", "CloseDoorsButton", "DoorsOpenButton"}
end

function TRAIN_SYSTEM:Outputs()
    return {"VE", "VZ", "ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled", "ReverserLeverState"}
end

function TRAIN_SYSTEM:TriggerInput(name, value)
    if self[name] then
        self[name] = value
    end
end

function TRAIN_SYSTEM:ReadTrainWire(wire)
    return self.Train:ReadTrainWire(wire)
end

function TRAIN_SYSTEM:WriteTrainWire(wire, value)
    self.Train:WriteTrainWire(wire, value)
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(Train)
    local t = self.Train 
    self:TriggerInput()
    self:TriggerOutput()
    self:U2Engine()
    self:MUHandler()

    -- print(self.ReverserState,self.Traction,self.Train)
    self.Speed = self.Train.Speed
    -- PrintMessage(HUD_PRINTTALK,self.ResistorBank)
    self.PrevTime = self.PrevTime or RealTime() - 0.33
    self.DeltaTime = RealTime() - self.PrevTime
    self.PrevTime = RealTime()
    local dT = self.DeltaTime
    -- Control Throttles in A or B independently, but....
    self.ThrottleStateA = math.Clamp(self.ThrottleStateA + self.ThrottleRateA, -100, 100)
    self.ThrottleStateB = math.Clamp(self.ThrottleStateB + self.ThrottleRateB, -100, 100)
    
    -- only pass on the actual value if the respective reverser is engaged 
    if self.ReverserLeverStateA > 0 or self.ReverserLeverStateA < 0 then
        -- Since the spring retention brakes engage at speeds <5 we need to pass 0 to the actual throttle variable as long as the throttle is >= 0 so that the train doesn't bob awkwardly trying to run during brake application
        self.ThrottleState = (self.Speed > 5 and self.ThrottleStateA >= 0) and self.ThrottleStateA or ((self.Speed < 5 and self.ThrottleStateA <= 0) and 0 or self.ThrottleStateA)
    elseif self.ReverserLeverStateB > 0 or self.ReverserLeverStateB < 0 then
        self.ThrottleState = (self.Speed > 5 and self.ThrottleStateB >= 0) and self.ThrottleStateB or ((self.Speed < 5 and self.ThrottleStateB <= 0) and 0 or self.ThrottleStateB)
    end
    
    -- Throttle animation handling. Adapt the value to the pose parameter on the model
    if self.ThrottleStateA <= 100 then
        self.ThrottleStateAnimA = self.ThrottleStateA / 200 + 0.5
    elseif self.ThrottleStateA >= 0 then
        self.ThrottleStateAnimA = self.ThrottleStateA * -0.1
    end
    
    -- Throttle animation handling. Adapt the value to the pose parameter on the model
    if self.ThrottleStateB <= 100 then
        self.ThrottleStateAnimB = self.ThrottleStateB / 200 + 0.5
    elseif self.ThrottleStateB >= 0 then
        self.ThrottleStateAnimB = self.ThrottleStateB * -0.1
    end
    
    if IsValid(self.Train.SectionB) then
        self.Train.SectionB:SetNW2Float("ThrottleAnimB", self.ThrottleStateAnimB)
        self.Train:SetNW2Float("ThrottleStateAnim", self.ThrottleStateAnimA)
    end
    
    -- Is the throttle engaged? We need to know that for a few things!
    self.ThrottleEngaged = self.ThrottleState ~= 0
    self.Train:SetNW2Bool("ThrottleEngaged", self.ThrottleEngaged)
    self.ReverserLeverStateA = math.Clamp(self.ReverserLeverStateA, -1, 3)
    self.ReverserLeverStateB = math.Clamp(self.ReverserLeverStateB, -1, 3)
    self.Train:WriteTrainWire(7, (self.BatteryOn or self.Train:ReadTrainWire(6) > 0) and 1 or 0)
    
    local values = {
        [1] = 0.4,
        [0] = 0.25,
        [3] = 0.8,
        [2] = 0.7,
        [-1] = 0
    }
    
    self.Train.SectionB:SetNW2Float("ReverserAnimate", values[self.ReverserLeverStateB] or 0)
    self.Train:SetNW2Float("ReverserAnimate", values[self.ReverserLeverStateA] or 0)
    self.Train.SectionB:SetNW2Int("ReverserLever", self.ReverserLeverStateB)
    -- Only on the * Setting of the reverser lever should the battery turn on, or the MU wire and the battery wire
    self.BatteryOn = self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(7) > 0 or (self.BatteryStartUnlock and self.Train:GetNW2Bool("BatteryOn", false)) or self.BatteryOn
    -- if the battery is on, we can command the pantograph
    self.PantoUp = (self.Train:GetNW2Bool("BatteryOn", false) == true and self.Train:GetNW2Bool("PantoUp")) or (self.Train:ReadTrainWire(17) > 0 and self.Train:ReadTrainWire(6) > 0)
    self.Train:SetNW2Bool("ReverserInsertedA", self.ReverserInsertedA)
    self.Train:SetNW2Bool("ReverserInsertedB", self.ReverserInsertedB)
    self.Train:TriggerInput("DriversWrenchPresent", (self.ReverserInsertedA or self.ReverserInsertedB) and 1 or 0)
    self.EmergencyBrake = self.Train:GetNW2Bool("EmergencyBrake", false)
    self.Train:SetNW2Float("BlinkerStatus", self.Train.Panel.BlinkerLeft > 0 and 1 or (self.Train.Panel.BlinkerRight > 0 and self.Train.Panel.BlinkerLeft < 1) and 0 or 0.5)
    self.ReverserState = (self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == 3) and -1 or 0 or (self.ReverserLeverStateA == 3 or self.ReverserLeverStateB == -1) and 1
    self.Train:WriteTrainWire(12, (self.Train.DeadmanUF.IsPressed > 0 and self.Train:ReadTrainWire(6) > 0 and (self.ReverserLeverStateA ~= 0 or self.ReverserLeverStateB ~= 0)) and 1 or 0)
    self.Train:WriteTrainWire(6, (self.VZ == true and self.Train:ReadTrainWire(6) < 1) and 1 or (self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2) and 1 or 0)
    self.TractionConditionFulfilled = (self.Train:ReadTrainWire(12) > 0 and self.Train:ReadTrainWire(6) > 0) and true or (self.VE and self.Train.DeadmanUF.IsPressed > 0) and true or false
    
    if self.TractionConditionFulfilled == true then
        self.Traction = math.Clamp(self.ThrottleState * 0.01, -1, 1)
        
        if self.Train:GetNW2Bool("DeadmanTripped", false) == false then
            if self.Train:ReadTrainWire(6) > 0 and not self.VE then
                self.Train:WriteTrainWire(1, self.Traction)
                self.Train:WriteTrainWire(2, (self.ThrottleState <= 0 or self:ReadTrainWire(1) < 0.1) and 1 or 0)
                self.Train:WriteTrainWire(10, self.EmergencyBrake == true and 1 or 0)
                self.Train:SetNW2Bool("ElectricBrakes", self.ThrottleState < 1 and true or false)
                self.Train:SetNW2Int("BrakePressure", self.ThrottleState > 0 and 0 or 2.7)
                self.BrakePressure = (self.Train:ReadTrainWire(1) < 0.01 and (self.Speed < 5)) and 2.7 or 0
                self.Train:WriteTrainWire(5, self.BrakePressure)
                self.Traction = (self.Speed < 5 and self.Train:ReadTrainWire(2) >= 0 and self.Train:ReadTrainWire(5) == 2.7) and 0 or self.Traction
            elseif self.VE or self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == -1 then
                self.BrakePressure = (self.ThrottleState <= 0 and (self.Speed < 5)) and 2.7 or 0
                self.Traction = (self.Speed < 5 and self.ThrottleState < 100 and self.BrakePressure == 2.7) and 0 or self.Traction
            end
            -- end
        elseif self.Train.DeadmanUF.DeadmanTripped then
            self.BrakePressure = 2.7
            
            if self.Speed < 5 then
                self.Traction = 0
            else
                self.Traction = 1
            end
        end
    end
end

function TRAIN_SYSTEM:Camshaft()
    -- Constants
    local maxMotorCurrent = 250 -- Maximum current per motor
    local totalMotors = 2 -- Total number of motors
    local totalMaxCurrent = maxMotorCurrent * totalMotors -- Total maximum current
    local powerSupplyVoltage = UF.Voltage -- Power supply voltage
    local numResistors = 20 -- Total number of resistors
    local maxResistorCurrent = 12.5 -- Maximum current per resistor
    local latency = 2 -- Latency (seconds)
    local engagedResistors = 0
    local switchingMomentRegistered = false
    local requiredResistors = 20

    local prevTraction = 0
    local currTraction = 0
    
    self.PrevResistors = self.EngagedResistors

    -- Function to simulate latency
    local function simulateLatency()
        if self.switchingMomentRegistered == false then
            self.switchingMomentRegistered = true
            self.SwitchingMoment = CurTime()
        end
        
        if CurTime() - self.SwitchingMoment > latency then self.switchingMomentRegistered = false return true end
        
        return false
    end
    
    -- Function to determine the number of resistors needed for a given throttle setting and speed
    local function controlResistors()
        if self.ThrottleState == 0 then return 20 end
        local requestedCurrent = totalMaxCurrent / math.abs(self.ThrottleState) -- Calculate requested current based on throttle setting
        
        -- Calculate number of required resistors
        local requiredResistors = math.ceil(requestedCurrent / maxResistorCurrent) -- Calculate adjusted required resistors
        
        if self.Speed == 0 then
            speedFactor = 0
        elseif (80 / self.Speed) > 1 then
            speedFactor = math.ceil(80 / self.Speed)
        else
            speedFactor = 0
        end
        
        -- Ensure the number of resistors is within the available range
        requiredResistors = math.max(0, math.min(numResistors, requiredResistors))
        requiredResistors = requiredResistors + speedFactor

        return requiredResistors
    end
    
    -- Simulate latency
    if self.Traction ~= self.PreviousTraction then 
        if simulateLatency() then
            -- Calculate the number of resistors based on throttle and speed
            self.EngagedResistors = controlResistors()
            self.PreviousTraction = self.Traction
        end
    end
    
    self.EngagedResistors = engagedResistors
    self.CurrentResistors = self.EngagedResistors

    return self.EngagedResistors * UF.convertToSourceForce(-7500)
end

function TRAIN_SYSTEM:U2Engine()
    -- 250A per motor, 2x250A, 600V, 20 resistors, 12.5A per resistor
    local prevResistors
    -- camshaft only moves when you're actually in gear
    local prevGear = prevGear or false
    local inGear = (self.ThrottleLeverStateA ~= 0 and self.ThrottleLeverStateA ~= 1) or (self.ThrottleLeverStateB ~= 0 and self.ThrottleLeverStateB ~= 1) or (self.Train:ReadTrainWire(3) > 0 or self.Train:ReadTrainWire(4) > 0)
    local isMoving = self.Speed > 3
    local isTractionApplied = self.Traction ~= 0

    if prevResistors ~= self.EngagedResistors and inGear and isMoving and isTractionApplied then
        self.CamshaftMoved = true
        prevResistors = self.EngagedResistors
    elseif prevResistors == self.EngagedResistors and inGear then
        self.CamshaftMoved = false
    end
    -- ampmetre fakery for until we've got a real electrical sim
    if math.abs(self.Train.FrontBogey.Acceleration) > 0 then
        self.Amps = 250000 / 600 * self.Traction * 0.0000001 * math.Round(self.Train.FrontBogey.Acceleration, 1)
    elseif self.Train.FrontBogey.Acceleration < 0 then
        self.Amps = 250000 / 600 * self.Traction * 0.0000001 * math.Round(self.Train.FrontBogey.Acceleration * -1, 1)
    end
    
    self.Train:SetNW2Bool("CamshaftMoved", self.CamshaftMoved)
    self.Train:SetNWFloat("Amps", self.Amps)
end

function TRAIN_SYSTEM:MUHandler()
    
    local VEStates = { 
        [-1] = true,
        [3] = true,
    }
    
    self.VZ = self.VZ or self.Train:ReadTrainWire(6) > 0 and (self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 0) or self.Train:ReadTrainWire(6) > 1
    self.VE = self.VE or not self.VZ or (VEStates[self.ReverserLeverStateA] or VEStates[self.ReverserLeverStateB])
    ---------------------------------------------------------------------------------------------------------
    if self.ReverserLeverStateB == 0 then
        if self.ReverserLeverStateA == -1 then
            self.ReverserState = -1
        elseif self.ReverserLeverStateA == 1 or self.ReverserLeverStateA == 0 then
            self.ReverserState = 0
            self.BatteryStartUnlock = true
        elseif self.ReverserLeverStateA == 2 or self.ReverserLeverStateA == 3 then
            self.ReverserState = 1
        end
    elseif self.ReverserLeverStateA == 0 then
        if self.ReverserLeverStateB == 1 then
            self.ReverserState = 0
            self.BatteryStartUnlock = true
        elseif self.ReverserLeverStateB == -1 or self.ReverserLeverStateB == 2 then
            self.ReverserState = 1
            self.BatteryStartUnlock = false
        elseif self.ReverserLeverStateB == 3 then
            self.ReverserState = -1
            self.BatteryStartUnlock = false
        elseif self.ReverserLeverStateB == 0 then
            self.ReverserState = 0
            self.BatteryStartUnlock = false
        end
    end
    
    
    self.Train:WriteTrainWire(3, self.ReverserLeverStateA == 2 and self.ReverserInsertedA and 1 or self.ReverserLeverStateB == 2 and self.ReverserInsertedB and 0 or 0)
    self.Train:WriteTrainWire(4, self.ReverserLeverStateA == 2 and self.ReverserInsertedA and 0 or self.ReverserLeverStateB == 2 and self.ReverserInsertedB and 1 or 0)
    self.Train:WriteTrainWire(6, (self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2) and 1 or 0)
    
    ---------------------------------------------------------------------------------------
    -- if the emergency brake is pulled high
    if self.Train:ReadTrainWire(10) > 0 then
        -- if the speed is greater than 2 (tolerances for inaccuracies registered due to wobble)
        if self.Speed >= 2 then
            self.ThrottleState = -100 -- Register the throttle to be all the way back
            self.Traction = -100
        elseif self.Speed < 2 then
            self.Traction = 0
        end
        
        self.Train.FrontBogey.BrakePressure = 2.7
        self.Train.MiddleBogey.BrakePressure = 2.7
        self.Train.RearBogey.BrakePressure = 2.7
        self.BrakePressure = 2.7
    end
    
    if self.ThrottleState ~= 0 and self.ReverserState ~= 1 and self.ReverserState ~= 0 and self.BatteryOn == true then
        self.FanTimer = CurTime()
        self.Train:SetNW2Bool("Fans", true)
    elseif self.BatteryOn == false then
        self.Train:SetNW2Bool("Fans", false)
    end
    
    if CurTime() - self.FanTimer > 5 and self.Speed < 5 then
        self.Train:SetNW2Bool("Fans", false)
    end
    
    if self.BatteryOn == false or self.Train:ReadTrainWire(7) < 1 then
        self.Train:WriteTrainWire(3, 0)
        self.Train:WriteTrainWire(4, 0)
        self.Train:WriteTrainWire(6, 0)
    end
    
    self.Train.PantoUp = self.Train.PantoUp or self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(17) > 0
    
    if self.Train.PantoUp == true then
        if self.Train:ReadTrainWire(6) > 0 then
            self.Train:WriteTrainWire(17, 1)
        end
        
        self.Train:SetNW2Bool("PantoUp", true)
    elseif self.Train.PantoUp == false then
        self.Train:SetNW2Bool("PantoUp", false)
        
        if self.Train:ReadTrainWire(6) > 0 then
            self.Train:WriteTrainWire(17, 0)
        end
    end
    -- print(self.Train:GetNW2Bool("PantoUp"))
    -- print(self.Train:GetNW2Bool("Fans"))
end
-- Are the doors unlocked, sideLeft,sideRight,door1 open, unlocked while reverser on * position
function TRAIN_SYSTEM:DoorHandler(unlock, left, right, door1, idleunlock, dT)
    local WagonList = self.Train.WagonList
    local irStatus = self:IRIS(true)
    local t = self.Train
    local previousUnlock = false
    for i = 1, #WagonList do
        local DoorStatesPerCar = right and WagonList[i].CoreSys.DoorStatesRight or left and WagonList[i].CoreSys.DoorStatesLeft or {}
        -- Exempt the door1 button, because that's not a passenger transfer. That's for special drivers' issues. 
        -- The doors right by the cab can be unlocked without having to unblock all doors and risk passengers.
        
        self.DoorsClosed = (DoorStatesPerCar[1] == 0 and DoorStatesPerCar[2] == 0 and DoorStatesPerCar[3] == 0 and
        DoorStatesPerCar[4] == 0)
    end
    self.ArmDoorsClosedAlarm = self.DoorsClosed and previousUnlock and not door1
    previousUnlock = not self.DoorsClosed
    t:SetNW2Bool("DoorChime", (self.ArmDoorsClosedAlarm and self.DoorsClosed))
    -------------------------------------------------------------------------------------
    --    ↑ checking whether doors are open anywhere | ↓ Actually controlling the doors
    --------------------------------------------------------------------------------------
    if self.ReverserStateA ~= 0 and not self.ConflictingHeads then
        self.DoorStatesRight[1] = right and door1 and math.Clamp(self.DoorStatesRight[1] + 0.2 * dT,0,1) or self.DoorStatesRight[1]
        self.DoorStatesLeft[4] = left and door1 and math.Clamp(self.DoorStatesLeft[4] + 0.2 * dT,0,1) or self.DoorStatesLeft[4]
    elseif self.ReverserStateB ~= 0 and not self.ConflictingHeads then
        self.DoorStatesRight[4] = right and door1 and math.Clamp(self.DoorStatesRight[4] + 0.2 * dT,0,1) or self.DoorStatesRight[4]
        self.DoorStatesLeft[1] = left and door1 and math.Clamp(self.DoorStatesLeft[1] + 0.2 * dT,0,1) or self.DoorStatesLeft[1]
    end
    --------------------------------------------------------
    local IRGates = self:IRIS(unlock)
    if unlock then
        self.DoorsPreviouslyUnlocked = true
        self.DoorLockSignalMoment = 0
        -- randomise door closing for more realistic behaviour. People are sometimes going to block the doors for a bit, or the relays don't respond in sync.
        if not self.DoorCloseMomentsCaptured then
            self.DoorCloseMoments[1] = math.random(1, 4)
            self.DoorCloseMoments[2] = math.random(1, 4)
            self.DoorCloseMoments[3] = math.random(1, 4)
            self.DoorCloseMoments[4] = math.random(1, 4)
            self.DoorCloseMomentsCaptured = true
        end
        
        if right then
            -- pick doors to be unlocked
            if not self.RandomnessCalulated then
                for i, v in ipairs(self.DoorRandomness) do
                    if i <= 6 and v < 0 then
                        -- we recycle the door randomness value as a general signal for requesting a door to open, and if a stop request originated from that door, always open it
                        self.DoorRandomness[i] =
                        self.StopRequestRight[i] and 3 or math.random(0, 4)
                        -- print(self.DoorRandomness[i], "doorrandom", i)
                        self.RandomnessCalculated = true
                        break
                    end
                end
            end
            
            -- increment the door states
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesRight[i] < 1 and not IRGates[i] then
                    self.DoorStatesRight[i] = self.DoorStatesRight[i] + 0.2 * dT
                end
                math.Clamp(self.DoorStatesRight[i], 0, 1)
            end
        elseif left then
            -- pick a random door to be unlocked
            if self.RandomnessCalulated ~= true then
                for i, v in ipairs(self.DoorRandomness) do
                    if i <= 4 and v < 0 then
                        -- the carriage does not seem to differentiate between a stop request done on the left or right side, just at what position the door is,
                        -- so just invert the stop request index in order to account for the fact we're counting A to B as 1 to 6, and B to A as 1 to 6 for door n°
                        self.DoorRandomness[i] = math.random(0, 4)
                        self.RandomnessCalculated = true
                        break
                    end
                end
            end
            
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesLeft[i] < 1 and not IRGates[i+4] then
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.2 * dT
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end
        end
    elseif not unlock then
        if self.DoorLockSignalMoment == 0 then
            self.DoorLockSignalMoment = CurTime()
        end
        self.DoorCloseMomentsCaptured = false -- reset the flag for the randomness of closing the doors
        
        if right then
            for i, v in ipairs(self.DoorStatesRight) do
                if CurTime() > self.DoorLockSignalMoment +
                self.DoorCloseMoments[i] and not irStatus[i] and v > 0 then
                    self.DoorStatesRight[i] =
                    self.DoorStatesRight[i] - 0.20 * dT
                    self.DoorStatesRight[i] = math.Clamp(
                    self.DoorStatesRight[i], 0, 1)
                end
            end
        elseif left then
            for i, v in ipairs(self.DoorStatesLeft) do
                if CurTime() > self.DoorLockSignalMoment +
                self.DoorCloseMoments[i] and not irStatus[i] and v > 0 then
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.20 * dT
                    self.DoorStatesLeft[i] =
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end
        end
    elseif idleunlock then
        -- If the Reverser is set to *, the doors automatically close again after five seconds
        if right then
            local opened
            -- Iterate through each door with random behavior
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesRight[i] < 1 then
                    if self.DoorOpenMoments[i] == 0 then
                        self.DoorStatesRight[i] =
                        self.DoorStatesRight[i] + 0.2 * dT
                        self.DoorStatesRight[i] = math.Clamp(
                        self.DoorStatesRight[i],
                        0, 1)
                    end
                elseif self.DoorStatesRight[i] > 0 and self.DoorOpenMoments[i] <
                CurTime() - 5 then
                    -- If five seconds have passed, close the door
                    if not irStatus[i] then
                        self.DoorStatesRight[i] =
                        self.DoorStatesRight[i] - 0.2 * dT
                        self.DoorStatesRight[i] = math.Clamp(
                        self.DoorStatesRight[i],
                        0, 1)
                    end
                end
                
                if self.DoorStatesRight[i] == 1 and not opened then
                    self.DoorOpenMoments[i] = CurTime() -- Record the moment the door opened
                    opened = true
                elseif self.DoorStatesRight[i] == 0 then
                    self.DoorOpenMoments[i] = 0
                    opened = false
                end
            end
        elseif left then
            local opened
            -- Similar logic for the left doors
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesLeft[i] < 1 then
                    if self.DoorStatesLeft[i] == 1 then
                        self.DoorOpenMoments[i] = CurTime()
                    elseif self.DoorOpenMoments[i] == 0 then
                        self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.1
                        self.DoorStatesLeft[i] = math.Clamp(
                        self.DoorStatesLeft[i], 0,
                        1)
                    end
                elseif self.DoorStatesLeft[i] > 0 and CurTime() -
                self.DoorOpenMoments[i] > 5 and not irStatus[i] then
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.1
                    self.DoorStatesLeft[i] =
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end
            
            if self.DoorStatesLeft[i] == 1 and not opened then
                self.DoorOpenMoments[i] = CurTime()
                opened = true
            end
        end
    end
end
function TRAIN_SYSTEM:CheckDoorsAllClosed(enable)
    if not enable then return nil end
    for k, v in pairs(self.Train.WagonList) do
        if self.Train.DoorSideUnlocked == "Left" or self.Train:ReadTrainWire(13) > 0 then
            for i in pairs(v.DoorStatesLeft) do
                if v.DoorStatesLeft[i] ~= 0 then
                    self.Train:WriteTrainWire(16, 0)
                    return false
                else
                    self.Train:WriteTrainWire(16, 1)
                    continue
                end
            end
        elseif self.Train.DoorSideUnlocked == "Right" or self.Train:ReadTrainWire(14) > 0 then
            for i in pairs(v.DoorStatesRight) do
                if v.DoorStatesRight[i] ~= 0 then
                    self.Train:WriteTrainWire(16, 0)
                    return false
                else
                    self.Train:WriteTrainWire(16, 1)
                    continue
                end
            end
        end
    end
    return true 
end

function TRAIN_SYSTEM:Blink(enable, left, right)
    local t = self.Train
    local sectionB = t.SectionB
    local tailblink = IsValid(t.RearCouple.CoupledEnt) and self:ReadTrainWire(6) > 0
    if t.BatteryOn == true or t:ReadTrainWire(6) > 0 then
        if not enable then
            t.BlinkerOn = false
            t.LastTriggerTime = CurTime()
        elseif CurTime() - t.LastTriggerTime > 0.4 then
            t.BlinkerOn = not t.BlinkerOn
            t.LastTriggerTime = CurTime()
        end
        
        t:SetLightPower(58, t.BlinkerOn and left)
        t:SetLightPower(48, t.BlinkerOn and left)
        t:SetLightPower(59, t.BlinkerOn and right)
        t:SetLightPower(49, t.BlinkerOn and right)
        t:SetLightPower(38, t.BlinkerOn and right or left and t.BlinkerOn)
        t:SetLightPower(56, t.BlinkerOn and left and right)
        t:SetLightPower(57, t.BlinkerOn and left and right)
        
        sectionB:SetLightPower(148,t.BlinkerOn and left)
        sectionB:SetLightPower(158,t.BlinkerOn and left)
        sectionB:SetLightPower(159,t.BlinkerOn and right)
        sectionB:SetLightPower(149,t.BlinkerOn and right)
        
        sectionB:SetLightPower(66,t.BlinkerOn and left and right)
        sectionB:SetLightPower(67,t.BlinkerOn and left and right)
        t:SetLightPower(48, t.BlinkerOn and left)
        t:SetLightPower(58, t.BlinkerOn and left)
        t:SetLightPower(59, t.BlinkerOn and right)
        t:SetNW2Bool("BlinkerTick", t.BlinkerOn) -- one tick sound for the blinker relay
    end
end