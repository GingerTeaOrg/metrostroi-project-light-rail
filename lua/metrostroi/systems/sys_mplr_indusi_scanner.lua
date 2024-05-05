Metrostroi.DefineSystem("mplr_INDUSI_scanner")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.ValidScanKeys = {
        "speed_forward",
        "speed_backward",
        "lights_on",
        "lights_off",
        "signal_danger_forward",
        "signal_danger_backward"
    }
    self.ScanDirection = "front"
end
function TRAIN_SYSTEM:Think(dT)
    local direction = self.Train.CoreSys.ReverserState > = 0
    local train = self.Train
    local deadman = self.Train.Deadman
    local speed = math.abs(self.Train.CoreSys.Speed)
    --we assume that the developer of the train has actually put the front bogey on the front of the train, so forwards = front bogey leading

    self.ScanEntity = direction and self.Train.FrontBogey or self.Train.FrontBogey

    self.ScanLocation = Metrostroi.GetPositionOnTrack(self.ScanEntity:GetPos(),self.ScanEntity:GetAngles())[1]

    self.SpeedLimitForward = self.ScanLocation and self.ScanLocation.node1.speed_forward or nil
    self.SpeedLimitBackward = self.ScanLocation and self.ScanLocation.node1.speed_backward or nil

    self.PassedSignal = Metrostroi.SignalEntitiesForNode[self.ScanLocation.node1] or Metrostroi.SignalEntitiesForNode[self.ScanLocation.node2]
    self.SignalTrackPos = IsValid(self.PassedSignal) or self.PassedSignal.TrackPosition or nil
    self.SPAD = IsValid(self.PassedSignal) and (self.SignalTrackPos.forward and self.ScanLocation.x > self.SignalTrackPos.x) or (not self.SignalTrackPos.forward and self.ScanLocation.x < self.SignalTrackPos.x) and self.ScanLocation.path == self.SignalTrackPos.path
    if self.SPAD then train:SetNW2Bool("DeadmanTripped",self.SPAD) end

    if self.SpeedLimitForward or self.SpeedLimitBackward then
        deadman:OverspeedProtection((direction and speed > self.SpeedLimitForward) or (not direction and speed > self.SpeedLimitBackward), direction and self.SpeedLimitForward or self.SpeedLimitBackward)
    end
end

