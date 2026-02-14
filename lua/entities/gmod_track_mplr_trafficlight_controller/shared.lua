ENT.PrintName = "Traffic Light Controller"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Time" )
	self:NetworkVar( "Float", 1, "StatesDuration" )
	self:NetworkVar( "Int", 0, "State" )
	self:NetworkVar( "Int", 1, "ID" )
	self:NetworkVar( "String", 0, "Type" )
	self:NetworkVar( "Bool", 0, "Disabled" )
	for i = 1, 10 do
		self:NetworkVar( "Int", 1 + i, "Lense" .. i )
	end

	if SERVER then self:SetupDataTablesSV() end
end