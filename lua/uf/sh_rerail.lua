--------------------------------------------------------------------------------
-- Rerailing, testing whether train is on rails
--------------------------------------------------------------------------------
-- Z Offset for rerailing bogeys
local bogeyOffset = 11
local TRACK_GAUGE = 56 --Distance between rails
local TRACK_WIDTH = 2.26 --Width of a single rail
local TRACK_HEIGHT = 3.24 --Height of a single rail
local TRACK_CLEARANCE = 60 --Vertical space above the rails that will always be clear of world, also used as rough estimation of train height
--------------------------------------------------------------------------------
local TRACK_SINGLERAIL = ( TRACK_GAUGE + TRACK_WIDTH ) / 2
local function dirdebug( pos, dir, color )
	if not pos or not dir then
		print( "No debug data received" )
		return
	end

	debugoverlay.Line( pos, pos + dir, 5, color or Color( 255, 255, 255 ), true )
end

-- Takes datatable from getTrackData
local function debugtrackdata( data )
	-- Assuming data has centerpos, forward, right, up
	dirdebug( data.centerpos, data.forward * 50, Color( 0, 255, 0 ) ) -- Forward in green
	dirdebug( data.centerpos, data.right * 50, Color( 255, 0, 0 ) ) -- Right in red
	dirdebug( data.centerpos, data.up * 50, Color( 0, 0, 255 ) ) -- Up in blue
end

-- Helper for commonly used trace
local function traceWorldOnly( pos, dir, col )
	local tr = util.TraceLine( {
		start = pos,
		endpos = pos + dir,
		mask = MASK_PLAYERSOLID
	} )

	-- Debug overlay
	debugoverlay.Line( tr.StartPos, tr.HitPos, 10, col or Color( 0, 0, 255 ), true )
	debugoverlay.Sphere( tr.StartPos, 2, 10, Color( 0, 255, 255 ), true )
	-- Print info about what we hit
	if tr.Hit then
		print( "[Rerail Debug] Hit entity:", tr.Entity, "Class:", tr.Entity:IsValid() and tr.Entity:GetClass() or "world" )
		print( "[Rerail Debug] Hit texture:", tr.HitTexture )
		print( "[Rerail Debug] Hit normal:", tr.HitNormal )
	else
		print( "[Rerail Debug] No hit" )
	end
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
	debugoverlay.Cross( pos, 5, 10, Color( 255, 0, 255 ), true )
	-- Trace down to find ground/rail top
	local tr = traceWorldOnly( pos, Vector( 0, 0, -500 ) )
	if not tr or not tr.Hit then return false end
	local updir = tr.HitNormal
	local floor = tr.HitPos + updir * ( TRACK_HEIGHT * 0.9 )
	-- First try to estimate right and forward
	local approxRight = forward:Cross( updir )
	tr = traceWorldOnly( floor, approxRight * 500 )
	if not tr or not tr.Hit then return false end
	-- Now properly compute track orientation
	local trackforward = tr.HitNormal:Cross( updir )
	local trackright = trackforward:Cross( updir )
	-- Debug overlays
	dirdebug( tr.HitPos, updir, Color( 0, 0, 255 ) ) -- Up
	dirdebug( floor, trackright, Color( 255, 0, 0 ) ) -- Right
	dirdebug( floor, trackforward, Color( 0, 255, 0 ) ) -- Forward
	debugoverlay.Axis( floor, trackforward:Angle(), 10, 5, true )
	-- Rail traces
	local tr1 = traceWorldOnly( floor, trackright * TRACK_GAUGE )
	local tr2 = traceWorldOnly( floor, -trackright * TRACK_GAUGE )
	if not tr1 or not tr2 then return false end
	debugoverlay.Line( tr1.StartPos, tr1.HitPos, 10, Color( 0, 255, 0 ), true )
	debugoverlay.Line( tr2.StartPos, tr2.HitPos, 10, Color( 0, 255, 0 ), true )
	local centerpos = ElevateToTrackLevel( floor, trackright, updir )
	if not centerpos then return false end
	return {
		forward = trackforward,
		right = trackright,
		up = updir,
		centerpos = centerpos
	}
end

MPLR.RerailGetTrackData = getTrackData
-- Helper function that tries to find trackdata at -z or -ent:Up()
local function getTrackDataBelowEnt( ent )
	local forward = ent:GetAngles():Forward()
	dirdebug( ent:GetPos(), forward ) -- Visualize initial forward vector
	local tr = traceWorldOnly( ent:GetPos(), Vector( 0, 0, -500 ) )
	local td = getTrackData( tr.HitPos, forward )
	if td then
		debugtrackdata( td ) -- Visualize track data below entity
		return td
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
		MPLR.RerailBogey( train )
	else
		ply:PrintMessage( HUD_PRINTTALK, "Rerailing whole train!" )
		MPLR.RerailTrain( train, ply )
	end
end

if SERVER then concommand.Add( "mplr_rerail", RerailConCMDHandler, nil, "Rerail a train or bogey", FCVAR_CLIENTCMD_CAN_EXECUTE ) end
--------------------------------------------------------------------------------
-- Rerails a single bogey
--------------------------------------------------------------------------------
function MPLR.RerailBogey( bogey )
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
function MPLR.RerailTrain( train, ply )
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