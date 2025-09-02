TOOL.Category = "Metrostroi: Project Light Rail"
TOOL.Name = "Railnetwork Debugger Tool"
-- Set the basic meta table
if CLIENT then
	TOOL.Author = "LillyWho"
	TOOL.Contact = "thegladostroll"
	TOOL.Purpose = "Prints railnetwork information to the player wherever it shoots"
	TOOL.Instructions = "How to use your toolgun"
	language.Add( "tool.railnetwork_debugger.name", "Metrostroi: Project Light Rail Track Debugger" )
	language.Add( "tool.railnetwork_debugger.desc", "Helper tool to get Metrostroi track data." )
	language.Add( "tool.railnetwork_debugger.left", "Left-click to print track data to console." )
	language.Add( "tool.railnetwork_debugger.right", "Right-click to load a signal's settings." )
	TOOL.Name = "Metrostroi Railnetwork Debugger" -- The name of your toolgun
	TOOL.Category = "Metrostroi Debug" -- The category of your toolgun
	TOOL.Information = {
		{
			name = "left"
		},
		{
			name = "right"
		}
	}

	-- Receive networked table from the server
	net.Receive( "SendTableToClient", function()
		-- Receive the table from the server
		local receivedTable = net.ReadTable()
		-- Do something with the received table
		print( "Received track data from server:" )
		PrintTable( receivedTable, 2 )
	end )
end

-- Networked variable setup
if SERVER then util.AddNetworkString( "SendTableToClient" ) end
TOOL.LastFire = 0
-- Define the primary function of your toolgun
function TOOL:LeftClick( trace )
	if SERVER then
		-- Check if the trace actually hits something
		if not trace.Hit then return false end
		-- Check the firing rate
		if CurTime() - self.LastFire < 5 then return false end
		-- Update last fire time
		self.LastFire = CurTime()
		-- Get track position
		local trackPos = Metrostroi.GetPositionOnTrack( trace.HitPos, trace.HitNormal )
		-- Send the track position table to the client
		net.Start( "SendTableToClient" )
		net.WriteTable( trackPos )
		net.Send( self.Owner )
		return true
	end
end

-- Define the secondary function of your toolgun
function TOOL:RightClick( trace )
	-- Add functionality for right-click action
end