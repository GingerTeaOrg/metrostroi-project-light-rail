
Metrostroi.DefineSystem("Duewag_U2")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.speed = 0
	self.ThrottleState = 0
	
	
	
	self.Drive = 0
	self.Brake = 0
	self.Reverse = 0
	self.Igbt74 = 0
	self.Bell = 0
	self.BitteZuruecktreten = 0
	self.Horn = 0
	self.PantoState = 0
	self.PantoUp = 0
	self.BatteryOn = 0
	

end


function TRAIN_SYSTEM:Inputs()
	return {"speed", "ThrottleState", "Drive", "Brake","Reverse","BellEngage","Horn","BitteZuruecktreten", "PantoUp", "BatteryOn", "KeyTurnOn", "BlinkerState", "StationBrakeOn", "StationBrakeOff"}
end

function TRAIN_SYSTEM:Outputs()
	return { "ThrottleState", "PantoState", "BlinkerState", "DoorSelectState", "BatteryOnState", "PantoState", "KeyTurnOn", "BlinkerState", "speed"}
end
function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end
end

function TRAIN_SYSTEM:TriggerOutput(name,value)

end


function TRAIN_SYSTEM:Throttle()

		

end
--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think()
	local train = self.Train 
	self.Train:SetPackedBool("Bell",self.Bell == 1)
	self.Train:SetPackedBool("igbt74",self.Igbt74 == 1)
	self.Train:SetPackedBool("BitteZuruecktreten",self.BitteZuruecktreten == 1)
	self.Train:SetPackedBool("Horn",self.Horn == 1)
	




	
end

