function UF.AddARSSubSection(node,source)
    if true then return end
    local ent = ents.Create("gmod_track_uf_signal")
    if not IsValid(ent) then return end

    local tr = Metrostroi.RerailGetTrackData(node.pos - node.dir*32,node.dir)
    if not tr then return end

    ent:SetPos(tr.centerpos - tr.up * 9.5)
    ent:SetAngles((-tr.right):Angle())
    ent:Spawn()

    -- Add to list of ARS subsections
    Metrostroi.ARSSubSections[ent] = true
    Metrostroi.ARSSubSectionCount = Metrostroi.ARSSubSectionCount + 1
end
--hook.Add("Metrostroi.AddARSSubSection","UFInjectSignalBlocks",UF.AddARSSubSection) --just hook it when Metrostroi does its business

function UF.UpdateStations()
    if not Metrostroi.Stations then return end
    local platforms = ents.FindByClass("gmod_track_uf_platform")
    for _,platform in pairs(platforms) do
        local station = Metrostroi.Stations[platform.StationIndex] or {}
        Metrostroi.Stations[platform.StationIndex] = station

        -- Position
        local dir = platform.PlatformEnd - platform.PlatformStart
        local pos1 = Metrostroi.GetPositionOnTrack(platform.PlatformStart,dir:Angle())[1]
        local pos2 = Metrostroi.GetPositionOnTrack(platform.PlatformEnd,dir:Angle())[1]
        if pos1 and pos2 then
            -- Add platform to station
            local platform_data = {
                x_start = pos1.x,
                x_end = pos2.x,
                length = math.abs(pos2.x - pos1.x),
                node_start = pos1.node1,
                node_end = pos2.node1,
                ent = platform,
            }
            if station[platform.PlatformIndex] then
                print(Format("MPLR: Error, station %03d has two platforms %d with same index!",platform.StationIndex,platform.PlatformIndex))
            else
                station[platform.PlatformIndex] = platform_data
            end

            -- Print information
            print(Format("\t[%03d][%d] %.3f-%.3f km (%.1f m) on path %d",
                platform.StationIndex,platform.PlatformIndex,pos1.x*1e-3,pos2.x*1e-3,
                platform_data.length,platform_data.node_start.path.id))
        else
            print(Format("MPLR: Error, station %03d platform %d, cant find pos! \n\tStart%s \n\tEnd:%s",platform.StationIndex,platform.PlatformIndex,platform.PlatformStart,platform.PlatformEnd))
        end
    end
end
hook.Add("Metrostroi.UpdateStations","UFInjectStations",UF.UpdateStations) --just hook it when Metrostroi does its business

function UF.UpdateSignalEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    if CurTime() - Metrostroi.OldUpdateTime < 0.05 then
        print("MPLR: Stopping all updates!")
        Metrostroi.IgnoreEntityUpdates = true
        timer.Simple(0.2, function()
            print("MPLR: Retrieve updates.")
            Metrostroi.IgnoreEntityUpdates = false
            UF.UpdateSignalEntities()
            Metrostroi.UpdateSwitchEntities()
            Metrostroi.UpdateARSSections()
        end)
        return
    end
    Metrostroi.OldUpdateTime = CurTime()
    local options = { z_pad = 256 }

    UF.UpdateSignalNames()

    Metrostroi.SignalEntitiesForNode = {}
    Metrostroi.SignalEntityPositions = {}



    local count = 0
    local repeater = 0
    local entities = ents.FindByClass("gmod_track_signal")
    print("MPLR: PreInitialize signals")
    for k,v in pairs(entities) do
        local pos = Metrostroi.GetPositionOnTrack(v:GetPos(),v:GetAngles() - Angle(0,90,0),options)[1]
        local pos2 = Metrostroi.GetPositionOnTrack(v:LocalToWorld(Vector(0,10,0)), v:GetAngles() - Angle(0,90,0),options)
        if pos then -- FIXME make it select proper path

            Metrostroi.SignalEntitiesForNode[pos.node1] =
                Metrostroi.SignalEntitiesForNode[pos.node1] or {}
            table.insert(Metrostroi.SignalEntitiesForNode[pos.node1],v)

            -- A signal belongs only to a single track
            Metrostroi.SignalEntityPositions[v] = pos
            v.TrackPosition = pos
            v.TrackX = pos.x
            if pos2 and pos2[1] then
                v.TrackDir = (pos2[1].x - v.TrackX) < 0
            else
                print(Format("MPLR: Signal %s, second position not found, system can't detect direction of the signal!",v.Name))
                v.TrackDir = true
            end
        else
            if v.NextSignal ~= "" then
                print(Format("MPLR: Signal %s, position not found, system can't detect the track occupation!",v.Name))
            end
        end
        if not v.Routes[1] then ErrorNoHalt(Format("MPLR: Signal %s don't have first route!",v.Name)) end
        count = count + 1
    end
    print(Format("MPLR: Total signals: %u (normal: %u, repeaters: %u)", count, count-repeater, repeater))
end

hook.Add("Metrostroi.UpdateSignalEntities","UFInjectSignals",UF.UpdateSignalEntities) --just hook it when Metrostroi does its business

function UF.UpdateSignalNames()
    print("MPLR: Updating signal names...")
    if not Metrostroi.SignalEntitiesByName then Metrostroi.SignalEntitiesByName = {} end
    if not Metrostroi.GetARSJointCache then Metrostroi.GetARSJointCache = {} end
    local entities = ents.FindByClass("gmod_track_uf_signal*")
    for k,v in pairs(entities) do
        if v.Name then
            if Metrostroi.SignalEntitiesByName[v.Name] then--
                print(Format("MPLR: Signal with this name %s already exists! Check signal names!\nInfo:\n\tFirst signal:  %s\n\tPos:    %s\n\tSecond signal: %s\n\tPos:    %s",
                v.Name, Metrostroi.SignalEntitiesByName[v.Name], Metrostroi.SignalEntitiesByName[v.Name]:GetPos(), v, v:GetPos()))
            else
                Metrostroi.SignalEntitiesByName[v.Name] = v
            end
        end
    end
end
hook.Add("Metrostroi.UpdateSignalNames","UFInjectSignalNames",UF.UpdateSignalNames)

function UF.Save(name)
    if not file.Exists("metrostroi_data","DATA") then
        file.CreateDir("metrostroi_data")
    end
    name = name or game.GetMap()

    -- Format signs, signal, switch data
    local signs = {}
    local signals_ents = ents.FindByClass("gmod_track_uf_signal*")
    if not signals_ents then print("MPLR: Signs file is corrupted!") end
    for k,v in pairs(signals_ents) do
        if not Metrostroi.ARSSubSections[v] then
            local Routes = table.Copy(v.Routes)
            table.insert(signs,{
                Class = "gmod_track_uf_signal",
                Pos = v:GetPos(),
                Angles = v:GetAngles(),
                SignalType = v.SignalType,
                Name = v.Name,
                RouteNumberSetup = v.RouteNumberSetup,
                RouteNumber =   v.RouteNumber,
                Routes = Routes,
                Left = v.Left,
                PassOcc = v.PassOcc,
            })
        end
    end
    local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k,v in ipairs(switch_ents) do
        table.insert(signs,{
            Class = "gmod_track_uf_switch",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            Name = v.Name,
            NotChangePos = v.NotChangePos,
            LockedSignal = v.LockedSignal,
        })
    end
    --[[local signs_ents = ents.FindByClass("gmod_track_signs")
    for k,v in pairs(signs_ents) do
        table.insert(signs,{
            Class = "gmod_track_signs",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            SignType = v.SignType,
            YOffset = v.YOffset,
            ZOffset = v.ZOffset,
            Left = v.Left,
        })
    end]]
    signs.Version = Metrostroi.SignalVersion
    -- Save data
    print("MPLR: Saving signs and track definition...")
    local data = util.TableToJSON(signs,true)
    file.Write(string.format("metrostroi_data/signs_%s.txt",name),data)
    print(Format("Saved to metrostroi_data/signs_%s.txt",name))

    --[[local auto = {}
    local auto_ents = ents.FindByClass("gmod_track_autodrive_plate")
    for k,v in pairs(auto_ents) do
        if not v.Linked then
            table.insert(auto,{
                Pos = v:GetPos(),
                Angles = v:GetAngles(),
                Type = v.PlateType,
                Right = v.Right,
                Mode = v.Mode,
                Model = v.Model,
                StationID = v.StationID,
                StationPath = v.StationPath,

                --UPPS
                UPPS = v.UPPS,
                DistanceToOPV = v.DistanceToOPV,

                SBPPType = v.SBPPType,
                IsDeadlock = v.IsDeadlock,
                DriveMode = v.DriveMode,
                RightDoors = v.RightDoors,
                WTime = v.WTime,
                RKPos = v.RKPos,
            })
        end
    end
    print("MPLR: Saving auto definition...")
    local adata = util.TableToJSON(auto,true)
    file.Write(string.format("metrostroi_data/auto_%s.txt",name),adata)
    print(Format("MPLR: Saved to metrostroi_data/auto_%s.txt",name))]]
end

hook.Add("Metrostroi.Save","UFInjectSignals",UF.Save)

function UF.Load(name,keep_signs)
    if not Metrostroi then print("Quitting because Metrostroi not loaded") return end
    name = name or game.GetMap()

    --loadTracks(name)

    -- Initialize stations list
    UF.UpdateStations()
    -- Print info
    UF.PrintStatistics()

    -- Ignore updates to prevent created/removed switches from constantly updating table of positions
    Metrostroi.IgnoreEntityUpdates = true
    UF.LoadSignalling(name,keep_signs)



    timer.Simple(0.05,function()
        -- No more ignoring updates
        Metrostroi.IgnoreEntityUpdates = false
        -- Load ARS entities
        UF.UpdateSignalEntities()
        -- Load switches
        UF.UpdateSwitchEntities()
    end)
end
hook.Add("Metrostroi.Load","UFLoadSignals",UF.Load)

local function printTable(table, indent)
    if not indent then indent = 0 end

    for key, value in pairs(table) do
        if type(value) == "table" then
            print(string.rep("  ", indent) .. key .. "=")
            printTable(value, indent + 1)
        else
            print(string.rep("  ", indent) .. key .. "= " .. tostring(value))
        end
    end
end

local function getFile(path,name,id)
    local data,found
    if file.Exists(Format(path..".txt",name),"DATA") then
        print(Format("MPLR: Loading %s definition...",id))
        data= util.JSONToTable(file.Read(Format(path..".txt",name),"DATA"))
        found = true
        printTable(data,1)
    end
    if not data and file.Exists(Format(path..".lua",name),"LUA") then
        print(Format("MPLR: Loading default %s definition...",id))
        data= util.JSONToTable(file.Read(Format(path..".lua",name),"LUA"))
        found = true
    end
    if not found then
        print(Format("%s definition file not found: %s",id,Format(path,name)))
        return
    elseif not data then
        print(Format("Parse error in %s %s definition JSON",id,Format(path,name)))
        return
    end
    return data
end

local function findKeyInNestedTable(table, keyToFind)
    for key, value in pairs(table) do
        if key == keyToFind then
            return value
        elseif type(value) == "table" then
            local result = findKeyInNestedTable(value, keyToFind)
            if result then
                return result
            end
        end
    end
end

function UF.LoadSignalling(name,keep)
    if keep then return end
    local signs = getFile("metrostroi_data/signs_%s",name,"Signal")

    if not signs then return end

    local signals_ents = ents.FindByClass("gmod_track_uf_signal")
    for k,v in pairs(signals_ents) do SafeRemoveEntity(v) end
    local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k,v in pairs(switch_ents) do SafeRemoveEntity(v) end
    local signs_ents = ents.FindByClass("gmod_track_uf_signs")
    for k,v in pairs(signs_ents) do SafeRemoveEntity(v) end

    -- Create new entities (add a delay so the old entities clean up)
    print("MPLR: Loading signs, signals, switches...")
    local version
    version = signs.Version
    if not version then
        print("MPLR: This signs file is incompatible with signs version")
        signs = nil
    else
        signs.Version = nil
    end
    if version ~= 1.2 then
        print(Format("MPLR: !!Converting from version %.1f!! signals converted to %s.",version,TwoToSix and "2/6" or "1/5"))
    end
    for k,v in pairs(signs) do
        local ent = ents.Create(v.Class)
        if IsValid(ent) then
            ent:SetPos(v.Pos)
            ent:SetAngles(v.Angles)
            if v.Class == "gmod_track_switch" then
                ---CHANGE
                ent.LockedSignal = v.LockedSignal
                ent.NotChangePos = v.NotChangePos
                ent.Invertred = v.Invertred
                ent.Name = v.Name,
                ent:Spawn()
            end
            if v.Class == "gmod_track_uf_signal" then
                ent.SignalType = v.SignalType
                ent.Name = v.Name
                ent.RouteNumber = v.RouteNumber
                ent.IsolateSwitches = v.IsolateSwitches
                ent.Routes = v.Routes
                ent.Left = v.Left
                ent:Spawn()
            elseif v.Class == "gmod_track_uf_signs" then
                ent.SignType = v.SignType
                ent.YOffset = v.YOffset
                ent.ZOffset = v.ZOffset
                ent.Left = v.Left,
                ent:Spawn()
                ent:SendUpdate()
            elseif v.Class == "gmod_track_uf_signal" then ent:Remove() end
        end
    end
end

function UF.PrintStatistics()
    local totalLength = 0
    for pathNo,path in pairs(Metrostroi.Paths) do
        totalLength = totalLength + path.length
    end

    print(Format("Metrostroi / MPLR: Total %.3f km of paths defined:",totalLength/1000))
    for pathNo,path in pairs(Metrostroi.Paths) do
        print(Format("\t[%d] %.3f km (%d nodes)",path.id,path.length/1000,#path))
    end

    local count = #Metrostroi.SpatialLookup
    local cells = {}
    for _,z in pairs(Metrostroi.SpatialLookup) do
        count = count + #z
        for _,x in pairs(z) do
            count = count + #x
            for _,y in pairs(x) do
                table.insert(cells,#y)
            end
        end
    end
    print(Format("Metrostroi: %d tables used for spatial lookup (%d cells)",count,#cells))
    local maxn,avgn = 0,0
    for k,v in pairs(cells) do maxn = math.max(maxn,v) avgn = avgn + v end
    print(Format("Metrostroi: Most nodes in cell: %d, average nodes in cell: %.2f",maxn,avgn/#cells))
end

function UF.UpdateSwitchEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    Metrostroi.SwitchesForNode = {}
    Metrostroi.SwitchesByName = {}

    local entities = ents.FindByClass("gmod_track_uf_switch")
    for k,v in pairs(entities) do
        local pos = Metrostroi.GetPositionOnTrack(v:GetPos(),v:GetAngles() - Angle(0,90,0))[1]
        if pos then
            if not v.Name or v.Name == "" then
                --pos.path.id.."/"..pos.node1.id
                if not Metrostroi.SwitchesByName[pos.path.id] then Metrostroi.SwitchesByName[pos.path.id] = {} end
                Metrostroi.SwitchesByName[pos.path.id][pos.node1.id] = v
            end
            Metrostroi.SwitchesForNode[pos.node1] = Metrostroi.SwitchesForNode[pos.node1] or {}
            table.insert(Metrostroi.SwitchesForNode[pos.node1],v)
            v.TrackPosition = pos -- FIXME: check that one switch belongs to one track
        end
        if v.Name and v.Name ~= "" then
            Metrostroi.SwitchesByName[v.Name] = v
        end

    end
    Metrostroi.PostSignalInitialize()
end