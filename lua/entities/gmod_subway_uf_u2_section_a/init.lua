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

function ENT:CreateBogeyUFInt(pos,ang,forward,typ)
    -- Create bogey entity
    local bogey = ents.Create("gmod_train_uf_bogey_int")
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
        elseif not forward and IsValid(self.MiddleBogey) then
            constraint.NoCollide(self.MiddleBogey,coupler,0,0)
        end
        
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,coupler)
    return coupler
end

ENT.BogeyDistance = 1100


ENT.SyncTable = { "speed", "ThrottleState", "Drive", "Brake","Reverse","BellEngage","Horn","WarningAnnouncement", "PantoUp", "BatteryOn", "KeyTurnOn", "BlinkerState", "StationBrakeOn", "StationBrakeOff"}


function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2h.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,20))  --set to 200 if one unit spawns in ground
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(395,15,34))
	self.InstructorsSeat = self:CreateSeat("instructor",Vector(395,-20,30),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
	--self.HelperSeat = self:CreateSeat("instructor",Vector(505,-25,55))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))
	self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.InstructorsSeat:SetColor(Color(0,0,0,0))
	self.Debug = 1
	self.CabEnabled = false
	self.LeadingCab = 0
	
	self.WarningAnnouncement = 0
	
	self.Speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserLeverState = 0
	self.ReverserEnaged = 0
	self.ChopperJump = 0
	self.BrakePressure = 0
	self.ThrottleRate = 0
	self.MotorPower = 0

	self.LastDoorTick = 0

	self.WagonNumber = 303

	self.Haltebremse = 0

	self.AlarmSound = 0
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector( 300,0,0),Angle(0,180,0),true,"duewag_motor")
    self.MiddleBogey  = self:CreateBogeyUF(Vector(0,0,-1),Angle(0,0,0),false,"u2joint")
    

	-- Create couples
    self.FrontCouple = self:CreateCoupleUF(Vector( 415,0,2),Angle(0,0,0),true,"u2")	
    
	self.DoorStates = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}
	
	-- Create U2 Section B
	self.u2sectionb = self:CreateSectionB(Vector(-770,0,-0))
	self.RearBogey = self.u2sectionb.RearBogey
	self.RearCouple = self.u2sectionb.RearCouple --self:CreateCoupleUF(Vector( 100,50,50),Angle(0,0,0),false,"U2")	
	
	
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

	self.BlinkerOn = false
	self.BlinkerLeft = false
	self.BlinkerRight = false
	self.Blinker = "Off"
	self.LastTriggerTime = 0

	

	self:SetNW2Bool("DepartureConfirmed",true)
	self:SetNW2Bool("DoorsUnlocked",false)
	--self.SetNW2String("DoorsSideUnlocked","None")

	self.DoorState = 0

	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUpSet",
		[KEY_D] = "ThrottleDownSet",
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
							[KEY_COMMA] = "BlinkerRightToggle",},
							
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


	self.Lights = {
	[50] = { "light",Vector(406,39,98), Angle(90,0,0), Color(227,197,160),     brightness = 0.5, scale = 0.5, texture = "sprites/light_glow02.vmt" }, --cab light
	[51] = { "light",Vector(430,40,28), Angle(0,0,0), Color(227,197,160),     brightness = 0.5, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight left
	[52] = { "light",Vector(430,-40,28), Angle(0,0,0), Color(227,197,160),     brightness = 0.5, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight right
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
	[33] = { "light",Vector(83,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 4
}


	self.TrainWireCrossConnections = {
        --[3] = 4, -- Reverser F<->B
		--[21] = 20,

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











function ENT:Think(dT)
	self.BaseClass.Think(self)
    
	
	self.u2sectionb:TrainSpawnerUpdate()
	--self:SetNW2Entity("U2a",self)

	--PrintMessage(HUD_PRINTTALK, self:GetNW2String("Texture"))
	if self:ReadTrainWire(7) == 1 then
		self:SetNW2Bool("BatteryOn",true)

	elseif self:ReadTrainWire(7) == 0 then
		self:SetNW2Bool("BatteryOn",false)
	end
	self:SetNW2Bool("PantoUp",self.PantoUp)
	self:SetNW2Bool("ReverserInserted",self.ReverserInsert)

	if self:ReadTrainWire(1) > 0 then
		self:SetNW2Bool("Fans",true)
	elseif self:ReadTrainWire(1) == 0  then
		self:SetNW2Bool("Fans",false)
	end
	

	self.Speed = math.abs(self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Float("Speed",self.Speed)
	self.Duewag_U2:TriggerInput("Speed",self.Speed*150)
 
	--PrintMessage(HUD_PRINTTALK,"Current Speed")
	--PrintMessage(HUD_PRINTTALK,self.Speed)

	
	
	

	if self.FrontCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("AIsCoupled", true)
	else
		self:SetNW2Bool("AIsCoupled",false)
	end
	
	self:SetNW2Float("BatteryCharge",self.Duewag_Battery.Voltage)

	
	if self:GetNW2Bool("Cablight",false) == true --[[self:GetNW2Bool("BatteryOn",false) == true]] then
        self:SetLightPower(50,true)
    elseif self:GetNW2Bool("Cablight",false) == false then
        self:SetLightPower(50,false)
    end


	if self.BatteryOn == true then
	self:SetNW2Bool("BatteryOn",true)
		if self.Duewag_U2.ReverserLeverState == 2 then
			self:WriteTrainWire(7,1)
		end
	elseif self.BatteryOn == false then
	self:SetNW2Bool("BatteryOn",false)
		if self.Duewag_U2.ReverserLeverState == 2 then
			self:WriteTrainWire(7,1)
		end
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
	
	
	
	
 	if self:GetNW2Bool("DoorsUnlocked",false) == true  then

		if self:GetNWString("DoorSide","none") == "left" then
			self:SetLightPower(30,true)
			self:SetLightPower(31,true)
			self:SetLightPower(32,true)
			self:SetLightPower(33,true)
		else
			self:SetLightPower(30,false)
			self:SetLightPower(31,false)
			self:SetLightPower(32,false)
			self:SetLightPower(33,false)
		end

		if self:GetNWString("DoorSide","none") == "left" and self.DoorState == 1 then
			self.LeftDoorsOpen = true
			self.RightDoorsOpen = false
			
		elseif self:GetNWString("DoorSide","none") == "none" then
		self.LeftDoorsOpen = false
		self.RightDoorsOpen = false
		
		elseif self:GetNWString("DoorSide","none") == "right" and self.DoorState == 1 then
			self.LeftDoorsOpen = false
			self.RightDoorsOpen = true
			
		end
	else 
		self.LeftDoorsOpen = false
		self.RightDoorsOpen = false
		
	end
	
	
	
	
if IsValid(self.FrontBogey) and IsValid(self.MiddleBogey) and IsValid(self.RearBogey) then
	
	
	self.FrontBogey.PneumaticBrakeForce = 10000.0
	self.MiddleBogey.PneumaticBrakeForce = 10000.0
	self.RearBogey.PneumaticBrakeForce = 10000.0  


	if self.Duewag_U2.ReverserLeverState == 3 or self:ReadTrainWire(6) < 1 then

		if self:GetNW2Bool("DepartureConfirmed",false) == true then





			if self.Duewag_U2.ThrottleState < 0 then
				self.RearBogey.MotorForce  = -20000 
				self.FrontBogey.MotorForce = -20000
				self:SetNW2Bool("Braking",true)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState > 0 and self:GetNW2Bool("DepartureConfirmed",false) ~=false then 
				self.RearBogey.MotorForce  = 20000
				self.FrontBogey.MotorForce = 20000
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self:GetNW2Bool("Speedlimiter",false) == true then 
				self.RearBogey.MotorForce  = -20000
				self.FrontBogey.MotorForce = -20000
				self:SetNW2Bool("Braking",true)
				self.RearBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.MotorPower = self.Duewag_U2.Traction
				self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure 
				self.MiddleBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
				self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
			elseif self.Duewag_U2.ThrottleState == 0 then 
				self.RearBogey.MotorForce  = 20000
				self.FrontBogey.MotorForce = 20000
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


		elseif self:GetNW2Bool("DepartureConfirmed",false) == false then
			self.FrontBogey.BrakeCylinderPressure = 2.7
			self.MiddleBogey.BrakeCylinderPressure = 2.7
			self.RearBogey.BrakeCylinderPressure = 2.7
			self.RearBogey.MotorPower = 0
			self.FrontBogey.MotorPower = 0
			self:SetNW2Bool("Braking",true)
			end
		

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
		
			if self:ReadTrainWire(9) > 0 then
				if self:ReadTrainWire(2) == 0 then
					self.RearBogey.MotorForce  = 20000
					self.FrontBogey.MotorForce = 20000
					self:SetNW2Bool("Braking",false)
				elseif self:ReadTrainWire(2) == 1 then 
					self.RearBogey.MotorForce  = -20000 
					self.FrontBogey.MotorForce = -20000
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

		

	end
	
	--PrintMessage(HUD_PRINTTALK, self:ReadTrainWire(1))
	--PrintMessage(HUD_PRINTTALK,#self.WagonList)

	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	--self:SetNWFloat("ThrottleState",self.ThrottleState)
	--self.Duewag_U2:TriggerInput("ThrottleRate", self.ThrottleRate)
	self:SetNWInt("ThrottleStateAnim", self.Duewag_U2.ThrottleStateAnim)



	---Door control

	if self:GetNW2Bool("DoorsUnlocked") == true then
		if self.DoorState <= 1 then
			self:DoorHandler(true,false)
			math.Clamp(self.DoorState,0,1)
			
			--PrintMessage(HUD_PRINTTALK, self.DoorState)
		elseif self.DoorState == 1 then
			self:DoorHandler(false,false)
			math.Clamp(self.DoorSate,0,1)
			self:SetNW2Bool("DoorsJustOpened",true)
		end
	elseif self:GetNW2Bool("DoorsUnlocked") == false then
		if self.DoorState >= 0 then
			self:DoorHandler(false,true)
			math.Clamp(self.DoorState,0,1)
		elseif self.DoorState <= 0 then
			self:DoorHandler(false,false)
			math.Clamp(self.DoorState,0,1)
			if self:GetNW2Bool("DoorsJustOpened",false) == true then
				self:SetNW2Bool("DoorsJustOpened",false)
				self:SetNW2Bool("DoorsJustClosed",true)
			end
		end
	end
	math.Clamp(self.DoorState,0,1)

	if self:GetNW2Bool("DoorCloseCommand",false) == true then
		self:SetNW2Bool("DoorAlarm",true)

	else
		self:SetNW2Bool("DoorAlarm",false)
	end
	
end





function ENT:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time

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
	
	if button == "WarningAnnouncementSet" then
			--self:Wait(1)
			self:SetNW2Bool("WarningAnnouncement", true)
	end

	
	if button == "ReverserUpSet" then
			if 
				not self.Duewag_U2.ThrottleEngaged == true  then
					if self.Duewag_U2.ReverserInserted == true then
						self.Duewag_U2.ReverserLeverState = self.Duewag_U2.ReverserLeverState + 1
						self.Duewag_U2.ReverserLeverState = math.Clamp(self.Duewag_U2.ReverserLeverState, -1, 3)
						--self.Duewag_U2:TriggerInput("ReverserLeverState",self.ReverserLeverState)
						PrintMessage(HUD_PRINTTALK,self.Duewag_U2.ReverserLeverState)
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
				PrintMessage(HUD_PRINTTALK,self.Duewag_U2.ReverserLeverState)
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
			PrintMessage(HUD_PRINTTALK, "Battery switch is ON")

			
			
			local delay
			local startMoment
			delay = 15
			
			startMoment = CurTime()
			if startMoment - 15 > 15 then
				self:SetNW2Bool("IBIS_impulse",true)
			end
			


			elseif  self.BatteryOn == true and self.Duewag_U2.ReverserLeverState == 1 then
				self.BatteryOn = false
				self:SetNW2Bool("BatteryOn",false)
				PrintMessage(HUD_PRINTTALK, "Battery switch is OFF")
				self.Duewag_Battery:TriggerInput("Charge",0)
			
		end
			
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
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 0 then -- If you press the button and the blinkers are already on, turn them off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
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
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) == 0 then -- If you press the button and the blinkers are already set to left, do nothing
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
		elseif
		self:ReadTrainWire(20) == 0 and self:ReadTrainWire(21) == 0 then
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
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

	if button == "DoorsUnlockSet" then
		
		if self:GetNW2Bool("DoorsUnlocked",false) == false then
			self:SetNW2Bool("DoorsUnlocked",true)
			self:SetNW2Bool("DepartureConfirmed",false)
			self:SetNW2Bool("DoorCloseCommand",false)
		end
	end

	if button == "DoorsLockSet" then

		if self:GetNW2Bool("DoorsUnlocked",false) == true then
			self:SetNW2Bool("DoorsUnlocked",false)
			self:SetNW2Bool("DoorCloseCommand",true)
		end
	end

	if button == "DoorsCloseConfirmSet" then

		self:SetNW2Bool("DoorCloseCommand",false)
		self:SetNW2Bool("DepartureConfirmed",true)
		if self:GetNW2Bool("DoorsClosedAlarm",false) == true then
			self:SetNW2Bool("DoorsClosedAlarm",false)
			
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
			PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString("DoorSide","none") == "none" then
			self:SetNWString("DoorSide","left")
			PrintMessage(HUD_PRINTTALK, "Door switch position left")
		end
	end

	if button == "DoorsSelectRightToggle" then
		if self:GetNWString("DoorSide","none") == "left" then
			self:SetNWString("DoorSide","none")
			PrintMessage(HUD_PRINTTALK, "Door switch position neutral")
		elseif self:GetNWString("DoorSide","none") == "none" then
			self:SetNWString("DoorSide","right")
			PrintMessage(HUD_PRINTTALK, "Door switch position right")
		end
	end
end


function ENT:OnButtonRelease(button,ply)
			if (button == "ThrottleUp" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDown" and self.Duewag_U2.ThrottleRate < 0) then
				self.Duewag_U2.ThrottleRate = 0
			end
			if (button == "ThrottleUpFast" and self.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDownFast" and self.Duewag_U2.ThrottleRate < 0) then
				self.Duewag_U2.ThrottleRate = 0
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
		self,
		0, --bone
		0, --bone
		Vector(0,0,0),
		Vector(0,0,0),
		0, --forcelimit
		0, --torquelimit
		xmin, --xmin
		0, --ymin
		-50, --zmin
		xmax, --xmax
		0, --ymax
		50, --zmax
		0, --xfric
		0, --yfric
		0, --zfric
		0, --rotonly
		1 --nocollide
	)
	
	
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


	self:SetNW2Bool("BlinkerTick",self.BlinkerOn) --one tick sound for the blinker relay

end

function ENT:DoorHandler(CommandOpen,CommandClose,State)

	--State = self.DoorState

	if CommandOpen == true and CommandClose == false then

			
			--print("DoorsOpening")
			--if State > 0 then return end -- State == 1 means Doors fully open, do nothing
			if self.DoorState <= 1 then -- If state less than 1, open them
				if self.DoorState != 1 then
				--if CurTime() == self.LastDoorTick + 1 then -- Every second, we check if a second has passed
					--print("Ticking door state +")
					self.DoorState = self.DoorState + 0.1 --A second has passed, so add a little to the door status register. How much added will be adjusted to properly drive the door animation.
					self.DoorState = math.Clamp(self.DoorState, 0, 1) --Just to be sure it doesn't go past scope
					self.LastDoorTick = CurTime()
				end
			elseif self.DoorState >= 1 then
				self.DoorState = 1
			end
			--print(self.DoorState)
	else

	end

	if CommandClose == true and CommandOpen == false then
		-- now we reverse the whole dance
		--print("DoorsClosing")
		--if State <= 0 then return end -- State == 1 means Doors fully open, do nothing
		if self.DoorState > 0 then -- If state less than 1, close them
			--if CurTime() == self.LastDoorTick + 1 then -- Every second, we check if a second has passed
				--print("Ticking door state -")
				self.DoorState = self.DoorState - 0.1 --A second has passed, so add a little to the door status register. How much added will be adjusted to properly drive the door animation.
				self.DoorState = math.Clamp(self.DoorState,0,1)
				self.LastDoorTick = CurTime()
				
			--end
		elseif self.DoorState <= 0 then
			self.DorState = 0
		end
	else
	end

	--self.DoorState = State

	--print(self.DoorState)

end