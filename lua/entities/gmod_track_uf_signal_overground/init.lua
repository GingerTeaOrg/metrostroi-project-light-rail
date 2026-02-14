AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString( "uf-signal" )
util.AddNetworkString( "uf-signal-state" )
util.AddNetworkString( "UpdateOvergroundSignal" )
function ENT:Initialize()
	self:SetModel( "models/lilly/mplr/signals/trafficlight/trafficlight_pole.mdl" )
	--self:PhysicsInit( SOLID_VPHYSICS )
	self.BlockMode = ( self.VMF and self.VMF.Blockmode > 0 ) or self:GetNW2Bool( "BlockMode", false )
	self.TrafficlightMode = self.TrafficlightMode or self.VMF and self.VMF.TrafficlightMode > 0 or self:GetNW2Bool( "TrafficlightMode", false )
	self.PriorityParameters = self.PriorityParameters or {}
	self.PriorityGiven = false
	self.Lenses = self.Lenses or self.DefaultLenses
	self.Columns = self.VMF and self.VMF.Columns or self:GetNW2Int( "Columns", 1 )
	self.TrackPosition = MPLR.GetPositionOnTrack( self:GetPos() - Vector( 0, 0, -10 ), self:GetAngles() )[ 1 ]
	self.Aspect = {}
	for i = 1, self.Columns do
		self.Aspect[ i ] = "F0"
	end

	self.Name1 = self:GetNW2String( "Name1", self.Name1 or "ER" )
	self.Name2 = self:GetNW2String( "Name2", self.Name2 or "ER" )
	self.Name = self.Name1 .. "/" .. self.Name2
	self.Node = self.TrackPosition.node1
	self.Forward = self.TrackPosition.forward
	self.Path = self.Node.path.id
	self.FailureIndex = 0
	self.SimulateFailedToRegister = false
	self.TrainRegistered = true
	self.NextSwitch = -1
	self.FailedToFindSwitch = false
	self:SendLensUpdate()
end

function ENT:SendLensUpdate()
	local pos = pos or self:GetPos()
	net.Start( "UpdateOvergroundSignal" )
	net.WriteEntity( self )
	net.WriteTable( self.Lenses )
	net.SendPVS( pos ) -- formerly net.Broadcast() but why send it to all clients when not all of them can see it?
end

function ENT:FailToRegisterSim()
	self.FailureIndex = math.random( 0, 100 )
	self.SimulateFailedToRegister = not self.SimulateFailedToRegister and self.FailureIndex >= 90 or self.SimulateFailedToRegister
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
	self.LastTrainCheck = self.LastTrainCheck or CurTime()
	self.TrackPosition = self.TrackPosition or Metrostroi.GetPositionOnTrack( self:GetPos() - Vector( 0, 0, -5 ), self:GetAngles() )[ 1 ]
	if not self.TrackPosition then
		--PrintMessage( HUD_PRINTTALK, "No trackpos" )
		--print( "exit" )
		return
	end

	self.Node = self.Node or self.TrackPosition.node1
	if self.BlockMode then
		--print( "Running block signalling" )
		self:BlockModeSignalling()
	else
		self:DetectTrainArrived()
		self:OnSightSignalling()
	end

	--timer.Simple( 4, function() self.SendSignalStateToClient( self ) end )
	self:SendSignalStateToClient( self )
	self:NextThink( CurTime() )
	return true
end

local nodes_traversed = 0
local max_nodes = 10
function ENT:FindNextSwitch( node )
	if not node then
		print( "NODE INVALID! QUITTING!!" )
		return
	end

	if self.FailedToFindSwitch then -- avoid spamming the console with repeat attempts!
		return
	end

	if nodes_traversed and nodes_traversed == max_nodes then
		print( "Maximum of nodes traversed without findings. Quitting" )
		self.FailedToFindSwitch = true
		return
	end

	local forward = not self.Forward
	local foundSwitch = MPLR.SwitchEntitiesByNode[ node ]
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

function ENT:DetectTrainArrived()
	local forward = self.TrackPosition.forward
	local x = self.TrackPosition.x
	-- safer calculation
	local scanStart, scanEnd
	if forward then
		scanStart = x
		scanEnd = x - 5 -- look ahead 30m
	else
		scanStart = x
		scanEnd = x + 5 -- look behind 30m
	end

	local occupied, firstTrain, lastTrain, trainList = MPLR.IsTrackOccupied( self.TrackPosition.node1, scanStart, forward, nil, scanEnd )
	local targetTrain
	--print( lastTrain )
	if lastTrain and not lastTrain.IBIS then
		for _, train in ipairs( trainList ) do
			if train.IBIS then
				targetTrain = train
				break
			end
		end
	else
		if IsValid( lastTrain ) and lastTrain.IBIS then
			targetTrain = lastTrain
		else
			targetTrain = nil
		end
	end

	self.TrainIsPresent = IsValid( targetTrain )
	if self.TrainIsPresent and self.FailureIndex == 0 then
		self:FailToRegisterSim()
	elseif not self.TrainIsPresent then
		self.FailureIndex = 0
	end

	if not self.SimulateFailedToRegister then
		self.TrainIsRegistered = IsValid( targetTrain )
		return
	else
		if IsValid( targetTrain ) then
			PrintMessage( HUD_PRINTTALK, tostring( targetTrain.WagNum ) .. ":" .. " Signal ahead failed to register you, please use key to proceed manually." )
			return
		end
	end
	--print( occupied, targetTrain )
end

function ENT:AdditionalAspect( column )
	local additionalLenses = {
		[ "So14" ] = true,
		[ "A1" ] = true
	}

	local prepareToDepartSignal = false
	local returnLenses
	for lens in pairs( self.Lenses[ column ] ) do
		if additionalLenses[ lens ] and self.TrainIsRegistered then
			returnLenses = "So14"
		elseif additionalLenses[ lens ] and not self.TrainIsRegistered then
			returnLenses = ""
		end

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
	-- Ensure NextSwitch is set or found
	if self.FailedToFindSwitch then
		for column, lensTab in ipairs( self.Lenses ) do
			-- Optional additional aspect (suffix)
			local aAspect = self:AdditionalAspect( tonumber( column, 10 ) )
			if aAspect then self.Aspect[ column ] = aAspect .. "_" .. "F0" end
		end
		return
	end

	self.NextSwitch = type( self.NextSwitch ) ~= "number" and self.NextSwitch or self:FindNextSwitch( self.Node )
	if not self.NextSwitch or not IsValid( self.NextSwitch ) then return end
	-- Determine orientation of the switch ("alt" vs "main")
	local switchOrientationLeft = self.NextSwitch.Left == "alt" or "main"
	-- Check if switch is thrown into alternate track
	local switchStatusAlternate = self.NextSwitch.AlternateTrack == true
	-- Decide actual direction ("left" or "right") based on orientation and status
	local switchPointsTo = switchOrientationLeft == "alt" and switchStatusAlternate and "left" or switchOrientationLeft == "main" and not switchStatusAlternate and "left" or "right"
	-- Mapping between F-signal aspects and directions
	local signalsToDirections = {
		[ "F1" ] = "left_right",
		[ "F2" ] = "right",
		[ "F3" ] = "left",
		[ "F5" ] = "left_right"
	}

	--local multiDirection = false
	-- Iterate through all signal columns
	for column, lensTab in ipairs( self.Lenses ) do
		-- Optional additional aspect (suffix)
		local aAspect = self:AdditionalAspect( tonumber( column, 10 ) )
		-- Iterate through lenses in this column
		for lens in pairs( lensTab ) do
			-- Process only recognized lenses
			if signalsToDirections[ lens ] then
				if lens ~= "F1" then
					-- F2, F3, F5: Aspect depends on switch position match
					local switchToAspect = string.find( signalsToDirections[ lens ], switchPointsTo ) and lens or "F0"
					if switchToAspect then self.Aspect[ column ] = switchToAspect end
				else
					local switchToAspect
					if self.Columns > 1 then
						if ( switchPointsTo == "left" and switchOrientationLeft == "main" ) or ( switchPointsTo == "right" and switchOrientationLeft == "alt" ) then
							switchToAspect = "F1"
						else
							--print( "halt" )
							switchToAspect = "F0"
						end
					else
						if switchPointsTo == "right" and switchOrientationLeft == "main" then
							switchToAspect = "F2"
						elseif switchPointsTo == "left" and switchOrientationLeft == "alt" then
							switchToAspect = "F3"
						elseif switchPointsTo == "left" and switchOrientationLeft == "main" then
							switchToAspect = "F1"
						end
					end

					self.Aspect[ column ] = switchToAspect
				end
			end

			-- Apply additional aspect modifier if present
			if aAspect then self.Aspect[ column ] = self.Aspect[ column ] .. "_" .. aAspect end
		end
	end
end

function ENT:BlockModeSignalling()
end

function ENT:OnRemove()
	MPLR.UpdateSignalEntities()
end