include( "shared.lua" )
ENT.RTMaterial = CreateMaterial( "UFRT4", "UnlitGeneric", {
	[ "$basetexture" ] = "example_rt",
	[ "$vertexcolor" ] = 1,
	[ "$vertexalpha" ] = 1,
	[ "$nolod" ] = 1,
	[ "$alphatest" ] = 1
} )

ENT.RTMaterial2 = CreateMaterial( "UFRT4", "VertexLitGeneric", {
	[ "$vertexcolor" ] = 0,
	[ "$vertexalpha" ] = 0,
	[ "$nolod" ] = 1
} )

function ENT:CreateRT( name, w, h )
	local RT = GetRenderTarget( "UF" .. self:EntIndex() .. ":" .. name, w or 512, h or 512 )
	if not RT then Error( "Can't create RT\n" ) end
	return RT
end

function ENT:ClockFace()
	if not IsValid( self.Hours ) and not IsValid( self.Minutes ) then return end
	local Time = self:GetNW2String( "Time", "0000" )
	local hours = tonumber( string.sub( Time, 1, 2 ), 10 )
	local minutes = tonumber( string.sub( Time, 3, 4 ), 10 )
	self.MinutePos = ( ( minutes / 60 ) * 100 ) + 2
	self.HourPos = ( ( hours / 12 ) * 100 - 4 ) + ( ( ( minutes / 60 ) * 100 ) + 2 ) / 12
	self.Hours:SetPoseParameter( "position", self.HourPos )
	self.Hours:InvalidateBoneCache()
	self.Minutes:SetPoseParameter( "position", self.MinutePos )
	self.Minutes:InvalidateBoneCache()
end

function ENT:Initialize()
	self.DFI1 = self:CreateRT( "RT1", 4096, 912 )
	-- self.DFI2 = self:CreateRT("RT2", 4096, 1024)
	--[[render.PushRenderTarget( self.DFI1, 0, 0, 1024, 128 )
	render.Clear( 0, 0, 0, 0 )
	render.PopRenderTarget()]]
	local ang = self:GetAngles()
	local pos = self:GetPos()
	self.EntIn = self:EntIndex()
	self.pos = self:LocalToWorld( Vector( -4, -8, 151 ) )
	self.pos2 = self:LocalToWorld( Vector( -12, 106, 169 ) )
	self.ang = self:LocalToWorldAngles( Angle( 0, 0, 96 ) )
	self.ang2 = self:LocalToWorldAngles( Angle( 0, 180, 96.8 ) )
	self.LEDMaterial = CreateMaterial( "LED", "UnlitGeneric", {
		[ "$basetexture" ] = "color/white",
		[ "$selfillum" ] = "1"
	} )

	--
	self.Hours = ents.CreateClientProp( "models/lilly/uf/stations/dfi_hands_hours.mdl" )
	self.Minutes = ents.CreateClientProp( "models/lilly/uf/stations/dfi_hands_minutes.mdl" )
	self.Hours:SetParent( self )
	self.Minutes:SetParent( self )
	self.Hours:SetPos( pos )
	--self.Hours:SetAngles( ang )
	self.Minutes:SetPos( pos )
	--self.Minutes:SetAngles( ang )
	self.Hours:Spawn()
	self.Minutes:Spawn()
	self.circlePoints = {}
	self.AnnouncementPlayed = false
	-- todo: Introduce an external table so that this can be made more flexible. Hardcoding is nono.
	self.Abbreviations = {
		[ "Ldstr" ] = "Ldstr.",
		[ "Pl" ] = "Platz",
		[ "Hhmrk" ] = "Hohemark",
		[ "Bmmrsh" ] = "Bommersheim"
	}

	self.Grid = {
		[ 1 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 2 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 3 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 4 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 5 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 6 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 7 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 8 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 9 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 10 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 11 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 12 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 13 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 14 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 15 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 16 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 17 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 18 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 19 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 20 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 21 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 22 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 23 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 24 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 25 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 26 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 27 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 28 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 29 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 30 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 31 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 32 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 33 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 34 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		[ 35 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	}

	self.Mode = self:GetNW2Int( "Mode", 0 )
	-- Define a unique material name
end

function ENT:Think()
	self:ClockFace()
	--self:RenderDisplay( self )
	self.Mode = self:GetNW2Int( "Mode", 0 )
	self.Theme = self:GetNW2String( "Theme", "Frankfurt" )
	self.Train1Time = self:GetNW2String( "Train1Time", "E" )
	self.Train2Time = self:GetNW2String( "Train2Time", "E" )
	self.Train3Time = self:GetNW2String( "Train3Time", "E" )
	self.Train4Time = self:GetNW2String( "Train4Time", "E" )
	self.Train1Destination = self:GetNW2String( "Train1Destination", "ERROR" )
	self.Train2Destination = self:GetNW2String( "Train2Destination", "ERROR" )
	self.Train3Destination = self:GetNW2String( "Train3Destination", "ERROR" )
	self.Train4Destination = self:GetNW2String( "Train4Destination", "ERROR" )
	self.Train1Entry = self:GetNW2Bool( "Train1Entry", false )
	self.Train2Entry = self:GetNW2Bool( "Train2Entry", false )
	self.Train3Entry = self:GetNW2Bool( "Train3Entry", false )
	self.Train4Entry = self:GetNW2Bool( "Train4Entry", false )
	if self.Theme == "Frankfurt" or self.Theme == "Essen" or self.Theme == "Duesseldorf" then
		if string.sub( self:GetNW2String( "Train1Line", "04" ), 1, 1 ) == "0" then
			self.Line1String = "U" .. string.sub( self:GetNW2String( "Train1Line", "U4" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train1Line", "U4" ), 1, 1 ) ~= "0" then
			self.Line1String = "U" .. self:GetNW2String( "Train1Line", "U4" )
		end

		if string.sub( self:GetNW2String( "Train2Line", "U4" ), 1, 1 ) == "0" then
			self.Line2String = "U" .. string.sub( self:GetNW2String( "Train2Line", "U4" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train2Line", "U4" ), 1, 1 ) ~= "0" then
			self.Line2String = "U" .. self:GetNW2String( "Train2Line", "U4" )
		end

		if string.sub( self:GetNW2String( "Train3Line", "U4" ), 1, 1 ) == "0" then
			self.Line3String = "U" .. string.sub( self:GetNW2String( "Train3Line", "U4" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train3Line", "U4" ), 1, 1 ) ~= "0" then
			self.Line3String = "U" .. self:GetNW2String( "Train3Line", "U4" )
		end

		if string.sub( self:GetNW2String( "Train4Line", "U4" ), 1, 1 ) == "0" then
			self.Line4String = "U" .. string.sub( self:GetNW2String( "Train4Line", "U4" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train4Line", "U4" ), 1, 1 ) ~= "0" then
			self.Line4String = "U" .. self:GetNW2String( "Train4Line", "U4" )
		end
	elseif self.Theme == "Koeln" or self.Theme == "Hannover" then
		if string.sub( self:GetNW2String( "Train1Line", "E0" ), 1, 1 ) == "0" then
			self.Line1String = string.sub( self:GetNW2String( "Train1Line", "E0" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train1Line", "E0" ), 1, 1 ) ~= "0" then
			self.Line1String = self:GetNW2String( "Train1Line", "E0" )
		end

		if string.sub( self:GetNW2String( "Train2Line", "E0" ), 1, 1 ) == "0" then
			self.Line2String = string.sub( self:GetNW2String( "Train2Line", "E0" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train2Line", "E0" ), 1, 1 ) ~= "0" then
			self.Line2String = self:GetNW2String( "Train2Line", "E0" )
		end

		if string.sub( self:GetNW2String( "Train3Line", "E0" ), 1, 1 ) == "0" then
			self.Line3String = string.sub( self:GetNW2String( "Train3Line", "E0" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train3Line", "E0" ), 1, 1 ) ~= "0" then
			self.Line3String = self:GetNW2String( "Train3Line", "E0" )
		end

		if string.sub( self:GetNW2String( "Train4Line", "E0" ), 1, 1 ) == "0" then
			self.Line4String = string.sub( self:GetNW2String( "Train4Line", "E0" ), 2, 2 )
		elseif string.sub( self:GetNW2String( "Train4Line", "E0" ), 1, 1 ) ~= "0" then
			self.Line4String = self:GetNW2String( "Train4Line", "E0" )
		end
	end

	if self.Mode == 2 and self.AnnouncementPlayed == false then
		self.AnnouncementPlayed = true
		if self.Theme == "Frankfurt" then -- todo implement other themes
			if self.Train1DestinationString and self.Train1DestinationString ~= "Leerfahrt" and self.Train1DestinationString ~= "PROBEWAGEN NICHT EINSTEIGEN" and self.Train1DestinationString ~= "FAHRSCHULE NICHT EINSTEIGEN" and self.Train1DestinationString ~= "SONDERWAGEN NICHT EINSTEIGEN" and self.Train1DestinationString ~= " " then
				self:PlayOnceFromPos( "lilly/uf/DFI/frankfurt/" .. self.Line1String .. " " .. "Richtung" .. " " .. self.Train1DestinationString .. ".mp3", 2, 1, 1, 1, self:GetPos() )
			else
				self:PlayOnceFromPos( "lilly/uf/DFI/frankfurt/Bitte Nicht Einsteigen.mp3", 2, 1, 1, 1, self:GetPos() )
			end
		end
	elseif self.Mode == 1 or self.Mode == 0 then
		self.AnnouncementPlayed = false
	end

	self.Train1DestinationString = self:SubstituteAbbreviation( self.Train1Destination ) and self:SubstituteAbbreviation( self.Train1Destination ) or self.Train1Destination
	self.Train2DestinationString = self:SubstituteAbbreviation( self.Train2Destination ) and self:SubstituteAbbreviation( self.Train2Destination ) or self.Train2Destination
	self.Train3DestinationString = self:SubstituteAbbreviation( self.Train3Destination ) and self:SubstituteAbbreviation( self.Train3Destination ) or self.Train3Destination
	self.Train4DestinationString = self:SubstituteAbbreviation( self.Train4Destination ) and self:SubstituteAbbreviation( self.Train4Destination ) or self.Train4Destination
	self.Pos = self:GetPos()
	self.plyPos = LocalPlayer():GetPos()
	self.dist = self.Pos:Distance( self.plyPos )
	-- print(self.dist)
end

function ENT:SubstituteAbbreviation( Input )
	local output = nil
	if Input == "ERROR" then return end
	if not self.Abbreviations then return nil end
	for k, v in pairs( self.Abbreviations ) do
		if string.find( Input, k, 1, true ) then output = string.gsub( Input, k, self.Abbreviations[ k ], 1 ) end
	end
	-- print(output)
	return output
end

function ENT:RenderDisplay( ent )
	if not ent.Grid then
		print( "NOGRID" )
		return
	end

	--print( "RENDERING!", self )
	if not ent.RenderTimer then ent.RenderTimer = RealTime() end
	if RealTime() - ent.RenderTimer > 2 then
		render.PushRenderTarget( ent.DFI1, 0, 0, 4096, 912 )
		render.Clear( 0, 0, 0, 255, true, true )
		cam.Start2D()
		if ent.Mode == 0 then
			ent:Mode0Disp( ent )
		elseif ent.Mode == 1 then
			ent:Mode1Disp( ent )
		elseif ent.Mode == 2 then
			ent:Mode2Disp( ent )
		end

		cam.End2D()
		render.PopRenderTarget()
		ent.RenderTimer = RealTime()
	end
end

function ENT:Draw()
	if not self.DisplayMaterial then
		self.DisplayMaterial = CreateMaterial( "display" .. self:EntIndex(), "UnlitGeneric", {
			[ "$basetexture" ] = self.DFI1:GetName()
		} )

		self.DisplayMaterial2 = CreateMaterial( "display2" .. self:EntIndex(), "UnlitGeneric", {
			[ "$basetexture" ] = self.DFI1:GetName()
		} )

		self:SetSubMaterial( 2, "!display" .. self:EntIndex() )
		self:SetSubMaterial( 3, "!display2" .. self:EntIndex() )
	end

	self:SetSubMaterial( 2, "!display" .. self:EntIndex() )
	self:SetSubMaterial( 3, "!display2" .. self:EntIndex() )
	self:DrawModel()
end

-- function ENT:DrawPost() end
function ENT:OnRemove()
	hook.Remove( "RenderDFIScreens" .. self:EntIndex() )
	if not IsValid( self.Hours ) then return end
	self.Hours:Remove()
	self.Minutes:Remove()
end

-- Define the LED matrix parameters
local matrixWidth = 192 -- Number of LEDs in a row
local ledSize = 21 -- Size of each LED element
function ENT:Circle( x, y, radius, seg )
	local cir = {}
	local segment = 360 / seg
	local sinCache, cosCache = {}, {}
	for i = 0, seg do
		local angle = math.rad( i * segment )
		local sinVal, cosVal = sinCache[ i ], cosCache[ i ]
		if not sinVal then
			sinVal, cosVal = math.sin( angle ), math.cos( angle )
			sinCache[ i ], cosCache[ i ] = sinVal, cosVal
		end

		local px, py = x + sinVal * radius, y + cosVal * radius
		local u, v = sinVal * 0.5 + 0.5, cosVal * 0.5 + 0.5
		table.insert( cir, {
			x = px,
			y = py,
			u = u,
			v = v
		} )
	end
	return cir
end

function ENT:PlayerDistance()
	local ply = LocalPlayer():GetPos()
	local pos = self:GetPos()
	local distance = ply:Distance( pos )
	return distance
end

function ENT:drawLED( x, y, ent )
	local c_lod = GetConVar( "mplr_lumino_lod" ):GetInt()
	local lodTab = {
		[ 1 ] = 6,
		[ 2 ] = 8,
		[ 3 ] = 12
	}

	local effectiveLod = lodTab[ c_lod ]
	local amberColor = Color( 255, 140, 0 )
	--local distance = ent:PlayerDistance()
	--local lod = ent:ilerp( distance, 10, 20, 4, effectiveLod )
	surface.SetDrawColor( amberColor )
	render.SetMaterial( ent.LEDMaterial )
	local cir = ent:Circle( 15 + x, 15 + y, ledSize / 2, effectiveLod )
	surface.DrawPoly( cir )
end

function ENT:ilerp( value, in_min, in_max, out_min, out_max )
	-- Ensure we avoid division by zero if in_min == in_max
	if in_min == in_max then return out_max end
	-- Scale the input value inversely to a 0-1 range
	local t = ( value - in_min ) / ( in_max - in_min )
	-- Invert the normalized value and scale it to the output range
	return out_max - t * ( out_max - out_min )
end

function ENT:NewDisplay( msg, ent )
	-- Initialize the starting X position, using ledX or defaulting to 0
	local startX = ledX or 0
	-- Retrieve the old message, ensuring it's a table with at least one element, otherwise default to an empty table
	local oldmsg = type( oldmsg ) == "table" and oldmsg[ 1 ] and oldmsg or {}
	-- Precompute the maximum rows and columns of the grid for reuse
	local maxRows = #ent.Grid
	local maxCols = #ent.Grid[ 1 ] -- assuming the grid is a rectangle
	-- Precompute the width of an empty character for spacing calculations
	local emptyCharWidth = #UF.charMatrixSmallThin[ "EMPTY" ][ 1 ]
	-- If the new message is different from the old one, clear the grid
	if msg ~= oldmsg then
		-- Optimized grid clearing using nested loop unrolling
		for row = 1, maxRows do
			local gridRow = ent.Grid[ row ]
			for col = 1, maxCols, 4 do
				gridRow[ col ] = 0
				if col + 1 <= maxCols then gridRow[ col + 1 ] = 0 end
				if col + 2 <= maxCols then gridRow[ col + 2 ] = 0 end
				if col + 3 <= maxCols then gridRow[ col + 3 ] = 0 end
			end
		end

		xOffset = 0
	end

	-- Initialize the y-coordinate
	local y_coordinate = 0
	-- Define the function to print LEDs for a given string, font, and X position
	local function printLED( str1, font, PosX )
		local charMatrix, charWidth, charRow, gridRow, gridRowIndex, gridColIndex
		local cumulativeWidth = 0 -- Track the total width used by previous characters
		local charSpacing = 1 -- Define a fixed spacing between characters
		-- Determine if we should apply spacing
		local applySpacing = font ~= "Symbols"
		-- Loop through each character in the string
		for i = 1, #str1 do
			local char = str1:sub( i, i )
			-- Determine the character matrix based on the font
			if font == "SmallThin" then
				charMatrix = UF.charMatrixSmallThin[ char ]
			elseif font == "SmallBold" then
				charMatrix = UF.charMatrixSmallBold[ char ]
			elseif font == "Symbols" then
				charMatrix = UF.charMatrixSymbols[ char ]
			elseif font == "Headline" then
				charMatrix = UF.charMatrixHeadline[ char ]
			else
				charMatrix = nil
				Error( "Character not found!!!" )
			end

			-- Handle space characters separately
			if char == " " then
				-- Use the width of the space character defined in the font's character matrix
				if font == "SmallThin" then
					charWidth = #UF.charMatrixSmallThin[ " " ][ 1 ]
				elseif font == "SmallBold" then
					charWidth = #UF.charMatrixSmallBold[ " " ][ 1 ]
				elseif font == "Headline" then
					charWidth = #UF.charMatrixHeadline[ "SPACE" ][ 1 ]
				elseif font == "Symbols" then
					charWidth = #UF.charMatrixSymbols[ " " ][ 1 ]
				end

				-- Simply increase the cumulativeWidth by the width of the space character
				cumulativeWidth = cumulativeWidth + charWidth + ( applySpacing and charSpacing or 0 )
			else
				-- If a valid character matrix is found, process it
				if charMatrix then
					charWidth = #charMatrix[ 1 ]
					-- Loop through each row of the character matrix
					for row = 1, #charMatrix do
						charRow = charMatrix[ row ]
						gridRowIndex = row + y_coordinate
						-- Ensure the grid row index is within bounds
						if gridRowIndex > 0 and gridRowIndex <= maxRows then
							gridRow = ent.Grid[ gridRowIndex ]
							-- Loop through each column of the character matrix
							for col = 1, charWidth do
								-- Calculate the absolute grid column index
								gridColIndex = PosX + cumulativeWidth + col
								-- Ensure the grid column index is within bounds
								if gridColIndex > 0 and gridColIndex <= maxCols then
									-- Set the grid value based on the character matrix value
									gridRow[ gridColIndex ] = tonumber( charRow:sub( col, col ) ) == 1 and 1 or 0
								end
							end
						end
					end

					-- Update cumulativeWidth for the next character
					cumulativeWidth = cumulativeWidth + charWidth + ( applySpacing and charSpacing or 0 )
				end
			end
		end
	end

	-- Loop through each message entry
	for k, v in ipairs( msg ) do
		-- Extract the y-coordinate from the message entry
		y_coordinate = v[ 1 ]
		-- Loop through each value in the message entry
		for _, val in ipairs( v ) do
			if type( val ) == "table" then
				-- Extract the string, font, and X position
				local str1 = val[ 1 ]
				local font = val[ 2 ]
				local PosX = val[ 3 ]
				-- Print the LEDs for the extracted string, font, and X position
				printLED( str1, font, PosX )
			end
		end
	end

	-- Loop through each row of the grid to draw the LEDs
	for k, gridRow in ipairs( ent.Grid ) do
		local ledY = ( k + 1 ) * ledSize
		for i = 1, matrixWidth do
			-- If the grid cell is 1, draw the LED
			if gridRow[ i ] == 1 then
				local ledX = startX + ( i + 1 ) * ledSize
				ent:drawLED( ledX, ledY, ent )
			end
		end
	end

	-- Update oldmsg to the current message
	oldmsg = msg
end

function ENT:Mode0Disp( ent )
	if ent.Mode ~= 0 then return end
	local Text = ent:GetNW2String( "ModeMessage", "Keine Zugfahrten!" )
	if Text == "false" then Text = "Keine Zugfahrten!" end
	ent.TextPosX = math.ceil( #ent.Grid / 2 ) + #Text
	local msg = {
		[ 1 ] = { 15, { Text, "SmallThin", ent.TextPosX } }
	}

	ent:NewDisplay( msg, ent )
	return
end

function ENT:Mode1Disp( ent )
	-- Mode 1 simply lists four different trains, so we can definitively define where to put all the different elements
	-- Format: Element = {"string",x}
	ent.LinePosX = 0
	ent.DestPosX = 20
	ent.TimePosX = 186
	ent.Row1 = 0 -- y coordinate for this row
	ent.Row2 = 9 -- y-coordinate for row 2
	ent.Row3 = 18
	ent.Row4 = 27
	-- FORMAT: {y-coordinate,{string_to_display,font,x-coordinate_of_string},etc}
	local msg = {
		[ 1 ] = { ent.Row1, { ent.Line1String, "SmallBold", ent.LinePosX }, { ent.Train1DestinationString, "SmallThin", ent.DestPosX }, { ent.Train1Time, "SmallBold", ent.TimePosX } }
	}

	local msg2 = { ent.Row2, { ent.Line2String, "SmallBold", ent.LinePosX }, { ent.Train2DestinationString, "SmallThin", ent.DestPosX }, { ent.Train2Time, "SmallBold", ent.TimePosX } }
	local msg3 = { ent.Row3, { ent.Line3String, "SmallBold", ent.LinePosX }, { ent.Train3DestinationString, "SmallThin", ent.DestPosX }, { ent.Train3Time, "SmallBold", ent.TimePosX } }
	local msg4 = { ent.Row4, { ent.Line4String, "SmallBold", ent.LinePosX }, { ent.Train4DestinationString, "SmallThin", ent.DestPosX }, { ent.Train4Time, "SmallBold", ent.TimePosX } }
	if ent.Train2Entry then
		table.insert( msg, 2, msg2 )
	else
		table.remove( msg, 2 )
	end

	if ent.Train3Entry then
		table.insert( msg, 3, msg3 )
	else
		table.remove( msg, 3 )
	end

	if ent.Train4Entry then
		table.insert( msg, 4, msg4 )
	else
		table.remove( msg, 4 )
	end

	ent:NewDisplay( msg, ent )
end

function ENT:Mode2Disp( ent )
	local Text = ent:GetNW2String( "ModeMessage", "Keine Zugfahrten!" )
	ent.LinePosX = 0
	if not ent.Line1String then return end
	local str = ent.Train1DestinationString
	local CarCount = ent:GetNW2Int( "Train1ConsistLength", 4 )
	-- I could fix the coordinate formatting, but... Come on. For every state we've got bespoke placements of the different elements on screen. Work smart, not hard!
	local CarPos = 155
	local TrackPos = 155
	local st = "Seckbacher Ldstr."
	ent.DestPosX = 22 --ent.Theme == "Essen" and ( 76 - ( DestWidth / 2 ) ) or #UF.charMatrixSmallThin[ string.sub( ent.Line1String, 1, 1 ) ][ 1 ] + #UF.charMatrixSmallThin[ string.sub( ent.LineString1, 2, 2 ) ][ 1 ] + 8
	-- todo implement modular "via" information, listing notable stations along the way: U7 Hausen über Eissporthalle/Festplatz
	local msg = {}
	if Text ~= "DontBoard" then
		msg[ 1 ] = { 0, { ent.Line1String, "Headline", ent.LinePosX }, { str, "Headline", ent.DestPosX } }
		msg[ 2 ] = { 26, { string.rep( "T", CarCount ), "Symbols", CarPos } }
		msg[ 3 ] = { 33, { "R", "Symbols", TrackPos } }
	elseif Text == "DontBoard" then
		local message = "Nicht Einsteigen!"
		local textPos = math.floor( #ent.Grid / 2 ) + #message
		msg = {
			[ 1 ] = { 15, { message, "SmallThin", textPos } }
		}
	elseif Text == "DestUnknown" then
		local message = "Auf Zugschild achten!"
		local textPos = math.floor( #ent.Grid / 2 ) + #message
		msg = {
			[ 1 ] = { 15, { message, "SmallThin", textPos } }
		}
	end

	ent:NewDisplay( msg, ent )
end

-- Function to draw a character on the LED display
function ENT:drawCharacter( char, startX, startY, font )
	-- Define the LED matrix for each character
	if font == "SmallThin" then
		if not UF.charMatrixSmallThin[ char ] then
			assert( UF.charMatrixSmallThin[ char ], "DFI DID NOT FIND CHARACTER IN CHARACTER SET!!! Character:" .. char )
			cam.End3D2D()
			return
		end

		local rows = #UF.charMatrixSmallThin[ char ]
		local cols = #UF.charMatrixSmallThin[ char ][ 1 ]
		for row = 1, rows do
			for col = 1, cols do
				local ledX = startX + ( col - 1 ) * ledSize
				local ledY = startY + ( row - 1 ) * ledSize
				-- Draw an LED if the matrix element is 1
				if tonumber( UF.charMatrixSmallThin[ char ][ row ]:sub( col, col ) ) == 1 then ent:drawLED( ledX, ledY, ent ) end
			end
		end
	elseif font == "SmallBold" then
		if not UF.charMatrixSmallBold[ char ] then
			assert( UF.charMatrixSmallBold[ char ], "DFI DID NOT FIND CHARACTER IN CHARACTER SET!!! Character:" .. char )
			cam.End3D2D()
			return
		end

		local rows = #UF.charMatrixSmallBold[ char ]
		local cols = #UF.charMatrixSmallBold[ char ][ 1 ]
		for row = 1, rows do
			for col = 1, cols do
				local ledX = startX + ( col - 1 ) * ledSize
				local ledY = startY + ( row - 1 ) * ledSize
				-- Draw an LED if the matrix element is 1
				if tonumber( UF.charMatrixSmallBold[ char ][ row ]:sub( col, col ) ) == 1 then ent:drawLED( ledX, ledY, ent ) end
			end
		end
	else
		local rows = #UF.charMatrixSmallThin[ char ]
		local cols = #UF.charMatrixSmallThin[ char ][ 1 ]
		for row = 1, rows do
			for col = 1, cols do
				local ledX = startX + ( col - 1 ) * ledSize
				local ledY = startY + ( row - 1 ) * ledSize
				-- Draw an LED if the matrix element is 1
				if tonumber( UF.charMatrixSmallThin[ char ][ row ]:sub( col, col ) ) == 1 then ent:drawLED( ledX, ledY, ent ) end
			end
		end
	end
end

function ENT:CharacterTest( startX, startY )
	local char = "T"
	startX = startX or 0
	startY = startY or 0
	local rows = #UF.charMatrixSymbols[ char ]
	local cols = #UF.charMatrixSymbols[ char ][ 1 ]
	for row = 1, rows do
		for col = 1, cols do
			local ledX = startX + ( col - 1 ) * ledSize
			local ledY = startY + ( row - 1 ) * ledSize
			-- Draw an LED if the matrix element is 1
			if tonumber( UF.charMatrixSymbols[ char ][ row ]:sub( col, col ) ) == 1 then ent:drawLED( ledX, ledY, ent ) end
		end
	end
end

-- Function to draw a string on the LED display with color and alignment
function ENT:drawString( str, startX, startY, orientation, font )
	local xOffset = 0
	if not orientation then
		xOffset = 0
	elseif orientation == "center" then
		xOffset = 0
	elseif orientation == "centre" then
		xOffset = 0
	elseif orientation == "right" then
		xOffset = 10
	elseif orientation == "left" then
		xOffset = -480
	else
		xOffset = 0
	end

	if font == "SmallThin" then
		for i = 1, #str do
			local char = str:sub( i, i )
			ent:drawCharacter( char, startX + xOffset, startY, font )
			xOffset = xOffset + ledSize * ( #UF.charMatrixSmallThin[ char ][ 1 ] + #UF.charMatrixSmallThin[ "EMPTY" ][ 1 ] ) -- Add some padding between characters
		end
	elseif font == "SmallBold" then
		for i = 1, #str do
			local char = str:sub( i, i )
			ent:drawCharacter( char, startX + xOffset, startY, font )
			xOffset = xOffset + ledSize * ( #UF.charMatrixSmallBold[ char ][ 1 ] + #UF.charMatrixSmallBold[ "EMPTY" ][ 1 ] ) -- Add some padding between characters
		end
	end
end

function ENT:findLongestTable( listOfTables )
	local longestTable = nil
	local maxLength = 0
	for _, tbl in ipairs( listOfTables ) do
		local currentLength = #tbl
		if currentLength > maxLength then
			maxLength = currentLength
			longestTable = tbl
		end
	end
	return longestTable
end