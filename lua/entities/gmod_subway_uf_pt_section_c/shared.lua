ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName 		= "Düwag Pt"
ENT.PrintNameTranslated       = "Düwag Pt"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi: Project Light Rail"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false

ENT.DontAccelerateSimulation = true

function ENT:InitializeSystems()
	self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("Duewag_Pt")
end
ENT.NumberRanges = {{700,780}}
ENT.SubwayTrain = {
    Type = "P8",
    Name = "Pt",
    WagType = 1,
    Manufacturer = "Düwag",
}

ENT.Spawner = {
    model = {
        "models/lilly/uf/pt/section-c.mdl",
        "models/lilly/uf/pt/section-ab.mdl"
    },
    interim = "gmod_subway_uf_pt_section_c",
}