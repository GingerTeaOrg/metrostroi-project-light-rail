AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:Initialize()
	--self:SetModel(self.VMF and self.BasePath .. "/" .. self.Types[self.VMF.Type] .. ".mdl" or self.BasePath .. "/" .. self.Types["Speed 40km/h"] .. ".mdl")
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 0, 0, 0, 0 ) )
	local pos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )
	self.TrackPosition = pos[ 1 ]
	self.Forward = self.TrackPosition.forward
	self.Node = self.TrackPosition.node1
	self.NextSign = self:FindNextSign()
	self.Type = self.VMF and self.VMF.Type or "speed_40"
	if string.match( self.Type, "^speed", 1 ) == "speed" then
		self:SetSpeedLimitSection()
		print( "Speedlimit" )
	end

	util.PrecacheModel( self.BasePath .. "/" .. self.Type .. ".mdl" )
	if not self:GetNW2String( "Model" ) then self:SetNW2String( "Model", self.BasePath .. "/" .. self.Type .. ".mdl" ) end
end

function ENT:FindNextSign()
	if not self.TrackPosition then return end
	local sign = UF.ScanTrackForEntity( "gmod_track_mplr_sign", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
	local signal = UF.ScanTrackForEntity( "gmod_track_uf_signal", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
	return sign or signal or nil
end

function ENT:SetSpeedLimitSection()
	local speedVar = self.Type
	local forward = self.Forward
	local k_v = {}
	print( self.NextSign )
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

	if forward and not self.Type ~= "speed_clear" then
		k_v = {
			speed_forward = string.sub( speedVar, #speedVar - 2, #speedVar )
		}
	elseif not forward and not self.Type ~= "speed_clear" then
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
		recursiveNodes( self.Node, self.Node.next ) --if there's no sign ahead, just write the speed restriction until the end
	else
		UF.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
	end
end