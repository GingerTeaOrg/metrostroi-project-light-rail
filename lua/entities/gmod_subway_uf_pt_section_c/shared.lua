ENT.Type = "anim"
ENT.Base = "gmod_subway_uf_base"
ENT.PrintName = "Duewag Pt"
ENT.PrintNameTranslated = "Duewag Pt"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = true
function ENT:InitializeSystems()
	self:LoadSystem( "Duewag_Deadman" )
	self:LoadSystem( "CoreSys", "Duewag_Pt" )
end

ENT.NumberRanges = { { 700, 780 } }
ENT.SubwayTrain = {
	Type = "P8",
	Name = "Pt",
	WagType = 1,
	Manufacturer = "Duewag"
}

ENT.DoorNumberRight = 6
ENT.DoorNumberLeft = 6
ENT.Bidirectional = true
ENT.Spawner = {
	model = { "models/lilly/uf/pt/section-c.mdl", "models/lilly/uf/pt/section-ab.mdl" },
	interim = "gmod_subway_uf_pt_section_ab"
}