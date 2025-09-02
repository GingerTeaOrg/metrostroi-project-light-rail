AddCSLuaFile( "cl_init.lua" )
include( "shared.lua" )
function ENT:KeyValue( key, value )
    self.VMF = self.VMF or {}
    self.VMF[ key ] = value
end

function ENT:Initialize()
    self:SetModel( "lilly/mplr/signals/ballises/ballise_essen.mdl" )
    self.PairedSignal = self:GetNW2Entity( "PairedSignal", self.VMF and self.VMF.PairedSignal )
end

function ENT:Think()
    if not IsValid( self.PairedSignal ) then return true end
    self.TransferImpulse = self.PairedSignal.Aspect
    return true
end