--------------------------------------------------------------------------------
-- Rerailing, testing whether train is on rails
--------------------------------------------------------------------------------
-- Z Offset for rerailing bogeys
local bogeyOffset = 20
local TRACK_GAUGE = 56 --Distance between rails
local TRACK_WIDTH = 2.26 --Width of a single rail
local TRACK_HEIGHT = 3.24 --Height of a single rail
local TRACK_CLEARANCE = 100 --Vertical space above the rails that will always be clear of world, also used as rough estimation of train height
--------------------------------------------------------------------------------
local TRACK_SINGLERAIL = ( TRACK_GAUGE + TRACK_WIDTH ) / 2
local function dirdebug( pos, dir, color )
	if not pos or not dir then
		print( "No debug data received" )
		return
	end

	-- If a table (track-data) is passed, try to use centerpos
	if type( pos ) == "table" and pos.centerpos then pos = pos.centerpos end
	-- Fallback: if pos is still not a vector, abort gracefully
	if not pos or not pos.x then
		print( "dirdebug: invalid pos (not a Vector)." )
		return
	end

	debugoverlay.Line( pos, pos + dir, 5, color or Color( 255, 255, 255 ), true )
end

-- Takes datatable from getTrackData
function debugtrackdata( ent )
	local data = getTrackDataBelowEnt( ent )
	if not data then return end
	-- Rail points
	debugoverlay.Cross( data.leftRail, 4, 10, Color( 255, 0, 0 ), true )
	debugoverlay.Cross( data.rightRail, 4, 10, Color( 0, 255, 0 ), true )
	-- Center line and direction
	debugoverlay.Line( data.leftRail, data.rightRail, 5, Color( 255, 255, 0 ), true )
	debugoverlay.Cross( data.centerpos, 6, 10, Color( 255, 255, 255 ), true )
	debugoverlay.Axis( data.centerpos, data.forward:Angle(), 20, 5, true )
end

-- Helper for commonly used trace
local function traceWorldOnly( pos, dir, col )
	local tr = util.TraceLine( {
		start = pos,
		endpos = pos + dir,
		mask = MASK_PLAYERSOLID
	} )

	-- Debug overlay
	--debugoverlay.Line( tr.StartPos, tr.HitPos, 10, col or Color( 0, 0, 255 ), true )
	--debugoverlay.Sphere( tr.StartPos, 2, 10, Color( 0, 255, 255 ), true )
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

	if IsValid( train ) then
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

local function ElevateToTrackLevel( pos, right, up )
	local tr1 = traceWorldOnly( pos + up * TRACK_CLEARANCE + right * TRACK_SINGLERAIL, -up * TRACK_CLEARANCE * 2 )
	local tr2 = traceWorldOnly( pos + up * TRACK_CLEARANCE - right * TRACK_SINGLERAIL, -up * TRACK_CLEARANCE * 2 )
	debugoverlay.Line( leftRailTop + offset, rightRailTop + offset, dbgTime, Color( 0, 0, 255 ), true )
	-- If either trace failed, we can’t determine rail height
	if not tr1.Hit or not tr2.Hit then return false end
	local rightRailTop = tr1.HitPos + up * TRACK_HEIGHT
	local leftRailTop = tr2.HitPos + up * TRACK_HEIGHT
	local centerpos = ( tr1.HitPos + tr2.HitPos ) / 2
	-- Debug overlay tweaks: longer lifetime + slight lift for visibility
	local dbgTime = 15
	local offset = up * 1.5
	debugoverlay.Cross( centerpos + offset, 5, dbgTime, Color( 0, 255, 255 ), true ) -- Elevated track center
	debugoverlay.Sphere( tr1.HitPos + offset, 2, dbgTime, Color( 0, 255, 0 ), true ) -- Right rail base
	debugoverlay.Sphere( tr2.HitPos + offset, 2, dbgTime, Color( 255, 0, 0 ), true ) -- Left rail base
	debugoverlay.Sphere( rightRailTop + offset, 2, dbgTime, Color( 0, 128, 0 ), true ) -- Right rail top
	debugoverlay.Sphere( leftRailTop + offset, 2, dbgTime, Color( 128, 0, 0 ), true ) -- Left rail top
	debugoverlay.Line( tr1.HitPos + offset, rightRailTop + offset, dbgTime, Color( 0, 255, 0 ), true )
	debugoverlay.Line( tr2.HitPos + offset, leftRailTop + offset, dbgTime, Color( 255, 0, 0 ), true )
	debugoverlay.Line( tr1.HitPos + offset, tr2.HitPos + offset, dbgTime, Color( 255, 255, 0 ), true )
	return {
		centerpos = centerpos,
		leftRail = tr2.HitPos,
		rightRail = tr1.HitPos,
		leftRailTop = leftRailTop,
		rightRailTop = rightRailTop
	}
end

-- Takes position and initial rough forward vector, return table of track data
-- Position needs to be between/below the tracks already, don't use a props origin
-- Only needs a rough forward vector, ent:GetAngles():Forward() suffices
function MPLR.RerailGetTrackData( pos, forward )
	print( "RUNNING" )
	debugoverlay.Text( pos + Vector( 0, 0, 50 ), "ENTER getTrackData", 5 )
	debugoverlay.Cross( pos, 5, 10, Color( 255, 0, 255 ), true )
	-- ↓ 1. Downward trace: find ground
	local tr = traceWorldOnly( pos, Vector( 0, 0, -500 ) )
	debugoverlay.Line( pos, pos - Vector( 0, 0, 500 ), 10, Color( 0, 255, 255 ), true )
	if not tr or not tr.Hit then
		debugoverlay.Cross( pos - Vector( 0, 0, 500 ), 5, 10, Color( 255, 0, 0 ), true )
		debugoverlay.Text( pos - Vector( 0, 0, 495 ), "Ground Miss", 5 )
		return false
	end

	local updir = tr.HitNormal
	local floor = tr.HitPos + updir * ( TRACK_HEIGHT * 0.9 )
	local approxRight = forward:Cross( updir )
	-- ↓ 2. Side trace: establish approximate right vector
	local trSide = traceWorldOnly( floor, approxRight * 500 )
	debugoverlay.Line( floor, floor + approxRight * 500, 10, Color( 0, 255, 255 ), true )
	debugoverlay.Cross( floor, 6, 10, Color( 255, 255, 255 ), true )
	debugoverlay.Text( floor + Vector( 0, 0, 8 ), "floor", 5 )
	debugoverlay.Cross( centerpos, 6, 10, Color( 0, 255, 255 ), true )
	debugoverlay.Text( centerpos + Vector( 0, 0, 8 ), "centerpos", 5 )
	if not trSide or not trSide.Hit then
		debugoverlay.Cross( floor + approxRight * 500, 5, 10, Color( 255, 0, 0 ), true )
		debugoverlay.Text( floor + approxRight * 500 + Vector( 0, 0, 5 ), "Right Wall Miss", 5 )
		print( "QUITTING" )
		return false
	end

	local trackforward = trSide.HitNormal:Cross( updir )
	local trackright = trackforward:Cross( updir )
	dirdebug( trSide.HitPos, updir * 50, Color( 0, 0, 255 ) ) -- Up
	dirdebug( floor, trackright * 50, Color( 255, 0, 0 ) ) -- Right
	dirdebug( floor, trackforward * 50, Color( 0, 255, 0 ) ) -- Forward
	debugoverlay.Axis( floor, trackforward:Angle(), 10, 5, true )
	debugoverlay.Text( floor + Vector( 0, 0, 15 ), "Track Axes", 5 )
	-- ↓ 3. Forward guide
	debugoverlay.Line( floor, floor + trackforward * 200, 10, Color( 0, 255, 255 ), true )
	-- ↓ 4. Trace left and right rails
	local trRight = traceWorldOnly( floor, trackright * TRACK_GAUGE )
	local trLeft = traceWorldOnly( floor, -trackright * TRACK_GAUGE )
	-- Right rail
	debugoverlay.Line( floor, floor + trackright * TRACK_GAUGE, 10, Color( 0, 255, 255 ), true )
	if trRight and trRight.Hit then
		debugoverlay.Cross( trRight.HitPos, 4, 10, Color( 0, 255, 0 ), true )
		debugoverlay.Text( trRight.HitPos + Vector( 0, 0, 5 ), "Right Rail", 5 )
	else
		debugoverlay.Cross( floor + trackright * TRACK_GAUGE, 4, 10, Color( 255, 0, 0 ), true )
		debugoverlay.Text( floor + trackright * TRACK_GAUGE + Vector( 0, 0, 5 ), "Right Miss", 5 )
	end

	-- Left rail
	debugoverlay.Line( floor, floor - trackright * TRACK_GAUGE, 10, Color( 0, 255, 255 ), true )
	if trLeft and trLeft.Hit then
		debugoverlay.Cross( trLeft.HitPos, 4, 10, Color( 0, 255, 0 ), true )
		debugoverlay.Text( trLeft.HitPos + Vector( 0, 0, 5 ), "Left Rail", 5 )
	else
		debugoverlay.Cross( floor - trackright * TRACK_GAUGE, 4, 10, Color( 255, 0, 0 ), true )
		debugoverlay.Text( floor - trackright * TRACK_GAUGE + Vector( 0, 0, 5 ), "Left Miss", 5 )
	end

	if not ( trRight and trLeft and trRight.Hit and trLeft.Hit ) then return false end
	-- ↓ 5. Connect rails and centre
	debugoverlay.Line( trLeft.HitPos, trRight.HitPos, 10, Color( 255, 255, 0 ), true ) -- rail gauge
	local centerpos = ( trLeft.HitPos + trRight.HitPos ) / 2
	debugoverlay.Cross( centerpos, 6, 10, Color( 255, 255, 255 ), true )
	debugoverlay.Text( centerpos + Vector( 0, 0, 10 ), "Track Centre", 5 )
	debugoverlay.Line( centerpos, trLeft.HitPos, 10, Color( 255, 255, 255 ), true )
	debugoverlay.Line( centerpos, trRight.HitPos, 10, Color( 255, 255, 255 ), true )
	-- ↓ 6. Elevation / top-of-rail indicators
	local railData = ElevateToTrackLevel( floor, trackright, updir )
	if not railData then return false end
	local topOfRail = centerpos + updir * ( TRACK_HEIGHT or 15 )
	debugoverlay.Line( centerpos, topOfRail, 10, Color( 0, 128, 255 ), true )
	debugoverlay.Cross( topOfRail, 5, 10, Color( 0, 128, 255 ), true )
	debugoverlay.Text( topOfRail + Vector( 0, 0, 5 ), "Top of Rail", 5 )
	-- ↓ 7. Clearance offset above the track
	local CLEARANCE_OFFSET = 150 -- cm → 1.5 m above top
	local clearancePos = topOfRail + updir * CLEARANCE_OFFSET
	debugoverlay.Line( topOfRail, clearancePos, 10, Color( 255, 128, 0 ), true )
	debugoverlay.Cross( clearancePos, 6, 10, Color( 255, 128, 0 ), true )
	debugoverlay.Text( clearancePos + Vector( 0, 0, 5 ), "Clearance", 5 )
	debugoverlay.Text( pos + Vector( 0, 0, 80 ), "EXIT getTrackData", 5 )
	print( "[getTrackData] floor", floor )
	print( "[getTrackData] right", trackright )
	print( "[getTrackData] leftRail", trLeft and trLeft.HitPos )
	print( "[getTrackData] rightRail", trRight and trRight.HitPos )
	print( "[getTrackData] center", centerpos )
	return {
		forward = trackforward,
		right = trackright,
		up = updir,
		centerpos = centerpos,
		leftRail = trLeft.HitPos,
		rightRail = trRight.HitPos,
		top = topOfRail,
		clearance = clearancePos,
	}
end

-- Helper function that tries to find trackdata at -z or -ent:Up()
function getTrackDataBelowEnt( ent )
	if not IsValid( ent ) then return nil end
	local pos = ent:GetPos()
	local down = Vector( 0, 0, -1 )
	local traceLength = 80
	-- Trace left and right from the bogey
	local offsetRight = ent:GetRight() * 35
	local tr1 = util.TraceLine( {
		start = pos + offsetRight,
		endpos = pos + offsetRight + down * traceLength,
		mask = MASK_SOLID_BRUSHONLY
	} )

	local tr2 = util.TraceLine( {
		start = pos - offsetRight,
		endpos = pos - offsetRight + down * traceLength,
		mask = MASK_SOLID_BRUSHONLY
	} )

	if not tr1.Hit or not tr2.Hit then return nil end
	local leftRailPos = tr2.HitPos
	local rightRailPos = tr1.HitPos
	local centerPos = ( leftRailPos + rightRailPos ) / 2
	local forward = ( rightRailPos - leftRailPos ):GetNormalized():Cross( Vector( 0, 0, 1 ) )
	local right = ( rightRailPos - leftRailPos ):GetNormalized()
	local up = forward:Cross( right ):GetNormalized()
	return {
		forward = forward,
		right = right,
		up = up,
		centerpos = centerPos,
		leftRail = leftRailPos,
		rightRail = rightRailPos
	}
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
	bogey:GetPhysicsObject():EnableMotion( false )
	local solids = {}
	local wheels = bogey.Wheels
	solids[ bogey ] = bogey:GetSolid()
	if wheels ~= nil then
		solids[ wheels ] = wheels:GetSolid()
		wheels:SetSolid( SOLID_NONE )
	end

	bogey:SetSolid( SOLID_NONE )
	bogey:GetPhysicsObject():EnableMotion( true )
	bogey:SetPos( trackData.centerpos + trackData.up * ( bogey.BogeyOffset or bogeyOffset ) )
	bogey:SetAngles( trackData.forward:Angle() )
	timer.Create( "mplr_rerailer_solid_reset_" .. bogey:EntIndex(), 0, 1, function() resetSolids( solids ) end )
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
		local frontdata = MPLR.RerailGetTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
		if not frontdata then return false end
		tr = traceWorldOnly( middlepos, -trackdata.up * 500 )
		if not tr or not tr.Hit then return false end
		local middledata = MPLR.RerailGetTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
		if not middledata then return false end
		tr = traceWorldOnly( rearepos, -trackdata.up * 500 )
		if not tr or not tr.Hit then return false end
		local reardata = MPLR.RerailGetTrackData( tr.HitPos + tr.HitNormal * 3, trackdata.forward )
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