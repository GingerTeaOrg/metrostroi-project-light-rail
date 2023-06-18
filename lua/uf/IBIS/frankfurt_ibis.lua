UF.AddSpecialAnnouncements("Frankfurt",{
    ["01"] = "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction.mp3",
    ["02"] = "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction_further_info_pending.mp3",
    ["03"] = "lilly/uf/IBIS/announcements/special/imn/diversion_due_to_malfunction.mp3",
    ["04"] = "lilly/uf/IBIS/announcements/special/imn/escorted_by_security.mp3",
    ["05"] = "lilly/uf/IBIS/announcements/special/imn/signal_delay.mp3",
    ["06"] = "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction.mp3",
    ["07"] = "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction_further_info_on_platform.mp3",
    ["08"] = "lilly/uf/IBIS/announcements/special/badesalz/arrival_at_stadium.mp3",
    ["09"] = "lilly/uf/IBIS/announcements/special/badesalz/clear_the_doors.mp3",
    ["10"] = "lilly/uf/IBIS/announcements/special/badesalz/departing_after_lost.mp3",
    ["11"] = "lilly/uf/IBIS/announcements/special/badesalz/diversion.mp3",
    ["12"] = "lilly/uf/IBIS/announcements/special/badesalz/end_of_line.mp3",
    ["13"] = "lilly/uf/IBIS/announcements/special/badesalz/greetings.mp3",
    ["14"] = "lilly/uf/IBIS/announcements/special/badesalz/put_your_feet_down.mp3",
    ["15"] = "lilly/uf/IBIS/announcements/special/badesalz/signal_malfunction.mp3",
    ["16"] = "lilly/uf/IBIS/announcements/special/badesalz/sorry_for_delay.mp3",
    ["17"] = "lilly/uf/IBIS/announcements/special/badesalz/ABFAHRT.mp3"
})

UF.AddIBISAnnouncements("Frankfurt",{

    [707] = {[1] = "sound/lilly/uf/IBIS/announcements/ffm/ubahn/stations/707.mp3"},
    [709] = {[1] = "sound/lilly/uf/IBIS/announcements/ffm/ubahn/stations/709.mp3"},
})

UF.AddIBISLines("Frankfurt",{
    --["00"] = true,
    ["01"] = true,
    ["02"] = true,
    ["03"] = true,
    ["04"] = true,
    ["05"] = true,
    ["06"] = true,
    ["07"] = true,
    ["08"] = true,
    ["09"] = true,

})

UF.AddIBISRoutes("Frankfurt",{ --Format: [Line] = {[RouteNumber] = {StationNumber1,StationNumber2,StationNumber3,etc},[RouteNumber2] = {etc}}

    ["01"] = {["01"] = {712,773,715,710,783,711},["02"] = {711,783,710,715,773,712},["00"] = {000,000}},
    ["02"] = {["01"] = {712,773,715,710,785,784},["02"] = {784,785,710,715,773,712}},
    ["03"] = {["01"] = {712,773,715,710,787,786},["02"] = {786,787,710,715,773,712}},
    ["04"] = {["01"] = {728,709,773,707,708},["02"] = {708,707,773,709,728},["03"] = {728,709,773,707,708,723,724},["04"] = {724,723,708,707,773,709,728}},
    ["05"] = {["01"] = {709,773,707,726},["02"] = {726,773,707,709}},
    ["06"] = {["01"] = {720,722,728,707,729,721},["02"] = {721,729,707,728,722,720},["03"] = {720,722,728,707,729,704,790}},
    ["07"] = {["01"] = {725,722,728,707,729,704,723,724},["02"] = {724,723,704,729,707,728,722,725}},
    ["08"] = {["01"] = {712,773,715,710,779},["02"] = {779,710,715,773,712}},
    ["09"] = {["01"] = {711,714,713},["02"] = {713,714,711}}
})



UF.AddIBISDestinations("Frankfurt",{
    [045] = "Leerfahrt",
    [700] = " ",
    [701] = "PROBEWAGEN NICHT EINSTEIGEN",
    [702] = "FAHRSCHULE NICHT EINSTEIGEN",
    [703] = "SONDERWAGEN NICHT EINSTEIGEN",
    [704] = "EISSPORTHALLE Festplatz",
    [707] = "Konstablerwache",
    [708] = "Seckbacker Ldstr",
    [709] = "Hauptbahnhof",
    [710] = "Heddernheim",
    [711] = "Ginnheim",
    [712] = "Südbahnhof",
    [713] = "Nieder-Eschbach",
    [714] = "Römerstadt",
    [715] = "Eschenheimer T",
    [716] = "Gonzenheim",
    [717] = "Oberursel Bhf",
    [718] = "Oberursel Hhmrk",
    [719] = "Oberursel Bmmrsh",
    [720] = "Heerstrasse",
    [721] = "Ostbahnhof",
    [722] = "Industriehof",
    [723] = "Johanna-Tesch Pltz",
    [724] = "Enkheim",
    [725] = "Hausen",
    [726] = "Preungesheim",
    [727] = "Eckenheimer Ldstr",
    [728] = "Bockenheimer Warte",
    [729] = "Zoo",
    [739] = "Stadtbahn-Zentralwerkstatt",
    [773] = "Willy-Brandt-Pl",
    [779] = "Riedberg",
    [782] = "Heddernheim",
    [783] = "Römerstadt",
    [784] = "BAD HOMBURG Gonzenheim",
    [785] = "Nieder-Eschbach",
    [786] = "OBERURSEL Hohemark",
    [787] = "OBERURSEL Bahnhof",
    [788] = "OBERURSEL Bommersheim",
    [789] = "FRANKFURT Südbahnhof",
    [790] = "RIEDERWALD Schäfflestr",
    [791] = "BORNHEIM Seckbacher Ldstr",
    [792] = "Zoo >> J. Tesch-Platz",
    [793] = "Riedberg",
    [794] = "BITTE NICHT einsteigen",
    [795] = "Eschenheimer Tor",


}
)

UF.AddIBISAnnouncementScript("Frankfurt",{

    [1] = "next_station",
    [2] = "station",
    [3] = "interchange",
    [4] = "exitside",
})

--[[UF.AddIBISAnnouncementMetadata("Frankfurt",{ --format: [station] = {[line] = {}}

    [707] = {[07] = {interchange = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/stations/707_interchange_06.mp3",15}, exit_left = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3",1}}

})]]

UF.AddIBISCommonFiles("Frankfurt",{
    next_station = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/common/next_station.mp3",1},
    exit_left = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3",1},
    exit_right = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_right.mp3",1},
    terminus = {"sound/lilly/uf/IBIS/announcements/ffm/ubahn/common/terminus.mp3",1},
},{next_station,exit_left})