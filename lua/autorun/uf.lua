if SERVER then
    --include("autorun/metrostroi.lua")
end
if not UF then
    -- Global library
    UF = {}
    print("UF Library starting")
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
UF.IBISAnnouncementScript = {}
UF.IBISCommonFiles = {}
UF.SpecialAnnouncementsIBIS = {}
UF.IBISSetup = {}
UF.IBISDestinations = {}
UF.IBISRoutes = {}
UF.IBISLines = {}
UF.TrainPositions = {}
UF.Stations = {}
UF.TrainCountOnPlayer = {}
UF.IBISDevicesRegistered = {}

function UF.AddIBISCommonFiles(name,datatable)
    if not datatable then return end
    for k,v in pairs(UF.IBISCommonFiles) do
        if v.name == name then
            UF.IBISCommonFiles[k] = datatable
            UF.IBISCommonFiles[k].name = name
            print("Light Rail: Changed \""..name.."\" IBIS announcer.")
            return
        end
    end
    local id = table.insert(UF.IBISCommonFiles,datatable)
    UF.IBISCommonFiles[id].name = name
    
    print("Light Rail: Added \""..name.."\" IBIS announcer.")
end

function UF.AddIBISAnnouncementScript(name,datatable)
    if not datatable then return end
    for k,v in pairs(UF.IBISAnnouncementScript) do
        if v.name == name then
            UF.IBISAnnouncementScript[k] = datatable
            UF.IBISAnnouncementScript[k].name = name
            print("Light Rail: Changed \""..name.."\" IBIS announcer.")
            return
        end
    end
    local id = table.insert(UF.IBISAnnouncementScript,datatable)
    UF.IBISAnnouncementScript[id].name = name
    
    print("Light Rail: Added \""..name.."\" IBIS announcer.")
end

function UF.AddIBISDestinations(name,index)
    if not index or not name then return end
    for k,v in pairs(UF.IBISDestinations) do
        if v.name == name then
            UF.IBISDestinations[k] = index
            UF.IBISDestinations[k].name = name
            
            print("Light Rail: Loaded \""..name.."\" IBIS station index.")
            return
        end
    end
    local id = table.insert(UF.IBISDestinations,index)
    UF.IBISDestinations[id].name = name
    print("Light Rail: Loaded \""..name.."\" IBIS station index.")
end

function UF.AddIBISRoutes(name,routes)
    if not name or not routes then return end
    for k,v in pairs(UF.IBISRoutes) do
        if v.name == name then
            UF.IBISRoutes[k] = routes
            UF.IBISRoutes[k].name = name
            
            print("Light Rail: Reloaded \""..name.."\" IBIS Route index.")
            return
        end
    end
    local id = table.insert(UF.IBISRoutes,routes)
    UF.IBISRoutes[id].name = name
    print("Light Rail: Loaded \""..name.."\" IBIS Route index.")
end



function UF.AddIBISLines(name,lines)
    if not name or not lines then return end
    for k,v in pairs(UF.IBISLines) do
        if v.name == name then
            UF.IBISLines[k] = lines
            UF.IBISLines[k].name = name
            
            print("Light Rail: Reloaded \""..name.."\" IBIS line index.")
            return
        end
    end
    local id = table.insert(UF.IBISLines,lines)
    UF.IBISLines[id].name = name
    print("Light Rail: Loaded \""..name.."\" IBIS line index.")
end


function UF.AddIBISRoutes(name,routes)
    if not name or not routes then return end
    for k,v in pairs(UF.IBISRoutes) do
        if v.name == name then
            UF.IBISRoutes[k] = routes
            UF.IBISRoutes[k].name = name
            
            print("Light Rail: Reloaded \""..name.."\" IBIS Route index.")
            return
        end
    end
    local id = table.insert(UF.IBISRoutes,routes)
    UF.IBISRoutes[id].name = name
    print("Light Rail: Loaded \""..name.."\" IBIS Route index.")
end

function UF.AddIBISAnnouncements(name,datatable)
    if not datatable then return end
    for k,v in pairs(UF.AnnouncementsIBIS) do
        if v.name == name then
            UF.AnnouncementsIBIS[k] = datatable
            UF.AnnouncementsIBIS[k].name = name
            print("Light Rail: Changed \""..name.."\" IBIS announcer.")
            return
        end
    end
    local id = table.insert(UF.AnnouncementsIBIS,datatable)
    UF.AnnouncementsIBIS[id].name = name
    
    print("Light Rail: Added \""..name.."\" IBIS announcer.")
end

function UF.AddSpecialAnnouncements(name,soundtable)
    if not name or not soundtable then return end
    
    for k,v in pairs(UF.SpecialAnnouncementsIBIS) do
        if v.name == name then
            UF.SpecialAnnouncementsIBIS[k] = soundtable
            UF.SpecialAnnouncementsIBIS[k].name = name
            
            print("Light Rail: Changed \""..name.."\" IBIS Service Announcements.")
            return
        end
    end
    local id = table.insert(UF.SpecialAnnouncementsIBIS,soundtable)
    UF.SpecialAnnouncementsIBIS[id].name = name
    print("Light Rail: Added \""..name.."\" IBIS Service announcement set.")
end



function UF.AddRollsignTex(id,stIndex,texture)
    if not UF.Skins[id] then
        UF.Skins[id] = {}
        if defaults[id] then
            if type(defaults[id]) == "table" then
                UF.Skins[id].default = defaults[id][1]
                for i=2,#defaults[id] do
                    UF.AddRollsignTex(id:sub(1,-8),1000+(i-1),defaults[id][i])
                    print("Light Rail: Added Rollsign texture")
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


if SERVER then
    files = file.Find("uf/IBIS/*.lua","LUA")
    for _,filename in pairs(files) do
        AddCSLuaFile("uf/IBIS/"..filename)
        include("uf/IBIS/"..filename)
    end
    
    
    if Metrostroi.Paths then
        local options = { z_pad = 256 }
        if Metrostroi.IgnoreEntityUpdates then return end
        print("[!] LIGHT RAIL: Injecting Light Rail Signal Entities into Railnetwork")
        local entities = ents.FindByClass("gmod_track_uf_signal")
        for k,v in pairs(entities) do
            local pos = Metrostroi.GetPositionOnTrack(v:GetPos(),v:GetAngles() - Angle(0,90,0),options)[1]
            if pos then -- FIXME make it select proper path
                Metrostroi.SignalEntitiesForNode[pos.node1] = 
                Metrostroi.SignalEntitiesForNode[pos.node1] or {}
                table.insert(Metrostroi.SignalEntitiesForNode[pos.node1],v)
                
                -- A signal belongs only to a single track
                Metrostroi.SignalEntityPositions[v] = pos
                v.TrackPosition = pos
                v.TrackX = pos.x
                --else
                --print("position not found",k,v)
            end
        end
    end
    
end