AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:CreatePanto( pos, ang, typ )
    local panto = ents.Create( "gmod_train_uf_panto" )
    panto:SetPos( self:LocalToWorld( pos ) )
    panto:SetAngles( self:GetAngles() + ang )
    panto.PantoType = typ
    panto.NoPhysics = self.NoPhysics or true
    panto:Spawn()
    panto.SpawnPos = pos
    panto.SpawnAng = ang
    panto:SetNW2Entity( "TrainEntity", self )
    panto.Train = self
    if self.NoPhysics then
        panto:SetParent( self )
    else
        constraint.Weld( panto, self, 0, 0, 0, true )
    end

    table.insert( self.TrainEntities, panto )
    -- panto:Activate()
    return panto
end

function ENT:CreateSection( pos, ang, ent, parentSection, sectionC, sectionA ) --right now this only is intended for a maximum of eight axle trains. That means, A/B/C sections only.
    ang = ang or Angle( 0, 0, 0 )
    local sectionEnt = ents.Create( ent )
    sectionEnt:SetPos( self:LocalToWorld( pos ) )
    sectionEnt:SetAngles( self:GetAngles() + ang )
    sectionEnt:Spawn()
    sectionEnt:Activate()
    sectionEnt:SetOwner( self:GetOwner() )
    if IsValid( parentSection ) and parentSection == sectionA then --if the parent section is an A section then we're only an A/B train so no need for sectionC params
        local index = parentSection:EntIndex()
        local sectionB = sectionEnt
        local sectionBIndex = sectionEnt:EntIndex()
        sectionB.parentSection = parentSection
        sectionB.SectionA = self
        sectionB:SetNW2Int( "parentSectionIndex", index )
        sectionB:SetNW2Int( "SectionAIndex", index )
        self:SetNW2Int( "SectionBIndex", sectionBIndex )
        --get original weights
        local selfPhys = self:GetPhysicsObject()
        local selfWeight = selfPhys:GetMass()
        local sectionPhys = sectionEnt:GetPhysicsObject()
        local sectionWeight = sectionPhys:GetMass()
        --set weights to maximum, in order to make the joint extra mellow
        selfPhys:SetMass( 50000 )
        sectionPhys:SetMass( 50000 )
        constraint.AdvBallsocket( sectionEnt, self.MiddleBogey, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
        --reset weights
        selfPhys:SetMass( selfWeight )
        sectionPhys:SetMass( sectionWeight )
    elseif IsValid( parentSection ) and parentSection == sectionC then
        local index = parentSection:EntIndex()
        if sectionA then
            local sectionB = sectionEnt
            --section A already exists so we must be spawning section B
            sectionA.SectionB = sectionB --tell section A this is section B
            sectionA:SetNW2Int( "SectionBIndex", sectionBIndex ) --give section A section B index number
            sectionB.ParentSection = parentSection --tell section B that section C (self) is parent section
            sectionB:SetNW2Int( "parentSectionIndex", index ) --give section B the parent section C index number
            local sectionBIndex = sectionB:EntIndex() --get section B index number
            self:SetNW2Int( "SectionBIndex", sectionBIndex ) --give parent section C (self) the section B index number
            --get original weights
            local selfPhys = self:GetPhysicsObject()
            local selfWeight = selfPhys:GetMass()
            local sectionPhys = sectionEnt:GetPhysicsObject()
            local sectionWeight = sectionPhys:GetMass()
            --set weights to maximum, in order to make the joint extra mellow
            selfPhys:SetMass( 50000 )
            sectionPhys:SetMass( 50000 )
            constraint.AdvBallsocket( sectionEnt, self.MiddleBogey2, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
            --reset weights
            selfPhys:SetMass( selfWeight )
            sectionPhys:SetMass( sectionWeight )
        elseif not sectionA then
            --we're spawning section A
            local sectionA = sectionEnt --define section A
            sectionA.ParentSection = self -- tell section A that section C (self because only sectionC calls this func) is the parent section
            sectionA:SetNW2Int( "parentSectionIndex", index ) --give sectionA the index number of sectionC for later processing on clientside
            local sectionAIndex = sectionA:EntIndex() --get section A index
            self:SetNW2Int( "SectionAIndex", sectionAIndex ) --give section C (self) index number of section A for later processing
            --get original weights
            local selfPhys = self:GetPhysicsObject()
            local selfWeight = selfPhys:GetMass()
            local sectionPhys = sectionEnt:GetPhysicsObject()
            local sectionWeight = sectionPhys:GetMass()
            --set weights to maximum, in order to make the joint extra mellow
            selfPhys:SetMass( 50000 )
            sectionPhys:SetMass( 50000 )
            constraint.AdvBallsocket( sectionEnt, self.MiddleBogey1, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
            --reset weights
            selfPhys:SetMass( selfWeight )
            sectionPhys:SetMass( sectionWeight )
        end
    end

    table.insert( self.TrainEntities, sectionEnt )
    constraint.NoCollide( self.MiddleBogey, sectionEnt, 0, 0 )
    constraint.NoCollide( self, sectionEnt, 0, 0 )
    return sectionEnt
end

function ENT:CreateCustomCoupler( pos, ang, forward, typ, a_b )
    if a_b == "b" then print( IsValid( self.SectionB ) ) end
    -- Create bogey entity
    local coupler = ents.Create( "gmod_train_uf_couple" )
    if a_b == "a" then
        local ent = IsValid( self.SectionA ) and self.SectionA or self
        coupler:SetPos( ent:LocalToWorld( pos ) )
        coupler:SetAngles( ent:GetAngles() + ang )
    elseif a_b == "b" then
        coupler:SetPos( self.SectionB:LocalToWorld( pos ) )
        coupler:SetAngles( self.SectionB:GetAngles() + ang )
    end

    coupler.CoupleType = typ
    coupler:Spawn()
    -- Assign ownership
    if CPPI and IsValid( self:CPPIGetOwner() ) then coupler:CPPISetOwner( self:CPPIGetOwner() ) end
    -- Some shared general information about the bogey
    coupler:SetNW2Bool( "IsForwardCoupler", forward )
    coupler:SetNW2Entity( "TrainEntity", self )
    coupler.SpawnPos = pos
    coupler.SpawnAng = ang
    -- Constraint coupler to the train
    if self.NoPhysics then
        coupler:SetParent( coupler )
    else
        if a_b == "a" then
            local ent = IsValid( self.SectionA ) and self.SectionA or self --eight or six axles? the primary ent is self on six axle trains, so mount it to self
            constraint.AdvBallsocket( ent, coupler, 0, -- bone
                0, -- bone
                pos, Vector( 0, 0, 0 ), 1, -- forcelimit
                1, -- torquelimit
                -2, -- xmin
                -2, -- ymin
                -15, -- zmin
                2, -- xmax
                2, -- ymax
                15, -- zmax
                0.1, -- xfric
                0.1, -- yfric
                1, -- zfric
                0, -- rotonly
                1 )

            -- nocollide
            constraint.Axis( coupler, ent, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, 0, 1, Vector( 0, 0, 1 ), false )
        elseif a_b == "b" then
            constraint.AdvBallsocket( self.SectionB, coupler, 0, -- bone
                0, -- bone
                pos, Vector( 0, 0, 0 ), 1, -- forcelimit
                1, -- torquelimit
                -2, -- xmin
                -2, -- ymin
                -15, -- zmin
                2, -- xmax
                2, -- ymax
                15, -- zmax
                0.1, -- xfric
                0.1, -- yfric
                1, -- zfric
                0, -- rotonly
                1 )

            -- nocollide
            constraint.Axis( coupler, self.SectionB, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, 0, 1, Vector( 0, 0, 1 ), false )
        end
    end

    -- Add to cleanup list
    table.insert( self.TrainEntities, coupler )
    return coupler
end

function ENT:CreateBogeyUF( pos, ang, forward, typ, a_b )
    -- Create bogey entity
    local bogey = ents.Create( "gmod_train_uf_bogey" )
    if a_b == "a" then
        local ent = IsValid( self.SectionA ) and self.SectionA or self
        bogey:SetPos( ent:LocalToWorld( pos ) )
        bogey:SetAngles( ent:GetAngles() + ang )
    elseif a_b == "b" then
        bogey:SetPos( self.SectionB:LocalToWorld( pos ) )
        bogey:SetAngles( self.SectionB:GetAngles() + ang )
    elseif a_b == "c" then
        bogey:SetPos( self:LocalToWorld( pos ) )
        bogey:SetAngles( self:GetAngles() + ang )
    else
        print( "ERROR: Section Ent to mount to not defined!!" )
        for _, v in ipairs( self.TrainEntities ) do
            SafeRemoveEntity( v )
        end
        return
    end

    bogey.BogeyType = typ
    bogey.NoPhysics = self.NoPhysics
    bogey:Spawn()
    -- Assign ownership
    if CPPI and IsValid( self:CPPIGetOwner() ) then bogey:CPPISetOwner( self:CPPIGetOwner() ) end
    -- Some shared general information about the bogey
    self.SquealSound = self.SquealSound or math.floor( 4 * math.random() )
    self.SquealSensitivity = self.SquealSensitivity or math.random()
    bogey.SquealSensitivity = self.SquealSensitivity
    bogey:SetNW2Int( "SquealSound", self.SquealSound )
    bogey:SetNW2Bool( "IsForwardBogey", forward )
    bogey:SetNW2Entity( "TrainEntity", self )
    bogey.SpawnPos = pos
    bogey.SpawnAng = ang
    local index = 1
    for i, v in ipairs( self.JointPositions ) do
        if v > pos.x then
            index = i + 1
        else
            break
        end
    end

    table.insert( self.JointPositions, index, pos.x + 53.6 )
    table.insert( self.JointPositions, index + 1, pos.x - 53.6 )
    -- Constraint bogey to the train
    if self.NoPhysics then
        bogey:SetParent( self )
    else
        if a_b == "a" then
            local ent = IsValid( self.SectionA ) and self.SectionA or self
            local BogeyPhys = bogey:GetPhysicsObject()
            local BogeyWeight = BogeyPhys:GetMass()
            local TrainPhys = ent:GetPhysicsObject()
            local TrainWeight = TrainPhys:GetMass()
            TrainPhys:SetMass( 50000 )
            BogeyPhys:SetMass( 50000 )
            constraint.AdvBallsocket( bogey, ent, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
            TrainPhys:SetMass( TrainWeight )
            BogeyPhys:SetMass( BogeyWeight )
            if IsValid( self.SectionA ) then constraint.NoCollide( bogey, self.SectionA ) end
            constraint.NoCollide( bogey, self )
        elseif a_b == "b" then
            local BogeyPhys = bogey:GetPhysicsObject()
            local BogeyWeight = BogeyPhys:GetMass()
            local TrainPhys = self.SectionB:GetPhysicsObject()
            local TrainWeight = TrainPhys:GetMass()
            TrainPhys:SetMass( 50000 )
            BogeyPhys:SetMass( 50000 )
            constraint.AdvBallsocket( bogey, self.SectionB, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
            TrainPhys:SetMass( TrainWeight )
            BogeyPhys:SetMass( BogeyWeight )
            constraint.NoCollide( bogey, self.SectionB )
            constraint.NoCollide( bogey, self )
        elseif a_b == "c" then
            local BogeyPhys = bogey:GetPhysicsObject()
            local BogeyWeight = BogeyPhys:GetMass()
            local TrainPhys = self:GetPhysicsObject()
            local TrainWeight = TrainPhys:GetMass()
            TrainPhys:SetMass( 50000 )
            BogeyPhys:SetMass( 50000 )
            constraint.AdvBallsocket( bogey, self, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, -0, -0, -180, 0, 0, 180, 0, 10, 0, 0, 1 ) -- bone -- bone		 -- forcelimit -- torquelimit -- xmin -- ymin -- zmin -- xmax -- ymax -- zmax -- xfric -- yfric -- zfric -- rotonly -- nocollide
            TrainPhys:SetMass( TrainWeight )
            BogeyPhys:SetMass( BogeyWeight )
            constraint.NoCollide( bogey, self )
            if IsValid( self.SectionA ) then constraint.NoCollide( bogey, self.SectionA ) end
            if IsValid( self.SectionB ) then constraint.NoCollide( bogey, self.SectionB ) end
        end
    end

    -- Add to cleanup list
    table.insert( self.TrainEntities, bogey )
    return bogey
end

function ENT:CreateGangway( pos, bone1, bone2, ent1, ent2, typ )
    local gangway = ents.Create( "prop_ragdoll" )
    gangway:SetModel( typ )
    gangway:SetPos( self:LocalToWorld( pos ) )
    gangway:Spawn()
    gangway:Activate()
    constraint.Weld( ent1, gangway, 0, bone1, 0, true, false )
    constraint.Weld( ent2, gangway, 0, bone2, 0, true, false )
    table.insert( self.TrainEntities, gangway )
end

-----------------------------------DUPLICATOR----------------------------------
function ENT:PreEntityCopy()
    local BaseDupe = {}
    local Tbl = {}
    if IsValid( self.FrontBogey ) then Tbl[ 1 ] = { self.FrontBogey:EntIndex(), self.FrontBogey.NoPhysics, self.FrontBogey:GetAngles(), } end
    if IsValid( self.FrontJoin ) then Tbl[ 1 ][ 4 ] = self.FrontJoin:EntIndex() end
    if IsValid( self.RearBogey ) then Tbl[ 2 ] = { self.RearBogey:EntIndex(), self.RearBogey.NoPhysics, self.RearBogey:GetAngles(), } end
    if IsValid( self.RearJoin ) then Tbl[ 2 ][ 4 ] = self.RearJoin:EntIndex() end
    BaseDupe.Tbl = Tbl
    duplicator.StoreEntityModifier( self, "BaseDupe", BaseDupe )
end

duplicator.RegisterEntityModifier( "BaseDupe", function() end )
function ENT:PostEntityPaste( ply, ent, createdEntities )
    local BaseDupe = ent.EntityMods.BaseDupe
    local Tbl = BaseDupe.Tbl
    for k, v in pairs( Tbl ) do
        BaseDupe.Tbl[ k ][ 1 ] = createdEntities[ BaseDupe.Tbl[ k ][ 1 ] ] or nil
        BaseDupe.Tbl[ k ][ 4 ] = createdEntities[ BaseDupe.Tbl[ k ][ 4 ] ] or nil
    end

    if IsValid( self.FrontBogey ) and IsValid( BaseDupe.Tbl[ 1 ][ 1 ] ) then self.FrontBogey:Remove() end
    if IsValid( self.RearBogey ) and IsValid( BaseDupe.Tbl[ 2 ][ 1 ] ) then self.RearBogey:Remove() end
    if IsValid( self.FrontJoin ) and IsValid( BaseDupe.Tbl[ 1 ][ 4 ] ) then self.FrontJoin:Remove() end
    if IsValid( self.RearJoin ) and IsValid( BaseDupe.Tbl[ 2 ][ 4 ] ) then self.RearJoin:Remove() end
    if IsValid( self.FrontBogey ) and IsValid( self.RearBogey ) and not self.IgnoreEngine then
        for i = 1, #self.TrainEntities do
            if IsValid( self.TrainEntities[ i ] ) and self.TrainEntities[ i ]:GetClass() == "gmod_train_bogey" then table.remove( self.TrainEntities, i ) end
        end
    end

    self.FrontBogey = Tbl[ 1 ][ 1 ] or nil
    self.RearBogey = Tbl[ 2 ][ 1 ] or nil
    for k, v in pairs( Tbl ) do
        if IsValid( v[ 1 ] ) then
            v[ 1 ].NoPhysics = v[ 2 ] or nil
            -- Assign ownership
            if CPPI and IsValid( self:CPPIGetOwner() ) then v[ 1 ]:CPPISetOwner( self:CPPIGetOwner() ) end
            -- Some shared general information about the bogey
            self.SquealSound = self.SquealSound or math.floor( 4 * math.random() )
            self.SquealSensitivity = self.SquealSensitivity or math.random()
            v[ 1 ].SquealSensitivity = self.SquealSensitivity
            v[ 1 ]:SetNW2Int( "SquealSound", self.SquealSound )
            v[ 1 ]:SetNW2Bool( "IsForwardBogey", k == 1 )
            v[ 1 ]:SetNW2Entity( "TrainEntity", self )
            -- Constraint bogey to the train
            if self.NoPhysics then
                v[ 1 ]:SetParent( self )
            else
                constraint.Axis( v[ 1 ], self, 0, 0, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 0, 0, 0, 1, Vector( 0, 0, 1 ), false )
            end

            table.insert( self.TrainEntities, v[ 1 ] )
        end
    end

    self.Owner = ply
end

--------------------------------------------------------------------------------
local C_MaxWagons = GetConVar( "mplr_maxwagons" )
local C_MaxTrains = GetConVar( "mplr_maxtrains" )
local C_MaxTrainsOnPly = GetConVar( "mplr_maxtrains_onplayer" )
function ENT:Initialize()
    self.Joints = {}
    self.JointPositions = {}
    if self:GetModel() == "models/error.mdl" then self:SetModel( "models/props_lab/reciever01a.mdl" ) end
    if not self.NoPhysics then
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
    else
        self:SetSolid( SOLID_VPHYSICS )
    end

    self:SetUseType( SIMPLE_USE )
    -- Prop-protection related
    if CPPI and IsValid( self.Owner ) then self:CPPISetOwner( self.Owner ) end
    -- Entities that belong to train and must be cleaned up later
    self.TrainEntities = {}
    -- All the sitting positions in train
    self.Seats = {}
    -- List of headlights, dynamic lights, sprite lights
    self.Lights = {}
    -- Load sounds
    self:InitializeSounds()
    if self.NoTrain then return end
    -- Possible number of train wires
    self.TrainWireCount = self.TrainWireCount or 36
    -- Train wires
    self:ResetTrainWires()
    self:UpdateWagonList()
    self:ChooseTrainWireLeader()
    self:GenerateWagonNumber()
    -- Systems defined in the train
    self.Systems = {}
    -- Initialize train systems
    self:InitializeSystems()
    -- Initialize highspeed interface
    self:InitializeHighspeedLayout()
    self:LoadSystem( "FailSim" )
    -- Setup drivers controls
    self.ButtonBuffer = {}
    self.KeyBuffer = {}
    self.KeyMap = {}
    self.MouseThrottle = 0
    -- Override for if drivers wrench is present
    self.DriversWrenchPresent = false
    self.Driver = "none"
    -- External interaction areas
    self.InteractionAreas = {}
    -- Joystick module support
    if joystick then self.JoystickBuffer = {} end
    self.DebugVars = {}
    -- Cross-connections in train wires
    self.TrainWireCrossConnections = {}
    self.TrainWireInverts = {}
    self.TrainWireWritersID = {}
    self.TrainWireTurbostroi = {}
    -- Overrides for train wire values from wiremod interface and special concommand
    self.TrainWireOverrides = {}
    self.TrainWireOutside = {}
    self.TrainWireOutsideFrom = {}
    -- Is this train 'odd' or 'even' in coupled set
    self.TrainCoupledIndex = 0
    self.MouseSensitivity = 5
    -- Speed and acceleration of train
    self.Speed = 0
    self.SpeedSign = 0
    self.Acceleration = 0
    -- Initialize train
    if Turbostroi and ( not self.NoPhysics ) and not self.DontAccelerateSimulation then Turbostroi.InitializeTrain( self ) end
    if not Turbostroi or self.DontAccelerateSimulation then self.DataCache = {} end
    -- Passenger related data (must be set by derived trains to allow boarding)
    self.LeftDoorsOpen = false
    --self.LeftDoorsBlocked = false
    self.PrevLeftDoorsOpening = false
    self.LeftDoorsOpening = false
    self.RightDoorsOpen = false
    --self.RightDoorsBlocked = false
    self.PrevRightDoorsOpening = false
    self.RightDoorsOpening = false
    -- Get default train mass
    if IsValid( self:GetPhysicsObject() ) then self.NormalMass = self:GetPhysicsObject():GetMass() end
    SetGlobalInt( "mplr_train_count", UF.TrainCount() )
    net.Start( "MPLRTrainCount" )
    net.Broadcast()
    --[[GRAVHULL
    if GravHull then
        if !(IsValid(self) and self:GetMoveType() == MOVETYPE_VPHYSICS and !GravHull.HULLS[self]) then return false end
        GravHull.RegisterHull(self,-2,100)
        GravHull.UpdateHull(self)
    end
    ]]
    self.FailSim:TriggerInput( "TrainWires", self.TrainWireCount )
    self:FindFineSkin()
    -- Initialize train systems
    self:PostInitializeSystems()
    for k, v in pairs( self.CustomSpawnerUpdates ) do
        if k ~= "BaseClass" then v( self ) end
    end

    self.WiperState = 0
    self.WiperInterval = 0
    self.WipeDown = false
    self.Wiped = false
end

util.AddNetworkString( "mplr-sound-inside-tracker" )
function ENT:IsPlyInsideTrain()
    -- Ensure tracking table exists
    self.PlayerInsideTrainTracker = self.PlayerInsideTrainTracker or {}
    -- Get bounding box in local space
    local physBBox1, physBBox2 = self:GetCollisionBounds()
    -- Convert bounding box to world space
    local worldMin = self:LocalToWorld( physBBox1 )
    local worldMax = self:LocalToWorld( physBBox2 )
    -- Track players inside bounding box
    for _, ply in ipairs( player.GetAll() ) do
        local pos = ply:GetPos()
        self.PlayerInsideTrainTracker[ ply ] = pos:WithinAABox( worldMin, worldMax )
    end

    -- Broadcast tracking data to clients
    net.Start( "mplr-sound-inside-tracker" )
    net.WriteEntity( self )
    net.WriteTable( self.PlayerInsideTrainTracker )
    net.Broadcast()
end

function ENT:GetWagonNumber()
    return self.WagonNumber or self:EntIndex()
end

-- Remove entity
function ENT:OnRemove()
    -- Remove all linked objects
    constraint.RemoveAll( self )
    if self.TrainEntities then
        for k, v in pairs( self.TrainEntities ) do
            SafeRemoveEntity( v )
        end
    end

    for i = string.byte( 'A' ), string.byte( 'Z' ) do
        local letter = string.char( i )
        local ent = self[ "Section" .. letter ]
        if IsValid( ent ) then SafeRemoveEntity( ent ) end
    end

    -- Deinitialize train
    if Turbostroi then Turbostroi.DeinitializeTrain( self ) end
    SetGlobalInt( "mplr_train_count", UF.TrainCount() )
    net.Start( "MPLRTrainCount" )
    net.Broadcast()
end

function ENT:GetDriverName()
    local drv = self:GetDriver()
    local name = tostring( self )
    if IsValid( drv ) then
        name = drv:GetName() .. "(sit in driver place)"
    elseif IsValid( self.Owner ) then
        name = self.Owner:GetName() .. "(owner)"
    end
    return name
end

function ENT:GetDriverPly()
    local drv = self:GetDriver()
    if IsValid( drv ) then
        return drv, true
    elseif IsValid( self.Owner ) then
        return self.Owner, false
    else
        return self, nil
    end
end

-- Interaction zones
function ENT:Use( ply )
    local tr = ply:GetEyeTrace()
    if not tr.Hit then return end
    local hitpos = self:WorldToLocal( tr.HitPos )
    --print(hitpos)
    if self.InteractionZones and ply:GetPos():Distance( tr.HitPos ) < 100 then
        for k, v in pairs( self.InteractionZones ) do
            if hitpos:Distance( v.Pos ) < v.Radius then self:ButtonEvent( v.ID, nil, ply ) end
        end
    end
end

-- Trigger output
function ENT:TriggerOutput( name, value )
    if Wire_TriggerOutput then Wire_TriggerOutput( self, name, tonumber( value ) or 0 ) end
end

-- Trigger input
function ENT:TriggerInput( name, value )
    -- Custom seat
    if name == "DriverSeat" then
        if IsValid( value ) and value:IsVehicle() then
            self.DriverSeat = value
        else
            self.DriverSeat = nil
        end
    end

    -- Train wire input
    if string.sub( name, 1, 9 ) == "TrainWire" then
        local id = tonumber( string.sub( name, 10 ) )
        self.TrainWireOverrides[ id ] = value
    end

    -- Drivers wrench present
    if name == "DriversWrenchPresent" then self.DriversWrenchPresent = value > 0.5 end
    -- Propagate inputs to relevant systems
    for k, v in pairs( self.Systems ) do
        if v.IsInput[ name ] then
            v:TriggerInput( name, value )
        elseif v.Name and ( string.sub( name, 1, #v.Name ) == v.Name ) then
            local subname = string.sub( name, #v.Name + 1 )
            if v.IsInput[ subname ] then v:TriggerInput( subname, value ) end
        end
    end
end

-- The debugger will call this
function ENT:GetDebugVars()
    -- Train wires
    for i = 1, 99 do
        self.DebugVars[ "TW" .. i ] = self:ReadTrainWire( i )
    end

    -- System variables
    for k, v in pairs( self.Systems ) do
        for _, output in pairs( v.OutputsList or {} ) do
            self.DebugVars[ ( v.Name or "" ) .. output ] = v[ output ] or 0
        end
    end

    -- Speed/acceleration
    self.DebugVars[ "Speed" ] = self.Speed
    self.DebugVars[ "Acceleration" ] = self.Acceleration
    return self.DebugVars
end

--Debugging function, call via the console or something
function ENT:ShowInteractionZones()
    for k, v in pairs( self.InteractionZones ) do
        debugoverlay.Sphere( self:LocalToWorld( v.Pos ), v.Radius, 15, Color( 255, 185, 0 ), true )
    end
end

--------------------------------------------------------------------------------
-- Highspeed interface
--------------------------------------------------------------------------------
-- Initialize highspeed layout
function ENT:InitializeHighspeedLayout()
    --local layout = ""
    self.HighspeedLayout = {}
    for k, v in pairs( Metrostroi.TrainHighspeedInterface ) do
        local offset = v[ 1 ] + 128
        if self.Systems[ v[ 2 ] ] then
            self.HighspeedLayout[ offset ] = function( value )
                if value then
                    self.Systems[ v[ 2 ] ]:TriggerInput( v[ 3 ], value )
                else
                    return self.Systems[ v[ 2 ] ][ v[ 3 ] ] or 0
                end
            end
        end
        --layout = layout.."["..offset.."]\t"..v[2].."."..v[3].."\r\n"
    end
    --file.Write("hs_layout.txt",layout)
    --[[local str = ""
    local offset = 0
    for k,v in SortedPairs(self.Systems) do
        for i=1,#v.InputsList do
            str = str.."{ "..offset..", \""..k.."\", \""..v.InputsList[i].."\" },\r\n"
            offset = offset + 1
        end
        for i=1,#v.OutputsList do
            str = str.."{ "..offset..", \""..k.."\", \""..v.OutputsList[i].."\" },\r\n"
            offset = offset + 1
        end
        str = str..k.."\r\n"
    end
    file.Write("hs_layout3.txt",str)]]
    --
end

function ENT:ChooseTrainWireLeader()
    local key = math.random( 1, #self.WagonList )
    for k, v in ipairs( self.WagonList ) do
        v.TrainWireLeader = key == k
    end
end

function ENT:ElectricConnected( train, isRear )
    if not IsValid( train ) then return end
    local conf = self.SubwayTrain
    if isRear then
        local rT = self.RearTrain
        local rC = rT.SubwayTrain
        if not IsValid( rT ) then return end
        local rTIsFront = rT.FrontTrain == train
        if rTIsFront and rC and rC.NoFrontEKK then return end
        if rC and conf and conf.EKKType ~= rC.EKKType then return end
        if rTIsFront and rT.FrontCoupledBogeyDisconnect or not rTIsFront and rT.RearCoupledBogeyDisconnect or self.RearCoupledBogeyDisconnect then return end
        if not IsValid( self.RearCouple ) or self.RearCouple:ElectricDisconnected() or ( rT.FrontTrain == self and ( not IsValid( rT.FrontCouple ) or rT.FrontCouple:ElectricDisconnected() ) or rT.RearTrain == self and ( not IsValid( rT.RearCouple ) or rT.RearCouple:ElectricDisconnected() ) ) then return end
    else
        local fT = self.FrontTrain
        local fC = fT.SubwayTrain
        if not IsValid( fT ) then return end
        local fTIsFront = fT.FrontTrain == train
        if conf.NoFrontEKK or fTIsFront and fC and fC.NoFrontEKK then return end
        if fC and conf and conf.EKKType ~= fC.EKKType then return end
        if fTIsFront and fT.FrontCoupledBogeyDisconnect or not fTIsFront and fT.RearCoupledBogeyDisconnect or self.FrontCoupledBogeyDisconnect then return end
        if IsValid( self.FrontCouple ) and self.FrontCouple:ElectricDisconnected() or ( fT.FrontTrain == self and ( not IsValid( fT.FrontCouple ) or fT.FrontCouple:ElectricDisconnected() ) or fT.RearTrain == self and ( not IsValid( fT.RearCouple ) or fT.RearCouple:ElectricDisconnected() ) ) then return end
    end
    return true
end

function ENT:UpdateWagonList( selfupdate )
    if self.LastWagonListUpdate == CurTime() then return end
    self.LastUpdate = CurTime()
    -- Populate list of wagons
    self.WagonList = {}
    self.WagonListIDs = {}
    local function populateList( train, checked )
        if IsValid( train ) then
            if checked[ train ] then return end
            checked[ train ] = true
            self.WagonListIDs[ train ] = table.insert( self.WagonList, train )
            local conf = train.SubwayTrain
            local fT = train.FrontTrain
            if IsValid( fT ) then
                local fC = fT.SubwayTrain
                --if not conf.NoFrontEKK and (fT.FrontTrain~=train or not fC.NoFrontEKK) and not train.FrontCoupledBogeyDisconnect and conf.EKKType == fC.EKKType then
                if train:ElectricConnected( fT, false ) then populateList( fT, checked ) end
            end

            local rT = train.RearTrain
            if IsValid( rT ) then
                local rC = rT.SubwayTrain
                --if (rT.FrontTrain~=train or not rC.NoFrontEKK) and not train.RearCoupledBogeyDisconnect and conf.EKKType == rC.EKKType then
                if train:ElectricConnected( rT, true ) then populateList( rT, checked ) end
            end
        end
    end

    populateList( self, {} )
    if selfupdate then return end
    for _, v in pairs( self.WagonList ) do
        if v ~= self then v:UpdateWagonList( true ) end
    end
end

function ENT:ShouldEcho()
    local function GetDimensions()
        -- Get the collision bounds
        local collisionMins, collisionMaxs = self:GetCollisionBounds()
        -- Calculate the dimensions
        local dimensions = collisionMaxs - collisionMins
        -- Print the dimensions
        --print( "Width: ", dimensions.x )
        --print( "Height: ", dimensions.z )
        --print( "Length: ", dimensions.y )
        return dimensions
    end

    local middleX = GetDimensions().x / 2
    local middleZ = GetDimensions().Z / 2
    local trace = util.TraceHull( {
        start = self:LocalToWorld( Vector( middleX, 0, middleZ ) ),
        endpos = self:LocalToWorld( Vector( middleX, 0, middleZ ) ),
        filter = self.TrainEntities,
        mins = Vector( -100, -100, -100 ),
        maxs = Vector( 100, 100, 100 ),
        mask = MASK_PLAYERSOLID
    } )

    if trace.HitWorld and trace.HitPos.z > 100 and trace.HitPos.x > 100 then return true end
    return false
end

function ENT:GetWagonCount()
    return #self.WagonList
end

function ENT:ReadCell( Address )
    if Address < 0 then return nil end
    if Address == 0 then return 1 end
    if ( Address > 0 ) and ( Address < 128 ) then return self:ReadTrainWire( Address ) end
    if self.HighspeedLayout[ Address ] then return self.HighspeedLayout[ Address ]() end
    if ( Address >= 49152 ) and ( Address < 49152 + 8192 ) then
        local x = Address - ( 49152 + 64 )
        local entryID = math.floor( x / 4 )
        local varID = x % 4
        if self.Schedule then
            if entryID >= 0 then
                local entry = self.Schedule[ entryID + 1 ]
                if entry then
                    if varID >= 2 then
                        return ( entry[ varID + 1 ] or 0 ) * 60
                    else
                        return entry[ varID + 1 ] or 0
                    end
                end
            end

            if Address == 49152 then return #self.Schedule end
            if Address == 49153 then return self.Schedule.ScheduleID end
            if Address == 49154 then return self.Schedule.Interval end
            if Address == 49155 then return self.Schedule.Duration end
            if Address == 49156 then return self.Schedule.StartStation end
            if Address == 49157 then return self.Schedule.EndStation end
            if Address == 49158 then return self.Schedule.StartTime * 60 end
            if Address == 49159 then return self.Schedule.EndTime * 60 end
        end

        local pos = UF.TrainPositions[ self ]
        if ( Address >= 49160 ) and ( Address <= 49171 ) and pos and pos[ 1 ] then
            pos = pos[ 1 ]
            -- Get stations
            local current, next, prev = 0, 0, 0
            local cPlatID, nPlatID, pPlatID = 0, 0, 0
            local x1, x2, x3 = 1e9, 0, 1e9
            for stationID, stationData in pairs( UF.Stations ) do
                for platformID, platformData in pairs( stationData ) do
                    if ( platformData.node_start.path == pos.path ) and ( platformData.x_start < pos.x ) and ( platformData.x_end > pos.x ) then
                        current = stationID
                        cPlatID = platformID
                    end

                    if ( platformData.node_start.path == pos.path ) and ( platformData.x_start > pos.x ) then
                        if platformData.x_start < x1 then
                            x1 = platformData.x_start
                            next = stationID
                            nPlatID = platformID
                        end
                    end

                    if ( platformData.node_start.path == pos.path ) and ( platformData.x_start < pos.x ) then
                        if platformData.x_start > x2 then
                            x2 = platformData.x_start
                            prev = stationID
                            pPlatID = platformID
                        end
                    end

                    if ( platformData.node_start.path == pos.path ) and ( platformData.x_end > pos.x ) then
                        if platformData.x_end < x3 then
                            x3 = platformData.x_end
                            next = stationID
                            nPlatID = platformID
                        end
                    end
                end
            end

            if Address == 49160 then return current end
            if Address == 49161 then return next end
            if Address == 49162 then return prev end
            if Address == 49163 then return x1 - pos.x end
            if Address == 49165 then return x3 - pos.x end
            if Address == 49166 then return cPlatID end
            if Address == 49167 then return nPlatID end
            if Address == 49168 then return pPlatID end
            if Address == 49169 then return current > 0 and current or next end
            if Address == 49170 then return cPlatID > 0 and cPlatID or nPlatID end
            if Address == 49170 then return x2 - pos.x end
        end
        return 0
    end

    if ( Address >= 57344 ) and ( Address < 57344 + 4096 ) then
        local x = Address - 57344
        local lineID = math.floor( x / 800 )
        local stationID = math.floor( ( x - lineID * 800 ) / 8 )
        local platformID = math.floor( ( x - lineID * 800 - stationID * 8 ) / 4 )
        local varID = x - lineID * 800 - stationID * 8 - platformID * 4
        local station = UF.Stations[ ( lineID + 1 ) * 100 + stationID ]
        if station then
            local platform = station[ platformID ]
            if platform then
                if varID == 0 then return platform.x_start end
                if varID == 1 then return platform.x_end end
                if varID == 2 then return platform.node_start.path.id end
                if varID == 3 then return 0 end
            end
        end
        return 0
    end

    if ( Address >= 65504 ) and ( Address <= 65510 ) then
        local pos = UF.TrainPositions[ self ]
        if pos and pos[ 1 ] then
            pos = pos[ 1 ]
            if Address == 65504 then return pos.x end
            if Address == 65505 then return pos.y end
            if Address == 65506 then return pos.z end
            if Address == 65507 then return pos.distance end
            if Address == 65508 then return pos.forward and 1 or 0 end
            if Address == 65509 then return pos.node.id end
            if Address == 65510 then return pos.path.id end
        end
        return 0
    end

    if Address == 65535 then
        ---self:UpdateWagonList()
        return #self.WagonList
    end

    if Address >= 65536 then
        local wagonIndex = 1 + math.floor( Address / 65536 )
        local variableAddress = Address % 65536
        ---self:UpdateWagonList()
        if self.WagonList[ wagonIndex ] and IsValid( self.WagonList[ wagonIndex ] ) then
            return self.WagonList[ wagonIndex ]:ReadCell( variableAddress )
        else
            return 0
        end
    end
end

function ENT:WriteCell( Address, value )
    if Address < 0 then return false end
    if Address == 0 then return true end
    if ( Address >= 1 ) and ( Address < 128 ) then
        self.TrainWireOverrides[ Address ] = value > 0 and 1 or nil
        return true
    end

    if self.HighspeedLayout[ Address ] then
        self.HighspeedLayout[ Address ]( value )
        return true
    end

    if ( Address >= 32768 ) and ( Address < ( 32768 + 32 * 24 ) ) then
        local stringID = math.floor( ( Address - 32768 ) / 32 )
        local charID = ( Address - 32768 ) % 32
        local prevStr = self:GetNW2String( "CustomStr" .. stringID )
        local newStr = ""
        for i = 0, 31 do
            local ch = string.byte( prevStr, i + 1 ) or 32
            if i == charID then ch = value end
            newStr = newStr .. ( string.char( ch ) or "?" )
        end

        self:SetNW2String( "CustomStr" .. stringID, newStr )
    end

    if Address == 49164 then if self.Announcer then self.Announcer:Queue( value ) end end
    if Address >= 65536 then
        local wagonIndex = 1 + math.floor( Address / 65536 )
        local variableAddress = Address % 65536
        ---self:UpdateWagonList()
        if self.WagonList[ wagonIndex ] and IsValid( self.WagonList[ wagonIndex ] ) then
            return self.WagonList[ wagonIndex ]:WriteCell( variableAddress, value )
        else
            return false
        end
    end
    return true
end

function ENT:CANWrite( target, targetid, textdata, numdata )
    for i = 1, #self.WagonList do
        local train = self.WagonList[ i ]
        if not targetid or targetid == train:GetWagonNumber() then
            local sys = train[ target ]
            if sys and sys.CANReceive then sys:CANReceive( target, targetid, textdata, numdata, tabledata ) end
            if targetid then return end
        end
    end
end

--------------------------------------------------------------------------------
-- Train wire I/O
--------------------------------------------------------------------------------
function ENT:LeaderReadTrainWire( id )
    if self.TrainWireOverrides[ id ] then return self.TrainWireOverrides[ id ] end
    if self.TrainWireOutside[ id ] then return ( self.TrainWireOutsideFrom[ id ] and ( self.TrainWireTurbostroi[ self.TrainWireOutsideFrom[ id ] ] or 0 ) or 1 ) * self.TrainWireOutside[ id ] end
    return ( self.TrainWireTurbostroi[ id ] or 0 ) + ( self.TrainWireWriters[ id ] or 0 )
end

function ENT:WriteTrainWire( k, v, ignore )
    if not self.TrainWireWritersID[ k ] then self.TrainWireWritersID[ k ] = true end
    self.TrainWireWriters[ k ] = v
end

function ENT:ReadTrainWire( k )
    return self.TrainWires[ k ] or 0
end

function ENT:ResetTrainWires()
    -- Remember old train wires reference
    local trainWires = self.TrainWires
    -- Create new train wires
    self.TrainWires = {}
    self.TrainWireWriters = {}
    -- Initialize train wires to zero values
    for i = 1, 128 do
        self.TrainWires[ i ] = 0
    end
end

--------------------------------------------------------------------------------
-- Coupling logic
--------------------------------------------------------------------------------
function ENT:UpdateIndexes()
    local function updateIndexes( train, checked, newIndex )
        if not train then return end
        if checked[ train ] then return end
        checked[ train ] = true
        train.TrainCoupledIndex = newIndex
        local conf = train.SubwayTrain
        local fT = train.FrontTrain
        if IsValid( fT ) then
            local fC = fT.SubwayTrain
            --if not conf.NoFrontEKK and (fT.FrontTrain~=train or not fC.NoFrontEKK) and not train.FrontCoupledBogeyDisconnect and conf.EKKType == fC.EKKType then
            if train:ElectricConnected( fT, false ) then
                if fT and ( fT.FrontTrain == train ) then
                    updateIndexes( fT, checked, 1 - newIndex )
                else
                    updateIndexes( fT, checked, newIndex )
                end
            end
        end

        local rT = train.RearTrain
        if IsValid( rT ) then
            local rC = rT.SubwayTrain
            --if (rT.FrontTrain~=train or not rC.NoFrontEKK) and not train.RearCoupledBogeyDisconnect and conf.EKKType == rC.EKKType then
            if train:ElectricConnected( rT, true ) then
                if rT and ( rT.RearTrain == train ) then
                    updateIndexes( rT, checked, 1 - newIndex )
                else
                    updateIndexes( rT, checked, newIndex )
                end
            end
        end
    end

    updateIndexes( self, {}, 0 )
end

function ENT:OnConnectDisconnect()
    self:UpdateCoupledTrains()
    --if ((train.FrontTrain == self) or (train.RearTrain == self)) then
    self:UpdateIndexes()
    --end
    self:UpdateWagonList()
    self:ChooseTrainWireLeader()
end

function ENT:OnCouple( bogey, isfront )
    if isfront then
        self.FrontCoupledBogey = bogey
    else
        self.RearCoupledBogey = bogey
    end

    local train = bogey:GetNW2Entity( "TrainEntity" )
    if not IsValid( train ) then return end
    hook.Run( "MetrostroiCoupled", self, train )
    --print(Format("%s(%05d) coupled with %s(%05d)",self,self:GetWagonNumber(),train,train:GetWagonNumber()))
    --Don't update train wires when there's no parent train
    self:OnConnectDisconnect()
    if self.OnCoupled then self:OnCoupled() end
    -- Update train wires
    --[[ if (isfront and self.FrontCoupledBogeyDisconnect) or (not isfront and self.RearCoupledBogeyDisconnect) then
    return
end--]]
    --[[GRAVHULL
if GravHull then
    if IsValid(ent) and self:GetMoveType() == MOVETYPE_VPHYSICS then
        if !GravHull.SHIPS[self] then
            self = self.MyShip or (self.Ghost and self.Ghost.MyShip)
        end
    end
    if IsValid(self) then
        self:GetOwner():ChatPrint("Removed a local physics system.")
        GravHull.UnHull(self)
    end
    
    if !(IsValid(self) and self:GetMoveType() == MOVETYPE_VPHYSICS and !GravHull.HULLS[self]) then return false end
    GravHull.RegisterHull(self,-2,100)
    GravHull.UpdateHull(self)
end
]]
end

function ENT:OnDecouple( isfront )
    --print(self,"Disconnected from front?:" ,isfront)
    if isfront then
        self.FrontCoupledBogey = nil
    else
        self.RearCoupledBogey = nil
    end

    self:OnConnectDisconnect()
    if self.OnDecoupled then self:OnDecoupled() end
end

function ENT:OnBogeyDisconnect( bogey, isfront )
    if isfront then
        self.FrontCoupledBogeyDisconnect = true
    else
        self.RearCoupledBogeyDisconnect = true
    end

    self:OnConnectDisconnect()
end

function ENT:OnBogeyConnect( bogey, isfront )
    --print(self,"Coupled with ",bogey," at ",isfront)
    if isfront then
        self.FrontCoupledBogeyDisconnect = false
    else
        self.RearCoupledBogeyDisconnect = false
    end

    local train = bogey:GetNW2Entity( "TrainEntity" )
    if not IsValid( train ) then return end
    --Don't update train wires when there's no parent train
    self:OnConnectDisconnect()
end

function ENT:UpdateCoupledTrains()
    if self.FrontCoupledBogey then
        self.FrontTrain = self.FrontCoupledBogey:GetNW2Entity( "TrainEntity" )
    else
        self.FrontTrain = nil
    end

    if self.RearCoupledBogey then
        self.RearTrain = self.RearCoupledBogey:GetNW2Entity( "TrainEntity" )
    else
        self.RearTrain = nil
    end
end

function ENT:AddAutodriveCoil( bogey, right )
    -- Create bogey entity
    local coil = right and bogey.CoilR or not right and bogey.CoilL
    if not IsValid( coil ) then
        coil = ents.Create( "gmod_train_autodrive_coil" )
        coil:Spawn()
        if right then
            bogey.CoilR = coil
        else
            bogey.CoilL = coil
        end

        -- Assign ownership
        if CPPI and IsValid( self:CPPIGetOwner() ) then coil:CPPISetOwner( self:CPPIGetOwner() ) end
    end

    if right then
        coil:SetPos( bogey:LocalToWorld( Vector( -54, 70, -30 ) ) )
    else
        coil:SetPos( bogey:LocalToWorld( Vector( -54, -70, -30 ) ) )
    end

    coil:SetAngles( bogey:GetAngles() )
    coil:SetParent( bogey )
    return coil
end

--------------------------------------------------------------------------------
-- Create a couple for the train
--------------------------------------------------------------------------------
function ENT:CreateCouple( pos, ang, forward, typ )
    -- Create bogey entity
    local coupler = ents.Create( "gmod_train_couple" )
    coupler:SetPos( self:LocalToWorld( pos ) )
    coupler:SetAngles( self:GetAngles() + ang )
    coupler.CoupleType = typ
    coupler:Spawn()
    -- Assign ownership
    if CPPI and IsValid( self:CPPIGetOwner() ) then coupler:CPPISetOwner( self:CPPIGetOwner() ) end
    -- Some shared general information about the bogey
    coupler:SetNW2Bool( "IsForwardCoupler", forward )
    coupler:SetNW2Entity( "TrainEntity", self )
    coupler.SpawnPos = pos
    coupler.SpawnAng = ang
    local index = 1
    local x = self:WorldToLocal( coupler:LocalToWorld( coupler.CouplingPointOffset ) ).x
    for i, v in ipairs( self.JointPositions ) do
        if v > pos.x then
            index = i + 1
        else
            break
        end
    end

    table.insert( self.JointPositions, index, x )
    -- Constraint bogey to the train
    if self.NoPhysics then
        coupler:SetParent( self )
    else
        constraint.AdvBallsocket( self, coupler, 0, --bone
            0, --bone
            pos, Vector( 0, 0, 0 ), 1, --forcelimit
            1, --torquelimit
            -2, --xmin
            -2, --ymin
            -15, --zmin
            2, --xmax
            2, --ymax
            15, --zmax
            0.1, --xfric
            0.1, --yfric
            1, --zfric
            0, --rotonly
            1 )

        --nocollide
        if forward and IsValid( self.FrontBogey ) then
            constraint.NoCollide( self.FrontBogey, coupler, 0, 0 )
        elseif not forward and IsValid( self.RearBogey ) then
            constraint.NoCollide( self.RearBogey, coupler, 0, 0 )
        end
        --[[
        constraint.Axis(coupler,self,0,0,
        Vector(0,0,0),Vector(0,0,0),
        0,0,0,1,Vector(0,0,1),false)]]
    end

    -- Add to cleanup list
    table.insert( self.TrainEntities, coupler )
    return coupler
end

--------------------------------------------------------------------------------
-- Create an entity for the seat
--------------------------------------------------------------------------------
function ENT:CreateSeatEntity( seat_info )
    -- Create seat entity
    local seat = ents.Create( "prop_vehicle_prisoner_pod" )
    seat:SetModel( seat_info.model or "models/nova/jeep_seat.mdl" ) --jalopy
    seat:SetPos( self:LocalToWorld( seat_info.offset ) )
    seat:SetAngles( self:GetAngles() + Angle( 0, -90, 0 ) + seat_info.angle )
    seat:SetKeyValue( "limitview", 0 )
    seat:Spawn()
    seat:GetPhysicsObject():SetMass( 10 )
    seat:SetCollisionGroup( COLLISION_GROUP_WORLD )
    self:DrawShadow( false )
    --Assign ownership
    if CPPI and IsValid( self:CPPIGetOwner() ) then seat:CPPISetOwner( self:CPPIGetOwner() ) end
    -- Hide the entity visually
    if seat_info.typ == "passenger" then
        seat:SetColor( Color( 0, 0, 0, 0 ) )
        seat:SetRenderMode( RENDERMODE_TRANSALPHA )
    end

    -- Set some shared information about the seat
    local seats = self:GetNW2Int( "seats", 0 ) + 1
    self:SetNW2Entity( "seat_" .. seats, seat )
    self:SetNW2Int( "seats", seats )
    seat:SetNW2String( "SeatType", seat_info.typ )
    seat:SetNW2Entity( "TrainEntity", self )
    seat_info.entity = seat
    -- Constrain seat to this object
    -- constraint.NoCollide(self,seat,0,0)
    seat:SetParent( self )
    -- Add to cleanup list
    table.insert( self.TrainEntities, seat )
    return seat
end

--------------------------------------------------------------------------------
-- Create a seat position
--------------------------------------------------------------------------------
function ENT:CreateSeat( typ, offset, angle, model )
    -- Add a new seat
    local seat_info = {
        typ = typ,
        offset = offset,
        model = model,
        angle = angle or Angle( 0, 0, 0 ),
    }

    table.insert( self.Seats, seat_info )
    if typ == "driver" then
        print( offset )
        self:SetNW2Vector( "DriversSeatPos", offset )
    end

    -- If needed, create an entity for this seat
    if ( typ == "driver" ) or ( typ == "instructor" ) or ( typ == "passenger" ) then return self:CreateSeatEntity( seat_info ) end
end

-- Returns if KV/reverser wrench is present in cabin
function ENT:IsWrenchPresent()
    if self.DriversWrenchPresent then return true end
    if self.DriversWrenchMissing then return false end
    for k, v in pairs( self.Seats ) do
        if IsValid( v.entity ) and v.entity.GetPassenger and ( ( v.typ == "driver" ) or ( v.typ == "instructor" ) ) then
            local player = v.entity:GetPassenger( 0 )
            if player and player:IsValid() then return true end
        end
    end
    return false
end

function ENT:GetDriver()
    if IsValid( self.DriverSeat ) then
        local ply = self.DriverSeat:GetPassenger( 0 )
        if IsValid( ply ) then return ply end
    end
end

hook.Remove( "SetupPlayerVisibility", "PVSDormantFix", function( ply )
    for _, ent in pairs( ents.FindByClass( "env_*" ) ) do
        if ent.DormantFix then ent:SetPreventTransmit( ply, not ply:TestPVS( ent ) ) end
    end
end )

--------------------------------------------------------------------------------
-- Turn light on or off
--------------------------------------------------------------------------------
function ENT:SetLightPower( index, power, brightness )
    local prevLightData = prevLightData or {}
    local lightData = self.Lights[ index ]
    if not lightData then
        --print( "ERROR! SetLightPower called on unconfigured light index: " .. index )
        return
    end

    self.GlowingLights = self.GlowingLights or {}
    self.LightBrightness = self.LightBrightness or {}
    brightness = brightness or 1
    -- Check if light already glowing
    if ( power and self.GlowingLights[ index ] ) and ( brightness == self.LightBrightness[ index ] ) then return end
    -- If light already glowing and only brightness changed
    if ( power and self.GlowingLights[ index ] ) and ( brightness ~= self.LightBrightness[ index ] ) then
        local light = self.GlowingLights[ index ]
        if ( lightData[ 1 ] == "glow" ) or ( lightData[ 1 ] == "light" ) then
            local brightness = brightness * ( lightData.brightness or 0.5 )
            light:SetKeyValue( "rendercolor", Format( "%i %i %i", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        end

        if lightData[ 1 ] == "headlight" then
            -- Set Brightness
            local brightness = brightness * ( lightData.brightness or 1.25 )
            light:SetKeyValue( "lightcolor", Format( "%i %i %i 255", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        end

        if lightData[ 1 ] == "dynamiclight" then
            --light:SetKeyValue("brightness", brightness * (lightData.brightness or 2))
            light:SetKeyValue( "_light", Format( "%i %i %i", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        end

        self.LightBrightness[ index ] = brightness
        return
    end

    -- Turn off light
    SafeRemoveEntity( self.GlowingLights[ index ] )
    self.GlowingLights[ index ] = nil
    self.LightBrightness[ index ] = brightness
    -- Create light
    if ( lightData[ 1 ] == "headlight" ) and power then
        local light = ents.Create( "env_projectedtexture" )
        light.DormantFix = true
        light:SetTransmitWithParent( true )
        light:SetParent( self )
        light:SetPos( self:LocalToWorld( lightData[ 2 ] ) )
        light:SetAngles( self:LocalToWorldAngles( lightData[ 3 ] ) )
        -- Set parameters
        light:SetKeyValue( "enableshadows", lightData.shadows or 1 )
        light:SetKeyValue( "farz", lightData.farz or 2048 )
        light:SetKeyValue( "nearz", lightData.nearz or 16 )
        light:SetKeyValue( "lightfov", lightData.fov or 120 )
        -- Set Brightness
        local brightness = brightness * ( lightData.brightness or 1.25 )
        light:SetKeyValue( "lightcolor", Format( "%i %i %i 255", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        -- Turn light on
        light:Spawn() --"effects/flashlight/caustics"
        light:Input( "SpotlightTexture", nil, nil, lightData.texture or "effects/flashlight001" )
        self.GlowingLights[ index ] = light
    end

    if ( lightData[ 1 ] == "glow" ) and power then
        local light = ents.Create( "env_sprite" )
        light.DormantFix = true
        light:SetTransmitWithParent( true )
        light:SetParent( self )
        light:SetLocalPos( lightData[ 2 ] )
        light:SetLocalAngles( lightData[ 3 ] )
        -- Set parameters
        local brightness = brightness * ( lightData.brightness or 0.5 )
        light:SetKeyValue( "rendercolor", Format( "%i %i %i", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        light:SetKeyValue( "rendermode", lightData.typ or 3 ) -- 9: WGlow, 3: Glow
        light:SetKeyValue( "renderfx", 14 )
        light:SetKeyValue( "model", lightData.texture or "sprites/glow1.vmt" )
        --      light:SetKeyValue("model", "sprites/light_glow02.vmt")
        --      light:SetKeyValue("model", "sprites/yellowflare.vmt")
        light:SetKeyValue( "scale", lightData.scale or 1.0 )
        light:SetKeyValue( "spawnflags", 1 )
        -- Turn light on
        light:Spawn()
        self.GlowingLights[ index ] = light
    end

    if ( lightData[ 1 ] == "light" ) and power then
        local light = ents.Create( "env_sprite" )
        light.DormantFix = true
        light:SetTransmitWithParent( true )
        light:SetParent( self )
        light:SetLocalPos( lightData[ 2 ] )
        light:SetLocalAngles( lightData[ 3 ] )
        -- Set parameters
        local brightness = brightness * ( lightData.brightness or 0.5 )
        light:SetKeyValue( "rendercolor", Format( "%i %i %i", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        light:SetKeyValue( "rendermode", lightData.typ or 9 ) -- 9: WGlow, 3: Glow
        light:SetKeyValue( "renderfx", 14 )
        --      light:SetKeyValue("model", "sprites/glow1.vmt")
        light:SetKeyValue( "model", lightData.texture or "sprites/light_glow02.vmt" )
        --      light:SetKeyValue("model", "sprites/yellowflare.vmt")
        light:SetKeyValue( "scale", lightData.scale or 1.0 )
        --Size of Glow Proxy Geometry
        light:SetKeyValue( "spawnflags", 1 )
        -- Turn light on
        light:Spawn()
        self.GlowingLights[ index ] = light
    end

    if ( lightData[ 1 ] == "dynamiclight" ) and power then
        local light = ents.Create( "light_dynamic" )
        light:SetParent( self )
        -- Set position
        light:SetLocalPos( lightData[ 2 ] )
        light:SetLocalAngles( lightData[ 3 ] )
        -- Set parameters
        light:SetKeyValue( "_light", Format( "%i %i %i", lightData[ 4 ].r * brightness, lightData[ 4 ].g * brightness, lightData[ 4 ].b * brightness ) )
        light:SetKeyValue( "style", 0 )
        light:SetKeyValue( "distance", lightData.distance or 300 )
        light:SetKeyValue( "brightness", lightData.brightness or 2 )
        -- Turn light on
        light:Spawn()
        light:Fire( "TurnOn", "", "0" )
        self.GlowingLights[ index ] = light
    end
end

--------------------------------------------------------------------------------
-- Joystick input
--------------------------------------------------------------------------------
function ENT:HandleJoystickInput( ply )
    for k, v in pairs( jcon.binds ) do
        if v:GetCategory() == "Metrostroi" then
            local jvalue = Metrostroi.GetJoystickInput( ply, k )
            if ( jvalue ~= nil ) and ( self.JoystickBuffer[ k ] ~= jvalue ) then
                local inputname = Metrostroi.JoystickSystemMap[ k ]
                self.JoystickBuffer[ k ] = jvalue
                if inputname then
                    if typ( jvalue ) == "boolean" then
                        if jvalue then
                            jvalue = 1.0
                        else
                            jvalue = 0.0
                        end
                    end

                    self:TriggerInput( inputname, jvalue )
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Keyboard input
--------------------------------------------------------------------------------
function ENT:IsModifier( key )
    return type( self.KeyMap[ key ] ) == "table"
end

function ENT:HasModifier( key )
    return self.KeyMods[ key ] ~= nil
end

function ENT:GetActiveModifiers( key )
    local tbl = {}
    local mods = self.KeyMods[ key ]
    for k, v in pairs( mods ) do
        if self.KeyBuffer[ k ] ~= nil then table.insert( tbl, k ) end
    end
    return tbl
end

function ENT:OnKeyEvent( key, state, ply, helper )
    if state then
        self:OnKeyPress( key )
    else
        self:OnKeyRelease( key )
    end

    local keyT = self.KeyMap[ key ]
    if self:HasModifier( key ) and not helper then
        --If we have a modifier
        local actmods = self:GetActiveModifiers( key )
        if #actmods > 0 then
            --Modifier is being preseed
            for k, v in pairs( actmods ) do
                if self.KeyMap[ v ][ key ] ~= nil then self:ButtonEvent( self.KeyMap[ v ][ key ], state, ply ) end
            end
            return
        end
    end

    if self:IsModifier( key ) then
        if keyT.helper and ( helper or keyT[ 1 ] ) then
            self:ButtonEvent( helper and keyT.helper or keyT[ 1 ], state, ply )
        elseif not helper then
            if state and keyT.def and not helper then
                self:ButtonEvent( keyT.def, state, ply )
            elseif not state then
                if keyT.def then self:ButtonEvent( keyT.def, state, ply ) end
                for k, v in pairs( keyT ) do
                    self:ButtonEvent( v, false, ply )
                end
            end
        end
    elseif keyT ~= nil and type( keyT ) == "string" and not helper then
        --If we're a regular binded key
        self:ButtonEvent( keyT, state, ply )
    end
end

function ENT:OnKeyPress( key )
end

function ENT:OnKeyRelease( key )
end

function ENT:ProcessKeyMap()
    self.KeyMods = {}
    for mod, v in pairs( self.KeyMap ) do
        if type( v ) == "table" then
            for k, _ in pairs( v ) do
                if not self.KeyMods[ k ] then self.KeyMods[ k ] = {} end
                self.KeyMods[ k ][ mod ] = true
            end
        end
    end
end

local function HandleKeyHook( ply, k, state )
    local train = ply:GetTrain()
    if IsValid( train ) then train.KeyMap[ k ] = state or nil end
end

function ENT:HandleKeyboardInput( ply )
    if not self.KeyMods and self.KeyMap then self:ProcessKeyMap() end
    -- Check for newly pressed keys
    for k, v in pairs( ply.keystate ) do
        if self.KeyBuffer[ k ] == nil then
            self.KeyBuffer[ k ] = true
            self:OnKeyEvent( k, true, ply )
        end
    end

    -- Check for newly released keys
    for k, v in pairs( self.KeyBuffer ) do
        if ply.keystate[ k ] == nil then
            self.KeyBuffer[ k ] = nil
            self:OnKeyEvent( k, false, ply )
        end
    end
end

hook.Add( "PlayerButtonUp", "mplr_button", function( ply, button )
    local train, seat = ply:GetTrain()
    if IsValid( train ) and train.KeyBuffer then
        if train.KeyBuffer[ button ] then
            train.KeyBuffer[ button ] = nil
            train:OnKeyEvent( button, false, ply, train.DriverSeat ~= seat )
        end
    end
end )

hook.Add( "PlayerButtonDown", "mplr_button", function( ply, button )
    local train, seat = ply:GetTrain()
    if IsValid( train ) and train.KeyBuffer then
        if train.KeyBuffer[ button ] == nil then
            train.KeyBuffer[ button ] = true
            train:OnKeyEvent( button, true, ply, train.DriverSeat ~= seat )
        end
    end
end )

function ENT:CreateJointSound( sndnum )
    local jID = self.SpeedSign > 0 and 1 or #self.JointPositions
    table.insert( self.Joints, {
        typ = sndnum,
        state = jID,
        dist = self.JointPositions[ jID ]
    } )
end

--------------------------------------------------------------------------------
-- Process train logic
--------------------------------------------------------------------------------
-- Think and execute systems stuff
local joints = { { 2, 12.5 }, { 3, 25 }, { 3, 50 }, { 2, 75 }, }
function ENT:Think()
    if self.FrontBogey then
        if self.SpeedSign and self.WagonList[ 1 ] == self and ( not self.FrontTrain and self.Speed * self.SpeedSign > 0.25 or not self.RearTrain and self.Speed * self.SpeedSign < -0.25 ) then
            --print(self.FrontBogey.Wheels,self.RearBogey)
            --self.TargetDist
            --self.rep = 0
            --self.rep = nil
            if not self.JointRepeats or self.JointRepeats <= 0 then
                local ch
                repeat
                    ch = math.ceil( math.random() * #joints )
                until ch ~= self.LastJoint

                self.LastJoint = ch
                self.JointDist = joints[ ch ][ 2 ]
                self.JointRepeats = math.floor( math.random( 1, joints[ ch ][ 1 ] ) )
            end

            if not self.CurrentJointDist then self.CurrentJointDist = 0 end
            if self.JointDist then
                self.CurrentJointDist = self.CurrentJointDist + self.DeltaTime * self.Speed * self.SpeedSign / 3.6
                if self.JointRepeats > 0 and ( self.CurrentJointDist > self.JointDist or self.CurrentJointDist < -self.JointDist ) then
                    self.JointRepeats = self.JointRepeats - 1
                    local snd = math.ceil( math.random() * 32 )
                    self:CreateJointSound( snd )
                    self.CurrentJointDist = 0
                end
            end
        end

        --DISTANCES
        --0.774
        --WHEELS:81 2.05 --2.66
        --TRAIN:755 19.17 24.79
        --89 2.26 2.92
        --171 4.34 5.61
        --584 14.83 19.17
        --666 16.91 21.84
        if #self.Joints > 0 then
            local first, last = self.JointPositions[ 1 ], self.JointPositions[ #self.JointPositions ]
            --self.Joints = {}
            for i, j in ipairs( self.Joints ) do
                j.dist = j.dist + self.DeltaTime * ( -self:GetVelocity():Dot( self:GetAngles():Forward() ) )
                local dist = j.dist
                local ch = false
                for iD, jD in ipairs( self.JointPositions ) do
                    if dist < jD and j.state < iD or dist > jD and j.state > iD then
                        --RunConsoleCommand("say",Format("[%d] dist(%.1f)%sjD(%.1f) %d%+d",i,dist,dist>jD and ">" or "<",jD,j.state,j.state>iD and j.state-1 or j.state+1))
                        j.state = iD --j.state>iD and j.state-1 or j.state+1
                        if 1 < iD and iD < #self.JointPositions then
                            ch = iD
                        else
                            if ( iD == 1 and dist > first ) and IsValid( self.FrontTrain ) then
                                self.FrontTrain:CreateJointSound( j.typ )
                            elseif ( iD ~= 1 and dist < last ) and IsValid( self.RearTrain ) then
                                self.RearTrain:CreateJointSound( j.typ )
                            end

                            table.remove( self.Joints, i )
                        end

                        break
                    end
                end

                if ch then self:PlayOnce( ch % 2 > 0 and "a" or "b", "styk", j.typ, math.floor( j.state / 2 ) ) end
            end
        end
    end

    if self.FailSim and self.FailSim.TrainWireFall and self.FailSim.TrainWireFail > 0 then
        self.TrainWireOutside[ self.FailSim.TrainWireFail ] = 1
        if fail then self.FailSim:TriggerInput( "ResetTW" ) end
    end

    self:ScrollThrottle()
    self.PrevTime = self.PrevTime or CurTime()
    self.DeltaTime = CurTime() - self.PrevTime
    self.PrevTime = CurTime()
    -- Calculate train acceleration
    --[[self.PreviousVelocity = self.PreviousVelocity or self:GetVelocity()
    local accelerationVector = 0.01905*(self:GetPhysicsObject():GetVelocity() - self.PreviousVelocity) / self.DeltaTime
    accelerationVector:Rotate(self:GetAngles())
    self:SetTrainAcceleration(accelerationVector)
    self.PreviousVelocity = self:GetVelocity()]]
    --
    -- Get angular velocity
    --self:SetTrainAngularVelocity(math.pi*self:GetPhysicsObject():GetAngleVelocity()/180)
    -- Apply mass of passengers
    if self.NormalMass then self:GetPhysicsObject():SetMass( self.NormalMass + 60 * self:GetNW2Float( "PassengerCount" ) ) end
    if self.AnnouncementToLeaveWagon and self:GetNW2Float( "PassengerCount" ) == 0 then self.AnnouncementToLeaveWagon = false end
    -- Calculate turn information, unused right now
    --[[if self.FrontBogey and self.RearBogey then
    self.BogeyDistance = self.BogeyDistance or self.FrontBogey:GetPos():Distance(self.RearBogey:GetPos())
    local a = math.AngleDifference(self.FrontBogey:GetAngles().y,self.RearBogey:GetAngles().y+180)
    self.TurnRadius = (self.BogeyDistance/2)/math.sin(math.rad(a/2))
    
    -- If we're pretty much going straight, correct massive values
    if math.abs(self.TurnRadius) > 1e4 then
        self.TurnRadius = 0
    end
end]]
    --
    -- Process the keymap for modifiers
    -- TODO: Need a neat way of calling this once after self.KeyMap is populated
    if not self.KeyMods and self.KeyMap then self:ProcessKeyMap() end
    -- Keyboard input is done via PlayerButtonDown/Up hooks that call ENT:OnKeyEvent
    -- Joystick input
    if IsValid( self.DriverSeat ) then
        local ply = self.DriverSeat:GetPassenger( 0 )
        if IsValid( ply ) then
            self.Driver = ply --you'd think this came standard in Metrostroi, but for some reason this isn't stored at all explicitly
            --if self.KeyMap then self:HandleKeyboardInput(ply) end
            if joystick then self:HandleJoystickInput( ply ) end
        else
            self.Driver = "none"
        end
    end

    if Turbostroi and not self.DontAccelerateSimulation then
        -- Run iterations on systems simulation
        local iterationsCount = 1
        if ( not self.Schedule ) or ( iterationsCount ~= self.Schedule.IterationsCount ) then
            self.Schedule = {
                IterationsCount = iterationsCount
            }

            local SystemIterations = {}
            -- Find max number of iterations
            local maxIterations = 0
            for k, v in pairs( self.Systems ) do
                if v.DontAccelerateSimulation then
                    SystemIterations[ k ] = v.SubIterations or 1
                    maxIterations = math.max( maxIterations, v.SubIterations or 1 )
                end
            end

            for iteration = 1, maxIterations do
                self.Schedule[ iteration ] = {}
                -- Populate schedule
                for k, v in pairs( self.Systems ) do
                    if v.DontAccelerateSimulation and ( iteration % ( maxIterations / ( v.SubIterations or 1 ) ) ) == 0 then table.insert( self.Schedule[ iteration ], v ) end
                end
            end
        end

        -- Simulate according to schedule
        for i, s in ipairs( self.Schedule ) do
            for k, v in ipairs( s ) do
                --v:Think(self.DeltaTime / (v.SubIterations or 1)/2,i)
                v:Think( self.DeltaTime / ( v.SubIterations or 1 ), i )
            end
        end
    else
        -- Output all variable values
        for sys_name, system in pairs( self.Systems ) do
            if system.OutputsList and not system.DontAccelerateSimulation then
                local dataCacheSys = self.DataCache[ sys_name ] or {}
                for _, name in pairs( system.OutputsList ) do
                    local value = system[ name ] or 0
                    if dataCacheSys[ name ] ~= value then
                        self:TriggerTurbostroiInput( sys_name, name, value )
                        dataCacheSys[ name ] = value
                    end
                end

                self.DataCache[ sys_name ] = dataCacheSys
            end
        end

        -- Run iterations on systems simulation
        local iterationsCount = 1
        if ( not self.Schedule ) or ( iterationsCount ~= self.Schedule.IterationsCount ) then
            self.Schedule = {
                IterationsCount = iterationsCount
            }

            local SystemIterations = {}
            -- Find max number of iterations
            local maxIterations = 0
            for k, v in pairs( self.Systems ) do
                SystemIterations[ k ] = v.SubIterations or 1
                maxIterations = math.max( maxIterations, SystemIterations[ k ] )
            end

            for iteration = 1, maxIterations do
                self.Schedule[ iteration ] = {}
                -- Populate schedule
                for k, v in pairs( self.Systems ) do
                    if ( iteration % ( maxIterations / SystemIterations[ k ] ) ) == 0 then table.insert( self.Schedule[ iteration ], v ) end
                end
            end
        end

        -- Simulate according to schedule
        for i, s in ipairs( self.Schedule ) do
            for k, v in ipairs( s ) do
                local el = v.FileName:find( "electric" )
                if el then
                    --time = SysTime()
                end

                --if v.DontAccelerateSimulation then
                v:Think( self.DeltaTime / ( v.SubIterations or 1 ), i )
                --[[ else
            v:Think(self.DeltaTime / (v.SubIterations or 1)/2,i)
            v:Think(self.DeltaTime / (v.SubIterations or 1)/2,i)
        end--]]
            end
        end
        --print(1/(SysTime()-time))
        -- Wire outputs
        --local triggerOutput = self.TriggerOutput
    end

    --[[ for k,v in pairs(self.TrainWireTurbostroi) do
self:WriteTrainWire(k,v)
end
-- Write and read train wires
local readTrainWire = self.ReadTrainWire
local writeTrainWire = self.WriteTrainWire
for k,v in pairs(self.TrainWireOverrides) do
    if v > 0 then writeTrainWire(self,k,v,true) end
end
for k,v in pairs(self.TrainWireOutside) do
    if v > 0 then writeTrainWire(self,k,v,true) end
end--]]
    if self.TrainWireLeader then
        if #self.WagonList == 1 then
            for twID in pairs( self.TrainWireWritersID ) do
                self.TrainWires[ twID ] = self:LeaderReadTrainWire( twID )
            end
        else
            local wires = {}
            for i, train in ipairs( self.WagonList ) do
                local inv = train.TrainCoupledIndex ~= self.TrainCoupledIndex
                for twID in pairs( train.TrainWireWritersID ) do
                    local target = twID
                    if inv then
                        for a, b in pairs( train.TrainWireCrossConnections ) do
                            if target == a then
                                target = b
                            elseif target == b then
                                target = a
                            end
                        end
                    end

                    local twVal = train:LeaderReadTrainWire( target )
                    if train.TrainWireInverts[ twID ] or wires[ twID ] == true then
                        if twVal <= 0 then
                            wires[ twID ] = true
                        elseif not wires[ twID ] or wires[ twID ] ~= true then
                            wires[ twID ] = ( wires[ twID ] or 0 ) + twVal
                        end
                    else
                        wires[ twID ] = ( wires[ twID ] or 0 ) + twVal
                    end
                end
            end

            local TrainCount = #self.WagonList
            for i, train in ipairs( self.WagonList ) do
                local inv = train.TrainCoupledIndex ~= self.TrainCoupledIndex
                for twID in pairs( wires ) do
                    local target = twID
                    if inv then
                        for a, b in pairs( train.TrainWireCrossConnections ) do
                            if target == a then
                                target = b
                            elseif target == b then
                                target = a
                            end
                        end
                    end

                    if wires[ twID ] == true then
                        train.TrainWires[ target ] = 0
                    else
                        train.TrainWires[ target ] = wires[ twID ]
                    end
                end
            end
        end
    end

    -- Calculate own speed and acceleration
    local speed, acceleration = 0, 0
    if IsValid( self.FrontBogey ) and IsValid( self.RearBogey ) and not self.IgnoreEngine then
        self.Speed = ( self.FrontBogey.Speed + self.RearBogey.Speed ) / 2
        self.SpeedSign = self.FrontBogey.SpeedSign or 1
        self.Acceleration = ( self.FrontBogey.Acceleration + self.RearBogey.Acceleration ) / 2
    else
        self.Acceleration = 0
        self.Speed = 0
        self.SpeedSign = 0
    end

    if self.Plombs and self.Plombs.Init then
        for k, v in pairs( self.Plombs ) do
            if k == "Init" then continue end
            if self.Plombs.Init then
                --self[k]:TriggerInput("Reset",true)
                self[ k ]:TriggerInput( "Block", true )
            end

            if type( v ) == "table" then
                self:SetPackedBool( k .. "Pl", v[ 1 ] )
            else
                self:SetPackedBool( k .. "Pl", v )
            end
        end

        self.Plombs.Init = nil
    end

    if self.Electric and self.Electric.Overheat1 then
        -- Draw overheat of the engines FIXME
        local smoke_intensity = self.Electric.Overheat1 * ( ( self.Electric.T1 - 200 ) / 400 ) or self.Electric.Overheat2 * ( ( self.Electric.T2 - 200 ) / 400 ) or 0
        -- Generate smoke
        self.PrevSmokeTime = self.PrevSmokeTime or CurTime()
        if ( smoke_intensity > 0.0 ) and ( CurTime() - self.PrevSmokeTime > 0.5 + 4.0 * ( 1 - smoke_intensity ) ) then
            self.PrevSmokeTime = CurTime()
            ParticleEffect( "generic_smoke", self:LocalToWorld( Vector( 100 * math.random(), 40, -80 ) ), Angle( 0, 0, 0 ), self )
        end
    end

    if ( not self.SpritesTimer or CurTime() - self.SpritesTimer > 1 ) and self.GlowingLights then
        for _, ply in ipairs( player.GetAll() ) do
            local inPVS = self:TestPVS( ply )
            for _, light in pairs( self.GlowingLights ) do
                light:SetPreventTransmit( ply, not inPVS )
            end
        end

        self.SpritesTimer = CurTime()
    end

    --[[
-- Update speed and acceleration
self.Speed = speed
self.Acceleration = acceleration
]]
    --[[
if(self.DriverSeat and IsValid(self.DriverSeat)) then
    if not self.DriverSeatPos then self.DriverSeatPos = self.DriverSeat:GetPos() end
    if self:GetDriver() then
        self.HeadAcceleration = math.Clamp((self.HeadAcceleration or 0)*0.95 + ((self.OldSpeed or 0) - self.Speed)*1.1, -10, 10)
        self.DriverSeat:SetPos(self.DriverSeatPos + Vector(math.Round(self.HeadAcceleration,2),0,0))
    elseif self.DriverSeat:GetPos() ~= self.DriverSeatPos then
        self.DriverSeat:SetPos(self.DriverSeatPos)
        self.HeadAcceleration = 0
    end
end
self.OldSpeed = self.Speed]]
    -- Go to next think
    self:SetNW2Float( "Accel", math.Round( ( self.OldSpeed or 0 ) - ( self.Speed or 0 ) * ( self.SpeedSign or 0 ), 2 ) )
    self:SetNW2Float( "TrainSpeed", self.Speed )
    self.OldSpeed = ( self.Speed or 0 ) * ( self.SpeedSign or 0 )
    for k, v in pairs( self.CustomThinks ) do
        if k ~= "BaseClass" then v( self ) end
    end

    self:NextThink( CurTime() + 0.05 )
    return true
end

function ENT:TriggerTurbostroiInput( sys, name, val )
    if name == "Value" then
        -- Autosend values to client
        if self.SyncTable and table.HasValue( self.SyncTable, sys ) then self:SetPackedBool( sys, val > 0 ) end
    end
end

--------------------------------------------------------------------------------
-- Default spawn function
--------------------------------------------------------------------------------
function ENT:SpawnFunction( ply, tr, className, rotate, func )
    --MaxTrains limit
    if self.ClassName ~= "gmod_subway_mplr_base" and not self.NoTrain then
        local Limit1 = math.min( 2, C_MaxWagons:GetInt() ) * C_MaxTrainsOnPly:GetInt() - 1
        local Limit2 = math.max( 0, C_MaxWagons:GetInt() - 2 ) * C_MaxTrainsOnPly:GetInt() - 1
        if UF.TrainCount() > C_MaxTrains:GetInt() * C_MaxWagons:GetInt() - 1 then
            ply:LimitHit( "train_limit" )
            --Metrostroi.LimitMessage(ply)
            return
        end

        if UF.TrainCountOnPlayer( ply ) > C_MaxWagons:GetInt() * C_MaxTrainsOnPly:GetInt() - 1 then
            ply:LimitHit( "train_limit" )
            --Metrostroi.LimitMessage(ply)
            return
        end

        if self.SubwayTrain and self.SubwayTrain.WagType == 1 then
            if UF.TrainCountOnPlayer( ply, 1 ) > Limit1 then
                ply:LimitHit( "train_limit" )
                --Metrostroi.LimitMessage(ply)
                return
            end
        elseif self.SubwayTrain and self.SubwayTrain.WagType == 2 then
            if UF.TrainCountOnPlayer( ply, 2 ) > Limit2 then
                ply:LimitHit( "train_limit" )
                --Metrostroi.LimitMessage(ply)
                return
            end
            --elseif self.ClassName:find("tatra") then
        end
    end

    local verticaloffset = 5 -- Offset for the train model
    local distancecap = 2000 -- When to ignore hitpos and spawn at set distanace
    local pos, ang = nil
    local inhibitrerail = false
    if func then
        pos, ang = func( ply )
        --TODO: Make this work better for raw base ent
    elseif tr.Hit and self.NoTrain then
        -- Regular spawn
        if tr.HitPos:Distance( tr.StartPos ) > distancecap then
            -- Spawnpos is far away, put it at distancecap instead
            pos = tr.StartPos + tr.Normal * distancecap
        else
            -- Spawn is near
            pos = tr.HitPos + tr.HitNormal * verticaloffset
        end

        ang = Angle( 0, tr.Normal:Angle().y, 0 )
    elseif tr.Hit and not self.NoTrain then
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

    local ent = ents.Create( className or self.ClassName )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    if rotate then ent:SetAngles( ent:LocalToWorldAngles( Angle( 0, 180, 0 ) ) ) end
    ent.Owner = ply
    ent:Spawn()
    ent:Activate()
    if not inhibitrerail then inhibitrerail = not Metrostroi.RerailTrain( ent ) end
    if rotate and inhibitrerail then
        ent:Remove()
        return false
    end
    -- Debug mode
    --Metrostroi.DebugTrain(ent,ply)
    return ent
end

function ENT:HackButtonPress( button ) --fixme: not sure if this is the way to go, but for now it works!
    local p = self.Panel
    local button3 = string.gsub( button, "Set", "" )
    if p[ button3 ] then p[ button3 ] = 1 end
end

function ENT:HackButtonRelease( button )
    local p = self.Panel
    local button3 = string.gsub( button, "Set", "" )
    if p[ button3 ] then p[ button3 ] = 0 end
end

function ENT:ToggleButton( button )
    button2 = string.gsub( button, "Toggle", "" )
    print( button2, self.Panel[ button2 ] )
    if not self.Panel[ button2 ] then return end
    if self.Panel[ button2 ] < 1 then
        self.Panel[ button2 ] = 1
    elseif self.Panel[ button2 ] > 0 then
        self.Panel[ button2 ] = 0
    end
end

--------------------------------------------------------------------------------
-- Process Cabin button and keyboard input
--------------------------------------------------------------------------------
function ENT:OnButtonPress( button, ply )
end

function ENT:OnButtonRelease( button )
end

-- Clears the serverside keybuffer and fires events
function ENT:ClearKeyBuffer( helper )
    for k, v in pairs( self.KeyBuffer ) do
        local button = self.KeyMap[ k ]
        if button ~= nil then
            if helper then
                if type( button ) == "table" and button.helper then self:ButtonEvent( button.helper, false ) end
            elseif type( button ) == "string" then
                self:ButtonEvent( button, false )
            else
                --Check modifiers as well
                for k2, v2 in pairs( button ) do
                    self:ButtonEvent( v2, false )
                end
            end
        end
    end

    self.KeyBuffer = {}
end

local function ShouldWriteToBuffer( buffer, state )
    if state == nil then return false end
    if state == false and buffer == nil then return false end
    return true
end

local function ShouldFireEvents( buffer, state )
    if state == nil then return true end
    if buffer == nil and state == false then return false end
    return state ~= buffer
end

-- Checks a button with the buffer and calls
-- OnButtonPress/Release as well as TriggerInput
function ENT:ButtonEvent( button, state, ply )
    if ShouldFireEvents( self.ButtonBuffer[ button ], state ) then
        if state == false and not self:OnButtonRelease( button, ply ) then
            self:TriggerInput( button, 0.0 )
        elseif state ~= false and not self:OnButtonPress( button, ply ) then
            self:TriggerInput( button, 1.0 )
            if self.Plombs and button:sub( -2, -1 ) == "Pl" and self.Plombs[ button:sub( 1, -3 ) ] then
                local plomb = self.Plombs[ button:sub( 1, -3 ) ]
                self:BrokePlomb( button:sub( 1, -3 ), ply )
                if type( plomb ) == "table" then
                    for i = 2, #plomb do
                        self:BrokePlomb( plomb[ i ], ply, i > 1 )
                    end
                end

                self:PlayOnce( "plomb", "cabin", 0.7 )
            end
        end
    end

    if ShouldWriteToBuffer( self.ButtonBuffer[ button ], state ) then self.ButtonBuffer[ button ] = state end
end

--------------------------------------------------------------------------------
-- Handle cabin buttons
--------------------------------------------------------------------------------
-- Receiver for CS buttons, Checks if people are the legit driver and calls buttonevent on the train
net.Receive( "mplr-mouse-move", function( len, ply )
    local train = net.ReadEntity()
    if not IsValid( train ) then return end
    if train.CursorMove then
        local sys = net.ReadString()
        local dX = net.ReadFloat()
        local dY = net.ReadFloat()
        train:CursorMove( sys, dX, dY )
    end
end )

net.Receive( "mplr-cabin-button", function( len, ply )
    local train = net.ReadEntity()
    local button = net.ReadString()
    local eventtype = net.ReadBit()
    local seat = ply:GetVehicle()
    local outside = net.ReadBool()
    if outside then
        if not IsValid( train ) then return end
        if outside and ( train.CPPICanPickup and not train:CPPICanPickup( ply ) ) then return end
        if not outside and ply ~= train.DriverSeat.lastDriver then return end
        if not outside and train.DriverSeat.lastDriverTime and ( CurTime() - train.DriverSeat.lastDriverTime ) > 1 then return end
    else
        if not IsValid( train ) then return end
        if ( seat ~= train.DriverSeat ) and ( seat ~= train.InstructorsSeat ) and ( train.CPPICanPhysgun and not train:CPPICanPhysgun( ply ) ) and not button:find( "Door" ) then return end
    end

    train:ButtonEvent( button, eventtype > 0, ply )
end )

-- Receiver for panel touchs, Checks if people are the legit driver and calls buttonevent on the train
net.Receive( "mplr-panel-touch", function( len, ply )
    local panel = net.ReadString()
    local x = net.ReadUInt( 11 )
    local y = net.ReadUInt( 11 )
    local outside = net.ReadBool()
    local state = net.ReadBool()
    local seat = ply:GetVehicle()
    local train
    if seat and IsValid( seat ) and not outside then
        -- Player currently driving
        train = seat:GetNW2Entity( "TrainEntity" )
        if ( not train ) or ( not train:IsValid() ) then return end
        if ( seat ~= train.DriverSeat ) and ( seat ~= train.InstructorsSeat ) and ( not train.CPPICanPhysgun or not train:CPPICanPhysgun( ply ) ) then return end
    else
        -- Player not driving, check recent train
        train = IsValid( ply.lastVehicleDriven ) and ply.lastVehicleDriven:GetNW2Entity( "TrainEntity" ) or NULL
        if outside then
            local trace = util.TraceLine( {
                start = ply:EyePos(),
                endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100,
                filter = function( ent ) if ent:GetClass():find( "subway" ) then return true end end
            } )

            train = trace.Entity
        end

        if not IsValid( train ) then return end
        if outside and train.CPPICanPickup and not train:CPPICanPickup( ply ) then return end
        if not outside and ply ~= train.DriverSeat.lastDriver then return end
        if not outside and train.DriverSeat.lastDriverTime and ( CurTime() - train.DriverSeat.lastDriverTime ) > 1 then return end
    end

    if panel == "" and train.PanelTouch then
        train:PanelTouch( state, x, y )
        return
    end

    if panel ~= "" and not train[ panel ] then
        print( "Metrostroi:System not found," .. panel )
        return
    end

    if panel ~= "" and not train[ panel ].Touch then
        print( "Metrostroi:Touch function not found in system " .. panel )
        return
    end

    if panel ~= "" then
        train[ panel ]:Touch( state, x, y )
    else
        train:Touch( state, x, y )
    end
end )

-- Denies entry if player recently sat in the same train seat
-- This prevents getting stuck in seats when trying to exit
local function CanPlayerEnter( ply, vec, role )
    local train = vec:GetNW2Entity( "TrainEntity" )
    if IsValid( train ) and IsValid( ply.lastVehicleDriven ) and ply.lastVehicleDriven.lastDriverTime ~= nil then if CurTime() - ply.lastVehicleDriven.lastDriverTime < 1 then return false end end
end

-- Exiting player hook, stores some vars and moves player if vehicle was train seat
local function HandleExitingPlayer( ply, vehicle )
    vehicle.lastDriver = ply
    vehicle.lastDriverTime = CurTime()
    ply.lastVehicleDriven = vehicle
    local train = vehicle:GetNW2Entity( "TrainEntity" )
    if IsValid( train ) then
        ply.lastTrain = train
        ply.lastTrainSeat = vehicle
        -- Move exiting player
        local seattype = vehicle:GetNW2String( "SeatType" )
        local offset
        if seattype == "driver" then
            offset = Vector( -5, 10, -17 )
        elseif seattype == "instructor" then
            offset = Vector( 5, -10, -17 )
        elseif seattype == "passenger" then
            offset = Vector( 10, 0, -17 )
        end

        offset:Rotate( train:GetAngles() )
        ply:SetPos( vehicle:GetPos() + offset )
        ply:SetEyeAngles( vehicle:GetForward():Angle() )
        -- Server
        train:ClearKeyBuffer( seattype )
        -- Client
        net.Start( "mplr-cabin-reset" )
        net.WriteEntity( train )
        net.Send( ply )
    end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_PVS
end

--------------------------------------------------------------------------------
-- Register joystick buttons
-- Won't get called if joystick isn't installed
-- I've put it here for now, trains will likely share these inputs anyway
local function JoystickRegister()
    Metrostroi.RegisterJoystickInput( "met_controller", true, "Controller", -3, 3 )
    Metrostroi.RegisterJoystickInput( "met_reverser", true, "Reverser", -1, 1 )
    Metrostroi.RegisterJoystickInput( "met_pneubrake", true, "Pneumatic Brake", 1, 5 )
    Metrostroi.RegisterJoystickInput( "met_headlight", false, "Headlight Toggle" )
    --  Metrostroi.RegisterJoystickInput("met_reverserup",false,"Reverser Up")
    --  Metrostroi.RegisterJoystickInput("met_reverserdown",false,"Reverser Down")
    --  Will make this somewhat better later
    --  Uncommenting these somehow makes the joystick addon crap itself
    Metrostroi.JoystickSystemMap[ "met_controller" ] = "KVControllerSet"
    Metrostroi.JoystickSystemMap[ "met_reverser" ] = "KVReverserSet"
    Metrostroi.JoystickSystemMap[ "met_pneubrake" ] = "PneumaticBrakeSet"
    Metrostroi.JoystickSystemMap[ "met_headlight" ] = "HeadLightsToggle"
    --  Metrostroi.JoystickSystemMap["met_reverserup"] = "KVReverserUp"
    --  Metrostroi.JoystickSystemMap["met_reverserdown"] = "KVReverserDown"
end

hook.Add( "JoystickInitialize", "mplr_cabin", JoystickRegister )
function ENT:BrokePlomb( but, ply, nosnd )
    if ply then
        local nomsg, noplomb = hook.Run( "MPLRPlombBroken", self, but, ply )
        if noplomb then return end
        if not nosnd and not nomsg then RunConsoleCommand( "say", ply:GetName() .. " broke seal on " .. but .. "!" ) end
    end

    self[ but ]:TriggerInput( "Block", false )
    self.Plombs[ but ] = false
    self:SetPackedBool( but .. "Pl", false )
end

--------------------------------------------------------------------------------
-- Common functions
--------------------------------------------------------------------------------
local types = {
    Texture = "train",
    PassTexture = "pass",
    CabTexture = "cab"
}

function ENT:FindFineSkin()
    if not self.SkinsType then return end
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
    local texture = Metrostroi.Skins[ "train" ][ self:GetNW2String( "Texture" ) ]
    local passtexture = Metrostroi.Skins[ "pass" ][ self:GetNW2String( "PassTexture" ) ]
    local cabintexture = Metrostroi.Skins[ "cab" ][ self:GetNW2String( "CabTexture" ) ]
    if texture and texture.func then self:SetNW2String( "Texture", texture.func( self ) ) end
    if passtexture and passtexture.func then self:SetNW2String( "PassTexture", passtexture.func( self ) ) end
    if cabintexture and cabintexture.func then self:SetNW2String( "CabTexture", cabintexture.func( self ) ) end
    self.Texture = self:GetNW2String( "Texture" )
    self.PassTexture = self:GetNW2String( "PassTexture" )
    self.CabTexture = self:GetNW2String( "CabTexture" )
    local texture = Metrostroi.Skins[ "train" ][ self.Texture ]
    local passtexture = Metrostroi.Skins[ "pass" ][ self.PassTexture ]
    local cabintexture = Metrostroi.Skins[ "cab" ][ self.CabTexture ]
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

        if cabintexture and cabintexture.textures and cabintexture.textures[ tex ] then self:SetSubMaterial( k - 1, cabintexture.textures[ tex ] ) end
        if passtexture and passtexture.textures and passtexture.textures[ tex ] then self:SetSubMaterial( k - 1, passtexture.textures[ tex ] ) end
        if texture and texture.textures and texture.textures[ tex ] then self:SetSubMaterial( k - 1, texture.textures[ tex ] ) end
    end

    if texture and texture.postfunc then texture.postfunc( self ) end
    if passtexture and passtexture.postfunc then passtexture.postfunc( self ) end
    if cabintexture and cabintexture.postfunc then cabintexture.postfunc( self ) end
    local level = math.random() > 0.95 and 0.7 or math.random() > 0.8 and 0.55 or math.random() > 0.35 and 0.25 or 0
    self:SetNW2Vector( "DirtLevel", math.Clamp( level + math.random() * 0.2 - 0.1, 0, 1 ) )
    if IsValid( self.SectionB ) then
        self.SectionB:SetNW2String( "Texture", self:GetNW2String( "Texture" ) )
        self.SectionB:UpdateTexturesA()
    end

    if IsValid( self.SectionA ) then
        self.SectionA:SetNW2String( "Texture", self:GetNW2String( "Texture" ) )
        self.SectionA:UpdateTexturesA()
    end

    if IsValid( self.MiddleBogey ) then
        self.MiddleBogey:SetNW2String( "Texture", self:GetNW2String( "Texture" ) )
        self.MiddleBogey:UpdateTextures()
    end

    if IsValid( self.MiddleBoge1 ) then
        self.MiddleBogey1:SetNW2String( "Texture", self:GetNW2String( "Texture" ) )
        self.MiddleBogey1:UpdateTextures()
    end

    if IsValid( self.MiddleBogey2 ) then
        self.MiddleBogey2:SetNW2String( "Texture", self:GetNW2String( "Texture" ) )
        self.MiddleBogey2:UpdateTextures()
    end
end

function ENT:UpdateTexturesA()
    local texture = Metrostroi.Skins[ "train" ][ self:GetNW2String( "Texture" ) ]
    local passtexture = Metrostroi.Skins[ "pass" ][ self:GetNW2String( "PassTexture" ) ]
    local cabintexture = Metrostroi.Skins[ "cab" ][ self:GetNW2String( "CabTexture" ) ]
    if texture and texture.func then self:SetNW2String( "Texture", texture.func( self ) ) end
    if passtexture and passtexture.func then self:SetNW2String( "PassTexture", passtexture.func( self ) ) end
    if cabintexture and cabintexture.func then self:SetNW2String( "CabTexture", cabintexture.func( self ) ) end
    self.Texture = self:GetNW2String( "Texture" )
    self.PassTexture = self:GetNW2String( "PassTexture" )
    self.CabTexture = self:GetNW2String( "CabTexture" )
    local texture = Metrostroi.Skins[ "train" ][ self.Texture ]
    local passtexture = Metrostroi.Skins[ "pass" ][ self.PassTexture ]
    local cabintexture = Metrostroi.Skins[ "cab" ][ self.CabTexture ]
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

        if cabintexture and cabintexture.textures and cabintexture.textures[ tex ] then self:SetSubMaterial( k - 1, cabintexture.textures[ tex ] ) end
        if passtexture and passtexture.textures and passtexture.textures[ tex ] then self:SetSubMaterial( k - 1, passtexture.textures[ tex ] ) end
        if texture and texture.textures and texture.textures[ tex ] then self:SetSubMaterial( k - 1, texture.textures[ tex ] ) end
    end

    if texture and texture.postfunc then texture.postfunc( self ) end
    if passtexture and passtexture.postfunc then passtexture.postfunc( self ) end
    if cabintexture and cabintexture.postfunc then cabintexture.postfunc( self ) end
    local level = math.random() > 0.95 and 0.7 or math.random() > 0.8 and 0.55 or math.random() > 0.35 and 0.25 or 0
    self:SetNW2Vector( "DirtLevel", math.Clamp( level + math.random() * 0.2 - 0.1, 0, 1 ) )
end

function ENT:GenerateWagonNumber( func )
    if self.NumberRanges then
        self.WagonNumber, self.WagonNumberConf = Metrostroi.GenerateNumber( self, self.NumberRanges, func )
        if self.WagonNumber then self:SetNW2Int( "WagonNumber", self.WagonNumber ) end
        self:UpdateWagonNumber()
    end
end

function ENT:UpdateWagonNumber()
end

function ENT:CANBus( targetSys, data )
    local wagonList = self.WagonList
    if not targetSys then
        for _, v in ipairs( wagonList ) do
            v:CANReceive( data )
        end
    else
        for _, v in ipairs( wagonList ) do
            v[ targetSys ]:CANReceive( data )
        end
    end
end

function ENT:CANReceive( data )
    if not data then return end
    if type( data ) == "table" then
        for k, v in pairs( data ) do
            self[ k ] = v
        end
    end
end

if game.SinglePlayer() then
    util.AddNetworkString( "PlayerButtonDown_mplr" )
    util.AddNetworkString( "PlayerButtonUp_mplr" )
    hook.Add( "PlayerButtonDown", "mplr_button", function( ply, button )
        if not IsFirstTimePredicted() then return end
        net.Start( "PlayerButtonDown_mplr" )
        net.WriteUInt( button, 16 )
        net.Send( ply )
    end )

    hook.Add( "PlayerButtonUp", "mplr_button", function( ply, button )
        if not IsFirstTimePredicted() then return end
        net.Start( "PlayerButtonUp_mplr" )
        net.WriteUInt( button, 16 )
        net.Send( ply )
    end )
end

util.AddNetworkString( "MouseWheelAnalog" )
net.Receive( "MouseWheelAnalog", function()
    local ent = net.ReadEntity()
    if not ent then return end
    local mThrottle = net.ReadFloat()
    local entType = string.match( ent:GetClass(), "section_a" ) == "section_a" and "a" or "b"
    if entType == "a" then
        ent.CoreSys.ThrottleMouseRateA = mThrottle
    elseif entType == "b" and ent.SectionA then
        ent.SectionA.CoreSys.ThrottleMouseRateB = mThrottle
    end
end )

function ENT:Wipe( speed )
    local dT = self.DeltaTime > 0 and self.DeltaTime or 1
    local factor = speed == 1 and 0.05 or speed == 2 and 0.25 or speed == 3 and 0.45
    if not factor or factor == 0 then return end
    local function wipeOnce( dT, factor )
        local wipeDown = self.WipeDown
        if self.WiperState < 1 and not self.WipeDown then
            self.WiperState = self.WiperState + factor * dT
            self.WiperState = math.Clamp( self.WiperState, 0, 1 )
        elseif self.WiperState == 1 and not self.WipeDown then
            self.WipeDown = true
        elseif self.WiperState > 0 and self.WipeDown then
            self.WiperState = self.WiperState - factor * dT
            self.WiperState = math.Clamp( self.WiperState, 0, 1 )
        elseif self.WiperState == 0 and wipeDown then
            self.WipeDown = false
            return true
        end
    end

    if ( speed < 1 or not speed ) and self.WiperState > 0 then
        self.WiperState = self.WiperState - factor * dT
        self.WiperState = math.Clamp( self.WiperState, 0, 1 )
    elseif ( speed < 1 or not speed ) and self.WiperState == 0 then
        return
    end

    if speed == 1 then
        if not self.Wiped then
            self.Wiped = wipeOnce( dT, factor )
            self.WipeInterval = CurTime()
        elseif self.Wiped and self.WipeInterval and CurTime() - self.WipeInterval > 5 or not self.WipeInterval then
            self.Wiped = false
        end
    elseif speed == 2 then
        if not self.Wiped then
            self.Wiped = wipeOnce( dT, factor )
        elseif self.Wiped then
            self.Wiped = false
        end
    elseif speed == 3 then
        if not self.Wiped then
            self.Wiped = wipeOnce( dT, factor )
        elseif self.Wiped then
            self.Wiped = false
        end
    end

    self:SetNW2Float( "WiperState", self.WiperState )
end