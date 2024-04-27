Metrostroi.DefineSystem("IBIS_secondary")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()

	if self.Train.SectionA then
		self.Primary = self.Train.SectionA.IBIS

		self.Route = self.Primary.Route
		self.RouteChar1 = self.Primary.RouteChar1
		self.RouteChar2 = self.Primary.RouteChar2
		self.DisplayedRouteChar1 = self.Primary.DisplayedRouteChar1
		self.DisplayedRouteChar2 = self.Primary.DisplayedRouteChar2

		self.DestinationText = self.Primary.DestinationText
		self.Destination = self.Primary.Destination
		self.FirstStation = self.Primary.FirstStation
		self.FirstStationString = self.Primary.FirstStationString
		self.CurrentStatonString = self.Primary.CurrentStationString
		self.CurrentStation = self.Primary.CurrentStation
		self.NextStationString = self.Primary.NextStationString
		self.NextStation = self.Primary.NextStation

		self.JustBooted = false
		self.PowerOn = 0
		self.IBISBootupComplete = 0
		self.Debug = 1

		self.BlinkText = false
		self.LastBlinkTime = 0

		self.KeyInputDone = false

		self.BootupComplete = false
		self.Course = self.Primary.Course -- Course index number, format is LineLineCourseCourse
		self.CourseChar1 = self.Primary.CourseChar1
		self.CourseChar2 = self.Primary.CourseChar2
		self.CourseChar3 = self.Primary.CourseChar3
		self.CourseChar4 = self.Primary.CourseChar4

		self.DisplayedCourseChar1 = self.Primary.DisplayedCourseChar1
		self.DisplayedCourseChar2 = self.Primary.DisplayedCourseChar2
		self.DisplayedCourseChar3 = self.Primary.DisplayedCourseChar3
		self.DisplayedCourseChar4 = self.Primary.DisplayedCourseChar4

		self.DefectChance = math.random(0, 100)
		self.LastRoll = CurTime()

		self.Destination = self.Primary.Destination -- Destination index number
		self.DestinationChar1 = self.Primary.DestinationChar1
		self.DestinationChar2 = self.Primary.DestinationChar2
		self.DestinationChar3 = self.Primary.DestinationChar3
		self.DisplayedDestinationChar1 = self.Primary.DisplayedDestinationChar1
		self.DisplayedDestinationChar2 = self.Primary.DisplayedDestinationChar2
		self.DisplayedDestinationChar3 = self.Primary.DisplayedDestinationChar3

		self.AnnouncementChar1 = self.Primary.AnnouncementChar1
		self.AnnouncementChar2 = self.Primary.AnnouncementChar2
		self.SpecialAnnouncement = self.Primary.SpecialAnnouncement

		self.CurrentStationInternal = self.Primary.CurrentStationInternal

		self.KeyInput = nil

		self.KeyRegistered = false

		self.ErrorMoment = 0

		self.ErrorAcknowledged = false

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
		self.State = self.Primary.State

		self.Menu = self.Primary.Menu -- which menu are we in
		self.Announce = false

	end

end

if TURBOSTROI then return end

if TRAIN_SYSTEM.Train and TRAIN_SYSTEM.Train.SectionA ~= nil then TRAIN_SYSTEM:Initialize() end

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
		antialias = false, -- can be disabled for pixel perfect font, but at low resolution the font is looks corrupted
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
	if IsValid(self.Train.SectionA) then
		local Menu = self.Train.SectionA:GetNW2Int("IBIS:Menu")
		local State = self.Train.SectionA:GetNW2Int("IBIS:State")
		local Route = self.Train.SectionA:GetNW2String("IBIS:RouteChar1") .. self.Train.SectionA:GetNW2String("IBIS:RouteChar2")
		local Course =
					self.Train.SectionA:GetNW2String("IBIS:CourseChar1") .. self.Train.SectionA:GetNW2String("IBIS:CourseChar2") .. self.Train.SectionA:GetNW2String("IBIS:CourseChar3")
								.. self.Train.SectionA:GetNW2String("IBIS:CourseChar4")
		local Destination = self.Train.SectionA:GetNW2String("IBIS:DestinationChar1") .. self.Train.SectionA:GetNW2String("IBIS:DestinationChar2")
					                    .. self.Train.SectionA:GetNW2String("IBIS:DestinationChar3")
		-- local DestinationText = self.Train.SectionA:GetNW2String("IBIS:DestinationText"," ")
		local CurrentStation = self.Train.SectionA:GetNW2String("CurrentStation", 0)
		local SpecialAnnouncement = self.Train.SectionA:GetNW2String("IBIS:SpecialAnnouncement", " ")
		----print(Route)
		----print(Course)

		local PowerOn = self.Train.SectionA:GetNW2Bool("IBISPowerOn", false)

		if PowerOn == true then
			surface.SetDrawColor(140, 190, 0, self.Warm and 130 or 255)
			surface.DrawRect(0, 0, 512, 128)
			self.Warm = true

			if self.Train.SectionA:GetNW2Bool("IBISBootupComplete", false) == false then
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
				self:PrintText(13.5, 1.5, SpecialAnnouncement)
				return
			end

			if Menu == 0 then
				self:PrintText(1.5, 6, Destination)
				self:PrintText(5.6, 6, Course)
				self:PrintText(10.5, 6, Route)
				self:PrintText(0, 1, CurrentStation)
				----print(self.Train.SectionA:GetNW2Int("IBIS:Route"))
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
		if State == 4 then self:BlinkText(true, self.DefectString[self.Train.SectionA:GetNW2Int("Defect", 1)]) end
		if State == 5 and Menu == 4 or State == 5 and Menu == 1 then self:BlinkText(true, "Kurs besetzt") end

		return
	end
end

function TRAIN_SYSTEM:Think(Train, dT)
	primary = self.Train.SectionA.IBIS
	for k, v in pairs(primary) do self[k] = v end
end
