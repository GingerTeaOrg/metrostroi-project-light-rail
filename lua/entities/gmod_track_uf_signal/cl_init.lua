include( "shared.lua" )
ENT.flux = include( "flux.lua" )
--------------------------------------------------------------------------------
-- We spawn the actual signal model separately so as to ensure that the position detection always selects the correct track to assign to.
-- The actual serverside entity can remain in the centre of the track while we move the signal and everything attached to it around.
function ENT:CreateSignalModel()
    self.SignalModel = ClientsideModel( self.SignalType, RENDERGROUP_OPAQUE )
    self.SignalModel:SetAngles( self:GetAngles() )
    local delta = self:LocalToWorld( self.Left and Vector( 0, -65, -8 ) or Vector( 0, 65, -8 ) )
    self.PositionModifier = delta
    self.SignalModel:SetPos( delta )
    self.SignalModel:Spawn()
end

function ENT:OnRemove()
    if IsValid( self.SignalModel ) then SafeRemoveEntity( self.SignalModel ) end
end

function ENT:Initialize()
    local function init2()
        print( "RUNNING CL INIT HOOK!!!!" )
        self.Left = self:GetNW2Bool( "Left", false )
        self.Pos = self:GetPos()
        self.PositionModifier = ( self.Left and Vector( 0, 20, 0 ) or Vector( 0, -20, 0 ) ) + self.Pos
        self:CreateSignalModel()
    end

    self.SignalType = self:GetNW2String( "Type", "Overground_Large" )
    util.PrecacheModel( self.SignalType )
    self.Name1 = self:GetNW2String( "Name1", "ER" )
    self.Name2 = self:GetNW2String( "Name2", "ER" )
    timer.Simple( 1, function() init2() end )
    self.RT = CreateMaterial( "bg", "VertexLitGeneric", {
        [ "$basetexture" ] = "color/white",
        [ "$model" ] = 1,
        [ "$translucent" ] = 1,
        [ "$vertexalpha" ] = 1,
        [ "$vertexcolor" ] = 1
    } )

    self.Aspect = "H0"
    self.PreviousAspect = ""
end

net.Receive( "mplr-signal", function()
    local ent = net.ReadEntity()
    if not IsValid( ent ) then return end
    ent.Routes = net.ReadTable()
end )

function ENT:Think()
    local CurTime = CurTime()
    --print( self.SignalModel:GetPos() )
    --self.SignalModel:SetAngles( self:GetAngles() + )
    self:SetNextClientThink( CurTime + 0.0333 )
    self.PrevTime = self.PrevTime or RealTime()
    self.DeltaTime = RealTime() - self.PrevTime
    self.PrevTime = RealTime()
    if not self.Name then
        if self.Sent and ( CurTime - self.Sent ) > 0 then self.Sent = nil end
        if not self.Sent then
            net.Start( "mplr-signal" )
            net.WriteEntity( self )
            net.SendToServer()
            self.Sent = CurTime + 1.5
        end
        return true
    end

    self.Aspect = self:GetNW2String( "Aspect", "H0" )
    self.SignalType = self:GetNW2String( "Type" )
end

hook.Add( "PostDrawOpaqueRenderables", "MyEntityDrawHook", function()
    -- Get all entities of your type
    for _, ent in pairs( ents.GetAll() ) do
        if ent:GetClass() == "gmod_track_uf_signal" and IsValid( ent.SignalModel ) and IsValid( ent ) then -- Replace with your entity class name
            ent:Draw()
        end
    end
end )

function ENT:Draw()
    -- Draw model
    if not self.SignalModel then return end
    local ang = self.SignalModel:LocalToWorldAngles( Angle( 0, 90, 90 ) )
    local pos, pos2, rectangle = self:PrintSignalName( self.SignalType )
    cam.Start3D2D( pos, ang, 0.05 )
    surface.SetMaterial( self.RT )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 5, -25, 220, 325 )
    self:PrintText( 0, 0, self.Name1 or "ER", "Text", Color( 78, 0, 0 ) )
    cam.End3D2D()
    cam.Start3D2D( pos2, ang, 0.06 )
    self:PrintText2( 0, 0, self.Name2 or "ER", "TextLarge", Color( 0, 0, 0 ) )
    cam.End3D2D()
    self:SignalAspect( self.Aspect or "Sh3d" )
    --[[if self.PreviousAspect ~= self.Aspect then
        
        self:FadeFromTo(self.PreviousAspect,self.Aspect)
        self.PreviousAspect = self.Aspect
    end]]
end

function ENT:PrintSignalName( type )
    local pos
    local pos2
    local rectangle
    if type == "models/lilly/uf/signals/Underground_Small_Pole.mdl" then
        pos = self.SignalModel:LocalToWorld( Vector( 7.5, 3.99, 125 ) )
        pos2 = self.SignalModel:LocalToWorld( Vector( 7.5, 3.5, 117 ) )
        rectangle = self.SignalModel:LocalToWorld( Vector( 7.5, 0, 50 ) )
    else
        pos = self.SignalModel:LocalToWorld( Vector( 4.5, -5, 38 ) )
        pos2 = self.SignalModel:LocalToWorld( Vector( 4.5, -5, 31 ) )
        rectangle = self.SignalModel:LocalToWorld( Vector( 4.6, 0, 31 ) )
    end
    return pos, pos2, rectangle
end

function ENT:FadeFromTo( PreviousAspect, NextAspect )
    if not PreviousAspect and NextAspect then return end
    if PreviousAspect == NextAspect then return end
    local fadeDuration = 4
    if not self.FadeRecorded then
        self.FadeRecorded = true
        self.FadeStart = CurTime()
        self.Fade = math.Clamp( ( CurTime() - self.FadeStart ) / fadeDuration, 0, 1 )
        local deltaTime = RealFrameTime()
        if PreviousAspect == "H0" and NextAspect == "H1" then
            --self.AlphaRed = Lerp(self.Fade, 255, 0)
            flux.to( self.AlphaRed, 2, {
                [ "self.AlphaRed" ] = 0
            } )

            --self.AlphaGreen = Lerp(self.Fade, 0, 255)
            flux.to( self.AlphaGreen, 2, {
                [ "self.AlphaGreen" ] = 255
            } )

            self.AlphaOrange = 0
        elseif PreviousAspect == "H0" and NextAspect == "H2" then
            --self.AlphaRed = Lerp(self.Fade, 255, 0)
            flux.to( self.AlphaRed, 2, {
                [ "self.AlphaRed" ] = 0
            } )

            --self.AlphaGreen = Lerp(self.Fade, 0, 255)
            flux.to( self.AlphaGreen, 2, {
                [ "self.AlphaGreen" ] = 255
            } )

            --self.AlphaOrange = Lerp(self.Fade, 0, 255)
            flux.to( self.AlphaOrange, 2, {
                [ "self.AlphaOrange" ] = 255
            } )
        elseif PreviousAspect == "H1" and NextAspect == "H0" then
            self.AlphaRed = Lerp( self.Fade, 0, 255 )
            self.AlphaGreen = Lerp( self.Fade, 255, 0 )
            self.AlphaOrange = 0
        elseif PreviousAspect == "H1" and NextAspect == "H2" then
            self.AlphaOrange = Lerp( self.Fade, 0, 255 )
            self.AlphaRed = 0
        elseif PreviousAspect == "H2" and NextAspect == "H1" then
            self.AlphaRed = 0
            self.AlphaOrange = Lerp( self.Fade, 0, 255 )
            self.AlphaGreen = 255
        elseif PreviousAspect == "H2" and NextAspect == "H0" then
            self.AlphaOrange = Lerp( self.Fade, 255, 0 )
            self.AlphaGreen = Lerp( self.Fade, 255, 0 )
            self.AlphaRed = Lerp( self.Fade, 0, 255 )
        end
    end

    self.FadeRecorded = false
end

function ENT:ClientSprites( position, size, color, active )
    if not active then return end
    --print( "Drawing sprite at position:", position, "with size:", size )
    local material = Material( "effects/yellowflare" )
    render.SetMaterial( material )
    render.DrawSprite( position, size, size, color )
end

function ENT:SetLensPositions( model )
    local pos_o
    local pos_g
    local pos_r
    local pos_rr
    if model == "models/lilly/uf/signals/Underground_Small_Pole.mdl" then
        pos_o = self.SignalModel:LocalToWorld( Vector( 7.5, 10.4, 146.4 ) )
        pos_g = self.SignalModel:LocalToWorld( Vector( 7.5, 10.4, 166.5 ) )
        pos_r = self.SignalModel:LocalToWorld( Vector( 7.5, 10.4, 158 ) )
        pos_rr = self.SignalModel:LocalToWorld( Vector( -7.5, -9.5, 135.8 ) )
    else
        pos_o = self.SignalModel:LocalToWorld( Vector( 7.5, 0, 82 ) )
        pos_g = self.SignalModel:LocalToWorld( Vector( 7.5, 0, 72 ) )
        pos_r = self.SignalModel:LocalToWorld( Vector( 7.5, 0, 92 ) )
        pos_rr = self.SignalModel:LocalToWorld( Vector( -7.5, -9.5, 135.8 ) )
    end
    return pos_o, pos_g, pos_r, pos_rr
end

function iLerp( value, in_min, in_max, out_min, out_max )
    -- Clamp the value within the input range
    local clampedValue = math.max( in_min, math.min( in_max, value ) )
    -- Normalize the clamped value to a range of 0 to 1
    local normalized = ( clampedValue - in_min ) / ( in_max - in_min )
    -- Map the normalized value to the output range
    return out_min + normalized * ( out_max - out_min )
end

function ENT:SignalAspect( aspect )
    if not aspect then return end
    self:GetPlayerDistance()
    local pos_o, pos_g, pos_r, pos_rr = self:SetLensPositions( self.SignalType )
    local ScalingEnabled = GetConVar( "mplr_enable_signal_sprite_scaling" ):GetBool()
    -- Invert the normalized distance for Lerp (to make scaling smaller when closer)
    self.SpriteSize = ScalingEnabled and iLerp( self.DistanceFactor, 10, 600, 10, 40 ) or 10
    if aspect == "H0" then
        self:ClientSprites( pos_o, self.SpriteSize, Color( 204, 116, 0 ), false )
        self:ClientSprites( pos_g, self.SpriteSize, Color( 27, 133, 0 ), false )
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed or 255), true)
        self:ClientSprites( pos_r, self.SpriteSize, Color( 200, 0, 0 ), true )
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0), true)
        self:ClientSprites( pos_rr, self.SpriteSize, Color( 200, 0, 0 ), false )
    elseif aspect == "H1" then
        --self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0,self.AlphaOrange), true)
        self:ClientSprites( pos_o, self.SpriteSize, Color( 204, 116, 0 ), false )
        --self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0,self.AlphaGreen), true)
        self:ClientSprites( pos_g, self.SpriteSize, Color( 27, 133, 0 ), true )
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed), true)
        self:ClientSprites( pos_r, self.SpriteSize, Color( 200, 0, 0 ), false )
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0,alpha_rr), true)
        self:ClientSprites( pos_rr, self.SpriteSize, Color( 200, 0, 0 ), true )
    elseif aspect == "H2" then
        --self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0,self.AlphaOrange), true)
        self:ClientSprites( pos_o, self.SpriteSize, Color( 204, 116, 0 ), true )
        --self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0,self.AlphaGreen), true)
        self:ClientSprites( pos_g, self.SpriteSize, Color( 27, 133, 0 ), true )
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed), true)
        self:ClientSprites( pos_r, self.SpriteSize, Color( 200, 0, 0 ), false )
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0,alpha_rr), true)
        self:ClientSprites( pos_rr, self.SpriteSize, Color( 200, 0, 0 ), true )
    elseif aspect == "Sh3d" then
        local blinkTime = blinkTime or 0
        local lensOn = false
        --self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0,self.AlphaOrange), true)
        self:ClientSprites( pos_o, self.SpriteSize, Color( 204, 116, 0 ), false )
        --self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0,self.AlphaGreen), true)
        self:ClientSprites( pos_g, self.SpriteSize, Color( 27, 133, 0 ), false )
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed), true)
        self:ClientSprites( pos_r, self.SpriteSize, Color( 200, 0, 0 ), false )
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0,alpha_rr), true)
        if not lensOn and CurTime() - blinkTime > 1 then
            lensOn = true
            blinkTime = CurTime()
        elseif lensOn and CurTime() - blinkTime > 1 then
            lensOn = false
            blinkTime = CurTime()
        end

        self:ClientSprites( pos_rr, self.SpriteSize, Color( 200, 0, 0 ), lensOn )
    end
end

function ENT:GetPlayerDistance()
    local ply = LocalPlayer()
    if not ply then
        self.DistanceFactor = 1
        return
    end

    -- Get the squared distance to the player in 2D
    local plyDistSqr = ply:GetPos():Distance2DSqr( self:GetPos() )
    -- Clamp to a minimum distance to avoid very small values
    self.DistanceFactor = math.max( plyDistSqr, 10 ) -- Set a minimum distance factor to avoid scaling issues
end

local debug = GetConVar( "metrostroi_drawsignaldebug" )
local function enableDebug()
    if debug then
        hook.Add( "PreDrawEffects", "MetrostroiSignalDebug", function()
            for _, sig in pairs( ents.FindByClass( "gmod_track_uf_signal" ) ) do
                if IsValid( sig ) and LocalPlayer():GetPos():Distance( sig:GetPos() ) < 384 then
                    local pos = sig:LocalToWorld( Vector( 48, 0, 50 ) )
                    local ang = sig:LocalToWorldAngles( Angle( 0, 90, 90 ) )
                    cam.Start3D2D( pos, ang, 0.25 )
                    surface.SetDrawColor( 125, 125, 0, 255 )
                    surface.DrawRect( 0, 0, 364, 100 )
                    draw.DrawText( "Signal name: " .. sig.Name1 .. "/" .. sig.Name2, "Trebuchet24", 5, 0, Color( 0, 0, 0, 255 ) )
                    draw.DrawText( "Aspect: " .. sig.Aspect, "Trebuchet24", 5, 20, Color( 0, 0, 0, 255 ) )
                    cam.End3D2D()
                end
            end
        end )
    else
        hook.Remove( "PreDrawEffects", "MetrostroiSignalDebug" )
    end
end

hook.Remove( "PreDrawEffects", "MetrostroiSignalDebug" )
cvars.AddChangeCallback( "metrostroi_drawsignaldebug", enableDebug )
enableDebug()
function ENT:PrintText( x, y, text, font, color )
    local str = { utf8.codepoint( text, 1, -1 ) }
    for i = 1, #str do
        local char = utf8.char( str[ i ] )
        draw.SimpleText( char, font, ( x + i ) * 55, y * 15 + 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

function ENT:PrintText2( x, y, text, font, color )
    local str = { utf8.codepoint( text, 1, -1 ) }
    for i = 1, #str do
        local char = utf8.char( str[ i ] )
        draw.SimpleText( char, font, ( x + i ) * 75, y * 15 + 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

surface.CreateFont( "Text", {
    font = "AkzidenzGroteskBE-Cn", --Akzidenz Gotesk BE Cn
    size = 160,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
    extended = true
} )

surface.CreateFont( "TextLarge", {
    font = "AkzidenzGroteskBE-Cn", --Akzidenz Gotesk BE Cn
    size = 254,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
    extended = true
} )