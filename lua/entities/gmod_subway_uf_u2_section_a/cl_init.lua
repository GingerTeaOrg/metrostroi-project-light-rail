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
    [6] = { "headlight",        Vector(406,39,98), Angle(90,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.7, texture = "effects/flashlight/soft.vmt" },
    [7] = { "headlight",        Vector(545,38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[8] = { "headlight",        Vector(545,-38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
    [9] = { "dynamiclight",        Vector(400,30,490), Angle(90,0,0), Color(226,197,160), fov=100,    brightness = 0.9, scale = 1.0, texture = "effects/flashlight/soft.vmt" }, --passenger light front left
    [10] = { "dynamiclight",        Vector(400,-30,490), Angle(90,0,0), Color(226,197,160), fov=100,    brightness = 1.0, scale = 1.0, texture = "effects/flashlight/soft.vmt" }, --passenger light front right
	[11] = { "dynamiclight",        Vector(327,-52,71), Angle(90,0,0), Color(255,102,0), fov=100,    brightness = 1.0, scale = 1.0, texture = "effects/flashlight/soft.vmt" },
}


ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlights_on.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}




ENT.ClientProps["Door_fr1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fr2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fl1"] = {
	model = "models/lilly/uf/u2/door_h_fl1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fl2"] = {
	model = "models/lilly/uf/u2/door_h_fl2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_rr1"] = {
	model = "models/lilly/uf/u2/door_h_rr1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_rr2"] = {
	model = "models/lilly/uf/u2/door_h_rr2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_rl1"] = {
	model = "models/lilly/uf/u2/door_h_rl1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_rl2"] = {
	model = "models/lilly/uf/u2/door_h_rl2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}


ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	--pos = Vector(530,-20.5,78),
    pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Pantograph"] = {
	model = "models/lilly/uf/common/pantograph.mdl",
	pos = Vector(43,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}



ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(413,31,55),
    ang = Angle(0,-90,0),
    hideseat = 0.2,
}

--[[ENT.ClientProps["reverser_lever"] = {
    model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
    pos = Vector(482.5,35.2,78),
    ang = Angle(0,-90,0),
    hideseat = 0.2,
}
ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/common/cab/speedneedle.mdl",
    pos = Vector(528,12.8,77.01),
    ang = Angle(-0.1,-90,9),
    hideseat = 0.2,
}]]

--[[
ENT.ButtonMap["Cab"] = {
    pos = Vector(484.9,32,77.2),
    ang = Angle(0,-90,8),
    width = 649,
    height = 130,
    scale = 0.069,
	
    buttons = {
		
    {ID = "WarningAnnouncementSet", x=345, y=22, radius=10, tooltip = "Please keep back announcement", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=1, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetHoldingBrakeSet", x=38.45, y=114, radius=10, tooltip = "Set mechanical holding brake manually", model = {
        model = "models/lilly/uf/common/cab/button_red.mdl", z=-1, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ReleaseHoldingBrakeSet", x=38.4, y=73, radius=10, tooltip = "Release mechanical holding brake manually", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerOvergroundSet", x=79, y=72, radius=10, tooltip = "Set passenger lights to overground mode", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerUndergroundSet", x=79, y=114, radius=10, tooltip = "Set passenger lights to underground mode", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "LightsToggle", x=39, y=21, radius=10, tooltip = "Enable Headlights", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=2,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "BatteryToggle", x=589, y=115, radius=10, tooltip = "Toggle Battery", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DriverLightToggle", x=589, y=83, radius=10, tooltip = "Toggle Cab Light", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointLeftSet", x=237, y=112, radius=10, tooltip = "Set track point to left", model = {
        model = "models/lilly/uf/common/cab/button_right.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ClearDoorClosedAlarmSet", x=276.5, y=113, radius=10, tooltip = "Clear door closed alarm", model = {
        model = "models/lilly/uf/common/cab/button_loeschen.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointRightSet", x=315, y=112, radius=10, tooltip = "Set track point to right", model = {
        model = "models/lilly/uf/common/cab/button_left.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "IndicatorLightsSwitchToggle", x=420, y=112, radius=10, tooltip = "Indicators Left/Right/Off", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "LowerPantographSet", x=449, y=112, radius=10, tooltip = "Lower pantograph", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ThrowCouplerSet", x=477, y=112, radius=10, tooltip = "Throw Coupler", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "OpenDoor1Set", x=502, y=112, radius=10, tooltip = "Open only door 1", model = {
        model = "models/lilly/uf/common/cab/button_red.mdl", z=-2.5, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SanderToggle", x=561, y=112, radius=10, tooltip = "Toggle sanding", model = {
        model = "models/lilly/uf/common/cab/button_red.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "UnlockDoorsSet", x=531, y=84, radius=10, tooltip = "Toggle doors unlocked", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "RaisePantographSet", x=449, y=80, radius=10, tooltip = "Raise Pantograph", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DoorSideSelectToggle", x=531, y=46, radius=10, tooltip = "Select door set to unlock", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "DoorCloseSignalSet", x=531, y=112, radius=10, tooltip = "Set doors to close", model = {
        model = "models/lilly/uf/common/cab/button_red.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
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
    pos = Vector(416.65,-14.8,59.6),
    ang = Angle(0,45,-48.5,0),
    width = 2,
    height = 2,
    scale = 0.0311,
}
--[[ENT.ButtonMap["IBIS"] = {
    pos = Vector(531,-23,84.9),
    ang = Angle(48,-225,0),
    width = 133,
    height = 230,
    scale = 0.04,

    buttons = {
        {ID = "Number1Set", x=41, y=72, radius=10, tooltip = "1",
        sndvol = 0.5, snd = function(val) return val and "IBIS_beep" or "IBIS_beep" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            
        },
        {ID = "Number2Set", x=40, y=50, radius=10, tooltip = "2", --[[model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
        },
        {ID = "Number3Set", x=40, y=27, radius=10, tooltip = "3", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
        },
        {ID = "Number4Set", x=65, y=72, radius=10, tooltip = "4", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number5Set", x=65, y=50, radius=10, tooltip = "5", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number6Set", x=65, y=27, radius=10, tooltip = "6", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number7Set", x=85, y=72, radius=10, tooltip = "7", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number8Set", x=85, y=50, radius=10, tooltip = "8", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number9Set", x=85, y=27, radius=10, tooltip = "9", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "DeleteSet", x=109, y=72, radius=10, tooltip = "Delete", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "Number0Set", x=109, y=50, radius=10, tooltip = "0", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "EnterSet", x=109, y=27, radius=10, tooltip = "Confirm", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "TimeAndDateSet", x=109, y=95, radius=10, tooltip = "Set time and date", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "SpecialAnnouncementsSet", x=109, y=118, radius=10, tooltip = "Special Annoucements", model = {
            model = "m", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
        {ID = "DestinationSet", x=85, y=95, radius=10, tooltip = "Destination", model = {
            model = "", z=0, ang=0,
            var="main",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
                }
        },
    }
}]]--

ENT.ButtonMap["LastStation"] = {
    pos = Vector(544,-25,145),
    ang = Angle(0,90,90),
    width = 840,
    height = 205,
    scale = 0.0625,
    buttons = {
        {ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
        {ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
    }
}
--[[]
ENT.ButtonMap["Left"] = {
    pos = Vector(527.7,39.5,74.5),
    ang = Angle(0,180,0),
    width = 160,
    height = 80,
    scale = 0.1,
    buttons = {
        {ID = "ParrallelToggle", x=24, y=21, radius=3, tooltip = "Set engines to shunt mode (not yet implemented)", model = {
            model = "models/lilly/uf/u2/switch_flick.mdl", z=5, ang=90,
            var="Parrallel",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),},
        },
        {ID = "WarnBlinkToggle", x=92, y=70, radius=3, tooltip = "Set indicators to warning mode", model = {
            model = "models/lilly/uf/u2/switch_flick.mdl", z=5, ang=0,
            var="Parrallel",speed=1, vmin=0, vmax=1,
            sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),},
        },
        }
}



]]
	
function ENT:Draw()
    self.BaseClass.Draw(self)
end


function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture",self.IBIS)
    self:DrawOnPanel("IBISScreen",function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255,255,255)
        surface.DrawTexturedRectRotated(55.5,12,108.5,25,0)
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



    self.CabLight = 0

    self.SpeedoAnim = 0
	
    --self:ShowHide("headlights_on",false,0)
	
	self.ThrottleLastEngaged = 0

    self.ElectricOnMoment = 0
	
	--self.LeftMirror = self:CreateRT("LeftMirror",512,256)
    --self.RightMirror = self:CreateRT("RightMirror",128,256)
end




function ENT:Think()
	self.BaseClass.Think(self)

    

	self:Animate("Throttle",self:GetNWFloat("ThrottleStateAnim", 0.5),-45,45,5,0.5,false)
    self:Animate("reverser_lever",10,0,100,5,0.5,false)

    if self:GetNW2Bool("ReverserInserted",false) == true then
        self:ShowHide("reverser_lever",true)
    elseif self:GetNW2Bool("ReverserInserted",false) == false then
        self:ShowHide("reverser_lever",false,0)
    end


    if self:GetNW2Bool("Cablight",false) == true --[[self:GetNW2Bool("BatteryOn",false) == true]] then
        self:SetLightPower(6,true)
    elseif self:GetNW2Bool("Cablight",false) == false then
        self:SetLightPower(6,false)
    end


    if self:GetNW2Bool("HeadlightsSwitch",false) == true and self:GetNW2Int("ReverserState",0) == 1 and self:GetNW2Bool("BatteryOn",false) then
        self:ShowHide("headlights_on",true,0)
    elseif self:GetNW2Bool("HeadlightsSwitch",false) == false then
        self:ShowHide("headlights_on",false,0)
    end

    if self:GetNW2Bool("BlinkerShineLeft",false) == true then
        self:SetLightPower(11,true)
    else
        self:SetLightPower(11,false)
    end


    self.SpeedoAnim = math.Clamp(self:GetNW2Float("Speed"),0, 80) * 0.01 * 2

    self:Animate("Speedo",self.SpeedoAnim,0,200,1,0.1,false)
    --self:Animate("Throttle",0,-45,45,3,0,false)
	
    
    self:SetSoundState("DoorsCloseAlarm", self:GetNW2Bool("DoorAlarm",false) and 1 or 0,1)
    
      

    self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound",false) and 1 or 0,1)

    --local JustLocked 

    if self:GetNW2Bool("BatteryOn",false) == true then
        
        if self:GetNW2Bool("DoorsClosedAlarmTrigger",false) == true then
            self:SetNW2Bool("DoorsClosedAlarmTrigger",false)

            self.JustLocked = CurTime()
        else 
            self.JustLocked = 0
        end

        if CurTime() - self.JustLocked > 5 and self:GetNW2Bool("DoorsClosedAlarmTrigger",false) == true then

            self:SetSoundState("DoorsCloseAlarm",true and 1 or 0,1)
        else
            self:SetSoundState("DoorsCloseAlarm",false and 1 or 0,1)
        end



	    self:SetSoundState("bell",self:GetNW2Bool("Bell",false) and 1 or 0,1)
        self:SetSoundState("bell_in",self:GetNW2Bool("Bell",false) and 1 or 0,1)
        self:SetSoundState("horn",self:GetNW2Bool("Horn",false) and 1 or 0,1)
    

            if self:GetNW2Bool("BlinkerTick",false) == true and not self:GetNW2Bool("BlinkerTicked",false) == true then

        
                self:PlayOnce("Blinker","cabin",0.4,1)   
                self:SetNW2Bool("BlinkerTicked",true)
        
            elseif self:GetNW2Bool("BlinkerTick",false) == false then
                self:SetNW2Bool("BlinkerTicked",false)
               --self:SetSoundState("Blinker",1,1,1)
               --self:SetNW2Bool("BlinkerTick",false)
             end

        if self:GetNW2Bool("DoorsUnlocked",false) == true and self:GetNW2Bool("DoorOpenSoundPlayed",false) == false then
            self:SetNW2Bool("DoorOpenSoundPlayed",true)
            self:SetNW2Bool("DoorCloseSoundPlayed",false)
            self:PlayOnce("Door_open1","cabin",0.4,1)
            self:SetNW2Bool("DoorsOpen",true)
        end

        if self:GetNW2Bool("DoorsUnlocked",false) == false and self:GetNW2Bool("DoorsOpen",false) == true and self:GetNW2Bool("DoorCloseSoundPlayed",false) == false then
            self:SetNW2Bool("DoorCloseSoundPlayed",true)
            self:SetNW2Bool("DoorsOpen",false)
            self:PlayOnce("Door_close1","cabin",0.4,1)
            self:SetNW2Bool("DoorOpenSoundPlayed",false)
        end
        
        if self:GetNW2Bool("IBIS_started",false) == false then 
            self:SetNW2Bool("IBIS_started",true)
            self.ElectricOnMoment = CurTime()
        end
    end

    --if CurTime() - self.ElectricOnMoment = 3 then
      --  self:PlayOnce("IBIS_bootup", "bass",1,1)
    --end
    --[[if self:GetNW2Bool("BatteryOn",false) == true then

        if self:GetNW2Bool("StartupPlayed",false) == false and self:GetNW2Bool("BatteryOn",false) == true then
            self:PlayOnce("Startup","cabin",1,1)
            self:SetNW2Bool("StartupPlayed",true)
            
        
        elseif self:GetNW2Bool("BatteryOn",false) == false then
            self:SetNW2Bool("StartupPlayed",false)
        end
    end]]

    


	if self:GetNW2Bool("WarningAnnouncement") == true then
        self:PlayOnce("WarningAnnouncement","cabin",1,1)

	end


    --[[local delay
    local startMoment
    delay = 15
    if self:GetNW2Bool("IBIS_impulse",false) == true then
        startMoment = CurTime()
        if startMoment - delay > 15 then
            self:PlayOnce("IBIS_bootup", "bass",1,1)
        end
    end]]

    self:SetLightPower(9,true)
    self:SetLightPower(10,true)

    if self:GetNW2Bool("Headlights",false) == true then
            
		    if self:GetNW2Bool("Headlights",false) == true then
                
                    self:SetLightPower(1,true)
                    self:SetLightPower(2,true)
                    self:SetLightPower(4,false)
                    self:SetLightPower(5,false)
            elseif
            self:GetNW2Bool("Headlights",false) == false then
                
                self:SetLightPower(1,false)
                self:SetLightPower(2,false)
            elseif
                self:GetNW2Bool("Taillights") == true then
                    self:SetLightPower(1,false)
                    self:SetLightPower(2,false)
                    self:SetLightPower(4,true)
                    self:SetLightPower(5,true)
            elseif
                self:GetNW2Bool("Taillights") == false and self:GetNW2Bool("Headlights",false) == true  then
                    self:SetLightPower(1,true)
                    self:SetLightPower(2,true)
                    self:SetLightPower(4,false,100)
                    self:SetLightPower(5,false,100)
            end

    elseif self:GetNW2Bool("Headlights",false) == false then
            self:SetLightPower(1,false)
            self:SetLightPower(2,false)
            

    elseif self:GetNW2Bool("Taillights") == true then
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
	
	
	
	
	-- Fan handler

    if self:GetNW2Bool("Fans",false) == true then
        self.ThrottleLastEngaged = CurTime()
    end

    if self:GetNW2Bool("Fans",false) == true and self:GetNW2Bool("BatteryOn",false) == true then
        self:SetSoundState("Fan1",1,1,1)
        self:SetSoundState("Fan2",1,1,1)
        self:SetSoundState("Fan3",1,1,1)
    end

    if self:GetNW2Bool("Fans",false) == false and self:GetNW2Int("Speed",0) < 3 then
        if CurTime() - self.ThrottleLastEngaged > 2 then
            self:SetSoundState("Fan1",0,1,1 )
            self:SetSoundState("Fan2",0,1,1 )
            self:SetSoundState("Fan3",0,1,1 )
        end
    end
	
	
	
	
	
	
	
	
	
	
	
	
    local dT = self.DeltaTime
	local speed = self:GetNW2Int("Speed")/100

	local nxt = 35

	
    if self:GetNW2Int("Speed") > 30 then
        self:SetSoundState("Cruise",math.Clamp(self:GetNW2Int("Speed"),0,100),1,1)
    end

    if self:GetNW2Int("Speed") < 10 then
        self:SetSoundState("Cruise",0,1,1)
    end

	
	
    local rollingi = math.min(1,self.TunnelCoeff+math.Clamp((self.StreetCoeff-0.82)/0.3,0,1))
    local rollings = math.max(self.TunnelCoeff*1,self.StreetCoeff)
	
	local rol5 = math.Clamp(speed/1,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol10 = math.Clamp(speed/12,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol40p = Lerp((speed)/12,0.6,1)
    local rol40 = math.Clamp((speed)/8,0,1)*(1-math.Clamp((speed)/8,0,1))
    local rol40p = Lerp((speed)/50,0.6,1)
    local rol70 = math.Clamp((speed)/8,0,1)*(1-math.Clamp((speed)/5,0,1))
    local rol70p = Lerp(0.8+(speed)/25*0.2,0.8,1.2)
    local rol80 = math.Clamp((speed)/5,0,1)
    local rol80p = Lerp(0.8+(speed)/15*0.2,0.8,1.2)
	
	
	
	--self:SetSoundState("rolling_10",math.min(1,rollingi*(1-rollings)+rollings*0.8)*rol5,1)
    --self:SetSoundState("rolling_10",rollingi*rol10,1)
    --self:SetSoundState("rolling_40",rollingi*rol40,rol40p)
    --self:SetSoundState("rolling_70",rollingi*rol70,rol70p)
    --self:SetSoundState("rolling_80",rollingi*rol80,rol80p)

	local rol_motors = math.Clamp((speed-20)/40,0,1)
    --self:SetSoundState("MotorType1",math.max(rollingi,rollings*0.8)*rol_motors,self:GetNW2Int("Speed")/56)
    self:SetSoundState("MotorType1",1,speed/56)
    --self:SetSoundState("MotorType1",10,1,1)
    --local rol10 = math.Clamp(speed/15,0,1)*(1-math.Clamp((speed)/35,0,1))
    --local rol10p = Lerp((speed)/14,0.6,0.78)
    local rol40 = math.Clamp((speed-18)/35,0,1)*(1-math.Clamp((speed)/40,0,1))
    local rol40p = Lerp((speed)/66,0.6,1.3)
    local rol70 = math.Clamp((speed-55)/20,0,1)--*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp((speed)/27,0.78,1.15)
	
	
end
Metrostroi.GenerateClientProps()
