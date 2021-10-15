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
	self.SoundPositions["bell"] = {1100,1e9,Vector(100,0,0),1}
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
	self.SoundNames["Deadman"] = {"lilly/uf/common/Duwag_Totmann.wav"}
	self.SoundPositions["Deadman"] = {800,1e9,Vector(300,14,14),1}
	

	self.SoundNames["rolling_10"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundNames["rolling_70"] = {loop=true,"lilly/uf/u2/rumb1.wav"}
	self.SoundPositions["rolling_10"] = {1200,1e9,Vector(0,0,0),1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]
	
	self.SoundNames["rolling_motors"] = {loop=true,"lilly/uf/u2/Moto/engine_loop_start.wav"}
	self.SoundPositions["rolling_motors"] = {480,1e12,Vector(0,0,0),.4}
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
    Vector(441,-72,200),Angle(1,180,0),15,
}


--ENT.NumberRanges = {{807,1000},{2001,2468}}
ENT.Spawner = {
head = "gmod_subway_uf_u2_section_a",
    interim = "gmod_subway_uf_u2_section_b",
    Metrostroi.Skins.GetTable("Texture","Texture",false,"train"),

}