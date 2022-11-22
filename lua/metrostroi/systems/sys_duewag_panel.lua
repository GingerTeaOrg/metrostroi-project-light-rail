--------------------------------------------------------------------------------
-- 81-722 controller panel
--------------------------------------------------------------------------------
-- Copyright (C) 2013-2018 Metrostroi Team & FoxWorks Aerospace s.r.o.
-- Contains proprietary code. See license.txt for additional information.
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("U2_Panel")
TRAIN_SYSTEM.DontAccelerateSimulation = false
function TRAIN_SYSTEM:Initialize()
    
    --Освещение
    self.Train:LoadSystem("CabinLight","Relay","Switch",{maxvalue=2,defaultvalue=0,bass=true})
    self.Train:LoadSystem("PanelLight","Relay","Switch",{bass=true})

    self.Train:LoadSystem("PB","Relay","Switch",{bass=true})
    self.Controller = 0
    self.TargetController = 0


    self.BattOn = 0
    self.BattOff = 0
    self.SOSDL = 0

    self.RS = 0
    self.AVS = 0
    self.LRU = 0

    self.EmergencyDriveL = 0
    self.EmergencyBrakeTPlusL = 0

    self.DoorLeftL = 0
    self.DoorRightL = 0
    self.MFDUPowerL = 0

    self.CabLights = 0
    self.PanelLights = 0

    self.Headlights1 = 0
    self.Headlights2 = 0
    self.RedLights = 0

    self.EmergencyLights = 0
    self.MainLights = 0

    self.V4 = 0

    self.UPOPower = 0
    self.AnnouncerPlaying = 0

    self.SOSD = 0

    self.PassSchemePowerL = 0
    self.PassSchemePowerR = 0

    self.DoorsW = 0
    self.BrW = 0
    self.GRP = 0

    self.RC = 0
    self.VPR1 = 0
    self.VPR2 = 0

    self.BARSPower = 0
    self.ARSPower = 0
    self.ALSPower = 0
end

function TRAIN_SYSTEM:Inputs()
    return { "KVUp", "KVDown", "KV1", "KV2", "KV4", "KV5", "KV6", "KV7", }
end

function TRAIN_SYSTEM:Outputs()
    return { "Controller","BattOn","BattOff","SOSDL","RS","AVS","LRU","EmergencyDriveL","EmergencyBrakeTPlusL","DoorLeftL","DoorRightL","MFDUPowerL","CabLights","PanelLights","Headlights1","Headlights2","RedLights","EmergencyLights","MainLights", "V4","SOSD","UPOPower","AnnouncerPlaying", "PassSchemePowerL", "PassSchemePowerR","DoorsW","BrW","GRP","RC","VPR1","VPR2","BARSPower","ARSPower","ALSPower"}
end
--if not TURBOSTROI then return end
function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "KVUp" and value > 0 and self.Controller < 2 then
        self.TargetController = self.TargetController + 1
        if self.TargetController <= -2 then
            self.TargetController = -1
        end
    end
    if name == "KVUp" and value == 0 and self.TargetController == 2 then
        self.TargetController = self.TargetController - 1
    end
    if name == "KVDown" and value > 0 and self.TargetController > -2 then
        self.TargetController = self.TargetController - 1
    end
    if name == "KVDown" and value == 0 and self.TargetController == -2 then
        self.TargetController = self.TargetController + 1
    end
    if name == "KV1"  then
        self.KV1Pressed = value > 0
        if value then
            self.TargetController = 1
        end
    end
    if name == "KV2" then
        if value > 0 then
            self.TargetController = 2
        elseif self.TargetController == 2 then
            self.TargetController = 1
        end
    end
    if name == "KV4" and value > 0 then
        self.TargetController = 0
    end
    if name == "KV5" then
        self.KV5Pressed = value > 0
        if value then
            self.TargetController = -1
        end
    end
    if name == "KV6" then
        if value > 0 then
            self.TargetController = -2
        elseif self.TargetController == -2 then
            self.TargetController = -1
        end
    end
    if name == "KV7" then
        self.TargetController = -3
    end
    self.ControllerTimer = CurTime()-1
end
function TRAIN_SYSTEM:Think()
    if self.Controller ~= self.TargetController and not self.ControllerTimer then
        self.ControllerTimer = CurTime()-1
    end
    if self.KV1Pressed then
        if self.Train.BUKP.PowerPrecent > 25 then
            self.TargetController = 0
        else
            self.TargetController = 1
        end
    end
    if self.KV5Pressed then
        if self.Train.BUKP.PowerPrecent < -25 then
            self.TargetController = 0
        else
            self.TargetController = -1
        end
    end
    if self.ControllerTimer and CurTime() - self.ControllerTimer > 0.1 and self.Controller ~= self.TargetController then
        local previousPosition = self.Controller
        self.ControllerTimer = CurTime()
        if self.TargetController > self.Controller then
            self.Controller = self.Controller + 1
        else
            self.Controller = self.Controller - 1
        end
        self.Train:PlayOnce("KU_"..previousPosition.."_"..self.Controller, "cabin",0.5)
    end

    if self.Controller == self.TargetController then
        self.ControllerTimer = nil
    end
end