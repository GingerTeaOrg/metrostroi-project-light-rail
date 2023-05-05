include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}


ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",        Vector(410,39,43), Angle(10,0,0), Color(216,161,92), fov=60,farz=600,brightness = 1.2, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
    [2] = { "headlight",        Vector(410,-39,43), Angle(10,0,0), Color(216,161,92), fov=60,farz=600,brightness = 1.2, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
    [3] = { "light",        Vector(406,0,100), Angle(0,0,0), Color(216,161,92), fov=40,farz=450,brightness = 3, texture = "effects/flashlight/soft",shadows = 1,headlight=true},
    [4] = { "headlight",        Vector(545,38.5,40), Angle(-20,0,0), Color(255,0,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[5] = { "headlight",        Vector(545,-38.5,40), Angle(-20,0,0), Color(255,0,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
    [6] = { "headlight",        Vector(406,39,98), Angle(90,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.7, texture = "effects/flashlight/soft.vmt" }, --cab lights
    [16] = { "headlight",        Vector(406,-39,98), Angle(90,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.7, texture = "effects/flashlight/soft.vmt" },
    [7] = { "headlight",        Vector(545,38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[8] = { "headlight",        Vector(545,-38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
    [9] = { "dynamiclight",        Vector(400,30,490), Angle(90,0,0), Color(226,197,160), fov=100,    brightness = 0.9, scale = 1.0, texture = "effects/flashlight/soft.vmt" }, --passenger light front left
    [10] = { "dynamiclight",        Vector(400,-30,490), Angle(90,0,0), Color(226,197,160), fov=100,    brightness = 1.0, scale = 1.0, texture = "effects/flashlight/soft.vmt" }, --passenger light front right
	[11] = { "dynamiclight",        Vector(327,-52,71), Angle(90,0,0), Color(255,102,0), fov=100,    brightness = 1.0, scale = 1.0, texture = "effects/flashlight/soft.vmt" },
}


ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlights_on.mdl",
	pos = Vector(-0.35,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["cab"] = {
    model ="models/lilly/uf/u2/u2-cabfront.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    scale = 1,
    nohide=true,
}

ENT.ClientProps["switching_iron"] = {
    model ="models/lilly/uf/u2/switching_iron.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    scale = 1,
    nohide=true,
}



ENT.ClientProps["Door_fr1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_fr2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_fl1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(721.5,0,0),
	ang = Angle(0,180,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_fl2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(721.5,0,0),
	ang = Angle(0,180,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_rr1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(-243,0,0),
	ang = Angle(0,0,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_rr2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(-243,0,0),
	ang = Angle(0,0,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_rl1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(478,0,0),
	ang = Angle(0,180,0),
	scale = 1,
    hideseat = 1000000,
}

ENT.ClientProps["Door_rl2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(478,0,0),
	ang = Angle(0,180,0),
	scale = 1,
    hideseat = 1000000,
}


ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
    pos = Vector(0.1,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

--[[ENT.ClientProps["Pantograph"] = {
	model = "models/lilly/uf/common/pantograph.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}]]

ENT.ClientProps["window_cab_l"] = {
	model = "models/lilly/uf/u2/window_cab_l.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["window_cab_r"] = {
	model = "models/lilly/uf/u2/window_cab_r.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["drivers_door"] = {
    model = "models/lilly/uf/u2/drivers_door.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    hideseat = 5,
}

ENT.ClientProps["Mirror"] = {
    model = "models/lilly/uf/u2/mirror.mdl",
    pos = Vector(0,0,0),
    ang = Angle(0,0,0),
    hideseat = 5,
}

ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/u2/cab/speedo.mdl",
    pos = Vector(418.192,10,54.66),
    ang = Angle(-8.7,0,0),
    hideseat = 0.2,
}

--[[ENT.ClientProps["BatterySwitch"] = {
    model = "models/lilly/uf/u2/cab/battery_switch.mdl",
    pos = Vector(413.5,-7,54.1),
    ang = Angle(-8.5,0,0),
    hideseat = 0.2,
}]]

ENT.ClientProps["DoorSwitch"] = {
    model = "models/lilly/uf/u2/cab/battery_switch.mdl",
    pos = Vector(418.5,-2.35,54.86),
    ang = Angle(-8.5,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["BlinkerSwitch"] = {
    model = "models/lilly/uf/u2/cab/battery_switch.mdl",
    pos = Vector(413.5,6.3,54),
    ang = Angle(-8.5,0,4),
    hideseat = 0.2,
}

--[[ENT.ClientProps["HeadlightSwitch"] = {
    model = "models/lilly/uf/u2/cab/battery_switch.mdl",
    pos = Vector(418.6,23.58,54.75),
    ang = Angle(-8.5,0,0),
    hideseat = 0.2,
}]]

ENT.ClientProps["DriverLightSwitch"] = {
    model = "models/lilly/uf/u2/cab/battery_switch.mdl",
    pos = Vector(415.7,-7,54.5),
    ang = Angle(-8.5,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["Voltage"] = {
    model = "models/lilly/uf/u2/cab/gauge.mdl",
    pos = Vector(418,18.7,54.8),
    ang = Angle(-12,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["Amps"] = {
    model = "models/lilly/uf/u2/cab/gauge.mdl",
    pos = Vector(418,1.5,54.8),
    ang = Angle(-12,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["reverser"] = {
    model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
    pos = Vector(0,-0.15,0),
    ang = Angle(0,0,0),
    hideseat = 0.2,
}

ENT.ClientProps["blinds_l"] = {
    model = "models/lilly/uf/u2/cab/blinds.mdl",
    pos = Vector(-0.6,0,0),
    ang = Angle(0,0,0),
    hideseat = 8,
}

ENT.ButtonMap["Drivers_Door"] = {
    pos = Vector(385.874,-10.7466,24.4478),
    ang = Angle(0,-90,-90),
    width = 25,
    height = 80,
    scale = 1,
    buttons ={
        
        {ID = "PassengerDoor",x=0,y=0,w=25,h=80, tooltip="Дверь в кабину машиниста из салона\nPass door", model = {
        var="PassengerDoor",sndid="door_cab_m",
        sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
        sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
        noTooltip = true,
    }},
    }
}
ENT.ButtonMap["Drivers_Door2"] = {
    pos = Vector(385.874,-35.7466,24.4478),
    ang = Angle(0,90,-90),
    width = 25,
    height = 80,
    scale = 1,
    buttons ={
        
        {ID = "PassengerDoor",x=0,y=0,w=25,h=80, tooltip="It's a door. Does this really need explanation?", model = {
        var="PassengerDoor",sndid="door_cab_m",
        sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
        sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
        noTooltip = true,
    }},
    }
}

ENT.ButtonMap["Button1a"] = {
    pos = Vector(396.3,-51,50.5),
    ang = Angle(0,0,90),
    width = 5,
    height = 5,
    scale = 0.4,
    buttons = {
        {ID = "Button1a",x=1.8,y=1.8,w=2,h=2,radius=1, tooltip="It's a door. Does this really need explanation?", model = {
            var="Button1a",
            sndid="door_cab_m",
            sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
            noTooltip = true,
        }},
    }
}


ENT.ButtonMap["Button2a"] = {
    pos = Vector(326,-51,50.5),
    ang = Angle(0,0,90),
    width = 5,
    height = 5,
    scale = 0.4,
    buttons = {
        {ID = "Button2a",x=1.8,y=1.8,w=2,h=2,radius=1, tooltip="It's a door. Does this really need explanation?", model = {
            var="Button2a",
            sndid="door_cab_m",
            sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
            noTooltip = true,
        }},
    }
}

ENT.ButtonMap["Button3a"] = {
    pos = Vector(150.6,-51,50.5),
    ang = Angle(0,0,90),
    width = 5,
    height = 5,
    scale = 0.4,
    buttons = {
        {ID = "Button3a",x=1.8,y=1.8,w=2,h=2,radius=1, tooltip="It's a door. Does this really need explanation?", model = {
            var="Button3a",
            sndid="door_cab_m",
            sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
            noTooltip = true,
        }},
    }
}


ENT.ButtonMap["Button4a"] = {
    pos = Vector(82.8,-51,50.5),
    ang = Angle(0,0,90),
    width = 5,
    height = 5,
    scale = 0.4,
    buttons = {
        {ID = "Button4a",x=1.8,y=1.8,w=2,h=2,radius=1, tooltip="It's a door. Does this really need explanation?", model = {
            var="Button4a",
            sndid="door_cab_m",
            sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),
            noTooltip = true,
        }},
    }
}


ENT.ButtonMap["Cab"] = {
    pos = Vector(419.6,24.88,55.2),
    ang = Angle(0,-90,8),
    width = 500,
    height = 120,
    scale = 0.069,
	
    buttons = {
		
    {ID = "WarningAnnouncementSet", x=266, y=18, radius=10, tooltip = "Please keep back announcement", model = {
        model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl", z=-5, ang=0,
        var="WarningAnnouncement", speed=15,
        sndvol = 1, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "VentilationSet", x=334, y=59, radius=10, tooltip = "Enable motor fans", model = {
        model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl", z=-5, ang=0,
        getfunc = function(ent) return ent:GetPackedRatio("Ventilation") end,var="Ventilation", speed=4,min=0,max=1,
        var="Ventilation",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ReleaseHoldingBrakeSet", x=21.5, y=90, radius=10, tooltip = "Release mechanical retainer brake manually", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", z=-6, ang=0,anim=true,
        var="ReleaseHoldingBrake",speed=5, min=0, max=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetHoldingBrakeSet", x=21.5, y=58, radius=10, tooltip = "set mechanical retainer brake manually", model = {
        model = "models/lilly/uf/u2/cab/button_indent_red.mdl", z=-5, ang=180,
        var="SetHoldingBrake",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerOvergroundSet", x=54, y=58, radius=10, tooltip = "Set passenger lights to overground mode", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", z=-5, ang=0,
        var="PassengerOverground",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ShedrunSet", x=87, y=90, radius=10, tooltip = "Toggle Indoors Mode", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", z=-6, ang=0,
        var="Shedrun",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "HighbeamToggle", x=118, y=90.4, radius=10, tooltip = "Toggle High Beam", model = {
        model = "models/lilly/uf/u2/cab/battery_switch.mdl", z=-5, ang=45,anim=true,
        var="Highbeam",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerUndergroundSet", x=54, y=91, radius=10, tooltip = "Set passenger lights to underground mode", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", z=-5, ang=0,
        var="PassengerUnderground",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "HeadlightsToggle", x=22, y=19, radius=10, tooltip = "Enable Headlights", model = {

        model= "models/lilly/uf/u2/cab/battery_switch.mdl",getfunc = function(ent) return ent:GetPackedBool("HeadlightsSwitch") and 1 or 0 end,
        z=0, ang=45,
        var="Headlights",speed=5, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 90,sndmax = 1e3,sndang = Angle(-90,0,0),
        }
    },
    {ID = "BatteryToggle", x=463, y=91, radius=10, tooltip = "Toggle Battery", model = {
        model = "models/lilly/uf/u2/cab/battery_switch.mdl", z=0, ang=45,
        getfunc =  function(ent) return ent.BatterySwitch end,
        var="BatteryToggle",speed=5, min=0, max=1,
        sndvol = 1, snd = function(val,val2) return val2 == 1 and "button_on" or val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SpeakerToggle", x=149, y=18.2, radius=10, tooltip = "Toggle Speaker Inside/Outside", model = {
        model = "models/lilly/uf/u2/cab/battery_switch.mdl", z=0, ang=0,
        --[[getfunc =  function(ent) return ent:GetPackedBool("FlickBatterySwitchOn") and 1 or 0.5 or ent:GetPackedBool("FlickBatterySwitchOff") and 1 or 0.5 end,]]
        var="Speaker",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DriverLightToggle", x=463, y=70, radius=10, tooltip = "Toggle Cab Light", model = {
        z=0, ang=0,
        var="DriverLight",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointLeftSet", x=179, y=91, radius=10, tooltip = "Set track point to left", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_arrow_right.mdl", z=-4, ang=90, anim=true,
        var="SetPointLeft",speed=15, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DoorsCloseConfirmSet", x=211, y=91, radius=10, tooltip = "Clear door closed alarm", model = {
        model = "models/lilly/uf/u2/cab/button_indent_orange.mdl", z=-2, ang=0, anim=true,
        var="DoorsCloseConfirm",speed=15, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointRightSet", x=241, y=91, radius=10, tooltip = "Set track point to right", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_arrow_left.mdl", z=-4, ang=90,anim=true,
        var="SetPointRight",speed=15, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "BlinkerLeftToggle", x=260, y=88, radius=8, tooltip = "Indicators Left", model = {
        z=0, ang=0,
        var="BlinkerLeft",speed=15, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "BlinkerRightToggle", x=280, y=88, radius=8, tooltip = "Indicators Right", model = {
        z=0, ang=0,
        var="BlinkerRight",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PantographLowerSet", x=303.5, y=91, radius=8, tooltip = "Lower Pantograph", model = { model = "models/lilly/uf/u2/cab/button_indent_red.mdl", anim=true,
        z=-5, ang=0,
        var="PantographLower",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PantographRaiseSet", x=303.5, y=58, radius=8, tooltip = "Raise Pantograph", model = { model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", anim=true,
        z=-5, ang=0,
        var="PantographRaise",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    --[[{ID = "LowerPantographSet", x=449, y=112, radius=10, tooltip = "Lower pantograph", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },]]
    {ID = "ThrowCouplerSet", x=334.8, y=91, radius=10, tooltip = "Throw Coupler", model = {
        model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl",getfunc = function(ent) return ent:GetPackedBool("ThrowCoupler") and 1 or 0 end, z=-5, ang=0,
        var="ThrowCoupler",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "OpenDoor1Set", x=364, y=91, radius=10, tooltip = "Open only door 1", model = {
        model = "models/lilly/uf/u2/cab/button_indent_red.mdl", z=-5, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SanderToggle", x=561, y=112, radius=10, tooltip = "Toggle sanding", model = {
        model = "models/lilly/uf/common/cab/button_red.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "UnlockDoorsSet", x=396.4, y=57.7, radius=10, tooltip = "Toggle doors unlocked", model = {
        model = "models/lilly/uf/u2/cab/button_indent_red.mdl", z=-5, ang=180,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    --[[{ID = "RaisePantographSet", x=449, y=80, radius=10, tooltip = "Raise Pantograph", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },]]
    {ID = "DoorSideSelectToggle", x=531, y=46, radius=10, tooltip = "Select door set to unlock", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DoorCloseSignalSet", x=396, y=91, radius=10, tooltip = "Set doors to close", model = {
        model = "models/lilly/uf/u2/cab/button_bulge_green.mdl", z=-5, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
}
}

ENT.ButtonMap["BOStrab"] = {
    pos = Vector(422,-33,55.2),
    ang = Angle(0,-122,0),
    width = 90,
    height = 150,
    scale = 0.069,
	
    buttons = {
        {ID = "OpenBOStrab", x=0,y=0,w=90,h=150, radius=1,tooltip="Read up on the Light Rail Operation Ordinance", model = {
            var="OpenBOStrab",
            sndid="door_cab_m",
            sndvol = 1, snd = function(val) return val and "door_cab_open" or "door_cab_close" end,
            sndmin = 90, sndmax = 1e3, sndang = Angle(-90,0,0),}
        },
    }
}
--[[ENT.ButtonMap["Lefthand"] = {
    pos = Vector(532.6,-19.2,83.09),
    ang = Angle(0,90,0),
    width = 112,
    height = 25,
    scale = 0.04,
}]]

ENT.ButtonMap["IBISScreen"] = {
    pos = Vector(419.73,-12.75,60.35),
    ang = Angle(0,-135.4,48.5),--(0,44.5,-47.9),
    width = 117,
    height = 29.9,
    scale = 0.0311,
}
ENT.ButtonMap["IBIS"] = {
    pos = Vector(415.2,-18,61),
    ang = Angle(48,-225,0),
    width = 100,
    height = 210,
    scale = 0.04,

    buttons = {
        {ID = "Number1Set", x=28, y=60, radius=10, tooltip = "1/RBL/Radio",var="Number1Set", model = { speed=4,min=0,max=1,
        var="Number1",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "IBIS_beep" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }   
        },
        {ID = "Number2Set", x=28, y=42, radius=10, tooltip = "2/Special Character", model = {
            z=0, ang=0,
            var="Number2",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
        },
        {ID = "Number3Set", x=28, y=24, radius=10, tooltip = "3/Advance current stop silently", model = {
            z=0, ang=0,
            var="Number3",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
        },
        {ID = "Number4Set", x=46, y=60, radius=10, tooltip = "4", model = {
            z=0, ang=0,
            var="Number4",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number5Set", x=46, y=42, radius=10, tooltip = "5", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number6Set", x=46, y=24, radius=10, tooltip = "6/Rewind current stop silently", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number7Set", x=65, y=60, radius=10, tooltip = "7/Route", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number8Set", x=65, y=42, radius=10, tooltip = "8/Disable Passenger Information System", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number9Set", x=65, y=24, radius=10, tooltip = "9/Announce stop manually", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "DeleteSet", x=85, y=60, radius=10, tooltip = "Delete", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number0Set", x=85, y=42, radius=10, tooltip = "0/Line/Course", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "EnterSet", x=85, y=24, radius=10, tooltip = "Confirm", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "TimeAndDateSet", x=85, y=78, radius=10, tooltip = "Set time and date", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "SpecialAnnouncementsSet", x=85, y=96, radius=10, tooltip = "Special Annoucements", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "DestinationSet", x=65, y=78, radius=10, tooltip = "Destination", model = {
            z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "IBIS_beep"  end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
    }
}

ENT.ButtonMap["Microphone"] = {
    pos = Vector(417.4,0.6,73),
    ang = Angle(120,-10,184),
    width = 50,
    height = 50,
    scale = 0.0625, 
    buttons = {
    {ID = "ComplaintSet",x=10,y=10,z=0,w=5,h=5,radius=90, tooltip="Activate Driver's Rage"},

    }
}





ENT.ButtonMap["Rollsign"] = {
    pos = Vector(424.5,-25,109),
    ang = Angle(0,90,90),
    width = 780,
    height = 160,
    scale = 0.0625,
    buttons = {
        --{ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
        --{ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
    }
}

ENT.ButtonMap["Blinds"] = {
    pos = Vector(415,40,100),
    ang = Angle(0,280,90),
    width = 50,
    height = 800,
    scale = 0.0625,
    buttons = {
        {ID = "Blinds+",x=000,y=200,w=50,h=205, tooltip="Pull the blinds up"},
        {ID = "Blinds-",x=0,y=400,w=50,h=205, tooltip="Pull the blinds down"},
    }
}


ENT.ButtonMap["CabWindowL"] = {
    pos = Vector(397,45,95),
    ang = Angle(0,0,90),
    width = 300,
    height = 600,
    scale = 0.0625,
    buttons = {
        {ID = "CabWindowL+",x=000,y=200,w=300,h=205, tooltip="Pull the Window up"},
        {ID = "CabWindowL-",x=0,y=400,w=300,h=205, tooltip="Pull the window down"},
    }
}

ENT.ButtonMap["CabWindowR"] = {
    pos = Vector(415,-45,95),
    ang = Angle(0,180,90),
    width = 300,
    height = 600,
    scale = 0.0625,
    buttons = {
        {ID = "CabWindowR+",x=000,y=200,w=300,h=205, tooltip="Pull the Window up"},
        {ID = "CabWindowR-",x=0,y=400,w=300,h=205, tooltip="Pull the window down"},
    }
}



ENT.ButtonMap["Left"] = {
    pos = Vector(415,30,56),
    ang = Angle(0,180,0),
    width = 160,
    height = 80,
    scale = 0.1,
    buttons = {
        {ID = "ParrallelToggle", x=27, y=32, radius=7, tooltip = "Set engines to shunt mode (not yet implemented)", model = {
            z=-5, ang=0,
            var="ParrallelToggle",speed=1, vmin=0, vmax=1,
            sndvol = 1, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),},
        },
        {ID = "WarnBlinkToggle", x=79, y=71, radius=7, tooltip = "Set indicators to warning mode", model = { 
            model="models/lilly/uf/u2/cab/switch_flick.mdl",
            getfunc = function(ent) return ent:GetPackedBool("WarnBlink") and 1 or 0 end,
            z=-3, ang=0,
            var="WarnBlink",speed=8, vmin=1, vmax=0,
            sndvol = 1, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),},
        },
        {ID = "ReduceBrakeSet", x=44, y=11.5, radius=7, tooltip = "Reduce track brake intensity", model = {
            z=-5, ang=0,
            var="ReduceBrakeSet",speed=1, vmin=0, vmax=1,
            sndvol = 1, snd = function(val) return val and "button_on" or "button_off" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),},
        },
        }
}


	
function ENT:Draw()
    self.BaseClass.Draw(self)
end


function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture",self.IBIS)
    self:DrawOnPanel("IBISScreen",function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(0,65,11)
        surface.DrawTexturedRectRotated(59,16,116,25,0)
    end)


    local mat = Material("models/lilly/uf/u2/rollsigns/frankfurt_stock.png")
    self:DrawOnPanel("Rollsign",function(...)
        surface.SetDrawColor( color_white )
        surface.SetMaterial(mat)
        surface.DrawTexturedRectUV(0,0,780,160,0,self.ScrollModifier,1,self.ScrollModifier + 0.015)
    end)
end


function ENT:OnPlay(soundid,location,range,pitch)
    if location == "stop" then
        if IsValid(self.Sounds[soundid]) then
            self.Sounds[soundid]:Pause()
            self.Sounds[soundid]:SetTime(0)
        end
        return
	end
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)

	
	self.IBIS = self:CreateRT("IBIS",512,128)
	

    self.Locked = 0

    self.EngineSNDConfig = {}

    self.SoundNames = {}

    self.SoundNames["loop_main"] = "lilly/uf/u2/engineloop_test.mp3"
    self.SoundNames["loop_secondary"] = "lilly/uf/u2/engineloop_test.mp3"


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

    self.CamshaftMadeSound = false
	
	self.ThrottleLastEngaged = 0

    self.ElectricOnMoment = 0
	self.IBISKickStart = false
	self.IBISStarted = false
	self.StartupSoundPlayed = false

    self.WarningAnnouncement = false

    self.CabWindowL = 0
    self.CabWindowR = 0
	
	--self.LeftMirror = self:CreateRT("LeftMirror",512,256)
    --self.RightMirror = self:CreateRT("RightMirror",128,256)

    self.ScrollModifier = 0
    self.ScrollMoment = 0

    self.PrevTime = 0
    self.DeltaTime = 0
    self.MotorPowerSound = 0

    self.Nags = {
        "Nag1",
        "Nag2",
        "Nag3"
    }
    self.Speed = 0

    self.BatterySwitch = 0.5
end




function ENT:Think()
	self.BaseClass.Think(self)

    self.Speed = self:GetNW2Int("Speed")
	
    if self:GetPackedBool("FlickBatterySwitchOn",false) == true then
        self.BatterySwitch = 1
    elseif self:GetPackedBool("FlickBatterySwitchOff",false) == true then
        self.BatterySwitch = 0
    else
        self.BatterySwitch = 0.5
    end
    
    self:Animate("Mirror",self:GetNW2Float("Mirror",0),0,100,17,1,0)
    self:Animate("drivers_door",self:GetNW2Float("DriversDoorState",0),0,100,1,1,false)
    self:Animate("blinds_l",self:GetNW2Float("Blinds",0),0,100,50,9,false)


    if self:GetNW2Float("ThrottleStateAnim",0) >= 0.5 then
	    self:Animate("Throttle",self:GetNWFloat("ThrottleStateAnim", 0.5),-45,45,50,8,false)
    elseif self:GetNW2Float("ThrottleStateAnim",0) <= 0.5 then
        self:Animate("Throttle",math.Clamp(self:GetNWFloat("ThrottleStateAnim", 0.5),0.09,1),-45,45,50,8,false)
    end


    if self:GetPackedBool("BOStrab",false) == true then
        gui.OpenURL( "http://thenest.dynv6.net:8085/lightrail/" )
    end

    self:Animate("reverser",self:GetNW2Float("ReverserAnimate"),0,100,50,9,false)
    self.CabWindowL = self:GetNW2Float("CabWindowL",0)
    self.CabWindowR = self:GetNW2Float("CabWindowR",0)
    self:Animate("window_cab_r",self:GetNW2Float("CabWindowR",0),0,100,50,9,false)
    self:Animate("window_cab_l",self:GetNW2Float("CabWindowL",0),0,100,50,9,false)

    --player:PrintMessage(HUD_PRINTTALK,self:GetNW2Float("CabWindowL",0))


    if self:GetNW2String("BlinkerDirection","none") == "none" then
        self:Animate("BlinkerSwitch",0.5,0,100,100,10,false)
    elseif self:GetNW2String("BlinkerDirection","none") == "left" then
        self:Animate("BlinkerSwitch",1,0,100,100,10,false)
    elseif self:GetNW2String("BlinkerDirection","none") == "right" then
        self:Animate("BlinkerSwitch",0,0,100,100,10,false)
    end

    if self:GetNWString("DoorSide","none") == "left" then
        self:Animate("DoorSwitch",1,0,100,100,10,false)
    elseif self:GetNWString("DoorSide","none") == "none" then
        self:Animate("DoorSwitch",0.5,0,100,100,10,false)
    elseif self:GetNWString("DoorSide","none") == "right" then
        self:Animate("DoorSwitch",0,0,100,100,10,false)
    end

    
    	if self:GetNW2Bool("ReverserInserted",false) == true then
        	self:ShowHide("reverser",true)
    	elseif self:GetNW2Bool("ReverserInserted",false) == false then
        	self:ShowHide("reverser",false,0)
    	end

    self:Animate("Door_fr2",self:GetNW2Int("Door1-2a"),0,100,1,.3,false)
    self:Animate("Door_fr1",self:GetNW2Int("Door1-2a"),0,100,1,.3,false)

    self:Animate("Door_rr2",self:GetNW2Int("Door3-4a"),0,100,1,.3,false)
    self:Animate("Door_rr1",self:GetNW2Int("Door3-4a"),0,100,1,.3,false)

    self:Animate("Door_fl2",self:GetNW2Int("Door7-8b"),0,100,1,.3,false)
    self:Animate("Door_fl1",self:GetNW2Int("Door7-8b"),0,100,1,.3,false)
    
    self:Animate("Door_rl2",self:GetNW2Int("Door5-6b"),0,100,1,.3,false)
    self:Animate("Door_rl1",self:GetNW2Int("Door5-6b"),0,100,1,.3,false)

    if self:GetNW2Bool("Microphone",false) == true then
        if self.Microphone == false then
            self.Microphone = true
            self:PlayOnce(self.Nags[1],"cabin",1,1)
        end
    end

    if self:GetNW2Bool("Microphone",false) == false then
        self.Microphone = false
    end




    if self:GetNW2Bool("CamshaftMoved",false) == true and self.CamshaftMadeSound == false then
        self.CamshaftMadeSound = true
        self:PlayOnce("Switchgear"..math.random(1,7),"cabin",0.2,1)
    else
        self.CamshaftMadeSound = false
    end

    --print(self.CamshaftMadeSound)

    
    
    	if self:GetPackedBool("HeadlightsSwitch",false) == true then
        	self:ShowHide("headlights_on",true,0)
            self:Animate("HeadlightSwitch",1,0,100,100,10,false)
    	elseif self:GetPackedBool("HeadlightsSwitch",false) == false then
        	self:ShowHide("headlights_on",false,0)
            self:Animate("HeadlightSwitch",0,0,100,100,10,false)
    	end
       

    	if self:GetNW2Bool("BlinkerShineLeft",false) == true then
        	self:SetLightPower(11,true)
    	else
        	self:SetLightPower(11,false)
    	end


    self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"),0,80) / 100 * 1.5

    self:Animate("Speedo",self.SpeedoAnim,0,100,32,0,0)
    --self:Animate("Throttle",0,-45,45,3,0,false)
	
    
    self:SetSoundState("DoorsCloseAlarm", self:GetNW2Bool("DoorAlarm",false) and 1 or 0,1)
    
      
    if self:GetNW2Bool("DeadmanAlarmSound",false) == true or self:GetNW2Bool("TractionAppliedWhileStillNoDeadman",false) == true then
        self:SetSoundState("Deadman",1,1)
    else
        self:SetSoundState("Deadman",0,1)
    end


    self.VoltAnim = self:GetNW2Float("BatteryCharge",0) / 46

    self:Animate("Voltage",self.VoltAnim,0,100,1,0,false)
    self.AmpAnim = self:GetNW2Float("Amps",0) / 0.5 * 100
    self:Animate("Amps",self.AmpAnim,0,100,1,0,false)
        --print(self.AmpAnim)
    if self:GetNW2Bool("Cablight",false) == true then
        self:Animate("DriverLightSwitch",1,0,100,100,10,false)
    else
        self:Animate("DriverLightSwitch",0.5,0,100,100,10,false)
    end

    if self:GetNW2Bool("BatteryOn",false) == true then
        
       


        if self:GetNW2Bool("Cablight",false) == true --[[self:GetNW2Bool("BatteryOn",false) == true]] then
            self:SetLightPower(6,true)
            self:SetLightPower(16,true)
        elseif self:GetNW2Bool("Cablight",false) == false then
            self:SetLightPower(6,false)
            self:SetLightPower(16,false)
        end

        if self:GetNW2Bool("Bell",false) == true then
	    	self:SetSoundState("bell",1,1)
        	self:SetSoundState("bell_in",1,1)
        else
            self:SetSoundState("bell",0,1)
        	self:SetSoundState("bell_in",0,1)
        end    

    if self:GetNW2Bool("EmergencyBrake",false) == true then
        self:Animate("Throttle",-1,-45,45,50,8,false)
    end

        self:SetSoundState("horn",self:GetNW2Bool("Horn",false) and 1 or 0,1)
    

            if self:GetNW2Bool("BlinkerTick",false) == true and self.BlinkerTicked == false then

        
                self:PlayOnce("Blinker","cabin",5,1)   
                --self:SetNW2Bool("BlinkerTicked",true)
                self.BlinkerTicked = true
            elseif self:GetNW2Bool("BlinkerTick",false) == false then
                --self:SetNW2Bool("BlinkerTicked",false)
                --self:SetSoundState("Blinker",1,1,1)
                --self:SetNW2Bool("BlinkerTick",false)
                self.BlinkerTicked = false
             end


             	-- Fan handler


        if self:GetNW2Bool("Fans",false) == true and self:GetNW2Bool("BatteryOn",false) == true then
            self:SetSoundState("Fan1",1,1,1)
            self:SetSoundState("Fan2",1,1,1)
            self:SetSoundState("Fan3",1,1,1)
        end

        if self:GetNW2Bool("Fans",false) == false then
            
                self:SetSoundState("Fan1",0,1,1 )
                self:SetSoundState("Fan2",0,1,1 )
                self:SetSoundState("Fan3",0,1,1 )
            
        end

        if self:GetNW2Bool("DoorsUnlocked",false) == true and self.DoorOpenSoundPlayed == false then
            self.DoorOpenSoundPlayed = true
            self.DoorCloseSoundPlayed = false
            self:PlayOnce("Door_open1","cabin",0.4,1)
            self.DoorsOpen = true
        end

        if self:GetNW2Bool("DoorsUnlocked",false) == false and self.DoorsOpen == true and self.DoorCloseSoundPlayed == false then
            self.DoorCloseSoundPlayed = true
            self.DoorsOpen = false
            self:PlayOnce("Door_close1","cabin",0.4,1)
            self.DoorOpenSoundPlayed = false
        end
        
        
	    if self.IBISStarted == false then
            if self:GetNW2Bool("IBISChime",false) == true then
                if self:GetNW2Bool("IBISBootupComplete",false) == true then
                    self.IBISStarted = true
                    self:PlayOnce("IBIS_bootup",Vector(412,-12,55),1,1)
                    --print("IBIS bootup complete")
                end

            end
        end
	
	    
		if self.StartupSoundPlayed == false then
		    self.StartupSoundPlayed = true
		    self:PlayOnce("Startup","cabin",1,1)
		end    
	    
		if self:GetPackedBool("WarningAnnouncement") == true then
            self:PlayOnce("Keep Clear",Vector(350,-30,113),1,1)
        end
    elseif self:GetNW2Bool("BatteryOn",false) == false then --what shall we do when the battery is off
		self.StartupSoundPlayed = false	

    end




    self:SetLightPower(9,true)
    self:SetLightPower(10,true)

    if self:GetPackedBool("Headlights",false) == true then
            
		    if self:GetPackedBool("Headlights",false) == true then
                
                    self:SetLightPower(1,true)
                    self:SetLightPower(2,true)
                    self:SetLightPower(4,false)
                    self:SetLightPower(5,false)
            elseif
            self:GetPackedBool("Headlights",false) == false then
                
                self:SetLightPower(1,false)
                self:SetLightPower(2,false)
            elseif
                self:GetPackedBool("Taillights") == true then
                    self:SetLightPower(1,false)
                    self:SetLightPower(2,false)
                    self:SetLightPower(4,true)
                    self:SetLightPower(5,true)
            elseif
                self:GetPackedBool("Taillights") == false and self:GetPackedBool("Headlights",false) == true  then
                    self:SetLightPower(1,true)
                    self:SetLightPower(2,true)
                    self:SetLightPower(4,false,100)
                    self:SetLightPower(5,false,100)
            end

    elseif self:GetPackedBool("Headlights",false) == false then
            self:SetLightPower(1,false)
            self:SetLightPower(2,false)
            

    elseif self:GetPackedBool("Taillights") == true then
            self:SetLightPower(1,false)
            self:SetLightPower(2,false)
            self:SetLightPower(4,true)
            self:SetLightPower(5,true)
        

    end

    if self:GetNW2Bool("Braking",false) == true then
        self:SetLightPower(4, true)
        self:SetLightPower(5, true)
    else
        self:SetLightPower(4, false)
        self:SetLightPower(5, false)
    end
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
    local dT = self.DeltaTime

	local nxt = 35

	

        

   
    
    
    --print(self.Speed)
    

	
	

    --self:U2SoundEngine()
	self:ScrollTracker()
    --[[if self.Speed > 15 then

        self:SetSoundState("Cruise",math.min(self.Speed / 80+0.2),1,1,1)
        self:SetSoundState("rumb1",math.min(self.Speed / 80+0.2),1,1,1)
    else
        self:SetSoundState("Cruise",math.min(self.Speed / 80+0.2),0,1,1)
        self:SetSoundState("rumb1",math.min(self.Speed / 80+0.2),0,1,1)
    end]]
	
end
Metrostroi.GenerateClientProps()

function ENT:U2SoundEngine()

    if self.Speed > 30 then
        self:SetSoundState("Cruise",self.Speed / 80+0.2,1,1,1)
    elseif self.Speed < 30 and self.Speed > 10 then
        self:SetSoundState("Cruise",self.Speed / 80,1,1,1)
    elseif self.Speed < 10 then
        self:SetSoundState("Cruise",0,1,1,1)
    end
end

function ENT:SetSoundState2(sound,volume,pitch,name,level )
    if not self.Sounds[sound] then
        if self.SoundNames[name or sound] and (not wheels or IsValid(self:GetNW2Entity("TrainWheels"))) then
            self.Sounds[sound] = CreateSound(wheels and self:GetNW2Entity("TrainWheels") or self, Sound(self.SoundNames[name or sound]))
        else
            return
        end
    end
    local snd = self.Sounds[sound]
    if (volume <= 0) or (pitch <= 0) then
        if snd:IsPlaying() then
            snd:ChangeVolume(0.0,0)
            snd:Stop()
        end
        return
    end
    local pch = math.floor(math.max(0,math.min(255,100*pitch)) )
    local vol = math.max(0,math.min(255,2.55*volume)) + (0.001/2.55) + (0.001/2.55)*math.random()
    if name~=false and not snd:IsPlaying() or name==false and snd:GetVolume()==0 then
    --if not self.Playing[sound] or name~=false and not snd:IsPlaying() or name==false and snd:GetVolume()==0 then
        if level and snd:GetSoundLevel() ~= level then
            snd:Stop()
            snd:SetSoundLevel(level)
        end
        snd:PlayEx(vol,pch+1)
    end
    --snd:SetDSP(22)
    snd:ChangeVolume(vol,0)
    snd:ChangePitch(pch+1,0)
    --snd:SetDSP(22)
end

function ENT:ScrollTracker()

    if self:GetNW2Bool("Rollsign+",false) == true then
        self.ScrollModifier = self.ScrollModifier + 0.0001
        self.ScrollMoment = RealTime()
        self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
    elseif self:GetNW2Bool("Rollsign-",false) == true then
        self.ScrollModifier = self.ScrollModifier - 0.0001
        self.ScrollMoment = RealTime()
        self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
    elseif self:GetNW2Bool("Rollsign-",false) == false and self:GetNW2Bool("Rollsign+",false) == false then
        self.ScrollModifier = self.ScrollModifier
        self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
    elseif self:GetNW2Bool("Rollsign-",false) == false and self:GetNW2Bool("Rollsign+",false) == false and self.ScrollMoment - RealTime() > 20 then
        self.ScrollModifier = self:GetNW2Float("ActualScrollState")
        self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
    end
end