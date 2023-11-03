include("shared.lua")

function ENT:Initialize()
    self.Anims = {}
    self.DeltaTime = 0
    self.PrevTime = 0
    self.PantoHeight = 0
    self.PantoRaised = false
    self.FirstRaise = true
    self.PantoHeight = self:GetNW2Vector("PantoHeight",Vector(0,0,0))
    self.PantoHeightTab = {}
    self.SoundPlayed = false
    self.Sounds = {}
end
function ENT:Think()
    if IsValid(self:GetNW2Entity("TrainEntity")) then
        self.Train = self:GetNW2Entity("TrainEntity")
    end
    self.PantoRaised = self.Train:GetNW2Bool("PantoUp",false)
    self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
    
    if self.PantoRaised == true then
        if not self.PantoMomentRegistered then
            self.PantoMomentRegistered = true
            self.PantoMoment = CurTime()
        end
        if self.SoundPlayed == false and CurTime() - self.PantoMoment > ((self.PantoHeight.z / 117 * 100) / 100) * 1.5 then --calculate the current percentage of the panto pased on the maximum extension. Extending the panto to full takes 1.5sec, calculate how long it takes at every height.
            self.SoundPlayed = true
            
            self:PlayOnceFromPos("plonk","lilly/uf/common/panto_applied.mp3",2,1,0,2,self:GetPos() + Vector(0,0,self.PantoHeight.z))
            
        end
        self.PantoHeight = self:GetNW2Vector("PantoHeight",Vector(0,0,0))
         
    elseif self.PantoRaised == false then
         self.PantoHeight = Vector(0,0,0)
         self.SoundPlayed = false
         self.FirstRaise = true
         self.PantoMomentRegistered = false
    end
    self.PantoHeight.z = math.Round(self.PantoHeight.z,2)
    self:Draw()
    print(self.PantoHeight.z)
end

function ENT:Draw()
    self:DrawModel()
    --self:Debug()
    if self.PantoRaised == true then
        if self.FirstRaise == true then
            self:SetPoseParameter("position",self:Animate("1",(self.PantoHeight.z - 9) / (117 - 10),0,100,1.5,2,0))
        else
            self:SetPoseParameter("position",self:Animate("1",(self.PantoHeight.z - 9) / (117 - 10),0,100,0.1,1,1))
        end
       
    else
        self:SetPoseParameter("position",self:Animate("1",0,0,100,0.1,0,1))
        self.FirstRaise = true
    end
    
    self:InvalidateBoneCache()

    
end

--------------------------------------------------------------------------------
-- Animation function
--------------------------------------------------------------------------------
function ENT:Animate(clientProp, value, min, max, speed, damping, stickyness)
    local id = clientProp
    if not self.Anims[id] then
        self.Anims[id] = {}
        self.Anims[id].val = value
        self.Anims[id].V = 0.0
    end

    if damping == false then
        local dX = speed * self.DeltaTime
        if value > self.Anims[id].val then
            self.Anims[id].val = self.Anims[id].val + dX
        end
        if value < self.Anims[id].val then
            self.Anims[id].val = self.Anims[id].val - dX
        end
        if math.abs(value - self.Anims[id].val) < dX then
            self.Anims[id].val = value
        end
    else
        -- Prepare speed limiting
        local delta = math.abs(value - self.Anims[id].val)
        local max_speed = 1.5*delta / self.DeltaTime
        local max_accel = 0.5 / self.DeltaTime

        -- Simulate
        local dX2dT = (speed or 128)*(value - self.Anims[id].val) - self.Anims[id].V * (damping or 8.0)
        if dX2dT >  max_accel then dX2dT =  max_accel end
        if dX2dT < -max_accel then dX2dT = -max_accel end

        self.Anims[id].V = self.Anims[id].V + dX2dT * self.DeltaTime
        if self.Anims[id].V >  max_speed then self.Anims[id].V =  max_speed end
        if self.Anims[id].V < -max_speed then self.Anims[id].V = -max_speed end

        self.Anims[id].val = math.max(0,math.min(1,self.Anims[id].val + self.Anims[id].V * self.DeltaTime))

        -- Check if value got stuck
        if (math.abs(dX2dT) < 0.001) and stickyness and (self.DeltaTime > 0) then
            self.Anims[id].stuck = true
        end
    end
    
    return min + (max-min)*self.Anims[id].val
end

function ENT:Debug()
    local mins = self:GetNWVector("mins",Vector(-24,-24,0))
    local maxs = self:GetNWVector("maxs",Vector(24,24,3))
    --print(self:GetPos())
    render.DrawWireframeBox( self:GetPos(), self:GetAngles(), Vector( -2,-24,0 ), Vector(maxs.x,maxs.y,self.PantoHeight.z), Color( 255, 255, 255 ), true )
end