Metrostroi.DefineSystem("Duewag_Pt")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	self.PrevTime = 0
	self.DeltaTime = 0
	self.Speed = 0
	self.ThrottleState = 0

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
	self.ReverserState = 0 --internal registry for forwards, neutral, backwards
	self.ReverserLeverState = 0 --for the reverser lever setting. -1 is reverse, 0 is neutral, 1 is startup, 2 is single unit, 3 is multiple unit

	self.VZ = false -- multiple unit mode
	self.VE = false --single unit mode
	
	self.BlinkerOnL = 0
	self.BlinkerOnR = 0
	self.BlinkerOnWarn = 0
	self.ThrottleRate = 0
	self.ThrottleEngaged = false
	self.TractionConditionFulfilled = false
	self.BrakePressure = 2.7
	self.TractionCutOut = false
	
	self.ThrottleStateAnim = 0 --whether to stop listening to the throttle input

	self.ThrottleCutOut = 0

	self.DynamicBraking = false --First stage of braking
	self.TrackBrake = false --Electromagnetic brake
	self.DiscBrake = false --physical friction brake

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
	
	

end

function TRAIN_SYSTEM:Think(Train)

	self.ThrottleState = self.ThrottleState + self.ThrottleRate --* dT * 2 --todo: enable deltaTime correction
	
	self.ThrottleState = math.Clamp(self.ThrottleState, -100,100)

	--Is the throttle engaged? We need to know that for a few things!
	if self.ThrottleState > 0 then
		self.ThrottleEngaged = true
		self.Train:SetNW2Bool("ThrottleEngaged",true)
	elseif self.ThrottleState <= 0 then
		self.ThrottleEngaged = false
		self.Train:SetNW2Bool("ThrottleEngaged",false)
	end



	if self.BatteryStartUnlock == false then --Only on the * Setting of the reverser lever should the battery turn on
		self.BatteryOn = self.BatteryOn
		--self.Train:WriteTrainWire(7,self.Train:ReadTrainWire(7))
	elseif self.BatteryStartUnlock == true then
		self.BatteryOn = self.Train:GetNW2Bool("BatteryOn",false)
			if self.Train:GetNW2Bool("BatteryOn",false) == true then
				self.Train:WriteTrainWire(7,1)
			end
			if self.Train:GetNW2Bool("BatteryOn",false) == false then
				self.Train:WriteTrainWire(7,0)
			end
	elseif self.BatteryStartUnlock == true or self.Train:ReadTrainWire(7) == 1 then --Except if the leading cab turns the batteries on for the entire train
		self.BatteryOn = true
		self.Train:SetNW2Bool("BatteryOn",true)
	end

	self.ReverserInserted = self.Train:GetNW2Bool("ReverserInserted") --get from the train whether the reverser is present

	self.ReverserLeverState = math.Clamp(self.ReverserLeverState, -1, 3)


	self.ReverserInserted = self.Train.ReverserInsertedA or self.Train.ReverserInserted B --get from the train whether the reverser is present


end