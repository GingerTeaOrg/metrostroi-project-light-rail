Metrostroi.DefineSystem( "Blinkers" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    self.LastTriggerTime = 0
    self.BlinkerOn = false
end

function TRAIN_SYSTEM:Think( dT )
    local p = self.Train.Panel
    local enable = p.BlinkerLeft > 0 or p.BlinkerRight > 0
    self:Blink( enable, p.BlinkerLeft > 0, p.BlinkerRight > 0 )
    --print( self.Train.Lights[ 49 ] )
end

function TRAIN_SYSTEM:Blink( enable, left, right )
    local t = self.Train
    local sectionB = t.SectionB
    local sectionA = t.SectionA
    if t.CoreSys.BatteryOn or t:ReadTrainWire( 6 ) > 0 then
        if left and right then
            self:HazardLights( self.BlinkerOn )
        else
            if sectionA then self:Blinking( enable, left, right, sectionA ) end
            if sectionB then self:Blinking( enable, left, right, sectionB ) end
            self:Blinking( enable, left, right, self.Train )
        end
    end
end

function TRAIN_SYSTEM:Blinking( enable, left, right, ent )
    local blinkerTabL = self.Train.BlinkersLeft
    local blinkerTabR = self.Train.BlinkersRight
    if not enable then
        self.BlinkerOn = false
        self.LastTriggerTime = CurTime()
        for k in pairs( blinkerTabL ) do
            ent:SetLightPower( k, self.BlinkerOn )
        end

        for k in pairs( blinkerTabR ) do
            ent:SetLightPower( k, self.BlinkerOn )
        end
    elseif CurTime() - self.LastTriggerTime > 0.4 then
        self.BlinkerOn = not self.BlinkerOn
        self.LastTriggerTime = CurTime()
    end

    if left then
        for k in pairs( blinkerTabL ) do
            ent:SetLightPower( k, self.BlinkerOn )
        end
    end

    if right then
        for k in pairs( blinkerTabR ) do
            ent:SetLightPower( k, self.BlinkerOn )
        end
    end

    ent:SetNW2Bool( "BlinkerTick", self.BlinkerOn )
end

function TRAIN_SYSTEM:HazardLights( enable )
    local t = self.Train
    local brakeLightL = t.BrakeLightLeft
    local brakeLightR = t.BrakeLightRight
    local fC = IsValid( t.FrontCouple.CoupledEnt )
    local rC = IsValid( t.RearCouple.CoupledEnt )
    if sectionA and not fC then
        for k in ipairs( brakeLightL ) do
            sectionA:SetLightPower( k, enable )
        end

        for k in ipairs( brakeLightR ) do
            sectionA:SetLightPower( k, enable )
        end
    end

    if sectionB and not rC then
        for k in ipairs( brakeLightL ) do
            sectionB:SetLightPower( k, enable )
        end

        for k in ipairs( brakeLightR ) do
            sectionB:SetLightPower( k, enable )
        end
    end

    if not sectionA and fC then
        for k in ipairs( brakeLightL ) do
            t:SetLightPower( k, enable )
        end

        for k in ipairs( brakeLightR ) do
            t:SetLightPower( k, enable )
        end
    end
end