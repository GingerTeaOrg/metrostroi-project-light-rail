ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "Duewag U3"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.SkinsType = "U3"

ENT.DontAccelerateSimulation = true

ENT.SubwayTrain = {Type = "U3", Name = "U3", WagType = 0, Manufacturer = "Duewag"}

ENT.Spawner = {
	model = {"models/lilly/uf/u3/u3_a.mdl", "models/lilly/uf/u3/u3_b.mdl"},
	head = "gmod_subway_uf_u3_section_a",
	interim = "gmod_subway_uf_u3_section_a",
	Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "train"),
}


ENT.Cameras = {
	{Vector(400, -55, 90), Angle(0, -170, 0), "Train.UF_U3.OutTheWindowRight"},
	{Vector(400, 55, 90), Angle(0, 170, 0), "Train.UF_U3.OutTheWindowLeft"},
	{Vector(300, 6, 90), Angle(0, 180 + 5, 0), "Train.UF_U3.PassengerStanding"},
	{Vector(70.5 + 10, 6, 90), Angle(0, 0, 0), "Train.UF_U3.PassengerStanding2"},
	{Vector(490.5, 0, 100), Angle(0, 180, 0), "Train.Common.RouteNumber"},
	{Vector(388, -30, 80), Angle(0, -90, 0), "Train.UF_U3.RouteList"},
	{Vector(450, 0, 70), Angle(80, 0, 0), "Train.Common.CouplerCamera"},
	{Vector(350, 60, 5), Angle(10, -80, 0), "Train.UF_U3.Bogey"},
	{Vector(413, -11, 62), Angle(35, -46, 0), "Train.UF_U3.IBIS"},
	{Vector(413, -25, 58), Angle(10, 50, 0), "Train.UF_U3.IBISKey"},
	{Vector(250, 6, 200), Angle(0, 180, 0), "Train.UF_U3.Panto"}
}

ENT.MirrorCams = {Vector(441, 72, 15), Angle(1, 180, 0), 15, Vector(441, -72, 15), Angle(1, 180, 0), 15}

function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U3")
	self:LoadSystem("DeadmanUF", "Duewag_Deadman")
	self:LoadSystem("IBIS","COPILOT")
	self:LoadSystem("Announcer", "uf_announcer")
	self:LoadSystem("Duewag_Battery")
	self:LoadSystem("Panel", "U2_panel")

	-- self:LoadSystem("duewag_electric")
end