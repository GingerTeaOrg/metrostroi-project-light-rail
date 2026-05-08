AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "flux.lua" )
include( "shared.lua" )
util.AddNetworkString( "mplr-signal-server" )
util.AddNetworkString( "mplr-signal-client" )
util.AddNetworkString( "mplr-signal-state" )
function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/scenery/trackside/signage/block_operation.mdl" )
	self.SignalType = self.SignalType or self.SignalTypes[ "Underground_Small_Pole" ]
	----print( self.SignalType )
	self.Aspect = "Sh3d"
	self:SetNW2String( "Type", self.SignalType )
	self:SetNW2String( "Aspect", self.Aspect )
	self.Angle = self.Angle or Angle( 0, 0, 0 )
	self:SetNW2Angle( "WorldAngle", self.Angle )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 0, 0, 0, 0 ) )
	self.TrackPosition = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.Node = self.TrackPosition.node1
	self.SpeedLimit = 0
	self.Name1 = self.Name1 or " "
	self.Name2 = self.Name2 or " "
	self.Routes = self.Routes or {}
	--if self.Name1 and self.Name1 ~= " " then self:SetNW2String( "Name1", self.Name1 ) end
	--if self.Name2 and self.Name2 ~= " " then self:SetNW2String( "Name2", self.Name2 ) end
	self.LastPVSTracking = 0
	self.Library = MPLR.SignalLib:New( self )
	print( "SignalLib at init:", MPLR.SignalLib )
end

util.AddNetworkString( "RespawnSignal" )
function ENT:UpdateSignalAspect()
	local state = self.Library:ReturnSignalState()
	local stateMap = {
		danger = "H0",
		doubleOccupation = "H3",
		caution = "H2",
		clear = "H1",
		emergency = "Sh3d"
	}

	self.Aspect = stateMap[ state ]
	self:SetNW2String( "Aspect", self.Aspect )
end

function ENT:OnRemove()
	MPLR.UpdateSignalEntities()
end

function ENT:GetSpeedLimit()
end

function ENT:Think()
	self:NextThink( CurTime() )
	if not self.Library then
		--print( "nolib" )
		return true
	end

	self.Library:Think()
	self:UpdateSignalAspect()
	--self:SetNW2String( "Type", self.SignalType )
	return true
end

--Net functions
--Send update, if parameters have been changed
function ENT:SendUpdate( ply )
	net.Start( "mplr-signal-server" )
	net.WriteEntity( self )
	net.WriteTable( self.Routes )
	net.WriteBool( true )
	net.SendPVS( self:GetPos() )
end

function ENT:SetSpeedLimitSection()
	local speedVar = self.Type
	local forward = self.Forward
	local k_v = {}
	local speedSectorLimit = MPLR.ScanTrackForEntity( "gmod_track_uf_signal", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
	local function recursiveNodes( node, nextNode )
		for k, v in pairs( k_v ) do
			node[ k ] = v
		end

		if forward and nextNode then
			recursiveNodes( nextNode, nextNode.next )
		elseif not nextNode then
			for k, v in pairs( k_v ) do
				node[ k ] = v
			end
		elseif not forward and nextNode then
			recursiveNodes( nextNode, nextNode.prev )
		end
	end

	if forward and self.Type ~= "speed_clear" then
		k_v = {
			speed_forward = string.sub( speedVar, #speedVar - 2, #speedVar )
		}
	elseif not forward and self.Type ~= "speed_clear" then
		k_v = {
			speed_backward = string.sub( speedVar, #speedVar - 2, #speedVar )
		}
	elseif forward then
		k_v = {
			speed_forward = nil
		}
	else
		k_v = {
			speed_backward = nil
		}
	end

	if not self.NextSign then
		recursiveNodes( self.Node, self.Node.next )
	else
		MPLR.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
	end
end

--On receive update request, we send update
net.Receive( "mplr-signal-client", function( _, ply )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or not ent.SendUpdate then return end
	ent:SendUpdate( ply )
end )

function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end