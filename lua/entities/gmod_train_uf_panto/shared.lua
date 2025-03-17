ENT.Type = "anim"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Types = {
	[ "diamond" ] = { "models/lilly/uf/panto_diamond.mdl", Vector( 0, 0.0, -7 ), Angle( 0, 0, 0 ), 9, },
	[ "einholm" ] = { "models/lilly/uf/panto_einholm.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), 0 },
}

function ENT:SmoothStep( xValues, yValues, numValues, pointX, trim )
	if trim then
		if pointX <= xValues[ 1 ] then return yValues[ 1 ] end
		if pointX >= xValues[ numValues ] then return yValues[ numValues ] end
	end

	local i = 1
	if pointX <= xValues[ 1 ] then
		i = 1
	elseif pointX >= xValues[ numValues ] then
		i = numValues
	else
		while pointX >= xValues[ i + 1 ] do
			i = i + 1
		end
	end

	if pointX == xValues[ i + 1 ] then return yValues[ i + 1 ] end
	local t = ( pointX - xValues[ i ] ) / ( xValues[ i + 1 ] - xValues[ i ] )
	t = t * t * ( 3 - 2 * t )
	return yValues[ i ] * ( 1 - t ) + yValues[ i + 1 ] * t
end

function ENT:SetBASSPos( snd, tbl )
	if tbl then
		snd:SetPos( self:LocalToWorld( Vector( 0, 0, tbl[ 3 ] ) ), self:GetAngles():Forward() )
	else
		snd:SetPos( self:GetPos() )
	end
end

function ENT:SetBassParameters( snd, pitch, volume, tbl, looping, spec )
	if snd:GetState() ~= GMOD_CHANNEL_STOPPED and snd:GetState() ~= GMOD_CHANNEL_PAUSED then return end
	self:SetBASSPos( snd, tbl )
	if tbl then
		snd:Set3DFadeDistance( tbl[ 1 ], tbl[ 2 ] )
		if tbl[ 4 ] then
			snd:SetVolume( tbl[ 4 ] * volume )
		else
			snd:SetVolume( volume )
		end
	else
		snd:Set3DFadeDistance( 200, 1e9 )
		snd:SetVolume( volume )
	end

	snd:EnableLooping( looping or false )
	snd:SetPlaybackRate( pitch )
	local siz1, siz2 = snd:Get3DFadeDistance()
	--[[]
	debugoverlay.Sphere(snd:GetPos(),4,2,Color(0,255,0),true)
	debugoverlay.Sphere(snd:GetPos(),siz1,2,Color(255,0,0,100),false)]]
	--debugoverlay.Sphere(snd:GetPos(),siz2,2,Color(0,0,255,100),false)
end

function ENT:PlayOnceFromPos( id, sndname, volume, pitch, min, max, location )
	if self.StopSounds then return end
	self:DestroySound( self.Sounds[ id ], true )
	self.Sounds[ id ] = nil
	if sndname == "_STOP" then return end
	self:CreateBASSSound( sndname, function( snd )
		self.Sounds[ id ] = snd
		self:SetBassParameters( self.Sounds[ id ], pitch, volume, location, false )
		snd:Play()
	end )
end

function ENT:CreateBASSSound( name, callback, noblock, onerr )
	if self.StopSounds then return end
	--if self.SoundSpawned and name:find(".wav") then return end
	--self.SoundSpawned = true
	sound.PlayFile( Sound( "sound/" .. name ), "3d noplay mono" .. ( noblock and " noblock" or "" ), function( snd, err, errName )
		if not IsValid( self ) then
			destroySound( snd )
			return
		end

		if err then
			self:DestroySound( snd )
			if err == 4 or err == 37 then self.StopSounds = true end
			if err ~= 41 then
				MsgC( Color( 255, 0, 0 ), Format( "Sound:%s\n\tErrCode:%s, ErrName:%s\n", name, err, errName ) )
				if onerr then callback( false ) end
			elseif GetConVar( "metrostroi_drawdebug" ):GetInt() ~= 0 then
				MsgC( Color( 255, 255, 0 ), Format( "Sound:%s\n\tBASS_ERROR_UNKNOWN (it's normal),ErrCode:%s, ErrName:%s\n", name, err, errName ) )
				self:CreateBASSSound( name, callback )
			end
			return
		elseif not self.Sounds then
			self:DestroySound( snd )
			if onerr then callback( false ) end
		else
			callback( snd )
		end
	end )
end

local function destroySound( snd, nogc )
	if IsValid( snd ) then snd:Stop() end
	if not nogc and snd and snd.__gc then snd:__gc() end
end

function ENT:DestroySound( snd, nogc )
	destroySound( snd, nogc )
end

physenv.AddSurfaceData( [[
"gmod_silent"
{
	"impacthard"	"DoorSound.Null"
	"impactsoft"	"DoorSound.Null"
	"audiohardnessfactor" "0.0"
	"audioroughnessfactor" "0.0"
	"scrapeRoughThreshold" "1.0"
	"impactHardThreshold" "1.0"
	"gamematerial"	"X"
}
"gmod_ice"
{
	"friction"	"0.01"
	"elasticity"	"0.01"
	"audioroughnessfactor" "0.1"
	"gamematerial"	"X"
}
]] )