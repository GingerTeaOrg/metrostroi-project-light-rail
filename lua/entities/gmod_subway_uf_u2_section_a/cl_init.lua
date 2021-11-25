include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}


ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",        Vector(545,50,43), Angle(0,0,0), Color(216,161,92), fov=60,farz=600,brightness = 1, texture = "models/metrostroi_train/equipment/headlight",shadows = 1,headlight=true},
    [2] = { "headlight",        Vector(545,-50,43), Angle(0,0,0), Color(216,161,92), fov=60,farz=600,brightness = 1, texture = "models/metrostroi_train/equipment/headlight2",shadows = 1,headlight=true},
    [3] = { "light",        Vector(545,0,600), Angle(0,0,0), Color(216,161,92), fov=40,farz=450,brightness = 3, texture = "effects/flashlight/soft",shadows = 1,headlight=true},
    [4] = { "headlight",        Vector(545,38.5,40), Angle(-20,0,0), Color(255,0,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[5] = { "headlight",        Vector(545,-38.5,40), Angle(-20,0,0), Color(255,0,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
    [6] = { "light",        Vector(519,40,131), Angle(0,-180,0), Color(255,254,184), fov=50 ,brightness = 0.1, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
    [7] = { "headlight",        Vector(545,38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true},
	[8] = { "headlight",        Vector(545,-38.5,45), Angle(-20,0,0), Color(255,102,0), fov=50 ,brightness = 0.7, farz=50,texture = "models/metrostroi_train/equipment/headlight2",shadows = 0,backlight=true}, 
	
}






ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlight_on.mdl",
	pos = Vector(541,0,43),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Door_fr"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(924,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}
ENT.ClientProps["Door_br"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(615,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}
ENT.ClientProps["Door_bl"] = {
	model = "models/lilly/uf/u2/u2h/doors.mdl",
	pos = Vector(-309,0,0),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(533.3,-19.5,82.5),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Pantograph"] = {
	model = "models/lilly/uf/common/pantograph.mdl",
	pos = Vector(43,0,155),
	ang = Angle(0,0,0),
	scale = 1,
}



ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(-0.5,0,-0.3),
	ang = Angle(0,0,0),
	scale = 1,
}

ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(527.70,38.5,77),
    ang = Angle(0,-90,0),
    hideseat = 0.2,
}

ENT.ClientProps["reverser_lever"] = {
    model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
    pos = Vector(535,38.5,78.3),
    ang = Angle(0,-90,0),
    hideseat = 0.2,
}
ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/common/cab/speedneedle.mdl",
    pos = Vector(535,12.8,77.01),
    ang = Angle(-0.1,-90,9),
    hideseat = 0.2,
}


ENT.ButtonMap["Cab"] = {
    pos = Vector(540,50,78),
    ang = Angle(0.01,-90,8),
    width = 650,
    height = 124,
    scale = 0.1,
	
    buttons = {
		
	--[[{ID = "ThrottleUp", x=150, y=112.5, radius=20, tooltip = "Combined Throttle Up", model = {
			model = "models/lilly/uf/u2/cab/kombihebel.mdl", z=0, ang=0,
			var="main",speed=1, vmin=0, vmax=1,
			sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            }
    },
    {ID = "ThrottleDown", x=150, y=155, radius=20, tooltip = "Combined Throttle Down", model = {
        model = "models/lilly/uf/u2/cab/kombihebel.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },]]
    {ID = "WarningAnnouncementSet", x=416, y=46, radius=10, tooltip = "Please keep back announcement", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerOvergroundSet", x=229.5, y=83, radius=10, tooltip = "Set passenger lights to overground mode", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "PassengerUndergroundSet", x=229.5, y=112, radius=10, tooltip = "Set passenger lights to underground mode", model = {
        model = "models/lilly/uf/common/cab/button_green.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "LightsToggle", x=200, y=45, radius=10, tooltip = "Enable Headlights", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
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
    {ID = "SetPointLeftSet", x=340, y=112, radius=10, tooltip = "Set track point to left", model = {
        model = "models/lilly/uf/common/cab/button_right.mdl", z=-2, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ClearDoorClosedAlarmSet", x=367.5, y=112, radius=10, tooltip = "Clear door closed alarm", model = {
        model = "models/lilly/uf/common/cab/button_loeschen.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointRightSet", x=395, y=112, radius=10, tooltip = "Set track point to right", model = {
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
}
}


ENT.ButtonMap["IBISScreen"] = {
    pos = Vector(532.6,-19.2,83.09),
    ang = Angle(0,45,-48.5,0),
    width = 112,
    height = 25,
    scale = 0.04,
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

ENT.ButtonMap["Left"] = {
    pos = Vector(530,40,78),
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
        }
}




	
function ENT:Draw()
    self.BaseClass.Draw(self)
end


function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture",self.ASNP)
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

	
	self.ASNP = self:CreateRT("717ASNP",512,128)
	
	self.DoorL1Open = 0
	self.DoorL2Open = 0
	self.DoorR1Open = 0
	self.DoorR2Open = 0

    self.CabLight = 0

    self.SpeedoAnim = 0
	
    self:ShowHide("headlights_on",false,0)
	
	self.ThrottleLastEngaged = 0
	
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
        self:SetLightPower(6,true,100)
    elseif self:GetNW2Bool("Cablight",false) == false then
        self:SetLightPower(6,false)
    end


    if self:GetNW2Bool("Headlights",false) == true and self:GetNW2Int("ReverserState",0) == 1 and self:GetNW2Bool("BatteryOn",false) then
        self:ShowHide("headlights_on",true,0)
    elseif self:GetNW2Bool("Headlights",false) == false then
        self:ShowHide("headlights_on",false,0)
    end

    self.SpeedoAnim = math.Clamp(self:GetNW2Float("Speed"),0, 80) * 0.01 * 2

    self:Animate("Speedo",self.SpeedoAnim,0,200,1,0.1,false)
    --self:Animate("Throttle",0,-45,45,3,0,false)
	

    self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound",false) and 1 or 0,1)



	self:SetSoundState("bell",self:GetNW2Bool("Bell",false) and 1 or 0,1)
    self:SetSoundState("horn",self:GetNW2Bool("Horn",false) and 1 or 0,1)
	
	if self:GetNW2Bool("WarningAnnouncement") == true then
        self:PlayOnce("WarningAnnouncement","cabin",1,1)

	end


    local delay
    local startMoment
    delay = 15
    if self:GetNW2Bool("IBIS_impulse",false) == true then
        startMoment = CurTime()
        if startMoment - delay > 15 then
            self:PlayOnce("IBIS_bootup", "bass",1,1)
        end
    end

    

    if self:GetNW2Float("BatteryCharge",0) > 0 and self:GetNW2Bool("BatteryOn",false) == true and self:GetNW2Bool("Headlights",false) == true then
            if self:GetNW2Float("Speed",0) < 1.5 then

                self:SetLightPower(6, true)
                self:SetLightPower(6, true)
            end
		    if self:GetNW2Bool("CabAEnabled",false) == true then
                if self:GetNW2Int("ReverserState") == 1 then
                    self:SetLightPower(1,true)
                    self:SetLightPower(2,true)
                    self:SetLightPower(4,false,100)
                    self:SetLightPower(5,false,100)
                elseif
                self:GetNW2Int("ReverserState") <= 0 then
                    self:SetLightPower(1,false)
                    self:SetLightPower(2,false)
                    self:SetLightPower(4,true,100)
                    self:SetLightPower(5,true,100)
                end

            elseif self:GetNW2Bool("CabBEnabled",false) == true then
              self:SetLightPower(1,false)
              self:SetLightPower(2,false)
              self:SetLightPower(4,true,100)
              self:SetLightPower(5,true,100)
            end

        elseif self:GetNW2Float("BatteryCharge",0) > 0 and self:GetNW2Bool("BatteryOn",false) == true and self:GetNW2Bool("Headlights",false) == false then
            self:SetLightPower(1,false)
            self:SetLightPower(2,false)
            self:SetLightPower(4,true,100)
            self:SetLightPower(5,true,100)

        elseif self:GetNW2Float("BatteryCharge",0) == 0 or self:GetNW2Bool("BatteryOn",false) == false then
            self:SetLightPower(1,false)
            self:SetLightPower(2,false)
            self:SetLightPower(4,false,100)
            self:SetLightPower(5,false,100)

    end

	
	
	
	
	-- Fan handler

    if self:GetNW2Bool("ThrottleEngaged",false) then
        self.ThrottleLastEngaged = CurTime()
    end

    if self:GetNW2Bool("ThrottleEngaged",false) == true and self:GetNW2Int("ReverserState",0) == 1 and self:GetNW2Bool("BatteryOn",false) == true then
        self:SetSoundState("Fan1",1,1,1)
        self:SetSoundState("Fan2",1,1,1)
        self:SetSoundState("Fan3",1,1,1)
    end

    if self:GetNW2Bool("ThrottleEngaged",false) == false and self:GetNW2Int("Speed",0) < 3 then
        if CurTime() - self.ThrottleLastEngaged > 5 then
            self:SetSoundState("Fan1",0,1,1 )
            self:SetSoundState("Fan2",0,1,1 )
            self:SetSoundState("Fan3",0,1,1 )
        end
    end
	
	
	
	
	
	
	
	
	
	
	
	

	local speed = self:GetNW2Int("Speed")/100

	local nxt = 35

	

	
	
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
    --self:SetSoundState("rolling_motors",math.max(rollingi,rollings*0.3)*rol_motors,speed/56)

    local rol10 = math.Clamp(speed/15,0,1)*(1-math.Clamp((speed)/35,0,1))
    local rol10p = Lerp((speed)/14,0.6,0.78)
    local rol40 = math.Clamp((speed-18)/35,0,1)*(1-math.Clamp((speed)/40,0,1))
    local rol40p = Lerp((speed)/66,0.6,1.3)
    local rol70 = math.Clamp((speed-55)/20,0,1)--*(1-math.Clamp((speed-72)/5,0,1))
    local rol70p = Lerp((speed)/27,0.78,1.15)
	
	
end
Metrostroi.GenerateClientProps()
