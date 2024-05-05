include("shared.lua")
function ENT:Initialize()
	self.Sign = ents.CreateClientProp(self:GetNW2String("Model", self.BasePath .. "/" .. "speed_40" .. ".mdl"))
	self.Sign:SetPos(self:GetPos())
	self.Sign:SetAngles(self:GetAngles() - Angle(0, 90, 0))
	self.Sign:Spawn()
end

function ENT:OnRemove() 
    if IsValid(self.Sign) then 
        self.Sign:Remove() 
    end 
end
