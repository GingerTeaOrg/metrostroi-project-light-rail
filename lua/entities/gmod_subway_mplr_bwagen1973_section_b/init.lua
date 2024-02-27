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
	self:SetModel("models/lilly/mplr/ruhrbahn/b_1973/section_b.mdl")
    self.BaseClass.Initialize(self)
    

	self.DriverSeat = self:CreateSeat("driver", Vector(-484, -3, 55),Angle(0,180,0))

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

	self.Blinker = "Off"

		-- Lights sheen
	self.Lights = {
		[50] = {"light", Vector(406, 39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
		[60] = {"light", Vector(406, -39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
		[51] = {"light", Vector(425.464, 40, 28), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight left
		[52] = {"light", Vector(425.464, -40, 28), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight right
		[53] = {"light", Vector(425.464, 0, 111), Angle(0, 0, 0), Color(226, 197, 160), brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt"}, -- headlight top
		[54] = {"light", Vector(425.464, 31.5, 24.55), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light left
		[55] = {"light", Vector(425.464, -31.5, 24.55), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light right
		[56] = {"light", Vector(426, 31.2, 31), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
		[57] = {"light", Vector(426, -31.2, 31), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
		[58] = {"light", Vector(327, 52, 74), Angle(0, 0, 0), Color(255, 100, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator top left
		[59] = {"light", Vector(327, -52, 74), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator top right
		[48] = {"light", Vector(327, 52, 68), Angle(0, 0, 0), Color(255, 100, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator bottom left
		[49] = {"light", Vector(327, -52, 68), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- indicator bottom right
		[30] = {"light", Vector(397, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 1
		[31] = {"light", Vector(326.738, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 2
		[32] = {"light", Vector(151.5, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 3
		[33] = {"light", Vector(83.7, 49, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front left 4
		[34] = {"light", Vector(396.884, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 1
		[35] = {"light", Vector(326.89, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 2
		[36] = {"light", Vector(152.116, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 3
		[37] = {"light", Vector(85, -51, 49.7), Angle(0, 0, 0), Color(9, 142, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- door button front right 4
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
	
	local Panel = self.Panel



end

function ENT:TrainSpawnerUpdate()
	self:UpdateTextures()
end