Metrostroi.DefineSystem("Chopper")

function TRAIN_SYSTEM:Initialize()
    -- Define constants
    self.Vdc = UF.Voltage -- DC source voltage, set server-wide by CVAR
    self.Rload = 10 -- Load resistance
    self.L = 0.1 -- Inductance
    self.C = 0.01 -- Capacitance
    
    -- Initial conditions
    self.Vc = 0 -- Capacitor voltage
    self.Il = 0 -- Inductor current
    self.Vt = 0 -- Thyristor voltage
    self.Iload = 0 -- Load current
    self.ChopperOutput = 0
    self.Frequency = 50 -- Frequency in Hz
    self.TickCounter = 0 -- Counter to keep track of ticks
    
    -- Constants for clamping
    self.Il_max = 1000 -- Maximum allowable inductor current
    self.Vc_max = 750 -- Maximum allowable capacitor voltage
    
    -- Damping factor for stability
    self.damping_factor = 0.95
end

function TRAIN_SYSTEM:Think(dT)
    -- Read train wire input and convert it to a duty cycle (0 to 100%)
    local dutyCycle = math.abs(self.Train:ReadTrainWire(1)) * 0.01
    -- Increment tick counter
    self.TickCounter = self.TickCounter + 1
    -- Simulate chopper thyristor
    self.ChopperOutput = self:simulateChopperThyristor(dutyCycle, dT)
end

-- Simulation function
function TRAIN_SYSTEM:simulateChopperThyristor(dutyCycle, dT)
    local period = 1 / self.Frequency
    
    if dutyCycle == 0 then
        -- Smooth transition when throttle is zeroed
        self.Il = self.Il * self.damping_factor
        self.Vc = self.Vc * self.damping_factor
        self.Vt = 0
        self.Iload = 0
        return 0
    end

    -- Calculate the effective time based on tick count and delta time
    local effectiveTime = CurTime() + dT
    
    -- Determine the gate voltage based on the duty cycle and effective time
    local Vg = (effectiveTime % period) < (dutyCycle * period) and self.Vdc or 0
    
    -- Calculate current and voltage changes
    local diL = (Vg - self.Vt - self.Il * self.Rload) / self.L * dT
    local dVc = (self.Il - self.Iload) / self.C * dT
    
    -- Update inductor current and capacitor voltage
    self.Il = self.Il + diL
    self.Vc = self.Vc + dVc
    
    -- Apply clamping to prevent extreme values
    self.Il = math.max(-self.Il_max, math.min(self.Il_max, self.Il))
    self.Vc = math.max(0, math.min(self.Vc_max, self.Vc))
    
    -- Update thyristor voltage and load current
    self.Vt = self.Vc > 0 and self.Vdc or 0
    self.Iload = self.Rload > 0 and (self.Vc / self.Rload) or 0
    
    -- Apply enhanced damping mechanism to stabilize values
    self.Il = self.Il * self.damping_factor
    self.Vc = self.Vc * self.damping_factor
    self.Vc = math.Clamp(self.Vc,0,1000)
    -- Debug print statement
    --print(string.format("TickCounter: %d, EffectiveTime: %.2f, Vg: %.2f, Il: %.2f, Vc: %.2f, Vt: %.2f, Iload: %.2f", self.TickCounter, effectiveTime, Vg, self.Il, self.Vc, self.Vt, self.Iload))
    
    return self.Vc
end

function TRAIN_SYSTEM:setMotorPower(power)
    -- Assuming two motors are named motor1 and motor2
    -- Adjust the behavior of the system based on MotorPower percentage
    local totalPower = power / 100 * self.Vdc
    
    if self.MotorMode == "parallel" then
        self.Vt = (totalPower / 2 > 0) and self.Vdc or 0
    elseif self.MotorMode == "series" then
        self.Vt = (totalPower > 0) and self.Vdc or 0
    end
end
