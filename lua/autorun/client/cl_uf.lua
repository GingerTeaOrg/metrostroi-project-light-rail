files = file.Find( "uf/cl_*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/" .. filename )
	include( "uf/" .. filename )
end

hook.Add( "OnEntityCreated", "MPLR_Lumino_ManageHook", function( ent )
	local isLumino = ent:GetClass() == "gmod_track_uf_dfi"
	if not isLumino then return end
	hook.Add( "PostDrawHUD", "MPLR_Lumino_Render_" .. ent:EntIndex(), function() if ent.RenderDisplay then ent:RenderDisplay( ent ) end end )
end )

hook.Add( "EntityRemoved", "MPLR_Lumino_ManageHookRemove", function( ent )
	local isLumino = ent:GetClass() == "gmod_track_uf_dfi"
	if not isLumino then return end
	hook.Remove( "PostDrawHUD", "MPLR_Lumino_Render_" .. ent:EntIndex() )
end )