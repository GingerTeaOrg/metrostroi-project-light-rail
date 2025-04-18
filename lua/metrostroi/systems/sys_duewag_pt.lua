Metrostroi.DefineSystem("Duewag_Pt")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.PrevTime = 0
	self.DeltaTime = 0
	self.Speed = 0
	self.ThrottleStateA = 0
	self.ThrottleStateB = 0

	self.ThrottleNotchTraction = false
	self.ThrottleNotchBraking = false
	self.ThrottleNotchEmergency = false

	self.ActualThrottleState = 0

	self.Voltage = 0

	self.ResistorBank = 0
	self.CurrentResistor = 0
	self.PrevResistorBank = nil
	self.ResistorChangeRegistered = false
	self.DoorFLState = 100
	self.DoorRLState = 100
	self.DoorFRState = 100
	self.DoorRRState = 100

	self.LeadingCab = 0

	self.ResetTrainWires = false

	self.Traction = 0

	self.Drive = 0
	self.Brake = 0
	self.Reverse = 0
	self.Bell = 0
	self.BitteZuruecktreten = 0
	self.Horn = 0
	self.PantoUp = false
	self.BatteryStartUnlock = false
	self.BatteryOn = false
	self.CabLights = 0
	self.HeadLights = 0
	self.StopLights = 0
	self.FanTimer = 0

	self.ReverserInserted = false
	self.ReverserState = 0 -- internal registry for forwards, neutral, backwards
	self.ReverserLeverState = 0 -- for the reverser lever setting. -1 is reverse, 0 is neutral, 1 is startup, 2 is single unit, 3 is multiple unit

	self.VZ = false -- multiple unit mode
	self.VE = false -- single unit mode

	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 0
	self.TractionCutOut = false

	self.ThrottleStateAnimA = 0 -- whether to stop listening to the throttle input
	self.ThrottleStateAnimB = 0
	self.ThrottleCutOut = 0

	self.DynamicBraking = false -- First stage of braking
	self.TrackBrake = false -- Electromagnetic brake
	self.DiscBrake = false -- physical friction brake

	self.EmergencyBrake = false

	self.CloseDoorsButton = false

	self.DoorsOpenButton = false

	self.Percentage = 0

	self.Amps = 0

	self.HeadlightsSwitch = false

	self.ManualRetainerBrake = false

	self.CamshaftMoveTimer = 0

	self.CamshaftFinishedMoving = true

	self.LeadingUnit = false

	self.PrevResistorBank = 0

	self.TractionJerk = 0

	self.HF = false
	self.LF = false

end

function TRAIN_SYSTEM:Think(dT)

	local t = self.Train

	self.ThrottleStateA = self.ThrottleStateA + self.ThrottleRate -- * dT * 2 --todo: enable deltaTime correction

	self.ThrottleStateA = math.Clamp(self.ThrottleStateA, -100, 100)

	self.ThrottleStateB = self.ThrottleStateB + self.ThrottleRate -- * dT * 2 --todo: enable deltaTime correction

	self.ThrottleStateB = math.Clamp(self.ThrottleStateB, -100, 100)

	-- Is the throttle engaged? We need to know that for a few things!
	self.ThrottleEngaged = (self.ThrottleStateA > 0 or self.ThrottleStateB > 0)
	t:SetNW2Bool("ThrottleEngaged", self.ThrottleEngaged)

	if self.ThrottleStateA <= 100 then -- Throttle animation handling. Adapt the value to the pose parameter on the model
		self.ThrottleStateAnimA = self.ThrottleStateA / 200 + 0.5
	elseif (self.ThrottleStateB >= 0) then
		self.ThrottleStateAnimA = (self.ThrottleStateA * -0.1)

	end

	if self.ThrottleStateB <= 100 then -- Throttle animation handling. Adapt the value to the pose parameter on the model
		self.ThrottleStateAnimB = self.ThrottleStateB / 200 + 0.5
	elseif (self.ThrottleStateB >= 0) then
		self.ThrottleStateAnimB = (self.ThrottleStateB * -0.1)

	end

	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted") -- get from the train whether the reverser is present

	self.ReverserLeverState = math.Clamp(self.ReverserLeverState, -1, 3)

	if self.ReverserLeverState == 0 then
		self.ReverserInserted = self.Train.ReverserInsertedA or self.Train.ReverserInsertedB -- get from the train whether the reverser is present

		if self.ReverserInserted == true and self.Train.ReverserInsertedA == true then
			self.Train.ReverserInsertedB = false
		elseif self.ReverserInserted == true and self.Train.ReverserInsertedB == true then
			self.Train.ReverserInsertedA = false
		end
	else
		self.ReverserInserted = self.ReverserInserted
		self.Train.ReverserInsertedA = self.Train.ReverserInsertedA
		self.Train.ReverserInsertedB = self.Train.ReverserInsertedB
	end

	if self.ReverserInserted == true and self.ReverserLeverState == 1 then
		self.BatteryStartUnlock = true

	else
		self.BatteryStartUnlock = false
	end

	if self.BatteryStartUnlock == false then -- Only on the * Setting of the reverser lever should the battery turn on
		self.BatteryOn = self.BatteryOn
		-- self.Train:WriteTrainWire(7,self.Train:ReadTrainWire(7))
	elseif self.BatteryStartUnlock == true then
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn", false)
		if self.Train:GetNW2Bool("BatteryOn", false) == true then self.Train:WriteTrainWire(7, 1) end
		if self.Train:GetNW2Bool("BatteryOn", false) == false then self.Train:WriteTrainWire(7, 0) end
	elseif self.BatteryStartUnlock == true or self.Train:ReadTrainWire(7) == 1 then -- Except if the leading cab turns the batteries on for the entire train
		self.BatteryOn = true
		self.Train:SetNW2Bool("BatteryOn", true)
	end

end
