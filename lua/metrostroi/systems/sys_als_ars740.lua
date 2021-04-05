--------------------------------------------------------------------------------
-- АРС-АЛС для русеча
-- переписал долбаеб (lindy2018)
-- UNNEEDABLE
-- нихуя не работет FIXME
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("ALS740")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	self.Train:LoadSystem("Relay","Switch", {bass = true})
	--self.Train:LoadSystem("ALSFreq","Relay","Switch",{bass=true})
	self.Train:LoadSystem("ALSCoil")
	-- Internal state
	self.SpeedLimit = 0
	--self.NextLimit = 0
	--self.ARSRing = false
	--self.Overspeed = false
	--self.ElectricBrake = false
	--self.PneumaticBrake1 = false
	--self.PneumaticBrake2 = true
	--self.AttentionPedal = false

	--self.KVT = false
	--self.LN = 0

	-- ARS wires
	-- Lamps
	---self.LKT = false
	--self.LVD = false
end

function TRAIN_SYSTEM:Outputs()
	return {
		"F1","F2","F3","F4","F5","F6","SpeedLimit" --,"NoFreq"
	}
end

function TRAIN_SYSTEM:Inputs()
	--return { "IgnoreThisARS","AttentionPedal","Ring" }
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local ALS = Train.ALSCoil
	local speed = math.Round(ALS.Speed or 0,1)

		if (ALS.F1+ALS.F2+ALS.F3+ALS.F4+ALS.F5+ALS.F6+self.NoFreq) == 0 then self.NoFreq = 1 end
		local V = math.floor(self.Speed +0.05)
		local Vlimit = 20
		local VLimit2
		if self.F4 then Vlimit = 40 end
		if self.F3 then Vlimit = 60 end
		if self.F2 then Vlimit = 70 end
		if self.F1 then Vlimit = 80 end

		-- Determine next limit and current limit
		self.SpeedLimit = VLimit2 or Vlimit+0.5
	
end
