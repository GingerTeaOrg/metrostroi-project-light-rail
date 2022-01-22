
Metrostroi.DefineSystem("Duewag_U2")
TRAIN_SYSTEM.DontAccelerateSimulation = true 

function TRAIN_SYSTEM:Initialize()

	self.PrevTime = 0
	self.DeltaTime = 0
	self.Speed = 0
	self.ThrottleState = 0
	
	self.Traction = 0
	
	self.Drive = 0
	self.Brake = 0
	self.Reverse = 0
	self.Igbt74 = 0
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
	self.ReverserLeverState = 0

	self.VZ = false
	self.VE = false
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 0
	self.TractionCutOut = false
	self.Haltebremse = 0
	self.ThrottleStateAnim = 0

	self.ThrottleCutOut = 0

	self.Haltebremse = false
	

end

if CLIENT then return end

function TRAIN_SYSTEM:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time


end


function TRAIN_SYSTEM:Inputs()
	return {"BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure","ReverserState","ReverserLeverState", "ReverserInserted","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse"}
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
	--self.TriggerInput()
	--self.TriggerOutput()
	
	self.PrevTime = self.PrevTime or RealTime()-0.33
    self.DeltaTime = (RealTime() - self.PrevTime)
    self.PrevTime = RealTime()
	local dT = self.DeltaTime

	
	self.ThrottleState = self.ThrottleState + self.ThrottleRate --* dT * 2
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	
	--print(#self.Train.WagonList)


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

	if self.BatteryStartUnlock == false then --Only on the * Setting onf the reverser lever should the battery turn on
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
	elseif self.BatteryStartUnlock == true or self.Train:ReadTrainWire(7) == 1 then --Except that the leading cab turns the batteries on for the entire train
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


	









	


	if self.BatteryStartUnlock == true then
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn")
	end

	if self.Train:GetNW2Bool("BatteryOn",false) == true then
		self.PantoUp = self.Train:GetNW2Bool("PantoUp")
	end


	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted")
	
	
	
	
	if self.Train:GetNW2Bool("BatteryOn",false) == true or self.Train:ReadTrainWire(6) == 1 and self.Train:ReadTrainWire(7) == 1--[[and self.PantoUp == true]] then

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
		if not self.Train:GetNW2Bool("DeadmanTripped",false) == true then
			--if self.Train.BatteryOn == true or self.Train:ReadTrainWire(7) == 1 then
				self.Traction = math.Clamp(self.ThrottleState * 0.01 * 800,-800,800)
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
		elseif 
			self.Train:GetNW2Bool("DeadmanTripped",false) == true then
			self.Traction = 0 
			self.BrakePressure = 2.7
			self.Train:WriteTrainWire(1,self.Traction)
		end
	end		
	

	if self.ThrottleState <= 100 then
		self.ThrottleStateAnim = self.ThrottleState / 200 + 0.5
	elseif (self.ThrottleState >= 0) then
		self.ThrottleStateAnim = (self.ThrottleState * -0.1)
		
	end		
				
	if self.ThrottleState < 0 and self.Train:GetNW2Float("Speed",0) < 2.5 then --Pneumatic Brakes engaged when electric brakes have brought down the speed to very low
 
			if self.Train:ReadTrainWire(6) == 1 then
				self.Train:WriteTrainWire(5,2.7)
			

			elseif self.Train:ReadTrainWire(6) == 0 then
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
	if self.ThrottleState == 0 and self.Train:GetNW2Float("Speed",0) < 3 then
 
		if self.Train:ReadTrainWire(6) == 1 then
			--self.Train:WriteTrainWire(5,0)
		

		elseif self.Train:ReadTrainWire(6) == 0 then
			--self.BrakePressure = 0
			--self.Train:SetNW2Int("BrakePressure",0)
		end
	
	end



	--[[if self.VZ == true then
			self.VE = false

	elseif self.VE == true then

			self.VZ = false
	end]]
	--[[if self.Speed > 81 then
		
		if self.Train:ReadTrainWire(6) == 1 then
			self.Traction = 100
			self.Train:WriteTrainWire(2,1)
			self.Train:SetNW2Bool("Speedlimiter",true)
		elseif self.Train:ReadTrainWire(6) == 0 then
			self.Train:SetNW2Bool("Speedlimiter",true)
			self.Traction = 100
		end
	elseif self.Speed < 80 then
		self.Traction = self.Traction
		if self.Train:GetNW2Bool("Speedlimiter",false) == true then
			self.Train:WriteTrainWire(2,0)
			self.Train:SetNW2Bool("Speedlimiter",false)
		end
	end]]



	
end

