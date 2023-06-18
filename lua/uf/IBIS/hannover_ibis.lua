UF.AddSpecialAnnouncements("Hannover",{
    ["01"] = "lilly/uf/IBIS/announcements/special/hannover/terminus.mp3",
    ["02"] = "lilly/uf/IBIS/announcements/special/hannover/uncoupling_a_car.mp3",
    ["03"] = "lilly/uf/IBIS/announcements/special/hannover/unlocking_doors_on_line.mp3",
    ["04"] = "lilly/uf/IBIS/announcements/special/hannover/stop_due_to_technical_issue.mp3",
    ["05"] = "lilly/uf/IBIS/announcements/special/hannover/stop_due_to_fault_further_info.mp3",
    ["06"] = "lilly/uf/IBIS/announcements/special/hannover/move_along_inside.mp3",
    ["07"] = "lilly/uf/IBIS/announcements/special/hannover/delay_due_to_signal.mp3",
    ["08"] = "lilly/uf/IBIS/announcements/special/hannover/clear_the_doors.mp3",
    ["09"] = "lilly/uf/IBIS/announcements/special/hannover/bus_replacement_service.mp3",
})



UF.AddIBISDestinations("Hannover",{
    [01] = "Misburg",
    [02] = "Buchholz/Bhf.",
    [07] = "Hauptbahnhof",
    [10] = "Haltenh.str+Nordh",
    [12] = "Alte Heide",
    [13] = "Langenhagen",
    [14] = "Dragonerstra?e",
    [15] = "Glocksee/Bhf.",
    [16] = "Bf. Leinhausen",
    [17] = "Empelde",
    [21] = "Altwarmbüchen",
    [24] = "Fuhsestra?e/Bhf.",
    [25] = "Waterloo", 
    [27] = "Hauptbahnhof/ZOB",
    [30] = "Rethen",
    [32] = "Sarstedt",
    [36] = "Döhren/Bhf",
    [40] = "Laatzen",
    [41] = "Nordhafen",
    [44] = "Messe/Nord",
    [45] = "Stöcken",
    [46] = "Fiedelerstra?e",
    [49] = "Schwarzer Bär",
    [51] = "Noltemeyebrücke",
    [54] = "Rethen+Messe/N",
    [57] = "Anderten",
    [58] = "Garbsen",
    [60] = "In den Sieb. Stücken",
    [63] = "Stadthalle",
    [64] = "Misburger Str.",
    [65] = "Haltenhoffstra?e",
    [66] = "Stationbrücke",
    [69] = "Wallensteinstr",
    [71] = "Kröpke",
    [72] = "Wettenbergen",
    [73] = "Rodenbruch",
    [76] = "Marienwerder",
    [78] = "Königsworther Platz",
    [81] = "Schlägerstr",
    [83] = "Ahlem",
    [84] = "Stadtfriedhof Stöcken",
    [85] = "Schierholzstr",
    [88] = "Zoo",
    [89] = "Freundallee",
    [90] = "Zoo+Messe/Ost",
    [92] = "Messe/Ost",
    [95] = "Kronsberg",
})

UF.AddIBISLines("Hannover",{
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
    ["10"] = true,
    ["11"] = true,
    ["12"] = true,
    ["13"] = true,
    ["14"] = true,
    ["15"] = true,
    ["16"] = true,
    ["17"] = true,
    ["18"] = true,

})

UF.AddIBISRoutes("Hannover",{ --Format: [Line] = {[RouteNumber] = {StationNumber1,StationNumber2,StationNumber3,etc},[RouteNumber2] = {etc}}
    ["01"] = {["01"] = {13,07,14,17,71,40,30,32},["02"] = {32,30,40,71,17,14,07,13}},
    ["09"] = {["01"] = {17,07},["02"] = {07,17}},
})

UF.AddIBISAnnouncementScript("Hannover",{

    [1] = "gong",
    [2] = "station",
    [3] = "interchange",
    [4] = "exitside",
})

UF.AddIBISCommonFiles("Hannover",{
    ["gong"] = "sound/lilly/uf/IBIS/announcements/hannover/common/gong.mp3",
    ["exit_left"] = "sound/lilly/uf/IBIS/announcements/hannover/common/exit_left.mp3",
    ["exit_right"] = "sound/lilly/uf/IBIS/announcements/hannover/common/exit_left.mp3",
    ["terminus"] = "lilly/uf/IBIS/announcements/special/hannover/terminus.mp3",
})