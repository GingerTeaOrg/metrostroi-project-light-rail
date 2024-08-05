Metrostroi.DefineSystem( "Throttle" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    local t = self.Train
    self.ReverserStateA = 0
    self.ThrottleStateA = 0
    self.ThrottleRateA = 0
    self.ReverserInsertedA = false
    if t.RequireIgnitionKey then
        self.IgnitionKeyInsertedA = false
        self.IgnitionKeyA = false
    end

    if t.Bidirectional then --provisions for trains that aren't bidirectional
        self.ReverserStateB = 0
        self.ThrottleStateB = 0
        self.ThrottleRateB = 0
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

function TRAIN_SYSTEM:ThrottleAUp()
    if self.ThrottleStateA == 100 then return end
    self.ThrottleStateA = self.ThrottleStateA + self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
end

function TRAIN_SYSTEM:ThrottleADown()
    if self.ThrottleStateA == 0 then return end
    self.ThrottleStateA = self.ThrottleStateA - self.ThrottleRateA
    self.ThrottleStateA = math.Clamp( self.ThrottleStateA, -100, 100 )
end

function TRAIN_SYSTEM:SetAToPct( percent )
    self.ThrottleStateA = percent
end

function TRAIN_SYSTEM:SetBToPct( percent )
    self.ThrottleStateB = percent
end

function TRAIN_SYSTEM:ThrottleBUp()
    if self.ThrottleStateB == 100 then return end
    self.ThrottleStateB = self.ThrottleStateB + self.ThrottleRateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
end

function TRAIN_SYSTEM:ThrottleBDown()
    if self.ThrottleStateB == 0 then return end
    self.ThrottleStateB = self.ThrottleStateB - self.ThrottleRateB
    self.ThrottleStateB = math.Clamp( self.ThrottleStateB, -100, 100 )
end