AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:PlayAnnounce(arriving,Ann)
    if not arriving then
        if self.MustPlayAnnounces then
            local tbl = Metrostroi.StationSound
            if not tbl and not Ann then return end
            local snd = Ann or table.Random(tbl)
            if not snd.sound then snd.sound = Sound(snd[1]) end
            sound.Play(snd.sound,self:LocalToWorld(Vector(0,-1200,200)),90,100,1)
            sound.Play(snd.sound,self:LocalToWorld(Vector(0,1200,200)),90,100,1)
            timer.Adjust( "metrostroi_station_announce_"..self:EntIndex(), snd[2]+math.random(10,30),0,function() self:PlayAnnounce() end)
            if self.SyncAnnounces and not Ann then
                local ent = Metrostroi.Stations[self.StationIndex][self.PlatformIndex == 2 and 1 or 2].ent
                if IsValid(ent) then ent:PlayAnnounce(nil,snd) end
            end
        else
            timer.Remove("metrostroi_station_announce_"..self:EntIndex())
        end
    elseif arriving == 1 then

    elseif arriving == 2 then
        sound.Play(Ann,self:LocalToWorld(Vector(-1200,0,50)),120,100,0.4)
        sound.Play(Ann,self:LocalToWorld(Vector(1200,0,50)),120,100,0.4)
    end
end

--------------------------------------------------------------------------------
-- Initialize the platform data
--------------------------------------------------------------------------------
function ENT:Initialize()
    -- Get platform parameters
    self.VMF = self.VMF or {}
    self.PlatformStart      = ents.FindByName(self.VMF.PlatformStart or "")[1]
    self.SignOff        = tonumber(self.VMF.Sign or "0") == 1
    self.PlatformEnd        = ents.FindByName(self.VMF.PlatformEnd or "")[1]
    self.StationIndex       = tonumber(self.VMF.StationIndex) or 100
    self.PlatformIndex      = tonumber(self.VMF.PlatformIndex) or 1
    self:SetNWInt("StationIndex",self.StationIndex)
    self:SetNWInt("PlatformIndex",self.PlatformIndex)
    self.PopularityIndex    = self.VMF.PopularityIndex or 1.0
    self.PlatformLast       = (self.VMF.PlatformLast == "yes")
    self.PlatformX0         = self.VMF.PlatformX0 or 0.80
    self.PlatformSigma      = self.VMF.PlatformSigma or 0.25
    if not self.PlatformStart then
        self.VMF.PlatformStart  = "station"..self.StationIndex.."_"..(self.VMF.PlatformStart or "")
        self.PlatformStart      = ents.FindByName(self.VMF.PlatformStart or "")[1]
    end
    if not self.PlatformEnd then
        self.VMF.PlatformEnd    = "station"..self.StationIndex.."_"..(self.VMF.PlatformEnd or "")
        self.PlatformEnd        = ents.FindByName(self.VMF.PlatformEnd or "")[1]
    end

    -- Drop to floor
    --self:DropToFloor()
    --if IsValid(self.PlatformStart) then self.PlatformStart:DropToFloor() end
    --if IsValid(self.PlatformEnd) then self.PlatformEnd:DropToFloor() end

    -- Positions
    if IsValid(self.PlatformStart) then
        self.PlatformStart = self.PlatformStart:GetPos()
    else
        self.PlatformStart = Vector(0,0,0)
    end
    if IsValid(self.PlatformEnd) then
        self.PlatformEnd = self.PlatformEnd:GetPos()
    else
        self.PlatformEnd = Vector(0,0,0)
    end
    self.PlatformDir   = self.PlatformEnd-self.PlatformStart
    self.PlatformNorm   = self.PlatformDir:GetNormalized()
    -- Platforms with tracks in middle
    local dot = (self:GetPos() - self.PlatformStart):Cross(self.PlatformEnd - self.PlatformStart)

    self.InvertSides = dot.z > 0.0

    -- Initial platform pool configuration
    self.WindowStart = 0  -- Increases when people board train
    self.WindowEnd = 0 -- Increases naturally over time
    self.PassengersLeft = 0 -- Number of passengers that left trains

    -- Send things to client
    self:SetNW2Float("X0",self.PlatformX0)
    self:SetNW2Float("Sigma",self.PlatformSigma)
    self:SetNW2Int("WindowStart",self.WindowStart)
    self:SetNW2Int("WindowEnd",self.WindowEnd)
    self:SetNW2Int("PassengersLeft",self.PassengersLeft)
    self:SetNW2Vector("PlatformStart",self.PlatformStart)
    self:SetNW2Vector("PlatformEnd",self.PlatformEnd)
    self:SetNW2Vector("StationCenter",self:GetPos())

    -- FIXME make this nicer
    for i=1,32 do self:SetNW2Vector("TrainDoor"..i,Vector(0,0,0)) end
    self:SetNW2Int("TrainDoorCount",0)
    local ars_ents = ents.FindInSphere(self.PlatformEnd,768)
    for k,v in pairs(ars_ents) do
        local delta_z = math.abs(self.PlatformEnd.z-v:GetPos().z)
    end
end

function ENT:OnRemove()
    timer.Destroy("metrostroi_station_announce_"..self:EntIndex())
end

--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue(key, value)
    self.VMF = self.VMF or {}
    self.VMF[key] = value
end


--------------------------------------------------------------------------------
-- Process platform logic
--------------------------------------------------------------------------------
function erf(x)
    local a1 =  0.254829592
    local a2 = -0.284496736
    local a3 =  1.421413741
    local a4 = -1.453152027
    local a5 =  1.061405429
    local p  =  0.3275911

    -- Save the sign of x
    sign = 1
    if x < 0 then sign = -1 end
    x = math.abs(x)

    -- A&S formula 7.1.26
    t = 1.0/(1.0 + p*x)
    y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*math.exp(-x*x)

    return sign*y
end
local function CDF(x,x0,sigma) return 0.5 * (1 + erf((x - x0)/math.sqrt(2*sigma^2))) end
local function merge(t1,t2) for k,v in pairs(t2) do table.insert(t1,v) end end

function ENT:PopulationCount()
    local totalCount = self.WindowEnd - self.WindowStart
    if self.WindowStart > self.WindowEnd then totalCount = (self:PoolSize() - self.WindowStart) + self.WindowEnd end
    return totalCount
end

local empty_checked = {}
local function getTrainDriver(train,checked)
    if not checked then
        for k,v in pairs(empty_checked) do empty_checked[k] = nil end
        checked = empty_checked
    end
    if not IsValid(train) then return end
    if checked[train] then return end
    checked[train] = true

    local ply = train:GetDriver()
    if IsValid(ply) then -- and (train.KV.ReverserPosition ~= 0)
        return ply
    end

    return getTrainDriver(train.RearTrain,checked) or getTrainDriver(train.FrontTrain,checked)
end


function ENT:GetDoorState()
    if not self.Doors then
        self.Doors = {}
        local doors = ents.FindByName("station"..self.StationIndex.."_platform"..self.PlatformIndex.."_door")
        for _,v in pairs(doors) do
            table.insert(self.Doors,v)
        end
    end
    for _,v in pairs(self.Doors) do
        if v:GetSaveTable().m_toggle_state ~= 1 then return true end
    end
    return false
end


function ENT:CheckDoorRandomness()
    local train = v
    local randomness = train.DoorRandomness

    for _, value in pairs(randomness) do
        if value ~= -1 then
            return false
        end
    end
    return true
    
end


local dT = 0.25
local trains  = {}
function ENT:Think()

    --if not Metrostroi.Stations[self.StationIndex] then return end
    -- Send update to client
    self:SetNW2Int("WindowStart",self.WindowStart)
    self:SetNW2Int("WindowEnd",self.WindowEnd)
    self:SetNW2Int("PassengersLeft",self.PassengersLeft)




    local boardingDoorList = {}
    local CurrentTrain
    local TrainArrivedDist

    local PeopleGoing = false
    local boarding = false

    local BoardTime = 8+7
    for k,v in pairs(ents.FindByClass("gmod_subway_*")) do
        if v.Base ~= "gmod_subway_base" and v:GetClass() ~= "gmod_subway_base" then continue end
        if not IsValid(v) or v:GetPos():Distance(self:GetPos()) > self.PlatformStart:Distance(self.PlatformEnd) then continue end

        local platform_distance = ((self.PlatformStart-v:GetPos()) - ((self.PlatformStart-v:GetPos()):Dot(self.PlatformNorm))*self.PlatformNorm):Length()
        local vertical_distance = math.abs(v:GetPos().z - self.PlatformStart.z)
        if vertical_distance >= 192 or platform_distance >= 256 then continue end

        local minb,maxb = v:LocalToWorld(Vector(-480,0,0)),v:LocalToWorld(Vector(480,0,0)) --FIXME
        local train_start       = (maxb - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length()^2)
        local train_end         = (minb - self.PlatformStart):Dot(self.PlatformDir) / (self.PlatformDir:Length()^2)
        local left_side         = train_start > train_end
        if self.InvertSides then left_side = not left_side end


        local doors_open        = left_side and v.LeftDoorsOpen or not left_side and v.RightDoorsOpen
        if (train_start < 0) and (train_end < 0) then doors_open = false end
        if (train_start > 1) and (train_end > 1) then doors_open = false end

        if -0.2 < train_start and train_start < 1.2  then
            v.BoardTime = self.Timer and CurTime()-self.Timer
        end

        if 0 < train_start  and train_start < 1 and (not TrainArrivedDist or TrainArrivedDist < train_start)  then
            TrainArrivedDist = train_start
            CurrentTrain = v
        end

        
        passengers_can_board = doors_open
        

        -- Board passengers
        if passengers_can_board then
            -- Find player of the train
            local driver = getTrainDriver(v)

            -- Limit train to platform
            train_start = math.max(0,math.min(1,train_start))
            train_end = math.max(0,math.min(1,train_end))
            -- Check if this was the last stop
            if (v.LastPlatform ~= self) then
                v.LastPlatform = self
                if v.AnnouncementToLeaveWagonAcknowledged then v.AnnouncementToLeaveWagonAcknowledged = nil end

                -- How many passengers must leave on this station
                local proportion = math.random() * math.max(0,1.0 + math.log(self.PopularityIndex))
                if self.PlatformLast then proportion = 1 end
                if (v.AnnouncementToLeaveWagon == true) then proportion = 1 end
                -- Total count
                v.PassengersToLeave = math.floor(proportion * v:GetNW2Float("PassengerCount") + 0.5)
            end
            -- Check for announcement
            if v.AnnouncementToLeaveWagon and not v.AnnouncementToLeaveWagonAcknowledged then
                v.AnnouncementToLeaveWagonAcknowledged = true
            end
            -- Calculate number of passengers near the train
            local passenger_density = math.abs(CDF(train_start,self.PlatformX0,self.PlatformSigma) - CDF(train_end,self.PlatformX0,self.PlatformSigma))
            local passenger_count = passenger_density * self:PopulationCount()
            -- Get number of doors
            local door_count = #v.LeftDoorPositions
            if not left_side then door_count = #v.RightDoorPositions end

            -- Get maximum boarding rate for normal russian subway train doors
            local max_boarding_rate = 1.4 * door_count * dT
            -- Get boarding rate based on passenger density
            local boarding_rate = math.min(max_boarding_rate,passenger_count)
            if self.PlatformLast then boarding_rate = 0 end
            -- Get rate of leaving
            local leaving_rate = 1.4 * door_count * dT
            if v.PassengersToLeave == 0 and not v.AnnouncementToLeaveWagonAcknowledged then leaving_rate = 0 end
            if v.AnnouncementToLeaveWagonAcknowledged then leaving_rate = leaving_rate*1.5 end
            -- Board these passengers into train
            local boarded   = math.min(math.max(2,math.floor(boarding_rate+0.5)),v.AnnouncementToLeaveWagonAcknowledged and 0 or self:PopulationCount())
            local left      = math.min(math.max(2,math.floor(leaving_rate +0.5)),v.AnnouncementToLeaveWagonAcknowledged and v:GetNW2Int("PassengerCount") or v.PassengersToLeave)
            if math.random() <= math.Clamp(17-passenger_count,0,17)/17*0.5 then boarded = 0 end
            if math.random() <= math.Clamp(17-v.PassengersToLeave,0,17)/17*0.5 then left = 0 end
            local passenger_delta = boarded - left
            -- People board from platform
            if boarded > 0 then
                PeopleGoing = true
                self.WindowStart = (self.WindowStart + boarded) % self:PoolSize()
            end
            -- People leave to
            if left > 0 then
                PeopleGoing = true
                if IsValid(driver) then
                    driver:AddFrags(left)
                    driver.MTransportedPassengers = (driver.MTransportedPassengers or 0) + left
                end

                -- Move passengers
                v.PassengersToLeave = v.PassengersToLeave - left
                self.PassengersLeft = self.PassengersLeft + left
                if v.AnnouncementToLeaveWagonAcknowledged and not self.PlatformLast then
                    if math.random() > 0.3 then
                        self.WindowStart = (self.WindowStart - left) % self:PoolSize()
                    end
                elseif not self.PlatformLast and math.random() > 0.9 then
                    self.WindowStart = (self.WindowStart - left) % self:PoolSize()
                end
            end
            --[[ People boarded train
            if boarded > 0 then
                if IsValid(driver) then
                    driver:AddDeaths(boarded)
                end
            end]]
            -- Change number of people in train
            v:BoardPassengers(passenger_delta)

            -- Keep list of door positions
            if left_side then
                for k, vec in pairs(v.LeftDoorPositions) do
                    table.insert(boardingDoorList, v:LocalToWorld(vec))
                end
            else
                for k, vec in pairs(v.RightDoorPositions) do
                    table.insert(boardingDoorList, v:LocalToWorld(vec))
                end
            end
            if v.AnnouncementToLeaveWagonAcknowledged then
                BoardTime = math.max(BoardTime,8+7+(v.PassengersToLeave or 0)*dT*0.6)
            else
                BoardTime = math.max(BoardTime,8+7+math.max((v.PassengersToLeave or 0)*dT,self:PopulationCount()*dT)*0.5)
            end
            -- Add doors to boarding list
            --print("BOARDING",boarding_rate,"DELTA = "..passenger_delta,self.PlatformLast,v:GetNW2Int("PassengerCount"))
        end
        if v.UPO then v.UPO.AnnouncerPlay = self.AnnouncerPlay end
        v.BoardTimer = self.BoardTimer
        boarding = boarding or passengers_can_board
    end
    --if not boarding then CurrentTrain = nil end
    self.BoardTime = BoardTime
    if CurrentTrain and not self.CurrentTrain then
        self.CurrentTrain = CurrentTrain
    elseif not CurrentTrain and self.CurrentTrain then
        self.CurrentTrain = nil
    end

    -- Add passengers
    if (not self.PlatformLast) and (#boardingDoorList == 0) then
        local target = GetConVarNumber("metrostroi_passengers_scale",50)*self.PopularityIndex --300
        -- then target = target*0.1 end

        if target <= 0 then
            self.WindowEnd = self.WindowStart
        else
            local growthDelta = math.max(0,(target-self:PopulationCount())*0.005)
            if growthDelta < 1.0 then -- Accumulate fractional rate
                self.GrowthAccumulation = (self.GrowthAccumulation or 0) + growthDelta
                if self.GrowthAccumulation > 1.0 then
                    growthDelta = 1
                    self.GrowthAccumulation = self.GrowthAccumulation - 1.0
                end
            end
            self.WindowEnd = (self.WindowEnd + math.floor(growthDelta+0.5)) % self:PoolSize()
        end
    end

    if self.OldOpened ~= self:GetDoorState() or self.OldPeopleGoing ~= PeopleGoing then
        self.OldOpened = self:GetDoorState()
        self.OldPeopleGoing = PeopleGoing
    end
    if self.BoardingDoorListLength ~= #boardingDoorList then
        -- Send boarding list FIXME make this nicer
        for k,v in ipairs(boardingDoorList) do
            self:SetNW2Vector("TrainDoor"..k,v)
        end
        self:SetNW2Int("TrainDoorCount",#boardingDoorList)
    end
    self.BoardingDoorListLength = #boardingDoorList
    self:NextThink(CurTime() + dT)
    return true
end
