include("shared.lua")
function ENT:Think()
    local train = self:GetNW2Entity("TrainEntity")
    self:Draw()
end


function ENT:ClientThink()
    
end

function ENT:Draw()
    self:DrawModel()
end