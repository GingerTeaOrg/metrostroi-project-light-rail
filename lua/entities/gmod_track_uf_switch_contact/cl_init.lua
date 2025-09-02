include( "shared.lua" )
function ENT:Initialize()
	self.Invisible = self:GetNW2Bool( "Invisible", false )
	if not self.Invisible then self.Sign = ents.CreateClientProp( "models/lilly/uf/signage/point_contact.mdl" ) end
	self.YOffset = self:GetNW2Float( "Horizontal", 0 )
	self.ZOffset = self:GetNW2Float( "Vertical", 0 )
	self.Rotation = self:GetNW2Float( "Rotation", 0 )
	if IsValid( self.Sign ) then
		self.Sign:SetPos( self:GetPos() + Vector( 0, 0, 100 ) )
		self.Sign:SetAngles( self:GetAngles() )
	end
end

function ENT:Draw()
	if IsValid( self.Sign ) and not self.Invisible then
		self.Sign:DrawModel()
	elseif not IsValid( self.Sign ) and not self.Invisible then
		self:CreateSign()
	end
end

function ENT:CreateSign()
	self.Sign = ents.CreateClientProp( "models/lilly/uf/signage/point_contact.mdl" )
	if IsValid( self.Sign ) then
		self.Sign:SetPos( self:GetPos() + Vector( 0, 0, 100 ) + Vector( 0, 0, self.ZOffset ) + Vector( 0, self.YOffset, 0 ) )
		self.Sign:SetAngles( self:GetAngles() + Angle( 0, 0, self.Rotation ) )
	end
end

function ENT:Think()
end

function ENT:OnRemove()
	if IsValid( self.Sign ) then self.Sign:Remove() end
end