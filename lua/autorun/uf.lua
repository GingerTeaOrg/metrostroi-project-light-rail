if not MPLR and Metrostroi then
	-- Global library
	MPLR = {}
	print( "MPLR: Library starting" )
	-- Supported train classes
	MPLR.TrainClasses = {}
	MPLR.IsTrainClass = {}
	MPLR.SpawnedTrains = {}
	MPLR.Consists = {}
	MPLR.CarsByCarNumbers = {}
	-- Supported train classes
	MPLR.TrainSpawnerClasses = {}
	timer.Simple( 0, function()
		for name in pairs( scripted_ents.GetList() ) do
			local prefix = "gmod_subway_uf_"
			local prefix2 = "gmod_subway_mplr_"
			local base = scripted_ents.Get( name ).Base
			if ( string.sub( name, 1, #prefix ) == prefix or string.sub( name, 1, #prefix2 ) == prefix2 ) and base ~= "gmod_subway_base" and not scripted_ents.Get( name ).NoTrain then
				table.insert( MPLR.TrainClasses, name )
				MPLR.IsTrainClass[ name ] = true
			end
		end
	end )

	--format: multiline
	timer.Simple(
		0, 
		function()
			MPLR.TrolleybusInstalled = trolleyFile
			MPLR.TrolleybusLoaded = Trolleybus_System and true or false
			if not MPLR.TrolleybusLoaded then include( "trolleybus_system.lua" ) end
		end
	)
end

if CLIENT then
	include( "autorun/client/cl_uf.lua" )
elseif SERVER then
	AddCSLuaFile( "autorun/client/cl_uf.lua" )
end

hook.Add( "MPLRCouplingCallback", "MPLRDigestConsist", function( ent )
	local wagonNumber = ent.WagonNumber
	local function checkTrainInConsist( consist, ent )
		for k in pairs( consist ) do
			if ent == k then return true end
		end
	end

	local function copyWagonList( consist, ent )
		local wagonList = ent.WagonList
		for _, v in ipairs( wagonList ) do
			MPLR.Consists[ consist ][ v.WagonNumber ] = true
		end
	end

	for k in ipairs( MPLR.Consists ) do
		if checkTrainInConsist( k, ent ) then
			MPLR.Consists[ k ][ wagonNumber ] = nil
			copyWagonList( #MPLR.Consists + 1, ent )
		end
	end
end )

MPLR.BogeyTypes = MPLR.BogeyTypes or {} -- bogey models and params
MPLR.BogeySounds = MPLR.BogeySounds or {} -- bogey sounds
MPLR.CouplerTypes = MPLR.CouplerTypes or {} -- coupler models and params
local directory = "models/uf"
local directory2 = "models/mplr"
local files, _ = file.Find( directory .. "/*.mdl", "GAME" ) -- Find all .mdl files in the directory
local files2, _ = file.Find( directory2 .. "/*.mdl", "GAME" ) -- Find all .mdl files in the directory
for _, filename in ipairs( files ) do
	local modelPath = directory .. "/" .. filename
	util.PrecacheModel( modelPath )
end

for _, filename in ipairs( files2 ) do
	local modelPath = directory .. "/" .. filename
	util.PrecacheModel( modelPath )
end

util.PrecacheModel( "models/lilly/uf/stations/dfi_hands_hours.mdl" )
util.PrecacheModel( "models/lilly/uf/stations/dfi_hands_minutes.mdl" )
if SERVER then
	util.AddNetworkString( "mplr-mouse-move" )
	util.AddNetworkString( "mplr-cabin-button" )
	util.AddNetworkString( "mplr-cabin-reset" )
	util.AddNetworkString( "mplr-panel-touch" )
end

timer.Create( "RBLHousekeeping", 30, 0, function()
	for name in pairs( ents.GetAll() ) do
		local prefix = "gmod_subway_uf_"
		local prefix2 = "gmod_subway_mplr_"
		if string.sub( name, 1, #prefix ) == prefix or string.sub( name, 1, #prefix2 ) == prefix2 then
			print( "MPLR RBL: Did housekeeping on entity", name )
			MPLR.IBISRegisteredTrains[ name ] = name.IBIS.Course
		end
	end

	for k, v in pairs( MPLR.IBISRegisteredTrains ) do
		if not IsValid( k ) then k = nil end
	end
end )

hook.Add( "EntityRemoved", "MPLRTrains", function( ent )
	for i, _ in pairs( MPLR.IBISRegisteredTrains ) do
		if i == ent then
			MPLR.IBISRegisteredTrains[ ent ] = nil
			print( "MPLR RBL: Cleared entity at index: ", i )
		end
	end

	MPLR.SpawnedTrains[ ent ] = nil
	Metrostroi.SpawnedTrains[ ent ] = nil
end )

if SERVER and Metrostroi then
	hook.Add( "OnEntityCreated", "MPLRTrains", function( ent )
		local prefix = "gmod_subway_uf_"
		local prefix2 = "gmod_subway_mplr_"
		if not IsValid( ent ) then return end
		if string.sub( ent:GetClass(), 1, #prefix ) == prefix or string.sub( ent:GetClass(), 1, #prefix2 ) == prefix2 then
			MPLR.SpawnedTrains[ ent ] = true
			Metrostroi.SpawnedTrains[ ent ] = true
		end
	end )
elseif CLIENT and Metrostroi then
	if not Metrostroi.SpawnedTrains then Metrostroi.SpawnedTrains = {} end
	hook.Add( "OnEntityCreated", "MPLRTrains", function( ent )
		local prefix = "gmod_subway_uf_"
		local prefix2 = "gmod_subway_mplr_"
		if not IsValid( ent ) then return end
		if ent:GetClass() == "gmod_subway_mplr_base" or scripted_ents.IsBasedOn( ent:GetClass(), "gmod_subway_mplr_base" ) then
			MPLR.SpawnedTrains[ ent ] = true
			Metrostroi.SpawnedTrains[ ent ] = true
		end
	end )
end

if CLIENT then
	hook.Add( "InitPostEntity", "MPLR_PostLaunch_RenderDisplays", function()
		-- Define the target entity class
		local targetClass = "gmod_track_uf_dfi"
		-- Table to track active hooks for entities
		local activeHooks = {}
		local function CreateEntityHook( entity )
			local hookName = "MPLR_Display_PostDrawHUD_Entity_" .. entity:EntIndex()
			hook.Add( "PostDrawHUD", hookName, function()
				if not IsValid( entity ) then
					-- Remove the hook if the entity is no longer valid
					hook.Remove( "PostDrawHUD", hookName )
					activeHooks[ hookName ] = nil
					return
				end

				-- Call RenderDisplay with the entity as a parameter
				if entity.RenderDisplay then
					entity:RenderDisplay( entity ) -- Pass entity as an argument
				end
			end )

			-- Track the hook
			activeHooks[ hookName ] = entity
		end

		for _, ent in ipairs( ents.GetAll() ) do
			if ent:GetClass() == "gmod_track_uf_dfi" then timer.Simple( 0, function() if IsValid( ent ) and ent:GetClass() == targetClass then CreateEntityHook( ent ) end end ) end
		end

		-- Hook to detect when entities are created
		hook.Add( "OnEntityCreated", "ManageEntityHooks_OnSpawn", function( entity )
			-- Delay to ensure the entity is fully initialized
			timer.Simple( 0, function() if IsValid( entity ) and entity:GetClass() == targetClass then CreateEntityHook( entity ) end end )
		end )
	end )
end

MPLR.IBISAnnouncementFiles = {}
MPLR.IBISAnnouncementScript = {}
MPLR.IBISCommonFiles = {}
MPLR.SpecialAnnouncementsIBIS = {}
MPLR.IBISSetup = {}
MPLR.IBISDestinations = {}
MPLR.IBISRoutes = {}
MPLR.IBISLines = {}
MPLR.TrainPositions = {}
MPLR.Stations = {}
MPLR.Rollsigns = {}
MPLR.TrainCountOnPlayer = {}
MPLR.IBISRegisteredTrains = {}
MPLR.IBISAnnouncementMetadata = {}
MPLR.IBISLinePrefixes = {}
function MPLR.checkDuplicateTrain( train, LC )
	local foundDuplicate = false -- Initialize variable to track duplicate value
	for key, value in pairs( MPLR.IBISRegisteredTrains ) do
		-- Check if the value is equal to the target
		if key ~= train and LC == value then
			foundDuplicate = true -- Found a duplicate value
			break -- Exit the loop since a duplicate value is found
		elseif key == train and value ~= LC or key == train and value == LC then
			foundDuplicate = false
			break
		end
	end
	return foundDuplicate -- Return true if no duplicate value found, false otherwise
end

function MPLR.RegisterTrain( LineCourse, train ) -- Registers a train for the RBL simulation
	local output
	local LineTable = train.IBIS.LineTable
	-- Step 1: Check if LineCourse and train are falsy values
	if not LineCourse and not train then
		-- Print statement for Step 1
		print( "LineCourse and train are falsy values. Exiting function." )
		return -- Return without performing any further actions
	end

	if ( LineCourse == "0000" or LineCourse == "00000" ) and next( MPLR.IBISRegisteredTrains ) and MPLR.IBISRegisteredTrains[ train ] then
		-- If the input is all zeros, we delete ourselves from the table
		MPLR.IBISRegisteredTrains[ train ] = nil
		print( "RBL: Logging service off", train )
		output = "logoff"
		return output
		-- Step 2: Check if MPLR.IBISRegisteredTrains table is empty
	elseif not next( MPLR.IBISRegisteredTrains ) and LineCourse ~= "0000" and LineTable[ string.sub( LineCourse, 1, 2 ) ] then
		-- Print statement for Step 2
		print( "RBL: Table is empty. Registering train." )
		-- Step 3b: Assign LineCourse to the LineCourse field of the newly inserted train
		train.RBLRegistered = true
		MPLR.IBISRegisteredTrains[ train ] = LineCourse
		print( "RBL: Train registered successfully with LineCourse:", LineCourse )
		output = true -- Return true to indicate successful registration
		return output
	elseif ( LineCourse ~= "0000" or LineCourse ~= "00000" ) and #LineCourse > 3 and MPLR.IBISRegisteredTrains[ train ] == LineCourse then
		print( "Train is already registered by this exact circulation. Doing Nothing." )
		train.RBLRegistered = true
		output = true
		return output
	elseif LineCourse ~= "0000" and LineTable[ string.sub( LineCourse, 1, 2 ) ] and #LineCourse >= 4 and MPLR.IBISRegisteredTrains[ train ] ~= LineCourse and MPLR.checkDuplicateTrain( train, LineCourse ) then
		print( "RBL: Another train is already registered on the same line circulation. Registration failed." )
		output = false -- Return false if the train is already registered on the same line course
		return output
	elseif LineCourse ~= "0000" and LineTable[ string.sub( LineCourse, 1, 2 ) ] and #LineCourse >= 4 and MPLR.IBISRegisteredTrains[ train ] ~= LineCourse and not MPLR.checkDuplicateTrain( train, LineCourse ) then
		MPLR.IBISRegisteredTrains[ train ] = LineCourse
		train.RBLRegistered = true
		print( "RBL: No conflicting train with LineCourse found. Registering new train.", LineCourse )
		output = true
		return output
	end
	return output
end

function MPLR.AddIBISCommonFiles( name, datatable )
	if not datatable then return end
	for k, v in pairs( MPLR.IBISCommonFiles ) do
		if v.name == name then
			MPLR.IBISCommonFiles[ k ] = datatable
			MPLR.IBISCommonFiles[ k ].name = name
			print( "Light Rail: Changed \"" .. name .. "\" IBIS announcer common files." )
			return
		end
	end

	local id = table.insert( MPLR.IBISCommonFiles, datatable )
	MPLR.IBISCommonFiles[ id ].name = name
	print( "Light Rail: Added \"" .. name .. "\" IBIS announcer common files." )
end

function MPLR.AddIBISAnnouncementMetadata( name, datatable )
	if not name and not datatable then return end
	for k, v in pairs( MPLR.IBISAnnouncementMetadata ) do
		if v.name == name then
			MPLR.IBISAnnouncementMetadata[ k ] = datatable
			MPLR.IBISAnnouncementMetadata[ k ].name = name
			print( "Light Rail: Changed \"" .. name .. "\" IBIS announcer Metadata." )
			return
		end
	end

	local id = table.insert( MPLR.IBISAnnouncementMetadata, datatable )
	MPLR.IBISAnnouncementMetadata[ id ].name = name
	print( "Light Rail: Added \"" .. name .. "\" IBIS announcer Metadata." )
end

function MPLR.AddIBISAnnouncementScript( name, datatable )
	if not name and not datatable then return end
	for k, v in pairs( MPLR.IBISAnnouncementScript ) do
		if v.name == name then
			MPLR.IBISAnnouncementScript[ k ] = datatable
			MPLR.IBISAnnouncementScript[ k ].name = name
			print( "Light Rail: Changed \"" .. name .. "\" IBIS announcer script." )
			return
		end
	end

	local id = table.insert( MPLR.IBISAnnouncementScript, datatable )
	MPLR.IBISAnnouncementScript[ id ].name = name
	print( "Light Rail: Added \"" .. name .. "\" IBIS announcer script." )
end

function MPLR.AddIBISDestinations( name, index )
	if not index or not name then return end
	for k, v in pairs( MPLR.IBISDestinations ) do
		if v.name == name then
			MPLR.IBISDestinations[ k ] = index
			MPLR.IBISDestinations[ k ].name = name
			print( "Light Rail: Loaded \"" .. name .. "\" IBIS station index." )
			return
		end
	end

	local id = table.insert( MPLR.IBISDestinations, index )
	MPLR.IBISDestinations[ id ].name = name
	print( "Light Rail: Loaded \"" .. name .. "\" IBIS station index." )
end

function MPLR.AddIBISRoutes( name, routes )
	if not name or not routes then return end
	for k, v in pairs( MPLR.IBISRoutes ) do
		if v.name == name then
			MPLR.IBISRoutes[ k ] = routes
			MPLR.IBISRoutes[ k ].name = name
			print( "Light Rail: Reloaded \"" .. name .. "\" IBIS Route index." )
			return
		end
	end

	local id = table.insert( MPLR.IBISRoutes, routes )
	MPLR.IBISRoutes[ id ].name = name
	print( "Light Rail: Loaded \"" .. name .. "\" IBIS Route index." )
end

function MPLR.AddIBISLines( name, lines )
	if not name or not lines then return end
	for k, v in pairs( MPLR.IBISLines ) do
		if v.name == name then
			MPLR.IBISLines[ k ] = lines
			MPLR.IBISLines[ k ].name = name
			print( "Light Rail: Reloaded \"" .. name .. "\" IBIS line index." )
			return
		end
	end

	local id = table.insert( MPLR.IBISLines, lines )
	MPLR.IBISLines[ id ].name = name
	print( "Light Rail: Loaded \"" .. name .. "\" IBIS line index." )
end

function MPLR.AddLinePrefixes( name, lines )
	if not name or not lines then return end
	for k, v in pairs( MPLR.IBISLinePrefixes ) do
		if v.name == name then
			MPLR.IBISLinePrefixes[ k ] = lines
			MPLR.IBISLinePrefixes[ k ].name = name
			print( "Light Rail: Reloaded \"" .. name .. "\" IBIS line index." )
			return
		end
	end

	local id = table.insert( MPLR.IBISLinePrefixes, lines )
	MPLR.IBISLinePrefixes[ id ].name = name
	print( "Light Rail: Loaded \"" .. name .. "\" line prefix index." )
end

function MPLR.AddRollsigns( name, train, tab )
	if not name or not train or not tab then return end
	if not MPLR.Rollsigns then MPLR.Rollsigns = {} end
	for k, v in pairs( MPLR.Rollsigns ) do
		if v.name == name then
			MPLR.Rollsigns[ k ] = tab
			MPLR.Rollsigns[ k ].name = name
			MPLR.Rollsigns[ k ].train = train
			print( "Project Light Rail: Reloaded \"" .. name .. "\" Rollsigns." )
			return
		end
	end

	local id = table.insert( MPLR.Rollsigns, tab )
	MPLR.Rollsigns[ id ].name = name
	MPLR.Rollsigns[ id ].train = train
	print( "Project Light Rail: Loaded \"" .. name .. "\" Rollsigns." )
end

files = file.Find( "uf/rollsigns/*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/rollsigns/" .. filename )
	include( "uf/rollsigns/" .. filename )
end

function MPLR.AddSpecialAnnouncements( name, soundtable )
	if not name or not soundtable then return end
	for k, v in pairs( MPLR.SpecialAnnouncementsIBIS ) do
		if v.name == name then
			MPLR.SpecialAnnouncementsIBIS[ k ] = soundtable
			MPLR.SpecialAnnouncementsIBIS[ k ].name = name
			print( "Light Rail: Changed \"" .. name .. "\" IBIS Service Announcements." )
			return
		end
	end

	local id = table.insert( MPLR.SpecialAnnouncementsIBIS, soundtable )
	MPLR.SpecialAnnouncementsIBIS[ id ].name = name
	print( "Light Rail: Added \"" .. name .. "\" IBIS Service announcement set." )
end

files = file.Find( "uf/IBIS/*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/IBIS/" .. filename )
	include( "uf/IBIS/" .. filename )
end

files = file.Find( "uf/maps/*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/maps/" .. filename )
	include( "uf/maps/" .. filename )
end

if not MPLR.RoutingTable then
	MPLR.SwitchTable = {} -- create a list of switches on the map. the individual IDs would be set via toolgun
	MPLR.RoutingTable = {} -- manually set routing table, for determining what IBIS Line/Route consists of what switch, where the switch needs to point, and what constitutes left or right 
end

function MPLR.CheckGameServerMode()
	MPLR.GameMode = {}
	MPLR.GameMode.SRCDS = game.IsDedicated()
	MPLR.GameMode.Single = game.SinglePlayer()
	MPLR.GameMode.Listen = not game.SinglePlayer() and not game.IsDedicated()
end

MPLR.CheckGameServerMode()
function MPLR.CheckForPathingData()
	local mapname = game.GetMap()
	local baseURL = "https://lillywho.github.io/mapdata/"
	if not Metrostroi.Paths then
		local trackFile = "metrostroi_data/track_" .. mapname .. ".txt"
		if not file.Exists( trackFile, "DATA" ) then
			print( "Attempting to fetch track data from repo" )
			local url = baseURL .. "track_" .. mapname .. ".txt"
			MPLR.httpHandler( url, trackFile )
		end
	end

	local signsFile = "project_light_rail_data/signs_" .. mapname .. ".txt"
	if not file.Exists( signsFile, "DATA" ) then
		print( "Attempting to fetch signalling data from repo" )
		local url = baseURL .. "signs_" .. mapname .. ".txt"
		MPLR.httpHandler( url, signsFile )
	end
end

function MPLR.httpHandler( url )
	-- Use HTTP to fetch the content from the URL
	http.Fetch( url, function( body, len, headers, code )
		-- Check if the status code indicates an error
		if code >= 400 then
			-- Print an error message to the console
			print( "HTTP error: " .. code )
			return
		end

		-- Success callback function
		print( "Download completed with status code: " .. code )
		-- Print the first 100 characters of the response body (for debug purposes)
		print( "Response body: " .. string.sub( body, 1, 100 ) )
		-- Define the file path within the data folder
		local filePath = "data/project_light_rail_data/" .. filename
		-- Write the downloaded content to a file in the data folder
		file.Write( filePath, body )
		-- Print a message to the console indicating the file has been saved
		print( "File saved to: " .. filePath )
	end, function( error )
		-- Failure callback function
		print( "Failed to download file: " .. error )
	end )
end

files = file.Find( "uf/routing/*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/routing/" .. filename )
	include( "uf/routing/" .. filename )
end

if SERVER then
	files = file.Find( "uf/sv*.lua", "LUA" )
	for _, filename in pairs( files ) do
		local fullpath = "uf/" .. filename
		if fullpath == "uf/sv_uf_railnetwork.lua" and not Metrostroi.Paths then
			print( "No pathing data registered. Trying to download before initialising MPLR Railnetwork!" )
			MPLR.CheckForPathingData()
			AddCSLuaFile( "uf/" .. filename )
			include( "uf/" .. filename )
		else
			AddCSLuaFile( "uf/" .. filename )
			include( "uf/" .. filename )
		end
	end
end

files = file.Find( "uf/cl_*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/" .. filename )
	include( "uf/" .. filename )
end

files = file.Find( "uf/sh_*.lua", "LUA" )
for _, filename in pairs( files ) do
	AddCSLuaFile( "uf/" .. filename )
	include( "uf/" .. filename )
end

AddCSLuaFile( "uf/sh_spawnmenu.lua" )
include( "uf/sh_spawnmenu.lua" )