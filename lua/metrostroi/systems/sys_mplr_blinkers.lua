Metrostroi.DefineSystem( "Blinkers" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    self.LastTriggerTime = 0
    self.BlinkerOn = false
end

function TRAIN_SYSTEM:Blink( enable, left, right )
    local t = self.Train
    local sectionB = t.SectionB
    local sectionA = t.SectionA
    local tailblink = not IsValid( t.RearCouple.CoupledEnt ) and t:ReadTrainWire( 6 ) < 1
    local blinkerTabL = t.BlinkersLeft
    local blinkerTabR = t.BlinkersRight
    local brakeLightL = t.BrakeLightLeft
    local brakeLightR = t.BrakeLightRight
    local function blinking( enable, left, right, ent )
        local t = self.Train
        if not enable then
            self.BlinkerOn = false
            self.LastTriggerTime = CurTime()
        elseif CurTime() - t.LastTriggerTime > 0.4 then
            self.BlinkerOn = not self.BlinkerOn
            self.LastTriggerTime = CurTime()
        end

        for k, _ in ipairs( blinkerTabL ) do
            ent:SetLightPower( k, self.BlinkerOn and left )
        end

        for k, _ in ipairs( blinkerTabR ) do
            ent:SetLightPower( k, self.BlinkerOn and right )
        end

        ent:SetNW2Bool( "BlinkerTick", self.BlinkerOn )
    end

    local function HazardLights( enable )
        local fC = IsValid( t.FrontCouple.CoupledEnt )
        local rC = IsValid( t.RearCouple.CoupledEnt )
        if sectionA and not fC then
            for k, _ in ipairs( brakeLightL ) do
                sectionA:SetLightPower( k, enable )
            end

            for k, _ in ipairs( brakeLightR ) do
                sectionA:SetLightPower( k, enable )
            end
        end

        if sectionB and not rC then
            for k, _ in ipairs( brakeLightL ) do
                sectionB:SetLightPower( k, enable )
            end

            for k, _ in ipairs( brakeLightR ) do
                sectionB:SetLightPower( k, enable )
            end
        end

        if not sectionA and fC then
            for k, _ in ipairs( brakeLightL ) do
                t:SetLightPower( k, enable )
            end

            for k, _ in ipairs( brakeLightR ) do
                t:SetLightPower( k, enable )
            end
        end
    end

    if t.CoreSys.BatteryOn or t:ReadTrainWire( 6 ) > 0 then
        if sectionA then blinking( enable, left, right, sectionA ) end
        if sectionB then blinking( enable, left, right, sectionB ) end
        blinking( enable, left, right, self )
        if left and right then HazardLights( self.BlinkerOn ) end
    end
end