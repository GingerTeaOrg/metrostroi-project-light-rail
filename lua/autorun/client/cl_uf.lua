files = file.Find( "uf/cl_*.lua", "LUA" )
for _, filename in pairs( files ) do
    AddCSLuaFile( "uf/" .. filename )
end

hook.Add( "PostDrawHUD", "RenderDFIScreens", function()
    for _, ent in ipairs( ents.FindByClass( "gmod_track_uf_dfi" ) ) do
        if IsValid( ent ) and ent.RenderDisplay then ent:RenderDisplay() end
    end
end )