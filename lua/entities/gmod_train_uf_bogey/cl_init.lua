include("shared.lua")

--------------------------------------------------------------------------------
function ENT:ReinitializeSounds()
    -- Bogey-related sounds
    self.SoundNames = {}
    self.EngineSNDConfig = {}

    self.SoundNames["ted1_703"]  = "lilly/uf/bogeys/u2/test/engine_loop_primary.mp3"
    self.SoundNames["ted2_703"]  = "lilly/uf/bogeys/u2/test/engine_loop_secondary.mp3"
    self.SoundNames["ted3_703"]  = "lilly/uf/bogeys/u2/drive_30_new.wav"
    self.SoundNames["ted4_703"]  = "lilly/uf/bogeys/u2/drive_40_new.wav"
    self.SoundNames["ted5_703"]  = "lilly/uf/bogeys/u2/drive_50.wav"
    self.SoundNames["ted6_703"]  = "lilly/uf/bogeys/u2/drive_60.wav"
    self.SoundNames["ted7_703"]  = "lilly/uf/bogeys/u2/drive_70.mp3"
    self.SoundNames["ted8_703"]  = "lilly/uf/bogeys/u2/drive_80.wav"
    --[[self.SoundNames["ted9_703"]  = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted10_703"] = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted11_703"] = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["tedm_703"]  = "lilly/uf/bogeys/u2/test/engine_loop_primary.wav"

    --[[self.SoundNames["ted1_703"]  = "lilly/uf/bogeys/u2/newloops/drive_10.wav"
    self.SoundNames["ted2_703"]  = "lilly/uf/bogeys/u2/newloops/drive_20.wav"
    self.SoundNames["ted3_703"]  = "lilly/uf/bogeys/u2/newloops/drive_30.wav"
    self.SoundNames["ted4_703"]  = "lilly/uf/bogeys/u2/newloops/drive_40.wav"
    self.SoundNames["ted5_703"]  = "lilly/uf/bogeys/u2/newloops/drive_50.wav"
    self.SoundNames["ted6_703"]  = "lilly/uf/bogeys/u2/drive_60_new.wav"
    self.SoundNames["ted7_703"]  = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted8_703"]  = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted9_703"]  = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted10_703"] = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["ted11_703"] = "lilly/uf/bogeys/u2/drive_70.wav"
    self.SoundNames["tedm_703"]  = "lilly/uf/bogeys/u2/engine_loop_start.wav"]]

    self.SoundNames["ted1_717"]  = "subway_trains/bogey/engines/717/engines_8.wav"
    self.SoundNames["ted2_717"]  = "subway_trains/bogey/engines/717/engines_16.wav"
    self.SoundNames["ted3_717"]  = "subway_trains/bogey/engines/717/engines_24.wav"
    self.SoundNames["ted4_717"]  = "subway_trains/bogey/engines/717/engines_32.wav"
    self.SoundNames["ted5_717"]  = "subway_trains/bogey/engines/717/engines_40.wav"
    self.SoundNames["ted6_717"]  = "subway_trains/bogey/engines/717/engines_48.wav"
    self.SoundNames["ted7_717"]  = "subway_trains/bogey/engines/717/engines_56.wav"
    self.SoundNames["ted8_717"]  = "subway_trains/bogey/engines/717/engines_64.wav"
    self.SoundNames["ted9_717"]  = "subway_trains/bogey/engines/717/engines_72.wav"
    self.SoundNames["ted10_717"] = "subway_trains/bogey/engines/717/engines_80.wav"

    self.SoundNames["ted11_720"] = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted1_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted2_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted3_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted4_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted5_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted6_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted7_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted8_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted9_720"]  = "lilly/uf//u2/engineloop_test.wav"
    self.SoundNames["ted10_720"] = "lilly/uf//u2/engineloop_test.wav"
    --*0.975
    --*1.025
    self.SoundNames["flangea"]      = "lilly/uf/bogeys/u2/curvehighspeed.wav"
    self.SoundNames["flangeb"]      = "lilly/uf/bogeys/u2/curvesqueal_a.wav"
    self.SoundNames["flange1"]      = "lilly/uf/bogeys/u2/curvesqueal_b.wav"
    self.SoundNames["flange2"]      = "lilly/uf/bogeys/u2/curvesqueal2.wav"
    self.SoundNames["brakea_loop1"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brakea_loop2"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_loop1"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_loop2"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_loop3"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_loop4"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_loopb"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake2_loop1"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake2_loop2"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_squeal1"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"
    self.SoundNames["brake_squeal2"]       = "lilly/uf/bogeys/u2/brake_squeal.wav"

    -- Remove old sounds
    if self.Sounds then
        for k,v in pairs(self.Sounds) do
            v:Stop()
        end
    end

    -- Create sounds
    self.Sounds = {}
    self.Playing = {}
    for k,v in pairs(self.SoundNames) do
        --if not file.Exists(v, "MOD") then
--          self.SoundNames[k] = nil
        --end
        util.PrecacheSound(v)
        local e = self
        if (k == "brake3a") and IsValid(self:GetNW2Entity("TrainWheels")) then
            e = self:GetNW2Entity("TrainWheels")
        end
        self.Sounds[k] = CreateSound(e, Sound(v))
    end

    self.Async = nil
    self.MotorSoundType = nil
end
function ENT:SetSoundState(sound,volume,pitch,name,level )
    if not self.Sounds[sound] then
        if self.SoundNames[name or sound] and (not wheels or IsValid(self:GetNW2Entity("TrainWheels"))) then
            self.Sounds[sound] = CreateSound(wheels and self:GetNW2Entity("TrainWheels") or self, Sound(self.SoundNames[name or sound]))
        else
            return
        end
    end
    local snd = self.Sounds[sound]
    if (volume <= 0) or (pitch <= 0) then
        if snd:IsPlaying() then
            snd:ChangeVolume(0.0,0)
            snd:Stop()
        end
        return
    end
    local pch = math.floor(math.max(0,math.min(255,100*pitch)) )
    local vol = math.max(0,math.min(255,2.55*volume)) + (0.001/2.55) + (0.001/2.55)*math.random()
    if name~=false and not snd:IsPlaying() or name==false and snd:GetVolume()==0 then
    --if not self.Playing[sound] or name~=false and not snd:IsPlaying() or name==false and snd:GetVolume()==0 then
        if level and snd:GetSoundLevel() ~= level then
            snd:Stop()
            snd:SetSoundLevel(level)
        end
        snd:PlayEx(vol,pch+1)
    end
    --snd:SetDSP(22)
    snd:ChangeVolume(vol,0)
    snd:ChangePitch(pch+1,0)
    --snd:SetDSP(22)
end

function ENT:Initialize()
    self.MotorPowerSound = 0
--  self:ReinitializeSounds()
    self.Texture = nil
end

function ENT:OnRemove()
    if self.Sounds then
        for k,v in pairs(self.Sounds) do
            v:Stop()
        end
        self.Sounds = nil
    end
end

--------------------------------------------------------------------------------
function ENT:Think()
    if not self.Sounds then
        self:ReinitializeSounds()
    end
    self.PrevTime = self.PrevTime or RealTime()-0.33
    self.DeltaTime = (RealTime() - self.PrevTime)
    self.PrevTime = RealTime()
    -- Get interesting parameters
    local train = self:GetNW2Entity("TrainEntity")

    local rollingi = math.min(1,train.TunnelCoeff+math.Clamp((train.StreetCoeff-0.6)/0.3,0,1)*0.8)
    --print(self:GetPos())
    local rollings = train.StreetCoeff
    local soundsmul = 1
    local streetC,tunnelC = 0,1
    if IsValid(train) then
        streetC,tunnelC = train.StreetCoeff or 0,train.TunnelCoeff or 1
        soundsmul = math.Clamp(tunnelC^1.5+(streetC^0.5)*0.2,0,1)
    end
    local motorPower = self:GetMotorPower()
    local speed = self:GetSpeed()
    if self.MotorSoundType ~= self:GetNWInt("MotorSoundType",1)then
        self.MotorSoundType = self:GetNWInt("MotorSoundType",1)
        for k,v in pairs(self.EngineSNDConfig) do self:SetSoundState(v[1],0,0) end
        self.EngineSNDConfig = {}
            table.insert(self.EngineSNDConfig,{"ted1_703" ,50,0,0,1})
            table.insert(self.EngineSNDConfig,{"ted2_703" ,50,00,0,1})

    end
    self.Async = self:GetNWBool("Async")
    -- Engine sound
    if not self:GetNWBool("DisableEngines") then
        self.MotorPowerSound = math.Clamp(self.MotorPowerSound + (motorPower - self.MotorPowerSound)*self.DeltaTime*3,-1,1)
        local t = RealTime()*2.75
        local modulation = (0.2 + 3.0*math.max(0,0.2+math.sin(t)*math.sin(t*3.12)*math.sin(t*0.24)*math.sin(t*4.0)))*math.Clamp(speed/4,0,1)
        local mod2 = 5.0-math.min(1.0,(math.abs(self.MotorPowerSound)/0.1))
        if (speed > -1.0) and (math.abs(self.MotorPowerSound)+modulation) >= 0.0 then
            --local startVolRamp = 0.2 + 0.8*math.max(0.0,math.min(1.0,(speed - 1.0)*0.5))
            local powerVolRamp
            
            powerVolRamp = 0.3*modulation*mod2 + 2*math.abs(self.MotorPowerSound)--2.0*(math.abs(motorPower)^2)
            --math.max(0.3,math.min(1.0,math.abs(motorPower)))

            --local k,x = 1.0,math.max(0,math.min(1.1,(speed-1.0)/80))
            --local motorPchRamp = (k*x^3 - k*x^2 + x)
            --local motorPitch = 0.03+1.85*motorPchRamp
            local volumemul = math.min(1,(speed/4)^3)
            local motorsnd = math.min(1.0,math.max(0.0,1.25*(math.abs(self.MotorPowerSound))))
            local motorvol = (soundsmul^0.3)*math.Clamp(motorsnd + powerVolRamp,0,1)*volumemul
            --local motorsnd = math.min(1.0,math.max(0.0,1.25*(math.abs(self.MotorPowerSound)-0.15) ))

            for i,snd in ipairs(self.EngineSNDConfig or {}) do
                local prev = self.EngineSNDConfig[i-1]
                local next = self.EngineSNDConfig[i+1]
                local volume = 1
                if prev and speed <= prev[4] then
                    volume = math.max(0,1-(prev[4]-speed)/(prev[4]-snd[3]))
                elseif next  and speed > next[3] then
                    volume = math.max(0,(snd[4]-speed)/(snd[4]-next[3]))
                end
                local pitch = math.max(0,speed/snd[2])+0.1*streetC
            
                    
                self:SetSoundState(snd[1].."1",((motorsnd + powerVolRamp)*volume+1)*(snd.vol or 1)*volumemul,pitch+0.15*0.9,snd[1],false)    
                
            end
        else
            for k,v in pairs(self.EngineSNDConfig) do
                self:SetSoundState(v[1].."1",0,0,v[1],false)
            end
            self:SetSoundState(v[1].."2",0,0,v[1],true)
        end
    end
    -- Brake squeal sound
    --if speed > 2 then
        --brakeRamp = 1 - math.min(1.0,math.max(0.0,(speed-3)/10.0))
    --end
    if squealSound == 0 then squealSound = 1 end
    if squealSound == 3 then squealSound = 2 end
    if self.Async then
        local brakeSqueal = self:GetNW2Float("BrakeSqueal",0)
        if (brakeSqueal) > 0.0 then
            local nominalSqueal = self:GetNWFloat("SqualPitch",1)
            local secondSqueal = math.Clamp(1-(speed-2)/5,0,1)
            local squealPitch = nominalSqueal+secondSqueal*0.05
            local squealVolume = math.Clamp(speed/2,0,1)

            local volume = brakeSqueal*squealVolume
            self:SetSoundState("brakea_loop1",volume*(1-secondSqueal*0.5)*0.4,squealPitch,false,75)
            self:SetSoundState("brakea_loop2",volume*secondSqueal*0.4,squealPitch,false,75)
        else
            self:SetSoundState("brakea_loop1",0,0)
            self:SetSoundState("brakea_loop2",0,0)
        end
        self:SetSoundState("brake_loop1",0,0)
        self:SetSoundState("brake_loop2",0,0)
        self:SetSoundState("brake_loop3",0,0)
        self:SetSoundState("brake_loop4",0,0)
        self:SetSoundState("brake_loopb",0,0)
        self:SetSoundState("brake2_loop1",0,0)
        self:SetSoundState("brake2_loop2",0,0)
    else
        local squealSound = self:GetNW2Int("SquealSound",0)
        local brakeSqueal1 = math.max(0.0,math.min(2,self:GetNW2Float("BrakeSqueal1")))--FIXME math.max(0.0,math.min(1,self:GetNW2Float("BrakeSqueal1")))
        --local brakeSqueal2 = 0--FIXME local brakeSqueal2 = math.max(0.0,math.min(1,self:GetNW2Float("BrakeSqueal2")))
        --local brakeSqueal2 = math.max(0.0,math.min(1,self:GetNW2Float("BrakeSqueal2")))
        --local brakeRamp = math.min(1.0,math.max(0.0,speed/2.0))
        local brakeRamp1 = math.min(1.0,math.max(0.0,(speed-10)/50.0))^1.5
        local brakeRamp2 = math.min(1.0,math.max(0.0,speed/3.0))
        if true or (brakeSqueal1) > 0.0 then
            local ramp = 0.3+math.Clamp((40-speed)/40,0,1)*0.7
            local typ = self:GetNW2Int("SquealType",1)
            self:SetSoundState("brake_loop1",typ==1 and soundsmul*brakeSqueal1*ramp*0.2 or 0,1+0.05*(1.0-brakeRamp2))
            self:SetSoundState("brake_loop2",typ==2 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
            self:SetSoundState("brake_loop3",typ==3 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
            self:SetSoundState("brake_loop4",typ==4 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
            self:SetSoundState("brake_loopb",typ<=4 and 0*soundsmul*brakeSqueal1*ramp*0.4 or 0,1+0.05*(1.0-brakeRamp2))
            --spb only
            local loop_h = soundsmul*brakeSqueal1*ramp*0.5
            if typ>=5 and loop_h > 0.1 and speed > 1.5 then
                if not self.HighLoop then
                    self.HighLoop = math.random()>0.5 and "brake_squeal2" or "brake_squeal1"
                end
                self:SetSoundState(self.HighLoop,loop_h*1.5,1)
            elseif loop_h<0.02 and self.HighLoop then
                self:SetSoundState(self.HighLoop,0,0)
                self.HighLoop = false
            end
            self.StartLoopStrength = loop_h
            self:SetSoundState("brake2_loop1",(typ==5 or typ==6) and math.Clamp(loop_h*0.5,0,0.5) or 0,1+0.06*(1.0-brakeRamp2))
            self:SetSoundState("brake2_loop2",typ>=6 and loop_h*0.3 or 0,1+0.06*(1.0-brakeRamp2))
            --self:SetSoundState("brake_loop2",brakeSqueal*brakeRamp2*0.2,1+0.06*(1.0-brakeRamp2))
        else
            self:SetSoundState("brake_loop1",0,0)
            self:SetSoundState("brake_loop2",0,0)
            self:SetSoundState("brake_loop3",0,0)
            self:SetSoundState("brake_loop4",0,0)
            self:SetSoundState("brake_loopb",0,0)
            self:SetSoundState("brake2_loop1",0,0)
            self:SetSoundState("brake2_loop2",0,0)
        end
        self:SetSoundState("brakea_loop1",0,0)
        self:SetSoundState("brakea_loop2",0,0)
    end

    -- Generate procedural landscape thingy
    local a = self:GetPos().x
    local b = self:GetPos().y
    local c = self:GetPos().z
    local f = 1--math.sin(c/200 + a*c/3e7 + b*c/3e7) --math.sin(a/3000)*math.sin(b/3000)
    -- Calculate flange squeal
    self.PreviousAngles = self.PreviousAngles or self:GetAngles()
    local deltaAngleYaw = math.abs(self:GetAngles().yaw - self.PreviousAngles.yaw)
    deltaAngleYaw = (deltaAngleYaw) % 360
    if deltaAngleYaw >= 180 then
        deltaAngleYaw = deltaAngleYaw - 360
    end
    --speed = 80
    local speedAdd = math.max(1,math.min(2,1-(speed-60)/40))
    local deltaAngle = deltaAngleYaw/math.max(0.1,self.DeltaTime)*speedAdd
    deltaAngle = math.max(math.min(1.0,f*10)*math.abs(deltaAngle),0)

    self.PreviousAngles = self:GetAngles()
    -- Smooth it out
    self.SmoothAngleDelta = self.SmoothAngleDelta or 0
    local speedSmooth = 4--20-math.Clamp((speed-10)/40,0,1)*16
    self.SmoothAngleDelta = math.min(7,self.SmoothAngleDelta + (deltaAngle - self.SmoothAngleDelta)*2*self.DeltaTime)
    --[[ if (not (self.SmoothAngleDelta <= 0)) and (not (self.SmoothAngleDelta >= 0)) then
        print(self.SmoothAngleDelta)
        self.SmoothAngleDelta = 0
    end--]]
    -- Create sound
    local speed_mod = math.min(1.0,math.max(0.0,speed/5))
    local flangea = math.Clamp((speed-18)/25,0,1)
    local x = self.SmoothAngleDelta
    local f1 = math.max(0,x-0.5)*0.1
    local f2 = math.max(0,x-3-flangea*1)*0.6
    local f3 = math.max(0,x-4.0-flangea*1.5)*0.6
    local t = RealTime()
    local modulation = 1.5*math.max(0,0.2+math.sin(t)*math.sin(t*3.12)*math.sin(t*0.24)*math.sin(t*4.0))
    local pitch40 = math.max(0.9,1.0+(speed-40.0)/160.0)
    local pitch60 = math.max(0.9,1.0+(speed-60.0)/160.0)
    -- Play it
    self:SetSoundState("flangea",(0.3+soundsmul*0.7)*(speed_mod)*math.Clamp(f2,0,1),pitch40)
    self:SetSoundState("flangeb",(0.3+soundsmul*0.7)*(speed_mod)*math.Clamp(f3*modulation,0,1),pitch40)
    self:SetSoundState("flange1",(0.3+soundsmul*0.7)*(speed_mod)*f1*modulation,pitch40)
    self:SetSoundState("flange2",(0.3+soundsmul*0.7)*(speed_mod)*f1,pitch40)
end


function ENT:UpdateTextures()
    self.Texture = self.Train:GetNW2String("Texture")
    --self.PassTexture = self.Train:GetNW2String("PassTexture")
    --self.CabinTexture = self.Train:GetNW2String("CabTexture")

    local texture = Metrostroi.Skins["train"][self.Texture]
   -- local passtexture = Metrostroi.Skins["pass"][self.PassTexture]
    --local cabintexture = Metrostroi.Skins["cab"][self.CabinTexture]
    for id,ent in pairs(self.ClientEnts) do
        if not IsValid(ent) then continue end
        if self.ClientProps[id].callback then self.ClientProps[id].callback(self,ent) end
        for k in pairs(ent:GetMaterials()) do ent:SetSubMaterial(k-1,"") end
        for k,v in pairs(ent:GetMaterials()) do
            local tex = string.Explode("/",v)
            tex = tex[#tex]
            --if cabintexture and cabintexture.textures and cabintexture.textures[tex] then
            --    ent:SetSubMaterial(k-1,cabintexture.textures[tex])
            --end
            --if passtexture and passtexture.textures and passtexture.textures[tex] then
            --    ent:SetSubMaterial(k-1,passtexture.textures[tex])
            --end
            if texture and texture.textures and texture.textures[tex] then
                ent:SetSubMaterial(k-1,texture.textures[tex])
            end
        end
    end
end

function ENT:Draw()
    self:DrawModel()
    --render.DrawLine(self:GetPos(),self:LocalToWorld(Vector(100,0,0)), Color(255,0,0), false)
end



