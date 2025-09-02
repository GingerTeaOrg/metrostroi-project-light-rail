if SERVER then return end
-- Define an icon path
local icon = "materials/vgui/icon.png"
local cats = {
    {}, -- Initialize categories
    {}
}

-- Hook to populate the entity list in the spawn menu
hook.Add( "InitPostEntity", "PopulateList", function( content, tree, node )
    -- Iterate through scripted entities and categorize them
    for name, _ in pairs( scripted_ents.GetList() ) do
        if MPLR.IsTrainClass[ name ] then
            local cat = name.Category or "creationtab_category.default"
            if not istable( cat ) then cat = { cat } end
            local curcats = cats
            table.insert( curcats[ 1 ], {
                PrintName = name.PrintName,
                Class = name,
                IconOverride = name.IconOverride,
                AdminOnly = name.AdminSpawnable,
            } )
        end
    end

    local order = {
        {
            cats, -- Initialize order of categories
            tree:Root()
        }
    }

    while #order > 0 do
        -- Process categories
        local cur = table.remove( order, 1 )
        for k, v in pairs( cur[ 1 ][ 2 ] ) do
            local node = cur[ 2 ]:AddNode( k, icon )
            node.DoPopulate = function( self )
                if self.PropPanel then return end
                self.PropPanel = vgui.Create( "ContentContainer", content )
                self.PropPanel:SetVisible( false )
                self.PropPanel:SetTriggerSpawnlistChange( false )
                -- Create content icons for each entity in the category
                for k, data in SortedPairsByMemberValue( v[ 1 ], "PrintName" ) do
                    spawnmenu.CreateContentIcon( "entity_lightrail", self.PropPanel, {
                        name = data.PrintName or data.Class,
                        class = data.Class,
                        icon = data.IconOverride or "entities/" .. data.Class .. ".png",
                        admin = data.AdminOnly,
                    } )
                end
            end

            -- Define click behavior for the category node
            node.DoClick = function( self )
                self:DoPopulate()
                content:SwitchPanel( self.PropPanel )
            end

            order[ #order + 1 ] = {
                v, -- Add subcategories to the order
                node
            }
        end
    end

    local FirstNode = tree:Root():GetChildNode( 0 )
    if IsValid( FirstNode ) then
        FirstNode:InternalDoClick() -- Select the first category node
    end
end )

-- Add a new creation tab titled "Project Light Rail" to the spawn menu
local tab = spawnmenu.AddCreationTab( "Metrostroi: Project Light Rail", function()
    local panel = vgui.Create( "SpawnmenuContentPanel" )
    return panel
end, "materials/vgui/icon.png", 20 )

-- Add a new content type to the spawn menu for entities related to Light Rail
local Type = spawnmenu.AddContentType( "entity_lightrail", function( parent, data )
    --if not data then return end
    -- Create a ContentIcon object and set its properties
    local icon = vgui.Create( "ContentIcon", tab )
    icon:SetSpawnName( data.class )
    icon:SetName( data.name )
    icon:SetMaterial( data.icon )
    icon:SetAdminOnly( data.admin )
    icon:SetColor( Color( 205, 92, 92 ) )
    -- Define click behavior for the icon
    icon.DoClick = function()
        surface.PlaySound( "ui/buttonclickrelease.wav" )
        -- Add custom click behavior here
    end

    -- Define behavior when right-clicking the icon
    icon.OpenMenu = function( self )
        local menu = DermaMenu()
        -- Add option to copy the spawn name to clipboard
        menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( self:GetSpawnName() ) end ):SetIcon( "icon16/page_copy.png" )
        menu:Open() -- Open the menu
    end

    parent:Add( icon ) -- Add the icon to the parent panel
    return icon -- Return the icon
end )