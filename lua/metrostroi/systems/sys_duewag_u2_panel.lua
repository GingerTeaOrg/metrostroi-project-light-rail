Metrostroi.DefineSystem( "U2_panel" )
function TRAIN_SYSTEM:Initialize()
    self.Train:LoadSystem( "WarningAnnouncement", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Ventilation", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "DeadmanPedal", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "PantoUp", "Relay", "Switch", {
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

    self.Train:LoadSystem( "BatteryDisable", "Relay", "Switch", {
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

    self.Train:LoadSystem( "Number1", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number2", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number3", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number4", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number5", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number6", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number7", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number8", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number9", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Number0", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Enter", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Delete", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Destination", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "SpecialAnnouncements", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "DateAndTime", "Relay", "Switch", {
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

    self.Train:LoadSystem( "Button1a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button2a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button3a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button4a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button5a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button6a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button7a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "Button8a", "Relay", "Switch", {
        bass = true
    } )

    self.Train:LoadSystem( "UnlockDoorButton", "Relay", "Switch", {
        bass = true
    } )

    self.UnlockDoorButton = 0
    self.DeadmanPedal = 0
    self.Button1a = 0
    self.Button2a = 0
    self.Button3a = 0
    self.Button4a = 0
    self.Button5a = 0
    self.Button6a = 0
    self.Button7a = 0
    self.Button8a = 0
    self.Wiper = 0
    self.ReduceBrake = 0
    self.Blinker = 0
    self.Highbeam = 0
    self.BlinkerLeft = 0
    self.BlinkerRight = 0
    self.DoorsLock = 0
    self.WarnBlink = 0
    self.AnnouncerPlaying = 0
    self.Number0 = 0
    self.Number1 = 0
    self.Number2 = 0
    self.Number3 = 0
    self.Number4 = 0
    self.Number5 = 0
    self.Number6 = 0
    self.Number7 = 0
    self.Number8 = 0
    self.Number9 = 0
    self.Enter = 0
    self.Delete = 0
    self.Destination = 0
    self.DateAndTime = 0
    self.SpecialAnnouncements = 0
    self.Door1 = 0
    self.Bell = 0
    self.Horn = 0
    self.WarningAnnouncement = 0
    self.PantoUp = 0
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
end

function TRAIN_SYSTEM:Outputs()
    return { "DoorsLock", "DoorsSelectRight", "DoorsSelectLeft", "DeadmanPedal", "Wiper", "BlinkerRight", "BlinkerLeft", "WarnBlink", "Microphone", "BellEngage", "Horn", "WarningAnnouncement", "PantographRaise", "PantographLower", "DoorsCloseConfirm", "PassengerLightsOn", "PassengerLightsOff", "SetHoldingBrake", "ReleaseHoldingBrake", "DoorsCloseConfirm", "SetPointRight", "SetPointLeft", "ThrowCoupler", "Door1", "UnlockDoors", "DoorCloseSignal", "Number1", "Number2", "Number3", "Number4", "Number6", "Number7", "Number8", "Number9", "Number0", "Destination", "Delete", "Route", "DateAndTime", "SpecialAnnouncements", "Headlights" }
end