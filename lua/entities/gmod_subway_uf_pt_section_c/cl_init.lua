include("shared.lua")

--------------------------------------------------------------------------------
-- переписанная татра + немного приколов от томаса | переписал Lindy 
--------------------------------------------------------------------------------

ENT.ClientProps = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ButtonMapMPLR = {}

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

UF.GenerateClientProps()