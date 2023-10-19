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
                print(Format("Metrostroi: Error, station %03d has two platforms %d with same index!",platform.StationIndex,platform.PlatformIndex))
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
        print("Metrostroi: Stopping all updates!")
        Metrostroi.IgnoreEntityUpdates = true
        timer.Simple(0.2, function()
            print("Metrostroi: Retrieve updates.")
            Metrostroi.IgnoreEntityUpdates = false
            Metrostroi.UpdateSignalEntities()
            Metrostroi.UpdateSwitchEntities()
            Metrostroi.UpdateARSSections()
        end)
        return
    end
    Metrostroi.OldUpdateTime = CurTime()
    local options = { z_pad = 256 }

    Metrostroi.UpdateSignalNames()

    Metrostroi.SignalEntitiesForNode = {}
    Metrostroi.SignalEntityPositions = {}



    local count = 0
    local repeater = 0
    local entities = ents.FindByClass("gmod_track_uf_signal*")
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
            if not v.ARSOnly then
                --v.AutostopPos = Metrostroi.GetTrackPosition(pos.path,v.TrackX - (v.TrackDir and 2.5 or -2.5))
                --if not v.AutostopPos then print(Format("Metrostroi: Signal %s, can't place autostop!",v.Name)) end
            end
        else
            if not v.Routes or v.Routes[1].NextSignal ~= "" then
                print(Format("MPLR: Signal %s, position not found, system can't detect the track occupation!",v.Name))
            end
        end
        if not v.Routes[1] then ErrorNoHalt(Format("MPRL: Signal %s don't have first route!",v.Name)) end
        if v.Routes and v.Routes[1].Repeater then
            repeater = repeater + 1
        end
        count = count + 1
        v:PreInitalize()
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
            for k,v in pairs(Routes) do
                v.LightsExploded = nil
                v.IsOpened = nil
            end
            table.insert(signs,{
                Class = "gmod_track_uf_signal",
                Pos = v:GetPos(),
                Angles = v:GetAngles(),
                SignalType = v.SignalType,
                Name = v.Name,
                RouteNumberSetup = v.RouteNumberSetup,
                LensesStr = v.LensesStr,
                RouteNumber =   v.RouteNumber,
                IsolateSwitches = v.IsolateSwitches,
                ARSOnly = v.ARSOnly,
                Routes = Routes,
                Approve0 = v.Approve0,
                TwoToSix = v.TwoToSix,
                NonAutoStop = v.NonAutoStop,
                Left = v.Left,
                Double = v.Double,
                DoubleL = v.DoubleL,
                AutoStop = v.AutoStop,
                PassOcc = v.PassOcc,
            })
        end
    end
    local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k,v in pairs(switch_ents) do
        table.insert(signs,{
            Class = "gmod_track_switch",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            Name = v.Name,
            Channel = v:GetChannel(),
            NotChangePos = v.NotChangePos,
            LockedSignal = v.LockedSignal,
            Invertred = v.Invertred,
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