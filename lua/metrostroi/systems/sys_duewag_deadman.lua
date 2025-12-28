-- Define the Duewag_Deadman train system
Metrostroi.DefineSystem( "Duewag_Deadman" )
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	-- Initialize various system variables
	self.IsPressed = false
	self.Alarm = 0
	self.AlarmSound = false
	self.AlarmTime = 0
	self.TractionWithoutDeadman = false
	self.KeyBypass = false
	self.AlarmTime = 0
	self.TrainHasReset = false
	self.EmergencyShutOff = false
	self.DeadmanTripped = false
	self.MUDeadman = false
	self.IsPressedA = false
	self.IsPressedB = false
	self.OverSpeed = false
	self.CabConflict = false
	self.Power = false
	self.BrokenConsist = false
	----------------------------
	self.Sys = self.Train.CoreSys
	self.PanelA = self.Train.Panel
	self.SPAD = false
	if self.Train.SectionB then self.PanelB = self.Train.SectionB.Panel end
end

-- Define inputs for the system
function TRAIN_SYSTEM:Inputs()
	return { "IsPressed", "IsPressedB", "Speed", "BypassKeyInserted" }
end

function TRAIN_SYSTEM:HasPower()
	local train = self.Train
	local batteryOn = train:GetNW2Bool( "BatteryOn", false ) --self.Train.Battery.Charge == 24
	return batteryOn or train:ReadTrainWire( 6 ) > 0 and train:ReadTrainWire( 7 ) > 0
end

function TRAIN_SYSTEM:IsPressedAcrossTrain()
	local MU = self.Train:ReadTrainWire( 6 ) > 0
	local sys = self.Train.CoreSys
	local p = self.Train.Panel
	local pB = ( self.Train.Bidirectional and self.Train.SectionB ) and self.Train.SectionB.Panel or nil
	local pressed
	if pB then
		if sys.ReverserA ~= 0 then
			pressed = p.DeadmanPedal > 0
		elseif sys.ReverserB ~= 0 then
			pressed = pB.Deadman > 0
		end
	else
		pressed = p.DeadmanPedal > 0
	end

	if MU then
		if pressed then self.Train:WriteTrainWire( 6, 1 ) end
		pressed = pressed or self.Train:ReadTrainWire( 6 ) > 0
	end
	return pressed
end

function TRAIN_SYSTEM:BrokenConsistProtect()
	if self.Train.SubwayTrain.Type ~= "U2" then return end
	local speed = self.Train.CoreSys.Speed
	local consistLength = #self.Train.WagonList
	local reverserA = self.Train.CoreSys.ReverserA
	local reverserB = self.Train.CoreSys.ReverserB
	local rng = math.random( 0, 100 )
	if consistLength == 1 and ( reverserA == 2 or reverserB == 2 ) and rng == 33 and speed > 5 then
		self.BrokenConsist = true
	elseif speed < 5 and ( reverserA == 0 and reverserB == 0 ) then
		self.BrokenConsist = false
	end
end

function TRAIN_SYSTEM:AlarmTimer()
	local speed = self.Train.CoreSys.Speed
	if not self.IsPressed and speed > 5 then
		self.Alarm = true
	elseif self.IsPressed and not self.DeadmanTripped then
		self.Alarm = false
	end
end

function TRAIN_SYSTEM:ResetDeadman()
	local indusi = self.Train.INDUSI
	local speed = self.Train.CoreSys.Speed
	local reverserA = self.Train.CoreSys.ReverserA
	local reverserB = self.Train.CoreSys.ReverserB
	local throttle
	if self.Train.CoreSys.ThrottleState then
		throttle = self.Train.CoreSys.ThrottleState
	elseif self.Train.CoreSys.ReverserA ~= 0 and self.Train.CoreSys.ThrottleStateA then
		throttle = self.Train.CoreSys.ThrottleStateA
	elseif self.Train.CoreSys.ReverserB ~= 0 and self.Train.CoreSys.ThrottleStateB then
		throttle = self.Train.CoreSys.ThrottleStateB
	end

	if self.DeadmanTripped and speed < 5 and ( reverserA == 0 and reverserB == 0 ) and throttle == 0 and not self.SPAD then
		self.DeadmanTripped = false
		self.OverSpeed = false
	end
end

function TRAIN_SYSTEM:EmergencyBrake()
	local indusi = self.Train.INDUSI
	if self.BrokenConsist then self.DeadmanTripped = true end
	if self.AlarmTime - CurTime() > 3 then self.DeadmanTripped = true end
	if indusi and indusi.SPAD then
		self.SPAD = indusi.SPAD
		self.DeadmanTripped = true
		PrintMessage( HUD_PRINTTALK, "SPAD TRIPPED" )
	end

	if self.OverSpeed then self.DeadmanTripped = true end
	self.Train:WriteTrainWire( 8, self.DeadmanTripped and 1 or 0 )
end

function TRAIN_SYSTEM:TractionAlarm()
	local reverserA = self.Train.CoreSys.ReverserA
	local reverserB = self.Train.CoreSys.ReverserB
	local throttle = reverserA ~= 0 and self.Train.CoreSys.ThrottleStateA or self.Train.CoreSys.ThrottleStateB
	local time
	local trainIsStopped = true
	if ( reverserA ~= 0 or reverserB ~= 0 ) and throttle > 0 and not self.IsPressed and trainIsStopped then
		time = not time and CurTime() or time
		self.TractionWithoutDeadman = true
		trainIsStopped = false
	else
		time = nil
		self.TractionWithoutDeadman = false
		trainIsStopped = true
	end

	if time and CurTime() - time > 2 then self.DeadmanTripped = true end
end

function TRAIN_SYSTEM:SoundAlarm()
	local reverserA = self.Train.CoreSys.ReverserA
	local reverserB = self.Train.CoreSys.ReverserB
	if reverserA ~= 0 then
		self.Train:SetNW2Bool( "DeadmanAlarmSound", self.BrokenConsist or self.CabConflict or self.Alarm or self.TractionWithoutDeadman or self.SPAD )
	elseif reverserB ~= 0 and self.Train.SectionB then
		self.Train.SectionB:SetNW2Bool( "DeadmanAlarmSound", self.BrokenConsist or self.CabConflict or self.Alarm or self.TractionWithoutDeadman or self.SPAD )
	elseif self.SPAD then
		self.Train:SetNW2Bool( "DeadmanAlarmSound", self.SPAD )
	else
		self.Train:SetNW2Bool( "DeadmanAlarmSound", false )
		if self.Train.SectionB then self.Train.SectionB:SetNW2Bool( "DeadmanAlarmSound", false ) end
	end
end

-- Update the system's logic in each frame
function TRAIN_SYSTEM:Think()
	if not self.Train.CoreSys then return end
	-- local variables to save space
	self.Power = self:HasPower()
	local train = self.Train
	if not self.Train.Panel then return end
	local speed = math.abs( train.Speed )
	if not speed then return end
	-- Check if battery is on and MUDeadman conditions are met
	if self.Power then
		self.IsPressed = self:IsPressedAcrossTrain()
		self:BrokenConsistProtect()
		self:TractionAlarm()
		self:AlarmTimer()
		self:SoundAlarm()
		self:EmergencyBrake()
		self:ResetDeadman()
		self:Overspeed()
	end
end

function TRAIN_SYSTEM:Overspeed()
	local speed = self.Train.CoreSys.Speed
	local Vmax = self.Train.SubwayTrain.Vmax
	if not self.OverSpeed then self.OverSpeed = speed > Vmax end
end

function TRAIN_SYSTEM:CabConflicting( conflict )
	self.CabConflict = conflict
end