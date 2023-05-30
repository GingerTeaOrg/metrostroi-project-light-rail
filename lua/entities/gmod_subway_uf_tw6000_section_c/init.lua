AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--------------------------------------------------------------------------------
-- немного переписанная татра lindy2017
--------------------------------------------------------------------------------
---------------------------------------------------
-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------


function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/pt/section-ab.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,0))
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(366,4,40))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))
	
	self.SectionC = self:GetNW2Entity("SectionC")
	-- Create bogeys
	self.FrontBogey = self.SectionC.FrontBogey
	self.MiddleBogeyA = self.SectionC.MiddleBogeyA
	self.MiddleBogeyB = self.SectionC.MiddleBogeyB
    self.RearBogey = self.SectionC.RearBogey

	self.FrontCouple = self.SectionC.FrontCouple
    self.RearCouple = self.SectionC.RearCouple
	
	self.ReverserInserted = false

	
	
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "ThrottleUp",
		[KEY_D] = "ThrottleDown",
		[KEY_H] = "BellEngageSet",
		[KEY_SPACE] = "DeadmanSet",
		[KEY_W] = "ReverserUpSet",
		[KEY_S] = "ReverserDownSet",
		[KEY_P] = "PantoUpSet",
		[KEY_O] = "DoorsUnlockSet",
		[KEY_I] = "DoorsLockSet",
		[KEY_K] = "DoorsCloseConfirmSet",
		[KEY_Z] = "WarningAnnouncementSet",
		[KEY_J] = "DoorsSelectLeftToggle",
		[KEY_L] = "DoorsSelectRightToggle",
		[KEY_B] = "BatteryToggle",
		[KEY_V] = "HeadlightsToggle",
		[KEY_M] = "Mirror",
		[KEY_1] = "Throttle10Pct",
		[KEY_2] = "Throttle20Pct",
		[KEY_3] = "Throttle30Pct",
		[KEY_4] = "Throttle40Pct",
		[KEY_5] = "Throttle50Pct",
		[KEY_6] = "Throttle60Pct",
		[KEY_7] = "Throttle70Pct",
		[KEY_8] = "Throttle80Pct",
		[KEY_9] = "Throttle90Pct",
		[KEY_PERIOD] = "WarnBlinkToggle",
		
		[KEY_COMMA] = "BlinkerLeftToggle",
		--[KEY_0] = "KeyTurnOn",
		
		[KEY_LSHIFT] = {
			[KEY_0] = "ReverserInsert",
			[KEY_A] = "ThrottleUpFast",
			[KEY_D] = "ThrottleDownFast",
			[KEY_S] = "ThrottleZero",
			[KEY_H] = "Horn",
			[KEY_V] = "DriverLightToggle",
			[KEY_COMMA] = "BlinkerRightToggle",
			[KEY_B] = "BatteryDisableToggle",
			[KEY_PAGEUP] = "Rollsign+",
			[KEY_PAGEDOWN] = "Rollsign-",
			[KEY_O] = "OpenDoor1Set",
		},
		
		[KEY_LALT] = {
			[KEY_PAD_1] = "Number1Set",
			[KEY_PAD_2] = "Number2Set",
			[KEY_PAD_3] = "Number3Set",
			[KEY_PAD_4] = "Number4Set",
			[KEY_PAD_5] = "Number5Set",
			[KEY_PAD_6] = "Number6Set",
			[KEY_PAD_7] = "Number7Set",
			[KEY_PAD_8] = "Number8Set",
			[KEY_PAD_9] = "Number9Set",
			[KEY_PAD_0] = "Number0Set",
			[KEY_PAD_ENTER] = "EnterSet",
			[KEY_PAD_DECIMAL] = "DeleteSet",
			[KEY_PAD_DIVIDE] = "DestinationSet",
			[KEY_PAD_MULTIPLY] = "SpecialAnnouncementsSet",
			[KEY_PAD_MINUS] = "TimeAndDateSet",
			[KEY_V] = "PassengerLightsSet",
			[KEY_D] = "EmergencyBrakeSet",
			
			
			
		},
	}
	
    self.Lights = {
        -- Headlight glow
        --[1] = { "headlight",      Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100, farz=6144,brightness = 4},

        -- Head (type 1)
        [2] = { "glow",             Vector(365,-40,-20), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[3] = { "glow",             Vector(365,-30,-25), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[4] = { "glow",             Vector(365,30,-25), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[5] = { "glow",             Vector(365,40,-20), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[6] = { "glow",             Vector(335,40,56), Angle(0,0,0), Color(199,0,0), brightness = 0.5, scale = 0.7 },
		[7] = { "glow",             Vector(335,-40,56), Angle(0,0,0), Color(199,0,0), brightness = 0.5, scale = 0.7 },
		[8] = { "glow",             Vector(365,40,-60), Angle(0,0,0), Color(199,0,0), brightness = 0.5, scale = 0.7 },
		[9] = { "glow",             Vector(365,-40,-60), Angle(0,0,0), Color(199,0,0), brightness = 0.5, scale = 0.7 },
        -- Cabin
        [10] = { "dynamiclight",        Vector( 300, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 0.3},
		--Salon
		[11] = { "dynamiclight",        Vector( 0, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[12] = { "dynamiclight",        Vector( 200, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[13] = { "dynamiclight",        Vector( -200, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
	}
	
	
	

end

function ENT:Think()
	
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)

	self.FrontBogey.BrakePressure = 0
	self.MiddleBogeyA.BrakePressure = 0
	self.MiddleBogeyB.BrakePressure = 0
	self.RearBogey.BrakePressure = 0

end


function ENT:OnButtonRelease(button,ply)
 
end




function ENT:OnButtonPress(button,ply)

	if self.SectionC.Duewag_Pt.ReverserInsertedA then
    end
end
