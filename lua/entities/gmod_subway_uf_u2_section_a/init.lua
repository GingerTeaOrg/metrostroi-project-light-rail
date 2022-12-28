AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--------------------------------------------------------------------------------
-- немного переписанная татра lindy2017
--------------------------------------------------------------------------------
---------------------------------------------------
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


ENT.SyncTable = {"Microphone","BellEngage","Horn","WarningAnnouncementSet", "PantoUp", "DoorsCloseConfirmSet", "PassengerLightsSet", "SetHoldingBrakeSet", "ReleaseHoldingBrakeSet", "PassengerOvergroundSet", "PassengerUndergroundSet", "DoorsCloseConfirmSet", "SetPointRightSet", "SetPointLeftSet", "ThrowCouplerSet", "OpenDoor1Set", "UnlockDoorsSet", "DoorCloseSignalSet", "Number1Set", "Number2Set", "Number3Set", "Number4Set", "Number6Set", "Number7Set", "Number8Set", "Number9Set", "Number0Set", "DestinationSet","DeleteSet","RouteSet","DateAndTimeSet","SpecialAnnouncementsSet"}


function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2h.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,10))  --set to 200 if one unit spawns in ground
	
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

	self.Haltebremse = 0
	self.CabWindowR = 0
	self.CabWindowL = 0
	self.AlarmSound = 0

	self.DoorsOpen = false
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector( 300,0,0),Angle(0,180,0),true,"duewag_motor")
    self.MiddleBogey  = self:CreateBogeyUF(Vector(0,0,0),Angle(0,0,0),false,"u2joint")
    

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
	self.FrontBogey:SetNWBool("Async",true)
    self.MiddleBogey:SetNWBool("Async",true)
	self.RearBogey:SetNWBool("Async",true)
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

	self.DoorState1 = 0
	self.DoorState2 = 0
	self.DoorState3 = 0
	self.DoorState4 = 0

	self.DoorState21 = 0
	self.DoorState22 = 0
	self.DoorState23 = 0
	self.DoorState24 = 0

	self.CommandOpen = false
	self.CommandClose = false

	
	self.DoorSideUnlocked = "None"
	self:SetNW2Bool("DepartureConfirmed",true)
	self:SetNW2Bool("DoorsUnlocked",false)


	self:SetPackedBool("FlickBatterySwitchOn",false)
	self:SetPackedBool("FlickBatterySwitchOff",false)

	self.PrevTime = 0
	self.DeltaTime = 0

	self.RollsignModifier = 0
	self.RollsignModifierRate = 0
	self.ScrollMoment = 0
	self.ScrollMomentDelta = 0
	self.ScrollMomentRecorded = false


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
		[KEY_V] = "LightsToggle",
		[KEY_M] = "Mirror",
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
	[54] = { "light",Vector(-426.5,31.5,31), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light left
	[55] = { "light",Vector(-426.5,-31.5,31), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light right
	[56] = { "light",Vector(-426.5,31.5,26), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --brake lights
	[57] = { "light",Vector(-426.5,-31.5,26), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, -- brake lights
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
}


	self.TrainWireCrossConnections = {
        --[3] = 4, -- Reverser F<->B
		--[21] = 20,

    }

	

self.InteractionZones = {
        {
            ID = "DoorButtonFLSet",
            Pos = Vector(397.343,51,49.7), Radius = 16,
        },

}


end









	
function ENT:TrainSpawnerUpdate()
			

		--local num = self.WagonNumber
		--math.randomseed(num+400)
		
        self.FrontCouple:SetParameters()
        self.RearCouple:SetParameters()
		local tex = "Def_U2"
		self:UpdateTextures()
		self.MiddleBogey:UpdateTextures()
		--self.MiddleBogey:UpdateTextures()
		--self:UpdateLampsColors()
		self.FrontCouple.CoupleType = "U2"
		self.RearCouple.CoupleType = "U2"
		--self.u2sectionb:SetNW2String("Texture", self:GetNW2String("Texture"))
		--self.u2sectionb.Texture = self:GetNW2String("Texture")
		
		

end



--[[function ENT:GetMotorPower()

	self.FrontBogey:GetMotorPower()
	
end]]







function ENT:Think(dT)
	self.BaseClass.Think(self)

	self.PrevTime = self.PrevTime or CurTime()
    self.DeltaTime = (CurTime() - self.PrevTime)
    self.PrevTime = CurTime()

    
	
	--self:SetNW2Entity("FrontBogey",self.FrontBogey)

	self.CabWindowL = math.Clamp(self.CabWindowL,0,1)
	self.CabWindowR = math.Clamp(self.CabWindowR,0,1)
	self:SetNW2Float("CabWindowL",self.CabWindowL)
	self:SetNW2Float("CabWindowR",self.CabWindowR)

	self.ScrollMomentDelta = self.ScrollMoment - CurTime()
	self.RollsignModifier = self.RollsignModifierRate * self.ScrollMomentDelta + math.Clamp(self.RollsignModifier,0,0.7)
	self:SetNW2Float("RollsignModifier",self.RollsignModifier)
	


	self.u2sectionb:TrainSpawnerUpdate()
	self:SetNW2Entity("U2a",self)

	--[[if self:GetPhysicsObject:GetMass() == 50000 and self.u2sectionb:GetPhysicsObject:GetMass() == 50000 then
		self:GetPhysicsObject:SetMass(16000)
		self.u2sectionb:GetPhysicsObject:SetMass(16000)
	end]]

	--PrintMessage(HUD_PRINTTALK, self:GetNW2String("Texture"))
	if self:ReadTrainWire(7) == 1 then
		self:SetNW2Bool("BatteryOn",true)

	elseif self:ReadTrainWire(7) == 0 then
		self:SetNW2Bool("BatteryOn",false)
	end
	self:SetNW2Bool("PantoUp",self.PantoUp)
	self:SetNW2Bool("ReverserInserted",self.ReverserInsert)

	if self:ReadTrainWire(1) > 0 and self:ReadTrainWire(3) > 1 and self.Speed < 5 then
		self:SetNW2Bool("Fans",true)
	elseif self:ReadTrainWire(1) == 0  then
		self:SetNW2Bool("Fans",false)
	end
	

	self.Speed = math.abs(self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Float("Speed",self.Speed)
	self.Duewag_U2:TriggerInput("Speed",self.Speed*150)
 
	--PrintMessage(HUD_PRINTTALK,"Current Speed")
	--PrintMessage(HUD_PRINTTALK,self.Speed)

	
	
	
	--print(#self.Train.WagonList)

	--Check if the A section is coupled
	if self.FrontCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("AIsCoupled", true)
	else
		self:SetNW2Bool("AIsCoupled",false)
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
	



	if self:GetNW2Bool("Cablight",false) == true --[[self:GetNW2Bool("BatteryOn",false) == true]] then
        self:SetLightPower(50,true)
		self:SetLightPower(60,true)
    elseif self:GetNW2Bool("Cablight",false) == false then
        self:SetLightPower(50,false)
		self:SetLightPower(60,false)
    end

	if self.BatteryOn == true then
		--self.Duewag_Battery.Charging = 1
		--self.Duewag_Battery:TriggerInput("Charge",0.2)

		self:SetNW2Float("BatteryCharge", self.Duewag_Battery.Voltage)
		
		self:SetNW2Bool("BatteryOn",true)

		if self.ElectricKickStart == false then	--if we haven't kicked off starting the power yet
			self.ElectricKickStart = true	--remember that we are doing now
			self.ElectricOnMoment = CurTime() --set the time that the IBIS starts booting now
			self.ElectricStarted = true
			--print(self.ElectricOnMoment)
			--self:SetNW2Float("ElectricOnMoment",self.ElectricOnMoment)
		end

		if CurTime() - self.ElectricOnMoment > 5 then
			self:SetNW2Bool("IBISChime",true)
			self:SetNW2Bool("IBISBootupComplete",true)
		end
		--print(self.ElectricOnMoment)
		
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
			self:WriteTrainWire(7,1)
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
	
	--if self:ReadTrainWire(7) == 1 then -- if the battery is on
		
		if self:GetNW2Bool("Braking",true) == true and not self:GetNW2Bool("AIsCoupled",false) == true and not self:ReadTrainWire(3) == 1 then
			self:SetLightPower(56,true)
			self:SetLightPower(57,true)
			self:SetNW2Bool("BrakeLights",true)
		elseif self:GetNW2Bool("AIsCoupled",false) == true then
			self:SetLightPower(56,false)
			self:SetLightPower(57,false)
			self:SetNW2Bool("BrakeLights",false)
		elseif self:GetNW2Bool("Headlights",false) == true then
			self:SetLightPower(56,false)
			self:SetLightPower(57,false)
			self:SetNW2Bool("BrakeLights",false)
		end
		
		
		if not self:GetNW2Bool("AIsCoupled",false) == true then
			if self:ReadTrainWire(4) == 1 and self:ReadTrainWire(3) == 0 then
				self:SetLightPower(51,false)
    			self:SetLightPower(52,false)
				self:SetLightPower(53,false)
				self:SetLightPower(54,true)
				self:SetLightPower(55,true)
				self:SetNW2Bool("Taillights",true) --send it off as an NW2 Bool, so that we don't need more logic in cl_init
				self:SetNW2Bool("Headlights",false)
			elseif self:ReadTrainWire(3) == 1 and self:ReadTrainWire(4) == 0 then
				if self:GetNW2Bool("HeadlightsSwitch",false) == true then
					self:SetLightPower(51,true)
    				self:SetLightPower(52,true)
					self:SetLightPower(53,true)
					self:SetNW2Bool("Taillights",false)
					self:SetNW2Bool("Headlights",true)
				elseif self:GetNW2Bool("HeadlightsSwitch",false) == false then
					self:SetLightPower(51,false)
    				self:SetLightPower(52,false)
					self:SetLightPower(53,false)
					self:SetNW2Bool("Taillights",false)
					self:SetNW2Bool("Headlights",false)

				end
				--[[self:SetLightPower(54,false)
				self:SetLightPower(55,false)
				self:SetNW2Bool("Taillights",false)]]

			end
		elseif self:GetNW2Bool("AIsCoupled",false) == true then
			if self:ReadTrainWire(4) == 1 then
				self:SetLightPower(51,false)
   		 		self:SetLightPower(52,false)
				self:SetLightPower(53,false)
				self:SetLightPower(54,false)
				self:SetLightPower(55,false)
				self:SetNW2Bool("Taillights",false)
				self:SetNW2Bool("Headlights",false)
			elseif self:ReadTrainWire(3) == 1 then
				self:SetLightPower(51,false)
    			self:SetLightPower(52,false)
				self:SetLightPower(53,false)
				self:SetLightPower(54,false)
				self:SetLightPower(55,false)
				self:SetNW2Bool("Taillights",false)
				self:SetNW2Bool("Headlights",false)
			end
		end
	--end
	
	


	

	

	


	
	local N = math.Clamp(self.Duewag_U2.Traction, 0, 100)
	
	
	if self:GetNW2Bool("DoorsUnlocked",false) == false then
			self:SetLightPower(30,false)
			self:SetLightPower(31,false)
			self:SetLightPower(32,false)
			self:SetLightPower(33,false)
			self:SetLightPower(34,false)
			self:SetLightPower(35,false)
			self:SetLightPower(36,false)
			self:SetLightPower(37,false)
	end
	
 	if self:GetNW2Bool("DoorsUnlocked",false) == true  then

		if self:GetNWString("DoorSide","none") == "left" then
			self:SetLightPower(30,true)
			self:SetLightPower(31,true)
			self:SetLightPower(32,true)
			self:SetLightPower(33,true)

			self:SetLightPower(34,false)
			self:SetLightPower(35,false)
			self:SetLightPower(36,false)
			self:SetLightPower(37,false)
		elseif self:GetNWString("DoorSide","none") == "none" then
			self:SetLightPower(30,false)
			self:SetLightPower(31,false)
			self:SetLightPower(32,false)
			self:SetLightPower(33,false)
			self:SetLightPower(34,false)
			self:SetLightPower(35,false)
			self:SetLightPower(36,false)
			self:SetLightPower(37,false)
		elseif self:GetNWString("DoorSide","none") == "right" then
			self:SetLightPower(34,true)
			self:SetLightPower(35,true)
			self:SetLightPower(36,true)
			self:SetLightPower(37,true)

			self:SetLightPower(30,false)
			self:SetLightPower(31,false)
			self:SetLightPower(32,false)
			self:SetLightPower(33,false)

		end

			if self:GetNWString("DoorSide","none") == "left" and (self:GetNW2Float("Door1-2b",0) == 1 or self:GetNW2Float("Door3-4b",0)  == 1 or self:GetNW2Float("Door5-6b",0) == 1 or self:GetNW2Float("Door7-8b",0)) then
				self.LeftDoorsOpen = true
				self.RightDoorsOpen = false
			
			elseif self:GetNWString("DoorSide","none") == "none" then
				self.LeftDoorsOpen = false
				self.RightDoorsOpen = false
		
			elseif self:GetNWString("DoorSide","none") == "right" and (self:GetNW2Float("Door1-2a",0) == 1 or self:GetNW2Float("Door3-4a",0)  == 1 or self:GetNW2Float("Door5-6a",0) == 1 or self:GetNW2Float("Door7-8a",0)) then
				self.LeftDoorsOpen = false
				self.RightDoorsOpen = true
			
			end
	else 
		self.LeftDoorsOpen = false
		self.RightDoorsOpen = false
		
	end
	
	
	
	
if IsValid(self.FrontBogey) and IsValid(self.MiddleBogey) and IsValid(self.RearBogey) then
	
	
	--self.FrontBogey.PneumaticBrakeForce = 10000.0
	--self.MiddleBogey.PneumaticBrakeForce = 10000.0
	--self.RearBogey.PneumaticBrakeForce = 10000.0  


	if self.Duewag_U2.ReverserLeverState == 3 or self:ReadTrainWire(6) < 1 then

		if self:GetNW2Bool("DepartureConfirmed",false) == true then





			if self.Duewag_U2.ThrottleState < 0 then
				self.RearBogey.MotorForce  = -59727.24 
				self.FrontBogey.MotorForce = -59727.24
				self:SetNW2Bool("Braking",true)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState > 0 and self:GetNW2Bool("DepartureConfirmed",false) ~=false then 
				self.RearBogey.MotorForce  = 49772.7
				self.FrontBogey.MotorForce = 49772.7 
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState == 0 then 
				self.RearBogey.MotorForce  = 0--199141405525
				self.FrontBogey.MotorForce = 0--199141405525
				self:SetNW2Bool("Braking",false)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Train:GetNW2Bool("DeadmanTripped") == true then
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				self.FrontBogey.BrakeCylinderPressure = 2.7 
				self.MiddleBogey.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self:SetNW2Bool("Braking",true)
			end

		elseif self:GetNW2Bool("DepartureConfirmed",false) == false then
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


		if self:ReadTrainWire(8) ~= 1 then


    		self.FrontBogey.BrakeCylinderPressure = self:ReadTrainWire(5) or 0
			self.MiddleBogey.BrakeCylinderPressure = self:ReadTrainWire(5) or 0
			self.RearBogey.BrakeCylinderPressure = self:ReadTrainWire(5) or 0
		--PrintMessage(HUD_PRINTTALK,self.FrontBogey.Acceleration)
			if self:ReadTrainWire(9) > 0 then
				if self:ReadTrainWire(2) == 0 then
					self.RearBogey.MotorForce  = 49772.7
					self.FrontBogey.MotorForce = 49772.7 
					self:SetNW2Bool("Braking",false)
				elseif self:ReadTrainWire(2) == 1 then 
					self.RearBogey.MotorForce  = -59727.24
					self.FrontBogey.MotorForce = -59727.24
					self:SetNW2Bool("Braking",true)
				end
				self.RearBogey.MotorPower = self:ReadTrainWire(1)
				self.FrontBogey.MotorPower = self:ReadTrainWire(1)
		

				if self:ReadTrainWire(3) == 1 then 
					self.FrontBogey.Reversed = false
					self.RearBogey.Reversed = false 
				elseif self:ReadTrainWire(4) == 1 then
					self.FrontBogey.Reversed = true
					self.RearBogey.Reversed = true
				end
			elseif self:ReadTrainWire(9) < 1 then

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
			self.RearBogey.MotorPower = 0
			self.FrontBogey.MotorPower = 0
			self:SetNW2Bool("Braking",true)

		


		end


	end
	self.FrontBogey.PneumaticBrakeForce = 130000

	
	
end



	 --15000*N / 20  ---(N < 0 and 1 or 0) ------- 1 unit = 110kw / 147hp | Total kW of U2 300kW


	

	--if self:GetNW2Bool("BatteryOn",false) == true or self:ReadTrainWire(7) == 1 then --blinker only works when electricity is on, duh
		if self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 0 then
			self:Blink(true,true,false)
		--self.Blinker = "Left"
		elseif self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 1 then
		self:Blink(true,false,true)
		--self.Blinker = "Right"
		elseif self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 1 then
			self:Blink(true,true,true)
		--self.Blinker = "Warn"
		elseif self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 0 then
			self:Blink(false,false,false)
		--self.Blinker = "Off"
		end
	--end
	
	--print(self.Blinker)


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
	--self:SetNWFloat("ThrottleState",self.ThrottleState)
	--self.Duewag_U2:TriggerInput("ThrottleRate", self.ThrottleRate)
	self:SetNWInt("ThrottleStateAnim", self.Duewag_U2.ThrottleStateAnim)




	---Door control
	if self.CommandClose == true then
		--PrintMessage(HUD_PRINTTALK, "Command to close doors running")
	end
	if self.CommandOpen == true then
		--PrintMessage(HUD_PRINTTALK, "Command to Open doors running")
	end

	if self:GetNW2Bool("DoorsUnlocked") == true and self:GetNWString("DoorSide","none") == "left" then --if the doors are cleared for opening and the side is left

		
		if self:GetNW2Float("Door1-2b",0) <=1 and self:GetNW2Float("Door3-4b",0) <=1 and self:GetNW2Float("Door5-6b",0) <=1 and self:GetNW2Float("Door7-8b",0) <= 1 then --then either of the doors are less than fully opened
			self:SetNW2Bool("DoorsJustOpened",true)
			self.CommandClose = false
			self.CommandOpen = true
			self:SetNWBool("DoorAlarmAlreadyTriggered",false)
			--self:DoorHandler(true,false) --give the command to open the doors
		elseif self:GetNW2Float("Door1-2b",0) >= 1 or self:GetNW2Float("Door3-4b",0) >= 1 or self:GetNW2Float("Door5-6b",0) >= 1 or self:GetNW2Float("Door7-8b",0) >= 1 then --if they're all at 1 then don't do anything anymore
			--self.CommandOpen = false
			--self.CommandClose = false
			--self:SetNW2Bool("DoorsJustOpened",true) --we've just opened the doors. This matters for simulating the departing procedure.
		end
	elseif self:GetNW2Bool("DoorsUnlocked") == true and self:GetNWString("DoorSide","none") == "right" then --same thing for the right side

		if self:GetNW2Float("Door1-2a",0) < 1 and self:GetNW2Float("Door3-4a",0) < 1 and self:GetNW2Float("Door5-6a",0) < 1 and self:GetNW2Float("Door7-8a",0) < 1 then
			self.CommandOpen = true
			--self.CommandClose = false
			self:SetNW2Bool("DoorsJustOpened",true)
		elseif self:GetNW2Float("Door1-2a",0) >= 1 or self:GetNW2Float("Door3-4a",0) >= 1 or self:GetNW2Float("Door5-6a",0) >= 1 or self:GetNW2Float("Door7-8a",0) >= 1 then
			--self.CommandOpen = false
			--self:SetNW2Bool("DoorsJustOpened",true)
		end
	


	elseif self:GetNW2Bool("DoorCloseCommand",false) == true then --if we've just gotten the door close signal
			self.CommandClose = true --set them to close
			self.CommandOpen = false
		if self:GetNW2Float("Door1-2a",0) <=0 and self:GetNW2Float("Door3-4a",0) and self:GetNW2Float("Door5-6a",0) and self:GetNW2Float("Door7-8a",0) <=0 and self:GetNW2Float("Door1-2b",0) <=0 and self:GetNW2Float("Door3-4b",0) <=0 and self:GetNW2Float("Door5-6b",0) and self:GetNW2Float("Door7-8b",0) then --if they're already closed
			--self.CommandOpen = false --stop controlling them
			self.CommandClose = false
			if self:GetNW2Bool("DoorsJustOpened",false) == true then --if they were just open, reset that flag
				self:SetNW2Bool("DoorsJustOpened",false)
				self.CommandClose = false
				self:SetNW2Bool("DoorsJustClosed",true) --say that we just closed the doors
			end
		end
	end
	--math.Clamp(self.DoorState,0,1)

	if self:GetNW2Bool("DoorsJustClosed",false) == true then --if all doors are closed
		if self:GetNWBool("DoorAlarmAlreadyTriggered",false) == false then
			self:SetNWBool("DoorAlarmAlreadyTriggered",true)
			self:SetNW2Bool("DoorAlarm",true) --set off the door closed confirmation
		end
	else
		--self:SetNW2Bool("DoorAlarm",false) --don't set it off yet if above condition isn't true, either not closed yet or confirmed departure button
	end

	--print(self:GetNW2Float("Door1-2a",0))
	--print(self:GetNW2Float("Door1-2b",0))

	--TEMPORARY

	if self.DoorSideUnlocked == "Left" then



		if self.CommandOpen == true and self.CommandClose == false then
	
			
	
					
	
			if self.DoorRandomness1 > 0 then
	
				
					if self:GetNW2Float("Door1-2b",0) <= 1 then -- If state less than 1, open them
	
						if self:GetNW2Float("Door1-2b",0) != 1 then
							self.DoorState1 = self:GetNW2Float("Door1-2b",0) + 0.1
							self.DoorState1 = math.Clamp(self.DoorState1,0,1)
							self:SetNW2Float("Door1-2b",self.DoorState1)
							
						end
					elseif self:GetNW2Float("Door1-2b",0) >= 1 then
						self:SetNW2Float("Door1-2b",1)
					end
			end
	
			if self.DoorRandomness2 > 0 then
	
				
				if self:GetNW2Float("Door3-4b",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door3-4b",0) != 1 then
						self.DoorState2 = self:GetNW2Float("Door3-4b",0) + 0.1
						self.DoorState2 = math.Clamp(self.DoorState2,0,1)
						self:SetNW2Float("Door3-4b",self.DoorState2)
						
					end
				elseif self:GetNW2Float("Door3-4b",0) >= 1 then
					self:SetNW2Float("Door3-4b",1)
				end
			end
	
			if self.DoorRandomness3 > 0 then
	
				
				if self:GetNW2Float("Door5-6b",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door5-6b",0) != 1 then
						self.DoorState2 = self:GetNW2Float("Door5-6b",0) + 0.1
						self.DoorState2 = math.Clamp(self.DoorState2,0,1)
						self:SetNW2Float("Door5-6b",self.DoorState2)
						
					end
				elseif self:GetNW2Float("Door5-6b",0) >= 1 then
					self:SetNW2Float("Door5-6b",1)
				end
			end
	
			if self.DoorRandomness4 > 0 then
	
				
				if self:GetNW2Float("Door7-8b",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door7-8b",0) != 1 then
						self.DoorState2 = self:GetNW2Float("Door7-8b",0) + 0.1
						self.DoorState2 = math.Clamp(self.DoorState2,0,1)
						self:SetNW2Float("Door7-8b",self.DoorState2)
						
					end
				elseif self:GetNW2Float("Door7-8b",0) >= 1 then
					self:SetNW2Float("Door7-8b",1)
				end
			end
	
		end
	
		if self.CommandClose == true and self.CommandOpen == false then
	
				
				
	
				
					if self:GetNW2Float("Door1-2b",0) > 0 then -- If state 1, close them
	
						if self:GetNW2Float("Door1-2b",0) != 0 then
							self.DoorState1 = self:GetNW2Float("Door1-2b",0) - 0.1
							self.DoorState1 = math.Clamp(self.DoorState1,0,1)
							self:SetNW2Float("Door1-2b",self.DoorState1)
						end
					elseif self:GetNW2Float("Door1-2b",0) <= 0 then
						self:SetNW2Float("Door1-2b",0)
					end
				
			
	
				
	
				
					if self:GetNW2Float("Door3-4b",0) > 0 then -- If state 1, close them
	
						if self:GetNW2Float("Door3-4b",0) != 0 then
							self.DoorState2 = self:GetNW2Float("Door3-4b",0) - 0.1
							self.DoorState2 = math.Clamp(self.DoorState2,0,1)
							self:SetNW2Float("Door3-4b",self.DoorState2)
						end
					elseif self:GetNW2Float("Door3-4b",0) <= 0 then
						self:SetNW2Float("Door3-4b",1)
					end
				
	
				
	
				
					if self:GetNW2Float("Door5-6b",0) > 0 then -- If state less than 1, open them
	
						if self:GetNW2Float("Door5-6b",0) != 0 then
							self.DoorState2 = self:GetNW2Float("Door5-6b",0) - 0.1
							self.DoorState2 = math.Clamp(self.DoorState2,0,1)
							self:SetNW2Float("Door5-6b",self.DoorState2)
							
						end
					elseif self:GetNW2Float("Door5-6b",0) <= 0 then
						self:SetNW2Float("Door5-6b",1)
					end
				
	
				
	
				
					if self:GetNW2Float("Door7-8b",0) > 0 then -- If state less than 1, open them
	
						if self:GetNW2Float("Door7-8b",0) != 0 then
							self.DoorState2 = self:GetNW2Float("Door7-8b",0) - 0.1
							self.DoorState2 = math.Clamp(self.DoorState2,0,1)
							self:SetNW2Float("Door7-8b",self.DoorState2)
							
						end
					elseif self:GetNW2Float("Door7-8b",0) <= 0 then
						self:SetNW2Float("Door7-8b",0)
					end
				
			
	
		end
	end
	
	if self.DoorSideUnlocked == "Right" then
	
	
			
	
	
		if self.CommandOpen == true and self.CommandClose == false then
	
			
	
					
	
			if self.DoorRandomness1 > 0 then
	
				
					if self:GetNW2Float("Door1-2a",0) <= 1 then -- If state less than 1, open them
	
						if self:GetNW2Float("Door1-2a",0) != 1 then
							self.DoorState1 = self:GetNW2Float("Door1-2a",0) + 0.1
							self.DoorState1 = math.Clamp(self.DoorState1,0,1)
							self:SetNW2Float("Door1-2a",self.DoorState1)
							
						end
					elseif self:GetNW2Float("Door1-2a",0) >= 1 then
						--self:SetNW2Float("Door1-2a",1)
						PrintMessage(HUD_PRINTTALK, "Door1-2a open")
						
					end
			end
	
			if self.DoorRandomness2 > 0 then
	
				
				if self:GetNW2Float("Door3-4a",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door3-4a",0) != 1 then
						self.DoorState2 = self:GetNW2Float("Door3-4a",0) + 0.1
						self.DoorState2 = math.Clamp(self.DoorState2,0,1)
						self:SetNW2Float("Door3-4a",self.DoorState2)
						
					end
				elseif self:GetNW2Float("Door3-4a",0) >= 1 then
					--self:SetNW2Float("Door3-4a",1)
					PrintMessage(HUD_PRINTTALK, "Door3-4a open")
					
				end
			end
	
			if self.DoorRandomness3 > 0 then
	
				
				if self:GetNW2Float("Door5-6a",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door5-6a",0) != 1 then
						self.DoorState3 = self:GetNW2Float("Door5-6a",0) + 0.1
						self.DoorState3 = math.Clamp(self.DoorState3,0,1)
						self:SetNW2Float("Door5-6a",self.DoorState3)
						
					end
				elseif self:GetNW2Float("Door5-6a",0) >= 1 then
					--self:SetNW2Float("Door5-6a",1)
					PrintMessage(HUD_PRINTTALK, "Door5-6a open")
					
				end
			end
	
			if self.DoorRandomness4 > 0 then
	
				
				if self:GetNW2Float("Door7-8a",0) <= 1 then -- If state less than 1, open them
	
					if self:GetNW2Float("Door7-8a",0) != 1 then
						self.DoorState4 = self:GetNW2Float("Door7-8a",0) + 0.1
						self.DoorState4 = math.Clamp(self.DoorState4,0,1)
						self:SetNW2Float("Door7-8a",self.DoorState4)
						
					end
				elseif self:GetNW2Float("Door7-8a",0) >= 1 then
					--self:SetNW2Float("Door7-8a",1)
					PrintMessage(HUD_PRINTTALK, "Door7-8a open")
					
				end
			end
	
		end
	
		if self.CommandClose == true and self.CommandOpen == false then
	
				
				
	
				
					if self:GetNW2Float("Door1-2a",0) > 0 then -- If state less than 1, open them
	
						--if self:GetNW2Float("Door1-2a",0) != 0 then
							self.DoorState1 = self:GetNW2Float("Door1-2a",0) - 0.1
							self.DoorState1 = math.Clamp(self.DoorState1,0,1)
							self:SetNW2Float("Door1-2a",self.DoorState1)
							print("Door1-2a")
							print(self.DoorState1)
						--end
					elseif self:GetNW2Float("Door1-2a",0) < 0 then
						--self:SetNW2Float("Door1-2a",0)
					end
			
	
				
	
				
					if self:GetNW2Float("Door3-4a",0) > 0 then -- If state less than 1, open them
	
						--if self:GetNW2Float("Door3-4a",0) != 0 then
							self.DoorState2 = self:GetNW2Float("Door3-4a",0) - 0.1
							self.DoorState2 = math.Clamp(self.DoorState2,0,1)
							self:SetNW2Float("Door3-4a",self.DoorState2)
							print("Door3-4a")
							print(self.DoorState2)
							
						--end
					elseif self:GetNW2Float("Door3-4a",0) < 0 then
						--self:SetNW2Float("Door3-4a",0)
					end
				
	
				
	
				
					if self:GetNW2Float("Door5-6a",0) > 0 then -- If state less than 1, open them
	
						--if self:GetNW2Float("Door5-6a",0) != 0 then
							self.DoorState3 = self:GetNW2Float("Door5-6a",0) - 0.1
							self.DoorState3 = math.Clamp(self.DoorState3,0,1)
							self:SetNW2Float("Door5-6a",self.DoorState3)
							
						--end
					elseif self:GetNW2Float("Door5-6a",0) < 0 then
						--self:SetNW2Float("Door5-6a",0)
						
					end
				
	
				
	
				
					if self:GetNW2Float("Door7-8a",0) > 0 then -- If state less than 1, open them
	
						--if self:GetNW2Float("Door7-8a",0) != 0 then
							self.DoorState4 = self:GetNW2Float("Door7-8a",0) - 0.1
							self.DoorState4 = math.Clamp(self.DoorState4,0,1)
							self:SetNW2Float("Door7-8a",self.DoorState4)
							
						--end
					elseif self:GetNW2Float("Door7-8a",0) < 0 then
						--self:SetNW2Float("Door7-8a",0)
						
					end
				
				
	
		end
	end
	
end




function ENT:OnButtonPress(button,ply)

	
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.Duewag_U2.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.Duewag_U2.ThrottleRate = -3 end
	end

	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.Duewag_U2.ThrottleRate = 5.5 end
		if button == "ThrottleDownFast" then self.Duewag_U2.ThrottleRate = -5.5  end
		
	end

	if self.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleZero" then self.Duewag_U2.ThrottleState = 0 end
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

	
	if self.RollsignModifierRate == 0 then
		
		if button == "Rollsign+" then
			if self.ScrollMomentRecorded == false then
				self.ScrollMomentRecorded = true
				self.ScrollMoment = CurTime()
			end
			self.RollsignModifierRate = 0.01
		end
		if button == "Rollsign-" then
			if self.ScrollMomentRecorded == false then
				self.ScrollMomentRecorded = true
				self.ScrollMoment = CurTime()
			end
			self.RollsignModifierRate = -0.01
		end
	end

	
	
	if button == "CabWindowR+" then
		
			self.CabWindowR = self.CabWindowR - 0.1
			--print(self:GetNW2Float("CabWindowR"))
		
	end

	if button == "CabWindowR-" then
		
			self.CabWindowR = self.CabWindowR + 0.1
			--print(self:GetNW2Float("CabWindowR"))
		
	end

	if button == "CabWindowL+" then
			self.CabWindowL = self.CabWindowL - 0.1
			--print(self:GetNW2Float("CabWindowL"))
		
	end

	if button == "CabWindowL-" then
		
			self.CabWindowL = self.CabWindowL + 0.1
			--print(self:GetNW2Float("CabWindowL"))
		
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
		if self.BatteryOn == false and self.Duewag_U2.ReverserLeverState == 1 then
			self.BatteryOn = true
			
			self.Duewag_Battery:TriggerInput("Charge",1.3)
			self:SetNW2Bool("BatteryOn",true)
			--PrintMessage(HUD_PRINTTALK, "Battery switch is ON")
		end
		self:SetNW2Bool("BatteryToggleIsTouched",true)
		self:SetNW2Bool("BatteryToggleOn",true)
	end

	if button == "BatteryDisableToggle" then
		if self.BatteryOn == true and self.Duewag_U2.ReverserLeverState == 1 then
			self.BatteryOn = false
			self.Duewag_Battery:TriggerInput("Charge",1.3)
			self:SetNW2Bool("BatteryOn",true)
			PrintMessage(HUD_PRINTTALK, "Battery switch is off")
			--self:SetNW2Bool("BatteryToggleIsTouched",true)
			
		end
		self:SetNW2Bool("BatteryToggleIsTouched",true)
		self:SetNW2Bool("BatteryToggleOff",true)
			
	end
	
	
	if button == "DeadmanSet" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 1)
			--print("DeadmanPressedYes")
	end
	

	if button == "BlinkerLeftToggle" then

		if self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 1 then -- If you press the button and the blinkers are already set to right, do nothing
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
		elseif
		self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 0 then -- If you press the button and the blinkers are off, set to left
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
			self:SetNW2String("BlinkerDirection","left")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 0 then -- If you press the button and the blinkers are already on, turn them off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
			self:SetNW2String("BlinkerDirection","none")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 1 then
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)
		end
	end


	if button == "BlinkerRightToggle" then

		if self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 1 then -- If you press the button and the blinkers are already set to right, turn them off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
			self:SetNW2String("BlinkerDirection","none")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 0 then -- If you press the button and the blinkers are already set to left, do nothing
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
		elseif
		self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 0 then
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
			self:SetNW2String("BlinkerDirection","right")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 1 then
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
		if self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 0 and self:ReadTrainWire(20) ~= 1 or self:ReadTrainWire(21) ~= 1 then
			self:SetNW2Bool("WarningBlinker",true)
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 1 then
				self:SetNW2Bool("WarningBlinker",false)
				self:WriteTrainWire(20,0)
				self:WriteTrainWire(21,0)
		end
	end
	



	if button == "DestinationSet" then
		self.IBIS:Trigger("Destination")
	end


	if button == "Number0Set" then
		self.IBIS:Trigger("Number0")
	end

	if button == "Number1Set" then
		self.IBIS:Trigger("Number1")
	end
	if button == "Number2Set" then
		self.IBIS:Trigger("Number2")
	end
	if button == "Number3Set" then
		self.IBIS:Trigger("Number3")
	end
	if button == "Number4Set" then
		self.IBIS:Trigger("Number4")
	end
	if button == "Number5Set" then
		self.IBIS:Trigger("Number5")
	end
	if button == "Number6Set" then
		self.IBIS:Trigger("Number6")
	end
	if button == "Number7Set" then
		self.IBIS:Trigger("Number7")
	end
	if button == "Number8Set" then
		self.IBIS:Trigger("Number8")
	end
	if button == "Number9Set" then
		self.IBIS:Trigger("Number9")
	end
	if button == "EnterSet" then
		self.IBIS:Trigger("Enter")
	end

	if button == "ThrowCouplerSet" then
		if self:ReadTrainWire(5) > 1 and self.Duewag_U2.Speed < 1 then
			self.FrontCouple:Decouple()
		end
	end

	if button == "DriverLightToggle" then

		if self:GetNW2Bool("Cablight",false) == false then
			self:SetNW2Bool("Cablight",true)
		elseif self:GetNW2Bool("Cablight",false) == true then
			self:SetNW2Bool("Cablight",false)
		end
	end
	if button == "LightsToggle" then
		if self:GetNW2Bool("HeadlightsSwitch",false) == false then
			self:SetNW2Bool("HeadlightsSwitch",true)
		elseif self:GetNW2Bool("HeadlightsSwitch",false) == true then
			self:SetNW2Bool("HeadlightsSwitch",false)
		end
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

	

	if button == "DoorsLockSet" then

		if self:GetNW2Bool("DoorsUnlocked",false) == true then
			self:SetNW2Bool("DoorsUnlocked",false)
			self:SetNW2Bool("DoorCloseCommand",true)
		end
	end

	if button == "Button1a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness1 == 0 then
				self.DoorRandomness1 = 1
			end
		end
	end

	if button == "Button2a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness1 == 0 then
				self.DoorRandomness1 = 1
			end
		end
	end

	if button == "Button3a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness2 == 0 then
				self.DoorRandomness2 = 1
			end
		end
	end

	if button == "Button4a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness2 == 0 then
				self.DoorRandomness2 = 1
			end
		end
	end

	--[[if button == "Button5b" or "Button6b" then
		if self.DoorSideUnlocked == "Left" then
			if self.DoorRandomness1 == 0 then
				self.DoorRandomness1 = 1
			end
		end
	end

	if button == "Button3b" or "Button4b" then
		if self.DoorRandomness2 == 0 then
			self.DoorRandomness2 = 1
		end
	end]]


	if button == "DoorsCloseConfirmSet" then

		self:SetNW2Bool("DoorCloseCommand",false)
		self:SetNW2Bool("DepartureConfirmed",true)
		if self:GetNW2Bool("DoorAlarm",false) == true then
			self:SetNW2Bool("DoorAlarm",false)
			
		end
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
end


function ENT:OnButtonRelease(button,ply)
			if (button == "ThrottleUp" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDown" and self.Duewag_U2.ThrottleRate < 0) then
				self.Duewag_U2.ThrottleRate = 0
			end
			if (button == "ThrottleUpFast" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDownFast" and self.Duewag_U2.ThrottleRate < 0) then
				self.Duewag_U2.ThrottleRate = 0
			end

			if button == "Rollsign+" then
				self.ScrollMomentRecorded = false
				self.RollsignModifierRate = 0
			end
			if button == "Rollsign-" then
				self.RollsignModifierRate = 0
				self.ScrollMomentRecorded = false
			end
		
			if button == "BatteryToggle" then
				self:SetNW2Bool("BatteryToggleIsTouched",false)
				self:SetNW2Bool("BatteryToggleOn",false)
			end

			if button == "BatteryDisableToggle" then
				self:SetNW2Bool("BatteryToggleIsTouched",false)
			
				self:SetNW2Bool("BatteryToggleOff",false)
			end

			if button == "DoorsUnlockSet"  then
		
				if self:GetNW2Bool("DoorsUnlocked",false) == false then
		
		
		
						self:SetNW2Bool("DoorsUnlocked",true)
						self:SetNW2Bool("DepartureConfirmed",false)
						self:SetNW2Bool("DoorCloseCommand",false)
						if self:GetNW2Bool("DoorRandomnessSet",false) == false then
							self:SetNW2Bool("DoorRandomnessSet",true)
							self.DoorRandomness1 = math.random(0,1)
							self.DoorRandomness2 = math.random(0,1)
							self.DoorRandomness3 = math.random(0,2)
							self.DoorRandomness4 = math.random(0,2)

						--PrintMessage(HUD_PRINTTALK,self.DoorRandomness1)
						--PrintMessage(HUD_PRINTTALK,self.DoorRandomness2)
						end
					
				end
			end

			if button == "DoorsLockSet"  then
		
				--if self:GetNW2Bool("DoorsUnlocked",false) == true then
		
		
		
						--[[self:SetNW2Bool("DoorsUnlocked",true)
						self:SetNW2Bool("DepartureConfirmed",false)
						self:SetNW2Bool("DoorCloseCommand",false)]]
						self.DoorRandomness1 = 0
						self.DoorRandomness2 = 0
						self.DoorRandomness3 = 0
						self.DoorRandomness4 = 0
						self:SetNW2Bool("DoorRandomnessSet",false)
					
					
				--end
			end
		
		if button == "DeadmanSet" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 0)
			--print("DeadmanPressedNo")
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

		--[[if button == "BatteryToggle" then
			if self:GetNW2Bool("BatteryOn",false) == false then
			self:SetNW2Int("Startup",CurTime())
				if self:GetNW2Bool("BatteryButton",false) == false then
					self:SetNW2Bool("BatteryButton",true)
				elseif self:GetNW2Bool("BatteryButton",false) == true then
					self:SetNW2Bool("BatteryButton",false)
					if self:GetNW2Bool("BatteryOn",false) == false then
						self:SetNW2Bool("IBISPlayed",false)
						self:SetNW2Bool("StartupPlayed",false)
					end
				end
			end
			
		end]]
		if button == "ComplaintSet" then
			self:SetNW2Bool("Microphone",false)
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
	
	constraint.Axis(
		u2sectionb,
		self.MiddleBogey,
		0, --bone
		0, --bone
		Vector(0,0,0),
		Vector(0,0,-0.4),
		0, --forcelimit
		0, --torquelimit
		0,
		1 --nocollide
	)
	
	constraint.NoCollide(self.MiddleBogey,u2sectionb,0,0)
	-- Add to cleanup list
	table.insert(self.TrainEntities,u2sectionb)
	return u2sectionb
end

function ENT:Blink(enable, left, right)


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
	self.u2sectionb.BlinkerRight = self.BlinkerOn and right

	if self.BlinkerOn and left and right then
		self:SetLightPower(56,self.BlinkerOn and left)
		self:SetLightPower(57,self.BlinkerOn and right)
	end


	self:SetNW2Bool("BlinkerTick",self.BlinkerOn) --one tick sound for the blinker relay

end

function ENT:DoorHandler(CommandOpen,CommandClose)
end


	

