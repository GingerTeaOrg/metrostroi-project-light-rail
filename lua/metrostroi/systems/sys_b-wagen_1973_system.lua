Metrostroi.DefineSystem("duewag_b_1973")
function TRAIN_SYSTEM:Initialize()
    self.ReverserStates = {
        ["RH"] = -1,
        ["0"] = 0,
        ["*"] = 1,
        ["VH"] = 2,
        ["A"] = 3,
        ["Nf"] = 4,
        ["NF"] = 4
    }

    self.CircuitOn = 0
    self.IgnitionKeyA = false
    self.IgnitionKeyAIn = false
    self.UncoupleKeyA = false
    self.IgnitionKeyB = false
    self.IgnitionKeyBIn = false

    self.UncoupleKeyB = false
    self.ReverserA = 0 -- -1 = RH, 0 = 0, 1 = *, 2 = VH, 3 = A, 4 = Nf
    self.ReverserB = 0
    self.ThrottleStateA = 0
    self.ThrottleRateA = 0
    self.ThrottleStateB = 0
    self.ThrottleRateB = 0


    self.CircuitBreakerOn = false
    self.PreviousCircuitBreaker = false
    self.PantographRaised = false

    self.MirrorLeft = false
    self.MirrorRight = false
    self.WiperState = 0
    self.StepStates = {
        ["High"] = 1,
        ["Low"] = 2,
        ["Lowest"] = 3
    }

    self.DoorUnlockStates = {
        ["None"] = 0,
        ["Left"] = 1,
        ["Right"] = 2
    }

    self.DoorUnlockState = 0
    self.DoorStatesRight = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
    }

    self.DoorStatesLeft = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
    }

    self.StepStatesRight = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
        [5] = 1,
        [6] = 1,
    }

    self.StepStatesLeft = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
        [5] = 1,
        [6] = 1,
    }

    self.StopRequest = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
    }

    self.StepSetting = 1
    self.BlinkerStates = {
        ["Off"] = 0,
        ["Left"] = 1,
        ["Right"] = 2,
        ["Hazard"] = 3
    }

    self.BlinkerState = 0
    self.BrakesAreApplied = false
    self.AIsCoupled = false
    self.BIsCoupled = false
    ----blinker variables
    self.LastTriggerTime = 0
    self.BlinkerOn = false
    self.ConflictingHeads = false --more than one head is not reverser at "0"
    self.CoupledSections = {
        ["A"] = false,
        ["B"] = false
    }

    self.BatteryState = false
    self.PreviousBatteryState = false
end



--==============================================================================================
function TRAIN_SYSTEM:Think(dT)
    self.SectionB = self.Train.SectionB
    if IsValid(self.Train.SectionB) and not self.SetSectionBNW2Int then
        self:NW2()
    end
    if self.Train.Battery then
        print("arooooo")
        self.Train.Battery = self.Battery
        self.WriteTrainWire = self.Train.WriteTrainWire
        self.ReadTrainWire = self.Train.ReadTrainWire
        self.SetLightPower = self.Train.SetLightPower
        self.SetLightPowerB = self.Train.SectionB.SetLightPower
    end
    self.FrontCoupler = self.Train.FrontCouple or nil
    self.RearCoupler = self.Train.RearCouple or nil
    self.Lights = self.Train and self.Train.Lights or nil
    self.Panto = self.Train.Panto or nil
    self.Panel = self.Train.Panel
    self.PanelB = self.Train.SectionB.Panel
    self:ReverserParameters()
    self:ThrottleParameters()
    self:BlinkerHandler()
    self:BrakesApplied()
    self:BrakeLights()
    self:Headlights()
    self:Coupled()
    self:EnableTrainHead()
    self:ChargeBattery()
    self:BatteryOffForceLightsDark()
    self:StopRequestLoop()
    self:Traction()
    self:ReverserSystem()

    self.Speed = math.abs(self.Train:GetVelocity():Dot(self.Train:GetAngles():Forward()) * 0.06858)
end

--==============================================================================================
function TRAIN_SYSTEM:IgnitionKeyInOutA()
    local t = self.Train
    if self.IgnitionKeyAIn and not self.IgnitionKeyA then
        self.IgnitionKeyAIn = false
    elseif not self.IgnitionKeyAIn then
        self.IgnitionKeyAIn = true
    end
    t:SetNW2Bool("IgnitionKeyIn",self.IgnitionKeyAIn)
    self.Panel.IgnitionKeyInserted = self.IgnitionKeyAIn and 1 or 0
end
function TRAIN_SYSTEM:IgnitionKeyOnA()
    local t = self.Train
    self.IgnitionKeyA = true
    t:SetNW2Bool("IgnitionTurned",self.IgnitionKeyA)
end

function TRAIN_SYSTEM:IgnitionKeyOffA()
    local t = self.Train
    self.IgnitionKeyA = false
    t:SetNW2Bool("IgnitionTurned",self.IgnitionKeyA)
end
function TRAIN_SYSTEM:IgnitionKeyInOutB()
    if self.IgnitionKeyBIn and not self.IgnitionKeyB then
        self.IgnitionKeyBIn = false
    elseif not self.IgnitionKeyBIn then
        self.IgnitionKeyBIn = true
    end
    self:SetSectionBNW2Bool("IgnitionKeyIn",self.IgnitionKeyBIn)
    self.PanelB.IgnitionKeyInserted = self.IgnitionKeyBIn and 1 or 0
end
function TRAIN_SYSTEM:Coupled()
    self.CoupledSections["A"] = IsValid(self.FrontCoupler.CoupledEnt)
    self.CoupledSections["B"] = IsValid(self.RearCoupler.CoupledEnt)
end

function TRAIN_SYSTEM:AllReversersInConsistZero()
    local reversers = 0
    local checkList = {}
    for _, v in pairs(self.Train.WagonList) do
        if v.CoreSys.ReverserStateA ~= 0 or v.CoreSys.ReverserStateB ~= 0 and not checkList[k] then
            reversers = reversers + 1
            checkList[v] = true
        end
    end

    return reversers
end

function TRAIN_SYSTEM:EnableTrainHead()
    self.ConflictingHeads = self:AllReversersInConsistZero() > 1
    if not self.ConflictingHeads and (self.ReverserStateA == 1 or self.ReverserStateB == 1) then
        self.CircuitBreakerUnlocked = true
    end
end

function TRAIN_SYSTEM:BatteryOn()
    if self.CircuitBreakerUnlocked then
        self.CircuitBreakerOn = true
    end
end

function TRAIN_SYSTEM:BatteryOff()
    if self.CircuitBreakerUnlocked then
        self.CircuitBreakerOn = false
    end
end

function TRAIN_SYSTEM:ReverserParameters()
    local train = self.Train
    local SectionB = train.SectionB
    train:SetNW2Int("ReverserLever", self.ReverserA + 1) --set the networked int for the reverser anim. We use a table clientside that starts at 0 so just +1 to current variable value
    SectionB:SetNW2Int("ReverserLever", self.ReverserB + 1)
end

function TRAIN_SYSTEM:ThrottleParameters()
    --map the -100 to 100 range to 0 to 100 on the pose parameter
    local function lerp(x, x0, x1, y0, y1)
        return y0 + (y1 - y0) * ((x - x0) / (x1 - x0))
    end

    local train = self.Train
    local SectionB = train.SectionB
    self.ThrottleStateA = math.Clamp(self.ThrottleStateA, -100, 100) --clamp the values in order to avoid some weirdness. We're only looking for -100% and 100%
    self.ThrottleStateB = math.Clamp(self.ThrottleStateB, -100, 100)
    local poseParam = lerp(self.ThrottleStateA, -100, 100, 0, 100)
    poseParam = math.Clamp(poseParam, 0, 100)
    train:SetNW2Int("ThrottleLever", poseParam)
    local poseParam2 = lerp(self.ThrottleStateB, -100, 100, 0, 100)
    poseParam2 = math.Clamp(poseParam2, 0, 100)
    SectionB:SetNW2Int("ThrottleLever", poseParam2)
    self.ThrottleStateA = math.Clamp(self.ThrottleStateA + self.ThrottleRateA, -100, 100)
    self.ThrottleStateB = math.Clamp(self.ThrottleStateB + self.ThrottleRateB, -100, 100)
end

---------------------------------------
function TRAIN_SYSTEM:ReverserDownA()
    if self.ReverserA == -1 or not self.IgnitionKeyA then return end
    self.ReverserA = self.ReverserA - 1
end

function TRAIN_SYSTEM:ReverserUpA()
    if self.ReverserA == 4 or not self.IgnitionKeyA then return end
    self.ReverserA = self.ReverserA + 1
end

function TRAIN_SYSTEM:ReverserDownB()
    if self.ReverserB == -1 or not self.IgnitionKeyB then return end
    self.ReverserB = self.ReverserB - 1
end

function TRAIN_SYSTEM:ReverserUpB()
    if self.ReverserB == 4 or not self.IgnitionKeyB then return end
    self.ReverserB = self.ReverserB + 1
end

----------------------------------------
function TRAIN_SYSTEM:BlinkerHandler()
    local blinkerLeft = self.Panel.BlinkerLeft > 0
    local blinkerRight = self.Panel.BlinkerRight > 0
    local hazard = self.Panel.HazardBlink > 0
    self:Blink(blinkerLeft or blinkerRight or hazard, blinkerLeft or hazard, blinkerRight or hazard)
end

function TRAIN_SYSTEM:Blink(enable, left, right)
    if not self.CircuitBreakerOn or self:ReadTrainWire(6) < 1 then return end
    if not enable then
        self.BlinkerOn = false
        self.LastTriggerTime = CurTime()
    elseif CurTime() - self.LastTriggerTime > 0.4 then
        self.BlinkerOn = not self.BlinkerOn
        self.LastTriggerTime = CurTime()
    end

    self:SetLightPower(58, self.BlinkerOn and left)
    self:SetLightPower(48, self.BlinkerOn and left)
    self:SetLightPower(59, self.BlinkerOn and right)
    self:SetLightPower(49, self.BlinkerOn and right)
    self:SetLightPower(38, self.BlinkerOn and right or left and self.BlinkerOn)
    self:SetLightPower(56, self.BlinkerOn and left and right)
    self:SetLightPower(57, self.BlinkerOn and left and right)
    if self.BrakesAreApplied == true and left and right and not self.BIsCoupled then
        -- if the brakes are applied and the blinkers are on
        self.SectionB:SetLightPower(66, self.BlinkerOn and left and right)
        self.SectionB:SetLightPower(67, self.BlinkerOn and left and right)
    elseif self.BrakesAreApplied == true and left and right and self.BIsCoupled then
        -- if the brakes are applied and the blinkers are not on
        -- self.SectionB:SetLightPower(66,true)
        -- self.SectionB:SetLightPower(67,true)
        -- if the brakes are applied and the blinkers are on
        self.SectionB:SetLightPower(66, false)
        self.SectionB:SetLightPower(67, false)
    elseif self.BrakesAreApplied == false and left and right and not self.BIsCoupled then
        -- if the brakes are not applied and the blinkers are on
        self.SectionB:SetLightPower(66, self.BlinkerOn and left and right)
        self.SectionB:SetLightPower(67, self.BlinkerOn and left and right)
        self.SectionB:SetLightPower(66, false)
        self.SectionB:SetLightPower(67, false)
    end

    self.SectionB:SetLightPower(148, self.BlinkerOn and left)
    self.SectionB:SetLightPower(158, self.BlinkerOn and left)
    self.SectionB:SetLightPower(149, self.BlinkerOn and right)
    self.SectionB:SetLightPower(159, self.BlinkerOn and right)
    self.Train:SetNW2Bool("BlinkerTick", self.BlinkerOn) -- one tick sound for the blinker relay
end

function TRAIN_SYSTEM:BrakesApplied()
    self.BrakesAreApplied = self.ThrottleStateA < 0 or self.ThrottleStateB < 0
end

function TRAIN_SYSTEM:Headlights()
    if self.Panel.Headlights < 1 or self.PanelB.Headlights < 1 then return end
    if self.ReverserStateA > 1 then
        self:SetLightPower(1, true)
        self:SetLightPower(2, true)
        self:SetLightPower(3, true)
        self:SetLightPower(4, false)
        self:SetLightPower(5, false)
        self:SetLightPowerB(1, false)
        self:SetLightPowerB(2, false)
        self:SetLightPowerB(3, false)
        self:SetLightPowerB(4, true)
        self:SetLightPower(5, true)
    else
        self:SetLightPower(1, false)
        self:SetLightPower(2, false)
        self:SetLightPower(3, false)
        self:SetLightPower(4, true)
        self:SetLightPower(5, true)
        self:SetLightPowerB(1, true)
        self:SetLightPowerB(2, true)
        self:SetLightPowerB(3, true)
        self:SetLightPowerB(4, false)
        self:SetLightPowerB(5, false)
    end
end

function TRAIN_SYSTEM:BrakeLights()
    if not self.Battery then return end
    if self.Battery.Voltage < 5 then
        self:SetLightPower(6, false)
        self:SetLightPower(7, false)
        self:SetLightPowerB(6, false)
        self:SetLightPowerB(7, false)
        return
    end

    self:SetLightPower(6, self.CoupledSections["A"] and self.BrakesAreApplied)
    self:SetLightPower(7, self.CoupledSections["A"] and self.BrakesAreApplied)
    self:SetLightPowerB(6, self.CoupledSections["B"] and self.BrakesAreApplied)
    self:SetLightPowerB(7, self.CoupledSections["B"] and self.BrakesAreApplied)
end

function TRAIN_SYSTEM:ChargeBattery()
    if not self.CircuitBreakerOn then return end
    self.Battery:TriggerInput("Charge", self.PantoUp and 5 or 0)
end

function TRAIN_SYSTEM:BatteryOffForceLightsDark() --just so we don't have to do it anywhere else, if the battery state is off, make sure any light is off
    if not self.Lights then return end --guard against race condition while the train is loading
    if self.CircuitBreakerOn then self.PreviousCircuitBreaker = self.CircuitBreakerOn end
    if self.PreviousCircuitBreaker ~= self.CircuitBreakerOn and not self.CircuitBreakerOn then
        self.PreviousCircuitBreaker = false
        for k,_ in ipairs(self.Lights) do
            self:SetLightPower(k,false)
        end
    end
end

-- Are the doors unlocked, sideLeft,sideRight,door1 open, unlocked while reverser on * position
function TRAIN_SYSTEM:DoorHandler(unlock, left, right, door1, idleunlock, dT)
    local WagonList = self.Train.WagonList
    local irStatus = self:IRIS(true)
    local inverseStopRequest = {
        [6] = 1,
        [5] = 2,
        [4] = 3,
        [3] = 4,
        [2] = 5,
        [1] = 6
    }
    -- simulate the relay system for triggering the departure chime. One for MU mode, one for SU mode.
    if self:ReadTrainWire(6) > 0 then
        for i = 1, #WagonList do
            -- Exempt the door1 button, because that's not a passenger transfer. That's for special drivers' issues. 
            -- The doors right by the cab can be unlocked without having to unblock all doors and risk passengers.
            if right and not door1 then
                local DoorStatesPerCar = WagonList[i].CoreSys.DoorStatesRight
                for j = 1, 6 do
                    if DoorStatesPerCar[j] ~= 0 then
                        self.ArmDoorsClosedAlarm = true
                        self.DoorsClosed = false
                        break -- if even a single door is open, we don't need to check for anything else. Just quit because we've set the flag already.
                    else
                        self.DoorsClosed = true
                    end
                end
            elseif left and not door1 then
                local DoorStatesPerCar = WagonList[i].CoreSys.DoorStatesLeft
                for j = 1, 6 do
                    if DoorStatesPerCar[j] ~= 0 then
                        self.ArmDoorsClosedAlarm = true
                        self.DoorsClosed = false
                        break
                    else
                        self.DoorsClosed = true
                    end
                end
            end
        end
    elseif right and not door1 then
        for i = 1, 6 do
            local DoorStatesPerCar = self.DoorStatesRight
            if DoorStatesPerCar[i] ~= 0 then
                self.ArmDoorsClosedAlarm = true --arm departure notice bell
                self.DoorsClosed = false
                break
            else
                self.DoorsClosed = true
            end
        end
    elseif left and not door1 then
        if self:ReadTrainWire(6) < 1 then
            for i = 1, 6 do
                local DoorStatesPerCar = self.DoorStatesLeft
                if DoorStatesPerCar[i] ~= 0 then
                    self.ArmDoorsClosedAlarm = true
                    self.DoorsClosed = false
                    break
                else
                    self.DoorsClosed = true
                end
            end
        end
    end
    self:NW2Bool("DoorChime",(self.ArmDoorsClosedAlarm and self.DoorsClosed))
    if self.DoorsClosed and self.ArmDoorsClosedAlarm then self.ArmDoorsClosedAlarm = true end
-------------------------------------------------------------------------------------
--    ↑ checking whether doors are open anywhere | ↓ Actually controlling the doors
--------------------------------------------------------------------------------------

    -- door1 control according to side preselection
    if right and door1 then
        if self.DoorStatesRight[1] < 1 then
            self.DoorStatesRight[1] = self.DoorStatesRight[1] + 0.13
            math.Clamp(self.DoorStatesRight[1], 0, 1)
        end
    elseif left and door1 then
        if self.DoorStatesLeft[4] < 1 then
            self.DoorStatesLeft[4] = self.DoorStatesLeft[4] + 0.13
            math.Clamp(self.DoorStatesLeft[4], 0, 1)
        end
    end
--------------------------------------------------------
    if unlock then
        self.DoorsPreviouslyUnlocked = true
        self.DoorLockSignalMoment = 0
        -- randomise door closing for more realistic behaviour. People are sometimes going to block the doors for a bit, or the relays don't respond in sync.
        if not self.DoorCloseMomentsCaptured then
            self.DoorCloseMoments[1] = math.random(1, 4)
            self.DoorCloseMoments[2] = math.random(1, 4)
            self.DoorCloseMoments[3] = math.random(1, 4)
            self.DoorCloseMoments[4] = math.random(1, 4)
            self.DoorCloseMoments[5] = math.random(1, 4)
            self.DoorCloseMoments[6] = math.random(1, 4)
            self.DoorCloseMomentsCaptured = true
        end

        if right then
            -- pick doors to be unlocked
            if not self.RandomnessCalulated then
                for i, v in ipairs(self.DoorRandomness) do
                    if i <= 6 and v < 0 then
                        --we recycle the door randomness value as a general signal for requesting a door to open, and if a stop request originated from that door, always open it
                        self.DoorRandomness[i] = self.StopRequestRight[i] and 3 or math.random(0, 4) 
                        -- print(self.DoorRandomness[i], "doorrandom", i)
                        self.RandomnessCalculated = true
                        break
                    end
                end
            end

            -- increment the door states
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesRight[i] < 1 then
                    self.DoorStatesRight[i] = self.DoorStatesRight[i] + 0.2 * dT
                end
                math.Clamp(self.DoorStatesRight[i], 0, 1)
            end
        elseif left then
            -- pick a random door to be unlocked
            if self.RandomnessCalulated ~= true then
                for i, v in ipairs(self.DoorRandomness) do
                    if i <= 4 and v < 0 then
                        -- the carriage does not seem to differentiate between a stop request done on the left or right side, just at what position the door is,
                        -- so just invert the stop request index in order to account for the fact we're counting A to B as 1 to 6, and B to A as 1 to 6 for door n°
                        self.DoorRandomness[i] = self.StopRequest[inverseStopRequest[i]] and 3 or math.random(0, 4) 
                        self.RandomnessCalculated = true
                        break
                    end
                end
            end

            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesLeft[i] < 1 then
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.2 * dT
                    math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end
        end
    elseif not unlock then
        if self.DoorLockSignalMoment == 0 then
            self.DoorLockSignalMoment = CurTime()
        end
        self.DoorCloseMomentsCaptured = false --reset the flag for the randomness of closing the doors

        if right then
            for i, v in ipairs(self.DoorStatesRight) do
                if CurTime() > self.DoorLockSignalMoment + self.DoorCloseMoments[i] and not irStatus[i] and v > 0 then
                    self.DoorStatesRight[i] = self.DoorStatesRight[i] - 0.20 * dT
                    self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
                end
            end
        elseif left then
            for i, v in ipairs(self.DoorStatesLeft) do
                if CurTime() > self.DoorLockSignalMoment + self.DoorCloseMoments[i] and not irStatus[i] and v > 0 then
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.20 * dT
                    self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end
        end
    elseif idleunlock then
        -- If the Reverser is set to *, the doors automatically close again after five seconds
        if right then
            local opened
            -- Iterate through each door with random behavior
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesRight[i] < 1 then
                    if self.DoorOpenMoments[i] == 0 then
                        self.DoorStatesRight[i] = self.DoorStatesRight[i] + 0.2 * dT
                        self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
                    end
                elseif self.DoorStatesRight[i] > 0 and self.DoorOpenMoments[i] < CurTime() - 5 then
                    -- If five seconds have passed, close the door
                    if not irStatus[i] then
                        self.DoorStatesRight[i] = self.DoorStatesRight[i] - 0.2 * dT
                        self.DoorStatesRight[i] = math.Clamp(self.DoorStatesRight[i], 0, 1)
                    end
                end

                if self.DoorStatesRight[i] == 1 and not opened then
                    self.DoorOpenMoments[i] = CurTime() -- Record the moment the door opened
                    opened = true
                elseif self.DoorStatesRight[i] == 0 then
                    self.DoorOpenMoments[i] = 0
                    opened = false
                end
            end
        elseif left then
            local opened
            -- Similar logic for the left doors
            for i, v in ipairs(self.DoorRandomness) do
                if v == 3 and self.DoorStatesLeft[i] < 1 then
                    if self.DoorStatesLeft[i] == 1 then
                        self.DoorOpenMoments[i] = CurTime()
                    elseif self.DoorOpenMoments[i] == 0 then
                        self.DoorStatesLeft[i] = self.DoorStatesLeft[i] + 0.1
                        self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
                    end
                elseif self.DoorStatesLeft[i] > 0 and CurTime() - self.DoorOpenMoments[i] > 5 and not irStatus[i] then
                    self.DoorStatesLeft[i] = self.DoorStatesLeft[i] - 0.1
                    self.DoorStatesLeft[i] = math.Clamp(self.DoorStatesLeft[i], 0, 1)
                end
            end

            if self.DoorStatesLeft[i] == 1 and not opened then
                self.DoorOpenMoments[i] = CurTime()
                opened = true
            end
        end
    end
end

function TRAIN_SYSTEM:IRIS(enable)
    -- IR sensors for blocking the doors
    local train = self.Train
    local trainB = self.Train.SectionB
    if not enable then return end
    local result1 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(452.36, -48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(452.36, -48.03, 76.3)) + train:GetForward() * 80,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result2 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(265.748, -48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(265.748, -48.03, 76.3)) + train:GetForward() * 80,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result3 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(110.236, -48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(110.236, -48.03, 76.3)) + train:GetForward() * 70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result4 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(-110.236, -48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(-110.236, -48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result5 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(-265.748, -48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(-265.748, -48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result6 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(-452.36, -48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(-452.36, -48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result7 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(-452.36, 48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(-452.36, 48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result8 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(-265.748, 48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(-265.748, 48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result9 = util.TraceHull(
        {
            start = trainB:LocalToWorld(Vector(110.236, 48.03, 76.3)),
            endpos = trainB:LocalToWorld(Vector(110.236, 48.03, 76.3)) + trainB:GetForward() * -70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result10 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(110.236, 48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(110.236, 48.03, 76.3)) + train:GetForward() * 70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result11 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(265.748, 48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(265.748, 48.03, 76.3)) + train:GetForward() * 70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local result12 = util.TraceHull(
        {
            start = train:LocalToWorld(Vector(452.36, 48.03, 76.3)),
            endpos = train:LocalToWorld(Vector(452.36, 48.03, 76.3)) + train:GetForward() * 70,
            mask = MASK_PLAYERSOLID,
            filter = {train}, -- filter out the train entity
            mins = Vector(-24, -2, 0),
            maxs = Vector(24, 2, 1)
        }
    )

    local status = {} -- Store the status in a table
    status[1] = IsValid(result1.Entity) and (result1.Entity:IsPlayer() or result1.Entity:IsNPC())
    status[2] = IsValid(result2.Entity) and (result2.Entity:IsPlayer() or result2.Entity:IsNPC())
    status[3] = IsValid(result3.Entity) and (result3.Entity:IsPlayer() or result3.Entity:IsNPC())
    status[4] = IsValid(result4.Entity) and (result4.Entity:IsPlayer() or result4.Entity:IsNPC())
    status[5] = IsValid(result5.Entity) and (result5.Entity:IsPlayer() or result5.Entity:IsNPC())
    status[6] = IsValid(result6.Entity) and (result6.Entity:IsPlayer() or result6.Entity:IsNPC())
    status[7] = IsValid(result7.Entity) and (result7.Entity:IsPlayer() or result7.Entity:IsNPC())
    status[8] = IsValid(result8.Entity) and (result8.Entity:IsPlayer() or result8.Entity:IsNPC())
    status[9] = IsValid(result9.Entity) and (result9.Entity:IsPlayer() or result9.Entity:IsNPC())
    status[10] = IsValid(result10.Entity) and (result10.Entity:IsPlayer() or result10.Entity:IsNPC())
    status[11] = IsValid(result11.Entity) and (result11.Entity:IsPlayer() or result11.Entity:IsNPC())
    status[12] = IsValid(result12.Entity) and (result12.Entity:IsPlayer() or result12.Entity:IsNPC())

    return status
end

function TRAIN_SYSTEM:StopRequestLoop()
    for k,v in ipairs(self.StopRequest) do
        if v then
            self.StopRequestDetected = true
            break
        end
    end
end


function TRAIN_SYSTEM:NW2()
    self.SetSectionBNW2Int = self.Train.SectionB.SetNW2Int
    self.SetSectionBNW2Float = self.Train.SectionB.SetNW2Float
    self.SetSectionBNW2String = self.Train.SectionB.SetNW2String
    self.SetSectionBNW2Bool = self.Train.SectionB.SetNW2Bool
    self.SetNW2Int = self.Train.SetNW2Int
    self.SetNW2Float = self.Train.SetNW2Float
    self.SetNW2String = self.Train.SetNW2String
    self.SetNW2Bool = self.Train.SetNW2Bool
end

function TRAIN_SYSTEM:Traction()
    local t = self.Train
    if self.ReverserStateA ~= 0 and self.ReverserStateA ~= 1 and not self.ConflictingHeads and self.IgnitionKeyA then
        t:WriteTrainWire(1,self.ThrottleStateA * .001)
    elseif self.ReverserStateB ~= 0 and self.ReverserStateB ~= 1 and not self.ConflictingHeads and self.IgnitionKeyB then
        t:WriteTrainWire(1,self.ThrottleStateB * .001)
    end
end

function TRAIN_SYSTEM:ReverserSystem()
    local t = self.Train

    t:WriteTrainWire(3,self.ReverserA >= 2 and 1 or 0)
    t:WriteTrainWire(4,self.ReverserB == -1 and 1 or 0)
end