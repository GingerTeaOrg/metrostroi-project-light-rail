Metrostroi.DefineSystem("IBIS")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
	self.Route = " " -- Route index number
	self.PromptRoute = " "
	self.RouteChar1 = "0"
	self.RouteChar2 = "0"
	self.DisplayedRouteChar1 = " "
	self.DisplayedRouteChar2 = " "

	self.Course = " " -- Course index number, format is LineLineCourseCourse
	self.CourseChar1 = "0"
	self.CourseChar2 = "0"
	self.CourseChar3 = "0"
	self.CourseChar4 = "0"
	self.CourseChar5 = "0"
	self.PromptCourse = " "
	self.DisplayedCourseChar1 = "0"
	self.DisplayedCourseChar2 = "0"
	self.DisplayedCourseChar3 = "0"
	self.DisplayedCourseChar4 = "0"
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
	self.ServiceAnnouncement = " "

	self.LineTable = UF.IBISLines[self.Train:GetNW2Int("IBIS:Lines", 1)]

	self.LineLookupComplete = false
	self.DestinationLookupComplete = false
	self.RouteLookupComplete = false

	self.RBLRegisterFailed = false
	self.RBLRegistered = false
	self.RBLSignedOff = true

	self.RouteTable = UF.IBISRoutes[self.Train:GetNW2Int("IBIS:Routes", 1)]

	self.DestinationTable = UF.IBISDestinations[self.Train:GetNW2Int("IBIS:Destinations", 1)]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[self.Train:GetNW2Int("IBIS:ServiceA", 1)]
	-- print("Selected Service Announcements:", self.Train:GetNW2Int("IBIS:ServiceA"))
	self.JustBooted = false
	self.PowerOn = 0
	self.IBISBootupComplete = 0

	self.ColdBoot = true
	self.ColdBootComplete = false
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
	self.PowerOffMoment = 0

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
		"ServiceAnnouncements", -- 14
		"TimeAndDate" -- 15
	}
	self.Triggers = {}
	self.State = 0

	self.Menu = 4 -- which menu are we in
	self.Announce = false

	self.FirstBoot = true

end

if TURBOSTROI then return end

function TRAIN_SYSTEM:Inputs() return {"KeyInput", "Power"} end
function TRAIN_SYSTEM:Outputs() return {"Course", "Route", "Destination", "State"} end

function TRAIN_SYSTEM:Trigger(name, time)
	local triggerTime = 0
	if self.State > 0 then
		if name and CurTime() - triggerTime > 1.5 then
			if not self.KeyRegistered then
				triggerTime = CurTime()
				self.KeyInput = name
				self.KeyRegistered = true
			end
		else
			-- Reset KeyInput immediately if the input is nil
			self.KeyInput = nil
			self.KeyRegistered = false
			triggerTime = 0
		end
	end
end

function TRAIN_SYSTEM:TriggerInput(name, value) if self[name] then self[name] = value end end

function TRAIN_SYSTEM:TriggerOutput(name, value) if self[name] then self[name] = value end end

if CLIENT then
	surface.CreateFont("IBIS", { -- main text font
		font = "LCDDot TR Regular",
		size = 55,
		weight = 10,
		blursize = 0,
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

function TRAIN_SYSTEM:ClientThink()

	if not self.DrawTimer then
		render.PushRenderTarget(self.Train.IBIS, 0, 0, 512, 128)
		-- render.Clear(0, 0, 0, 0)
		render.PopRenderTarget()
	end
	if self.DrawTimer and CurTime() - self.DrawTimer < 0.1 then return end
	self.DrawTimer = CurTime()
	render.PushRenderTarget(self.Train.IBIS, 0, 0, 512, 128)
	-- render.Clear(0, 0, 0, 0)
	cam.Start2D()
	self:IBISScreen(self.Train)
	cam.End2D()
	render.PopRenderTarget()
	if self.DrawTimer and CurTime() - self.DrawTimer < 0.2 then return end
	self.DrawTimer = CurTime()
	render.PushRenderTarget(self.Train.IBIS, 0, 0, 512, 128)
	-- render.Clear(0, 0, 0, 0)
	cam.Start2D()
	self:IBISScreen(self.Train)
	cam.End2D()
	render.PopRenderTarget()
end

function TRAIN_SYSTEM:PrintText(x, y, text, inverse)

	local str = {utf8.codepoint(text, 1, -1)}
	for i = 1, #str do
		local char = utf8.char(str[i])
		if inverse then
			draw.SimpleText(string.char(0x7f), "IBIS", (x + i) * 20.5 + 5, y * 40 + 40, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(char, "IBIS", (x + i) * 20.5 + 5, y * 40 + 40, Color(140, 190, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(char, "IBIS", (x + i) * 32, y * 15 + 20, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function TRAIN_SYSTEM:IBISScreen(Train)

	local Menu = self.Train:GetNW2Int("IBIS:Menu")
	local State = self.Train:GetNW2Int("IBIS:State")
	local Route = self.Train:GetNW2String("IBIS:RouteChar1") .. self.Train:GetNW2String("IBIS:RouteChar2")
	local Course = self.Train:GetNW2String("IBIS:CourseChar1") .. self.Train:GetNW2String("IBIS:CourseChar2") .. self.Train:GetNW2String("IBIS:CourseChar3")
				               .. self.Train:GetNW2String("IBIS:CourseChar4")
	local Destination = self.Train:GetNW2String("IBIS:DestinationChar1") .. self.Train:GetNW2String("IBIS:DestinationChar2") .. self.Train:GetNW2String("IBIS:DestinationChar3")
	-- local DestinationText = self.Train:GetNW2String("IBIS:DestinationText"," ")
	local CurrentStation = self.Train:GetNW2String("CurrentStation", 0)
	local ServiceAnnouncement = self.Train:GetNW2String("IBIS:ServiceAnnouncement", " ")
	----print(Route)
	----print(Course)

	local PowerOn = self.Train:GetNW2Bool("IBISPowerOn", false)

	if PowerOn == true then
		surface.SetDrawColor(140, 190, 0, self.Warm and 130 or 255)
		surface.DrawRect(0, 0, 512, 128)
		self.Warm = true

		if self.Train:GetNW2Bool("IBISBootupComplete", false) == false then
			self:PrintText(0, 0, "---------------")
			self:PrintText(0, 4, "---------------")
		end

	end

	if PowerOn == false then
		surface.SetDrawColor(37, 94, 0, 230)
		surface.DrawRect(0, 0, 512, 128)
		self.Warm = false

	end

	if State == 2 then

		if Menu == 4 then
			if self.CourseChar4 == " " then
				self:BlinkText(true, "Linie-Kurs:")
				self:PrintText(11.5, 1.5, Course)
			elseif self.CourseChar4 ~= " " then
				self:PrintText(0, 1.5, "Linie-Kurs:")
				self:PrintText(11.5, 1.5, Course)

			end

			return
		end

		if Menu == 5 then
			if self.RouteChar1 == " " then
				self:BlinkText(true, "Route :")
				self:PrintText(13.5, 1.5, Route)

			elseif self.RouteChar1 ~= " " then
				self:PrintText(13.5, 1.5, Route)
				self:PrintText(0, 1.5, "Route :")

			end
			return
		end

	end

	if State == -2 then
		surface.SetDrawColor(140, 190, 0, self.Warm and 130 or 255)
		self.Warm = true
		self:PrintText(0, 0, "IFIS ERROR")
		self:PrintText(0, 1, "Map is missing dataset")
		return
	end

	if State == 1 then

		if Menu == 1 then
			self:PrintText(0, 1.5, "Linie-Kurs:")
			self:PrintText(11.5, 1.5, Course)
			return
		end

		if Menu == 2 then
			self:PrintText(0, 1.5, "Route       :")
			self:PrintText(13.5, 1.5, Route)
			return
		end

		if Menu == 3 then
			self:PrintText(0, 1, "Ziel      :")
			self:PrintText(11, 1.5, Destination)
			return
		end

		if Menu == 6 then
			self:PrintText(0, 1.5, "Ansage      :")
			self:PrintText(13.5, 1.5, ServiceAnnouncement)
			return
		end

		if Menu == 0 then
			self:PrintText(1.5, 6, Destination)
			self:PrintText(5.6, 6, Course)
			self:PrintText(10.5, 6, Route)
			self:PrintText(0, 1, CurrentStation)
			----print(self.Train:GetNW2Int("IBIS:Route"))
			return
		end
	end
	if State == 3 then

		if Menu == 1 then
			self:BlinkText(true, "Ung. Linie")

			return
		end

		if Menu == 2 then
			self:BlinkText(true, "Ung. Route")

			return
		end

		if Menu == 3 then
			self:BlinkText(true, "Ung. Ziel")

			return
		end
		if Menu == 4 then
			self:BlinkText(true, "Ung. Linie")

			return
		end
		if Menu == 5 then
			self:BlinkText(true, "Ung. Route")

			return
		end
		if Menu == 6 then
			self:BlinkText(true, "Ung. Ansage")
			return
		end
	end
	if State == 4 then self:BlinkText(true, self.DefectString[self.Train:GetNW2Int("Defect", 1)]) end
	if State == 5 and Menu == 4 or State == 5 and Menu == 1 then self:BlinkText(true, "Kurs besetzt") end

	return
end

function TRAIN_SYSTEM:UpdateState()
	local batteryOn = self.Train.BatteryOn == true or self.Train.CoreSys.CircuitBreakerOn == true or self.Train:ReadTrainWire(6) > 0 or false
	local ibisKey = self.Train:GetNW2Bool("TurnIBISKey", false)
	local ibisKeyRequired = self.Train.CoreSys.ibisKeyRequired

	-- Function to reset state when device is off
	local function resetState()
		self.PowerOn = 0
		self.State = 0
		self.Menu = 0
		self.Train:SetNW2Bool("IBISPowerOn", false)
		self.Train:SetNW2Bool("IBISBootupComplete", false)
		self.Train:SetNW2Bool("IBISChime", false)
		self.PowerOnRegistered = false -- reset variables if device is off
		self.PowerOnMoment = 0
		if not self.PowerOffMomentRegistered then -- note when the device was switched off,
			self.PowerOffMomentRegistered = true -- to simulate the RAM losing data after an amount of time
			self.PowerOffMoment = CurTime()
		end
		self.JustBooted = false
	end
	local function completeReset()
		self.LineLookupComplete = false
		self.BootupComplete = false
		self.Course = " " -- Course index number, format is LineLineCourseCourse
		self.CourseChar1 = " "
		self.CourseChar2 = " "
		self.CourseChar3 = " "
		self.CourseChar4 = " "
		self.CourseChar5 = " "
		self.DisplayedCourseChar1 = " "
		self.DisplayedCourseChar2 = " "
		self.DisplayedCourseChar3 = " "
		self.DisplayedCourseChar4 = " "
		self.PreviousCourse = "0"
		self.Route = "0" -- Route index number
		self.RouteChar1 = " "
		self.RouteChar2 = " "
		self.DisplayedRouteChar1 = " "
		self.DisplayedRouteChar2 = " "

		self.DestinationText = ""
		self.FirstStation = 0
		self.FirstStationString = ""
		self.CurrentStatonString = ""
		self.CurrentStation = 0
		self.NextStationString = ""
		self.NextStation = 0
		self.JustBooted = false
		self.PowerOn = 0
		self.PowerOnMoment = 0
		self.Destination = 0 -- Destination index number
		self.DestinationChar1 = " "
		self.DestinationChar2 = " "
		self.DestinationChar3 = " "
		self.DisplayedDestinationChar1 = " "
		self.DisplayedDestinationChar2 = " "
		self.DisplayedDestinationChar3 = " "

		self.AnnouncementChar1 = " "
		self.AnnouncementChar2 = " "
		self.ServiceAnnouncement = " "

		self.CurrentStationInternal = 0
	end

	self.ColdBoot = (CurTime() - self.PowerOffMoment > 240) -- The last parameters are kept in RAM for a while after the device was powered down. After that, we boot into the complete set-up.

	if self.Menu > 0 then self:ReadDataset() end

	self.PowerOn = (batteryOn and ibisKey and ibisKeyRequired) or batteryOn and 1 or 0
	if (batteryOn and ibisKey and ibisKeyRequired) or batteryOn then
		self.Train:SetNW2Bool("IBISPowerOn", true)
		self.PowerOffMoment = 0
		if not self.PowerOnRegistered then -- register timer variable for simulated bootup
			self.PowerOnMoment = CurTime()
			self.PowerOnRegistered = true
			-- print("register",RealTime())
		end
		if CurTime() - self.PowerOnMoment > 5 then
			self.Train:SetNW2Bool("IBISBootupComplete", true) -- register that simulated bootup wait has passed
			self.Train:SetNW2Bool("IBISChime", true)
			if self.ColdBoot and not self.ColdBootCompleted then
				self.ColdBootCompleted = true
				self.State = 2
				self.Menu = 4
			end
		end
	elseif (batteryOn and not ibisKey and ibisKeyRequired) or not batteryOn then
		resetState()
	end

	if self.State == 1 and self.Menu == 0 then
		self.Train:SetNW2Bool("IBISError", false)
		self.ServiceAnnouncement = " "
		self.AnnouncementChar1 = " "
		self.AnnouncementChar2 = " "
		self.Train:SetNW2String("ServiceAnnouncement", "")
		-- self.PhonedHome = false
		if self.KeyInput == "7" then
			self.Menu = 2
		elseif self.KeyInput == "0" then
			self.Menu = 1
		elseif self.KeyInput == "Destination" then
			self.Menu = 3
		elseif self.KeyInput == "3" then
			local indexlength = #self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2]
			if indexlength > self.CurrentStationInternal then
				self.CurrentStationInternal = self.CurrentStationInternal + 1

				self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			end
			-- print indexlength
		elseif self.KeyInput == "6" then
			if self.CurrentStationInternal > 1 then
				self.CurrentStationInternal = self.CurrentStationInternal - 1

				self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			end
		elseif self.KeyInput == "ServiceAnnouncements" then
			self.Menu = 6
		elseif self.KeyInput == "9" then
			self:Play(CurTime())
		end
	elseif self.State == 1 and self.Menu == 6 and self.KeyInput == "Enter" then
		if self.ServiceAnnouncement ~= "00" and self.Menu == 6 then
			self:AnnQueue(self.ServiceAnnouncements[self.ServiceAnnouncement])
			print(self.ServiceAnnouncements[self.ServiceAnnouncement])
			self.Menu = 0
		elseif self.ServiceAnnouncement == "00" then
			self.Menu = 0
			self.ServiceAnnouncement = "  "
		else
			self.State = 3
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
		end
	elseif self.State == 1 and self.Menu == 6 and self.KeyInput == "Delete" and self.ServiceAnnouncement == "  " then
		self.Menu = 0
	end
	-- print(self.State, self.Menu)
	if self.State == 0 and not self.CANBus and self.PowerOffMomentRegistered and CurTime() - self.PowerOffMoment > 240 then completeReset() end
	if self.State == 4 then -- We're in the defect state
		if self.KeyInput == "Enter" then -- just confirm. Some IBIS devices just thought stuff was broken while it wasn't.
			self.State = 1
		end
	end

end

function TRAIN_SYSTEM:Think()
	local Train = self.Train
	-- if not Train.BatteryOn or not Train.CircuitBreakerOn or Train:ReadTrainWire(7) < 1 then return end -- why run anything when the train is off? fss.
	self.RouteTable = UF.IBISRoutes[self.Train:GetNW2Int("IBIS:Routes", 1)]
	self.DestinationTable = UF.IBISDestinations[self.Train:GetNW2Int("IBIS:Destinations", 1)]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[self.Train:GetNW2Int("IBIS:ServiceA", 1)]
	self.LineTable = UF.IBISLines[self.Train:GetNW2Int("IBIS:Lines", 1)]
	self:UpdateState()
	if Train.BatteryOn or Train:ReadTrainWire(7) > 0 then self:CANBusRunner() end

	if self.Train.SkinCategory == "U2h" then
		self.KeyInserted = self.Train.Duewag_U2.IBISKeyATurned or self.Train.Duewag_U2.IBISKeyBTurned
	else
		self.KeyInserted = false
	end

	-- Index number abstractions. An unset value is stored as -1, but we don't want the display to print -1. Instead, print a string of nothing.
	self.Route = self.RouteChar1 .. self.RouteChar2
	-- Make sure that displayed characters are never assigned the -1 value, because -1 symbolises an empty character. If something is -1, display empty.
	self.DisplayedRouteChar1 = tonumber(self.RouteChar1, 10) and self.RouteChar1 ~= " " and self.RouteChar1 or " "
	self.DisplayedRouteChar2 = tonumber(self.RouteChar2, 10) and self.RouteChar2 ~= " " and self.RouteChar2 or " "

	self.DisplayedDestinationChar1 = tonumber(self.DestinationChar1, 10) and self.DestinationChar1 ~= " " and self.DestinationChar1 or " "
	self.DisplayedDestinationChar2 = tonumber(self.DestinationChar2, 10) and self.DestinationChar2 ~= " " and self.DestinationChar2 or " "
	self.DisplayedDestinationChar3 = tonumber(self.DestinationChar3, 10) and self.DestinationChar3 ~= " " and self.DestinationChar3 or " "

	-- Apply the same principle as before to ensure that the CourseChar variables are valid.
	self.DisplayedCourseChar1 = tonumber(self.CourseChar1, 10) and self.CourseChar1 ~= " " and self.CourseChar1 or " "
	self.DisplayedCourseChar2 = tonumber(self.CourseChar2, 10) and self.CourseChar2 ~= " " and self.CourseChar2 or " "
	self.DisplayedCourseChar3 = tonumber(self.CourseChar3, 10) and self.CourseChar3 ~= " " and self.CourseChar3 or " "
	self.DisplayedCourseChar4 = tonumber(self.CourseChar4, 10) and self.CourseChar4 ~= " " and self.CourseChar4 or " "
	self.Destination = tonumber(self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3, 10) or 000
	self.ServiceAnnouncement = tonumber(self.AnnouncementChar1 .. self.AnnouncementChar2, 10) and self.AnnouncementChar1 .. self.AnnouncementChar2 or " "

	----print("Course Number:"..self.Train:GetNW2String("IBIS:CourseChar1",nil)..self.Train:GetNW2String("IBIS:CourseChar2")..self.Train:GetNW2String("IBIS:CourseChar3")..self.Train:GetNW2String("IBIS:CourseChar4")..self.Train:GetNW2String("IBIS:CourseChar5"))

	----print("IBIS loaded")

	----print(self.Route)

	-- math.Clamp(self.Route,0,99)
	-- math.Clamp(tonumber(self.Course),0,99999)
	-- math.Clamp(self.Destination,0,999)
	Train:SetNW2Int("IBIS:State", self.State)
	Train:SetNW2Int("IBIS:Route", self.Route)
	Train:SetNW2Int("IBIS:Destination", self.Destination)
	Train:SetNW2String("IBIS:DestinationText", self.DestinationString)
	Train:SetNW2Int("IBIS:Course", self.Course)
	Train:SetNW2Int("IBIS:MenuState", self.Menu)
	Train:SetNW2Int("IBIS:Menu", self.Menu)
	Train:SetNW2Int("IBIS:PowerOn", self.PowerOn)
	Train:SetNW2Int("IBIS:Booted", self.IBISBootupComplete)
	Train:SetNW2String("IBIS:KeyInput", self.KeyInput)
	Train:SetNW2String("IBIS:CourseChar4", self.CourseChar4)
	Train:SetNW2String("IBIS:CourseChar3", self.CourseChar3)
	Train:SetNW2String("IBIS:CourseChar2", self.CourseChar2)
	Train:SetNW2String("IBIS:CourseChar1", self.CourseChar1)
	Train:SetNW2String("IBIS:RouteChar1", self.RouteChar1)
	Train:SetNW2String("IBIS:RouteChar2", self.RouteChar2)
	Train:SetNW2String("IBIS:DestinationChar1", self.DestinationChar1)
	Train:SetNW2String("IBIS:DestinationChar2", self.DestinationChar2)
	Train:SetNW2String("IBIS:DestinationChar3", self.DestinationChar3)
	Train:SetNW2String("IBIS:ServiceAnnouncement", self.ServiceAnnouncement)

	self:InputProcessor(self.KeyInput)

	self.Course = self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4

	if self.CurrentStation ~= -1 and self.CurrentStation ~= nil and self.CurrentStation ~= 0 then
		self.Train:SetNW2String("CurrentStation", self.DestinationTable[self.CurrentStation])
	elseif self.CurrentStation == 0 then
		self.Train:SetNW2String("CurrentStation", " ")
	end

	if self.RouteChar1 .. self.RouteChar2 == "00" and self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4 == "0000" then -- forget the current station if we're not on line anymore
		self.CurrentStation = 0
	end
end

function TRAIN_SYSTEM:ResetCharValues()
	self.CourseChar1 = "0"
	self.CourseChar2 = "0"
	self.CourseChar3 = "0"
	self.CourseChar4 = "0"
	self.RouteChar1 = "0"
	self.RouteChar2 = "0"
	self.DestinationChar1 = "0"
	self.DestinationChar2 = "0"
	self.DestinationChar3 = "0"
	self.State = 1
	self.Menu = 0
end

function TRAIN_SYSTEM:ReadDataset()
	--[[ [i!] Explanation for those who don't speak German or who haven't spent too much time with this oddware:
    "Kurs" is is a two digit number that is appended to the line when entering the identification into the IBIS terminal.
    It serves as an ID to identify the service within the bunch of services running on the line. You might be asking, why not the wagon number suffices
    as an identifier. Well, one train firstly consists of multiple cars with multiple numbers so it can't serve as an ID for an entire train, and secondly,
    the schedules are arranged in circulations. For instance, as a driver in the real world you might be assigned the circulation U79/11. That means you're the eleventh
    train on the line, sent out neatly interspersed between the other services running the line. As such, the digital dispatching system is also organised so that a simple identifier is
    appended onto the line number. The route that is entered in the next step is only relevant for actually automatically routing the train along the line's path.

    In this example, the line is made up of two digits, though other models supported three or more depending on local requirements, directly followed by the Kurs: [LLKK]
    ]]

	local line = self.Course:sub(1, 2)
	if self.KeyInput == "Enter" and (self.Menu == 1 or self.Menu == 4) and self.State < 3 and self.LineTable[line] then
		if self.State == 2 and UF.RegisterTrain(self.Course, self.Train) then -- state 2 equals cold boot sequence, so switch over to Route prompt
			self.Menu = 5
			print("test")
			return
		elseif UF.RegisterTrain(self.Course, self.Train) then
			self.Menu = 0
			self.IndexValid = true
			return
		end
	elseif (self.Menu == 1 or self.Menu == 4) and self.State < 3 and self.KeyInput == "Enter" then
		if UF.RegisterTrain(self.Course, self.Train) == "logoff" then
			self.Menu = 0
			self.State = 0
			self.RouteChar1 = "0"
			self.RouteChar2 = "0"
			return
		end
	elseif (self.Menu == 2 or self.Menu == 5) and self.State < 3 and self.KeyInput == "Enter" and self.RouteChar2 ~= " " then
		if self.RouteChar1 == " " and tonumber(self.RouteChar2, 10) then self.RouteChar1 = "0" end
		local Route = self.RouteChar1 .. self.RouteChar2
		if self.RouteTable[line] then
			local routeTable = self.RouteTable[line][Route]
			if routeTable then
				print(routeTable[#routeTable])
				local destchars = tostring(routeTable[#routeTable])
				self.DestinationChar1 = destchars:sub(1, 1)
				self.DestinationChar2 = destchars:sub(2, 2)
				self.DestinationChar3 = destchars:sub(3, 3)
				self.FirstStation = routeTable[1]
				self.CurrentStation = self.FirstStation
				self.CurrentStationInternal = 1
				self.NextStation = self.RouteTable[self.CurrentStationInternal + 1]
				self.Menu = 0
				self.State = 1
			else
				self.Route = "00"
				self.IndexValid = false
			end
		elseif self.RouteChar1 .. self.RouteChar2 == "00" then
			self.Route = "00"
			self.CurrentStation = 0
			self.CurrentStationInternal = 0
			self.IndexValid = true
		end
	elseif (self.Menu == 1 or self.Menu == 4) and self.State < 3 and self.RouteChar1 .. self.RouteChar2 == "00" then
		self.CurrentStation = 0
		self.CurrentStationInternal = 0
		self.IndexValid = true
	elseif self.Menu == 3 and self.State < 3 and self.Destination ~= "   " then
		if self.DestinationTable[self.Destination] or self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3 == "000" then
			self.IndexValid = true
		else
			self.IndexValid = false
		end
	elseif self.Menu == 6 and self.State < 3 then
		self.IndexValid = self.ServiceAnnouncements[self.ServiceAnnouncement] ~= nil
	end
end

if CLIENT then
	function TRAIN_SYSTEM:ClientInitialize()
		self.LastBlinkTime = 0
		self.BlinkingText = false
		self.DefectStrings = {[1] = "IFIS FEHLER", [2] = "FUNK DEFEKT", [3] = "ENTWERTER 1 DEFEKT", [4] = "WEICHENST DEFEKT"}

	end
	function TRAIN_SYSTEM:BlinkText(enable, Text)
		if not enable then
			self.BlinkingText = false
		elseif CurTime() - self.LastBlinkTime > 1.5 then
			self:PrintText(0, 1.5, Text)
			if CurTime() - self.LastBlinkTime > 3 then self.LastBlinkTime = CurTime() end
		end
	end
end

function TRAIN_SYSTEM:AnnQueue(msg)
	local Announcer = self.Train.Announcer
	if msg and type(msg) ~= "table" then
		Announcer:Queue{msg}
	else
		Announcer:Queue(msg)
	end
end
TRAIN_SYSTEM.lastTrigger = 0
function TRAIN_SYSTEM:Play(time)
	local message = {}
	if CurTime() - self.lastTrigger < 1.5 then
		print("Bailing Play()", lastTrigger)
		return
	end
	self.lastTrigger = time

	local line = self.CourseChar1 .. self.CourseChar2
	local commonFiles = UF.IBISCommonFiles[self.Train:GetNW2Int("IBIS:CommonFiles", 1)]
	local announcementScript = UF.IBISAnnouncementScript[self.Train:GetNW2Int("IBIS:AnnouncementScript", 1)]
	for k, v in ipairs(announcementScript) do
		if v ~= "station" and type(commonFiles[v][1]) == "string" then
			local temp = {[1] = {[commonFiles[v][1]] = commonFiles[v][2]}}
			table.Add(message, temp)
		elseif announcementScript[k] == "station" then
			temp = UF.IBISAnnouncementMetadata[self.Train:GetNW2Int("IBIS:Announcements", 1)][self.CurrentStation][line][self.Route]
			table.Add(message, temp)
		end
		if k == #announcementScript then
			self:AnnQueue(message)
			return
		end
	end
end

if SERVER then
	function TRAIN_SYSTEM:OverrideSwitching(dir)
		local Train = self.Train
		if not (Train.BatteryOn or Train.CoreSys.CircuitOn or Train:ReadTrainWire(7) < 1) then return end
		self.Override = dir
	end

	function TRAIN_SYSTEM:InputProcessor(Input)

		if self.State == 1 and self.Menu == 0 then
			self.PreviousCourseNoted = false
			self.PreviousRouteNoted = false
			self.PreviousDestinationNoted = false
		end

		if self.State == 1 and self.Menu == 4 or self.Menu == 1 and self.State == 1 or self.State == 2 and self.Menu == 4 then -- only during startup in menus or manually triggered menus

			self:LinieKurs(self.KeyInput)

		elseif self.State == 1 and self.Menu == 5 or self.Menu == 2 and self.State == 1 or self.Menu == 5 and self.State == 2 then -- same procedure as above for routes as well

			self:RouteInput(self.KeyInput)

		elseif self.Menu == 3 and self.State == 1 then

			self:DestinationInput(self.KeyInput)

		elseif self.Menu == 6 and self.State == 1 then

			self:Announcement(self.KeyInput)
		end
	end
	function TRAIN_SYSTEM:LinieKurs(KeyInput) -- split Line/Course into a separate function

		if KeyInput == nil or KeyInput == "TimeAndDate" or KeyInput == "Enter" or KeyInput == "ServiceAnnouncements" then return end

		if KeyInput ~= "Delete" and KeyInput ~= nil and tonumber(KeyInput, 10) and not tonumber(self.CourseChar1, 10) then -- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
			self.CourseChar1 = self.CourseChar2
			self.CourseChar2 = self.CourseChar3
			self.CourseChar3 = self.CourseChar4
			self.CourseChar4 = KeyInput
		end

		if KeyInput == "Delete" and KeyInput ~= nil then
			self.CourseChar4 = self.CourseChar3
			self.CourseChar3 = self.CourseChar2
			self.CourseChar2 = self.CourseChar1
			self.CourseChar1 = " "
		end

	end
	function TRAIN_SYSTEM:RouteInput(Input) -- split Route into a separate function

		if Input == nil or Input == "TimeAndDate" or Input == "Enter" or Input == "ServiceAnnouncements" then return end
		if Input ~= nil and tonumber(Input, 10) and not tonumber(self.RouteChar1, 10) then -- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
			self.RouteChar1 = self.RouteChar2
			self.RouteChar2 = Input
		end

		if Input == "Delete" and Input ~= nil then
			self.RouteChar2 = self.RouteChar1
			self.RouteChar1 = " "
		end

	end
	function TRAIN_SYSTEM:DestinationInput(Input)
		if Input == nil or Input == "TimeAndDate" or Input == "Enter" or Input == "ServiceAnnouncements" then return end
		if Input ~= nil and tonumber(Input, 10) and not tonumber(self.DestinationChar1, 10) then -- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
			self.DestinationChar1 = self.DestinationChar2
			self.DestinationChar2 = self.DestinationChar3
			self.DestinationChar3 = Input
		end

		if Input == "Delete" and Input ~= nil then
			self.DestinationChar3 = self.DestinationChar2
			self.DestinationChar2 = self.DestinationChar1
			self.DestinationChar1 = " "
		end
	end
	function TRAIN_SYSTEM:Announcement(Input)
		-- print(self.AnnouncementChar1,self.AnnouncementChar2)
		if Input == nil or not tonumber(Input, 10) and Input ~= "Enter" and Input ~= "Delete" then return end

		if Input ~= nil and tonumber(Input, 10) and self.AnnouncementChar1 == " " and self.AnnouncementChar2 == " " then
			self.AnnouncementChar2 = Input
		elseif Input ~= nil and tonumber(Input, 10) and self.AnnouncementChar2 ~= " " and not (tonumber(self.AnnouncementChar1, 10) and tonumber(self.AnnouncementChar2, 10)) then
			self.AnnouncementChar1 = self.AnnouncementChar2
			self.AnnouncementChar2 = Input
		end

		if Input == "Delete" and Input ~= nil and (self.AnnouncementChar2 ~= " " or self.AnnouncementChar1 ~= " ") then
			self.AnnouncementChar2 = self.AnnouncementChar1
			self.AnnouncementChar1 = " "
		end
	end
end

function TRAIN_SYSTEM:DisasterTicker() -- Generate a random chance for defect simulation

	if CurTime() - self.LastRoll > 10 and self.State ~= 4 then
		local randomNumber = math.random(1, 10000)
		if randomnumber == 1 then
			self.State = 4
			self.Train:SetNW2Int("Defect", math.random(1, 4))
		end
		self.LastRoll = CurTime()
	end
end

function TRAIN_SYSTEM:CANReceive(SourceCar, target, targetdata)
	if SourceCar == self.Train then return end
	if target == "Line" then self.Line = targetdata end
	if target == "Route" then self.Route = targetdata end
	if target == "Course" then self.Course = targetdata end
	if target == "Destination" then self.Destination = targetdata end
	if target == "CurrentStation" then self.CurrentStation = targetdata end
	if target == "ServiceAnnouncement" then self.ServiceAnnouncement = targetdata end

end

function TRAIN_SYSTEM:CANWrite(target, targetdata)
	for i in self.Train.WagonList do
		local train = self.Train.WagonList[i]
		local sys = train[target]
		if sys and sys.CANReceive then sys:CANReceive(self.Train, target, targetdata) end
	end
end

function TRAIN_SYSTEM:CANBusRunner()

	local primary = self.KeyInserted
	local powered = self.Train.BatteryOn

	if primary and powered and #self.Train.WagonList > 1 then
		self:CANWrite(self.Train, "Line", self.Line)
		self:CANWrite(self.Train, "Route", self.Route)
		self:CANWrite(self.Train, "Course", self.Course)
		self:CANWrite(self.Train, "Destination", self.Destination)
		self:CANWrite(self.Train, "CurrentStation", self.CurrentStation)
	elseif not primary and powered then
		self.CANBus = true
	end

end

function TRAIN_SYSTEM:AnnouncementProcessor()

	local AnnouncementScript = UF.IBISAnnouncementScript[self.Train:GetNW2Int("IBIS:AnnouncementRoutine", 1)]
	local workingBuffer = {}
	local ProcessedInput = {}
	for i, v in pairs(AnnouncementScript) do table.Add(v, AnnouncementScript) end
end

function TRAIN_SYSTEM:Switching(Left, Right)
	-- Require 54 volts
	if self.Train.Battery and (self.Train.Battery.Voltage < 24) then return end

	self.Timer = self.Timer or CurTime()
	if CurTime() - self.Timer > 2.00 or self.TimerToggle then
		self.TimerToggle = nil
		self.Timer = CurTime()

		-- Get train position
		local pos = Metrostroi.TrainPositions[self.Train]
		if pos then pos = pos[1] end

		-- Get all switches in current isolated section
		local no_switches = true
		local signal = 0
		local Alt1, Alt2
		if pos then
			-- Get traffic light in front
			local light = Metrostroi.GetNextTrafficLight(pos.node1, pos.x, pos.forward)
			local function getSignal(base, chan)
				if (chan == 1) and (base == "alt") and light and light:GetInvertChannel1() then return "main" end
				if (chan == 2) and (base == "alt") and light and light:GetInvertChannel2() then return "main" end
				return base
			end

			-- Get switches and trigger them all
			local switches = Metrostroi.GetTrackSwitches(pos.node1, pos.x, pos.forward)
			for _, switch in pairs(switches) do
				Alt1 = Alt1 or (switch:GetChannel() == 1 and switch:GetSignal() > 0)
				Alt2 = Alt2 or (switch:GetChannel() == 2 and switch:GetSignal() > 0)
				no_switches = false
				if self.SelectAlternate == true then
					if self.Channel == 1 then switch:SendSignal(getSignal("alt", 1), 1) end
					if self.Channel == 2 then switch:SendSignal(getSignal("alt", 2), 2) end
				elseif self.SelectAlternate == false then
					if self.Channel == 1 then switch:SendSignal(getSignal("main", 1), 1) end
					if self.Channel == 2 then switch:SendSignal(getSignal("main", 2), 2) end
				end
				signal = math.max(signal, switch:GetSignal())
			end

			-- Reset state selection
		end
		self.Signal = signal
		self.Channel1Alternate = Alt1
		self.Channel2Alternate = Alt2
		-- If no switches, reset
		if (no_switches or not pos) and (self.SelectAlternate ~= nil) then self.Train:PlayOnce("dura2", "cabin", 0.30, 220) end
		self.SelectAlternate = nil
	end
end

function TRAIN_SYSTEM:AutomaticAnnouncement()
	local station = Metrostroi.Stations[self.CurrentStation]
	local dir = platform.PlatformEnd - platform.PlatformStart
	local pos1 = Metrostroi.GetPositionOnTrack(platform.PlatformStart, dir:Angle())[1]
	local pos2 = Metrostroi.GetPositionOnTrack(platform.PlatformEnd, dir:Angle())[1]

	local enteredVia = "null"

	local dir1 = "null"
	if pos2.x > pos1.x then
		dir1 = "up"
	elseif pos1.x < pos2.x then
		dir1 = "down"
	end

	local trainPos = Metrostroi.GetPositionOnTrack(self.Train:GetPos(), self.Train:GetAngles())[1]

	if enteredVia == "null" and trainPos.x == pos1.x then
		enteredVia = "start"
	elseif enteredVia == "null" and trainPos.x == pos1.x then
		enteredVia = "end"
	end

	if dir1 == "up" and enteredVia ~= "null" then
		if enteredVia == "start" and trainPos.x > pos2.x and trainPos.x - pos2.x > 30 then
			self.CurrentStationInternal = self.CurrentStationInternal + 1
			self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			enteredVia = "null" -- reset station entry point because we're gone from the station, so we need to rearm for next time.
		elseif enteredVia == "end" and trainPos.x < pos1.x and trainPos.x + pos1.x > 30 then -- station points upwards on the coordinate system and we are travelling downwards the system, that means the start is our last point of contact from which we measure distance, DOWNwards the coordinate system
			self.CurrentStationInternal = self.CurrentStationInternal + 1
			self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			enteredVia = "null"
		end
	elseif dir1 == "down" and enteredVia ~= "null" then
		if enteredVia == "start" and trainPos.x < pos2.x and trainPos.x + pos2.x > 30 then
			self.CurrentStationInternal = self.CurrentStationInternal + 1
			self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			enteredVia = "null"
		elseif enteredVia == "end" and trainPos.x > pos1.x and trainPos.x - pos1.x > 30 then
			self.CurrentStationInternal = self.CurrentStationInternal + 1
			self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
			enteredVia = "null"
		end
	elseif dir1 == "up" and enteredVia == "null" and (trainPos.x < pos1.x or trainPos.x > pos2.x) then -- if the train is in a terminus or got spawned there, there is no detected entry point, so just take any exit as the point to measure from
		self.CurrentStationInternal = self.CurrentStationInternal + 1
		self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
		enteredVia = "null"
	elseif dir2 == "down" and enteredVia == "null" and (trainPos.x < pos2.x or trainPos.x > pos1.x) then
		self.CurrentStationInternal = self.CurrentStationInternal + 1
		self.CurrentStation = self.RouteTable[self.CourseChar1 .. self.CourseChar2][self.RouteChar1 .. self.RouteChar2][self.CurrentStationInternal]
		enteredVia = "null"
	end
end
