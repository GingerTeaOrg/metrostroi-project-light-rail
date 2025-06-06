AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString"uf-signal"
util.AddNetworkString"uf-signal-state"
function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/signals/trafficlight/trafficlight_pole.mdl" )
	--self:PhysicsInit( SOLID_VPHYSICS )
	self.BlockMode = self.VMF and self.VMF.Blockmode > 0 or self:GetNW2Bool( "BlockMode", false )
	self.Lenses = self.DefaultLenses
	self.Columns = self.VMF and self.VMF.Columns or self:GetNW2Int( "Columns", 1 )
	self.TrackPosition = UF.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.Aspect = {
		[ 1 ] = "F1",
		[ 2 ] = "F4",
		[ 3 ] = "A1_F0"
	}

	self.Name1 = self.Name1 or self:GetNW2Bool( "Name1", "ER" )
	self.Name2 = self.Name2 or self:GetNW2Bool( "Name2", "ER" )
	self.Name = self.Name1 .. "/" .. self.Name2
	self.Node = self.TrackPosition.node1
	self.Forward = self.TrackPosition.forward
	self.Path = self.Node.path.id
	self.FailureIndex = 0
	self.SimulateFailedToRegister = false
	self.NextSwitch = -1
	util.AddNetworkString( "UpdateOvergroundSignal" )
end

function ENT:SendLensUpdate()
	local pos = pos or self:GetPos()
	net.Start( "UpdateOvergroundSignal" )
	net.WriteEntity( self )
	net.WriteTable( self.Lenses )
	net.SendPVS( pos ) -- formerly net.Broadcast() but why send it to all clients when not all of them can see it?
end

function ENT:FailToRegisterSim()
	self.FailureIndex = math.random( 0, 90 )
	self.SimulateFailedToRegister = not self.SimulateFailedToRegister and self.FailureIndex > 60 or self.SimulateFailedToRegister
end

function ENT:ParseLenses( str )
	if true then -- todo enable this function again and rework it to work with tables
		return
	end

	if not str or #str < 2 then return end
	local result = {}
	-- Use pattern matching to split by space, dash, or underscore
	for token in string.gmatch( str, "[^%s%-%_]+" ) do
		result[ string.lower( token ) ] = true
	end

	if #result < 1 then print( "Signal:", self.SignalName, "has not found any lenses to spawn." ) end
	return result
end

function ENT:Think()
	self.TrackPosition = self.TrackPosition or UF.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.Node = self.Node or self.TrackPosition.node1
	if self.BlockMode then
		self:BlockModeSignalling()
	else
		self:FailToRegisterSim()
		self:OnSightSignalling()
	end

	--timer.Simple( 4, function() self.SendSignalStateToClient( self ) end )
	self:SendSignalStateToClient( self )
	self:NextThink( CurTime() + 1 )
	return true
end

local nodes_traversed = 0
local max_nodes = 10
function ENT:FindNextSwitch( node )
	if not node then
		print( "NODE INVALID! QUITTING!!" )
		return
	end

	if nodes_traversed and nodes_traversed == max_nodes then
		print( "Maximum of nodes traversed without findings. Quitting" )
		return
	end

	local forward = not self.Forward
	local foundSwitch = UF.SwitchEntitiesByNode[ node ]
	local branch = node.branches and node.branches[ 1 ][ 2 ]
	--print( node.id )
	--print( branch )
	local function getNextNode()
		if not node then return end
		if forward and node.next then -- direction is forward and next node found
			return node.next
		elseif not forward and node.prev then
			-- direction is backward and previous node found
			return node.prev
		elseif forward and not node.next and branch then
			-- direction is forward and no next node but branch is found
			return branch
		elseif not forward and not node.prev and branch then
			-- direction is backward and no previous node but branch is found
			return branch
		end
	end

	if foundSwitch and IsValid( foundSwitch ) then
		print( "Overground Signal found switch", self.Name, self, foundSwitch )
		return foundSwitch
	end

	local nextNode = getNextNode()
	if not foundSwitch and forward then
		nodes_traversed = nodes_traversed + 1 or 1
		return self:FindNextSwitch( nextNode )
	elseif not foundSwitch and not forward then
		nodes_traversed = nodes_traversed + 1 or 1
		return self:FindNextSwitch( nextNode )
	end
end

function ENT:AdditionalAspect( column )
	local additionalLenses = {
		[ "So14" ] = true,
		[ "A1" ] = true
	}

	local prepareToDepartSignal = false
	local returnLenses
	for lens in pairs( self.Lenses[ column ] ) do
		if additionalLenses[ lens ] and self.TrainIsRegistered then returnLenses = "So14" end
		if additionalLenses[ lens ] and lens == "A1" then
			if not returnLenses then
				returnLenses = "A1"
			else
				returnLenses = returnLenses .. "_" .. "A1"
			end
		end
	end
	return returnLenses
end

function ENT:OnSightSignalling()
	self.NextSwitch = type( self.NextSwitch ) ~= "number" and self.NextSwitch or self:FindNextSwitch( self.Node )
	if not self.NextSwitch or not IsValid( self.NextSwitch ) then return end
	local switchOrientationLeft = self.NextSwitch.Left == "alt" or "main"
	local switchStatusAlternate = self.NextSwitch.AlternateTrack == true
	local switchPointsTo = switchOrientationLeft == "alt" and switchStatusAlternate and "left" or switchOrientationLeft == "main" and not switchStatusAlternate and "left" or "right"
	local signalsToDirections = {
		[ "F1" ] = "left_right",
		[ "F2" ] = "right",
		[ "F3" ] = "left",
		[ "F5" ] = "left_right"
	}

	for column, lensTab in ipairs( self.Lenses ) do
		local aAspect = self:AdditionalAspect( column )
		for lens in pairs( lensTab ) do
			if signalsToDirections[ lens ] then
				if lens ~= "F1" then
					local switchToAspect = string.find( signalsToDirections[ lens ], switchPointsTo ) and lens or "F0"
					--print( signalsToDirections[ lens ] )
					--print( switchToAspect )
					if switchToAspect then self.Aspect[ column ] = switchToAspect end
					--print( lens, self.Aspect[ column ], column, switchToAspect )
				else
					local switchToAspect = ( switchPointsTo == "left" and switchOrientationLeft == "main" or switchPointsTo == "right" and switchOrientationLeft == "alt" ) and "F1" or "F0"
					self.Aspect[ column ] = switchToAspect
				end
			end

			if aAspect then self.Aspect[ column ] = self.Aspect[ column ] .. "_" .. aAspect end
		end
	end
end

function ENT:BlockModeSignalling()
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end