include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}

ENT.ClientProps["empty_button"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector(-.1, .11, .06),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["empty_button2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector(-.1, -7, .06),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["empty_button3"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_empty.mdl",
	pos = Vector(-.1, -6, .06),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["headlights_lit"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/headlights_lit.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["destination_frame"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/destination_frame.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["door_opener"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_opener.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["door_button"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_button.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
}
ENT.ClientProps["int"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/int-essen.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}

ENT.ClientProps["seats"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/seats-essen.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}
ENT.ClientProps["bumper"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/bumper.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2
}
ENT.ClientProps["floor"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/floor.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),

}

ENT.ClientProps["door_rr1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),

}
ENT.ClientProps["door_rr2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),

}
ENT.ClientProps["door_fr1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(184.5, 0, 0),
	ang = Angle(0, 0, 0),

}
ENT.ClientProps["door_fr2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(184.5, 0, 0),
	ang = Angle(0, 0, 0),

}

ENT.ClientProps["door_fl1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(409, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door_fl2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(409, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door_rl1"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double.mdl",
	pos = Vector(225, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door_rl2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door_double2.mdl",
	pos = Vector(225, 0, 0),
	ang = Angle(0, 180, 0),

}
ENT.ClientProps["door1_r"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_r.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 00, 0),

}
ENT.ClientProps["door1_l"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/door1_l.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 00, 0),

}
ENT.ClientProps["throttle"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/throttle.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2

}
ENT.ClientProps["reverser"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/reverser.mdl",
	pos = Vector(-0.5, 0, 0),
	ang = Angle(0, 00, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_rr"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 00, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_fr"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(184, 0, 0),
	ang = Angle(0, 00, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_fl"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(408, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_rl"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep.mdl",
	pos = Vector(224, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 00, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray2"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(184, 0, 0),
	ang = Angle(0, 00, 0),
	hideseat = 0.2
}
ENT.ClientProps["key_ignition"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/cab/key.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 00, 0),
}
ENT.ClientProps["step_tray3"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(224, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}
ENT.ClientProps["step_tray4"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/step_large.mdl",
	pos = Vector(408, 0, 0),
	ang = Angle(0, 180, 0),
	hideseat = 0.2
}

ENT.ClientProps["foldingstep_small_r"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_r.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2

}
ENT.ClientProps["foldingstep_small_l"] = {
	model = "models/lilly/mplr/ruhrbahn/b_1973/foldingstep_small_l.mdl",
	pos = Vector(0, 0, 0),
	ang = Angle(0, 0, 0),
	hideseat = 0.2

}

ENT.ButtonMapMPLR["dashboard"] = {
    pos = Vector(508, 17, 71.88),
    ang = Angle(0, -90, 0),
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
                z = -2,
                ang = 90,
                anim = true,
                var = "PantographOff",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = -2,
                ang = 90,
                anim = true,
                var = "PantographOn",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "CircuitOnSet",
            x = 85,
            y = 62,
            radius = 10,
            tooltip = "Close Main Circuit Breaker",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_breaker_on.mdl",
                z = -2,
                ang = 90,
                anim = true,
                var = "CircuitOn",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "CircuitOffSet",
            x = 100,
            y = 62,
            radius = 10,
            tooltip = "Open Main Circuit Breaker",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_breaker_off.mdl",
                z = -2,
                ang = 90,
                anim = true,
                var = "CircuitOff",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = -2,
                ang = 90,
                anim = true,
                var = "StopRequest",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "DoorUnblockSet",
            x = 130,
            y = 62,
            radius = 10,
            tooltip = "Unblock Doors",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_unlock.mdl",
                z = -2,
                ang = 90,
                anim = true,
                var = "UnblockDoors",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = -1.8,
                ang = 90,
                anim = true,
                var = "WiperConstant",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = -1.8,
                ang = 90,
                anim = true,
                var = "WiperInterval",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "WindowWasher",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "MirrorLeft",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "MirrorRight",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "RevokeDoors",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "EmergencyBrakeDisable",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "Door1",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "DoorsForceClose",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "DoorsForceOpen",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "Lights",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 5,
                ang = 90,
                anim = true,
                var = "Defect",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },

		-----------------------------------------------------------------------
		{
            ID = "DoorLeftToggle",
            x = 173,
            y = 62,
            radius = 10,
            tooltip = "Select Left Side Doors",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_left.mdl",
                z = 0,
                ang = 90,
                anim = true,
                var = "DoorsSelectLeft",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "DoorRightToggle",
            x = 187.5,
            y = 62,
            radius = 10,
            tooltip = "Select Right Side Doors",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_door_right.mdl",
                z = 0,
                ang = 90,
                anim = true,
                var = "DoorsSelectRight",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		-----empty gap
		{
            ID = "StepsLowestToggle",
            x = 216.5,
            y = 62,
            radius = 10,
            tooltip = "Set Steps To Road Level",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_lowest.mdl",
                z = 0,
                ang = 90,
                anim = true,
                var = "StepsLowest",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "StepsLowToggle",
            x = 231,
            y = 62,
            radius = 10,
            tooltip = "Set Steps To Low Platform",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_low.mdl",
                z = 0,
                ang = 90,
                anim = true,
                var = "StepsLow",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },
		{
            ID = "StepsHighToggle",
            x = 245.5,
            y = 62,
            radius = 10,
            tooltip = "Set Steps To High Floor Platform",
            model = {
                model = "models/lilly/mplr/ruhrbahn/b_1973/cab/button_steps_high.mdl",
                z = 0,
                ang = 90,
                anim = true,
                var = "StepsHigh",
                speed = 20,
                vmin = 0,
                vmax = 100,
                getfunc = function(ent) return ent:GetNW2Bool("StepsHigh") and 1 or 0 end,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 0,
                ang = 90,
                anim = true,
                var = "SwitchLeft",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = -4,
                ang = 90,
                anim = true,
                var = "SwitchRight",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 0,
                ang = 90,
                anim = true,
                var = "BlinkerLeft",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 0,
                ang = 90,
                anim = true,
                var = "BlinkerRight",
                speed = 15,
                vmin = 0,
                vmax = 100,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "LightsOn",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "LightsOff",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "HazardBlink",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
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
                z = 3,
                ang = 90,
                anim = true,
                var = "SpringLoadedBrake",
                speed = 15,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        },


	}
}

ENT.ButtonMapMPLR["LineRollsign"] = {
    pos = Vector(511.25, -12, 115),
    ang = Angle(0, -90,-90),
    width = 9,
    height = 9,
    scale = 1,
}
ENT.ButtonMapMPLR["LineRollsignL"] = {
    pos = Vector(189.5, 48, 115),
    ang = Angle(0, 0,-90),
    width = 27,
    height = 9,
    scale = 1,
}
ENT.ButtonMapMPLR["LineRollsignR"] = {
    pos = Vector(216.75, -48, 115),
    ang = Angle(0, 180,-90),
    width = 28.8,
    height = 9,
    scale = 1,
}
ENT.ButtonMapMPLR["InfoRollsignR"] = {
    pos = Vector(224.8, 37, 115.3),
    ang = Angle(0, 180,-106),
    width = 42,
    height = 12.4,
    scale = 1,
}
ENT.ButtonMapMPLR["InfoRollsignL"] = {
    pos = Vector(182.8, -37, 115.3),
    ang = Angle(0, 0,-105),
    width = 42,
    height = 12.4,
    scale = 1,
}
ENT.ButtonMapMPLR["DestinationRollsign"] = {
    pos = Vector(511, 22, 115),
    ang = Angle(0, -90,-90),
    width = 35,
    height = 9,
    scale = 1,
}
ENT.ButtonMapMPLR["DestinationRollsignFront"] = {
    pos = Vector(511.25, 20.5, 115),
    ang = Angle(0, -90,-90),
    width = 33,
    height = 9,
    scale = 1,
}
function ENT:Initialize()
    self.BaseClass.Initialize(self)

	self.SectionB = self:GetNWEntity("SectionB")

    self.IBIS = self:CreateRT("IBIS", 512, 128)

    self.SpeedoAnim = 0
	self.VoltAnim = 0
	self.AmpAnim = 0

    self.KeyInserted = false 
    self.KeyTurned = false 

    self.CabWindowL = 0
	self.CabWindowR = 0

	self.Reverser = {
		[0] = 0,
		[1] = 0.25,
		[2] = 0.4,
		[3] = 0.625,
		[4] = 0.75,
		[5] = 0.78,
		[6] = 1
	}

    self.HeadlightsLit = false
    self:ShowHide("headlights_lit",self.HeadlightsLit)
    self:ShowHide("key_ignition",self.IgnitionKeyInserted)

    self.ScrollModifier1 = 0
    self.ScrollModifier2 = 0
end

function ENT:Think()
	self.BaseClass.Think(self)
    self:Animations()
    self:SoundsFunc()
    self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()

    self.BatteryOn = self:GetNW2Bool("BatteryOn", false)

	
end

function ENT:Animations()
    self.Speed = self:GetNW2Int("Speed",0)
    self.KeyInserted = self:GetNW2Bool("IgnitionKeyIn",false)
    self.KeyTurned = self:GetNW2Bool("IgnitionTurned",false)
    --self:Animate("Mirror_L", self:GetNW2Float("Mirror_L", 0), 0, 100, 17, 1, 0)
    --self:Animate("Mirror_R", self:GetNW2Float("Mirror_R", 0), 0, 100, 17, 1, 0)
    self:Animate("drivers_door", self:GetNW2Float("DriversDoorState", 0), 0, 100, 1, 1, 0)
    self:Animate("throttle", self:GetNW2Int("ThrottleLever",0.5) * 0.01, 0, 100, 50, 9, false)
    self:Animate("reverser", self.Reverser[self:GetNW2Int("ReverserLever",1)], 0, 100, 50, 9, false)
    self.CabWindowL = self:GetNW2Float("CabWindowL", 0)
	self.CabWindowR = self:GetNW2Float("CabWindowR", 0)
	--self:Animate("window_cab_r", self:GetNW2Float("CabWindowR", 0), 0, 100, 50, 9, false)
	--self:Animate("window_cab_l", self:GetNW2Float("CabWindowL", 0), 0, 100, 50, 9, false)

    self:ShowHide("key_ignition", self.KeyInserted)
    self:Animate("key_ignition", self.KeyTurned and 1 or 0, 0, 100, 800, 0, 0)

    --[[self:Animate("Door_fr2", Door12a, 0, 100, 100, 10, 0)
	self:Animate("Door_fr1", Door12a, 0, 100, 100, 10, 0)

	self:Animate("Door_rr2", Door34a, 0, 100, 100, 10, 0)
	self:Animate("Door_rr1", Door34a, 0, 100, 100, 10, 0)

	self:Animate("Door_fl2", Door78b, 0, 100, 100, 10, 0)
	self:Animate("Door_fl1", Door78b, 0, 100, 100, 10, 0)

	self:Animate("Door_rl2", Door56b, 0, 100, 100, 10, 0)
	self:Animate("Door_rl1", Door56b, 0, 100, 100, 10, 0)]]

    --self:ShowHide("headlights_on", self:GetNW2Bool("Headlights",false), 0)

    --self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"), 0, 100) / 100
	--self:Animate("Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0)

    --self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound", false) == true and 1 or 0, 1)

    --self.VoltAnim = self:GetNW2Float("BatteryCharge", 0) / 45
    --self:Animate("Voltage", self.VoltAnim, 0, 100, 1, 0, false)
	--self.AmpAnim = self:GetNW2Float("Amps", 0) / 0.5 * 100
	--self:Animate("Amps", self.AmpAnim, 0, 100, 1, 0, false)
end


function ENT:Draw() self.BaseClass.Draw(self) end

function ENT:DrawPost()
	local mat = Material("models/lilly/mplr/rollsigns/b_1973/lines_def.png","noclamp")
    local mat2 = Material("models/lilly/mplr/rollsigns/b_1973/flank_def.png","noclamp")
    local mat3 = Material("models/lilly/mplr/rollsigns/b_1973/internal_def.png","noclamp")
	self:DrawOnPanel("LineRollsign", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(1,1.8, 7.5, 7.6 , 0, self.ScrollModifier1 + .04, -1, self.ScrollModifier1 + 0.00)
	end)
    self:DrawOnPanel("DestinationRollsignFront", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat2)
		surface.DrawTexturedRectUV(1,1.8, 31, 7.6 , 0, self.ScrollModifier1, -.7, self.ScrollModifier1 - 1)
	end)

	self:DrawOnPanel("LineRollsignR", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat2)
		surface.DrawTexturedRectUV(1,0, 26.5, 7.6 , 0, self.ScrollModifier1 + .01, -1, self.ScrollModifier1 - 0.85)
	end)
	self:DrawOnPanel("LineRollsignL", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat2)
		surface.DrawTexturedRectUV(1,0, 26.5, 7.6 , 0, self.ScrollModifier1 + .01, -1, self.ScrollModifier1 - 0.85)
	end)

    self:DrawOnPanel("InfoRollsignR", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat3)
		surface.DrawTexturedRectUV(0,0, 41, 11 , 0, self.ScrollModifier1 + .1, -1, self.ScrollModifier1 - .85)
	end)
    self:DrawOnPanel("InfoRollsignL", function(...)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat3)
		surface.DrawTexturedRectUV(0,0, 41, 11 , 0, self.ScrollModifier1 + .1, -1, self.ScrollModifier1 - .85)
	end)
end

function ENT:SoundsFunc()
    --print(self:GetNW2Bool("Bell",false))
    self:SetSoundState("bell",self:GetNW2Bool("Bell",false) and 1 or 0,1)
    self:SetSoundState("bell_in",self:GetNW2Bool("Bell",false) and 1 or 0,1)
end

function ENT:OnPlay(soundid, location, range, pitch)
	if location == "stop" then
		if IsValid(self.Sounds[soundid]) then
			self.Sounds[soundid]:Pause()
			self.Sounds[soundid]:SetTime(0)
		end
		return
	end
end
UF.GenerateClientProps()