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

ENT.BogeyDistance = 2400


ENT.SyncTable = { "speed", "ThrottleState", "Drive", "Brake","Reverse","BellEngage","Horn","WarningAnnouncement", "PantoUp", "BatteryOn", "KeyTurnOn", "BlinkerState", "StationBrakeOn", "StationBrakeOff"}


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
	self.CabEnabled = 0
	self.LeadingCab = 0
	
	self.WarningAnnouncement = 0
	
	self.speed = 0
	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserEnaged = 0
	self.ChopperJump = 0
	self.BrakePressure = 0
	self.ThrottleRate = 0

	self.WagonNumber = 303

	self.Haltebremse = 0

	self.AlarmSound = 0
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF(Vector( 400,-0.7,0),Angle(0,180,0),true,"u2")
    self.RearBogey  = self:CreateBogeyUF(Vector(2.8,1.5,0),Angle(0,0,0),false,"u2joint")
    self.FrontBogey:SetNWBool("Async",true)
    self.RearBogey:SetNWBool("Async",true)
	-- Create couples
    self.FrontCouple = self:CreateCoupleUF(Vector( 530,0,8),Angle(0,0,0),true,"u2")	
    self.RearCouple = self:CreateCoupleUF(Vector( 100,50,50),Angle(0,0,0),false,"dummy")	

	self.Async = true
	-- Create U2 Section B
	self.u2sectionb = self:CreateSectionB(Vector(-770,0,0))
	
	
	self.PantoUp = false
	self.KeyInsert = false 
	self.ReverserInsert = false 
	self.KeyTurnOn = false
	self.BatteryOn = false
	
	self.FrontBogey:SetNWInt("MotorSoundType",0)
    self.RearBogey:SetNWInt("MotorSoundType",0)
	
	
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
		[KEY_Z] = "WarningAnnouncement",
		[KEY_PAD_4] = "BlinkerLeft",
		[KEY_PAD_5] = "BlinkerNeutral",
		[KEY_PAD_6] = "BlinkerRight",
		[KEY_PAD_8] = "BlinkerWarn",
		[KEY_J] = "DoorSelectLeft",
		[KEY_L] = "DoorSelectRight",
		[KEY_B] = "Battery",
		[KEY_0] = "KeyTurnOn",
		
		[KEY_LSHIFT] = {
							[KEY_0] = "KeyInsert",
							[KEY_9] = "ReverserInsert",
							[KEY_A] = "ThrottleUpFast",
							[KEY_D] = "ThrottleDownFast",
							[KEY_S] = "ThrottleZero"},
		[KEY_RALT] = {
							[KEY_PAD_1] = "Number1",
							[KEY_PAD_2] = "Number2",
							[KEY_PAD_3] = "Number3",
							[KEY_PAD_4] = "Number4",
							[KEY_PAD_5] = "Number5",
							[KEY_PAD_6] = "Number6",
							[KEY_PAD_7] = "Number7",
							[KEY_PAD_8] = "Number8",
							[KEY_PAD_9] = "Number9",
							[KEY_PAD_0] = "Number0",
							[KEY_PAD_ENTER] = "Enter",
							[KEY_PAD_DECIMAL] = "Delete",
							[KEY_PAD_DIVIDE] = "Destination",
							[KEY_PAD_MULTIPLY] = "SpecialAnnouncements",
							[KEY_PAD_MINUS] = "TimeAndDate",
		},
	}
	
--How to get the IBIS inputs? With function TRAIN_SYSTEM:Trigger(name,value)



	local rand = math.random() > 0.8 and 1 or math.random(0.95,0.99) --because why not
    



	--self:TrainSpawnerUpdate()




end









	
function ENT:TrainSpawnerUpdate()
			

		--local num = self.WagonNumber
		--math.randomseed(num+400)
		
		self.RearCouple.CoupleType = self.FrontCouple.CoupleType
        self.FrontCouple:SetParameters()
        self.RearCouple:SetParameters()
		local tex = "Def_U2"
		self:UpdateTextures()
		--self:UpdateLampsColors()
		self.FrontCouple.CoupleType = "U2"
		self.RearCouple.CoupleType = "dummy"

end











function ENT:Think(dT)
	self.BaseClass.Think(self)
    self:SetPackedBool("BellEngage",self.Duewag_U2.BellEngage)
	
	
	

	local function wait(seconds)
		local time = seconds or 1
		local start = os.time()
		repeat until os.time() == start + time
	end
	
	self:SetNW2Bool("KeyInsert",self.KeyInsert)
	self:SetNW2Bool("KeyTurnOn",self.KeyTurnOn)
	self:SetNW2Bool("BatteryOn",self.BatteryOn)
	self:SetNW2Bool("PantoUp",self.PantoUp)
	self:SetNW2Bool("ReverserInserted",self.ReverserInsert)

	if self:GetNW2Bool("ReverserInserted", false) == true then self:SetNW2Bool("CabActive", true) end
	

	self.Speed = math.abs(self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Float("Speed",self.Speed)
	self.Duewag_U2:TriggerInput("Speed",self.Speed*150)
 
	--PrintMessage(HUD_PRINTTALK,"Current Speed")
	--PrintMessage(HUD_PRINTTALK,self.Speed)

	--self.RearCouple:Remove()
	
	--self:SetPackedBool("Headlights1",true)
	
	

	
	

		
	
	


	


	
	
	
	local N = math.Clamp(self.Duewag_U2.Traction, 0, 100)
	
	
	
	if self.Duewag_Deadman.Alarm == 1 then
		self.Duewag_U2:TriggerInput("BrakePressure", -100)
	end
 	PrintMessage(HUD_PRINTTALK, self.Duewag_Deadman.Alarm)
	
	
	
	
	if IsValid(self.FrontBogey) and IsValid(self.RearBogey) then
	
	
	self.FrontBogey.PneumaticBrakeForce = (60000.0) 
	self.RearBogey.PneumaticBrakeForce = (60000.0) 
    self.FrontBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure  
	self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure  

	
	self.FrontBogey.MotorForce = self.Duewag_U2.Traction --15000*N / 20  ---(N < 0 and 1 or 0) ------- 1 unit = 110kw / 147hp | Total kW of U2 300kW
	self.FrontBogey.MotorPower = 100--(N *100) + (self.ChopperJump)
	self.FrontBogey.Reversed = self.ReverserState < 0
	self.RearBogey.MotorForce  = self.Duewag_U2.Traction --15000*N / 20 --18000*N
	self.RearBogey.MotorPower = 100--N *100 + (self.ChopperJump) --100 ----------- maximum kW of one bogey 36.67
	self.RearBogey.Reversed = self.Duewag_U2.ReverserState > 0
	end
	
	--PrintMessage(HUD_PRINTTALK, self.FrontBogey.MotorForce)

	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	--self:SetNWFloat("ThrottleState",self.ThrottleState)
	self.Duewag_U2:TriggerInput("ThrottleRate", self.ThrottleRate)
	--PrintMessage(HUD_PRINTTALK, self.Duewag_U2.ThrottleState)
	--Train:WriteTrainWire(1,self.FrontBogey.MotorForce)
	--PrintMessage(HUD_PRINTTALK, "Calculated Traction")
	--PrintMessage(HUD_PRINTTALK, self.Duewag_U2.Traction)
	self:SetNWInt("ThrottleStateAnim", self.Duewag_U2.ThrottleStateAnim)
	--PrintMessage(HUD_PRINTTALK, self:GetNWInt("ThrottleState", fallback = 0))
	--PrintMessage(HUD_PRINTTALK, self.Duewag_U2.ThrottleStateAnim)
	
end





function ENT:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time

end

function ENT:OnButtonPress(button,ply)

	
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.ThrottleRate = 2 end
		if button == "ThrottleDown" then self.ThrottleRate = -2 end
	end

	if self.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.ThrottleRate = 5.5 end
		if button == "ThrottleDownFast" then self.ThrottleRate = -5.5 end
	end

	if self.ThrottleRate == 0 then
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
	
	if button == "WarningAnnouncement"  then
			self:SetNW2Bool("WarningAnnouncement", 1)
	end
	
	if button == "KeyInsert" then
			if self.KeyInsert == false then
				self.KeyInsert = true 
				self.Duewag_U2:TriggerInput("KeyInsert",self.KeyInsert)
				self:SetPackedBool("KeyInsert",true)
				PrintMessage(HUD_PRINTTALK, "Key is in")
			

			elseif  self.KeyInsert == true then
				self.KeyInsert = false
				self.Duewag_U2:TriggerInput("KeyInsert",0)
				self:SetPackedBool("KeyInsert",0)
				PrintMessage(HUD_PRINTTALK, "Key is out")
			end
	end
	
	if button == "ReverserUp" then
			if 
				not self.Duewag_U2.ThrottleEngaged == true  then
					if self.Duewag_U2.ReverserInserted == true then
					self.ReverserState = self.ReverserState + 1
					self.ReverserState = math.Clamp(self.ReverserState,-1,1)
					self.Duewag_U2:TriggerInput("ReverserState",self.ReverserState)
					PrintMessage(HUD_PRINTTALK,self.ReverserState)
					end
			end
	end
	if button == "ReverserDown" then
			if 
				not self.Duewag_U2.ThrottleEngaged == true and self.Duewag_U2.ReverserInserted == true then
				self.ReverserState = self.ReverserState - 1
				self.ReverserState = math.Clamp(self.ReverserState,-1,1)
				self.Duewag_U2:TriggerInput("ReverserState",self.ReverserState)
			end
	end
	
	
	
	
	if button == "ReverserInsert" then
		if self.ReverserInsert == false then
			self.ReverserInsert = true
			self.Duewag_U2:TriggerInput("ReverserInserted",self.ReverserInsert)
			self:SetNW2Bool("ReverserInserted",true)
			PrintMessage(HUD_PRINTTALK, "Reverser is in")
		
		elseif  self.ReverserInsert == true then
			self.ReverserInsert = false
			self.Duewag_U2:TriggerInput("ReverserInserted",false)
			self:SetNW2Bool("ReverserInserted",false)
			PrintMessage(HUD_PRINTTALK, "Reverser is out")
		end
	end


	if button == "Battery" then
		if self.BatteryOn == false then
			self.BatteryOn = true
			self.Duewag_U2:TriggerInput("BatteryOn",self.ReverserInsert)
			self:SetNW2Bool("BatteryOn",true)
			PrintMessage(HUD_PRINTTALK, "Battery is ON")


			elseif  self.BatteryOn == true then
				self.BatteryOn = false
				self.Duewag_U2:TriggerInput("BatteryOn",false)
				self:SetNW2Bool("BatteryOn",false)
				PrintMessage(HUD_PRINTTALK, "Battery is OFF")
			
		end
			
	end
	
	
	if button == "Deadman" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 1)
			print("DeadmanPressedYes")
	end
	

	if button == "KeyTurnOn" then
			if self.KeyTurnOn == false then
				if self.KeyInsert == true	then
					self.KeyTurnOn = true
					PrintMessage(HUD_PRINTTALK, "Key is turned")
				end
			end
			else
			if self.KeyTurnOn == true then
					if self.KeyInsert == true  then
						self.KeyTurnOn = false
						PrintMessage(HUD_PRINTTALK, "Key is turned off")
					end
			end
	end

	if button == "Number7" then
		self.IBIS:Trigger("Number7")
	end

	if button == "Destination" then
		self.IBIS:Trigger("Destination")
	end


	if button == "Number0" then
		self.IBIS:Trigger("Number0")
	end

	if button == "Enter" then
		self.IBIS:Trigger("Enter")
	end
end


function ENT:OnButtonRelease(button,ply)
		

			
			----THROTTLE CODE --Black Phoenix: Make sure it snaps to zero when next to zero
			if (button == "ThrottleUp" and self.ThrottleRate > 0) or (button == "ThrottleDown" and self.ThrottleRate < 0) then
				self.ThrottleRate = 0
			end
			if (button == "ThrottleUpFast" and self.ThrottleRate > 0) or (button == "ThrottleDownFast" and self.ThrottleRate < 0) then
				self.ThrottleRate = 0
			end
		
		

		
		
		if button == "Deadman" then
			self.Duewag_Deadman:TriggerInput("IsPressed", 0)
			print("DeadmanPressedNo")
		end
	
		if button == "WarningAnnouncement" then
			self:SetNW2Bool("WarningAnnouncement", false)
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