include("shared.lua")

function ENT:Initialize()
end

function ENT:OnRemove()
end

--------------------------------------------------------------------------------
function ENT:Think()
    local coupled = self:GetNW2Bool("IsCoupledAnim",false)
    if coupled then
        self:SetPoseParameter("position",100)
    else
        self:SetPoseParameter("position",0)
    end
end