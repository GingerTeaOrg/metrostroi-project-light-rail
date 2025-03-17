AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 30000 -- Needed for gm trainspawner
function ENT:Initialize()
	-- Set model and initialize
	self:SetModel( "models/lilly/uf/pt/section-c.mdl" )
	self.BaseClass.Initialize( self )
	self:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )
	self.MiddleBogey1 = self:CreateBogeyUF( Vector( 140, 0, 5 ), Angle( 0, 0, 0 ), true, "pt", "c" ) --pos, ang, forward, typ, a_b
	self.MiddleBogey2 = self:CreateBogeyUF( Vector( -140, 0, 5 ), Angle( 0, 0, 0 ), true, "pt", "c" )
	self.SectionA = self:CreateSection( Vector( 145, 0, 2.8 ), Angle( 0, 0, 0 ), "gmod_subway_uf_pt_section_ab", self, self, nil ) --pos, ang, ent, parentSection, sectionC, sectionA
	self.FrontBogey = self:CreateBogeyUF( Vector( 260, 0, 0 ), Angle( 0, 0, 0 ), true, "pt", "a" ) --pos, ang, forward, typ, a_b
	self.SectionB = self:CreateSection( Vector( -145, 0, 2.8 ), Angle( 0, 180, 0 ), "gmod_subway_uf_pt_section_ab", self, self, self.SectionA )
	self.RearBogey = self:CreateBogeyUF( Vector( 260, 0, 0 ), Angle( 0, 5, 0 ), false, "pt", "b" )
	self.FrontCouple = self.SectionA:CreateCustomCoupler( Vector( 390, 0, 10 ), Angle( 0, 0, 0 ), true, "pt", "a" ) --pos, ang, forward, typ, a_b
	self.RearCouple = self.SectionB:CreateCustomCoupler( Vector( 390, 0, 10 ), Angle( 0, 0, 0 ), false, "pt", "b" )
	self.Panto = self:CreatePanto( Vector( 93, 0, 130 ), Angle( 0, 90, 0 ), "diamond" )
	self.PantoUp = false
end

function ENT:Think()
	self.BaseClass.Think( self )
	self.Speed = math.abs( -self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858 )
end