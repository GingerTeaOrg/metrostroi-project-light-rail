-- ПЕРЕПИСАННАЯ СИСТЕМА ТАТРЫ 
-- +НЕМНОГО ТОМАСА 

Metrostroi.DefineSystem("Duewag_U2_Systems")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.Drive = 0
	self.Brake = 0
	self.Reverse = 0
	self.Igbt74 = 0
	self.Bell = 0
	self.BitteZuruecktreten = 0
	self.Horn = 0

end


function TRAIN_SYSTEM:Inputs()
	return {"Drive", "Brake","Reverse","Bell","Horn","BitteZuruecktreten"}
end

function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end
end

--------------------------------------------------------------------------------
function TRAIN_SYSTEM:Think()
	local train = self.Train 
	self.Train:SetPackedBool("Bell",self.Bell == 1)
	self.Train:SetPackedBool("igbt74",self.Igbt74 == 1)
	self.Train:SetPackedBool("BitteZuruecktreten",self.BitteZuruecktreten == 1)
	self.Train:SetPackedBool("Horn",self.Horn == 1)
	
	-- спасибо glebqip за следующую строчку thx glebqip for this 
	--self.Igbt74 = math.min(1,self.Drive+self.Brake)

	self.Train.FrontBogey.MotorForce = 50000
	self.Train.FrontBogey.MotorPower = self.Drive - self.Brake
	self.Train.FrontBogey.Reversed = (self.Reverse > 0.5)
	self.Train.RearBogey.MotorForce  = 50000
	self.Train.RearBogey.MotorPower = self.Drive - self.Brake
	self.Train.RearBogey.Reversed = not (self.Reverse > 0.5)
end

