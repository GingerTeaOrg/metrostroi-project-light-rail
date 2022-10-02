UF.TotalkWh = UF.TotalkWh or tonumber(file.Read("metrostroi_data/total_kwh_UF.txt") or "") or 0
UF.TotalRateWatts = UF.TotalRateWatts or 0

UF.Voltage = 600
UF.Voltages = UF.Voltages or {}
UF.Currents = UF.Currents or {}
UF.Current = 0




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
    local panto = ents.FindByClass("gmod_train_uf_panto")
    for _,bogey in pairs(bogeys) do
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
                UF.TotalRateWatts = UF.TotalRateWatts + math.max(0,(train.Electric.EnergyChange or 0))
                local current = math.max(0,(train.Electric.Itotal or 0)) -  math.max(0,(train.Electric.Iexit or 0))
                local feeder = false
                local fB = train.FrontBogey
                local rB = train.RearBogey
                if IsValid(fB) then
                    if fB.Feeder then
                        UF.Currents[fB.Feeder] = UF.Currents[fB.Feeder] + fB.DropByPeople+current*0.4
                        feeder = true
                    else
                        UF.Current = UF.Current + fB.DropByPeople
                    end
                end
                if IsValid(rB) then
                    if rB.Feeder then
                        UF.Currents[rB.Feeder] = UF.Currents[rB.Feeder] + rB.DropByPeople+current*0.4
                        feeder = true
                    else
                        UF.Current = UF.Current + rB.DropByPeople
                    end
                end
                if not feeder then UF.Current = UF.Current + current*0.4 end
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
    if UF.Current > GetConVarNumber("uf_current_limit") then
        UF.VoltageRestoreTimer = CurTime() + 7.0
        print(Format("[!] Power feed protection tripped: current peaked at %.1f A",UF.Current))
    end

    local voltage = math.max(0,GetConVarNumber("uf_voltage"))

    -- Calculate new voltage
    local Rfeed = 0.03 --25
    UF.Voltage = voltage - UF.Current*Rfeed
    if CurTime() < UF.VoltageRestoreTimer then UF.Voltage = 0 end
    for i in pairs(UF.Voltages) do
        UF.Voltages[i] = math.max(0,voltage - UF.Currents[i]*Rfeed)
    end
    --print(Format("%5.1f v %.0f A",UF.Voltage,UF.Current))
end)


concommand.Add("uf_electric", function(ply, _, args) -- (%.2f$) Metrostroi.GetEnergyCost(Metrostroi.TotalkWh),
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

timer.Create("uf_ElectricConsumptionTimer",0.5,0,function()
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