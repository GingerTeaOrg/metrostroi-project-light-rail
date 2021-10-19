include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}


ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",        Vector(542,50,43), Angle(0,0,0), Color(216,161,92), fov=60,farz=420,brightness = 2.5, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
    [2] = { "headlight",        Vector(542,-50,43), Angle(0,0,0), Color(216,161,92), fov=60,farz=420,brightness = 2.5, texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,headlight=true},
    [101] = { "light",        Vector(542,50,43), Angle(0,0,0), Color(216,161,92), fov=160,farz=450,brightness = 1, texture = "models/metrostroi_train/equipment/headlight",shadows = 1},
    [201] = { "light",        Vector(542,-50,43), Angle(0,0,0), Color(216,161,92), fov=160,farz=450,brightness = 1, texture = "models/metrostroi_train/equipment/headlight",shadows = 1},
    [3] = { "light",        Vector(545,0,600), Angle(0,0,0), Color(216,161,92), fov=40,farz=450,brightness = 3, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
    [4] = { "headlight",        Vector(544,40,40), Angle(-20,0,0), Color(255,0,0), fov=160 ,brightness = 0.3, farz=450,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[5] = { "dynamiclight",		Vector(569,0,60), Angle(0,0,0), Color(255,132,0), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=false},
	[6] = { "dynamiclight",		Vector(560,0,60), Angle(0,0,0), Color(255,132,0), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=false},
}






ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlight_on.mdl",
	pos = Vector(541.35,0,43),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fr"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(924,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}
ENT.ClientProps["Door_br"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(615,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}
ENT.ClientProps["Door_bl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(-309,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(533.3,-19.5,82.5),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Pantograph"] = {
	model = "models/lilly/uf/common/pantograph.mdl",
	pos = Vector(43,0,155),
	ang = Angle(0,0,0),
	scale = 1,
}



ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(-0.5,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(527.70,32.5,77),
    ang = Angle(0,90,0),
    hideseat = 0.2,
}

ENT.ButtonMap["Cab"] = {
    pos = Vector(540,50,78.5),
    ang = Angle(0,-90,0),
    width = 690,
    height = 300,
    scale = 0.1,
	
    buttons = {
		
	{ID = "ThrottleUp", x=150, y=110.5, radius=20, tooltip = "Combined Throttle Up", model = {
			model = "models/lilly/uf/u2/cab/kombihebel.mdl", z=0, ang=0,
			var="main",speed=1, vmin=0, vmax=1,
			sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
    },
    {ID = "ThrottleDown", x=150, y=110.5, radius=20, tooltip = "Combined Throttle Down", model = {
        model = "models/lilly/uf/u2/cab/kombihebel.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
}
}

ENT.ButtonMap["LastStation"] = {
    pos = Vector(544,-25,145),
    ang = Angle(0,90,90),
    width = 840,
    height = 205,
    scale = 0.0625,
    buttons = {
        {ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
        {ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
    }
}




	
function ENT:Draw()
    self.BaseClass.Draw(self)
end




function ENT:OnPlay(soundid,location,range,pitch)
    if location == "stop" then
        if IsValid(self.Sounds[soundid]) then
            self.Sounds[soundid]:Pause()
            self.Sounds[soundid]:SetTime(0)
        end
        return
	end
	if self.Duewag_Deadman.AlarmSound ~= 0 then
		self.SetSoundState("Deadman",1,1,1)
	end
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end
	
	
	
	self.DoorL1Open = 0
	self.DoorL2Open = 0
	self.DoorR1Open = 0
	self.DoorR2Open = 0
	
	
	self.Ventilation = 0
	
	
	self.LeftMirror = self:CreateRT("LeftMirror",512,256)
    self.RightMirror = self:CreateRT("RightMirror",128,256)
end




function ENT:Think()
	self.BaseClass.Think(self)

	
	self:Animate("Throttle",self:GetNWInt("ThrottleState", 0),-45,45,1,True)
	
	

	
	
	if self:GetNW2Bool("BitteZuruecktreten") == true then

        self:SetNW2Bool("BitteZuruecktreten", false)
        self:PlayOnce("BitteZuruecktreten","cabin",1,1)
	    self:SetNW2Bool("BitteZuruecktreten", false)
	end
	
	
	
	local HL1 = self:Animate("Headlights1",self:GetPackedBool("Headlights1") and 1 or 0,0,1,6,false)
    local HL2 = self:Animate("Headlights2",self:GetPackedBool("Headlights2") and 1 or 0,0,1,6,false)
	local headlight = HL1*0.6+HL2*0.4
    self:SetLightPower(1,headlight>0,headlight)
    if IsValid(self.GlowingLights[1]) then
        if self:GetPackedRatio("Headlight") < 0.5 and self.GlowingLights[1]:GetFarZ() ~= 3144 then
            self.GlowingLights[1]:SetFarZ(3144)
        end
        if self:GetPackedRatio("Headlight") > 0.5 and self.GlowingLights[1]:GetFarZ() ~= 5144 then
            self.GlowingLights[1]:SetFarZ(5144)
        end
    end

	
	

    --self:SetLightPower(30,bright > 0,bright)
    --self:SetLightPower(31,bright > 0,bright)

 
 --   self:SetLightPower(8,RL > 0,RL)
  --  self:SetLightPower(9,RL > 0,RL)



	self:SetLightPower(1,true)
    self:SetLightPower(2,true)
    self:SetLightPower(101,true)
    self:SetLightPower(201,true)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	local speed = self:GetNW2Int("Speed")/100

	local nxt = 35

	

	
	
	local rollingi = math.min(1,self.TunnelCoeff+math.Clamp((self.StreetCoeff-0.82)/0.3,0,1))
    local rollings = math.max(self.TunnelCoeff*1,self.StreetCoeff)
	
	
	local rol5 = math.Clamp(speed/1,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol10 = math.Clamp(speed/12,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol40p = Lerp((speed)/12,0.6,1)
    local rol40 = math.Clamp((speed)/8,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol40p = Lerp((speed)/50,0.6,1)
    local rol70 = math.Clamp((speed)/8,0,1)*(1-math.Clamp((speed)/5,0,1))
    local rol70p = Lerp(0.8+(speed)/25*0.2,0.8,1.2)
    local rol80 = math.Clamp((speed)/5,0,1)
    local rol80p = Lerp(0.8+(speed)/15*0.2,0.8,1.2)
	
	
	
	--self:SetSoundState("rolling_10",math.min(1,rollingi*(1-rollings)+rollings*0.8)*rol5,1)
    --self:SetSoundState("rolling_10",rollingi*rol10,1)
    --self:SetSoundState("rolling_40",rollingi*rol40,rol40p)
    --self:SetSoundState("rolling_70",rollingi*rol70,rol70p)
    --self:SetSoundState("rolling_80",rollingi*rol80,rol80p)

	local rol_motors = math.Clamp((speed-20)/40,0,1)
    self:SetSoundState("rolling_motors",math.max(rollingi,rollings*0.3)*rol_motors,speed/56)

    local rol10 = math.Clamp(speed/15,0,1)*(1-math.Clamp((speed)/35,0,1))
    local rol10p = Lerp((speed)/14,0.6,0.78)
    local rol40 = math.Clamp((speed-18)/35,0,1)*(1-math.Clamp((speed)/40,0,1))
    local rol40p = Lerp((speed)/66,0.6,1.3)
    local rol70 = math.Clamp((speed-55)/20,0,1)--*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp((speed)/27,0.78,1.15)
	
	
end