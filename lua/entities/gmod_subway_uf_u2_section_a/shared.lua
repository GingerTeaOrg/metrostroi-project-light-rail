ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName 		= "Duewag U2h"
ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "U-Bahn Frankfurt Metrostroi"

ENT.Spawnable       = true
ENT.AdminSpawnable  = true

ENT.SkinsType = "U2h"

ENT.DontAccelerateSimulation = true


function ENT:PassengerCapacity()
    return 81
end

function ENT:GetStandingArea()
    return Vector(350,-20,25),Vector(60,20,25) -- TWEAK: NEEDS TESTING INGAME
end



function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop=0.01,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["bell"] = {1100,1e9,Vector(386,-20,8),0.7}
	self.SoundNames["bell_in"] = {loop=0.01,"lilly/uf/u2/insidecab/Bell_start.wav","lilly/uf/u2/insidecab/Bell_loop.wav", "lilly/uf/u2/insidecab/Bell_end.wav"}	
	self.SoundPositions["bell_in"] = {800,1e9,Vector(386,-20,50),1}

	self.SoundNames["Startup"] = {"lilly/uf/u2/startup.mp3"}	
	self.SoundPositions["Startup"] = {800,1e9,Vector(550,0,55),1}

	--self.SoundNames["DoorsCloseAlarm"] = {loop=0.014, "lilly/uf/u2/doorsareclosed_start.mp3", "lilly/uf/u2/Doorsareclosed_loop.mp3", "lilly/uf/u2/doorsareclosed_end.mp3"}	
	--self.SoundPositions["DoorsCloseAlarm"] = {800,1e9,Vector(550,0,55),1}

	self.SoundNames["horn"] = {loop=0.014,"lilly/uf/u2/U3_Hupe_Start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_Ende.mp3"}
	self.SoundPositions["horn"] = {1100,1e9,Vector(520,0,70),1}
	self.SoundNames["WarningAnnouncement"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["WarningAnnouncement"] = {1100,1e9,Vector(350,-30,113),1}

	self.SoundNames["Nag1"] = {"lilly/uf/u2/PAsystem/door_complaints/clear_the_doors.mp3"}
	self.SoundPositions["Nag1"] = {1100,1e9,Vector(350,-30,113),1}
	
	self.SoundNames["Door_open1"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open1"] = {400,1e9,Vector(360,40.5,120),1}

	self.SoundNames["Door_open2"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open2"] = {400,1e9,Vector(118,40.5,120),1}

	self.SoundNames["Door_close1"] = {"lilly/uf/u2/Door_close.mp3"}
	self.SoundPositions["Door_close1"] = {400,1e9,Vector(300,100,120),1}

	self.SoundNames["Deadman"] = {loop=0.5,"lilly/uf/common/deadman_start.mp3","lilly/uf/common/deadman_loop.mp3","lilly/uf/common/deadman_end.mp3"}
	self.SoundPositions["Deadman"] = {800,1e9,Vector(401,14,14),.7}

	self.SoundNames["DoorsCloseAlarm"] = {loop=0.01,"lilly/uf/common/doorsareclosed_start.mp3","lilly/uf/common/doorsareclosed_loop.mp3","lilly/uf/common/doorsareclosed_end.mp3"}
	self.SoundPositions["DoorsCloseAlarm"] = {400,1e9,Vector(412,0,53),0.8}
	

	self.SoundNames["rolling_10"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"lilly/uf/u2/rumb1.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
	
	self.SoundNames["rolling_motors"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundPositions["rolling_motors"] = {480,1e12,Vector(0,0,0),.4}

	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.wav"}
	self.SoundPositions["IBIS_beep"] = {1100,1e9,Vector(531,-23,84.9),.4}

	self.SoundNames["IBIS_bootup"] = {"lilly/uf/IBIS/startup_chime.mp3"}
	self.SoundPositions["IBIS_bootup"] = {1100,1e9,Vector(412,-12,55),.7}

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
	self.SoundPositions["button_on"] = {1100,1e9,Vector(250,0,200),1}

	self.SoundNames["button_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_off"] = {1100,1e9,Vector(250,0,200),1}

	self.SoundNames["Toggle"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["Toggle"] = {1100,1e9,Vector(250,0,200),1}

	self.SoundNames["Cruise"] = {loop=0.5,"lilly/uf/u2/cruise/cruise_medium_start.mp3","lilly/uf/u2/cruise/cruise_medium.mp3","lilly/uf/u2/cruise/cruise_medium_stop.mp3"}
	self.SoundPositions["Cruise"] = {1100,1e9,Vector(300,0,70),1}

	self.SoundNames["Blinker"] = {"lilly/uf/u2/blinker.mp3"}
	self.SoundPositions["Blinker"] = {10,1e9,Vector(400,-5,200),1}

	self.SoundNames["MotorType1"] = {loop=5, "lilly/uf/bogeys/u2/test/engine_loop_primary_start.mp3", "lilly/uf/bogeys/u2/test/engine_loop_primary.mp3", "lilly/uf/bogeys/u2/test/engine_loop_primary_end.mp3"}
	self.SoundPositions["MotorType1"] = {1100,1e9,Vector(540,0,70),0.035}

end

ENT.AnnouncerPositions = {
    {Vector(420,-38.2 ,35),80,0.33},
    {Vector(-3,-60, 62),300,0.2},
    {Vector(-3,60 ,62),300,0.2},
}

local function GetDoorPosition(i,k)

	--math.random
    return Vector(450,0)
end

ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i=0,3 do
    table.insert(ENT.LeftDoorPositions,GetDoorPosition(i,k))
    table.insert(ENT.RightDoorPositions,GetDoorPosition(i,k))
end



ENT.Cameras = {
    {Vector(480.5+17,-40,110),Angle(0,-90,0),"Train.UF_U2.Destinations"},
    {Vector(407.5+10,6,100),Angle(0,180+5,0),"Train.UF_U2.PassengerStanding"},
	{Vector(70.5+10,6,100),Angle(0,0,0),"Train.UF_U2.PassengerStanding2"},
    {Vector(490.5+90,0,150),Angle(0,180,0),"Train.Common.RouteNumber"},
    {Vector(570,0,70),Angle(80,0,0),"Train.Common.CouplerCamera"},
}
ENT.MirrorCams = {
    {Vector(407.5+30,40,5),Angle(30,10,0),"Train.U2.Left"},
    {Vector(450+13,0,26),Angle(60,0,0),"Train.U2.Right"},
}


function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2")
	self:LoadSystem("Duewag_Deadman")
	--self:LoadSystem("IBIS")
	self:LoadSystem("Duewag_Battery")
	--self:LoadSystem("81_71_LastStation","destination")
	
	--self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {
	Type = "U2",
	Name = "U2h",
	WagType = 0,
	Manufacturer = "Duewag",
}






ENT.NumberRanges = {{303,364}}


ENT.Spawner = {
head = "gmod_subway_uf_u2_section_a",
    interim = "gmod_subway_uf_u2_section_a",
    Metrostroi.Skins.GetTable("Texture","Spawner.Texture",false,"train"),
	Metrostroi.Skins.GetTable("Texture","Spawner.Texture",false,"cab"),

}