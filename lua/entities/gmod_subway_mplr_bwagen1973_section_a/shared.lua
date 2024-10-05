ENT.Type = "anim"
ENT.Base = "gmod_subway_uf_base"
ENT.PrintName = "Duewag B-Wagen 1973 Series"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.SkinsType = "B1973"
ENT.DontAccelerateSimulation = true
ENT.RenderGroup = 9
function ENT:PassengerCapacity()
	return 108
end

function ENT:GetStandingArea()
	return Vector( 420, -20, 40 ), Vector( 60, 20, 40 )
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds( self )
	self.SoundNames[ "bell" ] = {
		loop = 0.01,
		"lilly/uf/u2/Bell_start.mp3",
		"lilly/uf/u2/Bell_loop.mp3",
		"lilly/uf/u2/Bell_end.mp3"
	}

	self.SoundPositions[ "bell" ] = { 1100, 1e9, Vector( 480, -20, 8 ), 0.7 }
	self.SoundNames[ "bell_in" ] = {
		loop = 0.01,
		"lilly/uf/u2/insidecab/Bell_start.mp3",
		"lilly/uf/u2/insidecab/Bell_loop.mp3",
		"lilly/uf/u2/insidecab/Bell_end.mp3"
	}

	self.SoundNames[ "Cruise" ] = { "lilly/mplr/b-wagen_common/cruise.mp3" }
	self.SoundPositions[ "Cruise" ] = { 800, 1e9, Vector( 240, 0, 50 ), 1 }
	self.SoundNames[ "DepartureConfirmed" ] = { "lilly/mplr/common/departure_ready.wav" }
	self.SoundPositions[ "DepartureConfirmed" ] = { 800, 1e9, Vector( 484, 0, 50 ), 1 }
	-----------------------------------------------------------------------------------------
	self.SoundPositions[ "bell_in" ] = { 800, 1e9, Vector( 480, -20, 50 ), 1 }
	self.SoundNames[ "IBIS_beep" ] = { "lilly/uf/IBIS/beep.mp3" }
	self.SoundPositions[ "IBIS_beep" ] = { 1100, 1e9, Vector( 412, -12, 55 ), 5 }
	self.SoundNames[ "IBIS_bootup" ] = { "lilly/uf/IBIS/startup_chime.mp3" }
	self.SoundPositions[ "IBIS_bootup" ] = { 1100, 1e9, Vector( 412, -12, 55 ), 1 }
	self.SoundNames[ "IBIS_error" ] = { "lilly/uf/IBIS/error.mp3" }
	self.SoundPositions[ "IBIS_error" ] = { 1100, 1e9, Vector( 412, -12, 55 ), 1 }
	self.SoundNames[ "button_on" ] = { "lilly/uf/u2/insidecab/buttonclick.mp3" }
	self.SoundPositions[ "button_on" ] = { 1100, 1e9, Vector( 405, 36, 55 ), 1 }
	self.SoundNames[ "button_off" ] = { "lilly/uf/u2/insidecab/buttonclick.mp3" }
	self.SoundPositions[ "button_off" ] = { 1100, 1e9, Vector( 405, 36, 55 ), 1 }
	self.SoundNames[ "key_insert" ] = { "lilly/uf/common/key-1.wav" }
	self.SoundPositions[ "key_insert" ] = { 1100, 1e9, Vector( 480, 36, 70 ), 1 }
end

ENT.Cameras = { { Vector( 500, -50, 90 ), Angle( 0, -170, 0 ), "Train.UF_U2.OutTheWindowRight" }, { Vector( 500, 50, 90 ), Angle( 0, 170, 0 ), "Train.UF_U2.OutTheWindowLeft" }, { Vector( 300, 6, 100 ), Angle( 0, 180 + 5, 0 ), "Train.UF_U2.PassengerStanding" }, { Vector( 70.5 + 10, 6, 100 ), Angle( 0, 0, 0 ), "Train.UF_U2.PassengerStanding2" }, { Vector( 490.5, 0, 100 ), Angle( 0, 180, 0 ), "Train.Common.RouteNumber" }, { Vector( 480, -5, 100 ), Angle( 0, -180, 0 ), "Train.UF.RouteList" }, { Vector( 530, 0, 70 ), Angle( 80, 0, 0 ), "Train.Common.CouplerCamera" }, { Vector( 350, 60, 5 ), Angle( 10, -80, 0 ), "Train.UF_U2.Bogey" }, { Vector( 505, -7, 80 ), Angle( 35, 0, 0 ), "Train.UF.IBIS" }, { Vector( 250, 6, 200 ), Angle( 0, 180, 0 ), "Train.UF.Panto" } }
ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
ENT.SectionADoors = {
	[ 1 ] = Vector( 330.889, -46.4148, 35.3841 ),
	[ 2 ] = Vector( 88.604, -46.4148, 35.3841 ),
	[ 7 ] = Vector( 330.889, 46.4148, 35.3841 ),
	[ 8 ] = Vector( 88.604, 46.4148, 35.3841 )
}

ENT.SectionBDoors = {
	[ 3 ] = Vector( -330.889, -46.4148, 35.3841 ),
	[ 4 ] = Vector( -88.604, -46.4148, 35.3841 ),
	[ 5 ] = Vector( -330.889, 46.4148, 35.3841 ),
	[ 6 ] = Vector( -88.604, 46.4148, 35.3841 )
}

ENT.StepsLow = true
ENT.StepsMedium = true
ENT.StopRequest = true
ENT.Bidirectional = true
ENT.DoorsUnlockToggle = true
ENT.MirrorCams = { Vector( 540, 60, 100 ), Angle( 1, 180, 0 ), 50, Vector( 540, -60, 100 ), Angle( 1, 180, 0 ), 50 }
function ENT:InitializeSystems()
	self:LoadSystem( "DeadmanUF", "Duewag_Deadman" )
	self:LoadSystem( "Duewag_Battery" )
	self:LoadSystem( "Panel", "1973_panel" )
	self:LoadSystem( "Chopper" )
	self:LoadSystem( "CoreSys", "duewag_b_1973" )
	self:LoadSystem( "INDUSI", "mplr_INDUSI_scanner" )
	self:LoadSystem( "IBIS" )
	self:LoadSystem( "Announcer", "uf_announcer" )
	self:LoadSystem( "MPLR_DoorHandler" )
	self:LoadSystem( "Blinkers" )
	-- self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {
	Type = "B",
	Name = "B-Wagen Series 1973",
	WagType = 0,
	Manufacturer = "Duewag",
	Section = "A"
}

ENT.AnnouncerPositions = { { Vector( 293, 44, 102 ) }, { Vector( 293, -44, 102 ) } }
ENT.NumberRanges = { { 5021, 5028 } }
ENT.Spawner = {
	model = { "models/lilly/mplr/ruhrbahn/b_1973/section_a.mdl", "models/lilly/mplr/ruhrbahn/b_1973/section_b.mdl" },
	head = "gmod_subway_mplr_bwagen1973_section_a",
	interim = "gmod_subway_mplr_bwagen1973_section_a",
	Metrostroi.Skins.GetTable( "Texture", "Spawner.Texture", false, "train" ),
	Metrostroi.Skins.GetTable( "Texture", "Spawner.Texture", false, "cab" ),
	{
		"IBISData",
		"IBIS Line Index",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.IBISLines or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.IBISLines and val == 1 then
				ent:SetNW2Int( "IBIS:Lines", 1 )
			else
				ent:SetNW2Int( "IBIS:Lines", val )
			end
		end
	},
	{
		"IBISData2",
		"IBIS Route Index",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.IBISRoutes or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.IBISLRoutes and val == 1 then
				ent:SetNW2Int( "IBIS:Routes", 1 )
			else
				ent:SetNW2Int( "IBIS:Routes", val )
			end
		end
	},
	{
		"IBISData4",
		"IBIS Destinations",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.IBISDestinations or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.IBISDestinations and val == 1 then
				ent:SetNW2Int( "IBIS:Destinations", 1 )
			else
				ent:SetNW2Int( "IBIS:Destinations", val )
			end
		end
	},
	{
		"IBISData5",
		"IBIS Service Announcements",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.SpecialAnnouncementsIBIS or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.SpecialAnnouncementsIBIS and val == 1 then
				ent:SetNW2Int( "IBIS:ServiceA", 1 )
			else
				ent:SetNW2Int( "IBIS:ServiceA", val )
			end
		end
	},
	{
		"IBISData6",
		"IBIS Announcements Script",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.IBISAnnouncementScript or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.IBISAnnouncementScript and val == 1 then
				ent:SetNW2Int( "IBIS:AnnouncementScript", 1 )
			else
				ent:SetNW2Int( "IBIS:AnnouncementScript", val )
			end
		end
	},
	{
		"IBISData7",
		"IBIS Station Announcements",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.IBISAnnouncementMetadata or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.IBISAnnouncementMetadata and val == 1 then
				ent:SetNW2Int( "IBIS:Announcements", 1 )
			else
				ent:SetNW2Int( "IBIS:Announcements", val )
			end
		end
	},
	{
		"Signs",
		"Rollsign Texture",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( UF.BRollsigns or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if UF.U2Rollsigns and val == 1 then
				ent:SetNW2Int( "Rollsign", 1 )
			else
				ent:SetNW2Int( "Rollsign", val )
			end
		end
	}
}

ENT.DoorNumberRight = 6
ENT.DoorNumberLeft = 6
ENT.LeftDoorPositions = {
	[ 1 ] = Vector( -360, 45.1, 22.5 ),
	[ 2 ] = Vector( -118, 45.1, 22.5 ),
	[ 3 ] = Vector( 118, 45.1, 22.5 ),
	[ 4 ] = Vector( 360, 45.1, 22.5 )
}

ENT.RightDoorPositions = {
	[ 1 ] = Vector( 360, -45.1, 22.5 ),
	[ 2 ] = Vector( 118, -45.1, 22.5 ),
	[ 3 ] = Vector( -118, -45, 22.5 ),
	[ 4 ] = Vector( -360, -45.1, 22.5 )
}