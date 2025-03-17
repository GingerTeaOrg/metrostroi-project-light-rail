Metrostroi.DefineSystem( "HeadlightController" )
function TRAIN_SYSTEM:IsACoupled()
    return IsValid( self.Train.FrontCoupler.CoupledEnt )
end

function TRAIN_SYSTEM:IsBCoupled()
    return IsValid( self.Train.RearCoupler.CoupledEnt )
end

function TRAIN_SYSTEM:TurnOnHeadlightsA()
    local lightsTab = self.Train.HeadlightsTab
    if self.HeadlightsEnableDone then return end
    for k in ipairs( lightsTab ) do
        self.Train:SetLightPower( k, true )
    end

    self:TurnOnTaillights()
    self.HeadlightsEnableDone = true
end

function TRAIN_SYSTEM:TurnOffHeadlightsA()
    local lightsTab = self.Train.HeadlightsTab
    if not self.HeadlightsDisableDone then return end
    for k in ipairs( lightsTab ) do
        self.Train:SetLightPower( k, false )
    end

    self:TurnOffTaillights()
    self.HeadlightsEnableDone = false
end

function TRAIN_SYSTEM:TurnOnTaillightsA()
    local lightsTab = self.Train.TaillightsTab
    if self.TaillightsEnableDone then return end
    for k in ipairs( lightsTab ) do
        self.Train:SetLightPower( k, true )
    end
end

function TRAIN_SYSTEM:TurnOnTaillightsB()
    local lightsTab = self.Train.TaillightsTab
    if self.TaillightsEnableDoneB then return end
    for k in ipairs( lightsTab ) do
        self.Train.SectionB:SetLightPower( k, true )
    end
end

function TRAIN_SYSTEM:TurnOffTaillightsA()
    local lightsTab = self.Train.TaillightsTab
    if self.TraillightsDisableDone then return end
    for k in ipairs( lightsTab ) do
        self.Train:SetLightPower( k, false )
    end
end

function TRAIN_SYSTEM:ForwardBackward()
    local reverserA = self.Train.CoreSys.ReverserA
    local reverserB = self.Train.CoreSys.ReverserB
    if reverserA > 0 or reverserB < 0 then
        self.Forward = true
        self.Backward = true
    elseif reverserB > 0 or reverserA < 0 then
        self.Forward = false
        self.Backward = true
    elseif reverserB == 0 and reverserB == 0 then
        self.Forward = false
        self.Backward = false
    end
end

function TRAIN_SYSTEM:Initialize()
    self.HeadlightsDisableDone = true
    self.HeadlightsEnableDone = false
    self.HeadlightsOn = false
    self.TaillightsOn = false
    self.TaillightsEnableDone = false
    self.TaillightsDisableDone = true
    self.AIsCoupled = false
    self.BIsCoupled = false
    self.Forward = false
    self.Backward = false
end

function TRAIN_SYSTEM:DirectionalLighting()
    local aCoupled = self:IsACoupled()
    local bCoupled = self:IsBCoupled()
    if self.Forward then
        if aCoupled then
            self:TurnOnHeadlightsA()
            self:TurnOffTaillightsA()
        end
    elseif self.Backward then
        self.HeadlightsEnableDone = false
        self:TurnOnTaillightsA()
        self:TurnOffHeadlightsA()
    end
end

function TRAIN_SYSTEM:Think( dT )
    self:ForwardBackward()
end