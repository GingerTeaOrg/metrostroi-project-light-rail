AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "flux.lua" )
include( "shared.lua" )
util.AddNetworkString( "mplr-signal-server" )
util.AddNetworkString( "mplr-signal-client" )
util.AddNetworkString( "mplr-signal-state" )
function ENT:Initialize()
	self.SignalType = self.SignalType or self.SignalTypes[ "Underground_Small_Pole" ]
	--print( self.SignalType )
	self.Aspect = "Sh3d"
	self:SetNW2String( "Type", self.SignalType )
	self:SetNW2String( "Aspect", self.Aspect )
	self.Angle = self.Angle or Angle( 0, 0, 0 )
	self:SetNW2Angle( "WorldAngle", self.Angle )
	self:SetModel( "models/props_trainstation/payphone_reciever001a.mdl" )
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
end

util.AddNetworkString( "RespawnSignal" )
function ENT:UpdateSignalAspect()
	for k, _ in pairs( MPLR.SignalBlocks ) do
		local CurrentBlock = MPLR.SignalBlocks[ k ]
		local function GetSignals()
			for ky, val in pairs( CurrentBlock ) do
				if type( ky ) == "string" then return ky, val end
			end
		end

		local CurrentSignal, DistantSignal = GetSignals()
		if CurrentSignal ~= self.Name then continue end
		local _, DistantSignalEnt = Metrostroi.SignalEntitiesByName[ CurrentSignal ], Metrostroi.SignalEntitiesByName[ DistantSignal ]
		if not IsValid( DistantSignalEnt ) then
			self.Aspect = "Sh3d"
			return
		end

		local DistantAspect = DistantSignalEnt.Aspect
		self.Occupied = CurrentBlock.Occupied
		local Occupied = self.Occupied
		--print(self.Name,self.Aspect,self.Occupied,self.TrackPosition.forward)
		if not Occupied then
			if DistantAspect == "H0" then --if next signal is danger, we display caution
				self.Aspect = "H2"
			elseif DistantAspect == "H2" then
				--if next signal is caution, we can display clear
				self.Aspect = "H1"
			elseif DistantAspect == "H1" then
				--if next signal is clear, we're also clear
				self.Aspect = "H1"
			end
		elseif Occupied then
			self.Aspect = "H0"
		end
	end
end

function ENT:OnRemove()
	MPLR.UpdateSignalEntities()
end

function ENT:GetSpeedLimit()
end

function ENT:Think()
	self:NextThink( CurTime() )
	if not self.Library and IsValid( self ) then
		self.Library = MPLR.SignalLib:New( self )
		return true
	elseif not self.Library and not IsValid( self ) then
		return true
	end

	self.Library:Think()
	--print( "thinking" )
	--self:UpdateSignalAspect()
	--self:SetNW2String( "Type", self.SignalType )
	self:SetNW2String( "Aspect", self.Aspect )
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