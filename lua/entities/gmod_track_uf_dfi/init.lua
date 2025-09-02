AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
    if not MPLR then return end
    util.AddNetworkString( "PlayerTrackerDFI" .. self:EntIndex() )
    self:DropToFloor()
    if self.VMF and self.VMF.Type == "nopole" then
        self:SetModel( "models/lilly/uf/stations/dfi_nopole.mdl" )
    else
        self:SetModel( "models/lilly/uf/stations/dfi.mdl" )
    end

    self.PairedPlatform = self:GetNW2Entity( "PairedPlatform", self.VMF and self.VMF.PairedPlatform )
    self:DropToFloor()
    self.ValidLines = {
        [ "01" ] = true,
        [ "02" ] = true,
        [ "03" ] = true,
        [ "04" ] = true,
        [ "05" ] = true,
        [ "06" ] = true,
        [ "08" ] = true
    }

    self.DisplayedTrains = {}
    self.LastRefresh = CurTime()
    self.HasRefreshed = true
    self.NearestNodes = Metrostroi.NearestNodes( self:GetPos() )
    self.Position = self:GetPos()
    self.TrackPosition = Metrostroi.GetPositionOnTrack( self.Position, self:GetAngles() )[ 1 ]
    -- Based on the Metrostroi tracking system, where is the display?
    self.ScannedTrains = {}
    self.Mode = 0
    self.WorkTable = {}
    self.FilteredTable = {}
    self.SortedTable = {}
    self.Themes = {
        [ 1 ] = "Frankfurt",
        [ 2 ] = "Duesseldorf",
        [ 3 ] = "Essen",
        [ 4 ] = "Hannover"
    }

    if self.VMF then
        self.CurrentTheme = self.VMF.ThemeName
        self.ParentDisplay = self.VMF.ParentDisplay or nil
    end

    self.IgnoredTrains = {}
end

function ENT:GetPVS()
    local lastMSG = 0
    if CurTime() - lastMSG > 1 then
        net.Start( "PlayerTrackerDFI" .. self:EntIndex(), true )
        net.WriteInt( self:EntIndex() )
        net.SendPVS( self:GetPos() )
    end
end

local function valueExists( table, value )
    for _, v in ipairs( table ) do
        if v == value then return true end
    end
    return false
end

function ENT:DumpTable( table, indent )
    indent = indent or 0
    for key, value in pairs( table ) do
        if type( value ) == "table" then
            print( string.rep( "  ", indent ) .. key .. " = {" )
            self:DumpTable( value, indent + 1 )
            print( string.rep( "  ", indent ) .. "}" )
        else
            print( string.rep( "  ", indent ) .. key .. " = " .. tostring( value ) )
        end
    end
end

function ENT:Think()
    local trainPresent = self:TrainPresent()
    local stationIndex = tonumber( self.VMF.StationIndex, 10 )
    local platformIndex = tonumber( self.VMF.PlatformIndex, 10 )
    if not next( MPLR.StationEntsByIndex ) then return end
    self.PairedPlatform = self.PairedPlatform or MPLR.StationEntsByIndex[ stationIndex ][ platformIndex ]
    self.Time = os.date( "%I%M", os.time() )
    self:SetNW2String( "Time", self.Time )
    self.TrackPosition = self.TrackPosition or Metrostroi.GetPositionOnTrack( self.Position, self:GetAngles() )[ 1 ]
    self:SetNW2String( "Theme", self.CurrentTheme )
    if not next( MPLR.IBISRegisteredTrains ) or not Metrostroi.Paths then -- either fall back to idle, train list, or current train display
        self.Mode = 0
    elseif next( MPLR.IBISRegisteredTrains ) and Metrostroi.Paths then
        if CurTime() - self.LastRefresh > 10 then
            self.LastRefresh = CurTime()
            print( "Refreshing DFI" )
            self.SortedTable = {}
            self.WorkTable = {} -- reset the table for next run
            self.ScannedTrains = self:ScanForTrains() or {}
        end
    end

    if not next( self.ScannedTrains ) then
        self.Mode = 0
        self:NextThink( CurTime() + 0.25 )
        return
    end

    if not self.ParentDisplay then
        self:ProcessResults()
    else
        self:CopyResults()
    end

    self:SetNW2String( "ModeMessage", trainPresent )
    if not next( MPLR.IBISRegisteredTrains ) and not trainPresent then -- either fall back to idle, train list, or current train display
        self.Mode = 0
        self.IgnoredTrains = {}
    elseif not next( MPLR.IBISRegisteredTrains ) and trainPresent then
        self.Mode = 0
        self.IgnoredTrains = {}
    elseif self.Train1ETA and tonumber( self.Train1ETA ) > 0 then
        self.Mode = 1
    elseif self.Train1ETA and tonumber( self.Train1ETA ) == 0 or trainPresent then
        self.Mode = 2
        local CourseRoute = self.Train1Ent.IBIS.Course .. "/" .. self.Train1Ent.IBIS.Route
        if not valueExists( self.IgnoredTrains, CourseRoute ) then table.insert( self.IgnoredTrains, CourseRoute ) end
    end

    self:SetNW2Int( "Mode", self.Mode )
    self:NextThink( CurTime() + 0.25 )
end

function ENT:TrainPresent()
    if not IsValid( self.PairedPlatform ) then return end
    local platform = self.PairedPlatform
    local trainPresent, train = IsValid( platform.CurrentTrain ), platform.CurrentTrain
    if not trainPresent then return false end
    local msg = {}
    if not train.IBIS or not next( MPLR.IBISRegisteredTrains ) then
        return "DestUnknown"
    elseif train.IBIS then
        local ibis = train.IBIS
        local destination = string.lower( ibis.Destination )
        if string.find( destination, "nicht einsteigen" ) or string.find( destination, "leerfahrt" ) then
            return "DontBoard"
        else
            return "normal"
        end
    end
end

function ENT:CopyResults()
    local p = self.ParentDisplay
    self.Mode = p.Mode
    self.Train1Line = p.Train1Line
    self.Train1Destination = p.Train1Display
    self.Train1ETA = p.Train1ETA
    self.Train1ConsistLength = p.Train1ConsistLength
    self.Train2Line = p.Train2Line
    self.Train2Destination = p.Train2Display
    self.Train2ETA = p.Train2ETA
    self.Train3Line = p.Train3Line
    self.Train3Destination = p.Train3Display
    self.Train3ETA = p.Train3ETA
    self.Train4Line = p.Train4Line
    self.Train4Destination = p.Train4Display
    self.Train4ETA = p.Train4ETA
end

function ENT:ProcessResults()
    if not self.ScannedTrains then -- just quit if there's nothing to work with
        return
    end

    -- process everything into the list to be displayed on screen
    local subtables = {}
    -- Extract key-value pairs from the table and store them as subtables
    for key, value in pairs( self.ScannedTrains ) do
        -- self.ScannedTrains[k] = math.abs(k)
        local subtable = {}
        subtable[ key ] = value
        table.insert( subtables, subtable )
    end

    self.Train1, self.Train2, self.Train3, self.Train4 = unpack( subtables ) -- take apart that table
    if self.Train1 then
        for _, v in pairs( self.Train1 ) do
            local Train = v.train
            self.Train1Ent = Train
            if not IsValid( self.Train1Ent ) then return end
            if not v.ETA then return end
            self.Train1Line = string.sub( Train.IBIS.Course, 1, 2 )
            self.Train1Destination = Train:GetNW2String( "IBIS:DestinationText", "ERROR" )
            self.Train1ETA = tostring( math.Round( math.Round( v.ETA / 60 ) ) )
            self.Train1Dist = v.DIST
            self.Train1ConsistLength = #Train.WagonList
            self.Train1Vector = Metrostroi.GetPositionOnTrack( self.Train1Ent:GetPos(), self.Train1Ent:GetAngles() )[ 1 ]
        end
    end

    if self.Train2 then
        for _, v in pairs( self.Train2 ) do
            local Train = v.train
            if not IsValid( Train ) then break end
            self.Train2Ent = Train
            self.Train2Line = string.sub( Train.IBIS.Course, 1, 2 )
            self.Train2Destination = Train:GetNW2String( "IBIS:DestinationText", "ERROR" )
            self.Train2ETA = tostring( math.Round( math.Round( v.ETA / 60 ) ) )
            self.Train2ConsistLength = #Train.WagonList
            self.Train2Vector = Metrostroi.GetPositionOnTrack( Train:GetPos(), Train:GetAngles() )[ 1 ]
        end
    else
        self.Train2Line = " "
        self.Train2Destination = " "
        self.Train2ETA = " "
    end

    if self.Train3 then
        for _, v in pairs( self.Train3 ) do
            local Train = v.train
            if not IsValid( Train ) then break end
            self.Train3Line = string.sub( Train.IBIS.Course, 1, 2 )
            self.Train3Destination = Train:GetNW2String( "IBIS:DestinationText", "ERROR" )
            self.Train3ETA = tostring( math.Round( math.Round( v.ETA / 60 ) ) )
            self.Train3ConsistLength = #Train.WagonList
            self.Train3Vector = Metrostroi.GetPositionOnTrack( Train:GetPos(), Train:GetAngles() )[ 1 ]
        end
    else
        self.Train3Line = " "
        self.Train3Destination = " "
        self.Train3ETA = " "
    end

    if self.Train4 then
        for _, v in pairs( self.Train4 ) do
            local Train = v.train
            if not IsValid( Train ) then break end
            self.Train4Line = string.sub( Train.IBIS.Course, 1, 2 )
            self.Train4Destination = Train:GetNW2String( "IBIS:DestinationText", "ERROR" )
            self.Train4ETA = tostring( math.Round( math.Round( v.ETA / 60 ) ) )
            self.Train4ConsistLength = #Train.WagonList
            self.Train4Vector = Metrostroi.GetPositionOnTrack( Train:GetPos(), Train:GetAngles() )[ 1 ]
        end
    else
        self.Train4Line = " "
        self.Train4Destination = " "
        self.Train4ETA = " "
    end

    self:SetNW2String( "Train1Line", self.Train1Line )
    self:SetNW2String( "Train1Destination", self.Train1Destination )
    self:SetNW2String( "Train1Time", self.Train1ETA )
    self:SetNW2Int( "Train1ConsistLength", self.Train1ConsistLength )
    self:SetNW2String( "Train2Line", self.Train2Line )
    self:SetNW2String( "Train2Destination", self.Train2Destination )
    self:SetNW2String( "Train2Time", self.Train2ETA )
    self:SetNW2String( "Train3Line", self.Train3Line )
    self:SetNW2String( "Train3Destination", self.Train3Destination )
    self:SetNW2String( "Train3Time", self.Train3ETA )
    self:SetNW2String( "Train4Line", self.Train4Line )
    self:SetNW2String( "Train4Destination", self.Train4Destination )
    self:SetNW2String( "Train4Time", self.Train4ETA )
end

function ENT:ScanForTrains() --
    -- scrape all trains that have been logged into RBL, sort by distance, and display sorted by ETA
    if table.IsEmpty( MPLR.IBISRegisteredTrains ) then -- No point in doing anything if there isn't a single train registered / table is empty
        return
    end

    if not self.TrackPosition then return end
    for k, _ in pairs( MPLR.IBISRegisteredTrains ) do
        --print( Metrostroi.GetPositionOnTrack( k:GetPos(), k:GetAngles() )[ 1 ] )
        local trainCourse = k.IBIS.Course
        local route = k.IBIS.Route
        local courseRoute = trainCourse .. "/" .. route
        if not valueExists( self.WorkTable, k ) and not self.IgnoredTrains[ courseRoute ] then table.insert( self.WorkTable, k ) end
    end

    if #self.WorkTable < 1 then return end
    if #self.WorkTable > 4 then -- let's cut it short. The display only ever does four different trains.
        -- Iterate through the table and remove excess pairs
        local currentPairCount = 0
        for key in pairs( self.WorkTable ) do
            currentPairCount = currentPairCount + 1
            if currentPairCount > 4 then self.WorkTable[ key ] = nil end
        end
    end

    if not next( self.WorkTable ) then
        --print( "WorkTable Empty" )
        return
    end

    -- if nothing came of that, just exit
    -- if next(self.WorkTable) then print("WorkTable Length:", #self.WorkTable) end
    for k, v in ipairs( self.WorkTable ) do
        if not self.SortedTable[ k ] then
            local eta, Dist, _ = self:TrackETA( v )
            table.insert( self.SortedTable, {
                train = v, -- Insert a train and its ETA into the table
                ETA = eta,
                DIST = Dist
            } )
        else
            print( "Train already exists in table; bailing" )
            break
        end
    end

    -- now actually sort the table
    table.sort( self.SortedTable, function( a, b ) return a.ETA < b.ETA end )
    self:SetNW2Bool( "Train1Entry", self.Train1Entry ) -- We only display the entries that actually exist. Tell the client.
    self:SetNW2Bool( "Train2Entry", self.Train2Entry )
    self:SetNW2Bool( "Train3Entry", self.Train3Entry )
    self:SetNW2Bool( "Train4Entry", self.Train4Entry )
    return self.SortedTable -- return the shite
end

function ENT:TrackETA( train ) -- universal function for having Metrostroi calculate the ETA
    if train then
        local TrainPosOnTrack = Metrostroi.GetPositionOnTrack( train:GetPos(), train:GetAngles() )[ 1 ]
        -- input the train's world vector and get its position on the node system
        if not TrainPosOnTrack then return end
        return MPLR.GetTravelTime( TrainPosOnTrack.node1, self.TrackPosition.node1 ) -- return the travel time between the train and the display
    else
        return nil
    end
end

function ENT:Compare( a, b )
    return a < b
end

function ENT:KeyValue( key, value )
    self.VMF = self.VMF or {}
    self.VMF[ key ] = value
end