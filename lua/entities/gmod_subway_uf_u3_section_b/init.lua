AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.SyncTable = { "ReduceBrake", "Highbeam", "SetHoldingBrake", "DoorsLock", "DoorsUnlock", "PantographRaise", "PantographLower", "Headlights", "WarnBlink", "Microphone", "BellEngage", "Horn", "WarningAnnouncement", "PantoUp", "DoorsCloseConfirm", "ReleaseHoldingBrake", "PassengerOverground", "PassengerUnderground", "SetPointRight", "SetPointLeft", "ThrowCoupler", "Door1", "UnlockDoors", "DoorCloseSignal", "Number1", "Number2", "Number3", "Number4", "Number6", "Number7", "Number8", "Number9", "Number0", "Destination", "Delete", "Route", "DateAndTime", "SpecialAnnouncements" }
function ENT:Initialize()
	-- Set model and initialize
	self:SetModel( "models/lilly/uf/u3/u3_b.mdl" )
	self.BaseClass.Initialize( self )
	self:SetPos( self:GetPos() + Vector( 0, 0, 0 ) )
	self.CabEnabled = false
	self.BatteryOn = false
	self.BlinkerLeft = false
	self.BlinkerRight = false
	self.BlinkerHazard = false
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserEngaged = 0
	self.DriverSeat = self:CreateSeat( "driver", Vector( -395, -15, 34 ), Angle( 0, 180, 0 ) )
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
		--[KEY_0] = "KeyTurnOn",
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
		},
	}

	undo.Create( self.ClassName )
	undo.AddEntity( self )
	undo.SetPlayer( self.Owner )
	undo.SetCustomUndoText( "Undone a train" )
	undo.Finish()
	--self.Wheels = self.FrontBogey.Wheels
	self.Lights = {
		[ 61 ] = {
			"light", --headlight 1
			Vector( -426.5, 50, 42 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 62 ] = {
			"light", --headlight 2
			Vector( -426.5, -50, 42 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 1.5,
			texture = "sprites/light_glow02.vmt"
		},
		[ 63 ] = {
			"light", --headlight 3
			Vector( -426.5, 0, 149 ),
			Angle( 0, 0, 0 ),
			Color( 226, 197, 160 ),
			brightness = 0.9,
			scale = 0.45,
			texture = "sprites/light_glow02.vmt"
		},
		[ 64 ] = {
			"light", --tail light left
			Vector( -425.44, -30.9657, 25.6195 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 65 ] = {
			"light", --tail light right
			Vector( -425.44, 30.9657, 25.6195 ),
			Angle( 0, 0, 0 ),
			Color( 255, 0, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 66 ] = {
			"light", --brake light left
			Vector( -480.32, -30.9657, 41.43 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 67 ] = {
			"light", --brake light right
			Vector( -480.32, 30.9657, 41.43 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 158 ] = {
			"light", --indicator top left
			Vector( -327, 52, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 159 ] = {
			"light", --indicator top right
			Vector( -327, -52, 74 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 148 ] = {
			"light", --indicator bottom left
			Vector( -327, 52, 68 ),
			Angle( 0, 0, 0 ),
			Color( 255, 100, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 149 ] = {
			"light", --indicator bottom right
			Vector( -327, -52, 68 ),
			Angle( 0, 0, 0 ),
			Color( 255, 102, 0 ),
			brightness = 0.9,
			scale = 0.1,
			texture = "sprites/light_glow02.vmt"
		},
		[ 30 ] = {
			"light", --door button front left 1
			Vector( -397.343, 51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 31 ] = {
			"light", --door button front left 2
			Vector( -326.738, 51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 32 ] = {
			"light", --door button front left 3
			Vector( -151.5, 51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 33 ] = {
			"light", --door button front left 4
			Vector( -83.7, 51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 34 ] = {
			"light", --door button front right 1
			Vector( -396.884, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 35 ] = {
			"light", --door button front right 2
			Vector( -326.89, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 36 ] = {
			"light", --door button front right 3
			Vector( -152.116, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 37 ] = {
			"light", --door button front right 4
			Vector( -84.6012, -51, 49.7 ),
			Angle( 0, 0, 0 ),
			Color( 9, 142, 0 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
		[ 38 ] = {
			"light", --indicator indication lamp in cab
			Vector( -416.20, 6, 54 ),
			Angle( 0, 0, 0 ),
			Color( 0, 90, 59 ),
			brightness = 1,
			scale = 0.025,
			texture = "sprites/light_glow02.vmt"
		},
	}

	self.BrakePressure = 0
	self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
	--[[self.TrainWireCrossConnections = {
        --[4] = 3, -- Reverser F<->B
		--[21] = 20, --Blinkers
	}]]
	self:SetNW2String( "Texture", self.ParentTrain:GetNW2String( "Texture" ) .. "_b" )
	self:TrainSpawnerUpdate()
	self.InteractionZones = {
		{
			ID = "Button1b",
			Pos = Vector( 396.884, 51, 50.5 ),
			Radius = 16,
		},
		{
			ID = "Button2b",
			Pos = Vector( 326.89, 50, 49.5253 ),
			Radius = 16,
		},
		{
			ID = "Button3b",
			Pos = Vector( 152.116, 50, 49.5253 ),
			Radius = 16,
		},
		{
			ID = "Button4b",
			Pos = Vector( 84.6012, 50, 49.5253 ),
			Radius = 16,
		},
		{
			ID = "Button5a",
			Pos = Vector( -84.712746, -50.660839, 49.731411 ),
			Radius = 16,
		},
		{
			ID = "Button6a",
			Pos = Vector( -152.081543, -50.660969, 49.797302 ),
			Radius = 16,
		},
		{
			ID = "Button7a",
			Pos = Vector( -326.835022, -50.661758, 49.759453 ),
			Radius = 16,
		},
		{
			ID = "Button8a",
			Pos = Vector( -396.827484, -48.789711, 49.787682 ),
			Radius = 16,
		},
	}
end

function ENT:OnButtonPress( button, ply )
	if button == "IBISkeyInsertSet" then
		if self:GetNW2Bool( "InsertIBISKey", false ) == false then
			self:SetNW2Bool( "InsertIBISKey", true )
		else
			self:SetNW2Bool( "InsertIBISKey", false )
		end
	end

	if button == "IBISkeyTurnSet" then
		if self:GetNW2Bool( "InsertIBISKey", false ) == true then
			if self:GetNW2Bool( "TurnIBISKey", false ) == false then
				self:SetNW2Bool( "TurnIBISKey", true )
			else
				self:SetNW2Bool( "TurnIBISKey", false )
			end
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
	if self.ParentTrain.Duewag_U3.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.ParentTrain.Duewag_U3.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.ParentTrain.Duewag_U3.ThrottleRate = -3 end
	end

	if self.ParentTrain.Duewag_U3.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.ParentTrain.Duewag_U3.ThrottleRate = 10 end
		if button == "ThrottleDownFast" then self.ParentTrain.Duewag_U3.ThrottleRate = -10 end
	end

	if self.ParentTrain.Duewag_U3.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then self.ParentTrain.Duewag_U3.ThrottleRate = 20 end
		if button == "ThrottleDownReallyFast" then self.ParentTrain.Duewag_U3.ThrottleRate = -20 end
	end

	if button == "Door1Set" then
		self.Door1 = true
		self.Panel.Door1 = 1
	end

	if self.ParentTrain.Duewag_U3.ThrottleRate == 0 then
		if button == "ThrottleZero" then self.ParentTrain.Duewag_U3.ThrottleState = 0 end
		if self:GetNW2Bool( "EmergencyBrake", false ) == true then self:SetNW2Bool( "EmergencyBrake", false ) end
	end

	if button == "Throttle10Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 10 end
	if button == "Throttle20Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 20 end
	if button == "Throttle30Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 30 end
	if button == "Throttle40Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 40 end
	if button == "Throttle50Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 50 end
	if button == "Throttle60Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 60 end
	if button == "Throttle70Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 70 end
	if button == "Throttle80Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 80 end
	if button == "Throttle90Pct" then self.ParentTrain.Duewag_U3.ThrottleState = 90 end
	if button == "Throttle10-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -10 end
	if button == "Throttle20-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -20 end
	if button == "Throttle30-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -30 end
	if button == "Throttle40-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -40 end
	if button == "Throttle50-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -50 end
	if button == "Throttle60-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -60 end
	if button == "Throttle70-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -70 end
	if button == "Throttle80-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -80 end
	if button == "Throttle90-Pct" then self.ParentTrain.Duewag_U3.ThrottleState = -90 end
	if button == "PantographRaiseSet" then
		self.Panel.PantographRaise = 1
		if self.ParentTrain.Duewag_U3.BatteryOn == true then self.PantoUp = true end
	end

	if button == "PantographLowerSet" then if self.ParentTrain.Duewag_U3.BatteryOn == true then self.PantoUp = false end end
	if button == "EmergencyBrakeSet" and self:GetNW2Bool( "EmergencyBrake", false ) == false then
		self:SetNW2Bool( "EmergencyBrake", true )
	elseif button == "EmergencyBrakeSet" and self:GetNW2Bool( "EmergencyBrake", false ) == true then
		self:SetNW2Bool( "EmergencyBrake", false )
	end

	if button == "Rollsign+" then
		self:SetNW2Bool( "Rollsign+", true )
		self.ScrollMoment = CurTime()
	end

	if button == "Rollsign-" then
		self:SetNW2Bool( "Rollsign-", true )
		self.ScrollMoment = CurTime()
	end

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
		--self:Wait(1)
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
		if not self.ParentTrain.Duewag_U3.ThrottleEngaged then
			if self.ParentTrain.Duewag_U3.ReverserInsertedB == true then
				self.ParentTrain.Duewag_U3.ReverserLeverStateB = self.ParentTrain.Duewag_U3.ReverserLeverStateB + 1
				self.ParentTrain.Duewag_U3.ReverserLeverStateB = math.Clamp( self.ParentTrain.Duewag_U3.ReverserLeverStateB, -1, 3 )
				--self.ParentTrain.Duewag_U3:TriggerInput("ReverserLeverState",self.ReverserLeverState)
				PrintMessage( HUD_PRINTTALK, self.ParentTrain.Duewag_U3.ReverserLeverStateB )
			end
		end
	end

	if button == "ReverserDownSet" then
		if not self.ParentTrain.Duewag_U3.ThrottleEngaged and self.ParentTrain.Duewag_U3.ReverserInsertedB == true then
			--self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp( self.ParentTrain.Duewag_U3.ReverserLeverStateB, -1, 3 )
			--self.ParentTrain.Duewag_U3:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			self.ParentTrain.Duewag_U3.ReverserLeverStateB = self.ParentTrain.Duewag_U3.ReverserLeverStateB - 1
			self.ParentTrain.Duewag_U3.ReverserLeverStateB = math.Clamp( self.ParentTrain.Duewag_U3.ReverserLeverStateB, -1, 3 )
			PrintMessage( HUD_PRINTTALK, self.ParentTrain.Duewag_U3.ReverserLeverStateB )
		end
	end

	if self.ParentTrain.Duewag_U3.ReverserLeverStateB == 0 then
		if button == "ReverserInsert" then
			if self.ParentTrain.Duewag_U3.ReverserInsertedB == false then
				self.ParentTrain.Duewag_U3.ReverserInsertedB = true
			elseif self.ParentTrain.Duewag_U3.ReverserInsertedB and not self.ParentTrain.Duewag_U3.ReverserInsertedA then
				self.ParentTrain.Duewag_U3.ReverserInsertedA = false
				self.ParentTrain.Duewag_U3.ReverserInsertedB = true
			elseif not self.ParentTrain.Duewag_U3.ReverserInsertedB and self.ParentTrain.Duewag_U3.ReverserInsertedA then
				self.ParentTrain.Duewag_U3.ReverserInsertedB = false
			end
		end
	end

	if button == "BatteryToggle" then
		self:SetPackedBool( "FlickBatterySwitchOn", true )
		if self.BatteryOn == false and self.ParentTrain.Duewag_U3.ReverserLeverStateB == 1 then
			self.BatteryOn = true
			self.ParentTrain.Duewag_Battery:TriggerInput( "Charge", 1.3 )
			self.ParentTrain:SetNW2Bool( "BatteryOn", true )
			--PrintMessage(HUD_PRINTTALK, "Battery switch is ON")
		end
	end

	if button == "BatteryDisableToggle" then
		if self.BatteryOn == true and self.ParentTrain.Duewag_U3.ReverserLeverStateB == 1 then
			self.BatteryOn = false
			self.ParentTrain.Duewag_Battery:TriggerInput( "Charge", 0 )
			self.ParentTrain:SetNW2Bool( "BatteryOn", false )
			--PrintMessage(HUD_PRINTTALK, "Battery switch is off")
			--self:SetNW2Bool("BatteryToggleIsTouched",true)
		end

		self:SetPackedBool( "FlickBatterySwitchOff", true )
	end

	if button == "DeadmanSet" then
		self.ParentTrain.DeadmanUF.IsPressedB = true
		if self.ParentTrain:ReadTrainWire( 6 ) > 0 then self.ParentTrain:WriteTrainWire( 12, 1 ) end
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
		if self:ReadTrainWire( 5 ) > 1 and self.ParentTrain.Duewag_U3.Speed < 2 then self.FrontCouple:Decouple() end
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
		----print(self.ParentTrain.Duewag_U3.HeadlightsSwitch)
	end

	if button == "DoorsSelectLeftToggle" then
		if self.DoorSideUnlocked == "None" then
			self.DoorSideUnlocked = "Left"
		elseif self.DoorSideUnlocked == "Right" then
			self.DoorSideUnlocked = "None"
		elseif self.DoorSideUnlocked == "Left" then
			self.DoorSideUnlocked = self.DoorSideUnlocked
		end

		if self.Panel.DoorsLeft < 1 and self.Panel.DoorsRight > 0 then
			self.Panel.DoorsLeft = 0
			self.Panel.DoorsRight = 0
		elseif self.Panel.DoorsLeft < 1 and self.Panel.DoorsRight < 1 then
			self.Panel.DoorsLeft = 1
			self.Panel.DoorsRight = 0
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

		if self.Panel.DoorsLeft > 0 and self.Panel.DoorsRight < 1 then
			self.Panel.DoorsLeft = 0
			self.Panel.DoorsRight = 0
		elseif self.Panel.DoorsLeft < 1 and self.Panel.DoorsRight < 1 then
			self.Panel.DoorsLeft = 0
			self.Panel.DoorsRight = 1
		end
	end

	if button == "Button5a" then
		if self.ParentTrain.DoorSideUnlocked == "Right" then if self.ParentTrain.DoorRandomness[ 3 ] == 0 then self.ParentTrain.DoorRandomness[ 3 ] = 3 end end
		self.Panel.Button1a = 1
	end

	if button == "Button6a" then
		if self.ParentTrain.DoorSideUnlocked == "Right" then if self.ParentTrain.DoorRandomness[ 3 ] == 0 then self.ParentTrain.DoorRandomness[ 3 ] = 3 end end
		self.Panel.Button2a = 1
	end

	if button == "Button7a" then
		if self.ParentTrain.DoorSideUnlocked == "Right" then if self.ParentTrain.DoorRandomness[ 4 ] == 0 then self.ParentTrain.DoorRandomness[ 4 ] = 3 end end
		self.Panel.Button3a = 1
	end

	if button == "Button8a" then
		if self.ParentTrain.DoorSideUnlocked == "Right" then if self.ParentTrain.DoorRandomness[ 4 ] == 0 then self.ParentTrain.DoorRandomness[ 4 ] = 3 end end
		self.Panel.Button4a = 1
		--print(self.DoorRandomness[2])
	end

	if button == "Button8b" then if self.ParentTrain.DoorSideUnlocked == "Left" then self.DoorRandomness[ 4 ] = 3 end end
	if button == "Button7b" then if self.ParentTrain.DoorSideUnlocked == "Left" then self.ParentTrain.DoorRandomness[ 4 ] = 3 end end
	if button == "Button6b" then if self.ParentTrain.DoorSideUnlocked == "Left" then self.ParentTrain.DoorRandomness[ 3 ] = 3 end end
	if button == "Button5b" then if self.ParentTrain.DoorSideUnlocked == "Left" then self.ParentTrain.DoorRandomness[ 3 ] = 3 end end
	if button == "DoorsUnlockSet" then
		self.ParentTrain.DoorsUnlocked = true
		self.ParentTrain.DepartureConfirmed = false
		self.Panel.DoorsUnlockSet = 1
	end

	if button == "DoorsLockSet" then
		self.ParentTrain.DoorRandomness[ 1 ] = -1
		self.ParentTrain.DoorRandomness[ 2 ] = -1
		self.ParentTrain.DoorRandomness[ 3 ] = -1
		self.ParentTrain.DoorRandomness[ 4 ] = -1
		self.ParentTrain.DoorsPreviouslyUnlocked = true
		self.ParentTrain.RandomnessCalculated = false
		self.ParentTrain.DoorsUnlocked = false
		self.ParentTrain.Door1 = false
		self.Panel.DoorsLock = 1
	end

	if button == "DoorsCloseConfirmSet" then
		self.ParentTrain.DoorsPreviouslyUnlocked = false
		self.ParentTrain.DepartureConfirmed = true
	end

	if button == "SetHoldingBrakeSet" then
		self.ParentTrain.Duewag_U3.ManualRetainerBrake = true
		self.Panel.SetHoldingBrake = 1
	end

	if button == "ReleaseHoldingBrakeSet" then self.Panel.ReleaseHoldingBrake = 1 end
	if button == "ReleaseHoldingBrakeSet" then self.ParentTrain.Duewag_U3.ManualRetainerBrake = false end
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
			--PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString( "DoorSide", "none" ) == "none" then
			self:SetNWString( "DoorSide", "left" )
			--PrintMessage(HUD_PRINTTALK, "Door switch position left")
		end
	end

	if button == "DoorsSelectRightToggle" then
		if self:GetNWString( "DoorSide", "none" ) == "left" then
			self:SetNWString( "DoorSide", "none" )
			--PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString( "DoorSide", "none" ) == "none" then
			self:SetNWString( "DoorSide", "right" )
			--PrintMessage(HUD_PRINTTALK, "Door switch position right")
		end
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
			self.IBIS:Trigger( "Number0", RealTime() )
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
			--self.IBIS:Trigger(nil)
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number1Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number1", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number2Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number2", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number3Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number3", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number4Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number4", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number5Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number5", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number6Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number6", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number7Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number7", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number8Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number8", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "Number9Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "Number9", RealTime() )
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

	if button == "SpecialAnnouncementSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger( "SpecialAnnouncement", RealTime() )
			self:SetNW2Bool( "IBISKeyBeep", true )
		else
			self.IBIS:Trigger( nil )
			self:SetNW2Bool( "IBISKeyBeep", false )
		end
	end

	if button == "ReduceBrakeSet" then self.Panel.ReduceBrake = 1 end
end

function ENT:OnButtonRelease( button, ply )
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
	if ( button == "ThrottleUp" and self.ParentTrain.Duewag_U3.ThrottleRate > 0 ) or ( button == "ThrottleDown" and self.ParentTrain.Duewag_U3.ThrottleRate < 0 ) then self.ParentTrain.Duewag_U3.ThrottleRate = 0 end
	if ( button == "ThrottleUpFast" and self.ParentTrain.Duewag_U3.ThrottleRate > 0 ) or ( button == "ThrottleDownFast" and self.ParentTrain.Duewag_U3.ThrottleRate < 0 ) then self.ParentTrain.Duewag_U3.ThrottleRate = 0 end
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
		self.ParentTrain.DeadmanUF.IsPressedB = false
		if self.ParentTrain:ReadTrainWire( 6 ) > 0 then self.ParentTrain:WriteTrainWire( 12, 0 ) end
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

	if button == "SpecialAnnouncementSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger( nil )
		end

		self:SetNW2Bool( "IBISKeyBeep", true )
		self:SetNW2Bool( "IBISKeyBeep", false )
	end

	if button == "OpenBOStrab" then
		self:SetPackedBool( "BOStrab", true )
		--self:SetPackedBool("BOStrab",false)
	end
end

function ENT:TrainSpawnerUpdate()
	--local num = self.WagonNumber
	--math.randomseed(num+400)
	--self.RearCouple:SetParameters()
	--local tex = "Def_U2"
	--self:UpdateTextures()
	--self:UpdateLampsColors()
	--self.RearCouple.CoupleType = "U2"
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture"))
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture").."_b")
	self:SetNW2String( "Texture", self.ParentTrain:GetNW2String( "Texture" ) .. "_b" )
	self:UpdateTextures()
end

function ENT:Think()
	self.BaseClass.Think( self )
	self.Speed = math.abs( -self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858 )
end