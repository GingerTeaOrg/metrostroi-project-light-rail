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
	
	
	
	self.AnnouncementPlayed = false
	
	
end

function ENT:PrintText(x, y, text, font)
	local str = {utf8.codepoint(text, 1, -1)}
	for i = 1, #str do
		local char = utf8.char(str[i])
		draw.SimpleText(char, font, (x + i) * 55, y * 15 + 50, Color(255, 166, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	end
end

function ENT:Think()
	local mode = self:GetNW2Int("Mode", 0)
	self.Theme = self:GetNW2String("Theme","Frankfurt")
	
	self.Destination = self:GetNW2String("Train1Destination", "Testbahnhof")
	if self.Theme == "Frankfurt" or self.Theme == "Essen" or self.Theme == "Duesseldorf" then
		if string.sub(self:GetNW2String("Train1Line", "04"),1,1) == "0" then
			self.LineString1 = "U" .. string.sub(self:GetNW2String("Train1Line", "U4"), 2,2)
		elseif string.sub(self:GetNW2String("Train1Line", "U4"),1,1) ~= "0" then
			self.LineString1 = "U" .. self:GetNW2String("Train1Line", "U4")
		end
		
		if string.sub(self:GetNW2String("Train2Line", "U4"),1,1) == "0" then
			self.LineString2 = "U" .. string.sub(self:GetNW2String("Train2Line", "U4"), 2,2)
		elseif string.sub(self:GetNW2String("Train2Line", "U4"),1,1) ~= "0" then
			self.LineString2 = "U" .. self:GetNW2String("Train2Line", "U4")
		end
		
		if string.sub(self:GetNW2String("Train3Line", "U4"),1,1) == "0" then
			self.LineString3 = "U" .. string.sub(self:GetNW2String("Train3Line", "U4"), 2,2)
		elseif string.sub(self:GetNW2String("Train3Line", "U4"),1,1) ~= "0" then
			self.LineString3 = "U" .. self:GetNW2String("Train3Line", "U4")
		end
		
		if string.sub(self:GetNW2String("Train4Line", "U4"),1,1) == "0" then
			self.LineString4 = "U" .. string.sub(self:GetNW2String("Train4Line", "U4"), 2,2)
		elseif string.sub(self:GetNW2String("Train4Line", "U4"),1,1) ~= "0" then
			self.LineString4 = "U" .. self:GetNW2String("Train4Line", "U4")
		end
	elseif self.Theme == "Koeln" or self.Theme == "Hannover" then
		if string.sub(self:GetNW2String("Train1Line", "E0"),1,1) == "0" then
			self.LineString1 = string.sub(self:GetNW2String("Train1Line", "E0"), 2,2)
		elseif string.sub(self:GetNW2String("Train1Line", "E0"),1,1) ~= "0" then
			self.LineString1 = self:GetNW2String("Train1Line", "E0")
		end
		if string.sub(self:GetNW2String("Train2Line", "E0"),1,1) == "0" then
			self.LineString2 = string.sub(self:GetNW2String("Train2Line", "E0"), 2,2)
		elseif string.sub(self:GetNW2String("Train2Line", "E0"),1,1) ~= "0" then
			self.LineString2 = self:GetNW2String("Train2Line", "E0")
		end
		if string.sub(self:GetNW2String("Train3Line", "E0"),1,1) == "0" then
			self.LineString3 = string.sub(self:GetNW2String("Train3Line", "E0"), 2,2)
		elseif string.sub(self:GetNW2String("Train3Line", "E0"),1,1) ~= "0" then
			self.LineString3 = self:GetNW2String("Train3Line", "E0")
		end
		if string.sub(self:GetNW2String("Train4Line", "E0"),1,1) == "0" then
			self.LineString4 = string.sub(self:GetNW2String("Train4Line", "E0"), 2,2)
		elseif string.sub(self:GetNW2String("Train4Line", "E0"),1,1) ~= "0" then
			self.LineString4 = self:GetNW2String("Train4Line", "E0")
		end
	end
	if mode == 2 and self.AnnouncementPlayed == false then
		self.AnnouncementPlayed = true
		if self.Theme == "Frankfurt" then
			if self.Destination1 ~= "Leerfahrt" and self.Destination1 ~= "PROBEWAGEN NICHT EINSTEIGEN" and self.Destination1 ~= "FAHRSCHULE NICHT EINSTEIGEN" and self.Destination1 ~= "SONDERWAGEN NICHT EINSTEIGEN" and self.Destination1 ~= " " then
				self:PlayOnceFromPos("lilly/uf/DFI/frankfurt/"..self.LineString1.." ".."Richtung".." "..self.Destination..".mp3", 2, 1, 1, 1, self:GetPos())
			else
				self:PlayOnceFromPos("lilly/uf/DFI/frankfurt/Bitte Nicht Einsteigen.mp3", 2, 1, 1, 1, self:GetPos())
			end
		end
	elseif mode == 1 or mode == 0 then
		self.AnnouncementPlayed = false
	end
	
	
	self.Train1Time = self:GetNW2String("Train1Time", "E")
	self.Train2Time = self:GetNW2String("Train2Time", "E")
	self.Train3Time = self:GetNW2String("Train3Time", "E")
	self.Train4Time = self:GetNW2String("Train4Time", "E")
	
	self.Train1Destination = self:GetNW2String("Train1Destination", "ERROR")
	self.Train2Destination = self:GetNW2String("Train2Destination", "ERROR")
	self.Train3Destination = self:GetNW2String("Train3Destination", "ERROR")
	self.Train4Destination = self:GetNW2String("Train4Destination", "ERROR")
	
	self.Train1Entry = self:GetNW2Bool("Train1Entry",false)
	self.Train2Entry = self:GetNW2Bool("Train2Entry",false)
	self.Train3Entry = self:GetNW2Bool("Train3Entry",false)
	self.Train4Entry = self:GetNW2Bool("Train4Entry",false)


	
end

function ENT:Draw()
	self:DrawModel()
	
	local mode = self:GetNW2Int("Mode", 0)
	
	if mode == 2 then
		
		local pos = self:LocalToWorld(Vector(-25, 96, 169))
		local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
		cam.Start3D2D(pos, ang, 0.03)
		self:PrintText(-8, 0, self.LineString1, "Lumino_Big")
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
		
		---------------------------------------------------------------------------------
		self:PrintText(-1.5, 0, self.LineString1, "Lumino_Big")
		self:PrintText(1, 0, self.Train1Destination, "Lumino")
		if #self.Train1Time == 2 then
			self:PrintText(25, 0, self:GetNW2String("Train1Time", "10"), "Lumino")
		elseif #self.Train1Time == 1 then
			self:PrintText(26, 0, self:GetNW2String("Train1Time", "5"), "Lumino")
		end
		---------------------------------------------------------------------
		if self.Train2Entry == true then
			self:PrintText(-1.5, 6, self.LineString2, "Lumino_Big")
			self:PrintText(1, 6, self.Train2Destination, "Lumino")
			if #self.Train2Time == 2 then
				self:PrintText(25, 6, self.Train2Time, "Lumino")
			elseif #self.Train2Time == 1 then
				self:PrintText(26, 6, self.Train2Time, "Lumino")
			end
		end
		----------------------------------------------------------------------
		if self.Train3Entry == true then
			self:PrintText(-1.5, 12, self.LineString3, "Lumino_Big")
			self:PrintText(1, 12, self.Train3Destination, "Lumino")
			if #self.Train3Time == 2 then
				self:PrintText(25, 12, self.Train3Time, "Lumino")
			elseif #self.Train3Time == 1 then
				self:PrintText(26, 12, self.Train3Time, "Lumino")
			end
		end
		-------------------------------------------------------------------------------
		if self.Train4Entry == true then
			self:PrintText(-1.5, 18, self.LineString4, "Lumino_Big")
			self:PrintText(1, 18, self.Train4Destination, "Lumino")
			if #self.Train4Time == 2 then
				self:PrintText(25, 18, self.Train4Time, "Lumino")
			elseif #self.Train4Time == 1 then
				self:PrintText(26, 18, self.Train4Time, "Lumino")
			end
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
			pos = {204, 110},
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_LEFT,
			color = Color(255, 136, 0)
		})
		cam.End3D2D()
	end
end

