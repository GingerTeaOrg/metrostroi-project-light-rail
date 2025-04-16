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
	self:DrawShadow( false )
	print( self:GetNW2String( "Type", "speed_40" ) )
	local pos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )
	self.TrackPosition = pos[ 1 ]
	self.Forward = self.TrackPosition.forward
	self.Node = self.TrackPosition.node1
	if self.VMF and self.VMF.Type then self:SetNW2String( "Type", self.VMF.Type ) end
	self.Type = self.Type or self.VMF and self.VMF.Type or self:GetNW2String( "Type", "speed_40" )
	if string.match( self.Type, "speed", 1 ) then
		self.NextSign = self:FindNextSpeedSign()
		self:SetSpeedLimitSection()
		print( "Speedlimit" )
	elseif string.match( self.Type, "start_of_block_operation", 1 ) then
		self.NextSign = self:FindNextBlockEndSign()
		self:OpenBlockOperation()
	elseif string.match( self.Type, "end_of_block_operation", 1 ) then
		self.NextSign = self:FindNextBlockStartSign()
		self:CloseBlockOperation()
	elseif string.find( self:GetName(), "marker" ) then
		self:StopMarker()
	end
end

function ENT:FindNextSpeedSign()
	if not self.TrackPosition then return end
	local sign = UF.ScanTrackForEntity( "gmod_track_mplr_sign", self.Node, false, self.Forward, nil, true, "Type", "speed", true )
	local signal = UF.ScanTrackForEntity( "gmod_track_uf_signal", self.Node, false, self.Forward, nil, true, "Type", "speed", true )
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
	local speedVar = string.match( self.Type, "%d+" )
	local forward = self.Forward
	local k_v = {}
	if forward and self.Type ~= "speed_clear" then
		k_v = {
			speed_forward = tonumber( speedVar, 10 )
		}
	elseif not forward and self.Type ~= "speed_clear" then
		k_v = {
			speed_backward = tonumber( speedVar, 10 )
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

util.AddNetworkString( "RespawnSign" )
function ENT:Think()
	local rF = RecipientFilter( false ) -- TODO: test if this needs to be reliable or unreliable
	local pvsTab = next( pvsTab ) and pvsTab or {}
	local plyTab = player.GetAll()
	for _, ply in ipairs( plyTab ) do
		pvsTab[ ply ] = self:TestPVS( ply )
	end

	for ply, bool in pairs( pvsTab ) do
		if bool then rF:AddPlayer( ply ) end
	end

	net.Start( "RespawnSign" )
	net.WriteEntity( self )
	net.WriteBool( true )
	net.Send( rF )
	self:NextThink( CurTime() + 1 )
end

function ENT:OnRemove()
	local k_v = {}
	if string.match( self.Type, "speed", 1 ) then
		if forward then
			k_v = {
				speed_forward = nil
			}
		else
			k_v = {
				speed_backward = nil
			}
		end
	elseif string.match( self.Type, "start_of_block_operation" ) then
		k_v = {
			indusi = false
		}
	end
end

function ENT:RecursiveNodes( node, nextNode, k_v, forward )
	if not node then -- Safeguard for missing nodes
		return
	end

	for k, v in pairs( k_v ) do
		node[ k ] = v
	end

	if forward and nextNode then
		return self:RecursiveNodes( nextNode, nextNode.next, k_v, forward )
	elseif not forward and nextNode then
		return self:RecursiveNodes( nextNode, nextNode.prev, k_v, forward )
	end
end

function ENT:OpenBlockOperation()
	local k_v = {
		indusi = true
	}

	local node = self.TrackPosition.node1
	if not node then
		print( "MPLRSign: Node invalid, not writing 'start of block operation'" )
		return
	end

	print( "MPLR: Writing 'start of block operation'...", self )
	if not self.NextSign then
		self:RecursiveNodes( self.Node, self.Node.next, k_v ) --if there's no sign ahead, just write the info until the end
	else
		UF.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
	end
end

function ENT:CloseBlockOperation()
	local k_v = {
		indusi = false
	}

	local node = self.TrackPosition.node1
	if not node then return end
	print( "MPLR: Writing 'end of block operation'...", self )
	if not self.NextSign then
		self:RecursiveNodes( self.Node, self.Node.next, k_v ) --if there's no sign ahead, just write the info until the end
	else
		UF.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
	end
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