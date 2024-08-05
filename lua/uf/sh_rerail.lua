--------------------------------------------------------------------------------
-- Rerailing, testing whether train is on rails
--------------------------------------------------------------------------------
-- Z Offset for rerailing bogeys
local bogeyOffset = 31
local TRACK_GAUGE = 56 --Distance between rails
local TRACK_WIDTH = 2.2 --Width of a single rail
local TRACK_HEIGHT = 14 --Height of a single rail
local TRACK_CLEARANCE = 160 --Vertical space above the rails that will always be clear of world, also used as rough estimation of train height
--------------------------------------------------------------------------------
local TRACK_SINGLERAIL = ( TRACK_GAUGE + TRACK_WIDTH ) / 2
local function dirdebug( v1, v2 )
	debugoverlay.Line( v1, v1 + v2 * 30, 10, Color( 255, 0, 0 ), true )
end

-- Takes datatable from getTrackData
local function debugtrackdata( data )
	dirdebug( data.centerpos, data.forward )
	dirdebug( data.centerpos, data.right )
	dirdebug( data.centerpos, data.up )
end

-- Helper for commonly used trace
local function traceWorldOnly( pos, dir, col )
	local tr = util.TraceLine( {
		start = pos,
		endpos = pos + dir,
		mask = MASK_NPCWORLDSTATIC
	} )

	debugoverlay.Line( tr.StartPos, tr.HitPos, 10, col or Color( 0, 0, 255 ), true )
	debugoverlay.Sphere( tr.StartPos, 2, 10, Color( 0, 255, 255 ), true )
	return tr
end

-- Go over the enttable, bogeys and train and reset them
local function resetSolids( enttable, train )
	for k, v in pairs( enttable ) do
		if IsValid( k ) then
			k:SetSolid( v )
			k:GetPhysicsObject():EnableMotion( true )
		end
	end

	if train ~= nil and IsValid( train ) then
		train.FrontBogey:GetPhysicsObject():EnableMotion( true )
		train.MiddleBogey:GetPhysicsObject():EnableMotion( true )
		train.RearBogey:GetPhysicsObject():EnableMotion( true )
		if IsValid( train.FrontCouple ) then
			train.FrontCouple:GetPhysicsObject():EnableMotion( true )
			train.RearCouple:GetPhysicsObject():EnableMotion( true )
		end

		train:GetPhysicsObject():EnableMotion( true )
	end
end

-- Elevates a position to track level
-- Requires a position in the center of the track
local function ElevateToTrackLevel( pos, right, up )
	local tr1 = traceWorldOnly( pos + up * TRACK_CLEARANCE + right * TRACK_SINGLERAIL, -up * TRACK_CLEARANCE * 2 )
	local tr2 = traceWorldOnly( pos + up * TRACK_CLEARANCE - right * TRACK_SINGLERAIL, -up * TRACK_CLEARANCE * 2 )
	-- Visualize the rail traces
	debugoverlay.Line( tr1.StartPos, tr1.HitPos, 10, Color( 0, 255, 0 ), true ) -- Right rail
	debugoverlay.Line( tr2.StartPos, tr2.HitPos, 10, Color( 0, 255, 0 ), true ) -- Left rail
	if not tr1.Hit or not tr2.Hit then return false end
	local centerpos = ( tr1.HitPos + tr2.HitPos ) / 2
	debugoverlay.Cross( centerpos, 5, 10, Color( 0, 255, 255 ), true ) -- Elevated track center
	return centerpos
end

-- Takes position and initial rough forward vector, return table of track data
-- Position needs to be between/below the tracks already, don't use a props origin
-- Only needs a rough forward vector, ent:GetAngles():Forward() suffices
local function getTrackData( pos, forward )
	-- Trace down
	debugoverlay.Cross( pos, 5, 10, Color( 255, 0, 255 ), true ) -- Starting position cross
	local tr = traceWorldOnly( pos, Vector( 0, 0, -500 ) )
	if not tr or not tr.Hit then return false end
	debugoverlay.Line( tr.StartPos, tr.HitPos, 10, Color( 0, 255, 0 ), true ) -- Line showing the trace
	debugoverlay.Cross( tr.HitPos, 5, 10, Color( 255, 0, 0 ), true ) -- Hit position cross
	local updir = tr.HitNormal
	local floor = tr.HitPos + updir * ( TRACK_HEIGHT * 0.9 )
	local right = forward:Cross( updir )
	-- Trace right
	tr = traceWorldOnly( floor, right * 500 )
	if not tr or not tr.Hit then return false end
	debugoverlay.Line( tr.StartPos, tr.HitPos, 10, Color( 0, 255, 0 ), true ) -- Right trace
	local trackforward = tr.HitNormal:Cross( updir )
	local trackright = trackforward:Cross( updir )
	debugoverlay.Axis( floor, trackforward:Angle(), 10, 5, true ) -- Floor axes visualization
	-- Trace right and left for rails
	local tr1 = traceWorldOnly( floor, trackright * TRACK_GAUGE )
	local tr2 = traceWorldOnly( floor, -trackright * TRACK_GAUGE )
	if not tr1 or not tr2 then return false end
	debugoverlay.Line( tr1.StartPos, tr1.HitPos, 10, Color( 0, 255, 0 ), true ) -- Right rail trace
	debugoverlay.Line( tr2.StartPos, tr2.HitPos, 10, Color( 0, 255, 0 ), true ) -- Left rail trace
	debugoverlay.Cross( ( tr1.HitPos + tr2.HitPos ) / 2, 5, 10, Color( 255, 0, 0 ), true ) -- Midpoint between rails
	local centerpos = ElevateToTrackLevel( floor, trackright, updir )
	if not centerpos then return false end
	debugoverlay.Cross( centerpos, 5, 10, Color( 255, 0, 0 ), true ) -- Elevated center position
	local data = {
		forward = trackforward,
		right = trackright,
		up = updir,
		centerpos = centerpos
	}

	-- Visualize track data
	debugoverlay.Cross( centerpos, 5, 10, Color( 255, 0, 0 ), true ) -- Center position
	debugoverlay.Line( centerpos, centerpos + trackforward * 30, 10, Color( 255, 0, 0 ), true ) -- Forward direction
	debugoverlay.Line( centerpos, centerpos + trackright * 30, 10, Color( 0, 255, 0 ), true ) -- Right direction
	debugoverlay.Line( centerpos, centerpos + updir * 30, 10, Color( 0, 0, 255 ), true ) -- Up direction
	return data
end

UF.RerailGetTrackData = getTrackData
-- Helper function that tries to find trackdata at -z or -ent:Up()
local function getTrackDataBelowEnt( ent )
	local forward = ent:GetAngles():Forward()
	local tr = traceWorldOnly( ent:GetPos(), Vector( 0, 0, -500 ) )
	if tr.Hit then
		local td = getTrackData( tr.HitPos, forward )
		if td then return td end
	end

	local tr = traceWorldOnly( ent:GetPos(), ent:GetAngles():Up() * -500 )
	if tr.Hit then
		local td = getTrackData( tr.HitPos, forward )
		if td then return td end
	end
	return false
end

local function PlayerCanRerail( ply, ent )
	if CPPI and ent.CPPICanTool then
		return ent:CPPICanTool( ply, "metrostroi_rerailer" )
	else
		return ply:IsAdmin() or ( ent.Owner and ent.Owner == ply )
	end
end

-- ConCMD for rerailer
local function RerailConCMDHandler( ply, cmd, args, fullstring )
	local train = ply:GetEyeTrace().Entity
	if not IsValid( train ) then return end
	if not PlayerCanRerail( ply, train ) then
		ply:PrintMessage( HUD_PRINTTALK, "Cannot rerail!" )
		return
	end

	if train:GetClass() == "gmod_train_uf_bogey" then
		print( train )
		ply:PrintMessage( HUD_PRINTTALK, "Rerailing bogey!" )
		UF.RerailBogey( train )
	else
		ply:PrintMessage( HUD_PRINTTALK, "Rerailing whole train!" )
		UF.RerailTrain( train, ply )
	end
end

if SERVER then concommand.Add( "mplr_rerail", RerailConCMDHandler, nil, "Rerail a train or bogey", FCVAR_CLIENTCMD_CAN_EXECUTE ) end
--------------------------------------------------------------------------------
-- Rerails a single bogey
--------------------------------------------------------------------------------
function UF.RerailBogey( bogey )
	if timer.Exists( "mplr_rerailer_solid_reset_" .. bogey:EntIndex() ) then return false end
	local trackData = getTrackDataBelowEnt( bogey )
	if not trackData then return false end
	bogey:SetPos( trackData.centerpos + trackData.up * ( bogey.BogeyOffset or bogeyOffset ) )
	bogey:SetAngles( trackData.forward:Angle() )
	-- Visualize bogey placement
	debugoverlay.Cross( bogey:GetPos(), 5, 10, Color( 255, 255, 0 ), true ) -- Bogey position
	debugoverlay.Axis( bogey:GetPos(), bogey:GetAngles(), 10, 5, true ) -- Bogey axes
	bogey:GetPhysicsObject():EnableMotion( false )
	local solids = {}
	local wheels = bogey.Wheels
	solids[ bogey ] = bogey:GetSolid()
	bogey:SetSolid( SOLID_NONE )
	if wheels ~= nil then
		solids[ wheels ] = wheels:GetSolid()
		wheels:SetSolid( SOLID_NONE )
	end

	timer.Create( "mplr_rerailer_solid_reset_" .. bogey:EntIndex(), 1, 1, function() resetSolids( solids ) end )
	return true
end

--------------------------------------------------------------------------------
-- Rerails given train entity
--------------------------------------------------------------------------------
function UF.RerailTrain( train, ply )
	-- Safety checks
	if not IsValid( train ) or train.SubwayTrain == nil then return false end
	if train.NoPhysics or not IsValid( train:GetPhysicsObject() ) then return false end
	if timer.Exists( "mplr_rerailer_solid_reset_" .. train:EntIndex() ) then return false end
	local trackdata = getTrackDataBelowEnt( train )
	local trackdata2 = getTrackDataBelowEnt( train.SectionB )
	if not trackdata and trackdata2 then return false end
	local ang = trackdata.forward:Angle()
	local ang2 = trackdata2.forward:Angle()
	if train.AxleCount == 6 or not train.AxleCount then
		-- Get the positions of the bogeys if we'd rerail the train now
		local frontoffset = train:WorldToLocal( train.FrontBogey:GetPos() )
		frontoffset:Rotate( ang )
		local frontpos = frontoffset + train:GetPos()
		local middleoffset = train:WorldToLocal( train.MiddleBogey:GetPos() )
		middleoffset:Rotate( ang )
		local middlepos = middleoffset + train:GetPos()
		local rearoffset = train:WorldToLocal( train.RearBogey:GetPos() )
		rearoffset:Rotate( ang )
		local rearepos = middleoffset + train:GetPos()
		-- Visualize the expected bogey positions
		debugoverlay.Cross( frontpos, 5, 10, Color( 0, 255, 255 ), true ) -- Front bogey
		debugoverlay.Cross( middlepos, 5, 10, Color( 0, 255, 255 ), true ) -- Middle bogey
		debugoverlay.Cross( rearepos, 5, 10, Color( 0, 255, 255 ), true ) -- Rear bogey
		-- Get the track data at these locations
		local tr = traceWorldOnly( frontpos, -trackdata.up * 500 )
		if not tr or not tr.Hit then return false end
		local frontdata = getTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
		if not frontdata then return false end
		tr = traceWorldOnly( middlepos, -trackdata.up * 500 )
		if not tr or not tr.Hit then return false end
		local middledata = getTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
		if not middledata then return false end
		tr = traceWorldOnly( rearepos, -trackdata.up * 500 )
		if not tr or not tr.Hit then return false end
		local reardata = getTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
		if not reardata then return false end
		-- Calculate final train position and apply offsets
		local TrainOriginToBogeyOffset = ( train:WorldToLocal( train.FrontBogey:GetPos() ) + train:WorldToLocal( train.MiddleBogey:GetPos() ) ) / 2
		local TrainOriginToBogeyOffset2 = ( train:WorldToLocal( train.RearBogey:GetPos() ) + train:WorldToLocal( train.MiddleBogey:GetPos() ) ) / 2
		local centerpos = ( frontdata.centerpos + middledata.centerpos + reardata.centerpos ) / 3
		local ang = trackdata.forward:Angle()
		train:SetPos( centerpos + ang:Up() * TrainOriginToBogeyOffset.z )
		train:SetAngles( ang )
		-- Visualize the final train placement
		debugoverlay.Cross( train:GetPos(), 5, 10, Color( 255, 255, 0 ), true ) -- Train position
		debugoverlay.Axis( train:GetPos(), train:GetAngles(), 10, 5, true ) -- Train axes
		return true
	end
end