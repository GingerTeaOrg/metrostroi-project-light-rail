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
    self.BaseClass.Initialize(self)
    self:SetModel("models/lilly/mplr/ruhrbahn/b_1970/section-a.mdl")

	self.DriverSeat = self:CreateSeat("driver", Vector(395, 15, 34))

	self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")

	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0, 0, 0, 0))
	self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))

	self.DoorStatesRight = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
	self.DoorStatesLeft = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false

	self.DoorCloseMoments = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
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
	self.FrontBogey = self:CreateCustomBogey(Vector(290, 0, 0), Angle(0, 180, 0), true, "b_motor","a")
	self.MiddleBogey = self:CreateCustomBogey(Vector(0, 0, 0), Angle(0, 0, 0), false, "b_joint","b")
	self:SetNWEntity("FrontBogey", self.FrontBogey)

	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler(Vector(415, 0, 0), Angle(0, 0, 0), true, "b", "a")
	self.FrontCoupler = self.FrontCouple
	self.SectionB = self:CreateSectionB(Vector(-780, 0, 0))
	self.RearCouple = self:CreateCustomCoupler(Vector(415, 0, 0), Angle(0, 0, 0), true, "b", "a")
	self.RearCoupler = self.RearCouple

	self.Panto = self:CreatePanto(Vector(35, 0, 115), Angle(0, 90, 0), "einholm")

	self.Blinker = "Off"

	self.TrainWireCrossConnections = {
		[3] = 4, -- Reverser F<->B
		[21] = 20, -- blinker
		[13] = 14,
		[31] = 32
	}

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

	self:CoupledUncoupled()
	
	local Panel = self.Panel



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
	self.SectionB:TrainSpawnerUpdate()

	-- self.MiddleBogey:UpdateTextures()
	-- self.MiddleBogey:UpdateTextures()
	-- self:UpdateLampsColors()
	self.FrontCouple.CoupleType = "b"
	self.RearCouple.CoupleType = "b"
	self.FrontCouple:SetParameters()
	self.RearCouple:SetParameters()
end


function ENT:CreatePanto(pos, ang, type)
	local panto = ents.Create("gmod_train_uf_panto")

	panto:SetPos(self:LocalToWorld(pos))
	panto:SetAngles(self:GetAngles() + ang)

	panto.PantoType = type
	panto.NoPhysics = self.NoPhysics or true
	panto:Spawn()

	panto.SpawnPos = pos
	panto.SpawnAng = ang

	panto:SetNW2Entity("TrainEntity", self)
	panto.Train = self
	if self.NoPhysics then
		panto:SetParent(self)
	else
		constraint.Weld(panto, self, 0, 0, 0, true)
	end

	table.insert(self.TrainEntities, panto)
	-- panto:Activate()
	return panto

end

function ENT:CreateCustomCoupler(pos, ang, forward, typ, a_b)
	-- Create bogey entity
	local coupler = ents.Create("gmod_train_uf_couple")
	coupler:SetPos(self:LocalToWorld(pos))
	coupler:SetAngles(self:GetAngles() + ang)
	coupler.CoupleType = "u2"
	coupler:Spawn()

	-- Assign ownership
	if CPPI and IsValid(self:CPPIGetOwner()) then coupler:CPPISetOwner(self:CPPIGetOwner()) end

	-- Some shared general information about the bogey
	coupler:SetNW2Bool("IsForwardCoupler", forward)
	coupler:SetNW2Entity("TrainEntity", self)
	coupler.SpawnPos = pos
	coupler.SpawnAng = ang
	local index = 1
	local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
	for i, v in ipairs(self.JointPositions) do
		if v > pos.x then
			index = i + 1
		else
			break
		end
	end
	table.insert(self.JointPositions, index, x)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(coupler)
	else
		if a_b == "a" then
			constraint.AdvBallsocket(self, coupler, 0, -- bone
			0, -- bone
			pos, Vector(0, 0, 0), 1, -- forcelimit
			1, -- torquelimit
			-2, -- xmin
			-2, -- ymin
			-15, -- zmin
			2, -- xmax
			2, -- ymax
			15, -- zmax
			0.1, -- xfric
			0.1, -- yfric
			1, -- zfric
			0, -- rotonly
			1 -- nocollide
			)
		elseif a_b == "b" then
			constraint.AdvBallsocket(self.SectionB, coupler, 0, -- bone
			0, -- bone
			pos, Vector(0, 0, 0), 1, -- forcelimit
			1, -- torquelimit
			-2, -- xmin
			-2, -- ymin
			-15, -- zmin
			2, -- xmax
			2, -- ymax
			15, -- zmax
			0.1, -- xfric
			0.1, -- yfric
			1, -- zfric
			0, -- rotonly
			1 -- nocollide
			)
		end
	end
	if a_b == "a" then
		constraint.Axis(coupler, self, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, 0, 1, Vector(0, 0, 1), false)
	elseif a_b == "b" then
		constraint.Axis(coupler, self.SectionB, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, 0, 1, Vector(0, 0, 1), false)
	end

	-- Add to cleanup list
	table.insert(self.TrainEntities, coupler)
	return coupler
end