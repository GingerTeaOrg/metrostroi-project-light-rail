



UF.SwitchEntitiesByName = {}

UF.ActiveRoutes = {}
UF.SignalBlocks = {}


function UF.CheckOccupation()
    
    local DistantPos = self.DistantSignalEnt.TrackPosition.x
    local MyPos = self.TrackPosition
    for train, _ in pairs(Metrostroi.TrainPositions) do
        local TrainPos = Metrostroi.TrainPositions[train][1].x
        if MyPos.forward then
            if MyPos.x < TrainPos and DistantPos > TrainPos then
                return true
            end
        elseif not MyPos.forward then
            if MyPos.x > TrainPos and DistantPos < TrainPos then
                return true
            end
        end
    end
    return false
end

hook.Add("Initialize", "UF_MapInitialize", function()
    if not Metrostroi then assert(Metrostroi,"ERROR METROSTROI IS NOT INSTALLED / LOADED") return end
    timer.Simple(6, UF.Load)
end)

function UF.UpdateStations()
    if not Metrostroi.Stations then return end
    local platforms = ents.FindByClass("gmod_track_uf_platform")
    for _, platform in pairs(platforms) do
        local station = Metrostroi.Stations[platform.StationIndex] or {}
        Metrostroi.Stations[platform.StationIndex] = station
        
        -- Position
        local dir = platform.PlatformEnd - platform.PlatformStart
        local pos1 = Metrostroi.GetPositionOnTrack(platform.PlatformStart,
        dir:Angle())[1]
        local pos2 = Metrostroi.GetPositionOnTrack(platform.PlatformEnd,
        dir:Angle())[1]
        if pos1 and pos2 then
            -- Add platform to station
            local platform_data = {
                x_start = pos1.x,
                x_end = pos2.x,
                length = math.abs(pos2.x - pos1.x),
                node_start = pos1.node1,
                node_end = pos2.node1,
                ent = platform
            }
            if station[platform.PlatformIndex] then
                print(Format(
                "MPLR: Error, station %03d has two platforms %d with same index!",
                platform.StationIndex, platform.PlatformIndex))
            else
                station[platform.PlatformIndex] = platform_data
            end
            
            -- Print information
            print(Format("\t[%03d][%d] %.3f-%.3f km (%.1f m) on path %d",
            platform.StationIndex, platform.PlatformIndex,
            pos1.x * 1e-3, pos2.x * 1e-3, platform_data.length,
            platform_data.node_start.path.id))
        else
            print(Format(
            "MPLR: Error, station %03d platform %d, cant find pos! \n\tStart%s \n\tEnd:%s",
            platform.StationIndex, platform.PlatformIndex,
            platform.PlatformStart, platform.PlatformEnd))
        end
    end
end

function UF.UpdateSignalEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    if CurTime() - Metrostroi.OldUpdateTime < 0.05 then
        print("MPLR: Stopping all updates!")
        Metrostroi.IgnoreEntityUpdates = true
        timer.Simple(0.2, function()
            print("MPLR: Retrieve updates.")
            Metrostroi.IgnoreEntityUpdates = false
            UF.UpdateSignalEntities()
            UF.UpdateSwitchEntities()
            --Metrostroi.UpdateARSSections()
        end)
        return
    end
    Metrostroi.OldUpdateTime = CurTime()
    local options = {z_pad = 256}
    
    UF.UpdateSignalNames()
    
    Metrostroi.SignalEntitiesForNode = {}
    Metrostroi.SignalEntityPositions = {}
    
    local count = 0
    local repeater = 0
    local entities = ents.FindByClass("gmod_track_uf_signal*")
    print("MPLR: PreInitialize signals")
    for k, v in pairs(entities) do
        local pos = Metrostroi.GetPositionOnTrack(v:GetPos(), v:GetAngles() -
        Angle(0, 90, 0), options)[1]
        local pos2 = Metrostroi.GetPositionOnTrack(
        v:LocalToWorld(Vector(0, 10, 0)),
        v:GetAngles() - Angle(0, 90, 0), options)
        if pos then -- FIXME make it select proper path
            
            Metrostroi.SignalEntitiesForNode[pos.node1] = Metrostroi.SignalEntitiesForNode[pos.node1] or {}
            table.insert(Metrostroi.SignalEntitiesForNode[pos.node1], v)
            
            -- A signal belongs only to a single track
            Metrostroi.SignalEntityPositions[v] = pos
            v.TrackPosition = pos
            v.TrackX = pos.x
            v.DistantSignalEnt = Metrostroi.GetSignalByName(v.DistantSignal)
            if pos2 and pos2[1] then
                v.TrackDir = (pos2[1].x - v.TrackX) < 0
            else
                print(Format(
                "MPLR: Signal %s, second position not found, system can't detect direction of the signal!",
                v.Name))
                v.TrackDir = true
            end
        else
            if v.NextSignal ~= "" then
                print(Format(
                "MPLR: Signal %s, position not found, system can't detect the track occupation!",
                v.Name))
            end
        end
        -- if not v.Routes[1] then ErrorNoHalt(Format("MPLR: Signal %s don't have first route!",v.Name)) end
        count = count + 1
    end
    print(Format("MPLR: Total signals: %u (normal: %u, repeaters: %u)", count,
    count - repeater, repeater))
end

function UF.UpdateSignalNames()
    print("MPLR: Updating signal names...")
    if not Metrostroi.SignalEntitiesByName then
        Metrostroi.SignalEntitiesByName = {}
    end
    local entities = ents.FindByClass("gmod_track_uf_signal*")
    for k, v in pairs(entities) do
        if not IsValid(v) then continue end
        print(v, v.Name)
        if v.Name then
            if Metrostroi.SignalEntitiesByName[v.Name] then --
                print(Format(
                "MPLR: Signal with this name %s already exists! Check signal names!\nInfo:\n\tFirst signal:  %s\n\tPos:    %s\n\tSecond signal: %s\n\tPos:    %s",
                v.Name, Metrostroi.SignalEntitiesByName[v.Name],
                Metrostroi.SignalEntitiesByName[v.Name]:GetPos(), v,
                v:GetPos()))
            else
                Metrostroi.SignalEntitiesByName[v.Name] = v
            end
        end
    end
end

function UF.CheckForSignal(node, min_x, max_x)
    -- Check if the current node contains a signal (or any other conditions you need)
    if node and node.signals then
        for _, signal in pairs(node.signals) do
            if signal.type == "light" and signal.TrackX >= min_x and
            signal.TrackX <= max_x then
                -- Found a light signal within the specified range
                return true, signal
            end
        end
    end
    return false, nil -- No signal found in this segment
end

--------------------------------------------------------------------------------
-- Scans an isolated track segment and for every useable segment calls func
--------------------------------------------------------------------------------
local check_table = {}
function UF.ScanTrack(itype, node, func, x, dir, checked)
    local light, switch = itype == "light", itype == "switch"
    -- Check if this node was already scanned
    if not node then return end
    if not checked then
        for k, v in pairs(check_table) do check_table[k] = nil end
        checked = check_table
    end
    if checked[node] then return end
    checked[node] = true
    -- Try to use entire node length by default
    local min_x = node.x
    local max_x = min_x + node.length
    
    -- Get range of node which can be actually sensed
    local isolateForward = false -- Should scanning continue forward along track
    local isolateBackward = false -- Should scanning continue backward along track
    if Metrostroi.SignalEntitiesForNode[node] then
        for k, v in pairs(Metrostroi.SignalEntitiesForNode[node]) do
            local isolating = false
            if IsValid(v) then
                if light then
                    isolating = ((v.TrackDir == dir) or
                    (not v.PassOcc or v.TrackX == x))
                end
                if switch then isolating = v.IsolateSwitches end
                -- if itype == "ars" then isolating = true end
            end
            if isolating then
                -- If scanning forward, and there's a joint IN FRONT of current X
                if dir and (v.TrackX > x) then
                    max_x = math.min(max_x, v.TrackX)
                    isolateForward = true
                end
                -- If scanning forward, and there's a joint in current X
                -- This is triggered when traffic light searches for next light from its own X (then
                --  scan direction is defined by dir)
                if dir and (v.TrackX == x) then
                    min_x = math.max(min_x, v.TrackX)
                    isolateBackward = true
                end
                -- if scanning backward, and there's a joint BEHIND current X
                if (not dir) and (v.TrackX < x) then
                    min_x = math.max(min_x, v.TrackX)
                    isolateBackward = true
                end
                -- If scanning backward starting from current X, use dir for guiding scan
                if (not dir) and (v.TrackX == x) then
                    max_x = math.min(max_x, v.TrackX)
                    isolateForward = true
                end
            end
        end
    end
    
    -- Show the scanned path
    if GetConVar("metrostroi_drawdebug"):GetInt() == 1 then
        local T = CurTime()
        timer.Simple(0.05 + math.random()*0.05,function()
            if node.next then
                debugoverlay.Line(node.pos,node.next.pos,3,Color((T*1234)%255,(T*12345)%255,(T*12346)%255),true)
            end
        end)
    end
    
    -- Call function for the determined portion of the node
    local results = {func(node, min_x, max_x)}
    if results[1] ~= nil then return unpack(results) end
    -- First check all the branches, whose positions fall within min_x..max_x
    if node.branches and not ars then
        for k, v in pairs(node.branches) do
            if (v[1] >= min_x) and (v[1] <= max_x) then
                -- FIXME: somehow define direction and X!
                local results = {
                    UF.ScanTrack(itype, v[2], func, v[1], true, checked)
                }
                if results[1] ~= nil then return unpack(results) end
            end
        end
    end
    -- If not isolated, continue scanning forward from the front end of node
    if (dir or switch) and (not isolateForward) then
        local results = {
            UF.ScanTrack(itype, node.next, func, max_x, true, checked)
        }
        if results[1] ~= nil then return unpack(results) end
    end
    -- If not isolated, continue scanning backward from the rear end of node
    if (not dir or switch) and (not isolateBackward) then
        local results = {
            UF.ScanTrack(itype, node.prev, func, min_x, false, checked)
        }
        if results[1] ~= nil then return unpack(results) end
    end
end

function UF.Save(name)
    if not file.Exists("project_light_rail_data", "DATA") then
        file.CreateDir("project_light_rail_data")
    end
    name = name or game.GetMap()
    
    -- Format signs, signal, switch data
    local signs = {}
    local signals_ents = ents.FindByClass("gmod_track_uf_signal*")
    if not signals_ents then print("MPLR: Signalling file is corrupted!") end
    for k, v in pairs(signals_ents) do
        if not UF.PZBSections[v] then
            local Routes = table.Copy(v.Routes)
            table.insert(signs, {
                Class = "gmod_track_uf_signal",
                Pos = v:GetPos(),
                Angles = v:GetAngles(),
                SignalType = v.SignalType,
                Name1 = v.Name1,
                Name2 = v.Name2,
                Name = v.Name,
                ActiveRoute = 1,
                Routes = v.Routes
            })
        end
    end
    local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k, v in ipairs(switch_ents) do
        table.insert(signs, {
            Class = "gmod_track_uf_switch",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            Name = v.Name,
            NotChangePos = v.NotChangePos,
            LockedSignal = v.LockedSignal
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
    -- Save data
    print("MPLR: Saving signs and track definition...")
    local data = util.TableToJSON(signs, true)
    file.Write(string.format("project_light_rail_data/signs_%s.txt", name), data)
    print(Format("Saved to project_light_rail_data/signs_%s.txt", name))
    
end

function UF.Load(name, keep_signs)
    if not Metrostroi then
        print("Quitting because Metrostroi not loaded")
        return
    end
    name = name or game.GetMap()
    
    -- loadTracks(name)
    
    -- Initialize stations list
    UF.UpdateStations()
    -- Print info
    -- UF.PrintStatistics()
    
    -- Ignore updates to prevent created/removed switches from constantly updating table of positions
    Metrostroi.IgnoreEntityUpdates = true
    UF.LoadSignalling(name, keep_signs)
    
    timer.Simple(0.05, function()
        -- No more ignoring updates
        Metrostroi.IgnoreEntityUpdates = false
        -- Load ARS entities
        UF.UpdateSignalEntities()
        -- Load switches
        UF.UpdateSwitchEntities()
        UF.ConstructDefaultSignalBlocks()
        Server = ents.Create("gmod_mplr_signalserver")
        Server.Model = UF.ServerModel or nil
        Server.SoundLoop = UF.ServerSound or nil
        Server:SetPos(UF.ServerPos or Vector(0, 0, 0))
        Server:Spawn()
        print("MPLR: Spawned central signalling server")
    end)
end

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

local function getFile(path, name, id)
    local data, found
    if file.Exists(Format(path .. ".txt", name), "DATA") then
        print(Format("MPLR: Loading %s definition from txt file...", id))
        data = util.JSONToTable(file.Read(Format(path .. ".txt", name), "DATA"))
        found = true
    end
    if not data and file.Exists(Format(path .. ".lua", name), "LUA") then
        print(Format("MPLR: Loading %s definition from lua file...", id))
        data = util.JSONToTable(file.Read(Format(path .. ".lua", name), "LUA"))
        found = true
    end
    if not found then
        print(Format("%s definition file not found: %s", id, Format(path, name)))
        return
    elseif not data then
        print(Format("MPLR: Parse error in %s %s definition JSON", id,
        Format(path, name)))
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
            if result then return result end
        end
    end
end



function UF.ConstructDefaultSignalBlocks() -- those signals that do not need dynamic routing, just make static signal blocks ¯\_(ツ)_/¯ actually no let's just construct the default state
    print("MPLR: Loading default Signal blocks")
    UF.SignalBlocks = {}
    for k, v in pairs(Metrostroi.SignalEntitiesByName) do
        print("Constructing default signal blocks: " .. k, v.Routes[1].NextSignal)
        table.insert(UF.SignalBlocks,{[k] = v.Routes[1].NextSignal, Occupied = false})
        UF.ActiveRoutes[k] = 1
        print(k, UF.ActiveRoutes[k])
    end
end

function UF.OpenRoute(signal, route, ent)
    if not next(UF.SignalBlocks) then return end
    --print("Route Change requested on signal:", signal, "to route", route,"by entity:", ent)
    if UF.ActiveRoutes[signal] == route then
        print("Requested route already active, bailing out")
        return
    end
    
    local CurrentSignalEnt = Metrostroi.SignalEntitiesByName[signal] -- target the signal's entity for operations
    local RoutesTable = CurrentSignalEnt.Routes -- a little shortcut to the routes table, for readability
    local CurrentBlock
    local function checkSignal(v)
            for key,_ in pairs(v) do
                print(key,signal)
                return (key == signal)
            end
            return false
    end
    for _, v in ipairs(UF.SignalBlocks) do

        CurrentBlock = v        
        if checkSignal(v) then
            v[signal] = RoutesTable[route].NextSignal --look up what the next signal of the route is and set it
            UF.ActiveRoutes[signal] = route -- we're changing the currently active route on this signal, write that down, squire!
            print(Format("Opened Route %s on Signal %s to Signal %s",route,signal,RoutesTable[route].NextSignal))
        end
    end
end

function UF.UpdateSignalBlockOccupation()
    for k, v in pairs(UF.SignalBlocks) do
        local CurrentBlock = UF.SignalBlocks[k]
        local function GetSignals()
            for ky, val in pairs(CurrentBlock) do
                if type(ky) == "string" then return ky, val end
            end
        end
        
        -- print(CurrentBlock)
        local CurrentSignal, DistantSignal = GetSignals()
        local CurrentSignalEnt, DistantSignalEnt =
        Metrostroi.SignalEntitiesByName[CurrentSignal],
        Metrostroi.SignalEntitiesByName[DistantSignal]
        if not DistantSignalEnt then continue end
        local CurrentPos = CurrentSignalEnt.TrackPosition
        local DistantPos = DistantSignalEnt.TrackPosition
        if not next(Metrostroi.TrainPositions) then
            CurrentBlock.Occupied = false
            return
        end
        for ky, val in pairs(Metrostroi.TrainPositions) do
            local TrainPos = Metrostroi.TrainPositions[ky]
            for k2, v2 in pairs(TrainPos) do
                if v2.path == CurrentSignalEnt.Node.path then
                    local x1, x2 = v2.x, v2.x
                    if ((x1 >= CurrentPos.x) and (x1 <= DistantPos.x)) or
                    ((x2 >= CurrentPos.x) and (x2 <= DistantPos.x)) or
                    ((x1 <= CurrentPos.x) and (x2 >= DistantPos.x)) then
                        if CurrentBlock.Occupied == false then
                            print(CurrentSignal, "Changing to occupied",
                            CurrentPos.x, DistantPos.x)
                        end
                        CurrentBlock.Occupied = true
                    else
                        CurrentBlock.Occupied = false
                    end
                end
            end
        end
    end
end

function UF.LoadSignalling(name, keep)
    if keep then return end
    local signs = getFile("project_light_rail_data/signs_%s", name, "Signal")
    
    if not signs then return end
    
    local signals_ents = ents.FindByClass("gmod_track_uf_signal")
    for k, v in pairs(signals_ents) do SafeRemoveEntity(v) end
    local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k, v in pairs(switch_ents) do SafeRemoveEntity(v) end
    local signs_ents = ents.FindByClass("gmod_track_uf_signs")
    for k, v in pairs(signs_ents) do SafeRemoveEntity(v) end
    
    -- Create new entities (add a delay so the old entities clean up)
    print("MPLR: Loading signs, signals, switches...")
    for k, v in pairs(signs) do
        local ent = ents.Create(v.Class)
        if IsValid(ent) then
            ent:SetPos(v.Pos)
            ent:SetAngles(v.Angles)
            if v.Class == "gmod_track_uf_switch" then
                ---CHANGE
                ent.LockedSignal = v.LockedSignal
                ent.NotChangePos = v.NotChangePos
                ent.Inverted = v.Inverted
                ent.ID = v.ID, ent:Spawn()
            end
            if v.Class == "gmod_track_uf_signal" then
                ent.SignalType = v.SignalType
                ent.Name1 = v.Name1
                ent.Name2 = v.Name2
                ent.Name = v.Name
                ent.ActiveRoute = v.ActiveRoute
                ent.Routes = v.Routes, ent:Spawn()
                ent:SendUpdate()
            elseif v.Class == "gmod_track_uf_signs" then
                ent.SignType = v.SignType
                ent.YOffset = v.YOffset
                ent.ZOffset = v.ZOffset
                ent.Left = v.Left, ent:Spawn()
                ent:SendUpdate()
            end
        end
    end
    
end

function UF.IsTrackOccupied(src_node, x, dir, t, maximum_x)
    local Trains = {}
    UF.ScanTrack(t or "light", src_node, function(node, min_x, max_x)
        -- If there are no trains in node, keep scanning
        if (not Metrostroi.TrainsForNode[node]) or
        (#Metrostroi.TrainsForNode[node] == 0) then return end
        
        -- For every train in node, for every path it rests on, check if it's in range
        -- print("SCAN TRACK",node.id,min_x,max_x)
        for k, v in pairs(Metrostroi.TrainsForNode[node]) do
            local pos = Metrostroi.TrainPositions[v]
            for k2, v2 in pairs(pos) do
                if v2.path == node.path then
                    -- local pos1 = Metrostroi.GetPositionOnTrack(v:LocalToWorld(Vector(0,1,0)), v:GetAngles())
                    -- if pos1 then pos1 = pos1[1] end
                    -- if pos1 and (((pos1.x - v2.x) < 0 and not dir)  or ((pos1.x - v2.x) > 0 and dir)) then continue end
                    -- local TrackX = v2.TrackX
                    -- local x1 = v2.x-1100*0.5
                    -- local x2 = v2.x+1100*0.5
                    -- print(x1,x2)
                    local x1, x2 = v2.x, v2.x
                    if ((x1 >= min_x) and (x1 <= max_x)) or
                    ((x2 >= min_x) and (x2 <= max_x)) or
                    ((x1 <= min_x) and (x2 >= max_x)) then
                        table.insert(Trains, v) -- return true,v
                    end
                end
            end
        end
    end, x, dir, nil, maximum_x)
    
    return #Trains > 0, Trains[#Trains], Trains[1]
end

--------------------------------------------------------------------------------
-- Scans an isolated track segment and for every useable segment calls func
--------------------------------------------------------------------------------
local check_table = {}
function UF.ScanTrack(itype, node, func, x, dir, checked, maximum_x)
    local light, switch = itype == "light", itype == "switch"
    -- Check if this node was already scanned
    if not node then return end
    if not checked then
        for k, v in pairs(check_table) do check_table[k] = nil end
        checked = check_table
    end
    if checked[node] then return end
    checked[node] = true
    -- Try to use entire node length by default, but also allow for manual scan length
    local min_x = node.x
    
    local max_x = maximum_x or min_x + node.length
    
    -- Get range of node which can be actually sensed
    local isolateForward = false -- Should scanning continue forward along track
    local isolateBackward = false -- Should scanning continue backward along track
    if Metrostroi.SignalEntitiesForNode[node] then
        for k, v in pairs(Metrostroi.SignalEntitiesForNode[node]) do
            local isolating = false
            if IsValid(v) then
                if light then
                    isolating = ((v.TrackDir == dir) or (v.TrackX == x))
                end
                if switch then isolating = v.IsolateSwitches end
                -- if itype == "ars" then isolating = true end
            end
            if isolating then
                -- If scanning forward, and there's a joint IN FRONT of current X
                if dir and (v.TrackX > x) then
                    max_x = math.min(max_x, v.TrackX)
                    isolateForward = true
                end
                -- If scanning forward, and there's a joint in current X
                -- This is triggered when traffic light searches for next light from its own X (then
                --  scan direction is defined by dir)
                if dir and (v.TrackX == x) then
                    min_x = math.max(min_x, v.TrackX)
                    isolateBackward = true
                end
                -- if scanning backward, and there's a joint BEHIND current X
                if (not dir) and (v.TrackX < x) then
                    min_x = math.max(min_x, v.TrackX)
                    isolateBackward = true
                end
                -- If scanning backward starting from current X, use dir for guiding scan
                if (not dir) and (v.TrackX == x) then
                    max_x = math.min(max_x, v.TrackX)
                    isolateForward = true
                end
            end
        end
    end
    
    -- Show the scanned path
    --[[if GetConVar("metrostroi_drawdebug"):GetInt() == 1 then
    local T = CurTime()
    timer.Simple(0.05 + math.random()*0.05,function()
        if node.next then
            debugoverlay.Line(node.pos,node.next.pos,3,Color((T*1234)%255,(T*12345)%255,(T*12346)%255),true)
        end
    end)
end]]

-- Call function for the determined portion of the node
local results = {func(node, min_x, max_x)}
if results[1] ~= nil then return unpack(results) end
-- First check all the branches, whose positions fall within min_x..max_x
if node.branches and not ars then
    for k, v in pairs(node.branches) do
        if (v[1] >= min_x) and (v[1] <= max_x) then
            -- FIXME: somehow define direction and X!
            local results = {
                UF.ScanTrack(itype, v[2], func, v[1], true, checked)
            }
            if results[1] ~= nil then return unpack(results) end
        end
    end
end
-- If not isolated, continue scanning forward from the front end of node
if (dir or switch) and (not isolateForward) then
    local results = {
        UF.ScanTrack(itype, node.next, func, max_x, true, checked)
    }
    if results[1] ~= nil then return unpack(results) end
end
-- If not isolated, continue scanning backward from the rear end of node
if (not dir or switch) and (not isolateBackward) then
    local results = {
        UF.ScanTrack(itype, node.prev, func, min_x, false, checked)
    }
    if results[1] ~= nil then return unpack(results) end
end
end

function UF.PrintStatistics() end

function UF.UpdateSwitchEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    Metrostroi.SwitchesForNode = {}
    Metrostroi.SwitchesByName = {}
    
    local entities = ents.FindByClass("gmod_track_uf_switch")
    for k, v in pairs(entities) do
        local pos = Metrostroi.GetPositionOnTrack(v:GetPos(), v:GetAngles() -
        Angle(0, 90, 0))[1]
        if pos then
            if not v.Name or v.Name == "" then
                -- pos.path.id.."/"..pos.node1.id
                if not Metrostroi.SwitchesByName[pos.path.id] then
                    Metrostroi.SwitchesByName[pos.path.id] = {}
                end
                Metrostroi.SwitchesByName[pos.path.id][pos.node1.id] = v
            end
            Metrostroi.SwitchesForNode[pos.node1] =
            Metrostroi.SwitchesForNode[pos.node1] or {}
            table.insert(Metrostroi.SwitchesForNode[pos.node1], v)
            v.TrackPosition = pos -- FIXME: check that one switch belongs to one track
        end
        if v.Name and v.Name ~= "" then
            Metrostroi.SwitchesByName[v.Name] = v
        end
        
    end
end

--------------------------------------------------------------------------------
-- Get travel time between two nodes in seconds
--------------------------------------------------------------------------------
function UF.GetTravelTime(src, dest)
    -- Determine direction of travel
    -- assert(src.path == dest.path)
    local direction = src.x < dest.x
    
    -- Accumulate travel time
    local travel_time = 0
    local travel_dist = 0
    local travel_speed = 60
    local iter = 0
    function scan(node, path)
        local oldx
        local oldars
        while (node) and (node ~= dest) do
            local ars_speed
            -- local ars_joint = Metrostroi.GetARSJoint(node,node.x+0.01,path or true)
            --[[if ars_joint then
            --[[if oldx and oldx ~= ars_joint.TrackPosition.x then
            print(Format("\t\t\t%.2f:\t%s->%s",(ars_joint.TrackPosition.x - oldx)/18.8,oldars.Name,ars_joint.Name))
        end
        oldx = ars_joint.TrackPosition.x
        oldars = ars_joint
        --print(ars_joint.Name)
        local ARSLimit = ars_joint:GetMaxARS()
        --print(ARSLimit)
        if ARSLimit >= 4  then
            ars_speed = ARSLimit*10
        end
        --print(ars_speed)
    end]]
    -- if ars_speed then travel_speed = ars_speed end
    -- print(Format("[%03d] %.2f m   V = %02d km/h",node.id,node.length,ars_speed or 0))
    
    -- Assume 70% of travel speed
    local speed = travel_speed * 0.7
    
    -- Add to travel time
    travel_dist = travel_dist + node.length
    travel_time = travel_time + (node.length / (speed / 3.6))
    node = node.next
    if not node then break end
    if src.path == dest.path and node.branches and
    node.branches[1][2].path == src.path then
        scan(node, src.x > node.branches[1][2].x)
    end
    if src.path == dest.path and node.branches and node.branches[2] and
    node.branches[2][2].path == src.path then
        scan(node, src.x > node.branches[1][1].x)
    end
    assert(iter < 10000, "OH SHI~")
    iter = iter + 1
end
end
scan(src)

return travel_time, travel_dist
end
