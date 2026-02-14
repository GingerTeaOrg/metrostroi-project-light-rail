ENT.Type = "anim"
ENT.Base = "gmod_subway_mplr_base"
ENT.PrintName = "Duewag Pt"
ENT.PrintNameTranslated = "Duewag P8"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = true
function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds( self )
end

function ENT:InitializeSystems()
	--self:LoadSystem( "Duewag_Deadman" )
end

function ENT:ScrollDestinations( offset )
end

ENT.SubwayTrain = {
	Type = "P8",
	Name = "Pt",
	WagType = 0,
	Manufacturer = "Duewag"
}