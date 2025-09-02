Metrostroi.DefineSystem( "MPLR_DoorHandler" )
TRAIN_SYSTEM.DontAccelerateSystem = true
--if TURBOSTROI then return end
function TRAIN_SYSTEM:Initialize()
	local doornumberRight = #self.Train.DoorsRight
	local doornumberLeft = #self.Train.DoorsLeft
	local stepsLow = self.Train.StepsLow
	local stepsMedium = self.Train.StepsMedium
	local stopRequest = self.Train.StopRequest
	self.StepMode = 0
	self.DoorStatesRight = {}
	for i in pairs( self.Train.DoorsRight ) do
		self.DoorStatesRight[ i ] = 0
	end

	self.DoorRandomnessCalculated = false
	self.ArmDoorsClosedAlarm = false
	if doornumberLeft then
		self.DoorStatesLeft = {}
		for i in pairs( self.Train.DoorsLeft ) do
			self.DoorStatesLeft[ i ] = 0
		end
	end

	if stopRequest then
		self.StopRequest = {}
		for i = 1, #self.DoorStatesRight do
			self.StopRequest[ i ] = 0
		end

		self.InverseStopRequest = {}
		for k, v in ipairs( self.StopRequest ) do
			local length = #self.StopRequest
			self.InverseStopRequest[ length + 1 - k ] = v
		end
	end

	if stepsLow then
		self.StepStatesLowLeft = {}
		for i = 1, #self.DoorStatesLeft do
			self.StepStatesLowLeft[ i ] = 0
		end

		self.StepStatesLowRight = {}
		for i = 1, #self.DoorStatesRight do
			self.StepStatesLowRight[ i ] = 0
		end
	end

	if stepsMedium then
		self.StepStatesMediumLeft = {}
		for i = 1, #self.DoorStatesLeft do
			self.StepStatesMediumLeft[ i ] = 0
		end

		self.StepStatesMediumRight = {}
		for i = 1, #self.DoorStatesRight do
			self.StepStatesMediumRight[ i ] = 0
		end
	end

	self.DoorUnlockState = 0
	self.DoorLockMoment = 0
	self.DoorCloseMomentsLeft = {}
	self.DoorCloseMomentsRight = {}
	for i = 1, doornumberRight do
		self.DoorCloseMomentsRight[ i ] = 0
	end

	for i = 1, doornumberLeft do
		self.DoorCloseMomentsLeft[ i ] = 0
	end

	self.DoorRandomnessRight = {}
	self.DoorRandomnessLeft = {}
	for i in ipairs( self.DoorStatesRight ) do
		self.DoorRandomnessRight[ i ] = 0
	end

	for i in ipairs( self.DoorStatesLeft ) do
		self.DoorRandomnessLeft[ i ] = 0
	end

	self.DoorLockSignalMoment = 0
	self.DoorOpenMoments = {}
	self.DoorCloseMomentsCalculated = false
	self.DoorRandomnessCalculated = false
	self.DoorsCloseTriggered = false
	self.DoorsClosed = true
	self.DoorsPreviouslyUnlocked = false
	self.DoorsPreviousOpened = false
	self.RequireDepartureAcknowledge = self.Train.RequireDepartureAcknowledge
	self.DoorsForceClose = false
	---------------------------------------
	self.CarHasDoorsClosed = true
	self.TrainHasDoorsClosed = true
end

function TRAIN_SYSTEM:CheckLocalDoors()
	if self.StepStatesMediumLeft then
		for i = 1, #self.StepStatesMediumLeft do
			if self.StepStatesMediumLeft[ i ] ~= 0 then return false end
		end
	end

	if self.StepStatesLowLeft then
		for i = 1, #self.StepStatesLowLeft do
			if self.StepStatesLowLeft[ i ] ~= 0 then return false end
		end
	end

	if self.StepStatesMediumRight then
		for i = 1, #self.StepStatesMediumRight do
			if self.StepStatesMediumRight[ i ] ~= 0 then return false end
		end
	end

	if self.StepStatesLowRight then
		for i = 1, #self.StepStatesLowRight do
			if self.StepStatesLowRight[ i ] ~= 0 then return false end
		end
	end

	for _, v in ipairs( self.DoorStatesLeft ) do
		if v > 0.1 then return false end
	end

	for _, v in ipairs( self.DoorStatesRight ) do
		if v > 0.1 then return false end
	end
	return true
end

function TRAIN_SYSTEM:CheckTrainDoors( iAmLeader )
	local leader
	if not iAmLeader then
		for _, v in ipairs( self.Train.WagonList ) do
			if v.TrainWireLeader then leader = v end
		end
		return leader and leader.DoorHandler:CheckTrainDoors( true ) or nil
	else
		for _, v in ipairs( self.Train.WagonList ) do
			if not v.DoorHandler:CheckLocalDoors() then return false end
		end
	end
	return true
end

function TRAIN_SYSTEM:Think( dT )
	local t = self.Train
	local sys = self.Train.CoreSys
	if not sys then return end
	self:DoorHandler( dT )
	self:ForceDoorOpen()
	self.TrainHasDoorsClosed = self:CheckTrainDoors( self.Train.WireLeader )
	self.CarHasDoorsClosed = self:CheckLocalDoors()
end

function TRAIN_SYSTEM:DoorHandler( dT )
	local p = self.Train.Panel
	local left = p.DoorsSelectLeft > 0
	local right = p.DoorsSelectRight > 0
	local idle = self.ReverserA == 1 or self.ReverserB == 1
	local stepmode = self.StepMode
	local toggle = self.Train.DoorsUnlockToggle
	--print( "left", right )
	if p.UnlockDoors > 0 and self.DoorUnlockState == 0 then
		self.DoorsPreviouslyUnlocked = true
		if left then
			self.DoorUnlockState = 1
		elseif right then
			self.DoorUnlockState = 2
		end

		self.DoorsCloseTriggered = false
	elseif ( not toggle and p.DoorsLock > 0 or toggle and p.UnlockDoors == 0 ) and self.DoorUnlockState > 0 then
		--print( "LOCKING" )
		self.DoorUnlockState = 0
		self.DoorsCloseTriggered = true
	end

	if self.DoorsPreviouslyUnlocked and self.RequireDepartureAcknowledge and self.TrainHasDoorsClosed and self.DoorsCloseTriggered then
		if p.DoorsCloseConfirm > 0 then self.DoorsPreviouslyUnlocked = false end
		self.Train:SetNW2Bool( "DepartureAlarm", self.DoorsPreviouslyUnlocked )
	elseif ( ( self.DoorsPreviouslyUnlocked and self.DoorsPreviouslyOpened ) or ( self.DoorUnlockState == 0 and self.DoorsPreviouslyUnlocked ) ) and not self.RequireDepartureAcknowledge and self.TrainHasDoorsClosed then
		print( "DepartureClear!!" )
		self.Train:SetNW2Bool( "DepartureAlarm", true )
		self.DoorsPreviouslyUnlocked = false
		self.DoorsPreviouslyOpened = false
		--self.Train:SetNW2Bool( "DepartureAlarm", false )
	end

	if self.StepStatesMediumLeft or self.StepStatesMediumRight then self:Steps() end
	self:Doors( self.DoorUnlockState > 0, left, right, self.Door1Unlock, self.DoorUnlockState > 0 and idle, stepmode, dT )
	self:PrevUnlock( left, right, self.DoorUnlockState > 0 )
	self:DoorNW2()
	-------------------------
	if p.DoorsForceClose and p.DoorsForceClose > 1 then self:DoorsForceClose( left, right ) end
end

function TRAIN_SYSTEM:ForceDoorOpen()
	local p = self.Train.Panel
	local right = p.DoorsSelectRight > 0
	local tab = right and self.DoorRandomnessRight or self.DoorRandomnessLeft
	if p.DoorsForceOpen and p.DoorsForceOpen > 0 then
		for k, _ in pairs( tab ) do
			tab[ k ] = 3
		end
	end
end

function TRAIN_SYSTEM:ForceDoorClose()
	local p = self.Train.Panel
end

function TRAIN_SYSTEM:DoorStuck()
	local p = self.Train.Panel
	local stuck = 0
	local stuckWhich = 0
	local num = p.DoorsSelectLeft > 0 and #self.DoorStatesLeft or #self.DoorStatesRight
	if stuck == 0 then stuck = math.random( 0, 1 ) end
	if stuck > 0.8 and stuckWhich == 0 then stuckWhich = math.random( 1, num ) end
	return stuck, stuckWhich
end

function TRAIN_SYSTEM:DoorNW2()
	local t = self.Train
	local doorNumberRight = #self.Train.DoorsRight
	local doorNumberLeft = #self.Train.DoorsLeft
	for i = 1, doorNumberRight do
		t:SetNW2Float( "Door" .. i .. "a", self.DoorStatesRight[ i ] )
	end

	if doorNumberLeft then
		for i = 1, doorNumberLeft do
			t:SetNW2Float( "Door" .. i .. "b", self.DoorStatesLeft[ i ] )
		end
	end
end

function TRAIN_SYSTEM:StopRequest()
end

function TRAIN_SYSTEM:Steps()
	local p = self.Train.Panel
	local t = self.Train
	local sys = self.Train.CoreSys
	local conflictingHeads = sys.ConflictingHeads
	if ( self.ReverserA ~= 0 or self.ReverserB ~= 0 ) and not conflictingHeads then
		if p.StepsHigh > 0 then
			t:WriteTrainWire( 18, 1 )
		elseif p.StepsLow > 0 then
			t:WriteTrainWire( 19, 1 )
		elseif p.StepsLowest > 0 then
			t:WriteTrainWire( 20, 1 )
		end
	end

	if #t.WagonList > 1 and t:ReadTrainWire( 6 ) > 0 then
		self.StepMode = t:ReadTrainWire( 18 ) > 0 and 1 or t:ReadTrainWire( 19 ) > 0 and 2 or t:ReadTrainWire( 20 ) > 0 and 3 or 0
	else
		if p.StepsLow > 0 then
			self.StepMode = 1
		elseif p.StepsLowest > 0 then
			self.StepMode = 2
		elseif p.StepsHigh > 0 then
			self.StepMode = 0
		else
			self.StepMode = self.StepMode
		end
	end
end

function TRAIN_SYSTEM:StepHandler( side, open, dT )
	local t = self.Train
	local p = self.Train.Panel
	if self.StepMode < 1 then
		for k in ipairs( self.StepStatesMediumRight ) do
			if self.StepStatesMediumRight[ k ] > 0 then self.StepStatesMediumRight[ k ] = self.StepStatesMediumRight[ k ] - 0.5 * dT end
		end

		for k in ipairs( self.StepStatesLowRight ) do
			if self.StepStatesLowRight[ k ] > 0 then self.StepStatesLowRight[ k ] = self.StepStatesLowRight[ k ] - 0.5 * dT end
		end

		for k in ipairs( self.StepStatesMediumLeft ) do
			if self.StepStatesMediumLeft[ k ] > 0 then self.StepStatesMediumLeft[ k ] = self.StepStatesMediumLeft[ k ] - 0.5 * dT end
		end

		for k in ipairs( self.StepStatesLowLeft ) do
			if self.StepStatesLowLeft[ k ] < 0 then self.StepStatesLowLeft[ k ] = self.StepStatesLowLeft[ k ] - 0.5 * dT end
		end
		return
	end

	if self.StepMode < 1 then return end
	local factor = open and ( 0.5 * dT ) or ( -0.5 * dT ) -- open or close and factor in deltaTime
	local function updateStepStates( stepStates, side, open, factor )
		local doorRandomness = side == "right" and self.DoorRandomnessRight or self.DoorRandomnessLeft
		for i in pairs( doorRandomness ) do
			--print( i, "random" )
			if open then
				if stepStates[ i ] < 1 and doorRandomness[ i ] == 3 then stepStates[ i ] = stepStates[ i ] + factor end
			else
				if ( side == "right" or p.DoorsSelectRight > 0 ) and self.DoorStatesRight[ i ] < 0.1 then --steps only move to retract when the doors are closed already
					if stepStates[ i ] > 0 then stepStates[ i ] = stepStates[ i ] + factor end
				elseif ( side == "left" or p.DoorsSelectLeft > 0 ) and self.DoorStatesLeft[ i ] and self.DoorStatesLeft[ i ] < 0.1 then
					if stepStates[ i ] > 0 then stepStates[ i ] = stepStates[ i ] + factor end
				end
			end

			stepStates[ i ] = math.Clamp( stepStates[ i ], 0, 1 )
		end
	end

	--this train is capable of street-level boarding, half height boarding and platform boarding
	--we increment both step states if mode 2 (street level) is active
	if self.StepMode == 1 then
		if side == "right" then
			updateStepStates( self.StepStatesMediumRight, side, open, factor )
		elseif side == "left" then
			updateStepStates( self.StepStatesMediumLeft, side, open, factor )
		end
	elseif self.StepMode == 2 then
		if side == "right" or p.DoorsSelectRight > 0 then
			updateStepStates( self.StepStatesMediumRight, side, open, factor )
			updateStepStates( self.StepStatesLowRight, side, open, factor )
		elseif side == "left" or p.DoorsSelectLeft > 0 then
			updateStepStates( self.StepStatesMediumLeft, side, open, factor )
			updateStepStates( self.StepStatesLowLeft, side, open, factor )
		end
	end

	if self.StepStatesMediumLeft then
		for k, v in ipairs( self.StepStatesMediumLeft ) do
			t:SetNW2Float( "StepMediumLeft" .. k, v )
		end
	end

	if self.StepStatesLowLeft then
		for k, v in ipairs( self.StepStatesLowLeft ) do
			t:SetNW2Float( "StepLowestLeft" .. k, v )
		end
	end

	if self.StepStatesMediumRight then
		for k, v in ipairs( self.StepStatesMediumRight ) do
			t:SetNW2Float( "StepMediumRight" .. k, v )
		end
	end

	if self.StepStatesLowRight then
		for k, v in ipairs( self.StepStatesLowRight ) do
			t:SetNW2Float( "StepLowestRight" .. k, v )
		end
	end
end

-- Are the doors unlocked, sideLeft,sideRight,door1 open, unlocked while reverser on * position,steps high/medium/low
function TRAIN_SYSTEM:Doors( unlock, left, right, door1, idleunlock, stepmode, dT )
	local WagonList = self.Train.WagonList
	local t = self.Train
	if unlock then
		self.DoorLockMoment = 0
	elseif not unlock and self.DoorLockMoment == 0 then
		self.DoorLockMoment = CurTime()
	end

	--print( "TEST", unlock )
	local IRGates = self:IRIS( true )
	--PrintTable( IRGates )
	-- Initialize previousUnlock outside the loop to maintain state across iterations
	local previousUnlock = false
	-- Determine if the alarm for closed doors should be triggered
	self.ArmDoorsClosedAlarm = self.DoorsClosed and previousUnlock and not door1
	-- Update previousUnlock for next iteration
	previousUnlock = previousUnlock or not self.DoorsClosed or false
	-- Update NW2Bool to signal DoorChime if alarm is triggered and doors are closed
	t:SetNW2Bool( "DoorChime", self.ArmDoorsClosedAlarm and self.DoorsClosed and previousUnlock )
	-- IRIS operation for unlocking doors
	if unlock and self.ReverserA ~= 0 and not self.ConflictingHeads then
		if not self.DoorRandomnessCalculated then
			self.DoorRandomnessCalculated = true
			if right then
				for _, v in pairs( self.DoorRandomnessRight ) do
					v = math.random( 0, 4 )
				end
			else
				for _, v in pairs( self.DoorRandomnessLeft ) do
					v = math.random( 0, 4 )
				end
			end
		end

		self:UnlockDoors( right, left, IRGates, dT )
	elseif not unlock and not door1 then
		--print( "LOCKING!!" )
		self:LockDoors( right, left, IRGates, dT, lockSignalMoment )
		self.DoorRandomnessCalculated = false
	elseif idleunlock then
		self:IdleUnlock( right, left, IRGates, dT )
	elseif door1 then
		self:Door1Unlock( right, left )
	end

	if self.Train.StepsMedium or self.Train.StepsLower then self:StepHandler( right and "right" or left and "left", unlock, dT ) end
end

function TRAIN_SYSTEM:UnlockDoors( right, left, IRGates, dT )
	local function IncrementDoorStates( IRGates, left, right, dT )
		local stepStates = right and self.StepStatesMediumRight or self.StepStatesMediumLeft --only really needed to check the half height step in any case
		local tabRight = self.DoorRandomnessRight
		local tabLeft = self.DoorRandomnessLeft
		local doorStatesLeft = self.DoorStatesLeft
		--PrintTable( self.DoorStatesLeft )
		local doorStatesRight = self.DoorStatesRight
		if next( tabRight ) and right then
			for i = 1, #tabRight do
				if tabRight[ i ] == 3 and doorStatesRight[ i ] < 1 and not IRGates[ i ] then
					self.DoorsPreviouslyOpened = true
					if self.StepMode and self.StepMode < 1 then --no steps, open immediately
						doorStatesRight[ i ] = math.Clamp( doorStatesRight[ i ] + 0.55 * dT, 0, 1 )
						--print( doorStates[ i ] )
					elseif stepStates and self.StepMode > 0 and stepStates[ i ] == 1 then
						--first open steps, then the doors open
						doorStatesRight[ i ] = math.Clamp( doorStatesRight[ i ] + 0.55 * dT, 0, 1 )
					end
				end
			end
		end

		--PrintTable( tabLeft )
		if next( tabLeft ) and left then
			for i in pairs( tabLeft ) do
				--print( "i =", i, tabLeft[ i ], doorStatesLeft[ i ] )
				if tabLeft[ i ] == 3 and doorStatesLeft[ i ] < 1 and not IRGates[ i ] then
					if self.StepMode and self.StepMode < 1 then --no steps, open immediately
						doorStatesLeft[ i ] = math.Clamp( doorStatesLeft[ i ] + 0.55 * dT, 0, 1 )
						--print( doorStates[ i ] )
					elseif stepStates and self.StepMode > 0 and stepStates[ i ] == 1 then
						--first open steps, then the doors open
						doorStatesLeft[ i ] = math.Clamp( doorStatesLeft[ i ] + 0.55 * dT, 0, 1 )
					end
				end
			end
		end
	end

	if not self.DoorCloseMomentsCalculated then
		self.DoorCloseMomentsCalculated = true
		if right then
			for k in ipairs( self.DoorCloseMomentsRight ) do
				self.DoorCloseMomentsRight[ k ] = math.random( 0, 5 )
			end
		elseif left then
			for k in ipairs( self.DoorCloseMomentsLeft ) do
				self.DoorCloseMomentsLeft[ k ] = math.random( 0, 5 )
			end
		end
	end

	IncrementDoorStates( IRGates, left, right, dT )
end

function TRAIN_SYSTEM:LockDoors( right, left, IRGates, dT )
	--print( "locking" )
	local closeMoments = right and self.DoorCloseMomentsRight or self.DoorCloseMomentsLeft
	local function DecrementDoorStates( doorStates, lockSignalMoment, closeMoments, IRGates, right, dT )
		local stuck, stuckWhich = self:DoorStuck()
		for i, v in ipairs( doorStates ) do
			local currentDoorBlocked = stuck and stuckWhich == i
			--start closing doors if the IR sensor isn't blocked
			if CurTime() > self.DoorLockMoment + closeMoments[ i ] and not IRGates[ i ] and v > 0 and not currentDoorBlocked then
				doorStates[ i ] = math.Clamp( v - 0.55 * dT, 0, 1 )
			elseif ( IRGates[ i ] or currentDoorBlocked ) and doorStates[ i ] > 0 and doorStates[ i ] < 1 then
				--open the door back up if the corresponding sensor is blocked
				doorStates[ i ] = math.Clamp( v + 0.55 * dT, 0, 1 )
			end

			if right then
				self.DoorRandomnessRight[ i ] = 0
			else
				self.DoorRandomnessLeft[ i ] = 0
			end
		end
	end

	if next( self.DoorStatesRight ) then DecrementDoorStates( self.DoorStatesRight, self.DoorLockSignalMoment, closeMoments, IRGates, right, dT ) end
	if next( self.DoorStatesLeft ) then DecrementDoorStates( self.DoorStatesLeft, self.DoorLockSignalMoment, closeMoments, IRGates, right, dT ) end
end

function TRAIN_SYSTEM:IdleUnlock( right, left, IRGates, dT ) --when the train is parked but the doors are unlocked, the doors close after a short delay after opening
	local function HandleIdleUnlock( right, doorStates, doorOpenMoments, IRGates, dT )
		local doorRandomness = right and self.DoorRandomnessRight or self.DoorRandomnessLeft
		for i, v in ipairs( doorStates ) do
			if doorRandomness[ i ] == 3 and doorOpenMoments[ i ] == 0 then
				doorOpenMoments = CurTime()
			elseif doorRandomness[ i ] == 3 and doorOpenMoments > 0 and doorStates[ i ] < 1 and not IRGates[ i ] then
				doorStates[ i ] = math.Clamp( v + 0.1 * dT, 0, 1 )
			end

			if doorStates[ i ] > 0 and CurTime() - doorOpenMoments[ i ] > 5 and not IRGates[ i ] then doorStates[ i ] = math.Clamp( v - 0.1 * dT, 0, 1 ) end
			if doorStates[ i ] == 0 and doorRandomness[ i ] ~= 0 then
				doorRandomness[ i ] = 0
				doorOpenMoments = 0
			end
		end
	end

	HandleIdleUnlock( right, right and self.DoorStatesRight or left and self.DoorStatesLeft, self.DoorOpenMoments, IRGates, dT )
end

function TRAIN_SYSTEM:IRPerDoor( ent, vec1 )
	local train = ent
	local result = util.TraceHull( {
		start = train:LocalToWorld( vec1 ),
		endpos = train:LocalToWorld( vec1 ),
		mask = MASK_PLAYERSOLID,
		filter = {
			train -- filter out the train entity
		},
		mins = Vector( -24, -2, 0 ),
		maxs = Vector( 24, 2, 1 )
	} )
	return IsValid( result.Entity ) and ( result.Entity:IsPlayer() or result.Entity:IsNPC() )
end

function TRAIN_SYSTEM:IRIS( enable, left, right )
	-- IR sensors for blocking the doors
	local status = {}
	local train = self.Train
	local trainA = self.Train.SectionA or train --section A is defined on eight axle trains, or assume section A is main section in six axle trains
	local trainB = self.Train.SectionB -- get section B
	local sectionADoors = self.Train.SectionADoors
	local sectionCDoors = self.Train.SectionCDoors
	local sectionBDoors = self.Train.SectionBDoors
	if IsValid( trainA ) and IsValid( trainB ) and sectionCDoors then
		for i in pairs( sectionCDoors ) do
			if left and ENT.DoorsLeft[ i ] then
				status[ i ] = self:IRPerDoor( trainC, ENT.DoorsLeft[ i ] )
			elseif right and ENT.DoorsRight[ i ] then
				status[ i ] = self:IRPerDoor( trainC, ENT.DoorsRight[ i ] )
			end
		end
	end

	if IsValid( trainB ) then
		for i in pairs( sectionBDoors ) do
			if left and ENT.DoorsLeft[ i ] then
				status[ i ] = self:IRPerDoor( trainB, ENT.DoorsLeft[ i ] )
			elseif right and ENT.DoorsRight[ i ] then
				status[ i ] = self:IRPerDoor( trainB, ENT.DoorsRight[ i ] )
			end
		end
	end

	if IsValid( trainA ) then
		for i in pairs( sectionADoors ) do
			if left and ENT.DoorsLeft[ i ] then
				status[ i ] = self:IRPerDoor( train, ENT.DoorsLeft[ i ] )
			elseif right and ENT.DoorsRight[ i ] then
				status[ i ] = self:IRPerDoor( train, ENT.DoorsRight[ i ] )
			end
		end
	end
	return status
end

function TRAIN_SYSTEM:RandomUnlock( num, side )
	--print( "randomUnlock", num )
	if side == "left" then
		for i = 1, num do
			local dN = #self.DoorRandomnessLeft
			local dI = math.random( 1, dN )
			self.DoorRandomnessLeft[ dI ] = 3
		end
	elseif side == "right" then
		for i = 1, num do
			local dN = #self.DoorRandomnessRight
			local dI = math.random( 1, dN )
			self.DoorRandomnessRight[ dI ] = 3
		end
	end
end

function TRAIN_SYSTEM:PrevUnlock( left, right, unlocked )
	local doorsClosed = true
	local departureAlarm = false
	if unlocked then
		--self.DoorsPreviouslyUnlocked = true
		if self.RequireDepartureAcknowledge then self.DepartureConfirmed = false end
	end

	if self.DoorsPreviouslyUnlocked then
		for k, _ in ipairs( self.DoorStatesRight ) do
			if not self.StepStatesMediumRight then
				if self.DoorStatesRight[ k ] ~= 0 then
					doorsClosed = false
					break
				end
			else
				if self.DoorStatesRight[ k ] ~= 0 or self.StepStatesMediumRight[ k ] ~= 0 then
					doorsClosed = false
					break
				end
			end
		end

		for k, _ in ipairs( self.DoorStatesLeft ) do
			if not self.StepStatesMediumLeft then
				if self.DoorStatesLeft[ k ] ~= 0 then
					doorsClosed = false
					break
				end
			else
				if self.DoorStatesLeft[ k ] ~= 0 or self.StepStatesMediumLeft[ k ] ~= 0 then
					doorsClosed = false
					break
				end
			end
		end
	end
end

function TRAIN_SYSTEM:ForceClose( left, right )
	self.DoorCloseMomentsCalculated = true
	if right then
		for k in ipairs( self.DoorCloseMomentsRight ) do
			self.DoorCloseMomentsRight[ k ] = 0
		end
	elseif left then
		for k in ipairs( self.DoorCloseMomentsLeft ) do
			self.DoorCloseMomentsLeft[ k ] = 0
		end
	end
end