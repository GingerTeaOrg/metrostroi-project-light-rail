AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/lilly/uf/trackside/lumina_display.mdl")
end


function ENT:Think()
	
end

function ENT:TrackMyTrain()
	
end
