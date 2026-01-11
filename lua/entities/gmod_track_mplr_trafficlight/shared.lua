-- Copyright © Platunov I. M., 2020 All rights reserved
-- Modified for M:PLR based on Trolleybus GitHub Release under CC BY-NC-SA 4.0
ENT.PrintName = "Traffic Light"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
function ENT:LightType( type )
	return Trolleybus_System.TrafficLightTypes[ type or self:GetType() ]
end

function ENT:GetLense( num )
	if self:GetDisabled() then return "nolense" end
	local id = self[ "GetLense" .. num ]( self )
	return Trolleybus_System.TrafficLightLenseIDs[ id ] or "nolense"
end

function ENT:GetLenseData( num )
	local lense = self:GetLense( num )
	local ldata = Trolleybus_System.TrafficLightLenses[ lense ]
	if not ldata then
		lense = "nolense"
		ldata = Trolleybus_System.TrafficLightLenses[ lense ]
	end
	return lense, ldata
end

hook.Add( "CanProperty", "Trolleybus_System_TrafficLightEnts", function( ply, property, ent ) if ent:GetClass() == "trolleybus_trafficlight" or Trolleybus_System.NetworkSystem.GetNWVar( ent, "TrafficLight" ) then return false end end )
local tools = {
	trolleytrafficeditor = true,
	trolleytrafficlighteditor = true
}

hook.Add( "CanTool", "Trolleybus_System_TrafficLightEnts", function( ply, tr, toolname, tool, button ) if IsValid( tr.Entity ) and ( tr.Entity:GetClass() == "trolleybus_trafficlight" or Trolleybus_System.NetworkSystem.GetNWVar( tr.Entity, "TrafficLight" ) ) and not tools[ toolname ] then return false end end )