Metrostroi.DefineSystem( "Siemens_INDUSI" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
	self.Bypassed = false
	self.ScanOrigin1 = Vector( 0, 0, 0 )
	self.ScanOrigin2 = Vector( 0, 0, 0 )
	self.FrontBogeyTrackPos = {}
	self.RearBogeyTrackPos = {}
	self.SpeedLimit = -1
	self.ScanTimer = 0
	self.INDUSIRunner = "none"
	self:DetermineINDUSIRunner()
	self.CurConsistLength = 0
	self.PrevConsistLength = 0
end

function TRAIN_SYSTEM:Think( dT )
	if not next( Metrostroi.Paths ) then --quit if there is no Metrostroi pathing
		return
	end

	if not IsValid( self.Train.FrontBogey ) or not IsValid( self.Train.RearBogey ) then return end
	self:CheckForConsistChange()
	self:ApplyNW2Int()
	if self.INDUSIRunner ~= self.Train then return end
	local speed = self.Train.CoreSys.Speed
	local deadman = self.Train.Deadman
	if #self.Train.WagonList == 1 then
		self:Origin()
	else
		self:DetermineLeadingSensor()
	end

	if not self.Bypassed and CurTime() - self.ScanTimer > 1 then
		self:Scan()
		self.ScanTimer = CurTime()
	end

	deadman:OverSpeed( speed > self.SpeedLimit )
end

function TRAIN_SYSTEM:ApplyNW2Int()
	--fetch the entity that runs the function and get its speed limit
	local speedLimit = self.INDUSIRunner.Siemens_INDUSI.SpeedLimit
	if speedLimit > -1 then
		self.Train:SetNW2Int( "SpeedLimit", speedLimit )
	else
		self.Train:SetNW2Int( "SpeedLimit", 0 )
	end
end

function TRAIN_SYSTEM:CheckForConsistChange()
	self.PrevConsistLength = #self.Train.WagonList
	self.CurConsistLength = #self.Train.WagonList
	if self.CurConsistLength ~= self.PrevConsistLength then self:DetermineINDUSIRunner() end
end

function TRAIN_SYSTEM:DetermineINDUSIRunner() --randomly determine which carriage runs this function so we don't have to run it everywhere
	local length = #self.Train.WagonList
	if #self.Train.WagonList == 1 then
		self.INDUSIRunner = self.Train
		return
	end

	if self.Train == self.Train.WagonList[ 1 ] and self.INDUSIRunner == "none" then
		self.INDUSIRunner = self.Train.WagonList[ math.random( 1, length ) ]
		self.INDUSIRunner.Siemens_INDUSI.INDUSIRunner = self.INDUSIRunner
	end
end

function TRAIN_SYSTEM:DetermineLeadingSensor()
	local train = self.Train
	local velocity = train:GetVelocity()
	local consistLength = #self.Train.WagonList
	local trainStart = self.Train.WagonList[ 1 ]
	local trainEnd = self.Train.WagonList[ consistLength ]
	local posFirst = trainStart:GetPos()
	local posLast = trainEnd:GetPos()
	local directionVector = ( posFirst - posLast ):GetNormalized()
	local travelDirection = velocity:GetNormalized()
	if directionVector:Dot( travelDirection ) > 0 then
		self.ScanOrigin1 = self.Train.FrontBogey:LocalToWorld( Vector( 0, 0, 0 ) )
		self.ScanOrigin2 = self.Train.RearBogey:LocalToWorld( Vector( 0, 0, 0 ) )
		self.FrontBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin1 )
		self.RearBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin2 )
	else
		self.ScanOrigin1 = trainEnd.FrontBogey:LocalToWorld( Vector( 0, 0, 0 ) )
		self.ScanOrigin2 = trainEnd.Train.RearBogey:LocalToWorld( Vector( 0, 0, 0 ) )
		self.FrontBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin1 )
		self.RearBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin2 )
	end
end

function TRAIN_SYSTEM:Origin()
	self.ScanOrigin1 = self.Train.FrontBogey:LocalToWorld( Vector( 0, 0, 0 ) )
	self.ScanOrigin2 = self.Train.RearBogey:LocalToWorld( Vector( 0, 0, 0 ) )
	self.FrontBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin1 )
	self.RearBogeyTrackPos = Metrostroi.GetPositionOnTrack( self.ScanOrigin2 )
end

function TRAIN_SYSTEM:Scan()
	local leadingBogey = self:GetLeadingBogey()
	local speed = self.CoreSys.Speed or 0
	local speedLimit = 0
	local trackTbl = {}
	if leadingBogey == "FrontBogey" then
		trackTbl = self.FrontBogeyTrackPos
	else
		trackTbl = self.RearBogeyTrackPos
	end

	-- Ensure trackTbl is valid before accessing properties
	if trackTbl and trackTbl.forward ~= nil then
		local forward = trackTbl.forward
		if leadingBogey == "FrontBogey" then
			speedLimit = forward and trackTbl.speed_forward or trackTbl.speed_backward
		else
			speedLimit = not forward and trackTbl.speed_forward or trackTbl.speed_backward
		end
	end

	-- Update the speed limit if valid
	if speedLimit and tonumber( speedLimit, 10 ) then
		self.SpeedLimit = tonumber( speedLimit, 10 )
	else
		self.SpeedLimit = -1
	end
end

function TRAIN_SYSTEM:GetLeadingBogey()
	local train = self.Train
	local velocity = train:GetVelocity() -- Vector representing the train's velocity
	-- Get the positions of both bogies
	local posFront = train.FrontBogey:GetPos()
	local posRear = train.RearBogey:GetPos()
	-- Determine which bogey is ahead in the direction of travel
	-- If velocity is aligned more with the vector pointing from rear to front, front is leading
	local directionVector = ( posFront - posRear ):GetNormalized()
	local travelDirection = velocity:GetNormalized()
	-- Compare the dot products to see which bogey is leading
	if directionVector:Dot( travelDirection ) > 0 then
		return "FrontBogey"
	else
		return "RearBogey"
	end
end