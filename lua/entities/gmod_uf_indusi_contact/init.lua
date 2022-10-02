AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/lilly/uf/trackside/indusi_contact.mdl")
	self:SetSolid( SOLID_NONE )
end


function ENT:Think()
end
