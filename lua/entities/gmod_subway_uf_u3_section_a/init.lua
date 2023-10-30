AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

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

function ENT:CreateBogeyUF(pos, ang, forward, typ, a_b)
	-- Create bogey entity
	local bogey = ents.Create("gmod_train_uf_bogey")
	bogey:SetPos(self:LocalToWorld(pos))
	bogey:SetAngles(self:GetAngles() + ang)
	bogey.BogeyType = typ
	bogey.NoPhysics = self.NoPhysics
	bogey:Spawn()

	-- Assign ownership
	if CPPI and IsValid(self:CPPIGetOwner()) then bogey:CPPISetOwner(self:CPPIGetOwner()) end

	-- Some shared general information about the bogey
	self.SquealSound = self.SquealSound or math.floor(4 * math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound", self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index = 1
	for i, v in ipairs(self.JointPositions) do
		if v > pos.x then
			index = i + 1
		else
			break
		end
	end
	table.insert(self.JointPositions, index, pos.x + 53.6)
	table.insert(self.JointPositions, index + 1, pos.x - 53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
        if a_b == "a" then
		    constraint.Axis(bogey, self, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, 0, 1, Vector(0, 0, 1), false)
			constraint.NoCollide(bogey,self)
			constraint.NoCollide(bogey,self.SectionB)
        elseif a_b == "b" then
            constraint.Axis(bogey, self.SectionB, 0, 0, Vector(0, 0, 0), Vector(0, 0, 0), 0, 0, 0, 1, Vector(0, 0, 1), false)
			constraint.NoCollide(bogey,self)
			constraint.NoCollide(bogey,self.SectionB)
        end
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities, bogey)
	return bogey
end

function ENT:Initialize()
	
	self:SetModel("models/lilly/uf/u3/u3_a.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0, 0, 10)) -- set to 200 if one unit spawns in ground
    

    -- Create seat entities
	self.DriverSeat = self:CreateSeat("driver", Vector(450, 24, 48))
	self.InstructorsSeat = self:CreateSeat("instructor", Vector(395, -20, 10), Angle(0, 90, 0), "models/vehicles/prisoner_pod_inner.mdl")
	-- self.HelperSeat = self:CreateSeat("instructor",Vector(505,-25,55))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0, 0, 0, 0))
	self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.InstructorsSeat:SetColor(Color(0, 0, 0, 0))

    self.DoorStatesRight = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
	self.DoorStatesLeft = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
	self.DoorsUnlocked = false
	self.DoorsPreviouslyUnlocked = false
	self.RandomnessCalulated = false
	self.DepartureConfirmed = true

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
	self.FrontBogey = self:CreateBogeyUF(Vector(345, 0, 8), Angle(0, 180, 0), true, "duewag_motor", "a")
	self.MiddleBogey = self:CreateBogeyUF(Vector(0, 0, 11.6), Angle(0, 0, 0), false, "u3joint", "a")
	self:SetNWEntity("FrontBogey", self.FrontBogey)

	-- Create couples
	self.FrontCouple = self:CreateCustomCoupler(Vector(465, 0, 12), Angle(0, 0, 0), true, "u2", "a")

	self.BrakesOn = false
	self.ElectricOnMoment = 0
	self.ElectricKickStart = false
	self.ElectricStarted = false

	-- Create U3 Section B
	self.SectionB = self:CreateSectionB(Vector(-780, 0, -12))
	self.RearBogey = self:CreateBogeyUF(Vector(-345, 0, 8), Angle(0, 180, 0), false, "duewag_motor", "b")

	self.RearCouple = self:CreateCustomCoupler(Vector(-465, 0, 12), Angle(0, 180, 0), false, "u2", "b")
	self.Panto = self:CreatePanto(Vector(35, 0, 128), Angle(0, 90, 0), "diamond")
	self.PantoUp = false

	self.ReverserInsert = false
	self.BatteryOn = false

	self.FrontBogey:SetNWInt("MotorSoundType", 1)
	self.MiddleBogey:SetNWInt("MotorSoundType", 1)
	self.RearBogey:SetNWInt("MotorSoundType", 1)
	self.FrontBogey:SetNWBool("Async", false)
	self.MiddleBogey:SetNWBool("Async", false)
	self.RearBogey:SetNWBool("Async", false)
	self:SetNW2Float("Blinds", 0.2)
	self.BlinkerOn = false
	self.BlinkerLeft = false
	self.BlinkerRight = false
	self.Blinker = "Off"
	self.LastTriggerTime = 0
	self:SetNW2String("BlinkerDirection", "none")
	self.DoorRandomness = {[1] = -1, [2] = -1, [3] = -1, [4] = -1}
	-- self.Lights = {}
	self.DoorSideUnlocked = "None"

    self.RollsignModifier = 0
	self.RollsignModifierRate = 0
	self.ScrollMoment = 0
	self.ScrollMomentDelta = 0
	self.ScrollMomentRecorded = false
	self.IBISKeyPassed = false
	self.IBISUnlocked = false
	self.IBISKeyInserted = false
	self.ScrollModifier = 0

	self.TrainWireCrossConnections = {
		[3] = 4, -- Reverser F<->B
		[21] = 20, -- blinker
		[13] = 14,
		[31] = 32
	}

	self.DoorOpenMoments = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
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
		[KEY_B] = "BatteryToggle",
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
		[KEY_PERIOD] = "BlinkerRightSet",

		[KEY_COMMA] = "BlinkerLeftSet",
		[KEY_PAD_MINUS] = "IBISkeyTurnSet",

		[KEY_LSHIFT] = {
			[KEY_0] = "ReverserInsert",
			[KEY_A] = "ThrottleUpFast",
			[KEY_D] = "ThrottleDownFast",
			[KEY_S] = "ThrottleZero",
			[KEY_H] = "Horn",
			[KEY_V] = "DriverLightToggle",
			[KEY_COMMA] = "WarnBlinkToggle",
			[KEY_B] = "BatteryDisableToggle",
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
			[KEY_PAD_MINUS] = "IBISkeyInsertSet"
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
			[KEY_N] = "Parrallel"

		}
	}

    self.Lights = {
		[50] = {"light", Vector(406, 39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
		[60] = {"light", Vector(406, -39, 98), Angle(90, 0, 0), Color(227, 197, 160), brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt"}, -- cab light
		[51] = {"light", Vector(425.464, 40, 28), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight left
		[52] = {"light", Vector(425.464, -40, 28), Angle(0, 0, 0), Color(216, 161, 92), brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt"}, -- headlight right
		[53] = {"light", Vector(425.464, 0, 111), Angle(0, 0, 0), Color(226, 197, 160), brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt"}, -- headlight top
		[54] = {"light", Vector(425.464, 31.5, 24.55), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light left
		[55] = {"light", Vector(425.464, -31.5, 24.55), Angle(0, 0, 0), Color(255, 0, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- tail light right
		[56] = {"light", Vector(480.32, 31.2, 41.43), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
		[57] = {"light", Vector(480.32, -31.2, 41.43), Angle(0, 0, 0), Color(255, 102, 0), brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt"}, -- brake lights
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
		[38] = {"light", Vector(416.20, 6, 54), Angle(0, 0, 0), Color(0, 90, 59), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- indicator indication lamp in cab
		[39] = {"light", Vector(415.617, 18.8834, 54.8), Angle(0, 0, 0), Color(252, 247, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- battery discharge lamp in cab
		[40] = {"light", Vector(415.617, 12.4824, 54.9), Angle(0, 0, 0), Color(0, 130, 99), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- clear for departure lamp
		[41] = {"light", Vector(415.656, -2.45033, 54.55), Angle(0, 0, 0), Color(255, 0, 0), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"}, -- doors unlocked lamp
		[42] = {"light", Vector(415.656, 14.6172, 54.55), Angle(0, 0, 0), Color(27, 57, 141), brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt"} -- departure clear lamp
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

function ENT:CreateSectionB(pos)
	local ang = Angle(0, 0, 0)
	local u3sectionb = ents.Create("gmod_subway_uf_u3_section_b")
	u3sectionb.ParentTrain = self

	self:SetNWEntity("U3b", u3sectionb)
	u3sectionb:SetNWEntity("U3a", self)
	-- self.u3sectionb = u2b
	u3sectionb:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	u3sectionb:SetAngles(self:GetAngles() + ang)
	u3sectionb:Spawn()
	u3sectionb:SetOwner(self:GetOwner())
	local xmin = 5
	local xmax = 5

	constraint.AdvBallsocket(u3sectionb, self.MiddleBogey, 0, -- bone
	0, -- bone		
	Vector(0, 0, 0), Vector(0, 0, 0), 0, -- forcelimit
	0, -- torquelimit
	-0, -- xmin
	-0, -- ymin
	-180, -- zmin
	0, -- xmax
	0, -- ymax
	180, -- zmax
	0, -- xfric
	10, -- yfric
	0, -- zfric
	0, -- rotonly
	1 -- nocollide
	)

	table.insert(self.TrainEntities, u3sectionb)

	constraint.NoCollide(self.MiddleBogey, u3sectionb, 0, 0)
	constraint.NoCollide(self, u3sectionb, 0, 0)

	return u3sectionb
end


function ENT:Think(dT)
	self.BaseClass.Think(self)

    self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()

    self.Speed = math.abs(self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)

	if self.FrontCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("AIsCoupled", true)
	else
		self:SetNW2Bool("AIsCoupled", false)
	end

	if self.RearCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("BIsCoupled", true)
	else
		self:SetNW2Bool("BIsCoupled", false)
	end

    self:SetNW2Float("BatteryCharge", self.Duewag_Battery.Voltage)

		if IsValid(self.FrontBogey) and IsValid(self.MiddleBogey) and IsValid(self.RearBogey) then

		if self.Duewag_U3.ReverserLeverStateA == 3 or self:ReadTrainWire(6) < 1 or self.Duewag_U3.ReverserLeverStateA == -1 or self.Duewag_U3.ReverserLeverStateB == 3
					or self.Duewag_U3.ReverserLeverStateB == -1 then

			if self.DepartureConfirmed == true then

				if self.Duewag_U3.ThrottleState < 0 then

					self.RearBogey.MotorForce = 67791.24
					self.FrontBogey.MotorForce = 67791.24
					self.BrakesOn = true
					self.RearBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
				elseif self.Duewag_U3.ThrottleState > 0 then

					self.RearBogey.MotorForce = 67791.24
					self.FrontBogey.MotorForce = 67791.24
					self.RearBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.BrakesOn = false

				elseif self.Duewag_U3.ThrottleState == 0 then
					self.RearBogey.MotorForce = 67791.24
					self.FrontBogey.MotorForce = 67791.24
					self.BrakesOn = false
					self.RearBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, false)
						self.SectionB:SetLightPower(67, false)
					end
				elseif self.DeadmanUF.DeadmanTripped == true then
					if self.Speed > 5 then
						self.RearBogey.MotorPower = self.Duewag_U3.Traction
						self.FrontBogey.MotorPower = self.Duewag_U3.Traction
						self.FrontBogey.BrakeCylinderPressure = 2.7
						self.MiddleBogey.BrakeCylinderPressure = 2.7
						self.RearBogey.BrakeCylinderPressure = 2.7
						self.BrakesOn = true
						if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
							self.SectionB:SetLightPower(66, true)
							self.SectionB:SetLightPower(67, true)
						end
					else
						self.RearBogey.MotorPower = 0
						self.FrontBogey.MotorPower = 0
						self.FrontBogey.BrakeCylinderPressure = 2.7
						self.MiddleBogey.BrakeCylinderPressure = 2.7
						self.RearBogey.BrakeCylinderPressure = 2.7
						self.BrakesOn = true
						if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
							self.SectionB:SetLightPower(66, true)
							self.SectionB:SetLightPower(67, true)
						end
					end
				end

			elseif self.DepartureConfirmed == false then
				self.FrontBogey.BrakeCylinderPressure = 2.7
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				self.BrakesOn = true
				if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
					self.SectionB:SetLightPower(66, true)
					self.SectionB:SetLightPower(67, true)
				end

			end

			if self.Duewag_U3.ReverserState == 1 then
				self.FrontBogey.Reversed = false
				self.RearBogey.Reversed = false
			elseif self.Duewag_U3.ReverserState == -1 then
				self.FrontBogey.Reversed = true
				self.RearBogey.Reversed = true
			end

		elseif self:ReadTrainWire(6) > 0 then

			if self:ReadTrainWire(8) < 1 then

				self.FrontBogey.BrakeCylinderPressure = self:ReadTrainWire(5)
				self.MiddleBogey.BrakeCylinderPressure = self:ReadTrainWire(5)
				self.RearBogey.BrakeCylinderPressure = self:ReadTrainWire(5)

				if self:ReadTrainWire(9) < 1 then
					if self:ReadTrainWire(3) > 0 or self:ReadTrainWire(4) > 0 then
						if self:ReadTrainWire(2) < 1 then
							self.RearBogey.MotorForce = 67791.24
							self.FrontBogey.MotorForce = 67791.24
							self.BrakesOn = false
							if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
								self.SectionB:SetLightPower(66, false)
								self.SectionB:SetLightPower(67, false)

							end
						elseif self:ReadTrainWire(2) > 0 then
							self.RearBogey.MotorForce = 67791.24
							self.FrontBogey.MotorForce = 67791.24
							self.BrakesOn = true
							if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
								self.SectionB:SetLightPower(66, true)
								self.SectionB:SetLightPower(67, true)

							end
						end
						self.RearBogey.MotorPower = self:ReadTrainWire(1)
						self.FrontBogey.MotorPower = self:ReadTrainWire(1)

						if self:ReadTrainWire(4) < 1 and self:ReadTrainWire(3) > 0 then
							self.FrontBogey.Reversed = false
							self.RearBogey.Reversed = false
							-- print(self:ReadTrainWire(4),self)
						elseif self:ReadTrainWire(3) < 1 and self:ReadTrainWire(4) > 0 then
							self.FrontBogey.Reversed = true
							self.RearBogey.Reversed = true
							-- print(self:ReadTrainWire(3),self)
						end
					end
				elseif self:ReadTrainWire(9) > 0 then

					self.FrontBogey.BrakeCylinderPressure = 2.7
					self.MiddleBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.MotorPower = 0
					self.FrontBogey.MotorPower = 0
					self.BrakesOn = true
					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
					if self:ReadTrainWire(3) > 0 then
						self.FrontBogey.Reversed = false
						self.RearBogey.Reversed = false

					elseif self:ReadTrainWire(4) > 0 then
						self.FrontBogey.Reversed = true
						self.RearBogey.Reversed = true
					end
				end

			elseif self:ReadTrainWire(8) > 0 then
				self.FrontBogey.BrakeCylinderPressure = 2.7
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				if self.Duewag_U3.Speed >= 2 then
					self.RearBogey.MotorPower = 110
					self.FrontBogey.MotorPower = 110
					self.RearBogey.MotorForce = -67791.24
					self.FrontBogey.MotorForce = -67791.24

					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
				elseif self.Duewag_U3.Speed < 2 then
					self.RearBogey.MotorPower = 0
					self.FrontBogey.MotorPower = 0

					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
				end
			end

		elseif self.Duewag_U3.ReverserLeverStateA == -1 then
			if self.Duewag_U3.ThrottleState < 0 then
				self.RearBogey.MotorForce = 5980
				self.FrontBogey.MotorForce = 5980
				self.BrakesOn = true
				if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
					self.SectionB:SetLightPower(66, true)
					self.SectionB:SetLightPower(67, true)
				end
				self.RearBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
			elseif self.Duewag_U3.ThrottleState > 0 and self.DepartureConfirmed == true then
				self.RearBogey.MotorForce = 4980
				self.FrontBogey.MotorForce = 4980
				self.RearBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
			elseif self.Duewag_U3.ThrottleState == 0 then
				self.RearBogey.MotorForce = 0
				self.FrontBogey.MotorForce = 0
				self.BrakesOn = false
				if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
					self.SectionB:SetLightPower(66, false)
					self.SectionB:SetLightPower(67, false)
				end
				self.RearBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.MotorPower = self.Duewag_U3.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U3.BrakePressure
			elseif self.Train:GetNW2Bool("DeadmanTripped") == true then
				if self.Speed > 5 then
					self.RearBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.MotorPower = self.Duewag_U3.Traction
					self.FrontBogey.BrakeCylinderPressure = 2.7
					self.MiddleBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.BrakeCylinderPressure = 2.7
					self.BrakesOn = true
					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
				else
					self.RearBogey.MotorPower = 0
					self.FrontBogey.MotorPower = 0
					self.FrontBogey.BrakeCylinderPressure = 2.7
					self.MiddleBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.BrakeCylinderPressure = 2.7
					self.BrakesOn = true
					if self.RearCouple.CoupledEnt == nil and self.BlinkerOn == false then
						self.SectionB:SetLightPower(66, true)
						self.SectionB:SetLightPower(67, true)
					end
				end
			end
			if self.Duewag_U3.ReverserState == 1 then
				self.FrontBogey.Reversed = false
				self.RearBogey.Reversed = false
			elseif self.Duewag_U3.ReverserState == -1 then
				self.FrontBogey.Reversed = true
				self.RearBogey.Reversed = true
			end

		end
		-- self.FrontBogey.PneumaticBrakeForce = 100
		-- self.MiddleBogey.PneumaticBrakeForce = 60
		-- self.RearBogey.PneumaticBrakeForce = 100

	end


end


ENT.CloseMoments = {}
ENT.CloseMomentsCalc = false

function ENT:DoorHandler(unlock, left, right, door1, idleunlock) -- Are the doors unlocked, sideLeft,sideRight,door1 open, unlocked while reverser on * position
	
	
	print(self.DeltaTime)
	
	--local irStatus = self:IRIS(self.DoorStatesRight[1] > 0 or self.DoorStatesRight[2] > 0 or self.DoorStatesRight[3] > 0 or self.DoorStatesRight[4] > or self.DoorStatesLeft[1] > 0 or self.DoorStatesLeft[2] > 0 or self.DoorStatesLeft[3] > 0 or self.DoorStatesLeft[4]) -- Call IRIS function to get IR gate sensor status, but only when the doors are open
	local irStatus = self:IRIS(true)
	if right and door1 then -- door1 control according to side preselection
		if self.DoorStatesRight[1] < 1 then
			self.DoorStatesRight[1] = self.DoorStatesRight[1] + 0.13
			math.Clamp(self.DoorStatesRight[1], 0, 1)
		end
	elseif left and door1 then
		if self.DoorStatesLeft[4] < 1 then
			self.DoorStatesLeft[4] = self.DoorStatesLeft[4] + 0.13
			math.Clamp(self.DoorStatesLeft[4], 0, 1)
		end
	end
	----------------------------------------------------------------------
	if unlock then

		self.DoorsPreviouslyUnlocked = true
		self.DoorLockSignalMoment = 0
		if self.DoorCloseMomentsCaptured == false then -- randomise door closing for more realistic behaviour
			self.DoorCloseMoments[1] = math.random(1, 4)
			self.DoorCloseMoments[2] = math.random(1, 4)
			self.DoorCloseMoments[3] = math.random(1, 4)
			self.DoorCloseMoments[4] = math.random(1, 4)
			self.DoorCloseMomentsCaptured = true
		end

		if right then
			if self.RandomnessCalulated ~= true then -- pick a random door to be unlocked

				for i, v in ipairs(self.DoorRandomness) do
					if i <= 4 and v < 0 then

						self.DoorRandomness[i] = math.random(0, 4)

						-- print(self.DoorRandomness[i], "doorrandom", i)
						self.RandomnessCalculated = true
						break
					end
				end

			end

			for i, v in ipairs(self.DoorRandomness) do -- increment the door states

				if v == 3 and self.DoorStatesRight[i] < 1 then
					if self.DeltaTime > 0 or self.DeltaTime < 0 then
						self.DoorStatesRight[i] = self.DoorStatesRight[i] + (0.8 * self.DeltaTime/8)
						math.Clamp(self.DoorStatesRight[i], 0, 1)
					else
						self.DoorStatesRight[i] = self.DoorStatesRight[i] + 0.1
						math.Clamp(self.DoorStatesRight[i], 0, 1)
					end
				end
			end
		elseif left then
			if self.RandomnessCalulated ~= true then -- pick a random door to be unlocked

				for i, v in ipairs(self.DoorRandomness) do
					if i <= 4 and v < 0 then

						self.DoorRandomness[i] = math.random(0, 4)

						-- print(self.DoorRandomness[i], "doorrandom", i)
						self.RandomnessCalculated = true
						break
					end
				end
			end

			for i, v in ipairs(self.DoorRandomness) do
				if v == 3 and self.DoorStatesLeft[i] < 1 then
					if self.DeltaTime > 0 or self.DeltaTime < 0 then
						self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + (0.8 * self.DeltaTime/8)
						math.Clamp(self.DoorStatesLeft[i], 0, 1)
					else
						self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.1
						math.Clamp(self.DoorStatesLeft[i], 0, 1)
					end
				end
			end
		end
	elseif not unlock then
		if self.DoorLockSignalMoment == 0 then self.DoorLockSignalMoment = CurTime() end
		self.DoorCloseMomentsCaptured = false

		if right then

			for i, v in ipairs(self.DoorStatesRight) do
				if CurTime() > self.DoorLockSignalMoment + self.DoorCloseMoments[i] then
					if irStatus ~= "Sensor" .. i .. "Blocked" then
						if v > 0 then
							if self.DeltaTime > 0 or self.DeltaTime < 0 then
								self.DoorStatesRight[i] = self.DoorStatesRight[i] - (0.8 * self.DeltaTime/8)
								self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
							else
								self.DoorStatesRight[i] = self.DoorStatesRight[i] - 0.1
								self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
							end
						end
					end
				end
			end

		elseif left then

			for i, v in ipairs(self.DoorStatesLeft) do
				if CurTime() > self.DoorLockSignalMoment + self.DoorCloseMoments[i] then
					if irStatus ~= "Sensor" .. i + 4 .. "Blocked" then
						if v > 0 then
							if self.DeltaTime > 0 or self.DeltaTime < 0 then
								self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - (0.8 * self.DeltaTime/8)
								self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
							else
								self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.1
								self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
							end
						end
					end
				end
			end
		end

	elseif idleunlock then -- If the Reverser is set to *, the doors automatically close again after five seconds

		if right then
			local opened
			-- Iterate through each door with random behavior
			for i, v in ipairs(self.DoorRandomness) do
				if v == 3 and self.DoorStatesRight[i] < 1 then
					if self.DeltaTime > 0 or self.DeltaTime < 0 then -- Check if dT is something we use
						if self.DoorOpenMoments[i] == 0 then
							-- Increase door state based on time (using dT)
							self.DoorStatesRight[i] = self.DoorStatesRight[i] + (0.8 * self.DeltaTime/8)
							self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
						end
					else -- If dT is not usable
						if self.DoorOpenMoments[i] == 0 then
							-- Increase door state without using dT
							self.DoorStatesRight[i] = self.DoorStatesRight[i] + 0.1
							self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
						end
					end
				elseif self.DoorStatesRight[i] > 0 and self.DoorOpenMoments[i] < CurTime() - 5 then -- If five seconds have passed, close the door
					if irStatus ~= "Sensor" .. i .. "Blocked" then
						if self.DeltaTime > 0 or self.DeltaTime < 0 then
							-- Decrease door state based on time (using dT)
							self.DoorStatesRight[i] = self.DoorStatesRight[i] - (0.8 * self.DeltaTime/8)
							self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
						else
							-- Decrease door state without using dT
							self.DoorStatesRight[i] = self.DoorStatesRight[i] - 0.1
							self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
						end
					end
				end
				if self.DoorStatesRight[i] == 1 and not opened then
					self.DoorOpenMoments[i] = CurTime() -- Record the moment the door opened
					opened = true
				elseif self.DoorStatesRight[i] == 0 then
					self.DoorOpenMoments[i] = 0
					opened = false
				end
			end
		elseif left then
			local opened
			-- Similar logic for the left doors
			for i, v in ipairs(self.DoorRandomness) do
				if v == 3 and self.DoorStatesLeft[i] < 1 then
					if self.DeltaTime > 0 or self.DeltaTime < 0 then
						if self.DoorOpenMoments[i] == 0 then
							self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + (0.8 * self.DeltaTime/8)
							self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
							if self.DoorStatesLeft[i] == 1 then
								self.DoorOpenMoments[i] = CurTime()
							end
						end
					else
						if self.DoorOpenMoments[i] == 0 then
							self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.1
							self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
						end
					end
				elseif self.DoorStatesLeft[i] > 0 and self.DoorOpenMoments[i] +5 < CurTime() then
					if irStatus ~= "Sensor" .. i + 4 .. "Blocked" then
						if self.DeltaTime > 0 or self.DeltaTime < 0 then
							self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - (0.8 * self.DeltaTime/8)
							self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
						else
							self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.1
							self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
						end
					end
				end
				if self.DoorStatesLeft[i] == 1 and not opened then
					self.DoorOpenMoments[i] = CurTime()
					opened = true
				elseif self.DoorStatesLeft[i] == 0 then
					self.DoorOpenMoments[i] = 0
					opened = false
				end
			end
		end
	end
end

function ENT:IRIS(enable) -- IR sensors for blocking the doors
	if enable then
		local result1 = util.TraceHull({
			start = self:LocalToWorld(Vector(330.889, -46.4148, 35.3841)),
			endpos = self:LocalToWorld(Vector(330.889, -46.4148, 35.3841)) + self:GetForward() * 70,
			mask = MASK_PLAYERSOLID,
			filter = {self}, -- filter out the train entity
			mins = Vector(-24, -2, 0),
			maxs = Vector(24, 2, 1)
		})
		local result2 = util.TraceHull({
			start = self:LocalToWorld(Vector(88.604, -46.4148, 35.3841)),
			endpos = self:LocalToWorld(Vector(88.604, -46.4148, 35.3841)) + self:GetForward() * 70,
			mask = MASK_PLAYERSOLID,
			filter = {self}, -- filter out the train entity
			mins = Vector(-24, -2, 0),
			maxs = Vector(24, 2, 1)
		})
		local result7 = util.TraceHull({
			start = self:LocalToWorld(Vector(330.889, 46.4148, 35.3841)),
			endpos = self:LocalToWorld(Vector(330.889, 46.4148, 35.3841)) + self:GetForward() * 70,
			mask = MASK_PLAYERSOLID,
			filter = {self}, -- filter out the train entity
			mins = Vector(-24, -2, 0),
			maxs = Vector(24, 2, 1)
		})
		local result8 = util.TraceHull({
			start = self:LocalToWorld(Vector(88.604, 46.4148, 35.3841)),
			endpos = self:LocalToWorld(Vector(88.604, 46.4148, 35.3841)) + self:GetForward() * 70,
			mask = MASK_PLAYERSOLID,
			filter = {self}, -- filter out the train entity
			mins = Vector(-24, -2, 0),
			maxs = Vector(24, 2, 1)
		})
		local statuses = {} -- Store the statuses in a table

		if IsValid(result1.Entity) and (result1.Entity:IsPlayer() or result1.Entity:IsNPC()) then table.insert(statuses, "Sensor1Blocked") end

		if IsValid(result2.Entity) and (result2.Entity:IsPlayer() or result2.Entity:IsNPC()) then table.insert(statuses, "Sensor2Blocked") end

		if self.SectionB:IRIS(enable) == "Sensor3Blocked" then table.insert(statuses, "Sensor3Blocked") end

		if self.SectionB:IRIS(enable) == "Sensor4Blocked" then table.insert(statuses, "Sensor4Blocked") end

		if self.SectionB:IRIS(enable) == "Sensor5Blocked" then table.insert(statuses, "Sensor5Blocked") end

		if self.SectionB:IRIS(enable) == "Sensor6Blocked" then table.insert(statuses, "Sensor6Blocked") end

		if IsValid(result7.Entity) and (result7.Entity:IsPlayer() or result7.Entity:IsNPC()) then table.insert(statuses, "Sensor7Blocked") end

		if IsValid(result8.Entity) and (result8.Entity:IsPlayer() or result8.Entity:IsNPC()) then table.insert(statuses, "Sensor8Blocked") end

		if statuses then
			return unpack(statuses, 1, 8) -- Return all blocked sensors
		else
			return nil
		end
	end

end