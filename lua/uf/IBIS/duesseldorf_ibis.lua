UF.AddIBISLines("Düsseldorf",{
    ["74"] = true,
    ["77"] = true,
    ["78"] = true,
    ["79"] = true,
    ["81"] = true,

})

UF.AddIBISAnnouncementScript("Düsseldorf",{ --The general routine for announcement. Strings are from UF.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.

    [1] = "gong",
    [2] = "station",
})

UF.AddIBISAnnouncementScript("Düsseldorf Vintage",{ --The general routine for announcement. Strings are from UF.AddIBISCommonFiles. Table listing index numbers dictate the order of announcements. Any arbitrary extra announcements defined in IBISCommonFiles can be prefixed or appended.

    [1] = "gong_old",
    [2] = "station",
})

UF.AddIBISCommonFiles("Düsseldorf",{
    ["gong"] = {"lilly/uf/IBIS/announcements/rheinbahn/common/gong.mp3", 1.2},
	["gong_old"] = {"lilly/uf/IBIS/announcements/rheinbahn/common/gong_vintage.mp3", 1.2},
    ["terminus"] = {"lilly/uf/IBIS/announcements/rheinbahn/common/terminus.mp3", 1},
    ["request_stop"] = {"lilly/uf/IBIS/announcements/rheinbahn/common/request_stop.mp3", 1.5},
})

UF.AddIBISDestinations("Düsseldorf",{
	[001] = "Moorenstra?e",
	[002] = "Am Steinberg",
	[003] = "Kopernikusstr",
	[004] = "Auf'm Hennekamp",
	[005] = "Redinghovenstr",
	[006] = "D-Volksgarten S",
	[007] = "Kruppstra?e",
	[008] = "Fichtenstra?e",
	[009] = "Kettwiger Stra?e U",
	[010] = "D-Flingern S",
	[011] = "Schumannstra?e",
	[012] = "D-Zoo S",
	[013] = "Tu?mannstra?e",
	[014] = "Stockkampstra?e",
	[015] = "Marienhospital",
	[017] = "Sternstr",
	[018] = "Paul-Klee-Weg",
	[019] = "Karolingerplatz",
	[020] = "Kittelbachstra?e",
	[031] = "König-Heinrich-Pl. U",
	[032] = "Duisburg Hbf S U",
	[056] = "DU-Meiderich Bf U",
	[066] = "Kremerstra?e",
	[067] = "Karl-Jarres-Stra?e",
    [069] = "Grunewald",
	[071] = "Kulturstra?e",
	[072] = "Im Schlenk",
	[073] = "Waldfriedhof",
	[074] = "Muenchener Str",
	[075] = "Sittardsberg",
	[076] = "Muehlenkamp",
	[077] = "St.-Anna-Krankenhaus",
	[388] = "Kesselsberg",
	[484] = "Auf dem Damm U",
	[580] = "Duissern U",
	[581] = "Steinische Gasse U",
	[582] = "Platanenhof",
	[583] = "Musfeldstr",
	[992] = "Grunewald Betriebshof",
    [163] = "König-Heinrich-Pl",
    [164] = "Duisburg Hbf",
    [165] = "Duissern",
    [177] = "Steinsche Gasse",
    [185] = "Meiderich Bf",
    [363] = "Auf Dem Damm",
    [670] = "Heinrich-Heine-Allee",
    [881] = "Messe Ost",
}
)

UF.AddIBISAnnouncementMetadata("Düsseldorf",
                               { -- format: {[station] = {[line] = {[route] = {[audiofile] = seconds}}}} | Sets the "station" element announcement routine for each station on a basis of line, route
		[704] = {
				["07"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3"] = 16},
								[3] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3"] = 2}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3"] = 16},
								[3] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3"] = 2}
						}
				},
				["06"] = {
						["01"] = {
								[1] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3"] = 16},
								[3] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3"] = 2}
						},
						["02"] = {
								[1] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704.mp3"] = 1.8},
								[2] = {["lilly/uf/IBIS/announcements/ffm/ubahn/stations/704_interchange_06.mp3"] = 16},
								[3] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/exit_left.mp3"] = 2}
						}
				},
			},
		

})