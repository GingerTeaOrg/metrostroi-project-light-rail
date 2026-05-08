-- Copyright © Platunov I. M., 2021 All rights reserved
-- Contains part of the original Metrostroi platform entity
-- Modified under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License for M:PLR
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString( "TrolleybusSystem.Stop.PassOut" )
Trolleybus_System.StopsPassengersSpawn = Trolleybus_System.StopsPassengersSpawn or {
	NextSpawn = 0,
	Rate = { 15, 30 },
	Stops = 0
}

--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

function ENT:Initialize()
	self.VMF = self.VMF or {}
	self.PlatformStart = ents.FindByName( self.VMF.PlatformStart or "" )[ 1 ]
	self.PlatformEnd = ents.FindByName( self.VMF.PlatformEnd or "" )[ 1 ]
	self.StationIndex = tonumber( self.VMF.StationIndex ) or 100
	self.PlatformIndex = tonumber( self.VMF.PlatformIndex ) or 1
	self:SetNWInt( "StationIndex", self.StationIndex )
	self:SetNWInt( "PlatformIndex", self.PlatformIndex )
	if IsValid( self.PlatformStart ) then self.PlatformStart:DropToFloor() end
	if IsValid( self.PlatformEnd ) then self.PlatformEnd:DropToFloor() end
	-- Positions
	if IsValid( self.PlatformStart ) then
		self.PlatformStart = self.PlatformStart:GetPos()
	else
		self.PlatformStart = Vector( 0, 0, 0 )
	end

	self.PopularityIndex = self.VMF.PopularityIndex or 1.0
	self.PlatformLast = self.VMF.PlatformLast == "yes"
	self.PlatformX0 = self.VMF.PlatformX0 or 0.80
	self.PlatformSigma = self.VMF.PlatformSigma or 0.25
	if not self.PlatformStart then
		self.VMF.PlatformStart = "station" .. self.StationIndex .. "_" .. ( self.VMF.PlatformStart or "" )
		self.PlatformStart = ents.FindByName( self.VMF.PlatformStart or "" )[ 1 ]
	end

	if not self.PlatformEnd then
		self.VMF.PlatformEnd = "station" .. self.StationIndex .. "_" .. ( self.VMF.PlatformEnd or "" )
		self.PlatformEnd = ents.FindByName( self.VMF.PlatformEnd or "" )[ 1 ]
	end

	self.PlatformDir = self.PlatformEnd - self.PlatformStart
	self.PlatformNorm = self.PlatformDir:GetNormalized()
	-- Platforms with tracks in middle
	local dot = ( self:GetPos() - self.PlatformStart ):Cross( self.PlatformEnd - self.PlatformStart )
	self.InvertSides = dot.z > 0.0
	-- Initial platform pool configuration
	self.WindowStart = 0 -- Increases when people board train
	self.WindowEnd = 0 -- Increases naturally over time
	self.PassengersLeft = 0 -- Number of passengers that left trains
	self:SetNW2Float( "X0", self.PlatformX0 )
	self:SetNW2Float( "Sigma", self.PlatformSigma )
	self:SetNW2Int( "WindowStart", self.WindowStart )
	self:SetNW2Int( "WindowEnd", self.WindowEnd )
	self:SetNW2Int( "PassengersLeft", self.PassengersLeft )
	self:SetNW2Vector( "PlatformStart", self.PlatformStart )
	self:SetNW2Vector( "PlatformEnd", self.PlatformEnd )
	self:SetNW2Vector( "StationCenter", self:GetPos() )
	-- FIXME make this nicer
	for i = 1, 32 do
		self:SetNW2Vector( "TrainDoor" .. i, Vector( 0, 0, 0 ) )
	end

	self:SetNW2Int( "TrainDoorCount", 0 )
	self.DoorUnlockCalled = false
	self.PlatformsMarked = false
	self.StepsType = self.VMF.StepsType
	self:SetModel( "models/trolleybus/tstop.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	self:DrawShadow( false )
	self:GetPhysicsObject():EnableMotion( false )
	self:GetPhysicsObject():EnableDrag( false )
	self.SpawnTime = CurTime()
	self.LastTime = CurTime()
	self.CurrentTrolleybuses = {}
	self.CurrentTrains = {}
	self.Passengers = {}
	self.BoardingDoorListLength = {}
	Trolleybus_System.UpdateTransmit( self, "TrolleybusStopDrawDistance" )
	Trolleybus_System.StopsPassengersSpawn.Stops = Trolleybus_System.StopsPassengersSpawn.Stops + 1
end

function ENT:MarkPlatformPathing()
	if table.IsEmpty( Metrostroi.Paths ) then return end
	local startPos = self.PlatformStart
	local startAng = Angle( 0, 0, 0 )
	local endPos = self.PlatformEnd
	local endAng = Angle( 0, 0, 0 )
	if not Metrostroi.GetPositionOnTrack( startPos, startAng )[ 1 ] then return end
	local startTrackPos = Metrostroi.GetPositionOnTrack( startPos, startAng )[ 1 ].node1
	local endTrackPos = Metrostroi.GetPositionOnTrack( endPos, endAng )[ 1 ].node1
	-- Ensure valid track positions with INDUSI
	--if not ( startTrackPos.node1.indusi and endTrackPos.node1.indusi ) then return end
	-- Recursively mark nodes as part of the station
	local function markNodes( node, nodeEnd )
		local station = {
			[ "ID" ] = self.StationIndex,
			[ "Platform" ] = self.PlatformIndex
		}

		if node == nodeEnd then
			node.station = station
			return
		end

		node.station = station
		if node.x > nodeEnd.x then
			-- Traverse backwards on the track
			return markNodes( node.prev, nodeEnd )
		else
			-- Traverse forwards on the track
			return markNodes( node.next, nodeEnd )
		end
	end

	markNodes( startTrackPos, endTrackPos )
end

function ENT:CheckDoors( ent, left_side )
	if not ent.DoorHandler then
		--print( "No doorhandler!!" )
		return
	end

	local sideSelector = left_side and "Left" or "Right"
	local doorTab = left_side and ent.DoorHandler.DoorStatesLeft or ent.DoorHandler.DoorStatesRight
	local doors = false
	local requiredSteps = tonumber( self.StepsType, 10 )
	local steps = false
	if not doorTab then return end
	for _, v in ipairs( doorTab ) do
		if v > 0.9 then
			----print( "doors are open!" )
			doors = true
			break
		end
	end

	local function validateStepStates() -- Passengers shall only board if the correct steps are extended
		local mediumTab = ent.DoorHandler[ "StepStatesMedium" .. sideSelector ]
		local lowestTab = ent.DoorHandler[ "StepStatesLow" .. sideSelector ]
		if requiredSteps == 0 and mediumTab == nil then -- If the platform requires no steps and the car has no steps, just quit and return OK
			return true
		elseif requiredSteps == 0 and mediumTab ~= nil then
			for _, v in ipairs( mediumTab ) do
				if v ~= 0 then
					return false
				else
					return true
				end
			end
		elseif requiredSteps == 1 and mediumTab ~= nil then
			for _, v in ipairs( mediumTab ) do
				if v == 1 then return true end
			end
			return false
		elseif requiredSteps == 2 and lowestTab ~= nil then
			for _, v in ipairs( lowestTab ) do
				if v == 1 then return true end
			end
			return false
		end
	end

	steps = validateStepStates()
	return doors and steps or false
end

function ENT:CountDoors( ent, left_side )
	if not ent.DoorHandler then return end
	local count = 0
	local tab = left_side and ent.DoorHandler.DoorStatesLeft or ent.DoorHandler.DoorStatesRight
	if not tab then return 0 end
	for _, v in ipairs( tab ) do
		if v > 0.9 then
			count = count + 1
			continue
		end
	end
	return count
end

function ENT:CheckDoorRandomness( v, left )
	local train = v
	local randomness = left and train.DoorHandler.DoorRandomnessLeft or train.DoorHandler.DoorRandomnessRight
	for _, value in pairs( randomness ) do
		if value ~= 3 then return false end
	end
	return true
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:UpdateData( dt )
	self:SetStopName( dt.Name )
	self:SetSVName( dt.SVName )
	self:SetPavilion( dt.Pavilion )
	self:SetSize( dt.Length, dt.Width )
	self:SetPassCountPercent( dt.PassPercent )
	self:SetNotSolid( not self:GetPavilion() )
	local routesstr, routes, endroutes = {}, {}, {}
	for k, v in pairs( Trolleybus_System.Routes.Routes ) do
		for k2, v2 in ipairs( v.Dirs ) do
			local key = table.KeyFromValue( v2.Stops, self:GetID() )
			if key then
				routesstr[ #routesstr + 1 ] = k
				routes[ k ] = routes[ k ] or {}
				routes[ k ][ k2 ] = key
				if not v.Circular and key == #v2.Stops then endroutes[ k ] = true end
			end
		end
	end

	self:SetRoutesStr( table.concat( routesstr, "," ) )
	self.RoutesBelonging = routes
	self.EndRoutes = endroutes
	local i = 1
	while i <= #self.Passengers do
		if not self:CanPassReachGoal( self:GetID(), self.Passengers[ i ].GoalStop ) then
			table.remove( self.Passengers, i )
			self:SetPassCount( self:GetPassCount() - 1 )
		else
			i = i + 1
		end
	end
end

function ENT:SetNWVar( var, value )
	Trolleybus_System.NetworkSystem.SetNWVar( self, var, value )
end

function ENT:SetSize( l, w )
	self:SetLength( l )
	self:SetWidth( w )
end

function ENT:GetPassCountMult()
	if not StormFox2 then return 1 end
	local time = StormFox2.Time.Get()
	local hour = StormFox2.Time.GetHours( time )
	if StormFox2.Time.IsNight( time ) then
		return 1 / ( ( hour - 12 ) / 12 * 5 )
	else
		return 1 / ( ( 12 - hour ) / 12 * 5 )
	end
	return 1
end

function ENT:GetMaxPassCount()
	local x = math.floor( self:GetLength() / self.PassSize.x )
	local y = math.floor( self:GetWidth() / self.PassSize.y )
	return math.floor( x * y * self:GetPassCountMult() * ( self:GetPassCountPercent() / 100 ) )
end

function ENT:CanPassReachGoal( cur, goal, route )
	local curent = Trolleybus_System.Routes.StopEnts[ cur ]
	if not IsValid( curent ) then return false end
	local goalent = Trolleybus_System.Routes.StopEnts[ goal ]
	if not IsValid( goalent ) then return false end
	for k, v in pairs( route and {
		[ route ] = curent.RoutesBelonging[ route ]
	} or curent.RoutesBelonging ) do
		if not goalent.RoutesBelonging[ k ] then continue end
		local data = Trolleybus_System.Routes.Routes[ k ]
		if not data then continue end
		for k2, v2 in pairs( v ) do
			local gv2 = goalent.RoutesBelonging[ k ][ k2 ]
			if not gv2 then continue end
			if not data.Dirs[ k2 ] or data.Dirs[ k2 ].Stops[ v2 ] ~= cur or data.Dirs[ k2 ].Stops[ gv2 ] ~= goal then continue end
			if data.Circular or v2 < gv2 then return true end
		end
	end
	return false
end

function ENT:GetPassengersForTrolleybus( bus )
	local route = bus:GetMainTrolleybus():GetRouteNum()
	local passengers = {}
	for k, v in ipairs( self.Passengers ) do
		if self:CanPassReachGoal( self:GetID(), v.GoalStop, route ) then passengers[ #passengers + 1 ] = v end
	end
	return passengers
end

function ENT:Think()
	self.DeltaTime = CurTime() - self.LastTime
	self.LastTime = CurTime()
	self:BoardBusses()
	self:BoardTrains()
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:BoardBusses()
	self:SetupTrolleybuses()
	local busids = {}
	for bus, route in RandomPairs( self.CurrentTrolleybuses ) do
		busids[ #busids + 1 ] = bus:EntIndex()
		local openeddoors
		if not self.EndRoutes[ route ] and self:GetPassCount() > 0 and not bus.ExpelPassengers[ self ] and bus:GetVelocity():Length() < 5 and self:IsTrolleybusRouteRight( bus ) then
			local tofill = bus.PassCapacity - bus:GetPassCount()
			if tofill > 0 then
				openeddoors = 0
				for k, v in pairs( bus.DoorsData ) do
					if not v.nopass and bus:DoorIsOpened( k ) then openeddoors = openeddoors + 1 end
				end

				if openeddoors > 0 then
					local passengers = self:GetPassengersForTrolleybus( bus )
					if #passengers > 0 then
						for i = 1, math.min( #passengers, tofill, openeddoors ) do
							local passenger = passengers[ i ]
							table.RemoveByValue( self.Passengers, passenger )
							self:SetPassCount( self:GetPassCount() - 1 )
							bus.Passengers[ #bus.Passengers + 1 ] = passenger
							bus:SetPassCount( bus:GetPassCount() + 1 )
						end
					end
				end
			end
		end

		if bus:GetPassCount() > 0 and bus:GetVelocity():Length() < 5 then
			if not openeddoors then
				openeddoors = 0
				for k, v in pairs( bus.DoorsData ) do
					if not v.nopass and bus:DoorIsOpened( k ) then openeddoors = openeddoors + 1 end
				end
			end

			if openeddoors > 0 then
				local maxout = math.min( openeddoors, bus:GetPassCount() )
				local out = 0
				for k, v in ipairs( bus.Passengers ) do
					if self.EndRoutes[ route ] or bus.ExpelPassengers[ self ] or v.GoalStop == self:GetID() or not Trolleybus_System.Routes.StopEnts[ v.GoalStop ] then
						table.RemoveByValue( bus.Passengers, v )
						bus:SetPassCount( bus:GetPassCount() - 1 )
						out = out + 1
						if self:GetPassCount() < self:GetMaxPassCount() and bus.ExpelPassengers[ self ] and self:CanPassReachGoal( self:GetID(), v.GoalStop ) then
							self.Passengers[ #self.Passengers + 1 ] = v
							v:StopUpdate()
							self:SetPassCount( self:GetPassCount() + 1 )
						end
					end

					if out >= maxout then break end
				end

				net.Start( "TrolleybusSystem.Stop.PassOut", true )
				net.WriteEntity( self )
				net.WriteEntity( bus )
				net.WriteUInt( out, 8 )
				net.SendPVS( bus:WorldSpaceCenter() )
			end
		end
	end

	self:SetNWVar( "CurrentTrolleybuses", table.concat( busids, " " ) )
	local maxpasscount = self:GetMaxPassCount()
	while self:GetPassCount() > maxpasscount do
		table.remove( self.Passengers, math.random( 1, #self.Passengers ) )
		self:SetPassCount( self:GetPassCount() - 1 )
	end

	local i = 1
	while i <= #self.Passengers do
		if #busids > 0 then
			self.Passengers[ i ].LeaveTime = self.Passengers[ i ].LeaveTime + self.DeltaTime
		elseif CurTime() >= self.Passengers[ i ].LeaveTime then
			table.remove( self.Passengers, i )
			self:SetPassCount( self:GetPassCount() - 1 )
			continue
		end

		i = i + 1
	end

	Trolleybus_System.UpdateStopsPassengersSpawn()
	Trolleybus_System.UpdateTransmit( self, "TrolleybusStopDrawDistance" )
end

function ENT:BoardTrains()
	--if not Metrostroi.Stations[self.StationIndex] then return end
	-- Send update to client
	self:SetNW2Int( "WindowStart", self.WindowStart )
	self:SetNW2Int( "WindowEnd", self.WindowEnd )
	self:SetNW2Int( "PassengersLeft", self.PassengersLeft )
	local function lerp( start, finish, t )
		return start + ( finish - start ) * t
	end

	local boardingDoorList = {}
	local CurrentTrain
	local TrainArrivedDist
	local PeopleGoing = false
	local boarding = false
	local BoardTime = 8 + 7
	for k, v in pairs( ents.FindByClass( "gmod_subway_*" ) ) do
		if v.Base ~= "gmod_subway_mplr_base" or string.match( "subway_mplr", v.Base ) then continue end
		if not v.DoorHandler then continue end
		local doorHandler = v.DoorHandler
		if not IsValid( v ) or v:GetPos():Distance( self:GetPos() ) > self.PlatformStart:Distance( self.PlatformEnd ) then continue end
		local platform_distance = ( ( self.PlatformStart - v:GetPos() ) - ( self.PlatformStart - v:GetPos() ):Dot( self.PlatformNorm ) * self.PlatformNorm ):Length()
		local vertical_distance = math.abs( v:GetPos().z - self.PlatformStart.z )
		if vertical_distance >= 192 or platform_distance >= 256 then continue end
		local minb, maxb = v:LocalToWorld( Vector( -480, 0, 0 ) ), v:LocalToWorld( Vector( 480, 0, 0 ) ) --FIXME
		local train_start = ( maxb - self.PlatformStart ):Dot( self.PlatformDir ) / ( self.PlatformDir:Length() ^ 2 )
		local train_end = ( minb - self.PlatformStart ):Dot( self.PlatformDir ) / ( self.PlatformDir:Length() ^ 2 )
		local left_side = train_start > train_end
		if self.InvertSides then left_side = not left_side end
		local doorCount = self:CountDoors( v, left_side )
		local pop = self:GetPassCount()
		local doors_open = self:CheckDoors( v, left_side )
		if not doors_open and pop > 0 and v.DoorHandler.DoorUnlockState > 0 and not self.DoorUnlockCalled then
			v.DoorHandler:RandomUnlock( math.random( 1, doorCount ), left_side and "left" or "right" )
			--print( "Called RandomUnlock on train" )
			self.DoorUnlockCalled = true
		end

		if not doors_open then continue end
		if ( train_start < 0 ) and ( train_end < 0 ) then doors_open = false end
		if ( train_start > 1 ) and ( train_end > 1 ) then doors_open = false end
		if -0.2 < train_start and train_start < 1.2 then v.BoardTime = self.Timer and CurTime() - self.Timer end
		if 0 < train_start and train_start < 1 and ( not TrainArrivedDist or TrainArrivedDist < train_start ) then
			TrainArrivedDist = train_start
			CurrentTrain = v
		end

		passengers_can_board = doors_open
		-- Board passengers
		if passengers_can_board then
			-- Find player of the train
			local driver = getTrainDriver( v )
			local floorHeight, floorHeight2 = v:GetStandingArea()
			floorHeight = floorHeight.z
			self:SetNW2Float( "FloorHeight", floorHeight )
			self:SetNW2Vector( "TrainPos", v:GetPos() )
			-- Limit train to platform
			train_start = math.max( 0, math.min( 1, train_start ) )
			train_end = math.max( 0, math.min( 1, train_end ) )
			-- Check if this was the last stop
			if v.LastPlatform ~= self then
				v.LastPlatform = self
				if v.AnnouncementToLeaveWagonAcknowledged then v.AnnouncementToLeaveWagonAcknowledged = nil end
				-- How many passengers must leave on this station
				local proportion = math.random() * math.max( 0, 1.0 + math.log( self.PopularityIndex ) )
				if self.PlatformLast then proportion = 1 end
				if v.AnnouncementToLeaveWagon == true then proportion = 1 end
				-- Total count
				v.PassengersToLeave = math.floor( proportion * v:GetNW2Float( "PassengerCount" ) + 0.5 )
			end

			-- Check for announcement
			if v.AnnouncementToLeaveWagon and not v.AnnouncementToLeaveWagonAcknowledged then v.AnnouncementToLeaveWagonAcknowledged = true end
			-- Calculate number of passengers near the train
			local passenger_density = math.abs( CDF( train_start, self.PlatformX0, self.PlatformSigma ) - CDF( train_end, self.PlatformX0, self.PlatformSigma ) )
			local passenger_count = passenger_density * self:GetPassCount()
			-- Get number of doors
			local door_count = left_side and v.DoorNumberLeft or v.DoorNumberRight
			-- Get maximum boarding rate
			local max_boarding_rate = 1.2 * door_count * dT
			-- Get boarding rate based on passenger density
			local boarding_rate = math.min( max_boarding_rate, passenger_count )
			if self.PlatformLast then boarding_rate = 0 end
			-- Get rate of leaving
			local leaving_rate = 1.4 * door_count * dT
			if v.PassengersToLeave == 0 and not v.AnnouncementToLeaveWagonAcknowledged then leaving_rate = 0 end
			if v.AnnouncementToLeaveWagonAcknowledged then leaving_rate = leaving_rate * 1.5 end
			-- Board these passengers into train
			local boarded = math.min( math.max( 2, math.floor( boarding_rate + 0.5 ) ), v.AnnouncementToLeaveWagonAcknowledged and 0 or self:GetPassCount() )
			local left = math.min( math.max( 2, math.floor( leaving_rate + 0.5 ) ), v.AnnouncementToLeaveWagonAcknowledged and v:GetNW2Int( "PassengerCount" ) or v.PassengersToLeave )
			if math.random() <= math.Clamp( 17 - passenger_count, 0, 17 ) / 17 * 0.5 then boarded = 0 end
			if math.random() <= math.Clamp( 17 - v.PassengersToLeave, 0, 17 ) / 17 * 0.5 then left = 0 end
			local passenger_delta = boarded - left
			-- People board from platform
			if boarded > 0 then
				PeopleGoing = true
				self.WindowStart = ( self.WindowStart + boarded ) % self:PoolSize()
			end

			-- People leave to
			if left > 0 then
				PeopleGoing = true
				if IsValid( driver ) then
					driver:AddFrags( left )
					driver.MTransportedPassengers = ( driver.MTransportedPassengers or 0 ) + left
				end

				-- Move passengers
				v.PassengersToLeave = v.PassengersToLeave - left
				self.PassengersLeft = self.PassengersLeft + left
				if v.AnnouncementToLeaveWagonAcknowledged and not self.PlatformLast then
					if math.random() > 0.3 then self.WindowStart = ( self.WindowStart - left ) % self:PoolSize() end
				elseif not self.PlatformLast and math.random() > 0.9 then
					self.WindowStart = ( self.WindowStart - left ) % self:PoolSize()
				end
			end

			--People boarded train
			if IsValid( driver ) and boarded > 0 then driver:AddDeaths( boarded ) end
			-- Change number of people in train
			if v.SectionB and not v.SectionC then
				v.SectionB:BoardPassengers( passenger_delta / 2 )
				v:BoardPassengers( passenger_delta / 2 )
			elseif v.SectionA and v.SectionC then
				v.SectionA:BoardPassengers( passenger_delta / 3 )
				v.SectionB:BoardPassengers( passenger_delta / 3 )
				v:BoardPassengers( passenger_delta / 3 )
			end

			-- Keep list of door positions
			if left_side then
				for i, vec in pairs( v.DoorsLeft ) do
					if doorHandler.DoorStatesLeft[ i ] > 0.8 then boardingDoorList[ k ] = v:LocalToWorld( vec ) end
				end
			else
				for i, vec in pairs( v.DoorsRight ) do
					if doorHandler.DoorStatesRight[ i ] > 0.8 then boardingDoorList[ k ] = v:LocalToWorld( vec ) end
				end
			end

			if v.AnnouncementToLeaveWagonAcknowledged then
				BoardTime = math.max( BoardTime, 8 + 7 + ( v.PassengersToLeave or 0 ) * dT * 0.6 )
			else
				BoardTime = math.max( BoardTime, 8 + 7 + math.max( ( v.PassengersToLeave or 0 ) * dT, self:GetPassCount() * dT ) * 0.5 )
			end
			-- Add doors to boarding list
			----print("BOARDING",boarding_rate,"DELTA = "..passenger_delta,self.PlatformLast,v:GetNW2Int("PassengerCount"))
		end

		v.BoardTimer = self.BoardTimer
		boarding = boarding or passengers_can_board
	end

	--if not boarding then CurrentTrain = nil end
	self.BoardTime = BoardTime
	if CurrentTrain and not self.CurrentTrain then
		self.CurrentTrain = CurrentTrain
	elseif not CurrentTrain and self.CurrentTrain then
		self.CurrentTrain = nil
		self.DoorUnlockCalled = false
	end

	-- Add passengers
	if ( not self.PlatformLast ) and ( #boardingDoorList == 0 ) then
		local target = GetConVar( "metrostroi_passengers_scale" )
		local targetInt = target:GetInt() * self.PopularityIndex --300
		-- then target = target*0.1 end
		if targetInt <= 0 then
			self.WindowEnd = self.WindowStart
		else
			local growthDelta = math.max( 0, ( targetInt - self:GetPassCount() ) * 0.005 )
			if growthDelta < 1.0 then -- Accumulate fractional rate
				self.GrowthAccumulation = ( self.GrowthAccumulation or 0 ) + growthDelta
				if self.GrowthAccumulation > 1.0 then
					growthDelta = 1
					self.GrowthAccumulation = self.GrowthAccumulation - 1.0
				end
			end

			self.WindowEnd = ( self.WindowEnd + math.floor( growthDelta + 0.5 ) ) % self:PoolSize()
		end
	end

	if self.OldOpened ~= self:GetDoorState() or self.OldPeopleGoing ~= PeopleGoing then
		self.OldOpened = self:GetDoorState()
		self.OldPeopleGoing = PeopleGoing
	end

	if self.BoardingDoorListLength ~= #boardingDoorList then
		-- Send boarding list FIXME make this nicer
		for k, v in ipairs( boardingDoorList ) do
			self:SetNW2Vector( "TrainDoor" .. k, v )
		end

		self:SetNW2Int( "TrainDoorCount", #boardingDoorList )
	end

	self.BoardingDoorListLength = #boardingDoorList
end

function ENT:IsTrolleybusRouteRight( bus )
	if not Trolleybus_System.GetAdminSetting( "trolleybus_stop_route_check" ) then return true end
	local num = bus:GetMainTrolleybus():GetRouteNum()
	if not num then return false end
	return self:GetRoutes()[ num ]
end

function ENT:IsTrolleybusInBounds( bus )
	local lpos, lang = WorldToLocal( bus:WorldSpaceCenter(), bus:GetAngles(), self:GetPos(), self:GetAngles() )
	return lpos.x > 50 and lpos.x < 350 and math.abs( lpos.z ) < 150 and math.abs( lpos.y ) < self:GetLength() / 2 + bus:BoundingRadius() and math.abs( lang.p ) < 45 and math.abs( lang.r ) < 45 and math.abs( lang.y + 90 ) < 45
end

function ENT:SetupTrolleybuses()
	local cur = self.CurrentTrolleybuses
	local t = {}
	for k, v in ipairs( ents.FindByClass( "trolleybus_ent_*" ) ) do
		if not self:IsTrolleybusInBounds( v ) then
			local otherbus = v.IsTrailer and v:GetTrolleybus() or v:GetTrailer()
			if not IsValid( otherbus ) or not self:IsTrolleybusInBounds( otherbus ) then continue end
		end

		t[ v ] = true
		local num = v:GetMainTrolleybus():GetRouteNum()
		if not cur[ v ] then self:OnTrolleybusArrived( v, num ) end
		cur[ v ] = num
	end

	for k, v in pairs( cur ) do
		if not t[ k ] then
			cur[ k ] = nil
			self:OnTrolleybusLeft( k, v )
		end
	end
end

function ENT:OnTrolleybusArrived( bus, route )
	bus.ExpelPassengers[ self ] = false
	Trolleybus_System.RunEvent( "Stop_TrolleybusArrived", self, bus, route )
end

function ENT:OnTrolleybusLeft( bus, route )
	if IsValid( bus ) then bus.ExpelPassengers[ self ] = nil end
	Trolleybus_System.RunEvent( "Stop_TrolleybusLeft", self, bus, route )
end

function ENT:OnRemove()
	Trolleybus_System.StopsPassengersSpawn.Stops = math.max( 0, Trolleybus_System.StopsPassengersSpawn.Stops - 1 )
end

local PASSENGER = {
	Init = function( self, goalstop )
		self.GoalStop = goalstop
		self:StopUpdate()
	end,
	StopUpdate = function( self ) self.LeaveTime = CurTime() + math.random( 60 * 5, 60 * 10 ) end,
}

function Trolleybus_System.CreateNewPassenger( goalstop )
	local pass = setmetatable( {}, {
		__index = PASSENGER
	} )

	pass:Init( goalstop )
	return pass
end

function Trolleybus_System.UpdateStopsPassengersSpawn()
	local dt = Trolleybus_System.StopsPassengersSpawn
	if dt.Stops > 0 and CurTime() >= dt.NextSpawn then
		local stops = Trolleybus_System.Routes.StopEnts
		local dest, destid = table.Random( stops )
		if dest then
			local starts = {}
			for k, v in pairs( stops ) do
				if v:CanPassReachGoal( v:GetID(), destid ) then starts[ #starts + 1 ] = v end
			end

			if #starts > 0 then
				local start = starts[ math.random( #starts ) ]
				if start:GetPassCount() < start:GetMaxPassCount() then
					start.Passengers[ #start.Passengers + 1 ] = Trolleybus_System.CreateNewPassenger( destid )
					start:SetPassCount( start:GetPassCount() + 1 )
				end
			end
		end

		dt.NextSpawn = CurTime() + math.random( dt.Rate[ 1 ], dt.Rate[ 2 ] ) / dt.Stops
	end
end

function Trolleybus_System.TrolleybusExpelPassengers( bus )
	for k, v in pairs( bus.ExpelPassengers ) do
		bus.ExpelPassengers[ k ] = true
	end

	if IsValid( bus:GetTrailer() ) then
		bus = bus:GetTrailer()
		for k, v in pairs( bus.ExpelPassengers ) do
			bus.ExpelPassengers[ k ] = true
		end
	end
end

concommand.Add( "trolleybus_expel_passengers", function( ply, cmd, args, str )
	if not IsValid( ply ) or not Trolleybus_System.PlayerInDriverPlace( nil, ply ) then return end
	Trolleybus_System.TrolleybusExpelPassengers( Trolleybus_System.GetSeatTrolleybus( ply:GetVehicle() ) )
end, nil, "Высаживает пассажиров с троллейбуса" )