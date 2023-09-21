Metrostroi.DefineSystem("IBIS")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
	self.Route = "-1" -- Route index number
	self.PromptRoute = " "
	self.RouteChar1 = "-1"
	self.RouteChar2 = "-1"
	self.DisplayedRouteChar1 = " "
	self.DisplayedRouteChar2 = " "

	self.Course = " " -- Course index number, format is LineLineCourseCourse
	self.CourseChar1 = "-1"
	self.CourseChar2 = "-1"
	self.CourseChar3 = "-1"
	self.CourseChar4 = "-1"
	self.CourseChar5 = "-1"
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

	self.Destination = "-1" -- Destination index number
	self.DestinationChar1 = "-1"
	self.DestinationChar2 = "-1"
	self.DestinationChar3 = "-1"
	self.DisplayedDestinationChar1 = " "
	self.DisplayedDestinationChar2 = " "
	self.DisplayedDestinationChar3 = " "

	self.AnnouncementChar1 = "-1"
	self.AnnouncementChar2 = "-1"
	self.SpecialAnnouncement = "-1"

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

function TRAIN_SYSTEM:Inputs() return {"KeyInput", "Power"} end
function TRAIN_SYSTEM:Outputs() return {"Course", "Route", "Destination", "State"} end

function TRAIN_SYSTEM:Trigger(name, time)

	if self.State > 0 then

		if name == "Number0" then
			if self.KeyRegistered == false then
				self.KeyInput = "0"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end
		elseif name == "Number1" then

			if self.KeyRegistered == false then
				self.KeyInput = "1"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number2" then

			if self.KeyRegistered == false then
				self.KeyInput = "2"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number3" then

			if self.KeyRegistered == false then
				self.KeyInput = "3"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number4" then

			if self.KeyRegistered == false then
				self.KeyInput = "4"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number5" then

			if self.KeyRegistered == false then
				self.KeyInput = "5"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number6" then
			if self.KeyRegistered == false then
				self.KeyInput = "6"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number7" then

			if self.KeyRegistered == false then
				self.KeyInput = "7"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number8" then

			if self.KeyRegistered == false then
				self.KeyInput = "8"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number9" then

			if self.KeyRegistered == false then
				self.KeyInput = "9"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Number0" then

			if self.KeyRegistered == false then
				self.KeyInput = "0"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Delete" then

			if self.KeyRegistered == false then
				self.KeyInput = "Delete"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Enter" then

			if self.KeyRegistered == false then
				self.KeyInput = "Enter"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == "Destination" then

			if self.KeyRegistered == false then
				self.KeyInput = "Destination"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end
		elseif name == "SpecialAnnouncement" then

			if self.KeyRegistered == false then
				self.KeyInput = "SpecialAnnouncements"
				self.KeyRegistered = true
			else
				self.KeyInput = nil
			end

		elseif name == nil then
			self.KeyInput = nil
			self.KeyRegistered = false
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
	local SpecialAnnouncement = self.Train:GetNW2String("IBIS:SpecialAnnouncement", " ")
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
			if self.CourseChar4 == "-1" then
				self:BlinkText(true, "Linie-Kurs:")
				self:PrintText(11.5, 1.5, Course)
			elseif self.CourseChar4 ~= "-1" then
				self:PrintText(0, 1.5, "Linie-Kurs:")
				self:PrintText(11.5, 1.5, Course)

			end

			return
		end

		if Menu == 5 then
			if self.RouteChar1 == "-1" then
				self:BlinkText(true, "Route :")
				self:PrintText(13.5, 1.5, Route)

			elseif self.RouteChar1 ~= "-1" then
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
			self:PrintText(13.5, 1.5, SpecialAnnouncement)
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
			self:PrintText(0, 1, "Ung. Ansage")
			return
		end
	end
	if State == 4 then self:BlinkText(true, self.DefectString[self.Train:GetNW2Int("Defect", 1)]) end
	if State == 5 and Menu == 4 or State == 5 and Menu == 1 then self:BlinkText(true, "Kurs besetzt") end

	return
end

function TRAIN_SYSTEM:Think()

	local Train = self.Train
	self.KeyInserted = self.Train.Duewag_U2.IBISKeyATurned

	if Train.BatteryOn then self:CANBus() end

	if self.Menu > 0 then self:ReadDataset() end

	if self.Menu == 0 and self.State > 0 then self.LineLookupComplete = false end

	self.RouteTable = UF.IBISRoutes[self.Train:GetNW2Int("IBIS:Routes")]

	self.DestinationTable = UF.IBISDestinations[self.Train:GetNW2Int("IBIS:Destinations")]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[self.Train:GetNW2Int("IBIS:ServiceA")]
	self.LineTable = UF.IBISLines[self.Train:GetNW2Int("IBIS:Lines")]
	-- Index number abstractions. An unset value is stored as -1, but we don't want the display to print -1. Instead, print a string of nothing.

	-- Make sure that displayed characters are never assigned the -1 value, because -1 symbolises an empty character. If something is -1, display empty.
	self.DisplayedRouteChar1 = tonumber(self.RouteChar1, 10) and tonumber(self.RouteChar1, 10) > -1 and self.RouteChar1 or " "
	self.DisplayedRouteChar2 = tonumber(self.RouteChar2, 10) and tonumber(self.RouteChar2, 10) > -1 and self.RouteChar2 or " "

	self.DisplayedDestinationChar1 = tonumber(self.DestinationChar1, 10) and tonumber(self.DestinationChar1, 10) > -1 and self.DestinationChar1 or " "
	self.DisplayedDestinationChar2 = tonumber(self.DestinationChar2, 10) and tonumber(self.DestinationChar2, 10) > -1 and self.DestinationChar2 or " "
	self.DisplayedDestinationChar3 = tonumber(self.DestinationChar3, 10) and tonumber(self.DestinationChar3, 10) > -1 and self.DestinationChar3 or " "

	-- Apply the same principle as before to ensure that the CourseChar variables are valid.
	self.DisplayedCourseChar1 = tonumber(self.CourseChar1, 10) and tonumber(self.CourseChar1, 10) > -1 and self.CourseChar1 or " "
	self.DisplayedCourseChar2 = tonumber(self.CourseChar2, 10) and tonumber(self.CourseChar2, 10) > -1 and self.CourseChar2 or " "
	self.DisplayedCourseChar3 = tonumber(self.CourseChar3, 10) and tonumber(self.CourseChar3, 10) > -1 and self.CourseChar3 or " "
	self.DisplayedCourseChar4 = tonumber(self.CourseChar4, 10) and tonumber(self.CourseChar4, 10) > -1 and self.CourseChar4 or " "
	self.Destination = tonumber(self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3, 10) or 000

	----print("Course Number:"..self.Train:GetNW2String("IBIS:CourseChar1",nil)..self.Train:GetNW2String("IBIS:CourseChar2")..self.Train:GetNW2String("IBIS:CourseChar3")..self.Train:GetNW2String("IBIS:CourseChar4")..self.Train:GetNW2String("IBIS:CourseChar5"))

	----print("IBIS loaded")
	if self.Train.BatteryOn == true and self.Train:GetNW2Bool("TurnIBISKey", false) == true then
		self.PowerOn = 1
		self.Train:SetNW2Bool("IBISPowerOn", true)
		----print("IBIS powered")
	elseif self.Train.BatteryOn == true and self.Train:GetNW2Bool("TurnIBISKey", false) == false then
		self.PowerOn = 0
		self.Train:SetNW2Bool("IBISPowerOn", false)
		self.State = 0
		self.Menu = 0
		self.Train:SetNW2Bool("IBISBootupComplete", false)
		self.Train:SetNW2Bool("IBISChime", false)
	elseif self.Train.BatteryOn == false and self.Train:GetNW2Bool("TurnIBISKey", false) == false then
		self.PowerOn = 0
		self.Train:SetNW2Bool("IBISPowerOn", false)
		self.State = 0
		self.Menu = 0
		self.Train:SetNW2Bool("IBISBootupComplete", false)
		self.Train:SetNW2Bool("IBISChime", false)
	elseif self.Train.BatteryOn == false and self.Train:GetNW2Bool("TurnIBISKey", false) == true then
		self.PowerOn = 0
		self.Train:SetNW2Bool("IBISPowerOn", false)
		self.State = 0
		self.Menu = 0
		self.Train:SetNW2Bool("IBISBootupComplete", false)
		self.Train:SetNW2Bool("IBISChime", false)
		self.JustBooted = false
	end

	if self.PowerOn == 1 and self.ColdBoot then -- cold start
		self.PowerOffMoment = 0
		if self.PowerOnRegistered == false then -- register timer variable for simulated bootup
			self.PowerOnMoment = CurTime()
			self.PowerOnRegistered = true
			-- print("register",RealTime())
		end
		if CurTime() - self.PowerOnMoment > 5 then
			self.Train:SetNW2Bool("IBISBootupComplete", true) -- register that simulated bootup wait has passed
			self.Train:SetNW2Bool("IBISChime", true)
			self.ColdBoot = false
		end
	elseif self.PowerOn == 1 and not self.ColdBoot then -- warm start
		self.PowerOffMoment = 0
		if self.PowerOnRegistered == false then -- register timer variable for simulated bootup
			self.PowerOnMoment = CurTime()
			self.PowerOnRegistered = true
			-- print("register",RealTime())
		end
		if CurTime() - self.PowerOnMoment > 5 then
			self.Train:SetNW2Bool("IBISBootupComplete", true) -- register that simulated bootup wait has passed
			self.Train:SetNW2Bool("IBISChime", true)
			self.ColdBoot = false
		end
	elseif self.PowerOn == 0 then
		self.PowerOnRegistered = false -- reset variables if device is off
		self.PowerOnMoment = 0
		if not self.PowerOffMomentRegistered then --note when the device was switched off, to simulate the RAM losing data after an amount of time
			self.PowerOffMomentRegistered = true
			self.PowerOffMoment = CurTime()
		end

	end

	if self.Train:GetNW2Bool("IBISBootupComplete", false) == true then
		if self.JustBooted == false and self.ColdBoot then -- from a cold boot we start right into the prompt, if no data is already present on the CAN bus
			self.State = 2
			self.Menu = 4
			self.JustBooted = true
		elseif not self.JustBooted then
			self.State = 1
			self.Menu = 0
			self.JustBooted = true
		end
	end

	if self.State == 2 and self.Menu == 4 then
		if self.KeyInput == "Enter" and self.IndexValid == true and self.RBLRegistered == true then
			self.Menu = 5
			-- print("Got past RBL and index lookup")
		elseif self.KeyInput == "Enter" and self.IndexValid == false then
			self.Menu = 4
			self.State = 3
			-- print("Index Number invalid")
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
		elseif self.KeyInput == "Enter" and self.RBLRegisterFailed == true and self.IndexValid == true then
			self.State = 5
			self.Menu = 4
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
		elseif self.KeyInput == "Enter" and self.RBLRegistered == false and self.RBLSignedOff == true then
			-- print("IBIS logged off RBL")
			self.CourseChar1 = 0
			self.CourseChar2 = 0
			self.CourseChar3 = 0
			self.CourseChar4 = 0
			self.RouteChar1 = 0
			self.RouteChar2 = 0
			self.DestinationChar1 = 0
			self.DestinationChar2 = 0
			self.DestinationChar3 = 0
			self.State = 1
			self.Menu = 0
		end
	end

	if self.State == 5 and self.Menu == 4 then
		self.Train:SetNW2Bool("IBISError", false)
		if CurTime() - self.ErrorMoment > 2 then
			if self.KeyInput == "Enter" then
				self.State = 2
				self.Menu = 4
			end
		end
	end

	if self.State == 2 and self.Menu == 5 and self.Route ~= 0 then
		if self.KeyInput == "Enter" and self.IndexValid == true then
			self.State = 1
			self.Menu = 0
		elseif self.KeyInput == "Enter" and self.IndexValid == false then
			self.Menu = 5
			self.State = 3
			-- print("Index Number invalid")
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
		end

	end

	if self.State == 3 then -- IBIS ran into a missing index number of any sort, bumb the current state to 3
		self.LineLookupComplete = false
		if CurTime() - self.ErrorMoment > 5 then
			if self.KeyInput == "Enter" then
				self.State = 2
				self.Train:SetNW2Bool("IBISError", false)
				self.RBLRegisterFailed = false
				self.PhonedHome = false
			end

		end
	end

	if self.State == 4 then -- We're in the defect state

		if self.KeyInput == "Enter" then -- just confirm. Some IBIS devices just thought stuff was broken while it wasn't.
			self.State = 1
		end
	end
	if self.State == 1 and self.Menu == 0 then
		self.PreviousCourseNoted = false
		self.SpecialAnnouncement = " "
		self.AnnouncementChar1 = "-1"
		self.AnnouncementChar2 = "-1"
		self.Train:SetNW2String("ServiceAnnouncement", "")
		self.LineLookupComplete = false
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
		elseif self.KeyInput == "SpecialAnnouncements" then
			self.Menu = 6
		elseif self.KeyInput == "9" then
			self:Play()
		end
	elseif self.State == 1 and self.Menu == 1 then
		self.RBLSignedOff = false

		if self.KeyInput == "Enter" and self.IndexValid == true and self.RBLRegisterFailed == false then
			self.Menu = 0
			self.RBLSignedOff = false
			self.LineLookupComplete = false
			self.DestinationChar1 = "-1"
			self.DestinationChar2 = "-1"
			self.DestinationChar3 = "-1"
			self.RouteChar1 = "-1"
			self.RouteChar2 = "-1"
			self.CurrentStation = 0
			self.CurrentStationInternal = 0
			self.PhonedHome = false
		elseif self.KeyInput == "Enter" and self.IndexValid == false then
			self.Menu = 4
			self.State = 3
			-- print("Index Number invalid")
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
			self.LineLookupComplete = false
		elseif self.KeyInput == "Enter" and self.RBLRegisterFailed == true and self.IndexValid == true then
			self.State = 5
			self.Menu = 4
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
			self.LineLookupComplete = false
		elseif self.KeyInput == "Enter" and self.RBLRegistered == false and self.RBLSignedOff == true then
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
			self.CurrentStation = 0
			self.CurrentStationInternal = 0
			self.LineLookupComplete = false
			self.RBLSignedOff = false
		elseif self.KeyInput == "Delete" and self.Course == "-1-1-1-1" then
			self.Course = self.PreviousCourse
			self.Menu = 0
		end
	elseif self.State == 1 and self.Menu == 2 then
		if self.KeyInput == "Enter" and self.IndexValid == true then
			self.State = 1
			self.Menu = 0
		elseif self.KeyInput == "Enter" and self.IndexValid == false then
			self.Menu = 5
			self.State = 3
			-- print("Index Number invalid")
			self.Train:SetNW2Bool("IBISError", true)
			self.ErrorMoment = CurTime()
		end
	elseif self.State == 1 and self.Menu == 3 then
		if self.KeyInput == "Enter" then self.Menu = 0 end
	elseif self.State == 1 and self.Menu == 6 then
		if self.KeyInput == "Enter" then
			if self.ServiceAnnouncement ~= "00" and self.Menu == 6 and self.IndexValid == true then

				self:AnnQueue(self.ServiceAnnouncements[self.ServiceAnnouncement])

				-- print(self.ServiceAnnouncements[self.ServiceAnnouncement])
				self.Menu = 0
			elseif self.ServiceAnnouncement == "00" then
				self.Menu = 0
				self.ServiceAnnouncement = "  "
			else
				self.State = 3
				self.Train:SetNW2Bool("IBISError", true)
				self.ErrorMoment = CurTime()
			end
		elseif self.KeyInput == "Delete" and self.ServiceAnnouncement == "-1-1" then
			self.Menu = 0
		end
	end
	-- print(self.State, self.Menu)
	if self.State == 0 and not self.CANBus and self.PowerOffMomentRegistered and CurTime() - self.PowerOffMoment > 240 then
		self.LineLookupComplete = false
		self.BootupComplete = false
		self.Course = "0" -- Course index number, format is LineLineCourseCourse
		self.CourseChar1 = "-1"
		self.CourseChar2 = "-1"
		self.CourseChar3 = "-1"
		self.CourseChar4 = "-1"
		self.CourseChar5 = "-1"
		self.DisplayedCourseChar1 = " "
		self.DisplayedCourseChar2 = " "
		self.DisplayedCourseChar3 = " "
		self.DisplayedCourseChar4 = " "
		self.PreviousCourse = "0"
		self.Route = "0" -- Route index number
		self.RouteChar1 = "-1"
		self.RouteChar2 = "-1"
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
		self.DestinationChar1 = "-1"
		self.DestinationChar2 = "-1"
		self.DestinationChar3 = "-1"
		self.DisplayedDestinationChar1 = " "
		self.DisplayedDestinationChar2 = " "
		self.DisplayedDestinationChar3 = " "

		self.AnnouncementChar1 = "-1"
		self.AnnouncementChar2 = "-1"
		self.SpecialAnnouncement = " "

		self.CurrentStationInternal = 0
	end

	----print(self.Route)

	-- math.Clamp(self.Route,0,99)
	-- math.Clamp(tonumber(self.Course),0,99999)
	-- math.Clamp(self.Destination,0,999)
	Train:SetNW2Int("IBIS:State", self.State)
	Train:SetNW2Int("IBIS:Route", self.Route)
	Train:SetNW2Int("IBIS:Destination", self.Destination)
	Train:SetNW2String("IBIS:DestinationText", self.DestinationTable[self.Destination])
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
	Train:SetNW2String("IBIS:SpecialAnnouncement", self.ServiceAnnouncement)

	-- if self.KeyInput ~=nil then
	self:InputProcessor(self.KeyInput)
	-- end
	-- if self.Menu > 0 then
	--    self.Course = self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4
	-- end
	-- print(self.Course)
	if self.KeyInput ~= nil then
		-- print(self.KeyInput)
	end

	-- SetGlobal2Int("TrainID"..self.TrainID,self.Course..self.Route..self.TrainID)
	if self.Train.Duewag_U2.LeadingCab == 1 then
		self:SyncIBIS()
	else
	end

	if self.CurrentStation ~= -1 and self.CurrentStation ~= nil and self.CurrentStation ~= 0 then
		self.Train:SetNW2String("CurrentStation", self.DestinationTable[self.CurrentStation])
	elseif self.CurrentStation == 0 then
		self.Train:SetNW2String("CurrentStation", " ")
	end

	-- print(self.CurrentStationInternal)
	-- print(self.ServiceAnnouncements[1])
	-- print(self.CurrentStation)
	-- print(self.RBLSignedOff, "rbl signed off")
	-- print(self.LineLookupComplete, "line lookup complete")
	-- print(self.Course)
	if self.RouteChar1 .. self.RouteChar2 == "00" and self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4 == "0000" then -- forget the current station if we're not on line anymore
		self.CurrentStation = 0
	end
end

function TRAIN_SYSTEM:RBLPhoneHome(Course)
	if UF.RegisterTrain(Course, self.Train) == true and self.PhonedHome == false then self.PhonedHome = true end
	if self.PhonedHome == true then
		return true
	else
		return false
	end
end

function TRAIN_SYSTEM:ReadDataset()
	----print(tonumber(self.CourseChar1..self.CourseChar2,10))
	----print(self.LineTable[1])
	----print(tonumber(string.sub(self.Course, 1, 2)))
	-- print(self.LineTable["01"])
	if self.Menu == 1 and self.State == 1 or self.Menu == 4 and self.State < 3 then
		if self.CourseChar1 ~= " " and self.CourseChar2 ~= " " and self.CourseChar3 ~= " " and self.CourseChar4 ~= " " then -- reference the Line number with the provided dataset, self.Course contains the line number as part of the first two digits of the variable
			local line = self.CourseChar1 .. self.CourseChar2
			if self.LineTable[line] ~= nil then
				self.IndexValid = true
				-- print("Line Lookup succeeded", self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4)
				-- print(self:RBLPhoneHome())
				if self:RBLPhoneHome(self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4, self.Train) and self.RBLRegistered == false then

					self.RBLRegistered = true
					self.RBLSignedOff = false
					print("IBIS logged onto RBL")
				end
				if self.RBLRegistered == true then

					self.RBLRegisterFailed = false
					self.RBLSignedOff = false
					print("IBIS logged onto RBL", self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4)
				end
				if self:RBLPhoneHome(self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4, self.Train) == false then

					self.RBLRegisterFailed = true
					self.RBLRegistered = false

				end
			elseif UF.RegisterTrain(self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4, self.Train) == "logoff" and self.RBLRegistered == true and self.KeyInput
						== "Enter" then
				self.IndexValid = true
				self.RBLSignedOff = true
				self.RBLRegistered = false
				self.RBLRegisterFailed = false
				self.LineLookupComplete = true
				print("RegisterTrain logged off")
				self.RouteChar1 = "0"
				self.RouteChar2 = "0"
			elseif self.LineTable[line] == nil and self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4 ~= "0000" then
				if self.KeyInput == "Enter" then
					self.IndexValid = false
					print("Index invalid")
					print(self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4)
				end
			end

		end
		self.LineLookupComplete = true
	elseif self.Menu == 2 and self.State < 3 or self.Menu == 5 and self.State < 3 then
		if self.RouteChar1 ~= " " and self.RouteChar2 ~= " " then
			local line = self.CourseChar1 .. self.CourseChar2
			if self.RouteTable[line] then
				if self.RouteChar2 ~= " " and tonumber(self.RouteChar2, 10) < 10 and self.RouteChar1 == " " then -- treat a simple input of 1 to 9 as 01 to 09
					local AbstractedRoute = "0" .. self.RouteChar2
				end
				if not AbstractedRoute and self.RouteTable[line][self.RouteChar1 .. self.RouteChar2] then
					local destchars = self.RouteTable[line][self.RouteChar1 .. self.RouteChar2][#self.RouteTable[line][self.RouteChar1 .. self.RouteChar2]]
					self.DestinationChar1 = string.sub(destchars, 1, 1)
					self.DestinationChar2 = string.sub(destchars, 2, 2)
					self.DestinationChar3 = string.sub(destchars, 3, 3)
					self.FirstStation = self.RouteTable[line][self.RouteChar1 .. self.RouteChar2][1]
					self.CurrentStation = self.FirstStation
					self.CurrentStationInternal = 1
					self.NextStation = self.RouteTable
					-- print(self.Destination.."Destination index")
					self.IndexValid = true
				elseif AbstractedRoute and self.RouteTable[line][AbstractedRoute] then
					local destchars = self.RouteTable[line][AbstractedRoute][#self.RouteTable[line][AbstractedRoute]]
					self.DestinationChar1 = string.sub(destchars, 1, 1)
					self.DestinationChar2 = string.sub(destchars, 2, 2)
					self.DestinationChar3 = string.sub(destchars, 3, 3)
					self.FirstStation = self.RouteTable[line][self.RouteChar1 .. self.RouteChar2][1]
					self.CurrentStation = self.FirstStation
					self.CurrentStationInternal = 1
					self.NextStation = self.RouteTable
					-- print(self.Destination.."Destination index")
					self.IndexValid = true
				else
					-- self.State = 3
					self.Route = "0"
					self.IndexValid = false
				end
			elseif self.RouteChar1 .. self.RouteChar2 == "00" then
				self.IndexValid = true
				self.Route = "0"
				self.CurrentStation = 0
				self.CurrentStationInternal = 0
			end
		end
	elseif self.Menu == 1 and self.State < 3 or self.Menu == 4 and self.State < 3 then
		if self.RouteChar1 .. self.RouteChar2 == "00" then
			self.IndexValid = true
			self.Route = "0"
			self.CurrentStation = 0
			self.CurrentStationInternal = 0
		end
	elseif self.Menu == 3 and self.State < 3 then

		if self.Destination ~= "   " then -- reference the destination index number with the dataset

			if self.DestinationTable[self.Destination] then
				self.Destination = self.Destination
				self.IndexValid = true
			elseif self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3 == "000" then
				self.IndexValid = true
			else
				self.IndexValid = false
			end
		end
	elseif self.Menu == 6 and self.State < 3 then
		if self.ServiceAnnouncements[self.ServiceAnnouncement] then
			self.ServiceAnnouncement = self.ServiceAnnouncement
			self.IndexValid = true
		else

			self.IndexValid = false
		end
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

function TRAIN_SYSTEM:Play()
	local message = {}
	-- print("Current Station", self.CurrentStation)
	local tbl = UF.IBISAnnouncementMetadata[self.Train:GetNW2Int("IBIS:Announcements", 1)][self.CurrentStation][self.CourseChar1 .. self.CourseChar2][self.Route]
	local station = false
	-- print("Course",self.CourseChar1..self.CourseChar2)
	-- print("Route",self.Route)
	for k, v in ipairs(UF.IBISAnnouncementScript[self.Train:GetNW2Int("IBIS:AnnouncementScript", 1)]) do

		for ke, va in pairs(UF.IBISCommonFiles[self.Train:GetNW2Int("IBIS:AnnouncementScript", 1)]) do if v == ke then table.insert(message, 1, va) end end

	end

	self:AnnQueue(message)
	if station == false then
		station = true
		for key, value in ipairs(tbl) do
			local stbl = tbl[key]
			for ky, vl in pairs(stbl) do
				message = {}
				local pairTable = {}
				print(ky, vl)
				pairTable[ky] = vl
				table.insert(message, pairTable)
				self:AnnQueue(message)
			end

		end
	end
	if station == true then
		message = {}
		for k, v in ipairs(UF.IBISAnnouncementScript[self.Train:GetNW2Int("IBIS:AnnouncementScript", 1)]) do
			if k ~= 1 and v ~= "station" then
				for ke, va in pairs(UF.IBISCommonFiles[self.Train:GetNW2Int("IBIS:AnnouncementScript", 1)]) do if v == ke then table.insert(message, 1, va) end end
			end
			if next(message) then self:AnnQueue(message) end
		end

	end

end

if SERVER then

	function TRAIN_SYSTEM:InputProcessor(Input)

		if self.State == 1 and self.Menu == 0 then
			self.PreviousCourseNoted = false
			self.PreviousRouteNoted = false
			self.PreviousDestinationNoted = false
		end

		if self.State == 1 and self.Menu == 4 or self.Menu == 1 and self.State == 1 or self.State == 2 and self.Menu == 4 then -- only during startup in menus or manually triggered menus

			if self.PreviousCourseNoted == false and self.State ~= 2 then
				self.PreviousCourseNoted = true
				self.PreviousCourse = self.Course -- note the course we had before in order to restore it in case the prompt is empty and the user presses Delete again to return to main menu
				-- print("course remembered:", self.PreviousCourse)
			end

			if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" then
				if self.CourseChar4 == "-1" and self.CourseChar3 == "-1" and self.CourseChar2 == "-1" and self.CourseChar1 == "-1" then

					if self.KeyInput ~= nil then self.CourseChar4 = self.KeyInput end

				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 == "-1" and self.CourseChar2 == "-1" and self.CourseChar1 == "-1" then

					self.CourseChar3 = self.CourseChar4
					if self.KeyInput ~= nil then self.CourseChar4 = self.KeyInput end

				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 == "-1" and self.CourseChar1 == "-1" then

					self.CourseChar2 = self.CourseChar3
					self.CourseChar3 = self.CourseChar4
					if self.KeyInput ~= nil then self.CourseChar4 = self.KeyInput end
				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 ~= "-1" and self.CourseChar1 == "-1" then

					self.CourseChar1 = self.CourseChar2
					self.CourseChar2 = self.CourseChar3
					self.CourseChar3 = self.CourseChar4
					if self.KeyInput ~= nil then
						self.CourseChar4 = self.KeyInput
					else
						self.CourseChar4 = self.CourseChar4
					end
				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 ~= "-1" and self.CourseChar1 ~= "-1" then

					--[[self.CourseChar1 = self.CourseChar2
					self.CourseChar2 = self.CourseChar3						
					self.CourseChar3 = self.CourseChar4
					if self.KeyInput ~= nil then
						self.CourseChar4 = self.KeyInput
					else
						self.CourseChar4 = self.CourseChar4
					end]]
				end

			elseif Input ~= nil and Input == "Delete" then
				if self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 ~= "-1" and self.CourseChar1 ~= "-1" then

					self.CourseChar4 = self.CourseChar3
					self.CourseChar3 = self.CourseChar2
					self.CourseChar2 = self.CourseChar1
					self.CourseChar1 = "-1"
				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 ~= "-1" and self.CourseChar1 == "-1" then
					self.CourseChar4 = self.CourseChar3
					self.CourseChar3 = self.CourseChar2
					self.CourseChar2 = "-1"
				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 ~= "-1" and self.CourseChar2 == "-1" and self.CourseChar1 == "-1" then
					self.CourseChar4 = self.CourseChar3
					self.CourseChar3 = self.CourseChar2
					self.CourseChar3 = "-1"
				elseif self.CourseChar4 ~= "-1" and self.CourseChar3 == "-1" and self.CourseChar2 == "-1" and self.CourseChar1 == "-1" then
					self.CourseChar4 = "-1"
				end

			end
		elseif self.State == 1 and self.Menu == 5 or self.Menu == 2 and self.State == 1 or self.Menu == 5 and self.State == 2 then

			self.Route = self.RouteChar1 .. self.RouteChar2
			if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" then
				if self.RouteChar2 == "-1" and self.RouteChar1 == "-1" then
					self.RouteChar2 = self.KeyInput

				elseif self.RouteChar2 ~= "-1" and self.RouteChar1 == "-1" then

					self.RouteChar1 = self.RouteChar2

					if self.KeyInput ~= nil then self.RouteChar2 = self.KeyInput end
				elseif self.RouteChar2 ~= "-1" and self.RouteChar1 ~= "-1" then
					self.RouteChar1 = self.RouteChar2

					if self.KeyInput ~= nil then self.RouteChar2 = self.KeyInput end
				end
			elseif Input ~= nil and Input == "Delete" then
				if self.RouteChar1 ~= "-1" and self.RouteChar2 ~= "-1" then
					self.RouteChar2 = self.RouteChar1
					self.RouteChar1 = "-1"
				elseif self.RouteChar1 == "-1" and self.RouteChar2 ~= "-1" then
					self.RouteChar2 = "-1"
					self.RouteChar1 = "-1"
				elseif self.RouteChar1 == "-1" and self.RouteChar2 == "-1" then
					self.RouteChar2 = "-1"
					self.RouteChar1 = "-1"
				end
			end
		elseif self.Menu == 3 and self.State == 1 then
			if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "SpecialAnnouncements" then
				if self.DestinationChar3 == "-1" and self.DestinationChar2 == "-1" and self.DestinationChar1 == "-1" then

					if self.KeyInput ~= nil then self.DestinationChar3 = self.KeyInput end

				elseif self.DestinationChar3 ~= "-1" and self.DestinationChar2 == "-1" and self.DestinationChar1 == "-1" then

					self.DestinationChar2 = self.DestinationChar3

					if self.KeyInput ~= nil then self.DestinationChar3 = self.KeyInput end
				elseif self.DestinationChar3 ~= "-1" and self.DestinationChar2 ~= "-1" and self.DestinationChar1 == "-1" then

					self.DestinationChar1 = self.DestinationChar2

					if self.KeyInput ~= nil then self.DestinationChar3 = self.KeyInput end
				elseif self.DestinationChar3 ~= "-1" and self.DestinationChar2 ~= "-1" and self.DestinationChar1 ~= "-1" then
					self.DestinationChar1 = self.DestinationChar2
					self.DestinationChar2 = self.DestinationChar3
					if self.KeyInput ~= nil then self.DestinationChar3 = self.KeyInput end
				end
				self.Destination = self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3
			elseif Input ~= nil and Input == "Delete" and Input ~= "TimeAndDate" and Input ~= "SpecialAnnouncements" then
				if self.DestinationChar3 ~= "-1" and self.DestinationChar2 ~= "-1" and self.DestinationChar1 ~= "-1" then

					self.DestinationChar1 = self.DestinationChar2
					self.DestinationChar1 = "-1"
					self.DestinationChar3 = self.DestinationChar2
				elseif self.DestinationChar3 ~= "-1" and self.DestinationChar2 ~= "-1" and self.DestinationChar1 == "-1" then
					self.DestinationChar2 = self.DestinationChar3
					self.DestinationChar2 = "-1"
				elseif self.DestinationChar3 ~= "-1" and self.DestinationChar2 == "-1" and self.DestinationChar1 == "-1" then
					self.DestinationChar3 = "-1"
				end
			end
		elseif self.Menu == 6 and self.State == 1 then
			self.ServiceAnnouncement = tonumber(self.AnnouncementChar1 .. self.AnnouncementChar2, 10) and tonumber(self.AnnouncementChar1 .. self.AnnouncementChar2, 10) > -1
						                           and self.AnnouncementChar1 .. self.AnnouncementChar2 or "  "
			if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" then
				if self.AnnouncementChar2 == "-1" and self.AnnouncementChar1 == "-1" then
					self.AnnouncementChar2 = self.KeyInput

				elseif self.AnnouncementChar2 ~= "-1" and self.AnnouncementChar1 == "-1" then

					self.AnnouncementChar1 = self.AnnouncementChar2

					self.AnnouncementChar2 = self.KeyInput

				elseif self.AnnouncementChar2 ~= "-1" and self.AnnouncementChar1 ~= "-1" then
					self.AnnouncementChar1 = self.AnnouncementChar2
					self.AnnouncementChar2 = self.KeyInput

				end
			elseif Input ~= nil and Input == "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" then
				if self.AnnouncementChar1 ~= "-1" and self.AnnouncementChar2 ~= "-1" then
					self.AnnouncementChar2 = self.AnnouncementChar1
					self.AnnouncementChar1 = "-1"
				elseif self.AnnouncementChar1 == "-1" and self.AnnouncementChar2 ~= "-1" then
					self.AnnouncementChar2 = "-1"
					self.AnnouncementChar1 = "-1"
				end
			end
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

function TRAIN_SYSTEM:CANBus()

	local primary = self.KeyInserted
	local powered = self.Train.BatteryOn

	if primary and powered then
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
