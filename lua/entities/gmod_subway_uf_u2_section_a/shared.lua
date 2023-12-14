ENT.Type = "anim"
ENT.Base = "gmod_subway_uf_base"
ENT.PrintName = "Duewag U2h"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"

ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.SkinsType = "U2h"

ENT.DontAccelerateSimulation = true

function ENT:PassengerCapacity() return 50 end

function ENT:GetStandingArea()
	return Vector(350, -20, 25), Vector(60, 20, 25) -- TWEAK: NEEDS TESTING INGAME
end
if CLIENT then
	ENT.DecalPos = Vector(0, 0, 0)
	ENT.CarNumPos = Vector(0, 0, 0)
end
function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds(self)
	self.SoundNames["bell"] = {loop = 0.01, "lilly/uf/u2/Bell_start.mp3", "lilly/uf/u2/Bell_loop.mp3", "lilly/uf/u2/Bell_end.mp3"}
	self.SoundPositions["bell"] = {1100, 1e9, Vector(386, -20, 8), 0.7}
	self.SoundNames["bell_in"] = {loop = 0.01, "lilly/uf/u2/insidecab/Bell_start.mp3", "lilly/uf/u2/insidecab/Bell_loop.mp3", "lilly/uf/u2/insidecab/Bell_end.mp3"}
	self.SoundPositions["bell_in"] = {800, 1e9, Vector(386, -20, 50), 1}

	self.SoundNames["Startup"] = {"lilly/uf/u2/startup.mp3"}
	self.SoundPositions["Startup"] = {800, 1e9, Vector(550, 0, 55), 1}

	-- self.SoundNames["DoorsCloseAlarm"] = {loop=0.014, "lilly/uf/u2/doorsareclosed_start.mp3", "lilly/uf/u2/Doorsareclosed_loop.mp3", "lilly/uf/u2/doorsareclosed_end.mp3"}	
	-- self.SoundPositions["DoorsCloseAlarm"] = {800,1e9,Vector(550,0,55),1}

	self.SoundNames["horn"] = {loop = 0.014, "lilly/uf/u2/U3_Hupe_Start.mp3", "lilly/uf/u2/U3_Hupe_Loop.mp3", "lilly/uf/u2/U3_Hupe_Ende.mp3"}
	self.SoundPositions["horn"] = {1100, 1e9, Vector(520, 0, 70), 1}
	self.SoundNames["Keep Clear"] = {"lilly/uf/u2/Bitte_Zuruecktreten_out.mp3"}
	self.SoundPositions["Keep Clear"] = {1100, 1e9, Vector(350, -30, 113), 1}

	self.SoundNames["Nag1"] = {"lilly/uf/u2/PAsystem/door_complaints/clear_the_doors.mp3"}
	self.SoundPositions["Nag1"] = {1100, 1e9, Vector(350, -30, 113), 1}

	self.SoundNames["Door_open1r"] = {loop = 0.5, "lilly/uf/u2/Door_open_start.mp3", "lilly/uf/u2/Door_open_loop.mp3", "lilly/uf/u2/Door_open_end2.mp3"}
	self.SoundPositions["Door_open1r"] = {400, 1e9, Vector(370, -49.4254, 110), 1}

	self.SoundNames["Door_open2r"] = {loop = 0.5, "lilly/uf/u2/Door_open_start.mp3", "lilly/uf/u2/Door_open_loop.mp3", "lilly/uf/u2/Door_open_end2.mp3"}
	self.SoundPositions["Door_open2r"] = {400, 1e9, Vector(134.36, -49.4254, 110), 1}

	self.SoundNames["Door_close2r"] = {loop = 0.5, "lilly/uf/u2/Door_close_start.mp3", "lilly/uf/u2/Door_close_loop.mp3", "lilly/uf/u2/Door_close_end.mp3"}
	self.SoundPositions["Door_close2r"] = {400, 1e9, Vector(134.36, -49.4254, 110), 1}

	self.SoundNames["Door_close1r"] = {loop = 0.5, "lilly/uf/u2/Door_close_start.mp3", "lilly/uf/u2/Door_close_loop.mp3", "lilly/uf/u2/Door_close_end.mp3"}
	self.SoundPositions["Door_close1r"] = {400, 1e9, Vector(370, -49.4254, 110), 1}

	self.SoundNames["Door_open1l"] = {loop = 0.5, "lilly/uf/u2/Door_open_start.mp3", "lilly/uf/u2/Door_open_loop.mp3", "lilly/uf/u2/Door_open_end2.mp3"}
	self.SoundPositions["Door_open1l"] = {400, 1e9, Vector(409, 49.4254, 109), 1}

	self.SoundNames["Door_open2l"] = {loop = 0.5, "lilly/uf/u2/Door_open_start.mp3", "lilly/uf/u2/Door_open_loop.mp3", "lilly/uf/u2/Door_open_end2.mp3"}
	self.SoundPositions["Door_open2l"] = {400, 1e9, Vector(134.36, 49.4254, 109), 1}

	self.SoundNames["Door_close2l"] = {loop = 0.5, "lilly/uf/u2/Door_close_start.mp3", "lilly/uf/u2/Door_close_loop.mp3", "lilly/uf/u2/Door_close_end.mp3"}
	self.SoundPositions["Door_close2l"] = {400, 1e9, Vector(134.36, 49.4254, 109), 1}

	self.SoundNames["Door_close1l"] = {loop = 0.5, "lilly/uf/u2/Door_close_start.mp3", "lilly/uf/u2/Door_close_loop.mp3", "lilly/uf/u2/Door_close_end.mp3"}
	self.SoundPositions["Door_close1l"] = {400, 1e9, Vector(370, 49.4254, 110), 1}

	self.SoundNames["Deadman"] = {loop = 0.5, "lilly/uf/common/deadman_start.mp3", "lilly/uf/common/deadman_loop.mp3", "lilly/uf/common/deadman_end.mp3"}
	self.SoundPositions["Deadman"] = {800, 1e9, Vector(401, 14, 14), .7}

	self.SoundNames["DoorsCloseAlarm"] = {
		loop = 0.01,
		"lilly/uf/u2/overhaul/doorsareclosed_loop_start.mp3",
		"lilly/uf/u2/overhaul/doorsareclosed_loop.mp3",
		"lilly/uf/u2/overhaul/doorsareclosed_loop_end.mp3"
	}
	self.SoundPositions["DoorsCloseAlarm"] = {10, 1e9, Vector(386, 20, 8, 0, 53), 0.1}

	self.SoundNames["rolling_10"] = {loop = true, "lilly/uf/u2/Moto/engine_loop_start.mp3"}
	self.SoundNames["rolling_70"] = {loop = true, "lilly/uf/u2/rumb1.mp3"}
	self.SoundPositions["rolling_10"] = {1200, 1e9, Vector(0, 0, 0), 1}
	self.SoundPositions["rolling_70"] = self.SoundPositions["rolling_10"]

	self.SoundNames["rolling_motors_a"] = {
		loop = 1,
		"lilly/uf/bogeys/u2/test/engine_loop_primary_start.mp3",
		"lilly/uf/bogeys/u2/test/engine_loop_primary.mp3",
		"lilly/uf/bogeys/u2/test/engine_loop_primary_end.mp3"
	}
	self.SoundPositions["rolling_motors_a"] = {480, 1e12, Vector(0, 0, 0), 1}

	self.SoundNames["rolling_motors_b"] = {loop = true, "lilly/uf/bogeys/u2/test/engine_loop_secondary.mp3"}
	self.SoundPositions["rolling_motors_b"] = {480, 1e12, Vector(0, 0, 0), 1}

	self.SoundNames["IBIS_beep"] = {"lilly/uf/IBIS/beep.mp3"}
	self.SoundPositions["IBIS_beep"] = {1100, 1e9, Vector(412, -12, 55), 5}

	self.SoundNames["IBIS_bootup"] = {"lilly/uf/IBIS/startup_chime.mp3"}
	self.SoundPositions["IBIS_bootup"] = {1100, 1e9, Vector(412, -12, 55), 1}

	self.SoundNames["IBIS_error"] = {"lilly/uf/IBIS/error.mp3"}
	self.SoundPositions["IBIS_error"] = {1100, 1e9, Vector(412, -12, 55), 1}

	self.SoundNames["Fan1"] = {loop = 10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions["Fan1"] = {1100, 1e9, Vector(350, 0, 70), 0.035}
	self.SoundNames["Fan2"] = {loop = 10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions["Fan2"] = {1100, 1e9, Vector(250, 0, 70), 0.035}
	self.SoundNames["Fan3"] = {loop = 10.5, "lilly/uf/u2/fan_start.mp3", "lilly/uf/u2/fan.mp3", "lilly/uf/u2/fan_end.mp3"}
	self.SoundPositions["Fan3"] = {1100, 1e9, Vector(100, 0, 70), 0.035}

	self.SoundNames["Switchgear1"] = {"lilly/uf/u2/Stuk01.mp3"}
	self.SoundPositions["Switchgear1"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear2"] = {"lilly/uf/u2/Stuk02.mp3"}
	self.SoundPositions["Switchgear2"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear3"] = {"lilly/uf/u2/Stuk03.mp3"}
	self.SoundPositions["Switchgear3"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear4"] = {"lilly/uf/u2/Stuk04.mp3"}
	self.SoundPositions["Switchgear4"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear5"] = {"lilly/uf/u2/Stuk05.mp3"}
	self.SoundPositions["Switchgear5"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear6"] = {"lilly/uf/u2/Stuk06.mp3"}
	self.SoundPositions["Switchgear6"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["Switchgear7"] = {"lilly/uf/u2/Stuk07.mp3"}
	self.SoundPositions["Switchgear7"] = {1100, 1e9, Vector(250, 0, 200), 1}

	self.SoundNames["button_on"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_on"] = {1100, 1e9, Vector(405, 36, 55), 1}

	self.SoundNames["button_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["button_off"] = {1100, 1e9, Vector(405, 36, 55), 1}

	self.SoundNames["Toggle_on"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["Toggle_on"] = {1100, 1e9, Vector(405, 36, 55), 1}

	self.SoundNames["Toggle_off"] = {"lilly/uf/u2/insidecab/buttonclick.mp3"}
	self.SoundPositions["Toggle_off"] = {1100, 1e9, Vector(405, 36, 55), 1}

	self.SoundNames["Cruise"] = {"lilly/uf/u2/cruise/cruise_medium_start.mp3", "lilly/uf/u2/cruise/cruise_medium.mp3", "lilly/uf/u2/cruise/cruise_medium_stop.mp3"}
	self.SoundPositions["Cruise"] = {1100, 1e9, Vector(300, 0, 100), 1}

	self.SoundNames["rumb1"] = {"lilly/uf/u2/cruise/rumb1_start.mp3", "lilly/uf/u2/cruise/rumb1.mp3", "lilly/uf/u2/cruise/rumb1_stop.mp3"}
	self.SoundPositions["rumb1"] = {1100, 1e9, Vector(300, 0, 100), 1}

	self.SoundNames["Blinker"] = {"lilly/uf/u2/overhaul/u2_blinker_relay.mp3"}
	self.SoundPositions["Blinker"] = {10, 1e9, Vector(400, -5, 200), 1}

	self.SoundNames["Blinker_off"] = {"lilly/uf/u2/U2_Blinkerrelais_auslauf.mp3"}
	self.SoundPositions["Blinker_off"] = {10, 1e9, Vector(400, -5, 200), 1}

	self.SoundNames["Battery_breaker"] = {"lilly/uf/u2/u2_battery_breaker_on.mp3"}
	self.SoundPositions["Battery_breaker"] = {10, 1e9, Vector(400, -5, 200), 1}

	self.SoundNames["Battery_breaker_off"] = {"lilly/uf/u2/u2_battery_breaker_off.mp3"}
	self.SoundPositions["Battery_breaker_off"] = {10, 1e9, Vector(400, -5, 200), 1}

	self.SoundNames["MotorType1"] = {
		loop = 5,
		"lilly/uf/bogeys/u2/test/engine_loop_primary_start.mp3",
		"lilly/uf/bogeys/u2/test/engine_loop_primary.mp3",
		"lilly/uf/bogeys/u2/test/engine_loop_primary_end.mp3"
	}
	self.SoundPositions["MotorType1"] = {1100, 1e9, Vector(540, 0, 70), 0.035}

end

ENT.AnnouncerPositions = {{Vector(420, -38.2, 80)}, {Vector(420, 38.2, 80)}}



function ENT:ReturnOpenDoors()

	if self.DoorStatesRight[1] < 0.8 and self.DoorStatesRight[2] < 0.8 and self.DoorStatesRight[3] < 0.8 and self.DoorStatesRight[4] < 0.8 then
		self.RightDoorPositions = {}
	end
	for k,v in ipairs(self.DoorStatesRight) do
		
		if v > 0.8 and k < 3 then
			self.RightDoorPositions[k] = self.DoorVectorsRight[k]
		elseif v > 0.8 and k > 2 then
			self.SectionB.RightDoorPositions[k] = self.DoorVectorsRight[k]
		elseif v < 0.8 and k < 3 then
			self.RightDoorPositions[k] = nil
		elseif v < 0.8 and k > 2 then
			self.SectionB.RightDoorPositions[k] = nil
		end
		
	end

	for k,v in ipairs(self.DoorStatesLeft) do

		if v > 0.8 and k < 3 then
			self.SectionB.LeftDoorPositions[k] = self.DoorVectorsLeft[k]
		elseif v > 0.8 and k > 2 then
			self.LeftDoorPositions[k] = self.DoorVectorsLeft[k]
		elseif v < 0.8 and k < 3 then
			self.SectionB.LeftDoorPositions[k] = nil
		elseif v < 0.8 and k > 2 then
			self.LeftDoorPositions[k] = nil
		end
	end
end

ENT.DoorVectorsLeft = { [1] = Vector(-360,45.1,22.5),
					    [2] = Vector(-118,45.1,22.5),
						[3] = Vector(118,45.1,22.5),
						[4] = Vector(360,45.1,22.5)}

ENT.DoorVectorsRight = {[1] = Vector(360,-45.1,22.5),
						[2] = Vector(118,-45.1,22.5),
						[3] = Vector(-118,-45,22.5),
						[4] = Vector(-360,-45.1,22.5)}

ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}


ENT.Cameras = {
	{Vector(400, -55, 90), Angle(0, -170, 0), "Train.UF_U2.OutTheWindowRight"},
	{Vector(400, 55, 90), Angle(0, 170, 0), "Train.UF_U2.OutTheWindowLeft"},
	{Vector(300, 6, 90), Angle(0, 180 + 5, 0), "Train.UF_U2.PassengerStanding"},
	{Vector(70.5 + 10, 6, 90), Angle(0, 0, 0), "Train.UF_U2.PassengerStanding2"},
	{Vector(490.5, 0, 100), Angle(0, 180, 0), "Train.Common.RouteNumber"},
	{Vector(388, -30, 80), Angle(0, -90, 0), "Train.UF_U2.RouteList"},
	{Vector(388, 0, 120), Angle(0, -180, 0), "Train.UF_U2.Rollsign"},
	{Vector(450, 0, 70), Angle(80, 0, 0), "Train.Common.CouplerCamera"},
	{Vector(350, 60, 5), Angle(10, -80, 0), "Train.UF_U2.Bogey"},
	{Vector(413, -11, 62), Angle(35, -46, 0), "Train.UF_U2.IBIS"},
	{Vector(413, -25, 58), Angle(10, 50, 0), "Train.UF_U2.IBISKey"},
	{Vector(250, 6, 200), Angle(0, 180, 0), "Train.UF_U2.Panto"}
}

ENT.MirrorCams = {Vector(441, 72, 15), Angle(1, 180, 0), 15, Vector(441, -72, 15), Angle(1, 180, 0), 18}

function ENT:InitializeSystems()
	self:LoadSystem("Duewag_U2")
	self:LoadSystem("DeadmanUF", "Duewag_Deadman")
	self:LoadSystem("IBIS")
	self:LoadSystem("Announcer", "uf_announcer")
	self:LoadSystem("Duewag_Battery")
	self:LoadSystem("Panel", "U2_panel")

	-- self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {Type = "U2", Name = "U2h", WagType = 0, Manufacturer = "Duewag"}

ENT.AnnouncerPositions = {{Vector(293, 44, 102)}, {Vector(293, -44, 102)}}
function ENT:DeltaTime()
	ENT.PrevTime = ENT.PrevTime or RealTime()
	ENT.DeltaTime = (RealTime() - ENT.PrevTime)
	ENT.PrevTime = RealTime()
	return ENT.DeltaTime
end

ENT.NumberRanges = {{303, 364}}

ENT.Spawner = {
	model = {"models/lilly/uf/u2/u2h.mdl", "models/lilly/uf/u2/u2hb.mdl", "models/lilly/uf/u2/u2-cabfront.mdl"},
	head = "gmod_subway_uf_u2_section_a",
	interim = "gmod_subway_uf_u2_section_a",
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

	{"RetroMode", "Spawner.U2.RetroMode", "Boolean", false, function(ent, val, rot) ent:SetNW2Bool("RetroMode", val and not rot or not val and rot) end},
	{"Old Mirror", "Spawner.U2.OldMirror", "Boolean", true, function(ent, val, rot) ent:SetNW2Bool("OldMirror", val and not rot or not val and rot) end},
	-- {"San Diego","Spawner.U2.San Diego","Boolean",false,function(ent,val,rot) ent:SetNW2Bool("SanDiego",val and not rot or not val and rot) end},
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
		"U2Signs",
		"Rollsign Texture",
		"List",
		function(ent)
			local Rollsigns = {}
			for k, v in pairs(UF.U2Rollsigns or {}) do Rollsigns[k] = v.name end
			return Rollsigns
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
if CLIENT then
	function ENT:PlayOnceIBIS(soundid, range, pitch)

		if not soundid then ErrorNoHalt(debug.Trace()) end

		-- if not soundname then print("NO SOUND",soundname,soundid) return end
		if soundid then
			sound.PlayFile("sound/" .. soundid, "3d noplay mono", function(snd, err, errName)
				if not err and (IsValid(snd)) then
					snd:SetPos(self:GetPos(), self:LocalToWorldAngles(Angle(0, 0, 0)):Forward())
					snd:Set3DFadeDistance(500, 1000)
					snd:EnableLooping(false)
					snd:SetPlaybackRate(1)
					snd:Play()
				end
			end)
		end
	end
end
