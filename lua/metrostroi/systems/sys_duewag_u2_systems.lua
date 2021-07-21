
Metrostroi.DefineSystem("Duewag_U2")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()

	self.speed = 0
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
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.TractionConditionFulfilled = false
	

end


function TRAIN_SYSTEM:Wait(seconds)

	local time = seconds or 1
    local start = os.time()
    repeat until os.time() == start + time


end


function TRAIN_SYSTEM:Inputs()
	return {"speed", "ThrottleRate", "ThrottleState", "BrakePressure","ReverserState", "ReverserInserted","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOn", "KeyInsert", "KeyTurnOn", "BlinkerState", "StationBrakeOn"}
end

function TRAIN_SYSTEM:Outputs()
	return { "ThrottleState", "ThrottleRate", "ThrottleEngaged", "Traction", "BrakePressure", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "KeyTurnOn", "BlinkerState", "speed", "CabLight", "SpringBrake", "TractionConditionFulfilled"}
end
function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end

	--[[if name == "KeyInsert" then self.KeyInsert = value end
	if name == "KeyTurnOn" then self.KeyTurnOn = value end
	if name == "BatteryOn" then self.BatteryOn = value end
	if name == "PantoUp" then self.PantoUp = value end]]
end

function TRAIN_SYSTEM:TriggerOutput(name,value)
	if self[name] then self[name] = value end
end


function TRAIN_SYSTEM:BlinkerHandler()
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think(dT)
	local train = self.Train 

	
	

	
	self.ThrottleState = self.ThrottleState +  self.ThrottleRate
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)
	
	
	
	self.KeyInsert = self.Train:GetNW2Bool("KeyInsert")
	self.KeyTurnOn = self.Train:GetNW2Bool("KeyTurnOn")
	self.BatteryOn = self.Train:GetNW2Bool("BatteryOn")
	self.PantoUp = self.Train:GetNW2Bool("PantoUp")
	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted")
	--PrintMessage(HUD_PRINTTALK, "Duewag System: Reverser Inserted:")
	--PrintMessage(HUD_PRINTTALK, self.ReverserInserted)
	
	
	
	
	if self.KeyInsert == true and self.KeyTurnOn == true and self.BatteryOn == true and self.ReverserInserted == true and self.PantoUp == true then
		self.TractionConditionFulfilled = true
	end
		
		
	--if self.TractionConditionFulfilled == true then
		self.Traction = self.ThrottleState

	--else
	--	self.Traction = 0
	--end				
				
				
				
				
				
				
				
				
				
				
	




	
end

