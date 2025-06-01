files = file.Find( "uf/cl_*.lua", "LUA" )
for _, filename in pairs( files ) do
    AddCSLuaFile( "uf/" .. filename )
    include( "uf/" .. filename )
end