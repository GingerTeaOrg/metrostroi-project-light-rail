-- Copyright © Platunov I. M., 2021 All rights reserved
-- Modified under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License for M:PLR
include( "shared.lua" )
ENT.PassSpeed = 100
function ENT:Initialize()
	self:DrawShadow( false )
end

function ENT:PassengerTracker()
	self.Ents = self.Ents or {}
	local count = self:GetPassCount()
	local Ents = self.Ents
	if count > #Ents then
		while count > #Ents do
			local ent = MPLR.CreatePassenger()
			local pos, posindex = self:GetSpawnPassPos()
			local tr = util.TraceLine( {
				start = pos + Vector( 0, 0, 18 ),
				endpos = pos - Vector( 0, 0, 10000 ),
				mask = MASK_SOLID_BRUSHONLY
			} )

			ent.PosIndex = posindex
			ent:SetPos( tr.HitPos )
			ent:SetAngles( Angle( 0, self:GetAngles().y, 0 ) )
			Ents[ #Ents + 1 ] = ent
		end
	end
end

function ENT:BoardTrains()
	self.DeltaTime = RealFrameTime()
	if self:IsDormant() then
		if self.PlatformDrawn then
			self:OnRemove()
			self.PlatformDrawn = false
		end
		return
	end

	self.PlatformDrawn = true
	if self.PlatformStart == Vector( 0, 0, 0 ) then self.PlatformStart = self:GetNW2Vector( "PlatformStart" ) end
	if self.PlatformEnd == Vector( 0, 0, 0 ) then self.PlatformEnd = self:GetNW2Vector( "PlatformEnd" ) end
	-- Platform parameters
	local platformStart = self.PlatformStart
	local platformEnd = self.PlatformEnd
	local stationCenter = self:GetPos() --self:GetNW2Vector("StationCenter",false)
	if not platformStart or not platformEnd or not stationCenter or not self:GetNW2Float( "X0", false ) or not self:GetNW2Float( "Sigma", false ) then return end
	local function calculateBounds( vec1, vec2, vec3, height )
		local minBounds, maxBounds
		-- Check if Vec1 and Vec2 are aligned on X or Y axis
		if vec1.x == vec2.x then
			-- Aligned on X-axis, extend on Y
			minBounds = Vector( vec1.x - math.abs( vec3.y - vec1.y ), -- Extend based on Vec3's Y position
				math.min( vec1.y, vec2.y ), vec1.z )

			maxBounds = Vector( vec1.x + math.abs( vec3.y - vec1.y ), -- Extend based on Vec3's Y position
				math.max( vec1.y, vec2.y ), vec1.z + height )
		elseif vec1.y == vec2.y then
			-- Aligned on Y-axis, extend on X
			minBounds = Vector( math.min( vec1.x, vec2.x ), vec1.y - math.abs( vec3.x - vec1.x ), -- Extend based on Vec3's X position
				vec1.z )

			maxBounds = Vector( math.max( vec1.x, vec2.x ), vec1.y + math.abs( vec3.x - vec1.x ), -- Extend based on Vec3's X position
				vec1.z + height )
		end
		return minBounds, maxBounds
	end

	local minBounds, maxBounds = calculateBounds( platformStart, platformEnd, self:GetPos(), 50 )
	local function isInRegion( pos, min, max )
		if not min or not max then return false end
		return pos.x >= min.x and pos.x <= max.x and pos.y >= min.y and pos.y <= max.y and pos.z >= min.z and pos.z <= max.z
	end

	local inRange = isInRegion( self:GetPlayerPos(), minBounds, maxBounds )
	if inRange then
		self.PassengerSounds:ChangeVolume( 0.01, 2 )
		self.PassengerSounds:SetSoundLevel( 0 )
		self.PassengerSounds:Play()
		self.PassengerSounds:ChangeVolume( 0.01, 2 )
		--self.PassengerSounds:SetPos( self:GetPlayerPos() )
	else
		self.PassengerSounds:ChangeVolume( 0, 2 )
	end

	if self:GetNW2Bool( "MustPlaySpooky" ) then
		self.NonPassengerSounds:SetSoundLevel( 105 )
		self.NonPassengerSounds:Play()
		self.NonPassengerSounds:SetSoundLevel( 105 )
		self.NonPassengerSounds:ChangeVolume( 1 )
	else
		if self.NonPassengerSounds:IsPlaying() then self.NonPassengerSounds:Stop() end
	end

	-- Platforms with tracks in middle
	local dot = ( stationCenter - platformStart ):Cross( platformEnd - platformStart )
	if dot.z > 0.0 then
		local a, b = platformStart, platformEnd
		platformStart, platformEnd = b, a
	end

	-- If platform is defined and pool is not
	----print(self:GetNW2Vector("StationCenter"))
	----print(entStart,entEnd,self.Pool)
	self.Ents = self.Ents or {}
	local count = self:GetPassCount()
	local Ents = self.Ents
	if ( count < 1 ) and ( stationCenter:Length() > 0.0 ) then self:PopulatePlatform( platformStart, platformEnd, stationCenter ) end
	-- Check if set of models changed
	if ( CurTime() - ( self.ModelCheckTimer or 0 ) > 1.0 ) and poolReady then
		self.ModelCheckTimer = CurTime()
		local WindowStart = self:GetNW2Int( "WindowStart" )
		local WindowEnd = self:GetNW2Int( "WindowEnd" )
		for i = 1, self:PoolSize() do
			local in_bounds = false
			if WindowStart <= WindowEnd then in_bounds = ( i >= WindowStart ) and ( i < WindowEnd ) end
			if WindowStart > WindowEnd then in_bounds = ( i >= WindowStart ) or ( i <= WindowEnd ) end
			if in_bounds then
			else
				-- Model found that is not in window
				if IsValid( self.ClientModels[ i ] ) then
					-- Get nearest door
					local count = self:GetNW2Int( "TrainDoorCount", 0 )
					local distance = 1e9
					local target = Vector( 0, 0, 0 )
					for j = 1, count do
						local vec = self:GetNW2Vector( "TrainDoor" .. j, Vector( 0, 0, 0 ) )
						local d = vec:Distance( self.ClientModels[ i ]:GetPos() )
						if d < distance then
							target = vec
							distance = d
						end
					end

					-- Add to list of cleanups
					table.insert( self.CleanupModels, {
						ent = self.ClientModels[ i ],
						target = target,
					} )

					self.ClientModels[ i ] = nil
				end
			end
		end
	end

	-- Add models for cleanup of people who left trains
	self.PassengersLeft = self.PassengersLeft or self:GetNW2Int( "PassengersLeft" )
	while poolReady and ( self.PassengersLeft < self:GetNW2Int( "PassengersLeft" ) ) do
		-- Get random door
		local count = self:GetNW2Int( "TrainDoorCount", 0 )
		local i = math.max( 1, math.min( count, 1 + math.floor( ( count - 1 ) * math.random() + 0.5 ) ) )
		local pos = self:GetNW2Vector( "TrainDoor" .. i, Vector( 0, 0, 0 ) )
		pos.z = self:GetPos().z
		-- Create clientside model
		local i = math.max( 1, math.min( self:PoolSize(), 1 + math.floor( math.random() * self:PoolSize() + 0.5 ) ) )
		local ent = ClientsideModel( self.Pool[ i ].model, RENDERGROUP_OPAQUE )
		ent:SetPos( pos )
		ent:SetSkin( math.floor( ent:SkinCount() * self.Pool[ i ].skin ) )
		ent:SetModelScale( self.Pool[ i ].scale, 0 )
		-- Generate target pos
		local platformDir = platformEnd - platformStart
		local platformN = ( platformDir:Angle() + Angle( 0, 90, 0 ) ):Forward()
		local platformD = platformDir:GetNormalized()
		local platformWidth = ( ( platformStart - stationCenter ) - ( platformStart - stationCenter ):Dot( platformD ) * platformD ):Length()
		local target = pos + platformN * platformWidth
		pos = pos - platformN * 4.0 * math.random()
		pos = pos + platformD * 16.0 * math.random()
		target = target + platformD * 128.0 * math.random()
		-- Add to list of cleanups
		table.insert( self.CleanupModels, {
			ent = ent,
			target = target,
		} )

		-- Add passenger
		self.PassengersLeft = self.PassengersLeft + 1
	end

	-- Animate models for cleanup
	for k, v in pairs( self.CleanupModels ) do
		--  if not v or not IsValid(v) then self.CleanupModels[k] = nil return end
		if not IsValid( v.ent ) then continue end
		-- Get pos and target in XY plane
		local pos = v.ent:GetPos()
		local target = v.target
		local floorHeight = self:GetNW2Float( "FloorHeight", 0 )
		local selfHeight = self:GetPos().z
		local heightDelta = selfHeight > floorHeight and selfHeight - floorHeight or floorHeight - selfHeight
		pos.z = 0
		target.z = 0
		-- Find direction in which pedestrians must walk
		local targetDir = ( target - pos ):GetNormalized()
		-- Make it go along the platform if too far
		local distance = pos:Distance2D( target )
		if distance > 192 then
			local platformDir = ( platformEnd - platformStart ):GetNormalized()
			local projection = targetDir:Dot( platformDir )
			if math.abs( projection ) > 0.1 then targetDir = ( platformDir * projection ):GetNormalized() end
		end

		-- Move pedestrian
		local threshold = 16
		local speed = 256
		if distance > 1024 then speed = 512 end
		v.ent:SetPos( v.ent:GetPos() + targetDir * math.min( threshold, speed * self.DeltaTime ) )
		-- Rotate pedestrian
		v.ent:SetAngles( targetDir:Angle() + Angle( 0, 180, 0 ) )
		if distance < 3 * threshold then v.ent:SetPos( v.ent:GetPos() + targetDir * math.min( threshold, speed * self.DeltaTime ) + ( targetDir + Vector( 0, 0, heightDelta ) ) * math.min( threshold, speed * self.DeltaTime ) ) end
		-- Delete if reached the target point
		if distance < 2 * threshold or LocalPlayer():GetPos().z - v.ent:GetPos().z > 500 then
			v.ent:Remove()
			self.CleanupModels[ k ] = nil
		end

		-- Check if door can be reached at all (it still exists)
		local count = self:GetNW2Int( "TrainDoorCount", 0 )
		local distance = 1e9
		local new_target = target
		for j = 1, count do
			local vec = self:GetNW2Vector( "TrainDoor" .. j, Vector( 0, 0, 0 ) )
			local d = vec:Distance( v.target )
			if d < distance then
				new_target = vec
				distance = d
			end
		end

		if distance > 32 then
			v.target = self:GetPos()
		else
			v.target = new_target
		end
	end
end

function ENT:BoardBusses()
	if not self:IsDormant() then
		self.Ents = self.Ents or {}
		local count = self:GetPassCount()
		local Ents = self.Ents
		if count < #Ents then
			local buses = {}
			local str = self:GetNWVar( "CurrentTrolleybuses", "" )
			if str ~= "" then
				for k, v in ipairs( string.Explode( " ", self:GetNWVar( "CurrentTrolleybuses", "" ) ) ) do
					local ent = Entity( v )
					if IsValid( ent ) then buses[ #buses + 1 ] = ent end
				end
			end

			while count < #Ents do
				local ent = table.remove( Ents, math.random( 1, #Ents ) )
				if not IsValid( ent ) then continue end
				local pos = ent:GetPos()
				local doorpos, dist
				for k, bus in ipairs( buses ) do
					for k, v in pairs( bus.DoorsData ) do
						if v.nopass or not bus:DoorIsOpened( k ) then continue end
						local position = bus:LocalToWorld( v.pos )
						local distance = pos:Distance( position )
						if not dist or distance < dist then doorpos, dist = position, distance end
					end
				end

				if not doorpos then
					ent:Remove()
					continue
				end

				ent:SetPoseParameter( "move_x", 1 )
				ent:ResetSequence( "walk_all" )
				hook.Add( "Think", ent, function( ent )
					if not IsValid( self ) then
						ent:Remove()
						return
					end

					if Trolleybus_System.EyePos():Distance( ent:GetPos() ) > Trolleybus_System.GetPlayerSetting( "PassengersDrawDistance" ) then
						ent:Remove()
						return
					end

					self:MovePass( ent, doorpos, true )
					if self:Distance( ent:GetPos(), doorpos ) < 20 then ent:Remove() end
				end )
			end
		end
	end

	self:SetNextClientThink( CurTime() + 0.1 )
	return true
end

function ENT:MovePass( ent, pos, ang )
	local dir = ( pos - ent:GetPos() ):GetNormalized()
	dir.z = 0
	dir:Normalize()
	local fpos = ent:GetPos() + dir * self.PassSpeed * FrameTime()
	local tr = util.TraceLine( {
		start = fpos + Vector( 0, 0, 18 ),
		endpos = fpos - Vector( 0, 0, 10000 ),
		mask = MASK_SOLID_BRUSHONLY
	} )

	ent:SetPos( tr.StartSolid and fpos or tr.HitPos )
	if ang then
		ang = ( pos - ent:GetPos() ):Angle()
		ent:SetAngles( Angle( 0, ang.y, 0 ) )
	end

	ent:FrameAdvance( 0 )
end

function ENT:GetSpawnPassPos()
	local blocked = {}
	for k, v in pairs( self.Ents ) do
		if IsValid( v ) then blocked[ v.PosIndex ] = true end
	end

	local poss = {}
	local s = self.PassSize
	for x = 1, self:GetLength() / s.x do
		for y = 1, self:GetWidth() / s.y do
			local str = x .. ":" .. y
			if not blocked[ str ] then poss[ #poss + 1 ] = { x, y, str } end
		end
	end

	local pos = poss[ math.random( #poss ) ]
	if not pos then return self:GetPos(), "" end
	local p = Vector( -self:GetWidth() / 2, self:GetLength() / 2 ) + Vector( pos[ 2 ] * s.y - s.y / 2, -pos[ 1 ] * s.x + s.x / 2 )
	local r = math.random()
	math.randomseed( math.floor( p.x + p.y ) )
	p.x = p.x + math.Rand( -s.y, s.y ) / 3
	p.y = p.y + math.Rand( -s.x, s.x ) / 3
	math.randomseed( r * 1000 )
	return self:LocalToWorld( p ), pos[ 3 ]
end

function ENT:GetRandomPassPos()
	local pos, ang = self:GetPos(), self:GetAngles()
	pos:Add( math.Rand( 0, self:GetLength() / 2 ) * ang:Right() * ( math.random( 0, 1 ) == 1 and 1 or -1 ) )
	pos:Add( math.Rand( 0, self:GetWidth() / 2 ) * ang:Forward() * ( math.random( 0, 1 ) == 1 and 1 or -1 ) )
	return pos
end

function ENT:Distance( vec1, vec2 )
	return math.Distance( vec1.x, vec1.y, vec2.x, vec2.y )
end

function ENT:OnRemove()
	self:NotifyShouldTransmit( false )
end

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName
function ENT:Draw( flags )
	if self:GetPavilion() then
		self:DrawModel( flags )
		self:CreateShadow()
	else
		self:DestroyShadow()
	end
end

function ENT:DrawTranslucent( flags )
	if self:GetPavilion() then
		self:DrawModel( flags )
		self:CreateShadow()
	else
		self:DestroyShadow()
	end

	local pos, ang = self:GetPos() + self:GetAngles():Up() * 200, EyeAngles()
	ang:RotateAroundAxis( ang:Up(), -90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	cam.Start3D2D( pos, ang, 0.25 )
	local routesstr = ""
	for k, v in pairs( self:GetRoutes() ) do
		local route = Trolleybus_System.Routes.Routes[ k ]
		if route then routesstr = routesstr .. ( routesstr == "" and "" or ", " ) .. Trolleybus_System.Routes.GetRouteName( k ) end
	end

	local text = L( "trolleybus_stop", LN( "stop." .. game.GetMap() .. ".", self:GetStopName() ) )
	text = text .. "\n(!tstop " .. self:GetSVName() .. ")\n" .. L( "trolleybus_stop_routes", routesstr )
	draw.DrawText( text, "Trolleybus_System.Stop", 0, 0, Color( 255, 0, 0 ), 1, 1 )
	cam.End3D2D()
end

function ENT:NotifyShouldTransmit( should )
	if not should then
		if self.Ents then
			for k, v in pairs( self.Ents ) do
				SafeRemoveEntity( v )
			end

			self.Ents = nil
		end
	end
end

surface.CreateFont( "Trolleybus_System.Stop", {
	font = "Arial",
	size = 50,
	extended = true,
} )

net.Receive( "TrolleybusSystem.Stop.PassOut", function( len )
	local stop = net.ReadEntity()
	local bus = net.ReadEntity()
	local count = net.ReadUInt( 8 )
	if IsValid( stop ) and stop:GetClass() == "trolleybus_stop" and stop.GetRandomPassPos and IsValid( bus ) and not stop:IsDormant() and not bus:IsDormant() and bus.IsTrolleybus then
		for i = 1, count do
			local poss = {}
			for k, v in pairs( bus.DoorsData ) do
				if not v.nopass and bus:DoorIsOpened( k ) then poss[ #poss + 1 ] = v.pos end
			end

			if #poss == 0 then continue end
			local pass = Trolleybus_System.CreatePassenger()
			pass:SetPos( bus:LocalToWorld( table.Random( poss ) ) )
			pass:SetPoseParameter( "move_x", 1 )
			pass:SetSequence( "walk_all" )
			local goal = stop:GetRandomPassPos()
			stop:MovePass( pass, goal, true )
			hook.Add( "Think", pass, function( self )
				if not IsValid( stop ) then
					self:Remove()
					return
				end

				if Trolleybus_System.EyePos():Distance( self:GetPos() ) > Trolleybus_System.GetPlayerSetting( "PassengersDrawDistance" ) then
					self:Remove()
					return
				end

				stop:MovePass( self, goal, true )
				if stop:Distance( self:GetPos(), goal ) < 20 then self:Remove() end
			end )
		end
	end
end )