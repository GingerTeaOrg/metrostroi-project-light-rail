ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName		= "Daisy Display"
ENT.Author			= "Ron"
ENT.Category 		= "Metrostroi German Entities"
ENT.Editable 		= false
ENT.Spawnable 		= false
ENT.AdminOnly 		= false

if CLIENT then
	surface.CreateFont( "DaisyAnzeige", {
		font 		= "BigDots",
		size 		= 24,
		weight 		= 600,
		blursize 	= 0,
		scanlines 	= 2,
		antialias 	= true,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= false,
		outline 	= false
	})

	surface.CreateFont( "GleisAnzeige", { 
		font 		= "UBahn",
		size 		= 30,
		weight 		= 600,
		blursize 	= 0,
		scanlines 	= 2,
		antialias 	= true,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= false,
		outline 	= false
	})

	surface.CreateFont( "DaisyAnzeige2", {
		font 		= "Advanced LED Board-7",
		size 		= 24,
		weight 		= 600,
		blursize 	= 0,
		scanlines 	= 2,
		antialias 	= false,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= true,
		outline 	= false
	})
end