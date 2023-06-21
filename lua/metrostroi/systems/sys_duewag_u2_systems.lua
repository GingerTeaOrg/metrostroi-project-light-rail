
Metrostroi.DefineSystem("Duewag_U2")
TRAIN_SYSTEM.DontAccelerateSimulation = true 

function TRAIN_SYSTEM:Initialize()
	
	self.PrevTime = 0
	self.DeltaTime = 0
	self.Speed = 0
	self.ThrottleState = 0
	
	self.ThrottleNotchTraction = false
	self.ThrottleNotchBraking = false
	self.ThrottleNotchEmergency = false
	
	self.ActualThrottleState = 0
	
	self.Voltage = 0
	
	self.ResistorBank = 0
	self.CurrentResistor = 0
	self.PrevResistorBank = nil
	self.ResistorChangeRegistered = false
	self.DoorFLState = 100
	self.DoorRLState = 100
	self.DoorFRState = 100
	self.DoorRRState = 100
	
	self.LeadingCabA = 0
	
	self.ResetTrainWires = false
	
	self.Traction = 0
	
	self.Drive = 0
	self.Brake = 0
	self.Reverse = 0
	self.Bell = 0
	self.BitteZuruecktreten = 0
	self.Horn = 0
	self.PantoUp = false
	self.BatteryStartUnlock = false
	self.BatteryOn = false
	self.CabLights = 0
	self.HeadLights = 0
	self.StopLights = 0
	self.FanTimer = 0
	
	
	self.ReverserInserted = false

	self.ReverserInsertedA = false
	self.ReverserInsertedB = false
	
	self.ReverserLeverStateA = 0 --for the reverser lever setting. -1 is reverse, 0 is neutral, 1 is startup, 2 is single unit, 3 is multiple unit
	self.ReverserLeverStateB = 0
	
	
	self.ReverserState = 0 --internal registry for forwards, neutral, backwards


	self.VZ = false -- multiple unit mode
	self.VE = false --single unit mode
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 2.7
	self.TractionCutOut = false
	
	self.ThrottleStateAnim = 0 --whether to stop listening to the throttle input
	self.ThrottleStateAnimB = 0
	
	self.ThrottleCutOut = 0
	
	self.DynamicBraking = false --First stage of braking
	self.TrackBrake = false --Electromagnetic brake
	self.DiscBrake = false --physical friction brake
	
	self.EmergencyBrake = false
	
	self.CloseDoorsButton = false
	
	self.DoorsOpenButton = false
	
	self.Percentage = 0
	
	self.Amps = 0
	
	self.HeadlightsSwitch = false
	
	self.ManualRetainerBrake = false
	
	self.CamshaftMoveTimer = 0
	
	self.CamshaftFinishedMoving = true
	
	self.LeadingUnit = false
	
	self.PrevResistorBank = 0
	
	self.TractionJerk = 0
	
	self.Orientation = 0
	self.ReverseOrientation = 0

	self.IBISKeyA = false
	self.IBISKeyATurned = false

	self.IBISKeyB = false
	self.IBISKeyBTurned = false
	
	
	
end

if CLIENT then return end



function TRAIN_SYSTEM:Inputs()
	return {"HeadlightsSwitch","BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure","ReverserState","ReverserLeverState", "ReverserInserted","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse", "CloseDoorsButton", "DoorsOpenButton"}
end

function TRAIN_SYSTEM:Outputs()
	return { "VE","VZ","ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled","ReverserLeverState"}
end
function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end
	
	--[[if name == "KeyInsert" then self.KeyInsert = value end
	if name == "KeyTurnOn" then self.KeyTurnOn = value end
	if name == "BatteryOn" then self.BatteryOn = value end
	if name == "PantoUp" then self.PantoUp = value end
	if name == "ReverserState" then self.Reverserstate = value end]]
end

--[[function TRAIN_SYSTEM:TriggerOutput(name,value)
--if self[name] then self[name] = value end
if name == "KeyInsert" then self.KeyInsert = value end
if name == "KeyTurnOn" then self.KeyTurnOn = value end
if name == "BatteryOn" then self.BatteryOn = value end
if name == "PantoUp" then self.PantoUp = value end
if name == "ReverserState" then self.Reverserstate = value end
end]]




--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(Train)
	--local train = self.Train 
	self:TriggerInput()
	self:TriggerOutput()
	self:U2Engine()
	self:MUHandler()
	
	self:IsLeadingCab()
	self:IsLeadingUnit()
	
	self.Speed = self.Train.Speed
	
	--PrintMessage(HUD_PRINTTALK,self.ResistorBank)
	
	self.PrevTime = self.PrevTime or RealTime()-0.33
	self.DeltaTime = (RealTime() - self.PrevTime)
	self.PrevTime = RealTime()
	local dT = self.DeltaTime
	
	
	self.ThrottleState = self.ThrottleState + self.ThrottleRate
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	if IsValid(self.Train.u2sectionb) then
		self.Train.u2sectionb:SetNW2Int("ThrottleAnim",self.ThrottleStateAnimB)
	end
	--Is the throttle engaged? We need to know that for a few things!
	if self.ThrottleState > 0 then
		self.ThrottleEngaged = true
		self.Train:SetNW2Bool("ThrottleEngaged",true)
	elseif self.ThrottleState <= 0 then
		self.ThrottleEngaged = false
		self.Train:SetNW2Bool("ThrottleEngaged",false)
	end
	
	

	

	
	self.ReverserLeverStateA = math.Clamp(self.ReverserLeverStateA, -1, 3)
	self.ReverserLeverStateB = math.Clamp(self.ReverserLeverStateB, -1, 3)
	if self.ReverserLeverStateA == 2 or self.ReverserLeverStateB == 2 then
		self.Train:WriteTrainWire(7,1)
		self.Train.Duewag_Battery:TriggerInput("Charge",0.05)
		self.Train.Duewag_Battery.Charging = 1
	elseif self.ReverserLeverStateA == 3 or self.ReverserLeverStateA == 3 then
		self.Train:WriteTrainWire(7,0)
		self.Train:WriteTrainWire(6,0)
		self.Train.Duewag_Battery:TriggerInput("Charge",0.7)
	elseif self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == -1 then
		self.Train:WriteTrainWire(7,0)
		self.Train:WriteTrainWire(6,0)
		self.VE=true
	end
	if self.ReverserLeverStateA == 1 then
		self.Train:SetNW2Float("ReverserAnimate",0.4)
	
	elseif self.ReverserLeverStateA == 0 then
		self.Train:SetNW2Float("ReverserAnimate",0.25)
	
	elseif self.ReverserLeverStateA == 3 then
		self.Train:SetNW2Float("ReverserAnimate",1)
	
	elseif self.ReverserLeverStateA == 2 then
		self.Train:SetNW2Float("ReverserAnimate",0.7)
	
	elseif self.ReverserLeverStateA == -1 then
		self.Train:SetNW2Float("ReverserAnimate",0)
	end

	if self.ReverserLeverStateB == 1 then
		self.Train.u2sectionb:SetNW2Float("ReverserAnimate",0.4)
	
	elseif self.ReverserLeverStateB == 0 then
		self.Train.u2sectionb:SetNW2Float("ReverserAnimate",0.25)
	
	elseif self.ReverserLeverStateB == 3 then
		self.Train.u2sectionb:SetNW2Float("ReverserAnimate",1)
	
	elseif self.ReverserLeverStateB == 2 then
		self.Train.u2sectionb:SetNW2Float("ReverserAnimate",0.7)
	
	elseif self.ReverserLeverStateB == -1 then
		self.Train.u2sectionb:SetNW2Float("ReverserAnimate",0)
	end

	self.Train.u2sectionb:SetNW2Int("ReverserLever",self.ReverserLeverStateB)
	if self.BatteryStartUnlock == false then --Only on the * Setting of the reverser lever should the battery turn on
		self.BatteryOn = self.BatteryOn
		--self.Train:WriteTrainWire(7,self.Train:ReadTrainWire(7))
	elseif self.BatteryStartUnlock == true then
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn",false)
		if self.Train:GetNW2Bool("BatteryOn",false) == true then
			self.Train:WriteTrainWire(7,1)
		end
		if self.Train:GetNW2Bool("BatteryOn",false) == false then
			self.Train:WriteTrainWire(7,0)
		end
	elseif self.BatteryStartUnlock == true or self.Train:ReadTrainWire(7) == 1 then --Except if the leading cab turns the batteries on for the entire train
		self.BatteryOn = true
		self.Train:SetNW2Bool("BatteryOn",true)
	end
	
	
	
	
	if self.Train:GetNW2Bool("BatteryOn",false) == true then --if the battery is on, we can command the pantograph
		self.PantoUp = self.Train:GetNW2Bool("PantoUp")
	end
	
	self.Train:SetNW2Bool("ReverserInserted",self.ReverserInsertedA or self.ReverserInsertedB)
	
	if self.ReverserInsertedA or self.ReverserInsertedB then
		self.Train:TriggerInput("DriversWrenchPresent",1)
	else
		self.Train:TriggerInput("DriversWrenchPresent",0)
	end
	
	if self.Train:GetNW2Bool("EmergencyBrake",false) == true then
		self.EmergencyBrake = true
	else
		self.EmergencyBrake = false
	end
	
	if self.EmergencyBrake == true then
		if self.TractionConditionFulfilled == true then
			self.Train:WriteTrainWire(10,1)
		end
	else
		self.Train:WriteTrainWire(10,0)
	end
	
	
	
	
	if self.Train:GetNW2Bool("BatteryOn",false) == true or self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(7) > 0 then --if either the battery is on or the EMU cables signal multiple unit mode
		
		if self.Train.Duewag_Deadman.IsPressed > 0 then --set up the deadman state as a wire, for easier adaptation into the consist
			self.Train:WriteTrainWire(12,1)
		elseif self.Train.Duewag_Deadman.IsPressed < 1 then
			self.Train:WriteTrainWire(12,0)
		end
		
		
		if self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(12) > 0 then
			self.TractionConditionFulfilled = true
		elseif self.Train:ReadTrainWire(6) < 1 and self.Train.Duewag_Deadman.IsPressed > 0 then
			self.TractionConditionFulfilled = true
		elseif self.Train:ReadTrainWire(6) < 1 and self.Train.Duewag_Deadman.IsPressed < 1 then
			self.TractionConditionFulfilled = false
		elseif self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(12) < 1 then
			self.TractionConditionFulfilled = false
		end
		
		if self.ReverserState == 1 and self.Train.Duewag_Deadman.IsPressed == 1 then
			self.TractionConditionFulfilled = true
			
		elseif self.ReverserState == 1 and self.Train.Duewag_Deadman.IsPressed == 0 then
			self.TractionConditionFulfilled = false
			
		elseif self.ReverserState == -1 and self.Train.Duewag_Deadman.IsPressed == 0 then
			self.TractionConditionFulfilled = false
			
		elseif self.ReverserState == -1 and self.Train.Duewag_Deadman.IsPressed == 1 then
			self.TractionConditionFulfilled = true
			
		elseif self.ReverserState == 0 then
			self.TractionConditionFulfilled = false
		elseif self.Train:ReadTrainWire(3) > 0 and self.Train:ReadTrainWire(6) > 0 or self.Train:ReadTrainWire(4) > 0 then
			self.TractionConditionFulfilled = true
		end
		
		if self.ReverserState == 1 and self.Train.Duewag_Deadman.IsPressed == 0 and self.ThrottleState > 0 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",true)
		elseif self.ReverserState == -1 and self.Train.Duewag_Deadman.IsPressed == 0 and self.ThrottleState > 0 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",true)
		elseif self.ReverserState == -1 and self.Train.Duewag_Deadman.IsPressed == 0 and self.ThrottleState <= 0 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",false)
		elseif self.ReverserState == 1 and self.Train.Duewag_Deadman.IsPressed == 0 and self.ThrottleState <= 0 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",false)
		elseif self.ReverserState == 1 and self.Train.Duewag_Deadman.IsPressed == 1 and self.ThrottleState < 0 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",false)
		elseif self.ReverserState == -1 and self.Train.Duewag_Deadman.IsPressed == 1 then
			self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman",false)
		end
	end
	
	----print(tostring(self.VZ).."VZ")
	
	
	if self.Train.Panel.BlinkerLeft > 0 then
		self.Train:SetNW2Float("BlinkerStatus",1)
	elseif self.Train.Panel.BlinkerRight > 0 and self.Train.Panel.BlinkerLeft < 1 then
		self.Train:SetNW2Float("BlinkerStatus",0)
	elseif self.Train.Panel.BlinkerLeft < 1 and self.Train.Panel.BlinkerRight < 1 then
		self.Train:SetNW2Float("BlinkerStatus",0.5)
	end
	
	if self.TractionConditionFulfilled == true then
		if self.Train:GetNW2Bool("DeadmanTripped",false) == false then
			
			if self.CamshaftFinishedMoving == true then
				self.Traction = math.Clamp(self.ThrottleState * 0.01,-100,100)
			else
				self.Traction = self.Traction
			end 
			if self.VZ == true then
				if self.Traction > 0 then
					self.Train:WriteTrainWire(2,0)
					self.Train:WriteTrainWire(1,math.Clamp(self.Traction,0,100))
					self.Train:SetNW2Bool("ElectricBrakes",false)
					self.Train:SetNW2Int("BrakePressure",0)
					self.BrakePressure = 0
					
					----print("traction applied")
					
				elseif self.Traction <= 0 then
					----print("braking applied")
					self.Train:WriteTrainWire(2,1)
					if self.Speed > 3.5 and self.Train:ReadTrainWire(2) > 0 then
						self.Train:WriteTrainWire(1,self.Traction)
					elseif self.Speed < 5 and self.Train:ReadTrainWire(2) > 0 and self.Train:ReadTrainWire(5) == 2.7 then
						self.Traction = 0
						self.Train:WriteTrainWire(1,self.Traction)
					elseif self.Speed > 5 and self.Train:ReadTrainWire(2) > 0 and self.Train:ReadTrainWire(5) < 2.7 then
						self.Traction = self.Traction
						self.Train:WriteTrainWire(1,self.Traction)
					end
				end
				
				
				if self.Traction == 0 then
					self.Train:WriteTrainWire(1,self.Traction)	
				end
			elseif self.VE == true or self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == -1 then
				if self.Traction > 0 then
					self.Traction = self.Traction
					self.BrakePressure = 0
					print("ve sys")
				end
				if self.Traction < 0 and self.Speed > 3.5 then
					self.Traction = self.Traction
				elseif self.Traction < 0 and self.Speed < 5 then
						self.Traction = 0
						self.BrakePressure = 4
				elseif self.Speed < 0.2 and self.Traction < 0 then
						self.Traction = self.Traction
						self.BrakePressure = 2.7
				elseif self.Traction == 0 then
						self.Traction = self.Traction
					self.BrakePressure = self.BrakePressure
				end
			end
			if self.Train:ReadTrainWire(6) < 1 then
				if self.ReverserLeverStateA == -1 or self.ReverserLeverStateB == 3 then
					self.ReverserState = -1
				elseif self.ReverserLeverStateA == 3 or self.ReverserLeverStateB == -1 then
					self.ReverserState = 1
				end
			end
			
			
			--end
		elseif self.Train:GetNW2Bool("DeadmanTripped",false) == true then
			
		end
	end		
	
	
	if self.ThrottleState <= 100 then --Throttle animation handling. Adapt the value to the pose parameter on the model
		self.ThrottleStateAnim = self.ThrottleState / 200 + 0.5
	elseif (self.ThrottleState >= 0) then
		self.ThrottleStateAnim = (self.ThrottleState * -0.1)
		
	end		
	
	if self.ThrottleState < 0 and self.Speed < 8 or self.Train:ReadTrainWire(10) > 0 then --Pneumatic Brakes engaged when electric brakes have brought down the speed to very low
		
		if self.Train:ReadTrainWire(6) > 0 then --in MU mode we write that to the train wire for the train script to handle
			self.Train:WriteTrainWire(5,2.7)
			----print("Brake applied")
			
		elseif self.Train:ReadTrainWire(6) < 1 then --in single unit mode we write that directly to the brake pressure
			self.BrakePressure = 2.7
			
		end
		
	elseif self.ThrottleState > 0 then
		if self.Train:ReadTrainWire(6) > 0 then --in MU mode we write that to the train wire for the train script to handle
			self.Train:WriteTrainWire(5,0)
			----print("brake released")
			self.BrakePressure = 0
		elseif self.Train:ReadTrainWire(6) < 1 then --in single unit mode we write that directly to the brake pressure
			self.BrakePressure = 0
			
		end
		
	end
	
	if self.ThrottleState > 0 and self.Train:GetNW2Float("Speed",0) < 3 then
		
		if self.Train:ReadTrainWire(6) == 1 then
			
			self.Train:WriteTrainWire(5,0)
			
		elseif self.Train:ReadTrainWire(6) == 0 then
			
			self.BrakePressure = 0
			self.Train:SetNW2Int("BrakePressure",0)
		end
		
	end
	
	
	
	if self.Train.DepartureConfirmed == true then
		self.Train:WriteTrainWire(9,0)
		----print("Departure confirmed")
	else
		self.Train:WriteTrainWire(9,1)
	end
	
	
	
	
end


function TRAIN_SYSTEM:U2Engine()
	
	--275A per motor, 2x275A, 600V, 20 resistors, 27,5A per resistor
	self.Percentage = math.abs(self.ThrottleState)
	
	if self.Percentage == 0 then
		self.ResistorBank = 0
	elseif self.Percentage <= 5 and self.Percentage > 0 then
		self.ResistorBank = 1
	elseif self.Percentage >= 10 and self.Percentage < 15 then
		self.ResistorBank = 2
	elseif self.Percentage >= 15 and self.Percentage < 20 then
		self.ResistorBank = 3
	elseif self.Percentage >= 20 and self.Percentage < 25 then
		self.ResistorBank = 4
	elseif self.Percentage >= 25 and self.Percentage < 30 then
		self.ResistorBank = 5
	elseif self.Percentage >= 30 and self.Percentage < 35 then
		self.ResistorBank = 6
	elseif self.Percentage >= 35 and self.Percentage < 40 then
		self.ResistorBank = 7
	elseif self.Percentage >= 40 and self.Percentage < 45 then
		self.ResistorBank = 8
	elseif self.Percentage >= 45 and self.Percentage < 50 then
		self.ResistorBank = 9
	elseif self.Percentage >= 50 and self.Percentage < 55 then
		self.ResistorBank = 10
	elseif self.Percentage >= 55 and self.Percentage < 60 then
		self.ResistorBank = 11
	elseif self.Percentage >= 60 and self.Percentage < 65 then
		self.ResistorBank = 12
	elseif self.Percentage >= 65 and self.Percentage < 70 then
		self.ResistorBank = 13
	elseif self.Percentage >= 70 and self.Percentage < 75 then
		self.ResistorBank = 14
	elseif self.Percentage >= 75 and self.Percentage < 80 then
		self.ResistorBank = 15
	elseif self.Percentage >= 80 and self.Percentage < 85 then
		self.ResistorBank = 16
	elseif self.Percentage >= 85 and self.Percentage < 90 then
		self.ResistorBank = 17
	elseif self.Percentage >= 90 and self.Percentage < 95 then
		self.ResistorBank = 18
	elseif self.Percentage >= 95 and self.Percentage < 100 then
		self.ResistorBank = 19
	elseif self.Percentage == 100 then
		self.ResistorBank = 20
	end
	
	
	
	
	
	if self.ResistorBank ~= self.CurrentResistor then
		self.CamshaftMoveTimer = CurTime()
		self.ResistorChangeRegistered = true
		self.PrevResistorBank = self.CurrentResistor
		self.CurrentResistor = self.ResistorBank
		self.CamshaftFinishedMoving = false
	elseif self.ResistorBank == self.CurrentResistor then
		self.ResistorChangeRegistered = false
		self.Train:SetNW2Bool("CamshaftMoved",false)
		if self.CamshaftFinishedMoving == true then
			self.CamshaftMoveTimer = 0
		end
	end
	
	if self.ReverserState ~= 0 then --camshaft only moves when you're actually in gear
		if CurTime() - self.CamshaftMoveTimer > 0.4  then
			self.CamshaftFinishedMoving = true
			self.Train:SetNW2Bool("CamshaftMoved",true)
			
			
		end
		
		
	end
	
	
	if math.abs(self.Train.FrontBogey.Acceleration) > 0 then
		self.Amps = 300000 / 600 * self.Percentage * 0.0000001 * math.Round(self.Train.FrontBogey.Acceleration,1)
		
	elseif self.Train.FrontBogey.Acceleration < 0 then
		self.Amps = 300000 / 600 * self.Percentage * 0.0000001 * math.Round(self.Train.FrontBogey.Acceleration*-1,1)
	end
	
	
	self.Train:SetNW2Float("Amps",self.Amps)
end

function TRAIN_SYSTEM:IsLeadingCab()
	local output
	if self.ReverserInsertedA == true and self.VZ == true then
		output = true
	elseif self.ReverserInsertedA == false and self.VZ == true then
		output = false
	end
	return output
end

function TRAIN_SYSTEM:IsLeadingUnit()
	if self.VZ == true and self.Train.FrontCouple.CoupledEnt == nil then
		
		self.LeadingUnit = true
	else
		self.LeadingUnit = false
	end
	
end

function TRAIN_SYSTEM:MUHandler()
	
	
	if self.BatteryStartUnlock == true then --if we're allowed to turn on the battery, turn it on
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn")
	end
	
	if self.BatteryOn == true and self.Train:ReadTrainWire(6) > 0 then
		self.Train:WriteTrainWire(7,1)
	elseif self.BatteryOn == false and self.Train:ReadTrainWire(7) > 0 then
		self.Train:WriteTrainWire(7,0)
	end
	
	
	
	---------------------------------------------------------------------------------------------------------
	
	
	
	--Set reverser logic directly if we're the leading unit
	if self.ReverserLeverStateA == 0 then
		if self.LeadingCabA == 1 then
			self.ReverserState = 0
			--self.Train:WriteTrainWire(3,0)
			--self.Train:WriteTrainWire(4,0)
		elseif self.LeadingCabA == 0 then
			if self.Train:ReadTrainWire(6) < 1 then
				self.VE = false
				self.VZ = false
			elseif self.Train:ReadTrainWire(6) > 0 then
				self.VE = false
				self.VZ = true
			end
		end
		
		--self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverStateA == -1 and self.ReverserLeverStateB == 0 then
		if self.LeadingCabA == 1 then
			self.ReverserState = -1
		end
		self.VE = true
		self.VZ = false
		self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverStateA == 1 and self.ReverserLeverStateB == 0 then
		if self.LeadingCabA == 1 then
			self.ReverserState = 0
		end
		self.BatteryStartUnlock = true
		self.VE = false
		self.VZ = false
		--self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverStateA == 2 and self.ReverserLeverStateB == 0 then
		self.VZ = true
		self.VE = false
		self.ReverserState = 1
		
		self.Train:WriteTrainWire(3,1)
		self.Train:WriteTrainWire(6,1)
		----print(self.Train.FrontBogey.BrakeCylinderPressure)
	elseif self.ReverserLeverStateA == 3 and self.ReverserLeverStateB == 0 then --We're at position 3 of the reverser forwards, that means we don't talk to coupled units.
		self.VZ = false
		self.VE = true
		if self.LeadingCabA == 1 then
			--self.Train:WriteTrainWire(6,0)
			self.ReverserState = 1
		end

	elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == -1 then
		if self.LeadingCabA == 1 then
			self.ReverserState = -1
		end
		self.VE = true
		self.VZ = false
		--self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 0 then
		if self.LeadingCabA == 1 then
			self.ReverserState = 0
		end
		self.BatteryStartUnlock = true
		self.VE = false
		self.VZ = false
		--self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 2 then
		self.VZ = true
		self.VE = false
		self.ReverserState = 1
		
		self.Train:WriteTrainWire(3,0)
		self.Train:WriteTrainWire(4,1)
		self.Train:WriteTrainWire(6,1)
		----print(self.Train.FrontBogey.BrakeCylinderPressure)
	elseif self.ReverserLeverStateA == 0 and self.ReverserLeverStateB == 3 then --We're at position 3 of the reverser forwards, that means we don't talk to coupled units.
		self.VZ = false
		self.VE = true
		if self.LeadingCabA == 1 then
			--self.Train:WriteTrainWire(6,0)
			self.ReverserState = 1
		end
	end
	if self.ReverserInsertedA == true then
		self.Train:WriteTrainWire(3,self.ReverserLeverStateA == 2 and 1 or 0)
		self.Train:WriteTrainWire(4,(self.ReverserLeverStateA == 0 or self.ReverserLeverStateA == 3) and 1 or 0)
	elseif self.ReverserInsertedB == true then
		self.Train:WriteTrainWire(3,(self.ReverserLeverStateB == 0 or self.ReverserLeverStateB == 3) and 1 or 0)
		self.Train:WriteTrainWire(4,self.ReverserLeverStateB == 2 and 1 or 0)
	end
	self.Train:WriteTrainWire(6,self.VZ and 1 or 0)
	if self.LeadingCabA == 0 and self.Train:ReadTrainWire(6) > 0 then --if we're not the leading train, read this stuff from train wires
		self.VZ = true
		if self.Train:ReadTrainWire(3) > 0 and self.Train:ReadTrainWire(4) < 1 then --wire 3 high and wire 4 high that means
			self.ReverserState = 1	--forwards
			
		elseif self.Train:ReadTrainWire(3) < 1 and self.Train:ReadTrainWire(4) > 0 then --opposite means backwards
			self.ReverserState = -1
		elseif self.Train:ReadTrainWire(3) < 1 and self.Train:ReadTrainWire(4) < 1 then
			self.ReverserState = 0
		end
	elseif self.LeadingCabA == 1 and self.Train:ReadTrainWire(6) < 1 then
		self.VZ = false
	end
	
	--print("MUWire"..self.Train:ReadTrainWire(6))
	
	---------------------------------------------------------------------------------------
	
	if self.Train:ReadTrainWire(10) > 0 then --if the emergency brake is pulled high
		if self.Speed >= 2 then --if the speed is greater than 2 (tolerances for inaccuracies registered due to wobble)
			self.ThrottleState = -100 --Register the throttle to be all the way back
			self.Traction = -100
		elseif self.Speed < 2 then
			self.Traction = 0
		end
		self.Train.FrontBogey.BrakePressure = 2.7
		self.Train.MiddleBogey.BrakePressure = 2.7
		self.Train.RearBogey.BrakePressure = 2.7
		self.BrakePressure = 2.7
	else 
		self.Train.FrontBogey.BrakePressure = self.Train.FrontBogey.BrakePressure
		self.Train.MiddleBogey.BrakePressure = self.Train.MiddleBogey.BrakePressure
		self.Train.RearBogey.BrakePressure = self.Train.RearBogey.BrakePressure
		self.ThrottleState = self.ThrottleState
		self.Traction = self.Traction
	end
	
	
	if self.ThrottleState ~= 0 and self.ReverserState ~= 1 and self.ReverserState ~= 0 and self.BatteryOn == true then
		self.FanTimer = CurTime()
		self.Train:SetNW2Bool("Fans",true)
	elseif self.BatteryOn == false then
		self.Train:SetNW2Bool("Fans",false)
	end
	
	if CurTime() - self.FanTimer > 5 and self.Speed < 5 then
		
		self.Train:SetNW2Bool("Fans",false)
		
	end

	if self.BatteryOn == false or self.Train:ReadTrainWire(7) < 1 then
		self.Train:WriteTrainWire(3,0)
		self.Train:WriteTrainWire(4,0)
		self.Train:WriteTrainWire(6,0)
	end
	
	
	--print(self.Train:GetNW2Bool("Fans"))
end