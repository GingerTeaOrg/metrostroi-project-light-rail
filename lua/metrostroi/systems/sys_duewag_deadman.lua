-- Define the Duewag_Deadman train system
Metrostroi.DefineSystem("Duewag_Deadman")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	-- Initialize various system variables
	self.IsPressed = 0
	self.Alarm = 0
	self.AlarmSound = false
	self.AlarmTime = 0
	self.KeyBypass = false
	self.AlarmTimeRecorded = false
	self.TrainHasReset = false
	self.EmergencyShutOff = false
	self.DeadmanTripped = false
	self.MUDeadman = false
	self.IsPressedA = false
	self.IsPressedB = false
	self.OverSpeedCutout = false
end

-- Define inputs for the system
function TRAIN_SYSTEM:Inputs()
	return {"IsPressed", "IsPressedB", "Speed", "BypassKeyInserted"}
end

-- -- Handle inputs to the system
-- function TRAIN_SYSTEM:TriggerInput(name, value)
-- 	if name == "Speed" then self.Speed = value end
	
-- 	if name == "BypassKeyInserted" then self.KeyBypass = true end
-- end

-- Update the system's logic in each frame
function TRAIN_SYSTEM:Think()
	-- local variables to save space
	local train = self.Train
	local speed = math.abs(train.Speed)
	
	-- Determine if pedal A or pedal B is pressed, either way is fine
	if
		self.IsPressedA == true or self.IsPressedB == true then
		self.IsPressed = 1
	else
		self.IsPressed = 0
	end
	
	-- Check if battery is on and MUDeadman conditions are met
	if train:GetNW2Bool("BatteryOn", false) == true or train:ReadTrainWire(6) > 0 and train:ReadTrainWire(7) > 0 then
		if train:ReadTrainWire(6) > 0 and #train.WagonList < 2 and math.random(0,100) <= 33 and speed > 5 then
			self.IsPressed = 0
			self.DeadmanTripped = true
			self.BrokenConsistProtect = true
			self.MUDeadman = false
		end

		self.MUDeadman = train:ReadTrainWire(12) > 0 and train:ReadTrainWire(6) > 0
		
		-- Handle various deadman and emergency shut-off scenarios
		if self.IsPressed == 1 or self.MUDeadman == true and not self.BrokenConsistProtect then
			-- Reset deadman trip and alarm if conditions are met
			if self.EmergencyShutOff == false then
				if self.TrainHasReset == false then
					-- Reset deadman conditions
					train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.AlarmTime = CurTime()
				elseif self.TrainHasReset == true then
					-- Reset deadman conditions after reset
					train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.TrainHasReset = false
					self.AlarmTime = CurTime()
				end
			elseif self.EmergencyShutOff == true then
				-- Reset conditions after emergency shut-off
				if self.TrainHasReset == true then
					train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					self.EmergencyShutOff = false
					self.TrainHasReset = false
				end
			end
			-- Handle scenarios when pedal is not pressed
		elseif self.IsPressed == 0 and self.MUDeadman == false then
			if speed < 5 then
				if self.EmergencyShutOff == false and speed < 80 then
					-- Reset deadman conditions if speed is low
					train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					train:WriteTrainWire(8, 0)
					self.AlarmTime = CurTime()
				end
				-- Reset deadman conditions if previously reset
				if self.TrainHasReset == true then
					self.TrainHasReset = false
					train:SetNW2Bool("DeadmanTripped", false)
					self.DeadmanTripped = false
					self.AlarmSound = false
					train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)
					train:WriteTrainWire(8, 0)
					self.AlarmTime = CurTime()
				end
			-- Handle alarm when train is at speed but pedal not pressed
			elseif speed > 5 and self.AlarmTimeRecorded == false then 
				self.AlarmTimeRecorded = true
				self.AlarmTime = CurTime()
				self.AlarmSound = true
				self.TrainHasReset = false
			end
			-- Handle overspeed cut-out and emergency shut-off
			if train:GetNW2Bool("OverspeedCutOut", false) == true then
				if train:ReadTrainWire(6) > 0 then --only handle train wire when MU wire is high
					train:WriteTrainWire(8, 1)
				end
				self.EmergencyShutOff = true
				self.AlarmSound = true
			end
		end
	
		
		-- Handle emergency stop when deadman is tripped
		if train:GetNW2Bool("DeadmanTripped") == true and (train.Duewag_U2.ReverserLeverStateA == 0 or train.Duewag_U2.ReverserLeverStateA == 0) and train.Duewag_U2.ThrottleState == 0 then
			
			self.TrainHasReset = true
			train:SetNW2Bool("DeadmanTripped", false)
			self.AlarmSound = false
			train:WriteTrainWire(8, 0)
		end
		
		-- Check if alarm duration has passed and apply emergency shut-off
		if CurTime() - self.AlarmTime > 4.5 and self.KeyBypass == false and self.TrainHasReset == false and not self.TrainHasReset then
			train:SetNW2Bool("DeadmanTripped", true)
			if train:ReadTrainWire(6) == 1 then
					train:WriteTrainWire(8, 1)
						--print("Deadman braking")
			end
			self.EmergencyShutOff = true
			self.AlarmSound = true
		else
			self.EmergencyShutOff = false
				
			
		end
		-- Check if deadman is tripped and reset conditions
	
	end
	train:SetNW2Bool("DeadmanAlarmSound", self.AlarmSound)

	if train:GetNW2Bool("DeadmanTripped") == true and train.ReverserLeverState == 0 and self.ThrottleState == 0 and speed < 5 then
		self.TrainHasReset = true
	end
	
	-- Display debug information
	if self.TrainHasReset == true then
		-- print("Train Reset True")
	end
	
	if self.EmergencyShutOff == true then
		-- print("Emergency cutoff true")
	end

	-- Apply emergency shut-off if speed exceeds 81
	if speed > 81 then
		train:SetNW2Bool("DeadmanTripped", true)
		self.OverSpeedCutout = true
		self.AlarmSound = true
	end
	
	-- Reset deadman conditions if battery is off
	if train:GetNW2Bool("BatteryOn", false) == false then
		train:SetNW2Bool("DeadmanTripped", false)
		self.TrainHasReset = true
	end
	
	if train:GetNW2Bool("BatteryOn", false) == true or train:ReadTrainWire(6) > 0 then -- if either the battery is on or the EMU cables signal multiple unit mode
		train:WriteTrainWire(12, self.IsPressed)
		--train:SetNW2Bool("TractionAppliedWhileStillNoDeadman", (self.ReverserState ~= 0 and train:ReadTrainWire(12) < 1 and self.ThrottleState > 0) or false)
	end
end
