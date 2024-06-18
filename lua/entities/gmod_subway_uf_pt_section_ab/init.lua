AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/pt/section-ab.mdl")
	self.BaseClass.Initialize(self)
	-- self:SetPos(self:GetPos() + Vector(0,0,0))

	-- Create seat entities
	self.DriverSeat = self:CreateSeat("driver", Vector(366, 4, 40))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0, 0, 0, 0))

	self.SectionC = self:GetNW2Entity("SectionC")
	-- Create bogeys
	self.FrontBogey = self.SectionC.FrontBogey
	self.SectionBogeyA = self.SectionC.SectionBogeyA
	self.SectionBogeyB = self.SectionC.SectionBogeyB
	self.RearBogey = self.SectionC.RearBogey

	self.FrontCouple = self.SectionC.FrontCouple
	self.RearCouple = self.SectionC.RearCouple

	-- self.FrontStepR = self:CreateFoldingSteps("front_r")
	-- self.RearStepR = self:CreateFoldingSteps("front_r_back")
	-- self.FrontStepL = self:CreateFoldingSteps("front_l")
	-- self.RearStepL = self:CreateFoldingSteps("front_l_back")

	self.ReverserInserted = false

	-- print("UF: Init Pt Section A/B")

	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUp",
		[KEY_D] = "ThrottleDown",
		[KEY_H] = "BellEngageSet",
		[KEY_SPACE] = "DeadmanSet",
		[KEY_W] = "ReverserUpSet",
		[KEY_S] = "ReverserDownSet",
		[KEY_P] = "PantoUpSet",
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
		[KEY_PERIOD] = "WarnBlinkToggle",

		[KEY_COMMA] = "BlinkerLeftToggle",

		[KEY_PAGEUP] = "Rollsign1+",
		[KEY_PAGEDOWN] = "Rollsign1-",
		-- [KEY_0] = "KeyTurnOn",

		[KEY_LSHIFT] = {
			[KEY_0] = "ReverserInsert",
			[KEY_A] = "ThrottleUpFast",
			[KEY_D] = "ThrottleDownFast",
			[KEY_S] = "ThrottleZero",
			[KEY_H] = "Horn",
			[KEY_V] = "DriverLightToggle",
			[KEY_COMMA] = "BlinkerRightToggle",
			[KEY_B] = "BatteryDisableToggle",
			[KEY_PAGEUP] = "Rollsign+",
			[KEY_PAGEDOWN] = "Rollsign-",
			[KEY_O] = "OpenDoor1Set"

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
			[KEY_O] = "HighFloorSet",
			[KEY_I] = "LowFloorSet"
		}
	}
	self.Lights = {
		-- Headlight glow
		-- [1] = { "headlight",      Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100, farz=6144,brightness = 4},

		-- Head (type 1)
		[2] = {"glow", Vector(365, -40, -20), Angle(0, 0, 0), Color(255, 220, 180), brightness = 1, scale = 1.0},
		[3] = {"glow", Vector(365, -30, -25), Angle(0, 0, 0), Color(255, 220, 180), brightness = 1, scale = 1.0},
		[4] = {"glow", Vector(365, 30, -25), Angle(0, 0, 0), Color(255, 220, 180), brightness = 1, scale = 1.0},
		[5] = {"glow", Vector(365, 40, -20), Angle(0, 0, 0), Color(255, 220, 180), brightness = 1, scale = 1.0},
		[6] = {"glow", Vector(335, 40, 56), Angle(0, 0, 0), Color(199, 0, 0), brightness = 0.5, scale = 0.7},
		[7] = {"glow", Vector(335, -40, 56), Angle(0, 0, 0), Color(199, 0, 0), brightness = 0.5, scale = 0.7},
		[8] = {"glow", Vector(365, 40, -60), Angle(0, 0, 0), Color(199, 0, 0), brightness = 0.5, scale = 0.7},
		[9] = {"glow", Vector(365, -40, -60), Angle(0, 0, 0), Color(199, 0, 0), brightness = 0.5, scale = 0.7},
		-- Cabin
		[10] = {"dynamiclight", Vector(300, 0, 60), Angle(0, 0, 0), Color(216, 161, 92), distance = 450, brightness = 0.3},
		-- Salon
		[11] = {"dynamiclight", Vector(0, 0, 60), Angle(0, 0, 0), Color(216, 161, 92), distance = 450, brightness = 2},
		[12] = {"dynamiclight", Vector(200, 0, 60), Angle(0, 0, 0), Color(216, 161, 92), distance = 450, brightness = 2},
		[13] = {"dynamiclight", Vector(-200, 0, 60), Angle(0, 0, 0), Color(216, 161, 92), distance = 450, brightness = 2}
	}

	-- self:TrainSpawnerUpdate()
end

function ENT:Think()
	self.BaseClass.Think(self)
	self.SectionC = self:GetNW2Entity("SectionC")

	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()

	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed", self.Speed * 100)

	if self.SectionC.CoreSys.ReverserLeverState == 0 then
		self:SetNW2Float("ReverserAnim", 0.25)
	elseif self.SectionC.CoreSys.ReverserLeverState == 1 then
		self:SetNW2Float("ReverserAnim", 0.35)
	elseif self.SectionC.CoreSys.ReverserLeverState == 2 then
		self:SetNW2Float("ReverserAnim", 0.45)
	elseif self.SectionC.CoreSys.ReverserLeverState == 3 then
		self:SetNW2Float("ReverserAnim", 0.55)
	elseif self.SectionC.CoreSys.ReverserLeverState == -1 then
		self:SetNW2Float("ReverserAnim", 0)
	end
	self.Anims = {}
	self.FrontStepR:SetPoseParameter("position", self:Animate("FrontStepR", 0, 0, 100, 1, 10, false))
	self.FrontStepR:Activate()
	local Phys = self.FrontStepR:GetPhysicsObject()
	Phys:EnableCollisions()

	-- print(self.SectionC.CoreSys.ReverserLeverState)

end

function ENT:OnButtonRelease(button, ply) end

function ENT:OnButtonPress(button, ply)

	if self.SectionC.CoreSys.ReverserInsertedA then end

	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.SectionC.CoreSys.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.SectionC.CoreSys.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.SectionC.CoreSys.ThrottleRate = -3 end
	end

	if self.SectionC.CoreSys.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.SectionC.CoreSys.ThrottleRate = 8 end
		if button == "ThrottleDownFast" then self.SectionC.CoreSys.ThrottleRate = -8 end

	end

	if self.SectionC.CoreSys.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then self.SectionC.CoreSys.ThrottleRate = 10 end
		if button == "ThrottleDownReallyFast" then self.SectionC.CoreSys.ThrottleRate = -10 end

	end

	if self.SectionC.CoreSys.ReverserLeverState == 0 then
		if button == "ReverserInsert" then
			if self.ReverserInserted == false then
				self.ReverserInserted = true
				self.CoreSys.ReverserInserted = true
				self:SetNW2Bool("ReverserInserted", true)
				-- PrintMessage(HUD_PRINTTALK, "Reverser is in")

			elseif self.ReverserInserted == true then
				self.ReverserInserted = false
				self.CoreSys.ReverserInserted = false
				self:SetNW2Bool("ReverserInserted", false)
				-- PrintMessage(HUD_PRINTTALK, "Reverser is out")
			end
		end
	end

	if button == "ReverserUpSet" then
		if not self.SectionC.CoreSys.ThrottleEngaged == true then
			if self.SectionC.CoreSys.ReverserInserted == true then
				self.SectionC.CoreSys.ReverserLeverState = self.SectionC.CoreSys.ReverserLeverState + 1
				self.SectionC.CoreSys.ReverserLeverState = math.Clamp(self.SectionC.CoreSys.ReverserLeverState, -1, 3)
				-- self.CoreSys:TriggerInput("ReverserLeverState",self.ReverserLeverState)
				-- PrintMessage(HUD_PRINTTALK,self.CoreSys.ReverserLeverState)
			end
		end
	end
	if button == "ReverserDownSet" then
		if not self.SectionC.CoreSys.ThrottleEngaged == true and self.SectionC.CoreSys.ReverserInserted == true then
			-- self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp(self.SectionC.CoreSys.ReverserLeverState, -1, 3)
			-- self.CoreSys:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			self.SectionC.CoreSys.ReverserLeverState = self.SectionC.CoreSys.ReverserLeverState - 1
			self.SectionC.CoreSys.ReverserLeverState = math.Clamp(self.SectionC.CoreSys.ReverserLeverState, -1, 3)
			-- PrintMessage(HUD_PRINTTALK,self.CoreSys.ReverserLeverState)
		end
	end

	if button == "Rollsign1+" then self:SetNW2Bool("Rollsign1Scroll+") end
	if button == "Rollsign1-" then self:SetNW2Bool("Rollsign1Scroll-") end

	if button == "Rollsign+" then self:SetNW2Bool("RollsignScroll+") end
	if button == "Rollsign-" then self:SetNW2Bool("RollsignScroll-") end

end

function ENT:CreateCoupleUF_a(pos, ang, forward, typ)
	-- Create bogey entity
	local coupler = ents.Create("gmod_train_uf_couple")
	coupler:SetPos(self:LocalToWorld(pos))
	coupler:SetAngles(self:GetAngles() + ang)
	coupler.CoupleType = typ
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
		coupler:SetParent(self)
	else
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

		if IsValid(self.FrontBogey) then constraint.NoCollide(self.FrontBogey, coupler, 0, 0) end
		--[[
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)]]
	end

	-- Add to cleanup list
	table.insert(self.TrainEntities, coupler)
	return coupler
end

function ENT:CreateCoupleUF_b(pos, ang, forward, typ)
	-- Create bogey entity
	local coupler = ents.Create("gmod_train_uf_couple")
	coupler:SetPos(self:LocalToWorld(pos))
	coupler:SetAngles(self:GetAngles() + ang)
	coupler.CoupleType = typ
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
		coupler:SetParent(self)
	else
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

		if IsValid(self.RearBogey) then constraint.NoCollide(self.RearBogey, coupler, 0, 0) end

	end

	-- Add to cleanup list
	table.insert(self.TrainEntities, coupler)
	return coupler
end

function ENT:CreateFoldingSteps(pos)

	if pos == "front_r" then
		local step = ents.Create("prop_physics")
		step:SetModel("models/lilly/uf/pt/step_r.mdl")

		step:Spawn()
		step.SpawnPos = self:LocalToWorld(Vector(0, 0, 0))
		step:SetPos(self:LocalToWorld(Vector(237, 0, 0)))
		step.SpawnAng = Angle(0, 0, 0)
		step:SetAngles(self:GetAngles())
		constraint.Weld(step, self, 0, 0, 0, true, false)
		table.insert(self.TrainEntities, step)
		-- step:SetParent(self)
		return step
	elseif pos == "front_r_back" then
		local step = ents.Create("prop_physics")
		step:SetModel("models/lilly/uf/pt/step_r_back.mdl")
		step.SpawnPos = self:LocalToWorld(Vector(0, 0, 0))
		step:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
		step.SpawnAng = Angle(0, 0, 0)
		step:SetAngles(self:GetAngles())
		step:Spawn()
		constraint.Weld(step, self, 0, 0, 0, true, false)
		table.insert(self.TrainEntities, step)
		-- step:SetParent(self)
		return step
	elseif pos == "front_l" then
		local step = ents.Create("prop_physics")
		step:SetModel("models/lilly/uf/pt/step_r.mdl")
		step.SpawnPos = self:LocalToWorld(Vector(667, 0, 0))
		step:SetPos(self:LocalToWorld(Vector(430, 0, 0)))
		step.SpawnAng = Angle(0, 180, 0)
		step:SetAngles(self:GetAngles() + self:LocalToWorldAngles(Angle(0, 0, 180)))
		step:Spawn()
		constraint.Weld(step, self, 0, 0, 0, true, false)
		table.insert(self.TrainEntities, step)
		-- step:SetParent(self)
		return step
	elseif pos == "front_l_back" then
		local step = ents.Create("prop_physics")
		step:SetModel("models/lilly/uf/pt/step_r_back.mdl")
		step.SpawnPos = self:LocalToWorld(Vector(431.5, 0, 0))
		step:SetPos(self:LocalToWorld(Vector(194, 0, 0)))
		step:SetAngles(self:GetAngles() + self:LocalToWorldAngles(Angle(0, 0, 180)))
		step.SpawnAng = Angle(0, 180, 0)
		step:Spawn()
		constraint.Weld(step, self, 0, 0, 0, true, false)
		table.insert(self.TrainEntities, step)
		-- step:SetParent(self)
		return step
	end
end

--------------------------------------------------------------------------------
-- Animation function
--------------------------------------------------------------------------------
function ENT:Animate(clientProp, value, min, max, speed, damping, stickyness)
	local id = clientProp
	if not self.Anims[id] then
		self.Anims[id] = {}
		self.Anims[id].val = value
		self.Anims[id].V = 0.0
	end

	if damping == false then
		local dX = speed * self.DeltaTime
		if value > self.Anims[id].val then self.Anims[id].val = self.Anims[id].val + dX end
		if value < self.Anims[id].val then self.Anims[id].val = self.Anims[id].val - dX end
		if math.abs(value - self.Anims[id].val) < dX then self.Anims[id].val = value end
	else
		-- Prepare speed limiting
		local delta = math.abs(value - self.Anims[id].val)
		local max_speed = 1.5 * delta / self.DeltaTime
		local max_accel = 0.5 / self.DeltaTime

		-- Simulate
		local dX2dT = (speed or 128) * (value - self.Anims[id].val) - self.Anims[id].V * (damping or 8.0)
		if dX2dT > max_accel then dX2dT = max_accel end
		if dX2dT < -max_accel then dX2dT = -max_accel end

		self.Anims[id].V = self.Anims[id].V + dX2dT * self.DeltaTime
		if self.Anims[id].V > max_speed then self.Anims[id].V = max_speed end
		if self.Anims[id].V < -max_speed then self.Anims[id].V = -max_speed end

		self.Anims[id].val = math.max(0, math.min(1, self.Anims[id].val + self.Anims[id].V * self.DeltaTime))

		-- Check if value got stuck
		if (math.abs(dX2dT) < 0.001) and stickyness and (self.DeltaTime > 0) then self.Anims[id].stuck = true end
	end

	return min + (max - min) * self.Anims[id].val
end
