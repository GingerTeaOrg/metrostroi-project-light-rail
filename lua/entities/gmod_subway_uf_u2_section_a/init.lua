AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 1100
ENT.SyncTable = { "ReduceBrake", "Highbeam", "SetHoldingBrake", "DoorsLock", "DoorsUnlock", "PantographRaise", "PantographLower", "Headlights", "WarnBlink", "Microphone", "BellEngage", "Horn", "WarningAnnouncement", "PantoUp", "DoorsCloseConfirm", "ReleaseHoldingBrake", "PassengerOverground", "PassengerUnderground", "SetPointRight", "SetPointLeft", "ThrowCoupler", "Door1", "UnlockDoors", "DoorCloseSignal", "Number1", "Number2", "Number3", "Number4", "Number6", "Number7", "Number8", "Number9", "Number0", "Destination", "Delete", "Route", "DateAndTime", "ServiceAnnouncements" }
function ENT:Initialize()
	self.BaseClass.Initialize( self )
	self:SetPos( self:GetPos() + Vector( 0, 0, 10 ) ) -- set to 200 if one unit spawns in ground
	if self:GetNW2String( "Texture" ) == "OrEbSW" then self:SetNW2Bool( "RetroMode", false ) end
	-- Set model and initialize
	if self:GetNW2Bool( "RetroMode", false ) == true then
		self:SetModel( "models/lilly/uf/u2/u2_vintage.mdl" )
	elseif self:GetNW2Bool( "RetroMode", false ) == false then
		self:SetModel( "models/lilly/uf/u2/u2h.mdl" )
	end

	self.BaseClass.Initialize( self )
	self:SetPos( self:GetPos() + Vector( 0, 0, 10 ) ) -- set to 200 if one unit spawns in ground
	-- Create seat entities
	self.DriverSeat = self:CreateSeat( "driver", Vector( 395, 15, 34 ) )
	self.InstructorsSeat = self:CreateSeat( "instructor", Vector( 395, -20, 10 ), Angle( 0, 90, 0 ), "models/vehicles/prisoner_pod_inner.mdl" )
	-- self.HelperSeat = self:CreateSeat("instructor",Vector(505,-25,55))
	self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
	self.InstructorsSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.InstructorsSeat:SetColor( Color( 0, 0, 0, 0 ) )
	self.Debug = 1
	self.LeadingCab = 0
	self.WarningAnnouncement = 0
	self.SquealSensitivity = 20
	self.DoorStatesRight = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0
	}

	self.DoorStatesLeft = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0
	}

	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false
	self.RandomnessCalulated = false
	self.DepartureConfirmed = true
	self.DoorCloseMoments = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0
	}

	self.AllDoorsAreClosed = true
	self.DoorCloseMomentsCaptured = false
	self.Speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserLeverState = 0
	self.ReverserEnaged = 0
	self.BrakePressure = 0
	self.ThrottleRate = 0
	self.MotorPower = 0
	self.LastDoorTick = 0
	self.WagonNumber = 303
	self.Door1 = false
	self.CheckDoorsClosed = false
	self.Haltebremse = 0
	self.CabWindowR = 0
	self.CabWindowL = 0
	self.AlarmSound = 0
	self.DoorLockSignalMoment = 0
	self.DoorsOpen = false
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF( Vector( 290, 0, 0 ), Angle( 0, 180, 0 ), true, "duewag_motor", "a" )
	self.MiddleBogey = self:CreateBogeyUF( Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), false, "u2joint", "a" )
	self:SetNWEntity( "FrontBogey", self.FrontBogey )
	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler( Vector( 415, 0, 0 ), Angle( 0, 0, 0 ), true, "u2", "a" )
	self.ElectricOnMoment = 0
	self.ElectricKickStart = false
	self.ElectricStarted = false
	-- Create U2 Section B
	self.SectionB = self:CreateSection( Vector( 0, 0, 0 ), nil, --[[no angle]]
		"gmod_subway_uf_u2_section_b", self, nil, self )

	self.RearBogey = self:CreateBogeyUF( Vector( -290, 0, 0 ), Angle( 0, 180, 0 ), false, "duewag_motor", "b" )
	self.RearCouple = self:CreateCustomCoupler( Vector( -415, 0, 0 ), Angle( 0, 180, 0 ), false, "u2", "b" )
	self.Panto = self:CreatePanto( Vector( 35, 0, 115 ), Angle( 0, 90, 0 ), "diamond" )
	self.PantoUp = false
	self.ReverserInsert = false
	self.BatteryOn = false
	self.FrontBogey:SetNWString( "MotorSoundType", "U2" )
	self.MiddleBogey:SetNWString( "MotorSoundType", "U2" )
	self.RearBogey:SetNWString( "MotorSoundType", "U2" )
	self.FrontBogey:SetNWBool( "Async", false )
	self.MiddleBogey:SetNWBool( "Async", false )
	self.RearBogey:SetNWBool( "Async", false )
	self:SetNW2Float( "Blinds", 0.2 )
	self.BlinkerOn = false
	self.BlinkerLeft = false
	self.BlinkerRight = false
	self.Blinker = "Off"
	self.LastTriggerTime = 0
	self:SetNW2String( "BlinkerDirection", "none" )
	dS.DoorRandomnessRight = {
		[ 1 ] = -1,
		[ 2 ] = -1,
		[ 3 ] = -1,
		[ 4 ] = -1
	}

	-- self.Lights = {}
	self.DoorSideUnlocked = "None"
	self:SetPackedBool( "FlickBatterySwitchOn", false )
	self:SetPackedBool( "FlickBatterySwitchOff", false )
	self.PrevTime = 0
	self.DeltaTime = 0
	self.IBISKeyRegistered = false
	self.RollsignModifier = 0
	self.RollsignModifierRate = 0
	self.ScrollMoment = 0
	self.ScrollMomentDelta = 0
	self.ScrollMomentRecorded = false
	self.IBISKeyPassed = false
	self.IBISUnlocked = false
	self.IBISKeyInserted = false
	self.TrainWireCrossConnections = {
		[ 3 ] = 4, -- Reverser F<->B
		[ 21 ] = 20, -- blinker
		[ 13 ] = 14,
		[ 31 ] = 32
	}

	self.DoorOpenMoments = {
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0
	}

	-- Initialize key mapping
	self.KeyMap = {
		[ KEY_A ] = "ThrottleUp",
		[ KEY_D ] = "ThrottleDown",
		[ KEY_F ] = "ReduceBrake",
		[ KEY_H ] = "BellEngageSet",
		[ KEY_SPACE ] = "DeadmanSet",
		[ KEY_W ] = "ReverserUpSet",
		[ KEY_S ] = "ReverserDownSet",
		[ KEY_P ] = "PantographRaiseSet",
		[ KEY_O ] = "DoorsUnlockSet",
		[ KEY_I ] = "DoorsLockSet",
		[ KEY_K ] = "DoorsCloseConfirmSet",
		[ KEY_Z ] = "WarningAnnouncementSet",
		[ KEY_J ] = "DoorsSelectLeftToggle",
		[ KEY_L ] = "DoorsSelectRightToggle",
		[ KEY_B ] = "BatteryToggle",
		[ KEY_V ] = "HeadlightsToggle",
		[ KEY_M ] = "Mirror",
		[ KEY_1 ] = "Throttle10Pct",
		[ KEY_2 ] = "Throttle20Pct",
		[ KEY_3 ] = "Throttle30Pct",
		[ KEY_4 ] = "Throttle40Pct",
		[ KEY_5 ] = "Throttle50Pct",
		[ KEY_6 ] = "Throttle60Pct",
		[ KEY_7 ] = "Throttle70Pct",
		[ KEY_8 ] = "Throttle80Pct",
		[ KEY_9 ] = "Throttle90Pct",
		[ KEY_PERIOD ] = "BlinkerRightSet",
		[ KEY_COMMA ] = "BlinkerLeftSet",
		[ KEY_PAD_MINUS ] = "IBISkeyTurnSet",
		[ KEY_LSHIFT ] = {
			[ KEY_0 ] = "ReverserInsert",
			[ KEY_A ] = "ThrottleUpFast",
			[ KEY_D ] = "ThrottleDownFast",
			[ KEY_S ] = "ThrottleZero",
			[ KEY_H ] = "Horn",
			[ KEY_V ] = "DriverLightToggle",
			[ KEY_COMMA ] = "WarnBlinkToggle",
			[ KEY_B ] = "BatteryDisableToggle",
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
			[ KEY_P ] = "PantographLowerSet",
			[ KEY_MINUS ] = "RemoveIBISKey",
			[ KEY_PAD_MINUS ] = "IBISkeyInsertSet"
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
			[ KEY_N ] = "Parrallel"
		}
	}

	-- self:TrainSpawnerUpdate()
	-- Lights sheen
	self.Lights = {
		[ 50 ] = {
			"light",
			Vector( 406, 39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
		},
		-- cab light
		[ 60 ] = {
			"light",
			Vector( 406, -39, 98 ),
			Angle( 90, 0, 0 ),
			Color( 227, 197, 160 ),
			brightness = 0.6,
			scale = 0.5,
			texture = "sprites/light_glow02.vmt"
		},
		-- cab light
		[ 51 ] = {
			"light",
			Vector( 425.464, 40, 28 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		-- headlight left
		[ 52 ] = {
			"light",
			Vector( 425.464, -40, 28 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			brightness = 0.6,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		-- headlight right
		[ 53 ] = {
			"light",
			Vector( 425.464, 0, 111 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 0.45,
			texture = "sprites/light_glow02.vmt"
		},
		-- headlight top
		[ 54 ] = {
			"light",
			Vector( 425.464, 31.5, 25 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- tail light left
		[ 55 ] = {
			"light",
			Vector( 425.464, -31.5, 25 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- tail light right
		[ 56 ] = {
			"light",
			Vector( 426, 31.2, 31 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- brake lights
		[ 57 ] = {
			"light",
			Vector( 426, -31.2, 31 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- brake lights
		[ 58 ] = {
			"light",
			Vector( 327, 52, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- indicator top left
		[ 59 ] = {
			"light",
			Vector( 327, -52, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- indicator top right
		[ 48 ] = {
			"light",
			Vector( 327, 52, 68 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- indicator bottom left
		[ 49 ] = {
			"light",
			Vector( 327, -52, 68 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		-- indicator bottom right
		[ 30 ] = {
			"light",
			Vector( 397, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front left 1
		[ 31 ] = {
			"light",
			Vector( 326.738, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front left 2
		[ 32 ] = {
			"light",
			Vector( 151.5, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front left 3
		[ 33 ] = {
			"light",
			Vector( 83.7, 49, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front left 4
		[ 34 ] = {
			"light",
			Vector( 396.884, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front right 1
		[ 35 ] = {
			"light",
			Vector( 326.89, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front right 2
		[ 36 ] = {
			"light",
			Vector( 152.116, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front right 3
		[ 37 ] = {
			"light",
			Vector( 85, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- door button front right 4
		[ 38 ] = {
			"light",
			Vector( 416.20, 6, 54 ),
			Angle( 0, 0, 0 ),
			Color( 0, 90, 59 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- indicator indication lamp in cab
		[ 39 ] = {
			"light",
			Vector( 415.617, 18.8834, 54.8 ),
			Angle( 0, 0, 0 ),
			Color( 252, 247, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- battery discharge lamp in cab
		[ 40 ] = {
			"light",
			Vector( 415.617, 12.4824, 54.9 ),
			Angle( 0, 0, 0 ),
			Color( 0, 130, 99 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- clear for departure lamp
		[ 41 ] = {
			"light",
			Vector( 415.656, -2.45033, 54.55 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		-- doors unlocked lamp
		[ 42 ] = {
			"light",
			Vector( 415.656, 14.6172, 54.55 ),
			Angle( 0, 0, 0 ),
			Color( 27, 57, 141 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		}
	}

	-- departure clear lamp
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

	if self:GetNW2Bool( "RetroMode", false ) == true then
		self:SetModel( "models/lilly/uf/u2/u2_vintage.mdl" )
	elseif self:GetNW2Bool( "RetroMode", false ) == false then
		self:SetModel( "models/lilly/uf/u2/u2h.mdl" )
	end
end

function ENT:TrainSpawnerUpdate()
	local tex = "Def_U2"
	self.MiddleBogey.Texture = self.Texture
	self:UpdateTextures()
	self.MiddleBogey:UpdateTextures()
	self.SectionB:TrainSpawnerUpdate()
	-- self.MiddleBogey:UpdateTextures()
	-- self.MiddleBogey:UpdateTextures()
	-- self:UpdateLampsColors()
	self.FrontCouple.CoupleType = "u2"
	self.RearCouple.CoupleType = "u2"
	self.FrontCouple:SetParameters()
	self.RearCouple:SetParameters()
	-- self.SectionB:SetNW2String("Texture", self:GetNW2String("Texture"))
	-- self.SectionB.Texture = self:GetNW2String("Texture")
end

function ENT:HeadlightControl()
	local battery = self.CoreSys.BatteryOn
	local coupledA = IsValid( self.FrontCouple.CoupledEnt )
	local coupledB = IsValid( self.RearCouple.CoupledEnt )
	local headlights = self.Panel.Headlights > 0 or self.SectionB.Panel.Headlights > 0
	local MUMode = self:ReadTrainWire( 6 ) > 0 and true or false
	-- local reverse = self.CoreSys.ReverserState < 0 and true or false
	if not battery then
		for k, _ in ipairs( self.Lights ) do
			self:SetLightPower( k, false )
		end

		for k, _ in ipairs( self.SectionB.Lights ) do
			self.SectionB:SetLightPower( k, false )
		end
		return
	end

	if not self.BlinkerOn then -- control brake lights, but only if the hazard lights aren't on, TODO: differentiate between hazards and normal blinker
		self.SectionB:SetLightPower( 66, not CoupledB and self.BrakesOn )
		self.SectionB:SetLightPower( 67, not CoupledB and self.BrakesOn )
	end

	self:SetLightPower( 40, self.DepartureConfirmed )
	self:SetLightPower( 41, self.DoorsUnlocked )
	self:SetLightPower( 50, self:GetNW2Bool( "Cablight", false ) )
	self:SetLightPower( 60, self:GetNW2Bool( "Cablight", false ) )
	self:WriteTrainWire( 13, self.DoorSideUnlocked == "Left" and MUMode and 1 or 0 )
	self:WriteTrainWire( 14, self.DoorSideUnlocked == "Right" and MUMode and 1 or 0 )
	self:WriteTrainWire( 15, self.DoorsUnlocked and MUMode and 1 or 0 )
	self:WriteTrainWire( 33, ( headlights and MUMode or self:ReadTrainWire( 33 ) > 0 ) and 1 or 0 )
	self:WriteTrainWire( 31, ( headlights and self:ReadTrainWire( 3 ) > 0 and MUMode ) and 1 or ( self:ReadTrainWire( 3 ) > 0 and MUMode and self:ReadTrainWire( 33 ) > 0 ) and 1 or 0 )
	self:WriteTrainWire( 32, ( headlights and self:ReadTrainWire( 4 ) > 0 and MUMode ) and 1 or ( self:ReadTrainWire( 4 ) > 0 and MUMode and self:ReadTrainWire( 33 ) > 0 ) and 1 or 0 )
	--------------------------------------------------------------------------------------------------------------------------------------------
	self:SetLightPower( 51, self:ReadTrainWire( 31 ) > 0 and not coupledA or self.Panel.Headlights > 0 and not coupledA or false )
	self:SetLightPower( 52, self:ReadTrainWire( 31 ) > 0 and not coupledA or self.Panel.Headlights > 0 and not coupledA or false )
	self:SetLightPower( 53, self:ReadTrainWire( 31 ) > 0 and not coupledA or self.Panel.Headlights > 0 and not coupledA or false )
	self:SetLightPower( 54, self:ReadTrainWire( 32 ) > 0 and not coupledA or self.SectionB.Panel.Headlights > 0 and not coupledA or false or self.SectionB.Panel.Headlights > 0 and not coupledA or coupledA and false )
	self:SetLightPower( 55, self:ReadTrainWire( 32 ) > 0 and not coupledA or self.SectionB.Panel.Headlights > 0 and not coupledA or false or self.SectionB.Panel.Headlights > 0 and not coupledA or coupledA and false )
	---------------------------------------------------------------------------------------------------------------------------------------------
	self.SectionB:SetLightPower( 61, coupledB and false or self:ReadTrainWire( 31 ) > 0 and false or self.Panel.Headlights > 0 and false or self.SectionB.Panel.Headlights > 0 or self:ReadTrainWire( 32 ) > 0 or coupledB and false )
	self.SectionB:SetLightPower( 62, coupledB and false or self:ReadTrainWire( 31 ) > 0 and false or self.Panel.Headlights > 0 and false or self.SectionB.Panel.Headlights > 0 or self:ReadTrainWire( 32 ) > 0 or coupledB and false )
	self.SectionB:SetLightPower( 63, coupledB and false or self:ReadTrainWire( 31 ) > 0 and false or self.Panel.Headlights > 0 and false or self.SectionB.Panel.Headlights > 0 or self:ReadTrainWire( 32 ) > 0 or coupledB and false )
	self.SectionB:SetLightPower( 64, coupledB and false or self:ReadTrainWire( 31 ) > 0 and true or self.Panel.Headlights > 0 and not coupledB and true or false )
	self.SectionB:SetLightPower( 65, coupledB and false or self:ReadTrainWire( 31 ) > 0 and true or self.Panel.Headlights > 0 and not coupledB and true or false )
	-------------------------------------------------------------------------------------------------------------------------------------------
	self:SetLightPower( 30, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or ( self:ReadTrainWire( 13 ) > 0 and self:ReadTrainWire( 15 ) > 0 ) )
	self:SetLightPower( 31, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or ( self:ReadTrainWire( 13 ) > 0 and self:ReadTrainWire( 15 ) > 0 ) )
	self:SetLightPower( 32, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or ( self:ReadTrainWire( 13 ) > 0 and self:ReadTrainWire( 15 ) > 0 ) )
	self:SetLightPower( 33, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or ( self:ReadTrainWire( 13 ) > 0 and self:ReadTrainWire( 15 ) > 0 ) )
	self:SetLightPower( 34, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or ( self:ReadTrainWire( 14 ) > 0 and self:ReadTrainWire( 14 ) > 0 ) )
	self:SetLightPower( 35, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or ( self:ReadTrainWire( 14 ) > 0 and self:ReadTrainWire( 14 ) > 0 ) )
	self:SetLightPower( 36, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or ( self:ReadTrainWire( 14 ) > 0 and self:ReadTrainWire( 14 ) > 0 ) )
	self:SetLightPower( 37, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or ( self:ReadTrainWire( 14 ) > 0 and self:ReadTrainWire( 14 ) > 0 ) )
	---------------------------------------------------
	self.SectionB:SetLightPower( 30, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or self:ReadTrainWire( 13 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 31, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or self:ReadTrainWire( 13 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 32, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or self:ReadTrainWire( 13 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 33, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Left" ) or self:ReadTrainWire( 13 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 34, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or self:ReadTrainWire( 14 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 35, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or self:ReadTrainWire( 14 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 36, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or self:ReadTrainWire( 14 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
	self.SectionB:SetLightPower( 37, ( self.DoorsUnlocked == false and self:ReadTrainWire( 15 ) < 1 ) and false or ( self.DoorsUnlocked == true and self.DoorSideUnlocked == "Right" ) or self:ReadTrainWire( 14 ) > 0 and ( self:ReadTrainWire( 15 ) > 0 ) )
end

function ENT:Think( dT )
	self.BaseClass.Think( self )
	self:HeadlightControl()
	self.CoreSys:DoorHandler( self.DoorsUnlocked or self:ReadTrainWire( 15 ) > 0, self:ReadTrainWire( 13 ) > 0 or self.DoorSideUnlocked == "Left", self:ReadTrainWire( 14 ) > 0 or self.DoorSideUnlocked == "Right", false )
	self.CoreSys:Blink( ( self:ReadTrainWire( 20 ) > 0 or self:ReadTrainWire( 21 ) > 0 or self.Panel.BlinkerLeft > 0 or self.Panel.BlinkerRight > 0 ) and self.BatteryOn, self:ReadTrainWire( 20 ) > 0 or self.Panel.BlinkerLeft > 0 and not MU, self:ReadTrainWire( 21 ) > 0 or self.Panel.BlinkerRight > 0 and not MU )
	self:SetNW2Bool( "RetroMode", self.Texture == "SVB" )
	if self:GetNW2Bool( "RetroMode", false ) == true and self:GetNW2Bool( "ModelOverrideDone", false ) == false then
		self:SetModel( "models/lilly/uf/u2/u2_vintage.mdl" )
		self:SetNW2Bool( "ModelOverrideDone", true )
	end

	self:SetNW2String( "DoorSideUnlocked", self.DoorSideUnlocked )
	self:SetNW2Bool( "DoorsUnlocked", self.DoorsUnlocked )
	if self:GetPackedBool( "BOStrab", false ) == true then self:SetPackedBool( "BOStrab", false ) end
	self:SetNWEntity( "FrontBogey", self.FrontBogey )
	self:SetNW2Float( "MotorPower", self.FrontBogey:GetMotorPower() )
	local Panel = self.Panel
	self:SetPackedBool( "WarningAnnouncement", Panel.WarningAnnouncement > 0 )
	self:SetPackedBool( "AnnPlay", self.Panel.AnnouncerPlaying > 0 )
	self.CabWindowL = math.Clamp( self.CabWindowL, 0, 1 )
	self.CabWindowR = math.Clamp( self.CabWindowR, 0, 1 )
	self:SetNW2Float( "CabWindowL", self.CabWindowL )
	self:SetNW2Float( "CabWindowR", self.CabWindowR )
	self.Speed = math.abs( self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858 )
	self:SetNW2Int( "Speed", self.Speed )
	self:SetNW2Bool( "AIsCoupled", IsValid( self.FrontCouple.CoupledEnt ) )
	self:SetNW2Bool( "BIsCoupled", IsValid( self.RearCouple.CoupledEnt ) )
	self:SetNWFloat( "BatteryCharge", self.Duewag_Battery.Voltage )
	if self.BatteryOn == true or self:ReadTrainWire( 7 ) > 0 then
		self:Traction()
		self:WriteTrainWire( 20, self.Panel.WarnBlink < 1 and ( self.Panel.BlinkerLeft > 0 and 1 or 0 ) or 1 )
		self:WriteTrainWire( 21, self.Panel.WarnBlink < 1 and ( self.Panel.BlinkerRight > 0 and 1 or 0 ) or 1 )
		self.ThrottleState = math.Clamp( self.ThrottleState, -100, 100 )
		-- Send door states to client
		self:SetNWFloat( "Door12a", self.DoorStatesRight[ 1 ] )
		self:SetNWFloat( "Door34a", self.DoorStatesRight[ 2 ] )
		self:SetNWFloat( "Door56a", self.DoorStatesRight[ 3 ] )
		self:SetNWFloat( "Door78a", self.DoorStatesRight[ 4 ] )
		self:SetNWFloat( "Door12b", self.DoorStatesLeft[ 1 ] )
		self:SetNWFloat( "Door34b", self.DoorStatesLeft[ 2 ] )
		self:SetNWFloat( "Door56b", self.DoorStatesLeft[ 3 ] )
		self:SetNWFloat( "Door78b", self.DoorStatesLeft[ 4 ] )
		self:SetNWFloat( "DoorSwitch", self.Panel.DoorsSelectLeft > 0 and 1 or 0.5 or self.Panel.DoorsSelectLeft > 0 and 1 )
		self.AllDoorsAreClosed = self.CoreSys:CheckDoorsAllClosed( self.DoorsPreviouslyUnlocked ) and true or false
		self:SetNW2Bool( "DoorCloseAlarm", ( self.DoorsPreviouslyUnlocked and not self.DoorsUnlocked and self.AllDoorsAreClosed and not self.DoorsClosedAlarmAcknowledged and self.CoreSys.ReverserInsertedA == true ) and true or false )
		-- print(self.AllDoorsAreClosed)
		if self.DoorStatesRight[ 1 ] > 0 or self.DoorStatesRight[ 2 ] > 0 or self.DoorStatesRight[ 3 ] > 0 or self.DoorStatesRight[ 4 ] > 0 then
			self.RightDoorsOpen = true
			self.SectionB.RightDoorsOpen = true
		else
			self.RightDoorsOpen = false
			self.SectionB.RightDoorsOpen = false
		end

		if ( self.DoorStatesLeft[ 1 ] > 0 or self.DoorStatesLeft[ 2 ] > 0 ) and ( self.DoorStatesLeft[ 3 ] < 0.9 and self.DoorStatesLeft[ 4 ] < 0.9 ) then
			self.LeftDoorsOpen = false
			self.SectionB.LeftDoorsOpen = true
		elseif ( self.DoorStatesLeft[ 1 ] > 0.8 or self.DoorStatesLeft[ 2 ] > 0.8 ) and ( self.DoorStatesLeft[ 3 ] > 0.8 and self.DoorStatesLeft[ 4 ] > 0.8 ) then
			self.LeftDoorsOpen = true
			self.SectionB.LeftDoorsOpen = true
		elseif ( self.DoorStatesLeft[ 1 ] < 0.8 or self.DoorStatesLeft[ 2 ] < 0.8 ) and ( self.DoorStatesLeft[ 3 ] > 0.8 and self.DoorStatesLeft[ 4 ] > 0.8 ) then
			self.LeftDoorsOpen = true
			self.SectionB.LeftDoorsOpen = false
		else
			self.LeftDoorsOpen = false
			self.SectionB.LeftDoorsOpen = false
		end
	end
end

function ENT:OnButtonPress( button, ply )
	local dS = self.MPLR_DoorHandler
	if button == "IBISkeyInsertSet" then
		if self:GetNW2Bool( "InsertIBISKey", false ) == false then
			self:SetNW2Bool( "InsertIBISKey", true )
		else
			self:SetNW2Bool( "InsertIBISKey", false )
		end
	end

	if button == "IBISkeyTurnSet" then
		if self:GetNW2Bool( "TurnIBISKey", false ) == false then
			self:SetNW2Bool( "TurnIBISKey", true )
		else
			self:SetNW2Bool( "TurnIBISKey", false )
		end
	end

	if button == "SetPointLeftSet" then
		if self.IBIS.Override == "left" then
			self.IBIS:OverrideSwitching( nil )
		else
			self.IBIS.Override = "left"
		end
	end

	if button == "SetPointRightSet" then
		if self.IBIS.Override == "right" then
			self.IBIS:OverrideSwitching( nil )
		else
			self.IBIS.Override = "right"
		end
	end

	if button == "HighbeamToggle" then
		if self.Panel.Highbeam == 0 then
			self.Panel.Highbeam = 1
		else
			self.Panel.Highbeam = 0
		end
	end

	if button == "PassengerOvergroundSet" then self.Panel.PassengerOverground = 1 end
	if button == "PassengerUndergroundSet" then self.Panel.PassengerUnderground = 1 end
	if button == "SetPointLeftSet" then self.Panel.SetPointLeft = 1 end
	if button == "SetPointRightSet" then self.Panel.SetPointRight = 1 end
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.CoreSys.ThrottleRateA == 0 then
		if button == "ThrottleUp" then self.CoreSys.ThrottleRateA = 3 end
		if button == "ThrottleDown" then self.CoreSys.ThrottleRateA = -3 end
	end

	if self.CoreSys.ThrottleRateA == 0 then
		if button == "ThrottleUpFast" then self.CoreSys.ThrottleRateA = 10 end
		if button == "ThrottleDownFast" then self.CoreSys.ThrottleRateA = -10 end
	end

	if self.CoreSys.ThrottleRateA == 0 then
		if button == "ThrottleUpReallyFast" then self.CoreSys.ThrottleRateA = 20 end
		if button == "ThrottleDownReallyFast" then self.CoreSys.ThrottleRateA = -20 end
	end

	if button == "Door1Set" then
		self.Door1 = true
		self.Panel.Door1 = 1
	end

	if self.CoreSys.ThrottleRateA == 0 then
		if button == "ThrottleZero" then self.CoreSys.ThrottleStateA = 0 end
		if self:GetNW2Bool( "EmergencyBrake", false ) == true then self:SetNW2Bool( "EmergencyBrake", false ) end
	end

	if button == "Throttle10Pct" then self.CoreSys.ThrottleStateA = 10 end
	if button == "Throttle20Pct" then self.CoreSys.ThrottleStateA = 20 end
	if button == "Throttle30Pct" then self.CoreSys.ThrottleStateA = 30 end
	if button == "Throttle40Pct" then self.CoreSys.ThrottleStateA = 40 end
	if button == "Throttle50Pct" then self.CoreSys.ThrottleStateA = 50 end
	if button == "Throttle60Pct" then self.CoreSys.ThrottleStateA = 60 end
	if button == "Throttle70Pct" then self.CoreSys.ThrottleStateA = 70 end
	if button == "Throttle80Pct" then self.CoreSys.ThrottleStateA = 80 end
	if button == "Throttle90Pct" then self.CoreSys.ThrottleStateA = 90 end
	if button == "Throttle10-Pct" then self.CoreSys.ThrottleStateA = -10 end
	if button == "Throttle20-Pct" then self.CoreSys.ThrottleStateA = -20 end
	if button == "Throttle30-Pct" then self.CoreSys.ThrottleStateA = -30 end
	if button == "Throttle40-Pct" then self.CoreSys.ThrottleStateA = -40 end
	if button == "Throttle50-Pct" then self.CoreSys.ThrottleStateA = -50 end
	if button == "Throttle60-Pct" then self.CoreSys.ThrottleStateA = -60 end
	if button == "Throttle70-Pct" then self.CoreSys.ThrottleStateA = -70 end
	if button == "Throttle80-Pct" then self.CoreSys.ThrottleStateA = -80 end
	if button == "Throttle90-Pct" then self.CoreSys.ThrottleStateA = -90 end
	if button == "PantographRaiseSet" then
		self.Panel.PantographRaise = 1
		if self.CoreSys.BatteryOn == true then
			self.PantoUp = true
			if self:ReadTrainWire( 6 ) > 0 then self:WriteTrainWire( 17, 0 ) end
		end
	end

	if button == "PantographLowerSet" then
		if self.CoreSys.BatteryOn == true then
			self.PantoUp = false
			if self:ReadTrainWire( 6 ) > 0 then self:WriteTrainWire( 17, 0 ) end
		end
	end

	if button == "EmergencyBrakeSet" and self:GetNW2Bool( "EmergencyBrake", false ) == false then
		self:SetNW2Bool( "EmergencyBrake", true )
	elseif button == "EmergencyBrakeSet" and self:GetNW2Bool( "EmergencyBrake", false ) == true then
		self:SetNW2Bool( "EmergencyBrake", false )
	end

	if button == "Rollsign+" then self:SetNW2Bool( "Rollsign+", true ) end
	if button == "Rollsign-" then self:SetNW2Bool( "Rollsign-", true ) end
	if button == "CabWindowR+" then
		self.CabWindowR = self.CabWindowR - 0.1
		------print(self:GetNW2Float("CabWindowR"))
	end

	if button == "CabWindowR-" then
		self.CabWindowR = self.CabWindowR + 0.1
		------print(self:GetNW2Float("CabWindowR"))
	end

	if button == "CabWindowL+" then
		self.CabWindowL = self.CabWindowL - 0.1
		------print(self:GetNW2Float("CabWindowL"))
	end

	if button == "CabWindowL-" then
		self.CabWindowL = self.CabWindowL + 0.1
		------print(self:GetNW2Float("CabWindowL"))
	end

	if button == "WarningAnnouncementSet" then
		-- self:Wait(1)
		self:SetNW2Bool( "WarningAnnouncement", true )
	end

	if button == "Blinds+" then
		self:SetNW2Float( "Blinds", self:GetNW2Float( "Blinds" ) + 0.1 )
		self:SetNW2Float( "Blinds", math.Clamp( self:GetNW2Float( "Blinds" ), 0.2, 1 ) )
	end

	if button == "Blinds-" then
		self:SetNW2Float( "Blinds", self:GetNW2Float( "Blinds" ) - 0.1 )
		self:SetNW2Float( "Blinds", math.Clamp( self:GetNW2Float( "Blinds" ), 0.2, 1 ) )
	end

	if button == "ReverserUpSet" then
		if not self.CoreSys.ThrottleEngaged == true then
			if self.CoreSys.ReverserInsertedA == true then
				self.CoreSys.ReverserLeverStateA = self.CoreSys.ReverserLeverStateA + 1
				self.CoreSys.ReverserLeverStateA = math.Clamp( self.CoreSys.ReverserLeverStateA, -1, 3 )
			end
		end
	end

	if button == "ReverserDownSet" then
		if not self.CoreSys.ThrottleEngaged and self.CoreSys.ReverserInsertedA == true then
			-- self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp( self.CoreSys.ReverserLeverStateA, -1, 3 )
			-- self.CoreSys:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			self.CoreSys.ReverserLeverStateA = self.CoreSys.ReverserLeverStateA - 1
			self.CoreSys.ReverserLeverStateA = math.Clamp( self.CoreSys.ReverserLeverStateA, -1, 3 )
			-- PrintMessage(HUD_PRINTTALK,self.CoreSys.ReverserLeverStateA)
		end
	end

	if self.CoreSys.ReverserLeverStateB == 0 and self.CoreSys.ReverserLeverStateA == 0 then
		if button == "ReverserInsert" then
			if self.CoreSys.ReverserInsertedB and not self.CoreSys.ReverserInsertedA then
				self.CoreSys.ReverserInsertedA = true
				self.CoreSys.ReverserInsertedB = false
			elseif not self.CoreSys.ReverserInsertedB and self.CoreSys.ReverserInsertedA then
				self.CoreSys.ReverserInsertedA = false
			elseif not self.CoreSys.ReverserInsertedB and not self.CoreSys.ReverserInsertedA then
				self.CoreSys.ReverserInsertedA = true
			end
		end
	end

	if button == "BatteryToggle" then
		self:SetPackedBool( "FlickBatterySwitchOn", true )
		if self.BatteryOn == false and self.CoreSys.ReverserLeverStateA == 1 then
			self.BatteryOn = true
			self.Duewag_Battery:TriggerInput( "Charge", 1.3 )
			self:SetNW2Bool( "BatteryOn", true )
			-- PrintMessage(HUD_PRINTTALK, "Battery switch is ON")
		end
	end

	if button == "BatteryDisableToggle" then
		if self.BatteryOn == true and self.CoreSys.ReverserLeverStateA == 1 then
			self.BatteryOn = false
			self.Duewag_Battery:TriggerInput( "Charge", 0 )
			self:SetNW2Bool( "BatteryOn", false )
			-- PrintMessage(HUD_PRINTTALK, "Battery switch is off")
			-- self:SetNW2Bool("BatteryToggleIsTouched",true)
		end

		self:SetPackedBool( "FlickBatterySwitchOff", true )
	end

	if button == "DeadmanSet" then
		self.DeadmanUF.IsPressedA = true
		if self:ReadTrainWire( 6 ) > 0 then self:WriteTrainWire( 12, 1 ) end
		------print("DeadmanPressedYes")
	end

	if button == "BlinkerLeftSet" then
		if self.Panel.BlinkerLeft == 0 and self.Panel.BlinkerRight == 0 then
			self.Panel.BlinkerLeft = 1
		elseif self.Panel.BlinkerLeft == 0 and self.Panel.BlinkerRight == 1 then
			self.Panel.BlinkerLeft = 0
			self.Panel.BlinkerRight = 0
		end
	end

	if button == "BlinkerRightSet" then
		if self.Panel.BlinkerRight == 0 and self.Panel.BlinkerLeft == 0 then
			self.Panel.BlinkerRight = 1
		elseif self.Panel.BlinkerLeft == 1 and self.Panel.BlinkerRight == 0 then
			self.Panel.BlinkerRight = 0
			self.Panel.BlinkerLeft = 0
		end
	end

	if button == "BellEngageSet" then self:SetNW2Bool( "Bell", true ) end
	if button == "Horn" then self:SetNW2Bool( "Horn", true ) end
	if button == "WarnBlinkToggle" then
		if self.Panel.WarnBlink == 0 then
			self:SetNW2Bool( "WarningBlinker", true )
			self:WriteTrainWire( 20, 1 )
			self:WriteTrainWire( 21, 1 )
			self.Panel.WarnBlink = 1
		elseif self.Panel.WarnBlink == 1 then
			self:SetNW2Bool( "WarningBlinker", false )
			self:WriteTrainWire( 20, 0 )
			self:WriteTrainWire( 21, 0 )
			self.Panel.WarnBlink = 0
		end
	end

	if button == "ThrowCouplerSet" then
		if self:ReadTrainWire( 5 ) > 1 and self.CoreSys.Speed < 2 then self.FrontCouple:Decouple() end
		self.Panel.ThrowCoupler = 1
	end

	if button == "DriverLightToggle" then
		if self:GetNW2Bool( "Cablight", false ) == false then
			self:SetNW2Bool( "Cablight", true )
		elseif self:GetNW2Bool( "Cablight", false ) == true then
			self:SetNW2Bool( "Cablight", false )
		end
	end

	if button == "HeadlightsToggle" then
		if self.Panel.Headlights < 1 then
			self.Panel.Headlights = 1
		else
			self.Panel.Headlights = 0
		end
		----print(self.CoreSys.HeadlightsSwitch)
	end

	if button == "DoorsSelectLeftToggle" then
		if self.DoorSideUnlocked == "None" then
			self.DoorSideUnlocked = "Left"
		elseif self.DoorSideUnlocked == "Right" then
			self.DoorSideUnlocked = "None"
		elseif self.DoorSideUnlocked == "Left" then
			self.DoorSideUnlocked = self.DoorSideUnlocked
		end

		if self.Panel.DoorsSelectLeft < 1 and self.Panel.DoorsSelectRight > 0 then
			self.Panel.DoorsSelectLeft = 0
			self.Panel.DoorsSelectRight = 0
		elseif self.Panel.DoorsSelectLeft < 1 and self.Panel.DoorsSelectRight < 1 then
			self.Panel.DoorsSelectLeft = 1
			self.Panel.DoorsSelectRight = 0
		end
	end

	if button == "DoorsSelectRightToggle" then
		if self.DoorSideUnlocked == "None" then
			self.DoorSideUnlocked = "Right"
		elseif self.DoorSideUnlocked == "Right" then
			self.DoorSideUnlocked = "Right"
		elseif self.DoorSideUnlocked == "Left" then
			self.DoorSideUnlocked = "None"
		end

		if self.Panel.DoorsSelectLeft > 0 and self.Panel.DoorsSelectRight < 1 then
			self.Panel.DoorsSelectLeft = 0
			self.Panel.DoorsSelectRight = 0
		elseif self.Panel.DoorsSelectLeft < 1 and self.Panel.DoorsSelectRight < 1 then
			self.Panel.DoorsSelectLeft = 0
			self.Panel.DoorsSelectRight = 1
		end
	end

	if button == "Button1a" then
		if self.DoorSideUnlocked == "Right" then if dS.DoorRandomnessRight[ 1 ] == 0 then dS.DoorRandomnessRight[ 1 ] = 3 end end
		self.Panel.Button1a = 1
	end

	if button == "Button2a" then
		if self.DoorSideUnlocked == "Right" then dS.DoorRandomnessRight[ 1 ] = 3 end
		self.Panel.Button2a = 1
	end

	if button == "Button3a" then
		if self.DoorSideUnlocked == "Right" then dS.DoorRandomnessRight[ 2 ] = 3 end
		self.Panel.Button3a = 1
	end

	if button == "Button4a" then
		if self.DoorSideUnlocked == "Right" then dS.DoorRandomnessRight[ 2 ] = 3 end
		self.Panel.Button4a = 1
		-- print(dS.DoorRandomnessRight[2])
	end

	if button == "Button8b" then if self.DoorSideUnlocked == "Left" then dS.DoorRandomnessLeft[ 4 ] = 3 end end
	if button == "Button7b" then if self.DoorSideUnlocked == "Left" then dS.DoorRandomnessLeft[ 4 ] = 3 end end
	if button == "Button6b" then if self.DoorSideUnlocked == "Left" then dS.DoorRandomnessLeft[ 3 ] = 3 end end
	if button == "Button5b" then if self.DoorSideUnlocked == "Left" then dS.DoorRandomnessLeft[ 3 ] = 3 end end
	if button == "DoorsUnlockSet" then
		self.DoorsUnlocked = true
		self.DepartureConfirmed = false
		self.Panel.DoorsUnlockSet = 1
	end

	if button == "DoorsLockSet" then
		dS.DoorRandomnessRight[ 1 ] = -1
		dS.DoorRandomnessRight[ 2 ] = -1
		dS.DoorRandomnessRight[ 3 ] = -1
		dS.DoorRandomnessRight[ 4 ] = -1
		self.RandomnessCalculated = false
		self.DoorsUnlocked = false
		self.Door1 = false
		self.CheckDoorsClosed = true
	end

	if button == "DoorsCloseConfirmSet" then
		self.DoorsClosedAlarmAcknowledged = true
		self.DepartureConfirmed = true
		if self.DoorsClosed == true then self.ArmDoorsClosedAlarm = false end
	end

	if button == "SetHoldingBrakeSet" then
		self.CoreSys.ManualRetainerBrake = true
		self.Panel.SetHoldingBrake = 1
	end

	if button == "ReleaseHoldingBrakeSet" then self.Panel.ReleaseHoldingBrake = 1 end
	if button == "ReleaseHoldingBrakeSet" then self.CoreSys.ManualRetainerBrake = false end
	if button == "PassengerLightsToggle" then
		if self:GetNW2Bool( "PassengerLights", false ) == true then
			self:SetNW2Bool( "PassengerLights", false )
		elseif self:GetNW2Bool( "PassengerLights", false ) == false then
			self:SetNW2Bool( "PassengerLights", true )
		end
	end

	if button == "DoorsSelectLeftToggle" then
		if self:GetNWString( "DoorSide", "none" ) == "right" then
			self:SetNWString( "DoorSide", "none" )
			-- PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString( "DoorSide", "none" ) == "none" then
			self:SetNWString( "DoorSide", "left" )
		end
		-- PrintMessage(HUD_PRINTTALK, "Door switch position left")
	end

	if button == "DoorsSelectRightToggle" then
		if self:GetNWString( "DoorSide", "none" ) == "left" then
			self:SetNWString( "DoorSide", "none" )
			-- PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString( "DoorSide", "none" ) == "none" then
			self:SetNWString( "DoorSide", "right" )
		end
		-- PrintMessage(HUD_PRINTTALK, "Door switch position right")
	end

	if button == "PassengerDoor" then
		if self:GetNW2Float( "DriversDoorState", 0 ) == 0 then
			self:SetNW2Float( "DriversDoorState", 1 )
		else
			self:SetNW2Float( "DriversDoorState", 0 )
		end
	end

	if button == "Mirror" then
		if self:GetNW2Float( "Mirror", 0 ) == 0 then
			self:SetNW2Float( "Mirror", 1 )
		else
			self:SetNW2Float( "Mirror", 0 )
		end
	end

	if button == "ComplaintSet" then self:SetNW2Bool( "Microphone", true ) end
	if button == "ComplaintSet" then self:SetNW2Bool( "Microphone", false ) end
	if button == "DestinationSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self:SetNW2Bool( "IBISKeyBeep", true )
			self.IBIS:Trigger( "Destination", RealTime() )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number0Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "0", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "DeleteSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Delete", RealTime() )
			-- self.IBIS:Trigger(nil)
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number1Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "1", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number2Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "2", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number3Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "3", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number4Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "4", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number5Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "5", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number6Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "6", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number7Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "7", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number8Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "8", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number9Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "9", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "EnterSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Enter", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "ServiceAnnouncementSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "ServiceAnnouncements", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "ReduceBrakeSet" then self.Panel.ReduceBrake = 1 end
end

function ENT:OnButtonRelease( button, ply )
	if button == "CycleIBISKey" then
		if self.CoreSys.IBISKeyA == false and self.CoreSys.IBISKeyATurned == false then
			self.CoreSys.IBISKeyA = true
		elseif self.CoreSysIBISKeyA == true and self.CoreSys.IBISKeyATurned == false then
			self.CoreSys.IBISKeyA = true
			self.CoreSys.IBISKeyATurned = true
		elseif self.CoreSysIBISKeyA == true and self.CoreSys.IBISKeyATurned == true then
			self.CoreSys.IBISKeyA = true
			self.CoreSys.IBISKeyATurned = false
		end
	end

	if button == "RemoveIBISKey" then if self.CoreSys.IBISKeyA == true then self.CoreSys.IBISKeyA = false end end
	if button == "ReduceBrakeSet" then self.Panel.ReduceBrake = 0 end
	if button == "PassengerOvergroundSet" then self.Panel.PassengerOverground = 0 end
	if button == "PassengerUndergroundSet" then self.Panel.PassengerUnderground = 0 end
	if button == "ReleaseHoldingBrakeSet" then self.Panel.ReleaseHoldingBrake = 0 end
	if button == "SetHoldingBrakeSet" then self.Panel.SetHoldingBrake = 0 end
	if button == "SetPointLeftSet" then self.Panel.SetPointLeft = 0 end
	if button == "SetPointRightSet" then self.Panel.SetPointRight = 0 end
	if button == "DoorsLockSet" then self.Panel.DoorsLock = 0 end
	if button == "DoorsUnlockSet" then self.Panel.DoorsUnlockSet = 0 end
	if button == "Door1Set" then self.Panel.Door1 = 0 end
	if button == "PantographRaiseSet" then self.Panel.PantographRaise = 0 end
	if button == "ThrowCouplerSet" then self.Panel.ThrowCoupler = 0 end
	if button == "EmergencyBrakeSet" then end
	if ( button == "ThrottleUp" and self.CoreSys.ThrottleRateA > 0 ) or ( button == "ThrottleDown" and self.CoreSys.ThrottleRateA < 0 ) then self.CoreSys.ThrottleRateA = 0 end
	if ( button == "ThrottleUpFast" and self.CoreSys.ThrottleRateA > 0 ) or ( button == "ThrottleDownFast" and self.CoreSys.ThrottleRateA < 0 ) then self.CoreSys.ThrottleRateA = 0 end
	if button == "Rollsign+" then
		self:SetNW2Bool( "Rollsign+", false )
		self.ScrollMoment = CurTime()
	end

	if button == "Rollsign-" then
		self:SetNW2Bool( "Rollsign-", false )
		self.ScrollMoment = CurTime()
	end

	if button == "BatteryToggle" then self:SetPackedBool( "FlickBatterySwitchOn", false ) end
	if button == "BatteryDisableToggle" then self:SetPackedBool( "FlickBatterySwitchOff", false ) end
	if button == "DeadmanSet" then
		self.DeadmanUF.IsPressedA = false
		if self:ReadTrainWire( 6 ) > 0 then self:WriteTrainWire( 12, 0 ) end
		------print("DeadmanPressedNo")
	end

	if button == "WarningAnnouncementSet" then self:SetNW2Bool( "WarningAnnouncement", false ) end
	if button == "BellEngageSet" then self:SetNW2Bool( "Bell", false ) end
	if button == "Horn" then self:SetNW2Bool( "Horn", false ) end
	if button == "BatteryToggle" then self:SetNW2Bool( "IBIS_impulse", false ) end
	if button == "DestinationSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end
	end

	if button == "Number0Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number1Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "DeleteSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number2Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number3Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number4Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number5Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number6Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number7Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number8Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "Number9Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "EnterSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "ServiceAnnouncementSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "OpenBOStrab" then
		net.Start( "manual" )
		net.WriteBool( true )
		net.Send( self:GetDriverPly() )
		-- self:SetPackedBool("BOStrab",false)
	end
end

ENT.CloseMoments = {}
ENT.CloseMomentsCalc = false
-- Are the doors unlocked, sideLeft,sideRight,door1 open, unlocked while reverser on * position
function ENT:RollsignSync()
	print( self.RollsignModifier )
end

util.AddNetworkString( "RollsignState" )
net.Receive( "RollsignState", function()
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent ~= ENT then return end
	ENT.RollsignModifier = net.ReadFloat()
end )

function ENT:Traction()
	if not IsValid( self.FrontBogey ) and not IsValid( self.MiddleBogey ) and not IsValid( self.RearBogey ) then return end
	local resistors = self.Resistorbank:Camshaft()
	resistors = not resistors and 20 or resistors
	local throttle = self.CoreSys.Traction
	local MU = not ( self.CoreSys.ReverserLeverStateA == 3 or self:ReadTrainWire( 6 ) < 1 or self.CoreSys.ReverserLeverStateA == -1 or self.CoreSys.ReverserLeverStateB == 3 ) or self:ReadTrainWire( 6 ) > 0
	local throttleWire = self:ReadTrainWire( 1 )
	local deadmanTripped = self.DeadmanUF.DeadmanTripped or MU and self:ReadTrainWire( 8 )
	local parralel = self.Panel.Parralel > 0
	self.BrakesOn = MU and throttleWire < 0 or throttle < 0
	local reverser = self.CoreSys.ReverserState
	local braking = MU and throttleWire < 0 or throttle < 0 or false
	-- are the motors set to parralel or series?
	throttle = not parralel and throttle / 2 or throttle
	throttleWire = not parralel and throttleWire / 2 or throttleWire
	-- throttle = throttle * 10
	self:SetNW2Bool( "ElectricBrakes", MU and throttleWire < 1 or throttle < 0 )
	if not MU then
		if throttle > 0 and self.Speed < 8 then
			self.FrontBogey.MotorPower = throttle
		elseif throttle < 0 and self.Speed < 8 then
			self.FrontBogey.MotorPower = 0
		else
			self.FrontBogey.MotorPower = throttle
		end

		if throttle < 0 then
			self.FrontBogey.MotorPower = throttle * 100
			self.RearBogey.MotorForce = 69101.56
			self.FrontBogey.MotorForce = self.RearBogey.MotorForce
		else
			self.RearBogey.MotorForce = 127142.8 - ( ( ( resistors / 20 ) * 100 ) * 317.857142857145 ) * math.abs( throttle ) --[[6357.14 x 20]]
			self.FrontBogey.MotorForce = self.RearBogey.MotorForce
		end
	elseif MU then
		if throttleWire > 0 and self.Speed < 8 then
			self.FrontBogey.MotorPower = throttleWire
		elseif throttleWire < 0 and self.Speed < 8 then
			self.FrontBogey.MotorPower = 0
		else
			self.FrontBogey.MotorPower = throttleWire
		end

		if throttleWire > 0 then
			self.RearBogey.MotorForce = 127142.8 - ( ( resistors / 20 ) * 317.857142857145 ) * throttleWire
			self.FrontBogey.MotorForce = self.RearBogey.MotorForce
		elseif throttleWire < 0 then
			self.RearBogey.MotorForce = 69101.56
			self.FrontBogey.MotorForce = self.RearBogey.MotorForce
		end
	elseif deadmanTripped then
		self.RearBogey.MotorForce = 6910.157
		self.FrontBogey.MotorForce = 6910.157
	end

	--print( self.FrontBogey.BrakeCylinderPressure, self.RearBogey.MotorForce, self.RearBogey.MotorPower, throttle, self.CoreSys.ThrottleState, resistors )
	self.RearBogey.MotorPower = self.FrontBogey.MotorPower
	self.FrontBogey.BrakeCylinderPressure = ( MU and throttleWire > 0 or not MU and throttle > 0 or not self.DepartureConfirmed or self.Speed > 8 ) and 0 or 2.7
	self.MiddleBogey.BrakeCylinderPressure = self.FrontBogey.BrakeCylinderPressure
	self.RearBogey.BrakeCylinderPressure = self.FrontBogey.BrakeCylinderPressure
	self.FrontBogey.Reversed = reverser < 0 or ( MU and self:ReadTrainWire( 4 ) > 0 ) or false
	self.RearBogey.Reversed = self.FrontBogey.Reversed
end