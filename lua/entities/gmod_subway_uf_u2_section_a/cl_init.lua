include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
--------------------------------------------------------------------------------
-- переписал Lindy2017 + немного скриптов томаса
--------------------------------------------------------------------------------

ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",		Vector(570,0,80), Angle(0,0,0), Color(216,161,92), hfov=80, vfov=80,farz=5144,brightness = 4}, --216,161,92
}



/*
for i=1,3 do
	ENT.ClientProps["route_number"..i] = {
		model = "models/metrostroi_train/81-722/digits/digit.mdl",
		pos = Vector(343.65,-6-(i-1)*0.5,-0.4),
		ang = Angle(90,180,0),
		color=Color(255,115,91),
	}
end

for i=1,3 do
	ENT.ClientProps["route_number1"..i] = {
		model = "models/metrostroi_train/81-722/digits/digit.mdl",
		pos = Vector(334,-20-(i-1)*3,56),
		ang = Angle(90,0,0),
		color=Color(255,115,91),
		scale = 8
	}
end

ENT.ButtonMap["RouteNumberSet"] = {
	pos = Vector(343.65,-5.3,-0.4),
	ang = Angle(0,-90,0),
	width = 30,
	height = 10,
	scale = 0.085,
	buttons = {
		{ID = "RouteNumber1Set",x=0,y=0,w=10,h=10, tooltip="Первая цифра"},
		{ID = "RouteNumber2Set",x=10,y=0,w=10,h=10, tooltip="Вторая цифра"},
		{ID = "RouteNumber3Set",x=20,y=0,w=10,h=10, tooltip="Третья цифра"},
	}
}*/




ENT.ClientProps["Microphone"] = {
	model = "models/lilly/uf/u2/microphone.mdl",
	pos = Vector(518,-3.5,63),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(518,-2.5,63),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(-9.7,0,-0.75),
	ang = Angle(0,0,0),
	scale = 1,
}



ENT.ButtonMap["CabinDoor"] = {
	pos = Vector(280.5,64,56.7),
	ang = Angle(0,0,90),
    width = 642,
    height = 2000,
    scale = 0.1/2,
    buttons = {
        {ID = "CabinDoorLeft",x=0,y=0,w=642,h=2000, tooltip="Дверь в кабину машиниста\nCabin door", model = {
            var="CabinDoorLeft",sndid="door_cab_l",
            sndvol = 1, snd = function(_,val) return val == 1 and "door_cab_open" or val == 2 and "door_cab_roll" or val == 0 and "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
        }},
    }
}

ENT.ButtonMap["Cab"] = {
    pos = Vector(450,0,42),
    ang = Angle(0,0,90),
    width = 642,
    height = 2000,
    scale = 1,
	
    buttons = {

    }
}

function ENT:Think()
	self.BaseClass.Think(self)
	self:SetSoundState("horn1",self:GetPackedBool("Bell",false) and 1 or 0,1)
	self:SetSoundState("horn2",self:GetPackedBool("Horn",false) and 1 or 0,1)
	self:SetSoundState("Bitte_Zuruecktreten",self:GetPackedBool("BitteZuruecktreten",false) and 1 or 0,1)
	self:SetSoundState("igbt7",self:GetPackedBool("igbt74",false) and 1 or 0,1)		
		self:SetLightPower(1,true,1)
	if IsValid(self.GlowingLights[1]) then
		self.GlowingLights[1]:SetEnableShadows(true)
		self.GlowingLights[1]:SetFarZ(5144)--5144
	end	
	
	
	local door_l = self:GetPackedBool("CabinDoorLeft")
    local door_r = self:GetPackedBool("CabinDoorRight")
    local door_cab_l = self:Animate("door_cab_l",door_l and (self.Door3 or 0.99) or 0,0,1, 4, 1)
    local door_cab_r = self:Animate("door_cab_r",door_r and (self.Door4 or 0.99) or 0,0,1, 4, 1)

	local speed = self:GetNW2Int("Speed")/100
	local limit = 80
	local nxt = 35
	
	if IsValid(self.ClientEnts["speedo1"])then
		self.ClientEnts["speedo1"]:SetSkin(speed%10)
	end
	
	if IsValid(self.ClientEnts["speedo2"])then
		self.ClientEnts["speedo2"]:SetSkin(speed/10)
	end
	
	if speed ~= -1 then
		for i=1,5 do
			if IsValid(self.ClientEnts["speedfact"..i])then
				--self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
				self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
				--self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
			if IsValid(self.ClientEnts["speedrek"..i])then
				--self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
				--self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
				self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
			if IsValid(self.ClientEnts["speeddop"..i])then
				self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
			--	self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
			--	self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
	
		end
	end
	
	--door anim
	for i=0,3 do
		for k=0,1 do
			local n_l = "door"..i.."x"..k.."a"
			local n_r = "door"..i.."x"..k.."b"
			local rand = math.random(0.3,1.2)
			local door_cab_t =	self:Animate(n_l,self:GetPackedBool(40+(1-k)*4) and 1 or 0,0,1,rand,0) --			self:Animate(n_l,self:GetPackedBool(21+(1-k)*4) and 1 or 0,0,1,rand,0)
			local door_cab_n =	self:Animate(n_r,self:GetPackedBool(40+(1-k)*4) and 1 or 0,0,1,rand,0)--self:Animate(n_r,self:GetPackedBool(21+(1-k)*4) and 1 or 0,0,1,rand,0)
		end
	end
	
    local rol10 = math.Clamp(speed/5,0,1)*(1-math.Clamp((speed-50)/8,0,1))
    local rol70 = math.Clamp((speed-50)/8,0,1)
    self:SetSoundState("rolling_10",rol10,1)
    self:SetSoundState("rolling_70",rol70,1)
	/*
	local rn =  123

	for i=1,3 do
		if IsValid(self.ClientEnts["route_number"..i]) then
			local number = math.floor(rn/10^(3-i)) % 10
			--local d1 = math.floor(num) % 10
			--local d2 = math.floor(num / 10) % 10
			--local d3 = math.floor(num / 100) % 10
			self.ClientEnts["route_number"..i]:SetSkin(number)
		end
	end
	*/
	if speed > limit+1 then
        RunConsoleCommand("say"," превышает скорость 80 км/ч на срусиче!")
	end
	
	end
	
function ENT:Draw()
    self.BaseClass.Draw(self)
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end
end