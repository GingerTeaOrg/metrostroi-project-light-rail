MPLR.SignalLib = MPLR.SignalLib or {}
local LIB = MPLR.SignalLib
LIB.__index = LIB
function LIB:New( signalEnt )
	local obj = setmetatable( {}, LIB )
	obj:Initialize( signalEnt )
	return obj
end

function LIB:Initialize( signalEnt )
	self.SignalEnt = signalEnt
	self.Routes = self.SignalEnt.Routes or {}
	self.MainSignal = not self.SignalEnt.MainSignal and false or true -- assume we're the actual signal and not a repeater, unless stated otherwise
	self.AllowMultiOccupation = self.SignalEnt.AllowMultiOccupation -- We follow the NRW operational standards of BOStrab signalling, which explicitly allow for approach on sight on Signal H4 (single orange light)
	self.SignalState = "emergency" -- Default state for when the signal spawns. Basically an operational safe fallback. If a magnetic transmitter is attached, it will SPAD any passing train.
	self.Switches = {} -- Which switches are relevant to us.
	self.NodeCache = {} --table that saves the paths leading up to each next signal
	self.StartOperating = false -- Only pick up operation after running GetTrackPos()
	self.TrackPos = {}
	self.NoNextSignal = false -- This is set if we give up searching, either if there is no more node network, or if we have exceeded iterations
	self.Name = self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 -- Store the signal's location code in case we need it.
end

function LIB:GetTrackPos()
	if table.IsEmpty( self.TrackPos ) then
		self.TrackPos = Metrostroi.GetPositionOnTrack( self.SignalEnt:GetPos(), self.SignalEnt:GetAngles() )[ 1 ]
		if table.IsEmpty( self.TrackPos ) then return end
		self.Forward = self.TrackPos.forward
		self.NextSwitch, self.SwitchNode = self:FindNextSwitch()
		self.NextSignal, self.SignalNode = self:FindNextBlockSignal()
		self.StartOperating = true
	end
end

function LIB:Think()
	if not self.StartOperating and not self.NoNextSignal then
		timer.Simple( 2, function() self:GetTrackPos() end )
		return true
	end

	if self.NoNextSignal or self.NextSignal then self.SignalEnt:SetNW2String( "NextSignal", self.NoNextSignal and "none" or self.NextSignal.Name1 .. "/" .. self.NextSignal.Name2 ) end
	--print( self.TrackPos.path.id, self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 )
	self.EditMode = GetConVar( "mplr_signalling_editing_mode" ):GetBool()
	self:BlockSignalNoRoutes()
end

function LIB:ReturnSignalState()
	return self.SignalState
end

function LIB:CollectSwitches( node, count )
	local maxCount = 25
	count = count or 0
	count = count + 1
	if count > maxCount then return end
	if not node then
		error( "SignalLib: No next node found!! Exiting!" )
		return
	end

	self.VisitedNodes = self.VisitedNodes or {}
	if self.VisitedNodes[ node ] then return end
	self.VisitedNodes[ node ] = true
	local switchFound = MPLR.SwitchEntitiesByNode( node )
	if switchFound then table.insert( self.Switches, switchFound ) end
	-- Collect branch results
	if node.branches then
		for _, branch in pairs( node.branches ) do
			self:CollectSwitches( branch, count )
		end
	end

	-- Continue forward/backward
	if self.Forward then
		self:CollectSwitches( node.next, count )
	else
		self:CollectSwitches( node.prev, count )
	end
end

function LIB:BlockSignal()
	if not self.NoNextSignal and not self.NextSignal then self.NextSignal, self.SignalNode = IsValid( self.NextSignal ) and self.NextSignal or self:FindNextBlockSignal( self.TrackPos.node1 ) or nil end
	if not self.NextSignal or not self.SignalNode then return end
	local function checkSwitchVsSignal()
		local signalX = self.SignalNode.x
		local switchX = self.SwitchNode.x
		local forward = self.Forward
		return forward and signalX < switchX or not forward and signalX > switchX
	end

	local signalFirst = checkSwitchVsSignal() -- find out whether we can find the next signal before the next switch, then just run a simpler function
	if IsValid( self.NextSignal ) and signalFirst then
		self:BlockSignalNoRoutes()
		return
	end

	if not IsValid( self.NextSwitch ) or self.EditMode then self.NextSwitch, self.SwitchNode = self:FindNextSwitch() end
	table.insert( self.Switches, self.NextSwitch )
	if table.Count( self.Switches ) == 1 then self:CollectSwitches( self.TrackPos.node1 ) end
end

function LIB:BlockSignalNoRoutes()
	-- This is a simplified function in case there are no branching paths ahead. We just find the next signal and set our state based on it and the track occupation.
	if not IsValid( self.NextSignal ) and not self.NoNextSignal then self.NextSignal, self.SignalNode = self:FindNextBlockSignal() end
	if not IsValid( self.NextSignal ) then -- if there isn't a next signal, we're the absolute last one in the chain, so set to whatever emergency aspect there would be (actual correcponding aspect handled by individual entity)
		self.SignalState = "emergency"
		return -- no need to do anything if there is no next signal, so quit without further checks
	end

	local function checkBlock( trackPos ) -- simple block signalling helper
		return MPLR.IsTrackOccupied( trackPos.node1, trackPos.x, self.Forward, "light", self.NextSignal.TrackPosition.x )
	end

	local trainIsInBlockAhead = checkBlock( self.TrackPos )
	local nextSignalState = self.NextSignal.Library.SignalState -- ask the library of the next signal for its status
	local nextSignalType = self.NextSignal.MainSignal and "main" or "distant"
	if trainIsInBlockAhead then
		if not self.AllowMultiOccupation then
			self.SignalState = "danger"
			return
		else
			self.SignalState = "doubleOccupation"
			return
		end
	else
		self.SignalState = "clear"
	end

	if nextSignalState == "caution" then
		if nextSignalType == "main" then
			self.SignalState = "clear"
		else
			self.SignalState = "caution"
		end
	elseif nextSignalState == "danger" then
		self.SignalState = "caution"
	elseif nextSignalState == "error" then
		self.SignalState = "caution"
	elseif nextSignalState == "NONEXTSIGNAL" then
		self.SignalState = "caution" --this could also be emergency to indicate a real or simulated defect, but some signalling scenarios indicate the end of the line so it's only caution for now
	elseif nextSignalState == "emergency" then
		self.SignalState = "caution"
	end

	-- fallback to cover unknown or missing states
	self.SignalState = self.SignalState or not nextSignalState and "emergency"
end

function LIB:CacheNodePaths( start, target, scannedNodes, validNodes, originPath, encounteredSwitches )
	local maximumRange = 25
	encounteredSwitches = encounteredSwitches or {}
	---------
	if not validNodes then validNodes = {} end
	-------------------------
	local targetPath, targetPos, targetNode
	if type( target ) == "entity" then
		targetPos = target.TrackPos or target.TrackPosition
		targetPath = targetPos.node1.path.id
	else
		targetNode = target
		targetPath = target.path.id
	end

	-------------------------
	local startPos
	local startNode
	local startPath
	if type( start ) == "entity" then
		startPos = start.TrackPos or start.TrackPosition
		startNode = startPos.node1
		startPath = startPos.node1.path.id
	else
		startNode = start
		startPath = startNode.path.id
	end

	-------------------------
	if not scannedNodes then scannedNodes = {} end
	scannedNodes[ startPath ] = scannedNodes[ startPath ] or {}
	scannedNodes[ startPath ][ startNode ] = true
	if startPath ~= targetPath then -- if we're not yet on the target path
		if startPath ~= originPath then -- on the original path we only scan in the intended direction, on recusions we are agnostic to path directions to account for not knowing what way the branching path is facing
			local branch = startNode.next.branches
			local nextPath
			if branch then
				local switch = MPLR.SwitchEntitiesByNode[ startNode.next ]
				if switch then table.insert( encounteredSwitches, switch ) end
				nextPath = startNode.branches[ 1 ][ 2 ]
			end

			if nextPath then return self:CacheNodePaths( nextPath, target, scannedNodes, validNodes, encounteredSwitches ) end
		else
			local branch = startNode.next.branches
			local nextPath
			if branch then
				local switch = MPLR.SwitchEntitiesByNode[ startNode.prev ]
				if switch then table.insert( encounteredSwitches, switch ) end
				nextPath = startNode.branches[ 1 ][ 2 ]
			end

			if nextPath then return self:CacheNodePaths( nextPath, target, scannedNodes, validNodes, encounteredSwitches ) end
		end
	else -- we're on the target path, no need for more complex scans
		local signalFound = MPLR.SignalEntitiesByNode[ target.Name ]
		local signalMatch = signalFound == target
		validNodes[ startPath ] = { startNode }
		if not signalMatch then
			if startPos.x < targetPos.x then
				return self:CacheNodePaths( startNode.next, target, scannedNodes, validNodes, encounteredSwitches )
			else
				return self:CacheNodePaths( startNode.prev, target, scannedNodes, validNodes, encounteredSwitches )
			end
		else
			return true, validNodes, encounteredSwitches
		end
	end
end

function LIB:FindNextBlockSignal( node, block_iter )
	if self.NoNextSignal or self.StartOperating then return nil end
	block_iter = block_iter or 0
	if block_iter > 8 then
		ErrorNoHalt( "No next signal found!", self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 )
		self.NoNextSignal = true
		self.StartOperating = true
		return nil
	end

	if not node then node = self.TrackPos.node1 end
	local signalEnt = MPLR.SignalEntitiesByNode[ node ] and MPLR.SignalEntitiesByNode[ node ][ 1 ]
	local signal = IsValid( signalEnt ) and signalEnt
	local forward = self.Forward
	if ( forward and node.next ) and ( not signal or signal == self.SignalEnt ) and block_iter <= 8 then
		print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "Found no signal at node:", node.id, "Continuing search.", "Forward" )
		block_iter = block_iter + 1
		return self:FindNextBlockSignal( node.next, block_iter )
	elseif ( not forward and node.prev ) and ( not signal or signal == self.SignalEnt ) and block_iter <= 8 then
		print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "Found no signal at node:", node.id, "Continuing search.", "reverse" )
		block_iter = block_iter + 1
		return self:FindNextBlockSignal( node.prev, block_iter )
	elseif signal and signal ~= self.SignalEnt and signal.Library.Forward == self.Forward then
		print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "found Signal:", signal.Name1 .. "/" .. signal.Name2 )
		return signal, node
	elseif ( ( ( forward and not node.next ) or ( not forward and not node.prev ) ) and not signal ) or block_iter > 8 then
		ErrorNoHalt( "No next signal found!", self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 )
		self.NoNextSignal = true
		self.StartOperating = true
		return nil, nil
	end
end

function LIB:FindNextSwitch( node )
	-- Simple function to find the very next switch from the signal
	if not node then node = self.TrackPos.node1 end
	local switchEnt = MPLR.SwitchEntitiesByNode[ node ]
	local switch = IsValid( switchEnt ) and switchEnt
	local forward = self.Forward
	if not switch and forward then
		if node.next then
			return self:FindNextSwitch( node.next )
		else
			return nil
		end
	elseif not switch and not forward then
		if node.prev then
			return self:FindNextSwitch( node.prev )
		else
			return nil
		end
	elseif switch then
		return switch, node
	end
end

local Fahrstraße = {
	[ "Name" ] = "HBF-Incoming-Gl2-to-Gl1",
	[ "Switches" ] = {
		[ "W001" ] = "left",
		[ "W003" ] = "right"
	},
	[ "Signals" ] = {
		[ "Agl/A1" ] = "Jwd/A1"
	},
	[ "Conflicting" ] = { "HBF-Outgoing-Gl1-to-Gl1" }
}