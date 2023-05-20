--[[UF.AddIBISAnnouncer("Frankfurt",
{
    {
        
        Name = "U6",
        spec_last = {"terminates_here"},
        Loop = false,
        {
            110,"Международная",
            arrlast = {nil,{"arr_mejdunarodnaya_f",0.5,"last_f",2,"things_f",2,"deadlock_f"},"mejdunarodnaya_m"},
            dep = {{"doors_closing_m","park_kultury_m"}},
            not_last_c = {nil,"not_last_f"},spec_last_c = {nil,"spec_last_f"}, spec_wait_c = {nil,"spec_wait_f"},
        },
        {
            111,"Парк Культуры",
            arr = {{"station_m","park_kultury_m"},"arr_park_kultury_f"},
            dep = {{"doors_closing_m","politehnicheskaya_m",0.2,"politeness_m"},{"doors_closing_f","next_mejdunarodnaya_f",0.2,"politeness_f"}},
            not_last_c = {nil,"not_last_f"},spec_last_c = {nil,"spec_last_f"}, spec_wait_c = {nil,"spec_wait_f"},
        },
        {
            112,"Политехнич.",
            arr = {{"station_m","politehnicheskaya_m",0.2,"things_m"},{"arr_politehnicheskaya_f",0.2,"objects_f"}},
            dep = {{"doors_closing_m","prospekt_suvorova_m"},{"doors_closing_f","next_park_kultury_f"}},
            not_last_c = {nil,"not_last_f"},spec_last_c = {nil,"spec_last_f"}, spec_wait_c = {nil,"spec_wait_f"},
        },
        {
            113,"Пр. Суворова",
            arr = {{"station_m","prospekt_suvorova_m",0.2,"objects_m"},{"station_m","prospekt_suvorova_m",0.2,"things_m"}},
            dep = {{"doors_closing_m","nahimovskaya_m"},{"doors_closing_m","politehnicheskaya_m"}},
            not_last_c = {nil,"not_last_f"},spec_last_c = {nil,"spec_last_f"}, spec_wait_c = {nil,"spec_wait_f"},
        },
    }
})]]

UF.AddSpecialAnnouncements("Badesalz",{
    "lilly/uf/IBIS/announcements/special/badesalz/arrival_at_stadium.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/clear_the_doors.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/departure_after_lost.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/diversion.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/end_of_line.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/greetings.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/put_your_feet_down.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/signal_malfunction.mp3",
    "lilly/uf/IBIS/announcements/special/badesalz/sorry_for_delay.mp3",

})

UF.AddSpecialAnnouncements("Ingrid FFM",{
    "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction.mp3",
    "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction_further_info_pending.mp3",
    "lilly/uf/IBIS/announcements/special/imn/diversion_due_to_malfunction.mp3",
    "lilly/uf/IBIS/announcements/special/imn/escorted_by_security.mp3",
    "lilly/uf/IBIS/announcements/special/imn/signal_delay.mp3",
    "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction.mp3",
    "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction_further_info_on_platform.mp3",
})

UF.AddIBISLines("Frankfurt",{

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

    ["01"] = {["01"] = {712,773,715,710,783,711},["02"] = {711,783,710,715,773,712}},
    ["02"] = {["01"] = {712,773,715,710,785,784},["02"] = {784,785,710,715,773,712}},
    ["03"] = {["01"] = {712,773,715,710,787,786},["02"] = {786,787,710,715,773,712}},
    ["04"] = {["01"] = {728,709,773,707,708},["02"] = {708,707,773,709,728}},
    ["05"] = {["01"] = {709,773,707,726},["02"] = {726,773,707,709}},
    ["06"] = {["01"] = {720,722,728,707,729,721},["02"] = {721,729,707,728,722,720}},
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
    [715] = "Eschenheimer Tor",
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
    [773] = "Willy-Brandt-Platz",
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