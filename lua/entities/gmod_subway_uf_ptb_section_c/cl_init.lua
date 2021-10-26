include("shared.lua")



ENT.ClientProps = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ButtonMap = {}





function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Bogeys = {}
end






function ENT:Think()
	self.BaseClass.Think(self)
	self:SetSoundState("horn1",self:GetPackedBool("Bell",false) and 1 or 0,1)
	local speed = self:GetNW2Int("Speed")/100
	
	self:SetSoundState("horn1",self:GetPackedBool("Horn",false) and 1 or 0,1)
	
	
	

	
end

--UF.GenerateClientProps()