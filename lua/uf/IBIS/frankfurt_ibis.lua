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

    01,
    02,
    03,
    04,
    05,
    06,
    07,
    08,
    09,

})

UF.AddIBISRoutes("Frankfurt",{ --Format: [Line] = {[RouteNumber] = {StationNumber1,StationNumber2,StationNumber3,etc},[RouteNumber2] = {etc}}

    [01] = {[01] = {712,710,709},[02] = {709,710,712}},
    [02] = {},
    [04] = {},
    [05] = {},
    [06] = {},
    [07] = {},
    [08] = {},
    [09] = {}
})


for k, v in pairs(UF.IBISRoutes) do
    print(k,v[01])
end
UF.AddIBISDestinations("Frankfurt",{

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
    [779] = "Riedberg"

}
)