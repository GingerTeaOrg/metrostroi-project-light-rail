include( "shared.lua" )
function ENT:Initialize()
	self.YOffset = self:GetNW2Float( "Horizontal", 0 ) + 85
	self.ZOffset = self:GetNW2Float( "Vertical", 0 )
	self.Rotation = self:GetNW2Float( "Rotation", 0 )
	self.Pole = ClientsideModel( self.PoleModel, RENDERGROUP_OPAQUE )
	self.Pole:SetPos( self:LocalToWorld( Vector( 0, self.YOffset, self.ZOffset ) ) )
	self.Pole:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.Pole:Spawn()
	self.Pole:SetParent( self )
	self.LensCase = ClientsideModel( self.LensCasePath, RENDERGROUP_OPAQUE )
	self.LensCase:SetPos( self:LocalToWorld( Vector( 0, self.YOffset, self.ZOffset ) ) )
	self.LensCase:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.LensCase:Spawn()
	self.LensCase:SetParent( self )
	self.Straight = ClientsideModel( self.StraightLens, RENDERGROUP_OPAQUE )
	self.Left = ClientsideModel( self.LeftLens, RENDERGROUP_OPAQUE )
	self.Right = ClientsideModel( self.RightLens, RENDERGROUP_OPAQUE )
	self.Straight:SetPos( self:LocalToWorld( Vector( 12.5744, self.YOffset, 169.968 + self.ZOffset ) ) )
	self.Straight:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.Left:SetPos( self:LocalToWorld( Vector( 12.5744, self.YOffset, 169.968 + self.ZOffset ) ) )
	self.Left:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.Right:SetPos( self:LocalToWorld( Vector( 12.5744, self.YOffset, 169.968 + self.ZOffset ) ) )
	self.Right:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.Left:Spawn()
	self.Left:SetParent( self )
	self.Right:Spawn()
	self.Right:SetParent( self )
	self.Straight:Spawn()
	self.Straight:SetParent( self )
	self.TopBracket = ClientsideModel( self.TopBracketModel, RENDERGROUP_OPAQUE )
	self.TopBracket:SetPos( self:LocalToWorld( Vector( 0, self.YOffset, self.ZOffset ) ) )
	self.TopBracket:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.TopBracket:Spawn()
	self.TopBracket:SetParent( self )
	self.BottomBracket = ClientsideModel( self.BottomBracketModel, RENDERGROUP_OPAQUE )
	self.BottomBracket:SetPos( self:LocalToWorld( Vector( 0, self.YOffset, self.ZOffset ) ) )
	self.BottomBracket:SetAngles( self:LocalToWorldAngles( Angle( 0, 0, self.Rotation ) ) )
	self.BottomBracket:Spawn()
	self.BottomBracket:SetParent( self )
	self.Direction = self:GetNW2String( "Direction", "left" )
	self.PrevDirection = self.Direction
	self.SwitchMoment = 0
	self.SwitchLocked = self:GetNW2Bool( "Locked", false )
end

function ENT:ShowHide( show, ent )
	if show then
		ent:SetRenderMode( RENDERMODE_NORMAL )
		ent:SetColor( Color( 255, 255, 255 ) )
	else
		ent:SetRenderMode( RENDERMODE_TRANSALPHA )
		ent:SetColor( Color( 0, 0, 0, 0 ) )
	end
end

function ENT:Think()
	self:SetNextClientThink( CurTime() )
	self.Direction = self:GetNW2String( "Direction", "left" )
	if self.Direction ~= self.PrevDirection then
		self.SwitchMoment = RealTime()
		self.PrevDirection = self.Direction
	end

	if RealTime() - self.SwitchMoment < 2.5 then
		self:ShowHide( false, self.Left )
		self:ShowHide( false, self.Straight )
		self:ShowHide( false, self.Right )
		return true
	end

	if self.Direction == "left" then
		self:ShowHide( true, self.Left )
		self:ShowHide( false, self.Straight )
		self:ShowHide( false, self.Right )
	elseif self.Direction == "right" then
		self:ShowHide( false, self.Left )
		self:ShowHide( false, self.Straight )
		self:ShowHide( true, self.Right )
	elseif self.Direction == "straight" then
		self:ShowHide( false, self.Left )
		self:ShowHide( true, self.Straight )
		self:ShowHide( false, self.Right )
	end
	return true
end

function ENT:Draw()
	self:DrawShadow( false )
	return
end

function ENT:OnRemove()
	self.Pole:Remove()
	self.LensCase:Remove()
	self.Left:Remove()
	self.Right:Remove()
	self.Straight:Remove()
	self.TopBracket:Remove()
	self.BottomBracket:Remove()
end