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

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["horn1"] = {loop=0.6,"subway_trains/common/pneumatic/horn/horn1_start.wav","subway_trains/common/pneumatic/horn/horn1_loop.wav", "subway_trains/common/pneumatic/horn/horn1_end.mp3"}
	self.SoundPositions["horn1"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["igbt7"]   = {"subway_trains/740/tisu1.wav",loop = true}
	self.SoundPositions["igbt7"] = {800,1e9,Vector(100,0,0),0.035}

	self.SoundNames["rolling_10"] = {loop=true,"subway_trains/717/rolling/10_rolling.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"subway_trains/717/rolling/70_rolling.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),0.3}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
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