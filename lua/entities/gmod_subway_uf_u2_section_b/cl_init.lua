include("shared.lua")

--------------------------------------------------------------------------------
-- переписанная татра + немного приколов от томаса | переписал Lindy 
--------------------------------------------------------------------------------

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

for i=0,2 do
	for k=0,1 do
		ENT.ClientProps["door"..i.."x"..k.."a"] = {
			model = "models/81-740_leftdoor2.mdl",
			pos = GetDoorPosition(i,k,0),
			ang = Angle(0,90 +180*k,0)
		}
		ENT.ClientProps["door"..i.."x"..k.."b"] = {
			model = "models/81-740_leftdoor1.mdl",
			pos = GetDoorPosition(i,k,1),
			ang = Angle(0,90 +180*k,0)
		}
	end 
end

ENT.ClientProps["door4"] = {
	model = "models/interf/door_br.mdl",
	pos = Vector(-334.8,14.5,9),
	ang = Angle(0,-270,0.1)
}

ENT.ButtonMap["CabinDoorL"] = {
	pos = Vector(-334,16,-40),
	ang = Angle(0,-90,270),
    width = 642,
    height = 2000,
    scale = 0.1/2,
    buttons = {
        {ID = "CabinDoorLeft",x=0,y=0,w=642,h=2000, tooltip="Задняя дверь\nBack door", model = {
            var="CabinDoorLeft",sndid="door4",
            sndvol = 1, snd = function(_,val) return val == 1 and "door_cab_open" or val == 2 and "door_cab_roll" or val == 0 and "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
        }},
    }
}

ENT.ButtonMap["RearDoor1"] = {
    pos = Vector(240,40,40),
    ang = Angle(0,-90,90),
    width = 642,
    height = 2000,
    scale = 0.1/2,
    buttons = {
        {ID = "RearDoor",x=0,y=0,w=300,h=2000, tooltip="Открытие дверей левых 741\nLeft door open 741"},
    }
}

ENT.ButtonMap["RearDoor2"] = {
    pos = Vector(240,-30,40),
    ang = Angle(0,-90,90),
    width = 642,
    height = 2000,
    scale = 0.1/2,
    buttons = {
        {ID = "RearDoor2",x=0,y=0,w=300,h=2000, tooltip="Открытие дверей правых 741\nRight door open 741",},
    }
}

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

function ENT:Think()
	self.BaseClass.Think(self)

	local speed = self:GetNW2Int("Speed")/100
	local door_l = self:GetPackedBool("CabinDoorLeft")
    local door_4 = self:Animate("door4",door_l and (self.Door3 or 0.99) or 0,0,0.55, 64, 1)	
	self:SetSoundState("horn1",self:GetPackedBool("Horn",false) and 1 or 0,1)
	
	
	
	for i=0,3 do
		for k=0,1 do
			local n_l = "door"..i.."x"..k.."a"
			local n_r = "door"..i.."x"..k.."b"
			local rand = math.random(0.3,1.2)
			local door_cab_t =	self:Animate(n_l,self:GetPackedBool(40+(1-k)*4) and 1 or 0,0,1,rand,0) --			self:Animate(n_l,self:GetPackedBool(21+(1-k)*4) and 1 or 0,0,1,rand,0)
			local door_cab_n =	self:Animate(n_r,self:GetPackedBool(40+(1-k)*4) and 1 or 0,0,1,rand,0)--self:Animate(n_r,self:GetPackedBool(21+(1-k)*4) and 1 or 0,0,1,rand,0)
		end
	end
	
end

Metrostroi.GenerateClientProps()