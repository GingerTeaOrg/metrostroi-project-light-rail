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

	TOOL.ClientConVar[ "signal_type" ] = "Signal Type"
	TOOL.ClientConVar[ "signal_type" ] = "Overground_Large"
	TOOL.ClientConVar[ "horizontal_offset" ] = "0"
	TOOL.ClientConVar[ "vertical_offset" ] = "0"
	TOOL.ClientConVar[ "lateral_offset" ] = "0"
	TOOL.ClientConVar[ "signal_left" ] = "0"
	TOOL.ClientConVar[ "signal_rotation" ] = "0"
	TOOL.ClientConVar[ "Route1" ] = "Route 1 Data"
	TOOL.ClientConVar[ "Route1Switches" ] = "Route 1 Switch IDs"
	TOOL.ClientConVar[ "Route1SwitchSettings" ] = "Route1 Switch Settings"
	TOOL.ClientConVar[ "Route2" ] = "Route 2 Data"
	TOOL.ClientConVar[ "Route2Switches" ] = "Route 2 Switch IDs"
	TOOL.ClientConVar[ "Route2SwitchSettings" ] = "Route 2 Switch Settings"
	TOOL.ClientConVar[ "Route3" ] = "Route 3 Data"
	TOOL.ClientConVar[ "Route3Switches" ] = "Route 3 Switch IDs"
	TOOL.ClientConVar[ "Route3SwitchSettings" ] = "Route 3 Switch Settings"
	TOOL.ClientConVar[ "Route4" ] = "Route 4 Data"
	TOOL.ClientConVar[ "Route4Switches" ] = "Route 4 Switch IDs"
	TOOL.ClientConVar[ "Route4SwitchSettings" ] = "Route 4 Switch Settings"
	TOOL.ClientConVar[ "signal_name1" ] = "Iex"
	TOOL.ClientConVar[ "signal_name2" ] = "A1"
	TOOL.ClientConVar[ "multioccupation" ] = "0"
	TOOL.ClientConVar[ "mode" ] = 1
	TOOL.ClientConVar[ "selected_path" ] = -1
	TOOL.ClientConVar[ "start_node" ] = -1
	TOOL.ClientConVar[ "end_node" ] = -1
end

if SERVER then
	util.AddNetworkString( "uf_signal_settings" )
	util.AddNetworkString( "uf_signal_settings_client" )
	util.AddNetworkString( "metrostroi-lightrail-stool-signal-routes" )
	util.AddNetworkString( "metrostroi-lightrail-stool-signal-routes-clientToServer" )
	util.AddNetworkString( "metrostroi-lightrail-stool-signal-pathing-serverToClient" )
	util.AddNetworkString( "metrostroi-lightrail-stool-signal-pathing-clientToServer" )
end

local mode = mode or 1
TOOL.Paths = TOOL.Paths or {}
function TOOL:sendPathsToClient()
	if ( not self.SpatialLookup or table.IsEmpty( self.SpatialLookup ) ) and self.GetOwner and self:GetOwner() then
		net.Start( "metrostroi-lightrail-stool-signal-pathing-clientToServer" )
		net.WritePlayer( self:GetOwner() )
		net.SendToServer()
	else
		return TOOL.SpatialLookup
	end
end

if SERVER then --format: multiline
	net.Receive( "metrostroi-lightrail-stool-signal-pathing-clientToServer", function()
		local ply = net.ReadPlayer()
		net.Start( "metrostroi-lightrail-stool-signal-pathing-serverToClient" )
		net.WriteTable( Metrostroi.SpatialLookup )
		net.Send( ply )
	end )
end

--format: multiline
if CLIENT then
	net.Receive( "metrostroi-lightrail-stool-signal-pathing-serverToClient", function() TOOL.SpatialLookup = net.ReadTable() end )
end

TOOL.SpatialLookup = SERVER and Metrostroi.SpatialLookup or CLIENT and {}
function TOOL:Initialize()
	if CLIENT then RunConsoleCommand( "uf_signalling_signal_rotation", "0" ) end
end

function TOOL:DrawHUD()
	local ply = LocalPlayer()
	local playerAim = ply:EyeAngles():Forward()
	local targetClass = "gmod_track_uf_signal"
	local maxDistance = 1000 -- Set an appropriate max distance
	for _, ent in ipairs( ents.FindByClass( targetClass ) ) do
		if ent:IsValid() and ply:GetPos():DistToSqr( ent:GetPos() ) < maxDistance ^ 2 then
			local pos = ent:GetPos()
			local ang = ent:GetAngles()
			local direction = ( ent:GetPos() - ply:GetPos() ):GetNormalized()
			if direction:Dot( playerAim ) > 0.98 then render.DrawWireframeBox( pos, ang, Vector( 0, 40, 0 ), Vector( 40, 40, 40 ), Color( 255, 255, 255, 255 ), true ) end
		end
	end
end

-- Table of signal types with their respective models
local signalTypes = file.Find( "models/lilly/uf/signals/*.mdl", "GAME", "nameasc" )
-- The overground signals are in the same folder, but should be excluded and treated by a separate tool
local signalBlocklist = {
	[ "trafficlight_standard3lens.mdl" ] = true
}

local basePath = "models/lilly/uf/signals/"
-- Precaching signal models
if CLIENT then
	for _, modelPath in pairs( signalTypes ) do
		util.PrecacheModel( "models/lilly/uf/signals/" .. modelPath )
	end
end

local SPATIAL_CELL_WIDTH = 1024
local SPATIAL_CELL_HEIGHT = 256
-- Return spatial cell indexes for given XYZ
local function spatialPosition( pos )
	return math.floor( pos.x / SPATIAL_CELL_WIDTH ), math.floor( pos.y / SPATIAL_CELL_WIDTH ), math.floor( pos.z / SPATIAL_CELL_HEIGHT )
end

local function addLookup( node )
	local kx, ky, kz = spatialPosition( node.pos )
	TOOL.SpatialLookup[ kz ] = TOOL.SpatialLookup[ kz ] or {}
	TOOL.SpatialLookup[ kz ][ kx ] = TOOL.SpatialLookup[ kz ][ kx ] or {}
	TOOL.SpatialLookup[ kz ][ kx ][ ky ] = TOOL.SpatialLookup[ kz ][ kx ][ ky ] or {}
	table.insert( TOOL.SpatialLookup[ kz ][ kx ][ ky ], node )
end

-- Return list of nodes in spatial cell kx,ky,kz
local empty_table = {}
function TOOL:spatialNodes( kx, ky, kz )
	if self.SpatialLookup and self.SpatialLookup[ kz ] then
		if self.SpatialLookup[ kz ][ kx ] then
			return self.SpatialLookup[ kz ][ kx ][ ky ] or empty_table
		else
			return empty_table
		end
	else
		return empty_table
	end
end

function TOOL:NearestNodes( pos )
	local kx, ky, kz = spatialPosition( pos )
	local t = {}
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				table.insert( t, self:spatialNodes( kx + x, ky + y, kz + z ) )
			end
		end
	end

	local i, j = 0, 1
	return function()
		-- Find next set of nodes that's not empty
		while ( j <= #t ) and ( i >= #t[ j ] ) do
			j = j + 1
			i = 0
		end

		-- Should iterator end
		if j > #t then return nil end
		-- Iterate table like normal
		i = i + 1
		if i <= #t[ j ] then return t[ j ][ i ].id, t[ j ][ i ] end
	end
end

function TOOL:GetPositionOnTrack( pos, ang, opts )
	if not opts then opts = empty_table end
	-- Angle can be specified to determine if facing forward or backward
	ang = ang or Angle( 0, 0, 0 )
	-- Size of box which envelopes region of space that counts as being on track
	local X_PAD = 0
	local Y_PAD = opts and opts.y_pad or opts and opts.radius or 384 / 2
	local Z_PAD = opts and opts.z_pad or 256 / 2
	-- Find position on any track
	local results = {}
	for nodeID, node in self:NearestNodes( pos ) do
		-- Get local coordinate system of a section
		local forward = node.dir
		local up = Vector( 0, 0, 1 )
		local right = forward:Cross( up )
		-- Transform position into local coordinates
		local local_pos = pos - node.pos
		local local_x = local_pos:Dot( forward )
		local local_y = local_pos:Dot( right )
		local local_z = local_pos:Dot( up )
		local yz_delta = math.sqrt( local_y ^ 2 + local_z ^ 2 )
		-- Determine if facing forward or backward
		local local_dir = ang:Forward()
		local dir_delta = local_dir:Dot( forward )
		local dir_forward = dir_delta > 0
		local dir_angle = 90 - math.deg( math.acos( dir_delta ) )
		-- If this position resides on track, add it to results
		if ( ( local_x > -X_PAD ) and ( local_x < node.vec:Length() + X_PAD ) and ( local_y > -Y_PAD ) and ( local_y < Y_PAD ) and ( local_z > -Z_PAD ) and ( local_z < Z_PAD ) ) and ( opts and node.path ~= opts.ignore_path or true ) then
			table.insert( results, {
				node1 = node,
				node2 = node.next,
				path = node.path,
				angle = dir_angle, -- Angle between forward vector and axis of track
				forward = dir_forward, -- Is facing forward relative to track
				x = local_x * 0.01905 + node.x, -- Local coordinates in track curvilinear coordinates
				y = local_y * 0.01905, --
				z = local_z * 0.01905, --
				distance = yz_delta, -- Distance to path axis
			} )
		end
	end

	-- Sort results by distance
	table.sort( results, function( a, b ) return a.distance < b.distance end )
	-- Return list of positions
	return results
end

-- Function to build the settings pane
function TOOL.BuildCPanel( panel )
	local tool = tool or {}
	CreateClientConVar( "uf_signalling_signal_type", "Overground_Large" )
	CreateClientConVar( "uf_signalling_signal_rotation", "0", true )
	CreateClientConVar( "uf_signalling_signal_left", "0", true )
	--CreateClientConVar( "uf_signalling_signal_horizontal_offset", "0", true )
	--CreateClientConVar( "uf_signalling_signal_vertical_offset", "0", true )
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
		RunConsoleCommand( "uf_signalling_signal_name1", name1Value )
	end

	panel:AddPanel( signalName1Entry )
	-- Second text entry for bottom signal name
	local signalName2Entry = vgui.Create( "DTextEntry" )
	signalName2Entry:SetSize( 200, 25 )
	signalName2Entry:SetValue( signalName2 or "Bottom Signal Name Text" )
	signalName2Entry.OnEnter = function( self )
		local name2Value = self:GetValue() -- Use 'self' to get the text entry instance
		RunConsoleCommand( "uf_signalling_signal_name2", name2Value )
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
	--
	local leftCheckBox = panel:AddControl( "Checkbox", {
		Label = "Mount signal left or right hand side of track? (checked for left)",
	} )

	leftCheckBox.OnChange = function( self, bVal )
		local arg = bVal and "1" or "0"
		RunConsoleCommand( "uf_signalling_signal_left", arg )
	end

	local multiCheckBox = panel:AddControl( "Checkbox", {
		Label = "Does this signal allow for multiple trains to enter the block at caution?",
	} )

	multiCheckBox.OnChange = function( self, bVal )
		local arg = bVal and "1" or "0"
		RunConsoleCommand( "uf_signalling_multioccupation", arg )
	end

	local horizontalSlider = vgui.Create( "DNumSlider", panel )
	horizontalSlider:SetText( "Signal Prop Horizontal Offset" )
	horizontalSlider:SetMin( -45 )
	horizontalSlider:SetMax( 45 )
	horizontalSlider:SetDecimals( 1 )
	horizontalSlider:SetValue( rotation ) -- Initial rotation value
	horizontalSlider.OnValueChanged = function( value )
		local valString = tostring( value:GetValue() )
		print( value:GetValue() )
		RunConsoleCommand( "uf_signalling_horizontal_offset", valString )
	end

	panel:AddPanel( horizontalSlider )
	-------------------------------------------------
	local verticalSlider = vgui.Create( "DNumSlider", panel )
	verticalSlider:SetText( "Signal Prop Vertical Offset" )
	verticalSlider:SetMin( -45 )
	verticalSlider:SetMax( 45 )
	verticalSlider:SetDecimals( 1 )
	verticalSlider:SetValue( rotation ) -- Initial rotation value
	verticalSlider.OnValueChanged = function( value )
		local valString = tostring( value:GetValue() )
		RunConsoleCommand( "uf_signalling_vertical_offset", valString )
	end

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

	panel:AddPanel( submitButton )
	-- Apply settings button
	local ApplySettings = vgui.Create( "DButton", panel )
	ApplySettings:SetText( "Apply" )
	ApplySettings.DoClick = function()
		--net.Start( "uf_signal_settings" )
		--net.WriteTable( tool.Settings )
		--net.SendToServer()
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
local targetEnt = targetEnt or "nullEnt"
function TOOL:LeftClick( trace )
	if SERVER then
		if mode == 1 then
			self.Settings = ServerSettings
			--PrintTable( self.Settings, 1 )
			local ply = self:GetOwner()
			local trace = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 1000, -- Adjust the length based on how far you want to trace
				filter = { ply }
			} )

			local signalType = self:GetClientInfo( "signal_type" )
			local signalName1 = self:GetClientInfo( "signal_name1" )
			local signalName2 = self:GetClientInfo( "signal_name2" )
			local rotation = self:GetClientNumber( "signal_rotation" )
			local left = self:GetClientBool( "signal_left" )
			local horizontal = self:GetClientNumber( "horizontal_offset" )
			local vertical = self:GetClientNumber( "vertical_offset" )
			local ent = ents.Create( "gmod_track_uf_signal" )
			if not IsValid( ent ) then return false end
			ent.SignalType = signalTypes[ signalType ]
			-- Set the signal names before spawning the entity
			ent.Left = left
			PrintMessage( HUD_PRINTTALK, signalName1 )
			PrintMessage( HUD_PRINTTALK, signalName2 )
			ent.Name1 = signalName1
			ent.Name2 = signalName2
			ent:SetNW2String( "Name1", signalName1 )
			ent:SetNW2String( "Name2", signalName2 )
			ent.Routes = Routes
			local angleToPlayer = ( ply:GetShootPos() - trace.HitPos ):Angle()
			angleToPlayer.p = 0 -- Keep it upright by setting pitch to 0
			ent:SetAngles( angleToPlayer )
			ent:SetPos( trace.HitPos )
			ent:Spawn()
			undo.Create( "Signal" .. " " .. signalName1 .. "/" .. signalName2 )
			undo.AddEntity( ent )
			undo.SetPlayer( self:GetOwner() )
			undo.Finish()
			return true
		elseif mode == 2 then
			local ply = self:GetOwner()
			local playerPos = ply:GetPos()
			local targetClass = "gmod_track_uf_signal"
			local maxDistance = 1000
			if targetEnt == "nullEnt" then
				local targetList = ents.FindByClass( targetClass )
				for _, ent in ipairs( targetList ) do
					local entIsValid = ent:IsValid()
					local entPos = ent:GetPos()
					local entInRange = playerPos:DistToSqr( entPos ) < maxDistance ^ 2
					if entIsValid and entInRange then
						local direction = ( entPos - playerPos ):GetNormalized()
						if direction:Dot( playerAim ) > 0.98 then
							targetEnt = ent
						else
							ply:PrintMessage( HUD_PRINTTALK, "No signal entity found at aim vector!" )
						end
					end
				end
			end
		end
	elseif CLIENT then
		if mode == 2 then if not self.SpatialLookup then self:sendPathsToClient() end end
	end
end

--[[function TOOL:GetClientInfo( property )
	if self.ClientConVars[ property ] and CLIENT then return self.ClientConVars[ property ]:GetString() end
	return self:GetOwner():GetInfo( self:GetMode() .. "_" .. property )
end]]
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
		trace.Entity:SetNW2String( "Name1", signalName1 )
		trace.Entity:SetNW2String( "Name2", signalName2 )
		return true
	end
	return false
end

local lastSwitch = lastSwitch or 0
function TOOL:Reload()
	mode = self:GetClientNumber( "mode" )
	if mode == 1 and CurTime() - lastSwitch > 2 then
		lastSwitch = CurTime()
		RunConsoleCommand( "uf_signalling_mode", "2" )
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Switching to route editing mode." )
		return true
	elseif mode == 2 and CurTime() - lastSwitch > 2 then
		lastSwitch = CurTime()
		RunConsoleCommand( "uf_signalling_mode", "1" )
		self:GetOwner():PrintMessage( HUD_PRINTTALK, "Switching to signal spawning mode." )
		return true
	end
end

function TOOL:Think()
	mode = self:GetClientNumber( "mode", 1 )
	if CLIENT then
		print( self.Paths[ 1 ] )
		if mode == 1 then
			local ply = self:GetOwner()
			if not ply:IsAdmin() then
				ply:PrintMessage( HUD_PRINTTALK, "You're not a server admin. Bailing." )
				return false
			end

			local ClientSettings = ClientSettings or {}
			net.Receive( "uf_signal_settings_client", function() ClientSettings = net.ReadTable() end )
			self.Settings = ClientSettings
			if not self.Settings then
				--print( "NO SETTINGS" )
				return
			end

			if not IsValid( ply ) then
				--print( "No player" )
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
				--print( "No model sent, bailing out of preview function" )
				return
			end

			local rotation = self:GetClientNumber( "signal_rotation" )
			-- Spawn preview model if it doesn't exist
			if not IsValid( self.PreviewModel ) and mode == 1 then
				self.PreviewModel = ClientsideModel( modelName, RENDERGROUP_OPAQUE )
				self.PreviewModel:Spawn()
				self.PreviewModel:SetModel( modelName )
			end

			local left = self:GetClientBool( "signal_left" )
			local horizontal = self:GetClientNumber( "horizontal_offset" )
			local vertical = self:GetClientNumber( "vertical_offset" )
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
		elseif mode == 2 then
			if IsValid( self.PreviewModel ) then self.PreviewModel:Remove() end
		elseif mode == 3 then
			if IsValid( self.PreviewModel ) then self.PreviewModel:Remove() end
		end
	end
end

local last_request = last_request or 0
if CLIENT then
	function TOOL:DrawHUD()
		local owner = self:GetOwner()
		local tr = owner:GetEyeTrace()
		local traceLocal = ents.FindInSphere( tr.HitPos, 8 )
		local dist = owner:GetPos():Distance( tr.HitPos )
		cam.Start3D()
		for _, v in ipairs( traceLocal ) do
			if v:GetClass() == "gmod_track_uf_signal" and dist < 30 then render.DrawWireframeBox( v:GetPos(), Angle( 0, 0, 0 ), Vector( -10, 0, 0 ), Vector( 10, 10, 10 ), Color( 255, 0, 0 ), true ) end
		end

		if self.Paths and not table.IsEmpty( self.Paths ) then
			local hit = tr.Hit and tr.HitWorld
			print( tr.StartPos )
			local normal = tr.StartPos - tr.HitPos
			local trackPos = self:GetPositionOnTrack( tr.HitPos, normal:Angle() )
			local SelectedColor = Color( 255, 0, 0 )
			local DeSelectedColor = color_white
			for k, path in pairs( self.Paths ) do
				local lastnode = nil
				local colour = Either( k == trackPos.path, SelectedColor, DeSelectedColor )
				for _, node in pairs( path ) do
					-- draw a box if the hit position correlates with a track node
					if hit and trackPos.id == node.id and trackPos.path.id == node.path.id then render.DrawQuadEasy( trackPos.pos, trackpos.pos:Up(), 50, 50, SelectedColor, 0 ) end
					if lastnode then render.DrawLine( node, lastnode, colour, true ) end
					render.DrawWireframeSphere( node, 10, 2, 2, colour, true )
					lastnode = node
				end
			end
		end

		cam.End3D()
	end

	function TOOL:Deploy()
		if table.IsEmpty( self.Paths ) then
			net.Start( "metrostroi-lightrail-stool-signal-routes-clientToServer" )
			print( "Requesting pathing info" )
			net.WritePlayer( LocalPlayer() )
			net.SendToServer()
		end
	end
end

if SERVER then
	local sent = sent or {}
	local function sendPaths( index, ply )
		net.Start( "metrostroi-lightrail-stool-signal-routes" )
		net.WriteInt( index, 16 )
		net.WriteTable( Metrostroi.Paths[ index ] )
		net.Send( ply )
		return index
	end

	--FIXME: USE THIS AS REFERENCE: https://github.com/metrostroi-repo/MetrostroiAddon/blob/dev/lua/metrostroi/sv_trackeditor.lua https://github.com/metrostroi-repo/MetrostroiAddon/blob/dev/lua/metrostroi/cl_trackeditor.lua
	net.Receive( "metrostroi-lightrail-stool-signal-routes-clientToServer", function()
		local ply = net.ReadPlayer()
		print( "Sending pathing data to:", ply )
		local length = table.Count( Metrostroi.Paths )
		for i = 1, length do
			timer.Simple( 1, function() sendPaths( i, ply ) end )
		end
	end )
end

if CLIENT then
	net.Receive( "metrostroi-lightrail-stool-signal-routes", function()
		print( "reading pathing data" )
		index = net.ReadInt( 16 )
		TOOL.Paths[ index ] = net.ReadTable()
	end )
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
			--print( "Relaying settings" )
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
		local angles = entity:GetAngles()
		-- Set the wireframe color
		render.SetColorMaterial()
		render.DrawWireframeBox( position, angles, mins, maxs, Color( 255, 0, 0, 255 ), true )
	end
end