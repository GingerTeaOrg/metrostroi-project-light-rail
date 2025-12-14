include( "shared.lua" )
function ENT:Draw()
	--self:DrawModel()
	debugoverlay.Line( self:LocalToWorld( Vector( -20, 15, 0 ) ), self:LocalToWorld( Vector( -20, 15, -25 ) ), 1, Color( 255, 0, 0 ), true )
	return true
end