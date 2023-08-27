--------------------------------------------------------------------------------
-- Electric consumption stats
--------------------------------------------------------------------------------
-- Load total kWh
timer.Create("UF_TotalkWhTimer",5.00,0,function()
    file.Write("UF_data/total_kwh.txt",UF.TotalkWh or 0)
end)
UF.TotalkWh = UF.TotalkWh or tonumber(file.Read("UF_data/total_kwh.txt") or "") or 0
UF.TotalRateWatts = UF.TotalRateWatts or 0
CreateConVar("mplr_voltage", "600", FCVAR_NOTIFY, "Sets the Voltage applied to the overhead wire. Default is 600VDC, some maps may use 750VDC.",600,750)
local V = GetConVar("mplr_voltage")
UF.Voltage = V:GetInt()
UF.Voltages = UF.Voltages or {}
UF.Currents = UF.Currents or {}
UF.Current = 0
UF.PeopleOnRails = 0
UF.VoltageRestoreTimer = 0

local function consumeFromFeeder(inCurrent, inFeeder)
    if inFeeder then
        UF.Currents[inFeeder] = UF.Currents[inFeeder] + inCurrent*0.4
    else
        UF.Current = UF.Current + inCurrent*0.4
    end
end

local prevTime
hook.Add("Think", "UF_ElectricConsumptionThink", function()
    -- Change in time
    prevTime = prevTime or CurTime()
    local deltaTime = (CurTime() - prevTime)
    prevTime = CurTime()

    -- Calculate total rate
    UF.TotalRateWatts = 0
    UF.Current = 0
    for k,v in pairs(UF.Currents) do UF.Currents[k] = 0 end
    local pantos = ents.FindByClass("gmod_train_uf_panto")
    for _,panto in pairs(pantos) do
        if panto.Feeder then
            UF.Currents[panto.Feeder] = UF.Currents[panto.Feeder] + panto.DropByPeople
        else
            UF.Current = UF.Current + panto.DropByPeople
        end
    end
    for _,class in pairs(UF.TrainClasses) do
        local trains = ents.FindByClass(class)
        for _,train in pairs(trains) do
            if train.Electric then
                if train.Electric.EnergyChange then UF.TotalRateWatts = UF.TotalRateWatts + math.max(0, train.Electric.EnergyChange) end
                local current = math.max(0, train.Electric.Itotal or 0) -  math.max(0, train.Electric.Iexit or 0)

                local fB = IsValid(train.FrontBogey) and train.FrontBogey
                local rB = IsValid(train.RearBogey) and train.RearBogey
                if fB and (not fB.ContactStates or (not fB.ContactStates[1] and not fB.ContactStates[2])) then fB = nil end -- Don't have contact with TR
                if rB and (not rB.ContactStates or (not rB.ContactStates[1] and not rB.ContactStates[2])) then rB = nil end -- Don't have contact with TR

                local fBfeeder = fB and fB.Feeder
                local rBfeeder = rB and rB.Feeder

                if fBfeeder then
                    if not rBfeeder or fBfeeder == rBfeeder then
                        consumeFromFeeder(current, fBfeeder) -- Feeders are same
                    else
                        consumeFromFeeder(current * 0.5, fBfeeder) -- Feeders are different
                    end
                end

                if rBfeeder then
                    if not fBfeeder then
                        consumeFromFeeder(current, rBfeeder) -- Feeders are same
                    elseif fBfeeder ~= rBfeeder  then
                        consumeFromFeeder(current * 0.5, rBfeeder) -- Feeders are different
                    end
                end
                if not rBfeeder and not fBfeeder then consumeFromFeeder(current) end
            end
        end
    end
    -- Ignore invalid values
    if UF.TotalRateWatts > 1e8 then UF.TotalRateWatts = 0 end
    if UF.TotalRateWatts > 0 then
        -- Calculate total kWh
        UF.TotalkWh = UF.TotalkWh + (UF.TotalRateWatts/(3.6e6))*deltaTime
    end
    -- Calculate total resistance of people on rails and current flowing through
    --local Rperson = 0.613
    --local Iperson = UF.Voltage / (Rperson/(UF.PeopleOnRails + 1e-9))
    --UF.Current = UF.Current + Iperson

    -- Check if exceeded global maximum current
    if UF.Current > GetConVar("UF_current_limit"):GetInt() then
        UF.VoltageRestoreTimer = CurTime() + 7.0
        print(Format("[!] Power feed protection tripped: current peaked at %.1f A",UF.Current))
    end

    local voltage = math.max(0,GetConVar("mplr_voltage"):GetInt())

    -- Calculate new voltage
    local Rfeed = 0.03 --25
    UF.Voltage = voltage - UF.Current*Rfeed
    if CurTime() < UF.VoltageRestoreTimer then UF.Voltage = 0 end
    for i in pairs(UF.Voltages) do
        UF.Voltages[i] = math.max(0,voltage - UF.Currents[i]*Rfeed)
    end
    --print(Format("%5.1f v %.0f A",UF.Voltage,UF.Current))
end)

concommand.Add("mplr_electric", function(ply, _, args) -- (%.2f$) UF.GetEnergyCost(UF.TotalkWh),
    local m = Format("[%25s] %010.3f kWh, %.3f kW (%5.1f v, %4.0f A)","<total>",
        UF.TotalkWh,UF.TotalRateWatts*1e-3,
        UF.Voltage,UF.Current)
    if IsValid(ply)
    then ply:PrintMessage(HUD_PRINTCONSOLE,m)
    else print(m)
    end

    if CPPI then
        local U = {}
        local D = {}
        for _,class in pairs(UF.TrainClasses) do
            local trains = ents.FindByClass(class)
            for _,train in pairs(trains) do
                local owner = "(disconnected)"
                if train:CPPIGetOwner() then
                    owner = train:CPPIGetOwner():GetName()
                end
                if train.Electric then
                    U[owner] = (U[owner] or 0) + train.Electric.ElectricEnergyUsed
                    D[owner] = (D[owner] or 0) + train.Electric.ElectricEnergyDissipated
                end
            end
        end
        for player,_ in pairs(U) do --, n=%.0f%%
            --local m = Format("[%20s] %08.1f KWh (lost %08.1f KWh)",player,U[player]/(3.6e6),D[player]/(3.6e6)) --,100*D[player]/U[player]) --,D[player])
            local m = Format("[%25s] %010.3f kWh (%.2f$)",player,U[player]/(3.6e6),UF.GetEnergyCost(U[player]/(3.6e6)))
            if IsValid(ply)
            then ply:PrintMessage(HUD_PRINTCONSOLE,m)
            else print(m)
            end
        end
    end
end)

timer.Create("UF_ElectricConsumptionTimer",0.5,0,function()
    if CPPI then
        local U = {}
        local D = {}
        for _,class in pairs(UF.TrainClasses) do
            local trains = ents.FindByClass(class)
            for _,train in pairs(trains) do
                local owner = train:CPPIGetOwner()
                if owner and (train.Electric) then
                    U[owner] = (U[owner] or 0) + train.Electric.ElectricEnergyUsed
                    D[owner] = (D[owner] or 0) + train.Electric.ElectricEnergyDissipated
                end
            end
        end
        for player,_ in pairs(U) do
            if IsValid(player) then
                player:SetDeaths(10*U[player]/(3.6e6))
                player.MUsedEnergy = (player.MUsedEnergy or 0) + 10*U[player]/(3.6e6)
            end
        end
    end
end)

function UF.murder(v)
    local positions = Metrostroi.GetPositionOnTrack(v:GetPos())
    for k2,v2 in pairs(positions) do
        local y,z = v2.y,v2.z
        y = math.abs(y)

        local y1 = 0.91-0.10
        local y2 = 1.78 ---0.50
        if (y > y1) and (y < y2) and (z < -1.70) and (z > -1.72) and (Metrostroi.Voltage > 40) then
            local pos = v:GetPos()

            util.BlastDamage(v,v,pos,64,3.0*Metrostroi.Voltage)

            local effectdata = EffectData()
            effectdata:SetOrigin(pos + Vector(0,0,-16+math.random()*(40+0)))
            util.Effect("cball_explode",effectdata,true,true)

            sound.Play("ambient/energy/zap"..math.random(1,3)..".wav",pos,75,math.random(100,150),1.0)
            Metrostroi.PeopleOnRails = Metrostroi.PeopleOnRails + 1

            --if math.random() > 0.85 then
                --Metrostroi.VoltageRestoreTimer = CurTime() + 7.0
                --print("[!] Power feed protection tripped: "..(tostring(v) or "").." died on rails")
            --end
        end
    end
end

function UF.MapHasFullSupport(typ)
    if not typ then
        return (#Metrostroi.Paths > 0)
    elseif typ=="ars" then
        return next(Metrostroi.SignalEntitiesByName)
    elseif typ=="auto" then
        return Metrostroi.HaveAuto
    elseif typ=="sbpp" then
        return Metrostroi.HaveSBPP
    elseif typ=="pa" then
        return next(Metrostroi.PAMConfTest)
    end
end