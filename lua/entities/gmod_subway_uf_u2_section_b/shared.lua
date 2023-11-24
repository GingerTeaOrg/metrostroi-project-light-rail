ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"

ENT.PrintNameTranslated       = "U2 Section B"
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
	--self:LoadSystem("Duewag_U2")
	--self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("IBIS_secondary")
	self:LoadSystem("Panel","U2_panel")
	self:LoadSystem("IBIS","IBIS_secondary")
end

function ENT:GetStandingArea()
	return Vector(-350, -20, 25), Vector(-60, 20, 25) -- TWEAK: NEEDS TESTING INGAME
end

function ENT:PassengerCapacity() return 81 end
ENT.MirrorCams = {Vector(-441, 72, 150), Angle(1, -180, 0), 15, Vector(-441, -72, 150), Angle(1, -180, 0), 15}
function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop=0.01,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["bell"] = {1100,1e9,Vector(-386,20,8),0.7}
	self.SoundNames["bell_in"] = {loop=0.01,"lilly/uf/u2/insidecab/Bell_start.mp3","lilly/uf/u2/insidecab/Bell_loop.mp3", "lilly/uf/u2/insidecab/Bell_end.mp3"}	
	self.SoundPositions["bell_in"] = {800,1e9,Vector(-386,20,50),1}
	
	self.SoundNames["Startup"] = {"lilly/uf/u2/startup.mp3"}	
	self.SoundPositions["Startup"] = {800,1e9,Vector(550,0,55),1}
	
	--self.SoundNames["DoorsCloseAlarm"] = {loop=0.014, "lilly/uf/u2/doorsareclosed_start.mp3", "lilly/uf/u2/Doorsareclosed_loop.mp3", "lilly/uf/u2/doorsareclosed_end.mp3"}	
	--self.SoundPositions["DoorsCloseAlarm"] = {800,1e9,Vector(550,0,55),1}
	
	self.SoundNames["horn"] = {loop=0.014,"lilly/uf/u2/U3_Hupe_Start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_Ende.mp3"}
	self.SoundPositions["horn"] = {1100,1e9,Vector(520,0,70),1}
	self.SoundNames["Keep Clear"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["Keep Clear"] = {1100,1e9,Vector(350,-30,113),1}
	
	self.SoundNames["Nag1"] = {"lilly/uf/u2/PAsystem/door_complaints/clear_the_doors.mp3"}
	self.SoundPositions["Nag1"] = {1100,1e9,Vector(350,-30,113),1}
	
	self.SoundNames["Door_open1"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open1"] = {400,1e9,Vector(360,40.5,120),1}
	
	self.SoundNames["Door_open2"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open2"] = {400,1e9,Vector(118,40.5,120),1}
	
	self.SoundNames["Door_close1"] = {"lilly/uf/u2/Door_close.mp3"}
	self.SoundPositions["Door_close1"] = {400,1e9,Vector(300,100,120),1}
	
	self.SoundNames["Deadman"] = {loop=0.5,"lilly/uf/common/deadman_start.mp3","lilly/uf/common/deadman_loop.mp3","lilly/uf/common/deadman_end.mp3"}
	self.SoundPositions["Deadman"] = {800,1e9,Vector(-401,-14,14),.7}
	
	self.SoundNames["DoorsCloseAlarm"] = {loop=0.01,"lilly/uf/u2/overhaul/doorsareclosed_loop_start.mp3","lilly/uf/u2/overhaul/doorsareclosed_loop.mp3","lilly/uf/u2/overhaul/doorsareclosed_loop_end.mp3"}
	self.SoundPositions["DoorsCloseAlarm"] = {400,1e9,Vector(412,0,53),0.8}
	
	
	self.SoundNames["rolling_10"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.mp3"}
	self.SoundNames["rolling_70"] = {loop=true,"lilly/uf/u2/rumb1.mp3"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
	
	self.SoundNames["rolling_motors_a"] = {loop=1,"lilly/uf/bogeys/u2/test/engine_loop_primary_start.mp3","lilly/uf/bogeys/u2/test/engine_loop_primary.mp3","lilly/uf/bogeys/u2/test/engine_loop_primary_end.mp3"}
	self.SoundPositions["rolling_motors_a"] = {480,1e12,Vector(0,0,0),1}
	
	self.SoundNames["rolling_motors_b"] = {loop=true,"lilly/uf/bogeys/u2/test/engine_loop_secondary.mp3"}
	self.SoundPositions["rolling_motors_b"] = {480,1e12,Vector(0,0,0),1}
	
	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.mp3"}
	self.SoundPositions["IBIS_beep"] = {1100,1e9,Vector(531,-23,84.9),1}
	
	self.SoundNames["IBIS_bootup"] = {"lilly/uf/IBIS/startup_chime.mp3"}
	self.SoundPositions["IBIS_bootup"] = {1100,1e9,Vector(412,-12,55),1}

	self.SoundNames["IBIS_error"] = {"lilly/uf/IBIS/error.mp3"}
	self.SoundPositions["IBIS_error"] = {1100,1e9,Vector(412,-12,55),1}
	
	self.SoundNames["Fan1"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan1"] = {1100,1e9,Vector(350,0,70),0.035}
	self.SoundNames["Fan2"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan2"] = {1100,1e9,Vector(250,0,70),0.035}
	self.SoundNames["Fan3"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan3"] = {1100,1e9,Vector(100,0,70),0.035}
	
	self.SoundNames["Switchgear1"] = {"lilly/uf/u2/Stuk01.mp3"}
	self.SoundPositions["Switchgear1"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear2"] = {"lilly/uf/u2/Stuk02.mp3"}
	self.SoundPositions["Switchgear2"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear3"] = {"lilly/uf/u2/Stuk03.mp3"}
	self.SoundPositions["Switchgear3"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear4"] = {"lilly/uf/u2/Stuk04.mp3"}
	self.SoundPositions["Switchgear4"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear5"] = {"lilly/uf/u2/Stuk05.mp3"}
	self.SoundPositions["Switchgear5"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear6"] = {"lilly/uf/u2/Stuk06.mp3"}
	self.SoundPositions["Switchgear6"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["Switchgear7"] = {"lilly/uf/u2/Stuk07.mp3"}
	self.SoundPositions["Switchgear7"] = {1100,1e9,Vector(250,0,200),1}
	
	self.SoundNames["button_on"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_on"] = {1100,1e9,Vector(405,36,55),1}
	
	self.SoundNames["button_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_off"] = {1100,1e9,Vector(405,36,55),1}
	
	self.SoundNames["Toggle_on"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["Toggle_on"] = {1100,1e9,Vector(405,36,55),1}

	self.SoundNames["Toggle_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["Toggle_off"] = {1100,1e9,Vector(405,36,55),1}
	
	self.SoundNames["Cruise"] = {"lilly/uf/u2/cruise/cruise_medium_start.mp3","lilly/uf/u2/cruise/cruise_medium.mp3","lilly/uf/u2/cruise/cruise_medium_stop.mp3"}
	self.SoundPositions["Cruise"] = {1100,1e9,Vector(300,0,100),1}
	
	self.SoundNames["rumb1"] = {"lilly/uf/u2/cruise/rumb1_start.mp3","lilly/uf/u2/cruise/rumb1.mp3","lilly/uf/u2/cruise/rumb1_stop.mp3"}
	self.SoundPositions["rumb1"] = {1100,1e9,Vector(300,0,100),1}
	
	self.SoundNames["Blinker"] = {"lilly/uf/u2/overhaul/u2_blinker_relay.mp3"}
	self.SoundPositions["Blinker"] = {10,1e9,Vector(400,-5,200),1}

	self.SoundNames["Blinker_off"] = {"lilly/uf/u2/U2_Blinkerrelais_auslauf.mp3"}
	self.SoundPositions["Blinker_off"] = {10,1e9,Vector(400,-5,200),1}

	self.SoundNames["Battery_breaker"] = {"lilly/uf/u2/u2_battery_breaker_on.mp3"}
	self.SoundPositions["Battery_breaker"] = {10, 1e9, Vector(-400, 5, 200), 1}

	self.SoundNames["Battery_breaker_off"] = {"lilly/uf/u2/u2_battery_breaker_off.mp3"}
	self.SoundPositions["Battery_breaker_off"] = {10, 1e9, Vector(-400, 5, 200), 1}
	
	self.SoundNames["MotorType1"] = {loop=5, "lilly/uf/bogeys/u2/test/engine_loop_primary_start.mp3", "lilly/uf/bogeys/u2/test/engine_loop_primary.mp3", "lilly/uf/bogeys/u2/test/engine_loop_primary_end.mp3"}
	self.SoundPositions["MotorType1"] = {1100,1e9,Vector(540,0,70),0.035}
	
end