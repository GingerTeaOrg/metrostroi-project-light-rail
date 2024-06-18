include("shared.lua")
function ENT:Initialize()
	if not self:GetNW2Bool("Invisible", false) then 
        self.Sign = ents.CreateClientProp("models/lilly/uf/signage/point_contact.mdl") 
    end
	if IsValid(self.Sign) then 
        self.Sign:SetPos(self:GetPos() + Vector(0, 0, 100))
        self.Sign:SetAngles(self:GetAngles() + Angle(0,90,0))
    end
end

function ENT:Draw() self.Sign:DrawModel() end

function ENT:Think() end
