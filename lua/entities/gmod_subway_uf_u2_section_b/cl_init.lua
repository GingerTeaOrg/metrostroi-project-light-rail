include("shared.lua")

ENT.ClientProps = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ButtonMapMPLR = {}

ENT.Lights = {
    -- Headlight glow
    [1] = {
        "headlight",
        Vector(-410, 39, 43),
        Angle(10, 0, 0),
        Color(216, 161, 92),
        fov = 60,
        farz = 600,
        brightness = 1.2,
        texture = "models/metrostroi_train/equipment/headlight",
        shadows = 1,
        headlight = true
    },
    [2] = {
        "headlight",
        Vector(-410, -39, 43),
        Angle(10, 0, 0),
        Color(216, 161, 92),
        fov = 60,
        farz = 600,
        brightness = 1.2,
        texture = "models/metrostroi_train/equipment/headlight",
        shadows = 1,
        headlight = true
    },
    [3] = {
        "light",
        Vector(-406, 0, 100),
        Angle(0, 0, 0),
        Color(216, 161, 92),
        fov = 40,
        farz = 450,
        brightness = 3,
        texture = "effects/flashlight/soft",
        shadows = 1,
        headlight = true
    },
    [4] = {
        "headlight",
        Vector(-545, 38.5, 40),
        Angle(-20, 0, 0),
        Color(255, 0, 0),
        fov = 50,
        brightness = 0.7,
        farz = 50,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [5] = {
        "headlight",
        Vector(-545, -38.5, 40),
        Angle(-20, 0, 0),
        Color(255, 0, 0),
        fov = 50,
        brightness = 0.7,
        farz = 50,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [6] = {
        "headlight",
        Vector(-406, 39, 98),
        Angle(90, 0, 0),
        Color(226, 197, 160),
        brightness = 0.9,
        scale = 0.7,
        texture = "effects/flashlight/soft.vmt"
    }, -- cab lights
    [16] = {
        "headlight",
        Vector(-406, -39, 98),
        Angle(90, 0, 0),
        Color(226, 197, 160),
        brightness = 0.9,
        scale = 0.7,
        texture = "effects/flashlight/soft.vmt"
    },
    [7] = {
        "headlight",
        Vector(-545, 38.5, 45),
        Angle(-20, 0, 0),
        Color(255, 102, 0),
        fov = 50,
        brightness = 0.7,
        farz = 50,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [8] = {
        "headlight",
        Vector(-545, -38.5, 45),
        Angle(-20, 0, 0),
        Color(255, 102, 0),
        fov = 50,
        brightness = 0.7,
        farz = 50,
        texture = "models/metrostroi_train/equipment/headlight2",
        shadows = 0,
        backlight = true
    },
    [9] = {
        "dynamiclight",
        Vector(-400, 30, 490),
        Angle(90, 0, 0),
        Color(226, 197, 160),
        fov = 100,
        brightness = 0.9,
        scale = 1.0,
        texture = "effects/flashlight/soft.vmt"
    }, -- passenger light front left
    [10] = {
        "dynamiclight",
        Vector(-400, -30, 490),
        Angle(90, 0, 0),
        Color(226, 197, 160),
        fov = 100,
        brightness = 1.0,
        scale = 1.0,
        texture = "effects/flashlight/soft.vmt"
    }, -- passenger light front right
    [11] = {
        "dynamiclight",
        Vector(-327, -52, 71),
        Angle(90, 0, 0),
        Color(255, 102, 0),
        fov = 100,
        brightness = 1.0,
        scale = 1.0,
        texture = "effects/flashlight/soft.vmt"
    }
}

local function GetDoorPosition(i, k, j)
    if j == 0 then
        return Vector(230.8 - 35.0 * k - 232.2 * i, -67.5 * (1 - 2 * k), 4.3)
    else
        return Vector(230.8 - 35.0 * (1 - k) - 232.2 * i, -66 * (1 - 2 * k),
                      4.25)
    end
end

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self.IBIS = self:CreateRT("IBIS", 512, 128)

    self.ParentTrain = self:GetNWEntity("U2a")
    self.Bogeys = {}

    self.DoorSwitchStates = {["Left"] = 1, ["None"] = 0.5, ["Right"] = 0}

    self.ScrollModifier = 0
    self.ScrollMoment = 0

    if not self.FrontBogey or not self.RearBogey or not self.MiddleBogey then
        self.FrontBogey = self:GetNW2Entity("FrontBogey")
        self.MiddleBogey = self:GetNW2Entity("MiddleBogey")
        self.RearBogey = self:GetNW2Entity("RearBogey")
        table.insert(self.Bogeys, self.FrontBogey)
        table.insert(self.Bogeys, self.MiddleBogey)
        table.insert(self.Bogeys, self.RearBogey)
    end
    self.SpeedoAnim = 0

    self.ThrottleLastEngaged = 0

    self.ParentTrain = self:GetNWEntity("U2a")
    if IsValid(self.ParentTrain) then self:UpdateWagonNumber() end
    self.BatterySwitch = 0.5

end

ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/u2/cab/speedo.mdl",
    pos = Vector(-418.192, -10, 54.66),
    ang = Angle(-8.7, 180, 0),
    nohide = true
}
ENT.ClientProps["Mirror"] = {
    model = "models/lilly/uf/u2/mirror.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    nohide = true
}

ENT.ClientProps["Mirror_vintage"] = {
    model = "models/lilly/uf/u2/mirror_vintage.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    nohide = true
}

ENT.ClientProps["Door_fr1"] = {
    model = "models/lilly/uf/u2/door_h_fr1.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_fr2"] = {
    model = "models/lilly/uf/u2/door_h_fr2.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_rr1"] = {
    model = "models/lilly/uf/u2/door_h_fr1.mdl",
    pos = Vector(242.5, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_rr2"] = {
    model = "models/lilly/uf/u2/door_h_fr2.mdl",
    pos = Vector(242.5, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_fl1"] = {
    model = "models/lilly/uf/u2/door_h_fr1.mdl",
    pos = Vector(-721.3, 0, 0),
    ang = Angle(0, 0, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_fl2"] = {
    model = "models/lilly/uf/u2/door_h_fr2.mdl",
    pos = Vector(-721.3, 0, 0),
    ang = Angle(0, 0, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_rl1"] = {
    model = "models/lilly/uf/u2/door_h_fr1.mdl",
    pos = Vector(-479, 0, 0),
    ang = Angle(0, 0, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["Door_rl2"] = {
    model = "models/lilly/uf/u2/door_h_fr2.mdl",
    pos = Vector(-479, 0, 0),
    ang = Angle(0, 0, 0),
    scale = 1,
    nohide = true
}
ENT.ButtonMapMPLR["Rollsign"] = {
    pos = Vector(-424.5, 25, 109),
    ang = Angle(0, 270, 90),
    width = 780,
    height = 160,
    scale = 0.0625,
}

ENT.ClientProps["reverser"] = {
    model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
    pos = Vector(0, 0.5, 0),
    ang = Angle(0, 180, 0),

}
ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(0, 0.2, 0),
    ang = Angle(0, 180, 0),
    nohide = true
}
ENT.ClientProps["cab_decal"] = {
    model = "models/lilly/uf/u2/u2-cabfront-decal-1968.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, -180, 0),
    scale = 1,
    nohide = true
}
ENT.ClientProps["duewag_decal"] = {
    model = "models/lilly/uf/u2/duewag_decal.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1
}
ENT.ClientProps["cab"] = {
    model = "models/lilly/uf/u2/u2-cabfront_b.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}
ENT.ClientProps["headlights_on"] = {
    model = "models/lilly/uf/u2/headlight_on.mdl",
    pos = Vector(-535, 0, 43),
    ang = Angle(0, 180, 0),
    scale = 1,
    hide = 2
}
ENT.ClientProps["carnumber1"] = {
    model = "models/lilly/uf/u2/carnumber_front_1.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}
ENT.ClientProps["carnumber2"] = {
    model = "models/lilly/uf/u2/carnumber_front_2.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}
ENT.ClientProps["carnumber3"] = {
    model = "models/lilly/uf/u2/carnumber_front_3.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1,
    nohide = true
}
ENT.ClientProps["Mirror_vintage"] = {
    model = "models/lilly/uf/u2/mirror_vintage.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    nohide = true
}
ENT.ClientProps["RetroEquipment"] = {
    model = "models/lilly/uf/u2/retroprop_b.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    scale = 1,
    nohide = true
}

ENT.ClientProps["IBIS"] = {
    model = "models/lilly/uf/u2/IBIS.mdl",
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0),
    scale = 1
}
ENT.ButtonMapMPLR["IBISScreen"] = {
    pos = Vector(-419.6, 12.75, 60.35),
    ang = Angle(0, 45.4, 48.5), -- (0,44.5,-47.9),
    width = 117,
    height = 29.9,
    scale = 0.0311
}
ENT.ButtonMapMPLR["IBIS"] = {
    pos = Vector(-415.2, 18, 61),
    ang = Angle(48, -45, 0),
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
                speed = 4,
                min = 0,
                max = 1,
                var = "Number1",
                speed = 1,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "SpecialAnnouncementSet",
            x = 85,
            y = 96,
            radius = 10,
            tooltip = "Special Annoucements",
            model = {
                z = 0,
                ang = 0,
                var = "SpecialAnnouncement",
                speed = 1,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val) return val and "IBIS_beep" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }
    }
}

ENT.ButtonMapMPLR["Cab"] = {
    pos = Vector(-419.6, -24.88, 55.2),
    ang = Angle(0, 90, 8),
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "BlinkerLamp",
            x = 271,
            y = 58,
            radius = 10,
            tooltip = "Blinker Status Lamp",
            model = {
                model = "models/lilly/uf/u2/cab/button_bulge_green.mdl",
                z = -5,
                name = "BlinkerLamp",
            }
        }, {
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
                    lcolor = Color(255, 0, 0),
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "VentilationSet",
            x = 335,
            y = 58,
            radius = 10,
            tooltip = "Enable motor fans",
            model = {
                model = "models/lilly/uf/u2/cab/button_indent_yellow.mdl",
                z = -5,
                ang = 0,
                getfunc = function(ent)
                    return ent:GetPackedRatio("Ventilation")
                end,
                var = "Ventilation",
                speed = 4,
                min = 0,
                max = 1,
                var = "Ventilation",
                speed = 1,
                vmin = 0,
                vmax = 1,
                sndvol = 0.5,
                snd = function(val) return val and "button_on" end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "HighbeamToggle",
            x = 149,
            y = 90.4,
            radius = 10,
            tooltip = "Toggle High Beam",
            model = {
                model = "models/lilly/uf/u2/cab/battery_switch.mdl",
                z = -3,
                ang = 45,
                anim = true,
                var = "Highbeam",
                speed = 5,
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
        }, {
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
        }, {
            ID = "AutomatOnSet",
            x = 118.5,
            y = 90.4,
            radius = 10,
            tooltip = "Automat On",
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "AutomatOffSet",
            x = 118.5,
            y = 57,
            radius = 10,
            tooltip = "Automat Off",
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "HeadlightsToggle",
            x = 22,
            y = 19,
            radius = 10,
            tooltip = "Enable Headlights",
            model = {

                model = "models/lilly/uf/u2/cab/battery_switch.mdl",
                z = 0,
                ang = 45,
                var = "Headlights",
                speed = 5,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 90,
                sndmax = 1e3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "BatteryToggle",
            x = 463,
            y = 91,
            radius = 10,
            tooltip = "Toggle Battery",
            model = {
                model = "models/lilly/uf/u2/cab/battery_switch.mdl",
                z = -2.5,
                ang = 45,
                getfunc = function(ent) return ent.BatterySwitch end,
                var = "BatteryToggle",
                speed = 5,
                min = 0,
                max = 1,
                sndvol = 20,
                snd = function(val, val2)
                    return val2 == 1 and "button_on" or val and "button_on" or
                               "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "BlinkerSwitch",
            x = 271,
            y = 91,
            radius = 0.1,
            tooltip = "Indicator Switch",
            model = {
                model = "models/lilly/uf/u2/cab/battery_switch.mdl",
                z = 0,
                ang = 45,
                getfunc = function(ent)
                    return ent:GetNW2Float("BlinkerStatus")
                end,
                var = "BlinkerStatus",
                speed = 10,
                vmin = 0,
                vmax = 1,
                sndvol = 20,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                    lcolor = Color(129, 0, 0),
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                    lcolor = Color(129, 0, 0),
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
            ID = "DoorsUnlockSet",
            x = 396.4,
            y = 57.7,
            radius = 10,
            tooltip = "Toggle doors unlocked",
            model = {
                model = "models/lilly/uf/u2/cab/button_indent_red.mdl",
                z = -5,
                ang = 180,
                var = "DoorsUnlock",
                speed = 20,
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
        }, {
            ID = "DoorSideSelectToggle",
            x = 396.5,
            y = 17.8,
            radius = 10,
            tooltip = "Door Unlock Side Switch",
            model = {
                model = "models/lilly/uf/u2/cab/battery_switch.mdl",
                z = -2.5,
                ang = 45,
                getfunc = function(ent)
                    return ent.DoorSwitchStates[ent:GetNW2String(
                               "DoorSideUnlocked", "None")]
                end,
                var = "DoorSideSelect",
                speed = 5,
                vmin = 0,
                vmax = 1,
                sndvol = 50,
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }, {
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
                snd = function(val)
                    return val and "button_on" or "button_off"
                end,
                sndmin = 80,
                sndmax = 1e3 / 3,
                sndang = Angle(-90, 0, 0)
            }
        }
    }
}

function ENT:Draw()
    self.BaseClass.Draw(self)
    self:UpdateWagonNumber()
end

function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture", self.IBIS)
    self:DrawOnPanel("IBISScreen", function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(0, 65, 11)
        surface.DrawTexturedRectRotated(59, 16, 116, 25, 0)
    end)

    local mat = Material("models/lilly/uf/u2/rollsigns/frankfurt_stock.png")
    self:DrawOnPanel("Rollsign", function(...)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(mat)
        surface.DrawTexturedRectUV(0, 0, 780, 160, 0, self.ScrollModifier, 1,
                                   self.ScrollModifier + 0.015)
    end)
end
function ENT:UpdateWagonNumber()
    if not IsValid(self.ParentTrain) then return end
    for i = 0, 3 do
        -- self:ShowHide("TrainNumberL"..i,i<count)
        -- self:ShowHide("TrainNumberR"..i,i<count)
        -- if i< count then
        local leftNum, middleNum, rightNum = self.ClientEnts["carnumber1"],
                                             self.ClientEnts["carnumber2"],
                                             self.ClientEnts["carnumber3"]
        local num1 = tonumber(string.sub(
                                  self.ParentTrain:GetNW2Int("WagonNumber"), 1,
                                  1), 10)
        local num2 = tonumber(string.sub(
                                  self.ParentTrain:GetNW2Int("WagonNumber"), 2,
                                  2), 10)
        local num3 = tonumber(string.sub(
                                  self.ParentTrain:GetNW2Int("WagonNumber"), 3,
                                  3), 10)
        if IsValid(leftNum) then
            if num1 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                leftNum:SetSkin(10)
            elseif num1 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                leftNum:SetSkin(11)
            elseif num1 > 0 and self:GetNW2String("Texture") == "OrEbSW" then
                leftNum:SetSkin(num1 + 10)
            else
                leftNum:SetSkin(num1)
            end
        end
        if IsValid(middleNum) then
            if num2 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                middleNum:SetSkin(10)
            elseif num2 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                middleNum:SetSkin(11)
            elseif num2 > 0 and self:GetNW2String("Texture") == "OrEbSW" then
                middleNum:SetSkin(num2 + 10)
            else
                middleNum:SetSkin(num2)
            end
        end
        if IsValid(rightNum) then
            if num3 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                rightNum:SetSkin(10)
            elseif num3 < 1 and self:GetNW2String("Texture") ~= "OrEbSW" then
                rightNum:SetSkin(11)
            elseif num3 > 0 and self:GetNW2String("Texture") == "OrEbSW" then
                rightNum:SetSkin(num3 + 9)
            else
                rightNum:SetSkin(num3)
            end
        end
        -- end
    end

end
function ENT:Think()
    self.BaseClass.Think(self)
    self.ParentTrain = self:GetNWEntity("U2a")
    if not IsValid(self.ParentTrain) then return end -- we don't do anything without the A section

    self.Coupled = self.ParentTrain:GetNW2Bool("BIsCoupled", false) == true

    self.BatteryOn = self.ParentTrain:GetNW2Bool("BatteryOn")

    self:Animations()
    self:SoundRoutine()

end

function ENT:SoundRoutine()
    if self:GetNW2Bool("Bell", false) == true then
        self:SetSoundState("bell", 1, 1)
        self:SetSoundState("bell_in", 1, 1)
    else
        self:SetSoundState("bell", 0, 1)
        self:SetSoundState("bell_in", 0, 1)
    end

    if self:GetNW2Bool("WarningAnnouncement") == true then
        self:PlayOnce("WarningAnnouncement", "cabin", 1, 1)

    end
    self:SetSoundState("Deadman", self.ParentTrain:GetNW2Bool(
                           "DeadmanAlarmSound", false) and 1 or 0, 1)
end

function ENT:Animations()

    self:Animate("Throttle", self:GetNW2Float("ThrottleAnimB", 0), -45, 45, 50)

    self.SpeedoAnim = math.Clamp(self:GetNW2Int("Speed"), 0, 80) / 100 * 1.5
    self:Animate("Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0)

    self:ShowHide("RetroEquipment",
                  self.ParentTrain:GetNW2Bool("RetroMode", false))

    self:ShowHide("reverser",
                  self.ParentTrain:GetNW2Bool("ReverserInsertedB", false))

    self:Animate("reverser", self:GetNW2Float("ReverserAnimate", 0.5), 0, 100,
                 50)

    self.CabWindowL = self:GetNW2Float("CabWindowL", 0)
    self.CabWindowR = self:GetNW2Float("CabWindowR", 0)
    self:Animate("window_cab_r", self:GetNW2Float("CabWindowR", 0), 0, 100, 50,
                 9, false)
    self:Animate("window_cab_l", self:GetNW2Float("CabWindowL", 0), 0, 100, 50,
                 9, false)

    if self.ParentTrain:GetNW2Bool("Headlights", false) == true and
        self:GetNW2Bool("Headlights", false) == true then
        self:ShowHide("headlights_on", true)
    else
        self:ShowHide("headlights_on", false)
    end


    if self:GetPackedBool("FlickBatterySwitchOn", false) == true then
        self.BatterySwitch = 1
    elseif self:GetPackedBool("FlickBatterySwitchOff", false) == true then
        self.BatterySwitch = 0
    else
        self.BatterySwitch = 0.5
    end

    self:Animate("Mirror", self:GetNW2Float("Mirror", 0), 0, 100, 17, 1, 0)
    self:Animate("Mirror_vintage", self:GetNW2Float("Mirror", 0), 0, 100, 17, 1,
                 0)

    self:ShowHide("RetroEquipment",
                  self.ParentTrain:GetNW2Bool("RetroMode", false))

    self:Animate("Door_fr2", self.ParentTrain:GetNW2Float("Door12b"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_fr1", self.ParentTrain:GetNW2Float("Door12b"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_rr2", self.ParentTrain:GetNW2Float("Door34b"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_rr1", self.ParentTrain:GetNW2Float("Door34b"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_fl2", self.ParentTrain:GetNW2Float("Door78a"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_fl1", self.ParentTrain:GetNW2Float("Door78a"), 0, 100,
                 50, 0, 0)

    self:Animate("Door_rl2", self.ParentTrain:GetNW2Float("Door56a"), 0, 100,
                 50, 0, 0)
    self:Animate("Door_rl1", self.ParentTrain:GetNW2Float("Door56a"), 0, 100,
                 50, 0, 0)
    if self.ParentTrain:GetNW2Bool("RetroMode", false) == false then
        self:ShowHide("Mirror_vintage", false)
        self:ShowHide("Mirror", true)
    elseif self.ParentTrain:GetNW2Bool("RetroMode", false) == true then
        self:ShowHide("Mirror", false)
        self:ShowHide("Mirror_vintage", true)
    end

end

UF.GenerateClientProps()
