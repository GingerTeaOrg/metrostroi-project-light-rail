UF.AddSpecialAnnouncements("Hannover", {
		["01"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/stop_due_to_technical_issue.mp3"] = 5}},
		["02"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/delay_due_to_signal.mp3"] = 5}},
		["03"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/stop_due_to_fault_further_info.mp3"] = 5}},
		["04"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/unlocking_doors_on_line.mp3"] = 5}},
		["05"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/bus_replacement_service.mp3"] = 5}},
		["06"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/terminus.mp3"] = 5}},
		["07"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/uncoupling_a_car.mp3"] = 5}},
		["08"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/clear_the_doors.mp3"] = 5}},
		["09"] = {[1] = {["lilly/uf/IBIS/announcements/special/hannover/move_along_inside.mp3"] = 5}}
})

UF.AddIBISDestinations("Hannover", {
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
		[71] = "Kröpcke",
		[72] = "Wettenbergen",
		[73] = "Roderbruch",
		[76] = "Marienwerder",
		[78] = "Königsworther Platz",
		[81] = "Schl?gerstr",
		[83] = "Ahlem",
		[84] = "Stadtfriedhof Stöcken",
		[85] = "Schierholzstr",
		[88] = "Zoo",
		[89] = "Freundallee",
		[90] = "Zoo+Messe/Ost",
		[92] = "Messe/Ost",
		[95] = "Kronsberg"
})

UF.AddIBISLines("Hannover", {
		-- ["00"] = true,
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
		-- ["12"] = true,
		-- ["13"] = true,
		-- ["14"] = true,
		-- ["15"] = true,
		["16"] = true,
		["17"] = true,
		["18"] = true

})

UF.AddIBISRoutes("Hannover", { -- Format: [Line] = {[RouteNumber] = {StationNumber1,StationNumber2,StationNumber3,etc},[RouteNumber2] = {etc}}
		["01"] = {["01"] = {13, 14, 71, 40, 32}, ["02"] = {32, 40, 71, 14, 13}},
		["02"] = {["01"] = {12, 14, 07, 71, 40, 30}, ["02"] = {30, 40, 71, 07, 14, 12}},
		["03"] = {["01"] = {21, 07, 71, 69, 72}, ["02"] = {72, 69, 71, 07, 21}},
		["04"] = {["01"] = {58, 78, 71, 64, 73}, ["02"] = {73, 64, 71, 78, 58}},
		["09"] = {["01"] = {17, 07}, ["02"] = {07, 17}},
		["10"] = {["01"] = {83, 15, 27}, ["02"] = {27, 15, 83}},
		["11"] = {["01"] = {65, 71, 90}, ["02"] = {90, 71, 65}}
})

UF.AddIBISAnnouncementScript("Hannover", {[1] = "gong", [2] = "station"})

UF.AddIBISCommonFiles("Hannover", {["gong"] = {"lilly/uf/IBIS/announcements/hannover/common/gong.mp3", 1.3}})

UF.AddIBISAnnouncementMetadata("Hannover",
                               { -- format: {[station] = {[line] = {[route] = {[audiofile] = seconds}}}} | Sets the "station" element announcement routine for each station on a basis of line, route
		[01] = {
				["07"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/01_misburg.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/01_misburg_notice.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/01_misburg.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/01_misburg_notice.mp3"] = 1.8}
						}
				}
		},
		[07] = {
				["01"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_notice_010.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_notice_010.mp3"] = 1.8}
						}
				},
				["02"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				},
				["03"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				},
				["07"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				},
				["18"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				},
				["08"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				},
				["09"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/hannover/stations/07_hauptbahnhof_interchange.mp3"] = 1.8}
						}
				}
		},
		[12] = {
				["02"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/12_alte_heide.mp3"] = 1.8}, [2] = {["lilly/uf/IBIS/announcements/hannover/stations/endpunkt.mp3"] = 3}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/12_alte_heide.mp3"] = 1.8}, [2] = {["lilly/uf/IBIS/announcements/hannover/stations/endpunkt.mp3"] = 3}}
				}
		},
		[13] = {
				["01"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/13_langenhagen.mp3"] = 1.8}, [2] = {["lilly/uf/IBIS/announcements/hannover/stations/endpunkt.mp3"] = 3}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/13_langenhagen.mp3"] = 1.8}, [2] = {["lilly/uf/IBIS/announcements/hannover/stations/endpunkt.mp3"] = 3}}
				}
		},
		[14] = {
				["01"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/14_dragonerstr.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/14_dragonerstr.mp3"] = 1.1}}
				},
				["02"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/14_dragonerstr.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/14_dragonerstr.mp3"] = 1.1}}
				}
		},
		[40] = {
				["01"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/40_laatzen.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/40_laatzen.mp3"] = 1.1}}
				},
				["02"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/40_laatzen.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/40_laatzen.mp3"] = 1.1}}
				}
		},
		[71] = {
				["01"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/71_kröpcke.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/71_kröpcke.mp3"] = 1.1}}
				},
				["02"] = {
						["01"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/71_kröpcke.mp3"] = 1.1}},
						["02"] = {[1] = {["lilly/uf/IBIS/announcements/hannover/stations/71_kröpcke.mp3"] = 1.1}}
				}
		}
})
