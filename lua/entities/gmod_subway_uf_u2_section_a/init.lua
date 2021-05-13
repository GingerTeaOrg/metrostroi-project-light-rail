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
        elseif not forward and IsValid(self.RearBogey) then
            constraint.NoCollide(self.RearBogey,coupler,0,0)
        end
        
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,coupler)
    return coupler
end


ENT.SyncTable = { "speed", "ThrottleState", "Drive", "Brake","Reverse","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOn", "KeyTurnOn", "BlinkerState", "StationBrakeOn", "StationBrakeOff"}


function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2h.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,000))  --set to 200 if one unit spawns in ground
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(500,14,55))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))
	
	self.Debug = 1
	self.CabEnabled = 1
	
	self.speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserEnaged = 0
	self.ChopperJump = 0
	self.BrakePressure = 100
	
	self.AlarmSound = 0
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector( 346,0,0),Angle(0,180,0),true,"u2")
    self.RearBogey  = self:CreateBogeyUF(Vector(4,1,0),Angle(0,0,0),false,"u2joint")
    self.FrontBogey:SetNWBool("Async",true)
    self.RearBogey:SetNWBool("Async",true)
	-- Create couples
    self.FrontCouple = self:CreateCoupleUF(Vector( 525,0,15),Angle(0,0,0),true,"u2")	
    self.RearCouple = self:CreateCoupleUF(Vector( 100,0,100),Angle(0,0,0),false,"u2")	

	self.Async = true
	-- Create U2 Section B
	self.u2sectionb = self:CreateSectionB(Vector(-770,0,0))
	
	
	self.PantoState = 0
	
	self.ReverserState = 0
	
	
	
	
	--self.PantoState = 0
	
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUp",
		[KEY_D] = "ThrottleDown",
		[KEY_H] = "BellEngage",
		[KEY_SPACE] = "Deadman",
		[KEY_W] = "ReverserUp",
		[KEY_S] = "ReverserDown",
		[KEY_P] = "PantoUp",
		[KEY_O] = "DoorUnlock",
		[KEY_I] = "DoorLock",
		[KEY_K] = "DoorConfirm",
		[KEY_PAD_4] = "BlinkerLeft",
		[KEY_PAD_5] = "BlinkerNeutral",
		[KEY_PAD_6] = "BlinkerRight",
		[KEY_PAD_8] = "BlinkerWarn",
		[KEY_J] = "DoorSelectLeft",
		[KEY_L] = "DoorSelectRight",
		[KEY_B] = "BatteryOn",
		[KEY_N] = "BatteryOff",
		[KEY_0] = "KeyTurnOn",
		[KEY_1] = "Throttle10",
		[KEY_2] = "Throttle20",
		[KEY_3] = "Throttle30",
		[KEY_4] = "Throttle40",
		[KEY_5] = "Throttle50",
		
			[KEY_LSHIFT] = {
							[KEY_0] = "KeyToggle",},
		}
	

end





-- LOCAL FUNCTIONS FOR GETTING OUR OWN ENTITY SPAWNS



	
	

	



function ENT:Think()
	self.BaseClass.Think(self)
    self:SetPackedBool("BellEngage",self.BellEngage)
	
	

	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*150)
   --self.u2sectionb(self)

	--self.RearCouple:Remove()

	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)
	
	self:SetPackedBool("Headlights1",true)
	
	
	if self.ThrottleState > 0 then
		self.ThrottleEngaged = true
	end
	
	--self.BrakePressure = math.Clamp(self.ThrottleState, 0, -100) * -1
	
	
		local N = math.Clamp(self.ThrottleState, 0, 100)
	

	
	
	
	self:SetNW2Int("ThrottleState", self.ThrottleState)
	
	
	
	
	
	
	
	if IsValid(self.FrontBogey) and IsValid(self.RearBogey) then
	
	
	self.FrontBogey.PneumaticBrakeForce = (50000.0) 
    --self.FrontBogey.BrakeCylinderPressure = self.BrakePressure  

	
	self.FrontBogey.MotorForce = 20000*N / 20  ---(N < 0 and 1 or 0) ------- 1 unit = 110kw / 147hp | Total kW of U2 300kW
	self.FrontBogey.MotorPower = 600--(N *100) + (self.ChopperJump)
	self.FrontBogey.Reversed = self.ReverserState < 0
	self.RearBogey.MotorForce  = 20000*N / 20 --18000*N
	self.RearBogey.MotorPower = 600--N *100 + (self.ChopperJump) --100 ----------- maximum kW of one bogey 36.67
	self.RearBogey.Reversed = self.ReverserState > 0
	end
	
	if self.Debug == 1 then
		print("Front MotorForce and MotorPower")
		print(tostring(self.FrontBogey.MotorForce))
		print(tostring(self.FrontBogey.MotorPower))
	end
	
end


function ENT:OnButtonPress(button,ply)
	--if button == "DoorUnlock" then
	--	if self.DoorSelectState.Value == 1 then
	--	self.DoorSelectL:TriggerInput("DoorSelectState",1)
	--	else
    --    self.DoorSelectR:TriggerInput("DoorSelectState",0)
	--	end
    --end
	
	----THROTTLE CODE
	if button == "ThrottleUp"
			then
			self.ThrottleState = self.ThrottleState + 4
			
			self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
			self.Duewag_U2:TriggerInput("ThrottleState",self.ThrottleState)
			print(tostring(self.ThrottleState))
	
	end
	
	
	if button == "ThrottleDown"
			then
			self.ThrottleState = self.ThrottleState - 4
			self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
			self.Duewag_U2:TriggerInput("ThrottleState",self.ThrottleState)
			print(tostring(self.ThrottleState))
	
	end
	
	if button == "ReverserUp"
			then
			if 
				not self.ThrottleEngaged == true then
			self.ReverserState = self.ReverserState + 1
			self.ReverserState = math.Clamp(self.ReverserState,-1,1)
			self.Duewag_U2:TriggerInput("ReverserState",self.ReverserState)
			print(tostring(self.ReverserState))
			print("Reverser")
			end
	end
	if button == "ReverserDown"
			then
			if 
				not self.ThrottleEngaged == true then
			self.ReverserState = self.ReverserState - 1
			self.ReverserState = math.Clamp(self.ReverserState,-1,1)
			self.Duewag_U2:TriggerInput("ReverserState",self.ReverserState)
			print(tostring(self.ReverserState))
			end
	end
	
	
	
	if button == "Deadman" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 1)
			print("DeadmanPressedYes")
	end
	
	if button == "KeyToggle" then
			self.Duewag_U2:TriggerInput("KeyInsert", 1)
			print("Key is insterted")
	end
	if button == "KeyTurnOn" then
			self.Duewag_U2:TriggerInput("KeyTurnOn", 1)
			print("Key is enabled")
	end
end

function ENT:OnButtonRelease(button,ply)
		
		if button == "PantoUp" then
			if self.PantoState == 0
				then self.Duewag_U2:TriggerInput("PantoUp",1)
			end 
		end	
			
			----THROTTLE CODE --Black Phoenix: Make sure it snaps to zero when next to zero
		if button == "ThrottleUp" then
			self.Duewag_U2:TriggerInput("ThrottleState", self.ThrottleState)
			
		end
		if button == "ThrottleDown" then
			self.Duewag_U2:TriggerInput("ThrottleState", self.ThrottleState)
			
		end
		
		if button == "Deadman" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 0)
			print("DeadmanPressedNo")
		end
	

end


function ENT:CreateSectionB(pos)
	local ang = Angle(0,0,0)
	local u2sectionb = ents.Create("gmod_subway_uf_u2_section_b")
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



