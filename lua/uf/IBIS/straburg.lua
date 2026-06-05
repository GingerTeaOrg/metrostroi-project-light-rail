MPLR.AddSpecialAnnouncements( "Straburg", {
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

MPLR.AddIBISLines( "Straburg", {
	-- ["00"] = true,
	[ "10" ] = true,
} )

MPLR.AddIBISRoutes( "Straburg", {
	-- Format: [Line] = {[RouteNumber] = {StationNumber1,StationNumber2,StationNumber3,etc},[RouteNumber2] = {etc}}
	[ "10" ] = {
		[ "01" ] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 },
		[ "02" ] = { 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 },
		[ "03" ] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 },
	},
} )

MPLR.AddIBISCommonFiles( "Straburg", {
	[ "gong" ] = { "lilly/mplr/ibis/gong.wav", 1.3 },
	[ "next_station" ] = { "lilly/mplr/ibis/gm_lightrail_straburg/common/next station.wav", 1.8 }
} )

MPLR.AddIBISDestinations( "Straburg", {
	[ 999 ] = "Leerfahrt",
	[ 001 ] = "Altes Depot",
	[ 002 ] = "Dortmunder Str",
	[ 003 ] = "Dubliner Str",
	[ 004 ] = "Cork-Weg",
	[ 005 ] = "Am Feldweg",
	[ 006 ] = "Bottroper Ldstr",
	[ 007 ] = "Im Zauberwald",
	[ 008 ] = "Platz der Freiheit",
	[ 009 ] = "Torvalds-Allee",
	[ 010 ] = "Alchemistenstr",
	[ 011 ] = "Marie-Curie-Weg",
	[ 012 ] = "Bessie-Blount-Hospital",
	[ 013 ] = "Duewag-Werke",
	[ 014 ] = "Daconienweg",
	[ 015 ] = "Straburger Ldstr",
	[ 016 ] = "Marktplatz",
	[ 017 ] = "Rundfunkturm",
	[ 018 ] = "Bundesbahnplatz",
	[ 019 ] = "Stadthalle",
	[ 020 ] = "Platz der Vielfalt",
	[ 021 ] = "Engelstor",
	[ 022 ] = "Stadtbahn-Hauptwerkstatt",
	[ 023 ] = "Himmelsbruecke",
	[ 024 ] = "Saphirstr",
	[ 025 ] = "Michael-Vom-Walde",
	[ 026 ] = "Eleonoragasse",
	[ 027 ] = "Herzogin-Daphne-Str",
	[ 028 ] = "Joshua-Von-Der-Heide",
	[ 029 ] = "Am Drachenfels"
} )

MPLR.AddIBISAnnouncementScript( "Straburg", {
	-- The general routine for announcement. Strings are from MPLR.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.
	[ 1 ] = "gong",
	[ 2 ] = "next_station",
	[ 3 ] = "station"
} )

MPLR.AddIBISAnnouncementMetadata( "Straburg", {
	--[[] format:  | Sets the "station" element announcement routine for each station on a basis of line, route
	--	{
	--	[station] = {
	--				[line] = {
							[route] = {
										[audiofile] = seconds}
									}
							}
		}
			]]
	[ 001 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/001_straburg_old_depot.wav" ] = 2
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/001_straburg_old_depot.wav" ] = 2
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/001_straburg_old_depot.wav" ] = 2
				},
			},
		}
	},
	[ 002 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/002_dortmunder_str.wav" ] = 1.8
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/002_dortmunder_str.wav" ] = 1.8
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/002_dortmunder_str.wav" ] = 1.8
				},
			},
		},
	},
	[ 003 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/003_dubliner_str.wav" ] = 1.8
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/003_dubliner_str.wav" ] = 1.8
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/003_dubliner_str.wav" ] = 1.8
				},
			},
		},
	},
	[ 004 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/004_corkweg.wav" ] = 1.8
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/004_corkweg.wav" ] = 1.8
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/004_corkweg.wav" ] = 1.8
				},
			},
		},
	},
	[ 005 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/005_am_feldweg.wav" ] = 1.8
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/005_am_feldweg.wav" ] = 1.8
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/005_am_feldweg.wav" ] = 1.8
				},
			},
		},
	},
	[ 006 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/006_bottroper_ldstr.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/006_bottroper_ldstr.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/006_bottroper_ldstr.wav" ] = 1.1
				},
			},
		},
	},
	[ 007 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/007_im_zauberwald.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/007_im_zauberwald.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/007_im_zauberwald.wav" ] = 1.1
				},
			},
		},
	},
	[ 008 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/008_platz_der_freiheit.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/008_platz_der_freiheit.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/008_platz_der_freiheit.wav" ] = 1.1
				},
			},
		},
	},
	[ 009 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/009_torvaldsallee.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/009_torvaldsallee.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/009_torvaldsallee.wav" ] = 1.1
				},
			},
		},
	},
	[ 010 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/010_alchemistenstr.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/010_alchemistenstr.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/010_alchemistenstr.wav" ] = 1.1
				},
			},
		},
	},
	[ 011 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/011_marie_curie_weg.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/011_marie_curie_weg.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/011_marie_curie_weg.wav" ] = 1.1
				},
			},
		},
	},
	[ 012 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/012_bessie_blount_hospital.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/012_bessie_blount_hospital.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/012_bessie_blount_hospital.wav" ] = 1.1
				},
			},
		},
	},
	[ 013 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/013_duewag_werke.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/013_duewag_werke.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/013_duewag_werke.wav" ] = 1.1
				},
			},
		},
	},
	[ 014 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/014_draconienweg.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/014_draconienweg.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/014_draconienweg.wav" ] = 1.1
				},
			},
		},
	},
	[ 015 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/015_straburger_hauptstr.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/015_straburger_hauptstr.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/015_straburger_hauptstr.wav" ] = 1.1
				},
			},
		},
	},
	[ 016 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/016_marktplatz.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/016_marktplatz.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/016_marktplatz.wav" ] = 1.1
				},
			},
		},
	},
	[ 017 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/017_rundfunkturm.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/017_rundfunkturm.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/017_rundfunkturm.wav" ] = 1.1
				},
			},
		},
	},
	[ 018 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/018_bundesbahnplatz.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/018_bundesbahnplatz.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/018_bundesbahnplatz.wav" ] = 1.1
				},
			},
		},
	},
	[ 019 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/019_stadthalle.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/019_stadthalle.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/019_stadthalle.wav" ] = 1.1
				},
			},
		},
	},
	[ 020 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/020_platz_der_vielfalt.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/020_platz_der_vielfalt.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/020_platz_der_vielfalt.wav" ] = 1.1
				},
			},
		},
	},
	[ 021 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/021_engelstor.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/021_engelstor.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/021_engelstor.wav" ] = 1.1
				},
			},
		},
	},
	[ 022 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/022_stadtbahn_hauptwerkstadt.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/022_stadtbahn_hauptwerkstadt.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/022_stadtbahn_hauptwerkstadt.wav" ] = 1.1
				},
			},
		},
	},
	[ 023 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/023_himmelsbruecke.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/023_himmelsbruecke.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/023_himmelsbruecke.wav" ] = 1.1
				},
			},
		},
	},
	[ 024 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/024_saphirstr.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/024_saphirstr.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/024_saphirstr.wav" ] = 1.1
				},
			},
		},
	},
	[ 025 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/025_michael_von_walde_str.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/025_michael_von_walde_str.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/025_michael_von_walde_str.wav" ] = 1.1
				},
			},
		},
	},
	[ 026 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/026_eleonoragasse.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/026_eleonoragasse.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/026_eleonoragasse.wav" ] = 1.1
				},
			},
		},
	},
	[ 027 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/027_herzogin_daphne_str.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/027_herzogin_daphne_str.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/027_herzogin_daphne_str.wav" ] = 1.1
				},
			},
		},
	},
	[ 028 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/028_joshua_von_der_heide_allee.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/028_joshua_von_der_heide_allee.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/028_joshua_von_der_heide_allee.wav" ] = 1.1
				},
			},
		},
	},
	[ 029 ] = {
		[ "10" ] = {
			[ "01" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/029_am_drachenfels.wav" ] = 1.1
				},
			},
			[ "02" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/029_am_drachenfels.wav" ] = 1.1
				},
			},
			[ "03" ] = {
				[ 1 ] = {
					[ "lilly/mplr/ibis/gm_lightrail_straburg/stations/029_am_drachenfels.wav" ] = 1.1
				},
			},
		},
	},
} )