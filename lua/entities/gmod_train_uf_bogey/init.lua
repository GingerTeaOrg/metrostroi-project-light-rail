AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
--------------------------------------------------------------------------------
ENT.Types = {
    [ "u5" ] = { "models/lilly/uf/u5/bogey.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -14 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, -3.3 ), Vector( 4.3, 63, -3.3 ) },
    [ "u2joint" ] = { "models/lilly/uf/u2/jointbogey.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -14 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, 0 ), Vector( 4.3, 63, 0 ) },
    [ "b_motor" ] = { "models/lilly/mplr/bogeys/b-wagen/bogey_motor.mdl", Vector( 0, 0.0, -1.5 ), Angle( 0, 0, 0 ), "models/lilly/mplr/b_wheelset.mdl", Vector( 0, -61, -14 ), Vector( 0, 61, -15 ), nil, Vector( 4.3, -63, 0 ), Vector( 4.3, 63, 0 ) },
    [ "b_joint" ] = { "models/lilly/mplr/bogeys/b-wagen/joint_bogey.mdl", Vector( 0, 0.0, -1.5 ), Angle( 0, 0, 0 ), "models/lilly/mplr/b_wheelset.mdl", Vector( 0, -61, -28 ), Vector( 0, 61, -15 ), nil, Vector( 4.3, -63, 0 ), Vector( 4.3, 63, 0 ) },
    [ "u3joint" ] = { "models/lilly/uf/u3/jointbogey.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -14 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, 0 ), Vector( 4.3, 63, 0 ) },
    [ "duewag_motor" ] = { "models/lilly/uf/bogey/duewag_motor.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -14 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, -3.3 ), Vector( 4.3, 63, -3.3 ) },
    [ "pt" ] = { "models/lilly/uf/bogey/duewag_motor.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -14 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, -3.3 ), Vector( 4.3, 63, -3.3 ) },
    [ "def" ] = { "models/lilly/mplr/bogeys/b-wagen/bogey_motor.mdl", Vector( 0, 0.0, 0 ), Angle( 0, 0, 0 ), nil, Vector( 0, -61, -28 ), Vector( 0, 61, -14 ), nil, Vector( 4.3, -63, -3.3 ), Vector( 4.3, 63, -3.3 ) }
}

function ENT:SetParameters()
    local typ = self.Types[ self.BogeyType or "def" ]
    self:SetModel( typ and typ[ 1 ] or "models/lilly/mplr/bogeys/b-wagen/bogey_motor.mdl" )
    self.BogeyOffset = typ and typ[ 7 ]
end

function ENT:Initialize()
    self:SetParameters()
    if not self.NoPhysics then
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
    end

    -- Set proper parameters for the bogey
    if IsValid( self:GetPhysicsObject() ) then self:GetPhysicsObject():SetMass( 5000 ) end
    -- Store coupling point offset
    self.CouplingPointOffset = Vector( -480, 0, 0 )
    -- Setup default motor state
    self.Reversed = false
    self.MotorForce = 30000.0
    self.MotorPower = 0.0
    self.Speed = 0
    self.SpeedSign = 1
    self.Acceleration = 0
    self.PneumaticBrakeForce = 100000.0
    self.DisableSound = 0
    self.Texture = ""
    self.GetAdditionalTextures = false
    self.Variables = {}
    -- Pressure in brake cylinder
    self.BrakeCylinderPressure = 0.0 -- atm
    self.Voltage = 0
    self.VoltageDrop = 0
    self.DropByPeople = 0
    self.DisableParking = false
    self.NextStates = { false, false }
    self.CheckTimeout = 0
    if self:GetNW2Int( "SquealType", 0 ) == 0 then self:SetNW2Int( "SquealType", math.floor( math.random() * 4 ) + 1 ) end
    self.InhibitReRail = false
end

function ENT:InitializeWheels()
    -- Create missing wheels
    if IsValid( self.Wheels ) then SafeRemoveEntity( self.Wheels ) end
    local wheels = ents.Create( "gmod_train_uf_wheels" )
    local typ = self.Types[ self.BogeyType or "def" ]
    wheels.Model = typ[ 4 ]
    if typ and typ[ 3 ] then wheels:SetAngles( self:LocalToWorldAngles( typ[ 3 ] ) ) end
    if typ and typ[ 2 ] then wheels:SetPos( self:LocalToWorld( typ[ 2 ] ) ) end
    wheels.WheelType = self.BogeyType
    wheels.NoPhysics = self.NoPhysics
    wheels:Spawn()
    if self.NoPhysics then
        wheels:SetParent( self )
    else
        constraint.Weld( self, wheels, 0, 0, 0, 1, 0 )
    end

    if CPPI then wheels:CPPISetOwner( self:CPPIGetOwner() or self:GetNW2Entity( "TrainEntity" ):GetOwner() ) end
    wheels:SetNW2Entity( "TrainBogey", self )
    self.Wheels = wheels
end

function ENT:OnRemove()
    SafeRemoveEntity( self.Wheels )
    if self.CoupledBogey ~= nil then self:Decouple() end
end

function ENT:GetDebugVars()
    return self.Variables
end

function ENT:TriggerInput( iname, value )
    if iname == "BrakeCylinderPressure" then
        self.BrakeCylinderPressure = value
    elseif iname == "MotorCommand" then
        self.MotorPower = value
    elseif iname == "MotorForce" then
        self.MotorForce = value
    elseif iname == "MotorReversed" then
        self.Reversed = value > 0.5
    elseif iname == "DisableSound" then
        self.DisableSound = math.max( 0, math.min( 3, math.floor( value ) ) )
    end
end

function ENT:Think()
    -- Re-initialize wheels
    if not IsValid( self.Wheels ) or self.Wheels:GetNW2Entity( "TrainBogey" ) ~= self then
        self:InitializeWheels()
        constraint.NoCollide( self.Wheels, self, 0, 0 )
        if IsValid( self:GetNW2Entity( "TrainEntity" ) ) then constraint.NoCollide( self.Wheels, self:GetNW2Entity( "TrainEntity" ), 0, 0 ) end
    end

    -- Update timing
    self.PrevTime = self.PrevTime or CurTime()
    self.DeltaTime = CurTime() - self.PrevTime
    self.PrevTime = CurTime()
    self:SetNW2Entity( "TrainWheels", self.Wheels )
    -- Skip physics related stuff
    if self.NoPhysics or not self.Wheels:GetPhysicsObject():IsValid() then
        self:SetMotorPower( self.MotorPower or 0 )
        self:SetSpeed( self.Speed or 0 )
        self:NextThink( CurTime() )
        return true
    end

    -- Get speed of bogey in km/h
    local localSpeed = -self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858
    local absSpeed = math.abs( localSpeed )
    if self.Reversed then localSpeed = -localSpeed end
    local sign = 1
    if localSpeed < 0 then sign = -1 end
    self.Speed = absSpeed
    self.SpeedSign = self.Reversed and -sign or sign
    -- Calculate acceleration in m/s
    self.Acceleration = 0.277778 * ( self.Speed - ( self.PrevSpeed or 0 ) ) / self.DeltaTime
    self.PrevSpeed = self.Speed
    -- Add variables to debugger
    self.Variables[ "Speed" ] = self.Speed
    self.Variables[ "Acceleration" ] = self.Acceleration
    -- Calculate motor power
    local motorPower = 0.0
    if self.MotorPower > 0.0 then
        motorPower = math.Clamp( self.MotorPower, -1, 1 )
    else
        motorPower = math.Clamp( self.MotorPower * sign, -1, 1 )
    end

    -- Increace forces on slopes
    local slopemul = 1
    local pitch = self:GetAngles().pitch * sign
    if motorPower < 0 and pitch > 3 then
        slopemul = slopemul + math.Clamp( ( math.abs( pitch ) - 3 ) / 3, 0, 1 )
    else
        slopemul = slopemul + math.Clamp( ( pitch - 3 ) / 3, 0, 1 ) * 1.5
    end

    -- Final brake cylinder pressure
    local pneumaticPow = self.PneumaticPow or 1
    local pB = not self.DisableParking and self.ParkingBrakePressure or 0
    local BrakeCP = ( ( ( self.BrakeCylinderPressure / 2.7 + pB / 1.6 ) ^ pneumaticPow ) * 2.7 ) / 4.5
    -- + (self.ParkingBrake and 1 or 0)
    if ( BrakeCP * 4.5 > 1.5 - math.Clamp( math.abs( pitch ) / 1, 0, 1 ) ) and ( absSpeed < 1 ) then
        self.Wheels:GetPhysicsObject():SetMaterial( "gmod_silent" )
    else
        self.Wheels:GetPhysicsObject():SetMaterial( "gmod_ice" )
    end

    -- Calculate forces
    local motorForce = self.MotorForce * motorPower * slopemul
    local pneumaticFactor = math.Clamp( 0.5 * self.Speed, 0, 1 ) * ( 1 + math.Clamp( ( 2 - self.Speed ) / 2, 0, 1 ) * 0.5 )
    local pneumaticForce = 0
    if BrakeCP >= 0.05 then
        local slopemulBr = 1
        if -3 > pitch or pitch > 3 then slopemulBr = 1 + math.Clamp( ( math.abs( pitch ) - 3 ) / 3, 0, 1 ) * 0.7 end
        pneumaticForce = -sign * pneumaticFactor * self.PneumaticBrakeForce * BrakeCP * slopemulBr
    end

    -- Compensate forward friction
    local compensateA = self.Speed / 86
    local compensateF = sign * self:GetPhysicsObject():GetMass() * compensateA
    -- Apply sideways friction
    local sideSpeed = -self:GetVelocity():Dot( self:GetAngles():Right() ) * 0.06858
    if sideSpeed < 0.5 then sideSpeed = 0 end
    local sideForce = sideSpeed * 0.5 * self:GetPhysicsObject():GetMass()
    -- Apply force
    local dt_scale = 66.6 / ( 1 / self.DeltaTime )
    -- print(pneumaticForce)
    local force = dt_scale * ( motorForce + pneumaticForce + compensateF )
    local side_force = dt_scale * sideForce
    if self.Reversed then
        self:GetPhysicsObject():ApplyForceCenter( self:GetAngles():Forward() * force + self:GetAngles():Right() * side_force )
    else
        self:GetPhysicsObject():ApplyForceCenter( -self:GetAngles():Forward() * force + self:GetAngles():Right() * side_force )
    end

    -- Apply Z axis damping
    local avel = self:GetPhysicsObject():GetAngleVelocity()
    local avelz = math.min( 20, math.max( -20, avel.z ) )
    local damping = Vector( 0, 0, -avelz ) * 0.75 * dt_scale
    self:GetPhysicsObject():AddAngleVelocity( damping )
    -- Calculate brake squeal
    self.SquealSensitivity = 1
    local BCPress = math.abs( self.BrakeCylinderPressure )
    self.RattleRandom = self.RattleRandom or 0.5 + math.random() * 0.2
    local PnF1 = math.Clamp( ( BCPress - 0.6 ) / 0.6, 0, 2 )
    local PnF2 = math.Clamp( ( BCPress - self.RattleRandom ) / 0.6, 0, 2 )
    local brakeSqueal1 = ( PnF1 * PnF2 ) * pneumaticFactor
    -- local brakeSqueal2 = (PnF1*PnF3)*pneumaticFactor
    -- Send parameters to client
    if self.DisableSound < 1 then self:SetMotorPower( motorPower ) end
    if self.DisableSound < 2 then
        if self:GetNWBool( "Async" ) then
            self:SetNW2Float( "BrakeSqueal", ( self.BrakeCylinderPressure - 0.9 ) / 1.7 )
        else
            self:SetNW2Float( "BrakeSqueal1", brakeSqueal1 )
        end
    end

    if self.DisableSound < 3 then self:SetSpeed( absSpeed ) end
    self:NextThink( CurTime() )
    return true
end

--------------------------------------------------------------------------------
-- Default spawn function
--------------------------------------------------------------------------------
function ENT:SpawnFunction( ply, tr )
    local verticaloffset = 40 -- Offset for the train model, gmod seems to add z by default, nvm its you adding 170 :V
    local distancecap = 2000 -- When to ignore hitpos and spawn at set distanace
    local pos, ang = nil
    local inhibitrerail = self.InhibitReRail
    if tr.Hit then
        -- Setup trace to find out of this is a track
        local tracesetup = {}
        tracesetup.start = tr.HitPos
        tracesetup.endpos = tr.HitPos + tr.HitNormal * 80
        tracesetup.filter = ply
        local tracedata = util.TraceLine( tracesetup )
        if tracedata.Hit then
            -- Trackspawn
            pos = ( tr.HitPos + tracedata.HitPos ) / 2 + Vector( 0, 0, verticaloffset )
            ang = tracedata.HitNormal
            ang:Rotate( Angle( 0, 90, 0 ) )
            ang = ang:Angle()
            -- Bit ugly because Rotate() messes with the orthogonal vector | Orthogonal? I wrote "origional?!" :V
        else
            -- Regular spawn
            if tr.HitPos:Distance( tr.StartPos ) > distancecap then
                -- Spawnpos is far away, put it at distancecap instead
                pos = tr.StartPos + tr.Normal * distancecap
                inhibitrerail = true
            else
                -- Spawn is near
                pos = tr.HitPos + tr.HitNormal * verticaloffset
            end

            ang = Angle( 0, tr.Normal:Angle().y, 0 )
        end
    else
        -- Trace didn't hit anything, spawn at distancecap
        pos = tr.StartPos + tr.Normal * distancecap
        ang = Angle( 0, tr.Normal:Angle().y, 0 )
    end

    local ent = ents.Create( self.ClassName )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    ent:Spawn()
    ent:Activate()
    if not inhibitrerail then UF.RerailBogey( ent ) end
    return ent
end

local types = {
    Texture = "train",
    PassTexture = "pass",
    CabTexture = "cab"
}

function ENT:FindFineSkin()
    local train = self:GetNW2Entity( "TrainEntity" )
    if not train.SkinsType then return end
    for id, typ in pairs( types ) do
        local fineSkins = {
            all = {},
            def = {}
        }

        for k, v in pairs( Metrostroi.Skins[ typ ] ) do
            if v.textures and v.typ == self.SkinsType then
                table.insert( fineSkins.all, k )
                if v.def then table.insert( fineSkins.def, k ) end
            end
        end

        if #fineSkins.def > 0 then
            self:SetNW2String( id, table.Random( fineSkins.def ) )
            self:UpdateTextures()
        elseif #fineSkins.all > 0 then
            self:SetNW2String( id, table.Random( fineSkins.all ) )
            self:UpdateTextures()
        end
    end
end

function ENT:UpdateTextures()
    if texture and texture.func then self:SetNW2String( "Texture", texture.func( self ) ) end
    if passtexture and passtexture.func then self:SetNW2String( "PassTexture", passtexture.func( self ) ) end
    if cabintexture and cabintexture.func then self:SetNW2String( "CabTexture", cabintexture.func( self ) ) end
    self.Texture = self:GetNW2String( "Texture" )
    self.PassTexture = self:GetNW2String( "PassTexture" )
    self.CabTexture = self:GetNW2String( "CabTexture" )
    local texture = Metrostroi.Skins[ "train" ][ self.Texture ]
    for k in pairs( self:GetMaterials() ) do
        self:SetSubMaterial( k - 1, "" )
    end

    for k, v in pairs( self:GetMaterials() ) do
        local tex = v:gsub( "^.+/", "" )
        if self.GetAdditionalTextures then
            local tex = self:GetAdditionalTextures( tex )
            if tex then
                self:SetSubMaterial( k - 1, tex )
                continue
            end
        end

        if texture and texture.textures and texture.textures[ tex ] then self:SetSubMaterial( k - 1, texture.textures[ tex ] ) end
    end

    if texture and texture.postfunc then texture.postfunc( self ) end
end