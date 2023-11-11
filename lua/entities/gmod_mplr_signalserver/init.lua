include("shared.lua")

function ENT:Initialize()
    local ent = ents.FindByClass("gmod_mplr_signalserver")
    if #ent > 1 then
        self:Remove()
    end
end
function ENT:Think()
    self.BaseClass.Think()
    UF.UpdateSignalBlocks()
end