-- Define the Duewag_Deadman train system
Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	-- Initialize various system variables
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

-- Define inputs for the system
function TRAIN_SYSTEM:Inputs() return {"IsPressed", "IsPressedB", "Speed", "BypassKeyInserted"} end

-- Handle inputs to the system
function TRAIN_SYSTEM:TriggerInput(name, value)
	if name == "Speed" then self.Speed = value end
	
	if name == "BypassKeyInserted" then self.KeyBypass = true end
end

-- Update the system's logic in each frame
function TRAIN_SYSTEM:Think()
	local train = self.Train
	
	-- Determine if pedal A or pedal B is pressed, either way is fine
	if self.IsPressedA == true or self.IsPressedB == true then
		self.IsPressed = 1
	else
		self.IsPressed = 0
	end
	
	self.Speed = math.abs(self.Train.Speed)
	
	-- Check if battery is on and MUDeadman conditions are met
	if self.Train:GetNW2Bool("BatteryOn", false) == true or self.Train:ReadTrainWire(6) > 0 and self.Train:ReadTrainWire(7) > 0 then
		
		if self.Train:ReadTrainWire(6) > 0 and #self.Train.WagonList < 2 and math.random(0,100) <= 33 and self.Speed > 5 then
			self.IsPressed = 0
			self.DeadmanTripped = true
			self.BrokenConsistProtect = true
			self.MUDeadman = false
		end

		self.MUDeadman = self.Train:ReadTrainWire(12) > 0 and self.Train:ReadTrainWire(6) > 0
		
		
		-- Handle various deadman and emergency shut-off scenarios
		if self.IsPressed == 1 or self.MUDeadman == true and not self.BrokenConsistProtect then
			-- Reset deadman trip and alarm if conditions are met
			if self.EmergencyShutOff == false then
				if self.TrainHasReset == false then
					-- Reset deadman conditions
					self.Train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.AlarmTime = CurTime()
				elseif self.TrainHasReset == true then
					-- Reset deadman conditions after reset
					self.Train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.TrainHasReset = false
					self.AlarmTime = CurTime()
				end
			elseif self.EmergencyShutOff == true then
				-- Reset conditions after emergency shut-off
				if self.TrainHasReset == true then
					self.Train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.EmergencyShutOff = false
					self.TrainHasReset = false
				end
			end
			-- Handle scenarios when pedal is not pressed
		elseif self.IsPressed == 0 and self.MUDeadman == false then
			if self.Speed < 5 then
				if self.EmergencyShutOff == false and self.Speed < 80 then
					-- Reset deadman conditions if speed is low
					self.Train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.Train:WriteTrainWire(8, 0)
					self.AlarmTime = CurTime()
				end
				
				-- Reset deadman conditions if previously reset
				if self.TrainHasReset == true then
					self.TrainHasReset = false
					self.Train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.Train:WriteTrainWire(8, 0)
					self.AlarmTime = CurTime()
				end
			elseif self.Speed > 5 then
				-- Handle alarm when train is at speed but pedal not pressed
				if self.AlarmTimeRecorded == false then
					self.AlarmTimeRecorded = true
					self.AlarmTime = CurTime()
					self.AlarmSound = true
				end
				self.TrainHasReset = false
			end
			
			-- Handle overspeed cut-out and emergency shut-off
			if self.Train:GetNW2Bool("OverspeedCutOut", false) == true then
				if self.Train:ReadTrainWire(6) == 1 then
					self.Train:WriteTrainWire(8, 1)
					--print("Deadman braking")
				end
				self.EmergencyShutOff = true
				self.AlarmSound = true
			end
		end
		
		-- Handle emergency stop when deadman is tripped
		if self.Train:GetNW2Bool("DeadmanTripped") == true and (self.Train.Duewag_U2.ReverserLeverStateA == 0 or self.Train.Duewag_U2.ReverserLeverStateA == 0) and self.Train.Duewag_U2.ThrottleState == 0 then
			
			self.TrainHasReset = true
			self.Train:SetNW2Bool("DeadmanTripped", false)
			self.AlarmSound = false
			self.Train:WriteTrainWire(8, 0)
			
		end
		
		-- Check if alarm duration has passed and apply emergency shut-off
		if CurTime() - self.AlarmTime > 4.5 then
			if self.KeyBypass == false then
				if self.TrainHasReset == false then
					self.Train:SetNW2Bool("DeadmanTripped", true)
					if self.Train:ReadTrainWire(6) == 1 then
						self.Train:WriteTrainWire(8, 1)
						--print("Deadman braking")
					end
					self.EmergencyShutOff = true
					self.AlarmSound = true
				elseif self.TrainHasReset == true then
					self.EmergencyShutOff = false
				end
			end
		end
		
		-- Check if deadman is tripped and reset conditions
		
		
		
	end
	
	self.Train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
	if self.Train:GetNW2Bool("DeadmanTripped") == true then
		if self.Train.ReverserLeverState == 0 and self.ThrottleState == 0 and self.Speed < 5 then self.TrainHasReset = true end
	end
	
	-- Display debug information
	if self.TrainHasReset == true then
		-- print("Train Reset True")
	end
	
	if self.EmergencyShutOff == true then
		-- print("Emergency cutoff true")
	end
	
	-- Apply emergency shut-off if speed exceeds 81
	if self.Speed > 81 then
		self.Train:SetNW2Bool("DeadmanTripped", true)
		self.Train:SetNW2Bool("OverspeedCutOut", true)
		self.AlarmSound = true
	end
	
	-- Reset deadman conditions if battery is off
	if self.Train:GetNW2Bool("BatteryOn", false) == false then
		self.Train:SetNW2Bool("DeadmanTripped", false)
		self.TrainHasReset = true
	end
	
	if self.Train:GetNW2Bool("BatteryOn", false) == true or
	self.Train:ReadTrainWire(6) > 0 then -- if either the battery is on or the EMU cables signal multiple unit mode
		
		self.Train:WriteTrainWire(12, self.IsPressed)


		
		
		
		--self.Train:SetNW2Bool("TractionAppliedWhileStillNoDeadman", (self.ReverserState ~= 0 and self.Train:ReadTrainWire(12) < 1 and self.ThrottleState > 0) or false)
		
	end
end
