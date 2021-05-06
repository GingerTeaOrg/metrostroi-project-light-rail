ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName = "Bombardier U5-25"
ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "U-Bahn Frankfurt Metrostroi"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["horn1"] = {loop=0.12,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["horn1"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["horn2"] = {loop=0.5,"lilly/uf/u2/U3_Hupe_start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_end.mp3"}
	self.SoundPositions["horn2"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["BitteZuruecktreten"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["BitteZuruecktreten"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["igbt7"]   = {"lilly/uf/u2/Moto/Duewag_idle.mp3",loop = true}
	self.SoundPositions["igbt7"] = {800,1e9,Vector(100,0,0),0.035}

	self.SoundNames["rolling_10"] = {loop=true,"subway_trains/717/rolling/10_rolling.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"subway_trains/717/rolling/70_rolling.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),0.3}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
end

function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2_Systems")
	--self:LoadSystem("ALSCoil")
end

ENT.SubwayTrain = {
	Type = "U5",
	Name = "U5-25",
	WagType = 0,
	Manufacturer = "Duewag",
}

local Settings = {
		Train = 1,
		WagNum = 1,
		AutoCouple = false,
}
ENT.Ssttings = Settings


--ENT.NumberRanges = {{807,1000},{2001,2468}}
ENT.Spawner = {
head = "gmod_subway_uf_u5_section_a",
    interim = "gmod_subway_uf_u5_section_a",
    Metrostroi.Skins.GetTable("Texture","Texture",false,"train"),

}