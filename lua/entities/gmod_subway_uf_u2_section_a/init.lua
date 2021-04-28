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
ENT.SubwayTrain = {
	Type = "U2",
	Name = "U2h",
	WagType = 0,
	Manufacturer = "Duewag",
}


---- LOCAL FUNCTIONS FOR GETTING OUR OWN ENTITY SPAWNS


function ENT:CreateBogeyUF(pos,ang,forward,typ)
    -- Create bogey entity
    local bogeyUF = ents.Create("gmod_train_uf_bogeyUF")
    bogeyUF:SetPos(self:LocalToWorld(pos))
    bogeyUF:SetAngles(self:GetAngles() + ang)
    bogeyUF.BogeyType = typ
    bogeyUF.NoPhysics = self.NoPhysics
    bogeyUF:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then bogeyUF:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    self.SquealSound = self.SquealSound or math.floor(4*math.random())
    self.SquealSensitivity = self.SquealSensitivity or math.random()
    bogeyUF.SquealSensitivity = self.SquealSensitivity
    bogeyUF:SetNW2Int("SquealSound",self.SquealSound)
    bogeyUF:SetNW2Bool("IsForwardBogey", forward)
    bogeyUF:SetNW2Entity("TrainEntity", self)
    bogeyUF.SpawnPos = pos
    bogeyUF.SpawnAng = ang
    local index=1
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,pos.x+53.6)
    table.insert(self.JointPositions,index+1,pos.x-53.6)
    -- Constraint bogey to the train
    if self.NoPhysics then
        bogeyUF:SetParent(self)
    else
        constraint.Axis(bogeyUF,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)
        if forward and IsValid(self.FrontCouple) then
            constraint.NoCollide(bogeyUF,self.FrontCouple,0,0)
        elseif not forward and IsValid(self.RearCouple) then
            constraint.NoCollide(bogeyUF,self.RearCouple,0,0)
        end
    end
end
	
	
	
	function ENT:CreateCoupleUF(pos,ang,forward,typ)
    -- Create bogey entity
    local couplerUF = ents.Create("gmod_train_uf_couple")
    couplerUF:SetPos(self:LocalToWorld(pos))
    couplerUF:SetAngles(self:GetAngles() + ang)
    couplerUF.CoupleType = typ
    coupler:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then coupler:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    couplerUF:SetNW2Bool("IsForwardCoupler", forward)
    couplerUF:SetNW2Entity("TrainEntity", self)
    couplerUF.SpawnPos = pos
    couplerUF.SpawnAng = ang
    local index=1
    local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,x)
    -- Constraint bogey to the train
    if self.NoPhysics then
        bogeyUF:SetParent(couplerUF)
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

        if forward and IsValid(self.FrontBogey) then
            constraint.NoCollide(self.FrontBogey,coupler,0,0)
        elseif not forward and IsValid(self.RearBogey) then
            constraint.NoCollide(self.RearBogey,coupler,0,0)
        end
        --[[
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)]]
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,couplerUF)
    return couplerUF
end


function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2h.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,50))
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(540,11,60))
	--self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.DriverSeat:SetColor(Color(0,0,0,0))
	
	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 425,0,-1),Angle(0,180,0),true,"u2")
    self.RearBogey  = self:CreateBogey(Vector(0,0,-1),Angle(0,0,0),false,"u2joint")
    self.FrontBogey:SetNWBool("Async",true)
    self.RearBogey:SetNWBool("Async",true)
	-- Create couples
    --self.FrontCouple = self:CreateCouple(Vector( 460,-3,0),Angle(0,180,0),true,"u2")	
    --self.RearCouple = self:CreateCoupleUF(Vector( 320,0,-59),Angle(0,0,0),true,"u2")	
	self.Async = true
	-- Create U2 Section B
	self.u2sectionb = self:CreateSectionB(Vector(-660,0,-140))
	
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "Drive",
		[KEY_D] = "Brake",
		[KEY_R] = "Reverse",
		[KEY_L] = "Horn",
	}
	
end





	
	


function ENT:Think()
	self.BaseClass.Think(self)
    self:SetPackedBool("CabinDoorLeft",self.CabinDoorLeft)
    self:SetPackedBool("CabinDoorRight",self.CabinDoorRight)
	--self:SetPackedBool(44,self.RearDoor2)
	--self:SetPackedBool(40,self.RearDoor)
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*150)
   --self.u2sectionb(self)

end


function ENT:OnButtonRelease(button,ply)
    if button == "DoorLeft" then
        self.DoorLeft:TriggerInput("Set",0)
    end
end

function ENT:CreateSectionB(pos)
	local ang = Angle(0,0,0)
	local u2sectionb = ents.Create("gmod_subway_uf_u2_section_b")
	-- self.u2sectionb = u2b
	u2sectionb:SetPos(self:LocalToWorld(Vector(-1,0,-100)))
	u2sectionb:SetAngles(self:GetAngles() + ang)
	u2sectionb:Spawn()
	u2sectionb:SetOwner(self:GetOwner())
	local xmin = 5
	local xmax = 5
	--if button == "RearDoor" then u2sectionb.RearDoor = not u2sectionb.RearDoor end	
	
	constraint.AdvBallsocket(
		u2sectionb,
		self,
		0, --bone
		0, --bone
		Vector(0,0,0),
		Vector(0,0,0),
		0, --forcelimit
		0, --torquelimit
		xmin, --xmin
		0, --ymin
		-40, --zmin
		xmax, --xmax
		0, --ymax
		40, --zmax
		0, --xfric
		0, --yfric
		0, --zfric
		0, --rotonly
		1 --nocollide
	)
--	if button == "RearDoor" then vag741.RearDoor = not vag741.RearDoor end	
	
	-- Add to cleanup list
	table.insert(self.TrainEntities,u2sectionb)
	return u2sectionb
end


function ENT:OnButtonPress(button,ply)
	if button == "RearDoor" then self.RearDoor = not self.RearDoor end
	if button == "RearDoor2" then self.RearDoor2 = not self.RearDoor2 end
	/*if button == "RouteNumber1Set" then 
	self.RouteNumber1Set + 1
	end*/
	--if button == "RearDoor" then Vagon741.RearDoor = not Vagon741.RearDoor end	
end
