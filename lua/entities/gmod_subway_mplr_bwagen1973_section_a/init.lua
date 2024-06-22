AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 1100

ENT.SyncTable = {
	"IgnitionKey",
	"IgnitionKeyInserted",
	"UncouplingKey",
	"ParrallelMotors",
	"Deadman",
	"DoorsUnlock",
	"DoorsLock",
	"DoorsSelectRight",
	"DoorsSelectLeft",
	"Door1",
	"DoorsForceOpen",
	"DoorsForceClose",
	"MirrorLeft",
	"MirrorRight",
	"SwitchLeft",
	"SwitchRight",
	"Battery",
	"BatteryDisable",
	"PantographOn",
	"PantographOff",
	"Headlights",
	"HazardBlink",
	"DriverLight",
	"BlinkerRight",
	"BlinkerLeft",
	"StepsHigh",
	"StepsLow",
	"StepsLowest",
	"Bell",
	"Horn",
	"WiperConstantSet",
	"WiperIntervalSet",
	"WindowWasherSet",
	"EmergencyBrakeDisable"
}
ENT.InteractionZones = {
	{ID = "DoorButton3L", Pos = Vector(328.8, 51, 74), Radius = 16},
	{ID = "DoorButton4L", Pos = Vector(328.8, 51.3, 58), Radius = 16},
	{ID = "DoorButton5L", Pos = Vector(261, 51, 74), Radius = 16},
	{ID = "DoorButton6L", Pos = Vector(261, 51.3, 58), Radius = 16},
	{ID = "DoorButton7L", Pos = Vector(144.5, 51, 74), Radius = 16},
	{ID = "DoorButton8L", Pos = Vector(144.5, 51.3, 58), Radius = 16},
	{ID = "Button6b", Pos = Vector(152.116, 50, 49.5253), Radius = 16},
	{ID = "Button5b", Pos = Vector(84.6012, 50, 49.5253), Radius = 16}
}
function ENT:Initialize()
	self:SetModel("models/lilly/mplr/ruhrbahn/b_1973/section_a.mdl")
	self.BaseClass.Initialize(self)
	self.DriverSeat = self:CreateSeat("driver", Vector(484, 3, 55), Angle(0, 0, 0))

	-- self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")

	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0, 0, 0, 0))
	-- self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	-- self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))

	self.DoorStatesRight = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
	self.DoorStatesLeft = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false

	self.DoorCloseMoments = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
	self.DoorCloseMomentsCaptured = false

	self.Speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false

	self.Door1 = false

	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector(390, 0, 4), Angle(0, 0, 0), true, "b_motor", "a")
	self.MiddleBogey = self:CreateBogeyUF(Vector(0, 0, 4), Angle(0, 0, 0), false, "b_joint", "a")

	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler(Vector(475, 0, 30), Angle(0, 180, 0), true, "b", "a")
	self.FrontCoupler = self.FrontCouple
	self.SectionB = self:CreateSectionB(Vector(-780, 0, 0), Angle(0, 0, 0), "gmod_subway_mplr_bwagen1973_section_b", self)
	self.RearCouple = self:CreateCustomCoupler(Vector(-475, 0, 30), Angle(0, 0, 0), true, "b", "b")
	self.RearCoupler = self.RearCouple
	self.RearBogey = self:CreateBogeyUF(Vector(-390, 0, 4), Angle(0, 0, 0), true, "b_motor", "b")
	self.Panto = self:CreatePanto(Vector(36.5, 0, 135), Angle(0, 180, 0), "einholm")
	self.PantoUp = false

	self.FrontBogey:SetNWInt("MotorSoundType", 0)
	self.MiddleBogey:SetNWInt("MotorSoundType", 0)
	self.RearBogey:SetNWInt("MotorSoundType", 0)

	self.Blinker = "Off"

	self.TrainWireCrossConnections = {
		[4] = 3, -- Reverser F<->B
		[21] = 20, -- blinker
		[13] = 14,
		[31] = 32
	}

	-- Lights sheen
	self.Lights = {
		[1] = {"light", Vector(530, 30, 43), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight left
		[2] = {"light", Vector(530, -30, 43), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight right
		[3] = {"light", Vector(515, 0, 130), Angle(0, 0, 0), Color(226, 197, 160), brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt"}, -- headlight top
		[4] = {"light", Vector(525, 20.9, 41), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light left
		[5] = {"light", Vector(525, -20.9, 41), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light right
		[6] = {"light", Vector(525, 20.9, 46), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
		[7] = {"light", Vector(525, -20.9, 46), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
		[8] = {"light", Vector(487, 46, 79), Angle(0, 0, 0), Color(255, 100, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator top left
		[9] = {"light", Vector(487, -46, 79), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator top right
		[10] = {"light", Vector(487, 46, 74), Angle(0, 0, 0), Color(255, 100, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator bottom left
		[11] = {"light", Vector(487, -46, 74), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator bottom right
		[12] = {"light", Vector(397, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 1
		[13] = {"light", Vector(326.738, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 2
		[14] = {"light", Vector(151.5, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 3
		[15] = {"light", Vector(83.7, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 4
		[16] = {"light", Vector(396.884, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 1
		[17] = {"light", Vector(326.89, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 2
		[18] = {"light", Vector(152.116, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 3
		[19] = {"light", Vector(85, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 4
		[20] = {"light", Vector(406, 39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
		[21] = {"light", Vector(406, -39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"} -- cab light
	}

	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUp",
		[KEY_D] = "ThrottleDown",
		[KEY_F] = "ReduceBrake",
		[KEY_H] = "BellSet",
		[KEY_SPACE] = "DeadmanSet",
		[KEY_W] = "ReverserUpSet",
		[KEY_S] = "ReverserDownSet",
		[KEY_P] = "PantographOnSet",
		[KEY_O] = "DoorsUnlockToggle",
		[KEY_I] = "DoorsLockSet",
		[KEY_K] = "DoorsCloseConfirmSet",
		[KEY_Z] = "WarningAnnouncementSet",
		[KEY_J] = "DoorsSelectLeftToggle",
		[KEY_L] = "DoorsSelectRightToggle",
		[KEY_B] = "BatterySet",
		[KEY_V] = "HeadlightsToggle",
		[KEY_M] = "Mirror",
		[KEY_1] = "Throttle10Pct",
		[KEY_2] = "Throttle20Pct",
		[KEY_3] = "Throttle30Pct",
		[KEY_4] = "Throttle40Pct",
		[KEY_5] = "Throttle50Pct",
		[KEY_6] = "Throttle60Pct",
		[KEY_7] = "Throttle70Pct",
		[KEY_8] = "Throttle80Pct",
		[KEY_9] = "Throttle90Pct",
		[KEY_0] = "IgnitionKeyOn",
		[KEY_PERIOD] = "BlinkerRightToggle",
		[KEY_COMMA] = "BlinkerLeftToggle",
		[KEY_PAD_MINUS] = "IBISkeyTurnSet",
		[KEY_LSHIFT] = {
			[KEY_0] = "IgnitionKeyToggle",
			[KEY_A] = "ThrottleUpFast",
			[KEY_D] = "ThrottleDownFast",
			[KEY_S] = "ThrottleZero",
			[KEY_H] = "HornSet",
			[KEY_V] = "DriverLightToggle",
			[KEY_COMMA] = "WarnBlinkToggle",
			[KEY_B] = "BatteryDisableSet",
			[KEY_PAGEUP] = "Rollsign+",
			[KEY_PAGEDOWN] = "Rollsign-",
			[KEY_O] = "Door1Set",
			[KEY_1] = "Throttle10-Pct",
			[KEY_2] = "Throttle20-Pct",
			[KEY_3] = "Throttle30-Pct",
			[KEY_4] = "Throttle40-Pct",
			[KEY_5] = "Throttle50-Pct",
			[KEY_6] = "Throttle60-Pct",
			[KEY_7] = "Throttle70-Pct",
			[KEY_8] = "Throttle80-Pct",
			[KEY_9] = "Throttle90-Pct",
			[KEY_P] = "PantographOffSet",
			[KEY_MINUS] = "RemoveIBISKey"
		},
		[KEY_LALT] = {
			[KEY_PAD_1] = "Number1Set",
			[KEY_PAD_2] = "Number2Set",
			[KEY_PAD_3] = "Number3Set",
			[KEY_PAD_4] = "Number4Set",
			[KEY_PAD_5] = "Number5Set",
			[KEY_PAD_6] = "Number6Set",
			[KEY_PAD_7] = "Number7Set",
			[KEY_PAD_8] = "Number8Set",
			[KEY_PAD_9] = "Number9Set",
			[KEY_PAD_0] = "Number0Set",
			[KEY_PAD_ENTER] = "EnterSet",
			[KEY_PAD_DECIMAL] = "DeleteSet",
			[KEY_PAD_DIVIDE] = "DestinationSet",
			[KEY_PAD_MULTIPLY] = "SpecialAnnouncementsSet",
			[KEY_PAD_MINUS] = "TimeAndDateSet",
			[KEY_V] = "PassengerLightsSet",
			[KEY_D] = "EmergencyBrakeSet",
			[KEY_N] = "Parrallel",
			[KEY_0] = "IgnitionKeyOff"
		}
	}

	self.InteractionZones = {
		{ID = "Button1a", Pos = Vector(396.884, -51, 50.5), Radius = 16},
		{ID = "Button2a", Pos = Vector(326.89, -50, 49.5253), Radius = 16},
		{ID = "Button3a", Pos = Vector(152.116, -50, 49.5253), Radius = 16},
		{ID = "Button4a", Pos = Vector(84.6012, -50, 49.5253), Radius = 16},
		{ID = "Button8b", Pos = Vector(396.884, 51, 50.5), Radius = 16},
		{ID = "Button7b", Pos = Vector(326.89, 50, 49.5253), Radius = 16},
		{ID = "Button6b", Pos = Vector(152.116, 50, 49.5253), Radius = 16},
		{ID = "Button5b", Pos = Vector(84.6012, 50, 49.5253), Radius = 16}
	}
end

function ENT:Think(dT)
	self.BaseClass.Think(self)
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
	self.FrontCoupler = self.FrontCouple
	self.RearCoupler = self.RearCouple
	self:Traction()

end

function ENT:ToggleButton(button)

	button2 = string.gsub(button, "Toggle", "")
	print(button2)
	if self.Panel[button2] < 1 then
		self.Panel[button2] = 1
	elseif self.Panel[button2] > 0 then
		self.Panel[button2] = 0
	end

end

function ENT:SetButton(button) self.Panel[button] = 1 end
function ENT:UnsetButton(button) self.Panel[button] = 0 end
function ENT:OnButtonPress(button)

	local toggle = (string.find(button, "Toggle", 1)) ~= nil

	if button and toggle then
		self:ToggleButton(button)
	else
		self:SetButton(button)
	end

	local sys = self.CoreSys
	local panel = self.Panel
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
	if button == "StepsHighSet" then sys:StepsParameters("high") end
	if button == "StepsLowSet" then sys:StepsParameters("low") end
	if button == "StepsLowestSet" then sys:StepsParameters("lowest") end

	if button == "BlinkerLeftToggle" and sys.BlinkerState == sys.BlinkerStates["Off"] then
		sys.BlinkerState = sys.BlinkerStates["Left"]
	elseif button == "BlinkerLeftToggle" and sys.BlinkerState == sys.BlinkerStates["Right"] then
		sys.BlinkerState = sys.BlinkerStates["Off"]
	elseif button == "BlinkerRightToggle" and sys.BlinkerState == sys.BlinkerStates["Off"] then
		sys.BlinkerState = sys.BlinkerStates["Right"]
	elseif button == "BlinkerRightToggle" and sys.BlinkerState == sys.BlinkerStates["Right"] then
		sys.BlinkerState = sys.BlinkerStates["Off"]
	elseif button == "WarnBlinkToggle" then
		sys.BlinkerState = sys.BlinkerStates["Hazard"]
		panel.BlinkerLeft = 0
		panel.BlinkerRight = 0
	end

	if button == "DoorUnblockToggle" then end

	if button == "SwitchLeftToggle" then
		if self.IBIS.Override == "left" then
			self.IBIS:OverrideSwitching(nil)
		else
			self.IBIS.Override = "left"
		end
	end
	if button == "SwitchRightToggle" then
		if self.IBIS.Override == "right" then
			self.IBIS:OverrideSwitching(nil)
		else
			self.IBIS.Override = "right"
		end
	end

end
function ENT:OnButtonRelease(button)
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

	local tex = "Def_B_1973"
	self.MiddleBogey.Texture = self:GetNW2String("Texture")
	self:UpdateTextures()
	self.MiddleBogey:UpdateTextures()
	if IsValid(self.SectionB) then self.SectionB:TrainSpawnerUpdate() end

	-- self.MiddleBogey:UpdateTextures()
	-- self.MiddleBogey:UpdateTextures()
	-- self:UpdateLampsColors()
	self.FrontCouple.CoupleType = "b"
	self.RearCouple.CoupleType = "b"
	self.FrontCouple:SetParameters()
	self.RearCouple:SetParameters()
end

function ENT:Traction()
	if not IsValid(self.FrontBogey) and not IsValid(self.RearBogey) then return end
	local fb = self.FrontBogey
	local mb = self.MiddleBogey
	local rb = self.RearBogey
	local fbV = self.FrontBogey.MotorPower
	local rbV = self.RearBogey.MotorPower
	local fbN = self.FrontBogey.MotorForce
	local rbN = self.RearBogey.MotorForce
	local speed = self.CoreSys.Speed
	local traction = self:ReadTrainWire(1)
	local braking = traction < 1

	local chopper = self.Chopper.ChopperOutput

	self.FrontBogey.MotorForce = traction > 0 and 126688.07175 or -138363.606
	self.RearBogey.MotorForce = traction > 0 and 126688.07175 or -138363.606

	self.FrontBogey.MotorPower = (speed > 8 or not braking) and math.abs(chopper) or 0
	self.FrontBogey.MotorPower = (speed > 8 or not braking) and math.abs(chopper) or 0

	rb.Reversed = self:ReadTrainWire(3) > 0 and true or self:ReadTrainWire(4) > 0 and false
	fb.Reversed = self:ReadTrainWire(3) > 0 and true or self:ReadTrainWire(4) > 0 and false

	fb.BrakeCylinderPressure = (speed < 8 and braking) and 5 or 0
	mb.BrakeCylinderPressure = (speed < 8 and braking) and 5 or 0
	rb.BrakeCylinderPressure = (speed < 8 and braking) and 5 or 0
	-- print(chopper)
end
