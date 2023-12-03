AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("uf_contact")

ENT.Types = {
    ["diamond"] = {
        "models/lilly/uf/panto_diamond.mdl",
        Vector(0,0.0,-7),Angle(0,0,0),
    },
}


function ENT:SetParameters()
    local type = self.Types[self.PantoType or "diamond"]
    self:SetModel(type[1] or "models/lilly/uf/panto_diamond.mdl")
end

function ENT:Initialize()
    self:SetParameters()
    
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    

    --[[if IsValid(self:GetPhysicsObject()) then
        self:GetPhysicsObject():SetNoCollide(true)
    end]]

    self.Raised = false

    self.Height = 0
    self.Voltage = 600
    self.ContactStates = { false, false }
    self.NextStates = { false }
    --self.PantoPos = WorldToLocal(self:GetPos())
    self.VoltageDrop = 0
    self.DropByPeople = 0
    self.VotageDropByTouch = 0
    self.CheckTimeout = 0
    self.NoPhysics = false
    self.PantoType = {}
    self:SetModelScale(0.85,1)
    self.SoundPlayed = false
end


function ENT:TriggerInput(iname, value)
    if iname == "Raise" then self.PantographRaised = value end
end

function ENT:Think()
    self.BaseClass.Think(self)
    local testvector = Vector(0,0,100)

    -- Update timing
    self.PrevTime = self.PrevTime or CurTime()
    self.DeltaTime = (CurTime() - self.PrevTime)
    self.PrevTime = CurTime()
    
    local endscan = self:GetPos() + Vector(0,0,135)

    if self.Train.PantoUp == true then
        

        self:CheckVoltage(self.DeltaTime)
    end
    --print(self:GetUp())
    self.Debug = false
end


function ENT:CheckContact(pos,dir)
    local result = util.TraceHull({
        start = pos,
        endpos = pos + dir * 117,
        mask = MASK_SHOT_HULL,
        filter = { self }, --filter out the panto itself
        mins = Vector( -26,-26,0 ),--box should be 48 units wide and 120 units tall, in order to detect the full range of where catenary can be
        maxs = Vector(26,26,4),
    })
    
    if not result.Hit then self:SetNW2Vector("PantoHeight",Vector(0,0,117)) return end --if nothing touches the panto, it can spring to maximum freely
    self:SetNW2Bool("HitWire",result.Hit)
    local PhysObj = self:GetPhysicsObject()
    local pantoheight = PhysObj:WorldToLocalVector(result.HitPos+Vector(0,0,math.abs(pos.z))) - PhysObj:WorldToLocalVector(pos+Vector(0,0,math.abs(pos.z)))
    --print(pantoheight.z)
    --print("traceorigin",PhysObj:WorldToLocalVector(pos),"hitpos",PhysObj:WorldToLocalVector(result.HitPos),"calculated height diff",pantoheight.z)
    self:SetNW2Vector("PantoHeight",pantoheight)
    local traceEnt = result.Entity

    if IsValid(traceEnt) and traceEnt:GetClass() == "player" and UF.Voltage > 40 then --if the player hits the bounding box, unalive them
        local pPos = traceEnt:GetPos()
        util.BlastDamage(traceEnt,traceEnt,pPos,64,3.0*self.Voltage)
        
        local effectdata = EffectData()
        effectdata:SetOrigin(pPos + Vector(0,0,-16+math.random()*(40+0)))
        util.Effect("cball_explode",effectdata,true,true)
        sound.Play("ambient/energy/zap"..math.random(1,3)..".mp3",pPos,75,math.random(100,150),1.0)
        return false --don't return anything because... I mean, a human body is a conductor, just not a very good one
    elseif result.Hit and UF.Voltage > 40 then --randomly create some sparks if we're hitting catenary, with a 12% chance
        if self.Train.Speed >= 5 and math.random(0,100) >= 80 then
            local pPos = result.HitPos
            local effectdata = EffectData()
            effectdata:SetOrigin(pPos + Vector(0,math.random(-2,2),0))
            util.Effect("StunstickImpact",effectdata,true,true)
            sound.Play("ambient/energy/zap"..math.random(1,3)..".mp3",pPos,75,math.random(100,150),1.0)
        end
        return result.Hit, traceEnt --yes, we are touching catenary
    end

end


function ENT:CheckVoltage(dT)
    local C_mplr_train_requirewire = GetConVar("mplr_train_requirewire")
    -- Check contact states
    if (CurTime() - self.CheckTimeout) <= 0.25 then return end
    self.CheckTimeout = CurTime()
    local supported = C_mplr_train_requirewire:GetInt() > 0 and UF.MapHasFullSupport()

    
    
    local hit, hitEnt = self:CheckContact(self:GetPos(),self:GetUp())
    if not IsValid(hitEnt) then self.Voltage = 0 return end
    if hitEnt:GetClass() == "prop_static" and string.gmatch(hitEnt:GetModel(), "overhead_wire") == "overhead_wire" then
        self.Voltage = UF.Voltage
    else
        self.Voltage = 0
    end

end

function ENT:Debug()
    
    self:SetNWVector("mins",PhysObj:WorldToLocalVector(Vector( -2,-24,1 )))
    self:SetNWVector("maxs",PhysObj:WorldToLocalVector(Vector(2,24,3)))
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