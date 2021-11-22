ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"
ENT.PrintName 		= "Duewag U2h"
ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "U-Bahn Frankfurt Metrostroi"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false

ENT.DontAccelerateSimulation = false


function ENT:PassengerCapacity()
    return 162
end

function ENT:GetStandingArea()
    return Vector(-450,-30,-55),Vector(380,30,-55) -- TWEAK: NEEDS TESTING INGAME
end

local function GetDoorPosition(i,k)
    return Vector(359.0 - 35/2 - 229.5*i,-65*(1-2*k),7.5)
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop=0.01,"lilly/uf/u2/Bell_start.mp3","lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}	
	self.SoundPositions["bell"] = {1100,1e9,Vector(580,0,70),1}
	self.SoundNames["horn"] = {loop=0.014,"lilly/uf/u2/U3_Hupe_Start.mp3","lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_Ende.mp3"}
	self.SoundPositions["horn"] = {1100,1e9,Vector(580,0,70),1}
	self.SoundNames["WarningAnnouncement"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["WarningAnnouncement"] = {1100,1e9,Vector(550,0,300),1}
	self.SoundNames["idle"]   = {"lilly/uf/u2/Moto/Duewag_idle.mp3",loop = 1}
	self.SoundPositions["idle"] = {800,1e9,Vector(100,0,0),0.035}
	
	self.SoundNames["Door_open"] = {"lilly/uf/u2/Door_open.mp3"}
	self.SoundPositions["Door_open"] = {800,1e9,Vector(300,14,14),1}

	self.SoundNames["Door_close"] = {"lilly/uf/u2/Door_close.mp3"}
	self.SoundPositions["Door_close"] = {800,1e9,Vector(300,14,14),1}
	self.SoundNames["Deadman"] = {loop=0.5,"lilly/uf/common/deadman_start.mp3","lilly/uf/common/deadman_loop.mp3","lilly/uf/common/deadman_end.mp3"}
	self.SoundPositions["Deadman"] = {800,1e9,Vector(550,14,14),1}
	

	self.SoundNames["rolling_10"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"lilly/uf/u2/rumb1.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
	
	self.SoundNames["rolling_motors"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundPositions["rolling_motors"] = {480,1e12,Vector(0,0,0),.4}

	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.wav"}
	self.SoundPositions["IBIS_beep"] = {1100,1e9,Vector(531,-23,84.9),.4}

	self.SoundNames["IBIS_bootup"] = {"lilly/uf/IBIS/startup_chime.mp3"}
	self.SoundPositions["IBIS_bootup"] = {1100,1e9,Vector(531,-23,84.9),.4}

	self.SoundNames["Fan1"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan1"] = {1100,1e9,Vector(550,0,70),0.035}
	self.SoundNames["Fan2"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan2"] = {1100,1e9,Vector(250,0,70),0.035}
	self.SoundNames["Fan3"] = {loop=10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions ["Fan3"] = {1100,1e9,Vector(300,0,70),0.035}

end

ENT.AnnouncerPositions = {
    {Vector(420,-38.2 ,35),80,0.33},
    {Vector(-3,-60, 62),300,0.2},
    {Vector(-3,60 ,62),300,0.2},
}

ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i=0,3 do
    table.insert(ENT.LeftDoorPositions,GetDoorPosition(i,1))
    table.insert(ENT.RightDoorPositions,GetDoorPosition(i,0))
end



ENT.Cameras = {
    {Vector(480.5+17,-40,110),Angle(0,-90,0),"Train.UF_U2.Destinations"},
    {Vector(407.5+17,32,3),Angle(0,180-7,0),"Train.720.CameraPPZ"},
    {Vector(407.5+17,32,-19.5),Angle(0,180-7,0),"Train.720.CameraPV"},
    {Vector(407.5+10,6,100),Angle(0,180+5,0),"Train.UF_U2.PassengerStanding"},
    {Vector(407.5+50,-14,-15),Angle(90-46,0,0),"Train.720.CameraVityaz"},
    {Vector(407.5+40,-35,-30),Angle(60,90,0),"Train.720.CameraKRMH"},
    {Vector(380,35,-5),Angle(0,60,0),"Train.720.CameraPVZ"},
    {Vector(490.5+90,0,150),Angle(0,180,0),"Train.Common.RouteNumber"},
    {Vector(570,0,70),Angle(80,0,0),"Train.Common.CouplerCamera"},
}


function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2")
	self:LoadSystem("Duewag_Deadman")
	self:LoadSystem("IBIS")
	self:LoadSystem("Duewag_Battery")
	--self:LoadSystem("81_71_LastStation","destination")
	--self:LoadSystem("uf_bell")
	--self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {
	Type = "U2",
	Name = "U2h",
	WagType = 0,
	Manufacturer = "Duewag",
}

ENT.MirrorCams = {
    Vector(441,72,60),Angle(1,180,0),15,
    Vector(441,-72,60),Angle(1,180,0),15,
}




--ENT.NumberRanges = {{807,1000},{2001,2468}}
ENT.Spawner = {
head = "gmod_subway_uf_u2_section_a",
    interim = "gmod_subway_uf_u2_section_a",
    Metrostroi.Skins.GetTable("Texture","Texture",false,"train"),

}