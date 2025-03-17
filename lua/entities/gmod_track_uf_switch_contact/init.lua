AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/lilly/uf/signage/point_contact.mdl" )
	self.TargetEnt = ents.FindByName( self.VMF.SwitchEnt )[ 1 ] -- the switch this trigger is paired to
	self.SwitchID = self.TargetEnt.ID -- the switch ID
	self.Invisible = self.VMF.Invisible == "1" and true or false -- on the road we can just move the sign to wherever it makes sense, in tunnels we hide it
	self:SetNW2Bool( "Invisible", self.Invisible )
	util.PrecacheModel( "models/lilly/uf/signage/point_contact.mdl" ) -- precache for clientModel use
	self.TrackPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ] -- where on the rail coordinates are we
	self.AutomaticSwitching = self.VMF.SecondaryAutomaticSwitching -- what side to automatically switch to if a train approaches from the other end
	self.TrainInRange = false
	self.TargetEnt.PairedControllers[ self ] = true
end

function ENT:Think()
	local function executeSwitching( line, route, isOverride, train, isAutomaticOverride )
		local routeCommand = line and UF.RoutingTable[ line .. route ] and UF.RoutingTable[ line .. route ][ self.SwitchID ] or nil --get the routing command from the table
		print( "exec" )
		if isAutomaticOverride and IsValid( train ) then
			print( "Automatic Override" )
			self.TargetEnt:SecondarySwitchingQueue( isOverride, self )
		elseif isOverride then
			self.TargetEnt:SwitchingQueue( isOverride, self )
		elseif routeCommand then
			self.TargetEnt:SwitchingQueue( routeCommand, self )
		else
			print( "No switching possibility found. Quitting.", isAutomaticOverride )
			return
		end
	end

	self.TrackPos = self.TrackPos or Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	if not IsValid( self.TargetEnt ) then
		print( "ERROR! Target Switch not found!", self )
		return
	elseif not self.TargetEnt.TrackPos then
		print( "ERROR! Position of Target Switch on track not found!", self )
		return
	end

	local function iterateForward( node )
		if node.next then
			return iterateForward( node.next )
		else
			return node
		end
	end

	local function iterateBackward( node )
		if node.prev then
			return iterateBackward( node.prev )
		else
			return node
		end
	end

	local function checkInRange()
		local inRange
		local targetPath = self.TargetEnt.TrackPos.path.id
		local dir = self.TrackPos.forward
		if not self.AutomaticSwitching or self.AutomaticSwitching == "none" or targetPath == self.TrackPos.path.id then
			inRange, _, trainDetected = UF.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, self.TrackPos.x < self.TargetEnt.TrackPos.x, "light", self.TargetEnt.TrackPos.x )
			return inRange, _, trainDetected
		elseif dir then
			local lastNode = lastNode or iterateForward( self.TrackPos.node1 )
			print( lastNode.x, self.TrackPos.x, self.TrackPos.path.id )
			inRange, _, trainDetected = UF.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, dir, "light", lastNode.x )
			return inRange, _, trainDetected
		elseif not dir then
			local lastNode = lastNode or iterateBackward( self.TrackPos.node1 )
			inRange, _, trainDetected = UF.IsTrackOccupied( self.TrackPos.node1, self.TrackPos.x, dir, "light", lastNode.x )
			return inRange, _, trainDetected
		end
		return false
	end

	local found, _, TrainDetected = checkInRange()
	-- Check if there are trains detected
	if found then
		local train = TrainDetected.IBIS and TrainDetected or TrainDetected.SectionA and TrainDetected.SectionA.IBIS and TrainDetected.SectionA or TrainDetected.SectionC and TrainDetected.SectionC.IBIS and TrainDetected.SectionC or nil
		if not train or not train.IBIS then
			self:NextThink( CurTime() + 1 )
			return
		end

		local line = train.IBIS.LineLength == 2 and string.sub( train.IBIS.Course, 1, #train.IBIS.Course - 2 ) or train.IBIS.LineLength == 3 and string.sub( train.IBIS.Course, 1, #train.IBIS.Course - 2 ) or nil
		line = line and tonumber( line, 10 ) or nil
		local route = route and tonumber( train.IBIS.Route, 10 ) or nil
		local override = train.IBIS.Override
		-- Execute switching based on detected route or override
		if route and line and not override then
			self.TrainInRange = true -- Mark train in range
			executeSwitching( line, route, false, train )
			self:NextThink( CurTime() + 1 )
			return true
		elseif override then
			self.TrainInRange = true -- Mark train in range
			print( "override!" )
			executeSwitching( line, route, override, train )
			self:NextThink( CurTime() + 1 )
			return true
		elseif self.AutomaticSwitching and self.AutomaticSwitching ~= "none" then
			print( "AutomaticOverride" )
			self.TrainInRange = true
			executeSwitching( nil, nil, self.AutomaticSwitching, train, true ) --line, route, isOverride, train, isAutomaticOverride
			return true
		end
	else
		-- No trains found in the range, reset state
		if self.TrainInRange then
			print( "Train left the range. Clearing state." )
			self.TrainInRange = false
			self:NextThink( CurTime() + 1 )
			return true
		end
	end

	self:NextThink( CurTime() + 1.0 )
end

function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end