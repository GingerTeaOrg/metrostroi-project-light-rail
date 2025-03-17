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
	if self.VMF.Type then self:SetNW2String( "Type", self.VMF.Type ) end
	self.Type = self.Type or self.VMF and self.VMF.Type or self:GetNW2String( "Type", "speed_40" )
	if string.match( self.Type, "^speed", 1 ) == "speed" then
		self.NextSign = self:FindNextSpeedSign()
		self:SetSpeedLimitSection()
		print( "Speedlimit" )
	elseif string.match( self.Type, "^start_of_block_operation", 1 ) == "start_of_block_operation" then
		self.NextSign = self:FindNextBlockEndSign()
		self:OpenBlockOperation()
	elseif string.match( self.Type, "end_of_block_operation", 1 ) == "end_of_block_operation" then
		self.NextSign = self:FindNextBlockStartSign()
		self:OpenBlockOperation()
	elseif string.find( self:GetName(), "marker" ) then
		self:StopMarker()
	end
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
	return IsValid( sign ) and sign or nil
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

function ENT:Think()
	--print( self.Type )
end

function ENT:RecursiveNodes( node, nextNode, k_v, forward )
	if not node then -- Safeguard for missing nodes
		return
	end

	for k, v in pairs( k_v ) do
		node[ k ] = v
	end

	if forward and nextNode then
		self:RecursiveNodes( nextNode, nextNode.next, k_v, forward )
	elseif not forward and nextNode then
		self:RecursiveNodes( nextNode, nextNode.prev, k_v, forward )
	end
end

function ENT:OpenBlockOperation()
	local k_v = {
		indusi = true
	}

	if not node then
		print( "MPLRSign: Node invalid, not writing 'start of block operation'" )
		return
	end

	print( "MPLR: Writing 'start of block operation'...", self )
	UF.WriteToNodeTable( self.Node, self.NextSign.Node, self.Forward, k_v )
end

function ENT:CloseBlockOperation()
	local k_v = {
		indusi = false
	}

	if not node then return end
	UF.WriteToNodeTable( self.Node, self.NextSign.Node, self.Forward, k_v )
end

function ENT:StopMarker()
	-- expected format for mappers: station001_platform1_h1
	local name = string.Split( self:GetName(), "_" )
	local station = string.sub( name[ 1 ], 1, #"station" )
	local platform = string.sub( name[ 2 ], 1, #"platform" )
	local myType = name[ 3 ]
	if not tonumber( station, 10 ) then
		print( self:GetName() .. ":", "STOP MARKER NAME INCORRECTLY FORMATTED!!" )
		return
	end

	local stationTab = UF.StationEntsByIndex[ station ]
	if not next( stationTab ) then
		print( "ERROR: STATION INDEX " .. station .. "NOT FOUND!!" )
		return
	end

	if not stationTab[ platform ] then
		print( "ERROR: Platform Index " .. platform .. " of station" .. station .. " not found!!" )
		return
	end

	k_v = {}
	k_v[ myType ] = self:GetPos()
	table.Merge( stationTab[ platform ], k_v, true )
end