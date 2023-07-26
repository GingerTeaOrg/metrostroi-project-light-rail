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


ENT.RTMaterial = CreateMaterial("UFRT1","UnlitGeneric",{
    ["$vertexcolor"] = 0,
    ["$vertexalpha"] = 1,
    ["$nolod"] = 1,
})
ENT.RTMaterial2 = CreateMaterial("UFRT2","UnlitGeneric",{
    ["$vertexcolor"] = 0,
    ["$vertexalpha"] = 0,
    ["$nolod"] = 1,
})

function ENT:CreateRT(name, w, h)
    local RT = GetRenderTarget("UF"..self:EntIndex()..":"..name, w or 512, h or 512)
    if not RT then Error("Can't create RT\n") end
    return RT
end

function ENT:DrawOnPanel(func)
    local panel = {
    pos = Vector(-22, 96.4, 166),
    ang = Angle(0, 0, 96),--(0,44.5,-47.9),
    width = 117,
    height = 29.9,
    scale = 0.0311,}
    cam.Start3D2D(self:LocalToWorld(Vector(-22, 96.4, 166)), Angle(0, 0, 96), 0.03)
    func(panel)
    cam.End3D2D()
end

function ENT:DrawRTOnPanel(rt)
    cam.Start3D2D(self:LocalToWorld(Vector(-22, 96.4, 166)), Angle(0, 0, 96), 0.03)
    surface.SetMaterial(rt.mat)
    surface.DrawTexturedRectRotated(200/2,50/2,200,50,0)
    cam.End3D2D()
end


function ENT:Initialize()
    
    self.DFI = self:CreateRT("DFI",10000,10000)
end

function ENT:PrintText(x,y,text,font)
    local str = {utf8.codepoint(text,1,-1)}
    for i=1,#str do
        local char = utf8.char(str[i])
        draw.SimpleText(char,font,(x+i)*55,y*15+50,Color(255, 136, 0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        
    end
end

--[[function ENT:DrawPost()
    self.RTMaterial:SetTexture("$basetexture",self.DFI)
    self:DrawOnPanel(function(...)
        surface.SetMaterial(self.RTMaterial)
        surface.SetDrawColor(255,166,0)
        surface.DrawTexturedRectRotated(59,16,10000,10000,0)
    end)
end]]

function ENT:Draw()
    self:DrawModel()
    
    --self:DrawRTOnPanel(self.DFI)
    
    --self:CreateRT("DFI",10000,10000)
    
    
    
    local mode = 2 --self:GetNW2Int("Mode", 0)
    if mode == 2 then
        local pos = self:LocalToWorld(Vector(-25, 96, 169))
        local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
        cam.Start3D2D(pos, ang, 0.03)
        self:PrintText(-8,0,self:GetNW2String("Train Line", "U4"),"Lumino_Big")
        self:PrintText(-5.1,0,self:GetNW2String("Train Destination", "Testbahnhof"),"Lumino_Big")
        self:PrintText(-5,6,self:GetNW2String("Train Via", "über Testplatz"),"Lumino")
        self:PrintText(10,11.6,self:GetNW2String("Car Count", "ó"),"Lumino_Cars")
        self:PrintText(11.6,11.6,self:GetNW2String("Car Count", "ó"),"Lumino_Cars")
        self:PrintText(13.2,11.6,self:GetNW2String("Car Count", "ó"),"Lumino_Cars")
        self:PrintText(14.8,11.6,self:GetNW2String("Car Count", "ó"),"Lumino_Cars")
        --self:PrintText(9.7,12.4,"_","Lumino")
        --self:PrintText(9.33,13,".","Lumino Dot")
        --self:PrintText(10.5,12.4,"_","Lumino")
        --self:PrintText(10.94,13,".","Lumino Dot")
        --[[self:PrintText(9.55,12.4,"_","Lumino")
        self:PrintText(10.3,12.4,"_","Lumino")
        self:PrintText(11.05,12.4,"_","Lumino")
        self:PrintText(11.8,12.4,"_","Lumino")
        self:PrintText(12.55,12.4,"_","Lumino")]]
        cam.End3D2D()
    elseif mode == 1 then
        if self:GetNW2Bool("NothingRegistered", true) == false then
        local pos = self:LocalToWorld(Vector(-38.5, 96, 169.2))
        local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
        cam.Start3D2D(pos, ang, 0.03)
        --surface.SetDrawColor(255, 255, 255, 255)
        --surface.DrawRect(0, 0, 256, 320)
        self:PrintText(-1.5,0,self:GetNW2String("Train1Line", "U2"),"Lumino_Big")
        self:PrintText(1,0,self:GetNW2String("Train1Destination", "Testbahnhof"),"Lumino")
        if #self:GetNW2String("Train1Time", "5") == 2 then
            self:PrintText(25,0,self:GetNW2String("Train1Time", "10"),"Lumino")
        elseif #self:GetNW2String("Train1Time", "5") == 1 then
            self:PrintText(26,0,self:GetNW2String("Train1Time", "5"),"Lumino")
        end
        self:PrintText(-1.5,6,self:GetNW2String("Train2Line", "U2"),"Lumino_Big")
        self:PrintText(1,6,self:GetNW2String("Train2Destination", "Testbahnhof"),"Lumino")
        if #self:GetNW2String("Train2Time", "5") == 2 then
            self:PrintText(25,6,self:GetNW2String("Train2Time", "10"),"Lumino")
        elseif #self:GetNW2String("Train2Time", "5") == 1 then
            self:PrintText(26,6,self:GetNW2String("Train2Time", "5"),"Lumino")
        end

        self:PrintText(-1.5,12,self:GetNW2String("Train3Line", "U2"),"Lumino_Big")
        self:PrintText(1,12,self:GetNW2String("Train3Destination", "Testbahnhof"),"Lumino")
        if #self:GetNW2String("Train3Time", "5") == 2 then
            self:PrintText(25,12,self:GetNW2String("Train3Time", "10"),"Lumino")
        elseif #self:GetNW2String("Train3Time", "5") == 1 then
            self:PrintText(26,12,self:GetNW2String("Train3Time", "5"),"Lumino")
        end

        self:PrintText(-1.5,18,self:GetNW2String("Train4Line", "U2"),"Lumino_Big")
        self:PrintText(1,18,self:GetNW2String("Train4Destination", "Testbahnhof"),"Lumino")
        if #self:GetNW2String("Train4Time", "5") == 2 then
            self:PrintText(25,18,self:GetNW2String("Train4Time", "10"),"Lumino")
        elseif #self:GetNW2String("Train4Time", "5") == 1 then
            self:PrintText(26,18,self:GetNW2String("Train4Time", "5"),"Lumino")
        end
        cam.End3D2D()
    else
        local pos = self:LocalToWorld(Vector(-25, 96, 169))
        local ang = self:LocalToWorldAngles(Angle(0, 0, 96))
        cam.Start3D2D(pos, ang, 0.03)
        --surface.SetDrawColor(255, 255, 255, 255)
        --surface.DrawRect(0, 0, 256, 320)
        
        draw.Text({
            text = "Auf Zugschild achten!",
            font = "Lumino", --..self:GetNW2Int("Style", 1),
            pos = {200, 110},
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_LEFT,
            color = Color(255, 136, 0)
        })
        cam.End3D2D()
    end
    
end
end

