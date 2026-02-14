Metrostroi.DefineSystem( "mplr_INDUSI_scanner" )
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	self.SPAD = false
	self.SpeedRestriction = -1
end

function TRAIN_SYSTEM:Think( dT )
	local direction = self.Train.CoreSys.ReverserA >= 0 or self.Train.CoreSys.ReverserB and self.Train.CoreSys.ReverserB < 0
	local train = self.Train
	local deadman = self.Train.Deadman
	local speed = math.abs( self.Train.CoreSys.Speed )
	-- we assume that the developer of the train has actually put the front bogey on the front of the train, so forwards = front bogey leading
	self.ScanEntity = direction and self.Train.FrontBogey.INDUSICoil or self.Train.RearBogey.INDUSICoil
	self.SPAD = self.ScanEntity.SignalReceived == "SPAD"
end

function TRAIN_SYSTEM:Reset()
	self.Train.FrontBogey.INDUSICoil:Reset()
	self.Train.RearBogey.INDUSICoil:Reset()
	self.SPAD = false
	self.Train.Deadman.SPAD = false
end