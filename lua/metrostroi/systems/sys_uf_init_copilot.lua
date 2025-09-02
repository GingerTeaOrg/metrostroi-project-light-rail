Metrostroi.DefineSystem( "COPILOT" )
TRAIN_SYSTEM.DontAccelerateSimulation = false
function TRAIN_SYSTEM:Initialize()
	self.Route = " " -- Route index number
	self.PromptRoute = " "
	self.RouteChar1 = " "
	self.RouteChar2 = " "
	self.DisplayedRouteChar1 = " "
	self.DisplayedRouteChar2 = " "
	self.Course = " " -- Course index number, format is LineLineCourseCourse
	self.CourseChar1 = " "
	self.CourseChar2 = " "
	self.CourseChar3 = " "
	self.CourseChar4 = " "
	self.CourseChar5 = " "
	self.PromptCourse = " "
	self.DisplayedCourseChar1 = " "
	self.DisplayedCourseChar2 = " "
	self.DisplayedCourseChar3 = " "
	self.DisplayedCourseChar4 = " "
	self.PreviousCourse = "0"
	self.PreviousCourseNoted = false
	self.DestinationText = " " -- The terminus station name
	self.FirstStation = 0 -- First station index number
	self.FirstStationString = " " -- Name of the first station
	self.CurrentStatonString = " " -- For storing the name of the station to display on the screen, of the station we are at
	self.CurrentStation = 0 -- Actual station index number
	self.CurrentStationInternal = 0 -- How far along we are in a route's station listing
	self.NextStationString = ""
	self.NextStation = 0
	self.Destination = " " -- Destination index number
	self.DestinationChar1 = " "
	self.DestinationChar2 = " "
	self.DestinationChar3 = " "
	self.DisplayedDestinationChar1 = " "
	self.DisplayedDestinationChar2 = " "
	self.DisplayedDestinationChar3 = " "
	self.AnnouncementChar1 = " "
	self.AnnouncementChar2 = " "
	self.SpecialAnnouncement = " "
	self.LineTable = MPLR.IBISLines[ self.Train:GetNW2Int( "IBIS:Lines" ) ]
	self.LineLookupComplete = false
	self.DestinationLookupComplete = false
	self.RouteLookupComplete = false
	self.RBLRegisterFailed = false
	self.RBLRegistered = false
	self.RBLSignedOff = true
	self.RouteTable = MPLR.IBISRoutes[ self.Train:GetNW2Int( "IBIS:Routes" ) ]
	self.DestinationTable = MPLR.IBISDestinations[ self.Train:GetNW2Int( "IBIS:Destinations" ) ]
	self.ServiceAnnouncements = MPLR.SpecialAnnouncementsIBIS[ self.Train:GetNW2Int( "IBIS:ServiceA" ) ]
	-- print("Selected Service Announcements:", self.Train:GetNW2Int("IBIS:ServiceA"))
	self.JustBooted = false
	self.PowerOn = 0
	self.IBISBootupComplete = 0
	self.ColdBoot = true
	self.FullyBootupMoment = 0
	self.FullyBootupMomentRegistered = false
	self.Debug = 1
	self.BugCheck1 = false
	self.BugCheck2 = false
	self.BlinkText = false
	self.LastBlinkTime = 0
	self.KeyInputDone = false
	self.BootupComplete = false
	self.IndexValid = false
	self.PhonedHome = false
	self.DefectChance = math.random( 0, 100 )
	self.LastRoll = CurTime()
	self.TrainID = math.random( 9999, 1 )
	self.KeyInput = nil
	self.KeyRegistered = false
	self.ErrorMoment = 0
	self.ErrorAcknowledged = false
	self.KeyInserted = false
	self.KeyTurned = false
	self.PowerOnRegistered = false
	self.TriggerNames = {
		"Number1", -- 1
		"Number2", -- 2
		"Number3", -- 3
		"Number4", -- 4
		"Number5", -- 5
		"Number6", -- 6
		"Number7",
		"Number8",
		"Number9",
		"Number0",
		"Destination", -- 11
		"Delete", -- 12
		"Enter", -- 13
		"SpecialAnnouncements", -- 14
		"TimeAndDate" -- 15
	}

	self.Triggers = {}
	self.State = 0
	self.Menu = 0 -- which menu are we in
	self.Announce = false
end

if TURBOSTROI then return end
if CLIENT then
	surface.CreateFont( "IBIS", {
		-- main text font
		font = "LCDDot TR Regular",
		size = 55,
		weight = 10,
		blursize = false,
		antialias = true, -- can be disabled for pixel perfect font, but at low resolution the font is looks corrupted
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
		extended = true,
		scanlines = false
	} )

	surface.CreateFont( "IBIS_background", {
		-- background glow font
		font = "Liquid Crystal Display",
		size = 30,
		weight = 0,
		blursize = 3,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = true,
		outline = true,
		extended = true
	} )
end

function TRAIN_SYSTEM:ClientThink()
	if not self.DrawTimer then
		render.PushRenderTarget( self.Train.IBIS, 0, 0, 512, 128 )
		-- render.Clear(0, 0, 0, 0)
		render.PopRenderTarget()
	end

	if self.DrawTimer and CurTime() - self.DrawTimer < 0.1 then return end
	self.DrawTimer = CurTime()
	render.PushRenderTarget( self.Train.IBIS, 0, 0, 512, 128 )
	-- render.Clear(0, 0, 0, 0)
	cam.Start2D()
	self:IBISScreen( self.Train )
	cam.End2D()
	render.PopRenderTarget()
	if self.DrawTimer and CurTime() - self.DrawTimer < 0.2 then return end
	self.DrawTimer = CurTime()
	render.PushRenderTarget( self.Train.IBIS, 0, 0, 512, 128 )
	-- render.Clear(0, 0, 0, 0)
	cam.Start2D()
	self:IBISScreen( self.Train )
	cam.End2D()
	render.PopRenderTarget()
end

function TRAIN_SYSTEM:PrintText( x, y, text, inverse )
	local str = { utf8.codepoint( text, 1, -1 ) }
	for i = 1, #str do
		local char = utf8.char( str[ i ] )
		if inverse then
			draw.SimpleText( string.char( 0x7f ), "IBIS", ( x + i ) * 20.5 + 5, y * 40 + 40, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( char, "IBIS", ( x + i ) * 20.5 + 5, y * 40 + 40, Color( 140, 190, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( char, "IBIS", ( x + i ) * 32, y * 15 + 20, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
end

function TRAIN_SYSTEM:IBISScreen( Train )
	local PowerOn = self.Train:GetNW2Bool( "IBISPowerOn", false )
	if PowerOn == true then
		surface.SetDrawColor( 140, 190, 0, self.Warm and 130 or 255 )
		surface.DrawRect( 0, 0, 512, 128 )
		self.Warm = true
		if self.Train:GetNW2Bool( "IBISBootupComplete", false ) == false then
			self:PrintText( 0, 0, "---------------" )
			self:PrintText( 0, 4, "---------------" )
		end
	end

	if PowerOn == false then
		surface.SetDrawColor( 37, 94, 0, 230 )
		surface.DrawRect( 0, 0, 512, 128 )
		self.Warm = false
	end
end

if CLIENT then
	function TRAIN_SYSTEM:ClientInitialize()
		self.LastBlinkTime = 0
		self.BlinkingText = false
		self.DefectStrings = {
			[ 1 ] = "IFIS FEHLER",
			[ 2 ] = "FUNK DEFEKT",
			[ 3 ] = "ENTWERTER 1 DEFEKT",
			[ 4 ] = "WEICHENST DEFEKT"
		}
	end

	function TRAIN_SYSTEM:BlinkText( enable, Text )
		if not enable then
			self.BlinkingText = false
		elseif CurTime() - self.LastBlinkTime > 1.5 then
			self:PrintText( 0, 1.5, Text )
			if CurTime() - self.LastBlinkTime > 3 then self.LastBlinkTime = CurTime() end
		end
	end
end