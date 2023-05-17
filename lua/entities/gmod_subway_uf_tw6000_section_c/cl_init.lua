include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}


ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",		Vector(370,0,-40), Angle(0,0,90), Color(216,161,92), hfov=80, vfov=80,farz=5144,brightness = 4}, --216,161,92
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(-31.5,-7,10),
    ang = Angle(0,0,0),

}

ENT.ClientProps["reverser"] = {
    model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
    pos = Vector(-31.5,-9,10),
    ang = Angle(0,0,0),
}

ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/u2/cab/speedo.mdl",
    pos = Vector(360,0,120),
    ang = Angle(-8.7,0,0),
	scale = 10
}

ENT.ButtonMap["IBISScreen"] = {
    pos = Vector(385,-22,72),
    ang = Angle(0,-147,70),--(0,44.5,-47.9),
    width = 117,
    height = 29.9,
    scale = 0.0311,
}

ENT.ButtonMap["Rollsign"] = {
    pos = Vector(394,-12,121.8),
    ang = Angle(0,90,90),
    width = 560,
    height = 135,
    scale = 0.0625,
    buttons = {
        --{ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
        --{ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
    }
}

ENT.ButtonMap["Rollsign1"] = {
    pos = Vector(394,-22.8,121.8),
    ang = Angle(0,90,90),
    width = 158,
    height = 135,
    scale = 0.0625,
    buttons = {
        --{ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
        --{ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
    }
}





function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.IBIS = self:CreateRT("IBIS",512,128)

	self.ScrollModifier = 0
	self.ScrollModifier1 = 0
end



function ENT:Think()
	self.BaseClass.Think(self)
	self:Animate("reverser",self:GetNW2Float("ReverserAnimate"),0,100,50,9,false)
	if self:GetNW2Bool("ReverserInserted",false) == true then
    	self:ShowHide("reverser",true)
    elseif self:GetNW2Bool("ReverserInserted",false) == false then
    	self:ShowHide("reverser",false,0)
    end
end
	
function ENT:Draw()
    self.BaseClass.Draw(self)
end

function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture",self.IBIS)
    self:DrawOnPanel("IBISScreen",function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(0,65,11)
        surface.DrawTexturedRectRotated(59,16,116,25,0)
    end)


    local mat = Material("models/lilly/uf/pt/pt-destinations.png")
    self:DrawOnPanel("Rollsign",function(...)
        surface.SetDrawColor( color_white )
        surface.SetMaterial(mat)
        surface.DrawTexturedRectUV(0,0,560,137,0,self.ScrollModifier,1,self.ScrollModifier + 0.015)
    end)
	local mat1 = Material("models/lilly/uf/pt/pt-lines.png")
    self:DrawOnPanel("Rollsign",function(...)
        surface.SetDrawColor( color_white )
        surface.SetMaterial(mat1)
        surface.DrawTexturedRectUV(-180,-4,158,135,0,self.ScrollModifier1,1,self.ScrollModifier1 + 0.027)
    end)
end

