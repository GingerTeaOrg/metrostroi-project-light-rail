include("shared.lua")
surface.CreateFont("Lumino", {
	font = "Dot Matrix Umlaut",
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
})

surface.CreateFont("Lumino Dot", {
	font = "Dot Matrix Umlaut Dot",
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
})

surface.CreateFont("Lumino_Big", {
	font = "Dot Matrix Bold",
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
})

surface.CreateFont("Lumino_Cars", {
	font = "DFICustom Cars",
	size = 78,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
})

ENT.RTMaterial = CreateMaterial("UFRT1", "VertexLitGeneric", {["$vertexcolor"] = 0, ["$vertexalpha"] = 1, ["$nolod"] = 1})
ENT.RTMaterial2 = CreateMaterial("UFRT2", "VertexLitGeneric", {["$vertexcolor"] = 0, ["$vertexalpha"] = 0, ["$nolod"] = 1})

function ENT:CreateRT(name, w, h)
	local RT = GetRenderTarget("UF" .. self:EntIndex() .. ":" .. name, w or 512, h or 512)
	if not RT then Error("Can't create RT\n") end
	return RT
end

function ENT:DrawOnPanel(func)
	local panel = {
		pos = Vector(-22, 96.4, 166),
		ang = Angle(0, 0, 96), -- (0,44.5,-47.9),
		width = 117,
		height = 29.9,
		scale = 0.0311
	}
	local panel2 = {
		pos = Vector(-22, 96.4, 166),
		ang = Angle(0, 180, 96), -- (0,44.5,-47.9),
		width = 117,
		height = 29.9,
		scale = 0.0311
	}
	cam.Start3D2D(self:LocalToWorld(Vector(-22, 96.4, 166)), Angle(0, 0, 96), 0.03)
	func(panel)
	cam.End3D2D()
end

function ENT:DrawRTOnPanel(rt)
	cam.Start3D2D(self:LocalToWorld(Vector(-22, 96.4, 166)), Angle(0, 0, 96), 0.03)
	surface.SetMaterial(rt.mat)
	surface.DrawTexturedRectRotated(200 / 2, 50 / 2, 200, 50, 0)
	cam.End3D2D()
end

function ENT:Initialize() 
	self.DFI = self:CreateRT("DFI", 10000, 10000)
	
	self.LineString = " "

	self.AnnouncementPlayed = false
	
	
end

function ENT:PrintText(x, y, text, font)
	local str = {utf8.codepoint(text, 1, -1)}
	for i = 1, #str do
		local char = utf8.char(str[i])
		draw.SimpleText(char, font, (x + i) * 55, y * 15 + 50, Color(255, 136, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	end
end

function ENT:Think()
	local mode = self:GetNW2Int("Mode", 0)
	self.Theme = self:GetNW2String("Theme","Frankfurt")
	
	self.Destination = self:GetNW2String("Train1Destination", "Testbahnhof")
	if self.Theme == "Frankfurt" or self.Theme == "Essen" or self.Theme == "Duesseldorf" then
		self.LineString = self:GetNW2String("Train1Line", "U4")
		if string.sub(self.LineString,1,1) == 0 then
			self.LineString = string.sub(self.LineString,2,2)
			self.LineString = "U"..self.LineString
			print(self.LineString)
		end
	elseif self.Theme == "Koeln" or self."Hannover" then
		if string.sub(self.LineString,1,1) == 0 then
			self.LineString = string.sub(self.LineString,2,2)
			
		end
	end
	if mode == 2 and self.AnnouncementPlayed == false then
		self.AnnouncementPlayed = true
		self:PlayOnceFromPos("lilly/uf/DFI/frankfurt/"..self.LineString.." ".."Richtung"..self.Destination, 1, 1, 1, 1, self:GetPos()-Vector(0,0,-10))
	elseif mode == 1 or mode == 0 then
		self.AnnouncementPlayed = false
	end
	print(self.LineString)
end

function ENT:Draw()
	self:DrawModel()
	
	local mode = self:GetNW2Int("Mode", 0)

	if mode == 2 then
		
		local pos = self:LocalToWorld(Vector(-25, 96, 169))
		local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
		cam.Start3D2D(pos, ang, 0.03)
		self:PrintText(-8, 0, self.LineString, "Lumino_Big")
		self:PrintText(-5.1, 0, self:GetNW2String("Train1Destination", "Testbahnhof"), "Lumino_Big")
		--self:PrintText(-5, 6, self:GetNW2String("TrainVia", "über Testplatz"), "Lumino")
		self:PrintText(10, 11.6, string.rep("ó",self:GetNW2Int("Train1ConsistLength", 1)), "Lumino_Cars")
		self:PrintText(10.3, 12.5, "____", "Lumino")
		self:PrintText(9.1, 13.1, ":", "Lumino")
		
		-- self:PrintText(9.7,12.4,"_","Lumino")
		-- self:PrintText(9.33,13,".","Lumino Dot")
		-- self:PrintText(10.5,12.4,"_","Lumino")
		-- self:PrintText(10.94,13,".","Lumino Dot")
		--[[self:PrintText(9.55,12.4,"_","Lumino")
		self:PrintText(10.3,12.4,"_","Lumino")
		self:PrintText(11.05,12.4,"_","Lumino")
		self:PrintText(11.8,12.4,"_","Lumino")
		self:PrintText(12.55,12.4,"_","Lumino")]]
		cam.End3D2D()
	elseif mode == 1 then
		
		local pos = self:LocalToWorld(Vector(-38.5, 96, 169.2))
		local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
		cam.Start3D2D(pos, ang, 0.03)
		-- surface.SetDrawColor(255, 255, 255, 255)
		-- surface.DrawRect(0, 0, 256, 320)
		
		self:PrintText(-1.5, 0, self:GetNW2String("Train1Line", "E0"), "Lumino_Big")
		self:PrintText(1, 0, self:GetNW2String("Train1Destination", "ERROR"), "Lumino")
		if #self:GetNW2String("Train1Time", "5") == 2 then
			self:PrintText(25, 0, self:GetNW2String("Train1Time", "10"), "Lumino")
		elseif #self:GetNW2String("Train1Time", "5") == 1 then
			self:PrintText(26, 0, self:GetNW2String("Train1Time", "5"), "Lumino")
		end
		self:PrintText(-1.5, 6, self:GetNW2String("Train2Line", "E0"), "Lumino_Big")
		self:PrintText(1, 6, self:GetNW2String("Train2Destination", "ERROR"), "Lumino")
		if #self:GetNW2String("Train2Time", "5") == 2 then
			self:PrintText(25, 6, self:GetNW2String("Train2Time", " "), "Lumino")
		elseif #self:GetNW2String("Train2Time", " ") == 1 then
			self:PrintText(26, 6, self:GetNW2String("Train2Time", " "), "Lumino")
		end
		
		self:PrintText(-1.5, 12, self:GetNW2String("Train3Line", "E0"), "Lumino_Big")
		self:PrintText(1, 12, self:GetNW2String("Train3Destination", "ERROR"), "Lumino")
		if #self:GetNW2String("Train3Time", "5") == 2 then
			self:PrintText(25, 12, self:GetNW2String("Train3Time", "10"), "Lumino")
		elseif #self:GetNW2String("Train3Time", "5") == 1 then
			self:PrintText(26, 12, self:GetNW2String("Train3Time", "5"), "Lumino")
		end
		
		self:PrintText(-1.5, 18, self:GetNW2String("Train4Line", "E0"), "Lumino_Big")
		self:PrintText(1, 18, self:GetNW2String("Train4Destination", "ERROR"), "Lumino")
		if #self:GetNW2String("Train4Time", "5") == 2 then
			self:PrintText(25, 18, self:GetNW2String("Train4Time", "10"), "Lumino")
		elseif #self:GetNW2String("Train4Time", "5") == 1 then
			self:PrintText(26, 18, self:GetNW2String("Train4Time", "5"), "Lumino")
		end
		cam.End3D2D()
		
		
	elseif mode == 0 then
		local pos = self:LocalToWorld(Vector(-25, 96, 169))
		local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
		cam.Start3D2D(pos, ang, 0.03)
		-- surface.SetDrawColor(255, 255, 255, 255)
		-- surface.DrawRect(0, 0, 256, 320)
		
		draw.Text({
			text = "Auf Zugschild achten!",
			font = "Lumino", -- ..self:GetNW2Int("Style", 1),
			pos = {200, 110},
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_LEFT,
			color = Color(255, 136, 0)
		})
		cam.End3D2D()
	end
end

