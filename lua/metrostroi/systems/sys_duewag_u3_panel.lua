Metrostroi.DefineSystem( "U3_panel" )
function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem( "CircuitOn", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "RetainerOn", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "RetainerOff", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "CircuitOff", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Ventilation", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Deadman", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PantoRaise", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PantoLower", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "UnlockDoors", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "DoorsLock", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "DoorsCloseConfirm", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Door1", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Battery", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Headlights", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "WarnBlink", "Relay", "Switch", {
        bass = true,
        normally_closed = false
    } )

    self.Train:LoadSystem( "Wiper", "Relay", "Switch", {
        bass = true,
        normally_closed = false
    } )

    self.Train:LoadSystem( "DriverLight", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "BatteryOn", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "BatteryOff", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "BlinkerRight", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "BlinkerLeft", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PassengerOverground", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PassengerUnderground", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PantographRaise", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PantographLower", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "ReleaseHoldingBrake", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "SetHoldingBrake", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Bell", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Horn", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "ThrowCoupler", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "SetPointLeft", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "SetPointRight", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "AnnouncerPlaying", "Relay", {
        bass = true
    } )

    self.Train:LoadSystem( "Parralel", "Relay", "Switch", {
        bass = true,
        normally_closed = true
    } )

    self.Train:LoadSystem( "Highbeam", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Blinker", "Relay", {
        bass = true
    } )

    self.Train:LoadSystem( "ReduceBrake", "Relay", {
        bass = true
    } )

    self.Train:LoadSystem( "DoorsSelectLeft", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "DoorsSelectRight", "Relay", "Switch", {
        bass = true
    } )

    self.Wiper = 0
    self.ReduceBrake = 0
    self.Blinker = 0
    self.Highbeam = 0
    self.BlinkerLeft = 0
    self.BlinkerRight = 0
    self.DoorsLock = 0
    self.WarnBlink = 0
    self.AnnouncerPlaying = 0
    self.Door1 = 0
    self.Bell = 0
    self.Horn = 0
    self.WarningAnnouncement = 0
    self.DoorsCloseConfirm = 0
    self.SetHoldingBrake = 0
    self.ReleaseHoldingBrake = 0
    self.PassengerOverground = 0
    self.PassengerUnderground = 0
    self.PantographRaise = 0
    self.PantographLower = 0
    self.DoorsCloseConfirm = 0
    self.SetPointRight = 0
    self.SetPointLeft = 0
    self.ThrowCoupler = 0
    self.UnlockDoors = 0
    self.DoorCloseSignal = 0
    self.Parralel = 1
    self.Headlights = 0
    self.DoorsSelectLeft = 0
    self.DoorsSelectRight = 0
    self.DeadmanPedal = 0
end

function TRAIN_SYSTEM:Outputs()
    return { "DeadmanPedal", "Wiper", "BlinkerRight", "BlinkerLeft", "WarnBlink", "Microphone", "Bell", "Horn", "WarningAnnouncement", "PantographRaise", "PantographLower", "DoorsCloseConfirm", "PassengerLightsOn", "PassengerLightsOff", "SetHoldingBrake", "ReleaseHoldingBrake", "DoorsCloseConfirm", "SetPointRight", "SetPointLeft", "ThrowCoupler", "Door1", "UnlockDoors", "DoorCloseSignal", "Headlights" }
end