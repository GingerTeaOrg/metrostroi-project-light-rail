include("shared.lua")

function ENT:Initialize()
end

function ENT:OnRemove()
end

--------------------------------------------------------------------------------
function ENT:Think()
self:Animate
end

function ENT:Animate()
    
    if self:GetPackedBool("IsCoupledAnim",false) == true then
        self:SetPoseParameter("position",100)
    else
        self:SetPoseParameter("position",0)
    end

end
