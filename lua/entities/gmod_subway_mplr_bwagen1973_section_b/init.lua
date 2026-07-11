AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 780
ENT.SyncTable = { "LightsOn", "LightsOff", "IgnitionKey", "IgnitionKeyOn", "IgnitionKeyOff", "UncouplingKey", "ParrallelMotors", "Deadman", "UnlockDoors", "DoorsLock", "DoorsSelectRight", "DoorsSelectLeft", "Door1", "DoorsForceOpen", "DoorsForceClose", "MirrorLeft", "MirrorRight", "SwitchLeft", "SwitchRight", "Battery", "BatteryDisable", "PantographOn", "PantographOff", "Headlights", "HazardBlink", "DriverLight", "BlinkerRight", "BlinkerLeft", "StepsHigh", "StepsLow", "StepsLowest", "Bell", "Horn", "WiperConstantSet", "WiperIntervalSet", "WindowWasherSet", "EmergencyBrakeDisable", "CircuitBreaker", "CircuitBreakerUn" }
function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/ruhrbahn/b_1973/section_b.mdl" )
	self.BaseClass.Initialize( self )
	self.DriverSeat = self:CreateSeat( "driver", Vector( -484, -3, 55 ), Angle( 0, 180, 0 ) )
	-- self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
	self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
	-- self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	-- self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false
	self.DoorCloseMomentsCaptured = false
	self.Speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserLeverState = 0
	self.ReverserEnaged = 0
	self.BrakePressure = 0
	self.ThrottleRate = 0
	self.Door1 = false
	self.Blinker = "Off"
	-- Lights sheen
	self.Lights = {
		[ 1 ] = {
			"light", -- headlight left
			Vector( -530, 30, 43 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 2 ] = {
			"light", -- headlight right
			Vector( -530, -30, 43 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 3 ] = {
			"light", -- headlight top
			Vector( -515, 0, 130 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 0.45,
			texture = "sprites/light_glow02.vmt"
		},
		[ 4 ] = {
			"light", -- tail light left
			Vector( -525, 20.9, 41 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 5 ] = {
			"light", -- tail light right
			Vector( -525, -20.9, 41 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 6 ] = {
			"light", -- brake lights
			Vector( -525, 20.9, 46 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 7 ] = {
			"light", -- brake lights
			Vector( -525, -20.9, 46 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 8 ] = {
			"light", -- indicator top left
			Vector( -487, 46, 79 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 9 ] = {
			"light", -- indicator top right
			Vector( -487, -46, 79 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 10 ] = {
			"light", -- indicator bottom left
			Vector( -487, 46, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 11 ] = {
			"light", -- indicator bottom right
			Vector( -487, -46, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 12 ] = {
			"light", -- door button front left 1
			Vector( -397, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 13 ] = {
			"light", -- door button front left 2
			Vector( -326.738, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 14 ] = {
			"light", -- door button front left 3
			Vector( -151.5, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 15 ] = {
			"light", -- door button front left 4
			Vector( -83.7, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 16 ] = {
			"light", -- door button front right 1
			Vector( -396.884, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 17 ] = {
			"light", -- door button front right 2
			Vector( -326.89, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 18 ] = {
			"light", -- door button front right 3
			Vector( -152.116, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 19 ] = {
			"light", -- door button front right 4
			Vector( -85, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 20 ] = {
			"light", -- cab light
			Vector( -406, 39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 21 ] = {
			"light", -- cab light
			Vector( -406, -39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
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

	self.KeyMap = {
		[ KEY_A ] = "ThrottleUp",
		[ KEY_D ] = "ThrottleDown",
		[ KEY_F ] = "ReduceBrake",
		[ KEY_H ] = "BellSet",
		[ KEY_SPACE ] = "DeadmanPedalSet",
		[ KEY_W ] = "ReverserUpSet",
		[ KEY_S ] = "ReverserDownSet",
		[ KEY_P ] = "PantographOnSet",
		[ KEY_O ] = "UnlockDoorsToggle",
		[ KEY_I ] = "DoorsForceCloseSet",
		[ KEY_K ] = "DoorsCloseConfirmSet",
		[ KEY_Z ] = "WarningAnnouncementSet",
		[ KEY_J ] = "DoorsSelectLeftSet",
		[ KEY_L ] = "DoorsSelectRightSet",
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
			[ KEY_N ] = "ParrallelSet",
			[ KEY_R ] = "CircuitBreakerSet",
			[ KEY_T ] = "CircuitBreakerUnSet",
			[ KEY_0 ] = "IgnitionKeyOff"
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
	local Panel = self.Panel
	--if self.SectionA.IBIS then self.IBIS = self.SectionA.IBIS end
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
	if button and toggle and button ~= "IgnitionKeyToggle" then
		self:ToggleButton( button )
	else
		self:SetButton( button )
	end

	local sys = self.SectionA.CoreSys
	local panel = self.Panel
	local doorHandler = self.DoorHandler
	if button == "IgnitionKeyOn" then sys:IgnitionKeyOnOffB() end
	if button == "IgnitionKeyOff" then sys:IgnitionKeyOnOffB() end
	if button == "IgnitionKeyToggle" then sys:IgnitionKeyInOutB() end
	if button == "ReverserUpSet" then sys:ReverserUpB() end
	if button == "ReverserDownSet" then sys:ReverserDownB() end
	if sys.ThrottleRateB == 0 and sys.ReverserB ~= 1 then
		if button == "ThrottleUp" then sys.ThrottleRateB = 2 end
		if button == "ThrottleDown" then sys.ThrottleRateB = -2 end
		if button == "ThrottleUpFast" then sys.ThrottleRateB = 8 end
		if button == "ThrottleDownFast" then sys.ThrottleRateB = -8 end
	end

	if button == "ThrottleZero" then
		sys.ThrottleRateB = 0
		sys.ThrottleStateB = 0
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

	if button == "CircuitBreakerSet" then
		sys:HVCircuitOn()
	elseif button == "CircuitBreakerUnSet" then
		sys:HVCircuitOff()
	end
end

function ENT:OnButtonRelease( button )
	local sys = self.SectionA.CoreSys
	self:HackButtonRelease( button )
	if button == "ThrottleUp" or button == "ThrottleDown" or button == "ThrottleUpFast" or button == "ThrottleDownFast" then sys.ThrottleRateB = 0 end
	if button == "PantographOnSet" then self.Panel.PantographOn = 0 end
	if button == "PantographOffSet" then self.Panel.PantographOff = 0 end
	if button == "BellSet" then self.Panel.Bell = 0 end
	if button == "HornSet" then self.Panel.Horn = 0 end
end

function ENT:TrainSpawnerUpdate()
	self:UpdateTextures()
end