ENT.Type = "anim"
ENT.Base = "gmod_subway_base"
ENT.PrintName = "Duewag B-Wagen 1973 Series"
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
	return Vector(450, 0,5)
end
ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
for i = 0, 3 do
	table.insert(ENT.LeftDoorPositions, GetDoorPosition(i, k))
	table.insert(ENT.RightDoorPositions, GetDoorPosition(i, k))
end

ENT.MirrorCams = {Vector(441, 72, 15), Angle(1, 180, 0), 15, Vector(441, -72, 15), Angle(1, 180, 0), 15}

function ENT:InitializeSystems()
	--self:LoadSystem("Duewag_U2")
	self:LoadSystem("DeadmanUF", "Duewag_Deadman")
	self:LoadSystem("IBIS")
	self:LoadSystem("Announcer", "uf_announcer")
	self:LoadSystem("Duewag_Battery")
	self:LoadSystem("Panel", "U2_panel")

	-- self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {Type = "B", Name = "B-Wagen Series 1970", WagType = 0, Manufacturer = "Duewag"}

ENT.AnnouncerPositions = {{Vector(293, 44, 102)}, {Vector(293, -44, 102)}}
function ENT:DeltaTime()
	ENT.PrevTime = ENT.PrevTime or RealTime()
	ENT.DeltaTime = (RealTime() - ENT.PrevTime)
	ENT.PrevTime = RealTime()
	return ENT.DeltaTime
end

ENT.NumberRanges = {{5001, 5011}{5012, 5016},{5031, 5032},{5012, 5016},{5141, 5145}}

ENT.Spawner = {
	model = {"models/lilly/mplr/ruhrbahn/b_1970/section-a.mdl"},
	head = "gm_subway_uf_bwagen1970_section_a",
	interim = "gm_subway_uf_bwagen1970_section_a",
	Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "train"),
	Metrostroi.Skins.GetTable("Texture", "Spawner.Texture", false, "cab"),

	--[[spawnfunc = function(i,tbls,tblt)
        local WagNum = tbls.WagNum
        if WagNum > 1 then
			WagNum = 1
			return WagNum
			return "gmod_subway_uf_u2_section_a"
		else
			return "gmod_subway_uf_u2_section_a"
		end
    end,]]

	{
		"IBISData",
		"IBIS Line Index",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.IBISLines or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.IBISLines and val == 1 then
				ent:SetNW2Int("IBIS:Lines", 1)
			else
				ent:SetNW2Int("IBIS:Lines", val)
			end
		end
	},
	{
		"IBISData2",
		"IBIS Route Index",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.IBISRoutes or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.IBISLRoutes and val == 1 then
				ent:SetNW2Int("IBIS:Routes", 1)
			else
				ent:SetNW2Int("IBIS:Routes", val)
			end
		end
	},
	{
		"IBISData4",
		"IBIS Destinations",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.IBISDestinations or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.IBISDestinations and val == 1 then
				ent:SetNW2Int("IBIS:Destinations", 1)
			else
				ent:SetNW2Int("IBIS:Destinations", val)
			end
		end
	},
	{
		"IBISData5",
		"IBIS Service Announcements",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.SpecialAnnouncementsIBIS or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.SpecialAnnouncementsIBIS and val == 1 then
				ent:SetNW2Int("IBIS:ServiceA", 1)
			else
				ent:SetNW2Int("IBIS:ServiceA", val)
			end
		end
	},
	{
		"IBISData6",
		"IBIS Announcements Script",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.IBISAnnouncementScript or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.IBISAnnouncementScript and val == 1 then
				ent:SetNW2Int("IBIS:AnnouncementScript", 1)
			else
				ent:SetNW2Int("IBIS:AnnouncementScript", val)
			end
		end
	},
	{
		"IBISData7",
		"IBIS Station Announcements",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.IBISAnnouncementMetadata or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.IBISAnnouncementMetadata and val == 1 then
				ent:SetNW2Int("IBIS:Announcements", 1)
			else
				ent:SetNW2Int("IBIS:Announcements", val)
			end
		end
	},
	{
		"Signs",
		"Rollsign Texture",
		"List",
		function(ent)
			local Announcer = {}
			for k, v in pairs(UF.BRollsigns or {}) do Announcer[k] = v.name end
			return Announcer
		end,
		nil,
		function(ent, val, rot, i, wagnum, rclk)
			if UF.U2Rollsigns and val == 1 then
				ent:SetNW2Int("Rollsign", 1)
			else
				ent:SetNW2Int("Rollsign", val)
			end
		end
	}
}