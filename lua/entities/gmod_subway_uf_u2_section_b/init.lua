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
	Type = "U2h",
	Name = "U2h section B",
	WagType = 0,
	Manufacturer = "Duewag",
}

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/u2/u2hb.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,100))

	self.Bogeys = {}
	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 0,0,0),Angle(0,0,0),true,"u2")--103,0,-80
	table.insert(self.Bogeys,self.FrontBogey)	
	self.RearBogey  = self:CreateBogey(Vector( -425,0,0),Angle(0,0,0),false,"u2")
	
	--self.RearCouple = self:CreateCouple(Vector( -288,0,-59),Angle(0,180,0),true,"u2")	
    --self.FrontCouple = self:CreateCouple(Vector( 0,0,-59),Angle(0,180,0),true,"u2")	
	
    --self.RearBogey:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.RearBogey:SetColor(Color(0,0,0,0))		

	self.Timer = CurTime()	
	self.Timer2 = CurTime()
	self:SetNW2Entity("RearBogey",self.RearBogey)
	self:SetNW2Entity("MiddleBogey",self.MiddleBogey)
	self:SetNW2Entity("FrontBogey",self.FrontBogey)
	undo.Create(self.ClassName)	
	undo.AddEntity(self)	
	undo.SetPlayer(self.Owner)
	undo.SetCustomUndoText("Undone a train")
	undo.Finish()
	
	self.Wheels = self.FrontBogey.Wheels
   
	self.Lights = {
		[111] = { "dynamiclight",        Vector( 0, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[112] = { "dynamiclight",        Vector( 200, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[113] = { "dynamiclight",        Vector( -200, 0, 60), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
	}
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end

	self:LoadSystem("CAP","Relay","Switch", {bass = true})	
end

function ENT:OnButtonPress(button,ply)
    if button == "CabinDoorLeft" then self.CabinDoorLeft = not self.CabinDoorLeft end
	if button == "RearDoor" then self.RearDoor = not self.RearDoor end
	if button == "RearDoor2" then self.RearDoor2 = not self.RearDoor2 end
end


function ENT:Think()
	self.BaseClass.Think(self)
	if self.Timer and CurTime()-self.Timer > 0.1 then
		--self.RearBogey.Wheels:SetRenderMode(RENDERMODE_TRANSALPHA)
		--self.RearBogey.Wheels:SetColor(Color(0,0,0,0))		
		
		if CurTime()-self.Timer > 1 then
			self.FrontBogey:Remove()
			--self.RearCouple:Remove()		
			--self.FrontBogey.Wheels:GetPhysicsObject():SetMass(6000)
			self.Timer = nil
		end
	end
	
	if self.Timer2 and CurTime()-self.Timer2 < 1 then
		for k,v in pairs(self.Bogeys) do
			constraint.Weld(v,v.Wheels,0,0,0,1,0)
			constraint.NoCollide(v.Wheels,self,0,0)		
		end

	elseif self.Timer2 then	
		self.Timer2 = nil
	end
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)
	if self.Speed > 1 or self.Duewag_U2_Systems.Drive == 1 then
		local Active = self.Duewag_U2_Systems.Drive == 1 and 0.1 or 0.25
	end
	
	self:SetLightPower(111,true)
	self:SetLightPower(112,true)
	self:SetLightPower(113,true)
	self:SetPackedBool("CabinDoorLeft",self.CabinDoorLeft)
	self:SetPackedBool(44,self.RearDoor2)
	self:SetPackedBool(40,self.RearDoor)
end
