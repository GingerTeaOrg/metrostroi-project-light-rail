Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.IsPressed = 0
	self.Alarm = 0
	self.AlarmSound = 0
	self.Speed = 0

end

function TRAIN_SYSTEM:Inputs()
		return {"IsPressed", "Speed"}
end

function TRAIN_SYSTEM:Outputs()
		return {"Alarm", "AlarmSound"}
		
end


function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "IsPressed" then
        self.IsPressed = value
    end
	if name == "Speed" then
		self.Speed = value
	end
end


function TRAIN_SYSTEM:Think()
		local train = self.Train
		
		if self.Train:GetNW2Int("Speed",0) > 5 and self.IsPressed < 1 then
				self.AlarmSound = 1
				print("DEADMAN ALARM SOUNDING")
				timer.Create("Countdown", 5, 0, function() self.Alarm = 1 end )
		else if self.IsPressed < 1 and self.Train:GetNW2Int("Speed",0) < 5 then
				 self.Alarm = 0
				 
		end
	end
end
