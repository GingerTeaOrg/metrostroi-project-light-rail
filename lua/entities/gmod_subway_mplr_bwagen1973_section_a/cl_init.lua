include( "shared.lua" )
ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}
ENT.ButtonMapMPLR[ "IBISScreen" ] = {
	pos = Vector( 511.85, -4.1, 74.93 ),
	ang = Angle( 0, -90, 35 ),
	width = 123,
	height = 29.9,
	scale = 0.0311
}

ENT.ClientProps[ "empty_button" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector( -0.1, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "empty_button2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector( -0.1, -7.1, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "empty_button3" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector( -0.1, -6.1, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "empty_button4" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector( 2.45, -7.1, 0.25 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "empty_button5" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector( 2.45, -6.1, 0.25 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "headlights_lit" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/headlights_lit.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "destination_frame" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/destination_frame.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_opener" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_opener.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_button" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_button.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "int" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/int-essen.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "seats" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/seats-essen.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "bumper" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/bumper.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "floor" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/floor.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_rr1" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_rr2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_fr1" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector( 184, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_fr2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector( 184, 0, 0 ),
	ang = Angle( 0, 0, 0 )
}

ENT.ClientProps[ "door_fl2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector( 409, 0, 0 ),
	ang = Angle( 0, 180, 0 )
}

ENT.ClientProps[ "door_fl1" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector( 409, 0, 0 ),
	ang = Angle( 0, 180, 0 )
}

ENT.ClientProps[ "door_rl1" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector( 225, 0, 0 ),
	ang = Angle( 0, 180, 0 )
}

ENT.ClientProps[ "door_rl2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector( 225, 0, 0 ),
	ang = Angle( 0, 180, 0 )
}

ENT.ClientProps[ "door1_r" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_r.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 00, 0 )
}

ENT.ClientProps[ "step1_r" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_small.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 00, 0 )
}

ENT.ClientProps[ "door1_l" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_l.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 00, 0 )
}

ENT.ClientProps[ "throttle" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/throttle.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "reverser" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/reverser.mdl",
	pos = Vector( -0.5, 0, 0 ),
	ang = Angle( 0, 00, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_rr" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 00, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_fr" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector( 183.8, 0, 0 ),
	ang = Angle( 0, 00, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_fl" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector( 408, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_rl" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector( 224, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "step_tray" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 00, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "step_tray2" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector( 184, 0, 0 ),
	ang = Angle( 0, 00, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "key_ignition" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/key.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "step_tray3" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector( 224, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "step_tray4" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector( 408, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_small_r" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_r.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "foldingstep_small_l" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_l.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ClientProps[ "mirror_l" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/mirror_l.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "mirror_r" ] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/mirror_r.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ButtonMapMPLR[ "dashboard" ] = {
	pos = Vector( 508, 16.9, 72 ),
	ang = Angle( 0, -90, 0 ),
	width = 490,
	height = 92,
	scale = 0.069,
	buttons = {
		{
			ID = "PantographOffSet",
			x = 70,
			y = 62,
			radius = 10,
			tooltip = "Lower Pantograph",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_lower_panto.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "PantographOff",
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
			ID = "PantographOnSet",
			x = 55,
			y = 62,
			radius = 10,
			tooltip = "Raise Pantograph",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_raise_panto.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "PantographOn",
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
			ID = "BatterySet",
			x = 85,
			y = 62,
			radius = 10,
			tooltip = "Close Main Circuit Breaker",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_breaker_on.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "Battery",
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
			ID = "BatteryDisableSet",
			x = 100,
			y = 62,
			radius = 10,
			tooltip = "Open Main Circuit Breaker",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_breaker_off.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "CircuitOff",
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
			ID = "StopRequestIndicator",
			x = 115,
			y = 62,
			radius = 10,
			tooltip = "Stop Request Indicator",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_stop_brake.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "StopRequest",
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
			ID = "DoorsUnlockToggle",
			x = 130,
			y = 62,
			radius = 10,
			tooltip = "Unlock Doors",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_unlock.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "DoorsUnlock",
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
		--------------------------------------------------------
		{
			ID = "WiperConstantSet",
			x = 70,
			y = 24,
			radius = 10,
			tooltip = "Wipers to full service",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_wiper_constant.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "WiperConstant",
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
			ID = "WiperIntervalSet",
			x = 55,
			y = 24,
			radius = 10,
			tooltip = "Wipers to interval",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_wiper_interval.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "WiperInterval",
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
			ID = "WindowWasherSet",
			x = 85,
			y = 25,
			radius = 10,
			tooltip = "Window Washer",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_window_washer.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "WindowWasher",
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
			ID = "MirrorLeftToggle",
			x = 100,
			y = 25,
			radius = 10,
			tooltip = "Mirror Left",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_mirror_left.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "MirrorLeft",
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
			ID = "MirrorRightToggle",
			x = 115,
			y = 25,
			radius = 10,
			tooltip = "Mirror Right",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_mirror_right.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "MirrorRight",
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
			ID = "DoorUnblockStatus",
			x = 130,
			y = 25,
			radius = 10,
			tooltip = "Door Unblock Status",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_undo_door_unlock.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "RevokeDoors",
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
		--------------------------------------------------------------------------------------------------------
		{
			ID = "EmergencyBrakeDisableSet",
			x = 173,
			y = 24.5,
			radius = 10,
			tooltip = "Bypass Emergency Brake",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_emergency_brake.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "EmergencyBrakeDisable",
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
			ID = "Door1Toggle",
			x = 187.5,
			y = 24.5,
			radius = 10,
			tooltip = "Open Door 1",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_1.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "Door1",
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
			ID = "DoorsForceCloseSet",
			x = 202,
			y = 24.5,
			radius = 10,
			tooltip = "Force Close Doors",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_force_close.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "DoorsForceClose",
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
			ID = "DoorsForceOpenSet",
			x = 216.5,
			y = 24.5,
			radius = 10,
			tooltip = "Force Open Doors",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_force_open.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "DoorsForceOpen",
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
			ID = "LightsSet",
			x = 231,
			y = 24.5,
			radius = 10,
			tooltip = "Lights?",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_light.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "Lights",
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
			ID = "ButtonDefectSet",
			x = 245.5,
			y = 24.5,
			radius = 10,
			tooltip = "Defect Present in Train",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_defect.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "Defect",
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
		-----------------------------------------------------------------------
		{
			ID = "DoorsSelectLeftToggle",
			x = 173,
			y = 62,
			radius = 10,
			tooltip = "Select Left Side Doors",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_left.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "DoorsSelectLeft",
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
			ID = "DoorsSelectRightToggle",
			x = 187.5,
			y = 62,
			radius = 10,
			tooltip = "Select Right Side Doors",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_right.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "DoorsSelectRight",
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
		-----empty gap
		{
			ID = "StepsLowestSet",
			x = 216.5,
			y = 62,
			radius = 10,
			tooltip = "Set Steps To Road Level",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_lowest.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "StepsLowest",
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
			ID = "StepsLowSet",
			x = 231,
			y = 62,
			radius = 10,
			tooltip = "Set Steps To Low Platform",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_low.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "StepsLow",
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
			ID = "StepsHighSet",
			x = 245.5,
			y = 62,
			radius = 10,
			tooltip = "Set Steps To High Floor Platform",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_high.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "StepsHigh",
				speed = 20,
				vmin = 0,
				vmax = 1,
				getfunc = function( ent ) return ent:GetNW2Bool( "StepsHigh" ) and 1 or 0 end,
				sndvol = 20,
				snd = function( val ) return val and "button_on" or "button_off" end,
				sndmin = 80,
				sndmax = 1e3 / 3,
				sndang = Angle( -90, 0, 0 )
			}
		},
		{
			ID = "SwitchLeftToggle",
			x = 320,
			y = 62,
			radius = 10,
			tooltip = "Override next point to left",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_switching_left.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "SwitchLeft",
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
			ID = "SwitchRightToggle",
			x = 335,
			y = 62,
			radius = 10,
			tooltip = "Override next point to right",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_switching_right.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "SwitchRight",
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
			ID = "BlinkerLeftToggle",
			x = 350,
			y = 62,
			radius = 10,
			tooltip = "Set the indicators to left turn",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_blinker_left.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
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
			ID = "BlinkerRightToggle",
			x = 365,
			y = 62,
			radius = 10,
			tooltip = "Set the indicators to right turn",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_blinker_right.mdl",
				z = -2.5,
				ang = 90,
				anim = true,
				var = "BlinkerRight",
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
		-----------------------------------------------------------
		{
			ID = "LightsOnSet",
			x = 320,
			y = 25,
			radius = 10,
			tooltip = "Lights On",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_lights_on.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "LightsOn",
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
			ID = "LightsOffSet",
			x = 335,
			y = 25,
			radius = 10,
			tooltip = "Lights Off",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_lights_off.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "LightsOff",
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
			ID = "HazardBlinkToggle",
			x = 350,
			y = 25,
			radius = 10,
			tooltip = "Hazard Lights",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_hazards.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "HazardBlink",
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
			ID = "ApplySpringLoadedBrakeToggle",
			x = 365,
			y = 25,
			radius = 10,
			tooltip = "Manually apply spring-loaded brake",
			model = {
				model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_funny.mdl",
				z = 1,
				ang = 90,
				anim = true,
				var = "SpringLoadedBrake",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton3L" ] = {
	pos = Vector( 328.8, 51, 74 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton3LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton3LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton4L" ] = {
	pos = Vector( 328.8, 51.3, 58 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton4LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton4LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton5L" ] = {
	pos = Vector( 261, 51, 74 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton5LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton5LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton6L" ] = {
	pos = Vector( 261, 51.3, 58 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton6LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton6LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton7L" ] = {
	pos = Vector( 144.5, 51, 74 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton7LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton7LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "DoorButton8L" ] = {
	pos = Vector( 144.5, 51.3, 58 ),
	ang = Angle( 90, 90, 0 ),
	width = 50,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "DoorButton8LSet",
			x = 24,
			y = 24,
			radius = 30,
			tooltip = "Request Door Open",
			model = {
				z = 0,
				ang = 90,
				anim = true,
				var = "DoorButton8LSet",
				speed = 15,
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

ENT.ButtonMapMPLR[ "LineRollsign" ] = {
	pos = Vector( 511.25, -12, 115 ),
	ang = Angle( 0, -90, -90 ),
	width = 9,
	height = 9,
	scale = 1
}

ENT.ButtonMapMPLR[ "LineRollsignL" ] = {
	pos = Vector( 189.5, 48, 115 ),
	ang = Angle( 0, 0, -90 ),
	width = 27,
	height = 9,
	scale = 1
}

ENT.ButtonMapMPLR[ "LineRollsignR" ] = {
	pos = Vector( 216.75, -48, 115 ),
	ang = Angle( 0, 180, -90 ),
	width = 28.8,
	height = 9,
	scale = 1
}

ENT.ButtonMapMPLR[ "InfoRollsignR" ] = {
	pos = Vector( 224.8, 37, 115.3 ),
	ang = Angle( 0, 180, -106 ),
	width = 42,
	height = 12.4,
	scale = 1
}

ENT.ButtonMapMPLR[ "InfoRollsignL" ] = {
	pos = Vector( 182.8, -37, 115.3 ),
	ang = Angle( 0, 0, -105 ),
	width = 42,
	height = 12.4,
	scale = 1
}

ENT.ButtonMapMPLR[ "DestinationRollsign" ] = {
	pos = Vector( 511, 22, 115 ),
	ang = Angle( 0, -90, -90 ),
	width = 35,
	height = 9,
	scale = 1
}

ENT.ButtonMapMPLR[ "DestinationRollsignFront" ] = {
	pos = Vector( 511.25, 20.5, 115 ),
	ang = Angle( 0, -90, -90 ),
	width = 33,
	height = 9,
	scale = 1
}

function ENT:Initialize()
	self.BaseClass.Initialize( self )
	self.SectionB = self:GetNWEntity( "SectionB" )
	self.IBIS = self:CreateRT( "IBIS", 515, 131 )
	self.SpeedoAnim = 0
	self.VoltAnim = 0
	self.AmpAnim = 0
	self.KeyInserted = false
	self.KeyTurned = false
	self.CabWindowL = 0
	self.CabWindowR = 0
	self.Reverser = {
		[ 0 ] = 0,
		[ 1 ] = 0.25,
		[ 2 ] = 0.4,
		[ 3 ] = 0.625,
		[ 4 ] = 0.75,
		[ 5 ] = 0.78,
		[ 6 ] = 1
	}

	self.HeadlightsLit = false
	self:ShowHide( "headlights_lit", self.HeadlightsLit )
	self:ShowHide( "key_ignition", self.IgnitionKeyInserted )
	self.ScrollModifier1 = 0
	self.ScrollModifier2 = 0
end

function ENT:Think()
	self.BaseClass.Think( self )
	self:Animations()
	self:SoundsFunc()
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	self.BatteryOn = self:GetNW2Bool( "BatteryOn", false )
	if not IsValid( self.SectionB ) then self.SectionB = Entity( self.SectionBIndex ) end
end

function ENT:Animations()
	if not IsValid( self.SectionB ) then
		print( "sectionB invalid" )
		return
	end

	self.Speed = self:GetNW2Int( "Speed", 0 )
	self.KeyInserted = self:GetNW2Bool( "IgnitionKeyIn", false )
	self.KeyTurned = self:GetNW2Bool( "IgnitionTurned", false )
	self:Animate( "drivers_door", self:GetNW2Float( "DriversDoorState", 0 ), 0, 100, 1, 1, 0 )
	self:Animate( "throttle", self:GetNW2Int( "ThrottleLever", 0.5 ) * 0.01, 0, 100, 50, 9, false )
	self:Animate( "reverser", self.Reverser[ self:GetNW2Int( "ReverserLever", 1 ) ], 0, 100, 50, 9, false )
	self.CabWindowL = self:GetNW2Float( "CabWindowL", 0 )
	self.CabWindowR = self:GetNW2Float( "CabWindowR", 0 )
	-- self:Animate("window_cab_r", self:GetNW2Float("CabWindowR", 0), 0, 100, 50, 9, false)
	-- self:Animate("window_cab_l", self:GetNW2Float("CabWindowL", 0), 0, 100, 50, 9, false)
	self:ShowHide( "key_ignition", self.KeyInserted )
	self:Animate( "key_ignition", self.KeyTurned and 1 or 0, 0, 100, 800, 0, 0 )
	local Door1a = self:GetNW2Float( "Door1a", 0 )
	local Door12a = self:GetNW2Float( "Door2a", 0 )
	local Door34a = self:GetNW2Float( "Door3a", 0 )
	local Door56a = self:GetNW2Float( "Door4a", 0 )
	local Door78a = self:GetNW2Float( "Door5a", 0 )
	local Door9a = self:GetNW2Float( "Door6a", 0 )
	local Door1b = self:GetNW2Float( "Door1b", 0 )
	local Door23b = self:GetNW2Float( "Door2b", 0 )
	local Door45b = self:GetNW2Float( "Door3b", 0 )
	local Door67b = self:GetNW2Float( "Door4b", 0 )
	local Door89b = self:GetNW2Float( "Door5b", 0 )
	local Door10b = self:GetNW2Float( "Door6b", 0 )
	---------------------------------------------------------------------------
	self:Animate( "door1_r", Door1a, 0, 100, 100, 10, 0 )
	self:Animate( "door_fr2", Door12a, 0, 100, 100, 10, 0 )
	self:Animate( "door_fr1", Door12a, 0, 100, 100, 10, 0 )
	self:Animate( "door_rr2", Door34a, 0, 100, 100, 10, 0 )
	self:Animate( "door_rr1", Door34a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_rl1", Door56a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_rl2", Door56a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_fl1", Door78a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_fl2", Door78a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door1_l", Door9a, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door1_r", Door1b, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_fr1", Door23b, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_fr2", Door23b, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_rr1", Door45b, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "door_rr2", Door45b, 0, 100, 100, 10, 0 )
	self:Animate( "door_fl2", Door67b, 0, 100, 100, 10, 0 )
	self:Animate( "door_fl1", Door67b, 0, 100, 100, 10, 0 )
	self:Animate( "door_rl2", Door89b, 0, 100, 100, 10, 0 )
	self:Animate( "door_rl1", Door89b, 0, 100, 100, 10, 0 )
	local StepMediumLeft1 = self:GetNW2Float( "StepMediumLeft1", 0 )
	local StepMediumLeft2 = self:GetNW2Float( "StepMediumLeft2", 0 )
	local StepMediumLeft3 = self:GetNW2Float( "StepMediumLeft3", 0 )
	local StepMediumLeft4 = self:GetNW2Float( "StepMediumLeft4", 0 )
	local StepMediumLeft5 = self:GetNW2Float( "StepMediumLeft5", 0 )
	local StepMediumLeft6 = self:GetNW2Float( "StepMediumLeft6", 0 )
	self:Animate( "foldingstep_fl", StepMediumLeft4, 0, 100, 100, 10, 0 )
	self:Animate( "foldingstep_rl", StepMediumLeft5, 0, 100, 100, 10, 0 )
	local StepLowestLeft1 = self:GetNW2Float( "StepLowestLeft1", 0 )
	local StepLowestLeft2 = self:GetNW2Float( "StepLowestLeft2", 0 )
	local StepLowestLeft3 = self:GetNW2Float( "StepLowestLeft3", 0 )
	local StepLowestLeft4 = self:GetNW2Float( "StepLowestLeft4", 0 )
	local StepLowestLeft5 = self:GetNW2Float( "StepLowestLeft5", 0 )
	local StepLowestLeft6 = self:GetNW2Float( "StepLowestLeft6", 0 )
	self:Animate( "step_tray4", StepLowestLeft4, 0, 100, 100, 10, 0 )
	self:Animate( "step_tray3", StepLowestLeft5, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "step_tray2", StepLowestLeft5, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "step_tray", StepLowestLeft4, 0, 100, 100, 10, 0 )
	local StepMediumRight1 = self:GetNW2Float( "StepMediumRight1", 0 )
	self:Animate( "foldingstep_small_r", StepMediumRight1, 0, 100, 100, 10, 0 )
	local StepMediumRight2 = self:GetNW2Float( "StepMediumRight2", 0 )
	local StepMediumRight3 = self:GetNW2Float( "StepMediumRight3", 0 )
	local StepMediumRight4 = self:GetNW2Float( "StepMediumRight4", 0 )
	local StepMediumRight5 = self:GetNW2Float( "StepMediumRight5", 0 )
	local StepMediumRight6 = self:GetNW2Float( "StepMediumRight6", 0 )
	self:Animate( "foldingstep_fr", StepMediumRight2, 0, 100, 100, 10, 0 )
	self:Animate( "foldingstep_rr", StepMediumRight3, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "foldingstep_fl", StepMediumRight5, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "foldingstep_rl", StepMediumRight4, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "foldingstep_small_l", StepMediumRight6, 0, 100, 100, 10, 0 )
	local StepLowestRight1 = self:GetNW2Float( "StepLowestRight1", 0 )
	local StepLowestRight2 = self:GetNW2Float( "StepLowestRight2", 0 )
	local StepLowestRight3 = self:GetNW2Float( "StepLowestRight3", 0 )
	local StepLowestRight4 = self:GetNW2Float( "StepLowestRight4", 0 )
	local StepLowestRight5 = self:GetNW2Float( "StepLowestRight5", 0 )
	local StepLowestRight6 = self:GetNW2Float( "StepLowestRight6", 0 )
	self:Animate( "step_tray", StepLowestRight3, 0, 100, 100, 10, 0 )
	self:Animate( "step_tray2", StepLowestRight2, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "step_tray3", StepLowestRight4, 0, 100, 100, 10, 0 )
	self.SectionB:Animate( "step_tray4", StepLowestRight5, 0, 100, 100, 10, 0 )
	local mirrorLeft = self:GetNW2Bool( "MirrorLeft", 0 ) and 1 or 0
	local mirrorRight = self:GetNW2Bool( "MirrorRight", 0 ) and 1 or 0
	self:Animate( "mirror_l", mirrorLeft, 0, 1, 35, 10, 5 )
	self:Animate( "mirror_r", mirrorRight, 0, 1, 35, 10, 5 )
	--self:Animate("step_tray", StepLowestRight2, 0, 100, 100, 10, 0)
	-- self:ShowHide("headlights_on", self:GetNW2Bool("Headlights",false), 0)
	-- self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"), 0, 100) / 100
	-- self:Animate("Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0)
	-- self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound", false) == true and 1 or 0, 1)
	-- self.VoltAnim = self:GetNW2Float("BatteryCharge", 0) / 45
	-- self:Animate("Voltage", self.VoltAnim, 0, 100, 1, 0, false)
	-- self.AmpAnim = self:GetNW2Float("Amps", 0) / 0.5 * 100
	-- self:Animate("Amps", self.AmpAnim, 0, 100, 1, 0, false)
end

function ENT:Draw()
	self.BaseClass.Draw( self )
end

ENT.RTMaterialUF = CreateMaterial( "MetrostroiRT1", "VertexLitGeneric", {
	[ "$vertexcolor" ] = 0,
	[ "$vertexalpha" ] = 1,
	[ "$nolod" ] = 1
} )

function ENT:DrawPost()
	local mat = Material( "models/lilly/mplr/rollsigns/b_1973/lines_def.png", "noclamp" )
	local mat2 = Material( "models/lilly/mplr/rollsigns/b_1973/flank_def.png", "noclamp" )
	local mat3 = Material( "models/lilly/mplr/rollsigns/b_1973/internal_def.png", "noclamp" )
	self:DrawOnPanel( "LineRollsign", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat )
		surface.DrawTexturedRectUV( 1, 1.8, 7.5, 7.6, 0, self.ScrollModifier1 + .04, -1, self.ScrollModifier1 + 0.00 )
	end )

	self:DrawOnPanel( "DestinationRollsignFront", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat2 )
		surface.DrawTexturedRectUV( 1, 1.8, 31, 7.6, 0, self.ScrollModifier1, -.7, self.ScrollModifier1 - 1 )
	end )

	self:DrawOnPanel( "LineRollsignR", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat2 )
		surface.DrawTexturedRectUV( 1, 0, 26.5, 7.6, 0, self.ScrollModifier1 + .01, -1, self.ScrollModifier1 - 0.85 )
	end )

	self:DrawOnPanel( "LineRollsignL", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat2 )
		surface.DrawTexturedRectUV( 1, 0, 26.5, 7.6, 0, self.ScrollModifier1 + .01, -1, self.ScrollModifier1 - 0.85 )
	end )

	self:DrawOnPanel( "InfoRollsignR", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat3 )
		surface.DrawTexturedRectUV( 0, 0, 41, 11, 0, self.ScrollModifier1 + .1, -1, self.ScrollModifier1 - .85 )
	end )

	self:DrawOnPanel( "InfoRollsignL", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat3 )
		surface.DrawTexturedRectUV( 0, 0, 41, 11, 0, self.ScrollModifier1 + .1, -1, self.ScrollModifier1 - .85 )
	end )

	self.RTMaterialUF:SetTexture( "$basetexture", self.IBIS )
	self:DrawOnPanel( "IBISScreen", function( ... )
		surface.SetMaterial( self.RTMaterialUF )
		surface.SetDrawColor( 0, 65, 11 )
		surface.DrawTexturedRectRotated( 60, 16, 122, 28, 0 )
	end )
end

function ENT:SoundsFunc()
	-- print(self:GetNW2Bool("Bell",false))
	self:SetSoundState( "bell", self:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
	self:SetSoundState( "bell_in", self:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
	self:SetSoundState( "DepartureConfirmed", self:GetNW2Bool( "DepartureAlarm", false ) and 1 or 0, 1 )
end

function ENT:OnPlay( soundid, location, range, pitch )
	if location == "stop" then
		if IsValid( self.Sounds[ soundid ] ) then
			self.Sounds[ soundid ]:Pause()
			self.Sounds[ soundid ]:SetTime( 0 )
		end
		return
	end
end

UF.GenerateClientProps()