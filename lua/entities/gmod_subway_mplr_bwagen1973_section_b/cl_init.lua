include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}

ENT.ClientProps["int"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/int-essen.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}

ENT.ClientProps["seats"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/seats-essen.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	nohide = true
}
ENT.ClientProps["bumper"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/bumper.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	nohide = true
}
ENT.ClientProps["floor"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/floor.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	nohide = true
}

ENT.ClientProps["throttle"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/throttle.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	nohide = true
}
ENT.ClientProps["reverser"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/reverser.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	nohide = true
}


ENT.ClientProps["door_rr1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door_rr2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),

}

ENT.ClientProps["door_fr1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(-184.25, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door_fr2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(-184.25, 0, 0),
	ang = Angle(0, 180, 0),

}

ENT.ClientProps["door_fl1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(-409, 0, 0),
	ang = Angle(0, 0, 0),

}
ENT.ClientProps["door_fl2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(-409, 0, 0),
	ang = Angle(0, 0, 0),

}

ENT.ClientProps["door_rl1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(-224.5, 0, 0),
	ang = Angle(0, 0, 0),

}
ENT.ClientProps["door_rl2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(-224.5, 0, 0),
	ang = Angle(0, 0, 0),

}

ENT.ClientProps["door1_r"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_r.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door1_l"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_l.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["foldingstep_small_r"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_r.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_small_l"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_l.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_rr"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_fr"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(-184, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_fl"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(-408, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_rl"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(-224, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(-184.25, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray3"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(-224.5, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray4"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(-408, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}

function ENT:Initialize()
    self.BaseClass.Initialize(self)

	self.SectionB = self:GetNWEntity("SectionB")

    self.IBIS = self:CreateRT("IBIS", 512, 128)

    self.SpeedoAnim = 0
	self.VoltAnim = 0
	self.AmpAnim = 0

    self.KeyInserted = false 
    self.KeyTurned = false 

    self.CabWindowL = 0
	self.CabWindowR = 0
end

function ENT:Think()
	self.BaseClass.Think(self)
    --self:Animations()
    self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()

    self.BatteryOn = self:GetNW2Bool("BatteryOn", false)
	self:Animate("door1_r", 1, 0, 100, 100, 10, 0)
	self:Animate("door_hr1", 1, 0, 100, 100, 10, 0)


end

function ENT:Animations()
    self.Speed = self:GetNW2Int("Speed")
    self.KeyInserted = self:GetNW2Bool("MainKeyInserted",false)
    self.KeyTurned = self:GetNW2Bool("MainKeyTurned",false)
    self:Animate("Mirror_L", self:GetNW2Float("Mirror_L", 0), 0, 100, 17, 1, 0)
    self:Animate("Mirror_R", self:GetNW2Float("Mirror_R", 0), 0, 100, 17, 1, 0)
    self:Animate("drivers_door", self:GetNW2Float("DriversDoorState", 0), 0, 100, 1, 1, 0)
    self:Animate("reverser", self:GetNW2Float("ReverserAnimate"), 0, 100, 50, 9, false)
    self.CabWindowL = self:GetNW2Float("CabWindowL", 0)
	self.CabWindowR = self:GetNW2Float("CabWindowR", 0)
	self:Animate("window_cab_r", self:GetNW2Float("CabWindowR", 0), 0, 100, 50, 9, false)
	self:Animate("window_cab_l", self:GetNW2Float("CabWindowL", 0), 0, 100, 50, 9, false)

    self:ShowHide("Mainkey", self.KeyInserted)
    self:Animate("MainKey", self.KeyTurned == true and 0 or 1, 0, 100, 800, 0, 0)

    self:Animate("door1_r", .5, 0, 100, 100, 10, 0)
	self:Animate("Door_fr1", Door12a, 0, 100, 100, 10, 0)

	self:Animate("Door_rr2", Door34a, 0, 100, 100, 10, 0)
	self:Animate("Door_rr1", Door34a, 0, 100, 100, 10, 0)

	self:Animate("Door_fl2", Door78b, 0, 100, 100, 10, 0)
	self:Animate("Door_fl1", Door78b, 0, 100, 100, 10, 0)

	self:Animate("Door_rl2", Door56b, 0, 100, 100, 10, 0)
	self:Animate("Door_rl1", Door56b, 0, 100, 100, 10, 0)

    self:ShowHide("headlights_on", self:GetNW2Bool("Headlights",false), 0)

    self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"), 0, 100) / 100
	self:Animate("Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0)

    self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound", false) == true and 1 or 0, 1)

    self.VoltAnim = self:GetNW2Float("BatteryCharge", 0) / 45
    self:Animate("Voltage", self.VoltAnim, 0, 100, 1, 0, false)
	self.AmpAnim = self:GetNW2Float("Amps", 0) / 0.5 * 100
	self:Animate("Amps", self.AmpAnim, 0, 100, 1, 0, false)
end


function ENT:Draw() self.BaseClass.Draw(self) end

function ENT:DrawPost()
	--[[self.RTMaterialUF:SetTexture("$basetexture", self.IBIS)
	self:DrawOnPanel("IBISScreen", function(...)
		surface.SetMaterial(self.RTMaterial)
		surface.SetDrawColor(0, 65, 11)
		surface.DrawTexturedRectRotated(59, 16, 116, 25, 0)
	end)

	local mat = Material("models/lilly/uf/u2/rollsigns/frankfurt_stock.png")
	self:DrawOnPanel("Rollsign", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0, 0, 780, 160, 0, self.ScrollModifier, 1, self.ScrollModifier + 0.015)
	end)]]
end

function ENT:OnPlay(soundid, location, range, pitch)
	if location == "stop" then
		if IsValid(self.Sounds[soundid]) then
			self.Sounds[soundid]:Pause()
			self.Sounds[soundid]:SetTime(0)
		end
		return
	end
end