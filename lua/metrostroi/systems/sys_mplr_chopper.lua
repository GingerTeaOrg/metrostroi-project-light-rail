Metrostroi.DefineSystem( "Chopper" )
function TRAIN_SYSTEM:Initialize()
    -- Define constants
    self.Vdc = MPLR.Voltage -- DC source voltage, set server-wide by CVAR
    self.Rload = 10 -- Load resistance
    self.L = 0.1 -- Inductance
    self.C = 0.01 -- Capacitance
    -- Initial conditions
    self.Vc = 0 -- Capacitor voltage
    self.Il = 0 -- Inductor current
    self.Vt = 0 -- Thyristor voltage
    self.Iload = 0 -- Load current
    self.ChopperOutput = 0
    self.Frequency = 60 -- Frequency in Hz
    self.TickCounter = 0 -- Counter to keep track of ticks
    -- Constants for clamping
    self.Il_max = 1000 -- Maximum allowable inductor current
    self.Vc_max = 750 -- Maximum allowable capacitor voltage
    -- Damping factor for stability
    self.damping_factor = 0.95
end

function TRAIN_SYSTEM:ComputeLoadFactor( speed, throttle )
    local Vmax = self.Train.SubwayTrain.Vmax or 80
    local loadRange = 2
    speed = math.min( math.max( speed, 0 ), Vmax )
    local speedLoadFactor = 3 - ( speed / Vmax ) * loadRange
    local pitchDeg = self.Train:GetAngles().p or 0
    local pitchRad = math.rad( pitchDeg )
    -- Gradient as sine (positive means forward uphill)
    local slopeSin = math.sin( pitchRad )
    -- Get velocity sign: positive if moving forward, negative if backward
    local velocity = self.Train.CoreSys.Speed or 0
    local velocitySign = velocity >= 0 and 1 or -1
    -- Check if train is moving uphill:
    -- uphill if velocity direction opposes slope direction
    local movingUphill = ( velocitySign * slopeSin ) < 0
    self.Mass = self.Train.SubwayTrain.Mass
    self.g = 9.81
    local slopeForce = self.Mass * self.g * math.abs( slopeSin ) -- abs slope for load magnitude
    -- Base slope load factor = 1 + slopeForce / scale
    local slopeLoadFactor = 1
    if movingUphill then
        slopeLoadFactor = slopeLoadFactor + slopeForce / 10000
    else
        -- downhill or flat, reduce load a bit (optional)
        slopeLoadFactor = slopeLoadFactor * 0.9
    end

    local loadFactor = throttle * speedLoadFactor * slopeLoadFactor
    return math.max( 0.1, loadFactor )
end

function TRAIN_SYSTEM:Think( dT )
    local dutyCycle = math.abs( self.Train:ReadTrainWire( 1 ) ) * 0.01
    local speed = self.Train.CoreSys.Speed * 3.6 -- m/s to km/h
    local loadFactor = self:ComputeLoadFactor( speed, dutyCycle )
    self:SetLoadFactor( loadFactor )
    self.TickCounter = self.TickCounter + 1
    local currentTime = CurTime()
    self.ChopperOutput = self:simulateChopperThyristor( dutyCycle, dT, currentTime )
end

function TRAIN_SYSTEM:SetLoadFactor( factor )
    self.LoadFactor = math.max( 0.1, factor ) -- prevent zero or negative load
end

function TRAIN_SYSTEM:simulateChopperThyristor( dutyCycle, dT, currentTime )
    local period = 1 / self.Frequency
    if dutyCycle == 0 then
        self.Il = self.Il * self.damping_factor
        self.Vc = self.Vc * self.damping_factor
        self.Vt = 0
        self.Iload = 0
        return 0
    end

    local effectiveTime = currentTime + dT
    local Vg = ( effectiveTime % period ) < ( dutyCycle * period ) and self.Vdc or 0
    local effectiveRload = self.Rload / self.LoadFactor
    local diL = ( Vg - self.Vt - self.Il * effectiveRload ) / self.L * dT
    local dVc = ( self.Il - self.Iload ) / self.C * dT
    self.Il = self.Il + diL
    self.Vc = self.Vc + dVc
    self.Il = math.max( -self.Il_max, math.min( self.Il_max, self.Il ) )
    self.Vc = math.max( 0, math.min( self.Vc_max, self.Vc ) )
    self.Vt = self.Vc > 0 and self.Vdc or 0
    self.Iload = effectiveRload > 0 and ( self.Vc / effectiveRload ) or 0
    self.Il = self.Il * self.damping_factor
    self.Vc = self.Vc * self.damping_factor
    self.Vc = math.Clamp( self.Vc, 0, 1000 )
    return self.Vc
end