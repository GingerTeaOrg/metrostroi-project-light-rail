Metrostroi.DefineSystem( "Duewag_U2" )
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
    self.EngagedResistors = 0
    self.PreviousResistors = 0
    self.switchingMomentRegistered = false
    self.SwitchingMoment = 0
    self.CurrentTraction = 0
    self.PreviousTraction = 0
    self.DoorStatesRight = {
        [ 1 ] = 0,
        [ 2 ] = 0,
        [ 3 ] = 0,
        [ 4 ] = 0,
    }

    self.DoorStatesLeft = {
        [ 1 ] = 0,
        [ 2 ] = 0,
        [ 3 ] = 0,
        [ 4 ] = 0,
    }

    self.DoorOpenMoments = {
        [ 1 ] = 0,
        [ 2 ] = 0,
        [ 3 ] = 0,
        [ 4 ] = 0,
    }

    self.DoorCloseMoments = {
        [ 1 ] = 0,
        [ 2 ] = 0,
        [ 3 ] = 0,
        [ 4 ] = 0,
    }

    self.DoorLockSignalMoment = 0
    self.DoorRandomness = {
        [ 1 ] = 0,
        [ 2 ] = 0,
        [ 3 ] = 0,
        [ 4 ] = 0,
    }
end

if CLIENT then return end
function TRAIN_SYSTEM:Inputs()
    return { "HeadlightsSwitch", "BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure", "ReverserState", "ReverserLeverState", "ReverserInserted", "BellEngage", "Horn", "BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse", "CloseDoorsButton", "DoorsOpenButton" }
end

function TRAIN_SYSTEM:Outputs()
    return { "VE", "VZ", "ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled", "ReverserLeverState" }
end

function TRAIN_SYSTEM:TriggerInput( name, value )
    if self[ name ] then self[ name ] = value end
end

function TRAIN_SYSTEM:ReadTrainWire( wire )
    return self.Train:ReadTrainWire( wire )
end

function TRAIN_SYSTEM:WriteTrainWire( wire, value )
    self.Train:WriteTrainWire( wire, value )
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think( Train, dT )
    local t = self.Train
    self:TriggerInput()
    self:TriggerOutput()
    t.Resistorbank:Engine()
    self:MUHandler()
    -- print(self.ReverserState,self.Traction,self.Train)
    self.Speed = self.Train.Speed
    -- PrintMessage(HUD_PRINTTALK,self.ResistorBank)
    self.PrevTime = self.PrevTime or RealTime() - 0.33
    self.DeltaTime = RealTime() - self.PrevTime
    self.PrevTime = RealTime()
    local dT = self.DeltaTime
    -- Control Throttles in A or B independently, but....
    self.ThrottleStateA = self.ThrottleStateA + self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
    self.ThrottleStateB = self.ThrottleStateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
    -- only pass on the actual value if the respective reverser is engaged 
    if self.ReverserLeverStateA > 0 or self.ReverserLeverStateA < 0 then
        self.ThrottleState = self.ThrottleStateA
    elseif self.ReverserLeverStateB > 0 or self.ReverserLeverStateB < 0 then
        self.ThrottleState = self.ThrottleStateB
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

    if IsValid( self.Train.SectionB ) then
        self.Train.SectionB:SetNW2Float( "ThrottleAnimB", self.ThrottleStateAnimB )
        self.Train:SetNW2Float( "ThrottleStateAnim", self.ThrottleStateAnimA )
    end

    -- Is the throttle engaged? We need to know that for a few things!
    self.ThrottleEngaged = self.ThrottleState ~= 0
    self.Train:SetNW2Bool( "ThrottleEngaged", self.ThrottleEngaged )
    self.ReverserLeverStateA = math.Clamp( self.ReverserLeverStateA, -1, 3 )
    self.ReverserLeverStateB = math.Clamp( self.ReverserLeverStateB, -1, 3 )
    self.Train:WriteTrainWire( 7, ( self.BatteryOn or self.Train:ReadTrainWire( 6 ) > 0 ) and 1 or 0 )
    local values = {
        [ 1 ] = 0.4,
        [ 0 ] = 0.25,
        [ 3 ] = 0.8,
        [ 2 ] = 0.7,
        [ -1 ] = 0
    }

    self.Train.SectionB:SetNW2Float( "ReverserAnimate", values[ self.ReverserLeverStateB ] or 0 )
    self.Train:SetNW2Float( "ReverserAnimate", values[ self.ReverserLeverStateA ] or 0 )
    self.Train.SectionB:SetNW2Int( "ReverserLever", self.ReverserLeverStateB )
    -- Only on the * Setting of the reverser lever should the battery turn on, or the MU wire and the battery wire
    self.BatteryOn = self.Train:ReadTrainWire( 6 ) > 0 and self.Train:ReadTrainWire( 7 ) > 0 or ( self.BatteryStartUnlock and self.Train:GetNW2Bool( "BatteryOn", false ) ) or self.BatteryOn
    -- if the battery is on, we can command the pantograph
    self.PantoUp = ( self.Train:GetNW2Bool( "BatteryOn", false ) == true and self.Train:GetNW2Bool( "PantoUp" ) ) or ( self.Train:ReadTrainWire( 17 ) > 0 and self.Train:ReadTrainWire( 6 ) > 0 )
    self.Train:SetNW2Bool( "ReverserInsertedA", self.ReverserInsertedA )
    self.Train:SetNW2Bool( "ReverserInsertedB", self.ReverserInsertedB )
    self.Train:TriggerInput( "DriversWrenchPresent", ( self.ReverserInsertedA or self.ReverserInsertedB ) and 1 or 0 )
    self.EmergencyBrake = self.Train:GetNW2Bool( "EmergencyBrake", false )
    self.Train:SetNW2Float( "BlinkerStatus", self.Train.Panel.BlinkerLeft > 0 and 1 or ( self.Train.Panel.BlinkerRight > 0 and self.Train.Panel.BlinkerLeft < 1 ) and 0 or 0.5 )
    self.ReverserState = self.ReverserLeverStateA > 0 and 1 or self.ReverserLeverStateA < 0 and -1 or 0
    self.Train:WriteTrainWire( 12, ( self.Train.DeadmanUF.IsPressed > 0 and self.Train:ReadTrainWire( 6 ) > 0 and ( self.ReverserLeverStateA ~= 0 or self.ReverserLeverStateB ~= 0 ) ) and 1 or 0 )
    self.Train:WriteTrainWire( 6, ( self.VZ == true and self.Train:ReadTrainWire( 6 ) < 1 ) and 1 or ( self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2 ) and 1 or 0 )
    self.TractionConditionFulfilled = ( self.Train:ReadTrainWire( 12 ) > 0 and self.Train:ReadTrainWire( 6 ) > 0 ) and true or ( self.VE and self.Train.DeadmanUF.IsPressed > 0 ) and true or false
    self.Traction = math.Clamp( self.ThrottleState * 0.01, -1, 1 )
    self.Train:WriteTrainWire( 1, self.Traction )
    self.Train:WriteTrainWire( 10, self.EmergencyBrake == true and 1 or 0 )
end

function TRAIN_SYSTEM:MUHandler()
    local VEStates = {
        [ -1 ] = true,
        [ 3 ] = true,
    }

    self.VZ = self.VZ or self.Train:ReadTrainWire( 6 ) > 0 and ( self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 0 ) or self.Train:ReadTrainWire( 6 ) > 1
    self.VE = self.VE or not self.VZ or ( VEStates[ self.ReverserLeverStateA ] or VEStates[ self.ReverserLeverStateB ] )
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

    self.Train:WriteTrainWire( 3, self.ReverserLeverStateA == 2 and self.ReverserInsertedA and 1 or self.ReverserLeverStateB == 2 and self.ReverserInsertedB and 0 or 0 )
    self.Train:WriteTrainWire( 4, self.ReverserLeverStateA == 2 and self.ReverserInsertedA and 0 or self.ReverserLeverStateB == 2 and self.ReverserInsertedB and 1 or 0 )
    self.Train:WriteTrainWire( 6, ( self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2 ) and 1 or 0 )
    ---------------------------------------------------------------------------------------
    -- if the emergency brake is pulled high
    if self.Train:ReadTrainWire( 10 ) > 0 then
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
        self.Train:SetNW2Bool( "Fans", true )
    elseif self.BatteryOn == false then
        self.Train:SetNW2Bool( "Fans", false )
    end

    if CurTime() - self.FanTimer > 5 and self.Speed < 5 then self.Train:SetNW2Bool( "Fans", false ) end
    if self.BatteryOn == false or self.Train:ReadTrainWire( 7 ) < 1 then
        self.Train:WriteTrainWire( 3, 0 )
        self.Train:WriteTrainWire( 4, 0 )
        self.Train:WriteTrainWire( 6, 0 )
    end

    self.Train.PantoUp = self.Train.PantoUp or self.Train:ReadTrainWire( 6 ) > 0 and self.Train:ReadTrainWire( 17 ) > 0
    if self.Train.PantoUp == true then
        if self.Train:ReadTrainWire( 6 ) > 0 then self.Train:WriteTrainWire( 17, 1 ) end
        self.Train:SetNW2Bool( "PantoUp", true )
    elseif self.Train.PantoUp == false then
        self.Train:SetNW2Bool( "PantoUp", false )
        if self.Train:ReadTrainWire( 6 ) > 0 then self.Train:WriteTrainWire( 17, 0 ) end
    end
    -- print(self.Train:GetNW2Bool("PantoUp"))
    -- print(self.Train:GetNW2Bool("Fans"))
end

function TRAIN_SYSTEM:Blink( enable, left, right )
    local t = self.Train
    local sectionB = t.SectionB
    local tailblink = IsValid( t.RearCouple.CoupledEnt ) and self:ReadTrainWire( 6 ) > 0
    if t.BatteryOn == true or t:ReadTrainWire( 6 ) > 0 then
        if not enable then
            t.BlinkerOn = false
            t.LastTriggerTime = CurTime()
        elseif CurTime() - t.LastTriggerTime > 0.4 then
            t.BlinkerOn = not t.BlinkerOn
            t.LastTriggerTime = CurTime()
        end

        t:SetLightPower( 58, t.BlinkerOn and left )
        t:SetLightPower( 48, t.BlinkerOn and left )
        t:SetLightPower( 59, t.BlinkerOn and right )
        t:SetLightPower( 49, t.BlinkerOn and right )
        t:SetLightPower( 38, t.BlinkerOn and right or left and t.BlinkerOn )
        t:SetLightPower( 56, t.BlinkerOn and left and right )
        t:SetLightPower( 57, t.BlinkerOn and left and right )
        sectionB:SetLightPower( 148, t.BlinkerOn and left )
        sectionB:SetLightPower( 158, t.BlinkerOn and left )
        sectionB:SetLightPower( 159, t.BlinkerOn and right )
        sectionB:SetLightPower( 149, t.BlinkerOn and right )
        sectionB:SetLightPower( 66, t.BlinkerOn and left and right )
        sectionB:SetLightPower( 67, t.BlinkerOn and left and right )
        t:SetLightPower( 48, t.BlinkerOn and left )
        t:SetLightPower( 58, t.BlinkerOn and left )
        t:SetLightPower( 59, t.BlinkerOn and right )
        t:SetNW2Bool( "BlinkerTick", t.BlinkerOn ) -- one tick sound for the blinker relay
    end
end