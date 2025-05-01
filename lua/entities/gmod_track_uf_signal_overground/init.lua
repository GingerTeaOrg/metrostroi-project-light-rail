AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString"uf-signal"
util.AddNetworkString"uf-signal-state"
function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/signals/trafficlight/trafficlight_pole.mdl" )
	--self:PhysicsInit( SOLID_VPHYSICS )
	self.BlockMode = self.VMF and self.VMF.Blockmode > 0 or false
	self.Lenses = self:ParseLenses( self.VMF and next( self.VMF ) and self.VMF.Lenses or "F0_F4_F1" )
end

function ENT:ParseLenses( str )
	if not str or #str < 2 then return end
	local result = {}
	-- Use pattern matching to split by space, dash, or underscore
	for token in string.gmatch( str, "[^%s%-%_]+" ) do
		result[ string.lower( token ) ] = true
	end

	if #result < 1 then print( "Signal:", self.SignalName, "has not found any lenses to spawn." ) end
	return result
end

function ENT:Think()
	if self.BlockMode then
		self:BlockModeSignalling()
	else
		self:OnSightSignalling()
	end

	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:OnSightSignalling()
end

function ENT:BlockModeSignalling()
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end