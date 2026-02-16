ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "LillyWho"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.PrintName = "Lumino Platform Display (Frankfurt)"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.AdminSpawnable = true
ENT.Panel1 = { Vector( 100, 0, 0 ), Vector( 200, -50, 0 ) }
ENT.Panel1Angle = { Angle( 0, 15, 0 ) }
ENT.Panel2 = { Vector( 100, 0, 0 ), Vector( 200, -50, 0 ) }
ENT.Panel2Angle = { Angle( 0, 15, 0 ) }
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
-- Function: Set parameters for sound including DSP
function ENT:SetBassParameters( snd, pitch, volume, tbl, looping, spec, dspEffect )
	if snd:GetState() ~= GMOD_CHANNEL_STOPPED and snd:GetState() ~= GMOD_CHANNEL_PAUSED then return end
	self:SetBASSPos( snd, tbl )
	if tbl then
		snd:Set3DFadeDistance( tbl[ 1 ], tbl[ 2 ] )
		snd:SetVolume( tbl[ 4 ] and tbl[ 4 ] * volume or volume )
	else
		snd:Set3DFadeDistance( 200, 1e9 )
		snd:SetVolume( volume )
	end

	snd:EnableLooping( looping or false )
	snd:SetPlaybackRate( pitch )
	-- Apply DSP Effect (e.g., Echo)
	if dspEffect then snd:SetDSP( dspEffect ) end
	local siz1, siz2 = snd:Get3DFadeDistance()
	debugoverlay.Sphere( snd:GetPos(), 4, 2, Color( 0, 255, 0 ), true )
	debugoverlay.Sphere( snd:GetPos(), siz1, 2, Color( 255, 0, 0, 100 ), false )
end

-- Function: Play sound with DSP effect
function ENT:PlayOnceFromPos( sndname, volume, pitch, min, max, location, dspEffect )
	if self.StopSounds then return end
	self:DestroySound( sndname, true )
	if sndname == "_STOP" then return end
	self:CreateBASSSound( sndname, function( sndname )
		self:SetBassParameters( sndname, pitch, volume, location, false, nil, dspEffect )
		sndname:Play()
	end )
end

ENT.AnnouncementSounds = { "U1 Richtung Ginnheim", "U1 Richtung Heddernheim", "U1 Richtung Roemerstadt", "U1 Richtung Suedbahnhof", "U2 Richtung Gonzenheim", "U2 Richtung Heddernheim", "U2 Richtung Nieder-Eschbach", "U2 Richtung Suedbahnhof", "U3 Richtung Heddernheim", "U3 Richtung Hohemark", "U3 Richtung Oberursel Bahnhof", "U3 Richtung Oberursel Bommersheim", "U3 Richtung Suedbahnhof", "U4 Richtung Bockenheimer Warte", "U4 Richtung Enkheim", "U4 Richtung Hauptbahnhof", "U4 Richtung Konstablerwache", "U4 Richtung Schaefflestrasse", "U4 Richtung Seckbacher Ldstr", "U5 Richtung Eckenh Ldstr Marbachweg", "U5 Richtung Hauptbahnhof", "U5 Richtung Hauptfriedhof", "U5 Richtung Konstablerwache", "U5 Richtung Preungesheim", "U6 Richtung Bockenheimer Warte", "U6 Richtung Heerstrasse", "U6 Johanna-Tesch-Platz", "U6 Richtung Ostbahnhof", "U6 Richtung Zoo", "U7 Richtung Enkheim", "U7 Richtung Hausen", "U7 Richtung Johanna-Tesch-Platz", "U7 Richtung Schaefflestrasse", "U7 Richtung Zoo", "U8 Richtung Heddernheim", "U8 Richtung Riedberg", "U8 Richtung Suedbahnhof", "U8 Richtung Ginnheim", "U8 Richtung Nieder-Eschbach", "U9 Richtung Nieder-Eschbach", "U9 Richtung Roemerstadt" }