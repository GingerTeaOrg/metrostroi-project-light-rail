files = file.Find( "uf/cl_*.lua", "LUA" )
for _, filename in pairs( files ) do
    AddCSLuaFile( "uf/" .. filename )
end

-- Function to add a hook to the entity
local function AddEntityHook( ent )
    hook.Add( "PostDrawHUD", "RenderDFIScreens" .. ent:EntIndex(), function() if IsValid( ent ) and ent.RenderDisplay then ent:RenderDisplay() end end )
end

-- Add hooks for entities that exist at map start
for _, ent in ipairs( ents.FindByClass( "gmod_track_uf_dfi" ) ) do
    AddEntityHook( ent )
end

-- Add hooks for entities that are created after map start
hook.Add( "OnEntityCreated", "AddHookToNewDFIEntities", function( ent )
    if ent:GetClass() == "gmod_track_uf_dfi" then
        timer.Simple( 0, function()
            -- Delay to ensure entity is fully initialized
            if IsValid( ent ) then AddEntityHook( ent ) end
        end )
    end
end )