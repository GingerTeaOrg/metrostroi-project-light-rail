include( "shared.lua" )
ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}
ENT.Lights = {
	-- Headlight glow
	[ 1 ] = {
		"headlight",
		Vector( 410, 39, 43 ),
		Angle( 10, 0, 0 ),
		Color( 216, 161, 92 ),
		fov = 60,
		farz = 600,
		brightness = 1.2,
		texture = "models/metrostroi_train/equipment/headlight",
		shadows = 1,
		headlight = true
	},
	[ 2 ] = {
		"headlight",
		Vector( 410, -39, 43 ),
		Angle( 10, 0, 0 ),
		Color( 216, 161, 92 ),
		fov = 60,
		farz = 600,
		brightness = 1.2,
		texture = "models/metrostroi_train/equipment/headlight",
		shadows = 1,
		headlight = true
	},
	[ 3 ] = {
		"light",
		Vector( 406, 0, 100 ),
		Angle( 0, 0, 0 ),
		Color( 216, 161, 92 ),
		fov = 40,
		farz = 450,
		brightness = 3,
		texture = "effects/flashlight/soft",
		shadows = 1,
		headlight = true
	},
	[ 4 ] = {
		"headlight",
		Vector( 545, 38.5, 40 ),
		Angle( -20, 0, 0 ),
		Color( 255, 0, 0 ),
		fov = 50,
		brightness = 0.7,
		farz = 50,
		texture = "models/metrostroi_train/equipment/headlight2",
		shadows = 0,
		backlight = true
	},
	[ 5 ] = {
		"headlight",
		Vector( 545, -38.5, 40 ),
		Angle( -20, 0, 0 ),
		Color( 255, 0, 0 ),
		fov = 50,
		brightness = 0.7,
		farz = 50,
		texture = "models/metrostroi_train/equipment/headlight2",
		shadows = 0,
		backlight = true
	},
	[ 6 ] = {
		"headlight", -- cab lights
		Vector( 406, 39, 98 ),
		Angle( 90, 0, 0 ),
		Color( 226, 197, 160 ),
		brightness = 0.9,
		scale = 0.7,
		texture = "effects/flashlight/soft.vmt"
	},
	[ 16 ] = {
		"headlight",
		Vector( 406, -39, 98 ),
		Angle( 90, 0, 0 ),
		Color( 226, 197, 160 ),
		brightness = 0.9,
		scale = 0.7,
		texture = "effects/flashlight/soft.vmt"
	},
	[ 7 ] = {
		"headlight",
		Vector( 545, 38.5, 45 ),
		Angle( -20, 0, 0 ),
		Color( 255, 102, 0 ),
		fov = 50,
		brightness = 0.7,
		farz = 50,
		texture = "models/metrostroi_train/equipment/headlight2",
		shadows = 0,
		backlight = true
	},
	[ 8 ] = {
		"headlight",
		Vector( 545, -38.5, 45 ),
		Angle( -20, 0, 0 ),
		Color( 255, 102, 0 ),
		fov = 50,
		brightness = 0.7,
		farz = 50,
		texture = "models/metrostroi_train/equipment/headlight2",
		shadows = 0,
		backlight = true
	},
	[ 9 ] = {
		"dynamiclight", -- passenger light front left
		Vector( 400, 30, 490 ),
		Angle( 90, 0, 0 ),
		Color( 226, 197, 160 ),
		fov = 100,
		brightness = 0.9,
		scale = 1.0,
		texture = "effects/flashlight/soft.vmt"
	},
	[ 10 ] = {
		"dynamiclight", -- passenger light front right
		Vector( 400, -30, 490 ),
		Angle( 90, 0, 0 ),
		Color( 226, 197, 160 ),
		fov = 100,
		brightness = 1.0,
		scale = 1.0,
		texture = "effects/flashlight/soft.vmt"
	},
	[ 11 ] = {
		"dynamiclight",
		Vector( 327, -52, 71 ),
		Angle( 90, 0, 0 ),
		Color( 255, 102, 0 ),
		fov = 100,
		brightness = 1.0,
		scale = 1.0,
		texture = "effects/flashlight/soft.vmt"
	}
}

ENT.ClientProps[ "headlights_on" ] = {
	model = "models/lilly/uf/u2/headlights_on.mdl",
	pos = Vector( -0.35, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "IBISkey" ] = {
	model = "models/lilly/uf/u2/cab/key.mdl",
	pos = Vector( 00.3, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "cab" ] = {
	model = "models/lilly/uf/u2/u2-cabfront.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "cab_decal" ] = {
	model = "models/lilly/uf/u2/u2-cabfront-decal-1968.mdl",
	pos = ENT.DecalPos,
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber1" ] = {
	model = "models/lilly/uf/u2/carnumber_front_1.mdl",
	pos = ENT.CarNumPos,
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber2" ] = {
	model = "models/lilly/uf/u2/carnumber_front_2.mdl",
	pos = ENT.CarNumPos,
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber3" ] = {
	model = "models/lilly/uf/u2/carnumber_front_3.mdl",
	pos = ENT.CarNumPos,
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber1int" ] = {
	model = "models/lilly/uf/u2/intnum1.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber2int" ] = {
	model = "models/lilly/uf/u2/intnum2.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "carnumber3int" ] = {
	model = "models/lilly/uf/u2/intnum3.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "switching_iron" ] = {
	model = "models/lilly/uf/u2/switching_iron.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "RetroEquipment" ] = {
	model = "models/lilly/uf/u2/retroprop.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fr1" ] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fr2" ] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fl1" ] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector( 721.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fl2" ] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector( 721.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rr1" ] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector( -242, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rr2" ] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector( -242, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rl1" ] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector( 479, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rl2" ] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector( 479, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "IBIS" ] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector( 0.1, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "duewag_decal" ] = {
	model = "models/lilly/uf/u2/duewag_decal.mdl",
	pos = Vector( 0.1, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "window_cab_l" ] = {
	model = "models/lilly/uf/u2/window_cab_l.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "window_cab_r" ] = {
	model = "models/lilly/uf/u2/window_cab_r.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "Throttle" ] = {
	model = "models/lilly/uf/common/cab/throttle.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "drivers_door" ] = {
	model = "models/lilly/uf/u2/drivers_door.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "Mirror_r" ] = {
	model = "models/lilly/uf/u2/mirror.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "Speedo" ] = {
	model = "models/lilly/uf/u2/cab/speedo.mdl",
	pos = Vector( 418.192, 10, 54.66 ),
	ang = Angle( -8.7, 0, 0 ),
	nohide = true
}

function ENT:Mirror()
	local old = self:GetNW2Bool( "OldMirror", false )
	local mirror = self.ClientProps[ "Mirror_r" ]
	mirror.model = old and "models/lilly/uf/u2/mirror_vintage.mdl" or "models/lilly/uf/u2/mirror.mdl"
end

--[[ENT.ClientProps["BatterySwitch"] = {
model = "models/lilly/uf/u2/cab/battery_switch.mdl",
pos = Vector(413.5,-7,54.1),
ang = Angle(-8.5,0,0),
hideseat = 0.2,
}]]
--[[ENT.ClientProps["HeadlightSwitch"] = {
model = "models/lilly/uf/u2/cab/battery_switch.mdl",
pos = Vector(418.6,23.58,54.75),
ang = Angle(-8.5,0,0),
hideseat = 0.2,
}]]
ENT.ClientProps[ "DriverLightSwitch" ] = {
	model = "models/lilly/uf/u2/cab/battery_switch.mdl",
	pos = Vector( 415.7, -7, 54.5 ),
	ang = Angle( -8.5, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "Voltage" ] = {
	model = "models/lilly/uf/u2/cab/gauge.mdl",
	pos = Vector( 418, 18.7, 54.8 ),
	ang = Angle( -12, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "Amps" ] = {
	model = "models/lilly/uf/u2/cab/gauge.mdl",
	pos = Vector( 418, 1.5, 54.8 ),
	ang = Angle( -12, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "reverser" ] = {
	model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
	pos = Vector( -0.1, -0.25, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "blinds_l" ] = {
	model = "models/lilly/uf/u2/cab/blinds.mdl",
	pos = Vector( -0.6, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 8
}

ENT.ButtonMapMPLR[ "Drivers_Door" ] = {
	pos = Vector( 385.874, -10.7466, 24.4478 ),
	ang = Angle( 0, -90, -90 ),
	width = 25,
	height = 80,
	scale = 1,
	buttons = {
		{
			ID = "PassengerDoor",
			x = 0,
			y = 0,
			w = 25,
			h = 80,
			tooltip = "Cab Door",
			model = {
				var = "PassengerDoor",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Drivers_Door2" ] = {
	pos = Vector( 385.874, -35.7466, 24.4478 ),
	ang = Angle( 0, 90, -90 ),
	width = 25,
	height = 80,
	scale = 1,
	buttons = {
		{
			ID = "PassengerDoor",
			x = 0,
			y = 0,
			w = 25,
			h = 80,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "PassengerDoor",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button1a" ] = {
	pos = Vector( 395.8, -51, 50.5 ),
	ang = Angle( 0, 0, 90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button1a",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button1a",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button2a" ] = {
	pos = Vector( 326, -51, 50.5 ),
	ang = Angle( 0, 0, 90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button2a",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button2a",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button3a" ] = {
	pos = Vector( 151, -51, 50.5 ),
	ang = Angle( 0, 0, 90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button3a",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button3a",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button4a" ] = {
	pos = Vector( 83.7, -51, 50.5 ),
	ang = Angle( 0, 0, 90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button4a",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button4a",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button8b" ] = {
	pos = Vector( 395.8, 51, 50.5 ),
	ang = Angle( 90, 0, -90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button8b",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button8b",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button7b" ] = {
	pos = Vector( 326, 51, 50.5 ),
	ang = Angle( 90, 0, -90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button7b",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button7b",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button6b" ] = {
	pos = Vector( 150.6, 51, 50.5 ),
	ang = Angle( 90, 0, -90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button6a",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button6b",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Button5b" ] = {
	pos = Vector( 82.8, 51, 50.5 ),
	ang = Angle( 90, 0, -90 ),
	width = 5,
	height = 5,
	scale = 0.4,
	buttons = {
		{
			ID = "Button5b",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "It's a door. Does this really need explanation?",
			model = {
				var = "Button5b",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "DeadmanButton" ] = {
	pos = Vector( 410.2, -1.3, 52 ),
	ang = Angle( 90, 0, -90 ),
	width = 3,
	height = 3,
	scale = 0.2,
	buttons = {
		{
			ID = "DeadmanButton",
			x = 0,
			y = 0,
			w = 5,
			h = 5,
			radius = 1,
			tooltip = "Deadman",
			model = {
				var = "DeadmanButton",
				sndid = "door_cab_m",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 ),
				noTooltip = true
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Cab" ] = {
	pos = Vector( 419.6, 24.88, 55.2 ),
	ang = Angle( 0, -90, 8 ),
	width = 500,
	height = 120,
	scale = 0.069,
	buttons = {
		{
			ID = "WarningAnnouncementSet",
			x = 266,
			y = 18,
			radius = 10,
			tooltip = "Please keep back announcement",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl",
				z = -5,
				ang = 0,
				var = "WarningAnnouncement",
				speed = 15,
				sndvol = 1,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "BlinkerLamp",
			x = 271,
			y = 58,
			radius = 10,
			tooltip = "Blinker Status Lamp",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -5,
				name = "BlinkerLamp"
			}
		},
		{
			ID = "DepartureBlockedLamp",
			x = 242,
			y = 58,
			radius = 10,
			tooltip = "Train not cleared for departure",
			model = {
				lamp = {
					model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
					var = "DepartureBlocked",
					z = 0,
					anim = true,
					lcolor = Color( 255, 0, 0 ),
					lz = 12,
					lbright = 3,
					lfov = 130,
					lfar = 16,
					lnear = 8,
					lshadows = 0
				},
				model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
				z = -5,
				ang = 0,
				var = "DepartureBlocked",
				speed = 15,
				sndvol = 1,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "VentilationSet",
			x = 335,
			y = 58,
			radius = 10,
			tooltip = "Enable motor fans",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl",
				z = -5,
				ang = 0,
				getfunc = function( ent ) return ent:GetPackedRatio( "Ventilation" ) end,
				var = "Ventilation",
				speed = 4,
				min = 0,
				max = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "button_on" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "ReleaseHoldingBrakeSet",
			x = 21.5,
			y = 90,
			radius = 10,
			tooltip = "Release mechanical retainer brake manually",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -6,
				ang = 0,
				anim = true,
				var = "ReleaseHoldingBrake",
				speed = 20,
				min = 0,
				max = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SetHoldingBrakeSet",
			x = 21.5,
			y = 58,
			radius = 10,
			tooltip = "set mechanical retainer brake manually",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_red.mdl",
				z = -5,
				ang = 180,
				var = "SetHoldingBrake",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "PassengerOvergroundSet",
			x = 54,
			y = 58,
			radius = 10,
			tooltip = "Set passenger lights to overground mode",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_green.mdl",
				z = -5,
				ang = 0,
				var = "PassengerOverground",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "ShedrunSet",
			x = 87,
			y = 90,
			radius = 10,
			tooltip = "Toggle Indoors Mode",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -6,
				ang = 0,
				var = "Shedrun",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "HighbeamToggle",
			x = 149,
			y = 90.4,
			radius = 10,
			tooltip = "Toggle Headlights On/Off/Highbeam",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = -3,
				ang = 45,
				anim = true,
				var = "HeadlightStatus",
				getfunc = function( ent ) return ent:GetNW2Float( "HeadlightStatus" ) == 0 and 0.5 or ent:GetNW2Float( "HeadlightStatus" ) == 0.5 and 0 or ent:GetNW2Float( "HeadlightStatus" ) == 1 and 1 or 0.5 end,
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "HighbeamLamp",
			x = 149,
			y = 57,
			radius = 10,
			tooltip = "High Beam On",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_blue.mdl",
				z = -6,
				ang = 45,
				anim = false,
				var = "HighbeamLamp"
			}
		},
		{
			ID = "AutomatOnSet",
			x = 118.5,
			y = 90.4,
			radius = 10,
			tooltip = "Automat On (Main HV Breaker)",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -5,
				ang = 45,
				anim = true,
				var = "AutomatOn",
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "AutomatOffSet",
			x = 118.5,
			y = 57,
			radius = 10,
			tooltip = "Automat Off (Main HV Breaker)",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
				z = -5,
				ang = 45,
				anim = true,
				var = "AutomatOff",
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "WiperToggle",
			x = 211,
			y = 57,
			radius = 10,
			tooltip = "Wipers",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = -4,
				ang = 45,
				anim = true,
				var = "Wiper",
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "PassengerUndergroundSet",
			x = 54,
			y = 91,
			radius = 10,
			tooltip = "Set passenger lights to underground mode",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -5,
				ang = 0,
				var = "PassengerUnderground",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "InteriourLightsToggle",
			x = 22,
			y = 19,
			radius = 10,
			tooltip = "Toggle Interiour Lighting",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = 0,
				ang = 45,
				var = "InteriourLights",
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "BatteryToggle",
			x = 463,
			y = 91,
			radius = 10,
			tooltip = "Toggle Battery",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = -2.5,
				ang = 45,
				getfunc = function( ent ) return ent.BatterySwitch end,
				var = "BatteryToggle",
				speed = 5,
				min = 0,
				max = 1,
				sndvol = 20,
				snd = function( val, val2 ) return val2 == 1 and "button_on" or val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SpeakerToggle",
			x = 149,
			y = 18.2,
			radius = 10,
			tooltip = "Toggle Speaker Inside/Outside",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = 0,
				ang = 0,
				--[[getfunc =  function(ent) return ent:GetPackedBool("FlickBatterySwitchOn") and 1 or 0.5 or ent:GetPackedBool("FlickBatterySwitchOff") and 1 or 0.5 end,]]
				var = "Speaker",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DriverLightToggle",
			x = 463,
			y = 70,
			radius = 10,
			tooltip = "Toggle Cab Light",
			model = {
				z = 0,
				ang = 0,
				var = "DriverLight",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SetPointLeftSet",
			x = 179.8,
			y = 90,
			radius = 10,
			tooltip = "Set track point to left",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_arrow_right.mdl",
				z = -4,
				ang = 90,
				anim = true,
				var = "SetPointLeft",
				speed = 15,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DoorsCloseConfirmSet",
			x = 211,
			y = 91,
			radius = 10,
			tooltip = "Clear door closed alarm",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_orange.mdl",
				z = -2,
				ang = 0,
				anim = true,
				var = "DoorsCloseConfirm",
				speed = 15,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SetPointRightSet",
			x = 241.4,
			y = 90.5,
			radius = 10,
			tooltip = "Set track point to right",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_arrow_left.mdl",
				z = -4,
				ang = 90,
				anim = true,
				var = "SetPointRight",
				speed = 15,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "BlinkerLeftSet",
			x = 260,
			y = 88,
			radius = 8,
			tooltip = "Indicators Left",
			model = {
				z = 0,
				ang = 0,
				var = "BlinkerLeft",
				speed = 15,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "BlinkerRightSet",
			x = 280,
			y = 88,
			radius = 8,
			tooltip = "Indicators Right",
			model = {
				z = 0,
				ang = 0,
				var = "BlinkerRight",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "BlinkerSwitch",
			x = 271,
			y = 91,
			radius = 0.1,
			tooltip = "Indicator Switch",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = 0,
				ang = 45,
				getfunc = function( ent ) return ent:GetNW2Float( "BlinkerStatus" ) end,
				var = "BlinkerStatus",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "PantographLowerSet",
			x = 303.5,
			y = 91,
			radius = 8,
			tooltip = "Lower Pantograph",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
				anim = true,
				z = -5,
				ang = 0,
				var = "PantographLower",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "PantographRaiseSet",
			x = 303.5,
			y = 58,
			radius = 8,
			tooltip = "Raise Pantograph",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				anim = true,
				z = -5,
				ang = 0,
				var = "PantographRaise",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "ThrowCouplerSet",
			x = 335,
			y = 90.8,
			radius = 10,
			tooltip = "Throw Coupler",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl",
				z = -5,
				ang = 0,
				var = "ThrowCoupler",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Door1Set",
			x = 364,
			y = 91,
			radius = 10,
			tooltip = "Open only door 1",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_red.mdl",
				z = -5,
				ang = 0,
				var = "OpenDoor1",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "MalfunctionLamp",
			x = 364,
			y = 57.7,
			radius = 10,
			tooltip = "Malfunction detected",
			model = {
				lamp = {
					var = "DepartureBlocked",
					z = 0,
					anim = true,
					lcolor = Color( 129, 0, 0 ),
					lz = 12,
					lbright = 3,
					lfov = 130,
					lfar = 16,
					lnear = 8,
					lshadows = 0
				},
				model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
				z = -5,
				ang = 0,
				var = "Malfunction",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SandLamp",
			x = 431,
			y = 90,
			radius = 10,
			tooltip = "Sander indicator",
			model = {
				lamp = {
					var = "Sand",
					z = 0,
					anim = true,
					lcolor = Color( 129, 0, 0 ),
					lz = 12,
					lbright = 3,
					lfov = 130,
					lfar = 16,
					lnear = 8,
					lshadows = 0
				},
				model = "models/lilly/uf/u2/cab/button_bulge_red.mdl",
				z = -7,
				ang = 0,
				var = "Sand",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SanderToggle",
			x = 561,
			y = 112,
			radius = 10,
			tooltip = "Toggle sanding",
			model = {
				model = "models/lilly/uf/common/cab/button_red.mdl",
				z = -2,
				ang = 0,
				var = "Sander",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "UnlockDoorsSet",
			x = 396.4,
			y = 57.7,
			radius = 10,
			tooltip = "Toggle doors unlock",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_red.mdl",
				z = -5,
				ang = 180,
				var = "UnlockDoors",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DoorSideSelectToggle",
			x = 396.5,
			y = 17.8,
			radius = 10,
			tooltip = "Door Unlock Side Switch",
			model = {
				model = "models/lilly/uf/u2/cab/battery_switch.mdl",
				z = -2.5,
				ang = 45,
				getfunc = function( ent ) return ent:GetPackedBool( "DoorsSelectLeft", false ) and 1 or ent:GetPackedBool( "DoorsSelectRight", false ) and 0 or 0.5 end,
				var = "DoorSideSelect",
				speed = 5,
				vmin = 0,
				vmax = 1,
				sndvol = 50,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DoorsLockSet",
			x = 396,
			y = 91,
			radius = 10,
			tooltip = "Set doors to close",
			model = {
				model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
				z = -5,
				ang = 0,
				var = "DoorsLock",
				speed = 20,
				vmin = 0,
				vmax = 1,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		}
	}
}

ENT.ButtonMapMPLR[ "BOStrab" ] = {
	pos = Vector( 422, -33, 55.2 ),
	ang = Angle( 0, -122, 0 ),
	width = 90,
	height = 150,
	scale = 0.069,
	buttons = {
		{
			ID = "OpenBOStrab",
			x = 0,
			y = 0,
			w = 90,
			h = 150,
			radius = 1,
			tooltip = "Read up on the Light Rail Operation Ordinance",
			model = {
				var = "OpenBOStrab",
				sndvol = 1,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 )
			}
		}
	}
}

ENT.ButtonMapMPLR[ "IBISKey" ] = {
	pos = Vector( 416, -19.4, 57.4 ),
	ang = Angle( 0, -45, 90 ),
	width = 10,
	height = 10,
	scale = 0.069,
	buttons = {
		{
			ID = "IBISkeyTurnSet",
			x = 0,
			y = 0,
			w = 10,
			h = 10,
			radius = 1,
			tooltip = "Turn IBIS key",
			model = {
				var = "TurnIBISKey",
				sndvol = 1,
				snd = function( val ) return val and "door_cab_open" or "door_cab_close" end,
				sndmin = 90,
				sndmax = 1e3,
				sndang = Angle( -90, 0, 0 )
			}
		}
	}
}

--[[ENT.ButtonMapMPLR["Lefthand"] = {
pos = Vector(532.6,-19.2,83.09),
ang = Angle(0,90,0),
width = 112,
height = 25,
scale = 0.04,
}]]
ENT.ButtonMapMPLR[ "IBISScreen" ] = {
	pos = Vector( 419.74, -12.76, 60.35 ),
	ang = Angle( 0, -135.45, 48.5 ), -- (0,44.5,-47.9),
	width = 117,
	height = 29.9,
	scale = 0.0311
}

ENT.ButtonMapMPLR[ "IBIS" ] = {
	pos = Vector( 415.2, -18, 61 ),
	ang = Angle( 48, -225, 0 ),
	width = 100,
	height = 210,
	scale = 0.04,
	buttons = {
		{
			ID = "Number1Set",
			x = 28,
			y = 60,
			radius = 10,
			tooltip = "1/RBL/Radio",
			var = "Number1Set",
			model = {
				min = 0,
				max = 1,
				var = "Number1",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number2Set",
			x = 28,
			y = 42,
			radius = 10,
			tooltip = "2/Special Character",
			model = {
				z = 0,
				ang = 0,
				var = "Number2",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number3Set",
			x = 28,
			y = 24,
			radius = 10,
			tooltip = "3/Advance current stop silently",
			model = {
				z = 0,
				ang = 0,
				var = "Number3",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number4Set",
			x = 46,
			y = 60,
			radius = 10,
			tooltip = "4",
			model = {
				z = 0,
				ang = 0,
				var = "Number4",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number5Set",
			x = 46,
			y = 42,
			radius = 10,
			tooltip = "5",
			model = {
				z = 0,
				ang = 0,
				var = "Number5",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number6Set",
			x = 46,
			y = 24,
			radius = 10,
			tooltip = "6/Rewind current stop silently",
			model = {
				z = 0,
				ang = 0,
				var = "Number6",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number7Set",
			x = 65,
			y = 60,
			radius = 10,
			tooltip = "7/Route",
			model = {
				z = 0,
				ang = 0,
				var = "Number7",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number8Set",
			x = 65,
			y = 42,
			radius = 10,
			tooltip = "8/Disable Passenger Information System",
			model = {
				z = 0,
				ang = 0,
				var = "Number8",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number9Set",
			x = 65,
			y = 24,
			radius = 10,
			tooltip = "9/Announce stop manually",
			model = {
				z = 0,
				ang = 0,
				var = "Number9",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DeleteSet",
			x = 85,
			y = 60,
			radius = 10,
			tooltip = "Delete",
			model = {
				z = 0,
				ang = 0,
				var = "Delete",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "Number0Set",
			x = 85,
			y = 42,
			radius = 10,
			tooltip = "0/Line/Course",
			model = {
				z = 0,
				ang = 0,
				var = "Number0",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "EnterSet",
			x = 85,
			y = 24,
			radius = 10,
			tooltip = "Confirm",
			model = {
				z = 0,
				ang = 0,
				var = "Enter",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "TimeAndDateSet",
			x = 85,
			y = 78,
			radius = 10,
			tooltip = "Set time and date",
			model = {
				z = 0,
				ang = 0,
				var = "TimeAndDate",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "ServiceAnnouncementSet",
			x = 85,
			y = 96,
			radius = 10,
			tooltip = "Service Annoucements",
			model = {
				z = 0,
				ang = 0,
				var = "ServiceAnnouncement",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "DestinationSet",
			x = 65,
			y = 78,
			radius = 10,
			tooltip = "Destination",
			model = {
				z = 0,
				ang = 0,
				var = "Destination",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 0.5,
				snd = function( val ) return val and "IBIS_beep" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		}
	}
}

ENT.ButtonMapMPLR[ "Microphone" ] = {
	pos = Vector( 417.4, 0.6, 73 ),
	ang = Angle( 120, -10, 184 ),
	width = 50,
	height = 50,
	scale = 0.0625,
	buttons = {
		{
			ID = "ComplaintSet",
			x = 10,
			y = 10,
			z = 0,
			w = 5,
			h = 5,
			radius = 90,
			tooltip = "Activate Driver's Rage"
		}
	}
}

ENT.ButtonMapMPLR[ "Rollsign" ] = {
	pos = Vector( 424.5, -25, 109 ),
	ang = Angle( 0, 90, 90 ),
	width = 780,
	height = 160,
	scale = 0.0625,
	buttons = {}
}

-- {ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
-- {ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
ENT.ButtonMapMPLR[ "Blinds" ] = {
	pos = Vector( 415, 40, 100 ),
	ang = Angle( 0, 280, 90 ),
	width = 50,
	height = 800,
	scale = 0.0625,
	buttons = {
		{
			ID = "Blinds+",
			x = 000,
			y = 200,
			w = 50,
			h = 205,
			tooltip = "Pull the blinds up"
		},
		{
			ID = "Blinds-",
			x = 0,
			y = 400,
			w = 50,
			h = 205,
			tooltip = "Pull the blinds down"
		}
	}
}

ENT.ButtonMapMPLR[ "CabWindowL" ] = {
	pos = Vector( 397, 45, 95 ),
	ang = Angle( 0, 0, 90 ),
	width = 300,
	height = 600,
	scale = 0.0625,
	buttons = {
		{
			ID = "CabWindowL+",
			x = 000,
			y = 200,
			w = 300,
			h = 205,
			tooltip = "Pull the Window up"
		},
		{
			ID = "CabWindowL-",
			x = 0,
			y = 400,
			w = 300,
			h = 205,
			tooltip = "Pull the window down"
		}
	}
}

ENT.ButtonMapMPLR[ "CabWindowR" ] = {
	pos = Vector( 415, -45, 95 ),
	ang = Angle( 0, 180, 90 ),
	width = 300,
	height = 600,
	scale = 0.0625,
	buttons = {
		{
			ID = "CabWindowR+",
			x = 000,
			y = 200,
			w = 300,
			h = 205,
			tooltip = "Pull the Window up"
		},
		{
			ID = "CabWindowR-",
			x = 0,
			y = 400,
			w = 300,
			h = 205,
			tooltip = "Pull the window down"
		}
	}
}

ENT.ButtonMapMPLR[ "Left" ] = {
	pos = Vector( 415, 30, 56 ),
	ang = Angle( 0, 180, 0 ),
	width = 160,
	height = 80,
	scale = 0.1,
	buttons = {
		{
			ID = "ParrallelToggle",
			x = 27,
			y = 29.5,
			radius = 7,
			tooltip = "Set engines to shunt mode (not yet implemented)",
			model = {
				model = "models/lilly/uf/u2/cab/switch_flick.mdl",
				z = -2,
				ang = 90,
				var = "ParrallelToggle",
				speed = 1,
				vmin = 0,
				vmax = 1,
				sndvol = 1,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "WarnBlinkToggle",
			x = 79.5,
			y = 70,
			radius = 7,
			tooltip = "Set indicators to warning mode",
			model = {
				speed = 10,
				model = "models/lilly/uf/u2/cab/switch_flick.mdl",
				z = -3,
				ang = 180,
				var = "WarnBlink",
				sndvol = 1,
				snd = function( val, val2 ) return val and "switch_panel_up" or val2 and "switch_panel_down" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "ReduceBrakeSet",
			x = 42.8,
			y = 10,
			radius = 7,
			tooltip = "Reduce track brake intensity",
			model = {
				model = "models/lilly/uf/u2/cab/button_indent_white.mdl",
				z = -3,
				ang = 0,
				var = "ReduceBrake",
				speed = 10,
				vmin = 0,
				vmax = 1,
				sndvol = 1,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		}
	}
}

ENT.RTMaterialMPLR = CreateMaterial( "MetrostroiRT1", "VertexLitGeneric", {
	[ "$vertexcolor" ] = 0,
	[ "$vertexalpha" ] = 1,
	[ "$nolod" ] = 1
} )

function ENT:Draw()
	self.BaseClass.Draw( self )
end

function ENT:DrawPost()
	self.RTMaterialMPLR:SetTexture( "$basetexture", self.IBIS )
	self:DrawOnPanel( "IBISScreen", function( ... )
		surface.SetMaterial( self.RTMaterialMPLR )
		surface.SetDrawColor( 0, 65, 11 )
		surface.DrawTexturedRectRotated( 59, 16, 116, 25, 0 )
	end )

	local mat = self.Rollsign
	self:DrawOnPanel( "Rollsign", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat )
		surface.DrawTexturedRectUV( 0, 0, 780, 160, 0, self.RollsignPos, 1, self.RollsignPos + 0.015 )
	end )
end

function ENT:OnPlay( soundid, location )
	if location == "stop" then
		if IsValid( self.Sounds[ soundid ] ) then
			self.Sounds[ soundid ]:Pause()
			self.Sounds[ soundid ]:SetTime( 0 )
		end
		return
	end
end

function ENT:UpdateWagonNumber()
	-- self:ShowHide("TrainNumberL"..i,i<count)
	-- self:ShowHide("TrainNumberR"..i,i<count)
	-- if i< count then
	local leftNum, middleNum, rightNum = self.ClientEnts[ "carnumber1" ], self.ClientEnts[ "carnumber2" ], self.ClientEnts[ "carnumber3" ]
	local intnum1, intnum2, intnum3 = self.ClientEnts[ "carnumber1int" ], self.ClientEnts[ "carnumber2int" ], self.ClientEnts[ "carnumber3int" ]
	local num1 = tonumber( string.sub( self:GetNW2Int( "WagonNumber" ), 1, 1 ), 10 )
	local num2 = tonumber( string.sub( self:GetNW2Int( "WagonNumber" ), 2, 2 ), 10 )
	local num3 = tonumber( string.sub( self:GetNW2Int( "WagonNumber" ), 3, 3 ), 10 )
	if IsValid( intnum1 ) then
		if num1 < 1 then
			intnum1:SetSkin( 10 )
		else
			intnum1:SetSkin( num1 )
		end
	end

	if IsValid( intnum2 ) then
		if num2 < 1 then
			intnum2:SetSkin( 0 )
		else
			intnum2:SetSkin( num2 )
		end
	end

	if IsValid( intnum3 ) then
		if num3 < 1 then
			intnum3:SetSkin( 10 )
		else
			intnum3:SetSkin( num3 )
		end
	end

	if IsValid( leftNum ) then
		if num1 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			leftNum:SetSkin( 10 )
		elseif num1 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			leftNum:SetSkin( 11 )
		elseif num1 > 0 and self:GetNW2String( "Texture" ) == "OrEbSW" then
			leftNum:SetSkin( num1 + 10 )
		else
			leftNum:SetSkin( num1 )
		end
	end

	if IsValid( middleNum ) then
		if num2 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			middleNum:SetSkin( 10 )
		elseif num2 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			middleNum:SetSkin( 11 )
		elseif num2 > 0 and self:GetNW2String( "Texture" ) == "OrEbSW" then
			middleNum:SetSkin( num2 + 10 )
		else
			middleNum:SetSkin( num2 )
		end
	end

	if IsValid( rightNum ) then
		if num3 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			rightNum:SetSkin( 10 )
		elseif num3 < 1 and self:GetNW2String( "Texture" ) ~= "OrEbSW" then
			rightNum:SetSkin( 11 )
		elseif num3 > 0 and self:GetNW2String( "Texture" ) == "OrEbSW" then
			rightNum:SetSkin( num3 + 10 )
		else
			rightNum:SetSkin( num3 )
		end
	end

	if IsValid( self.SectionB ) and self.SectionB.UpdateWagonNumber then self.SectionB:UpdateWagonNumber() end
end

function ENT:Initialize()
	self.BaseClass.Initialize( self )
	self.RollsignPos = 0
	self.ScrollModifier = 0
	self.IBIS = self:CreateRT( "IBIS", 512, 128 )
	self.DoorSwitchStates = {
		[ "Left" ] = 1,
		[ "None" ] = 0.5,
		[ "Right" ] = 0
	}

	self.Locked = 0
	self.EngineSNDConfig = {}
	self.SoundNames = {}
	self.SoundNames[ "loop_main" ] = "lilly/uf/u2/engineloop_test.mp3"
	self.SoundNames[ "loop_secondary" ] = "lilly/uf/u2/engineloop_test.mp3"
	self.MotorPowerSound = 0
	self.CabLight = 0
	self.SpeedoAnim = 0
	self.VoltAnim = 0
	self.AmpAnim = 0
	self.Microphone = false
	self.BlinkerTicked = false
	self.DoorOpenSoundPlayed = false
	self.DoorCloseSoundPlayed = false
	self.DoorsOpen = false
	self.ArmDoorCloseAlarm = false
	self.CamshaftMadeSound = false
	self.AnnouncementTriggered = false
	self.ThrottleLastEngaged = 0
	self.IBISBootCompleted = false
	self.IBISBeep = false
	self.BatteryBreakerOnSoundPlayed = false
	self.BatteryBreakerOffSoundPlayed = false
	self.BlinkerPrevOn = false
	self.WarningAnnouncement = false
	self.CabWindowL = 0
	self.CabWindowR = 0
	-- self.LeftMirror = self:CreateRT("LeftMirror",512,256)
	-- self.RightMirror = self:CreateRT("RightMirror",128,256)
	self.ScrollMoment = 0
	self.PrevTime = 0
	self.DeltaTime = 0
	self.MotorPowerSound = 0
	self.Nags = { "Nag1", "Nag2", "Nag3" }
	self.Speed = 0
	self.BatterySwitch = 0.5
	self:ShowHide( "reverser", true )
	self:ShowHide( "reverser", false )
	-- 
	self.Rollsign = Material( self:GetNW2String( "Rollsign", "models/lilly/uf/u2/rollsigns/frankfurt_stock.png" ) )
	if not IsValid( self.SectionB ) then self.BaseClass.InitSegments( self ) end
	self:UpdateWagonNumber()
end

function ENT:Think()
	self.BaseClass.Think( self )
	self:Mirror()
	self:Animations()
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	if self:GetNW2String( "Texture", "" ) == "SVB" then
		self:ShowHide( "carnumber1", false )
		self:ShowHide( "carnumber2", false )
		self:ShowHide( "carnumber3", false )
		if IsValid( self.SectionB ) then
			self.SectionB:ShowHide( "carnumber1", false )
			self.SectionB:ShowHide( "carnumber2", false )
			self.SectionB:ShowHide( "carnumber3", false )
			self.SectionB:ShowHide( "duewag_decal", false )
		end

		self:ShowHide( "duewag_decal", false )
	elseif self:GetNW2String( "Texture", "" ) == "OrEbSW" or self:GetNW2String( "Texture", "" ) == "OrEbSW_2" then
		local decal = self.ClientEnts[ "cab_decal" ]
		local duewag = self.ClientEnts[ "duewag_decal" ]
		local leftNum, middleNum, rightNum = self.ClientEnts[ "carnumber1" ], self.ClientEnts[ "carnumber2" ], self.ClientEnts[ "carnumber3" ]
		if IsValid( self.SectionB ) then local leftNum1, middleNum2, rightNum3 = self.SectionB.ClientEnts[ "carnumber1" ], self.SectionB.ClientEnts[ "carnumber2" ], self.SectionB.ClientEnts[ "carnumber3" ] end
		if IsValid( self.SectionB ) and IsValid( leftNum1 ) and IsValid( middleNum2 ) and IsValid( rightNum3 ) then
			leftNum1:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
			middleNum2:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
			rightNum3:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
		end

		if IsValid( self.SectionB ) and IsValid( self.SectionB.ClientEnts[ "cab_decal" ] ) and IsValid( self.SectionB.ClientEnts[ "duewag_decal" ] ) then
			local decal2 = self.SectionB.ClientEnts[ "cab_decal" ]
			local duewag2 = self.SectionB.ClientEnts[ "duewag_decal" ]
			decal2:SetPos( self:LocalToWorld( Vector( 0.17, 0, 8 ) ) )
			duewag2:SetPos( self:LocalToWorld( Vector( 0.17, 0, -18 ) ) )
		end

		if IsValid( leftNum ) and IsValid( middleNum ) and IsValid( rightNum ) then
			leftNum:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
			middleNum:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
			rightNum:SetPos( self:LocalToWorld( Vector( 0, 0, 9 ) ) )
		end

		if IsValid( decal ) and IsValid( duewag ) then
			decal:SetPos( self:LocalToWorld( Vector( -0.17, 0, 8 ) ) )
			duewag:SetPos( self:LocalToWorld( Vector( -0.17, 0, -18 ) ) )
		end
	else
		self:ShowHide( "carnumber1", true )
		self:ShowHide( "carnumber2", true )
		self:ShowHide( "carnumber3", true )
	end

	self.Speed = self:GetNW2Int( "Speed" )
	if self:GetPackedBool( "FlickBatterySwitchOn", false ) == true then
		self.BatterySwitch = 1
	elseif self:GetPackedBool( "FlickBatterySwitchOff", false ) == true then
		self.BatterySwitch = 0
	else
		self.BatterySwitch = 0.5
	end

	self:Animate( "Mirror_r", self:GetNW2Float( "Mirror_r", 0 ), 0, 100, 17, 1, 0 )
	self:Animate( "drivers_door", self:GetNW2Float( "DriversDoorState", 0 ), 0, 100, 1, 1, 0 )
	self:Animate( "blinds_l", self:GetNW2Float( "Blinds", 0 ), 0, 100, 50, 9, 0 )
	self:ShowHide( "RetroEquipment", self:GetNW2Bool( "RetroMode", false ) )
	if IsValid( self.SectionB ) then self.SectionB:ShowHide( "RetroEquipment", self:GetNW2Bool( "RetroMode", false ) ) end
	self.ThrottleStateAnim = self:GetNW2Float( "ThrottleStateAnim", 0 )
	if self.ThrottleStateAnim >= 0.5 then
		self:Animate( "Throttle", self.ThrottleStateAnim, -45, 45, 50, 8, false )
	elseif self.ThrottleStateAnim <= 0.5 then
		self:Animate( "Throttle", math.Clamp( self.ThrottleStateAnim, 0.09, 1 ), -45, 45, 50, 8, false )
	end

	if self:GetPackedBool( "BOStrab", false ) == true then gui.OpenURL( "https://lillywho.github.io" ) end
	if self:GetNW2Bool( "IBISKeyBeep", false ) == true then
		if self.IBISBeep == false then
			self.IBISBeep = true
			self:PlayOnce( "IBIS_beep", "cabin", 0.6, 1 )
		end
	else
		self.IBISBeep = false
	end

	if self:GetNW2String( "ServiceAnnouncement", "" ) ~= "" then
		----print(self:GetNW2String("ServiceAnnouncement",""))
		if self.AnnouncementPlayed == false then
			self.AnnouncementPlayed = true
			self:PlayOnceFromPos( "PSA", self:GetNW2String( "ServiceAnnouncement" ), 1, 1, 1, 2, Vector( 293, 44, 102 ) )
			self:PlayOnceFromPos( "PSA2", self:GetNW2String( "ServiceAnnouncement" ), 1, 1, 1, 2, Vector( 293, -44, 102 ) )
		end
	else
		self.AnnouncementPlayed = false
	end

	self:Animate( "reverser", self:GetNW2Float( "ReverserAnimate" ), 0, 100, 50, 9, false )
	self.CabWindowL = self:GetNW2Float( "CabWindowL", 0 )
	self.CabWindowR = self:GetNW2Float( "CabWindowR", 0 )
	self:Animate( "window_cab_r", self:GetNW2Float( "CabWindowR", 0 ), 0, 100, 50, 9, false )
	self:Animate( "window_cab_l", self:GetNW2Float( "CabWindowL", 0 ), 0, 100, 50, 9, false )
	-- player:PrintMessage(HUD_PRINTTALK,self:GetNW2Float("CabWindowL",0))
	self:ShowHide( "IBISkey", self:GetNW2Bool( "InsertIBISKey", false ) )
	self:Animate( "IBISkey", self:GetNW2Bool( "TurnIBISKey", false ) == true and 0 or 1, 0, 100, 800, 0, 0 )
	self:ShowHide( "reverser", self:GetNW2Bool( "ReverserInsertedA", false ) )
	-----------------------------------------------------------------------
	local Door1a = self:GetNW2Float( "Door1a", 1 )
	local Door2a = self:GetNW2Float( "Door2a", 1 )
	local Door3b = self:GetNW2Float( "Door3a", 1 )
	local Door4b = self:GetNW2Float( "Door4a", 1 )
	self:Animate( "Door_fr2", Door1a, 0, 100, 100, 10, 0 )
	self:Animate( "Door_fr1", Door1a, 0, 100, 100, 10, 0 )
	self:Animate( "Door_rr2", Door2a, 0, 100, 100, 10, 0 )
	self:Animate( "Door_rr1", Door2a, 0, 100, 100, 10, 0 )
	self:Animate( "Door_fl2", Door4b, 0, 100, 100, 10, 0 )
	self:Animate( "Door_fl1", Door4b, 0, 100, 100, 10, 0 )
	self:Animate( "Door_rl2", Door3b, 0, 100, 100, 10, 0 )
	self:Animate( "Door_rl1", Door3b, 0, 100, 100, 10, 0 )
	----------------------------------------------------------
	if self:GetNW2Bool( "Microphone", false ) == true and self.Microphone == false then
		self.Microphone = true
		self:PlayOnce( self.Nags[ 1 ], "cabin", 1, 1 )
	end

	if self:GetNW2Bool( "Microphone", false ) == false then self.Microphone = false end
	if self:GetNW2Bool( "CamshaftMoved", false ) == true and self.CamshaftMadeSound == false then
		self.CamshaftMadeSound = true
		self:PlayOnce( "Switchgear" .. math.random( 1, 7 ), "cabin", 0.2, 1 )
	else
		self.CamshaftMadeSound = false
	end

	----print(self.CamshaftMadeSound)
	self:ShowHide( "headlights_on", self:GetPackedBool( "Headlights", false ), 0 )
	if IsValid( self.SectionB ) then self.SectionB:ShowHide( "headlights_on", self:GetPackedBool( "Headlights", false ), 0 ) end
	if self:GetNW2Bool( "BlinkerShineLeft", false ) == true then
		self:SetLightPower( 11, true )
	else
		self:SetLightPower( 11, false )
	end

	self.SpeedoAnim = math.Clamp( self:GetNW2Int( "Speed" ), 0, 80 ) / 100 * 1.5
	self:Animate( "Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0 )
	-- self:Animate("Throttle", 0, -45, 45, 3, false, false)
	local alarm = self:GetNW2Bool( "DepartureAlarm", false )
	self:SetSoundState( "DoorsCloseAlarm", alarm and 80 or 0, 1 )
	local deadman = self:GetNW2Bool( "DeadmanAlarmSound", false )
	self:SetSoundState( "Deadman", deadman and 1 or 0, 1 )
	self.VoltAnim = self:GetNWFloat( "BatteryCharge", 0 ) / 46
	self:Animate( "Voltage", self.VoltAnim, 0, 100, 1, 0, false )
	self.AmpAnim = self:GetNWFloat( "Amps", 0 ) / 0.5 * 100
	self:Animate( "Amps", self.AmpAnim, 0, 100, 1, 0, false )
	----print(self.AmpAnim)
	if self:GetNW2Bool( "Cablight", false ) == true then
		self:Animate( "DriverLightSwitch", 1, 0, 100, 100, 10, false )
	else
		self:Animate( "DriverLightSwitch", 0.5, 0, 100, 100, 10, false )
	end

	if self:GetNW2Bool( "BatteryOn", false ) == true then
		if self:GetNW2Bool( "Cablight", false ) == true then --[[self:GetNW2Bool("BatteryOn",false) == true]]
			self:SetLightPower( 6, true )
			self:SetLightPower( 16, true )
		elseif self:GetNW2Bool( "Cablight", false ) == false then
			self:SetLightPower( 6, false )
			self:SetLightPower( 16, false )
		end

		if self:GetNW2Bool( "Bell", false ) == true then
			self:SetSoundState( "bell", 1, 1 )
			self:SetSoundState( "bell_in", 1, 1 )
		else
			self:SetSoundState( "bell", 0, 1 )
			self:SetSoundState( "bell_in", 0, 1 )
		end

		if self:GetNW2Bool( "EmergencyBrake", false ) == true then self:Animate( "Throttle", -1, -45, 45, 50, 8, false ) end
		self:SetSoundState( "horn", self:GetNW2Bool( "Horn", false ) and 1 or 0, 1 )
		if self:GetNW2Bool( "BlinkerTick", false ) == true and self.BlinkerTicked == false then
			self:PlayOnce( "Blinker", "cabin", 5, 1 )
			-- self:SetNW2Bool("BlinkerTicked",true)
			self.BlinkerTicked = true
		elseif self:GetNW2Bool( "BlinkerTick", false ) == false then
			-- self:SetNW2Bool("BlinkerTicked",false)
			-- self:SetSoundState("Blinker",1,1,1)
			-- self:SetNW2Bool("BlinkerTick",false)
			self.BlinkerTicked = false
		end

		-- Fan handler
		if self:GetNW2Bool( "Fans", false ) == true and self:GetNW2Bool( "BatteryOn", false ) == true then
			self:SetSoundState( "Fan1", 1, 1, 1 )
			self:SetSoundState( "Fan2", 1, 1, 1 )
			self:SetSoundState( "Fan3", 1, 1, 1 )
		end

		if self:GetNW2Bool( "Fans", false ) == false and self:GetNW2Bool( "BatteryOn", false ) == true then
			----print("fans low")
			self:SetSoundState( "Fan1", 0.4, 1, 0 )
			self:SetSoundState( "Fan2", 0.4, 1, 0 )
			self:SetSoundState( "Fan3", 0.4, 1, 0 )
		elseif self:GetNW2Bool( "Fans", false ) == false and self:GetNW2Bool( "BatteryOn", false ) == false or self:GetNW2Bool( "Fans", false ) == true and self:GetNW2Bool( "BatteryOn", false ) == false then
			self:SetSoundState( "Fan1", 0, 1, 1 )
			self:SetSoundState( "Fan2", 0, 1, 1 )
			self:SetSoundState( "Fan3", 0, 1, 1 )
		end

		if self:GetNW2Bool( "IBISBootupComplete", false ) == true and self:GetNW2Bool( "IBISChime", false ) == true and self.IBISBootCompleted == false then
			self.IBISBootCompleted = true
			self:PlayOnce( "IBIS_bootup", Vector( 412, -12, 55 ), 0.4, 1 )
		end

		if self:GetNW2Bool( "IBISError", false ) and not self.IBISErrorPlayed then
			self.IBISErrorPlayed = true
			self:PlayOnce( "IBIS_error", Vector( 412, -12, 55 ), 0.4, 1 )
		elseif not self:GetNW2Bool( "IBISError", false ) then
			self.IBISErrorPlayed = false
		end

		self.BatteryBreakerOffSoundPlayed = false
		if self.StartupSoundPlayed == false then
			self.StartupSoundPlayed = true
			-- self:PlayOnce("Startup","cabin",0.4,1)
			self:PlayOnce( "Battery_breaker", "cabin", 20, 1 )
		end

		if self:GetPackedBool( "WarningAnnouncement" ) == true then self:PlayOnce( "Keep Clear", Vector( 350, -30, 113 ), 0.8, 1 ) end
	elseif self:GetNW2Bool( "BatteryOn", false ) == false then
		-- what shall we do when the battery is off
		self.StartupSoundPlayed = false
		if self.BatteryBreakerOffSoundPlayed == false then
			self.BatteryBreakerOffSoundPlayed = true
			self:PlayOnce( "Battery_breaker_off", "cabin", 1, 1 )
		end
	end

	self:SetLightPower( 9, true )
	self:SetLightPower( 10, true )
	local headlights = self:GetNW2Float( "HeadlightStatus", 0 )
	if self.Lights then
		if headlights > 0 then
			self:SetLightPower( 1, false )
			self:SetLightPower( 2, false )
			self:SetLightPower( 4, false )
			self:SetLightPower( 5, false )
			self.Lights[ 1 ][ "farz" ] = 600
			self.Lights[ 2 ][ "farz" ] = 600
			self:SetLightPower( 1, true )
			self:SetLightPower( 2, true )
			self:SetLightPower( 4, false )
			self:SetLightPower( 5, false )
		elseif headlights > 0.5 then
			self:SetLightPower( 1, false )
			self:SetLightPower( 2, false )
			self:SetLightPower( 4, false )
			self:SetLightPower( 5, false )
			self.Lights[ 1 ][ "farz" ] = 800
			self.Lights[ 2 ][ "farz" ] = 800
			self:SetLightPower( 1, true )
			self:SetLightPower( 2, true )
			self:SetLightPower( 4, false )
			self:SetLightPower( 5, false )
		else
			self:SetLightPower( 1, false )
			self:SetLightPower( 2, false )
			self:SetLightPower( 4, false )
			self:SetLightPower( 5, false )
		end
	end
end

function ENT:U2SoundEngine()
	self:SetSoundState( "Cruise", Lerp( self.Speed, 0, 1 ), 1, 1, 1 )
	self:SetSoundState( "rumb1", Lerp( self.Speed, 0, 1 ), 1, 1, 1 )
end

function ENT:Animations()
	self:RollsignTracker()
end

function ENT:OnAnnouncer( volume )
	return self:GetPackedBool( "AnnPlay" ) and volume or 0
end

MPLR.GenerateClientProps()