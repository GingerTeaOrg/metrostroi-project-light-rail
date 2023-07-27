Metrostroi.DefineSystem("U2_Electric")
TRAIN_SYSTEM.DontAccelerateSimulation = true


function TRAIN_SYSTEM:Initialize()
    Metrostroi.BaseSystems["Electric_UF"].Initialize(self) --Mostly highly customised to Metrostroi trains but maybe useful still? -- nevermind, downloaded it for modification
    if IsValid(self.Train.Panto) then
        self.PowerSupply = self.Train.Panto
    end
    self.TargetCurrent = 600 --some trains do up to 750V, the U2 runs on 600VDC
    self.Battery = self.Train.Duewag_Battery --who's your battery?


end


function TRAIN_SYSTEM:Think()
    local Train = self.Train
end
