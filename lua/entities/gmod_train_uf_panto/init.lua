AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString( "uf_contact" )
game.AddParticles( "particles/electrical_fx.PCF" )
PrecacheParticleSystem( "electrical_arc_01" )
function ENT:SetParameters()
	local type = self.Types[ self.PantoType or "diamond" ]
	self:SetModel( type[ 1 ] or "models/lilly/uf/panto_diamond.mdl" )
end

function ENT:Initialize()
	self:SetParameters()
	self:PhysicsInit( SOLID_NONE )
	--self:SetMoveType( MOVETYPE_VPHYSICS )
	--self:SetSolid( SOLID_VPHYSICS )
	--[[if IsValid(self:GetPhysicsObject()) then
        self:GetPhysicsObject():SetNoCollide(true)
    end]]
	self.Raised = false
	self.PreviouslyRaised = false
	self.RaiseLowerAnim = 0
	self.Height = 0
	self.Voltage = 0
	self.CheckTimeout = 0
	self.NoPhysics = false
	--self:SetModelScale(0.85,1)
	self.SoundPlayed = false
end

function ENT:TriggerInput( iname, value )
	if iname == "Raise" then self.PantographRaised = value end
end

function ENT:Think()
	self.BaseClass.Think( self )
	self:SetNW2Int( "AnimOffset", self.Types[ "diamond" ][ 4 ] )
	-- Update timing
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	self:CheckVoltage( self.DeltaTime )
	if self.Train.PantoUp == true then
		self.Raised = true
	else
		self.Raised = false
	end
end

function ENT:CheckContact( pos )
	local position = self:LocalToWorld( Vector( -10, 0, 0 ) )
	local dir = self:GetUp()
	local result = util.TraceHull( {
		start = position,
		endpos = position + dir * 135,
		mask = MASK_SHOT_HULL,
		filter = {
			self --filter out the panto itself
		},
		mins = Vector( -26, -26, 0 ),
		maxs = Vector( 26, 26, 0 ),
	} )

	if not result.Hit then --if nothing touches the panto, it can spring to maximum freely
		return false, nil, 135
	end

	self:SetNW2Bool( "HitWire", result.Hit )
	local pantoheight = self:WorldToLocal( result.HitPos ) --- PhysObj:WorldToLocalVector( pos + Vector( 0, 0, math.abs( pos.z ) ) )
	--print(pantoheight.z)
	--print("traceorigin",PhysObj:WorldToLocalVector(pos),"hitpos",PhysObj:WorldToLocalVector(result.HitPos),"calculated height diff",pantoheight.z)
	local traceEnt = result.Entity
	if IsValid( traceEnt ) and traceEnt:GetClass() == "player" and MPLR.Voltage > 40 then --if the player hits the bounding box, unalive them
		local pPos = traceEnt:GetPos()
		util.BlastDamage( traceEnt, traceEnt, pPos, 100, 3.0 * MPLR.Voltage )
		local effectdata = EffectData()
		effectdata:SetOrigin( pPos + Vector( 0, 0, -16 + math.random() * ( 40 + 0 ) ) )
		util.Effect( "cball_explode", effectdata, true, true )
		sound.Play( "ambient/energy/zap" .. math.random( 1, 3 ) .. ".mp3", pPos, 75, math.random( 100, 150 ), 1.0 )
		local msg = {
			[ 1 ] = "%s tried to lick the pantograph! Dummy!",
			[ 2 ] = "%s tried to give the pantograph a hug!",
			[ 3 ] = "%s tried to become one with the pantograph! How zen!",
			[ 4 ] = "%s just found out what Mister Ohm liked to do in his free time!",
			[ 5 ] = "%s noticed a slight tingling sensation and an extreme sense of death!",
			[ 6 ] = "%s tried to subway surf!",
			[ 7 ] = "Who has ascended to the realm of Electron? Why, it's %s!",
			[ 8 ] = "%s just checked the voltage. It's %sV!",
			[ 9 ] = "%s will stick to energy drinks from now on instead.",
			[ 10 ] = "%s, deus Juppiter volt, uh I mean, vult tuum mortem. That's right, it's Latin. Look it up!",
			[ 11 ] = "%s used Thunderbolt. They hit themself in confusion. It was very effective!",
			[ 12 ] = "%s just found out that electrons taste.... purple. How strange.",
			[ 13 ] = "%s found Electro-Jesus high up on the roof of a train. Praise be!",
			[ 14 ] = "%s partook in the mighty power of Thor! RAGNAROK AWAITS!",
			[ 15 ] = "Does anybody else smell bacon? %s does!",
			[ 16 ] = "They reached for the sky and were struck down by the gods! %s!",
			[ 17 ] = "Dinner is served! Extra crispy, %s!",
			[ 18 ] = "Learn a Jedi must. About a force called Electricity, %s!",
			[ 19 ] = "%s just felt warm and fuzzy all over, before turning into ash."
		}

		local rnd = math.random( 1, #msg )
		local list = player.GetHumans()
		for _, v in ipairs( list ) do
			if traceEnt:Health() == 0 then v:PrintMessage( HUD_PRINTTALK, string.format( msg[ rnd ], traceEnt:GetPlayerInfo().name, MPLR.Voltage ) ) end
		end
		return false, nil, pantoheight.z --don't return anything because... I mean, a human body is a conductor, just not a very good one
	elseif result.Hit and traceEnt:GetClass() == "prop_static" and MPLR.Voltage > 40 then
		--randomly create some sparks if we're hitting catenary, with a 12% chance
		if self.Train.Speed >= 5 and math.random( 0, 100 ) >= 80 then
			local pPos = result.HitPos
			ParticleEffect( "electrical_arc_01", pPos, result.Normal:Angle(), self )
			sound.Play( "ambient/energy/zap" .. math.random( 1, 3 ) .. ".mp3", pPos, 75, math.random( 100, 150 ), 1.0 )
		end
		return result.Hit, traceEnt, pantoheight.z --yes, we are touching catenary
	end
end

function ENT:CheckVoltage( dT )
	local C_mplr_train_requirewire = GetConVar( "mplr_train_requirewire" )
	local supported = C_mplr_train_requirewire:GetInt() > 0
	-- Check contact states
	--if ( CurTime() - self.CheckTimeout ) <= 0.25 then return end
	local hit, hitEnt, pantoheight = self:CheckContact()
	if ( not IsValid( hitEnt ) or not hit ) and supported then self.Voltage = 0 end
	if self.Raised and not self.PreviouslyRaised and self.RaiseLowerAnim < pantoheight then
		self.RaiseLowerAnim = self.RaiseLowerAnim + ( 8 * self.DeltaTime )
		self.RaiseLowerAnim = math.min( pantoheight, self.RaiseLowerAnim )
		self.Train:SetNW2Bool( "PantoMovingUp", true )
	elseif not self.Raised and self.PreviouslyRaised and self.RaiseLowerAnim > 0 then
		self.RaiseLowerAnim = self.RaiseLowerAnim - ( 8 * self.DeltaTime )
		self.RaiseLowerAnim = math.max( 0, self.RaiseLowerAnim )
		self.Train:SetNW2Bool( "PantoMovingDown", true )
	elseif self.Raised and not self.PreviouslyRaised and self.RaiseLowerAnim >= pantoheight then
		self.PreviouslyRaised = true
		self.Train:SetNW2Bool( "PantoMovingUp", false )
	elseif not self.Raised and self.PreviouslyRaised and self.RaiseLowerAnim <= 0 then
		self.PreviouslyRaised = false
		self.Train:SetNW2Bool( "PantoMovingDown", false )
	end

	if self.Raised and not self.PreviouslyRaised and pantoheight > self.RaiseLowerAnim then
		self:SetNW2Int( "PantoHeight", self.RaiseLowerAnim )
	elseif not self.Raised and self.PreviouslyRaised or not self.Raised and not self.PreviouslyRaised then
		self:SetNW2Int( "PantoHeight", self.RaiseLowerAnim )
	else
		self:SetNW2Float( "PantoHeight", pantoheight )
	end

	local model = hitEnt and string.match( hitEnt:GetModel(), "overhead_wire", 1 )
	if not supported or hitEnt and hitEnt:GetClass() == "prop_static" and model then self.Voltage = MPLR.Voltage end
	self.CheckTimeout = CurTime()
end

function ENT:Debug()
	self:SetNWVector( "mins", self:WorldToLocalVector( Vector( -26, -26, 0 ) ) )
	self:SetNWVector( "maxs", self:WorldToLocalVector( Vector( 26, 26, 1.5 ) ) )
end

function ENT:AcceptInput( inputName, activator, called, data )
	if inputName == "OnFeederIn" then
		self.Feeder = tonumber( data )
		if self.Feeder and not MPLR.Voltages[ self.Feeder ] then
			MPLR.Voltages[ self.Feeder ] = 0
			MPLR.Currents[ self.Feeder ] = 0
		end
	elseif inputName == "OnFeederOut" then
		self.Feeder = nil
	end
end