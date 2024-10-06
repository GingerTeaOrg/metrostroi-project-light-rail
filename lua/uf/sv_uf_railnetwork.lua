if Metrostroi.Paths then
    UF.SwitchEntitiesByID = {}
    UF.ActiveRoutes = {}
    UF.SignalBlocks = {}
    UF.StationEntsByIndex = {}
end

function UF.CheckOccupation()
    local DistantPos = self.DistantSignalEnt.TrackPosition.x
    local MyPos = self.TrackPosition
    for train, _ in pairs( Metrostroi.TrainPositions ) do
        local TrainPos = Metrostroi.TrainPositions[ train ][ 1 ].x
        if MyPos.forward then
            if MyPos.x < TrainPos and DistantPos > TrainPos then return true end
        elseif not MyPos.forward then
            if MyPos.x > TrainPos and DistantPos < TrainPos then return true end
        end
    end
    return false
end

hook.Add( "Initialize", "UF_MapInitialize", function()
    if not Metrostroi then
        assert( Metrostroi, "ERROR METROSTROI IS NOT INSTALLED / LOADED" )
        return
    end

    timer.Simple( 6, UF.Load )
end )

function UF.UpdateStations()
    if not Metrostroi.Stations then return end
    if not UF.StationEntsByIndex then return end
    local platforms = ents.FindByClass( "gmod_track_uf_platform" )
    for _, platform in pairs( platforms ) do
        local station = Metrostroi.Stations[ platform.StationIndex ] or {}
        Metrostroi.Stations[ platform.StationIndex ] = station
        -- Ensure the sub-table for the specific station index is initialized
        UF.StationEntsByIndex = UF.StationEntsByIndex or {}
        UF.StationEntsByIndex[ platform.StationIndex ] = UF.StationEntsByIndex[ platform.StationIndex ] or {}
        -- Assign the platform object to the correct platform index within the station index
        UF.StationEntsByIndex[ platform.StationIndex ][ platform.PlatformIndex ] = platform
        -- Position
        local dir = platform.PlatformEnd - platform.PlatformStart
        local pos1 = Metrostroi.GetPositionOnTrack( platform.PlatformStart, dir:Angle() )[ 1 ]
        local pos2 = Metrostroi.GetPositionOnTrack( platform.PlatformEnd, dir:Angle() )[ 1 ]
        if pos1 and pos2 then
            -- Add platform to station
            local platform_data = {
                x_start = pos1.x,
                x_end = pos2.x,
                length = math.abs( pos2.x - pos1.x ),
                node_start = pos1.node1,
                node_end = pos2.node1,
                forward = pos1.x > pos2.x,
                ent = platform
            }

            if station[ platform.PlatformIndex ] then
                print( Format( "MPLR: Error, station %03d has two platforms %d with same index!", platform.StationIndex, platform.PlatformIndex ) )
            else
                station[ platform.PlatformIndex ] = platform_data
            end

            -- Print information
            print( Format( "\t[%03d][%d] %.3f-%.3f km (%.1f m) on path %d", platform.StationIndex, platform.PlatformIndex, pos1.x * 1e-3, pos2.x * 1e-3, platform_data.length, platform_data.node_start.path.id ) )
        else
            print( Format( "MPLR: Error, station %03d platform %d, cant find pos! \n\tStart%s \n\tEnd:%s", platform.StationIndex, platform.PlatformIndex, platform.PlatformStart, platform.PlatformEnd ) )
        end
    end
end

function UF.UpdateSignalEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    if CurTime() - Metrostroi.OldUpdateTime < 0.05 then
        print( "MPLR: Stopping all updates!" )
        Metrostroi.IgnoreEntityUpdates = true
        timer.Simple( 0.2, function()
            print( "MPLR: Retrieve updates." )
            Metrostroi.IgnoreEntityUpdates = false
            Metrostroi.UpdateSignalEntities()
            UF.UpdateSwitchEntities()
            --Metrostroi.UpdateARSSections()
        end )
        return
    end

    Metrostroi.OldUpdateTime = CurTime()
    local options = {
        z_pad = 256
    }

    UF.UpdateSignalNames()
    Metrostroi.SignalEntitiesForNode = {}
    Metrostroi.SignalEntityPositions = {}
    local count = 0
    local repeater = 0
    local entities = ents.FindByClass( "gmod_track_uf_signal*" )
    print( "MPLR: PreInitialize signals" )
    for k, v in pairs( entities ) do
        local pos = Metrostroi.GetPositionOnTrack( v:GetPos(), v:GetAngles() - Angle( 0, 90, 0 ), options )[ 1 ]
        local pos2 = Metrostroi.GetPositionOnTrack( v:LocalToWorld( Vector( 0, 10, 0 ) ), v:GetAngles() - Angle( 0, 90, 0 ), options )
        if pos then -- FIXME make it select proper path
            Metrostroi.SignalEntitiesForNode[ pos.node1 ] = Metrostroi.SignalEntitiesForNode[ pos.node1 ] or {}
            table.insert( Metrostroi.SignalEntitiesForNode[ pos.node1 ], v )
            -- A signal belongs only to a single track
            Metrostroi.SignalEntityPositions[ v ] = pos
            v.TrackPosition = pos
            v.TrackX = pos.x
            v.DistantSignalEnt = Metrostroi.GetSignalByName( v.DistantSignal )
            if pos2 and pos2[ 1 ] then
                v.TrackDir = ( pos2[ 1 ].x - v.TrackX ) < 0
            else
                print( Format( "MPLR: Signal %s, second position not found, system can't detect direction of the signal!", v.Name ) )
                v.TrackDir = true
            end
        else
            if v.NextSignal ~= "" then print( Format( "MPLR: Signal %s, position not found, system can't detect the track occupation!", v.Name ) ) end
        end

        -- if not v.Routes[1] then ErrorNoHalt(Format("MPLR: Signal %s don't have first route!",v.Name)) end
        count = count + 1
    end

    print( Format( "MPLR: Total signals: %u (normal: %u, repeaters: %u)", count, count - repeater, repeater ) )
    local entities = ents.FindByClass( "gmod_track_uf_switch" )
    for k, v in pairs( entities ) do
        if v.ID then UF.SwitchEntitiesByID[ v.ID ] = v end
    end
end

function UF.UpdateSignalNames()
    print( "MPLR: Updating signal names..." )
    if not Metrostroi.SignalEntitiesByName then Metrostroi.SignalEntitiesByName = {} end
    local entities = ents.FindByClass( "gmod_track_uf_signal*" )
    for k, v in pairs( entities ) do
        if not IsValid( v ) then continue end
        print( v, v.Name )
        if v.Name then
            if Metrostroi.SignalEntitiesByName[ v.Name ] then --
                print( Format( "MPLR: Signal with this name %s already exists! Check signal names!\nInfo:\n\tFirst signal:  %s\n\tPos:    %s\n\tSecond signal: %s\n\tPos:    %s", v.Name, Metrostroi.SignalEntitiesByName[ v.Name ], Metrostroi.SignalEntitiesByName[ v.Name ]:GetPos(), v, v:GetPos() ) )
            else
                Metrostroi.SignalEntitiesByName[ v.Name ] = v
            end
        end
    end
end

function UF.CheckForSignal( node, min_x, max_x )
    -- Check if the current node contains a signal
    if node and node.signals then
        for _, signal in pairs( node.signals ) do
            if signal.type == "light" and signal.TrackX >= min_x and signal.TrackX <= max_x then
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
-- UF.ScanTrack recursively scans the track starting from a given node, calling a specified function for each node it encounters.
-- Parameters:
--   itype: The type of scan (e.g., "light", "switch"). Controls scan behavior.
--   node: The node to start scanning from.
--   func: The callback function to be called for each node, which receives the node and its min/max X range.
--   x: The current X position (starting point) for scanning.
--   dir: Direction of scanning (true = forward, false = backward).
--   checked: A table of nodes that have already been scanned (to avoid infinite loops).
-- Returns:
--   Results from the callback function, if any are returned.
local check_table = {} -- Table to track which nodes have already been checked.
function UF.ScanTrack( itype, node, func, x, dir, checked )
    local light, switch = itype == "light", itype == "switch" -- Determine if we're scanning for "light" or "switch".
    -- If no node is provided, stop the scan.
    if not node then return end
    -- If no 'checked' table is passed, initialize it to track scanned nodes.
    if not checked then
        for k, _ in pairs( check_table ) do
            check_table[ k ] = nil -- Reset the check_table for fresh scans.
        end

        checked = check_table
    end

    -- If this node has already been scanned, skip it.
    if checked[ node ] then return end
    checked[ node ] = true -- Mark this node as scanned.
    -- Set initial X bounds (full node length by default).
    local min_x = node.x
    local max_x = min_x + node.length
    -- Variables to control isolation (i.e., stopping the scan at certain signals/switches).
    local isolateForward = false
    local isolateBackward = false
    -- Check for signals or switches on this node to determine isolation behavior.
    if Metrostroi.SignalEntitiesForNode[ node ] then
        for _, signal in pairs( Metrostroi.SignalEntitiesForNode[ node ] ) do
            local isolating = false
            if IsValid( signal ) then
                -- Light scans: check if the signal is aligned with the scan direction or has a pass/occupation constraint.
                if light then isolating = ( signal.TrackDir == dir ) or ( not signal.PassOcc or signal.TrackX == x ) end
                -- Switch scans: check if the signal isolates switches.
                if switch then isolating = signal.IsolateSwitches end
            end

            -- If the signal isolates this section of the track, adjust the X bounds accordingly.
            if isolating then
                -- Forward direction: limit max_x if the signal is in front.
                if dir and ( signal.TrackX > x ) then
                    max_x = math.min( max_x, signal.TrackX )
                    isolateForward = true
                end

                -- Forward direction: limit min_x if the signal is at the current X.
                if dir and ( signal.TrackX == x ) then
                    min_x = math.max( min_x, signal.TrackX )
                    isolateBackward = true
                end

                -- Backward direction: limit min_x if the signal is behind.
                if not dir and ( signal.TrackX < x ) then
                    min_x = math.max( min_x, signal.TrackX )
                    isolateBackward = true
                end

                -- Backward direction: limit max_x if the signal is at the current X.
                if not dir and ( signal.TrackX == x ) then
                    max_x = math.min( max_x, signal.TrackX )
                    isolateForward = true
                end
            end
        end
    end

    -- Debugging: draw a visual representation of the scanned path (optional).
    if GetConVar( "mplr_drawdebug" ):GetInt() == 1 then
        local T = CurTime()
        timer.Simple( 0.05 + math.random() * 0.05, function() if node.next then debugoverlay.Line( node.pos, node.next.pos, 3, Color( ( T * 1234 ) % 255, ( T * 12345 ) % 255, ( T * 12346 ) % 255 ), true ) end end )
    end

    -- Call the function for the current node with its min/max X bounds.
    local results = { func( node, min_x, max_x ) }
    if results[ 1 ] ~= nil then -- If the function returns anything, stop further scanning.
        return unpack( results )
    end

    -- Handle node branches: if any branches fall within the X range, scan them as well.
    if node.branches then
        for _, branch in pairs( node.branches ) do
            if ( branch[ 1 ] >= min_x ) and ( branch[ 1 ] <= max_x ) then
                local branch_results = { UF.ScanTrack( itype, branch[ 2 ], func, branch[ 1 ], true, checked ) }
                if branch_results[ 1 ] ~= nil then return unpack( branch_results ) end
            end
        end
    end

    -- Continue scanning forward if not isolated, scanning from the front end of the node.
    if ( dir or switch ) and not isolateForward then
        local forward_results = { UF.ScanTrack( itype, node.next, func, max_x, true, checked ) }
        if forward_results[ 1 ] ~= nil then return unpack( forward_results ) end
    end

    -- Continue scanning backward if not isolated, scanning from the rear end of the node.
    if ( not dir or switch ) and not isolateBackward then
        local backward_results = { UF.ScanTrack( itype, node.prev, func, min_x, false, checked ) }
        if backward_results[ 1 ] ~= nil then return unpack( backward_results ) end
    end
end

local finalEntList = {}
local EntTrackPos = {}
local entList = ents.GetAll()
function UF.ScanTrackForEntity( entityClass, currentNode, position, direction, checkedNodes, searchForVal, key, val, partialMatch )
    if not currentNode then return end
    if not next( entList ) then entList = ents.GetAll() end
    --get applicable entities, either with containing a variable and value, or not
    for _, ent in ipairs( entList ) do
        if ent:GetClass() == entityClass and searchForVal and ent[ key ] == val then
            for k, v in ipairs( finalEntList ) do
                if not finalEntList[ ent ] then
                    table.insert( finalEntList, ent )
                    continue
                end
            end
        elseif ent:GetClass() == entityClass and searchForVal and partialMatch and string.match( ent[ key ], "^" .. val ) == val then
            for k, v in ipairs( finalEntList ) do
                if not finalEntList[ ent ] then
                    table.insert( finalEntList, ent )
                    continue
                end
            end
        elseif ent:GetClass() == entityClass then
            for k, v in ipairs( finalEntList ) do
                if not finalEntList[ ent ] then
                    table.insert( finalEntList, ent )
                    continue
                end
            end
        end
    end

    --give applicable entities track coordinates
    for k, v in ipairs( finalEntList ) do
        if not EntTrackPos[ v ] then EntTrackPos[ v ] = Metrostroi.GetPositionOnTrack( v:GetPos(), v:GetAngles() )[ 1 ] end
    end

    -- If the current node is nil or has already been checked, return
    if checkedNodes then if checkedNodes[ currentNode ] then return end end
    -- Mark the current node as checked
    if currentNode then checkedNodes[ currentNode ] = true end
    -- Determine the scanning direction (forward or backward)
    local forwardScan = direction
    -- Initialize the scanning range
    local minPosition = currentNode.x
    local maxPosition = minPosition + currentNode.length
    local results = {}
    if forwardScan then --we're scanning forwards along the node
        for k, v in pairs( EntTrackPos ) do --iterate over all entities that we have put into the filtered table
            if v.x >= currentNode.x then
                table.insert( results, k ) --add the entity to our output table
            else
                EntTrackPos[ k ] = nil --entity doesn't match, so clear it out of the table
            end
        end
    else
        for k, v in pairs( EntTrackPos ) do --same as before but backwards
            if v.x <= currentNode.x then
                table.insert( results, k )
            else
                EntTrackPos[ k ] = nil
            end
        end
    end

    if results[ 1 ] ~= nil then return unpack( results ) end
    -- Recursively scan the branches of the current node
    if currentNode.branches then
        for _, branch in pairs( currentNode.branches ) do
            local branchPosition, branchNode = branch[ 1 ], branch[ 2 ]
            if forwardScan and branchPosition >= minPosition and branchPosition <= maxPosition then
                local branchResults = { UF.ScanTrackForEntity( entityClass, branchNode, branchPosition, true, checkedNodes ) }
                if branchResults[ 1 ] ~= nil then return unpack( branchResults ) end
            end
        end
    end

    -- Continue scanning forward or backward based on the direction
    if forwardScan then
        return UF.ScanTrackForEntity( entityClass, currentNode.next, maxPosition, true, checkedNodes )
    else
        return UF.ScanTrackForEntity( entityClass, currentNode.prev, minPosition, false, checkedNodes )
    end
end

function UF.Save( name )
    if not file.Exists( "project_light_rail_data", "DATA" ) then file.CreateDir( "project_light_rail_data" ) end
    name = name or game.GetMap()
    -- Format signs, signal, switch data
    local signs = {}
    local signals_ents = ents.FindByClass( "gmod_track_uf_signal*" )
    if not signals_ents then print( "MPLR: Signalling file is corrupted!" ) end
    for k, v in pairs( signals_ents ) do
        if not UF.PZBSections[ v ] then
            local Routes = table.Copy( v.Routes )
            table.insert( signs, {
                Class = "gmod_track_uf_signal",
                Pos = v:GetPos(),
                Angles = v:GetAngles(),
                SignalType = v.SignalType,
                Name1 = v.Name1,
                Name2 = v.Name2,
                Name = v.Name,
                ActiveRoute = 1,
                Routes = v.Routes
            } )
        end
    end

    local switch_ents = ents.FindByClass( "gmod_track_uf_switch" )
    for k, v in ipairs( switch_ents ) do
        table.insert( signs, {
            Class = "gmod_track_uf_switch",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            ID = v.ID,
        } )
    end

    local signs_ents = ents.FindByClass( "gmod_track_mplr_sign" )
    for _, v in pairs( signs_ents ) do
        table.insert( signs, {
            Class = "gmod_track_mplr_sign",
            Pos = v:GetPos(),
            Angles = v:GetAngles(),
            SignType = v.Type,
            YOffset = v.YOffset,
            ZOffset = v.ZOffset,
            Left = v.Left,
        } )
    end

    -- Save data
    print( "MPLR: Saving signs and track definition..." )
    local data = util.TableToJSON( signs, true )
    file.Write( string.format( "project_light_rail_data/signs_%s.txt", name ), data )
    print( Format( "Saved to project_light_rail_data/signs_%s.txt", name ) )
end

function UF.Load( name, keep_signs )
    if not Metrostroi then
        print( "Quitting because Metrostroi not loaded" )
        return
    end

    name = name or game.GetMap()
    -- loadTracks(name)
    -- Initialize stations list
    -- Print info
    -- UF.PrintStatistics()
    -- Ignore updates to prevent created/removed switches from constantly updating table of positions
    Metrostroi.IgnoreEntityUpdates = true
    UF.LoadSignalling( name, keep_signs )
    timer.Simple( 0.05, function()
        -- No more ignoring updates
        Metrostroi.IgnoreEntityUpdates = false
        -- Load ARS entities
        UF.UpdateSignalEntities()
        -- Load switches
        UF.UpdateSwitchEntities()
        UF.UpdateStations()
        UF.ConstructDefaultSignalBlocks()
        if not ents.FindByClass( "gmod_mplr_signalserver" ) then
            Server = ents.Create( "gmod_mplr_signalserver" )
            Server.Model = UF.ServerModel or nil
            Server.SoundLoop = UF.ServerSound or nil
            Server:SetPos( UF.ServerPos or Vector( 0, 0, 0 ) )
            Server:Spawn()
            print( "MPLR: Spawned central signalling server" )
        end
    end )
end

local function printTable( table, indent )
    if not indent then indent = 0 end
    for key, value in pairs( table ) do
        if type( value ) == "table" then
            print( string.rep( "  ", indent ) .. key .. "=" )
            printTable( value, indent + 1 )
        else
            print( string.rep( "  ", indent ) .. key .. "= " .. tostring( value ) )
        end
    end
end

local function getFile( path, name, id )
    local data, found
    if file.Exists( Format( path .. ".txt", name ), "DATA" ) then
        print( Format( "MPLR: Loading %s definition from txt file...", id ) )
        data = util.JSONToTable( file.Read( Format( path .. ".txt", name ), "DATA" ) )
        found = true
    end

    if not data and file.Exists( Format( path .. ".lua", name ), "LUA" ) then
        print( Format( "MPLR: Loading %s definition from lua file...", id ) )
        data = util.JSONToTable( file.Read( Format( path .. ".lua", name ), "LUA" ) )
        found = true
    end

    if not found then
        print( Format( "%s definition file not found: %s", id, Format( path, name ) ) )
        return
    elseif not data then
        print( Format( "MPLR: Parse error in %s %s definition JSON", id, Format( path, name ) ) )
        return
    end
    return data
end

local function findKeyInNestedTable( table, keyToFind )
    for key, value in pairs( table ) do
        if key == keyToFind then
            return value
        elseif type( value ) == "table" then
            local result = findKeyInNestedTable( value, keyToFind )
            if result then return result end
        end
    end
end

function UF.ConstructDefaultSignalBlocks() -- those signals that do not need dynamic routing, just make static signal blocks ¯\_(ツ)_/¯ actually no let's just construct the default state
    print( "MPLR: Loading default Signal blocks" )
    UF.SignalBlocks = {}
    for k, v in pairs( Metrostroi.SignalEntitiesByName ) do
        print( "Constructing default signal blocks: " .. k, v.Routes[ 1 ].NextSignal )
        table.insert( UF.SignalBlocks, {
            [ k ] = v.Routes[ 1 ].NextSignal,
            Occupied = false
        } )

        UF.ActiveRoutes[ k ] = 1
        print( k, UF.ActiveRoutes[ k ] )
    end
end

function UF.OpenRoute( signal, route, ent )
    if not next( UF.SignalBlocks ) then return end
    --print("Route Change requested on signal:", signal, "to route", route,"by entity:", ent)
    if UF.ActiveRoutes[ signal ] == route then
        print( "Requested route already active, bailing out" )
        return
    end

    local CurrentSignalEnt = Metrostroi.SignalEntitiesByName[ signal ] -- target the signal's entity for operations
    local RoutesTable = CurrentSignalEnt.Routes -- a little shortcut to the routes table, for readability
    local CurrentBlock
    local function checkSignal( v )
        for key, _ in pairs( v ) do
            print( key, signal )
            return key == signal
        end
        return false
    end

    for _, v in ipairs( UF.SignalBlocks ) do
        CurrentBlock = v
        if checkSignal( v ) then
            v[ signal ] = RoutesTable[ route ].NextSignal --look up what the next signal of the route is and set it
            UF.ActiveRoutes[ signal ] = route -- we're changing the currently active route on this signal, write that down, squire!
            print( Format( "Opened Route %s on Signal %s to Signal %s", route, signal, RoutesTable[ route ].NextSignal ) )
        end
    end
end

function UF.UpdateSignalBlockOccupation()
    for k, v in pairs( UF.SignalBlocks ) do
        local CurrentBlock = UF.SignalBlocks[ k ]
        local function GetSignals()
            for ky, val in pairs( CurrentBlock ) do
                if type( ky ) == "string" then return ky, val end
            end
        end

        -- print(CurrentBlock)
        local CurrentSignal, DistantSignal = GetSignals()
        local CurrentSignalEnt, DistantSignalEnt = Metrostroi.SignalEntitiesByName[ CurrentSignal ], Metrostroi.SignalEntitiesByName[ DistantSignal ]
        if not DistantSignalEnt then continue end
        local CurrentPos = CurrentSignalEnt.TrackPosition
        local DistantPos = DistantSignalEnt.TrackPosition
        if not next( Metrostroi.TrainPositions ) then
            CurrentBlock.Occupied = false
            return
        end

        CurrentBlock.Occupied = UF.IsTrackOccupied( CurrentPos.node1, CurrentPos.x, CurrentPos.x < DistantPos.x, "light", DistantPos.x )
    end
end

function UF.LoadSignalling( name, keep )
    if keep then return end
    local signs = getFile( "project_light_rail_data/signs_%s", name, "Signal" )
    if not signs then return end
    local signals_ents = ents.FindByClass( "gmod_track_uf_signal" )
    for k, v in pairs( signals_ents ) do
        SafeRemoveEntity( v )
    end

    --[[local switch_ents = ents.FindByClass("gmod_track_uf_switch")
    for k, v in pairs(switch_ents) do SafeRemoveEntity(v) end]]
    local signs_ents = ents.FindByClass( "gmod_track_uf_signs" )
    for k, v in pairs( signs_ents ) do
        SafeRemoveEntity( v )
    end

    -- Create new entities (add a delay so the old entities clean up)
    print( "MPLR: Loading signs, signals, switches..." )
    for k, v in pairs( signs ) do
        local ent = ents.Create( v.Class )
        if IsValid( ent ) then
            ent:SetPos( v.Pos )
            ent:SetAngles( v.Angles )
            if v.Class == "gmod_track_uf_switch" then
                ---CHANGE
                ent.LockedSignal = v.LockedSignal
                ent.NotChangePos = v.NotChangePos
                ent.Inverted = v.Inverted
                ent.ID = v.ID
            end

            if v.Class == "gmod_track_uf_signal" then
                ent.SignalType = v.SignalType
                ent.Name1 = v.Name1
                ent.Name2 = v.Name2
                ent.Name = v.Name
                ent.ActiveRoute = v.ActiveRoute
                ent.Routes = v.Routes
                ent:SendUpdate()
            elseif v.Class == "gmod_track_uf_signs" then
                ent.SignType = v.SignType
                ent.YOffset = v.YOffset
                ent.ZOffset = v.ZOffset
                ent.Left = v.Left
                ent:SendUpdate()
            end
        end
    end
end

-- UF.IsTrackOccupied checks if any trains are present between two positions on the track.
-- It scans the track from a source node, returning true if a train is detected, along with details of the train(s).
-- Parameters:
--   src_node: The node to start scanning from.
--   x: The current X position on the track.
--   dir: Direction of travel (true = forward, false = backward).
--   t: The type of scan (e.g., "light", "switch"). Defaults to "light".
--   maximum_x: The maximum X position to scan up to.
-- Returns:
--   true if a train is found, along with the first and last detected train and a list of all trains.
function UF.IsTrackOccupied( src_node, x, dir, t, maximum_x )
    local Trains = {} -- List to store any detected trains.
    -- Call UF.ScanTrack to scan the track and look for trains. The callback checks for trains within the scan range.
    UF.ScanTrack( t or "light", src_node, function( node, min_x, max_x )
        -- If no trains are present in this node, continue scanning.
        if ( not Metrostroi.TrainsForNode[ node ] ) or ( #Metrostroi.TrainsForNode[ node ] == 0 ) then return end
        -- Loop through each train in the node.
        for _, train in pairs( Metrostroi.TrainsForNode[ node ] ) do
            -- Get the position of the train on the track.
            local positions = Metrostroi.TrainPositions[ train ]
            -- For each path that the train is on, check if it's in the scan range.
            for _, pos_data in pairs( positions ) do
                -- Check if the train's path matches the node's path.
                if pos_data.path == node.path then
                    -- Define X bounds for the train's position.
                    local x1, x2 = pos_data.x, pos_data.x
                    -- Check if the train is within the scanning range (between min_x and max_x).
                    if ( ( x1 >= min_x ) and ( x1 <= max_x ) ) or ( ( x2 >= min_x ) and ( x2 <= max_x ) ) or ( ( x1 <= min_x ) and ( x2 >= max_x ) ) then
                        -- Train detected, insert into the Trains list.
                        table.insert( Trains, train )
                    end
                end
            end
        end
    end, x, dir, nil, maximum_x )
    -- Return true if any trains were found, and also return the first and last train detected, along with the train list.
    return #Trains > 0, Trains[ #Trains ], Trains[ 1 ], Trains
end

local nodes = {}
function UF.WriteToNodeTable( node_start, node_end, forwards, k_v )
    if not node_start then return end
    nodeTab = node_start
    for k, v in pairs( k_v ) do
        print( k, v )
        node_start[ k ] = v
    end

    if node_start == node_end then return true end
    if forwards then
        UF.WriteToNodeTable( node_start.next, node_end, forwards, k_v )
    else
        UF.WriteToNodeTable( node_start.prev, node_end, forwards, k_v )
    end
end

function UF.PrintStatistics()
end

function UF.UpdateSwitchEntities()
    if Metrostroi.IgnoreEntityUpdates then return end
    Metrostroi.SwitchesForNode = {}
    Metrostroi.SwitchesByName = {}
    local entities = ents.FindByClass( "gmod_track_uf_switch" )
    for k, v in pairs( entities ) do
        local pos = Metrostroi.GetPositionOnTrack( v:GetPos(), v:GetAngles() - Angle( 0, 90, 0 ) )[ 1 ]
        if pos then
            if not v.Name or v.Name == "" then
                -- pos.path.id.."/"..pos.node1.id
                if not Metrostroi.SwitchesByName[ pos.path.id ] then Metrostroi.SwitchesByName[ pos.path.id ] = {} end
                Metrostroi.SwitchesByName[ pos.path.id ][ pos.node1.id ] = v
            end

            Metrostroi.SwitchesForNode[ pos.node1 ] = Metrostroi.SwitchesForNode[ pos.node1 ] or {}
            table.insert( Metrostroi.SwitchesForNode[ pos.node1 ], v )
            v.TrackPosition = pos -- FIXME: check that one switch belongs to one track
        end

        if v.Name and v.Name ~= "" then Metrostroi.SwitchesByName[ v.Name ] = v end
    end
end

--------------------------------------------------------------------------------
-- Get travel time between two nodes in seconds
--------------------------------------------------------------------------------
function UF.GetTravelTime( src, dest )
    -- Determine direction of travel
    -- assert(src.path == dest.path)
    local direction = src.x < dest.x
    -- Accumulate travel time
    local travel_time = 0
    local travel_dist = 0
    local travel_speed = 60
    local iter = 0
    local function scan( node, path )
        local oldx
        local oldars
        while node and ( node ~= dest ) do
            -- print(Format("[%03d] %.2f m   V = %02d km/h",node.id,node.length,ars_speed or 0))
            -- Assume 70% of travel speed
            local speed = travel_speed * 0.7
            -- Add to travel time
            travel_dist = travel_dist + node.length
            travel_time = travel_time + ( node.length / ( speed / 3.6 ) )
            node = node.next
            if not node then break end
            if src.path == dest.path and node.branches and node.branches[ 1 ][ 2 ].path == src.path then scan( node, src.x > node.branches[ 1 ][ 2 ].x ) end
            iter = iter + 1
            assert( iter < 10000, "OH SHI~" )
        end
    end

    if src.path == dest.path and src.branches and src.branches[ 2 ] and src.branches[ 2 ][ 2 ].path == dest.path then scan( src, src.x > src.branches[ 1 ][ 1 ].x ) end
    return travel_time, travel_dist
end