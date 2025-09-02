AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
--------------------------------------------------------------------------------
-- Initialize the platform data
--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Get platform parameters
	self.VMF = self.VMF or {}
	self.PlatformStart = ents.FindByName( self.VMF.PlatformStart or "" )[ 1 ]
	self.SignOff = tonumber( self.VMF.Sign or "0" ) == 1
	self.PlatformEnd = ents.FindByName( self.VMF.PlatformEnd or "" )[ 1 ]
	self.StationIndex = tonumber( self.VMF.StationIndex ) or 100
	self.PlatformIndex = tonumber( self.VMF.PlatformIndex ) or 1
	self:SetNWInt( "StationIndex", self.StationIndex )
	self:SetNWInt( "PlatformIndex", self.PlatformIndex )
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

	-- Drop to floor
	self:DropToFloor()
	if IsValid( self.PlatformStart ) then self.PlatformStart:DropToFloor() end
	if IsValid( self.PlatformEnd ) then self.PlatformEnd:DropToFloor() end
	-- Positions
	if IsValid( self.PlatformStart ) then
		self.PlatformStart = self.PlatformStart:GetPos()
	else
		self.PlatformStart = Vector( 0, 0, 0 )
	end

	if IsValid( self.PlatformEnd ) then
		self.PlatformEnd = self.PlatformEnd:GetPos()
	else
		self.PlatformEnd = Vector( 0, 0, 0 )
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
	-- Send things to client
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
end

function ENT:MarkPlatformPathing()
	local startPos = self.PlatformStart
	local startAng = Angle( 0, 0, 0 )
	local endPos = self.PlatformEnd
	local endAng = Angle( 0, 0, 0 )
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

--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue( key, value )
	self.VMF = self.VMF or {}
	self.VMF[ key ] = value
end

--------------------------------------------------------------------------------
-- Process platform logic
--------------------------------------------------------------------------------
function erf( x )
	local a1 = 0.254829592
	local a2 = -0.284496736
	local a3 = 1.421413741
	local a4 = -1.453152027
	local a5 = 1.061405429
	local p = 0.3275911
	-- Save the sign of x
	sign = 1
	if x < 0 then sign = -1 end
	x = math.abs( x )
	-- A&S formula 7.1.26
	t = 1.0 / ( 1.0 + p * x )
	y = 1.0 - ( ( ( ( ( a5 * t + a4 ) * t ) + a3 ) * t + a2 ) * t + a1 ) * t * math.exp( -x * x )
	return sign * y
end

local function CDF( x, x0, sigma )
	return 0.5 * ( 1 + erf( ( x - x0 ) / math.sqrt( 2 * sigma ^ 2 ) ) )
end

local function merge( t1, t2 )
	for k, v in pairs( t2 ) do
		table.insert( t1, v )
	end
end

function ENT:PopulationCount()
	local totalCount = self.WindowEnd - self.WindowStart
	if self.WindowStart > self.WindowEnd then totalCount = ( self:PoolSize() - self.WindowStart ) + self.WindowEnd end
	return totalCount
end

local empty_checked = {}
local function getTrainDriver( train, checked )
	if not checked then
		for k, v in pairs( empty_checked ) do
			empty_checked[ k ] = nil
		end

		checked = empty_checked
	end

	if not IsValid( train ) then return end
	if checked[ train ] then return end
	checked[ train ] = true
	local ply = train:GetDriver()
	if IsValid( ply ) then -- and (train.KV.ReverserPosition ~= 0)
		return ply
	end
	return getTrainDriver( train.RearTrain, checked ) or getTrainDriver( train.FrontTrain, checked )
end

function ENT:GetDoorState()
	if not self.Doors then
		self.Doors = {}
		local doors = ents.FindByName( "station" .. self.StationIndex .. "_platform" .. self.PlatformIndex .. "_door" )
		for _, v in pairs( doors ) do
			table.insert( self.Doors, v )
		end
	end

	for _, v in pairs( self.Doors ) do
		if v:GetSaveTable().m_toggle_state ~= 1 then return true end
	end
	return false
end

function ENT:CheckDoorRandomness( v, left )
	local train = v
	local randomness = left and train.DoorHandler.DoorRandomnessLeft or train.DoorHandler.DoorRandomnessRight
	for _, value in pairs( randomness ) do
		if value ~= 3 then return false end
	end
	return true
end

local dT = 0.25
local trains = {}
function ENT:Think()
	if not table.IsEmpty( Metrostroi.Paths ) and not self.PlatformsMarked then
		self.PlatformsMarked = true
		self:MarkPlatformPathing()
	end

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
		local pop = self:PopulationCount()
		local doors_open = self:CheckDoors( v, left_side )
		if not doors_open and pop > 0 and v.DoorHandler.DoorUnlockState > 0 and not self.DoorUnlockCalled then
			v.DoorHandler:RandomUnlock( math.random( 2, doorCount ), left_side and "left" or "right" )
			print( "Called RandomUnlock on train" )
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
			local passenger_count = passenger_density * self:PopulationCount()
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
			local boarded = math.min( math.max( 2, math.floor( boarding_rate + 0.5 ) ), v.AnnouncementToLeaveWagonAcknowledged and 0 or self:PopulationCount() )
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
				BoardTime = math.max( BoardTime, 8 + 7 + math.max( ( v.PassengersToLeave or 0 ) * dT, self:PopulationCount() * dT ) * 0.5 )
			end
			-- Add doors to boarding list
			--print("BOARDING",boarding_rate,"DELTA = "..passenger_delta,self.PlatformLast,v:GetNW2Int("PassengerCount"))
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
			local growthDelta = math.max( 0, ( targetInt - self:PopulationCount() ) * 0.005 )
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
	self:NextThink( CurTime() + dT )
	return true
end

function ENT:CheckDoors( ent, left_side )
	if not ent.DoorHandler then
		print( "No doorhandler!!" )
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
			--print( "doors are open!" )
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