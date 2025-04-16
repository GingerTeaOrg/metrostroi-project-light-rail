AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "flux.lua" )
include( "shared.lua" )
util.AddNetworkString"mplr-signal"
util.AddNetworkString"mplr-signal-state"
function ENT:Initialize()
    self.SignalType = self.SignalType or self.SignalTypes[ "Underground_Small_Pole" ]
    print( self.SignalType )
    self.Aspect = "Sh3d"
    self:SetNW2String( "Type", self.SignalType )
    self:SetNW2String( "Aspect", self.Aspect )
    self.Angle = self.Angle or Angle( 0, 0, 0 )
    self:SetNW2Angle( "WorldAngle", self.Angle )
    self:SetModel( "models/props_trainstation/payphone_reciever001a.mdl" )
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetColor( Color( 0, 0, 0, 0 ) )
    self.TrackPosition = Metrostroi.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
    self.Node = self.TrackPosition.node1
    self.SpeedLimit = 0
    self.Left = self.Left or false
    self.Name1 = self.Name1 or " "
    self.Name2 = self.Name2 or " "
    self.Routes = self.Routes or {}
    if self.Name1 and self.Name1 ~= " " then self:SetNW2String( "Name1", self.Name1 ) end
    if self.Name2 and self.Name2 ~= " " then self:SetNW2String( "Name2", self.Name2 ) end
    self.LastPVSTracking = 0
end

util.AddNetworkString( "RespawnSignal" )
function ENT:UpdateSignalAspect()
    for k, _ in pairs( UF.SignalBlocks ) do
        local CurrentBlock = UF.SignalBlocks[ k ]
        local function GetSignals()
            for ky, val in pairs( CurrentBlock ) do
                if type( ky ) == "string" then return ky, val end
            end
        end

        local CurrentSignal, DistantSignal = GetSignals()
        if CurrentSignal ~= self.Name then continue end
        local _, DistantSignalEnt = Metrostroi.SignalEntitiesByName[ CurrentSignal ], Metrostroi.SignalEntitiesByName[ DistantSignal ]
        if not IsValid( DistantSignalEnt ) then
            self.Aspect = "Sh3d"
            return
        end

        local DistantAspect = DistantSignalEnt.Aspect
        self.Occupied = CurrentBlock.Occupied
        local Occupied = self.Occupied
        --print(self.Name,self.Aspect,self.Occupied,self.TrackPosition.forward)
        if not Occupied then
            if DistantAspect == "H0" then --if next signal is danger, we display caution
                self.Aspect = "H2"
            elseif DistantAspect == "H2" then
                --if next signal is caution, we can display clear
                self.Aspect = "H1"
            elseif DistantAspect == "H1" then
                --if next signal is clear, we're also clear
                self.Aspect = "H1"
            end
        elseif Occupied then
            self.Aspect = "H0"
        end
    end
end

function ENT:OnRemove()
    UF.UpdateSignalEntities()
end

function ENT:GetMaxARS() --for compatibility reasons, we need to maintain the original function name. That doesn't mean we can't make a proxy with a more memorable name.
    return self:GetSpeedLimit()
end

function ENT:GetSpeedLimit()
end

function ENT:Think()
    print( "thinking" )
    --self:UpdateSignalAspect()
    self:SetNW2String( "Type", self.SignalType )
    self:SetNW2String( "Aspect", self.Aspect )
    self:PVSTracking()
    self:NextThink( CurTime() + 1 )
    return true
end

function ENT:PVSTracking()
    print( "pvstracking" )
    if CurTime() - self.LastPVSTracking > 1 then return end
    local rF = RecipientFilter( false ) -- TODO: test if this needs to be reliable or unreliable
    local pvsTab = next( pvsTab ) and pvsTab or {}
    local plyTab = player.GetAll()
    for _, ply in ipairs( plyTab ) do
        pvsTab[ ply ] = self:TestPVS( ply )
    end

    for ply, bool in pairs( pvsTab ) do
        if bool then rF:AddPlayer( ply ) end
    end

    net.Start( "RespawnSignal" )
    net.WriteBool( true )
    net.Send( rF )
    self.LastPVSTracking = CurTime()
end

--Net functions
--Send update, if parameters have been changed
function ENT:SendUpdate( ply )
    net.Start( "mplr-signal" )
    net.WriteEntity( self )
    net.WriteTable( self.Routes )
    net.WriteString( self.Name1 )
    net.WriteString( self.Name2 )
    net.WriteBool( self.Left )
    if ply then
        net.Send( ply )
    else
        net.Broadcast()
    end
end

function ENT:SetSpeedLimitSection()
    local speedVar = self.Type
    local forward = self.Forward
    local k_v = {}
    local speedSectorLimit = UF.ScanTrackForEntity( "gmod_track_uf_signal", self.Node, self.TrackPosition.x, self.Forward, nil, true, "Type", "speed", true )
    local function recursiveNodes( node, nextNode )
        for k, v in pairs( k_v ) do
            node[ k ] = v
        end

        if forward and nextNode then
            recursiveNodes( nextNode, nextNode.next )
        elseif not nextNode then
            for k, v in pairs( k_v ) do
                node[ k ] = v
            end
        elseif not forward and nextNode then
            recursiveNodes( nextNode, nextNode.prev )
        end
    end

    if forward and not self.Type ~= "speed_clear" then
        k_v = {
            speed_forward = string.sub( speedVar, #speedVar - 2, #speedVar )
        }
    elseif not forward and not self.Type ~= "speed_clear" then
        k_v = {
            speed_backward = string.sub( speedVar, #speedVar - 2, #speedVar )
        }
    elseif forward then
        k_v = {
            speed_forward = nil
        }
    else
        k_v = {
            speed_backward = nil
        }
    end

    if not self.NextSign then
        recursiveNodes( self.Node, self.Node.next )
    else
        UF.WriteToNodeTable( self.Node, self.NextSign.Node, forward, k_v )
    end
end

--On receive update request, we send update
net.Receive( "mplr-signal", function( _, ply )
    local ent = net.ReadEntity()
    if not IsValid( ent ) or not ent.SendUpdate then return end
    ent:SendUpdate( ply )
end )

function ENT:KeyValue( key, value )
    self.VMF = self.VMF or {}
    self.VMF[ key ] = value
end