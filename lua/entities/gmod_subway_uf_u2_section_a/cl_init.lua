include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}
--------------------------------------------------------------------------------
-- переписал Lindy2017 + немного скриптов томаса
--------------------------------------------------------------------------------

ENT.Lights = {
	-- Headlight glow
	[1] = { "headlights",		Vector(580,0,50), Angle(0,0,180), Color(169,130,88), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
	[2] = { "taillights",		Vector(560,0,50), Angle(0,0,0), Color(169,130,88), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
	[3] = { "blinkerfrontl",		Vector(569,0,60), Angle(0,0,0), Color(169,130,88), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=false},
	[3] = { "blinkerfrontr",		Vector(560,0,60), Angle(0,0,0), Color(169,130,88), brightness = 3 ,fov = 90, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=false},
}









ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(533,-19,82),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}


ENT.ClientProps["brake_cylinder"] = {
    model = "models/metrostroi_train/Equipment/arrow_nm.mdl",
    pos = Vector(526.535736,-22.815704,-3.113149+5.35),
    ang = Angle(-62.299999,-33.400002,0.000000),
    hideseat = 0.2,
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/u2/cab/kombihebel.mdl",
    pos = Vector(527.70,35.5,77),
    ang = Angle(0,90,0),
    hideseat = 0.2,
}

ENT.ButtonMap["Cab"] = {
    pos = Vector(540,50,80),
    ang = Angle(0,-90,0),
    width = 690,
    height = 300,
    scale = 0.1,
	
    buttons = {
		
	{ID = "ThrottleUp", x=146, y=143.5, radius=15, tooltip = "Combined Throttle", model = {
			model = "models/lilly/uf/u2/cab/kombihebel.mdl", z=0, ang=0,
			var="main",speed=1, vmin=0, vmax=1,
			sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),

    }},
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
	
	
	self.LeftMirror = self:CreateRT("LeftMirror",128,256)
    self.RightMirror = self:CreateRT("RightMirror",128,256)
end




function ENT:Think()
	self.BaseClass.Think(self)

	
	
	self:Animate("Throttle",self:GetPackedRatio("ThrottleState"),1, 3,4,false)
	
	
	local BitteZuruecktreten = 0
	
	
	if self.Duewag_U2.BitteZuruecktreten == 1 then
        
       self:PlayOnce("BitteZuruecktreten","cabin",1,1)
		self:SetNW2Int("BitteZuruecktreten", 0)
	end
	
	
	
	
	
		self:SetLightPower(1,true,1)
	if IsValid(self.GlowingLights[1]) then
		self.GlowingLights[1]:SetEnableShadows(true)
		self.GlowingLights[1]:SetFarZ(5144)--5144
	end	
	
	
	local HL1 = self:Animate("Headlights",self:GetPackedBool("Headlights1") and 1 or 0,0,1,6,false)
    local RL = self:Animate("RedLights_a",self:GetPackedBool("RedLights") and 1 or 0,0,1,6,false)
    self:ShowHideSmooth("Headlights_1",HL1)
    
    local bright = HL1*0.5
    --self:SetLightPower(30,bright > 0,bright)
    --self:SetLightPower(31,bright > 0,bright)

    self:ShowHideSmooth("taillights",RL)
 --   self:SetLightPower(8,RL > 0,RL)
  --  self:SetLightPower(9,RL > 0,RL)

    local headlight = HL1*0.6
    self:SetLightPower(1,headlight>0,headlight)
    self:SetLightPower(2,self:GetPackedBool("taillights"),RL)

    if IsValid(self.GlowingLights[1]) then
        if self:GetPackedRatio("Headlight") < 0.5 and self.GlowingLights[1]:GetFarZ() ~= 3144 then
            self.GlowingLights[1]:SetFarZ(3144)
        end
        if self:GetPackedRatio("Headlight") > 0.5 and self.GlowingLights[1]:GetFarZ() ~= 5144 then
            self.GlowingLights[1]:SetFarZ(5144)
        end
    end

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	local speed = self:GetNW2Int("Speed")/100

	local nxt = 35

	

	
	
	local rollingi = math.min(1,self.TunnelCoeff+math.Clamp((self.StreetCoeff-0.82)/0.3,0,1))
    local rollings = math.max(self.TunnelCoeff*1,self.StreetCoeff)
	
	
	local rol5 = math.Clamp(speed/1,0,1)*(1-math.Clamp((speed-3)/8,0,1))
    local rol10 = math.Clamp(speed/12,0,1)*(1-math.Clamp((speed-25)/8,0,1))
    local rol40p = Lerp((speed-25)/12,0.6,1)
    local rol40 = math.Clamp((speed-23)/8,0,1)*(1-math.Clamp((speed-55)/8,0,1))
    local rol40p = Lerp((speed-23)/50,0.6,1)
    local rol70 = math.Clamp((speed-50)/8,0,1)*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp(0.8+(speed-65)/25*0.2,0.8,1.2)
    local rol80 = math.Clamp((speed-70)/5,0,1)
    local rol80p = Lerp(0.8+(speed-72)/15*0.2,0.8,1.2)
	
	
	
	--self:SetSoundState("rolling_10",math.min(1,rollingi*(1-rollings)+rollings*0.8)*rol5,1)
    --self:SetSoundState("rolling_10",rollingi*rol10,1)
    --self:SetSoundState("rolling_40",rollingi*rol40,rol40p)
    --self:SetSoundState("rolling_70",rollingi*rol70,rol70p)
    --self:SetSoundState("rolling_80",rollingi*rol80,rol80p)

	--local rol_motors = math.Clamp((speed-20)/40,0,1)
    --self:SetSoundState("rolling_motors",math.max(rollingi,rollings*0.3)*rol_motors,speed/56)

    local rol10 = math.Clamp(speed/15,0,1)*(1-math.Clamp((speed-18)/35,0,1))
    local rol10p = Lerp((speed-15)/14,0.6,0.78)
    local rol40 = math.Clamp((speed-18)/35,0,1)*(1-math.Clamp((speed-55)/40,0,1))
    local rol40p = Lerp((speed-15)/66,0.6,1.3)
    local rol70 = math.Clamp((speed-55)/20,0,1)--*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp((speed-55)/27,0.78,1.15)
	
	
end