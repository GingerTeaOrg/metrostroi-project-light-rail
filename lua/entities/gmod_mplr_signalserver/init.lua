AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    local ent = ents.FindByClass("gmod_mplr_signalserver")
    if #ent > 1 then
        SafeRemoveEntity(self)
    end
end
function ENT:Think()
    self.BaseClass.Think()
    UF.UpdateSignalBlocks()

    UF.UpdateSignalBlockOccupation()
    self:NextThink(CurTime() + 0.25)
end