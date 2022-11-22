
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
	--self.PrevResistorBank = nil
	self.DoorFLState = 100
	self.DoorRLState = 100
	self.DoorFRState = 100
	self.DoorRRState = 100



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
	
	self.ReverserInserted = false
	self.ReverserState = 0
	self.ReverserLeverState = 0 --for the reverser lever setting. -1 is reverse, 0 is neutral, 1 is startup, 2 is single unit, 3 is multiple unit

	self.VZ = false --single unit mode
	self.VE = false --multiple unit mode
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 0
	self.TractionCutOut = false
	
	self.ThrottleStateAnim = 0 --whether to stop listening to the throttle input

	self.ThrottleCutOut = 0

	self.DynamicBraking = false --First stage of braking
	self.TrackBrake = false --Electromagnetic brake
	self.DiscBrake = false --physical friction brake



	self.CloseDoorsButton = false

	self.DoorsOpenButton = false
	
	

end

if CLIENT then return end

function TRAIN_SYSTEM:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time


end


function TRAIN_SYSTEM:Inputs()
	return {"BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure","ReverserState","ReverserLeverState", "ReverserInserted","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse", "CloseDoorsButton", "DoorsOpenButton"}
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



	self.PrevTime = self.PrevTime or RealTime()-0.33
    	self.DeltaTime = (RealTime() - self.PrevTime)
    	self.PrevTime = RealTime()
	local dT = self.DeltaTime

	
	self.ThrottleState = self.ThrottleState + self.ThrottleRate --* dT * 2 --todo: enable deltaTime correction
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)

	--[[if self.ThrottleState >= 1 and self.ThrottleState <= 5 then
		self.ThrottleNotchTraction = true
		self.ActualThrottleState = 6
	elseif self.ThrottleState > 5 then
		self.ThrottleNotchTraction = false
		self.ActualThrottleState = self.ThrottleState
	elseif self.ThrottleState <= -1 and self.ThrottleState >= -5 then
		self.ThrottleNotchBraking = true
		self.ActualThrottleState = -6
	elseif self.ThrottleState <= -6 and self.ThrottleState =< -89 then
		self.ActualThrottleState = self.ThrottleState
	elseif self.ThrottleState <= -90 and self.ThrottleState >= -100 then
		self.ThrottleNotchEmergency = true
		self.ActualThrottleState = -100
	end]]


	--print(#self.Train.WagonList)

	--print(self.Train)


	--Is the throttle engaged? We need to know that for a few things!
	if self.ThrottleState > 0 then
		self.ThrottleEngaged = true
		self.Train:SetNW2Bool("ThrottleEngaged",true)
	elseif self.ThrottleState <= 0 then
		self.ThrottleEngaged = false
		self.Train:SetNW2Bool("ThrottleEngaged",false)
	end

	
	--Set reverser logic either directly or if the train wire 6 is applied, read it from there VE=single traction
	if self.ReverserLeverState == 0 and self.Train:ReadTrainWire(6) == 0 then
		self.ReverserState = 0
		self.VE = false
		self.VZ = false
	elseif self.ReverserLeverState == -1 then
		self.ReverserState = -1
		self.VE = true
		self.VZ = false
		self.Train:WriteTrainWire(6,0)
	elseif self.ReverserLeverState == 1 then
		self.ReverserState = 0
		self.BatteryStartUnlock = true
		self.VE = false
		self.VZ = false
	elseif self.ReverserLeverState == 2 then
		self.VZ = true
		self.Train:WriteTrainWire(6,1)
		if self.Train:ReadTrainWire(3) == 1 then
			self.ReverserState = 1
		elseif self.Train:ReadTrainWire(4) == 1 then
			self.ReverserState = -1
		end
	elseif self.Train:ReadTrainWire(6) == 1 or self.ReverserLeverState == 2 then
		self.VZ = true
		if self.Train:ReadTrainWire(3) == 1 then
			self.ReverserState = 1
		elseif self.Train:ReadTrainWire(4) == 1 then
			self.ReverserState = -1
		end
	elseif self.Train:ReadTrainWire(6) == 1 and self.ReverserLeverState == 3 then
		self.VZ = false
		self.VE = true
		self.Train:WriteTrainWire(6,0)
	end
	math.Clamp(self.ReverserLeverState, -1, 3)
	
	if self.ReverserLeverState == 2 then
		self.VZ = true
		self.VE = false
		self.ReverserState = 1
		self.Train:WriteTrainWire(6,1)
	end

	if self.ReverserLeverState == 3 then
		self.VZ = false
		self.VE = true
		self.ReverserState = 1
		self.Train:WriteTrainWire(6,0)
	end

	if self.BatteryStartUnlock == false then --Only on the * Setting of the reverser lever should the battery turn on
		self.BatteryOn = self.BatteryOn
		self.Train:WriteTrainWire(7,self.Train:ReadTrainWire(7))
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



	self.ReverserLeverState = math.Clamp(self.ReverserLeverState, -2, 3)



	-- Implement reverser state via two separate train wires, so that train wires can be crossed for proper MU setup
	if self.ReverserState == 1 then
		self.Train:WriteTrainWire(3,1)
		self.Train:SetNW2Int("ReverserState",1)
	elseif self.ReverserState == -1 then
		self.Train:WriteTrainWire(4,1)
		self.Train:SetNW2Int("ReverserState",-1)
	elseif self.ReverserState == 1 then
		self.Train:WriteTrainWire(3,0)
		self.Train:WriteTrainWire(4,0)
		self.Train:SetNW2Int("ReverserState",0)

	end


	



	

	--self.BrakePressure = math.Clamp(self.ThrottleState,-100,0)  * -0.01 * 2.7 --convert to positive value and put in percentage relation of maximum brake value



	--if self.ThrottleState < 0 then


	









	


	if self.BatteryStartUnlock == true then --if we're allowed to turn on the battery, turn it on
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn")
	end

	if self.Train:GetNW2Bool("BatteryOn",false) == true then --if the battery is on, we can command the pantograph
		self.PantoUp = self.Train:GetNW2Bool("PantoUp")
	end


	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted") --get from the train whether the reverser is present
	
	
	
	
	if self.Train:GetNW2Bool("BatteryOn",false) == true or self.Train:ReadTrainWire(6) == 1 and self.Train:ReadTrainWire(7) == 1--[[and self.PantoUp == true]] then --if either the battery is on or the EMU cables signal multiple unit mode

		if self.ReverserState == 1 then
			self.TractionConditionFulfilled = true
		end
		if self.ReverserState == -1 then
			self.TractionConditionFulfilled = true
		end
		if self.ReverserState == 0 then
			self.TractionConditionFulfilled = false
		end
	end
		
		
	if self.TractionConditionFulfilled == true then
		--self.Traction = 15000*self.ThrottleState / 20
		if self.Train:GetNW2Bool("DeadmanTripped",false) == false then
			--if self.Train.BatteryOn == true or self.Train:ReadTrainWire(7) == 1 then
				self.Traction = math.Clamp(self.ThrottleState * 0.01 * 800,-800,800) --right now it's coupled directly to the throttle. This needs a somewhat realistic custom simulation, if we don't get schematics
				if self.VZ == true then
					if self.Traction > 0 then
						self.Train:WriteTrainWire(2,0)
						self.Train:WriteTrainWire(1,math.Clamp(self.Traction,0,600))
						self.Train:SetNW2Bool("ElectricBrakes",false)
						self.Train:SetNW2Int("BrakePressure",0)
						self.BrakePressure = 0
						
					
					end
					if self.Traction < 0 then
					
						self.Train:WriteTrainWire(2,1)
						self.Train:WriteTrainWire(1,self.Traction * -1)
						if self.Speed < 2.5 and self.Train:ReadTrainWire(2) == 1 and self.Train:ReadTrainWire(5) == 2.7 then
							self.Traction = 0
						elseif self.Speed > 2 and self.Train:ReadTrainWire(2) == 1 and self.Train:ReadTrainWire(5) == 0 then
							self.Traction = self.Traction
						end
					end

					if self.Traction == 0 then
						self.Train:WriteTrainWire(1,self.Traction)
						--self.Train:WriteTrainWire(2,0)
					end
				elseif self.VE == true then
					if self.Traction > 0 then
						self.Traction = self.Traction
						--self.Train:WriteTrainWire(2,0)
						--self.BrakePressure = 0
					end
					if self.Traction < 0 then
						self.Traction = self.Traction * -1
						if self.Speed < 2.5 and self.ThrottleState < 0 and self.BrakePressure == 2.7 then
							self.Traction = 0
						elseif self.Speed > 2 and self.ThrottleState > 0 and self.BrakePressure == 0 then
							self.Traction = self.Traction
						end
					end
					if self.Traction == 0 then
						self.Traction = self.Traction
						--self.BrakePressure = 0
					end
				end


			
			--end
		elseif self.Train:GetNW2Bool("DeadmanTripped",false) == true then
			if self.Speed > 5 then
				self.Traction = -1000 
				self.BrakePressure = 2.7
				self.Train:WriteTrainWire(1,self.Traction)
			elseif self.Speed < 5 then
				self.BrakePressure = 2.7
				self.Traction = 0
				self.Train:WriteTrainWire(1,self.Traction)
			end
		end
	end		
	

	if self.ThrottleState <= 100 then --Throttle animation handling. Adapt the value to the pose aprameter on the model
		self.ThrottleStateAnim = self.ThrottleState / 200 + 0.5
	elseif (self.ThrottleState >= 0) then
		self.ThrottleStateAnim = (self.ThrottleState * -0.1)
		
	end		
				
	if self.ThrottleState < 0 and self.Train:GetNW2Float("Speed",0) < 8 then --Pneumatic Brakes engaged when electric brakes have brought down the speed to very low
 
			if self.Train:ReadTrainWire(6) == 1 then --in MU mode we write that to the train wire for the train script to handle
				self.Train:WriteTrainWire(5,2.7)
			

			elseif self.Train:ReadTrainWire(6) == 0 then --in single unit mode we write that directly to the brake pressure
				self.BrakePressure = 2.7
				self.Train:SetNW2Int("BrakePressure",2.7)
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
	--[[if self.ThrottleState == 0 and self.Train:GetNW2Float("Speed",0) < 3 then
 
		if self.Train:ReadTrainWire(6) == 1 then
			--self.Train:WriteTrainWire(5,0)
		

		elseif self.Train:ReadTrainWire(6) == 0 then
			self.BrakePressure = 0
			self.Train:SetNW2Int("BrakePressure",0)
		end
	
	end]]

	if self.Train:GetNW2Bool("DepartureConfirmed",false) == true then
		self.Train:WriteTrainWire(9,1)
	elseif
		self.Train:GetNW2Bool("DepartureConfirmed",false) == false then
			self.Train:WriteTrainWire(9,0)
	end



	
end


function TRAIN_SYSTEM:U2Engine()

	local Percentage

	if self.ThrottleState >= 0 then
		Percentage = self.ThrottleState
	elseif self.ThrottleState < 0 then
		Percentage = self.ThrottleState * -1
	end

	if Percentage <= 5 and Percentage > 0 then
		self.ResistorBank = 1
	elseif Percentage >= 10 and Percentage < 15 then
		self.ResistorBank = 2
	elseif Percentage >= 15 and Percentage < 20 then
		self.ResistorBank = 3
	elseif Percentage >= 20 and Percentage < 25 then
		self.ResistorBank = 4
	elseif Percentage >= 25 and Percentage < 30 then
		self.ResistorBank = 5
	elseif Percentage >= 30 and Percentage < 35 then
		self.ResistorBank = 6
	elseif Percentage >= 35 and Percentage < 40 then
		self.ResistorBank = 7
	elseif Percentage >= 40 and Percentage < 45 then
		self.ResistorBank = 8
	elseif Percentage >= 45 and Percentage < 50 then
		self.ResistorBank = 9
	elseif Percentage >= 50 and Percentage < 55 then
		self.ResistorBank = 10
	elseif Percentage >= 55 and Percentage < 60 then
		self.ResistorBank = 11
	elseif Percentage >= 60 and Percentage < 65 then
		self.ResistorBank = 12
	elseif Percentage >= 65 and Percentage < 70 then
		self.ResistorBank = 13
	elseif Percentage >= 70 and Percentage < 75 then
		self.ResistorBank = 14
	elseif Percentage >= 75 and Percentage < 80 then
		self.ResistorBank = 15
	elseif Percentage >= 80 and Percentage < 85 then
		self.ResistorBank = 16
	elseif Percentage >= 85 and Percentage < 90 then
		self.ResistorBank = 17
	elseif Percentage >= 90 and Percentage < 95 then
		self.ResistorBank = 18
	elseif Percentage >= 95 and Percentage < 100 then
		self.ResistorBank = 19
	elseif Percentage == 100 then
		self.ResistorBank = 100
	end

	self.PrevResistorBank = self.PrevResistorBank or self.ResistorBank


	if self.PrevResistorBank ~=  self.ResistorBank then
		self.Train:SetNW2Bool("CamshaftMove",true)
		self.Train:SetNW2Bool("CamshaftMove",false)
		--print("CamshaftMove")
		--self.PrevResistorBank = self.PrevResistorBank or self.ResistorBank
		self.PrevResistorBank = self.ResistorBank
	end

	if self.Train:GetNW2Bool("CamshaftMove",false) == true then
		print("CamshaftMove")
	end
end
