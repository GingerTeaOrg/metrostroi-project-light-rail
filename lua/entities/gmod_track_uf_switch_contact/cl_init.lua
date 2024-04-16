function ENT:Initialize()
    if not self:GetNW2Bool("Invisible",false) then
        self.Sign = ents.CreateClientProp("models/lilly/uf/signage/point_contact.mdl")
    end
    if IsValid(self.Sign) then
        self.Sign:SetPos(self:GetPos() + Vector(0,-10,10)
    end
end