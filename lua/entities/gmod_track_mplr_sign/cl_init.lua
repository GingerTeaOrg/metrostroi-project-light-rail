include( "shared.lua" )
function ENT:Initialize()
	self.Horizontal = self:GetNW2Int( "Horizontal", 0 )
	self.Vertical = self:GetNW2Int( "Vertical", 0 )
	self.Rotation = self:GetNW2Int( "Rotation", 0 )
	self.Left = self:GetNW2Bool( "Left", false )
	self.Sign = ents.CreateClientProp( self:GetNW2String( "Type", self.BasePath .. "/" .. "speed_40" .. ".mdl" ) )
	local offset = self:LocalToWorld( ( self.Left and Vector( 0, -60, 0 ) or Vector( 0, 60, 0 ) ) + Vector( 0, self.Horizontal, self.Vertical ) )
	self.Sign:SetPos( offset )
	self.Sign:SetAngles( self:GetAngles() - Angle( 0, 90, 0 ) )
	self.Sign:Spawn()
end

function ENT:OnRemove()
	if IsValid( self.Sign ) then self.Sign:Remove() end
end