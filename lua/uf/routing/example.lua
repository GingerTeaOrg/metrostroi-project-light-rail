--Format: [LineRoute, ie line 02 and route 01 being 0102] = { [switchid] = "left", [switchid2] = "right,"}
UF.RoutingTable = {["0201"] = { [01] = "left", [02] = "right", [03] = "left"}, ["0202"] = {[03] = "right", [02] = "left", [03] = "right"} }
--define which metrostroi position constitutes left or right here
UF.SwitchTable = { [01] = {["left"] = "main"}, [02] = {["left"] = "alt"}, [03] = {["left"] = "main"}}