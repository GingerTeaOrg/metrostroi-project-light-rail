Metrostroi.DefineSystem( "Duewag_U3" )
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
    self.Orientation = 0
    self.ReverseOrientation = 0
    self.IBISKeyA = false
    self.IBISKeyATurned = false
    self.IBISKeyB = false
    self.IBISKeyBTurned = false
end

if CLIENT then return end
function TRAIN_SYSTEM:Inputs()
    return { "HeadlightsSwitch", "BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure", "ReverserState", "ReverserLeverState", "ReverserInserted", "BellEngage", "Horn", "BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse", "CloseDoorsButton", "DoorsOpenButton" }
end

function TRAIN_SYSTEM:Outputs()
    return { "VE", "VZ", "ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled", "ReverserLeverState" }
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think( dT )
    local train = self.Train
    self:Reverser( train )
    self:ThrottleAgent( train )
    -- print(self.ReverserState,self.Traction,self.Train)
    self.Speed = math.abs( train:GetVelocity():Dot( train:GetAngles():Forward() ) * 0.06858 )
    -- only pass on the actual value if the respective reverser is engaged 
end

function TRAIN_SYSTEM:ThrottleAgent( train )
    self.ThrottleStateA = self.ThrottleStateA + self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
    self.ThrottleStateB = self.ThrottleStateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
    local cabA = self.ReverserLeverStateA > 0 or self.ReverserLeverStateA < 0
    local cabB = self.ReverserLeverStateB > 0 or self.ReverserLeverStateB < 0
    if cabA then
        self.ThrottleState = self.ThrottleStateA
    elseif cabB then
        self.ThrottleState = self.ThrottleStateB
    end

    train:SetNW2Float( "ThrottleStateA", self.ThrottleStateA )
    train:WriteTrainWire( 1, self.ThrottleState )
end

function TRAIN_SYSTEM:Reverser( train )
    train:SetNW2Bool( "ReverserInsertedA", self.ReverserInsertedA )
    train:SetNW2Bool( "ReverserInsertedB", self.ReverserInsertedB )
    local values = {
        [ 1 ] = 0.4,
        [ 0 ] = 0.25,
        [ 3 ] = 0.8,
        [ 2 ] = 0.7,
        [ -1 ] = 0
    }

    local reversed = self.ReverserLeverStateA < 0 or self.ReverserLeverStateB > 0
    train:WriteTrainWire( 4, reversed and 1 or 0 )
    train:SetNW2Float( "ReverserAnimate", values[ self.ReverserLeverStateA ] )
end