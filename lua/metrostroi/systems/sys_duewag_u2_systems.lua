
Metrostroi.DefineSystem("Duewag_U2")
--TRAIN_SYSTEM.DontAccelerateSimulation = false

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
	self.BatteryOn = false
	self.KeyInsert = false
	self.KeyTurnOn = false
	self.CabLights = 0
	self.HeadLights = 0
	self.StopLights = 0
	
	self.ReverserInserted = false
	self.ReverserState = 0
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 0
	self.TractionCutOut = false
	self.Haltebremse = 0
	

end

if CLIENT then return end

function TRAIN_SYSTEM:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time


end


function TRAIN_SYSTEM:Inputs()
	return {"BrakePressure", "speed", "ThrottleRate", "ThrottleState", "BrakePressure","ReverserState", "ReverserInserted","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOnA", "BatteryOnB", "KeyInsertA", "KeyInsertB", "KeyTurnOnA", "KeyTurnOnB", "BlinkerState", "Haltebremse"}
end

function TRAIN_SYSTEM:Outputs()
	return { "ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "KeyTurnOn", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled"}
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


function TRAIN_SYSTEM:BlinkerHandler()
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(Train,dT)
	--local train = self.Train 
	--self.TriggerInput()
	--self.TriggerOutput()

	self.PrevTime = self.PrevTime or RealTime()-0.33
    self.DeltaTime = (RealTime() - self.PrevTime)
    self.PrevTime = RealTime()
	local dT = self.DeltaTime

	
	self.ThrottleState = self.ThrottleState +  self.ThrottleRate
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	


	if self.ThrottleState > 0 then
		self.ThrottleEngaged = true
	else
		self.ThrottleEngaged = false
	end

	if self.Speed < 2 then
		if ThrottleEngaged == false then
		timer.Create("ThrottleLastEngaged", 1, 0, function() self.Haltebremse = 1 end)
		end
	end
	
	if ThrottleEngaged == true then
		self.SpringBrake = 0
	end





	

	self.BrakePressure = math.Clamp(self.ThrottleState,-100,0)  * -0.01 * 2.7 --convert to positive value and put in percentage relation of maximum brake value
	
	if self.Haltebremse == true then --try to implement the brake on stopped train
		self.BrakePressure = 2.7
	end




	









	


	
	self.BatteryOn = self.Train:GetNW2Bool("BatteryOn")
	self.PantoUp = self.Train:GetNW2Bool("PantoUp")
	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted")
	--PrintMessage(HUD_PRINTTALK, "Duewag System: Reverser Inserted:")
	--PrintMessage(HUD_PRINTTALK, self.ReverserInserted)
	
	
	
	
	if self.BatteryOnA == true and self.ReverserInserted == true and self.PantoUp == true then
		self.TractionConditionFulfilled = true
	end
		
		
	--if self.TractionConditionFulfilled == true and if not self.TractionCutOut == true then
		self.Traction = self.ThrottleState
		self.Train:WriteTrainWire(1,self.Traction) 
	--else
	--	self.Traction = 0
	--end				
	
				
				
				
				
				
				
				
				
				
	




	
end

