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
    self.PreviousTraction = 0
    self.Amps = 0
end

function TRAIN_SYSTEM:Think()
    self:Camshaft()
    self:Engine()
end

function TRAIN_SYSTEM:TriggerInput( key, val )
    if self[ key ] then
        self[ key ] = val
    else
        return false
    end
end

function TRAIN_SYSTEM:Camshaft()
    -- Constants
    local maxMotorCurrent = 250 -- Maximum current per motor
    local totalMotors = 2 -- Total number of motors
    local totalMaxCurrent = maxMotorCurrent * totalMotors -- Total maximum current
    local powerSupplyVoltage = UF.Voltage -- Power supply voltage
    local numResistors = self.ResistorCount -- Total number of resistors
    local maxResistorCurrent = self.MaxResistorCurrent -- Maximum current per resistor
    local latency = 2 -- Latency (seconds)
    local throttleState = self.Train.CoreSys.ThrottleState
    self.PrevResistors = self.EngagedResistors or 0 -- Ensure initialized
    -- Function to simulate latency
    local function simulateLatency()
        if not self.switchingMomentRegistered then
            self.switchingMomentRegistered = true
            self.SwitchingMoment = CurTime()
        end

        if CurTime() - self.SwitchingMoment > latency then
            self.switchingMomentRegistered = false
            return true
        end
        return false
    end

    -- Function to determine the number of resistors needed for a given throttle setting and speed
    local function controlResistors()
        local sys = self.Train.CoreSys
        local throttleState = self.Train.CoreSys.ThrottleState
        if throttleState == 0 or not throttleState then return 20 end
        local requestedCurrent = totalMaxCurrent / math.abs( throttleState ) -- Calculate requested current based on throttle setting
        local requiredResistors = math.ceil( requestedCurrent / maxResistorCurrent ) -- Calculate adjusted required resistors
        -- Adjust for speed factor
        local speedFactor = 0
        if sys.Speed > 0 and ( 80 / sys.Speed ) > 1 then speedFactor = math.ceil( 80 / sys.Speed ) end
        -- Ensure the number of resistors is within the available range
        requiredResistors = math.min( numResistors, requiredResistors + speedFactor )
        return requiredResistors
    end

    -- Simulate latency and update resistors if needed
    if math.abs( throttleState ) ~= self.PreviousTraction then
        print( "camshaft" )
        if simulateLatency() then
            -- Calculate the number of resistors based on throttle and speed
            self.EngagedResistors = controlResistors()
            self.PreviousTraction = math.abs( throttleState )
        end
    end

    self.CurrentResistors = self.EngagedResistors
    return self.EngagedResistors
end

function TRAIN_SYSTEM:Engine()
    local sys = self.Train.CoreSys
    -- 250A per motor, 2x250A, 600V, 20 resistors, 12.5A per resistor
    local prevResistors = prevResistors or 0
    -- camshaft only moves when you're actually in gear
    local prevGear = prevGear or false
    local inGear = ( self.ThrottleLeverStateA ~= 0 and self.ThrottleLeverStateA ~= 1 ) or ( self.ThrottleLeverStateB ~= 0 and self.ThrottleLeverStateB ~= 1 ) or ( self.Train:ReadTrainWire( 3 ) > 0 or self.Train:ReadTrainWire( 4 ) > 0 )
    local isMoving = sys.Speed > 3
    local isTractionApplied = sys.Traction ~= 0
    if prevResistors ~= self.EngagedResistors and inGear and isMoving and isTractionApplied then
        self.CamshaftMoved = true
        prevResistors = self.EngagedResistors
    elseif prevResistors == self.EngagedResistors and inGear then
        self.CamshaftMoved = false
    end

    -- ampmetre fakery for until we've got a real electrical sim
    if math.abs( self.Train.FrontBogey.Acceleration ) > 0 then
        self.Amps = 250000 / 600 * sys.Traction * 0.0000001 * math.Round( self.Train.FrontBogey.Acceleration, 1 )
    elseif self.Train.FrontBogey.Acceleration < 0 then
        self.Amps = 250000 / 600 * sys.Traction * 0.0000001 * math.Round( self.Train.FrontBogey.Acceleration * -1, 1 )
    end

    self.Train:SetNW2Bool( "CamshaftMoved", self.CamshaftMoved )
    self.Train:SetNWFloat( "Amps", self.Amps )
end