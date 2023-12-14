Metrostroi.DefineSystem("Siemens_Fahrsperre")


function TRAIN_SYSTEM:Initialize()

    self.Bypassed = false

    self.ScanOrigin = self.Train.FrontBogey:LocalToWorld(Vector(0,0,0))


end