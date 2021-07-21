--------------------------------------------------------------------------------
-- 81-720 train horn
--------------------------------------------------------------------------------
-- Copyright (C) 2013-2018 Metrostroi Team & FoxWorks Aerospace s.r.o.
-- Contains proprietary code. See license.txt for additional information.
--------------------------------------------------------------------------------
UF.DefineSystem("uf_bell")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Active = false
end

function TRAIN_SYSTEM:Outputs() --"21",
    return { "Active" }
end

function TRAIN_SYSTEM:Inputs()
    return { "Engage"}
end

function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "Engage" then
        self.Active = value > 0.5
    end
end

function TRAIN_SYSTEM:Think()
    self.Train:SetNW2Bool("BellState",self.Active) --or self.Train.Electric.V1 > 0)
end

function TRAIN_SYSTEM:ClientThink(dT)
    local active = self.Train:GetNW2Bool("BellState",false)
    self.Active = self.Active

    -- Calculate pitch
    local absolutePitch  = 1 
    local absoluteVolume = 1 
    local pitch = 1
    -- Play horn sound
    self.Train:SetSoundState("bell",self.Active and absoluteVolume or 0,absolutePitch*pitch,nil,1.09)
    self.Active = active
end