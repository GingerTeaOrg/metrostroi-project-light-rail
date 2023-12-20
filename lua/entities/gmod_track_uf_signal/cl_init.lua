include("shared.lua")
ENT.flux = include("flux.lua")



--------------------------------------------------------------------------------
function ENT:Initialize()
    
    self.RT = CreateMaterial( "bg", "VertexLitGeneric", {
        ["$basetexture"] = "color/white",
        ["$model"] = 1,
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$vertexcolor"] = 1
    } )
    
end

net.Receive("mplr-signal", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    ent.Routes = net.ReadTable()
    ent.Name = net.ReadString()
    ent.Name1 = net.ReadString()
    ent.Name2 = net.ReadString()
end)

local timer = CurTime()

hook.Add("Think","MPLRRenderSignals", function()
    local C_RenderDistance = GetConVar("mplr_signal_distance")
    if CurTime() - timer < 1.5 or not IsValid(LocalPlayer()) then return end
    timer = CurTime()
    local plyPos = LocalPlayer():GetPos()
    --if C_RenderDistance:GetInt() then
    --    local dist = C_RenderDistance:GetInt()
    --else
    local dist = 8192
    --end
    for _,sig in pairs(ents.FindByClass("gmod_track_uf_signal*")) do
        if not IsValid(sig) then continue end
        local sigPos = sig:GetPos()
        sig.RenderDisable = sigPos:Distance(plyPos) > dist or math.abs(plyPos.z - sigPos.z) > 1500
    end
end)

function ENT:Think()

    local CurTime = CurTime()
    self:SetNextClientThink(CurTime + 0.0333)
    self.PrevTime = self.PrevTime or RealTime()
    self.DeltaTime = (RealTime() - self.PrevTime)
    self.PrevTime = RealTime()
    
    if not self.Name then
        if self.Sent and (CurTime - self.Sent) > 0 then
            self.Sent = nil
        end
        if not self.Sent then
            net.Start("metrostroi-signal")
            net.WriteEntity(self)
            net.SendToServer()
            self.Sent = CurTime + 1.5
        end
        return true
    end
    
    self.Aspect = self:GetNW2String("Aspect","H0")
    self.SignalType = self:GetNW2String("Type")
end



function ENT:Draw()
    
    
    -- Draw model
    self:DrawModel()
    local ang = self:LocalToWorldAngles(Angle(0,90,90))
    local pos = self:LocalToWorld(Vector(7.5, 3.99, 125))
    local pos2 = self:LocalToWorld(Vector(7.5, 3.5, 117))
    rectangle = self:LocalToWorld(Vector(7.5, 3.99, 125))
    cam.Start3D2D(pos, ang, 0.05)
    surface.SetMaterial(self.RT)
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect(rectangle.x,rectangle.y,100,200)
    self:PrintText(0, 0, self.Name1 or "ER", "Text",Color(78, 0, 0))        
    cam.End3D2D()
    cam.Start3D2D(pos2,ang, 0.06)
    self:PrintText2(0, 0, self.Name2 or "ER", "TextLarge",Color(0, 0, 0))        
    cam.End3D2D()
    
    self:SignalAspect(self.Aspect or "H0")
    --[[if self.PreviousAspect ~= self.Aspect then
        
        self:FadeFromTo(self.PreviousAspect,self.Aspect)
        self.PreviousAspect = self.Aspect
    end]]
    
    
    
    
end

function ENT:FadeFromTo(PreviousAspect,NextAspect)
    
    if not PreviousAspect and NextAspect then return end
    if PreviousAspect == NextAspect then return end
    local fadeDuration = 4
    if not self.FadeRecorded then
        self.FadeRecorded = true
        self.FadeStart = CurTime()
        self.Fade = math.Clamp((CurTime() - self.FadeStart) / fadeDuration,0,1)
        local deltaTime = RealFrameTime()
        if PreviousAspect == "H0" and NextAspect == "H1" then
            --self.AlphaRed = Lerp(self.Fade, 255, 0)
            flux.to(self.AlphaRed, 2, { ["self.AlphaRed"] = 0 })
            --self.AlphaGreen = Lerp(self.Fade, 0, 255)
            flux.to(self.AlphaGreen, 2, { ["self.AlphaGreen"] = 255})
            self.AlphaOrange = 0
        elseif PreviousAspect == "H0" and NextAspect == "H2" then
            --self.AlphaRed = Lerp(self.Fade, 255, 0)
            flux.to(self.AlphaRed, 2, { ["self.AlphaRed"] = 0 })
            --self.AlphaGreen = Lerp(self.Fade, 0, 255)
            flux.to(self.AlphaGreen, 2, { ["self.AlphaGreen"] = 255})
            --self.AlphaOrange = Lerp(self.Fade, 0, 255)
            flux.to(self.AlphaOrange, 2, { ["self.AlphaOrange"] = 255})
        elseif PreviousAspect == "H1" and NextAspect == "H0" then
            self.AlphaRed = Lerp(self.Fade, 0, 255)
            self.AlphaGreen = Lerp(self.Fade, 255, 0)
            self.AlphaOrange = 0
        elseif PreviousAspect == "H1" and NextAspect == "H2" then
            self.AlphaOrange = Lerp(self.Fade, 0, 255)
            self.AlphaRed = 0
        elseif PreviousAspect == "H2" and NextAspect == "H1" then
            self.AlphaRed = 0
            self.AlphaOrange = Lerp(self.Fade, 0, 255)
            self.AlphaGreen = 255
        elseif PreviousAspect == "H2" and NextAspect == "H0" then
            self.AlphaOrange = Lerp(self.Fade, 255, 0)
            self.AlphaGreen = Lerp(self.Fade, 255, 0)
            self.AlphaRed = Lerp(self.Fade, 0, 255)
        end
    end
    self.FadeRecorded = false
end

function ENT:ClientSprites(position, size, color,active,fadeIn,fadeOut)
    if not active then return end
    local material = Material("effects/yellowflare")
    render.SetMaterial( material )
    render.DrawSprite( position, size, size, color) 
end

function ENT:SignalAspect(aspect)
    if not aspect then return end
    self:GetPlayerDistance()
    pos_o = self:LocalToWorld(Vector(7.5, 10.4, 146.4))
    pos_g = self:LocalToWorld(Vector(7.5, 10.4, 166.5))
    pos_r = self:LocalToWorld(Vector(7.5, 10.4, 157.8))
    pos_rr = self:LocalToWorld(Vector(-7.5, -9.5, 135.8))

    local ScalingEnabled = GetConVar("mplr_enable_signal_sprite_scaling"):GetBool()
    
    self.SpriteSize = ScalingEnabled and self.SignalType == "models/lilly/uf/signals/Underground_Small_Pole.mdl" and math.Clamp(10 + self.DistanceFactor,10,30) or 10
    
    if aspect == "H0" and self.SignalType == "models/lilly/uf/signals/Underground_Small_Pole.mdl" then

        self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0), false)

        self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0), false)
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed or 255), true)
        self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0), true)
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0), true)
        self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0), false)
    elseif aspect == "H1" and self.SignalType == "models/lilly/uf/signals/Underground_Small_Pole.mdl" then
        --self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0,self.AlphaOrange), true)
        self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0), false)
        --self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0,self.AlphaGreen), true)
        self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0), true)
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed), true)
        self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0), false)
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0,alpha_rr), true)
        self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0), true)
    elseif aspect == "H2" and self.SignalType == "models/lilly/uf/signals/Underground_Small_Pole.mdl" then
        --self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0,self.AlphaOrange), true)
        self:ClientSprites(pos_o, self.SpriteSize, Color(204, 116, 0), true)
        --self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0,self.AlphaGreen), true)
        self:ClientSprites(pos_g, self.SpriteSize, Color(27, 133, 0), true)
        --self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0,self.AlphaRed), true)
        self:ClientSprites(pos_r, self.SpriteSize, Color(200, 0, 0), false)
        --self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0,alpha_rr), true)
        self:ClientSprites(pos_rr, self.SpriteSize, Color(200, 0, 0), true)      
    end
end

function ENT:GetPlayerDistance() --get distance to the player so that we can scale up the sprites artificially
    local ply = LocalPlayer()
    local plyDist = ply:GetPos():Distance2DSqr(self:GetPos()) --Let's just do a simplified 2D vector. It's not *that* crucial to have the Z axis, too.
    self.DistanceFactor = (plyDist / 5) * 0.0005
end

local debug = GetConVar("metrostroi_drawsignaldebug")

local function enableDebug()
    if debug:GetBool() then
        hook.Add("PreDrawEffects","MetrostroiSignalDebug",function()
            for _,sig in pairs(ents.FindByClass("gmod_track_uf_signal")) do
                if IsValid(sig) and LocalPlayer():GetPos():Distance(sig:GetPos()) < 384 then
                    local pos = sig:LocalToWorld(Vector(48,0,150))
                    local ang = sig:LocalToWorldAngles(Angle(0,180,90))
                    cam.Start3D2D(pos, ang, 0.25)
                    
                    if sig:GetNW2Bool("Debug",false) then
                        surface.SetDrawColor(sig.ARSOnly and 255 or 125, 125, 0, 255)
                        surface.DrawRect(0, -60, 364, 210)
                        if not sig.ARSOnly then
                            surface.DrawRect(0, 155, 240, 170)
                            surface.DrawRect(0, 330, 240, 190)
                            surface.SetDrawColor(0,0,0, 255)
                            surface.DrawRect(245, 155, 119, 365)
                        else
                            surface.DrawRect(0, 155, 364, 150)
                            surface.DrawRect(0, 310, 364, 190)
                        end
                        
                        if sig.Name then
                            draw.DrawText(Format("Joint main info (%d)",sig:EntIndex()),"Trebuchet24",5,-60,Color(200,0,0,255))
                            draw.DrawText("Signal name: "..sig.Name,"Trebuchet24",          15, -40,Color(0, 0, 0, 255))
                            draw.DrawText("TrackID: "..sig:GetNW2Int("PosID",0),"Trebuchet24",  25, -20,Color(0, 0, 0, 255))
                            draw.DrawText(Format("PosX: %.02f",sig:GetNW2Float("Pos",0)),"Trebuchet24", 135, -20,Color(0, 0, 0, 255))
                            draw.DrawText(Format("NextSignalName: %s",sig:GetNW2String("NextSignalName","N/A")),"Trebuchet24",  15, 0,Color(0, 0, 0, 255))
                            draw.DrawText(Format("TrackID: %s",sig:GetNW2Int("NextPosID",0)),"Trebuchet24", 25, 20,Color(0, 0, 0, 255))
                            draw.DrawText(Format("PosX: %.02f",sig:GetNW2Float("NextPos",0)),"Trebuchet24", 135, 20,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Dist: %.02f",sig:GetNW2Float("DistanceToNext",0)),"Trebuchet24",  15, 40,Color(0, 0, 0, 255))
                            draw.DrawText(Format("PrevSignalName: %s",sig:GetNW2String("PrevSignalName","N/A")),"Trebuchet24",  15, 60,Color(0, 0, 0, 255))
                            draw.DrawText(Format("TrackID: %s",sig:GetNW2Int("PrevPosID",0)),"Trebuchet24", 25, 80,Color(0, 0, 0, 255))
                            draw.DrawText(Format("PosX: %.02f",sig:GetNW2Float("PrevPos",0)),"Trebuchet24", 135, 80,Color(0, 0, 0, 255))
                            draw.DrawText(Format("DistPrev: %.02f",sig:GetNW2Float("DistanceToPrev",0)),"Trebuchet24",  15, 100,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Current route: %d",sig:GetNW2Int("CurrentRoute",-1)),"Trebuchet24",   15, 120,Color(0, 0, 0, 255))
                            
                            draw.DrawText("AB info","Trebuchet24",5,160,Color(200,0,0,255))
                            draw.DrawText(Format("Occupied: %s",sig:GetNW2Bool("Occupied",false) and "Y" or "N"),"Trebuchet24",5,180,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Linked to controller: %s",sig:GetNW2Bool("LinkedToController",false) and "Y" or "N"),"Trebuchet24",5,200,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Num: %d",sig:GetNW2Int("ControllersNumber",0)),"Trebuchet24",10,220,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Controller logic: %s",sig:GetNW2Bool("BlockedByController",false) and "Y" or "N"),"Trebuchet24",5,240,Color(0, 0, 0, 255))
                            draw.DrawText(Format("Autostop: %s",not sig.ARSOnly and sig.AutostopPresent and (sig:GetNW2Bool("Autostop") and "Up" or "Down") or "No present"),"Trebuchet24",5,260,Color(0, 0, 0, 255))
                            draw.DrawText(Format("2/6: %s",sig:GetNW2Bool("2/6",false) and "Y" or "N"),"Trebuchet24",5,280,Color(0, 0, 0, 255))
                            draw.DrawText(Format("FreeBS: %d",sig:GetNW2Int("FreeBS")),"Trebuchet24",5,300,Color(0, 0, 0, 255))
                            
                            draw.DrawText("ARS info","Trebuchet24",5,335,Color(200,0,0,255))
                            local num = 0
                            for i,tbl in pairs(ars) do
                                if not tbl then continue end
                                if sig:GetNW2Bool("CurrentARS"..(i-1),false) then
                                    draw.DrawText(Format("(% s)",tbl[1]),"Trebuchet24",5,355+num*20,Color(0,100,0,255))
                                    draw.DrawText(Format("%s",tbl[2]),"Trebuchet24",105,355+num*20,Color(0,100,0,255))
                                else
                                    draw.DrawText(Format("(% s)",tbl[1]),"Trebuchet24",5,355+num*20,Color(0, 0, 0, 255))
                                    draw.DrawText(Format("%s",tbl[2]),"Trebuchet24",105,355+num*20,Color(0, 0, 0, 255))
                                end
                                num = num+1
                            end
                            if sig:GetNW2Bool("CurrentARS325",false) or sig:GetNW2Bool("CurrentARS325_2",false) then
                                draw.DrawText("(325 Hz)","Trebuchet24",5,355+num*20,Color(0,100,0,255))
                                draw.DrawText(Format("LN:%s Apr0:%s",sig:GetNW2Bool("CurrentARS325",false) and "Y" or "N",sig:GetNW2Bool("CurrentARS325_2",false) and "Y" or "N"),"Trebuchet24",105,355+num*20,Color(0,100,0,255))
                            else
                                draw.DrawText("(325 Hz)","Trebuchet24",5,355+num*20,Color(0, 0, 0, 255))
                                draw.DrawText(Format("LN:%s Apr0:%s",sig:GetNW2Bool("CurrentARS325",false) and "Y" or "N",sig:GetNW2Bool("CurrentARS325_2",false) and "Y" or "N"),"Trebuchet24",105,355+num*20,Color(0, 0, 0, 255))
                            end
                            
                            if not sig.ARSOnly then
                                draw.DrawText("Signal info","Trebuchet24",250,160,Color(200,0,0,255))
                                local ID = 0
                                local ID2 = 0
                                local first = true
                                for _,v in ipairs(sig.LensesTBL) do
                                    local data
                                    if not sig.TrafficLightModels[sig.LightType][v] then
                                        data = sig.TrafficLightModels[sig.LightType][#v-1]
                                    else
                                        data = sig.TrafficLightModels[sig.LightType][v]
                                    end
                                    if not data then continue end
                                    
                                    --sig.NamesOffset = sig.NamesOffset + Vector(0,0,data[1])
                                    if v ~= "M" then
                                        for i = 1,#v do
                                            ID2 = ID2 + 1
                                            local n = tonumber(sig.Sig[ID2])
                                            local State = n == 1 and "X" or (n == 2 and (RealTime() % 1.2 > 0.4)) and "B" or false
                                            draw.DrawText(Format(v[i],sig:EntIndex()),"Trebuchet24",250,160 + ID*20 + ID2*20,cols[v[i]])
                                            if State then
                                                draw.DrawText(State,"Trebuchet24",280,160 + ID*20 + ID2*20,cols[v[i]])
                                            end
                                        end
                                    else
                                        ID2 = ID2 + 1
                                        draw.DrawText("M","Trebuchet24",250,160 + ID*20 + ID2*20,Color(200,200,200))
                                        draw.DrawText(sig.Num or "none","Trebuchet24",280,160 + ID*20 + ID2*20,Color(200,200,200))
                                        
                                        --if Metrostroi.RoutePointer[sig.Num[1]] then sig.Models[1][sig.RouteNumber]:SetSkin(Metrostroi.RoutePointer[sig.Num[1]]) end
                                    end
                                    
                                    ID = ID + 1
                                end
                            end
                        else
                            draw.DrawText("No data...","Trebuchet24",5,0,Color(0, 0, 0, 255))
                        end
                    else
                        surface.SetDrawColor(sig.ARSOnly and 255 or 125, 125, 0, 255)
                        surface.DrawRect(0, 0, 364, 25)
                        draw.DrawText("Debug disabled...","Trebuchet24",5,0,Color(0, 0, 0, 255))
                    end
                    cam.End3D2D()
                end
            end
        end)
    else
        hook.Remove("PreDrawEffects","MetrostroiSignalDebug")
    end
end
hook.Remove("PreDrawEffects","MetrostroiSignalDebug")
cvars.AddChangeCallback( "metrostroi_drawsignaldebug", enableDebug)
enableDebug()

function ENT:PrintText(x, y, text, font,color)
    local str = {utf8.codepoint(text, 1, -1)}
    for i = 1, #str do
        local char = utf8.char(str[i])
        draw.SimpleText(char, font, (x + i) * 55, y * 15 + 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
    end
end

function ENT:PrintText2(x, y, text, font,color)
    local str = {utf8.codepoint(text, 1, -1)}
    for i = 1, #str do
        local char = utf8.char(str[i])
        draw.SimpleText(char, font, (x + i) * 75, y * 15 + 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
    end
end


surface.CreateFont("Text", {
    font = "AkzidenzGroteskBE-Cn", --Akzidenz Gotesk BE Cn
    size = 160,
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
surface.CreateFont("TextLarge", {
    font = "AkzidenzGroteskBE-Cn", --Akzidenz Gotesk BE Cn
    size = 254,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
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
