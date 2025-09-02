TOOL.Category = "Metrostroi: Project Light Rail"
TOOL.Name = "Switch Tool"
TOOL.Command = nil
TOOL.ConfigName = ""
if SERVER then util.AddNetworkString"metrostroi-lightrail-stool-switch" end
TOOL.ClientConVar[ "ID" ] = ""
TOOL.ClientConVar[ "left_path" ] = -1
TOOL.ClientConVar[ "right_path" ] = -1
TOOL.ClientConVar[ "allow_iron" ] = 1
if CLIENT then
	language.Add( "Tool.uf_switch.name", "Switch Tool" )
	language.Add( "Tool.uf_switch.desc", "Sets/edits switch parameters" )
	language.Add( "Tool.uf_switch.0", "Primary: Set settings\nSecondary: Copy settings" )
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end
	local ply = self:GetOwner()
	if ply:IsValid() and ( not ply:IsAdmin() ) then return false end
	if not trace then return false end
	if trace.Entity and trace.Entity:IsPlayer() then return false end
	local entlist = ents.FindInSphere( trace.HitPos, 64 )
	for k, v in pairs( entlist ) do
		if v:GetClass() == "gmod_track_uf_switch" then
			v.ID = self:GetClientInfo( "ID" ) ~= "" and self:GetClientInfo( "ID" ) or nil
			v.AllowSwitchingIron = self:GetClientNumber( "allow_iron" ) == 1
			if not v.DirectionsToPaths then v.DirectionsToPaths = {} end
			v.DirectionsToPaths[ "left" ] = self:GetClientNumber( "left_path" )
			v.DirectionsToPaths[ "right" ] = self:GetClientNumber( "right_path" )
			MPLR.SwitchPathIDsByDirection[ v ] = {
				[ "left" ] = v.DirectionsToPaths[ "left" ],
				[ "right" ] = v.DirectionsToPaths[ "right" ]
			}

			ply:PrintMessage( HUD_PRINTTALK, Format( "ID:%s || Left path is %s, Right path is %s || Switching Iron is %s allowed", self:GetClientInfo( "ID" ) ~= "" and self:GetClientInfo( "ID" ) or "nil", self:GetClientNumber( "left_path" ), self:GetClientNumber( "right_path" ), self:GetClientNumber( "allow_iron" ) == 0 and "not " or "" ) )
			return true
		end
	end
	return false
end

function TOOL:RightClick( trace )
	if CLIENT then return false end
	--[[
	local ply = self:GetOwner()
	if (ply:IsValid()) and (not ply:IsAdmin()) then return false end
	if not trace then return false end
	if trace.Entity and trace.Entity:IsPlayer() then return false end

	local entlist = ents.FindInSphere(trace.HitPos,64)
	for k,v in pairs(entlist) do
		if v:GetClass() == "gmod_track_switch" then
			v:SetChannel(2)
			print("Set channel 2")
		end
	end]]
	return false
end

--[[function TOOL:Reload( trace )
	if CLIENT then return true end
	local ply = self:GetOwner()
	if ply:IsValid() and ( not ply:IsAdmin() ) then return false end
	if not trace then return false end
	if trace.Entity and trace.Entity:IsPlayer() then return false end
	local entlist = ents.FindInSphere( trace.HitPos, 64 )
	for k, v in pairs( entlist ) do
		if v:GetClass() == "gmod_track_uf_switch" then
			net.Start( "metrostroi-lightrail-stool-switch" )
			net.WriteString( v.ID or "" )
			net.WriteBool( v.LockedSignal )
			net.WriteBool( not v.NotChangePos )
			net.WriteBool( v.Invertred )
			net.Send( ply )
			--if self:GetClientNumber("lock") == 1 then
			--if v.LockedSignal then v.LockedSignal = nil else v.LockedSignal = v.LastSignal end
			--print("Locked switch signal",v.LockedSignal)
			--else
			--not v.NotChangePos
			--print(v.NotChangePos and "Disabled" or "Enabled")
			--end
		end
	end
	return true
end]]
function TOOL.BuildCPanel( panel )
	panel = panel or controlpanel.Get( "uf_switch" )
	panel:SetName( "#Tool.switch.name" )
	panel:Help( "#Tool.switch.desc" )
	panel:TextEntry( "ID Number", "uf_switch_id" )
	panel:TextEntry( "Path on logical left", "uf_switch_left_path" )
	panel:TextEntry( "Path on logical right", "uf_switch_right_path" )
	--[[local CBChannel = panel:ComboBox( "Channel", "switch_channel" )
	CBChannel:AddChoice( "None", 0 )
	CBChannel:AddChoice( "1", 1 )
	CBChannel:AddChoice( "2", 2 )]]
	panel:CheckBox( "Allow manual switching via switching iron", "uf_switch_allow_iron" )
end

net.Receive( "metrostroi-lightrail-stool-switch", function( _, ply )
	local TOOL = LocalPlayer and LocalPlayer():GetTool( "uf_switch" ) or ply:GetTool( "uf_switch" )
	RunConsoleCommand( "uf_switch_ID", net.ReadString() )
	RunConsoleCommand( "uf_switch_left_path", tonumber( net.ReadString(), 10 ) )
	RunConsoleCommand( "uf_switch_right_path", tonumber( net.ReadString(), 10 ) )
	RunConsoleCommand( "uf_switch_allow_iron", net.ReadBool() and 1 or 0 )
end )