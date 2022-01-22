AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

--------------------------------------------------------------------------------
-- переписал Lindy2017 
-- ориг скрипты - татра и томас 
--------------------------------------------------------------------------------

---------------------------------------------------
-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------
ENT.SubwayTrain = {
	Type = "U2h",
	Name = "U2h section B",
	WagType = 0,
	Manufacturer = "Duewag",
}

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2hb.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,4.9))

	self.Bogeys = {}
	-- Create bogeys
	--self.FrontBogey = self:CreateBogey(Vector( 0,0,0),Angle(0,0,0),true,"u2")--103,0,-80
	table.insert(self.Bogeys,self.FrontBogey)	
	self.RearBogey  = self:CreateBogeyUF(Vector( -400,0,0),Angle(0,180,0),true,"u2")
	
	self.CabEnabled = false
	self.BatteryOn = false

	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserEngaged = 0
	
	self.DriverSeat = self:CreateSeat("driver",Vector(-500,-17,55), Angle(0,180,0))
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
		[KEY_Z] = "WarningAnnouncementSet",
		[KEY_PAD_4] = "BlinkerLeft",
		[KEY_PAD_5] = "BlinkerNeutral",
		[KEY_PAD_6] = "BlinkerRight",
		[KEY_PAD_8] = "BlinkerWarn",
		[KEY_J] = "DoorSelectLeft",
		[KEY_L] = "DoorSelectRight",
		[KEY_B] = "Battery",
		--[KEY_0] = "KeyTurnOn",
		
		[KEY_LSHIFT] = {
							[KEY_0] = "KeyInsert",
							[KEY_9] = "ReverserInsert",
							[KEY_A] = "ThrottleUpFast",
							[KEY_D] = "ThrottleDownFast",
							[KEY_S] = "ThrottleZero",
							[KEY_H] = "Horn"},
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
	self.RearCouple = self:CreateCoupleUF(Vector( -528,0,8),Angle(0,180,0),true,"u2")	
    --self.FrontCouple = self:CreateCoupleUF(Vector( 0,0,23),Angle(0,180,0),true,"u2")	
	
    --self.RearBogey:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.RearBogey:SetColor(Color(0,0,0,0))		

	--self.Timer = CurTime()	
	--self.Timer2 = CurTime()
	self:SetNW2Entity("RearBogey",self.ParentTrain.RearBogey)
	self:SetNW2Entity("MiddleBogey",self.ParentTrain.MiddleBogey)
	self:SetNW2Entity("FrontBogey",self.ParentTrain.FrontBogey)
	undo.Create(self.ClassName)	
	undo.AddEntity(self)	
	undo.SetPlayer(self.Owner)
	undo.SetCustomUndoText("Undone a train")
	undo.Finish()
	
	--self.Wheels = self.FrontBogey.Wheels
   
	self.Lights = {
	[61] = { "light",Vector(-538.7,50,43), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 1.5, texture = "sprites/light_glow02.vmt" },
    [62] = { "light",Vector(-538.7,-50,43), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 1.5, texture = "sprites/light_glow02.vmt" },
	[63] = { "light",Vector(-538.7,0,149), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt" },
	[64] = { "light",Vector(-538.7,39.5,40), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" },
	[65] = { "light",Vector(-538.7,-39.5,40), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" },
	[66] = { "light",Vector(-538.7,39.5,46.2), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" },
	[67] = { "light",Vector(-538.7,-39.5,46.2), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" },
	}
	--[[for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end]]

	self.BrakePressure = 0	

	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))



	self.TrainWireCrossConnections = {
        [3] = 4, -- Reverser F<->B

    }
	self:SetNW2String("Texture",self.ParentTrain:GetNW2String("Texture").."_b")
	self:TrainSpawnerUpdate()
end



-- LOCAL FUNCTIONS FOR GETTING OUR OWN ENTITY SPAWNS


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
    bogey:SetNW2Entity("TrainEntity", self.ParentTrain)
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
    coupler:SetNW2Entity("TrainEntity", self.ParentTrain)
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




function ENT:UnitLink()
	return{"BogeyPower","BogeyBrakeCylinderPressure","TrainWire1","TrainWire2","TrainWire3","TrainWire4","TrainWire5"}
end

function ENT:TriggerUnitLink(name,value)
	if self[name] then self[name] = value end
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
	
	if button == "WarningAnnouncementSet" then
			self:Wait(1)
			self:SetNW2Bool("WarningAnnouncement", true)
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
			self.Duewag_U2:TriggerInput("BatteryOn",self.BatteryOn)
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

	if button == "BellEngage" then
		self:SetNW2Bool("Bell",true)
	end

	if button == "Horn" then
		self:SetNW2Bool("Horn",true)
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
		if self.Duewag_U2.BrakePressure > 1 and self.Duewag_U2.Speed < 1 then
			self.RearCouple:Decouple()
		end
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
	
		if button == "WarningAnnouncementSet" then
			self:SetNW2Bool("WarningAnnouncement", false)
		end

		if button == "BellEngage" then
			self:SetNW2Bool("Bell",false)
		end
		if button == "Horn" then
			self:SetNW2Bool("Horn",false)
		end
end



function ENT:TrainSpawnerUpdate()
			

	--local num = self.WagonNumber
	--math.randomseed(num+400)
	
	self.RearCouple:SetParameters()
	--local tex = "Def_U2"
	--self:UpdateTextures()
	--self:UpdateLampsColors()
	self.RearCouple.CoupleType = "U2"
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture"))
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture").."_b")
	self:SetNW2String("Texture",self.ParentTrain:GetNW2String("Texture").."_b")
	self:UpdateTextures()

end


function ENT:Think()
	self.BaseClass.Think(self)
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*150)

	
	--PrintMessage(HUD_PRINTTALK, self:GetNW2String("Texture"))
	
	--self:SetLightPower(111,true)
	--self:SetLightPower(112,true)
	--self:SetLightPower(113,true)

	if self.BatteryOn == true then 
		self.CabEnabled = true
		self:SetNW2Bool("CabBEnabled",true)
	end


	
    --self.RearBogey.MotorForce  =  self.ParentTrain.FrontBogey.MotorForce--18000*N

	
	--self.RearBogey.MotorPower = self:ReadTrainWire(1)--N *100 + (self.ChopperJump) --100 ----------- maximum kW of one bogey 36.67
	--self.RearBogey.Reversed = self:ReadTrainWire(2) < 0


    --self.RearBogey.PneumaticBrakeForce = 50000.0
    

	--self.RearBogey.Reversed = self.ParentTrain.ReverserState < 1
	
	--[[if IsValid(self.ParentTrain) then
		self.RearBogey.MotorPower = self.ParentTrain.FrontBogey.MotorPower
		self:WriteTrainWire(1,self.ParentTrain.FrontBogey.MotorPower)
		self.RearBogey.Reversed = self.ParentTrain.ReverserState > 0
		self.RearBogey.BrakeCylinderPressure = self.ParentTrain.BrakePressure
		--PrintMessage(HUD_PRINTTALK,self.ParentTrain.MotorPower)
		--Var1 = self.ParentTrain.Something
		--NWVar = self.ParentTrain:GetNW2Int("Something")
	end]]


	if self.RearCouple.CoupledEnt ~= nil then
		self:SetNW2Bool("BIsCoupled", true)
	else
		self:SetNW2Bool("BIsCoupled",false)
	end
	--self:SetNW2Bool("BIsCoupled",self.RearCouple:AreCoupled(self.RearCouple))
    
	
		if not self:GetNW2Bool("BIsCoupled",false) == true then
			if self.ParentTrain:ReadTrainWire(3) == 1 then
				self:SetLightPower(61,false)
    			self:SetLightPower(62,false)
				self:SetLightPower(63,false)
				self:SetLightPower(64,true)
				self:SetLightPower(65,true)
			elseif self.ParentTrain:ReadTrainWire(4) == 1 then
				if self:GetNW2Bool("HeadlightsSwitch",false) == true then
				self:SetLightPower(61,true)
    			self:SetLightPower(62,true)
				self:SetLightPower(63,true)
				end
				self:SetLightPower(64,false)
				self:SetLightPower(65,false)
			end
		elseif self:GetNW2Bool("BIsCoupled",false) == true then
			if self.ParentTrain:ReadTrainWire(3) == 1 then
				self:SetLightPower(61,false)
   		 		self:SetLightPower(62,false)
				self:SetLightPower(63,false)
				self:SetLightPower(64,false)
				self:SetLightPower(65,false)
			elseif self.ParentTrain:ReadTrainWire(4) == 1 then
				self:SetLightPower(61,false)
    			self:SetLightPower(62,false)
				self:SetLightPower(63,false)
				self:SetLightPower(64,false)
				self:SetLightPower(65,false)
			end
		end
	
	if self.ParentTrain:GetNW2Bool("Braking",true) == true and not self:GetNW2Bool("BIsCoupled",false) == true then
		self:SetLightPower(66,true)
		self:SetLightPower(67,true)
	elseif self:GetNW2Bool("BIsCoupled",false) == true then
		self:SetLightPower(66,false)
		self:SetLightPower(67,false)
	elseif self.ParentTrain:GetNW2Bool("Braking",true) == false then 
		self:SetLightPower(66,false)
		self:SetLightPower(67,false)
	end
	

end
