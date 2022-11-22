AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("uf_contact")

ENT.Types = {
    ["diamond"] = {
        "models/lilly/uf/common/pantograph.mdl",
        Vector(0,0.0,-7),Angle(0,90,0),
    },
}


function ENT:SetParameters()
    local type = self.Types[self.PantoType or "Diamond"]
    self:SetModel(type[1] or "models/lilly/uf/common/pantograph.mdl")
end

function ENT:Initialize()
    self:SetParameters()

    if Wire_CreateInputs then
        self.Inputs = Wire_CreateInputs(self,{
            "Raise",})
        self.Outputs = Wire_CreateOutputs(self,{
            "Contact",
        })
    end

    if IsValid(self:GetPhysicsObject()) then
        self:GetPhysicsObject():SetNoCollide(true)
    end

    self.Raised = false

    self.Height = 0
    self.Voltage = 0
    self.ContactStates = { false, false }
    self.NextStates = { false }
    self.PantoPos = Vector(0,0,255)
    self.VoltageDrop = 0
    self.DropByPeople = 0
    self.VotageDropByTouch = 0
    self.CheckTimeout = 0
end


function ENT:TriggerInput(iname, value)
    if iname == "Raise" then self.PantographRaised = value end
end

function ENT:Think()
    self.BaseClass.Think(self)
end


function ENT:CheckContact(pos,dir,id,cpos)
    local result = util.TraceHull({
        start = self:LocalToWorld(pos),
        endpos = self:LocalToWorld(pos + dir*10),
        mask = -1,
        filter = { self:GetNW2Entity("TrainEntity"), self },
        mins = Vector( -2, -2, -2 ),
        maxs = Vector( 2, 2, 2 )
    })

    if not result.Hit then return end
    if result.HitWorld then return true end

    local traceEnt = result.Entity
    if traceEnt:GetClass() == "player" and self.Voltage > 40 then
        local pPos = traceEnt:GetPos()
        util.BlastDamage(traceEnt,traceEnt,pPos,64,3.0*self.Voltage)

        local effectdata = EffectData()
        effectdata:SetOrigin(pPos + Vector(0,0,-16+math.random()*(40+0)))
        util.Effect("cball_explode",effectdata,true,true)
        sound.Play("ambient/energy/zap"..math.random(1,3)..".wav",pPos,75,math.random(100,150),1.0)
        return
    end
    return result.Hit
end


function ENT:CheckVoltage(dT)
    -- Check contact states
    if (CurTime() - self.CheckTimeout) <= 0.25 then return end
    self.CheckTimeout = CurTime()
    --local supported = C_Reqiure3rdRail:GetInt() > 0 and UF.MapHasFullSupport()
    local feeder = self.Feeder and UF.Voltages[self.Feeder]
    local volt = feeder or UF.Voltage or 750

    -- Non-metrostroi maps
    if not supported then
        self.Voltage = volt
        self.NextStates[1] = true
        self.NextStates[2] = true
        return
    end


    self.NextStates[1] = not self.DisableContacts and not self.DisableContactsManual
                        and self:CheckContact(self.PantLPos,Vector(0,-1,0),1,self.PantoPos)

    -- Detect changes in contact states
    local i=1
        local state = self.NextStates[i]
        if state ~= self.ContactStates[i] then
            self.ContactStates[i] = state
            if not state then return end

            self.VoltageDrop = -40*(0.5 + 0.5*math.random())

            local dt = CurTime() - self.PlayTime[i]
            self.PlayTime[i] = CurTime()

            local volume = 0.53
            if dt < 1.0 then volume = 0.43 end
            if i == 1 then sound.Play("subway_trains/bogey/tr_"..math.random(1,5)..".wav",self:LocalToWorld(self.PantLPos),65,math.random(90,120),volume) end
            if i == 2 then sound.Play("subway_trains/bogey/tr_"..math.random(1,5)..".wav",self:LocalToWorld(self.PantRPos),65,math.random(90,120),volume) end

            -- Sparking probability
            local probability = math.Clamp(1-(self.MotorPower/2),0,1)
            if math.random() > probability then
                local effectdata = EffectData()
                if i == 1 then effectdata:SetOrigin(self:LocalToWorld(self.PantLPos)) end
                if i == 2 then effectdata:SetOrigin(self:LocalToWorld(self.PantRPos)) end
                effectdata:SetNormal(Vector(0,0,-1))
                util.Effect("stunstickimpact", effectdata, true, true)

                local light = ents.Create("light_dynamic")
                light:SetPos(effectdata:GetOrigin())
                light:SetKeyValue("_light","100 220 255")
                light:SetKeyValue("style", 0)
                light:SetKeyValue("distance", 256)
                light:SetKeyValue("brightness", 5)
                light:Spawn()
                light:Fire("TurnOn","","0")
                light.Time = CurTime()
                timer.Simple(0.1,function()
                    SafeRemoveEntity(light)
                end)
                sound.Play("subway_trains/bogey/spark.mp3",effectdata:GetOrigin(),75,math.random(100,150),volume)
                --self.Train:PlayOnce("zap",sound_source,0.7*volume,50+math.random(90,120))
            end
        end
    
    -- Voltage spikes
    self.VoltageDrop = math.max(-30,math.min(30,self.VoltageDrop + (0 - self.VoltageDrop)*10*dT))

    -- Detect voltage
    self.Voltage = 0
    self.DropByPeople = 0
    
        if self.ContactStates[i] then
            self.Voltage = volt + self.VoltageDrop
        elseif IsValid(self.Connectors[i]) and self.Connectors[i].Coupled == self then
            self.Voltage = self.Connectors[i].Power and UF.Voltage or 0
        end

    if self.VoltageDropByTouch > 0 then
        local Rperson = 0.613
        local Iperson = UF.Voltage / (Rperson/(self.VoltageDropByTouch + 1e-9))
        self.DropByPeople = Iperson
    end
end



function ENT:SpawnFunction(ply, tr)
    local verticaloffset = 40 -- Offset for the train model, gmod seems to add z by default, nvm its you adding 170 :V
    local distancecap = 2000 -- When to ignore hitpos and spawn at set distanace
    local pos, ang = nil
    local inhibitrerail = false

    if tr.Hit then
        -- Setup trace to find out of this is a track
        local tracesetup = {}
        tracesetup.start=tr.HitPos
        tracesetup.endpos=tr.HitPos+tr.HitNormal*80
        tracesetup.filter=ply

        local tracedata = util.TraceLine(tracesetup)

        if tracedata.Hit then
            -- Trackspawn
            pos = (tr.HitPos + tracedata.HitPos)/2 + Vector(0,0,verticaloffset)
            ang = tracedata.HitNormal
            ang:Rotate(Angle(0,90,0))
            ang = ang:Angle()

        else
            -- Regular spawn
            if tr.HitPos:Distance(tr.StartPos) > distancecap then
                -- Spawnpos is far away, put it at distancecap instead
                pos = tr.StartPos + tr.Normal * distancecap
                inhibitrerail = true
            else
                -- Spawn is near
                pos = tr.HitPos + tr.HitNormal * verticaloffset
            end
            ang = Angle(0,tr.Normal:Angle().y,0)
        end
    else
        -- Trace didn't hit anything, spawn at distancecap
        pos = tr.StartPos + tr.Normal * distancecap
        ang = Angle(0,tr.Normal:Angle().y,0)
    end

    local ent = ents.Create(self.ClassName)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Spawn()
    ent:Activate()

    return ent
end


























function ENT:AcceptInput(inputName, activator, called, data)
    if inputName == "OnFeederIn" then
        self.Feeder = tonumber(data)
        if self.Feeder and not UF.Voltages[self.Feeder] then
            UF.Voltages[self.Feeder] = 0
            UF.Currents[self.Feeder] = 0
        end
    elseif inputName == "OnFeederOut" then
        self.Feeder = nil
    end
end