AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self.TargetEnt = self:GetInternalVariable("SwitchEnt")
    self.SwitchID = self.TargetEnt.ID
    self.Invisible = self:GetInternalVariable("Invisible") == 1 and true or false
    self:SetNW2Bool("Invisible",self.Invisible)
    util.PrecacheModel("models/lilly/uf/signage/point_contact.mdl")
end

function ENT:Think()
    if not self.SwitchID then return end
    local target = self.TargetEnt
    local trace = util.TraceHull({
        start = self:GetPos(),
        endpos = start + Vector(0,0,100),
        filter = self,
        mins = Vector( -10, -10, -10 ),
	    maxs = Vector( 10, 10, 10 ),
	    mask = MASK_SHOT_HULL
    })
    entString = string.sub(trace:GetClass(),1,#"gmod_subway_uf_")
    entString2 = string.sub(trace:GetClass(),1,#"gmod_subway_mplr_")

    if entString == "gmod_subway_uf_" or entString2 == "gmod_subway_mplr_" then

        local route = trace.IBIS.Route
        local line = string.sub(trace.IBIS.LineCourse,1,#trace.IBIS.LineCourse - 2) --future proofing for LLLKK format
        local override = trace.IBIS.ManualOverride
        if route and line and not override then
            local success = target:TriggerSwitch(UF.RoutingTable[line..route][ID],trace)
        elseif route and line and override then
            local success = target:TriggerSwitch(override,trace)
        end
    elseif trace:GetClass() == "gmod_train_uf_bogey" then
        local train = target.TrainEntity
        local route = train.IBIS.Route
        local line = train.IBIS.LineCourse
        local override = train.IBIS.ManualOverride
    end
    self:NextThink(CurTime() + 1.0)
end