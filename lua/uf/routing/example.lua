-- Format: LineRoute = {[SwitchID] = "Direction"}
UF.RoutingTable = {
    [ "00101" ] = {
        [ 1 ] = "Right",
        [ 2 ] = "Right",
        [ 4 ] = "Left",
        [ 3 ] = "Right",
    },
}

UF.RoutingTable[ "0101" ] = UF.RoutingTable[ "00101" ]