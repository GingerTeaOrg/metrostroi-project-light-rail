AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")




function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/pt/section-ab.mdl")
	self.BaseClass.Initialize(self)
	--self:SetPos(self:GetPos() + Vector(0,0,0))
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(366,4,40))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))
	
	self.SectionC = self:GetNW2Entity("SectionC")
	-- Create bogeys
	self.FrontBogey = self.SectionC.FrontBogey
	self.SectionBogeyA = self.SectionC.SectionBogeyA
	self.SectionBogeyB = self.SectionC.SectionBogeyB
    self.RearBogey = self.SectionC.RearBogey

	self.FrontCouple = self.SectionC.FrontCouple
    self.RearCouple = self.SectionC.RearCouple
	
	self.ReverserInserted = false

	--print("UF: Init Pt Section A/B")
	
	
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

		[KEY_PAGEUP] = "Rollsign1+",
		[KEY_PAGEDOWN] = "Rollsign1-",
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
			[KEY_O] = "HighFloorSet",
			[KEY_I] = "LowFloorSet",			
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
	
	
	
	--self:TrainSpawnerUpdate()
end

function ENT:Think()
	self.BaseClass.Think(self)
	self.SectionC = self:GetNW2Entity("SectionC")

	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)

	

	if self.SectionC.Duewag_Pt.ReverserLeverState == 0 then
		self:SetNW2Float("ReverserAnim",0.25)
	elseif self.SectionC.Duewag_Pt.ReverserLeverState == 1 then
		self:SetNW2Float("ReverserAnim",0.35)
	elseif self.SectionC.Duewag_Pt.ReverserLeverState == 2 then
		self:SetNW2Float("ReverserAnim",0.45)
	elseif self.SectionC.Duewag_Pt.ReverserLeverState == 3 then
		self:SetNW2Float("ReverserAnim",0.55)
	elseif self.SectionC.Duewag_Pt.ReverserLeverState == -1 then
		self:SetNW2Float("ReverserAnim",0)
	end
	
	--print(self.SectionC.Duewag_Pt.ReverserLeverState)

end


function ENT:OnButtonRelease(button,ply)
 
end




function ENT:OnButtonPress(button,ply)

	if self.SectionC.Duewag_Pt.ReverserInsertedA then
    end

		----THROTTLE CODE -- Initial Concept credit Toth Peter
	if self.SectionC.Duewag_Pt.ThrottleRate == 0 then
		if button == "ThrottleUp" then self.SectionC.Duewag_Pt.ThrottleRate = 3 end
		if button == "ThrottleDown" then self.SectionC.Duewag_Pt.ThrottleRate = -3 end
	end
	
	if self.SectionC.Duewag_Pt.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then self.SectionC.Duewag_Pt.ThrottleRate = 8 end
		if button == "ThrottleDownFast" then self.SectionC.Duewag_Pt.ThrottleRate = -8 end
		
	end
	
	if self.SectionC.Duewag_Pt.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then self.SectionC.Duewag_Pt.ThrottleRate = 10 end
		if button == "ThrottleDownReallyFast" then self.SectionC.Duewag_Pt.ThrottleRate = -10 end
		
	end

	if self.SectionC.Duewag_Pt.ReverserLeverState == 0 then
		if button == "ReverserInsert" then
			if self.ReverserInserted == false then
				self.ReverserInserted = true
				self.Duewag_Pt.ReverserInserted = true
				self:SetNW2Bool("ReverserInserted",true)
				--PrintMessage(HUD_PRINTTALK, "Reverser is in")
				
			elseif  self.ReverserInserted == true then
				self.ReverserInserted = false
				self.Duewag_Pt.ReverserInserted = false
				self:SetNW2Bool("ReverserInserted",false)
				--PrintMessage(HUD_PRINTTALK, "Reverser is out")
			end
		end
	end

	if button == "ReverserUpSet" then
		if 
		not self.SectionC.Duewag_Pt.ThrottleEngaged == true  then
			if self.SectionC.Duewag_Pt.ReverserInserted == true then
				self.SectionC.Duewag_Pt.ReverserLeverState = self.SectionC.Duewag_Pt.ReverserLeverState + 1
				self.SectionC.Duewag_Pt.ReverserLeverState = math.Clamp(self.SectionC.Duewag_Pt.ReverserLeverState, -1, 3)
				--self.Duewag_Pt:TriggerInput("ReverserLeverState",self.ReverserLeverState)
				--PrintMessage(HUD_PRINTTALK,self.Duewag_Pt.ReverserLeverState)
			end
		end
	end
	if button == "ReverserDownSet" then
		if 
		not self.SectionC.Duewag_Pt.ThrottleEngaged == true and self.SectionC.Duewag_Pt.ReverserInserted == true then
			--self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp(self.SectionC.Duewag_Pt.ReverserLeverState, -1, 3)
			--self.Duewag_Pt:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			self.SectionC.Duewag_Pt.ReverserLeverState = self.SectionC.Duewag_Pt.ReverserLeverState - 1
			self.SectionC.Duewag_Pt.ReverserLeverState = math.Clamp(self.SectionC.Duewag_Pt.ReverserLeverState, -1, 3)
			--PrintMessage(HUD_PRINTTALK,self.Duewag_Pt.ReverserLeverState)
		end
	end

	if button == "Rollsign1+" then
		self:SetNW2Bool("Rollsign1Scroll+")
	end
	if button == "Rollsign1-" then
		self:SetNW2Bool("Rollsign1Scroll-")
	end

	if button == "Rollsign+" then
		self:SetNW2Bool("RollsignScroll+")
	end
	if button == "Rollsign-" then
		self:SetNW2Bool("RollsignScroll-")
	end


end

function ENT:CreateCoupleUF_a(pos,ang,forward,typ)
    -- Create bogey entity
    local coupler = ents.Create("gmod_train_uf_couple")
    coupler:SetPos(self:LocalToWorld(pos))
    coupler:SetAngles(self:GetAngles() + ang)
    coupler.CoupleType = typ
    coupler:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then coupler:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    coupler:SetNW2Bool("IsForwardCoupler", forward)
    coupler:SetNW2Entity("TrainEntity", self)
    coupler.SpawnPos = pos
    coupler.SpawnAng = ang
    local index=1
    local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,x)
    -- Constraint bogey to the train
    if self.NoPhysics then
        coupler:SetParent(self)
    else
        constraint.AdvBallsocket(
            self,
            coupler,
            0, --bone
            0, --bone
            pos,
            Vector(0,0,0),
            1, --forcelimit
            1, --torquelimit
            -2, --xmin
            -2, --ymin
            -15, --zmin
            2, --xmax
            2, --ymax
            15, --zmax
            0.1, --xfric
            0.1, --yfric
            1, --zfric
            0, --rotonly
            1 --nocollide
        )

        if IsValid(self.FrontBogey) then
            constraint.NoCollide(self.FrontBogey,coupler,0,0)
        end
        --[[
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)]]
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,coupler)
    return coupler
end

function ENT:CreateCoupleUF_b(pos,ang,forward,typ)
    -- Create bogey entity
    local coupler = ents.Create("gmod_train_uf_couple")
    coupler:SetPos(self:LocalToWorld(pos))
    coupler:SetAngles(self:GetAngles() + ang)
    coupler.CoupleType = typ
    coupler:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then coupler:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    coupler:SetNW2Bool("IsForwardCoupler", forward)
    coupler:SetNW2Entity("TrainEntity", self)
    coupler.SpawnPos = pos
    coupler.SpawnAng = ang
    local index=1
    local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,x)
    -- Constraint bogey to the train
    if self.NoPhysics then
        coupler:SetParent(self)
    else
        constraint.AdvBallsocket(
            self,
            coupler,
            0, --bone
            0, --bone
            pos,
            Vector(0,0,0),
            1, --forcelimit
            1, --torquelimit
            -2, --xmin
            -2, --ymin
            -15, --zmin
            2, --xmax
            2, --ymax
            15, --zmax
            0.1, --xfric
            0.1, --yfric
            1, --zfric
            0, --rotonly
            1 --nocollide
        )

        
        if IsValid(self.RearBogey) then
            constraint.NoCollide(self.RearBogey,coupler,0,0)
        end
        
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,coupler)
    return coupler
end