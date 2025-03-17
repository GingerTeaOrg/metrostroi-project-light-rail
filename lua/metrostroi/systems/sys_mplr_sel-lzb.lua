Metrostroi.DefineSystem( "LZB90" )
if TURBOSTROI then return end
function TRAIN_SYSTEM:Initialize()
    if not self.Train.LZBTab then return end
    local tab = self.Train.LZBTab
    self.UnitLength = tab.Length
    self.Weight = tab.Weight
    self.UnitVmax = tab.Vmax
    self.TractivePower = tab.TractivePower
    self.BrakingPower = tab.BrakingPower
    self.BrakingCurve = tab.BrakingCurve
    self.AccelCurve = tab.AccelCurve
    self.TrainLength = 1
    self.TrainLengthInMetres = tab.LengthInMetres
    self.SpeedLimit = -1
    self.SpeedOverride = -1
    self.TargetSpeed = -1
    self.VirtualThrottle = 0
    self.CurrentSpeed = 0
    self.NextStationDist = 0
    self.NextStation = "none"
    self.StoppingTarget = "none"
end

local function Lerp( factor, target, current )
    return current + ( target - current ) * factor
end

function TRAIN_SYSTEM:Think( dT )
    if not self.Train.LZBTab then return end
    self.dT = dT
    self.Tick = self.Tick or CurTime()
    if CurTime() - self.Tick == 1 then
        self.Tick = CurTime()
        self:UpdateTrainLength()
        self:ProcessSpeedCurves( dT )
        self:UpdateTargetSpeed( dT ) -- Update the target speed needle
    end

    self.CurrentSpeed = self.CoreSys.Speed
end

function TRAIN_SYSTEM:UpdateTrainLength()
    self.TrainLength = self.Train.WagonList
    self.TrainLengthInMetres = self.TrainLength * self.UnitLength
end

function TRAIN_SYSTEM:ScanSpeedLimit()
    -- this is going to rest on the assumption that the train's forward side also contains the front bogey, so bear in mind
    local fb = self.Train.FrontBogey
    local rb = self.Train.RearBogey
    local fbPos = Metrostroi.GetPositionOnTrack( fb:GetPos(), fb:GetAngles() )[ 1 ]
    local rbPos = Metrostroi.GetPositionOnTrack( rb:GetPos(), rb:GetAngles() )[ 1 ]
    local selfPos = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
    local forward = selfPos.forward
    local function scanFrontBogey( forward )
        if forward then
            self.SpeedLimit = fbPos.node1.speed_forward
        else
            self.SpeedLimit = fbPos.node1.speed_backward
        end
    end

    local function scanRearBogey( forward )
        if forward then
            self.SpeedLimit = rbPos.node1.speed_forward
        else
            self.SpeedLimit = rbPos.node1.speed_backward
        end
    end

    if not rbPos and not fbPos or not next( Metrostroi.Paths ) then return end
    if self.CoreSys.ReverserA == 3 then -- For now we're only supporting the B-Wagen which has its reverser automatic setting on 3
        scanFrontBogey( forward )
    elseif self.CoreSys.ReverserB == 3 then
        scanRearBogey( forward )
    end
end

function TRAIN_SYSTEM:GetAccelerationCurve( currentSpeed )
    local curve = self.AccelCurve or {}
    -- Check if the curve has values; if not, return a default value (e.g., 1)
    if #curve == 0 then return 1 end
    -- Find the appropriate acceleration factor based on current speed
    for i = 1, #curve do
        local speedThreshold = curve[ i ].Speed
        local accelerationValue = curve[ i ].Value
        -- If current speed is less than or equal to the threshold, return the corresponding value
        if currentSpeed <= speedThreshold then return accelerationValue end
    end
    -- If current speed exceeds the last threshold, return the last defined acceleration value
    return curve[ #curve ].Value
end

function TRAIN_SYSTEM:UpdateTargetSpeed( dT )
    -- Example logic for setting target speed based on the current state
    local maxSpeed = self.UnitVmax -- Set target speed based on maximum speed
    self.TargetSpeed = maxSpeed -- This could be dynamically set based on conditions
    -- Lerp factor (adjust this value for faster/slower needle movement)
    local lerpFactor = 0.1 -- A value between 0 and 1, closer to 1 for faster reaction
    -- Apply linear interpolation to smoothly transition target speed
    self.TargetSpeed = Lerp( lerpFactor, self.TargetSpeed, self.CurrentSpeed )
end

function TRAIN_SYSTEM:ProcessTraction( dT )
    local noOverride = self.SpeedOverride == -1
    local maxSpeed = noOverride and math.min( self.UnitVmax, self.SpeedLimit ) or math.min( self.UnitVmax, self.SpeedLimit, self.SpeedOverride )
    local weight = self.Weight
    local tractivePower = self.Train.LZBTab.TractivePower
    local brakingPower = self.Train.LZBTab.BrakingPower
    local accelerationCurve = self:GetAccelerationCurve( self.CurrentSpeed )
    local brakingCurve = self:GetBrakingCurve( self.CurrentSpeed )
    local maxAcceleration = ( tractivePower / weight ) * accelerationCurve
    local maxDeceleration = ( brakingPower / weight ) * brakingCurve
    if dT == 0 then dT = 1 end
    if self.TargetSpeed < maxSpeed then
        self.TargetSpeed = math.min( self.TargetSpeed + maxAcceleration * dT, maxSpeed )
    else
        self.TargetSpeed = math.max( self.TargetSpeed - maxDeceleration * dT, 0 )
    end

    -- Update the virtual throttle to reflect both acceleration and braking
    self.VirtualThrottle = self:CalculateThrottle( dT )
end

function TRAIN_SYSTEM:CalculateThrottle( dT )
    -- Ensure dT is defined and greater than zero to avoid division by zero
    if dT == 0 then dT = 1 end
    local maxAcceleration = ( self.TractivePower / self.Weight ) * self:GetAccelerationCurve( self.CurrentSpeed )
    local maxDeceleration = ( self.BrakingPower / self.Weight ) * self:GetBrakingCurve( self.CurrentSpeed )
    -- Calculate the current change in speed
    local currentChangeInSpeed = ( self.TargetSpeed - self.CurrentSpeed ) * dT
    -- If we're accelerating
    if currentChangeInSpeed > 0 then
        -- Calculate throttle percentage based on acceleration
        local throttlePercentage = math.Clamp( currentChangeInSpeed / maxAcceleration, 0, 1 ) * 100
        return throttlePercentage
    else
        -- If we're decelerating
        local brakePercentage = math.Clamp( -currentChangeInSpeed / maxDeceleration, 0, 1 ) * 100
        return -brakePercentage -- Negative for braking
    end
end

function TRAIN_SYSTEM:StationApproach()
    local nextStationIndex = self.Train.IBIS.CurrentStation -- Get the next station from the IBIS
    if not nextStationIndex then return end
    local stationData = UF.StationEntsByIndex[ nextStationIndex ] -- Get station data by index
    if not stationData or not stationData.platform_data then return end
    -- Get platform data and compare distances to see if train is approaching the station
    local platformData = stationData.platform_data
    local platformStart = platformData.x_start
    local platformEnd = platformData.x_end
    local fbPos = Metrostroi.GetPositionOnTrack( fb:GetPos(), fb:GetAngles() )[ 1 ].x
    local rbPos = Metrostroi.GetPositionOnTrack( rb:GetPos(), rb:GetAngles() )[ 1 ].x
    local trainPos = self.CoreSys.ReverserA == 3 and fbPos or self.CoreSys.ReverserB == 3 and rbPos or nil
    local stationForward = platformStart < platformEnd
    self.NextStationDist = self:Distance2DSqr( stationData.Ent:GetPos() )
    if self.NextStationDist <= 600 then
        self.SpeedOverride = 40
    elseif trainPos and ( stationForward and ( trainPos > platformStart and trainPos < platformEnd ) or not stationForward and ( trainPos < platformStart and trainPos > platformEnd ) ) then
        self:BrakeToStopMarker( platformData )
    else
        self.SpeedOverride = -1
    end
end

function TRAIN_SYSTEM:BrakeToStopMarker( platformData )
    local markers = {
        [ 4 ] = platformData.h4,
        [ 3 ] = platformData.h3,
        [ 2 ] = platformData.h2,
        [ 1 ] = platformData.h1
    }

    local function reversePairs( t )
        local function iterator( t, i )
            i = i - 1
            if i > 0 then return i, t[ i ] end
        end
        return iterator, t, #t + 1
    end

    local trainLength = #self.Train.WagonList
    -- stop at the stop marker that corresponds with our train length, otherwise stop at the next best marker
    for k, v in reversePairs( markers ) do
        if v and k == trainLength then
            self.StoppingTarget = v
            break
        else
            self.StoppingTarget = markers[ trainLength - 1 ]
        end
    end
end