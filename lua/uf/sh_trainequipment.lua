
if not next(UF.BogeySounds) and not next(UF.BogeyTypes) and not UF.CouplerTypes then
    --add all default calues for all tables
    local DefSoundTab = {
        EngineSNDConfig = {
            U2 = {{"u2_1", 80, 0, 80, 1}, {"u2_2", 40, 30, 80, 1}},
            U3 = {{"u3_1", 80, 10, 80, 1}}
        },
        SoundNames = {
            ["u2_1"] = "lilly/uf/bogeys/u2/motor_primary.wav",
            ["u2_2"] = "lilly/uf/bogeys/u2/motor_secondary_test.wav",
            ["u3_1"] = "lilly/uf/bogeys/u2/motor_primary.wav",
            ["flangea"] = "lilly/uf/bogeys/u2/curvesqueal_a.mp3",
            ["flangeb"] = "lilly/uf/bogeys/u2/curvesqueal_b.mp3",
            ["flange1"] = "lilly/uf/bogeys/u2/curvesqueal.mp3",
            ["flange2"] = "lilly/uf/bogeys/u2/curvesqueal2.mp3",
            ["brakea_loop1"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brakea_loop2"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_loop1"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_loop2"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_loop3"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_loop4"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_loopb"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake2_loop1"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake2_loop2"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_squeal1"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
            ["brake_squeal2"] = "lilly/uf/bogeys/u2/brake_squeal.mp3",
        },
    }

    table.Add(UF.BogeySounds, DefSoundTab)
    local DefBogeyTab = {
        u5 = {"models/lilly/uf/u5/bogey.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, -3.3), Vector(4.3, 63, -3.3),},
        u2joint = {"models/lilly/uf/u2/jointbogey.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, 0), Vector(4.3, 63, 0),},
        u3joint = {"models/lilly/uf/u3/jointbogey.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, 0), Vector(4.3, 63, 0),},
        duewag_motor = {"models/lilly/uf/bogey/duewag_motor.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, -3.3), Vector(4.3, 63, -3.3),},
        ptb = {"models/lilly/uf/ptb/ptbogey.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, -3.3), Vector(4.3, 63, -3.3),},
        def = {"models/lilly/uf/bogey/duewag_motor.mdl", Vector(0, 0.0, 0), Angle(0, 0, 0), nil, Vector(0, -61, -14), Vector(0, 61, -14), nil, Vector(4.3, -63, -3.3), Vector(4.3, 63, -3.3),},
    }

    table.Add(UF.BogeyTypes, DefBogeyTab)
    local DefCouplerTab = {
        ["u5"] = {"models/lilly/uf/coupler_new.mdl", Vector(42.5, 0, 0)},
        ["u2"] = {"models/lilly/uf/coupler_new.mdl", Vector(38, 0, 0)},
        ["pt"] = {"models/lilly/uf/coupler_new.mdl", Vector(37.7, 0, 0)},
        def = {"models/lilly/uf/coupler_new.mdl", Vector(38, 0, 0)},
    }

    table.Add(UF.CouplerTypes, DefCouplerTab)
    files = file.Find("uf/trainequipment/*.lua", "LUA")
    for _, filename in pairs(files) do
        AddCSLuaFile("uf/" .. filename)
        include("uf/" .. filename)
    end
end

print("MPLR: Set up couplers and bogeys!")