AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.BogeyDistance = 30000 -- Needed for gm trainspawner
--------------------------------------------------------------------------------
-- переписал Lindy2017 
-- ориг скрипты - татра и томас 
--------------------------------------------------------------------------------
---------------------------------------------------
-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------
ENT.SubwayTrain = {
	Type = "P8",
	Name = "Pt",
	WagType = 2,
	Manufacturer = "Duewag"
}

function ENT:Initialize()
	-- Set model and initialize
	self:SetModel( "models/lilly/uf/pt/section-c.mdl" )
	self.BaseClass.Initialize( self )
	self:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )
	self.Bogeys = {}
	self.SectionA = self:CreateSection( Vector( 145, 0, 2.8 ), Angle( 0, 0, 0 ), "gmod_subway_uf_pt_section_ab", self, nil, self )
	-- Create bogeys
	self.FrontBogey = self:CreateBogeyUF( Vector( 390, 0, 4 ), Angle( 0, 180, 0 ), true, "duewag_motor", "a" ) -- 380,0,14
	self.FrontBogey.InhibitReRail = true
	self.RearBogey = self:CreateBogeyUF( Vector( -144, 0, 14 ), Angle( 0, 0, 0 ), true, "duewag_motor" ) ---380,0,14
	self.RearBogey.InhibitReRail = true
	self.SectionA = self:CreateSectionA( Vector( 145, 0, 2.8 ) )
	self.SectionBogeyA = self:CreateBogeyUF_a( Vector( 380, 0, 14 ), Angle( 0, 0, 0 ), false, "duewag_motor" )
	self.SectionBogeyA.InhibitReRail = true
	self.SectionB = self:CreateSection( Vector( -145, 0, 2.8 ) )
	self.SectionBogeyB = self:CreateBogeyUF_b( Vector( -380, 0, 14 ), Angle( 0, 0, 0 ), false, "duewag_motor" )
	self.SectionBogeyB.InhibitReRail = true
	-- self.RearBogey = self.SectionBogeyB
	self.OptOutRerail = true
	self.FrontCouple = self.SectionA:CreateCoupleUF_a( Vector( 390, 0, 10 ), Angle( 0, 0, 0 ), true, "pt" )
	self.RearCouple = self.SectionB:CreateCoupleUF_b( Vector( 390, 0, 10 ), Angle( 0, 0, 0 ), false, "pt" )
	self.Panto = self:CreatePanto( Vector( 93, 0, 130 ), Angle( 0, 90, 0 ), "diamond" )
	self.PantoUp = false
	-- self.SectionA.BaseClass:Initialize(self.SectionA)
	-- self.SectionB.BaseClass:Initialize(self.SectionB)
	-- self.DriverSeat = self:CreateSeat("driver",Vector(0,0,80))
	constraint.NoCollide( self.FrontBogey, self.SectionA, 0, 0 )
	constraint.NoCollide( self.RearBogey, self.SectionB, 0, 0 )
	constraint.NoCollide( self.SectionBogeyA, self.SectionA, 0, 0 )
	constraint.NoCollide( self.SectionBogeyA, self, 0, 0 )
	constraint.NoCollide( self.SectionBogeyB, self, 0, 0 )
	constraint.NoCollide( self.SectionBogeyB, self.SectionB, 0, 0 )
	self:SetNW2Entity( "RearBogey", self.RearBogey )
	self:SetNW2Entity( "MiddleBogey1", self.SectionBogeyA )
	self:SetNW2Entity( "MiddleBogey2", self.SectionBogeyB )
	self:SetNW2Entity( "FrontBogey", self.FrontBogey )
	self:SetNW2Entity( "SectionA", self.SectionA )
	self:SetNW2Entity( "SectionB", self.SectionB )
	self:SetNW2Entity( "SectionC", self )
	-- self.Wheels = self.FrontBogey.Wheels	
	self.ReverserInsertedA = false
	self.ReverserInsertedB = false
	self.ThrottleAnimB = 0
	self.ThrottleAnimA = 0
	self:SetNW2Bool( "DepartureConfirmed", true )
end

function ENT:OnButtonPress( button, ply )
end

function ENT:Think()
	self.BaseClass.Think( self )
	self.Speed = math.abs( -self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858 )
	self:SetNW2Int( "Speed", self.Speed * 100 )
	-- self.ReverserInsertedB = self.SectionB.ReverserInserted
	self.ReverserInsertedA = self.SectionA.ReverserInserted
	self.SectionA:SetNW2Bool( "ReverserInserted", self.ReverserInsertedA )
	-- self.SectionB:SetNW2Bool("ReverserInserted",self.ReverserInsertedB)
	if IsValid( self.FrontBogey ) and IsValid( self.SectionBogeyA ) and IsValid( self.SectionBogeyB ) and IsValid( self.RearBogey ) then
		if self.CoreSys.ThrottleStateA < 0 or self.CoreSys.ThrottleStateB < 0 then
			self.RearBogey.MotorForce = -5980
			self.FrontBogey.MotorForce = -5980
			self:SetNW2Bool( "Braking", true )
			self.RearBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.SectionBogeyA.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
		elseif self.CoreSys.ThrottleStateA > 0 or self.CoreSys.ThrottleStateB > 0 and self:GetNW2Bool( "DepartureConfirmed", false ) ~= false then
			self.RearBogey.MotorForce = 4980
			self.FrontBogey.MotorForce = 4980
			self.RearBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.SectionBogeyA.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
		elseif self.CoreSys.ThrottleStateA == 0 or self.CoreSys.ThrottleStateB == 0 then
			self.RearBogey.MotorForce = 0
			self.FrontBogey.MotorForce = 0
			self:SetNW2Bool( "Braking", false )
			self.RearBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.MotorPower = self.CoreSys.Traction
			self.FrontBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.SectionBogeyA.BrakeCylinderPressure = self.CoreSys.BrakePressure
			self.RearBogey.BrakeCylinderPressure = self.CoreSys.BrakePressure
		elseif self.Train:GetNW2Bool( "DeadmanTripped" ) == true then
			if self.Speed > 5 then
				self.RearBogey.MotorPower = self.CoreSys.Traction
				self.FrontBogey.MotorPower = self.CoreSys.Traction
				self.FrontBogey.BrakeCylinderPressure = 2.7
				self.SectionBogeyA.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self:SetNW2Bool( "Braking", true )
			else
				self.RearBogey.MotorPower = 0
				self.FrontBogey.MotorPower = 0
				self.FrontBogey.BrakeCylinderPressure = 2.7
				self.SectionBogeyA.BrakeCylinderPressure = 2.7
				self.RearBogey.BrakeCylinderPressure = 2.7
				self:SetNW2Bool( "Braking", true )
			end
		end
	elseif self:GetNW2Bool( "DepartureConfirmed", false ) == false then
		self.FrontBogey.BrakeCylinderPressure = 2.7
		self.SectionBogeyA.BrakeCylinderPressure = 2.7
		self.RearBogey.BrakeCylinderPressure = 2.7
		self.RearBogey.MotorPower = 0
		self.FrontBogey.MotorPower = 0
		self:SetNW2Bool( "Braking", true )
	end

	if self.CoreSys.ReverserState == 1 then
		self.FrontBogey.Reversed = false
		self.RearBogey.Reversed = false
	elseif self.CoreSys.ReverserState == -1 then
		self.FrontBogey.Reversed = true
		self.RearBogey.Reversed = true
	end
end

function ENT:CarBus()
	-- if self.SectionA[name] then self[name] = value end
	-- if self.SectionB[name] then self[name] = value end
	if self.SectionA.ReverserInserted == true then
		self.ReverserInsertedA = true
	elseif self.SectionA.ReverserInserted == false then
		self.ReverserInsertedA = false
	end

	if self.SectionB.ReverserInserted == true then
		self.ReverserInsertedB = true
	elseif self.SectionB.ReverserInserted == false then
		self.ReverserInsertedB = false
	end
end