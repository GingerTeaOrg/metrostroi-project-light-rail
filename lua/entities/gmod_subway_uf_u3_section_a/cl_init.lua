include( "shared.lua" )
ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMapMPLR = {}
ENT.AutoAnims = {}
ENT.AutoAnimNames = {}
ENT.ClientProps[ "wipers" ] = {
	model = "models/lilly/uf/u3/wipers.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fr1" ] = {
	model = "models/lilly/uf/u3/door_1.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fr2" ] = {
	model = "models/lilly/uf/u3/door_2.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rr1" ] = {
	model = "models/lilly/uf/u3/door_1.mdl",
	pos = Vector( -200.5, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rr2" ] = {
	model = "models/lilly/uf/u3/door_2.mdl",
	pos = Vector( -200.5, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fl1" ] = {
	model = "models/lilly/uf/u3/door_1.mdl",
	pos = Vector( 659.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_fl2" ] = {
	model = "models/lilly/uf/u3/door_2.mdl",
	pos = Vector( 659.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rl1" ] = {
	model = "models/lilly/uf/u3/door_1.mdl",
	pos = Vector( 458.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Door_rl2" ] = {
	model = "models/lilly/uf/u3/door_2.mdl",
	pos = Vector( 458.5, 0, 0 ),
	ang = Angle( 0, 180, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "mirror_r" ] = {
	model = "models/lilly/uf/u3/mirror_r.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "mirror_l" ] = {
	model = "models/lilly/uf/u3/mirror_l.mdl",
	pos = Vector( 0, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1,
	nohide = true
}

ENT.ClientProps[ "Throttle" ] = {
	model = "models/lilly/uf/common/cab/throttle.mdl",
	pos = Vector( 45.1, 7.45, 12 ),
	ang = Angle( 0, 0, 0 ),
	nohide = true
}

ENT.ClientProps[ "headlights_on" ] = {
	model = "models/lilly/uf/u3/headlights_lit.mdl",
	pos = Vector( 0.1, 0, 0 ),
	ang = Angle( 0, 0, 0 ),
	scale = 1
}

ENT.ClientProps[ "reverser" ] = {
	model = "models/lilly/uf/u2/cab/reverser_lever.mdl",
	pos = Vector( 46, 7, 12 ),
	ang = Angle( 0, 0, 0 ),
	hideseat = 0.2
}

ENT.ButtonMapMPLR[ "IBISScreen" ] = {
	pos = Vector( 469.83, -0.75, 73.41 ),
	ang = Angle( 0, -135, 78.8 ), -- (0,44.5,-47.9),
	width = 147,
	height = 80,
	scale = 0.0311
}

ENT.ButtonMapMPLR[ "Rollsign" ] = {
	pos = Vector( 470, -28, 121 ),
	ang = Angle( 0, 90, 90 ),
	width = 890,
	height = 160,
	scale = 0.0625,
	buttons = {}
}

-- {ID = "LastStation-",x=000,y=0,w=400,h=205, tooltip=""},
-- {ID = "LastStation+",x=400,y=0,w=400,h=205, tooltip=""},
ENT.ButtonMapMPLR[ "Dashboard1" ] = {
	pos = Vector( 464, 33, 68.4 ),
	ang = Angle( 0, -90, 9 ),
	width = 370,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "RetainerOnSet",
			x = 14.5,
			y = 18,
			radius = 10,
			tooltip = "Enable Retainer Brake Manually",
			model = {
				model = "models/lilly/uf/u3/cab/retainer_on.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "RetainerOn",
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
			ID = "RetainerOffSet",
			x = 14.5,
			y = 36.5,
			radius = 10,
			tooltip = "Disable Retainer Brake Manually",
			model = {
				model = "models/lilly/uf/u3/cab/retainer_on.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "RetainerOff",
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
			ID = "CircuitOnSet",
			x = 48,
			y = 36.5,
			radius = 10,
			tooltip = "Close Circuit Breaker",
			model = {
				model = "models/lilly/uf/u3/cab/circuit_on.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "CircuitOn",
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
			ID = "CircuitOffSet",
			x = 48,
			y = 18,
			radius = 10,
			tooltip = "Open Circuit Breaker",
			model = {
				model = "models/lilly/uf/u3/cab/circuit_off.mdl",
				z = 1.8,
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
	}
}

ENT.ButtonMapMPLR[ "Dashboard2" ] = {
	pos = Vector( 466, 33, 71.25 ),
	ang = Angle( 0, -90, 54.4 ),
	width = 370,
	height = 50,
	scale = 0.069,
	buttons = {
		{
			ID = "BatteryOnSet",
			x = 14.5,
			y = 18,
			radius = 10,
			tooltip = "Enable Battery",
			model = {
				model = "models/lilly/uf/u3/cab/battery_on.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "BatteryOn",
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
			ID = "PantoLowerSet",
			x = 48,
			y = 36.5,
			radius = 10,
			tooltip = "Lower Pantograph",
			model = {
				model = "models/lilly/uf/u3/cab/panto_off.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "PantoLower",
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
			ID = "PantoRaiseSet",
			x = 48,
			y = 18,
			radius = 10,
			tooltip = "Raise Pantograph",
			model = {
				model = "models/lilly/uf/u3/cab/panto_on.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "PantoRaise",
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
			ID = "BatteryOffSet",
			x = 14.5,
			y = 36.5,
			radius = 10,
			tooltip = "Disable Battery",
			model = {
				model = "models/lilly/uf/u3/cab/battery_off.mdl",
				z = 1.8,
				ang = 90,
				anim = true,
				var = "BatteryOff",
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
	}
}

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

function ENT:Draw()
	self.BaseClass.Draw( self )
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

function ENT:UpdateWagonNumber()
	for i = 0, 3 do
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
	end
end

function ENT:Initialize()
	self.BaseClass.Initialize( self )
	self.SectionB = self:GetNWEntity( "U2b" )
	self.IBIS = self:CreateRT( "IBIS", 512, 128 )
	self.Locked = 0
	self.EngineSNDConfig = {}
	self.SoundNames = {}
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
	self.ScrollModifier = 0
	self.ScrollMoment = 0
	self.PrevTime = 0
	self.DeltaTime = 0
	self.MotorPowerSound = 0
	self.Nags = { "Nag1", "Nag2", "Nag3" }
	self.Speed = 0
	self.BatterySwitch = 0.5
	self:ShowHide( "reverser", true )
	self:ShowHide( "reverser", false )
	self:UpdateWagonNumber()
	-- self.SectionB:UpdateWagonNumber()
	self.Rollsign = Material( self:GetNW2String( "Rollsign", "models/lilly/uf/u2/rollsigns/frankfurt_stock.png" ) )
end

ENT.RTMaterialUF = CreateMaterial( "MetrostroiRT1", "VertexLitGeneric", {
	[ "$vertexcolor" ] = 0,
	[ "$vertexalpha" ] = 1,
	[ "$nolod" ] = 1
} )

function ENT:DrawPost()
	self.RTMaterialUF:SetTexture( "$basetexture", self.IBIS )
	self:DrawOnPanel( "IBISScreen", function( ... )
		surface.SetMaterial( self.RTMaterial )
		surface.SetDrawColor( 0, 65, 11 )
		surface.DrawTexturedRectRotated( 74, 41, 144, 75, 0 )
	end )

	local mat = self.Rollsign
	self:DrawOnPanel( "Rollsign", function( ... )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat )
		surface.DrawTexturedRectUV( 0, 0, 890, 160, 0, self.ScrollModifier, 1, self.ScrollModifier + 0.015 )
	end )
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

function ENT:Think()
	self.BaseClass.Think( self )
	self:SoundRoutine()
	self:Animations()
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	self.ScrollModifier = 0.548
	self:ShowHide( "reverser", self:GetNW2Bool( "ReverserInsertedA", false ) )
	local Door12a = math.Clamp( self:GetNW2Float( "Door12a" ), 0, 1 )
	local Door34a = math.Clamp( self:GetNW2Float( "Door34a" ), 0, 1 )
	local Door56b = self:GetNW2Float( "Door56b" )
	local Door78b = self:GetNW2Float( "Door78b" )
	self.ThrottleStateAnim = self:GetNW2Float( "ThrottleStateAnim", 0 )
	if self.ThrottleStateAnim >= 0.5 then
		self:Animate( "Throttle", self.ThrottleStateAnim, -45, 45, 50, 8, false )
	elseif self.ThrottleStateAnim <= 0.5 then
		self:Animate( "Throttle", math.Clamp( self.ThrottleStateAnim, 0.09, 1 ), -45, 45, 50, 8, false )
	end

	self:Animate( "reverser", self:GetNW2Float( "ReverserAnimate" ), 0, 100, 50, 9, false )
end

function ENT:OnAnnouncer( volume )
	return self:GetPackedBool( "AnnPlay" ) and volume or 0
end

UF.GenerateClientProps()
function ENT:SoundRoutine()
	if self:GetNW2Bool( "Bell", false ) == true then
		self:SetSoundState( "bell", 1, 1 )
		self:SetSoundState( "bell_in", 1, 1 )
	else
		self:SetSoundState( "bell", 0, 1 )
		self:SetSoundState( "bell_in", 0, 1 )
	end

	if self:GetNW2Bool( "WarningAnnouncement" ) == true then self:PlayOnce( "WarningAnnouncement", "cabin", 1, 1 ) end
	self:SetSoundState( "Deadman", self:GetNW2Bool( "DeadmanAlarmSound", false ) and 1 or 0, 1 )
	local Chopper = self:GetNW2Bool( "Chopper", false )
	self:SetSoundState( "Chopper", Chopper and 1 or 0, 1 )
end

function ENT:Animations()
	self.SpeedoAnim = math.Clamp( self:GetNW2Int( "Speed" ), 0, 80 ) / 100 * 1.5
	self:Animate( "Speedo", self.SpeedoAnim, 0, 100, 32, 1, 0 )
	self:ShowHide( "reverser", self:GetNW2Bool( "ReverserInsertedB", false ) )
	self:Animate( "reverser", self:GetNW2Float( "ReverserAnimate", 0.5 ), 0, 100, 50 )
	self.CabWindowL = self:GetNW2Float( "CabWindowL", 0 )
	self.CabWindowR = self:GetNW2Float( "CabWindowR", 0 )
	self:Animate( "window_cab_r", self:GetNW2Float( "CabWindowR", 0 ), 0, 100, 50, 9, false )
	self:Animate( "window_cab_l", self:GetNW2Float( "CabWindowL", 0 ), 0, 100, 50, 9, false )
	if self:GetNW2Bool( "Headlights", false ) == true and self:GetNW2Bool( "Headlights", false ) == true then
		self:ShowHide( "headlights_on", true )
	else
		self:ShowHide( "headlights_on", false )
	end

	self:Animate( "Mirror", self:GetNW2Float( "Mirror", 0 ), 0, 100, 17, 1, 0 )
	self:Animate( "Mirror_vintage", self:GetNW2Float( "Mirror", 0 ), 0, 100, 17, 1, 0 )
	self:ShowHide( "RetroEquipment", self:GetNW2Bool( "RetroMode", false ) )
	self:Animate( "Door_fr2", self:GetNW2Float( "Door12a" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_fr1", self:GetNW2Float( "Door12a" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_rr2", self:GetNW2Float( "Door34a" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_rr1", self:GetNW2Float( "Door34a" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_fl2", self:GetNW2Float( "Door78b" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_fl1", self:GetNW2Float( "Door78b" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_rl2", self:GetNW2Float( "Door56b" ), 0, 100, 50, 0, 0 )
	self:Animate( "Door_rl1", self:GetNW2Float( "Door56b" ), 0, 100, 50, 0, 0 )
	self:Animate( "wipers", self:GetNW2Float( "WiperState" ), 0, 100, 100, 12, 0 ) --clientProp, value, min, max, speed, damping, stickyness, name
	if self:GetNW2Bool( "RetroMode", false ) == false then
		self:ShowHide( "Mirror_vintage", false )
		self:ShowHide( "Mirror", true )
	elseif self:GetNW2Bool( "RetroMode", false ) == true then
		self:ShowHide( "Mirror", false )
		self:ShowHide( "Mirror_vintage", true )
	end
end