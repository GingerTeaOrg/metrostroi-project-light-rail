include("shared.lua")



ENT.ClientProps = {}
ENT.AutoAnims = {}
ENT.ClientSounds = {}
ENT.ButtonMap = {}

local function GetDoorPosition(i,k,j)
	if j == 0 
	then return Vector(230.8 - 35.0*k     - 232.2*i,-67.5*(1-2*k),4.3)
	else return Vector(230.8 - 35.0*(1-k) - 232.2*i,-66*(1-2*k),4.25)
	end
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Bogeys = {}
	if not self.FrontBogey or not self.RearBogey or not self.MiddleBogey then
		self.FrontBogey = self:GetNW2Entity("FrontBogey")
		self.MiddleBogey = self:GetNW2Entity("MiddleBogey")
		self.RearBogey = self:GetNW2Entity("RearBogey")	
		table.insert(self.Bogeys,self.FrontBogey)
		table.insert(self.Bogeys,self.MiddleBogey)
		table.insert(self.Bogeys,self.RearBogey)
	end
	self.SpeedoAnim = 0
	
	
	self.ThrottleLastEngaged = 0

	self.ParentTrain = self:GetNW2Entity("U2a")
end


--[[
ENT.ClientProps["Throttle"] = {
    model = "models/lilly/uf/common/cab/throttle.mdl",
    pos = Vector(-521.29,-39,77),
    ang = Angle(0,90,0),
    hideseat = 0.2,
}

ENT.ClientProps["Speedo"] = {
    model = "models/lilly/uf/common/cab/speedneedle.mdl",
    pos = Vector(-500,12.8,77.01),
    ang = Angle(-0.1,-90,9),
    hideseat = 0.2,
}]]--

ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}

ENT.ClientProps["headlights_on"] = {
	model = "models/lilly/uf/u2/headlight_on.mdl",
	pos = Vector(-535,0,43),
	ang = Angle(0,180,0),
	scale = 1,
	hide = 2,
}

ENT.ClientProps["Door_fr1"] = {
	model = "models/lilly/uf/u2/door_h_fr1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_fr2"] = {
	model = "models/lilly/uf/u2/door_h_fr2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_fl1"] = {
	model = "models/lilly/uf/u2/door_h_fl1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_fl2"] = {
	model = "models/lilly/uf/u2/door_h_fl2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_rr1"] = {
	model = "models/lilly/uf/u2/door_h_rr1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_rr2"] = {
	model = "models/lilly/uf/u2/door_h_rr2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_rl1"] = {
	model = "models/lilly/uf/u2/door_h_rl1.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}

ENT.ClientProps["Door_rl2"] = {
	model = "models/lilly/uf/u2/door_h_rl2.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,-180,0),
	scale = 1,
}




ENT.ClientProps["IBIS"] = {
	model = "models/lilly/uf/u2/IBIS.mdl",
	pos = Vector(0,0,0),
	ang = Angle(0,180,0),
	scale = 1,
}


ENT.ButtonMap["Cab"] = {
    pos = Vector(-540,50,78),
    ang = Angle(0,-90,8),
    width = 650,
    height = 124,
    scale = 0.1,
	
    buttons = {
		
	{ID = "ThrottleUp", x=150, y=112.5, radius=20, tooltip = "Combined Throttle Up", model = {
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
    },
    {ID = "WarningAnnouncementSet", x=415, y=47, radius=10, tooltip = "Please keep back announcement", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=5, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "CablightOvergroundSet", x=230, y=80, radius=10, tooltip = "Set cab lights to overground mode", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "CablightUndergroundSet", x=230, y=115, radius=10, tooltip = "Set cab lights to underground mode", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "LightsToggle", x=200, y=45, radius=10, tooltip = "Enable lights", model = {
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
    {ID = "SetPointLeftSet", x=340, y=115, radius=10, tooltip = "Set track point to left", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ClearDoorClosedAlarmSet", x=369, y=115, radius=10, tooltip = "Clear door closed alarm", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SetPointRightSet", x=395, y=115, radius=10, tooltip = "Set track point to right", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "IndicatorLightsSwitchToggle", x=420, y=115, radius=10, tooltip = "Indicators Left/Right/Off", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "LowerPantographSet", x=449, y=115, radius=10, tooltip = "Lower pantograph", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "ThrowCouplerSet", x=478, y=115, radius=10, tooltip = "Throw Coupler", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "OpenDoor1Set", x=501, y=115, radius=10, tooltip = "Open only door 1", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "SanderToggle", x=559, y=115, radius=10, tooltip = "Toggle sanding", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "UnlockDoors", x=531, y=84, radius=10, tooltip = "Toggle doors unlocked", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "RaisePantograph", x=449, y=83, radius=10, tooltip = "Raise Pantograph", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
        var="main",speed=1, vmin=0, vmax=1,
        sndvol = 0.5, snd = function(val) return val and "button_press" or "button_release" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
        }
    },
    {ID = "RaisePantograph", x=369, y=83, radius=10, tooltip = "Raise Pantograph", model = {
        model = "models/lilly/uf/common/cab/button_orange.mdl", z=0, ang=0,
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
    pos = Vector(-532.6,-19.2,83.09),
    ang = Angle(0,45,-48.5),
    width = 112,
    height = 25,
    scale = 0.04,
}
ENT.ButtonMap["IBIS"] = {
    pos = Vector(-531,-23,84.9),
    ang = Angle(48,-225,0),
    width = 133,
    height = 230,
    scale = 0.04,

    buttons = {
        {ID = "Number1Set", x=41, y=72, radius=10, tooltip = "1",
        sndvol = 0.5, snd = function(val) return val and "IBIS_beep" or "IBIS_beep" end,sndmin = 80, sndmax = 1e3/3, sndang = Angle(-90,0,0),
            
        },
        {ID = "Number2Set", x=40, y=50, radius=10, tooltip = "2", model = {
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
}

function ENT:Think()
	self.BaseClass.Think(self)
	self.ParentTrain = self:GetNW2Entity("U2a")
	self:SetSoundState("horn1",self:GetPackedBool("Bell",false) and 1 or 0,1)
	local speed = self:GetNW2Int("Speed")/100
	
	
	self:Animate("Throttle",self:GetNWFloat("ThrottleStateAnim", 0.5),-45,45,5,0.5,false)



    self.SpeedoAnim = math.Clamp(self:GetNW2Float("Speed"),0, 80) * 0.01 * 2

    self:Animate("Speedo",self.SpeedoAnim,0,200,1,0.1,false)
    --self:Animate("Throttle",0,-45,45,3,0,false)
	if not self.ParentTrain:GetNW2Bool("Headlights",false) == true and self:GetNW2Bool("Headlights",false) == true then
        self:ShowHide("headlights_on",true)
    else
        self:ShowHide("headlights_on",false)
    end
    

    if self:GetNW2Bool("BIsCoupled",false) == true then -- Fixme set headlights
    end

	

    self:SetSoundState("Deadman", self:GetNW2Bool("DeadmanAlarmSound",false) and 1 or 0,1)



	self:SetSoundState("bell",self:GetNW2Bool("Bell",false) and 1 or 0,1)
    self:SetSoundState("horn",self:GetNW2Bool("Horn",false) and 1 or 0,1)
	
	if self:GetNW2Bool("WarningAnnouncement") == true then
        self:PlayOnce("WarningAnnouncement","cabin",1,1)

	end
	--print(self.ParentTrain)
	--Fan handler, reacts to motors
	if IsValid(self.ParentTrain) then
		--print(self.ParentTrain)
		if self.ParentTrain:GetNW2Bool("ThrottleEngaged",false) == true then
      	  self.ThrottleLastEngaged = CurTime()
    	end

    	if self.ParentTrain:GetNW2Bool("ThrottleEngaged",false) == true then
      	  self:SetSoundState("Fan1",1,1,1)
      	  self:SetSoundState("Fan2",1,1,1)
      	  self:SetSoundState("Fan3",1,1,1)
    	end

    	if self.ParentTrain:GetNW2Bool("ThrottleEngaged",false) == false and self:GetNW2Int("Speed",0) < 3 then
       	 if CurTime() - self.ThrottleLastEngaged > 5 then
            self:SetSoundState("Fan1",0,1,1 )
            self:SetSoundState("Fan2",0,1,1 )
            self:SetSoundState("Fan3",0,1,1 )
        	end
    	end
	end

	
end

--UF.GenerateClientProps()