Metrostroi.DefineSystem( "IBIS_secondary" )
TRAIN_SYSTEM.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	if self.Train.SectionA.IBIS then
		self.Primary = self.Train.SectionA.IBIS
	elseif self.Train.SectionC.IBIS then
		self.Primary = self.Train.SectionC.IBIS
	end

	self.Override = self.Primary.Override
end

function TRAIN_SYSTEM:Think()
	self.Override = self.Primary.Override
end