-- Register the tool
if CLIENT then
    language.Add( "tool.uf_signs.name", "Metrostroi: Project Light Rail Sign Spawner" )
    language.Add( "tool.uf_signs.desc", "Set up your signs" )
    language.Add( "tool.uf_signs.left", "Left-click to spawn a sign." )
    language.Add( "tool.uf_signs.right", "Right-click to load a sign's settings." )
    TOOL.Category = "Metrostroi: Project Light Rail"
    TOOL.Name = "Sign Spawner"
    TOOL.Information = {
        {
            name = "left"
        },
        {
            name = "right"
        }
    }

    TOOL.ClientConVar[ "sign_type" ] = "speed_60"
    TOOL.ClientConVar[ "sign_vertical_offset" ] = "0"
    TOOL.ClientConVar[ "sign_horizontal_offset" ] = "0"
    TOOL.ClientConVar[ "sign_left" ] = "0"
end

if SERVER then
    util.AddNetworkString( "uf_sign_settings" )
    util.AddNetworkString( "uf_sign_settings_client" )
end

function TOOL:Initialize()
    if CLIENT then
        CreateClientConVar( "uf_signs_sign_type", "speed_60" )
        CreateClientConVar( "uf_signs_sign_vertical_offset", "0", true )
        CreateClientConVar( "uf_signs_sign_horizontal_offset", "0", true )
        hook.Add( "PostDrawOpaqueRenderables", "DrawSignalWireframe", function()
            local player = LocalPlayer()
            local trace = player:GetEyeTrace()
            if trace.Entity:IsValid() and trace.Entity:GetClass() == "gmod_track_uf_signal" then DrawWireframeBox( trace.Entity ) end
        end )
    end
end

-- Table of signal types with their respective models
local signalTypes = file.Find( "models/lilly/uf/signage/*.mdl", "GAME", "nameasc" )
-- Add more signal types as needed
-- Precaching signal models
if CLIENT then
    for _, modelPath in pairs( signalTypes ) do
        util.PrecacheModel( modelPath )
    end
end

-- Function to build the settings pane
function TOOL.BuildCPanel( panel )
    local tool = tool or {}
    local basePath = "models/lilly/uf/signage/"
    CreateClientConVar( "uf_signs_sign_type", "speed_60" )
    CreateClientConVar( "uf_signs_sign_left", "0", true )
    CreateClientConVar( "uf_signs_sign_vertical_offset", "0", true )
    CreateClientConVar( "uf_signs_sign_horizontal_offset", "0", true )
    CreateClientConVar( "uf_signs_sign_rotation", "0", true )
    tool.Settings = tool.Settings or {}
    -- Header for signal settings
    panel:AddControl( "Header", {
        Description = "Sign Settings"
    } )

    -- Model preview panel
    local modelPreviewPanel = vgui.Create( "DPanel" )
    local panelSize = 300 -- Desired size
    modelPreviewPanel:SetSize( 100, panelSize )
    local modelPreview = vgui.Create( "DModelPanel", modelPreviewPanel )
    modelPreview:SetSize( 100, 220 ) -- Adjust size as needed
    modelPreview:SetModel( "" ) -- Set initial model to an empty string
    modelPreview:Dock( TOP )
    local scrollPanel = vgui.Create( "DScrollPanel", modelPreviewPanel )
    scrollPanel:Dock( FILL )
    for _, modelPath in pairs( signalTypes ) do
        local button = vgui.Create( "DButton", scrollPanel )
        button:SetText( modelPath )
        button:Dock( TOP )
        button.DoClick = function()
            LocalPlayer():EmitSound( "buttons/button3.wav" )
            modelPreview:SetModel( basePath .. modelPath )
            RunConsoleCommand( "uf_signs_sign_type", basePath .. modelPath )
        end
    end

    -- Adjust camera position for model preview
    modelPreview.LayoutEntity = function( ent )
        ent:SetCamPos( Vector( -100, 100, 0 ) )
        ent:SetLookAt( Vector( 0, 0, 0 ) )
        ent:SetFOV( 15 )
    end

    panel:AddPanel( modelPreviewPanel )
    -- Rotation slider
    local rotationSlider = vgui.Create( "DNumSlider", panel )
    rotationSlider:SetText( "Signal Prop Rotation" )
    rotationSlider:SetMin( -75 )
    rotationSlider:SetMax( 75 )
    rotationSlider:SetDecimals( 0 )
    rotationSlider:SetValue( rotation ) -- Initial rotation value
    rotationSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signs_sign_rotation", tostring( value:GetValue() ) ) end
    panel:AddPanel( rotationSlider )
    local leftCheckBox = panel:AddControl( "Checkbox", {
        Label = "Mount signal left or right hand side of track? (checked for left)",
    } )

    -- Fixing the OnChange for checkbox
    leftCheckBox.OnChange = function( self, bVal )
        local arg = bVal and 1 or 0
        RunConsoleCommand( "uf_signs_sign_left", tostring( arg ) )
    end

    local horizontalSlider = vgui.Create( "DNumSlider", panel )
    horizontalSlider:SetText( "Sign Prop Horizontal Offset" )
    horizontalSlider:SetMin( -400 )
    horizontalSlider:SetMax( 400 )
    horizontalSlider:SetDecimals( 1 )
    horizontalSlider:SetValue( rotation ) -- Initial rotation value
    horizontalSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signs_sign_horizontal_offset", tostring( value:GetValue() ) ) end
    panel:AddPanel( horizontalSlider )
    -------------------------------------------------
    local verticalSlider = vgui.Create( "DNumSlider", panel )
    verticalSlider:SetText( "Sign Prop Vertical Offset" )
    verticalSlider:SetMin( -400 )
    verticalSlider:SetMax( 400 )
    verticalSlider:SetDecimals( 1 )
    verticalSlider:SetValue( rotation ) -- Initial rotation value
    verticalSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signs_sign_vertical_offset", tostring( value:GetValue() ) ) end
    panel:AddPanel( verticalSlider )
    -- Instructions
    panel:AddControl( "Label", {
        Text = "Primary Fire to Spawn Signal"
    } )

    panel:AddControl( "Label", {
        Text = "Secondary Fire to Update Signal"
    } )
end

-- Function to create the signal entity
function TOOL:LeftClick()
    if SERVER then
        self.Settings = ServerSettings
        --PrintTable( self.Settings, 1 )
        local ply = self:GetOwner()
        local trace = util.TraceLine( {
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
            filter = { ply }
        } )

        local signType = self:GetClientInfo( "sign_type" )
        local rotation = self:GetClientNumber( "sign_rotation", 0 )
        local left = self:GetClientBool( "sign_left" )
        local horizontal = self:GetClientNumber( "sign_horizontal_offset" )
        local vertical = self:GetClientNumber( "sign_vertical_offset" )
        local ent = ents.Create( "gmod_track_mplr_sign" )
        if not IsValid( ent ) then
            print( "Sign Entity not valid!!" )
            return false
        end

        ent.Type = signType
        ent:SetNW2Int( "Horizontal", horizontal )
        ent:SetNW2Int( "Vertical", vertical )
        ent:SetNW2Int( "Rotation", rotation )
        ent:SetNW2Bool( "Left", left )
        ent:SetNW2String( "Type", signType )
        -- Set the signal names before spawning the entity
        ent.Left = left
        local angleToPlayer = ( ply:GetShootPos() - trace.HitPos ):Angle()
        angleToPlayer.p = 0 -- Keep it upright by setting pitch to 0
        ent:SetAngles( angleToPlayer )
        ent:SetPos( trace.HitPos )
        ent:Spawn()
        undo.Create( "Sign" )
        undo.AddEntity( ent )
        undo.SetPlayer( self:GetOwner() )
        undo.Finish()
        return true
    end
end

function TOOL:GetClientInfo( property )
    if self.ClientConVars[ property ] and CLIENT then return self.ClientConVars[ property ]:GetString() end
    return self:GetOwner():GetInfo( self:GetMode() .. "_" .. property )
end

-- Function to update signal names on right-click
function TOOL:RightClick( trace )
    if CLIENT then return false end
    local ply = self:GetOwner()
    if not ply:IsAdmin() then return end
    if not IsValid( trace.Entity ) or not trace.Entity:IsValid() then return false end
    if trace.Entity:GetClass() == "gmod_track_uf_signal" then
        local signalType = self.Settings[ "SignalType" ]
        local modelName = signalTypes[ signalType ]
        local signalName1 = self.Settings[ "Name1" ]
        local signalName2 = self.Settings[ "Name2" ]
        local Rotation = self.Settings[ "Rotation" ]
        trace.Entity.Name1 = signalName1
        trace.Entity.Name2 = signalName2
        return true
    end
    return false
end

-- Function to create the model preview
function TOOL:Think()
    if CLIENT then
        local ply = self:GetOwner()
        if not ply:IsAdmin() then
            ply:PrintMessage( HUD_PRINTTALK, "You're not a server admin. Bailing." )
            return
        end

        local ClientSettings = ClientSettings or {}
        net.Receive( "uf_sign_settings_client", function() ClientSettings = net.ReadTable() end )
        self.Settings = ClientSettings
        if not self.Settings then
            print( "NO SETTINGS" )
            return
        end

        if not IsValid( ply ) then
            print( "No player" )
            return
        end

        local trace = util.TraceLine( {
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
            filter = { ply }
        } )

        if not trace.Hit then -- If the trace doesn't hit anything, return
            return
        end

        local signType = GetConVar( "uf_signs_sign_type" ):GetString()
        local modelName = signType or "models/error.mdl"
        if not modelName then
            print( "No model sent, bailing out of preview function" )
            return
        end

        local rotation = GetConVar( "uf_signs_sign_rotation" ):GetInt()
        -- Spawn preview model if it doesn't exist
        if not IsValid( self.PreviewModel ) then
            self.PreviewModel = ClientsideModel( modelName, RENDERGROUP_OPAQUE )
            self.PreviewModel:Spawn()
            self.PreviewModel:SetModel( modelName )
        end

        local left = GetConVar( "uf_signs_sign_left" ):GetInt() > 0
        local horizontal = GetConVar( "uf_signs_sign_horizontal_offset" ):GetInt()
        local vertical = GetConVar( "uf_signs_sign_vertical_offset" ):GetInt()
        local offset = left and -60 or 60 -- Y-axis offset
        local horizontalOffset = offset + horizontal
        local delta = Vector( 0, horizontalOffset, vertical )
        -- Calculate the aim direction and set the position of the preview model
        local aimDirection = ply:GetAimVector()
        local offsetPosition = trace.HitPos + aimDirection:Angle():Right() * delta.y -- Apply right vector for the offset
        -- Set position and rotation of the preview model
        self.PreviewModel:SetPos( offsetPosition + Vector( 0, 0, vertical ) )
        -- Make the preview model face the player
        local angleToPlayer = ( ply:GetShootPos() - trace.HitPos ):Angle()
        angleToPlayer.p = 0 -- Keep it upright by setting pitch to 0
        self.PreviewModel:SetAngles( angleToPlayer + Angle( 0, -90, 0 ) + Angle( 0, rotation, 0 ) )
        self.PreviewModel:SetModel( modelName )
        self.PreviewModel:SetRenderMode( RENDERMODE_TRANSCOLOR )
        self.PreviewModel:SetColor( Color( 255, 255, 255, 161 ) )
        self.PreviewModel:SetNoDraw( false )
    end
end

-- Function to remove the model preview
function TOOL:Holster()
    if CLIENT then if IsValid( self.PreviewModel ) then self.PreviewModel:Remove() end end
end

if SERVER then
    local ServerSettings = ServerSettings or {}
    net.Receive( "uf_sign_settings", function()
        ServerSettings = net.ReadTable()
        if ServerSettings then
            print( "Relaying settings" )
            net.Start( "uf_sign_settings_client" )
            net.WriteTable( ServerSettings, true )
            net.Broadcast()
        end
    end )
end

local function DrawWireframeBox( entity )
    if IsValid( entity ) then
        local mins, maxs = entity:GetRenderBounds()
        local position = entity:GetPos()
        -- Set the wireframe color
        render.SetColorMaterial()
        render.DrawWireframeBox( position, entity:GetAngles(), mins, maxs, Color( 255, 0, 0, 255 ), true )
    end
end