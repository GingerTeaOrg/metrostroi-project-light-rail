ENT.Type = "anim"
ENT.Base = "gmod_subway_mplr_base"
ENT.PrintName = "AI train"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail (Utilities)"
ENT.Spawnable = false
ENT.AdminSpawnable = true
function ENT:PassengerCapacity()
	return self.CustomPassengerCapacity or 50
end

function ENT:GetStandingArea()
	return Vector( -450, -30, -45 ), Vector( 380, 30, -45 )
end

function ENT:InitializeSystems()
	--self:LoadSystem("ALS_ARS")
end