Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.IsPressed = 0
	self.Alarm = 0
	self.AlarmSound = false
	self.Speed = 0
	self.AlarmTime = 0
	self.BrakeTime = 0
	self.KeyBypass = false
	self.BrakeMomentAlreadyRecorded = false

end

function TRAIN_SYSTEM:Inputs()
		return {"IsPressed", "Speed", "BypassKeyInserted"}
end


function TRAIN_SYSTEM:TriggerInput(name,value)
    if name == "IsPressed" then
        self.IsPressed = value
    end
	if name == "Speed" then
		self.Speed = value
	end
	
	if name == "BypassKeyInserted" then
		self.KeyBypass = true
	end
end



function TRAIN_SYSTEM:Think()
		local train = self.Train
		
	if self.Train:GetNW2Bool("ReverserInserted",false) == true then

		if self.Train:GetNW2Int("Speed",0) > 5 and self.IsPressed == 1 then --Train is at speed, and pedal is pressed
		self.AlarmTime = CurTime()
		self.Train:SetNW2Bool("DeadmanTripped",false)
		self.AlarmSound = false
		self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound) 
		
		end

		if self.Train:GetNW2Int("Speed",0) < 5 then--and self.IsPressed == 1 then --Train is under 5kph
			
			if self.Train:GetNW2Bool("DeadmanTripped") == true then --If we've tripped an emergency stop
				if self.IsPressed == 1 then								--And if we're pressing the pedal
					if CurTime() - self.BrakeTime > 10 and self.Speed > 4 then --If the moment of braking was 10 secs ago
						if self.IsPressed == 1 then -- and if we're pressing the pedal
						--if self.Train:GetNW2Bool("DeadmanTripped",true) then
							self.Train:SetNW2Bool("DeadmanTripped",false) --Reset the trip and the time flags and the brake moment
							self.AlarmSound = false
							self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound) 
							self.BrakeTime = CurTime()
							self.AlarmTime = CurTime()
							self.Train:WriteTrainWire(8,0)
							self.BrakeMomentAlreadyRecorded = false
							
						--end
						end
					end
				end
			else
				self.AlarmTime = CurTime()
			end
			--self.Train:SetNW2Bool("DeadmanTripped",false)
		end

		if self.Train:GetNW2Int("Speed",0) < 5 and self.IsPressed == 0 then --Train is stationary, and pedal is not pressed.
			self.AlarmTime = CurTime()
			--self.Train:SetNW2Bool("DeadmanTripped",false)
		end

		if self.Train:GetNW2Int("Speed",0) > 5 and self.IsPressed == 0 then -- Train is at speed, but pedal is not pressed

			self.AlarmTime = self.AlarmTime
			self.AlarmSound = true
		end

		if CurTime() - self.AlarmTime > 5 then --If the alarm has gone off for five seconds
			if self.KeyBypass == false then
				self.Train:SetNW2Bool("DeadmanTripped",true) --trip the deadman switch
				if self.Train:ReadTrainWire(6) == 1 then --if the MU mode is engaged
					self.Train:WriteTrainWire(8,1) --tell the train wire that braking is active
				end
				
			end
			
		end
		
		if self.Train:GetNW2Bool("DeadmanTripped") == true then --if the deadman is  tripped
			if self.BrakeMomentAlreadyRecorded == false then --if the point in time when we've started braking is not already captured
				self.BrakeMomentAlreadyRecorded = true --we've just done that now
				self.BrakeTime = CurTime() --We've tripped the deadman just now.
			end
		end

		self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
	end
		
end
