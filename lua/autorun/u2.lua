function MPLR.AddU2Rollsigns( name, lines )
    if not name or not lines then return end
    for k, v in pairs( MPLR.U2Rollsigns ) do
        if v.name == name then
            MPLR.U2Rollsigns[ k ] = lines
            MPLR.U2Rollsigns[ k ].name = name
            print( "Light Rail: Reloaded \"" .. name .. "\" U2 Rollsigns." )
            return
        end
    end

    local id = table.insert( MPLR.U2Rollsigns, lines )
    MPLR.U2Rollsigns[ id ].name = name
    print( "Light Rail: Loaded \"" .. name .. "\" U2 Rollsigns." )
end

files = file.Find( "uf/rollsigns/u2/*.lua", "LUA" )
for _, filename in pairs( files ) do
    AddCSLuaFile( "uf/rollsigns/u2/" .. filename )
    include( "uf/rollsigns/u2/" .. filename )
end