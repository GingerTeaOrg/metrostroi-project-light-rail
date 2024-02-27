AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 1100

ENT.SyncTable = {
	"ReduceBrake",
	"Highbeam",
	"SetHoldingBrake",
	"DoorsLock",
	"DoorsUnlock",
	"PantographRaise",
	"PantographLower",
	"Headlights",
	"WarnBlink",
	"Microphone",
	"BellEngage",
	"Horn",
	"WarningAnnouncement",
	"PantoUp",
	"DoorsCloseConfirm",
	"ReleaseHoldingBrake",
	"PassengerOverground",
	"PassengerUnderground",
	"SetPointRight",
	"SetPointLeft",
	"ThrowCoupler",
	"Door1",
	"UnlockDoors",
	"DoorCloseSignal",
	"Number1",
	"Number2",
	"Number3",
	"Number4",
	"Number6",
	"Number7",
	"Number8",
	"Number9",
	"Number0",
	"Destination",
	"Delete",
	"Route",
	"DateAndTime",
	"SpecialAnnouncements"
}

function ENT:Initialize()
	self:SetModel("models/lilly/mplr/ruhrbahn/b_1973/section_a.mdl")
	self.BaseClass.Initialize(self)
	self.DriverSeat = self:CreateSeat("driver", Vector(484, 3, 55),Angle(0,0,0))
	
	--self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
	
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0, 0, 0, 0))
	--self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	--self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))
	
	self.DoorStatesRight = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
	self.DoorStatesLeft =  {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false
	
	self.DoorCloseMoments = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
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
	
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector(380, 0, 15), Angle(0, 0, 0), true, "b_motor","a")
	self.MiddleBogey = self:CreateBogeyUF(Vector(0, 0, 15), Angle(0, 0, 0), false, "b_joint","a")
	
	
	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler(Vector(475, 0, 30), Angle(0, 180, 0), true, "b", "a")
	self.FrontCoupler = self.FrontCouple
	self.SectionB = self:CreateSectionB(Vector(-780, 0, 0),Angle(0,0,0),"gmod_subway_mplr_bwagen1973_section_b")
	self.RearCouple = self:CreateCustomCoupler(Vector(-475, 0, 30), Angle(0, 0, 0), true, "b", "b")
	self.RearCoupler = self.RearCouple
	self.RearBogey = self:CreateBogeyUF(Vector(-380, 0, 15), Angle(0, 0, 0), true, "b_motor","b")
	self.Panto = self:CreatePanto(Vector(36.5, 0, 135), Angle(0, 180, 0), "einholm")
	self.PantoUp = false

	self.FrontBogey:SetNWInt("MotorSoundType", 0)
	self.MiddleBogey:SetNWInt("MotorSoundType", 0)
	self.RearBogey:SetNWInt("MotorSoundType", 0)
	
	
	self.Blinker = "Off"
	
	self.TrainWireCrossConnections = {
		[3] = 4, -- Reverser F<->B
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
		[21] = {"light", Vector(406, -39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
	}
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUp",
		[KEY_D] = "ThrottleDown",
		[KEY_F] = "ReduceBrake",
		[KEY_H] = "BellEngageSet",
		[KEY_SPACE] = "DeadmanSet",
		[KEY_W] = "ReverserUpSet",
		[KEY_S] = "ReverserDownSet",
		[KEY_P] = "PantographRaiseSet",
		[KEY_O] = "DoorsUnlockSet",
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
		[KEY_PERIOD] = "BlinkerRightSet",
		[KEY_COMMA] = "BlinkerLeftSet",
		[KEY_PAD_MINUS] = "IBISkeyTurnSet",
		[KEY_LSHIFT] = {
			[KEY_0] = "IgnitionKeyToggle",
			[KEY_A] = "ThrottleUpFast",
			[KEY_D] = "ThrottleDownFast",
			[KEY_S] = "ThrottleZero",
			[KEY_H] = "Horn",
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
			[KEY_P] = "PantographLowerSet",
			[KEY_MINUS] = "RemoveIBISKey",
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
			[KEY_0] = "IgnitionKeyOff",
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
	
	
	self.CircuitOn = 0
end

function ENT:Think(dT)
	self.BaseClass.Think(self)
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
	self.FrontCoupler = self.FrontCouple
	self.RearCoupler = self.RearCouple
	self:CoupledUncoupled()
	local Panel = self.Panel
	local sys = self.CoreSys
	
	
	
end

function ENT:OnButtonPress(button)
	if button == "IgnitionKeyOn" then
		self.CoreSys:IgnitionKeyOnA()
	end
	if button == "IgnitionKeyOff" then
		self.CoreSys:IgnitionKeyOffA()
	end
	if button == "ReverserUpSet" then
		self.CoreSys:ReverserUpA()
	end
	if button == "ReverserDownSet" then
		self.CoreSys:ReverserDownA()
	end
	if self.CoreSys.ThrottleRateA == 0 and self.CoreSys.ReverserA ~= 1 then
		if button == "ThrottleUp" then self.CoreSys.ThrottleRateA = 3 end
		if button == "ThrottleDown" then self.CoreSys.ThrottleRateA = -3 end
		if button == "ThrottleUpFast" then self.CoreSys.ThrottleRateA = 8 end
		if button == "ThrottleDownFast" then self.CoreSys.ThrottleRateA = -8 end
	end

	if button == "ThrottleZero" then
		self.CoreSys.ThrottleRateA = 0
		self.CoreSys.ThrottleStateA = 0
	end

	if button == "BatterySet" then
		self.CoreSys:BatteryOn()
	end
	if button == "BatteryDisableSet" then
		self.CoreSys:BatteryOff()
	end
	if button == "PantographRaiseSet" then
		self.PantoUp = true
		self:SetNW2Bool("PantoUp",true)
		print("bap")
	end
	if button == "PantographLowerSet" then
		self.PantoUp = false
		self:SetNW2Bool("PantoUp",false)
	end
end
function ENT:OnButtonRelease(button)
	if button == "ThrottleUp" or button == "ThrottleDown" or button == "ThrottleUpFast" or button == "ThrottleDownFast" then
		self.CoreSys.ThrottleRateA = 0
	end
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