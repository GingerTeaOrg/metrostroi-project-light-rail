Metrostroi.AnnouncementsIBIS = {}
Metrostroi.IBISSetup = {}
function Metrostroi.AddIBISAnnouncer(name,soundtable,datatable)
    if not soundtable or not datatable then return end
    for k,v in pairs(datatable) do
        if not istable(v) then continue end
        for k2,stbl in pairs(v) do
            if not istable(stbl) then continue end
            if stbl.have_interchange then stbl.have_interchange = true end
        end
    end
    for k,v in pairs(Metrostroi.AnnouncementsIBIS) do
        if v.name == name then
            Metrostroi.AnnouncementsIBIS[k] = soundtable
            Metrostroi.AnnouncementsIBIS[k].name = name
            Metrostroi.IBISSetup[k] = datatable
            Metrostroi.IBISSetup[k].name = name
            print("Metrostroi: Changed \""..name.."\" IBIS announcer.")
            return
        end
    end
    local id = table.insert(Metrostroi.AnnouncementsIBIS,soundtable)
    Metrostroi.AnnouncementsIBIS[id].name = name

    local id = table.insert(Metrostroi.IBISSetup,datatable)
    Metrostroi.IBISSetup[id].name = name
    print("Metrostroi: Added \""..name.."\" IBIS announcer.")
end