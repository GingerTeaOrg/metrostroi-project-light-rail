-- Format: LineRoute = {[SwitchID] = "Direction"}
MPLR.RoutingTable = {
    [ "00101" ] = {
        [ 1 ] = "Right",
        [ 2 ] = "Right",
        [ 4 ] = "Left",
        [ 3 ] = "Right",
    },
}

MPLR.RoutingTable[ "0101" ] = MPLR.RoutingTable[ "00101" ]