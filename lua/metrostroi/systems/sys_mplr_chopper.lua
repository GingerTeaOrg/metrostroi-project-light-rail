Metrostroi.DefineSystem("Chopper")

function TRAIN_SYSTEM:Initialize()
    
    -- Define constants
    self.Vdc = UF.Voltage -- DC source voltage, usually 600 to 650V
    self.Rload = 10 -- Load resistance
    self.L = 0.1 -- Inductance
    self.C = 0.01 -- Capacitance
    
    -- Initial conditions
    self.Vc = 0 -- Capacitor voltage
    self.Il = 0 -- Inductor current
    self.Vt = 0 -- Thyristor voltage
    self.Iload = 0 -- Load current
    self.ChopperOutput = 0
    self.Frequency = 50
end

function TRAIN_SYSTEM:Think(dT)
    local t = self.Train:ReadTrainWire(1)
    -- Run simulation with assumed frequency of 50 Hz
    self.ChopperOutput = self:simulateChopperThyristor(math.abs(t), 50,dT) -- Example: 50 Hz, 50% duty cycle, simulation time 0.1 seconds
    
end



-- Simulation function
function TRAIN_SYSTEM:simulateChopperThyristor(dutyCycle, dT)
    local period = 1 / self.Frequency
    if dutyCycle == 0 then self:Initialize() return 0 end
    -- Update control signals based on real time
    local time = CurTime()
    local Vg = (time % period) < (dutyCycle * period) and self.Vdc or 0
    
    -- Calculate current and voltage
    local diL = (Vg - self.Vt - self.Il * self.Rload) / self.L * dT
    local dVc = (self.Il - self.Iload) / self.C * dT

    
    self.Il = self.Il + diL
    self.Vc = math.floor(self.Vc + dVc)
    self.Vt = self.Vc > 0 and self.Vdc or 0
    self.Iload = self.Vc / self.Rload
    self.Vc = self.Vc > 0 and self.Vc / 100000 or 0
    return self.Vc
end

function TRAIN_SYSTEM:setMotorPower(power)
    -- Assuming two motors are named motor1 and motor2
    -- Adjust the behavior of the system based on MotorPower percentage
    -- You may need to tweak this logic based on your system's behavior
    local totalPower = power / 100 * self.Vdc
    
    if self.MotorMode == "parallel" then
        self.Vt = totalPower / 2 > 0 and self.Vdc or 0
    elseif self.MotorMode == "series" then
        self.Vt = totalPower > 0 and self.Vdc or 0
    end
end