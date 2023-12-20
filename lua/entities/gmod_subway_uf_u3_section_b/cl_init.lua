include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}

ENT.ClientProps["Door_fr1"] = {model = "models/lilly/uf/u3/door_1.mdl", pos = Vector(0, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_fr2"] = {model = "models/lilly/uf/u3/door_2.mdl", pos = Vector(0, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_rr1"] = {model = "models/lilly/uf/u3/door_1.mdl", pos = Vector(200.5, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_rr2"] = {model = "models/lilly/uf/u3/door_2.mdl", pos = Vector(200.5, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_fl1"] = {model = "models/lilly/uf/u3/door_1.mdl", pos = Vector(-659.5, 0, 0), ang = Angle(0, 0, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_fl2"] = {model = "models/lilly/uf/u3/door_2.mdl", pos = Vector(-659.5, 0, 0), ang = Angle(0, 0, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_rl1"] = {model = "models/lilly/uf/u3/door_1.mdl", pos = Vector(-458.5, 0, 0), ang = Angle(0, 0, 0), scale = 1, nohide = true}

ENT.ClientProps["Door_rl2"] = {model = "models/lilly/uf/u3/door_2.mdl", pos = Vector(-458.5, 0, 0), ang = Angle(0, 0, 0), scale = 1, nohide = true}


ENT.ClientProps["mirror_r"] = {model = "models/lilly/uf/u3/mirror_r.mdl", pos = Vector(0, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}
ENT.ClientProps["mirror_l"] = {model = "models/lilly/uf/u3/mirror_l.mdl", pos = Vector(0, 0, 0), ang = Angle(0, 180, 0), scale = 1, nohide = true}



ENT.ButtonMapMPLR["Rollsign"] = {
	pos = Vector(-470, 28, 121),
	ang = Angle(0, -90, 90),
	width = 890,
	height = 160,
	scale = 0.0625,
	buttons = {
		-- {ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
		-- {ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
	}
}

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	
	self.SectionB = self:GetNWEntity("U2b")
	
	self.IBIS = self:CreateRT("IBIS", 512, 128)
	
	self.Locked = 0
	
	self.EngineSNDConfig = {}
	
	self.SoundNames = {}
	
	self.MotorPowerSound = 0
	self.CabLight = 0
	
	self.SpeedoAnim = 0
	self.VoltAnim = 0
	self.AmpAnim = 0
	
	self.Microphone = false
	self.BlinkerTicked = false
	self.DoorOpenSoundPlayed = false
	self.DoorCloseSoundPlayed = false
	self.DoorsOpen = false
	
	self.CamshaftMadeSound = false
	self.AnnouncementTriggered = false
	self.ThrottleLastEngaged = 0
	
	self.IBISBootCompleted = false
	self.IBISBeep = false
	
	self.BatteryBreakerOnSoundPlayed = false
	self.BatteryBreakerOffSoundPlayed = false
	
	self.BlinkerPrevOn = false
	
	self.WarningAnnouncement = false
	
	self.CabWindowL = 0
	self.CabWindowR = 0
	
	-- self.LeftMirror = self:CreateRT("LeftMirror",512,256)
	-- self.RightMirror = self:CreateRT("RightMirror",128,256)
	
	self.ScrollModifier = 0
	self.ScrollMoment = 0
	
	self.PrevTime = 0
	self.DeltaTime = 0
	self.MotorPowerSound = 0
	
	self.Nags = {"Nag1", "Nag2", "Nag3"}
	self.Speed = 0
	
	self.BatterySwitch = 0.5
	self:ShowHide("reverser", true)
	self:ShowHide("reverser", false)
	self:UpdateWagonNumber()
	-- self.SectionB:UpdateWagonNumber()
	
	self.Rollsign = Material(self:GetNW2String("Rollsign","models/lilly/uf/u2/rollsigns/frankfurt_stock.png"))
end

function ENT:Think()
    self.BaseClass.Think(self)
    self.ParentTrain = self:GetNWEntity("U2a")
    if not IsValid(self.ParentTrain) then return end -- we don't do anything without the A section

    self.Coupled = self.ParentTrain:GetNW2Bool("BIsCoupled", false) == true

    self.BatteryOn = self.ParentTrain:GetNW2Bool("BatteryOn")

    self:Animations()
    self:SoundRoutine()

end

function ENT:SoundRoutine()
    if self:GetNW2Bool("Bell", false) == true then
        self:SetSoundState("bell", 1, 1)
        self:SetSoundState("bell_in", 1, 1)
    else
        self:SetSoundState("bell", 0, 1)
        self:SetSoundState("bell_in", 0, 1)
    end

    if self:GetNW2Bool("WarningAnnouncement") == true then
        self:PlayOnce("WarningAnnouncement", "cabin", 1, 1)

    end
    self:SetSoundState("Deadman", self.ParentTrain:GetNW2Bool(
                           "DeadmanAlarmSound", false) and 1 or 0, 1)
end

function ENT:DrawPost()
	--[[self.RTMaterialUF:SetTexture("$basetexture", self.IBIS)
	self:DrawOnPanel("IBISScreen", function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(0, 65, 11)
		surface.DrawTexturedRectRotated(74, 41, 144, 75, 0)
	end)]]
	
	local mat = self.Rollsign
	self:DrawOnPanel("Rollsign", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0, 0, 890, 160, 0, self.ScrollModifier, 1, self.ScrollModifier + 0.015)
	end)
end

function ENT:Animations()

    self:Animate("Throttle", self:GetNW2Float("ThrottleAnimB", 0), -45, 45, 50)

    self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"), 0, 80) / 100 * 1.5
    self:Animate("Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0)

    self:ShowHide("RetroEquipment",
                  self.ParentTrain:GetNW2Bool("RetroMode", false))

    self:ShowHide("reverser",
                  self.ParentTrain:GetNW2Bool("ReverserInsertedB", false))

    self:Animate("reverser", self:GetNW2Float("ReverserAnimate", 0.5), 0, 100,
                 50)

    self.CabWindowL = self:GetNW2Float("CabWindowL", 0)
    self.CabWindowR = self:GetNW2Float("CabWindowR", 0)
    self:Animate("window_cab_r", self:GetNW2Float("CabWindowR", 0), 0, 100, 50,
                 9, false)
    self:Animate("window_cab_l", self:GetNW2Float("CabWindowL", 0), 0, 100, 50,
                 9, false)

    if self.ParentTrain:GetNW2Bool("Headlights", false) == true and
        self:GetNW2Bool("Headlights", false) == true then
        self:ShowHide("headlights_on", true)
    else
        self:ShowHide("headlights_on", false)
    end


    if self:GetPackedBool("FlickBatterySwitchOn", false) == true then
        self.BatterySwitch = 1
    elseif self:GetPackedBool("FlickBatterySwitchOff", false) == true then
        self.BatterySwitch = 0
    else
        self.BatterySwitch = 0.5
    end

    self:Animate("Mirror", self:GetNW2Float("Mirror", 0), 0, 100, 17, 1, 0)
    self:Animate("Mirror_vintage", self:GetNW2Float("Mirror", 0), 0, 100, 17, 1,
                 0)

    self:ShowHide("RetroEquipment",
                  self.ParentTrain:GetNW2Bool("RetroMode", false))

    self:Animate("Door_fr2", self.ParentTrain:GetNW2Float("Door12b"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_fr1", self.ParentTrain:GetNW2Float("Door12b"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_rr2", self.ParentTrain:GetNW2Float("Door34b"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_rr1", self.ParentTrain:GetNW2Float("Door34b"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_fl2", self.ParentTrain:GetNW2Float("Door78a"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_fl1", self.ParentTrain:GetNW2Float("Door78a"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_rl2", self.ParentTrain:GetNW2Float("Door56a"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_rl1", self.ParentTrain:GetNW2Float("Door56a"), 0, 100,
                 50, 0, 0)
    if self.ParentTrain:GetNW2Bool("RetroMode", false) == false then
        self:ShowHide("Mirror_vintage", false)
        self:ShowHide("Mirror", true)
    elseif self.ParentTrain:GetNW2Bool("RetroMode", false) == true then
        self:ShowHide("Mirror", false)
        self:ShowHide("Mirror_vintage", true)
    end

end