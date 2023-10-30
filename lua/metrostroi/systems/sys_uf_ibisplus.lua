Metrostroi.DefineSystem("IBISPlus")

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

	self.LineTable = UF.IBISLines[self.Train:GetNW2Int("IBIS:Lines")]

	self.LineLookupComplete = false
	self.DestinationLookupComplete = false
	self.RouteLookupComplete = false

	self.RBLRegisterFailed = false
	self.RBLRegistered = false
	self.RBLSignedOff = true

	self.RouteTable = UF.IBISRoutes[self.Train:GetNW2Int("IBIS:Routes")]

	self.DestinationTable = UF.IBISDestinations[self.Train:GetNW2Int("IBIS:Destinations")]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[self.Train:GetNW2Int("IBIS:ServiceA")]
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

	self.DefectChance = math.random(0, 100)
	self.LastRoll = CurTime()

	self.TrainID = math.random(9999, 1)

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
	surface.CreateFont("IBIS", { -- main text font
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
	})
	surface.CreateFont("IBIS_background", { -- background glow font
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
	})
end