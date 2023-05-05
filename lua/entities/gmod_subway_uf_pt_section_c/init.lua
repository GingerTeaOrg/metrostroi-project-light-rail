AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

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
	Manufacturer = "Duewag",
}

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/pt/section-c.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,5))

	

	self.Bogeys = {}
	-- Create bogeys
	
	
				
	self.MiddleBogeyA  = self:CreateBogeyUF(Vector( 132,0,16),Angle(0,0,0),false,"duewag_motor")
	self.SectionA = self:CreateSectionA(Vector(134,0,2.8))
	self.FrontBogey = self:CreateBogeyUF_a(Vector(380,0,14),Angle(0,0,0),true,"duewag_motor")
	self.MiddleBogeyB  = self:CreateBogeyUF(Vector( -132,0,16),Angle(0,0,0),false,"duewag_motor")

	
	self.SectionB = self:CreateSectionB(Vector(-134,0,2.8))
	
	self.RearBogey = self:CreateBogeyUF_b(Vector( -380,0,14),Angle(0,0,0),false,"duewag_motor")
	self.FrontCouple = self:CreateCoupleUF_a(Vector( 525,0,14),Angle(0,0,0),true,"u2")	
    self.RearCouple = self:CreateCoupleUF_b(Vector( -525,0,14),Angle(0,-180,0),false,"u2")				
	table.insert(self.Bogeys,self.FrontBogey)
	table.insert(self.Bogeys,self.RearBogey)
	table.insert(self.Bogeys,self.MiddleBogeyA)
	table.insert(self.Bogeys,self.MiddleBogeyB)

	constraint.NoCollide(self.FrontBogey,self.SectionA,0,0)
	constraint.NoCollide(self.RearBogey,self.SectionB,0,0)
	constraint.NoCollide(self.MiddleBogeyA,self.SectionA,0,0)
	constraint.NoCollide(self.MiddleBogeyA,self,0,0)
	constraint.NoCollide(self.MiddleBogeyB,self,0,0)
	constraint.NoCollide(self.MiddleBogeyB,self.SectionB,0,0)
	self:SetNW2Entity("RearBogey",self.RearBogey)
	self:SetNW2Entity("MiddleBogey1",self.MiddleBogeyA)
	self:SetNW2Entity("MiddleBogey2",self.MiddleBogeyB)
	self:SetNW2Entity("FrontBogey",self.FrontBogey)
	
	
	self:SetNW2Entity("SectionA",self.SectionA)
	self:SetNW2Entity("SectionB",self.SectionB)
	self:SetNW2Entity("SectionC",self)

	--[[undo.Create(self.ClassName)	
	undo.AddEntity(self)	
	undo.SetPlayer(self.Owner)
	undo.SetCustomUndoText("Undone a train")
	undo.Finish()]]
	
	self.Wheels = self.FrontBogey.Wheels	


	self.ReverserInsertedA = false
	self.ReverserInsertedB = false
	self.ThrottleAnimB = 0
	self.ThrottleAnimA = 0


end

function ENT:OnButtonPress(button,ply)
    if button == "CabinDoorLeft" then self.CabinDoorLeft = not self.CabinDoorLeft end
	if button == "RearDoor" then self.RearDoor = not self.RearDoor end
	if button == "RearDoor2" then self.RearDoor2 = not self.RearDoor2 end
end


function ENT:Think()
	self.BaseClass.Think(self)
	
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)
	
	--print(self.MiddleBogeyA)


	if IsValid(self.FrontBogey) and IsValid(self.MiddleBogeyA) and IsValid(self.MiddleBogeyB) and IsValid(self.RearBogey) then


	end
	
end


function ENT:CreateSectionA(pos)
	local ang = Angle(0,0,0)
	local SecA = ents.Create("gmod_subway_uf_pt_section_ab")
	--self.Vagon741 = SecA
	SecA:SetPos(self:LocalToWorld(pos))
	SecA:SetAngles(self:GetAngles() + ang)
	SecA:Spawn()
	SecA:SetOwner(self:GetOwner())
	SecA:SetNW2Entity("SectionC",self)
	local xmin = 5
	local xmax = 5
	
	
	constraint.Axis(
	self.MiddleBogeyA,
	SecA,
	0, --bone
	0, --bone
	Vector(0,0,0),
	Vector(4,0,0),
	0, --forcelimit
	0, --torquelimit
	0,
	1 --nocollide
	)
	-- Add to cleanup list
	table.insert(self.TrainEntities,SecA)
	return SecA
end

function ENT:CreateSectionB(pos)
	local ang = Angle(0,180,0)
	local SecB = ents.Create("gmod_subway_uf_pt_section_ab")

	SecB:SetPos(self:LocalToWorld(pos))
	SecB:SetAngles(self:GetAngles() + ang)
	SecB:Spawn()
	SecB:SetOwner(self:GetOwner())
	SecB:SetNW2Entity("SectionC",self)
	local xmin = 5
	local xmax = 5
		
	

	constraint.Axis(
	self.MiddleBogeyB,
	SecB,
	0, --bone
	0, --bone
	Vector(0,0,0),
	Vector(-4,0,0),
	0, --forcelimit
	0, --torquelimit
	0,
	1 --nocollide
	)
	
	-- Add to cleanup list
	table.insert(self.TrainEntities,SecB)
	return SecB
end

function ENT:CreateBogeyUF(pos,ang,forward,typ)
	-- Create bogey entity
	local bogey = ents.Create("gmod_train_uf_bogey")
	bogey:SetPos(self:LocalToWorld(pos))
	bogey:SetAngles(self:GetAngles() + ang)
	bogey.BogeyType = typ
	bogey.NoPhysics = self.NoPhysics
	bogey:Spawn()
	
	-- Assign ownership
	if CPPI and IsValid(self:CPPIGetOwner()) then bogey:CPPISetOwner(self:CPPIGetOwner()) end
	
	-- Some shared general information about the bogey
	self.SquealSound = self.SquealSound or math.floor(4*math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound",self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index=1
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,pos.x+53.6)
	table.insert(self.JointPositions,index+1,pos.x-53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
		constraint.Axis(bogey,self,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)
		if forward and IsValid(self.FrontCouple) then
			constraint.NoCollide(bogey,self.FrontCouple,0,0)
		elseif not forward and IsValid(self.RearCouple) then
			constraint.NoCollide(bogey,self.RearCouple,0,0)
		end
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
end

function ENT:CreateBogeyUF_a(pos,ang,forward,typ)
	-- Create bogey entity
	local bogey = ents.Create("gmod_train_uf_bogey")
	bogey:SetPos(self:LocalToWorld(pos))
	bogey:SetAngles(self:GetAngles() + ang)
	bogey.BogeyType = typ
	bogey.NoPhysics = self.NoPhysics
	bogey:Spawn()
	
	-- Assign ownership
	if CPPI and IsValid(self:CPPIGetOwner()) then bogey:CPPISetOwner(self:CPPIGetOwner()) end
	
	-- Some shared general information about the bogey
	self.SquealSound = self.SquealSound or math.floor(4*math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound",self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index=1
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,pos.x+53.6)
	table.insert(self.JointPositions,index+1,pos.x-53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
		constraint.Axis(bogey,self.SectionA,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)
		if forward and IsValid(self.FrontCouple) then
			constraint.NoCollide(bogey,self.FrontCouple,0,0)
			constraint.NoCollide(bogey,self.SectionA,0,0)
		elseif not forward and IsValid(self.RearCouple) then
			constraint.NoCollide(bogey,self.RearCouple,0,0)
		end
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
end

function ENT:CreateBogeyUF_b(pos,ang,forward,typ)
	-- Create bogey entity
	local bogey = ents.Create("gmod_train_uf_bogey")
	bogey:SetPos(self:LocalToWorld(pos))
	bogey:SetAngles(self:GetAngles() + ang)
	bogey.BogeyType = typ
	bogey.NoPhysics = self.NoPhysics
	bogey:Spawn()
	
	-- Assign ownership
	if CPPI and IsValid(self:CPPIGetOwner()) then bogey:CPPISetOwner(self:CPPIGetOwner()) end
	
	-- Some shared general information about the bogey
	self.SquealSound = self.SquealSound or math.floor(4*math.random())
	self.SquealSensitivity = self.SquealSensitivity or math.random()
	bogey.SquealSensitivity = self.SquealSensitivity
	bogey:SetNW2Int("SquealSound",self.SquealSound)
	bogey:SetNW2Bool("IsForwardBogey", forward)
	bogey:SetNW2Entity("TrainEntity", self)
	bogey.SpawnPos = pos
	bogey.SpawnAng = ang
	local index=1
	for i,v in ipairs(self.JointPositions) do
		if v>pos.x then index=i+1 else break end
	end
	table.insert(self.JointPositions,index,pos.x+53.6)
	table.insert(self.JointPositions,index+1,pos.x-53.6)
	-- Constraint bogey to the train
	if self.NoPhysics then
		bogey:SetParent(self)
	else
		constraint.Axis(bogey,self.SectionB,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)
		if forward and IsValid(self.FrontCouple) then
			constraint.NoCollide(bogey,self.FrontCouple,0,0)
		elseif not forward and IsValid(self.RearCouple) then
			constraint.NoCollide(bogey,self.RearCouple,0,0)
		end
	end
	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
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
		bogey:SetParent(coupler)
	else
		constraint.AdvBallsocket(
		self.SectionA,
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
	end
	
	if forward and IsValid(self.FrontBogey) then
		constraint.NoCollide(self.FrontBogey,coupler,0,0)
		constraint.NoCollide(self.FrontBogey,self.SectionA,0,0)
	elseif not forward and IsValid(self.MiddleBogey) then
		constraint.NoCollide(self.MiddleBogey,coupler,0,0)
		constraint.NoCollide(self.MiddleBogey,self.SectionA,0,0)
	end
	
	constraint.Axis(coupler,self.SectionA,0,0,
	Vector(0,0,0),Vector(0,0,0),
	0,0,0,1,Vector(0,0,1),false)
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
		bogey:SetParent(coupler)
	else
		constraint.AdvBallsocket(
		self.SectionB,
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
	end
	if forward and IsValid(self.FrontBogey) then
		constraint.NoCollide(self.FrontBogey,coupler,0,0)
		constraint.NoCollide(self.FrontBogey,self.SectionB,0,0)
	elseif not forward and IsValid(self.RearBogey) then
		constraint.NoCollide(self.RearBogey,coupler,0,0)
		constraint.NoCollide(self.RearBogey,self.SectionB,0,0)
	end
	
	constraint.Axis(coupler,self.SectionB,0,0,
	Vector(0,0,0),Vector(0,0,0),
	0,0,0,1,Vector(0,0,1),false)
end

function ENT:CarBus()

	--if self.SectionA[name] then self[name] = value end
	--if self.SectionB[name] then self[name] = value end

	if self.SectionA.ReverserInserted == true then self.ReverserInsertedA = true
	elseif self.SectionA.ReverserInserted == false then self.ReverserInsertedA = false
	end

	if self.SectionB.ReverserInserted == true then self.ReverserInsertedB = true
	elseif self.SectionB.ReverserInserted == false then self.ReverserInsertedB = false
	end
end