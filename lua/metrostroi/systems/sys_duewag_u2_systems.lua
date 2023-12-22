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
    self.DoorFLState = 100
    self.DoorRLState = 100
    self.DoorFRState = 100
    self.DoorRRState = 100
    
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
    
end

if CLIENT then return end

function TRAIN_SYSTEM:Inputs()
    return {
        "HeadlightsSwitch", "BrakePressure", "speed", "ThrottleRate",
        "ThrottleState", "BrakePressure", "ReverserState", "ReverserLeverState",
        "ReverserInserted", "BellEngage", "Horn", "BitteZuruecktreten",
        "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB",
        "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse",
        "CloseDoorsButton", "DoorsOpenButton"
    }
end

function TRAIN_SYSTEM:Outputs()
    return {
        "VE", "VZ", "ThrottleState", "ThrottleRate", "ThrottleEngaged",
        "Traction", "BrakePressure", "PantoState", "BlinkerState",
        "DoorSelectState", "BatteryOnState", "PantoState", "BlinkerState",
        "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled",
        "ReverserLeverState"
    }
end
function TRAIN_SYSTEM:TriggerInput(name, value)
    if self[name] then self[name] = value end
end


--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(Train)
    -- local train = self.Train 
    self:TriggerInput()
    self:TriggerOutput()
    self:U2Engine()
    self:MUHandler()
    
    -- print(self.ReverserState,self.Traction,self.Train)
    
    self.Speed = self.Train.Speed
    
    -- PrintMessage(HUD_PRINTTALK,self.ResistorBank)
    
    self.PrevTime = self.PrevTime or RealTime() - 0.33
    self.DeltaTime = (RealTime() - self.PrevTime)
    self.PrevTime = RealTime()
    local dT = self.DeltaTime
    -- Control Throttles in A or B independently, but....
    self.ThrottleStateA = math.Clamp(self.ThrottleStateA + self.ThrottleRateA,
    -100, 100)
    self.ThrottleStateB = math.Clamp(self.ThrottleStateB + self.ThrottleRateB,
    -100, 100)
    
    if self.ReverserLeverStateA > 0 or self.ReverserLeverStateA < 0 then -- only pass on the actual value if the respective reverser is engaged 
        -- Since the spring retention brakes engage at speeds <5 we need to pass 0 to the actual throttle variable as long as the throttle is >= 0 so that the train doesn't bob awkwardly trying to run during brake application
        self.ThrottleState = (self.Speed > 5 and self.ThrottleStateA >= 0) and self.ThrottleStateA or ((self.Speed < 5 and self.ThrottleStateA <= 0) and 0 or self.ThrottleStateA)
    elseif self.ReverserLeverStateB > 0 or self.ReverserLeverStateB < 0 then
        self.ThrottleState = (self.Speed > 5 and self.ThrottleStateB >= 0) and self.ThrottleStateB or ((self.Speed < 5 and self.ThrottleStateB <= 0) and 0 or self.ThrottleStateB)
    end
    
    if self.ThrottleStateA <= 100 then -- Throttle animation handling. Adapt the value to the pose parameter on the model
        self.ThrottleStateAnimA = self.ThrottleStateA / 200 + 0.5
    elseif (self.ThrottleStateA >= 0) then
        self.ThrottleStateAnimA = (self.ThrottleStateA * -0.1)
        
    end
    if self.ThrottleStateB <= 100 then -- Throttle animation handling. Adapt the value to the pose parameter on the model
        self.ThrottleStateAnimB = self.ThrottleStateB / 200 + 0.5
    elseif (self.ThrottleStateB >= 0) then
        self.ThrottleStateAnimB = (self.ThrottleStateB * -0.1)
        
    end
    
    if IsValid(self.Train.SectionB) then
        self.Train.SectionB:SetNW2Float("ThrottleAnimB",
        self.ThrottleStateAnimB)
        self.Train:SetNW2Float("ThrottleStateAnim", self.ThrottleStateAnimA)
    end
    -- Is the throttle engaged? We need to know that for a few things!

    self.ThrottleEngaged = self.ThrottleState ~= 0
    self.Train:SetNW2Bool("ThrottleEngaged",self.ThrottleEngaged)

    self.ReverserLeverStateA = math.Clamp(self.ReverserLeverStateA, -1, 3)
    self.ReverserLeverStateB = math.Clamp(self.ReverserLeverStateB, -1, 3)

    
    self.Train:WriteTrainWire(7,(self.BatteryOn and self.Train:ReadTrainWire(6) > 0) and 1 or 0)

    local values = {[1] = 0.4, [0] = 0.25, [3] = 0.8, [2] = 0.7, [-1] = 0}
    self.Train.SectionB:SetNW2Float("ReverserAnimate", values[self.ReverserLeverStateB] or 0)
    self.Train:SetNW2Float("ReverserAnimate", values[self.ReverserLeverStateA] or 0)
    self.Train.SectionB:SetNW2Int("ReverserLever", self.ReverserLeverStateB)

    

    -- Only on the * Setting of the reverser lever should the battery turn on, or the MU wire and the battery wire

    self.BatteryOn = (self.Train:GetNW2Bool("BatteryOn", false)) or (self.Train:ReadTrainWire(7) > 0 and self.Train:ReadTrainWire(6) > 0)

    if self.Train:ReadTrainWire(6) > 0 then
        self.BatteryOn = self.Train:ReadTrainWire(7) > 0
    elseif self.BatteryStartUnlock then
        self.BatteryOn = self.Train:GetNW2Bool("BatteryOn", false)
    else
        self.BatteryOn = self.BatteryOn
    end

    -- if the battery is on, we can command the pantograph
    self.PantoUp = (self.Train:GetNW2Bool("BatteryOn", false) == true and self.Train:GetNW2Bool("PantoUp")) or (self.Train:ReadTrainWire(17) > 0 and self.Train:ReadTrainWire(6) > 0)
    self.Train:SetNW2Bool("ReverserInsertedA", self.ReverserInsertedA)
    self.Train:SetNW2Bool("ReverserInsertedB", self.ReverserInsertedB)
    self.Train:TriggerInput("DriversWrenchPresent", (self.ReverserInsertedA or self.ReverserInsertedB) and 1 or 0)
    self.EmergencyBrake = self.Train:GetNW2Bool("EmergencyBrake", false)
    self.Train:SetNW2Float("BlinkerStatus", self.Train.Panel.BlinkerLeft > 0 and 1 or (self.Train.Panel.BlinkerRight > 0 and self.Train.Panel.BlinkerLeft < 1) and 0 or (self.Train.Panel.BlinkerLeft < 1 and self.Train.Panel.BlinkerRight < 1) or 0.5)
    self.ReverserState = (self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == 3) and -1 or (self.ReverserLeverStateA == 3 or self.ReverserLeverStateB == -1) and 1
    
    self.Train:WriteTrainWire(12, (self.Train.DeadmanUF.IsPressed > 0 and self.Train:ReadTrainWire(6) > 0 and (self.ReverserLeverStateA ~= 0 or self.ReverserLeverStateB ~= 0)) and 1 or 0)

    self.Train:WriteTrainWire(6,(self.VZ == true and self.Train:ReadTrainWire(6) < 1) and 1 or (self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2) and 1 or 0)
    self.TractionConditionFulfilled = (self.Train:ReadTrainWire(12) > 0 and self.Train:ReadTrainWire(6) > 0) and true or (self.VE and self.Train.DeadmanUF.IsPressed > 0) and true or false
    if self.TractionConditionFulfilled == true then
        self.Traction = math.Clamp(self.ThrottleState * 0.01, -1, 1)
        if self.Train:GetNW2Bool("DeadmanTripped", false) == false then
            if self.Train:ReadTrainWire(6) > 0 and not self.VE then

                self.Train:WriteTrainWire(1, self.Traction)
                self.Train:WriteTrainWire(2, self.ThrottleState < 1 and 1 or 0)
                self.Train:WriteTrainWire(10, self.EmergencyBrake == true and 1 or 0)
                self.Train:SetNW2Bool("ElectricBrakes", self.ThrottleState < 1 and true or false)
                self.Train:SetNW2Int("BrakePressure", self.ThrottleState > 0 and 0 or 2.7)
                self.BrakePressure = (self.Train:ReadTrainWire(1) < 0.01 and (self.Speed < 5)) and 2.7 or 0
                self.Train:WriteTrainWire(5, self.BrakePressure)
                self.Traction = (self.Speed < 5 and self.Train:ReadTrainWire(2) >= 0 and self.Train:ReadTrainWire(5) == 2.7) and 0 or self.Traction
                
                
                
                
            elseif self.VE or self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == -1 then
                
                self.BrakePressure = (self.ThrottleState <= 0 and (self.Speed < 5)) and 2.7 or 0
                self.Traction = (self.Speed < 5 and self.ThrottleState < 100 and self.BrakePressure == 2.7 ) and 0 or self.Traction
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

function TRAIN_SYSTEM:Camshaft(throttle)
    -- Constants
    local maxMotorCurrent = 250 -- Maximum current per motor
    local totalMotors = 2 -- Total number of motors
    local totalMaxCurrent = maxMotorCurrent * totalMotors -- Total maximum current
    local powerSupplyVoltage = UF.Voltage -- Power supply voltage
    local numResistors = 20 -- Total number of resistors
    local maxResistorCurrent = 12.5 -- Maximum current per resistor
    local acceleration = 1.1 -- Acceleration (m/s²)
    local deceleration = 1.2 -- Deceleration (m/s²)
    local latency = 2 -- Latency (seconds)
    local switching_moment = 0
    local engagedResistors = 0
    local switchingMomentRegistered = false
    local requiredResistors = 20
    
    -- Function to simulate latency
    local function simulateLatency()
        if switchingMomentRegistered == false then
            switchingMomentRegistered = true
            switching_moment = CurTime()
        end
        if CurTime() - switching_moment > latency then return true end
        return false
    end
    
    -- Function to determine the number of resistors needed for a given throttle setting and speed
    local function controlResistors()
        local requestedCurrent = totalMaxCurrent / math.abs(self.ThrottleState)  -- Calculate requested current based on throttle setting

        -- Calculate number of required resistors
        local requiredResistors = math.ceil(requestedCurrent / maxResistorCurrent) -- Calculate adjusted required resistors

        if (80 / self.Speed) > 1 then
            speedFactor = math.ceil(80 / self.Speed)
        else
            speedFactor = 0
        end
        -- Ensure the number of resistors is within the available range
        requiredResistors = math.max(0, math.min(numResistors, requiredResistors))
        requiredResistors = requiredResistors + speedFactor
        return requiredResistors
    end

    local function brakeResistors()
        local requestedCurrent = totalMaxCurrent / math.abs(self.ThrottleState)  -- Calculate requested current based on throttle setting

        -- Calculate number of required resistors
        local requiredResistors = math.ceil(requestedCurrent / maxResistorCurrent) -- Calculate adjusted required resistors

        if (self.Speed / 8) > 1 then
            speedFactor = math.ceil(self.Speed / 8)
        else
            speedFactor = 0
        end
        -- Ensure the number of resistors is within the available range
        requiredResistors = math.max(0, math.min(numResistors, requiredResistors))
        requiredResistors = requiredResistors
        return requiredResistors
    end
    
    controlResistors()
    
    -- Simulate latency
    if simulateLatency() then
        -- Calculate the number of resistors based on throttle and speed
        engagedResistors = controlResistors()
    else
        engagedResistors = engagedResistors
    end
    self.EngagedResistors = engagedResistors


    
    return engagedResistors * UF.convertToSourceForce(-7500)
end




function TRAIN_SYSTEM:U2Engine()
    
    -- 250A per motor, 2x250A, 600V, 20 resistors, 12.5A per resistor

    
    
    local prevResistors
    -- camshaft only moves when you're actually in gear
    local inGear = (self.ThrottleLeverStateA ~= 0 and self.ThrottleLeverStateA ~=1) or (self.ThrottleLeverStateB ~= 0 and self.ThrottleLeverStateB ~=1) or (self.Train:ReadTrainWire(3) > 0 or self.Train:ReadTrainWire(4) > 0)

    if prevResistors ~= self.EngagedResistors and inGear then
        self.CamshaftMoved = true
        prevResistors = self.EngagedResistors
    elseif prevResistors == self.EngagedResistors then
        self.CamshaftMoved = false
    end
    
    if math.abs(self.Train.FrontBogey.Acceleration) > 0 then
        self.Amps = 300000 / 600 * self.Percentage * 0.0000001 *
        math.Round(self.Train.FrontBogey.Acceleration, 1)
        
    elseif self.Train.FrontBogey.Acceleration < 0 then
        self.Amps = 300000 / 600 * self.Percentage * 0.0000001 *
        math.Round(self.Train.FrontBogey.Acceleration * -1, 1)
    end
    self.Train:SetNW2Bool("CamshaftMoved", self.CamshaftMoved)
    self.Train:SetNW2Float("Amps", self.Amps)
end


function TRAIN_SYSTEM:MUHandler()
        
    ---------------------------------------------------------------------------------------------------------
    
    if self.ReverserLeverStateA == -1 and self.ReverserLeverStateB == 0 then
        self.ReverserState = -1
        self.VE = true
        self.VZ = false
    elseif self.ReverserLeverStateA == 1 and self.ReverserLeverStateB == 0 then
        self.ReverserState = 0
        self.BatteryStartUnlock = true
        self.VE = false
        self.VZ = false
        -- self.Train:WriteTrainWire(6,0)
    elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 1 then
        self.ReverserState = 0
        self.BatteryStartUnlock = true
        self.VE = false
        self.VZ = false
    elseif self.ReverserLeverStateA == 2 and self.ReverserLeverStateB == 0 then
        self.VZ = true
        self.VE = false
        self.ReverserState = 1
    elseif self.ReverserLeverStateA == 3 and self.ReverserLeverStateB == 0 then -- We're at position 3 of the reverser forwards, that means we don't talk to coupled units.
        self.VZ = false
        self.VE = true
        self.ReverserState = 1
    elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == -1 then
        self.ReverserState = 1
        self.VE = true
        self.VZ = false
    elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 0 then
        self.ReverserState = 0
        self.BatteryStartUnlock = false
        self.VE = self.VE or false
        self.VZ = self.VZ or false
    elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 2 then
        self.VZ = true
        self.VE = false
        self.ReverserState = 1
        self.BatteryStartUnlock = false
    elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 3 then -- We're at position 3 of the reverser forwards, that means we don't talk to coupled units.
        self.VZ = false
        self.VE = true
        self.ReverserState = -1
        self.BatteryStartUnlock = false
    end
    if self.ReverserInsertedA == true then
        self.Train:WriteTrainWire(3, self.ReverserLeverStateA == 2 and 1 or 0)
        self.Train:WriteTrainWire(4, self.ReverserLeverStateA == 2 and 0 or 1)
    elseif self.ReverserInsertedB == true then
        self.Train:WriteTrainWire(3, self.ReverserLeverStateB == 2 and 0 or 1)
        self.Train:WriteTrainWire(4, self.ReverserLeverStateB == 2 and 1 or 0)
    end
    self.Train:WriteTrainWire(6, self.VZ and (self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2) and 1 or 0)
    
    ---------------------------------------------------------------------------------------
    
    if self.Train:ReadTrainWire(10) > 0 then -- if the emergency brake is pulled high
        if self.Speed >= 2 then -- if the speed is greater than 2 (tolerances for inaccuracies registered due to wobble)
            self.ThrottleState = -100 -- Register the throttle to be all the way back
            self.Traction = -100
        elseif self.Speed < 2 then
            self.Traction = 0
        end
        self.Train.FrontBogey.BrakePressure = 2.7
        self.Train.MiddleBogey.BrakePressure = 2.7
        self.Train.RearBogey.BrakePressure = 2.7
        self.BrakePressure = 2.7
    else
        self.Train.FrontBogey.BrakePressure =
        self.Train.FrontBogey.BrakePressure
        self.Train.MiddleBogey.BrakePressure =
        self.Train.MiddleBogey.BrakePressure
        self.Train.RearBogey.BrakePressure = self.Train.RearBogey.BrakePressure
        self.ThrottleState = self.ThrottleState
        self.Traction = self.Traction
    end
    
    if self.ThrottleState ~= 0 and self.ReverserState ~= 1 and
    self.ReverserState ~= 0 and self.BatteryOn == true then
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
    
    self.Train.PantoUp =
    self.Train.PantoUp or self.Train:ReadTrainWire(6) > 0 and
    self.Train:ReadTrainWire(17) > 0
    
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

function TRAIN_SYSTEM:CheckDoorsAllClosed(enable)
    local DoorOpen
    if enable then
        for k, v in pairs(self.Train.WagonList) do
            if self.Train.DoorSideUnlocked == "Left" or
            self.Train:ReadTrainWire(13) > 0 then
                for i in pairs(v.DoorStatesLeft) do
                    if v.DoorStatesLeft[i] ~= 0 then
                        self.Train:WriteTrainWire(16, 0)
                        DoorOpen = true
                    else
                        self.Train:WriteTrainWire(16, 1)
                    end
                end
            elseif self.Train.DoorSideUnlocked == "Right" or
            self.Train:ReadTrainWire(14) > 0 then
                for i in pairs(v.DoorStatesRight) do
                    if v.DoorStatesRight[i] ~= 0 then
                        self.Train:WriteTrainWire(16, 0)
                        DoorOpen = true
                    else
                        self.Train:WriteTrainWire(16, 1)
                    end
                end
            end
        end
        return DoorOpen
    else
        return false
    end
    
end
