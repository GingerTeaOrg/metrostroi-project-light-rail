AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/ron/gm_metro_u6/station/daisy_contact.mdl")
	self:SetSolid( SOLID_NONE )
end


function ENT:Think()
end
