include("shared.lua")

function ENT:Initialize()

end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:Draw()
    self:DrawModel()
    local coupled = self:GetNW2Bool("IsCoupledAnim",false)
    self:SetPoseParameter("position", coupled and 100 or 0)
    self:InvalidateBoneCache()
end