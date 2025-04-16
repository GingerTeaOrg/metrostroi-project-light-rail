AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 1100
ENT.SyncTable = { "DoorsSelectRight", "DoorsSelectLeft", "ReduceBrake", "Highbeam", "SetHoldingBrake", "DoorsLock", "DoorsUnlock", "PantographRaise", "PantographLower", "Headlights", "WarnBlink", "Microphone", "BellEngage", "Horn", "WarningAnnouncement", "PantoUp", "DoorsCloseConfirm", "ReleaseHoldingBrake", "PassengerOverground", "PassengerUnderground", "SetPointRight", "SetPointLeft", "ThrowCoupler", "Door1", "UnlockDoors", "DoorCloseSignal", "Number1", "Number2", "Number3", "Number4", "Number6", "Number7", "Number8", "Number9", "Number0", "Destination", "Delete", "Route", "DateAndTime", "ServiceAnnouncements" }
ENT.Lights = {
    [ 50 ] = {
        -- cab light 1
        "light",
        Vector( 406, 39, 98 ),
        Angle( 90, 0, 0 ),
        Color( 227, 197, 160 ),
        brightness = 0.6,
        scale = 0.5,
        texture = "sprites/light_glow02.vmt"
    },
    [ 60 ] = {
        -- cab light 2
        "light",
        Vector( 406, -39, 98 ),
        Angle( 90, 0, 0 ),
        Color( 227, 197, 160 ),
        brightness = 0.6,
        scale = 0.5,
        texture = "sprites/light_glow02.vmt"
    },
    [ 51 ] = {
        -- headlight left
        "light",
        Vector( 425.464, 40, 28 ),
        Angle( 0, 0, 0 ),
        Color( 216, 161, 92 ),
        brightness = 0.6,
        scale = 1.5,
        texture = "sprites/light_glow02.vmt"
    },
    [ 52 ] = {
        -- headlight right
        "light",
        Vector( 425.464, -40, 28 ),
        Angle( 0, 0, 0 ),
        Color( 216, 161, 92 ),
        brightness = 0.6,
        scale = 1.5,
        texture = "sprites/light_glow02.vmt"
    },
    [ 53 ] = {
        -- headlight top
        "light",
        Vector( 425.464, 0, 111 ),
        Angle( 0, 0, 0 ),
        Color( 226, 197, 160 ),
        brightness = 0.9,
        scale = 0.45,
        texture = "sprites/light_glow02.vmt"
    },
    [ 54 ] = {
        -- tail light left
        "light",
        Vector( 425.464, 31.5, 25 ),
        Angle( 0, 0, 0 ),
        Color( 255, 0, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 55 ] = {
        -- tail light right
        "light",
        Vector( 425.464, -31.5, 25 ),
        Angle( 0, 0, 0 ),
        Color( 255, 0, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 56 ] = {
        -- brake lights
        "light",
        Vector( 426, 31.2, 31 ),
        Angle( 0, 0, 0 ),
        Color( 255, 102, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 57 ] = {
        -- brake lights
        "light",
        Vector( 426, -31.2, 31 ),
        Angle( 0, 0, 0 ),
        Color( 255, 102, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 58 ] = {
        -- indicator top left
        "light",
        Vector( 327, 52, 74 ),
        Angle( 0, 0, 0 ),
        Color( 255, 100, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 59 ] = {
        -- indicator top right
        "light",
        Vector( 327, -52, 74 ),
        Angle( 0, 0, 0 ),
        Color( 255, 102, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 48 ] = {
        -- indicator bottom left
        "light",
        Vector( 327, 52, 68 ),
        Angle( 0, 0, 0 ),
        Color( 255, 100, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 49 ] = {
        -- indicator bottom right
        "light",
        Vector( 327, -52, 68 ),
        Angle( 0, 0, 0 ),
        Color( 255, 102, 0 ),
        brightness = 0.9,
        scale = 0.1,
        texture = "sprites/light_glow02.vmt"
    },
    [ 30 ] = {
        "light",
        Vector( 397, 49, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front left 1
    [ 31 ] = {
        "light",
        Vector( 326.738, 49, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front left 2
    [ 32 ] = {
        "light",
        Vector( 151.5, 49, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front left 3
    [ 33 ] = {
        "light",
        Vector( 83.7, 49, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front left 4
    [ 34 ] = {
        "light",
        Vector( 396.884, -51, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front right 1
    [ 35 ] = {
        "light",
        Vector( 326.89, -51, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front right 2
    [ 36 ] = {
        "light",
        Vector( 152.116, -51, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front right 3
    [ 37 ] = {
        "light",
        Vector( 85, -51, 49.7 ),
        Angle( 0, 0, 0 ),
        Color( 9, 142, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- door button front right 4
    [ 38 ] = {
        "light",
        Vector( 416.20, 6, 54 ),
        Angle( 0, 0, 0 ),
        Color( 0, 90, 59 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- indicator indication lamp in cab
    [ 39 ] = {
        "light",
        Vector( 415.617, 18.8834, 54.8 ),
        Angle( 0, 0, 0 ),
        Color( 252, 247, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- battery discharge lamp in cab
    [ 40 ] = {
        "light",
        Vector( 415.617, 12.4824, 54.9 ),
        Angle( 0, 0, 0 ),
        Color( 0, 130, 99 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- clear for departure lamp
    [ 41 ] = {
        "light",
        Vector( 415.656, -2.45033, 54.55 ),
        Angle( 0, 0, 0 ),
        Color( 255, 0, 0 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    },
    -- doors unlocked lamp
    [ 42 ] = {
        "light",
        Vector( 415.656, 14.6172, 54.55 ),
        Angle( 0, 0, 0 ),
        Color( 27, 57, 141 ),
        brightness = 1,
        scale = 0.025,
        texture = "sprites/light_glow02.vmt"
    }
}

function ENT:Initialize()
    self.BaseClass.Initialize( self )
    self:SetModel( "models/lilly/uf/u1/body.mdl" )
    self.BaseClass.Initialize( self )
    self.DriverSeat = self:CreateSeat( "driver", Vector( 395, 15, 34 ) )
    self.InstructorsSeat = self:CreateSeat( "instructor", Vector( 395, -20, 10 ), Angle( 0, 90, 0 ), "models/vehicles/prisoner_pod_inner.mdl" )
    -- self.HelperSeat = self:CreateSeat("instructor",Vector(505,-25,55))
    self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
    self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
    self.InstructorsSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
    self.InstructorsSeat:SetColor( Color( 0, 0, 0, 0 ) )
    self.FrontCouple = self:CreateCustomCoupler( Vector( 415, 0, 0 ), Angle( 0, 0, 0 ), true, "u2", "a" )
    self.FrontBogey = self:CreateBogeyUF( Vector( 290, 0, 0 ), Angle( 0, 180, 0 ), true, "duewag_motor", "a" )
    self.MiddleBogey = self:CreateBogeyUF( Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), false, "u1joint", "a" )
    self.SectionB = self:CreateSection( Vector( 0, 0, 0 ), nil, --[[no angle]]
        "gmod_subway_uf_u1_section_b", self, nil, self )

    self.RearBogey = self:CreateBogeyUF( Vector( -290, 0, 0 ), Angle( 0, 180, 0 ), false, "duewag_motor", "b" )
    self.RearCouple = self:CreateCustomCoupler( Vector( -415, 0, 0 ), Angle( 0, 180, 0 ), false, "u2", "b" )
    self.Panto = self:CreatePanto( Vector( 35, 0, 115 ), Angle( 0, 90, 0 ), "diamond" )
    self.FrontBogey:SetNWString( "MotorSoundType", "U2" )
    self.MiddleBogey:SetNWString( "MotorSoundType", "U2" )
    self.RearBogey:SetNWString( "MotorSoundType", "U2" )
    -----------------------------
    self.TrainWireCrossConnections = {
        [ 4 ] = 3, -- Reverser F<->B
        [ 21 ] = 20, -- blinker
        [ 13 ] = 14,
        [ 31 ] = 32
    }

    ------------------------------
    self.KeyMap = {
        [ KEY_A ] = "ThrottleUp",
        [ KEY_D ] = "ThrottleDown",
        [ KEY_F ] = "ReduceBrake",
        [ KEY_H ] = "BellEngageSet",
        [ KEY_SPACE ] = "DeadmanPedalSet",
        [ KEY_W ] = "ReverserUpSet",
        [ KEY_S ] = "ReverserDownSet",
        [ KEY_P ] = "PantographRaiseSet",
        [ KEY_O ] = "UnlockDoorsSet",
        [ KEY_I ] = "DoorsLockSet",
        [ KEY_K ] = "DoorsCloseConfirmSet",
        [ KEY_Z ] = "WarningAnnouncementSet",
        [ KEY_J ] = "DoorsSelectLeftToggle",
        [ KEY_L ] = "DoorsSelectRightToggle",
        [ KEY_B ] = "BatteryToggle",
        [ KEY_V ] = "HeadlightsToggle",
        [ KEY_M ] = "Mirror",
        [ KEY_1 ] = "Throttle10Pct",
        [ KEY_2 ] = "Throttle20Pct",
        [ KEY_3 ] = "Throttle30Pct",
        [ KEY_4 ] = "Throttle40Pct",
        [ KEY_5 ] = "Throttle50Pct",
        [ KEY_6 ] = "Throttle60Pct",
        [ KEY_7 ] = "Throttle70Pct",
        [ KEY_8 ] = "Throttle80Pct",
        [ KEY_9 ] = "Throttle90Pct",
        [ KEY_PERIOD ] = "BlinkerRightToggle",
        [ KEY_COMMA ] = "BlinkerLeftToggle",
        [ KEY_PAD_MINUS ] = "IBISkeyTurnSet",
        [ KEY_LSHIFT ] = {
            [ KEY_0 ] = "ReverserInsert",
            [ KEY_A ] = "ThrottleUpFast",
            [ KEY_D ] = "ThrottleDownFast",
            [ KEY_S ] = "ThrottleZero",
            [ KEY_H ] = "Horn",
            [ KEY_V ] = "DriverLightToggle",
            [ KEY_COMMA ] = "WarnBlinkToggle",
            [ KEY_B ] = "BatteryDisableToggle",
            [ KEY_PAGEUP ] = "Rollsign+",
            [ KEY_PAGEDOWN ] = "Rollsign-",
            [ KEY_O ] = "Door1Set",
            [ KEY_1 ] = "Throttle10-Pct",
            [ KEY_2 ] = "Throttle20-Pct",
            [ KEY_3 ] = "Throttle30-Pct",
            [ KEY_4 ] = "Throttle40-Pct",
            [ KEY_5 ] = "Throttle50-Pct",
            [ KEY_6 ] = "Throttle60-Pct",
            [ KEY_7 ] = "Throttle70-Pct",
            [ KEY_8 ] = "Throttle80-Pct",
            [ KEY_9 ] = "Throttle90-Pct",
            [ KEY_P ] = "PantographLowerSet",
            [ KEY_MINUS ] = "RemoveIBISKey",
            [ KEY_PAD_MINUS ] = "IBISkeyInsertSet"
        },
        [ KEY_LALT ] = {
            [ KEY_PAD_1 ] = "Number1Set",
            [ KEY_PAD_2 ] = "Number2Set",
            [ KEY_PAD_3 ] = "Number3Set",
            [ KEY_PAD_4 ] = "Number4Set",
            [ KEY_PAD_5 ] = "Number5Set",
            [ KEY_PAD_6 ] = "Number6Set",
            [ KEY_PAD_7 ] = "Number7Set",
            [ KEY_PAD_8 ] = "Number8Set",
            [ KEY_PAD_9 ] = "Number9Set",
            [ KEY_PAD_0 ] = "Number0Set",
            [ KEY_PAD_ENTER ] = "EnterSet",
            [ KEY_PAD_DECIMAL ] = "DeleteSet",
            [ KEY_PAD_DIVIDE ] = "DestinationSet",
            [ KEY_PAD_MULTIPLY ] = "SpecialAnnouncementsSet",
            [ KEY_PAD_MINUS ] = "TimeAndDateSet",
            [ KEY_V ] = "PassengerLightsSet",
            [ KEY_D ] = "EmergencyBrakeSet",
            [ KEY_N ] = "Parrallel"
        }
    }
end

function ENT:TrainSpawnerUpdate()
    local tex = "Def_U2"
    self.MiddleBogey.Texture = self.Texture
    self:UpdateTextures()
    self.MiddleBogey:UpdateTextures()
    self.SectionB:UpdateTextures()
    -- self.MiddleBogey:UpdateTextures()
    -- self.MiddleBogey:UpdateTextures()
    -- self:UpdateLampsColors()
    self.FrontCouple.CoupleType = "u2"
    self.RearCouple.CoupleType = "u2"
    self.FrontCouple:SetParameters()
    self.RearCouple:SetParameters()
    -- self.SectionB:SetNW2String("Texture", self:GetNW2String("Texture"))
    -- self.SectionB.Texture = self:GetNW2String("Texture")
end