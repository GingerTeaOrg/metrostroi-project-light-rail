AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/johnsheppard44/mmp/electronics/communication/aa3_electronics_hand radio.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self.TrainEnt = self:GetNW2Entity( "TrainEnt" )
	self.SignalReceived = "nil"
end

function ENT:Think()
	self:NextThink( CurTime() )
	local messageReceived = self:ScanDown()
	self.SignalReceived = messageReceived
	return true
end

function ENT:Reset()
	self.SignalReceived = "nil"
end

function ENT:ScanDown( mode )
	local hitEnt
	tr1 = {
		start = self:LocalToWorld( Vector( -20, 15, 0 ) ),
		endpos = self:LocalToWorld( Vector( -20, 15, -25 ) ),
		filter = { self, }
	}

	tr2 = {
		start = self:LocalToWorld( Vector( -20, 18, 0 ) ),
		endpos = self:LocalToWorld( Vector( -20, 18, -25 ) ),
		filter = { self, }
	}

	local hit1 = util.TraceLine( tr1 )
	local hit2 = util.TraceLine( tr2 )
	if IsValid( hit1.Entity ) and hit1.Entity:GetClass() == "gmod_track_mplr_ballise" then hitEnt = hit1.Entity end
	if IsValid( hit2.Entity ) and hit2.Entity:GetClass() == "gmod_track_mplr_ballise" then hitEnt = hit2.Entity end
	return hitEnt and hitEnt.TransferImpulse or nil
end