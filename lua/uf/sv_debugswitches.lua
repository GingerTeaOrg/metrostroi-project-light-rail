function MPLR.DebugSwitchPaths()
    local switches = ents.FindByClass( "gmod_track_uf_switch" )
    for _, v in ipairs( switches ) do
        if next( v.Paths ) then
            for i, p in ipairs( v.Paths ) do
                print( "Entity: " .. v, i, p )
            end
        end
    end
end

local function printTableLimited( table, depth )
    if depth == nil then depth = 0 end
    if depth >= 2 or type( table ) ~= "table" then
        print( table )
        return
    end

    for key, value in pairs( table ) do
        print( key, value )
        if type( value ) == "table" then
            print( "    Subtable:", value )
            for k, v in pairs( value ) do
                print( "     ", k, v )
            end
        end
    end
end

function MPLR.PrintBranchPathsNearSwitch()
    local switches = ents.FindByClass( "gmod_track_uf_switch" )
    for _, ent in ipairs( switches ) do
        local branches = Metrostroi.GetPositionOnTrack( ent:GetPos(), ent:GetAngles() )[ 1 ].node1
        printTableLimited( branches, 1 )
        if not branches then
            print( "Switch is not placed on branches! Exiting!", ent )
            return
        else
            for k, _ in pairs( branches ) do
                print( branches[ k ] )
            end
        end
    end
end