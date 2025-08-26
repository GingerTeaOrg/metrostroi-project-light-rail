TOOL.Category = "Metrostroi: Project Light Rail"
TOOL.Name = "Overground Signalling Tool"
TOOL.Command = nil
TOOL.ConfigName = ""
if SERVER then util.AddNetworkString"metrostroi-lightrail-stool-osignalling" end
TOOL.ClientConVar[ "name1" ] = ""
TOOL.ClientConVar[ "name2" ] = ""
TOOL.ClientConVar[ "HorizontalOffset" ] = 0
TOOL.ClientConVar[ "VerticalOffset" ] = 0
TOOL.ClientConVar[ "LateralOffset" ] = 0
TOOL.ClientConVar[ "Rotation" ] = 0
TOOL.ClientConVar[ "blockmode" ] = 0
TOOL.ClientConVar[ "columns" ] = 1
TOOL.ClientConVar[ "column_1_lenses" ] = "F0_F4_F1"
TOOL.ClientConVar[ "column_2_lenses" ] = "F0_F4_F1"
TOOL.ClientConVar[ "column_3_lenses" ] = "F0_F4_F1"
if CLIENT then
	language.Add( "Tool.uf_overground_signalling.name", "Overground Signalling" )
	language.Add( "Tool.uf_overground_signalling.desc", "Spawns Overground Tram Signals or edits their settings" )
	language.Add( "Tool.uf_overground_signalling.0", "Primary: Spawn\nSecondary: Copy settings" )
end

function TOOL:Think()
	if CLIENT then
		local ply = self:GetOwner()
		if not ply:IsAdmin() then
			ply:PrintMessage( HUD_PRINTTALK, "You're not a server admin. Bailing." )
			self:Holster()
			return false
		end

		local trace = util.TraceLine( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 1000,
			filter = { ply }
		} )

		if not IsValid( self.PreviewModel ) then
			self.PreviewModel = ClientsideModel( "models/lilly/mplr/signals/trafficlight/trafficlight_pole.mdl", RENDERGROUP_TRANSLUCENT )
			self.PreviewModel:Spawn()
		end

		if not trace.Hit then -- If the trace doesn't hit anything, return
			return
		end

		local horizontal = GetConVar( "uf_overground_signalling_HorizontalOffset" ):GetInt()
		local vertical = GetConVar( "uf_overground_signalling_VerticalOffset" ):GetInt()
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
	end
end

function TOOL:Holster()
	if CLIENT then self.PreviewModel:Remove() end
end

function TOOL:CreateGhostEntities()
	if not self.GhostEntities then self.GhostEntities = {} end
	local signalColumns = self:GetClientNumber( "uf_overground_signalling_columns", 1 )
	for i = 1, signalColumns do
		self.GhostEntities[ i ] = {}
	end
end

function TOOL:LeftClick( trace )
	local name1 = self:GetClientInfo( "name1" ) ~= "" and self:GetClientInfo( "name1" ) or nil
	local name2 = self:GetClientInfo( "name2" ) ~= "" and self:GetClientInfo( "name2" ) or nil
	local blockSignalling = self:GetClientNumber( "blockmode", 1 ) > 0
	local signalColumns = self:GetClientNumber( "columns", 1 )
	print( signalColumns )
	local horizontalOffset = self:GetClientNumber( "HorizontalOffset", 0 )
	local verticalOffset = self:GetClientNumber( "VerticalOffset", 0 )
	local lateralOffset = self:GetClientNumber( "LateralOffset", 0 )
	local rotation = self:GetClientNumber( "Rotation", 0 )
	if CLIENT then return true end
	local ply = self:GetOwner()
	if not IsValid( ply ) or not ply:IsAdmin() then return false end
	if not trace or ( trace.Entity and trace.Entity:IsPlayer() ) then return false end
	local entlist = ents.FindInSphere( trace.HitPos, 64 )
	local spawnNewEnt = true
	for _, v in pairs( entlist ) do
		if v:GetClass() == "gmod_track_uf_signal_overground" then
			ply:PrintMessage( HUD_PRINTTALK, "Updating existing signal" )
			-- update entity
			local columnString1 = self:GetClientInfo( "column_1_lenses" )
			local columnString2 = self:GetClientInfo( "column_2_lenses" )
			local columnString3 = self:GetClientInfo( "column_3_lenses" )
			local columnString1Processed = string.Explode( "_", columnString1 )
			local columnString2Processed = string.Explode( "_", columnString2 )
			local columnString3Processed = string.Explode( "_", columnString3 )
			local columnTab = {}
			for i = 1, 3 do
				local whichTab = i == 1 and columnString1Processed or i == 2 and columnString2Processed or i == 3 and columnString3Processed
				columnTab[ i ] = {}
				for _, v in ipairs( whichTab ) do
					if v ~= "" then -- ignore empties
						columnTab[ i ][ v ] = true
						print( columnTab[ i ][ v ] )
					end
				end
			end

			v.Lenses = columnTab
			v:SetNW2String( "column_1_lenses", self:GetClientInfo( "column_1_lenses" ) )
			v:SetNW2String( "columns_2_lenses", self:GetClientInfo( "column_2_lenses" ) )
			v:SetNW2String( "columns_3_lenses", self:GetClientInfo( "column_3_lenses" ) )
			v:SetNW2String( "Name1", name1 )
			v:SetNW2String( "Name2", name2 )
			v:SetNW2Bool( "BlockSignalling", blockSignalling )
			v:SetNW2Float( "SignalColumns", signalColumns )
			v:SetNW2Float( "HorizontalOffset", horizontalOffset )
			v:SetNW2Float( "VerticalOffset", verticalOffset )
			v:SetNW2Float( "LateralOffset", lateralOffset )
			v:SetNW2Float( "Rotation", rotation )
			v:SetNW2Bool( "RespawnLenses", true )
			v:SetNW2Bool( "RespawnLenses", false )
			spawnNewEnt = false
			break
		end
	end

	if spawnNewEnt then
		local newSignal = ents.Create( "gmod_track_uf_signal_overground" )
		local columnString1 = self:GetClientInfo( "column_1_lenses" )
		local columnString2 = self:GetClientInfo( "column_2_lenses" )
		local columnString3 = self:GetClientInfo( "column_3_lenses" )
		local columnString1Processed = string.Explode( "_", columnString1 )
		local columnString2Processed = string.Explode( "_", columnString2 )
		local columnString3Processed = string.Explode( "_", columnString3 )
		local columnTab = {}
		for i = 1, signalColumns do
			local whichTab = i == 1 and columnString1Processed or i == 2 and columnString2Processed or i == 3 and columnString3Processed
			columnTab[ i ] = {}
			for _, v in ipairs( whichTab ) do
				if v ~= "" then -- ignore empties
					columnTab[ i ][ v ] = true
					print( v, columnTab[ i ][ v ] )
				end
			end
		end

		newSignal:SetNW2String( "Column1Lenses", columnString1 )
		newSignal:SetNW2String( "Column2Lenses", columnString2 )
		newSignal:SetNW2String( "Column3Lenses", columnString3 )
		newSignal.Lenses = columnTab
		local angleToPlayer = ( trace.StartPos - trace.HitPos ):Angle()
		angleToPlayer.p = 0
		newSignal:SetNW2String( "Name1", name1 )
		newSignal:SetNW2String( "Name2", name2 )
		newSignal:SetNW2Bool( "BlockSignalling", blockSignalling )
		newSignal:SetNW2Int( "SignalColumns", signalColumns )
		newSignal:SetNW2Float( "HorizontalOffset", horizontalOffset )
		newSignal:SetNW2Float( "VerticalOffset", verticalOffset )
		newSignal:SetNW2Float( "LateralOffset", lateralOffset )
		newSignal:SetNW2Float( "Rotation", rotation )
		newSignal:SetPos( trace.HitPos )
		newSignal:SetAngles( angleToPlayer )
		newSignal:Spawn()
		undo.Create( "Overground Signal: " .. ( name1 or "N/A" ) .. "/" .. ( name2 or "N/A" ) )
		undo.AddEntity( newSignal )
		undo.SetPlayer( ply )
		undo.Finish()
	end
	return true
end

function TOOL.BuildCPanel( panel )
	panel = panel or controlpanel.Get( "uf_overground_signalling" )
	panel:SetName( "#Tool.switch.name" )
	panel:Help( "#Tool.switch.desc" )
	panel:TextEntry( "Primary Signal name", "uf_overground_signalling_name1" )
	panel:TextEntry( "Secondary Signal name", "uf_overground_signalling_name2" )
	panel:CheckBox( "Enable Block Signalling Mode", "uf_overground_signalling_blockmode" )
	local SignalColumns = panel:ComboBox( "How many Signals on the pole?", "uf_overground_signalling_columns" )
	SignalColumns:AddChoice( "1", 1 )
	SignalColumns:AddChoice( "2", 2 )
	SignalColumns:AddChoice( "3", 3 )
	panel:NumSlider( "HorizontalOffset", "uf_overground_signalling_HorizontalOffset", -50, 50, 1 )
	panel:NumSlider( "VerticalOffset", "uf_overground_signalling_VerticalOffset", -50, 50, 1 )
	panel:NumSlider( "LateralOffset", "uf_overground_signalling_LateralOffset", -50, 50, 1 )
	panel:NumSlider( "Rotation", "uf_overground_signalling_Rotation", -50, 50, 1 )
	panel:TextEntry( "Lenses for Signal 1", "uf_overground_signalling_column_1_lenses" )
	panel:TextEntry( "Lenses for Signal 2", "uf_overground_signalling_column_2_lenses" )
	panel:TextEntry( "Lenses for Signal 3", "uf_overground_signalling_column_3_lenses" )
end

net.Receive( "metrostroi-lightrail-stool-osignalling", function( _, ply )
	local TOOL = LocalPlayer and LocalPlayer():GetTool( "uf_overground_signalling" ) or ply:GetTool( "signalling" )
	RunConsoleCommand( "uf_overground_signalling_name1", net.ReadString() )
	RunConsoleCommand( "uf_overground_signalling_name2", net.ReadString() )
	RunConsoleCommand( "uf_overground_signalling_blockmode", net.ReadBool() and 1 or 0 )
	RunConsoleCommand( "uf_overground_signalling_columns", tonumber( net.ReadString(), 10 ) )
	RunConsoleCommand( "uf_overground_signalling_column_1_lenses", net.ReadString() )
	RunConsoleCommand( "uf_overground_signalling_column_2_lenses", net.ReadString() )
	RunConsoleCommand( "uf_overground_signalling_column_3_lenses", net.ReadString() )
end )