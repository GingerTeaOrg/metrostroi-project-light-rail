AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/signals/ballises/ballise_essen.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self.TransferImpulse = "SPAD"
	self.PairedSignal = self:GetNW2String( "PairedSignal", self.VMF and self.VMF.PairedSignal or nil )
	self.BalliseName = self.PairedSignal and "ballise_" .. self.PairedSignal or self:GetNW2String( "BalliseName", self.VMF and self.VMF.BalliseName or nil )
	self.PairedSignal = MPLR.SignalEntitiesByName[ self.PairedSignal ]
end

function ENT:Think()
	self:NextThink( CurTime() )
	if not table.IsEmpty( MPLR.SignalEntitiesByName ) and type( self.PairedSignal ) == "string" then self.PairedSignal = MPLR.SignalEntitiesByName[ self.PairedSignal ] end
	if not IsValid( self.PairedSignal ) or not self.PairedSignal then
		self.PairedSignal = self:GetNW2String( "PairedSignal", self.VMF and self.VMF.PairedSignal or nil )
		self.PairedSignal = MPLR.SignalEntitiesByName[ self.PairedSignal ]
		print( MPLR.SignalEntitiesByName[ self.PairedSignal ] )
		return true
	end
	--print( IsValid( self.PairedSignal ) )
	return true
end

function ENT:SelectImpulseToTransfer()
	local aspect = self.PairedSignal.Aspect
	local speedRestriction = self.PairedSignal.SpeedRestriction
	if aspect == "H1" then
		self.TransferImpulse = "clear"
	elseif aspect == "H2" then
		self.TransferImpulse = "caution_" .. speedRestriction
	elseif aspect == "H0" or aspect == "Sh3d" then
		self.TransferImpulse = "SPAD"
	elseif aspect == "H3" then
		self.TransferImpulse = "caution_45"
	end
end