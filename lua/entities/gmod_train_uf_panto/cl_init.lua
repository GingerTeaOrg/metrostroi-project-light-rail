include( "shared.lua" )
function ENT:Initialize()
	self.Anims = {}
	self.DeltaTime = 0
	self.PrevTime = 0
	self.PantoHeight = 0
	self.FirstRaise = true
	self.PantoHeight = self:GetNW2Float( "PantoHeight", 0 )
	self.PantoHeightTab = {}
	self.SoundPlayed = false
	self.Sounds = {}
end

function ENT:Think()
	if IsValid( self:GetNW2Entity( "TrainEntity" ) ) then self.Train = self:GetNW2Entity( "TrainEntity" ) end
	self.PantoHeight = self:GetNW2Float( "PantoHeight", 0 )
	self.DeltaTime = RealFrameTime() --CurTime() - self.PrevTime
	self.PantoHeight = math.Round( self.PantoHeight, 2 )
	self:Draw()
	--print(self.PantoHeight.z)
end

function ENT:Draw()
	local function lerp( x, in_min, in_max, out_min, out_max )
		return out_min + ( x - in_min ) * ( out_max - out_min ) / ( in_max - in_min )
	end

	self:DrawModel()
	self:Debug()
	local lerped = math.Remap( self.PantoHeight, 0, 135, 0, 1 ) --+ math.Remap( self.PantoHeight, 0, 135, -0.03, 0.079 )
	local speed = self.FirstRaise and 1.1 or 2
	self:SetPoseParameter( "position", self:Animate( "1", lerped, 0, 100, speed, 2, true ) )
	self:InvalidateBoneCache()
end

--------------------------------------------------------------------------------
-- Animation function
--------------------------------------------------------------------------------
function ENT:Animate( clientProp, value, min, max, speed, damping, stickyness )
	local id = clientProp
	if not self.Anims[ id ] then
		self.Anims[ id ] = {}
		self.Anims[ id ].val = value
		self.Anims[ id ].V = 0.0
	end

	if not damping or damping == 0 then
		local dX = speed * self.DeltaTime
		if value > self.Anims[ id ].val then self.Anims[ id ].val = self.Anims[ id ].val + dX end
		if value < self.Anims[ id ].val then self.Anims[ id ].val = self.Anims[ id ].val - dX end
		if math.abs( value - self.Anims[ id ].val ) < dX then self.Anims[ id ].val = value end
	else
		-- Prepare speed limiting
		local delta = math.abs( value - self.Anims[ id ].val )
		local max_speed = 1.5 * delta / self.DeltaTime
		local max_accel = 0.5 / self.DeltaTime
		-- Simulate
		local dX2dT = ( speed or 128 ) * ( value - self.Anims[ id ].val ) - self.Anims[ id ].V * ( damping or 8.0 )
		if dX2dT > max_accel then dX2dT = max_accel end
		if dX2dT < -max_accel then dX2dT = -max_accel end
		self.Anims[ id ].V = self.Anims[ id ].V + dX2dT * self.DeltaTime
		if self.Anims[ id ].V > max_speed then self.Anims[ id ].V = max_speed end
		if self.Anims[ id ].V < -max_speed then self.Anims[ id ].V = -max_speed end
		self.Anims[ id ].val = math.max( 0, math.min( 1, self.Anims[ id ].val + self.Anims[ id ].V * self.DeltaTime ) )
		-- Check if value got stuck
		if ( math.abs( dX2dT ) < 0.001 ) and stickyness and ( self.DeltaTime > 0 ) then self.Anims[ id ].stuck = true end
	end
	return min + ( max - min ) * self.Anims[ id ].val
end

function ENT:Debug()
	local cvar = GetConVar( "metrostroi_drawdebug" ):GetBool()
	if not cvar then return end
	local mins = self:GetNWVector( "mins", Vector( -24, -24, 0 ) )
	local maxs = self:GetNWVector( "maxs", Vector( 24, 24, 1.5 ) )
	--print(self:GetPos())
	render.DrawWireframeBox( self:LocalToWorld( Vector( -10, 0, 0 ) ), self:GetAngles(), mins, Vector( maxs.x, maxs.y, self.PantoHeight ), Color( 255, 255, 255 ), true )
end