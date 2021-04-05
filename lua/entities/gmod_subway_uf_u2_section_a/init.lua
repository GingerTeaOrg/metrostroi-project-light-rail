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

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/body_u2ha.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,140))
	
	-- Create seat entities
    self.DriverSeat = self:CreateSeat("driver",Vector(315,19,-27))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.DriverSeat:SetColor(Color(0,0,0,0))
	
	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 190,0,-75),Angle(0,180,0),true,"u2")
    self.RearBogey  = self:CreateBogey(Vector(-335,0,-75),Angle(0,0,0),false,"u2")
    self.FrontBogey:SetNWBool("Async",true)
    self.RearBogey:SetNWBool("Async",true)
	-- Create couples
    self.FrontCouple = self:CreateCouple(Vector( 0,0,-59),Angle(0,180,0),true,"u2")	
    self.RearCouple = self:CreateCouple(Vector( 320,0,-59),Angle(0,0,0),true,"u2")	
	self.Async = true
	-- Create 741
	self.Vagon741 = self:Create741(Vector(-660,0,-140))
	
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_A] = "Drive",
		[KEY_D] = "Brake",
		[KEY_R] = "Reverse",
		[KEY_L] = "Horn",
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
	
	
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end

end

function ENT:Think()
	self.BaseClass.Think(self)
	self:SetLightPower(10,true)
	self:SetLightPower(11,true)
	self:SetLightPower(12,true)
	self:SetLightPower(13,true)
	self:SetLightPower(2,true)
	self:SetLightPower(3,true)
	self:SetLightPower(4,true)
	self:SetLightPower(5,true)
	self:SetLightPower(6,true)
	self:SetLightPower(7,true)
	self:SetLightPower(8,true)
	self:SetLightPower(9,true)
    self:SetPackedBool("CabinDoorLeft",self.CabinDoorLeft)
    self:SetPackedBool("CabinDoorRight",self.CabinDoorRight)
	self:SetPackedBool(44,self.RearDoor2)
	self:SetPackedBool(40,self.RearDoor)
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)
   -- self.vag_741(self)

end


function ENT:OnButtonRelease(button,ply)
    if button == "DoorLeft" then
        self.DoorLeft:TriggerInput("Set",0)
    end
end

function ENT:CreateSectionB(pos)
	local ang = Angle(0,0,0)
	local u2sectionb = ents.Create("gmod_subway_u2_section_b")
	--self.Vagon741 = vag741
	u2sectionb:SetPos(self:LocalToWorld(pos))
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
		Vector(310,0,0),
		pos,
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
    if button == "CabinDoorLeft" then self.CabinDoorLeft = not self.CabinDoorLeft end
    if button == "CabinDoorRight" then self.CabinDoorRight = not self.CabinDoorRight end
	if button == "RearDoor" then self.RearDoor = not self.RearDoor end
	if button == "RearDoor2" then self.RearDoor2 = not self.RearDoor2 end
	/*if button == "RouteNumber1Set" then 
	self.RouteNumber1Set + 1
	end*/
	--if button == "RearDoor" then Vagon741.RearDoor = not Vagon741.RearDoor end	
end
