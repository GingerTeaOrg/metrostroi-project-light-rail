AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
    local ent = ents.FindByClass( "gmod_mplr_signalserver" )
    if #ent > 1 then
        SafeRemoveEntity( self )
        return
    end

    self:SetModel( self.Model or "" )
    if not self.Model then --if we haven't been given a proper model, just hide awoobwoobwoobwoob (V)(;,,;)(V)
        self:SetRenderMode( RENDERMODE_TRANSALPHA )
        self:SetColor( Color( 0, 0, 0, 0 ) )
    end
end

function ENT:Think()
    self.BaseClass.Think()
    UF.UpdateSignalBlockOccupation()
    self:NextThink( CurTime() + 0.25 )
end