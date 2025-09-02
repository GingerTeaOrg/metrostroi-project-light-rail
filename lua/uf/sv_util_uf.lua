--------------------------------------------------------------------------------
-- Electric consumption stats
--------------------------------------------------------------------------------
-- Load total kWh
timer.Create( "MPLR_TotalkWhTimer", 5.00, 0, function() file.Write( "MPLR_data/total_kwh.txt", MPLR.TotalkWh or 0 ) end )
MPLR.TotalkWh = MPLR.TotalkWh or tonumber( file.Read( "MPLR_data/total_kwh.txt" ) or "" ) or 0
MPLR.TotalRateWatts = MPLR.TotalRateWatts or 0
CreateConVar( "mplr_voltage", "600", FCVAR_NOTIFY, "Sets the Voltage applied to the overhead wire. Default is 600VDC, some maps may use 750VDC.", 600, 750 )
local V = GetConVar( "mplr_voltage" )
MPLR.Voltage = V:GetInt()
MPLR.Voltages = MPLR.Voltages or {}
MPLR.Currents = MPLR.Currents or {}
MPLR.Current = 0
MPLR.PeopleOnRails = 0
MPLR.VoltageRestoreTimer = 0
CreateConVar( "mplr_drawdebug", "0", FCVAR_NOTIFY, "Enable or disable track debugging" )
local function consumeFromFeeder( inCurrent, inFeeder )
    if inFeeder then
        MPLR.Currents[ inFeeder ] = MPLR.Currents[ inFeeder ] + inCurrent * 0.4
    else
        MPLR.Current = MPLR.Current + inCurrent * 0.4
    end
end

util.AddNetworkString( "RBLTriggerClientRequest" )
util.AddNetworkString( "RBLSendToClient" )
--format: multiline
net.Receive(
    "RBLTriggerClientRequest", 
    function( ply, cmd, args )
        local line = net.ReadFloat()
        local ply = net.ReadPlayer()
        local arg = net.ReadFloat()
        if not arg then
            net.Start( "RBLSendToClient" )
            net.WriteBool( false ) --hasArgument
            net.WriteTable( MPLR.IBISRegisteredTrains )
            net.Send( ply )
        elseif arg then
            local result = MPLR.IBISRegisteredTrains[ arg ]
            if result then
                net.Start( "RBLSendToClient" )
                net.WriteBool( true ) --hasArgument
                net.WriteBool( true ) --found match in table
            end
        end
    end
)

local prevTime
--[[hook.Add("Think", "MPLR_ElectricConsumptionThink", function()
    -- Change in time
    prevTime = prevTime or CurTime()
    local deltaTime = (CurTime() - prevTime)
    prevTime = CurTime()

    -- Calculate total rate
    MPLR.TotalRateWatts = 0
    MPLR.Current = 0
    for k,v in pairs(MPLR.Currents) do MPLR.Currents[k] = 0 end
    local pantos = ents.FindByClass("gmod_train_uf_panto")
    for _,panto in pairs(pantos) do
        if panto.Feeder then
            MPLR.Currents[panto.Feeder] = MPLR.Currents[panto.Feeder] + panto.DropByPeople
        else
            MPLR.Current = MPLR.Current + panto.DropByPeople
        end
    end
    for _,class in pairs(MPLR.TrainClasses) do
        local trains = ents.FindByClass(class)
        for _,train in pairs(trains) do
            if train.Electric then
                if train.Electric.EnergyChange then MPLR.TotalRateWatts = MPLR.TotalRateWatts + math.max(0, train.Electric.EnergyChange) end
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
    if MPLR.TotalRateWatts > 1e8 then MPLR.TotalRateWatts = 0 end
    if MPLR.TotalRateWatts > 0 then
        -- Calculate total kWh
        MPLR.TotalkWh = MPLR.TotalkWh + (MPLR.TotalRateWatts/(3.6e6))*deltaTime
    end
    -- Calculate total resistance of people on rails and current flowing through
    --local Rperson = 0.613
    --local Iperson = MPLR.Voltage / (Rperson/(MPLR.PeopleOnRails + 1e-9))
    --MPLR.Current = MPLR.Current + Iperson

    -- Check if exceeded global maximum current
    if MPLR.Current > GetConVar("mplr_current_limit"):GetInt() then
        MPLR.VoltageRestoreTimer = CurTime() + 7.0
        print(Format("[!] Power feed protection tripped: current peaked at %.1f A",MPLR.Current))
    end

    local voltage = math.max(0,GetConVar("mplr_voltage"):GetInt())

    -- Calculate new voltage
    local Rfeed = 0.03 --25
    MPLR.Voltage = voltage - MPLR.Current*Rfeed
    if CurTime() < MPLR.VoltageRestoreTimer then MPLR.Voltage = 0 end
    for i in pairs(MPLR.Voltages) do
        MPLR.Voltages[i] = math.max(0,voltage - MPLR.Currents[i]*Rfeed)
    end
    --print(Format("%5.1f v %.0f A",MPLR.Voltage,MPLR.Current))
end)]]
concommand.Add( "mplr_electric", function( ply, _, args )
    -- (%.2f$) MPLR.GetEnergyCost(MPLR.TotalkWh),
    local m = Format( "[%25s] %010.3f kWh, %.3f kW (%5.1f v, %4.0f A)", "<total>", MPLR.TotalkWh, MPLR.TotalRateWatts * 1e-3, MPLR.Voltage, MPLR.Current )
    if IsValid( ply ) then
        ply:PrintMessage( HUD_PRINTCONSOLE, m )
    else
        print( m )
    end

    if CPPI then
        local U = {}
        local D = {}
        for _, class in pairs( MPLR.TrainClasses ) do
            local trains = ents.FindByClass( class )
            for _, train in pairs( trains ) do
                local owner = "(disconnected)"
                if train:CPPIGetOwner() then owner = train:CPPIGetOwner():GetName() end
                if train.Electric then
                    U[ owner ] = ( U[ owner ] or 0 ) + train.Electric.ElectricEnergyUsed
                    D[ owner ] = ( D[ owner ] or 0 ) + train.Electric.ElectricEnergyDissipated
                end
            end
        end

        for player, _ in pairs( U ) do --, n=%.0f%%
            --local m = Format("[%20s] %08.1f KWh (lost %08.1f KWh)",player,U[player]/(3.6e6),D[player]/(3.6e6)) --,100*D[player]/U[player]) --,D[player])
            local m = Format( "[%25s] %010.3f kWh (%.2f$)", player, U[ player ] / 3.6e6, MPLR.GetEnergyCost( U[ player ] / 3.6e6 ) )
            if IsValid( ply ) then
                ply:PrintMessage( HUD_PRINTCONSOLE, m )
            else
                print( m )
            end
        end
    end
end )

timer.Create( "MPLR_ElectricConsumptionTimer", 0.5, 0, function()
    if CPPI then
        local U = {}
        local D = {}
        for _, class in pairs( MPLR.TrainClasses ) do
            local trains = ents.FindByClass( class )
            for _, train in pairs( trains ) do
                local owner = train:CPPIGetOwner()
                if owner and train.Electric then
                    U[ owner ] = ( U[ owner ] or 0 ) + train.Electric.ElectricEnergyUsed
                    D[ owner ] = ( D[ owner ] or 0 ) + train.Electric.ElectricEnergyDissipated
                end
            end
        end

        for player, _ in pairs( U ) do
            if IsValid( player ) then
                player:SetDeaths( 10 * U[ player ] / 3.6e6 )
                player.MUsedEnergy = ( player.MUsedEnergy or 0 ) + 10 * U[ player ] / 3.6e6
            end
        end
    end
end )

function MPLR.murder( v )
    local positions = Metrostroi.GetPositionOnTrack( v:GetPos() )
    for k2, v2 in pairs( positions ) do
        local y, z = v2.y, v2.z
        y = math.abs( y )
        local y1 = 0.91 - 0.10
        local y2 = 1.78 ---0.50
        if ( y > y1 ) and ( y < y2 ) and ( z < -1.70 ) and ( z > -1.72 ) and ( Metrostroi.Voltage > 40 ) then
            local pos = v:GetPos()
            util.BlastDamage( v, v, pos, 64, 3.0 * Metrostroi.Voltage )
            local effectdata = EffectData()
            effectdata:SetOrigin( pos + Vector( 0, 0, -16 + math.random() * ( 40 + 0 ) ) )
            util.Effect( "cball_explode", effectdata, true, true )
            sound.Play( "ambient/energy/zap" .. math.random( 1, 3 ) .. ".wav", pos, 75, math.random( 100, 150 ), 1.0 )
            Metrostroi.PeopleOnRails = Metrostroi.PeopleOnRails + 1
            --if math.random() > 0.85 then
            --Metrostroi.VoltageRestoreTimer = CurTime() + 7.0
            --print("[!] Power feed protection tripped: "..(tostring(v) or "").." died on rails")
            --end
        end
    end
end

function MPLR.MapHasFullSupport( typ ) --todo establish criteria for when a map is fully finished
    if not typ then return #Metrostroi.Paths > 0 end
end

function MPLR.convertToSourceForce( newtonMetrePerSecond )
    local newtonInKg = 0.1 -- 1 Newton is roughly 0.1 kilograms
    local inchToMeter = 0.0254 -- 1 inch is equal to 0.0254 meters
    local conversionFactor = newtonInKg / inchToMeter -- Conversion factor assuming 1sU = 1in
    local result = newtonMetrePerSecond * conversionFactor
    return result
end

function MPLR.TrainCount( ... )
    local classnames = { ... }
    if #classnames == 1 then return #ents.FindByClass( classnames[ 1 ] ) end
    local N = 0
    for k, v in pairs( #classnames > 0 and classnames or MPLR.TrainClasses ) do
        if not baseclass.Get( v ).SubwayTrain then continue end
        N = N + #ents.FindByClass( v )
    end
    return N
end

function MPLR.TrainCountOnPlayer( ply, ... )
    local classnames = { ... }
    local typ
    if type( classnames[ 1 ] ) == "number" then
        typ = classnames[ 1 ]
        classnames = {}
    end

    if CPPI then
        local N = 0
        for k, v in pairs( #classnames > 0 and classnames or MPLR.TrainClasses ) do
            if not baseclass.Get( v ).SubwayTrain then continue end
            local ents = ents.FindByClass( v )
            for k2, v2 in pairs( ents ) do
                if ply == v2:CPPIGetOwner() and ( not typ or v2.SubwayTrain.WagType == typ ) then N = N + 1 end
            end
        end
        return N
    end
    return 0
end

function MPLR.VoltageChanged()
end

-- format: multiline
hook.Add(
    "PlayerEnteredVehicle", 
    "MPLRPlayerTrain", 
    function( ply, veh )
        ply.InMPLRTrain = IsValid( veh:GetNW2Entity( "TrainEntity" ) ) and veh:GetNW2Entity( "TrainEntity" ).Base == "gm_subway_uf_base"
    end
)

-- format: multiline
hook.Add(
    "PlayerLeaveVehicle", 
    "MPLRPlayerTrain", 
    function( ply, veh )
        ply.InMPLRTrain = false
    end
)