ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"

ENT.PrintNameTranslated       = "81-741test"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi (trains)"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false
ENT.SkinsType = "U2hb"

ENT.DontAccelerateSimulation = true
function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2")
	self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("IBIS")
	self:LoadSystem("Duewag_Battery")
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop=0.1,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["bell"] = {1100,1e9,Vector(550,-30,0),1}
	self.SoundNames["horn2"] = {loop=0.5,"lilly/uf/u2/U3_Hupe_start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_end.mp3"}
	self.SoundPositions["horn2"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["BitteZuruecktreten"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["BitteZuruecktreten"] = {1100,1e9,Vector(100,0,0),1}
	self.SoundNames["idle"]   = {"lilly/uf/u2/Moto/Duewag_idle.mp3",loop = 1}
	self.SoundPositions["idle"] = {800,1e9,Vector(100,0,0),0.035}
	
	self.SoundNames["Door_open"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open"] = {800,1e9,Vector(300,14,14),1}

	self.SoundNames["Door_close"] = {"lilly/uf/u2/Door_close.mp3"}
	self.SoundPositions["Door_close"] = {800,1e9,Vector(300,14,14),1}
	self.SoundNames["Deadman"] = {loop=0.5,"lilly/uf/common/deadman_start.mp3","lilly/uf/common/deadman_loop.mp3","lilly/uf/common/deadman_end.mp3"}
	self.SoundPositions["Deadman"] = {800,1e9,Vector(-550,14,14),1}
	

	self.SoundNames["rolling_10"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"lilly/uf/u2/rumb1.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
	
	self.SoundNames["rolling_motors"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundPositions["rolling_motors"] = {480,1e12,Vector(0,0,0),.4}


	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.wav"}
	self.SoundPositions["IBIS_beep"] = {1100,1e9,Vector(-531,-23,84.9),.4}

	self.SoundNames["Fan1"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan1"] = {1100,1e9,Vector(-550,0,70),0.035}
	self.SoundNames["Fan2"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan2"] = {1100,1e9,Vector(-250,0,70),0.035}
	self.SoundNames["Fan3"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan3"] = {1100,1e9,Vector(-300,0,70),0.035}
end