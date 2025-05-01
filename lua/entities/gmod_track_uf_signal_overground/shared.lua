ENT.Type = "anim"
ENT.PrintName = "BOStrab Overground Signal"
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true
ENT.AdminSpawnable = true
ENT.LensOrder = {
    [ 1 ] = "So14",
    [ 2 ] = "A1",
    [ 3 ] = "F5",
    [ 4 ] = "F0",
    [ 5 ] = "F4",
    [ 6 ] = "F1",
    [ 7 ] = "F2",
    [ 8 ] = "F3"
}

ENT.SignalName1 = ENT.VMF and ENT.VMF.SignalName1 or ENT.SignalName1
ENT.SignalName2 = ENT.VMF and ENT.VMF.SignalName2 or ENT.SignalName2
ENT.SignalName = ENT.VMF and ENT.VMF.SignalName or ENT.SignalName
if SERVER then util.AddNetworkString( "SyncKeyValueSignals" ) end
if SERVER then
    function ENT:KeyValue( key, value )
        if SERVER then
            self.VMF = self.VMF or {}
            self.VMF[ key ] = value
            if next( self.VMF ) then
                net.Start( "SyncKeyValueSignals" )
                net.WriteTable( self.VMF )
                net.Broadcast()
            end
        end
    end
elseif CLIENT then
    ENT.VMF = ENT.VMF or {}
    net.Receive( "SyncKeyValueSignals" )
    ENT.VMF = net.ReadTable()
end