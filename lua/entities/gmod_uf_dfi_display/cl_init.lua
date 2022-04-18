include('shared.lua')

function ENT:Initialize()

	self.Minute = self.Minute or 0
	self.Hour = self.Hour or 0
	self.AttachmentTable = {}
	local AttachmentNames = {"Abfahrt01A", "Abfahrt01B", 
								 "Abfahrt02A", "Abfahrt02B",
								 "Ziel01A", "Ziel01B",
								 "Ziel02A", "Ziel02B",
								 "Linie01A", "Linie01B",
								 "Linie02A", "Linie02B",
								 "GleisA", "GleisB",
								 "UhrA", "UhrB"}
	for i=1,table.Count( AttachmentNames ) do 
		local attnum = self:LookupAttachment(AttachmentNames[i])
		local att = self:GetAttachment(attnum)
		if !att then return end
		self.AttachmentTable[i] = att
	end
	
	if Metrostroi then
		self.Minute = Metrostroi.GetSyncTime()/60
		self.Hour =  Metrostroi.GetSyncTime()/3600
	end
	self:SpawnZeiger()
end

function ENT:SpawnZeiger()
	self.zeiger = {}
	self.zeiger_gross = {}
	self.zeiger_klein = {}
	self.zeiger_grossA = nil
	self.zeiger_kleinA = nil
	self.zeiger_grossB = nil
	self.zeiger_kleinB = nil
		
	self.zeiger_grossA = ents.CreateClientProp("models/props_borealis/mooring_cleat01.mdl") 
	self.zeiger_grossA:SetModel("models/ron/gm_metro_u6/station/uhrzeiger_gross.mdl")
	self.zeiger_grossA:PhysicsInit( SOLID_VPHYSICS )
	self.zeiger_grossA:SetMoveType( MOVETYPE_NONE  )
	self.zeiger_grossA:SetSolid( SOLID_NONE )
	self.zeiger_grossA:SetPos(self.AttachmentTable[15].Pos)
	self.zeiger_grossA:SetAngles(self.AttachmentTable[15].Ang)
	self.zeiger_grossA:SetParent(self)

	self.zeiger_kleinA = ents.CreateClientProp("models/props_borealis/mooring_cleat01.mdl")
	self.zeiger_kleinA:SetModel("models/ron/gm_metro_u6/station/uhrzeiger_klein.mdl")
	self.zeiger_kleinA:PhysicsInit( SOLID_VPHYSICS ) 
	self.zeiger_kleinA:SetMoveType( MOVETYPE_NONE  )
	self.zeiger_kleinA:SetSolid( SOLID_NONE )
	self.zeiger_kleinA:SetPos(self.AttachmentTable[15].Pos)
	self.zeiger_kleinA:SetAngles(self.AttachmentTable[15].Ang)
	self.zeiger_kleinA:SetParent(self)

	self.zeiger_grossB = ents.CreateClientProp("models/props_borealis/mooring_cleat01.mdl")
	self.zeiger_grossB:SetModel("models/ron/gm_metro_u6/station/uhrzeiger_gross.mdl")
	self.zeiger_grossB:PhysicsInit( SOLID_VPHYSICS )
	self.zeiger_grossB:SetMoveType( MOVETYPE_NONE  )
	self.zeiger_grossB:SetSolid( SOLID_NONE )
	self.zeiger_grossB:SetPos(self.AttachmentTable[16].Pos)
	self.zeiger_grossB:SetAngles(self.AttachmentTable[16].Ang)
	self.zeiger_grossB:SetParent(self)
	
	self.zeiger_kleinB = ents.CreateClientProp("models/props_borealis/mooring_cleat01.mdl") 
	self.zeiger_kleinB:SetModel("models/ron/gm_metro_u6/station/uhrzeiger_klein.mdl")
	self.zeiger_kleinB:PhysicsInit( SOLID_VPHYSICS )
	self.zeiger_kleinB:SetMoveType( MOVETYPE_NONE  )
	self.zeiger_kleinB:SetSolid( SOLID_NONE )
	self.zeiger_kleinB:SetPos(self.AttachmentTable[16].Pos)
	self.zeiger_kleinB:SetAngles(self.AttachmentTable[16].Ang)
	self.zeiger_kleinB:SetParent(self)
	
	self.zeiger_gross = {self.zeiger_grossA, self.zeiger_grossB}
	self.zeiger_klein = {self.zeiger_kleinA, self.zeiger_kleinB}
	self.zeiger = {self.zeiger_gross, self.zeiger_klein}
	return self.zeiger
end

function ENT:Draw()
	self:DrawModel()

	self.TrackNumber = self:GetNWInt("TrackNumber", 0)
	self.TextDepartA = self:GetNWString("TextDepartA", 0)
	self.TextDepartB = self:GetNWString("TextDepartB", 0)
	self.TextDestA = self:GetNWString("TextDestA", 0)
	self.TextDestB = self:GetNWString("TextDestB", 0)
	self.TextLineA = self:GetNWString("TextLineA", 0)
	self.TextLineB = self:GetNWString("TextLineB", 0)
	
	if !self.AttachmentTable then return end
	-- Draw Departure Time
	self:drawText(self.AttachmentTable, 1,  0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDepartA) 
	self:drawText(self.AttachmentTable, 2,  0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDepartA)
	self:drawText(self.AttachmentTable, 3,  0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDepartB)
	self:drawText(self.AttachmentTable, 4,  0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDepartB)
	
	-- Draw Destinations
	self:drawText(self.AttachmentTable, 5,  0.14, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDestA)
	self:drawText(self.AttachmentTable, 6,  0.14, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDestA)
	self:drawText(self.AttachmentTable, 7,  0.14, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDestB)
	self:drawText(self.AttachmentTable, 8,  0.14, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextDestB)
	
	-- Draw Lines
	self:drawText(self.AttachmentTable, 9,  0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextLineA)
	self:drawText(self.AttachmentTable, 10, 0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextLineA)
	self:drawText(self.AttachmentTable, 11, 0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextLineB)
	self:drawText(self.AttachmentTable, 12, 0.15, "DaisyAnzeige", Color(255, 216, 0, 255), self.TextLineB)

	-- Draw Track Number 
	self:drawText(self.AttachmentTable, 13, 0.1, "GleisAnzeige", Color(255, 255, 255, 255), self.TrackNumber)
	self:drawText(self.AttachmentTable, 14, 0.1, "GleisAnzeige", Color(255, 255, 255, 255), self.TrackNumber)
end 

function ENT:drawText(Atttable, index, scale, font, color, text)
	if !Atttable then print("drawtext: No AttachmentTable") return end 
	local index = index or 1
	local scale = scale or 1
	local font = font or ""
	local color = color or color_white
	local text = text or "NULL"
	cam.Start3D2D( Atttable[index].Pos, Atttable[index].Ang, scale )
			surface.SetFont( font ) 
			surface.SetTextColor( color )
			surface.SetTextPos( 0, 0)
			surface.DrawText( text )
	cam.End3D2D()
end

function ENT:OnRemove()
	if not IsValid(self.zeiger) then return end
	SafeRemoveEntity(self.zeiger[1][1])
	SafeRemoveEntity(self.zeiger[1][2])
	SafeRemoveEntity(self.zeiger[2][1])
	SafeRemoveEntity(self.zeiger[2][2])
end

function ENT:Think()
	if Metrostroi then
		local d = os.date("!*t",Metrostroi.GetSyncTime())
		if self.OldSec ~= d.sec then
			self.OldSec = d.sec
			self.SecPull = RealTime()+0.05 
		end
		if d.sec == 0 then
			self:EmitSound("mus/clock_click"..math.random(1,8)..".wav",65,math.random(95,105),0.5)
			self.Minute = Metrostroi.GetSyncTime()/60
			self.Hour =  Metrostroi.GetSyncTime()/3600
		end
		if not IsValid(self.zeiger[1][1]) then return end
		if not IsValid(self.zeiger[1][2]) then return end
		if not IsValid(self.zeiger[2][1]) then return end
		if not IsValid(self.zeiger[2][2]) then return end
		self.zeiger[1][1]:SetAngles(self.AttachmentTable[15].Ang+Angle(self.Minute*-6,0,0))
		self.zeiger[2][1]:SetAngles(self.AttachmentTable[15].Ang+Angle(self.Hour*-30,0,0))
		self.zeiger[1][2]:SetAngles(self.AttachmentTable[16].Ang+Angle(self.Minute*-6,0,0))
		self.zeiger[2][2]:SetAngles(self.AttachmentTable[16].Ang+Angle(self.Hour*-30,0,0))
	else
		if not IsValid(self.zeiger[1][1]) then return end
		if not IsValid(self.zeiger[1][2]) then return end
		if not IsValid(self.zeiger[2][1]) then return end
		if not IsValid(self.zeiger[2][2]) then return end
		self.zeiger[1][1]:SetAngles(self.AttachmentTable[15].Ang+Angle(-6,0,0))
		self.zeiger[2][1]:SetAngles(self.AttachmentTable[15].Ang+Angle(-30,0,0))
		self.zeiger[1][2]:SetAngles(self.AttachmentTable[16].Ang+Angle(-6,0,0))
		self.zeiger[2][2]:SetAngles(self.AttachmentTable[16].Ang+Angle(-30,0))
	end
	if not IsValid(self.zeiger[1][1]) then return end
	if not IsValid(self.zeiger[1][2]) then return end
	if not IsValid(self.zeiger[2][1]) then return end
	if not IsValid(self.zeiger[2][2]) then return end
	self.zeiger[1][1]:SetPos(self.AttachmentTable[15].Pos)
	self.zeiger[2][1]:SetPos(self.AttachmentTable[15].Pos)
	self.zeiger[1][2]:SetPos(self.AttachmentTable[16].Pos)
	self.zeiger[2][2]:SetPos(self.AttachmentTable[16].Pos)
end