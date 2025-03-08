Metrostroi.DefineSystem( "IBIS" )
TRAIN_SYSTEM.DontAccelerateSimulation = false
function TRAIN_SYSTEM:Initialize()
	self.Route = " " -- Route index number
	self.RouteChar1 = "0"
	self.RouteChar2 = "0"
	self.DisplayedRouteChar1 = " "
	self.DisplayedRouteChar2 = " "
	self.RoutePrompt1 = " "
	self.RoutePrompt2 = " "
	self.RoutePromptFull = " "
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
	self.DisplayedCourseChar5 = " "
	self.CoursePrompt1 = " "
	self.CoursePrompt2 = " "
	self.CoursePrompt3 = " "
	self.CoursePrompt4 = " "
	self.CoursePrompt5 = " "
	self.CoursePromptFull = " "
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
	self.DestPrompt1 = " "
	self.DestPrompt2 = " "
	self.DestPrompt3 = " "
	self.DestPromptFull = " "
	self.AnnouncementChar1 = " "
	self.AnnouncementChar2 = " "
	self.AnnouncementPrompt1 = " "
	self.AnnouncementPrompt2 = " "
	self.ServiceAnnouncement = " "
	self.LineLookupComplete = false
	self.DestinationLookupComplete = false
	self.RouteLookupComplete = false
	self.RBLRegisterFailed = false
	self.RBLRegistered = false
	self.RBLSignedOff = true
	self.PowerOn = 0
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
	self.NumberKeys = {
		[ "Number1" ] = false, -- 1
		[ "Number2" ] = false, -- 2
		[ "Number3" ] = false, -- 3
		[ "Number4" ] = false, -- 4
		[ "Number5" ] = false, -- 5
		[ "Number6" ] = false, -- 6
		[ "Number7" ] = false,
		[ "Number8" ] = false,
		[ "Number9" ] = false,
		[ "Number0" ] = false,
	}

	self.State = 0
	self.Menu = 4 -- which menu are we in
	self.Announce = false
	self.AutomaticAnnouncementDone = true
	self.LineTable = UF.IBISLines[ self.Train:GetNW2Int( "IBIS:Lines", 1 ) ]
	self.RouteTable = UF.IBISRoutes[ self.Train:GetNW2Int( "IBIS:Routes", 1 ) ]
	self.DestinationTable = UF.IBISDestinations[ self.Train:GetNW2Int( "IBIS:Destinations", 1 ) ]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[ self.Train:GetNW2Int( "IBIS:ServiceA", 1 ) ]
	self.LineLength = self:GetLineLength()
	self.Debounce = {}
	--PrintTable( self.LineTable )
end

TRAIN_SYSTEM.DebounceTime = 1.5
function TRAIN_SYSTEM:HandleInput()
	local p = self.Train.Panel
	local currentTime = CurTime() -- Get the current time
	for k, v in pairs( self.TriggerNames ) do
		if p[ v ] and ( p[ v ] > 0 ) ~= self.Triggers[ v ] then
			-- Check if debounce time has passed
			if not self.Debounce[ v ] or ( currentTime - self.Debounce[ v ] > self.DebounceTime ) then
				self.Triggers[ v ] = p[ v ] > 0
				self.Debounce[ v ] = currentTime -- Reset debounce timer
			else
				self.Triggers[ v ] = false
			end
		end
	end

	for k, v in pairs( self.NumberKeys ) do
		if self.Triggers[ k ] and string.match( k, "Number", 1 ) then
			self.NumberKeys[ k ] = true
		else
			self.NumberKeys[ k ] = false
		end
	end
end

if TURBOSTROI then return end
function TRAIN_SYSTEM:Inputs()
	return { "KeyInput", "Power" }
end

function TRAIN_SYSTEM:Outputs()
	return { "Course", "Route", "Destination", "State" }
end

function TRAIN_SYSTEM:TriggerInput( name, value )
	if self[ name ] then self[ name ] = value end
end

function TRAIN_SYSTEM:TriggerOutput( name, value )
	if self[ name ] then self[ name ] = value end
end

if CLIENT then
	surface.CreateFont( "IBIS", {
		-- main text font
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
	local Menu = self.Train:GetNW2Int( "IBIS:Menu" )
	local State = self.Train:GetNW2Int( "IBIS:State" )
	local Route = self.Train:GetNW2String( "IBIS:RouteChar1" ) .. self.Train:GetNW2String( "IBIS:RouteChar2" )
	local Course = self.Train:GetNW2String( "IBIS:CourseChar1" ) .. self.Train:GetNW2String( "IBIS:CourseChar2" ) .. self.Train:GetNW2String( "IBIS:CourseChar3" ) .. self.Train:GetNW2String( "IBIS:CourseChar4" )
	local Destination = self.Train:GetNW2String( "IBIS:DestinationChar1" ) .. self.Train:GetNW2String( "IBIS:DestinationChar2" ) .. self.Train:GetNW2String( "IBIS:DestinationChar3" )
	local DestinationText = self.Train:GetNW2String( "IBIS:DestinationText", " " )
	local prompt = self.Train:GetNW2String( "Prompt", "ERR" )
	local CurrentStation = self.Train:GetNW2String( "CurrentStation", 0 )
	local ServiceAnnouncement = self.Train:GetNW2String( "IBIS:ServiceAnnouncement", " " )
	local PowerOn = self.Train:GetNW2Bool( "IBISPowerOn", false )
	local BootupComplete = self.Train:GetNW2Bool( "IBISBootupComplete", false )
	if PowerOn == true then
		surface.SetDrawColor( 140, 190, 0, self.Warm and 130 or 255 )
		surface.DrawRect( 0, 0, 512, 128 )
		self.Warm = true
		if not BootupComplete then
			self:PrintText( 0, 0, "---------------" )
			self:PrintText( 0, 4, "---------------" )
		end
	end

	if PowerOn == false then
		surface.SetDrawColor( 37, 94, 0, 230 )
		surface.DrawRect( 0, 0, 512, 128 )
		self.Warm = false
	end

	if State == 2 then
		if Menu == 1 then
			if prompt == "    " or prompt == "     " then
				self:BlinkText( true, "Linie-Kurs:" )
				self:PrintText( 11.5, 1.5, prompt )
			else
				self:PrintText( 0, 1.5, "Linie-Kurs:" )
				self:PrintText( 11.5, 1.5, prompt )
			end
			return
		end

		if Menu == 2 then
			if self.RouteChar1 == " " and self.RouteChar2 == " " then
				self:BlinkText( true, "Route :" )
				self:PrintText( 13.5, 1.5, prompt )
			elseif self.RouteChar1 ~= " " then
				self:PrintText( 13.5, 1.5, prompt )
				self:PrintText( 0, 1.5, "Route :" )
			end
			return
		end
	end

	if State == -2 then
		surface.SetDrawColor( 140, 190, 0, self.Warm and 130 or 255 )
		self.Warm = true
		self:PrintText( 0, 0, "IFIS ERROR" )
		self:PrintText( 0, 1, "Map is missing dataset" )
		return
	end

	if State == 1 then
		if Menu == 1 then
			self:PrintText( 0, 1.5, "Linie-Kurs:" )
			self:PrintText( 11.5, 1.5, prompt )
			return
		end

		if Menu == 2 then
			self:PrintText( 0, 1.5, "Route       :" )
			self:PrintText( 13.5, 1.5, prompt )
			return
		end

		if Menu == 3 then
			self:PrintText( 0, 1, "Ziel      :" )
			self:PrintText( 11, 1.5, prompt )
			return
		end

		if Menu == 4 then
			self:PrintText( 0, 1.5, "Ansage      :" )
			self:PrintText( 13.5, 1.5, prompt )
			return
		end

		if Menu == 0 then
			self:PrintText( 1.5, 6, Destination )
			self:PrintText( 5.6, 6, Course )
			self:PrintText( 10.5, 6, Route )
			self:PrintText( 0, 1, CurrentStation )
			----print(self.Train:GetNW2Int("IBIS:Route"))
			return
		end
	end

	if State == 3 then
		if Menu == 1 then
			self:BlinkText( true, "Ung. Linie" )
			return
		end

		if Menu == 2 then
			self:BlinkText( true, "Ung. Route" )
			return
		end

		if Menu == 3 then
			self:BlinkText( true, "Ung. Ziel" )
			return
		end

		if Menu == 4 then
			self:BlinkText( true, "Ung. Ansage" )
			return
		end
	end

	if State == 4 then self:BlinkText( true, self.DefectString[ self.Train:GetNW2Int( "Defect", 1 ) ] ) end
	if State == 5 and Menu == 4 or State == 5 and Menu == 1 then self:BlinkText( true, "Kurs besetzt" ) end
	return
end

function TRAIN_SYSTEM:UpdateState()
	local trainPower = self.Train.BatteryOn == true or self.Train.CoreSys.CircuitBreakerOn == true or self.Train:ReadTrainWire( 6 ) > 0 or false
	local ibisKey = self.Train:GetNW2Bool( "TurnIBISKey", false )
	local ibisKeyRequired = self.Train.IBISKeyRequired
	-- Function to reset state when device is off
	local function resetState()
		--print( "Reset IBIS" )
		self.PowerOn = 0
		self.State = 0
		self.Menu = 0
		self.Train:SetNW2Bool( "IBISPowerOn", false )
		self.Train:SetNW2Bool( "IBISBootupComplete", false )
		self.Train:SetNW2Bool( "IBISChime", false )
		self.PowerOnRegistered = false -- reset variables if device is off
		self.PowerOnMoment = 0
		if not self.PowerOffMomentRegistered then -- note when the device was switched off,
			self.PowerOffMomentRegistered = true -- to simulate the RAM losing data after an amount of time
			self.PowerOffMoment = CurTime()
		end
	end

	local function completeReset()
		self.LineLookupComplete = false
		self.BootupComplete = false
		self.Course = "     " -- Course index number, format is LineLineCourseCourse
		self.CourseChar1 = " "
		self.CourseChar2 = " "
		self.CourseChar3 = " "
		self.CourseChar4 = " "
		self.CourseChar5 = " "
		self.DisplayedCourseChar1 = " "
		self.DisplayedCourseChar2 = " "
		self.DisplayedCourseChar3 = " "
		self.DisplayedCourseChar4 = " "
		self.DisplayedCourseChar5 = " "
		self.PreviousCourse = "  "
		self.Route = "  " -- Route index number
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

	self.PowerOn = ( ibisKeyRequired and ibisKey and trainPower ) or not ibisKeyRequired and trainPower or false
	-- The last parameters are kept in RAM for a while after the device was powered down. After that, we boot into the complete set-up.
	if not self.PowerOn and CurTime() - self.PowerOffMoment > 240 then
		self.ColdBoot = true
	elseif self.PowerOn and CurTime() - self.PowerOffMoment < 240 then
		self.ColdBoot = false
	end

	if self.Menu > 0 then self:ReadDataset() end
	if self.PowerOn then
		self.Train:SetNW2Bool( "IBISPowerOn", true )
		self.PowerOffMoment = 0
		if not self.PowerOnRegistered then -- register timer variable for simulated bootup
			self.PowerOnMoment = CurTime()
			self.PowerOnRegistered = true
		end

		if CurTime() - self.PowerOnMoment > 5 then
			self.Train:SetNW2Bool( "IBISBootupComplete", true ) -- register that simulated bootup wait has passed
			self.Train:SetNW2Bool( "IBISChime", true )
			if self.ColdBoot and not self.ColdBootCompleted then
				self.ColdBootCompleted = true
				self.State = 2
				self.Menu = 1
			else
				if self.Course == "    " or self.Course == "     " then
					self.Menu = 1
					self.State = 1
				else
					if not self.BootupComplete then
						self.BootupComplete = true
						self.Menu = 0
						self.State = 2
					end
				end
			end
		end
	else
		resetState()
	end

	if self.State == 1 and self.Menu == 0 then
		self.Train:SetNW2Bool( "IBISError", false )
		-- self.PhonedHome = false
		if self.Triggers[ "7" ] then
			self.Menu = 2
		elseif self.Triggers[ "0" ] then
			self.Menu = 1
		elseif self.Triggers[ "Destination" ] then
			self.Menu = 3
		elseif self.Triggers[ "3" ] then
			local indexlength = #self.RouteTable[ self.CourseChar1 .. self.CourseChar2 ][ self.RouteChar1 .. self.RouteChar2 ]
			if indexlength > self.CurrentStationInternal then
				self.CurrentStationInternal = self.CurrentStationInternal + 1
				self.CurrentStation = self.RouteTable[ self.CourseChar1 .. self.CourseChar2 ][ self.RouteChar1 .. self.RouteChar2 ][ self.CurrentStationInternal ]
			end
			-- print indexlength
		elseif self.Triggers[ "6" ] then
			if self.CurrentStationInternal > 1 then
				self.CurrentStationInternal = self.CurrentStationInternal - 1
				self.CurrentStation = self.RouteTable[ self.CourseChar1 .. self.CourseChar2 ][ self.RouteChar1 .. self.RouteChar2 ][ self.CurrentStationInternal ]
			end
		elseif self.Triggers[ "ServiceAnnouncements" ] then
			self.Menu = 4
		elseif self.Triggers[ "9" ] then
			self:Play( CurTime() )
		end
	end

	if self.Menu > 0 then self:ReadDataset() end
	-- print(self.State, self.Menu)
	if self.State == 0 and not self.CANBus and self.PowerOffMomentRegistered and CurTime() - self.PowerOffMoment > 240 then completeReset() end
	if self.State == 4 and self.Triggers[ "Enter" ] then -- We're in the defect state
		-- just confirm. Some IBIS devices just thought stuff was broken while it wasn't. we don't model failure states
		self.State = 1
	end
end

function TRAIN_SYSTEM:Think()
	local Train = self.Train
	-- if not Train.BatteryOn or not Train.CircuitBreakerOn or Train:ReadTrainWire(7) < 1 then return end -- why run anything when the train is off? fss.
	self.RouteTable = UF.IBISRoutes[ self.Train:GetNW2Int( "IBIS:Routes", 1 ) ]
	self.DestinationTable = UF.IBISDestinations[ self.Train:GetNW2Int( "IBIS:Destinations", 1 ) ]
	self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[ self.Train:GetNW2Int( "IBIS:ServiceA", 1 ) ]
	self.LineTable = UF.IBISLines[ self.Train:GetNW2Int( "IBIS:Lines", 1 ) ]
	self:UpdateState()
	if self.PowerOn or Train:ReadTrainWire( 7 ) > 0 then self:CANBusRunner() end
	if self.Train.SkinCategory == "U2h" then
		self.KeyInserted = self.Train.CoreSys.IBISKeyATurned
	else
		self.KeyInserted = false
	end

	if self.Menu == 0 then self:Menu0() end
	self:HandleInput()
	self:ProcessChars()
end

function TRAIN_SYSTEM:ProcessChars()
	local Train = self.Train
	self.Route = self.RouteChar1 .. self.RouteChar2
	self.DisplayedRouteChar1 = tonumber( self.RouteChar1, 10 ) and self.RouteChar1 ~= " " and self.RouteChar1 or " "
	self.DisplayedRouteChar2 = tonumber( self.RouteChar2, 10 ) and self.RouteChar2 ~= " " and self.RouteChar2 or " "
	self.DisplayedDestinationChar1 = tonumber( self.DestinationChar1, 10 ) and self.DestinationChar1 ~= " " and self.DestinationChar1 or " "
	self.DisplayedDestinationChar2 = tonumber( self.DestinationChar2, 10 ) and self.DestinationChar2 ~= " " and self.DestinationChar2 or " "
	self.DisplayedDestinationChar3 = tonumber( self.DestinationChar3, 10 ) and self.DestinationChar3 ~= " " and self.DestinationChar3 or " "
	-- Apply the same principle as before to ensure that the CourseChar variables are valid.
	self.DisplayedCourseChar1 = tonumber( self.CourseChar1, 10 ) and self.CourseChar1 ~= " " and self.CourseChar1 or " "
	self.DisplayedCourseChar2 = tonumber( self.CourseChar2, 10 ) and self.CourseChar2 ~= " " and self.CourseChar2 or " "
	self.DisplayedCourseChar3 = tonumber( self.CourseChar3, 10 ) and self.CourseChar3 ~= " " and self.CourseChar3 or " "
	self.DisplayedCourseChar4 = tonumber( self.CourseChar4, 10 ) and self.CourseChar4 ~= " " and self.CourseChar4 or " "
	self.Destination = tonumber( self.DestinationChar1 .. self.DestinationChar2 .. self.DestinationChar3, 10 ) or 000
	self.ServiceAnnouncement = tonumber( self.AnnouncementChar1 .. self.AnnouncementChar2, 10 ) and self.AnnouncementChar1 .. self.AnnouncementChar2 or " "
	self.DestinationString = self.DestinationTable[ self.Destination ]
	Train:SetNW2Int( "IBIS:State", self.State )
	Train:SetNW2Int( "IBIS:Route", self.Route )
	Train:SetNW2Int( "IBIS:Destination", self.Destination )
	Train:SetNW2String( "IBIS:DestinationText", self.DestinationString )
	Train:SetNW2Int( "IBIS:Course", self.Course )
	Train:SetNW2Int( "IBIS:MenuState", self.Menu )
	Train:SetNW2Int( "IBIS:Menu", self.Menu )
	Train:SetNW2Int( "IBIS:PowerOn", self.PowerOn )
	Train:SetNW2Int( "IBIS:Booted", self.IBISBootupComplete )
	Train:SetNW2String( "IBIS:CourseChar5", self.CourseChar5 )
	Train:SetNW2String( "IBIS:CourseChar4", self.CourseChar4 )
	Train:SetNW2String( "IBIS:CourseChar3", self.CourseChar3 )
	Train:SetNW2String( "IBIS:CourseChar2", self.CourseChar2 )
	Train:SetNW2String( "IBIS:CourseChar1", self.CourseChar1 )
	Train:SetNW2String( "IBIS:RouteChar1", self.RouteChar1 )
	Train:SetNW2String( "IBIS:RouteChar2", self.RouteChar2 )
	Train:SetNW2String( "IBIS:DestinationChar1", self.DestinationChar1 )
	Train:SetNW2String( "IBIS:DestinationChar2", self.DestinationChar2 )
	Train:SetNW2String( "IBIS:DestinationChar3", self.DestinationChar3 )
	Train:SetNW2String( "IBIS:ServiceAnnouncement", self.ServiceAnnouncement )
	if self.LineLength == 2 then
		self.Course = self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4
	elseif self.LineLength == 3 then
		self.Course = self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3 .. self.CourseChar4 .. self.CourseChar5
	end

	if self.CurrentStation ~= -1 and self.CurrentStation ~= nil and self.CurrentStation ~= 0 then
		self.Train:SetNW2String( "CurrentStation", self.DestinationTable[ self.CurrentStation ] )
	elseif self.CurrentStation == 0 then
		self.Train:SetNW2String( "CurrentStation", " " )
	end
end

function TRAIN_SYSTEM:ResetCharValues()
	self.CourseChar1 = " "
	self.CourseChar2 = " "
	self.CourseChar3 = " "
	self.CourseChar4 = " "
	self.RouteChar1 = " "
	self.RouteChar2 = " "
	self.DestinationChar1 = " "
	self.DestinationChar2 = " "
	self.DestinationChar3 = " "
	self.State = 1
	self.Menu = 0
end

function TRAIN_SYSTEM:GetLineLength()
	local longest = 0
	for k, v in pairs( self.LineTable ) do
		if tonumber( k, 10 ) then if #k > longest then longest = #k end end
	end
	return longest
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
	local function commitMenu1()
		for i = 1, self.LineLength do
			self[ "CourseChar" .. i ] = self[ "CoursePrompt" .. i ]
		end
	end

	local function commitMenu2()
		for i = 1, 2 do
			self[ "RouteChar" .. i ] = self[ "RoutePrompt" .. i ]
		end
	end

	local function commitMenu3()
		for i = 1, 3 do
			self[ "DestinationChar" .. i ] = self[ "DestPrompt" .. i ]
		end
	end

	local function commitMenu4()
		self.AnnouncementChar1 = self.AnnouncementPrompt1
		self.AnnouncementChar2 = self.AnnouncementPrompt2
	end

	if self.Menu == 0 then
		self:Menu0()
	elseif self.Menu == 1 then
		local commit = self:Menu1()
		--print( commit )
		if commit then
			commitMenu1()
			if self.State == 2 then
				self.Menu = 2
			elseif self.State == 1 then
				self.Menu = 0
			end
		elseif commit == "fail" then
			self.State = 3
		end
	elseif self.Menu == 2 then
		local commit = self:Menu2()
		if commit then
			commitMenu2()
			self.Menu = 0
			self.State = 1
		elseif commit == "fail" then
			self.State = 3
		end
	elseif self.Menu == 3 then
		local commit = self:Menu3()
		if commit then
			commitMenu3()
			self.Menu = 0
		elseif commit == "fail" then
			self.State = 3
		end
	elseif self.Menu == 4 then
		local commit = self:Menu4()
		if commit then
			commitMenu4()
			self:AnnQueue( self.ServiceAnnouncements[ self.AnnouncementChar1 .. self.AnnouncementChar2 ] )
			self.AnnouncementPrompt1 = " "
			self.AnnouncementPrompt2 = " "
			self.AnnouncementChar1 = " "
			self.AnnouncementChar2 = " "
			self.Menu = 0
		elseif commit == "fail" then
			self.State = 3
		end
	end
end

function TRAIN_SYSTEM:Menu0()
	if self.State == 0 then return end
	local line = " "
	if self.LineLength == 2 then
		line = self.CourseChar1 .. self.CourseChar2
	elseif self.LineLength == 3 then
		line = self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3
	end

	local route = self.Route
	local routeTable = self.RouteTable[ line ] and self.RouteTable[ line ][ route ] or nil
	if self.Triggers[ "Number3" ] then
		self.CurrentStationInternal = self.CurrentStationInternal + 1
		self.CurrentStation = routeTable[ self.CurrentStationInternal ]
		self.NextStation = self.RouteTable[ self.CurrentStationInternal + 1 ]
	elseif self.Triggers[ "Number6" ] then
		self.CurrentStationInternal = self.CurrentStationInternal - 1
		self.CurrentStation = routeTable[ self.CurrentStationInternal ]
		self.NextStation = self.RouteTable[ self.CurrentStationInternal - 1 ]
	elseif self.Triggers[ "Number7" ] then
		self.Menu = 2
	elseif self.Triggers[ "Number9" ] then
		self:Play()
	end
end

function TRAIN_SYSTEM:Menu1()
	--State, self.Menu )
	--Menu 1, LinieKurs
	if self.Menu ~= 1 then return end
	local currentTime = CurTime()
	local function returnNumber()
		for k, v in pairs( self.NumberKeys ) do
			local number = string.sub( k, 7, 7 )
			if self.NumberKeys[ k ] then return number end
		end
		return nil
	end

	local input = returnNumber()
	if input and not tonumber( self.CoursePrompt1, 10 ) then -- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
		if not self.Debounce[ input ] or ( currentTime - self.Debounce[ input ] > self.DebounceTime ) then
			if self.LineLength == 2 then
				self.CoursePrompt1 = self.CoursePrompt2
				self.CoursePrompt2 = self.CoursePrompt3
				self.CoursePrompt3 = self.CoursePrompt4
				self.CoursePrompt4 = input
			elseif self.LineLength == 3 then
				self.CoursePrompt1 = self.CoursePrompt2
				self.CoursePrompt2 = self.CoursePrompt3
				self.CoursePrompt3 = self.CoursePrompt4
				self.CoursePrompt4 = self.CoursePrompt5
				self.CoursePrompt5 = input
			end

			self.Debounce[ input ] = currentTime
		end
	elseif self.Triggers[ "Delete" ] then
		if not self.Debounce[ "Delete" ] or ( currentTime - self.Debounce[ "Delete" ] > self.DebounceTime ) then
			print( "delete" )
			if self.LineLength == 2 then
				self.CoursePrompt4 = self.CoursePrompt3
				self.CoursePrompt3 = self.CoursePrompt2
				self.CoursePrompt2 = self.CoursePrompt1
				self.CoursePrompt1 = " "
			elseif self.LineLength == 3 then
				self.CoursePrompt5 = self.CoursePrompt4
				self.CoursePrompt4 = self.CoursePrompt3
				self.CoursePrompt3 = self.CoursePrompt2
				self.CoursePrompt2 = self.CoursePrompt1
				self.CoursePrompt1 = " "
			end

			self.Debounce[ "Delete" ] = currentTime
		end
	else
		self.CoursePrompt1 = self.CoursePrompt1
		self.CoursePrompt2 = self.CoursePrompt2
		self.CoursePrompt3 = self.CoursePrompt3
		self.CoursePrompt4 = self.CoursePrompt4
		self.CoursePrompt5 = self.CoursePrompt5
	end

	local prompt
	if self.LineLength == 3 then
		prompt = self.CoursePrompt1 .. self.CoursePrompt2 .. self.CoursePrompt3 .. self.CoursePrompt4 .. self.CoursePrompt5
	elseif self.LineLength == 2 then
		prompt = self.CoursePrompt1 .. self.CoursePrompt2 .. self.CoursePrompt3 .. self.CoursePrompt4
	end

	self.Train:SetNW2String( "Prompt", prompt )
	if self.State == 1 and self.Triggers[ "Enter" ] then
		local registered = registered or UF.RegisterTrain( prompt, self.Train )
		if registered == true then
			return true
		elseif registered == "logout" then
			for i = 1, 5 do
				self[ CourseChar .. i ] = " "
			end

			for i = 1, 2 do
				self[ RouteChar .. i ] = " "
			end

			for i = 1, 3 do
				self[ DestinationChar .. i ] = " "
			end
		else
			return "fail"
		end
	elseif self.State == 2 and self.Triggers[ "Enter" ] then
		local registered = registered or UF.RegisterTrain( prompt, self.Train )
		if registered then
			self.Menu = 2
			return true
		elseif registered == "logout" then
			for i = 1, 5 do
				self[ CourseChar .. i ] = " "
			end

			for i = 1, 2 do
				self[ RouteChar .. i ] = " "
			end

			for i = 1, 3 do
				self[ DestinationChar .. i ] = " "
			end
			return true
		else
			return "fail"
		end
	end
	return false
end

function TRAIN_SYSTEM:Menu2()
	if self.Menu ~= 2 then return end
	local line = self.Course:sub( 1, self.LineLength )
	local currentTime = CurTime()
	local function returnNumber()
		for k, v in pairs( self.NumberKeys ) do
			local number = string.sub( k, 7, 7 )
			if self.NumberKeys[ k ] then return number end
		end
		return nil
	end

	local input = returnNumber()
	if input then print( input ) end
	if input and tonumber( input, 10 ) and not tonumber( self.RoutePrompt, 10 ) then -- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
		if not self.Debounce[ input ] or ( currentTime - self.Debounce[ input ] > self.DebounceTime ) then
			-- Input starts at the last digit and gets shifted around at every turn, until the whole prompt is full
			self.RoutePrompt1 = self.RoutePrompt2
			self.RoutePrompt2 = input
			self.Debounce[ input ] = CurTime()
		end
	elseif self.Triggers[ "Delete" ] then
		if not self.Debounce[ "Delete" ] or ( currentTime - self.Debounce[ "Delete" ] > self.DebounceTime ) then
			self.RoutePrompt2 = self.RoutePrompt1
			self.RoutePrompt1 = " "
			self.Debounce[ "Delete" ] = CurTime()
		end
	else
		self.RoutePrompt1 = self.RoutePrompt1
		self.RoutePrompt2 = self.RoutePrompt2
	end

	if self.Triggers[ "Enter" ] then
		if self.RoutePrompt1 == " " and tonumber( self.RoutePrompt2, 10 ) then self.RoutePrompt1 = "0" end
		local Route = self.RoutePrompt1 .. self.RoutePrompt2
		if self.RouteTable[ line ] then
			local routeTable = self.RouteTable[ line ][ Route ]
			if routeTable then
				local destchars = tostring( routeTable[ #routeTable ] ) --get last station number
				self.DestinationChar1 = destchars:sub( 1, 1 )
				self.DestinationChar2 = destchars:sub( 2, 2 )
				self.DestinationChar3 = destchars:sub( 3, 3 )
				self.FirstStation = routeTable[ 1 ]
				self.CurrentStation = self.FirstStation
				self.CurrentStationInternal = 1
				self.NextStation = self.RouteTable[ self.CurrentStationInternal + 1 ]
				return true
			else
				return "fail"
			end
		elseif self.RoutePrompt1 .. self.RoutePrompt2 == "00" then
			self.Route = "  "
			self.CurrentStation = 0
			self.CurrentStationInternal = 0
			return true
		end
	end

	local prompt = self.RoutePrompt1 .. self.RoutePrompt2
	--print( prompt )
	self.Train:SetNW2String( "Prompt", prompt )
	return false
end

function TRAIN_SYSTEM:Menu3()
	if self.Menu ~= 3 then return end
	local function returnNumber()
		for k, _ in pairs( self.NumberKeys ) do
			if self.NumberKeys[ k ] then
				return k
			else
				continue
			end
		end
		return nil
	end

	local input = returnNumber()
	if input then
		self.DestinationPrompt1 = self.DestinationPrompt2
		self.DestinationPrompt2 = self.DestinationPrompt3
		self.DestinationPrompt3 = input
	elseif self.Triggers[ "Delete" ] then
		self.DestinationPrompt3 = self.DestinationPrompt2
		self.DestinationPrompt2 = self.DestinationPrompt1
		self.DestinationPrompt1 = " "
	end

	local prompt = self.DestinationPrompt1 .. self.DestinationPrompt2 .. self.DestinationPrompt3
	if self.DestinationTable[ prompt ] and self.Triggers[ "Enter" ] then
		return true
	else
		return "fail"
	end
	return false
end

function TRAIN_SYSTEM:Menu4()
	if self.Menu ~= 4 then return end
	local function returnNumber()
		for k, v in pairs( self.NumberKeys ) do
			if self.NumberKeys[ k ] then
				return k
			else
				continue
			end
		end
		return nil
	end

	local input = returnNumber()
	-- print(self.AnnouncementChar1,self.AnnouncementChar2)
	if input then
		self.AnnouncementPrompt1 = self.AnnouncementPrompt2
		self.AnnouncementPrompt2 = self.KeyInput
	elseif self.Triggers[ "Delete" ] then
		self.AnnouncementPrompt2 = self.AnnouncementPrompt1
		self.AnnouncementPrompt1 = " "
	end

	if self.ServiceAnnouncements[ self.AnnouncementPrompt1 .. self.AnnouncementPrompt2 ] and self.Triggers[ "Enter" ] then
		return true
	elseif not self.ServiceAnnouncements[ self.AnnouncementChar1 .. self.AnnouncementChar2 ] and self.Triggers[ "Enter" ] then
		return "fail"
	end
	return false
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

function TRAIN_SYSTEM:AnnQueue( msg )
	local Announcer = self.Train.Announcer
	if msg and type( msg ) ~= "table" then
		Announcer:Queue( msg )
	else
		Announcer:Queue( msg )
	end
end

TRAIN_SYSTEM.lastTrigger = 0
function TRAIN_SYSTEM:Play( time )
	local message = {}
	local line
	if self.LineLength == 2 then
		line = self.CourseChar1 .. self.CourseChar2
	elseif self.LineLength == 3 then
		line = self.CourseChar1 .. self.CourseChar2 .. self.CourseChar3
	end

	local commonFiles = UF.IBISCommonFiles[ self.Train:GetNW2Int( "IBIS:CommonFiles", 1 ) ]
	local announcementScript = UF.IBISAnnouncementScript[ self.Train:GetNW2Int( "IBIS:AnnouncementScript", 1 ) ]
	local temp = {}
	for i = 1, #announcementScript do
		if announcementScript[ i ] ~= "station" and type( commonFiles[ announcementScript[ i ] ][ 1 ] ) == "string" then
			temp = {
				[ commonFiles[ announcementScript[ i ] ][ 1 ] ] = commonFiles[ announcementScript[ i ] ][ 2 ]
			}

			table.insert( message, i, temp )
		elseif announcementScript[ i ] == "station" then
			print( line )
			temp = UF.IBISAnnouncementMetadata[ self.Train:GetNW2Int( "IBIS:Announcements", 1 ) ][ self.CurrentStation ][ line ][ self.Route ]
			if not temp then
				print( "ANNOUNCEMENT CORRUPT" )
				return
			end

			for j = 1, #temp do
				table.insert( message, temp[ j ] )
			end
		end
	end

	PrintTable( message )
	if next( message ) then self:AnnQueue( message ) end
end

function TRAIN_SYSTEM:OverrideSwitching( dir )
	local Train = self.Train
	if not ( Train.BatteryOn or Train.CoreSys.CircuitOn or Train:ReadTrainWire( 7 ) < 1 ) then return end
	self.Override = dir
end

function TRAIN_SYSTEM:DisasterTicker() -- Generate a random chance for defect simulation
	if CurTime() - self.LastRoll > 10 and self.State ~= 4 then
		local randomNumber = math.random( 1, 100 )
		if randomNumber == 1 then
			self.State = 4
			self.Train:SetNW2Int( "Defect", math.random( 1, 4 ) )
		end

		self.LastRoll = CurTime()
	end
end

function TRAIN_SYSTEM:CANBusRunner()
	local t = self.Train
	if not self.PoweredOn then return end
	if t:ReadTrainWire( 6 ) < 1 then return end
	tabledata = {
		[ "Course" ] = self.Course,
		[ "Route" ] = self.Route,
		[ "Destination" ] = self.Destination,
	}

	t:CANWrite( t, t.WagonNumber, nil, nil, nil, tabledata )
end

function TRAIN_SYSTEM:CANReceive( source, sourceid, target, targetid, textdata, numdata, tabledata )
	if tabledata then
		self.CANBus = true
		for k, v in pairs( tabledata ) do
			self[ k ] = v
		end
	end
end

function TRAIN_SYSTEM:AnnouncementProcessor()
	local AnnouncementScript = UF.IBISAnnouncementScript[ self.Train:GetNW2Int( "IBIS:AnnouncementRoutine", 1 ) ]
	local workingBuffer = {}
	local ProcessedInput = {}
	for i, v in pairs( AnnouncementScript ) do
		table.Add( v, AnnouncementScript )
	end
end

function TRAIN_SYSTEM:AutomaticAnnouncement()
	local platform = Metrostroi.Stations[ self.CurrentStation ] -- target the platform data for the current station by Index
	local forward = platform.forward -- does the platform point up or down on the X coordinate?
	-- get platform start and end
	local pos1 = Metrostroi.GetPositionOnTrack( platform.PlatformStart, platform.ent.PlatformStart:GetAngles() )[ 1 ]
	local pos2 = Metrostroi.GetPositionOnTrack( platform.PlatformEnd, platform.ent.PlatformEnd:GetAngles() )[ 1 ]
	-- we're only interested in the X values of the platform
	pos1 = pos1.x
	pos2 = pos2.x
	-- calculate a mid point so we don't have to complicate things by detecting entries and exits
	local mediumPos = forward and pos2 - pos1 or pos1 - pos2
	-- get the train's position and filter for X coordinate
	local trainPos = Metrostroi.GetPositionOnTrack( self.Train:GetPos(), self.Train:GetAngles() )[ 1 ]
	trainPos = trainPos.x
	-- are we in the station or not?
	local inStation = ( forward and ( trainPos < pos2 and trainPos > pos1 ) ) or ( trainPos < pos1 and trainPos > pos2 )
	-- if we're outside of the station and further away than 30 units, regardless of orientation, we're doing an announcement
	if not inStation and ( forward and trainPos > mediumPos and trainPos - mediumPos == 30 ) or ( not forward and trainPos < mediumPos and mediumPos - trainPos == 30 ) then self.AutomaticAnnouncementDone = false end
	-- take care of the announcement: tick up the line's station counter, set our new station and play the announcement
	if not self.AutomaticAnnouncementDone then
		self.CurrentStationInternal = self.CurrentStationInternal + 1
		self.CurrentStation = self.RouteTable[ self.CourseChar1 .. self.CourseChar2 ][ self.RouteChar1 .. self.RouteChar2 ][ self.CurrentStationInternal ]
		self:Play( CurTime() )
		self.AutomaticAnnouncementDone = true
	end
end