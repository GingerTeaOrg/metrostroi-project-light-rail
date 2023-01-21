UF.AddIBISAnnouncer("Frankfurt",{
    delay_due_to_malfunction = {"lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction.mp3",1},
    delay_due_to_malfunction_further_info_pending = {"lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction_further_info_pending.mp3",1},
    diversion_due_to_malfunction = 
    escorted_by_security = {"lilly/uf/IBIS/announcements/special/imn/escorted_by_security.mp3",1},
    signal_delay = {"lilly/uf/IBIS/announcements/special/imn/signal_delay.mp3",1},
    this_train_terminates_due_to_malfunction = {"lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction.mp3",1},
    this_train_terminates_due_to_malfunction_further_info_on_platform = {"lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction_further_info_on_platform.mp3",1},
},
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
})