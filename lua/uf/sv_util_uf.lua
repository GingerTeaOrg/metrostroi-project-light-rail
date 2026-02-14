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

function MPLR.CheckKurs( line, arg, ply )
	if not line and not arg then
		ply:PrintMessage( HUD_PRINTTALK, "Please specify a line and circulation ID." )
		return
	end

	if line and not arg then
		local result = MPLR.IBISRegisteredTrains[ line ]
		if result then
			ply:PrintMessage( HUD_PRINTTALK, "Circulation IDs already taken are:" )
			for _, v in pairs( result ) do
				ply:PrintMessage( HUD_PRINTTALK, v )
			end
		else
			ply:PrintMessage( HUD_PRINTTALK, "No trains registered on this line yet." )
		end
	elseif line and arg then
		local taken = MPLR.IBISRegisteredTrains[ line ] == arg
		local response = taken and "taken" or "not taken"
		ply:PrintMessage( HUD_PRINTTALK, "This circulation ID is " .. response .. "." )
	end
end

-- format: multiline
hook.Add(
	"PlayerSay", 
	"MPLR_RBLCheck", 
	function( ply, text, teamChat )
		if bDead then return true end
		text = string.lower( text )
		local silent = string.sub( text, 1, 1 ) == "/"
		local command = "!mplr_rbl"
		local command2 = "/mplr_rbl"
		local command3 = "!rbl"
		local command4 = "/rbl"
		local match1
		local match2
		local match3
		local match4
		match1 = string.sub( text, 1, #command ) == command
		match2 = string.sub( text, 1, #command2 ) == command2
		match3 = string.sub( text, 1, #command3 ) == command3
		match4 = string.sub( text, 1, #command4 ) == command4
		if not match1 and not match2 and not match3 and not match4 then return end
		local message
		if match1 then
			message = string.Trim( string.sub( text, #command + 1 ) )
		elseif match2 then
			message = string.Trim( string.sub( text, #command2 + 1 ) )
		elseif match3 then
			message = string.Trim( string.sub( text, #command3 + 1 ) )
		elseif match4 then
			message = string.Trim( string.sub( text, #command4 + 1 ) )
		end

		local args = string.Explode( " ", message )
		local line = tonumber( args[ 1 ] )
		print( args[ 1 ] )
		print( args[ 2 ] )
		local arg = tonumber( args[ 2 ] )
		MPLR.CheckKurs( line, arg, ply )
		-- Hide chat message if silent
		if silent then return "" end
	end
)

--------------------------------------------------------------------------------
-- Joystick controls
-- Author: HunterNL
--------------------------------------------------------------------------------
MPLR.JoystickValueRemap = MPLR.JoystickValueRemap or {}
MPLR.JoystickSystemMap = MPLR.JoystickSystemMap or {}
function MPLR.RegisterJoystickInput( uid, analog, desc, min, max )
	if not joystick then Error( "Joystick Input registered without joystick addon installed, get it at https://github.com/AmyJeanes/Joystick-Module" ) end
	--If this is only called in a JoystickRegister hook it should never even happen
	if #uid > 20 then
		print( "Metrostroi Joystick UID too long, trimming" )
		local uid = string.Left( uid, 20 )
	end

	local atype
	if analog then
		atype = "analog"
	else
		atype = "digital"
	end

	local temp = {
		uid = uid,
		type = atype,
		description = desc,
		category = "Metrostroi: Project Light Rail" --Just Metrostroi for now, seperate catagories for different trains later?
	}

	--Catergory is also checked in subway base, don't just change
	--Joystick addon's build-in remapping doesn't work so well, so we're doing this instead
	if min ~= nil and max ~= nil and analog then MPLR.JoystickValueRemap[ uid ] = { min, max } end
	jcon.register( temp )
end

-- Wrapper around joystick get to implement our own remapping
function MPLR.GetJoystickInput( ply, uid )
	local remapinfo = MPLR.JoystickValueRemap[ uid ]
	local jvalue = joystick.Get( ply, uid )
	if remapinfo == nil then
		return jvalue
	elseif jvalue ~= nil then
		return math.Remap( joystick.Get( ply, uid ), 0, 255, remapinfo[ 1 ], remapinfo[ 2 ] )
	else
		return jvalue
	end
end

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