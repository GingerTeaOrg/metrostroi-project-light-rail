Metrostroi.DefineSystem("U2b")

Metrostroi.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Think(dT)
	local sectionA = self.Train.SectionA
	self.DoorRandomness = sectionA.DoorRandomness
end
