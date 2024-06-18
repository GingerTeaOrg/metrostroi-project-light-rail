ENT.Type = "anim"
ENT.Base = "gmod_subway_uf_base"
ENT.PrintName = "Duewag B-Wagen 1973 Series Section B"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.SkinsType = "B1970"

ENT.DontAccelerateSimulation = true

function ENT:PassengerCapacity() return 81 end

function ENT:GetStandingArea()
	return Vector(350, -20, 25), Vector(60, 20, 25) -- TWEAK: NEEDS TESTING INGAME
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)

	self.SoundNames["bell"] = {loop = 0.01, "lilly/uf/u2/Bell_start.mp3", "lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}
	self.SoundPositions["bell"] = {1100, 1e9, Vector(386, -20, 8), 0.7}
	self.SoundNames["bell_in"] = {loop = 0.01, "lilly/uf/u2/insidecab/Bell_start.mp3", "lilly/uf/u2/insidecab/Bell_loop.mp3", "lilly/uf/u2/insidecab/Bell_end.mp3"}
	self.SoundPositions["bell_in"] = {800, 1e9, Vector(386, -20, 50), 1}

	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.mp3"}
	self.SoundPositions["IBIS_beep"] = {1100, 1e9, Vector(412, -12, 55), 5}

	self.SoundNames["IBIS_bootup"] = {"lilly/uf/IBIS/startup_chime.mp3"}
	self.SoundPositions["IBIS_bootup"] = {1100, 1e9, Vector(412, -12, 55), 1}

	self.SoundNames["IBIS_error"] = {"lilly/uf/IBIS/error.mp3"}
	self.SoundPositions["IBIS_error"] = {1100, 1e9, Vector(412, -12, 55), 1}

	self.SoundNames["button_on"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_on"] = {1100, 1e9, Vector(405, 36, 55), 1}

	self.SoundNames["button_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_off"] = {1100, 1e9, Vector(405, 36, 55), 1}

end

ENT.Cameras = {
	{Vector(400, -55, 90), Angle(0, -170, 0), "Train.UF_U2.OutTheWindowRight"},
	{Vector(400, 55, 90), Angle(0, 170, 0), "Train.UF_U2.OutTheWindowLeft"},
	{Vector(300, 6, 90), Angle(0, 180 + 5, 0), "Train.UF_U2.PassengerStanding"},
	{Vector(70.5 + 10, 6, 90), Angle(0, 0, 0), "Train.UF_U2.PassengerStanding2"},
	{Vector(490.5, 0, 100), Angle(0, 180, 0), "Train.Common.RouteNumber"},
	{Vector(388, -30, 80), Angle(0, -90, 0), "Train.UF_U2.RouteList"},
	{Vector(450, 0, 70), Angle(80, 0, 0), "Train.Common.CouplerCamera"},
	{Vector(350, 60, 5), Angle(10, -80, 0), "Train.UF_U2.Bogey"},
	{Vector(413, -11, 62), Angle(35, -46, 0), "Train.UF_U2.IBIS"},
	{Vector(413, -25, 58), Angle(10, 50, 0), "Train.UF_U2.IBISKey"},
	{Vector(250, 6, 200), Angle(0, 180, 0), "Train.UF_U2.Panto"}
}

local function GetDoorPosition(i, k)

	-- math.random
	return Vector(450, 0, 5)
end
ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i = 0, 3 do
	table.insert(ENT.LeftDoorPositions, GetDoorPosition(i, k))
	table.insert(ENT.RightDoorPositions, GetDoorPosition(i, k))
end

ENT.MirrorCams = {Vector(441, 72, 15), Angle(1, 180, 0), 15, Vector(441, -72, 15), Angle(1, 180, 0), 15}

function ENT:InitializeSystems()
	-- self:LoadSystem("DeadmanUF", "Duewag_Deadman")
	-- self:LoadSystem("IBIS")
	-- self:LoadSystem("Announcer", "uf_announcer")
	-- self:LoadSystem("Duewag_Battery")
	self:LoadSystem("Panel", "1973_panel")

	-- self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {Type = "B", Name = "B-Wagen Series 1973", WagType = 0, Manufacturer = "Duewag"}

ENT.AnnouncerPositions = {{Vector(293, 44, 102)}, {Vector(293, -44, 102)}}
