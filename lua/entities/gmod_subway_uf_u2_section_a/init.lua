AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------
ENT.SubwayTrain = {
	Type = "U2 ",
	Name = "U2h ",
	WagType = 0,
	Manufacturer = "Duewag",
}


function ENT:CreatePanto(pos,ang,type)
	local panto = ents.Create("gmod_train_uf_panto")
	
	panto:SetPos(self:LocalToWorld(pos))
	panto:SetAngles(self:GetAngles() + ang)
	
	panto.PantoType = type
	panto.NoPhysics = self.NoPhysics or true
	panto:Spawn()
	
	panto.SpawnPos = pos
	panto.SpawnAng = ang
	
	
	--if self.NoPhysics then
	--	panto:SetParent(self)
	--else
	constraint.Weld(panto,self,0,0,
	Vector(0,0,0),Vector(0,0,0),
	0,0,0,1,Vector(0,0,1),true)
	--end
	
	table.insert(self.TrainEntities,panto)
	return panto
	
end


function ENT:CreateBogeyUF(pos,ang,forward,typ)
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
	self.SquealSound = self.SquealSound or math.floor(4*math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound",self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index=1
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,pos.x+53.6)
	table.insert(self.JointPositions,index+1,pos.x-53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
		constraint.Axis(bogey,self,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)
		if forward and IsValid(self.FrontCouple) then
			constraint.NoCollide(bogey,self.FrontCouple,0,0)
		elseif not forward and IsValid(self.RearCouple) then
			constraint.NoCollide(bogey,self.RearCouple,0,0)
		end
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
end

function ENT:CreateBogeyUF_b(pos,ang,forward,typ)
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
	self.SquealSound = self.SquealSound or math.floor(4*math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound",self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index=1
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,pos.x+53.6)
	table.insert(self.JointPositions,index+1,pos.x-53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
		
		
		
		constraint.Axis(bogey,self.u2sectionb,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)
		if forward and IsValid(self.FrontCouple) then
			constraint.NoCollide(bogey,self.FrontCouple,0,0)
		elseif not forward and IsValid(self.RearCouple) then
			constraint.NoCollide(bogey,self.RearCouple,0,0)
		end
		
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
end

function ENT:CreateCoupleUF(pos,ang,forward,typ)
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
	local index=1
	local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,x)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(coupler)
	else
		constraint.AdvBallsocket(
		self,
		coupler,
		0, --bone
		0, --bone
		pos,
		Vector(0,0,0),
		1, --forcelimit
		1, --torquelimit
		-2, --xmin
		-2, --ymin
		-15, --zmin
		2, --xmax
		2, --ymax
		15, --zmax
		0.1, --xfric
		0.1, --yfric
		1, --zfric
		0, --rotonly
		1 --nocollide
	)
	
	if forward and IsValid(self.FrontBogey) then
		constraint.NoCollide(self.FrontBogey,coupler,0,0)
		constraint.NoCollide(self.FrontBogey,self,0,0)
	elseif not forward and IsValid(self.MiddleBogey) then
		constraint.NoCollide(self.MiddleBogey,coupler,0,0)
		constraint.NoCollide(self.MiddleBogey,self,0,0)
	end
	
	constraint.Axis(coupler,self,0,0,
	Vector(0,0,0),Vector(0,0,0),
	0,0,0,1,Vector(0,0,1),false)
end

-- Add to cleanup list
table.insert(self.TrainEntities,coupler)
return coupler
end

function ENT:CreateCouplerUF_b(pos,ang,forward,typ)
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
	local index=1
	local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,x)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(coupler)
	else
		constraint.AdvBallsocket(
		self.u2sectionb,
		coupler,
		0, --bone
		0, --bone
		pos,
		Vector(0,0,0),
		1, --forcelimit
		1, --torquelimit
		-2, --xmin
		-2, --ymin
		-15, --zmin
		2, --xmax
		2, --ymax
		15, --zmax
		0.1, --xfric
		0.1, --yfric
		1, --zfric
		0, --rotonly
		1 --nocollide
	)
	
	if forward and IsValid(self.FrontBogey) then
		constraint.NoCollide(self.FrontBogey,coupler,0,0)
		constraint.NoCollide(self.FrontBogey,self.u2sectionb,0,0)
	elseif not forward and IsValid(self.RearBogey) then
		constraint.NoCollide(self.RearBogey,coupler,0,0)
		constraint.NoCollide(self.RearBogey,self.u2sectionb,0,0)
	end
	
	constraint.Axis(coupler,self.u2sectionb,0,0,
	Vector(0,0,0),Vector(0,0,0),
	0,0,0,1,Vector(0,0,1),false)
end

-- Add to cleanup list
table.insert(self.TrainEntities,coupler)
return coupler
end

ENT.BogeyDistance = 1100


ENT.SyncTable = {"Headlights","WarnBlink","Microphone","BellEngage","Horn","WarningAnnouncement", "PantoUp", "DoorsCloseConfirm","PassengerLights", "SetHoldingBrake", "ReleaseHoldingBrake", "PassengerOverground", "PassengerUnderground", "SetPointRight", "SetPointLeft", "ThrowCoupler", "OpenDoor1", "UnlockDoors", "DoorCloseSignal", "Number1", "Number2", "Number3", "Number4", "Number6", "Number7", "Number8", "Number9", "Number0", "Destination","Delete","Route","DateAndTime","SpecialAnnouncements"}


function ENT:Initialize()
	
	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2h.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,10))  --set to 200 if one unit spawns in ground
	
	self:SetMassFib()
	-- Create seat entities
	self.DriverSeat = self:CreateSeat("driver",Vector(395,15,34))
	self.InstructorsSeat = self:CreateSeat("instructor",Vector(395,-20,10),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
	--self.HelperSeat = self:CreateSeat("instructor",Vector(505,-25,55))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.DriverSeat:SetColor(Color(0,0,0,0))
	self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.InstructorsSeat:SetColor(Color(0,0,0,0))
	
	self.Debug = 1
	self.LeadingCab = 0
	
	self.WarningAnnouncement = 0
	
	self.SquealSensitivity = 200
	
	self.DoorStatesRight = {
		["Door12a"] = 0,
		["Door34a"] = 0,
		["Door56a"] = 0,
		["Door78a"] = 0,}
		self.DoorStatesLeft = {
			["Door12b"] = 0,
			["Door34b"] = 0,
			["Door56b"] = 0,
			["Door78b"] = 0,
		}
		self.DoorsUnlocked = false
		self.DoorsPreviouslyUnlocked = false
		self.RandomnessCalulated = false
		self.DepartureConfirmed = true
		
		
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
		
		self.Haltebremse = 0
		self.CabWindowR = 0
		self.CabWindowL = 0
		self.AlarmSound = 0
		
		self.DoorsOpen = false
		-- Create bogeys
		self.FrontBogey = self:CreateBogeyUF(Vector( 300,0,0),Angle(0,180,0),true,"duewag_motor")
		self.MiddleBogey  = self:CreateBogeyUF(Vector(0,0,0),Angle(0,0,0),false,"u2joint")
		self:SetNW2Entity("FrontBogey",self.FrontBogey)
		self.MiddleBogey:SetNW2Entity("MainTrain",self)
		-- Create couples
		self.FrontCouple = self:CreateCoupleUF(Vector( 415,0,2),Angle(0,0,0),true,"u2")	
		
		
		self.ElectricOnMoment = 0
		self.ElectricKickStart = false
		self.ElectricStarted = false 
		
		-- Create U2 Section B
		self.u2sectionb = self:CreateSectionB(Vector(-780,0,0))
		self.RearBogey = self:CreateBogeyUF_b(Vector( -300,0,0),Angle(0,180,0),false,"duewag_motor")
		self.RearCouple = self:CreateCouplerUF_b(Vector( -415,0,2),Angle(0,180,0),true,"u2")	
		--self.Panto = self:CreatePanto(Vector(0,0,0),Angle(0,0,0),"diamond")
		--self:GetPhysicsObject():SetMass(50000)
		--self.u2sectionb:GetPhysicsObject():SetMass(50000)
		
		self.PantoUp = 0
		
		self.ReverserInsert = false 
		self.BatteryOn = false
		
		self.FrontBogey:SetNWInt("MotorSoundType",0)
		self.MiddleBogey:SetNWInt("MotorSoundType",0)
		self.RearBogey:SetNWInt("MotorSoundType",0)
		self.FrontBogey:SetNWBool("Async",false)
		self.MiddleBogey:SetNWBool("Async",false)
		self.RearBogey:SetNWBool("Async",false)
		--[[self.FrontBogey:TriggerInput("DisableSound",3)
		self.MiddleBogey:TriggerInput("DisableSound",3)
		self.RearBogey:TriggerInput("DisableSound",3)]]
		
		--self.PantoState = 0
		
		-- Blinker variables
		
		self:SetNW2Float("Blinds",0.2)
		
		--self.FrontBogey.DisableSound = 3
		--self.MiddleBogey.DisableSound = 3
		--self.RearBogey.DisableSound = 3
		
		
		self.BlinkerOn = false
		self.BlinkerLeft = false
		self.BlinkerRight = false
		self.Blinker = "Off"
		self.LastTriggerTime = 0
		
		self:SetNW2String("BlinkerDirection","none")
		
		self.DoorRandomness1 = 0
		self.DoorRandomness2 = 0
		self.DoorRandomness3 = 0
		self.DoorRandomness4 = 0
		
		
		
		
		--self.Lights = {}
		self.DoorSideUnlocked = "None"
		
		
		self:SetPackedBool("FlickBatterySwitchOn",false)
		self:SetPackedBool("FlickBatterySwitchOff",false)
		
		self.PrevTime = 0
		self.DeltaTime = 0
		
		self.IBISKeyRegistered =false
		
		self.RollsignModifier = 0
		self.RollsignModifierRate = 0
		self.ScrollMoment = 0
		self.ScrollMomentDelta = 0
		self.ScrollMomentRecorded = false
		
		self.IBISKeyPassed = false
		
		self.ScrollModifier = 0
		
		self.TrainWireCrossConnections = {
			[4] = 3, -- Reverser F<->B
			[21] = 20, --blinker
			
		}
		
		--[[self:SetNW2Int("Door1-2a",0)
		self:SetNW2Int("Door3-4a",0)
		self:SetNW2Int("Door5-6a",0)
		self:SetNW2Int("Door7-8a",0)
		self:SetNW2Int("Door1-2b",0)
		self:SetNW2Int("Door3-4b",0)
		self:SetNW2Int("Door5-6b",0)
		self:SetNW2Int("Door7-8b",0)]]
		
		-- Initialize key mapping
		self.KeyMap = {
			[KEY_A] = "ThrottleUp",
			[KEY_D] = "ThrottleDown",
			[KEY_F] = "ReduceBrake",
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
			--[KEY_0] = "KeyTurnOn",
			
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
				[KEY_O] = "OpenDoor1Set",
				[KEY_1] = "Throttle10-Pct",
				[KEY_2] = "Throttle20-Pct",
				[KEY_3] = "Throttle30-Pct",
				[KEY_4] = "Throttle40-Pct",
				[KEY_5] = "Throttle50-Pct",
				[KEY_6] = "Throttle60-Pct",
				[KEY_7] = "Throttle70-Pct",
				[KEY_8] = "Throttle80-Pct",
				[KEY_9] = "Throttle90-Pct",
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
				
				
				
			},
		}
		
		--How to get the IBIS inputs? With function TRAIN_SYSTEM:Trigger(name,value)
		
		
		
		local rand = math.random() > 0.8 and 1 or math.random(0.95,0.99) --because why not
		
		
		
		
		self:TrainSpawnerUpdate()
		--self.u2sectionb:SetNW2String("Texture", self:GetNW2String("Texture"))
		--self.u2sectionb:TrainSpawnerUpdate()
		
		--Lights sheen
		self.Lights = {
			[50] = { "light",Vector(406,39,98), Angle(90,0,0), Color(227,197,160),     brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt" }, --cab light
			[60] = { "light",Vector(406,-39,98), Angle(90,0,0), Color(227,197,160),     brightness = 0.6, scale = 0.5, texture = "sprites/light_glow02.vmt" }, --cab light
			[51] = { "light",Vector(430,40,28), Angle(0,0,0), Color(216,161,92),     brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight left
			[52] = { "light",Vector(430,-40,28), Angle(0,0,0), Color(216,161,92),     brightness = 0.6, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight right
			[53] = { "light",Vector(428,0,111), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt" }, --headlight top
			[54] = { "light",Vector(426.5,31.5,31), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light left
			[55] = { "light",Vector(426.5,-31.5,31), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light right
			[56] = { "light",Vector(426.5,31.2,31.5), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --brake lights
			[57] = { "light",Vector(426.5,-31.2,31.5), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, -- brake lights
			[58] = { "light",Vector(327,52,74), Angle(0,0,0), Color(255,100,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator top left
			[59] = { "light",Vector(327,-52,74), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator top right
			[48] = { "light",Vector(327,52,68), Angle(0,0,0), Color(255,100,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator bottom left
			[49] = { "light",Vector(327,-52,68), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator bottom right
			[30] = { "light",Vector(397.343,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 1
			[31] = { "light",Vector(326.738,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 2
			[32] = { "light",Vector(151.5,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 3
			[33] = { "light",Vector(83.7,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 4
			[34] = { "light",Vector(397.343,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 1
			[35] = { "light",Vector(326.738,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 2
			[36] = { "light",Vector(151.5,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 3
			[37] = { "light",Vector(83.7,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 4
			[38] = { "light",Vector(416.31,8.34,54.4798), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --indicator indication lamp in cab
		}
		
		
		
		
		
		
		self.InteractionZones = {
			{
				ID = "Button1a",
				Pos = Vector(396.3,-51,50.5), Radius = 16,
			},
			
		}
		
		
	end
	
	
	
	
	
	
	
	
	
	
	function ENT:TrainSpawnerUpdate()
		
		
		
		
		self.FrontCouple:SetParameters()
		self.RearCouple:SetParameters()
		local tex = "Def_U2"
		self.MiddleBogey.Texture = self:GetNW2String("Texture")
		self:UpdateTextures()
		self.MiddleBogey:UpdateTextures()
		
		--self.MiddleBogey:UpdateTextures()
		--self.MiddleBogey:UpdateTextures()
		--self:UpdateLampsColors()
		self.FrontCouple.CoupleType = "U2"
		self.RearCouple.CoupleType = "U2"
		--self.u2sectionb:SetNW2String("Texture", self:GetNW2String("Texture"))
		--self.u2sectionb.Texture = self:GetNW2String("Texture")
		
		
		
	end
	
	
	
	
	
	
	
	function ENT:Think(dT)
		self.BaseClass.Think(self)
		
		--print(table.ToString(UF.IBISLines[1]))
		print(UF.RegisterTrain("0123",self))
		
		if self.DoorSideUnlocked == "Left" and self.DoorsUnlocked == true and self.Door1 ~= true then
			self:DoorHandler(true,true,false,false)
			self:SetNW2Bool("DoorsClosing",false)
		elseif self.DoorSideUnlocked == "Right" and self.DoorsUnlocked == true and self.Door1 ~= true then
			self:DoorHandler(true,false,true,false)
			self:SetNW2Bool("DoorsClosing",false)
		elseif self.DoorSideUnlocked == "Right" and self.Door1 == true then
			self:DoorHandler(false,false,true,true)
			self:SetNW2Bool("DoorsClosing",false)
		elseif self.DoorSideUnlocked == "Left" and self.Door1 == true then
			self:DoorHandler(false,true,false,true)	
			self:SetNW2Bool("DoorsClosing",false)
		elseif self.DoorSideUnlocked == "Left" and self.DoorsUnlocked == false and self.Door1 ~= true then
			self:DoorHandler(false,true,false,false)
			self:SetNW2Bool("DoorsClosing",true)
		elseif self.DoorSideUnlocked == "Right" and self.DoorsUnlocked == false and self.Door1 ~= true then
			self:DoorHandler(false,false,true,false)
			self:SetNW2Bool("DoorsClosing",true)
		end
		
		self:SetNW2String("DoorSideUnlocked",self.DoorSideUnlocked)
		self:SetNW2Bool("DoorsUnlocked",self.DoorsUnlocked)
		
		
		if self:GetPackedBool("BOStrab",false) == true then
			self:SetPackedBool("BOStrab",false)
		end
		
		
		self:RollsignSync()
		self:SetNW2Entity("FrontBogey",self.FrontBogey)
		self.PrevTime = self.PrevTime or CurTime()
		self.DeltaTime = (CurTime() - self.PrevTime)
		self.PrevTime = CurTime()
		
		self:SetNW2Float("MotorPower",self.FrontBogey:GetMotorPower())
		local Panel = self.Panel
		
		------print(self:GetNW2Float("MotorPower"))
		
		self:SetPackedBool("WarnBlink",Panel.WarnBlink > 0)
		self:SetPackedBool("WarningAnnouncement",Panel.WarningAnnouncement > 0)
		self:SetPackedBool("SetHoldingBrake",Panel.SetHoldingBrake > 0)
		self:SetPackedBool("PassengerOverground",Panel.PassengerLightsOff > 0)
		self:SetPackedBool("PassengerUnderground",Panel.PassengerLightsOn > 0)
		self:SetPackedBool("SetPointLeft",Panel.SetPointLeft > 0)
		self:SetPackedBool("SetPointRight",Panel.SetPointLeft > 0)
		self:SetPackedBool("AnnPlay",self.Panel.AnnouncerPlaying > 0)
		
		
		
		self:SetPackedBool("Headlights",self.Panel.Headlights > 0)
		
		
		--temporary, move to electrical system later
		
		if self.Duewag_U2.ReverserState > 0 and self.Duewag_U2.BatteryOn == true then
			if self.Duewag_U2.HeadlightsSwitch == true then
				self.Panel.Headlights = 1
			else
				self.Panel.Headlights = 0
			end
			
		else
			self.Panel.Headlights = 0
		end
		
		
		------print(self:GetPackedBool("WarningAnnouncement"))
		--self:SetNW2Entity("FrontBogey",self.FrontBogey)
		------print(self.Panel.WarnBlink)
		self.CabWindowL = math.Clamp(self.CabWindowL,0,1)
		self.CabWindowR = math.Clamp(self.CabWindowR,0,1)
		self:SetNW2Float("CabWindowL",self.CabWindowL)
		self:SetNW2Float("CabWindowR",self.CabWindowR)
		
		--[[self.ScrollMomentDelta = self.ScrollMoment - CurTime()
		self.RollsignModifier = self.RollsignModifierRate * self.ScrollMomentDelta + math.Clamp(self.RollsignModifier,0,0.7)
		self:SetNW2Float("RollsignModifier",self.RollsignModifier)]]
		
		
		
		self.u2sectionb:TrainSpawnerUpdate()
		self:SetNW2Entity("U2a",self)
		
		--[[if self:GetPhysicsObject:GetMass() == 50000 and self.u2sectionb:GetPhysicsObject:GetMass() == 50000 then
		self:GetPhysicsObject:SetMass(16000)
		self.u2sectionb:GetPhysicsObject:SetMass(16000)
	end]]
	
	--PrintMessage(HUD_PRINTTALK, self:GetNW2String("Texture"))
	
	self:SetNW2Bool("PantoUp",self.PantoUp)
	self:SetNW2Bool("ReverserInserted",self.ReverserInsert)
	
	
	
	self.Speed = math.abs(self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed)
	
	--PrintMessage(HUD_PRINTTALK,"Current Speed")
	--PrintMessage(HUD_PRINTTALK,self.Speed)
	
	
	
	
	
	
	--Check if the A section is coupled
	if self.FrontCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("AIsCoupled", true)
	else
		self:SetNW2Bool("AIsCoupled",false)
	end
	
	if self.RearCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("BIsCoupled", true)
	else
		self:SetNW2Bool("BIsCoupled",false)
	end
	--Check if the B section is coupled
	if self.RearCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("BIsCoupled", true)
	else
		self:SetNW2Bool("BIsCoupled",false)
	end
	
	
	
	
	self:SetNW2Float("BatteryCharge",self.Duewag_Battery.Voltage)
	--If either of the sections are coupled, consider the unit coupled.
	--[[if self.RearCouple.CoupledEnt ~= nil or self.RearCouple.CoupledEnt ~= nil then
	self:SetNW2Bool("UnitCoupled",true)
else
	self:SetNW2Bool("UnitCoupled",false)
end]]






if self.BatteryOn == true or self:ReadTrainWire(7) > 0 then
	--self.Duewag_Battery.Charging = 1
	--self.Duewag_Battery:TriggerInput("Charge",0.2)
	
	self:SetNW2Float("BatteryCharge", self.Duewag_Battery.Voltage)
	
	self:SetNW2Bool("BatteryOn",true)
	--print(self:GetNW2Bool("BatteryOn",false))
	if self:GetNW2Bool("Cablight",false) == true --[[self:GetNW2Bool("BatteryOn",false) == true]] then
	self:SetLightPower(50,true)
	self:SetLightPower(60,true)
elseif self:GetNW2Bool("Cablight",false) == false then
	self:SetLightPower(50,false)
	self:SetLightPower(60,false)
end
if self.ElectricKickStart == false then	--if we haven't kicked off starting the power yet
	self.ElectricKickStart = true	--remember that we are doing now
	self.ElectricOnMoment = CurTime() --set the time that the IBIS starts booting now
	self.ElectricStarted = true
	------print(self.ElectricOnMoment)
	--self:SetNW2Float("ElectricOnMoment",self.ElectricOnMoment)
end

if CurTime() - self.ElectricOnMoment > 5 then
	self:SetNW2Bool("IBISChime",true)
	self:SetNW2Bool("IBISBootupComplete",true)
end
------print(self.ElectricOnMoment)

if self.IBIS.BootupComplete == true then
	self:SetNW2Bool("IBISChime",true)
end


if self.Duewag_U2.ReverserLeverState == 2 then
	self:WriteTrainWire(7,1)
	self.Duewag_Battery:TriggerInput("Charge",0.05)
	self.Duewag_Battery.Charging = 1
end

elseif self.BatteryOn == false then
	self:SetNW2Bool("BatteryOn",false)
	if self.Duewag_U2.ReverserLeverState == 2 then
		self:WriteTrainWire(7,0)
		self.Duewag_Battery.Charging = 0
		self.Duewag_Battery:TriggerInput("Charge",0)
	end
	
end

if self.Duewag_U2.ReverserLeverState == 1 then
	self:SetNW2Float("ReverserAnimate",0.4)
	
elseif self.Duewag_U2.ReverserLeverState == 0 then
	self:SetNW2Float("ReverserAnimate",0.25)
	
elseif self.Duewag_U2.ReverserLeverState == 3 then
	self:SetNW2Float("ReverserAnimate",1)
	
elseif self.Duewag_U2.ReverserLeverState == 2 then
	self:SetNW2Float("ReverserAnimate",0.7)
	
elseif self.Duewag_U2.ReverserLeverState == -1 then
	self:SetNW2Float("ReverserAnimate",0)
end

if self:ReadTrainWire(7) > 1 or self.Duewag_U2.BatteryOn == true then -- if the battery is on
	
	if self:GetNW2Bool("Braking",true) == true and self:GetNW2Bool("AIsCoupled",false) == false and self:ReadTrainWire(3) < 1 and self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
		self:SetLightPower(56,true)
		self:SetLightPower(57,true)
		self:SetNW2Bool("BrakeLights",true)
	elseif self:GetNW2Bool("AIsCoupled",false) == true and self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
		self:SetLightPower(56,false)
		self:SetLightPower(57,false)
		self:SetNW2Bool("BrakeLights",false)
	elseif self:GetPackedBool("Headlights",false) == true and self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
		self:SetLightPower(56,false)
		self:SetLightPower(57,false)
		self:SetNW2Bool("BrakeLights",false)
		
	end
	
	
	if self:GetNW2Bool("AIsCoupled",false) == false then
		
		if self:ReadTrainWire(4) > 0 and self:ReadTrainWire(3) < 1 then
			self:SetLightPower(51,false)
			self:SetLightPower(52,false)
			self:SetLightPower(53,false)
			self:SetLightPower(54,true)
			self:SetLightPower(55,true)
		elseif self:ReadTrainWire(3) > 0 then
			if self:GetPackedBool("Headlights",false) == true then
				self:SetLightPower(51,true)
				self:SetLightPower(52,true)
				self:SetLightPower(53,true)
				self:SetLightPower(54,false)
				self:SetLightPower(55,false)
				
			elseif self:GetPackedBool("Headlights",false) == false then
				self:SetLightPower(51,false)
				self:SetLightPower(52,false)
				self:SetLightPower(53,false)
				self:SetLightPower(54,false)
				self:SetLightPower(55,false)
				
				
			end
			
		end
	elseif self:GetNW2Bool("AIsCoupled",false) == true then
		if self:ReadTrainWire(4) > 0 then
			self:SetLightPower(51,false)
			self:SetLightPower(52,false)
			self:SetLightPower(53,false)
			self:SetLightPower(54,false)
			self:SetLightPower(55,false)
			--self:SetNW2Bool("Taillights",false)
			--self:SetNW2Bool("Headlights",false)
		elseif self:ReadTrainWire(3) > 0 then
			self:SetLightPower(51,false)
			self:SetLightPower(52,false)
			self:SetLightPower(53,false)
			self:SetLightPower(54,false)
			self:SetLightPower(55,false)
			--self:SetNW2Bool("Taillights",false)
			--self:SetNW2Bool("Headlights",false)
		end
	end
end












local N = math.Clamp(self.Duewag_U2.Traction, 0, 100)


if self.DoorsUnlocked == false then
	self:SetLightPower(30,false)
	self:SetLightPower(31,false)
	self:SetLightPower(32,false)
	self:SetLightPower(33,false)
	self:SetLightPower(34,false)
	self:SetLightPower(35,false)
	self:SetLightPower(36,false)
	self:SetLightPower(37,false)
end

if self.DoorsUnlocked == true then
	
	if self.DoorSideUnlocked == "Left" then
		self:SetLightPower(30,true)
		self:SetLightPower(31,true)
		self:SetLightPower(32,true)
		self:SetLightPower(33,true)
		
		self:SetLightPower(34,false)
		self:SetLightPower(35,false)
		self:SetLightPower(36,false)
		self:SetLightPower(37,false)
	elseif self.DoorSideUnlocked == "None" then
		self:SetLightPower(30,false)
		self:SetLightPower(31,false)
		self:SetLightPower(32,false)
		self:SetLightPower(33,false)
		self:SetLightPower(34,false)
		self:SetLightPower(35,false)
		self:SetLightPower(36,false)
		self:SetLightPower(37,false)
	elseif self.DoorSideUnlocked == "Right" then
		self:SetLightPower(34,true)
		self:SetLightPower(35,true)
		self:SetLightPower(36,true)
		self:SetLightPower(37,true)
		
		self:SetLightPower(30,false)
		self:SetLightPower(31,false)
		self:SetLightPower(32,false)
		self:SetLightPower(33,false)
		
	end
	
	
end





if IsValid(self.FrontBogey) and IsValid(self.MiddleBogey) and IsValid(self.RearBogey) then
	
	--print(#self.WagonList)
	--self.FrontBogey.PneumaticBrakeForce = 10000.0
	--self.MiddleBogey.PneumaticBrakeForce = 10000.0
	--self.RearBogey.PneumaticBrakeForce = 10000.0  
	
	
	if self.Duewag_U2.ReverserLeverState == 3 or self:ReadTrainWire(6) < 1 then
		
		if self.DepartureConfirmed == true then
			
			
			
			
			
			if self.Duewag_U2.ThrottleState < 0 then
				self.RearBogey.MotorForce  = -5980 
				self.FrontBogey.MotorForce = -5980
				self:SetNW2Bool("Braking",true)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState > 0 and self.DepartureConfirmed == true then 
				self.RearBogey.MotorForce  = 4980
				self.FrontBogey.MotorForce = 4980 
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState == 0 then 
				self.RearBogey.MotorForce  = 0
				self.FrontBogey.MotorForce = 0
				self:SetNW2Bool("Braking",false)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Train:GetNW2Bool("DeadmanTripped") == true then
				if self.Speed > 5 then
					self.RearBogey.MotorPower = self.Duewag_U2.Traction
					self.FrontBogey.MotorPower = self.Duewag_U2.Traction
					self.FrontBogey.BrakeCylinderPressure = 2.7 
					self.MiddleBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.BrakeCylinderPressure = 2.7
					self:SetNW2Bool("Braking",true)
				else
					self.RearBogey.MotorPower = 0
					self.FrontBogey.MotorPower = 0
					self.FrontBogey.BrakeCylinderPressure = 2.7 
					self.MiddleBogey.BrakeCylinderPressure = 2.7
					self.RearBogey.BrakeCylinderPressure = 2.7
					self:SetNW2Bool("Braking",true)
				end
			end
			
		elseif self.DepartureConfirmed == false then
			self.FrontBogey.BrakeCylinderPressure = 2.7
			self.MiddleBogey.BrakeCylinderPressure = 2.7
			self.RearBogey.BrakeCylinderPressure = 2.7
			self.RearBogey.MotorPower = 0
			self.FrontBogey.MotorPower = 0
			self:SetNW2Bool("Braking",true)
			
			
			
		end
		
		if self.Duewag_U2.ReverserState == 1 then 
			self.FrontBogey.Reversed = false
			self.RearBogey.Reversed = false 
		elseif self.Duewag_U2.ReverserState == -1 then
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
						self.RearBogey.MotorForce  = 67791.24 
						self.FrontBogey.MotorForce = 67791.24    
						self:SetNW2Bool("Braking",false)
					elseif self:ReadTrainWire(2) > 0 then 
						self.RearBogey.MotorForce  = -67791.24  
						self.FrontBogey.MotorForce = -67791.24 
						self:SetNW2Bool("Braking",true)
					end
					self.RearBogey.MotorPower = self:ReadTrainWire(1)
					self.FrontBogey.MotorPower = self:ReadTrainWire(1)
					
					
					if self:ReadTrainWire(3) > 0 then 
						self.FrontBogey.Reversed = false
						self.RearBogey.Reversed = false 
					elseif self:ReadTrainWire(4) > 0 then
						self.FrontBogey.Reversed = true
						self.RearBogey.Reversed = true
					end
				end
			elseif self:ReadTrainWire(9) > 0 then
				
				self.FrontBogey.BrakeCylinderPressure = 2.7
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				self:SetNW2Bool("Braking",true)
				if self:ReadTrainWire(3) == 1 then 
					self.FrontBogey.Reversed = false
					self.RearBogey.Reversed = false 
				elseif self:ReadTrainWire(4) == 1 then
					self.FrontBogey.Reversed = true
					self.RearBogey.Reversed = true
				end
			end
			
		elseif self:ReadTrainWire(8) > 0 then
			self.FrontBogey.BrakeCylinderPressure = 2.7
			self.MiddleBogey.BrakeCylinderPressure = 2.7
			self.RearBogey.BrakeCylinderPressure = 2.7
			if self.Duewag_U2.Speed >= 2 then 
				self.RearBogey.MotorPower = 110
				self.FrontBogey.MotorPower = 110
				self.RearBogey.MotorForce  = -67791.24 
				self.FrontBogey.MotorForce = -67791.24
				print("deadman braking")
			elseif self.Duewag_U2.Speed < 2 then
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				print("low speed cutoff")
			end
			
			
			
			
			
			
		end
		
	elseif self.Duewag_U2.ReverserLeverState == -1 then
		print(self.Duewag_U2.BrakePressure)
		if self.Duewag_U2.ThrottleState < 0 then
			self.RearBogey.MotorForce  = -5980 
			self.FrontBogey.MotorForce = -5980
			self:SetNW2Bool("Braking",true)
			self.RearBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
			self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
		elseif self.Duewag_U2.ThrottleState > 0 and self.DepartureConfirmed == true then 
			self.RearBogey.MotorForce  = 4980
			self.FrontBogey.MotorForce = 4980 
			self.RearBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
			self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
		elseif self.Duewag_U2.ThrottleState == 0 then 
			self.RearBogey.MotorForce  = 0
			self.FrontBogey.MotorForce = 0
			self:SetNW2Bool("Braking",false)
			self.RearBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.MotorPower = self.Duewag_U2.Traction
			self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
			self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
		elseif self.Train:GetNW2Bool("DeadmanTripped") == true then
			if self.Speed > 5 then
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = 2.7 
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self:SetNW2Bool("Braking",true)
			else
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				self.FrontBogey.BrakeCylinderPressure = 2.7 
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self:SetNW2Bool("Braking",true)
			end
		end
		
	end
	self.FrontBogey.PneumaticBrakeForce = 43.333
	self.MiddleBogey.PneumaticBrakeForce = 43.333
	self.RearBogey.PneumaticBrakeForce = 43.333
	
	
	
end



--15000*N / 20  ---(N < 0 and 1 or 0) ------- 1 unit = 110kw / 147hp | Total kW of U2 300kW


--PrintMessage(HUD_PRINTTALK,self:ReadTrainWire(3)..tostring(self))

--if self:GetNW2Bool("BatteryOn",false) == true or self:ReadTrainWire(7) == 1 then --blinker only works when electricity is on, duh
if self:ReadTrainWire(20) > 0 and self:ReadTrainWire(21) < 1 then
	self:Blink(true,true,false)
	
elseif self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) > 0 then
	self:Blink(true,false,true)
	
elseif self:ReadTrainWire(20) > 0 and self:ReadTrainWire(21) > 0 then
	self:Blink(true,true,true)
	
elseif self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
	self:Blink(false,false,false)
	
end




--if self.Duewag_U2.VZ == true then
--N *100 + (self.ChopperJump) --100 ----------- maximum kW of one bogey 36.67
--elseif self.Duewag_U2.VE == true and self.Duewag_U2.VZ == false then
--self.RearBogey.MotorPower = self.Duewag_U2.Traction
--self.FrontBogey.MotorPower = self.Duewag_U2.Traction
--end



--end

--PrintMessage(HUD_PRINTTALK, self:ReadTrainWire(1))
--PrintMessage(HUD_PRINTTALK,#self.WagonList)

self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)

self:SetNWInt("ThrottleStateAnim", self.Duewag_U2.ThrottleStateAnim)

--Send door states to client
self:SetNW2Float("Door12a",self.DoorStatesRight["Door12a"])
self:SetNW2Float("Door34a",self.DoorStatesRight["Door34a"])
self:SetNW2Float("Door56a",self.DoorStatesRight["Door56a"])
self:SetNW2Float("Door78a",self.DoorStatesRight["Door78a"])

self:SetNW2Float("Door12b",self.DoorStatesRight["Door12b"])
self:SetNW2Float("Door34b",self.DoorStatesRight["Door34b"])
self:SetNW2Float("Door56b",self.DoorStatesRight["Door56b"])
self:SetNW2Float("Door78b",self.DoorStatesRight["Door78b"])

if self.DoorsPreviouslyUnlocked == true and self.DoorsUnlocked == false and self.LeftDoorsOpen == false and self.RightDoorsOpen == false then
	self:SetNW2Bool("DoorCloseAlarm",true)
else
	self:SetNW2Bool("DoorCloseAlarm",false)
end





if self.DoorStatesRight["Door12a"] > 0 or self.DoorStatesRight["Door34a"] > 0 or self.DoorStatesRight["Door56a"] > 0 or self.DoorStatesRight["Door78a"] > 0 then
	self.RightDoorsOpen = true
else
	self.RightDoorsOpen = false
end
if self.DoorStatesLeft["Door12b"] > 0 or self.DoorStatesLeft["Door34b"] > 0 or self.DoorStatesLeft["Door56b"] > 0 or self.DoorStatesLeft["Door78b"] > 0 then
	self.LeftDoorsOpen = true
else
	self.LeftDoorsOpen = false
end



end




function ENT:OnButtonPress(button,ply)
	
	
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.Duewag_U2.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.Duewag_U2.ThrottleRate = -3 end
	end
	
	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.Duewag_U2.ThrottleRate = 8 end
		if button == "ThrottleDownFast" then self.Duewag_U2.ThrottleRate = -8 end
		
	end
	
	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then self.Duewag_U2.ThrottleRate = 10 end
		if button == "ThrottleDownReallyFast" then self.Duewag_U2.ThrottleRate = -10 end
		
	end
	
	if button == "OpenDoor1Set" then
		
		if self.Door1 == false then
			self.Door1 = true
		end
	end
	
	
	if button == "Door1Set" then
		self.Door1 = true
	end
	
	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleZero" then self.Duewag_U2.ThrottleState = 0 end
	end
	
	if button == "Throttle10Pct" then
		self.Duewag_U2.ThrottleState = 10
	end
	
	if button == "Throttle20Pct" then
		self.Duewag_U2.ThrottleState = 20
	end
	
	if button == "Throttle30Pct" then
		self.Duewag_U2.ThrottleState = 30
	end
	if button == "Throttle40Pct" then
		self.Duewag_U2.ThrottleState = 40
	end
	if button == "Throttle50Pct" then
		self.Duewag_U2.ThrottleState = 50
	end
	if button == "Throttle60Pct" then
		self.Duewag_U2.ThrottleState = 60
	end
	if button == "Throttle70Pct" then
		self.Duewag_U2.ThrottleState = 70
	end
	if button == "Throttle80Pct" then
		self.Duewag_U2.ThrottleState = 80
	end
	if button == "Throttle90Pct" then
		self.Duewag_U2.ThrottleState = 90
	end
	
	if button == "Throttle10-Pct" then
		self.Duewag_U2.ThrottleState = -10
	end
	
	if button == "Throttle20-Pct" then
		self.Duewag_U2.ThrottleState = -20
	end
	
	if button == "Throttle30-Pct" then
		self.Duewag_U2.ThrottleState = -30
	end
	if button == "Throttle40-Pct" then
		self.Duewag_U2.ThrottleState = -40
	end
	if button == "Throttle50-Pct" then
		self.Duewag_U2.ThrottleState = -50
	end
	if button == "Throttle60-Pct" then
		self.Duewag_U2.ThrottleState = -60
	end
	if button == "Throttle70-Pct" then
		self.Duewag_U2.ThrottleState = -70
	end
	if button == "Throttle80-Pct" then
		self.Duewag_U2.ThrottleState = -80
	end
	if button == "Throttle90-Pct" then
		self.Duewag_U2.ThrottleState = -90
	end
	
	if button == "PantoUp" then
		if self.PantoUp == false then
			self.PantoUp = true 
			self.Duewag_U2:TriggerInput("PantoUp",self.KeyPantoUp)
			self:SetPackedBool("PantoUp",true)
			PrintMessage(HUD_PRINTTALK, "Panto is up")
		else
			
			if  self.PantoUp == true then
				self.PantoUp = false
				self.Duewag_U2:TriggerInput("PantoUp",0)
				self:SetPackedBool("PantoUp",0)
				PrintMessage(HUD_PRINTTALK, "Panto is down")
			end
		end
		
	end
	
	
	if button == "EmergencyBrakeSet" and self:GetNW2Bool("EmergencyBrake",false) == false then
		self:SetNW2Bool("EmergencyBrake",true)
	elseif button == "EmergencyBrakeSet" and self:GetNW2Bool("EmergencyBrake",false) == true then
		self:SetNW2Bool("EmergencyBrake",false)
	end
	
	if button == "Rollsign+" then
		self:SetNW2Bool("Rollsign+",true)
		self.ScrollMoment = CurTime()
	end
	if button == "Rollsign-" then
		self:SetNW2Bool("Rollsign-",true)
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
		self:SetNW2Bool("WarningAnnouncement", true)
	end
	
	if button == "Blinds+" then
		
		self:SetNW2Float("Blinds",self:GetNW2Float("Blinds") +0.1)
		self:SetNW2Float("Blinds",math.Clamp(self:GetNW2Float("Blinds"),0.2,1))
	end
	
	if button == "Blinds-" then
		
		self:SetNW2Float("Blinds",self:GetNW2Float("Blinds") -0.1)
		self:SetNW2Float("Blinds",math.Clamp(self:GetNW2Float("Blinds"),0.2,1))
	end
	
	if button == "ReverserUpSet" then
		if 
		not self.Duewag_U2.ThrottleEngaged == true  then
			if self.Duewag_U2.ReverserInserted == true then
				self.Duewag_U2.ReverserLeverState = self.Duewag_U2.ReverserLeverState + 1
				self.Duewag_U2.ReverserLeverState = math.Clamp(self.Duewag_U2.ReverserLeverState, -1, 3)
				--self.Duewag_U2:TriggerInput("ReverserLeverState",self.ReverserLeverState)
				--PrintMessage(HUD_PRINTTALK,self.Duewag_U2.ReverserLeverState)
			end
		end
	end
	if button == "ReverserDownSet" then
		if 
		not self.Duewag_U2.ThrottleEngaged == true and self.Duewag_U2.ReverserInserted == true then
			--self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp(self.Duewag_U2.ReverserLeverState, -1, 3)
			--self.Duewag_U2:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			self.Duewag_U2.ReverserLeverState = self.Duewag_U2.ReverserLeverState - 1
			self.Duewag_U2.ReverserLeverState = math.Clamp(self.Duewag_U2.ReverserLeverState, -1, 3)
			--PrintMessage(HUD_PRINTTALK,self.Duewag_U2.ReverserLeverState)
		end
	end
	
	
	
	if self.Duewag_U2.ReverserState == 0 then
		if button == "ReverserInsert" then
			if self.ReverserInsert == false then
				self.ReverserInsert = true
				self.Duewag_U2:TriggerInput("ReverserInserted",self.ReverserInsert)
				self:SetNW2Bool("ReverserInserted",true)
				--PrintMessage(HUD_PRINTTALK, "Reverser is in")
				
			elseif  self.ReverserInsert == true then
				self.ReverserInsert = false
				self.Duewag_U2:TriggerInput("ReverserInserted",false)
				self:SetNW2Bool("ReverserInserted",false)
				--PrintMessage(HUD_PRINTTALK, "Reverser is out")
			end
		end
	end
	
	
	if button == "BatteryToggle" then
		
		self:SetPackedBool("FlickBatterySwitchOn",true)
		if self.BatteryOn == false and self.Duewag_U2.ReverserLeverState == 1 then
			self.BatteryOn = true
			
			self.Duewag_Battery:TriggerInput("Charge",1.3)
			self:SetNW2Bool("BatteryOn",true)
			--PrintMessage(HUD_PRINTTALK, "Battery switch is ON")
		end
	end
	
	if button == "BatteryDisableToggle" then
		if self.BatteryOn == true and self.Duewag_U2.ReverserLeverState == 1 then
			self.BatteryOn = false
			self.Duewag_Battery:TriggerInput("Charge",1.3)
			self:SetNW2Bool("BatteryOn",false)
			--PrintMessage(HUD_PRINTTALK, "Battery switch is off")
			--self:SetNW2Bool("BatteryToggleIsTouched",true)
			
		end
		self:SetPackedBool("FlickBatterySwitchOff",true)
		
	end
	
	
	if button == "DeadmanSet" then
		self.Duewag_Deadman:TriggerInput("IsPressed", 1)
		if self:ReadTrainWire(6) > 0 then
			self:WriteTrainWire(12,1)
		end
		------print("DeadmanPressedYes")
	end
	
	
	if button == "BlinkerLeftToggle" then
		
		if self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) > 0 then -- If you press the button and the blinkers are already set to right, do nothing
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
		elseif
		self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are off, set to left
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
			--self:SetNW2String("BlinkerDirection","left")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are already on, turn them off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
			--self:SetNW2String("BlinkerDirection","none")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) > 0 then
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)
		end
	end
	
	
	if button == "BlinkerRightToggle" then
		
		if self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) > 0 then -- If you press the button and the blinkers are already set to right, turn them off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
			self:SetNW2String("BlinkerDirection","none")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are already set to left, do nothing
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
		elseif
		self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
			self:SetNW2String("BlinkerDirection","right")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) > 0 then
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)	
		end
	end
	
	if button == "BellEngageSet" then
		self:SetNW2Bool("Bell",true)
	end
	
	if button == "Horn" then
		self:SetNW2Bool("Horn",true)
	end
	
	
	if button == "WarnBlinkToggle" then
		if self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 and self:ReadTrainWire(20) ~= 1 or self:ReadTrainWire(21) ~= 1 then
			self:SetNW2Bool("WarningBlinker",true)
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)
			self.Panel.WarnBlink = 1
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) > 0 then
			self:SetNW2Bool("WarningBlinker",false)
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
			self.Panel.WarnBlink = 0
		end
	end
	
	
	
	if button == "ThrowCouplerSet" then
		if self:ReadTrainWire(5) > 1 and self.Duewag_U2.Speed < 1 then
			self.FrontCouple:Decouple()
		end
		self:SetPackedBool("ThrowCoupler",true)
	end
	
	if button == "DriverLightToggle" then
		
		if self:GetNW2Bool("Cablight",false) == false then
			self:SetNW2Bool("Cablight",true)
		elseif self:GetNW2Bool("Cablight",false) == true then
			self:SetNW2Bool("Cablight",false)
		end
	end
	if button == "HeadlightsToggle" then
		
		if self.Duewag_U2.HeadlightsSwitch == false then
			self.Duewag_U2.HeadlightsSwitch = true
			self:SetPackedBool("HeadlightsSwitch",self.Duewag_U2.HeadlightsSwitch)
		else
			self.Duewag_U2.HeadlightsSwitch = false
			self:SetPackedBool("HeadlightsSwitch",self.Duewag_U2.HeadlightsSwitch)
		end
		----print(self.Duewag_U2.HeadlightsSwitch)
	end
	
	if button == "DoorsSelectLeftToggle" then
		if self.DoorSideUnlocked == "None" then
			self.DoorSideUnlocked = "Left"
		elseif self.DoorSideUnlocked == "Right" then
			self.DoorSideUnlocked = "None"
		elseif self.DoorSideUnlocked == "Left" then
			self.DoorSideUnlocked = self.DoorSideUnlocked
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
	end
	
	
	
	
	if button == "Button1a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness1 == 0 then
				self.DoorRandomness1 = 4
			end
		end
	end
	
	if button == "Button2a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness1 == 0 then
				self.DoorRandomness1 = 4
			end
		end
	end
	
	if button == "Button3a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness2 == 0 then
				self.DoorRandomness2 = 4
			end
		end
	end
	
	if button == "Button4a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness2 == 0 then
				self.DoorRandomness2 = 4
			end
		end
	end
	
	
	if button == "DoorsUnlockSet"  then
		
		self.DoorsUnlocked = true
		self.DepartureConfirmed = false
		
	end
	
	
	if button == "DoorsLockSet"  then
		
		
		self.DoorRandomness1 = 0
		self.DoorRandomness2 = 0
		self.DoorRandomness3 = 0
		self.DoorRandomness4 = 0
		
		self.DoorsPreviouslyUnlocked = true
		self.RandomnessCalculated = false
		self.DoorsUnlocked = false
		self.Door1 = false
		
		
	end
	
	if button == "DoorsCloseConfirmSet" then
		
		self.DoorsPreviouslyUnlocked = false
		self.DepartureConfirmed = true
	end
	
	if button == "SetHoldingBrakeSet" then
		
		self.Duewag_U2.ManualRetainerBrake = true
	end
	
	if button == "ReleaseHoldingBrakeSet" then
		
		self.Duewag_U2.ManualRetainerBrake = false
	end
	
	if button == "PassengerLightsToggle" then
		if self:GetNW2Bool("PassengerLights",false) == true then
			self:SetNW2Bool("PassengerLights",false)
		elseif self:GetNW2Bool("PassengerLights",false) == false then
			self:SetNW2Bool("PassengerLights",true)
		end
	end
	
	if button == "DoorsSelectLeftToggle" then
		if self:GetNWString("DoorSide","none") == "right" then
			self:SetNWString("DoorSide","none")
			--PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString("DoorSide","none") == "none" then
			self:SetNWString("DoorSide","left")
			--PrintMessage(HUD_PRINTTALK, "Door switch position left")
		end
	end
	
	if button == "DoorsSelectRightToggle" then
		if self:GetNWString("DoorSide","none") == "left" then
			self:SetNWString("DoorSide","none")
			--PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString("DoorSide","none") == "none" then
			self:SetNWString("DoorSide","right")
			--PrintMessage(HUD_PRINTTALK, "Door switch position right")
		end
	end
	
	if button == "PassengerDoor" then
		
		if self:GetNW2Float("DriversDoorState",0) == 0 then
			self:SetNW2Float("DriversDoorState",1)
		else
			self:SetNW2Float("DriversDoorState",0)
		end
	end
	
	if button == "Mirror" then
		if self:GetNW2Float("Mirror",0) == 0 then
			self:SetNW2Float("Mirror",1)
		else
			self:SetNW2Float("Mirror",0)
		end
	end
	
	if button == "ComplaintSet" then
		self:SetNW2Bool("Microphone",true)
	end
	
	
	if button == "ComplaintSet" then
		
		self:SetNW2Bool("Microphone",false)
	end
	
	if button == "DestinationSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self:SetNW2Bool("IBISKeyBeep",true)
			self.IBIS:Trigger("Destination",RealTime())
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	
	
	if button == "Number0Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number0",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
		
	end
	
	if button == "Number1Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number1",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number2Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number2",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number3Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number3",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number4Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number4",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number5Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number5",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number6Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number6",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number7Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number7",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number8Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number8",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number9Set" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Number9",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "EnterSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("Enter",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "SpecialAnnouncementSet" then
		if self.IBISKeyRegistered == false then
			self.IBISKeyRegistered = true
			self.IBIS:Trigger("SpecialAnnouncement",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
end


function ENT:OnButtonRelease(button,ply)
	
	
	
	if button == "EmergencyBrakeSet" then
		--self:SetNW2Bool("EmergencyBrake",false)
	end
	
	if (button == "ThrottleUp" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDown" and self.Duewag_U2.ThrottleRate < 0) then
		self.Duewag_U2.ThrottleRate = 0
	end
	if (button == "ThrottleUpFast" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDownFast" and self.Duewag_U2.ThrottleRate < 0) then
		self.Duewag_U2.ThrottleRate = 0
	end
	
	
	
	if button == "Rollsign+" then
		self:SetNW2Bool("Rollsign+",false)
		self.ScrollMoment = CurTime()
	end
	if button == "Rollsign-" then
		self:SetNW2Bool("Rollsign-",false)
		self.ScrollMoment = CurTime()
	end
	
	if button == "BatteryToggle" then
		self:SetPackedBool("FlickBatterySwitchOn",false)
	end
	
	if button == "BatteryDisableToggle" then
		self:SetPackedBool("FlickBatterySwitchOff",false)
	end
	
	
	
	if button == "DeadmanSet" then
		self.Duewag_Deadman:TriggerInput("IsPressed", 0)
		
		if self:ReadTrainWire(6) > 0 then
			self:WriteTrainWire(12,0)
		end
		------print("DeadmanPressedNo")
	end
	
	if button == "WarningAnnouncementSet" then
		self:SetNW2Bool("WarningAnnouncement", false)
	end
	
	if button == "BellEngageSet" then
		self:SetNW2Bool("Bell",false)
	end
	if button == "Horn" then
		self:SetNW2Bool("Horn",false)
	end
	
	if button == "BatteryToggle" then
		self:SetNW2Bool("IBIS_impulse",false)
	end
	
	if button == "DestinationSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	
	
	if button == "Number0Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
		
	end
	
	if button == "Number1Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number2Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number3Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number4Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number5Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number6Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number7Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number8Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "Number9Set" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "EnterSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	if button == "SpecialAnnouncementSet" then
		if self.IBISKeyRegistered == true then
			self.IBISKeyRegistered = false
			self.IBIS:Trigger(nil)
		end
	end
	
	
	if button == "OpenBOStrab" then
		self:SetPackedBool("BOStrab",true)
		--self:SetPackedBool("BOStrab",false)
	end
	
end

function ENT:CreateSectionB(pos)
	local ang = Angle(0,0,0)
	local u2sectionb = ents.Create("gmod_subway_uf_u2_section_b")
	u2sectionb.ParentTrain = self
	u2sectionb:SetNW2Entity("U2a",self)
	-- self.u2sectionb = u2b
	u2sectionb:SetPos(self:LocalToWorld(Vector(0,0,0)))
	u2sectionb:SetAngles(self:GetAngles() + ang)
	u2sectionb:Spawn()
	u2sectionb:SetOwner(self:GetOwner())
	local xmin = 5
	local xmax = 5
	
	
	constraint.AdvBallsocket(
	u2sectionb,
	self.MiddleBogey,
	0, --bone
	0, --bone		
	Vector(0,0,0),
	Vector(0,0,6),		
	0, --forcelimit
	0, --torquelimit
	-20, --xmin
	0, --ymin
	-180, --zmin
	20, --xmax
	0, --ymax
	180, --zmax
	0, --xfric
	5, --yfric
	0, --zfric
	0, --rotonly
	1--nocollide
)


table.insert(self.TrainEntities,u2sectionb)


constraint.NoCollide(self.MiddleBogey,u2sectionb,0,0)
constraint.NoCollide(self,u2sectionb,0,0)

return u2sectionb
end


function ENT:SetRetainerBrake(enable)
	
	if enable then
		self.FrontBogey.BrakeCylinderPressure = 2.7 
		self.MiddleBogey.BrakeCylinderPressure = 2.7
		self.RearBogey.BrakeCylinderPressure = 2.7
	else
		self.FrontBogey.BrakeCylinderPressure = self.FrontBogey.BrakeCylinder
		self.MiddleBogey.BrakeCylinderPressure = self.MiddleBogey.BrakeCylinderPressure
		self.RearBogey.BrakeCylinderPressure = self.RearBogey.BrakeCylinderPressure
	end
end
function ENT:Blink(enable, left, right)
	
	if self.BatteryOn == true then
		if not enable then
			
			self.BlinkerOn = false
			self.LastTriggerTime = CurTime()
			
			
		elseif CurTime() - self.LastTriggerTime > 0.4 then
			self.BlinkerOn = not self.BlinkerOn
			
			self.LastTriggerTime = CurTime()
			
		end
		
		self:SetLightPower(58,self.BlinkerOn and left)
		
		self.u2sectionb.BlinkerLeft = self.BlinkerOn and left
		
		self:SetLightPower(48,self.BlinkerOn and left)
		self:SetLightPower(59,self.BlinkerOn and right)
		self:SetLightPower(49,self.BlinkerOn and right)
		self:SetLightPower(38,self.BlinkerOn and right or left and self.BlinkerOn)
		self.u2sectionb.BlinkerRight = self.BlinkerOn and right
		
		if self.BlinkerOn and left and right then
			self:SetLightPower(56,self.BlinkerOn)
			self:SetLightPower(57,self.BlinkerOn)
			self:SetLightPower(38,self.BlinkerOn and left and right)
		end
		
		if self.BlinkerOn and left == true then
			self:SetLightPower(38,self.BlinkerOn and left)
		end
		if self.BlinkerOn and right == true then
			self:SetLightPower(38,self.BlinkerOn and right)
		end
		
		self:SetNW2Bool("BlinkerTick",self.BlinkerOn) --one tick sound for the blinker relay
	end
end

function ENT:DoorHandler(unlock,left,right,door1)--Are the doors unlocked, sideLeft,sideRight,door1 open
	
	
	if right and door1 then --door1 control according to side preselection
		if self.DoorStatesRight["Door12a"] < 1 then
			self.DoorStatesRight["Door12a"] = self.DoorStatesRight["Door12a"] + 0.1
		end
	elseif left and door1 then
		if self.DoorStatesLeft["Door78b"] < 1 then
			self.DoorStatesLeft["Door78b"] = self.DoorStatesLeft["Door78b"] + 0.1
		end
	end
	----------------------------------------------------------------------	
	if unlock then 
		if right then
			
			if self.RandomnessCalulated ~= true then --pick a random door to be unlocked
				self.RandomnessCalculated = true
				self.DoorRandomness1 = math.random(0,4)
				self.DoorRandomness2 = math.random(0,4)
				self.DoorRandomness3 = math.random(0,4)
				self.DoorRandomness4 = math.random(0,4)
				
			end
			if self.DoorRandomness1 == 3 then
				if self.DoorStatesRight["Door12a"] < 1 then
					self.DoorStatesRight["Door12a"] = self.DoorStatesRight["Door12a"] + 0.1
				end
				
			end
			if self.DoorRandomness2 == 3 then
				if self.DoorStatesRight["Door34a"] < 1 then
					self.DoorStatesRight["Door34a"] = self.DoorStatesRight["Door34a"] + 0.1
				end
				
			end
			if self.DoorRandomness3 == 3 then
				if self.DoorStatesRight["Door56a"] < 1 then
					self.DoorStatesRight["Door56a"] = self.DoorStatesRight["Door56a"] + 0.1
				end
				
			end
			if self.DoorRandomness4 == 3 then
				if self.DoorStatesRight["Door78a"] < 1 then
					self.DoorStatesRight["Door78a"] = self.DoorStatesRight["Door78a"] + 0.1
				end
				
			end
		elseif left then
			if not self.RandomnessCalulated then
				self.RandomnessCalculated = true
				self.DoorRandomness1 = math.random(0,4)
				self.DoorRandomness2 = math.random(0,4)
				self.DoorRandomness3 = math.random(0,4)
				self.DoorRandomness4 = math.random(0,4)
			end
			if self.DoorRandomness1 == 3 then
				if self.DoorStatesLeft["Door12b"] < 1 then
					self.DoorStatesLeft["Door12b"] = self.DoorStatesLeft["Door12b"] + 0.1
				end
			end
			if self.DoorRandomness2 == 3 then
				if self.DoorStatesLeft["Door34b"] < 1 then
					self.DoorStatesLeft["Door34b"] = self.DoorStatesLeft["Door34b"] + 0.1
				end
			end
			if self.DoorRandomness3 == 3 then
				if self.DoorStatesLeft["Door56b"] < 1 then
					self.DoorStatesLeft["Door56b"] = self.DoorStatesLeft["Door56b"] + 0.1
				end
			end
			if self.DoorRandomness4 == 3 then
				if self.DoorStatesLeft["Door78b"] < 1 then
					self.DoorStatesLeft["Door78b"] = self.DoorStatesLeft["Door78b"] + 0.1
				end
			end
		end
	else
		if right then
			
			
			if self.DoorStatesRight["Door12a"] > 0 then
				self.DoorStatesRight["Door12a"] = self.DoorStatesRight["Door12a"] - 0.05
			end
			
			
			if self.DoorStatesRight["Door34a"] > 0 then
				self.DoorStatesRight["Door34a"] = self.DoorStatesRight["Door34a"] - 0.05
			end
			
			
			if self.DoorStatesRight["Door56a"] > 0 then
				self.DoorStatesRight["Door56a"] = self.DoorStatesRight["Door56a"] - 0.05
			end
			
			
			if self.DoorStatesRight["Door78a"] > 0 then
				self.DoorStatesRight["Door78a"] = self.DoorStatesRight["Door78a"] - 0.05
			end
			
		elseif left then
			
			if self.DoorStatesLeft["Door12b"] > 0 then
				self.DoorStatesLeft["Door12b"] = self.DoorStatesLeft["Door12b"] - 0.05
			end
			
			
			if self.DoorStatesLeft["Door34b"] > 0 then
				self.DoorStatesLeft["Door34b"] = self.DoorStatesLeft["Door34b"] - 0.05
			end
			
			
			if self.DoorStatesLeft["Door56b"] > 0 then
				self.DoorStatesLeft["Door56b"] = self.DoorStatesLeft["Door56b"] - 0.05
			end
			
			
			if self.DoorStatesLeft["Door78b"] > 0 then
				self.DoorStatesLeft["Door78b"] = self.DoorStatesLeft["Door78b"] - 0.05
			end
			
		end
	end
	
	
end

function ENT:RollsignSync()
	
	if self.ScrollMoment - CurTime() > 20 then
		self:SetNW2Float("ActualScrollState",self.ScrollModifier)
	end 
	
	if self:GetNW2Bool("Rollsign+",false) == true then
		self.ScrollModifier = self.ScrollModifier + 0.0001 * self.DeltaTime
		self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
	elseif self:GetNW2Bool("Rollsign-",false) == true then
		self.ScrollModifier = self.ScrollModifier - 0.0001 * self.DeltaTime
		self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
	elseif self:GetNW2Bool("Rollsign-",false) == false and self:GetNW2Bool("Rollsign+",false) == false then
		self.ScrollModifier = self.ScrollModifier
		self.ScrollModifier = math.Clamp(self.ScrollModifier,0,1)
	end
end

function ENT:SetMassFib()
	
	local phys = self:GetPhysicsObject()
	
	if ( IsValid( phys ) ) then -- Always check with IsValid! The ent might not have physics!
		phys:SetMass(50000)
		
	end
end

