ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName = "Duewag U2h"
ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "U-Bahn Frankfurt Metrostroi"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false




function ENT:PassengerCapacity()
    return 162
end

function ENT:GetStandingArea()
    return Vector(-450,-30,-55),Vector(380,30,-55) -- TWEAK: NEEDS TESTING INGAME
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop=0.1,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["horn1"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["horn2"] = {loop=0.5,"lilly/uf/u2/U3_Hupe_start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_end.mp3"}
	self.SoundPositions["horn2"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["BitteZuruecktreten"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["BitteZuruecktreten"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["igbt7"]   = {"lilly/uf/u2/Moto/Duewag_idle.mp3",loop = 1}
	self.SoundPositions["igbt7"] = {800,1e9,Vector(100,0,0),0.035}
	
	self.SoundNames["Door_open"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open"] = {800,1e9,Vector(300,14,14),1}

	self.SoundNames["Door_close"] = {"lilly/uf/u2/Door_close.mp3"}
	self.SoundPositions["Door_close"] = {800,1e9,Vector(300,14,14),1}

	self.SoundNames["rolling_10"] = {loop=true,"subway_trains/717/rolling/10_rolling.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"subway_trains/717/rolling/70_rolling.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),0.3}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
end




function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2_Systems")
	--self:LoadSystem("uf_bell")
	--self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {
	Type = "U2",
	Name = "U2h",
	WagType = 0,
	Manufacturer = "Duewag",
}




--ENT.NumberRanges = {{807,1000},{2001,2468}}
ENT.Spawner = {
head = "gmod_subway_uf_u2_section_a",
    interim = "gmod_subway_uf_u2_section_b",
    Metrostroi.Skins.GetTable("Texture","Texture",false,"train"),

}