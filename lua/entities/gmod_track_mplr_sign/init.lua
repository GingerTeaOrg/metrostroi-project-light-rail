AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:Initialize()
	
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 0, 0, 0, 0 ) )
	local pos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )
	self.TrackPosition = pos[ 1 ]
	self.Forward = self.TrackPosition.forward
	self.Node = self.TrackPosition.node1
	
	self.Type = self.VMF and self.VMF.Type or "speed_40"
	if string.match( self.Type, "^speed", 1 ) == "speed" then
		self.NextSign = self:FindNextSpeedSign()
		self:SetSpeedLimitSection()
		print( "Speedlimit" )
	elseif string.match( self.Type, "start_of_block_operation", 1 ) == "start_of_block_operation" then
		self.NextSign = self:FindNextBlockEndSign()
		self:OpenBlockOperation()
	elseif string.match( self.Type, "end_of_block_operation", 1 ) == "end_of_block_operation" then
		self.NextSign = self:FindNextBlockStartSign()
		self:OpenBlockOperation()
	end

	util.PrecacheModel( self.BasePath .. "/" .. self.Type .. ".mdl" )
	if not self:GetNW2String( "Model" ) then self:SetNW2String( "Model", self.BasePath .. "/" .. self.Type .. ".mdl" ) end
end

function ENT:FindNextSpeedSign()
	if not self.TrackPosition then return end
	local sign = UF.ScanTrackForEntity( "gmod_track_mplr_sign", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
	local signal = UF.ScanTrackForEntity( "gmod_track_uf_signal", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
	return sign or signal or nil
end
function ENT:FindNextBlockEndSign()
	if not self.TrackPosition then return end
	local sign = UF.ScanTrackForEntity( "gmod_track_mplr_sign", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "end_of_block_operation", true )
	return sign or nil
end
function ENT:FindNextBlockStartSign()
	if not self.TrackPosition then return end
	local sign = UF.ScanTrackForEntity( "gmod_track_mplr_sign", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "start_of_block_operation", true )
	return sign or nil
end
function ENT:SetSpeedLimitSection()
	local speedVar = self.Type
	local forward = self.Forward
	local k_v = {}
	print( self.NextSign )

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
		self:RecursiveNodes( self.Node, self.Node.next, k_v ) --if there's no sign ahead, just write the speed restriction until the end
	else
		UF.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
	end
end
function ENT:RecursiveNodes( node, nextNode, k_v )
	for k, v in pairs( k_v ) do
		node[ k ] = v
	end

	if forward and nextNode then
		self:RecursiveNodes( nextNode, nextNode.next )
	elseif not nextNode then
		for k, v in pairs( k_v ) do
			node[ k ] = v
		end
	elseif not forward and nextNode then
		self:RecursiveNodes( nextNode, nextNode.prev )
	end
end

function ENT:OpenBlockOperation()
	local k_v = {
		indusi = true
	}
	if not node then return end
	UF.WriteToNodeTable( self.Node, self.NextSign.Node, self.Forward, k_v )
end

function ENT:CloseBlockOperation()
	local k_v = {
		indusi = false
	}
	if not node then return end
	UF.WriteToNodeTable( self.Node, self.NextSign.Node, self.Forward, k_v )
end