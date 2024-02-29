Metrostroi.DefineSystem("1973_panel")

function TRAIN_SYSTEM:Initialize()

    self.Train:LoadSystem("IgnitionKey","Relay","Switch", {bass = true})
    self.Train:LoadSystem("IgnitionKeyInserted","Relay","Switch", {bass = true})
    self.Train:LoadSystem("UncouplingKey","Relay","Switch", {bass = true})

    self.Train:LoadSystem("ParrallelMotors","Relay","Switch", {bass = true, normally_closed = true})

    self.Train:LoadSystem("Deadman","Relay","Switch", {bass = true})

    self.Train:LoadSystem("DoorsUnlock","Relay","Switch", {bass = true})
    self.Train:LoadSystem("DoorsLock","Relay","Switch", {bass = true})
    self.Train:LoadSystem("DoorsSelectRight","Relay","Switch", {bass = true})
    self.Train:LoadSystem("DoorsSelectLeft","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Door1","Relay","Switch",{bass = true})
    self.Train:LoadSystem("DoorsForceOpen","Relay","Switch", {bass = true})
    self.Train:LoadSystem("DoorsForceClose","Relay","Switch", {bass = true})

    self.Train:LoadSystem("MirrorLeft","Relay","Switch", {bass = true})
    self.Train:LoadSystem("MirrorRight","Relay","Switch", {bass = true})

    self.Train:LoadSystem("SwitchLeft","Relay","Switch", {bass = true})
    self.Train:LoadSystem("SwitchRight","Relay","Switch", {bass = true})

    self.Train:LoadSystem("BreakerOn","Relay","Switch", {bass = true})
    self.Train:LoadSystem("BreakerOff","Relay","Switch", {bass = true})

    self.Train:LoadSystem("PantographOn","Relay","Switch", {bass = true})
    self.Train:LoadSystem("PantographOff","Relay","Switch", {bass = true})

    self.Train:LoadSystem("Headlights","Relay","Switch", {bass = true})
    self.Train:LoadSystem("HazardBlink","Relay","Switch", {bass = true, normally_closed = false})
    self.Train:LoadSystem("DriverLight","Relay","Switch", {bass = true})

    self.Train:LoadSystem("BlinkerRight","Relay","Switch", {bass = true})
    self.Train:LoadSystem("BlinkerLeft","Relay","Switch", {bass = true})


    self.Train:LoadSystem("StepsHigh","Relay","Switch", {bass = true})
    self.Train:LoadSystem("StepsLow","Relay","Switch", {bass = true})
    self.Train:LoadSystem("StepsLowest","Relay","Switch", {bass = true})



    self.Train:LoadSystem("ReleaseHoldingBrake","Relay","Switch", {bass = true})
    self.Train:LoadSystem("SetHoldingBrake","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Bell","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Horn","Relay","Switch", {bass = true})
    self.Train:LoadSystem("ThrowCoupler","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number1","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number2","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number3","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number4","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number5","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number6","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number7","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number8","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number9","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Number0","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Enter","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Delete","Relay","Switch", {bass = true})
    self.Train:LoadSystem("Destination","Relay","Switch", {bass = true})
    self.Train:LoadSystem("SpecialAnnouncements","Relay","Switch", {bass = true})
    self.Train:LoadSystem("DateAndTime","Relay","Switch", {bass = true})
    self.Train:LoadSystem("SetPointLeft", "Relay", "Switch", {bass = true})
    self.Train:LoadSystem("SetPointRight", "Relay", "Switch", {bass = true})
    self.Train:LoadSystem("AnnouncerPlaying", "Relay", {bass = true})
    self.Train:LoadSystem("Parralel", "Relay", "Switch", {bass = true})
    self.Train:LoadSystem("Highbeam", "Relay", "Switch", {bass = true})
    self.Train:LoadSystem("Blinker", "Relay", {bass = true})
 
    self.Train:LoadSystem("Button1a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button2a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button3a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button4a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button5a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button6a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button7a", "Relay", "Switch", {bass=true})
    self.Train:LoadSystem("Button8a", "Relay", "Switch", {bass=true})

    self.HazardBlink = 0

    self.IgnitionKey = 0
    self.IgnitionKeyInserted = 0
    self.UncouplingKey = 0

    self.ParrallelMotors = 1

    self.Deadman = 0

    self.AnnouncementPlaying = 0

    self.DoorsUnlock = 0
    self.DoorsLock = 0
    self.DoorsSelectRight = 0
    self.DoorsSelectLeft = 0
    self.Door1 = 0
    self.DoorsForceOpen = 0
    self.DoorsForceClose = 0

    self.MirrorLeft = 0
    self.MirrorRight = 0

    self.SwitchLeft = 0
    self.SwitchRight = 0

    self.BreakerOn = 0
    self.BreakerOff = 0

    self.PantographOn = 0
    self.PantographOff = 0

    self.Headlights = 0
    self.WarnBlink = 0
    self.DriverLight = 0

    self.BlinkerLeft = 0
    self.BlinkerRight = 0

    self.StepsHigh = 0
    self.StepsLow = 0
    self.StepsLowest = 0

    self.Bell = 0
    self.Horn = 0

    self.ThrowCoupler = 0


    

end

function TRAIN_SYSTEM:Outputs()
    return {"IgnitionKey","IgnitionKeyInserted","UncouplingKey","ParrallelMotors","Deadman","AnnouncementPlaying","DoorsUnlock","DoorsLock","DoorsSelectRight","DoorsSelectLeft","Door1","DoorsForceOpen","DoorsForceClose","MirrorLeft","MirrorRight","SwitchLeft","SwitchRight","BreakerOn","BreakerOff","PantographOn","PantographOff","Headlights","WarnBlink","DriverLight","BlinkerLeft","BlinkerRight","StepsHigh","StepsLow","StepsLowest","Bell","Horn","ThrowCoupler"}
end
