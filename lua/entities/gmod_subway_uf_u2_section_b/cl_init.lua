include("shared.lua")



ENT.ClientProps = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ButtonMap = {}

local function GetDoorPosition(i,k,j)
	if j == 0 
	then return Vector(230.8 - 35.0*k     - 232.2*i,-67.5*(1-2*k),4.3)
	else return Vector(230.8 - 35.0*(1-k) - 232.2*i,-66*(1-2*k),4.25)
	end
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Bogeys = {}
	if not self.FrontBogey or not self.RearBogey or not self.MiddleBogey then
		self.FrontBogey = self:GetNW2Entity("FrontBogey")
		self.MiddleBogey = self:GetNW2Entity("MiddleBogey")
		self.RearBogey = self:GetNW2Entity("RearBogey")	
		table.insert(self.Bogeys,self.FrontBogey)
		table.insert(self.Bogeys,self.MiddleBogey)
		table.insert(self.Bogeys,self.RearBogey)
	end
end


ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_b.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlight_on.mdl",
	pos = Vector(-535,0,43),
	ang = Angle(0,180,0),
	scale = 1,
}

ENT.ClientProps["Door_fl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(7,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}

ENT.ClientProps["Door_fr"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(-918,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}
ENT.ClientProps["Door_br"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(-610,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}
ENT.ClientProps["Door_bl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(314,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}

ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(-525.3,19.5,82.5),
	ang = Angle(0,180,0),
	scale = 1,
}


function ENT:Think()
	self.BaseClass.Think(self)
	self:SetSoundState("horn1",self:GetPackedBool("Bell",false) and 1 or 0,1)
	local speed = self:GetNW2Int("Speed")/100
	
	self:SetSoundState("horn1",self:GetPackedBool("Horn",false) and 1 or 0,1)
	
	
	

	
end

--UF.GenerateClientProps()