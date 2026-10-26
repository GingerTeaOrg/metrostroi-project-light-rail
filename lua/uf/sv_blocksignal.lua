MPLR.AvailableFahrstrassen = {}
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
	self.SimpleRoutes = false
	self.ActiveFahrstrasse = "none"
	self.Defect = false
	self.ScanNode = {}
	self.ScanIter = 0
	self.SpeedRestrict = 0
end

function LIB:GetTrackPos()
	if not self.TrackPos then self.TrackPos = {} end
	if table.IsEmpty( self.TrackPos ) then
		self.TrackPos = Metrostroi.GetPositionOnTrack( self.SignalEnt:GetPos(), self.SignalEnt:GetAngles() )[ 1 ]
		if not self.TrackPos or table.IsEmpty( self.TrackPos ) then return end
		self.Forward = not self.TrackPos.forward
		timer.Simple( 10, function()
			self.NextSignal, self.SignalNode = self:FindNextBlockSignal()
			self:FindInRoutes()
		end )

		self.StartOperating = true
	end
end

function LIB:ScanForTrain()
	local function buildScanPerimeter( node, iter, forward )
		if table.IsEmpty( self.ScanNode ) and self.ScanIter < 15 then
			self.ScanIter = iter + 1
			---@diagnostic disable-next-line: undefined-field
			node = node or self.TrackPos.node1
			local followingNode = forward and node.next or node.prev
			if not followingNode then return node end
			return buildScanPerimeter( followingNode, self.ScanIter, forward )
		else
			return node
		end
	end

	self.ScanNode = not table.IsEmpty( self.ScanNode ) and self.ScanNode or buildScanPerimeter( node, self.ScanIter, not self.Forward ) -- caching the perimeter so we don't have to iterate over and over, scan backwards relative to the signal orientation
	local inRange
	local train
	if not self.ScanNode or table.IsEmpty( self.ScanNode ) then return end
	if self.Forward then
		inRange, train, trainDetected, trainList = MPLR.IsTrackOccupied( self.ScanNode, self.ScanNode.x, self.Forward, self.TrackPos.x, self.TrackPos.node1 )
	else
		inRange, train, trainDetected, trainList = MPLR.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, self.Forward, self.ScanNode.x, self.ScanNode )
	end

	if inRange and not train.IBIS then
		for _, v in ipairs( trainList ) do
			if v.IBIS then
				--print( "IBIS" )
				trainDetected = v
				break
			end
		end
	end
	return inRange, train, trainDetected, trainList
end

function LIB:Think()
	if not self.StartOperating then
		timer.Simple( 2, function() self:GetTrackPos() end )
		return true
	end

	--print( self.TrackPos.path.id, self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 )
	self.EditMode = GetConVar( "mplr_signalling_editing_mode" ):GetBool()
	self:BlockSignal()
	return true
end

function LIB:ReturnSignalState()
	return self.SignalState
end

function LIB:GenerateImpromptuFahrstrasse()
	local name = self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2
	local nextSignal = self.NextSignal or self:FindNextBlockSignal()
	if not nextSignal then return false end
	local nextSignalName = nextSignal.Name1 .. "/" .. nextSignal.Name2
	local fahrstrasseName = name .. "_to_" .. nextSignalName
	local signals = {}
	signals[ name ] = nextSignalName
	if not MPLR.AvailableFahrstrassen[ 1 ] then MPLR.AvailableFahrstrassen[ 1 ] = {} end
	MPLR.AvailableFahrstrassen[ 1 ][ fahrstrasseName ] = {}
	MPLR.AvailableFahrstrassen[ 1 ][ fahrstrasseName ].Signals = signals
	local myNode = self.TrackPos.node1
	local distantNode = nextSignal.Library.TrackPos.node1
	local forward = myNode.id < distantNode.id
	local nodes = {}
	local pathID = myNode.path.id
	nodes[ myNode.path.id ] = {}
	if forward then
		for i = myNode.id, distantNode.id do
			if not nodes[ pathID ][ i ] then nodes[ pathID ][ i ] = {} end
			nodes[ pathID ][ i ] = true
		end
	else
		for i = distantNode.id, myNode.id do
			if not nodes[ pathID ][ i ] then nodes[ pathID ][ i ] = {} end
			nodes[ pathID ][ i ] = true
		end
	end

	MPLR.AvailableFahrstrassen[ 1 ][ fahrstrasseName ].nodes = {}
	MPLR.AvailableFahrstrassen[ 1 ][ fahrstrasseName ].nodes = nodes
	self.SimpleRoutes = true
end

function LIB:FindInRoutes()
	if not MPLR.AvailableFahrstrassen[ 1 ] then MPLR.AvailableFahrstrassen[ 1 ] = {} end
	for _, v in pairs( MPLR.AvailableFahrstrassen[ 1 ] ) do -- TODO: ADD A REVERSED ROUTES LIST SORTED BY SIGNAL FOR EASIER TRAVERSAL
		--print( v )
		if v.Signals and v.Signals[ self.Name ] then return true end
	end

	self:GenerateImpromptuFahrstrasse()
	return false
end

function LIB:BlockSignal()
	local c_verbose = GetConVar( "mplr_verbose" ):GetBool()
	--local ibisConvar = GetConVar( "mplr_signalling_allow_without_ibis" ):GetBool()
	if self.NoNextSignal and self.SimpleRoutes then
		self.SignalState = "NONEXTSIGNAL"
		return
	end

	self:TrackOccupation()
	self.TrainDetected, _, self.Train = self:ScanForTrain()
	local ibis
	local line
	local ibisRoute
	if self.TrainDetected and self.Train.IBIS then
		ibis = self.Train.IBIS
		line = ibis.Course
		line = string.sub( line, 1, #line - 2 )
		ibisRoute = ibis.Route
	end

	local defectSim = math.random( 0, 100 ) < 3 -- TODO: IMPLEMENT H4 THE THREE DOTS, passing signal at danger via specific order
	if self.SimpleRoutes then
		local routeName = self.Name .. "_to_" .. self.NextSignal.Library.Name
		local route = MPLR.AvailableFahrstrassen[ 1 ] and MPLR.AvailableFahrstrassen[ 1 ][ routeName ] or nil
		if not route then
			self:GenerateImpromptuFahrstrasse()
			return
		end

		if self.TrainDetected then
			if c_verbose then print( Format( "Opening simple route %s for service: %s", routeName, line .. "_" .. ibisRoute ) ) end
			MPLR.ActiveFahrstrassen[ routeName ] = MPLR.AvailableFahrstrassen[ 1 ][ routeName ]
			self.ActiveFahrstrasse = MPLR.AvailableFahrstrassen[ 1 ][ routeName ]
		else -- TODO: IMPLEMENT TRACKING OF TRAIN HAVING ENTERED BLOCK FROM STAGING IN FRONT OF SIGNAL -- why the fuck did I write that?? what does it mean??
			if MPLR.ActiveFahrstrassen and MPLR.ActiveFahrstrassen[ routeName ] then
				MPLR.ActiveFahrstrassen[ routeName ] = false
				self.ActiveFahrstrasse = false
				self.Defect = false
			end
		end
	else
		if not self.TrainDetected then
			--print( "No train", self.Name )
			for k, v in pairs( MPLR.ActiveFahrstrassen ) do
				if v and v.Signals then
					for signal in pairs( v.Signals ) do
						if signal == self.Name then MPLR.ActiveFahrstrassen[ k ] = nil end
						self.ActiveFahrstrasse = "none"
						self:TrackOccupation()
						--self.SignalState = "danger"
					end
				end
			end
			return
		end

		if not ibis then -- we simply cannot know where a train has to go without it having an IBIS that tells us what this train is about
			return
		end

		if table.IsEmpty( MPLR.LineRoutingInfo ) then -- if the map has none configured, just quit
			return
		end

		if not line or not ibisRoute then return end
		local routeRequest = MPLR.LineRoutingInfo[ line .. "_" .. ibisRoute ] and MPLR.LineRoutingInfo[ line .. "_" .. ibisRoute ][ self.Name ] -- construct the table index 
		if not routeRequest then
			if c_verbose then print( "undeclared route at:", self.Name ) end
			return
		end

		local routeTable = MPLR.AvailableFahrstrassen[ 1 ][ routeRequest ]
		if not routeTable then return end
		local conflicts = routeTable and routeTable[ "Conflicting" ]
		-- check for routes that would conflict with the requested one
		if conflicts then
			for _, v in ipairs( conflicts ) do
				if MPLR.ActiveFahrstrassen[ v ] then -- TODO: Maybe report to the driver that they have to wait, for debug reasons?
					--print( "return" )
					return -- just return if there is already a conflict
				end
			end
		end

		MPLR.ActiveFahrstrassen[ routeRequest ] = routeTable
		--print( routeTable )
		self.ActiveFahrstrasse = routeTable
		self.NextSignal = self.ActiveFahrstrasse[ "Signals" ][ self.Name ]
		if defectSim and not self.Defect then self.Defect = true end
	end
end

local templateLineRouting = {
	-- This shall be contained within the same table, because whether we're overground just requesting a switch to move, or a route to be opened, it doesn't really need much sorting.
	[ "17_11" ] = {
		[ "Abs/A3" ] = "Depart_Depot",
		[ "Jwd/E4" ] = "JahnplatzWestend_To_Marktstraße",
	},
	[ "17_12" ] = {
		[ "Jwd/E3" ] = "JahnplatzWestend_To_Merianplatz",
	}
}

function LIB:TrackOccupation()
	local route = self.ActiveFahrstrasse
	if not route or route == "none" then
		--print( "No route. Falling back.", self.Name )
		self.SignalState = "danger"
		return
	end

	local nodes = route.nodes
	local paths = table.GetKeys( nodes )
	local firstPath = paths[ 1 ]
	local lastPath = paths[ #paths ]
	local occupied
	for i = firstPath, lastPath do
		local pathNodes = nodes[ i ]
		local nodeNumbers = table.GetKeys( pathNodes )
		local firstNode = Metrostroi.Paths[ i ][ nodeNumbers[ 1 ] ]
		local lastNode = Metrostroi.Paths[ i ][ nodeNumbers[ #nodeNumbers ] ]
		occupied, _, _, self.TrainsInBlock = MPLR.IsTrackOccupied( firstNode, firstNode.x, true, lastNode.x, lastNode )
		if occupied then break end
	end

	local nextSignal = MPLR.SignalEntitiesByName[ route.Signals[ self.Name ] ]
	if not nextSignal then
		self.SignalState = "EMERGENCY"
		return
	end

	local nextSignalState = nextSignal.Library.SignalState
	local nextSignalType = self.NextSignal.MainSignal and "main" or "distant" -- TODO: ALSO ACCOUNT FOR DISTANT SIGNALS
	if occupied then
		if not self.AllowMultiOccupation then
			self.SignalState = "danger"
			return
		else
			self.SignalState = "doubleOccupation"
			return
		end
	else
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
	end
end

function LIB:FindNextBlockSignal( node, block_iter )
	local c_verbose = GetConVar( "mplr_verbose" ):GetBool()
	if table.IsEmpty( MPLR.SignalEntitiesByNode ) or table.Count( MPLR.SignalEntitiesByNode ) < 3 then
		print( "Signal entities table is empty, quitting." )
		return
	elseif self.NoNextSignal then
		--print( "No next Signal found" )
		return
	end

	local limit = 48
	block_iter = block_iter or 0
	if block_iter > limit then
		if c_verbose then ErrorNoHalt( "No next signal found!", self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 ) end
		self.NoNextSignal = true
		self.StartOperating = true
		return nil
	end

	if not node then node = self.TrackPos.node1 end
	local signalEnt = MPLR.SignalEntitiesByNode[ node ]
	print( signalEnt )
	local signal = ( signalEnt ~= self.SignalEnt ) and signalEnt or nil
	local forward = self.Forward
	if signal and signal.Library and signal.Library.Forward == forward then --TODO: SUPPORT F-signals without block signalling
		--[[and signal ~= self.SignalEnt]]
		if c_verbose then print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "found Signal:", signal.Name1 .. "/" .. signal.Name2 ) end
		self.StartOperating = true
		return signal, node
	elseif ( forward and node.next ) and block_iter <= limit then
		--[[( not signal or signal == self.SignalEnt ) and]]
		if c_verbose then print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "Found no signal at node:", node.id, "Continuing search.", "Forward" ) end
		block_iter = block_iter + 1
		return self:FindNextBlockSignal( node.next, block_iter )
	elseif ( not forward and node.prev ) and block_iter <= limit then
		if c_verbose then print( self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2, "Found no signal at node:", node.id, "Continuing search.", "reverse" ) end
		block_iter = block_iter + 1
		return self:FindNextBlockSignal( node.prev, block_iter )
	elseif ( ( ( forward and not node.next ) or ( not forward and not node.prev ) ) and not signal ) or block_iter > limit then
		if c_verbose then ErrorNoHalt( "No next signal found!", self.SignalEnt.Name1 .. "/" .. self.SignalEnt.Name2 ) end
		self.NoNextSignal = true
		self.StartOperating = true
		return nil, nil
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
	[ "Conflicting" ] = { "HBF-Outgoing-Gl1-to-Gl1" },
	[ "Nodes" ] = {}
}