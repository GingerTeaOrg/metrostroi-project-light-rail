include( "shared.lua" )
function ENT:ParseLenses( str )
    if not str or #str < 2 then return end
    local result = {}
    -- Use pattern matching to split by space, dash, or underscore
    for token in string.gmatch( str, "[^%s%-%_]+" ) do
        result[ string.lower( token ) ] = true
    end

    if not next( result ) then print( "Signal:", self.SignalName, "has not found any lenses to spawn." ) end
    return result
end

function ENT:Initialize()
    self:SetRenderMode( RENDERMODE_NORMAL )
    self:DrawShadow( true )
    self.Lenses = self:ParseLenses( next( self.VMF ) and self.VMF.Lenses or "A1_F0_F4_F2" )
    self.LensModels = {}
    self.LensCases = {}
    self:SpawnLenses()
end

function ENT:Think()
end

function ENT:SpawnLenses()
    local lensBasepath = "models/lilly/mplr/signals/trafficlight/sprites/sprite_"
    local lensCase = "models/lilly/mplr/signals/trafficlight/trafficlight_lenscase.mdl"
    local offset = 0
    local spriteOffset = -170
    for i = 1, #self.LensOrder do
        local lens = string.lower( self.LensOrder[ i ] )
        if self.Lenses[ lens ] then
            self.LensModels[ lens ] = ents.CreateClientProp( lensBasepath .. lens .. ".mdl" )
            self.LensModels[ lens ]:SetPos( self:LocalToWorld( Vector( 12.6, 0, 0 ) ) - Vector( 0, 0, spriteOffset ) )
            spriteOffset = spriteOffset + 15
            self.LensModels[ lens ]:SetAngles( self:GetAngles() )
            self.LensModels[ lens ]:Spawn()
            self.LensModels[ lens ]:SetParent( self )
            self.LensCases[ lens ] = ents.CreateClientProp( lensCase )
            self.LensCases[ lens ]:SetPos( self:GetPos() - Vector( 0, 0, offset ) )
            self.LensCases[ lens ]:SetAngles( self:GetAngles() )
            self.LensCases[ lens ]:Spawn()
            self.LensCases[ lens ]:SetParent( self )
            offset = offset + 15
        end
    end
end

function ENT:OnRemove()
    for k, v in pairs( self.LensCases ) do
        v:Remove()
    end

    for k, v in pairs( self.LensModels ) do
        v:Remove()
    end
end

function ENT:Draw()
    self:DrawModel()
end