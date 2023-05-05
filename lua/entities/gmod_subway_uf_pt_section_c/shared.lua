ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName 		= "Düwag Pt"
ENT.PrintNameTranslated       = "81-741test"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi: Project Light Rail"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false


function ENT:InitializeSystems()
	self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("Duewag_Pt")
end
