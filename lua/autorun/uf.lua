if not UF then
    -- Global library
    UF = {}

    -- Supported train classes
    UF.TrainClasses = {}
    UF.IsTrainClass = {}
    -- Supported train classes
    UF.TrainSpawnerClasses = {}
    timer.Simple(0.05, function()
        for name in pairs(scripted_ents.GetList()) do
            local prefix = "gmod_subway_uf_"
            if string.sub(name,1,#prefix) == prefix and scripted_ents.Get(name).Base == "gmod_subway_base" and not scripted_ents.Get(name).NoTrain then
                table.insert(UF.TrainClasses,name)
                UF.IsTrainClass[name] = true
            end
        end




    end)
    
end

--List of spawned trains
UF.SpawnedTrains = {}
for k,ent in pairs(ents.GetAll()) do
    if ent.ClassName == "gmod_subway_uf" then
        UF.SpawnedTrains[ent] = true
    end
end

hook.Add("EntityRemoved","UFTrains",function(ent)
    if UF.SpawnedTrains[ent] then
        UF.SpawnedTrains[ent] = nil
    end
end)
if SERVER then
    hook.Add("OnEntityCreated","UFTrains",function(ent)
        if ent:GetClass() == "gmod_subway_uf" then
            UF.SpawnedTrains[ent] = true
        end
    end)
else
    hook.Add("OnEntityCreated","UFTrains",function(ent)
        if ent:GetClass() == "gmod_subway_uf" then
            UF.SpawnedTrains[ent] = true
        end
    end)
end

UF.AnnouncementsIBIS = {}
UF.IBISSetup = {}
function UF.AddIBISAnnouncer(name,soundtable,datatable)
    if not soundtable or not datatable then return end
    for k,v in pairs(datatable) do
        if not istable(v) then continue end
        for k2,stbl in pairs(v) do
            if not istable(stbl) then continue end
            if stbl.have_inrerchange then stbl.have_interchange = true end
        end
    end
    for k,v in pairs(UF.AnnouncementsIBIS) do
        if v.name == name then
            UF.AnnouncementsIBIS[k] = soundtable
            UF.AnnouncementsIBIS[k].name = name
            UF.IBISSetup[k] = datatable
            UF.IBISSetup[k].name = name
            print("UF: Changed \""..name.."\" IBIS announcer.")
            return
        end
    end
    local id = table.insert(UF.AnnouncementsIBIS,soundtable)
    UF.AnnouncementsIBIS[id].name = name

    local id = table.insert(UF.IBISSetup,datatable)
    UF.IBISSetup[id].name = name
    print("UF: Added \""..name.."\" IBIS announcer.")
end

function UF.AddRollsignTex(id,stIndex,texture)
    if not UF.Skins[id] then
        UF.Skins[id] = {}
        if defaults[id] then
            if type(defaults[id]) == "table" then
                UF.Skins[id].default = defaults[id][1]
                for i=2,#defaults[id] do
                    UF.AddRollsignTex(id:sub(1,-8),1000+(i-1),defaults[id][i])
                end
            else
                UF.Skins[id].default = defaults[id]
            end
        end
    end
    local tbl = UF.Skins[id]
    for k,v in pairs(tbl) do
        if k == index then
            tbl[v] = texture
            return
        end
    end
    tbl[stIndex] = table.insert(tbl,texture)
end
