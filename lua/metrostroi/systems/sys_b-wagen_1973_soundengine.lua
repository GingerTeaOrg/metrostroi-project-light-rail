Metrostroi.DefineSystem( "duewag_b_1973_soundeng" )
function TRAIN_SYSTEM:Initialize()
	self.BrakeHiss = false
	self.BrakesAppliedFullSound = false
	self.PrevThrottleA = 0
	self.ThrottleA = 0
	self.ThrottleAZeroed = true
	self.ThrottleAZeroedSoundPlayed = true
	self.PrevThrottleB = 0
	self.ThrottleB = 0
	self.ThrottleBZeroed = true
	self.ThrottleBZeroedSoundPlayed = true
	----
	self.ReverserA = 0
	self.PrevReverserA = 0
	self.ReverserB = 0
	self.PrevReverserB = 0
	----
	self.Compressor = false
	----
	self.CruiseSound = 0
end

function TRAIN_SYSTEM:ClientInitialize()
end

----------------------------------------------------------------
function TRAIN_SYSTEM:Think()
	self.CoreSys = self.CoreSys or self.Train.CoreSys
	self.Speed = self.CoreSys.Speed
	self.BrakesAreApplied = self.CoreSys.BrakesAreApplied
	self:BrakeSounds()
	self:MotorSounds()
	self:ThrottleSounds()
	self:ReverserSounds()
	self:KeySounds()
end

function TRAIN_SYSTEM:MotorSounds()
	local cS = self.Train.CoreSys
	self.Train:SetNWBool( "ThrottlePositive", cS.ThrottleStateA > 0 or cS.ThrottleStateB > 0 )
	if cS.ThrottleStateA ~= 0 or cS.ThrottleStateB ~= 0 then
		--PrintMessage( HUD_PRINTTALK, "Chopper Sound On" )
		self.Train:SetNW2Bool( "Chopper", true )
	else
		self.Train:SetNW2Bool( "Chopper", false )
	end
end

function TRAIN_SYSTEM:ThrottleSounds()
	local t = self.Train
	local cS = self.Train.CoreSys or nil
	if not cS then return end
	self.PrevThrottleA = cS.ThrottleStateA
	self.ThrottleAMoved = self.PrevThrottleA ~= self.ThrottleA and ( self.ThrottleA - self.PrevThrottleA > 16 or self.PrevThrottleA - self.ThrottleA > -16 )
	self.ThrottleAUp = self.PrevThrottleA < self.ThrottleA
	if self.ThrottleAMoved and cS.ThrottleStateA ~= 0 then
		t:PlayOnce( "throttle_up" )
		self.PrevThrottleA = self.ThrottleA
	elseif self.ThrottleAMoved and cS.ThrottleStateA == 0 then
		t:PlayOnce( "throttle_up" )
		t:PlayOnce( "throttle_up" )
		t:PlayOnce( "throttle_zero" )
	end

	self.ThrottleA = cS.ThrottleStateA
	self.PrevThrottleB = cS.ThrottleStateB
	self.ThrottleBMoved = self.PrevThrottleB ~= self.ThrottleB
	self.ThrottleBUp = self.PrevThrottleB < self.ThrottleB
	if self.ThrottleBMoved and cS.ThrottleStateB ~= 0 then
		t.SectionB:PlayOnce( "throttle_up" )
		self.PrevThrottleB = self.ThrottleB
	elseif self.ThrottleBMoved and cS.ThrottleStateB == 0 then
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_up" )
		t.SectionB:PlayOnce( "throttle_zero" )
	end

	self.ThrottleB = cS.ThrottleStateB
end

function TRAIN_SYSTEM:ReverserSounds()
	local t = self.Train
	local cS = self.Train.CoreSys or nil
	if not cS then return end
	self.PrevReverserA = cS.ReverserA
	self.ReverserAMoved = self.PrevReverserA ~= self.ReverserA
	self.ReverserAUp = self.PrevReverserA < self.ReverserA
	self.ReverserADown = self.PrevReverserA > self.ReverserA
	if self.ReverserAMoved and self.ReverserAUp then
		t:PlayOnce( "reverser_down" )
		self.PrevReverserA = self.ReverserA
	elseif self.ReverserAMoved and self.ReverserADown then
		t:PlayOnce( "reverser_up" )
		self.PrevReverserA = self.ReverserA
	end

	self.ReverserA = cS.ReverserA
	----
end

function TRAIN_SYSTEM:BrakeSounds()
	if self.Speed < 2 and self.BrakesAreApplied and not self.BrakesAppliedFullSound then
		self.BrakesAppliedFullSound = true
		self.Train:PlayOnce( "brake_hiss" )
	elseif self.Speed > 5 and not self.BrakesAreApplied and self.BrakesAppliedFullSound then
		self.BrakesAppliedFullSound = false
	end
end

local prevOn = prevOn or false
function TRAIN_SYSTEM:KeySounds()
	local cS = self.Train.CoreSys
	if cS.IgnitionKeyA and not self.IgnitionKeyAOnPlayed then
		self.Train:PlayOnce( "key_turn" )
		self.IgnitionKeyAOnPlayed = true
		prevOn = true
	elseif not cS.IgnitionKeyA and not self.IgnitionKeyAOnPlayed and prevOn then
		self.Train:PlayOnce( "key_turn" )
		self.IgnitionKeyAOnPlayed = false
		prevOn = false
	end
end

local time
function TRAIN_SYSTEM:ClientThink()
	local function bellCurve( speed )
		local x = speed
		local target = 12
		local maxDistance = 13
		-- Normalize distance
		local n = math.abs( x - target ) / maxDistance
		-- Curve controls
		local sigma = 0.2 -- width of main peak
		local gamma = 0.47 -- tail softness (<1 = flatter tail)
		-- Final score (0–1)
		return math.exp( -( n * n ) / ( 2 * sigma * sigma ) ) ^ gamma
	end

	local t = self.Train
	self.Speed = self.Train:GetNW2Int( "Speed", 0 )
	--LocalPlayer():PrintMessage( HUD_PRINTTALK, tostring( self.Speed ) )
	time = time or RealTime()
	--print( time, RealTime(), RealTime() - time > 15 )
	----
	local batteryOn = self.Train:GetNW2Bool( "BatteryOn", false )
	if not batteryOn then return end
	local departureAlarm = self.Train:GetNW2Bool( "DepartureAlarm", false )
	--print( departureAlarm )
	if departureAlarm then
		--self.Train:PlayOnce( "DepartureConfirmed" )
		self.Train:SetNW2Bool( "DepartureAlarm", false )
	end

	--self.Train:SetSoundState( "bell", self.Train:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
	self.Train:SetSoundState( "bell_in", self.Train:GetNW2Bool( "Bell", false ) and 1 or 0, 1 )
	local brakeSetHiss = self.Train:GetNW2Bool( "BrakeSetHiss", false )
	if brakeSetHiss then self.Train:PlayOnceFromPos( "BrakesSet", self.Train.SoundNames[ "BrakesSet" ][ 1 ], 1, 1, 1, 1, Vector( 400, 0, 100 ) ) end
	--------
	local chopper = self.Train:GetNW2Bool( "Chopper", false )
	local vol = math.Remap( bellCurve( self.Speed ), 0.0005, 1, self.Speed > 1 and 0.01 or 0, 3 )
	--LocalPlayer():PrintMessage( HUD_PRINTTALK, tostring( vol ) )
	local pitch = ( self.Speed > 0 and self.Speed < 3 ) and 1.01 or 1 + math.sin( CurTime() * 1.8 ) * 0.00099
	local throttlePositive = self.Train:GetNW2Bool( "ThrottlePositive", false )
	local engage = throttlePositive and chopper or not ThrottlePositive and self.Speed > 1 -- Make it so!
	self.Train:SetSoundState( "Chopper", engage and vol or 0, pitch )
	--------
	local cruiseFactor = math.Remap( self.Speed, 1, 100, 0, 3 )
	local cruisePitch = math.Remap( self.Speed, 0, 100, 0.5, 1.5 )
	self.Train:SetSoundState( "Cruise", cruiseFactor, 1 )
	self.Train.SectionB:SetSoundState( "Cruise", cruiseFactor, 1 )
end

----------------------------------------------------------------
if SERVER then
	function TRAIN_SYSTEM:ServerPlaceholder()
	end
end

if CLIENT then
	function TRAIN_SYSTEM:ClientPlaceholder()
	end
end