MPLR.AddSpecialAnnouncements( "Demo", {
    [ "01" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction.mp3" ] = 10
        }
    },
    [ "02" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/delay_due_to_malfunction_further_info_pending.mp3" ] = 10
        }
    },
    [ "03" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/diversion_due_to_malfunction.mp3" ] = 10
        }
    },
    [ "04" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/escorted_by_security.mp3" ] = 10
        }
    },
    [ "05" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/signal_delay.mp3" ] = 10
        }
    },
    [ "06" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction.mp3" ] = 10
        }
    },
    [ "07" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/imn/this_train_terminates_due_to_malfunction_further_info_on_platform.mp3" ] = 10
        }
    },
    [ "08" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/arrival_at_stadium.mp3" ] = 10
        }
    },
    [ "09" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/clear_the_doors.mp3" ] = 10
        }
    },
    [ "10" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/departing_after_lost.mp3" ] = 10
        }
    },
    [ "11" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/diversion.mp3" ] = 10
        }
    },
    [ "12" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/end_of_line.mp3" ] = 10
        }
    },
    [ "13" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/greetings.mp3" ] = 10
        }
    },
    [ "14" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/put_your_feet_down.mp3" ] = 10
        }
    },
    [ "15" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/signal_malfunction.mp3" ] = 10
        }
    },
    [ "16" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/sorry_for_delay.mp3" ] = 10
        }
    },
    [ "17" ] = {
        [ 1 ] = {
            [ "lilly/uf/IBIS/announcements/special/badesalz/ABFAHRT.mp3" ] = 10
        }
    }
} )

MPLR.AddIBISLines( "Demo", {
    -- ["00"] = true,
    [ "01" ] = true,
} )

MPLR.AddIBISDestinations( "Demo", {
    [ 999 ] = "Leerfahrt",
    [ 001 ] = "Borsigallee",
    [ 002 ] = "Katernberger Str",
    [ 003 ] = "Dom/Römer",
    [ 004 ] = "Zoo",
    [ 005 ] = "Höhenstr",
    [ 006 ] = "Nordwest-Zentrum"
} )

MPLR.AddIBISAnnouncementScript( "Demo", {
    -- The general routine for announcement. Strings are from MPLR.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.
    [ 1 ] = "next_station",
    [ 2 ] = "station"
} )