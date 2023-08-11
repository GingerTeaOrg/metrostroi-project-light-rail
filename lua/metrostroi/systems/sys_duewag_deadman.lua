Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.IsPressed = 0
	self.Alarm = 0
	self.AlarmSound = false
	self.Speed = 0
	self.AlarmTime = 0
	self.KeyBypass = false

	self.AlarmTimeRecorded = false

	self.TrainHasReset = false
	self.EmergencyShutOff = false
	self.DeadmanTripped = false

	self.MUDeadman = false

	self.IsPressedA = false
	self.IsPressedB = false

end

function TRAIN_SYSTEM:Inputs()
		return {"IsPressed", "IsPressedB", "Speed", "BypassKeyInserted"}
end


function TRAIN_SYSTEM:TriggerInput(name,value)
    
	if name == "Speed" then
		self.Speed = value
	end
	
	if name == "BypassKeyInserted" then
		self.KeyBypass = true
	end
end



function TRAIN_SYSTEM:Think()
	local train = self.Train
	if self.IsPressedA == true or self.IsPressedB == true then
		self.IsPressed = 1
	else
		self.IsPressed = 0
	end
	
	self.Speed = math.abs(self.Train.Speed)
	if self.Train:GetNW2Bool("BatteryOn",false) == true then
		if self.Train:ReadTrainWire(12) > 0 and self.Train:ReadTrainWire(6) > 0 then
			self.MUDeadman = true
		else
			self.MUDeadman = false
		end
		if self.IsPressed == 1 or self.MUDeadman == true then
			if self.EmergencyShutOff == false then
				if self.TrainHasReset == false then
						self.Train:SetNW2Bool("DeadmanTripped",false)
						self.DeadmanTripped = false
						self.AlarmSound = false
						self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
						self.AlarmTime = CurTime()
				elseif self.TrainHasReset == true then
						self.Train:SetNW2Bool("DeadmanTripped",false)
						self.DeadmanTripped = false
						self.AlarmSound = false
						self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
						self.TrainHasReset = false
						self.AlarmTime = CurTime()
				end
			elseif self.EmergencyShutOff == true then
				if self.TrainHasReset == true then
					
						self.Train:SetNW2Bool("DeadmanTripped",false)
						self.DeadmanTripped = false
						self.AlarmSound = false
						self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
						self.EmergencyShutOff = false
						self.TrainHasReset = false
					
				end
			end

		elseif self.IsPressed == 0 or self.MUDeadman == false then
			
			if self.Speed < 5 then
				if self.EmergencyShutOff == false and self.Speed < 80 then
					self.Train:SetNW2Bool("DeadmanTripped",false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
					self.Train:WriteTrainWire(8,0)
					--print("Deadman is clear")
					self.AlarmTime = CurTime()
				end

				if self.TrainHasReset == true then
					self.TrainHasReset = false
					self.Train:SetNW2Bool("DeadmanTripped",false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
					self.Train:WriteTrainWire(8,0)
					--print("Deadman is clear")
					self.AlarmTime = CurTime()
				end
			elseif self.Speed > 5 then -- Train is at speed, but pedal is not pressed
				if self.AlarmTimeRecorded == false then
					self.AlarmTimeRecorded = true
					self.AlarmTime = CurTime()
					self.AlarmSound = true
				end
				self.TrainHasReset = false
			end
			if self.Train:GetNW2Bool("OverspeedCutOut",false) == true then
				if self.Train:ReadTrainWire(6) == 1 then --if the MU mode is engaged
					self.Train:WriteTrainWire(8,1) --tell the train wire that braking is active
					print("Deadman braking")
				end
				self.EmergencyShutOff = true
				self.AlarmSound = true
			end


		end

		
			
			if self.Train:GetNW2Bool("DeadmanTripped") == true then --If we've tripped an emergency stop
				if self.Train.Duewag_U2.ReverserLeverState == 0 then								--And if we're pressing the pedal
					if self.Train.Duewag_U2.ThrottleState == 0 then --If the moment of braking was 10 secs ago
							self.TrainHasReset = true
							self.Train:SetNW2Bool("DeadmanTripped",false) --Reset the trip and the time flags and the brake moment
							self.AlarmSound = false
							self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound) 
							self.Train:WriteTrainWire(8,0)
						
						
					end
				end
			end

		


		if CurTime() - self.AlarmTime > 4.5 then --If the alarm has gone off for three seconds
			if self.KeyBypass == false then
				if self.TrainHasReset == false then
					self.Train:SetNW2Bool("DeadmanTripped",true) --trip the deadman switch
					if self.Train:ReadTrainWire(6) == 1 then --if the MU mode is engaged
						self.Train:WriteTrainWire(8,1) --tell the train wire that braking is active
						print("Deadman braking")
					end
					self.EmergencyShutOff = true
					self.AlarmSound = true
				elseif self.TrainHasReset == true then
					self.EmergencyShutOff = false
				end
				
			end
			
		end
		
		if self.Train:GetNW2Bool("DeadmanTripped") == true then --if the deadman is  tripped
			if self.Train.ReverserLeverState == 0 then
				if self.ThrottleState == 0 then
					if self.Speed < 5 then
						self.TrainHasReset = true
					end
				end
			end
		end

		self.Train:SetNW2Bool("DeadmanAlarmSound",self.AlarmSound)
	end
		
	if self.TrainHasReset == true then
		--print("Train Reset True")
	end

	if self.EmergencyShutOff == true then
		--print("Emergency cutoff true")
	end

	if self.Speed > 81 then
		self.Train:SetNW2Bool("DeadmanTripped",true)
		self.Train:SetNW2Bool("OverspeedCutOut",true)
		self.AlarmSound = true
	end

	if self.Train:GetNW2Bool("BatteryOn",false) == false then
		self.Train:SetNW2Bool("DeadmanTripped",false)
		self.TrainHasReset = true
	end
end
