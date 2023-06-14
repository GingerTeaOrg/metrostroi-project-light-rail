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
	self:SetPos(self:GetPos() + Vector(0,0,0))

	self.Bogeys = {}
	-- Create bogeys
	--table.insert(self.Bogeys,self.FrontBogey)	
	--self.RearBogey = self:CreateBogeyUF(Vector( -300,0,0),Angle(0,180,0),true,"duewag_motor")
	self.ParentTrain = self:GetNW2Entity("U2a")
	self.CabEnabled = false
	self.BatteryOn = false

	self.BlinkerLeft = false
	self.BlinkerRight = false

	self.BlinkerHazard = false

	self.ThrottleState = 0
	self.ThrottleEngaged = false
	self.ReverserState = 0
	self.ReverserEngaged = 0
	
	self.DriverSeat = self:CreateSeat("driver",Vector(-395,-15,34),Angle(0,180,0))
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
			--[KEY_0] = "KeyTurnOn",
			
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
	
	self.RearCouple = self.ParentTrain.RearCouple
    --self.FrontCouple = self:CreateCoupleUF(Vector( 0,0,23),Angle(0,180,0),true,"u2")	
	
    --self.RearBogey:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.RearBogey:SetColor(Color(0,0,0,0))		

	--self.Timer = CurTime()	
	--self.Timer2 = CurTime()
	--[[self:SetNW2Entity("RearBogey",self.ParentTrain.RearBogey)
	self:SetNW2Entity("MiddleBogey",self.ParentTrain.MiddleBogey)
	self:SetNW2Entity("FrontBogey",self.ParentTrain.FrontBogey)]]
	undo.Create(self.ClassName)	
	undo.AddEntity(self)	
	undo.SetPlayer(self.Owner)
	undo.SetCustomUndoText("Undone a train")
	undo.Finish()
	
	--self.Wheels = self.FrontBogey.Wheels
   
	self.Lights = {
	[61] = { "light",Vector(-426.5,50,42), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight 1
    [62] = { "light",Vector(-426.5,-50,42), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 1.5, texture = "sprites/light_glow02.vmt" }, --headlight 2
	[63] = { "light",Vector(-426.5,0,149), Angle(0,0,0), Color(226,197,160),     brightness = 0.9, scale = 0.45, texture = "sprites/light_glow02.vmt" }, --headlight 3
	[64] = { "light",Vector(-425.44,-30.9657,25.6195), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light left
	[65] = { "light",Vector(-425.44,30.9657,25.6195), Angle(0,0,0), Color(255,0,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --tail light right
	[66] = { "light",Vector(-426.5,-30.9657,31.5), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --brake light left
	[67] = { "light",Vector(-426.5,30.9657,31.5), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --brake light right
	[158] = { "light",Vector(-327,52,74), Angle(0,0,0), Color(255,100,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator top left
	[159] = { "light",Vector(-327,-52,74), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator top right
	[148] = { "light",Vector(-327,52,68), Angle(0,0,0), Color(255,100,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator bottom left
	[149] = { "light",Vector(-327,-52,68), Angle(0,0,0), Color(255,102,0),     brightness = 0.9, scale = 0.1, texture = "sprites/light_glow02.vmt" }, --indicator bottom right
	[30] = { "light",Vector(-397.343,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 1
	[31] = { "light",Vector(-326.738,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 2
	[32] = { "light",Vector(-151.5,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 3
	[33] = { "light",Vector(-83.7,51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front left 4
	[34] = { "light",Vector(-397.343,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 1
	[35] = { "light",Vector(-326.738,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 2
	[36] = { "light",Vector(-151.5,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 3
	[37] = { "light",Vector(-83.7,-51,49.7), Angle(0,0,0), Color(9,142,0),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --door button front right 4
	[38] = { "light",Vector(-416.20,6,54), Angle(0,0,0), Color(0,90,59),     brightness = 1, scale = 0.025, texture = "sprites/light_glow02.vmt" }, --indicator indication lamp in cab
	}
	--[[for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end]]

	self.BrakePressure = 0	

	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))



	--[[self.TrainWireCrossConnections = {
        --[4] = 3, -- Reverser F<->B
		--[21] = 20, --Blinkers
	}]]
    
	self:SetNW2String("Texture",self.ParentTrain:GetNW2String("Texture").."_b")
	self:TrainSpawnerUpdate()
	self.U2SectionA = self:GetNW2Entity("U2a")
end



-- LOCAL FUNCTIONS FOR GETTING OUR OWN ENTITY SPAWNS







function ENT:UnitLink()
	return{"BogeyPower","BogeyBrakeCylinderPressure","TrainWire1","TrainWire2","TrainWire3","TrainWire4","TrainWire5"}
end

function ENT:TriggerUnitLink(name,value)
	if self[name] then self[name] = value end
end



function ENT:OnButtonPress(button,ply)

	if button == "HighbeamToggle" then
		if self.Panel.Highbeam == 0 then
			self.Panel.Highbeam = 1
		else
			self.Panel.Highbeam = 0
		end
	end

	if button == "PassengerOvergroundSet" then
		self.Panel.PassengerOverground = 1
	end
	if button == "PassengerUndergroundSet" then
		self.Panel.PassengerUnderground = 1
	end
	
	if button == "SetPointLeftSet" then
		self.Panel.SetPointLeft = 1
	end
	if button == "SetPointRightSet" then
		self.Panel.SetPointRight = 1
	end
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.ParentTrain.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.ParentTrain.Duewag_U2.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.ParentTrain.Duewag_U2.ThrottleRate = -3 end
	end
	
	if self.ParentTrain.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.ParentTrain.Duewag_U2.ThrottleRate = 8 end
		if button == "ThrottleDownFast" then self.ParentTrain.Duewag_U2.ThrottleRate = -8 end
		
	end
	
	if self.ParentTrain.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then self.ParentTrain.Duewag_U2.ThrottleRate = 10 end
		if button == "ThrottleDownReallyFast" then self.ParentTrain.Duewag_U2.ThrottleRate = -10 end
		
	end
	
	
	
	if button == "Door1Set" then
		self.Door1 = true
		self.Panel.Door1 = 1
	end
	
	if self.ParentTrain.Duewag_U2.ThrottleRate == 0 then
		if button == "ThrottleZero" then self.ParentTrain.Duewag_U2.ThrottleState = 0 end
		if self:GetNW2Bool("EmergencyBrake",false) == true then
			self:SetNW2Bool("EmergencyBrake",false)
		end
	end
	
	if button == "Throttle10Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 10
	end
	
	if button == "Throttle20Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 20
	end
	
	if button == "Throttle30Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 30
	end
	if button == "Throttle40Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 40
	end
	if button == "Throttle50Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 50
	end
	if button == "Throttle60Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 60
	end
	if button == "Throttle70Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 70
	end
	if button == "Throttle80Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 80
	end
	if button == "Throttle90Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = 90
	end
	
	if button == "Throttle10-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -10
	end
	
	if button == "Throttle20-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -20
	end
	
	if button == "Throttle30-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -30
	end
	if button == "Throttle40-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -40
	end
	if button == "Throttle50-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -50
	end
	if button == "Throttle60-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -60
	end
	if button == "Throttle70-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -70
	end
	if button == "Throttle80-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -80
	end
	if button == "Throttle90-Pct" then
		self.ParentTrain.Duewag_U2.ThrottleState = -90
	end
	
	if button == "PantographRaiseSet" then
		self.Panel.PantographRaise = 1
		
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
		not self.ParentTrain.Duewag_U2.ThrottleEngaged == true  then
			if self.ParentTrain.Duewag_U2.ReverserInsertedB == true then
				self.ParentTrain.Duewag_U2.ReverserLeverState = self.ParentTrain.Duewag_U2.ReverserLeverStateB + 1
				self.ParentTrain.Duewag_U2.ReverserLeverState = math.Clamp(self.ParentTrain.Duewag_U2.ReverserLeverStateB, -1, 3)
			end
		end
	end
	if button == "ReverserDownSet" then
		if 
		not self.ParentTrain.Duewag_U2.ThrottleEngaged == true and self.ParentTrain.Duewag_U2.ReverserInsertedB == true then

			math.Clamp(self.ParentTrain.Duewag_U2.ReverserLeverStateB, -1, 3)
			self.ParentTrain.Duewag_U2.ReverserLeverStateB = self.ParentTrain.Duewag_U2.ReverserLeverStateB - 1
			self.ParentTrain.Duewag_U2.ReverserLeverStateB = math.Clamp(self.ParentTrain.Duewag_U2.ReverserLeverStateB, -1, 3)

		end
	end
	
	
	
	if self.ParentTrain.Duewag_U2.ReverserState == 0 then
		if button == "ReverserInsert" then
			if self.ParentTrain.Duewag_U2.ReverserInsertedB == false then
				self.ParentTrain.Duewag_U2.ReverserInsertedB = true
				self.ParentTrain.Duewag_U2.ReverserInsertedA = false
				self:SetNW2Bool("ReverserInserted",true)
	
				
			elseif self.ParentTrain.Duewag_U2.ReverserInsertedB == true then
				self.ParentTrain.Duewag_U2.ReverserInsertedB = false
				self.ParentTrain.Duewag_U2.ReverserInsertedA = false
				self:SetNW2Bool("ReverserInserted",false)
			end
		end
	end
	
	
	if button == "BatteryToggle" then
		
		self:SetPackedBool("FlickBatterySwitchOn",true)
		if self.BatteryOn == false and self.ParentTrain.Duewag_U2.ReverserLeverStateB == 1 then
			self.BatteryOn = true
			self:SetNW2Bool("BatteryOn",true)
		end
	end
	
	if button == "BatteryDisableToggle" then
		if self.BatteryOn == false and self.ParentTrain.Duewag_U2.ReverserLeverStateB == 1 then
			self.BatteryOn = false
			self.Duewag_Battery:TriggerInput("Charge",0)
			self:SetNW2Bool("BatteryOn",false)
		end
		self:SetPackedBool("FlickBatterySwitchOff",true)
		
	end
	
	
	if button == "DeadmanSet" then
		self.ParentTrain.Duewag_Deadman:TriggerInput("IsPressed", 1)
		if self:ReadTrainWire(6) > 0 then
			self:WriteTrainWire(12,1)
		end
		------print("DeadmanPressedYes")
	end
	
	
	if button == "BlinkerLeftSet" then
		
		if self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) > 0 then -- If you press the button and the blinkers are already set to right, turn off
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
		elseif
		self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are off, set to left
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
			--self:SetNW2String("BlinkerDirection","left")
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are already on, turn them off
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,0)
			--self:SetNW2String("BlinkerDirection","none")
		elseif
		self:ReadTrainWire(20) > 0 and self:ReadTrainWire(21) > 0 then
			--self:WriteTrainWire(20,1)
			--self:WriteTrainWire(21,1)
		end
		if self.Panel.BlinkerLeft == 0 and self.Panel.BlinkerRight == 0 then
			self.Panel.BlinkerLeft = 1
		elseif self.Panel.BlinkerLeft == 0 and self.Panel.BlinkerRight == 1 then 
			self.Panel.BlinkerLeft = 0
			self.Panel.BlinkerRight = 0
		end
	end
	
	
	if button == "BlinkerRightSet" then
		
		if self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) > 0 then -- If you press the button and the blinkers are already set to right, do nothing
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
			
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) < 1 then -- If you press the button and the blinkers are already set to left, set to neutral
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,0)
		elseif
		self:ReadTrainWire(20) < 1 and self:ReadTrainWire(21) < 1 then
			self:WriteTrainWire(20,0)
			self:WriteTrainWire(21,1)
			
		elseif
		self:ReadTrainWire(20) == 1 and self:ReadTrainWire(21) > 0 then
			self:WriteTrainWire(20,1)
			self:WriteTrainWire(21,1)	
		end

		if self.Panel.BlinkerRight == 0 and self.Panel.BlinkerLeft == 0 then
			self.Panel.BlinkerRight = 1
		elseif self.Panel.BlinkerLeft == 1 and self.Panel.BlinkerRight == 0 then
			self.Panel.BlinkerRight = 0
			self.Panel.BlinkerLeft = 0
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
		if self:ReadTrainWire(5) > 1 and self.ParentTrain.Duewag_U2.Speed < 1 then
			self.FrontCouple:Decouple()
		end
		self.Panel.ThrowCoupler = 1
	end
	
	if button == "DriverLightToggle" then
		
		if self:GetNW2Bool("Cablight",false) == false then
			self:SetNW2Bool("Cablight",true)
		elseif self:GetNW2Bool("Cablight",false) == true then
			self:SetNW2Bool("Cablight",false)
		end
	end
	if button == "HeadlightsToggle" then
		
		if self.ParentTrain.Duewag_U2.HeadlightsSwitch == false then
			self.ParentTrain.Duewag_U2.HeadlightsSwitch = true
			self:SetPackedBool("HeadlightsSwitch",self.ParentTrain.Duewag_U2.HeadlightsSwitch)
		else
			self.ParentTrain.Duewag_U2.HeadlightsSwitch = false
			self:SetPackedBool("HeadlightsSwitch",self.ParentTrain.Duewag_U2.HeadlightsSwitch)
		end
		----print(self.ParentTrain.Duewag_U2.HeadlightsSwitch)
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
			if self.DoorRandomness[1] == 0 then
				self.DoorRandomness[1] = 4
			end
		end
	end
	
	if button == "Button2a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness[1] == 0 then
				self.DoorRandomness[1] = 4
			end
		end
	end
	
	if button == "Button3a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness[2] == 0 then
				self.DoorRandomness[2] = 4
			end
		end
	end
	
	if button == "Button4a" then
		if self.DoorSideUnlocked == "Right" then
			if self.DoorRandomness[2] == 0 then
				self.DoorRandomness[2] = 4
			end
		end
	end
	
		if button == "Button1b" then
		if self.DoorSideUnlocked == "Left" then
			if self.DoorRandomness[1] == 0 then
				self.DoorRandomness[1] = 4
			end
		end
	end
	
	if button == "Button2b" then
		if self.DoorSideUnlocked == "Left" then
			if self.DoorRandomness[1] == 0 then
				self.DoorRandomness[1] = 4
			end
		end
	end
	
	if button == "Button3b" then
		if self.DoorSideUnlocked == "Left" then
			if self.DoorRandomness[2] == 0 then
				self.DoorRandomness[2] = 4
			end
		end
	end
	
	if button == "Button4b" then
		if self.DoorSideUnlocked == "Left" then
			if self.DoorRandomness[2] == 0 then
				self.DoorRandomness[2] = 4
			end
		end
	end
	
	if button == "DoorsUnlockSet"  then
		
		self.DoorsUnlocked = true
		self.DepartureConfirmed = false
		self.Panel.DoorsUnlockSet = 1
	end
	
	
	if button == "DoorsLockSet"  then
		
		
		self.DoorRandomness[1] = -1
		self.DoorRandomness[2] = -1
		self.DoorRandomness[3] = -1
		self.DoorRandomness[4] = -1
		
		self.DoorsPreviouslyUnlocked = true
		self.RandomnessCalculated = false
		self.DoorsUnlocked = false
		self.Door1 = false
		self.Panel.DoorsLock = 1
		
	end
	
	if button == "DoorsCloseConfirmSet" then
		
		self.DoorsPreviouslyUnlocked = false
		self.DepartureConfirmed = true
	end
	
	if button == "SetHoldingBrakeSet" then
		
		self.ParentTrain.Duewag_U2.ManualRetainerBrake = true
		self.Panel.SetHoldingBrake = 1
	end

	if button == "ReleaseHoldingBrakeSet" then
		
		self.Panel.ReleaseHoldingBrake = 1
	end	
	
	if button == "ReleaseHoldingBrakeSet" then
		
		self.ParentTrain.Duewag_U2.ManualRetainerBrake = false
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
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self:SetNW2Bool("IBISKeyBeep",true)
			self.ParentTrain.IBIS:Trigger("Destination",RealTime())
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	
	
	if button == "Number0Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number0",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
		
	end
	
	if button == "Number1Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number1",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number2Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number2",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number3Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number3",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number4Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number4",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number5Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number5",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number6Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number6",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number7Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number7",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number8Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number8",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "Number9Set" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Number9",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "EnterSet" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("Enter",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
	if button == "SpecialAnnouncementSet" then
		if self.ParentTrain.IBISKeyRegistered == false then
			self.ParentTrain.IBISKeyRegistered = true
			self.ParentTrain.IBIS:Trigger("SpecialAnnouncement",RealTime())
			self:SetNW2Bool("IBISKeyBeep",true)
		else
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
	end
end


function ENT:OnButtonRelease(button,ply)

	if button == "PassengerOvergroundSet" then
		self.Panel.PassengerOverground = 0
	end
	if button == "PassengerUndergroundSet" then
		self.Panel.PassengerUnderground = 0
	end


	if button == "ReleaseHoldingBrakeSet" then
		
		self.Panel.ReleaseHoldingBrake = 0
	end	


	if button == "SetHoldingBrakeSet" then
		

		self.Panel.SetHoldingBrake = 0
	end

	if button == "SetPointLeftSet" then
		self.Panel.SetPointLeft = 0
	end
	if button == "SetPointRightSet" then
		self.Panel.SetPointRight = 0
	end

	if button == "DoorsLockSet"  then
		
		self.Panel.DoorsLock = 0
		
	end
	if button == "DoorsUnlockSet"  then
		self.Panel.DoorsUnlockSet = 0
	end
	
	if button == "Door1Set" then
		self.Panel.Door1 = 0
	end
	if button == "PantographRaiseSet" then
		self.Panel.PantographRaise = 0
		
	end
	if button == "ThrowCouplerSet" then
		self.Panel.ThrowCoupler = 0
	end
	if button == "EmergencyBrakeSet" then
		
	end
	
	if (button == "ThrottleUp" and self.ParentTrain.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDown" and self.ParentTrain.Duewag_U2.ThrottleRate < 0) then
		self.ParentTrain.Duewag_U2.ThrottleRate = 0
	end
	if (button == "ThrottleUpFast" and self.ParentTrain.Duewag_U2.ThrottleRate > 0) or (button == "ThrottleDownFast" and self.ParentTrain.Duewag_U2.ThrottleRate < 0) then
		self.ParentTrain.Duewag_U2.ThrottleRate = 0
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
		self.ParentTrain.Duewag_Deadman:TriggerInput("IsPressed", 0)
		
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
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	
	
	if button == "Number0Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
			self:SetNW2Bool("IBISKeyBeep",false)
		end
		
	end
	
	if button == "Number1Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number2Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number3Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number4Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number5Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number6Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number7Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number8Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "Number9Set" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "EnterSet" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	if button == "SpecialAnnouncementSet" then
		if self.ParentTrain.IBISKeyRegistered == true then
			self.ParentTrain.IBISKeyRegistered = false
			self.ParentTrain.IBIS:Trigger(nil)
		end
	end
	
	
	if button == "OpenBOStrab" then
		self:SetPackedBool("BOStrab",true)
		--self:SetPackedBool("BOStrab",false)
	end
	
end



function ENT:TrainSpawnerUpdate()
			

	--local num = self.WagonNumber
	--math.randomseed(num+400)
	
	--self.RearCouple:SetParameters()
	--local tex = "Def_U2"
	--self:UpdateTextures()
	--self:UpdateLampsColors()
	--self.RearCouple.CoupleType = "U2"
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture"))
	--self:SetNW2String("Texture", self.ParentTrain:GetNW2String("Texture").."_b")
	self:SetNW2String("Texture",self.ParentTrain:GetNW2String("Texture").."_b")
	self:UpdateTextures()

end


function ENT:Think()
	self.BaseClass.Think(self)
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*150)

	if self.ParentTrain:GetNW2Bool("RetroMode",false) == true then
		self:SetModel("models/lilly/uf/u2/u2_vintage_b.mdl")
	end
	--PrintMessage(HUD_PRINTTALK, self:GetNW2String("Texture"))
	
	--self:SetLightPower(111,true)
	--self:SetLightPower(112,true)
	--self:SetLightPower(113,true)








	--self:SetNW2Bool("BIsCoupled",self.RearCouple:AreCoupled(self.RearCouple))
    
	

	
	--[[if self.ParentTrain:GetNW2Bool("Braking",true) == true and self.ParentTrain:GetNW2Bool("BIsCoupled",false) == false then
		self:SetLightPower(66,true)
		self:SetLightPower(67,true)
	elseif self.ParentTrain:GetNW2Bool("BIsCoupled",false) == true then
		self:SetLightPower(66,false)
		self:SetLightPower(67,false)
	elseif self.ParentTrain:GetNW2Bool("Braking",true) == false then 
		self:SetLightPower(66,false)
		self:SetLightPower(67,false)
	end]]
	

end
