---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
-- This entity script including "init.lua" and "cl_init.lua" is licensed under CreativeCommons-NonCommercial-Attribution-ShareAlike.                         --
-- On top of the terms mentioned in said license, training AI models on this code, for any purpose, commercial or non-commercial, is prohibited. --
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.PrintName = "BOStrab Overground Signal"
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true
ENT.AdminSpawnable = true
ENT.LensOrder = {
    --In which order the lenses appear
    [ 1 ] = "So14",
    [ 2 ] = "A1",
    [ 3 ] = "F0",
    [ 4 ] = "F4",
    [ 5 ] = "F1",
    [ 6 ] = "F2",
    [ 7 ] = "F3",
    [ 8 ] = "F5",
}

ENT.AdditionalLenses = {
    [ "So14" ] = true,
    [ "A1" ] = true
}

ENT.DefaultLenses = {
    [ 1 ] = {
        [ "A1" ] = true,
        [ "F0" ] = true,
        [ "F4" ] = true,
        [ "F3" ] = true
    },
    [ 2 ] = {
        [ "A1" ] = true,
        [ "F0" ] = true,
        [ "F4" ] = true,
        [ "F1" ] = true
    },
    [ 3 ] = {
        [ "A1" ] = true,
        [ "F0" ] = true,
        [ "F4" ] = true,
        [ "F2" ] = true
    },
}

if SERVER then
    util.AddNetworkString( "SyncKeyValueSignalsOverground" )
    util.AddNetworkString( "SyncSignalStatesOverground" )
end

if SERVER then
    function ENT:SendSignalStateToClient( ent )
        if not self then self = ent end
        local aspect = self.Aspect
        if type( aspect ) ~= "table" then return end
        net.Start( "SyncSignalStatesOverground", false )
        net.WriteEntity( self )
        net.WriteTable( aspect, false )
        net.SendPVS( self:GetPos() )
    end
elseif CLIENT then
    -- format: multiline
    net.Receive(
        "SyncSignalStatesOverground", 
        function()
            local ent = net.ReadEntity()
            if not IsValid( ent ) then return end
            ent.Aspect = net.ReadTable()
        end
    )
end

function ENT:SetLensesFromNW2()
    local constructTable = {}
    if not self.VMF then
        constructTable[ 1 ] = self:GetNW2String( "Column1Lenses", "F0" )
        constructTable[ 2 ] = self:GetNW2String( "Column2Lenses", "F0" )
        constructTable[ 3 ] = self:GetNW2String( "Column3Lenses", "F0" )
    else
        constructTable[ 1 ] = self.VMF.Column1Lenses
        constructTable[ 2 ] = self.VMF.Column2Lenses
        constructTable[ 3 ] = self.VMF.Column3Lenses
    end
    return constructTable
end

if SERVER then
    function ENT:KeyValue( key, value )
        if SERVER then
            self.VMF = self.VMF or {}
            self.VMF[ key ] = value
            if next( self.VMF ) then
                net.Start( "SyncKeyValueSignalsOverground" )
                net.WriteEntity( self )
                net.WriteTable( self.VMF )
                net.Broadcast()
            end
        end
    end
elseif CLIENT then
    ENT.VMF = ENT.VMF or {}
    --format: multiline
    net.Receive(
        "SyncKeyValueSignalsOverground", 
        function()
            local ent = net.ReadEntity()
            if not IsValid( ent ) then return end
            ent.VMF = net.ReadTable()
        end
    )
end