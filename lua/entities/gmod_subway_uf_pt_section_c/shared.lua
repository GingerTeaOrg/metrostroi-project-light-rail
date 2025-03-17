ENT.Type = "anim"
ENT.Base = "gmod_subway_uf_base"
ENT.PrintName = "Duewag Pt"
ENT.PrintNameTranslated = "Duewag Pt"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.DontAccelerateSimulation = true
function ENT:InitializeSystems()
	self:LoadSystem( "CoreSys", "Duewag_Pt" )
	self:LoadSystem( "DeadmanUF", "Duewag_Deadman" )
	self:LoadSystem( "IBIS" )
	self:LoadSystem( "Announcer", "uf_announcer" )
	self:LoadSystem( "Duewag_Battery" )
	self:LoadSystem( "Panel", "U2_panel" )
	self:LoadSystem( "MPLR_DoorHandler" )
end

ENT.NumberRanges = { { 700, 780 } }
ENT.SubwayTrain = {
	Type = "P8",
	Name = "Pt",
	WagType = 1,
	Manufacturer = "Duewag",
	Vmax = 80
}

ENT.DoorNumberRight = 4
ENT.DoorNumberLeft = 4
ENT.DoorsRight = {
	[ 1 ] = Vector( 330.889, -46.4148, 35.3841 ),
	[ 2 ] = Vector( 88.604, -46.4148, 35.3841 ),
	[ 3 ] = Vector( -330.889, -46.4148, 35.3841 ),
	[ 4 ] = Vector( -88.604, -46.4148, 35.3841 ),
}

ENT.DoorsLeft = {
	[ 1 ] = Vector( -330.889, 46.4148, 35.3841 ),
	[ 2 ] = Vector( -88.604, 46.4148, 35.3841 ),
	[ 3 ] = Vector( 330.889, 46.4148, 35.3841 ),
	[ 4 ] = Vector( 88.604, 46.4148, 35.3841 )
}

ENT.SectionADoors = {
	[ 1 ] = Vector( 330.889, -46.4148, 35.3841 ),
	[ 2 ] = Vector( 88.604, -46.4148, 35.3841 ),
	[ 7 ] = Vector( 330.889, 46.4148, 35.3841 ),
	[ 8 ] = Vector( 88.604, 46.4148, 35.3841 )
}

ENT.SectionBDoors = {
	[ 3 ] = Vector( -330.889, -46.4148, 35.3841 ),
	[ 4 ] = Vector( -88.604, -46.4148, 35.3841 ),
	[ 5 ] = Vector( -330.889, 46.4148, 35.3841 ),
	[ 6 ] = Vector( -88.604, 46.4148, 35.3841 )
}

ENT.RequireDepartureAcknowledge = true
ENT.Bidirectional = true
ENT.Spawner = {
	model = { "models/lilly/uf/pt/section-c.mdl", "models/lilly/uf/pt/section-ab.mdl" },
	interim = "gmod_subway_uf_pt_section_ab"
}