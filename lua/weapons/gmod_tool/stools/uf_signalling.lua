-- Register the tool
if CLIENT then
    language.Add( "tool.uf_signalling.name", "Metrostroi: Project Light Rail Signal Spawner" )
    language.Add( "tool.uf_signalling.desc", "Set up your signals, in style!" )
    language.Add( "tool.uf_signalling.left", "Left-click to spawn a signal." )
    language.Add( "tool.uf_signalling.right", "Right-click to load a signal's settings." )
    TOOL.Category = "Metrostroi: Project Light Rail"
    TOOL.Name = "Signal Spawner"
    TOOL.Information = {
        {
            name = "left"
        },
        {
            name = "right"
        }
    }

    TOOL.ClientConVar[ "signal_type" ] = "Overground_Large"
end

if SERVER then
    util.AddNetworkString( "uf_signal_settings" )
    util.AddNetworkString( "uf_signal_settings_client" )
end

function TOOL:Initialize()
    if CLIENT then
        CreateClientConVar( "uf_signalling_signal_type", "Overground_Large" )
        CreateClientConVar( "uf_signalling_signal_name1", "name1", true )
        CreateClientConVar( "uf_signalling_signal_name2", "name2", true )
        CreateClientConVar( "uf_signalling_signal_rotation", "0", true )
        hook.Add( "PostDrawOpaqueRenderables", "DrawSignalWireframe", function()
            local player = LocalPlayer()
            local targetClass = "gmod_track_uf_signal"
            local maxDistance = 1000 -- Set an appropriate max distance
            for _, ent in ipairs( ents.FindByClass( targetClass ) ) do
                if ent:IsValid() and player:GetPos():DistToSqr( ent:GetPos() ) < maxDistance ^ 2 then
                    local direction = ( ent:GetPos() - player:GetPos() ):GetNormalized()
                    if direction:Dot( player:EyeAngles():Forward() ) > 0.98 then -- Adjust threshold as needed
                        print( "TRUE" )
                        render.DrawWireframeBox( ent:GetPos(), ent:GetAngles(), Vector( 0, 40, 0 ), Vector( 40, 40, 40 ), Color( 255, 255, 255, 255 ), true )
                    end
                end
            end
        end )
    end
end

-- Table of signal types with their respective models
local signalTypes = file.Find( "models/lilly/uf/signals/*.mdl", "GAME", "nameasc" )
-- The overground signals are in the same folder, but should be excluded and treated by a separate tool
local signalBlocklist = {
    [ "trafficlight_standard3lens.mdl" ] = true
}

local basePath = "models/lilly/uf/signals/"
-- Add more signal types as needed
-- Precaching signal models
if CLIENT then
    for _, modelPath in pairs( signalTypes ) do
        util.PrecacheModel( "models/lilly/uf/signals/" .. modelPath )
    end
end

-- Function to build the settings pane
function TOOL.BuildCPanel( panel )
    local tool = tool or {}
    CreateClientConVar( "uf_signalling_signal_type", "Overground_Large" )
    CreateClientConVar( "uf_signalling_signal_name1", "name1", true )
    CreateClientConVar( "uf_signalling_signal_name2", "name2", true )
    CreateClientConVar( "uf_signalling_signal_rotation", "0", true )
    CreateClientConVar( "uf_signalling_signal_left", "0", true )
    CreateClientConVar( "uf_signalling_signal_horizontal_offset", "0", true )
    CreateClientConVar( "uf_signalling_signal_vertical_offset", "0", true )
    -- Header for signal settings
    panel:AddControl( "Header", {
        Description = "Signal Settings"
    } )

    -- Model preview panel
    local modelPreviewPanel = vgui.Create( "DPanel" )
    local panelSize = 350 -- Desired size
    modelPreviewPanel:SetSize( 100, panelSize )
    panel:AddPanel( modelPreviewPanel )
    panel:DockPadding( 0, 10, 5, 10 )
    local modelPreview = vgui.Create( "DModelPanel", modelPreviewPanel )
    modelPreview:SetSize( 220, 280 ) -- Adjust size as needed
    modelPreview:SetModel( "" ) -- Set initial model to an empty string
    --modelPreview:Dock( TOP )
    local scrollPanel = vgui.Create( "DScrollPanel", modelPreviewPanel )
    scrollPanel:Dock( FILL )
    for _, modelPath in pairs( signalTypes ) do
        if not signalBlocklist[ modelPath ] then
            local button = vgui.Create( "DButton", scrollPanel )
            button:SetText( modelPath )
            button:Dock( TOP )
            button.DoClick = function()
                LocalPlayer():EmitSound( "buttons/button3.wav" )
                modelPreview:SetModel( basePath .. modelPath )
                RunConsoleCommand( "uf_signalling_signal_type", basePath .. modelPath )
            end
        end
    end

    -- Adjust camera position for model preview
    modelPreview.LayoutEntity = function( ent )
        ent:SetCamPos( Vector( 120, 0, 100 ) )
        ent:SetLookAt( Vector( 0, 0, 120 ) )
        ent:SetFOV( 75 )
    end

    -- First text entry for signal name
    local signalName1Entry = vgui.Create( "DTextEntry" )
    signalName1Entry:SetSize( 200, 25 )
    signalName1Entry:SetValue( signalName1 or "Top Signal Name Text" )
    signalName1Entry.OnEnter = function( self )
        local name1Value = self:GetValue() -- Use 'self' to get the text entry instance
        RunConsoleCommand( "uf_signalling_signal_name1", tostring( name1Value ) )
    end

    panel:AddPanel( signalName1Entry )
    -- Second text entry for bottom signal name
    local signalName2Entry = vgui.Create( "DTextEntry" )
    signalName2Entry:SetSize( 200, 25 )
    signalName2Entry:SetValue( signalName2 or "Bottom Signal Name Text" )
    signalName2Entry.OnEnter = function( self )
        local name2Value = self:GetValue() -- Use 'self' to get the text entry instance
        RunConsoleCommand( "uf_signalling_signal_name2", tostring( name2Value ) )
    end

    panel:AddPanel( signalName2Entry )
    -- Rotation slider
    local rotationSlider = vgui.Create( "DNumSlider", panel )
    rotationSlider:SetText( "Signal Prop Rotation" )
    rotationSlider:SetMin( -75 )
    rotationSlider:SetMax( 75 )
    rotationSlider:SetDecimals( 0 )
    rotationSlider:SetValue( rotation ) -- Initial rotation value
    rotationSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signalling_signal_rotation", tostring( value:GetValue() ) ) end
    local leftCheckBox = panel:AddControl( "Checkbox", {
        Label = "Mount signal left or right hand side of track? (checked for left)",
    } )

    -- Fixing the OnChange for checkbox
    leftCheckBox.OnChange = function( self, bVal )
        local arg = bVal and 1 or 0
        RunConsoleCommand( "uf_signalling_signal_left", tostring( arg ) )
    end

    local horizontalSlider = vgui.Create( "DNumSlider", panel )
    horizontalSlider:SetText( "Signal Prop Horizontal Offset" )
    horizontalSlider:SetMin( -45 )
    horizontalSlider:SetMax( 45 )
    horizontalSlider:SetDecimals( 1 )
    horizontalSlider:SetValue( rotation ) -- Initial rotation value
    horizontalSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signalling_signal_horizontal_offset", tostring( value:GetValue() ) ) end
    panel:AddPanel( horizontalSlider )
    -------------------------------------------------
    local verticalSlider = vgui.Create( "DNumSlider", panel )
    verticalSlider:SetText( "Signal Prop Vertical Offset" )
    verticalSlider:SetMin( -45 )
    verticalSlider:SetMax( 45 )
    verticalSlider:SetDecimals( 1 )
    verticalSlider:SetValue( rotation ) -- Initial rotation value
    verticalSlider.OnValueChanged = function( value ) RunConsoleCommand( "uf_signalling_signal_vertical_offset", tostring( value:GetValue() ) ) end
    panel:AddPanel( verticalSlider )
    -------------------------------------------------
    -- Function to handle input for switch settings
    local function InputSwitchingData()
        local SwitchInput = vgui.Create( "DFrame" )
        SwitchInput:SetSize( 200, 150 )
        SwitchInput:SetTitle( "Switching Data" )
        SwitchInput:Center()
        SwitchInput:MakePopup()
        -- Labels and text entries
        local labels = { "Switch", "Main/Alternate" }
        local yOffset = 66
        local textEntries = {}
        for i = 1, 2 do
            for j = 1, #labels do
                local label = vgui.Create( "DLabel", SwitchInput )
                label:SetPos( 15 + ( j - 1 ) * 88, yOffset + 5 )
                label:SetText( labels[ j ] .. " " .. i )
                label:SizeToContents()
                local textEntry = vgui.Create( "DTextEntry", SwitchInput )
                textEntry:SetPos( 10 + ( j - 1 ) * 85, yOffset )
                textEntry:SetSize( 90, 25 )
                -- Handle input logic
                textEntry.OnValueChange = function( self )
                    local value = textEntry:GetValue()
                    tool.Settings.Routes[ i ] = tool.Settings.Routes[ i ] or {}
                    tool.Settings.Routes[ i ][ "Switches" ] = tool.Settings.Routes[ i ][ "Switches" ] or {}
                    tool.Settings.Routes[ i ][ "Switches" ][ labels[ j ] ] = value
                end

                -- Store entries and update position
                textEntries[ i ] = textEntry
                yOffset = yOffset + 30
            end
        end

        -- Apply button
        local submitButton = vgui.Create( "DButton", SwitchInput )
        submitButton:SetText( "Apply" )
        submitButton:Dock( BOTTOM )
        submitButton.DoClick = function()
            net.Start( "uf_signal_settings" )
            net.WriteTable( tool.Settings )
            net.SendToServer()
            SwitchInput:Close()
        end
    end

    -- Set up routes button
    local submitButton = vgui.Create( "DButton", panel )
    submitButton:SetText( "Set up Routes" )
    submitButton.DoClick = function()
        local inputFrame = vgui.Create( "DFrame" )
        inputFrame:SetSize( 440, 300 )
        inputFrame:SetTitle( "Input Route Data" )
        inputFrame:Center()
        inputFrame:MakePopup()
        -- Number of routes slider
        local slider = vgui.Create( "DNumSlider", inputFrame )
        slider:SetText( "Number of Routes" )
        slider:SetPos( 10, 30 )
        slider:SetWide( 380 )
        slider:SetMin( 1 )
        slider:SetMax( 4 )
        slider:SetDecimals( 0 )
        slider:SetValue( 1 )
        local labels = { "Next Signal" }
        local yOffset = 70
        local textEntries = {}
        local switchButtons = {}
        -- Function to dynamically create fields for each route
        local function createFields( numFields )
            -- Clear previous fields
            for _, entry in ipairs( textEntries ) do
                if IsValid( entry ) then entry:Remove() end
            end

            for i = 1, numFields do
                textEntries[ i ] = {} -- Initialize row for text entries
                local label = vgui.Create( "DLabel", inputFrame )
                label:SetPos( 10 + 100, yOffset + 5 )
                label:SetText( labels[ 1 ] .. " " .. i )
                label:SizeToContents()
                local textEntry = vgui.Create( "DTextEntry", inputFrame )
                textEntry:SetPos( 5 + 100, yOffset )
                textEntry:SetSize( 100, 25 )
                -- Handle route data input
                textEntry.OnValueChange = function( self )
                    local value = textEntry:GetValue()
                    tool.Settings.Routes[ i ] = tool.Settings.Routes[ i ] or {}
                    tool.Settings.Routes[ i ][ "NextSignal" ] = value
                end

                -- Switch input button for each route
                local switchButton = vgui.Create( "DButton", inputFrame )
                switchButton:SetPos( 205, yOffset + 2.4 )
                switchButton:SetText( "Switching Data for Route" )
                switchButton.DoClick = function() InputSwitchingData() end
                textEntries[ i ] = textEntry
                yOffset = yOffset + 30
            end
        end

        -- Slider value changed
        slider.OnValueChanged = function( self, value )
            yOffset = 70
            createFields( value )
        end

        createFields( slider:GetValue() )
    end

    panel:AddPanel( submitButton )
    -- Apply settings button
    local ApplySettings = vgui.Create( "DButton", panel )
    ApplySettings:SetText( "Apply" )
    ApplySettings.DoClick = function()
        net.Start( "uf_signal_settings" )
        net.WriteTable( tool.Settings )
        net.SendToServer()
        LocalPlayer():EmitSound( "buttons/button3.wav" )
    end

    panel:AddPanel( ApplySettings )
    -- Instructions
    panel:AddControl( "Label", {
        Text = "Primary Fire to Spawn Signal"
    } )

    panel:AddControl( "Label", {
        Text = "Secondary Fire to Update Signal"
    } )
end

-- Function to create the signal entity
function TOOL:LeftClick( trace )
    if SERVER then
        self.Settings = ServerSettings
        --PrintTable( self.Settings, 1 )
        local ply = self:GetOwner()
        local trace = util.TraceLine( {
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
            filter = { ply }
        } )

        local signalType = GetConVar( "uf_signalling_signal_type" ):GetString()
        local signalName1 = GetConVar( "uf_signalling_signal_name1" ):GetString()
        local signalName2 = GetConVar( "uf_signalling_signal_name2" ):GetString()
        local rotation = GetConVar( "uf_signalling_signal_rotation" ):GetInt()
        local left = GetConVar( "uf_signalling_signal_left" ):GetInt() > 0
        local horizontal = GetConVar( "uf_signalling_signal_horizontal_offset" ):GetInt()
        local vertical = GetConVar( "uf_signalling_signal_vertical_offset" ):GetInt()
        local ent = ents.Create( "gmod_track_uf_signal" )
        if not IsValid( ent ) then return false end
        ent.SignalType = signalTypes[ signalType ]
        -- Set the signal names before spawning the entity
        ent.Left = left
        ent.Name1 = signalName1
        ent.Name2 = signalName2
        ent.DistantSignal = DistantSignal
        ent.Routes = Routes
        local angleToPlayer = ( ply:GetShootPos() - trace.HitPos ):Angle()
        angleToPlayer.p = 0 -- Keep it upright by setting pitch to 0
        ent:SetAngles( angleToPlayer )
        ent:SetPos( trace.HitPos )
        ent:Spawn()
        undo.Create( "Signal" )
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
            return false
        end

        local ClientSettings = ClientSettings or {}
        net.Receive( "uf_signal_settings_client", function() ClientSettings = net.ReadTable() end )
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

        local signalType = GetConVar( "uf_signalling_signal_type" ):GetString()
        local modelName = signalTypes[ signalType ] or "models/lilly/uf/signals/underground_small_pole.mdl"
        if not modelName then
            print( "No model sent, bailing out of preview function" )
            return
        end

        local rotation = GetConVar( "uf_signalling_signal_rotation" ):GetInt()
        -- Spawn preview model if it doesn't exist
        if not IsValid( self.PreviewModel ) then
            self.PreviewModel = ClientsideModel( modelName, RENDERGROUP_OPAQUE )
            self.PreviewModel:Spawn()
            self.PreviewModel:SetModel( modelName )
        end

        local left = GetConVar( "uf_signalling_signal_left" ):GetInt() > 0
        local horizontal = GetConVar( "uf_signalling_signal_horizontal_offset" ):GetInt()
        local vertical = GetConVar( "uf_signalling_signal_vertical_offset" ):GetInt()
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
        self.PreviewModel:SetAngles( angleToPlayer + Angle( 0, rotation, 0 ) )
        self.PreviewModel:SetModel( modelName )
        self.PreviewModel:SetNoDraw( false )
    end
end

-- Function to remove the model preview
function TOOL:Holster()
    if CLIENT then if IsValid( self.PreviewModel ) then self.PreviewModel:Remove() end end
end

if SERVER then
    local ServerSettings = ServerSettings or {}
    net.Receive( "uf_signal_settings", function()
        ServerSettings = net.ReadTable()
        if ServerSettings then
            print( "Relaying settings" )
            net.Start( "uf_signal_settings_client" )
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