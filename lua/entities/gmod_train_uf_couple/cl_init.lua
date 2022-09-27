include("shared.lua")

function ENT:Initialize()
end

function ENT:OnRemove()
end

--------------------------------------------------------------------------------
function ENT:Think()
end

function ENT:Animate(clientProp, value, min, max, speed, damping, stickyness)
    local id = clientProp
    if not self.Anims[id] then
        self.Anims[id] = {}
        self.Anims[id].val = value
        self.Anims[id].value = min + (max-min)*value
        self.Anims[id].V = 0.0
        self.Anims[id].block = false
        self.Anims[id].stuck = false
        self.Anims[id].P = value
    end
    if self.Hidden[id] or self.Hidden.anim[id] then return 0 end
    if self.Anims[id].Ignore then
        if RealTime()-self.Anims[id].Ignore < 0 then
            return self.Anims[id].value
        else
            self.Anims[id].Ignore = nil
        end
    end
    local val = self.Anims[id].val
    if value ~= val then
        self.Anims[id].block = false
    end
    if self.Anims[id].block then
        if self.Anims[id].reload and IsValid(self.ClientEnts[clientProp]) then
            self.ClientEnts[clientProp]:SetPoseParameter("position",self.Anims[id].value)
            self.Anims[id].reload = false
        end
        return self.Anims[id].value--min + (max-min)*self.Anims[id].val
    end
    --if self["_anim_old_"..id] == value then return self["_anim_old_"..id] end
    -- Generate sticky value
    if stickyness and damping then
        if (math.abs(self.Anims[id].P - value) < stickyness) and (self.Anims[id].stuck) then
            value = self.Anims[id].P
            self.Anims[id].stuck = false
        else
            self.Anims[id].P = value
        end
    end
    local dT = FrameTime()--self.DeltaTime
    if damping == false then
        local dX = speed * dT
        if value > val then
            val = val + dX
        end
        if value < val then
            val = val - dX
        end
        if math.abs(value - val) < dX then
            val = value
            self.Anims[id].V = 0
        else
            self.Anims[id].V = dX
        end
    else
        -- Prepare speed limiting
        local delta = math.abs(value - val)
        local max_speed = 1.5*delta / dT
        local max_accel = 0.5 / dT

        -- Simulate
        local dX2dT = (speed or 128)*(value - val) - self.Anims[id].V * (damping or 8.0)
        if dX2dT >  max_accel then dX2dT =  max_accel end
        if dX2dT < -max_accel then dX2dT = -max_accel end

        self.Anims[id].V = self.Anims[id].V + dX2dT * dT
        if self.Anims[id].V >  max_speed then self.Anims[id].V =  max_speed end
        if self.Anims[id].V < -max_speed then self.Anims[id].V = -max_speed end

        val = math.max(0,math.min(1,val + self.Anims[id].V * dT))

        -- Check if value got stuck
        if (math.abs(dX2dT) < 0.001) and stickyness and (dT > 0) then
            self.Anims[id].stuck = true
        end
    end
    local retval = min + (max-min)*val
    if IsValid(self.ClientEnts[clientProp]) then
        self.ClientEnts[clientProp]:SetPoseParameter("position",retval)
    end
    if math.abs(self.Anims[id].V) == 0 and math.abs(val-value) == 0 and not self.Anims[id].stuck then
        self.Anims[id].block = true
    end

    self.Anims[id].val = val
    self.Anims[id].oldival = value
    self.Anims[id].oldspeed = speed
    self.Anims[id].value = retval
    return retval
end
