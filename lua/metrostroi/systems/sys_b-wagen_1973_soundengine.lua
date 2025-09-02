Metrostroi.DefineSystem( "duewag_b_1973_soundeng" )
function TRAIN_SYSTEM:Initialize()
    self.BrakeHiss = false
    self.BrakesAppliedFullSound = false
    ----
    self.Compressor = false
    ----
    self.CruiseSound = 0
end

function TRAIN_SYSTEM:ClientInitialize()
end

----------------------------------------------------------------
function TRAIN_SYSTEM:Think()
    self.CoreSys = self.CoreSys or self.Train.CoreSys
    self.Speed = self.CoreSys.Speed
    self.BrakesAreApplied = self.CoreSys.BrakesAreApplied
    self:BrakeSounds()
    self:MotorSounds()
end

function TRAIN_SYSTEM:MotorSounds()
    if self.Train.FrontBogey.MotorPower ~= 0 or self.Train.CoreSys.ThrottleStateA > 0 then
        --PrintMessage( HUD_PRINTTALK, "Chopper Sound On" )
        self.Train:SetNW2Bool( "Chopper", true )
    else
        self.Train:SetNW2Bool( "Chopper", false )
    end
end

function TRAIN_SYSTEM:BrakeSounds()
    if self.Speed < 5 and self.BrakesAreApplied and not self.BrakesAppliedFullSound then
        self.BrakesAppliedFullSound = true
        self.Train:SetNW2Bool( "BrakeSetHiss", true )
        self.Train:SetNW2Bool( "BrakeSetHiss", false )
    elseif self.Speed > 5 and not self.BrakesAreApplied and self.BrakesAppliedFullSound then
        self.Train:SetNW2Bool( "BrakeSetHiss", false )
        self.BrakesAppliedFullSound = false
    end
end

local time
function TRAIN_SYSTEM:ClientThink()
    time = time or RealTime()
    --print( time, RealTime(), RealTime() - time > 15 )
    if RealTime() - time > 15 then
        time = RealTime()
        --self.Train:PlayOnceFromPos( "DepartureConfirmed", self.Train.SoundNames[ "DepartureConfirmed" ][ 1 ], 1, 1, 1, 1, Vector( 400, 0, 100 ) )
    end

    ----
    local batteryOn = self.Train:GetNW2Bool( "BatteryOn", false )
    if not batteryOn then return end
    local departureAlarm = self.Train:GetNW2Bool( "DepartureAlarm", false )
    --print( departureAlarm )
    if departureAlarm then
        self.Train:PlayOnceFromPos( "DepartureConfirmed", self.Train.SoundNames[ "DepartureConfirmed" ][ 1 ], 1, 1, 1, 1, self.Train.SoundPositions[ "DepartureConfirmed" ][ 3 ] )
        self.Train:SetNW2Bool( "DepartureAlarm", false )
        LocalPlayer():PrintMessage( HUD_PRINTTALK, "Ding!!" )
    end

    --self.Train:SetSoundState( "bell", self.Train:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
    self.Train:SetSoundState( "bell_in", self.Train:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
    local brakeSetHiss = self.Train:GetNW2Bool( "BrakeSetHiss", false )
    if brakeSetHiss then self.Train:PlayOnceFromPos( "BrakesSet", self.Train.SoundNames[ "BrakesSet" ][ 1 ], 1, 1, 1, 1, Vector( 400, 0, 100 ) ) end
    --------
    local chopper = self.Train:GetNW2Bool( "Chopper", false )
    self.Train:SetSoundState( "Chopper", chopper and 1 or 0, 1 )
end

----------------------------------------------------------------
if SERVER then
    function TRAIN_SYSTEM:ServerPlaceholder()
    end
end

if CLIENT then
    function TRAIN_SYSTEM:ClientPlaceholder()
    end
end