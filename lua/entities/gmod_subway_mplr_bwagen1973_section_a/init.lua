AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 780
ENT.SyncTable = { "IgnitionKey", "IgnitionKeyInserted", "UncouplingKey", "ParrallelMotors", "Deadman", "DoorsUnlock", "DoorsLock", "DoorsSelectRight", "DoorsSelectLeft", "Door1", "DoorsForceOpen", "DoorsForceClose", "MirrorLeft", "MirrorRight", "SwitchLeft", "SwitchRight", "Battery", "BatteryDisable", "PantographOn", "PantographOff", "Headlights", "HazardBlink", "DriverLight", "BlinkerRight", "BlinkerLeft", "StepsHigh", "StepsLow", "StepsLowest", "Bell", "Horn", "WiperConstantSet", "WiperIntervalSet", "WindowWasherSet", "EmergencyBrakeDisable" }
ENT.InteractionZones = {
	{
		ID = "DoorButton3L",
		Pos = Vector( 328.8, 51, 74 ),
		Radius = 16
	},
	{
		ID = "DoorButton4L",
		Pos = Vector( 328.8, 51.3, 58 ),
		Radius = 16
	},
	{
		ID = "DoorButton5L",
		Pos = Vector( 261, 51, 74 ),
		Radius = 16
	},
	{
		ID = "DoorButton6L",
		Pos = Vector( 261, 51.3, 58 ),
		Radius = 16
	},
	{
		ID = "DoorButton7L",
		Pos = Vector( 144.5, 51, 74 ),
		Radius = 16
	},
	{
		ID = "DoorButton8L",
		Pos = Vector( 144.5, 51.3, 58 ),
		Radius = 16
	},
	{
		ID = "Button6b",
		Pos = Vector( 152.116, 50, 49.5253 ),
		Radius = 16
	},
	{
		ID = "Button5b",
		Pos = Vector( 84.6012, 50, 49.5253 ),
		Radius = 16
	}
}

ENT.TrainWireCrossConnections = {
	[ 4 ] = 3, -- Reverser F<->B
	[ 21 ] = 20, -- blinker
	[ 13 ] = 14,
	[ 31 ] = 32
}

ENT.KeyMap = {
	[ KEY_A ] = "ThrottleUp",
	[ KEY_D ] = "ThrottleDown",
	[ KEY_F ] = "ReduceBrake",
	[ KEY_H ] = "BellSet",
	[ KEY_SPACE ] = "DeadmanSet",
	[ KEY_W ] = "ReverserUpSet",
	[ KEY_S ] = "ReverserDownSet",
	[ KEY_P ] = "PantographOnSet",
	[ KEY_O ] = "DoorsUnlockToggle",
	[ KEY_I ] = "DoorsForceCloseSet",
	[ KEY_K ] = "DoorsCloseConfirmSet",
	[ KEY_Z ] = "WarningAnnouncementSet",
	[ KEY_J ] = "DoorsSelectLeftToggle",
	[ KEY_L ] = "DoorsSelectRightToggle",
	[ KEY_B ] = "BatterySet",
	[ KEY_V ] = "HeadlightsToggle",
	[ KEY_M ] = "MirrorLeftToggle",
	[ KEY_1 ] = "Throttle10Pct",
	[ KEY_2 ] = "Throttle20Pct",
	[ KEY_3 ] = "Throttle30Pct",
	[ KEY_4 ] = "Throttle40Pct",
	[ KEY_5 ] = "Throttle50Pct",
	[ KEY_6 ] = "Throttle60Pct",
	[ KEY_7 ] = "Throttle70Pct",
	[ KEY_8 ] = "Throttle80Pct",
	[ KEY_9 ] = "Throttle90Pct",
	[ KEY_0 ] = "IgnitionKeyOn",
	[ KEY_PERIOD ] = "BlinkerRightToggle",
	[ KEY_COMMA ] = "BlinkerLeftToggle",
	[ KEY_PAD_MINUS ] = "IBISkeyTurnSet",
	[ KEY_LSHIFT ] = {
		[ KEY_O ] = "DoorsForceOpenSet",
		[ KEY_0 ] = "IgnitionKeyToggle",
		[ KEY_A ] = "ThrottleUpFast",
		[ KEY_D ] = "ThrottleDownFast",
		[ KEY_S ] = "ThrottleZero",
		[ KEY_H ] = "HornSet",
		[ KEY_V ] = "DriverLightToggle",
		[ KEY_COMMA ] = "WarnBlinkToggle",
		[ KEY_B ] = "BatteryDisableSet",
		[ KEY_M ] = "MirrorRightToggle",
		[ KEY_PAGEUP ] = "Rollsign+",
		[ KEY_PAGEDOWN ] = "Rollsign-",
		[ KEY_1 ] = "Throttle10-Pct",
		[ KEY_2 ] = "Throttle20-Pct",
		[ KEY_3 ] = "Throttle30-Pct",
		[ KEY_4 ] = "Throttle40-Pct",
		[ KEY_5 ] = "Throttle50-Pct",
		[ KEY_6 ] = "Throttle60-Pct",
		[ KEY_7 ] = "Throttle70-Pct",
		[ KEY_8 ] = "Throttle80-Pct",
		[ KEY_9 ] = "Throttle90-Pct",
		[ KEY_P ] = "PantographOffSet",
	},
	[ KEY_LALT ] = {
		[ KEY_PAD_1 ] = "Number1Set",
		[ KEY_PAD_2 ] = "Number2Set",
		[ KEY_PAD_3 ] = "Number3Set",
		[ KEY_PAD_4 ] = "Number4Set",
		[ KEY_PAD_5 ] = "Number5Set",
		[ KEY_PAD_6 ] = "Number6Set",
		[ KEY_PAD_7 ] = "Number7Set",
		[ KEY_PAD_8 ] = "Number8Set",
		[ KEY_PAD_9 ] = "Number9Set",
		[ KEY_PAD_0 ] = "Number0Set",
		[ KEY_PAD_ENTER ] = "EnterSet",
		[ KEY_PAD_DECIMAL ] = "DeleteSet",
		[ KEY_PAD_DIVIDE ] = "DestinationSet",
		[ KEY_PAD_MULTIPLY ] = "SpecialAnnouncementsSet",
		[ KEY_PAD_MINUS ] = "TimeAndDateSet",
		[ KEY_V ] = "PassengerLightsSet",
		[ KEY_D ] = "EmergencyBrakeSet",
		[ KEY_N ] = "Parrallel",
		[ KEY_0 ] = "IgnitionKeyOff"
	}
}

function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/ruhrbahn/b_1973/section_a.mdl" )
	self.BaseClass.Initialize( self )
	self.DriverSeat = self:CreateSeat( "driver", Vector( 484, 3, 55 ), Angle( 0, 0, 0 ) )
	self.PassengerSeat = self:CreateSeat( "passenger", Vector( 450, 3, 55 ), Angle( 0, 0, 0 ) )
	-- self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
	self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
	-- self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	-- self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
	self.Speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.Door1 = false
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF( Vector( 390, 0, 4 ), Angle( 0, 180, 0 ), true, "b_motor", "a" )
	self.MiddleBogey = self:CreateBogeyUF( Vector( 0, 0, 4 ), Angle( 0, 180, 0 ), false, "b_joint", "a" )
	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler( Vector( 475, 0, 30 ), Angle( 0, 0, 0 ), true, "b", "a" )
	self.FrontCoupler = self.FrontCouple
	self.SectionB = self:CreateSection( Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), "gmod_subway_mplr_bwagen1973_section_b", self, nil, self )
	self.RearCouple = self:CreateCustomCoupler( Vector( -475, 0, 30 ), Angle( 0, 180, 0 ), true, "b", "b" )
	self.RearCoupler = self.RearCouple
	self.RearBogey = self:CreateBogeyUF( Vector( -390, 0, 4 ), Angle( 0, 180, 0 ), true, "b_motor", "b" )
	self.Panto = self:CreatePanto( Vector( 36.5, 0, 135 ), Angle( 0, 180, 0 ), "einholm" )
	self.PantoUp = false
	self.FrontBogey:SetNWInt( "MotorSoundType", 0 )
	self.MiddleBogey:SetNWInt( "MotorSoundType", 0 )
	self.RearBogey:SetNWInt( "MotorSoundType", 0 )
	self.Blinker = "Off"
	-- Lights sheen
	self.Lights = {
		[ 1 ] = {
			"light", -- headlight left
			Vector( 530, 30, 43 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 2 ] = {
			"light", -- headlight right
			Vector( 530, -30, 43 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 3 ] = {
			"light", -- headlight top
			Vector( 515, 0, 130 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 0.45,
			texture = "sprites/light_glow02.vmt"
		},
		[ 4 ] = {
			"light", -- tail light left
			Vector( 525, 20.9, 41 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 5 ] = {
			"light", -- tail light right
			Vector( 525, -20.9, 41 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 6 ] = {
			"light", -- brake lights
			Vector( 525, 20.9, 46 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 7 ] = {
			"light", -- brake lights
			Vector( 525, -20.9, 46 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 8 ] = {
			"light", -- indicator top left
			Vector( 487, 46, 79 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 9 ] = {
			"light", -- indicator top right
			Vector( 487, -46, 79 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 10 ] = {
			"light", -- indicator bottom left
			Vector( 487, 46, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 11 ] = {
			"light", -- indicator bottom right
			Vector( 487, -46, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 12 ] = {
			"light", -- door button front left 1
			Vector( 397, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 13 ] = {
			"light", -- door button front left 2
			Vector( 326.738, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 14 ] = {
			"light", -- door button front left 3
			Vector( 151.5, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 15 ] = {
			"light", -- door button front left 4
			Vector( 83.7, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 16 ] = {
			"light", -- door button front right 1
			Vector( 396.884, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 17 ] = {
			"light", -- door button front right 2
			Vector( 326.89, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 18 ] = {
			"light", -- door button front right 3
			Vector( 152.116, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 19 ] = {
			"light", -- door button front right 4
			Vector( 85, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 20 ] = {
			"light", -- cab light
			Vector( 406, 39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 21 ] = {
			"light", -- cab light
			Vector( 406, -39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
		}
	}

	-- Initialize key mapping
	self.KeyMap = {
		[ KEY_A ] = "ThrottleUp",
		[ KEY_D ] = "ThrottleDown",
		[ KEY_F ] = "ReduceBrake",
		[ KEY_H ] = "BellSet",
		[ KEY_SPACE ] = "DeadmanSet",
		[ KEY_W ] = "ReverserUpSet",
		[ KEY_S ] = "ReverserDownSet",
		[ KEY_P ] = "PantographOnSet",
		[ KEY_O ] = "DoorsUnlockToggle",
		[ KEY_I ] = "DoorsLockSet",
		[ KEY_K ] = "DoorsCloseConfirmSet",
		[ KEY_Z ] = "WarningAnnouncementSet",
		[ KEY_J ] = "DoorsSelectLeftToggle",
		[ KEY_L ] = "DoorsSelectRightToggle",
		[ KEY_B ] = "BatterySet",
		[ KEY_V ] = "HeadlightsToggle",
		[ KEY_1 ] = "Throttle10Pct",
		[ KEY_2 ] = "Throttle20Pct",
		[ KEY_3 ] = "Throttle30Pct",
		[ KEY_4 ] = "Throttle40Pct",
		[ KEY_5 ] = "Throttle50Pct",
		[ KEY_6 ] = "Throttle60Pct",
		[ KEY_7 ] = "Throttle70Pct",
		[ KEY_8 ] = "Throttle80Pct",
		[ KEY_9 ] = "Throttle90Pct",
		[ KEY_0 ] = "IgnitionKeyOn",
		[ KEY_PERIOD ] = "BlinkerRightToggle",
		[ KEY_COMMA ] = "BlinkerLeftToggle",
		[ KEY_PAD_MINUS ] = "IBISkeyTurnSet",
		[ KEY_LSHIFT ] = {
			[ KEY_0 ] = "IgnitionKeyToggle",
			[ KEY_A ] = "ThrottleUpFast",
			[ KEY_D ] = "ThrottleDownFast",
			[ KEY_S ] = "ThrottleZero",
			[ KEY_H ] = "HornSet",
			[ KEY_V ] = "DriverLightToggle",
			[ KEY_COMMA ] = "WarnBlinkToggle",
			[ KEY_B ] = "BatteryDisableSet",
			[ KEY_PAGEUP ] = "Rollsign+",
			[ KEY_PAGEDOWN ] = "Rollsign-",
			[ KEY_O ] = "Door1Set",
			[ KEY_1 ] = "Throttle10-Pct",
			[ KEY_2 ] = "Throttle20-Pct",
			[ KEY_3 ] = "Throttle30-Pct",
			[ KEY_4 ] = "Throttle40-Pct",
			[ KEY_5 ] = "Throttle50-Pct",
			[ KEY_6 ] = "Throttle60-Pct",
			[ KEY_7 ] = "Throttle70-Pct",
			[ KEY_8 ] = "Throttle80-Pct",
			[ KEY_9 ] = "Throttle90-Pct",
			[ KEY_P ] = "PantographOffSet",
		},
		[ KEY_LALT ] = {
			[ KEY_PAD_1 ] = "Number1Set",
			[ KEY_PAD_2 ] = "Number2Set",
			[ KEY_PAD_3 ] = "Number3Set",
			[ KEY_PAD_4 ] = "Number4Set",
			[ KEY_PAD_5 ] = "Number5Set",
			[ KEY_PAD_6 ] = "Number6Set",
			[ KEY_PAD_7 ] = "Number7Set",
			[ KEY_PAD_8 ] = "Number8Set",
			[ KEY_PAD_9 ] = "Number9Set",
			[ KEY_PAD_0 ] = "Number0Set",
			[ KEY_PAD_ENTER ] = "EnterSet",
			[ KEY_PAD_DECIMAL ] = "DeleteSet",
			[ KEY_PAD_DIVIDE ] = "DestinationSet",
			[ KEY_PAD_MULTIPLY ] = "SpecialAnnouncementsSet",
			[ KEY_PAD_MINUS ] = "TimeAndDateSet",
			[ KEY_V ] = "PassengerLightsSet",
			[ KEY_D ] = "EmergencyBrakeSet",
			[ KEY_N ] = "Parrallel",
			[ KEY_0 ] = "IgnitionKeyOff"
		}
	}

	self.InteractionZones = {
		{
			ID = "Button1a",
			Pos = Vector( 396.884, -51, 50.5 ),
			Radius = 16
		},
		{
			ID = "Button2a",
			Pos = Vector( 326.89, -50, 49.5253 ),
			Radius = 16
		},
		{
			ID = "Button3a",
			Pos = Vector( 152.116, -50, 49.5253 ),
			Radius = 16
		},
		{
			ID = "Button4a",
			Pos = Vector( 84.6012, -50, 49.5253 ),
			Radius = 16
		},
		{
			ID = "Button8b",
			Pos = Vector( 396.884, 51, 50.5 ),
			Radius = 16
		},
		{
			ID = "Button7b",
			Pos = Vector( 326.89, 50, 49.5253 ),
			Radius = 16
		},
		{
			ID = "Button6b",
			Pos = Vector( 152.116, 50, 49.5253 ),
			Radius = 16
		},
		{
			ID = "Button5b",
			Pos = Vector( 84.6012, 50, 49.5253 ),
			Radius = 16
		}
	}
end

function ENT:Think( dT )
	self.BaseClass.Think( self )
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	self.FrontCoupler = self.FrontCouple
	self.RearCoupler = self.RearCouple
	self:Traction()
end

function ENT:SetButton( button )
	self.Panel[ button ] = 1
end

function ENT:UnsetButton( button )
	self.Panel[ button ] = 0
end

function ENT:OnButtonPress( button )
	self:HackButtonPress( button )
	local toggle = string.find( button, "Toggle", 1 ) ~= nil
	if button and toggle then
		self:ToggleButton( button )
	else
		self:SetButton( button )
	end

	local sys = self.CoreSys
	local panel = self.Panel
	local doorHandler = self.MPLR_DoorHandler
	if button == "IgnitionKeyOn" then sys:IgnitionKeyOnA() end
	if button == "IgnitionKeyOff" then sys:IgnitionKeyOffA() end
	if button == "IgnitionKeyToggle" then sys:IgnitionKeyInOutA() end
	if button == "ReverserUpSet" then sys:ReverserUpA() end
	if button == "ReverserDownSet" then sys:ReverserDownA() end
	if sys.ThrottleRateA == 0 and sys.ReverserA ~= 1 then
		if button == "ThrottleUp" then sys.ThrottleRateA = 3 end
		if button == "ThrottleDown" then sys.ThrottleRateA = -3 end
		if button == "ThrottleUpFast" then sys.ThrottleRateA = 8 end
		if button == "ThrottleDownFast" then sys.ThrottleRateA = -8 end
	end

	if button == "ThrottleZero" then
		sys.ThrottleRateA = 0
		sys.ThrottleStateA = 0
	end

	if button == "BatterySet" then sys:BatteryOn() end
	if button == "BatteryDisableSet" then sys:BatteryOff() end
	if button == "BlinkerLeftToggle" and sys.BlinkerState == sys.BlinkerStates[ "Off" ] then
		sys.BlinkerState = sys.BlinkerStates[ "Left" ]
	elseif button == "BlinkerLeftToggle" and sys.BlinkerState == sys.BlinkerStates[ "Right" ] then
		sys.BlinkerState = sys.BlinkerStates[ "Off" ]
	elseif button == "BlinkerRightToggle" and sys.BlinkerState == sys.BlinkerStates[ "Off" ] then
		sys.BlinkerState = sys.BlinkerStates[ "Right" ]
	elseif button == "BlinkerRightToggle" and sys.BlinkerState == sys.BlinkerStates[ "Right" ] then
		sys.BlinkerState = sys.BlinkerStates[ "Off" ]
	elseif button == "WarnBlinkToggle" then
		sys.BlinkerState = sys.BlinkerStates[ "Hazard" ]
		panel.BlinkerLeft = 0
		panel.BlinkerRight = 0
	end

	if button == "SwitchLeftToggle" then
		if self.IBIS.Override == "left" then
			self.IBIS:OverrideSwitching( nil )
		else
			self.IBIS.Override = "left"
		end
	end

	if button == "SwitchRightToggle" then
		if self.IBIS.Override == "right" then
			self.IBIS:OverrideSwitching( nil )
		else
			self.IBIS.Override = "right"
		end
	end

	if button == "DoorsForceOpenSet" then
		local right = panel.DoorsSelectRight > 0
		local tab = right and doorHandler.DoorRandomnessRight or doorHandler.DoorRandomnessLeft
		for k, _ in ipairs( tab ) do
			tab[ k ] = 3
		end
	end
end

function ENT:OnButtonRelease( button )
	self:HackButtonRelease( button )
	if button == "ThrottleUp" or button == "ThrottleDown" or button == "ThrottleUpFast" or button == "ThrottleDownFast" then self.CoreSys.ThrottleRateA = 0 end
	if button == "PantographOnSet" then self.Panel.PantographOn = 0 end
	if button == "PantographOffSet" then self.Panel.PantographOff = 0 end
	if button == "BellSet" then self.Panel.Bell = 0 end
	if button == "HornSet" then self.Panel.Horn = 0 end
end

function ENT:CoupledUncoupled()
	self.AisCoupled = self.FrontCoupler.CoupledEnt ~= nil
	self.BisCoupled = self.RearCoupler.CoupledEnt ~= nil
end

function ENT:TrainSpawnerUpdate()
	self.MiddleBogey.Texture = self:GetNW2String( "Texture" )
	self:UpdateTextures()
	self.MiddleBogey:UpdateTextures()
	if IsValid( self.SectionB ) then self.SectionB:TrainSpawnerUpdate() end
	-- self.MiddleBogey:UpdateTextures()
	-- self.MiddleBogey:UpdateTextures()
	-- self:UpdateLampsColors()
	self.FrontCouple.CoupleType = "b"
	self.RearCouple.CoupleType = "b"
	self.FrontCouple:SetParameters()
	self.RearCouple:SetParameters()
end

function ENT:Traction()
	if not IsValid( self.FrontBogey ) and not IsValid( self.RearBogey ) then return end
	local fb = self.FrontBogey
	local mb = self.MiddleBogey
	local rb = self.RearBogey
	local speed = self.CoreSys.Speed
	local traction = self:ReadTrainWire( 1 ) * 0.01
	local chopper = self.Chopper.ChopperOutput > 0 and self.Chopper.ChopperOutput / 750 or 0
	local emergency = self:ReadTrainWire( 10 ) > 0
	--print(chopper,traction)
	local P = math.max( 0, 0.04449 + 1.06879 * math.abs( chopper ) - 0.465729 * chopper ^ 2 )
	if speed < 10 then P = P * ( 1.0 + 0.5 * ( 10.0 - speed ) / 10.0 ) end
	self.FrontBogey.MotorForce = traction > 0 and 56688.07175 or 68363.606
	self.RearBogey.MotorForce = self.FrontBogey.MotorForce
	if traction > 0 and not emergency then
		fb.MotorPower = math.abs( chopper )
	elseif traction <= 0 and speed > 8 and not emergency then
		fb.MotorPower = traction
	elseif emergency and speed > 8 then
		fb.MotorPower = -1
	elseif speed < 8 and traction <= 0 then
		fb.MotorPower = 0
	end

	self.RearBogey.MotorPower = self.FrontBogey.MotorPower
	rb.Reversed = self:ReadTrainWire( 4 ) > 0
	fb.Reversed = rb.Reversed
	if speed > 8 and traction < 0 then
		fb.BrakeCylinderPressure = math.abs( traction * 5 )
	elseif speed < 8 and traction <= 0 then
		fb.BrakeCylinderPressure = 6
	elseif traction > 0 then
		fb.BrakeCylinderPressure = 0
	else
		fb.BrakeCylinderPressure = 0 -- or another default value if needed
	end

	mb.BrakeCylinderPressure = fb.BrakeCylinderPressure
	rb.BrakeCylinderPressure = fb.BrakeCylinderPressure
	--print(self.FrontBogey.MotorPower, traction, fb.BrakeCylinderPressure, rb.Reversed, self.FrontBogey.MotorForce)
end