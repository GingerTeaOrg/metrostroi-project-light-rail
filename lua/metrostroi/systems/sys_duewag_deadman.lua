Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.IsPressed = 0
	self.Alarm = 0
	self.AlarmSound = 0
	

end

function TRAIN_SYSTEM:Inputs()
		return {"IsPressed"}
end

function TRAIN_SYSTEM:Outputs()
		return {"Alarm", "AlarmSound"}
		
end


function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "IsPressed" then
        self.IsPressed = value
    end
end


function TRAIN_SYSTEM:Think()
		local train = self.Train
		
		 if self.IsPressed ~= 1 then
		 self.AlarmSound = 1
		 print("DEADMAN ALARM SOUNDING")
		 timer.Create("Countdown", 3, 0, function() self.Alarm = 1 end )
		 end
end
