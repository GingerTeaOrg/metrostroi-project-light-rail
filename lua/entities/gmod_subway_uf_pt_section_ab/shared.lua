ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName 		= "Düwag Pt"
ENT.PrintNameTranslated       = "Duewag P8"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi: Project Light Rail"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

ENT.DontAccelerateSimulation = true

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
end

function ENT:InitializeSystems()
	self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("Duewag_Pt")
	
end

function ENT:ScrollDestinations(offset)
end

ENT.SubwayTrain = {
	Type = "P8",
	Name = "Pt",
	WagType = 0,
	Manufacturer = "Duewag",
}