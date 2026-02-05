ENT.Type = "anim"
ENT.Base = "gmod_subway_mplr_base"
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
ENT.BrakeLightLeft = {
	[ 6 ] = true
}

ENT.BrakeLightRight = {
	[ 7 ] = true
}

function ENT:PassengerCapacity()
	return 108
end

function ENT:GetStandingArea()
	return Vector( 420, -20, 40 ), Vector( 60, 20, 40 )
end

function ENT:InitializeSounds()
	self.BaseClass.InitializeSounds( self )
	self.SoundNames[ "bell" ] = nil
	self.SoundPositions[ "bell" ] = nil
	self.SoundNames[ "bell" ] = {
		loop = 0.01,
		"lilly/uf/u2/Bell_start.mp3",
		"lilly/uf/u2/Bell_loop.mp3",
		"lilly/uf/u2/Bell_end.mp3"
	}

	self.SoundPositions[ "RaisePanto" ] = { 400, 1e9, Vector( 20, 0, 400 ), 1 }
	self.SoundPositions[ "LowerPanto" ] = { 400, 1e9, Vector( 20, 0, 400 ), 1 }
	self.SoundPositions[ "bell" ] = { 1100, 1e9, Vector( 480, -20, 8 ), 0.7 }
	self.SoundNames[ "bell_in" ] = {
		loop = 0.01,
		"lilly/mplr/b80c_firstgen/bell_start.wav",
		"lilly/mplr/b80c_firstgen/bell_loop.wav",
		"lilly/mplr/b80c_firstgen/bell_end.wav"
	}

	self.SoundPositions[ "bell_in" ] = { 800, 1e9, Vector( 480, -20, 50 ), 1 }
	-----------------------------------------------------------------------------
	self.SoundNames[ "BrakesRelease" ] = { "lilly/mplr/b80c_firstgen/brake_release.wav" }
	self.SoundPositions[ "BrakesRelease" ] = { 800, 1e9, Vector( 440, 0, 100 ), 1 }
	self.SoundNames[ "BrakesSet" ] = { "lilly/mplr/b80c_firstgen/brake_hiss.wav" }
	self.SoundPositions[ "BrakesSet" ] = { 800, 1, Vector( 440, 0, 100 ), 1 }
	self.SoundNames[ "Chopper" ] = {
		loop = 2.25,
		"lilly/mplr/b80c_firstgen/chopper.wav"
	}

	self.SoundNames[ "throttle_up" ] = { { "lilly/mplr/b80c_firstgen/throttle_notch_up1.mp3", "lilly/mplr/b80c_firstgen/throttle_notch_up2.mp3", "lilly/mplr/b80c_firstgen/throttle_notch_up3.mp3", "lilly/mplr/b80c_firstgen/throttle_notch_up4.mp3", "lilly/mplr/b80c_firstgen/throttle_notch_up5.mp3", "lilly/mplr/b80c_firstgen/throttle_notch_up6.mp3" } }
	self.SoundPositions[ "throttle_up" ] = { 40, 1e9, Vector( 502, -20.727, 50 ), 1 }
	self.SoundNames[ "throttle_zero" ] = { "lilly/mplr/b80c_firstgen/throttle_notch_down_tozero.mp3" }
	self.SoundPositions[ "throttle_zero" ] = { 40, 1e9, Vector( 502, -20.727, 50 ), 1 }
	self.SoundNames[ "reverser_up" ] = { "lilly/mplr/b80c_firstgen/reverser_up.mp3" }
	self.SoundPositions[ "reverser_up" ] = { 40, 1e9, Vector( 502, -20.727, 50 ), 1 }
	self.SoundPositions[ "Chopper" ] = { 800, 1e9, Vector( 440, 0, 100 ), 1 }
	self.SoundNames[ "Cruise" ] = { "lilly/mplr/b-wagen_common/cruise.mp3" }
	self.SoundPositions[ "Cruise" ] = { 800, 1e9, Vector( 240, 0, 50 ), 1 }
	self.SoundNames[ "DepartureConfirmed" ] = { "lilly/mplr/common/departure_ready.wav" }
	self.SoundPositions[ "DepartureConfirmed" ] = { 800, 1e9, Vector( 484, 0, 50 ), 1 }
	self.SoundNames[ "DepartureConfirmed2" ] = { "lilly/mplr/b80c_firstgen/departure_bell_1.wav" }
	self.SoundPositions[ "DepartureConfirmed2" ] = { 800, 1e9, Vector( 484, 0, 50 ), 1 }
	self.SoundNames[ "DepartureConfirmed3" ] = { "lilly/mplr/b80c_firstgen/departure_bell_2.wav" }
	self.SoundPositions[ "DepartureConfirmed3" ] = { 800, 1e9, Vector( 484, 0, 50 ), 1 }
	self.SoundNames[ "brake_hiss" ] = { "lilly/mplr/b80c_firstgen/brake_hiss.wav" }
	self.SoundPositions[ "brake_hiss" ] = { 800, 1e9, Vector( 350, 0, 50 ), 1 }
	self.SoundNames[ "chopper" ] = { "lilly/mplr/b80c_firstgen/chopper.wav" }
	self.SoundPositions[ "chopper" ] = { 800, 1e9, Vector( 350, 0, 50 ), 1 }
	self.SoundNames[ "key_insert" ] = { "lilly/mplr/b-wagen_common/key_insert.wav" }
	self.SoundPositions[ "key_insert" ] = { 800, 1e9, Vector( 484, 0, 50 ), 1 }
	-----------------------------------------------------------------------------------------
	self.SoundNames[ "IBIS_beep" ] = { "lilly/uf/IBIS/beep.mp3" }
	self.SoundPositions[ "IBIS_beep" ] = { 1100, 1e9, Vector( 412, -12, 55 ), 5 }
	self.SoundNames[ "IBIS_bootup" ] = { "lilly/uf/IBIS/startup_chime.mp3" }
	self.SoundPositions[ "IBIS_bootup" ] = { 1100, 1e9, Vector( 412, -12, 55 ), 1 }
	self.SoundNames[ "IBIS_error" ] = { "lilly/uf/IBIS/error.mp3" }
	self.SoundPositions[ "IBIS_error" ] = { 1, 1e9, Vector( 412, -12, 55 ), 1 }
	self.SoundNames[ "button_on" ] = { "lilly/mplr/b80c_firstgen/button_on.mp3" }
	self.SoundPositions[ "button_on" ] = { 1, 1e9, Vector( 405, 36, 55 ), 1 }
	self.SoundNames[ "button_off" ] = { "lilly/mplr/b80c_firstgen/button_off.mp3" }
	self.SoundNames[ "button_toggle_on" ] = { "lilly/mplr/b80c_firstgen/button_click_in.mp3" }
	self.SoundPositions[ "button_toggle_on" ] = { 1, 1e9, Vector( 405, 36, 55 ), 1 }
	self.SoundNames[ "button_toggle_off" ] = { "lilly/mplr/b80c_firstgen/button_click_out.mp3" }
	self.SoundPositions[ "button_toggle_off" ] = { 1, 1e9, Vector( 405, 36, 55 ), 1 }
	self.SoundNames[ "key_insert" ] = { "lilly/uf/common/key-1.wav" }
	self.SoundPositions[ "key_insert" ] = { 1100, 1e9, Vector( 480, 36, 70 ), 1 }
end

ENT.Cameras = { { Vector( 500, -50, 90 ), Angle( 0, -170, 0 ), "Train.MPLR.OutTheWindowRight" }, { Vector( 500, 50, 90 ), Angle( 0, 170, 0 ), "Train.MPLR_U2.OutTheWindowLeft" }, { Vector( 300, 6, 100 ), Angle( 0, 180 + 5, 0 ), "Train.MPLR_U2.PassengerStanding" }, { Vector( 70.5 + 10, 6, 100 ), Angle( 0, 0, 0 ), "Train.MPLR_U2.PassengerStanding2" }, { Vector( 490.5, 0, 100 ), Angle( 0, 180, 0 ), "Train.Common.RouteNumber" }, { Vector( 480, -5, 100 ), Angle( 0, -180, 0 ), "Train.MPLR.RouteList" }, { Vector( 530, 0, 70 ), Angle( 80, 0, 0 ), "Train.Common.CouplerCamera" }, { Vector( 350, 60, 5 ), Angle( 10, -80, 0 ), "Train.MPLR_U2.Bogey" }, { Vector( 505, -7, 80 ), Angle( 35, 0, 0 ), "Train.MPLR.IBIS" }, { Vector( 250, 6, 200 ), Angle( 0, 180, 0 ), "Train.MPLR.Panto" } }
ENT.LeftDoorPositions = {}
ENT.RightDoorPositions = {}
ENT.SectionADoors = {
	[ 1 ] = true,
	[ 2 ] = true,
	[ 7 ] = true,
	[ 8 ] = true
}

ENT.SectionBDoors = {
	[ 3 ] = true,
	[ 4 ] = true,
	[ 5 ] = true,
	[ 6 ] = true
}

ENT.DoorsRight = {
	[ 1 ] = Vector( 330.889, -46.4148, 35.3841 ),
	[ 2 ] = Vector( 330.889, -46.4148, 35.3841 ),
	[ 3 ] = Vector( 88.604, -46.4148, 35.3841 ),
	[ 4 ] = Vector( -330.889, -46.4148, 35.3841 ),
	[ 5 ] = Vector( -88.604, -46.4148, 35.3841 ),
	[ 6 ] = Vector( -88.604, -46.4148, 35.3841 ),
}

ENT.DoorsLeft = {
	[ 1 ] = Vector( -330.889, 46.4148, 35.3841 ),
	[ 2 ] = Vector( -330.889, 46.4148, 35.3841 ),
	[ 3 ] = Vector( -88.604, 46.4148, 35.3841 ),
	[ 4 ] = Vector( 330.889, 46.4148, 35.3841 ),
	[ 5 ] = Vector( 88.604, 46.4148, 35.3841 ),
	[ 6 ] = Vector( 88.604, 46.4148, 35.3841 )
}

ENT.StepsLow = true
ENT.StepsMedium = true
ENT.StopRequest = true
ENT.Bidirectional = true
ENT.DoorsUnlockToggle = true
ENT.BlinkersLeft = {
	[ 58 ] = true,
	[ 48 ] = true
}

ENT.BlinkersRight = {
	[ 49 ] = true,
	[ 59 ] = true
}

ENT.MirrorCams = { Vector( 540, 60, 100 ), Angle( 1, 180, 0 ), 50, Vector( 540, -60, 100 ), Angle( 1, 180, 0 ), 50 }
function ENT:InitializeSystems()
	self:LoadSystem( "DeadmanMPLR", "Duewag_Deadman" )
	self:LoadSystem( "Battery", "Duewag_Battery" )
	self:LoadSystem( "Panel", "1973_panel", true )
	self:LoadSystem( "Chopper" )
	self:LoadSystem( "CoreSys", "duewag_b_1973" )
	self:LoadSystem( "INDUSI", "mplr_INDUSI_scanner" )
	self:LoadSystem( "IBIS" )
	self:LoadSystem( "Announcer", "uf_announcer" )
	self:LoadSystem( "DoorHandler", "MPLR_DoorHandler" )
	self:LoadSystem( "SoundEng", "duewag_b_1973_soundeng" )
	self:LoadSystem( "Blinkers" )
	local loadLZB = self:GetNW2Bool( "LZBEnable", false )
	if loadLZB then self:LoadSystem( "LZB90" ) end
	-- self:LoadSystem("duewag_electric")
end

ENT.SubwayTrain = {
	Type = "B",
	Name = "B-Wagen Series 1973",
	WagType = 0,
	Manufacturer = "Duewag",
	Section = "A",
	Vmax = 100,
	Voltage = 750,
	Mass = 38500,
	StepsMedium = true,
	StepsLow = true,
	StopRequest = true,
	Bidirectional = true
}

ENT.LZBTab = {
	TractivePower = 470,
	BrakingPower = 1.2,
	-- TODO: Establish an actual braking and acceleration curve
	BrakingCurve = { 0.1, 0.4, 0.8, 1 },
	AccelCurve = { 1, 0.8, 0.4, 0.1 },
	LengthInMetres = 26,
	Weight = 40
}

ENT.AnnouncerPositions = { { Vector( 293, 44, 102 ) }, { Vector( 293, -44, 102 ) } }
ENT.NumberRanges = { { 5001, 5028 } }
ENT.Spawner = {
	model = { "models/lilly/mplr/ruhrbahn/b_1973/section_a.mdl", "models/lilly/mplr/ruhrbahn/b_1973/section_b.mdl" },
	head = "gmod_subway_mplr_bwagen1973_section_a",
	interim = "gmod_subway_mplr_bwagen1973_section_a",
	Metrostroi.Skins.GetTable( "Texture", "Spawner.Texture", false, "train" ),
	Metrostroi.Skins.GetTable( "Texture", "Spawner.Texture", false, "cab" ),
	{ "LZBEnable", "Spawner.B1973.LZBEnable", "Boolean", false, function( ent, val, rot ) ent:SetNW2Bool( "LZBLoad", val and not rot or not val and rot ) end },
	{
		"IBISData",
		"IBIS Line Index",
		"List",
		function( ent )
			local Announcer = {}
			for k, v in pairs( MPLR.IBISLines or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.IBISLines and val == 1 then
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
			for k, v in pairs( MPLR.IBISRoutes or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.IBISLRoutes and val == 1 then
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
			for k, v in pairs( MPLR.IBISDestinations or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.IBISDestinations and val == 1 then
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
			for k, v in pairs( MPLR.SpecialAnnouncementsIBIS or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.SpecialAnnouncementsIBIS and val == 1 then
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
			for k, v in pairs( MPLR.IBISAnnouncementScript or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.IBISAnnouncementScript and val == 1 then
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
			for k, v in pairs( MPLR.IBISAnnouncementMetadata or {} ) do
				Announcer[ k ] = v.name
			end
			return Announcer
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.IBISAnnouncementMetadata and val == 1 then
				ent:SetNW2Int( "IBIS:Announcements", 1 )
			else
				ent:SetNW2Int( "IBIS:Announcements", val )
			end
		end
	},
	{
		"RollsignData",
		"Rollsign Texture",
		"List",
		function()
			local Rollsign = {}
			for k, v in pairs( MPLR.Rollsigns or {} ) do
				if "B-Wagen Series 1973" == MPLR.Rollsigns[ k ].train then Rollsign[ k ] = v.name end
			end

			PrintTable( Rollsign )
			return Rollsign
		end,
		nil,
		function( ent, val, rot, i, wagnum, rclk )
			if MPLR.Rollsigns[ val ] and val == 1 then
				ent:SetNW2Int( "RollsignTexture", 1 )
			else
				ent:SetNW2Int( "RollsignTexture", val )
			end
		end
	},
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