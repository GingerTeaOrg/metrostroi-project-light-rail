Metrostroi.DefineSystem( "Throttle" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    local t = self.Train
    self.ReverserStateA = 0
    self.ThrottleStateA = 0
    self.ThrottleRateA = 0
    self.ThrottleUpA = false
    self.ThrottleUpAFast = false
    self.ThrottleDownA = false
    self.ThrottleDownAFast = false
    self.ReverserInsertedA = false
    if t.RequireIgnitionKey then
        self.IgnitionKeyInsertedA = false
        self.IgnitionKeyA = false
    end

    if t.Bidirectional then --provisions for trains that aren't bidirectional
        self.ReverserStateB = 0
        self.ThrottleStateB = 0
        self.ThrottleRateB = 0
        self.ThrottleUpB = false
        self.ThrottleUpBFast = false
        self.ThrottleDownB = false
        self.ThrottleDownBFast = false
        self.CabBActive = false
        if t.RequireIgnitionKey then
            self.IgnitionKeyInsertedB = false
            self.IgnitionKeyA = false
        end
    end

    self.CabAActive = false
end

function TRAIN_SYSTEM:Think( dT )
    local t = self.Train
    t:SetNW2Float( "ThrottleStateA", self.ThrottleStateA )
    t:SetNW2Float( "ThrottleStateB", self.ThrottleStateB )
    self:ThrottleRunner()
end

function TRAIN_SYSTEM:ThrottleRunner()
    if self.ThrottleUpA then
        self:SetThrottleAUp( self.ThrottleUpAFast )
    elseif self.ThrottleUpB then
        self:SetThrottleBUp( self.ThrottleUpBFast )
    elseif self.ThrottleADown then
        self:SetThrottleADown( self.ThrottleBDownFast )
    elseif self.ThrottleBDown then
        self.SetThrottleBDown( self.ThrottleBDownFast )
    end
end

function TRAIN_SYSTEM:CabActive()
    local t = self.Train
    local requireKey = t.RequireIgnitionKey
    local bidirectional = t.Bidirectional
    if requireKey then
        if bidirectional and self.IgnitionKeyA then
            self.CabAActive = true
        elseif bidirectional and self.IgnitionKeyB then
            self.CabBActive = true
        elseif not bidirectional then
            self.CabAActive = self.IgnitionKeyA
        end
    else
        self.CabAActive = self.ReverserInsertedA
        self.CabBActive = self.ReverserInsertedB
    end
end

function TRAIN_SYSTEM:SetThrottleAUp( fast )
    if self.ThrottleStateA == 100 then
        self.ThrottleRateA = 0
        return
    end

    local rate = fast and 8 or 4
    self.ThrottleRateA = self.ThrottleRateA + rate
    self.ThrottleStateA = self.ThrottleStateA + self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
    return
end

function TRAIN_SYSTEM:SetThrottleADown( fast )
    if self.ThrottleStateA == -100 then
        self.ThrottleRateA = 0
        return
    end

    local rate = fast and 8 or 4
    self.ThrottleRateA = self.ThrottleRateA + rate
    self.ThrottleStateA = self.ThrottleStateA - self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
    return
end

function TRAIN_SYSTEM:ThrottleAStopMove()
    self.ThrottleRateA = 0
end

function TRAIN_SYSTEM:ThrottleAZero()
    print( "zeroooo" )
    self.ThrottleRateA = 0
    self.ThrottleStateA = 0
end

function TRAIN_SYSTEM:SetAToPct( percent )
    self.ThrottleStateA = percent
end

function TRAIN_SYSTEM:SetBToPct( percent )
    self.ThrottleStateB = percent
end

function TRAIN_SYSTEM:SetThrottleBUp()
    if self.ThrottleStateB == 100 then return end
    self.ThrottleStateB = self.ThrottleStateB + self.ThrottleRateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
end

function TRAIN_SYSTEM:SetThrottleBDown()
    if self.ThrottleStateB == 0 then return end
    self.ThrottleStateB = self.ThrottleStateB - self.ThrottleRateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
end