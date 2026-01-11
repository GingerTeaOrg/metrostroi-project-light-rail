-- Copyright © Platunov I. M., 2021 All rights reserved
-- Modified for M:PLR based on Trolleybus GitHub Release under CC BY-NC-SA 4.0
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:SetupDataTablesSV()
	self:NetworkVarNotify( "Type", function( self, name, old, new )
		if old == new then return end
		self:SetupType( new )
	end )
end

function ENT:Initialize()
	self.Controller = self.Controller or self:GetNW2Entity( "Controller" )
	self.OtherParts = {}
	self.Red = true
	self.Yellow = false
	self.Green = false
	if self:GetType() == "" then
		self:SetType( "default" )
	else
		self:SetupType()
	end

	self:SwitchState( 0 )
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	Trolleybus_System.UpdateTransmit( self, "TrafficLightDrawDistance" )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetupType( type )
	local data = self:LightType( type )
	self:SetModel( data.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:GetPhysicsObject():EnableMotion( false )
	for k, v in ipairs( self.OtherParts ) do
		if Trolleybus_System.NetworkSystem.GetNWVar( self, "TrafficLightBase" ) == v:EntIndex() then
			self:SetPos( v:GetPos() )
			self:SetAngles( v:GetAngles() )
		end

		self:DontDeleteOnRemove( v )
		v:DontDeleteOnRemove( self )
		v:Remove()
	end

	Trolleybus_System.NetworkSystem.SetNWVar( self, "TrafficLightBase", nil )
	self.OtherParts = {}
	if data.OtherParts then
		local pos, ang = self:GetPos(), self:GetAngles()
		local base = data.OtherParts.Base
		if base then
			local dt = data.OtherParts[ base ]
			local pos, ang = LocalToWorld( dt[ 2 ] or vector_origin, dt[ 3 ] or angle_zero, pos, ang )
			self:SetPos( pos )
			self:SetAngles( ang )
		end

		for k, v in ipairs( data.OtherParts ) do
			local mdl = ents.Create( "prop_dynamic" )
			mdl:SetModel( v[ 1 ] )
			mdl:SetPos( base == k and pos or self:LocalToWorld( v[ 2 ] or vector_origin ) )
			mdl:SetAngles( base == k and ang or self:LocalToWorldAngles( v[ 3 ] or angle_zero ) )
			if v[ 4 ] then
				for k, v in ipairs( v[ 4 ] ) do
					mdl:SetBodygroup( k - 1, v )
				end
			end

			mdl:Spawn()
			if mdl:PhysicsInit( SOLID_VPHYSICS ) then
				mdl:GetPhysicsObject():EnableMotion( false )
			else
				mdl:SetMoveType( MOVETYPE_NONE )
			end

			mdl:DeleteOnRemove( self )
			self:DeleteOnRemove( mdl )
			Trolleybus_System.NetworkSystem.SetNWVar( mdl, "TrafficLight", self:EntIndex() )
			if base == k then Trolleybus_System.NetworkSystem.SetNWVar( self, "TrafficLightBase", mdl:EntIndex() ) end
			table.insert( self.OtherParts, mdl )
		end
	end

	for k, v in ipairs( data.Lenses ) do
		self:SetLense( k, v[ 4 ] or "nolense" )
	end
end

function ENT:SetLense( num, lense )
	local id = Trolleybus_System.TrafficLightLenses[ lense ].ID
	self[ "SetLense" .. num ]( self, id )
end

function ENT:LoadBehaviour( data )
	self.Data = data
	self:SetType( data.Type or 0 )
	self:SetID( data.ID )
	self:SetStatesDuration( 0 )
	self.StatesTime = {}
	for k, v in ipairs( data.States ) do
		self.StatesTime[ k ] = self:GetStatesDuration()
		self:SetStatesDuration( self:GetStatesDuration() + v.Time )
	end

	Trolleybus_System.TrafficLightIDs[ data.ID ] = self
	self:UpdateState( true )
end

function ENT:IsStopSignal()
	return not self:GetDisabled() and self.Data and self.Data.States[ self:GetState() ] and self.Data.States[ self:GetState() ].IsStopSignal
end

function ENT:Think()
	self:NextTink( CurTime() + 1 )
	Trolleybus_System.UpdateTransmit( self, "TrafficLightDrawDistance" )
	for k, v in ipairs( self.OtherParts ) do
		Trolleybus_System.UpdateTransmit( v, "TrafficLightDrawDistance" )
	end
	return true
end