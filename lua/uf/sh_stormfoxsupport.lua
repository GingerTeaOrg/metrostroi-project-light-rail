if ( not StormFox or StormFox.Version < 2 ) and not StormFox2 then return end
MPLR.WeatherSimActive = true
if CLIENT then
	MPLR.Time = StormFox2.Time.GetDisplay()
elseif SERVER then
	local timeInt = StormFox2.Time.Get( true )
	local timeString = StormFox2.Time.TimeToString( timeInt )
	MPLR.Time = timeString
end

MPLR.Day = StormFox2.Time.IsDay()
MPLR.Night = StormFox2.Time.IsNight()
MPLR.Temp = StormFox2.Temperature.Get( "celsius" )
MPLR.Rain = StormFox2.Weather.IsRaining()
MPLR.RainAmount = StormFox2.Weather.GetRainAmount()
MPLR.SlipperyTracks = MPLR.SlipperyTracks or false
function MPLR.WeatherTracker()
	MPLR.Day = StormFox2.Time.IsDay()
	MPLR.Night = StormFox2.Time.IsNight()
	MPLR.Temp = StormFox2.Temperature.Get( "celsius" )
	MPLR.Rain = StormFox2.Weather.IsRaining()
	MPLR.RainAmount = StormFox2.Weather.GetRainAmount()
	if CLIENT then
		MPLR.Time = StormFox2.Time.GetDisplay()
	elseif SERVER then
		local timeInt = StormFox2.Time.Get( true )
		local timeString = StormFox2.Time.TimeToString( timeInt, false )
		MPLR.Time = timeString
	end
end

function MPLR.IsSlippery()
	local rain = MPLR.Rain
	local rainAmount = MPLR.RainAmount
	if rain and rainAmount > 0.35 or MPLR.Temp <= 0 then
		MPLR.SlipperyTracks = true
	else
		MPLR.SlipperyTracks = false
	end
end

local outageTimer = 30
local previousVoltage = previousVoltage or -1
local outageMoment = outageMoment or -1
function MPLR.OutageCountdown()
	if CurTime() - outageMoment > outageTimer and previousVoltage ~= -1 and MPLR.Voltage ~= previousVoltage then
		outageMoment = -1
		MPLR.Voltage = previousVoltage
		previousVoltage = -1
	end
end

function MPLR.StrikeCatenary()
	local thunder = StormFox2.Thunder.IsThundering()
	local rand = math.random( 0, 100 )
	local entList = ents.FindByClass( "prop_static" )
	local hasStruck = false
	if rand < 99 or not thunder then return end
	for _, ent in ipairs( entList ) do
		local model = ent:GetModel()
		if ( string.find( model, "overhead_wire" ) or string.find( model, "catenary" ) ) and not hasStruck then
			StormFox2.Thunder.Strike( ent, 0 )
			previousVoltage = MPLR.Voltage
			outageMoment = CurTime()
			MPLR.Voltage = 0
			MPLR.OutageCountdown()
			break
		end
	end
end

hook.Add( "Think", "MPLR_WeatherTracker", function() MPLR.WeatherTracker() end )
hook.Add( "Think", "MPLR_ThunderTracker", function() MPLR.StrikeCatenary() end )
hook.Add( "Think", "MPLR_SlipperyTracker", function() MPLR.IsSlippery() end )