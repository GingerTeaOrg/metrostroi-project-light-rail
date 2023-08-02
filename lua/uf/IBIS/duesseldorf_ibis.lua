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

UF.AddIBISCommonFiles("Düsseldorf",{
    ["gong"] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/next_station.mp3"] = 1.2},
    ["terminus"] = {["lilly/uf/IBIS/announcements/ffm/ubahn/common/terminus.mp3"] = 1},
    ["request_stop"] = {["lilly/uf/IBIS/announcements/rheinbahn/common/request_stop.mp3"] = 1.5},
})

UF.AddIBISDestinations("Frankfurt",{
    [158] = "Grunewald",
    [159] = "Karl-Jarres-Str",
    [160] = "Kremerstraße",
    [163] = "König-Heinrich-Pl",
    [164] = "Duisburg Hbf",
    [165] = "Duissern",
    [177] = "Steinsche Gasse",
    [178] = "Platanenhof",
    [185] = "Meiderich Bf",
    [363] = "Auf Dem Damm",
    [670] = "Heinrich-Heine-Allee",
    [881] = "Messe Ost",
 


}
)