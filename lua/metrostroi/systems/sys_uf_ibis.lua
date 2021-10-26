Metrostroi.DefineSystem("IBIS")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.Route = 0
    self.RouteChar1 = nil
    self.RouteChar2 = nil

	self.Course = 0
    self.CourseChar1 = nil
    self.CourseChar2 = nil
    self.CourseChar3 = nil
    self.CourseChar4 = nil


	self.Destination = 0
    self.DestinationChar1 = nil
    self.DestinationChar2 = nil
    self.DestinationChar3 = nil
	
    self.KeyInput = nil

	 self.TriggerNames = {
        "Number1",
        "Number2",
        "Number3",
        "Number4",
        "Number5",
        "Number6",
		"Number7",
		"Number8",
		"Number9",
		"Number0",
		"Destination",
        "Delete",
        "Enter",
        "SpecialAnnouncements",
        "TimeAndDate"
    }

    self.Triggers = {}
    self.State = 0

    self.Menu = 0
    self.Announce = false


    if not self:GetNW2Int("CabActive",0) == 1 then
        self.Train:LoadSystem("Number1","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number2","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number3","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number4","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number5","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number6","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number7","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number8","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number9","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Number0","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Destination","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Delete","Relay","Switch",{bass = true })
        self.Train:LoadSystem("SpecialAnnouncements","Relay","Switch",{bass = true })
        self.Train:LoadSystem("TimeAndDate","Relay","Switch",{bass = true })
        self.Train:LoadSystem("Enter","Relay","Switch",{bass = true })
    end

end

function TRAIN_SYSTEM:Inputs()
    return {"KeyInput","State"}
end
function TRAIN_SYSTEM:Outputs()
    return {"Course","Route","Destination"}
end

function TRAIN_SYSTEM:Trigger(name,value)

    if self.State == 1 then

        if name == "Destination" then --Destination button: Menu index 1
            
            if self.Menu == 0 then
            self.Menu = 1
            end

        end

            if name == "Number7" then --Number 7 in idle means Route button, Menu Index 3
                if self.Menu == 0 then
                    self.Menu = 3
                end
            end


        
        if name == "Number0" then --Number 0 in idle means Course selection, Menu index 2
            if self.Menu == 0 then
                self.Menu = 2
            end
        end

        --refactor for the correct input method, in train script use self.Train.IBIS.[TriggerName]
    
       if name == "Number0" then
            self.KeyInput = 0
        end
        if name == "Number1" then
            self.KeyInput = 1
        end
       if name == "Number2" then
           self.KeyInput = 2
        end
        if name == "Number3" then
            self.KeyInput = 3
        end
        if name == "Number4" then
            self.KeyInput = 4
       end
       if name == "Number5" then
           self.KeyInput = 5
       end
      if name == "Number6" then
          self.KeyInput = 6
      end
      if name == "Number8" then
          self.KeyInput = 8
        end
       if name == "Number9" then
          self.KeyInput = 9
        end
      if name == "Destination" then
        self.KeyInput = "Destination"
      end
       if name == "Delete" then
          self.KeyInput = "Delete"
      end

    end

end




function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end
    
    
 


end



if CLIENT then
    local function createFont(name,font,size)
        surface.CreateFont("Metrostroi_"..name, {
            font = font,
            size = size,
            weight = 500,
            blursize = false,
            antialias = true,
            underline = false,
            italic = false,
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false,
            extended = true,
            scanlines = false,
        })
end



    createFont("ASNP","Liquid Crystal Display",30,400)



function TRAIN_SYSTEM:ClientThink()
    if not self.Train:ShouldDrawPanel("IBISScreen") then return end
        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.ASNP,0,0,512, 128)
            render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end
        if self.DrawTimer and CurTime()-self.DrawTimer < 0.1 then return end
        self.DrawTimer = CurTime()
        render.PushRenderTarget(self.Train.ASNP,0,0,512, 128)
        --render.Clear(0, 0, 0, 0)
        cam.Start2D()
            self:ASNPScreen(self.Train)
        cam.End2D()
        render.PopRenderTarget()
        if self.DrawTimer and CurTime()-self.DrawTimer < 0.1 then return end
        self.DrawTimer = CurTime()
        render.PushRenderTarget(self.Train.ASNP,0,0,512, 128)
        --render.Clear(0, 0, 0, 0)
        cam.Start2D()
            self:ASNPScreen(self.Train)
        cam.End2D()
        render.PopRenderTarget()
    end
end

function TRAIN_SYSTEM:PrintText(x,y,text,inverse)
    if text == "II" then
        self:PrintText(x-0.2,y,"I",inverse)
        self:PrintText(x+0.2,y,"I",inverse)
        return
    end
    local str = {utf8.codepoint(text,1,-1)}
    for i=1,#str do
        local char = utf8.char(str[i])
        if inverse then
            draw.SimpleText(string.char(0x7f),"Metrostroi_ASNP",(x+i)*20.5+5,y*40+40,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText(char,"Metrostroi_ASNP",(x+i)*20.5+5,y*40+40,Color(140,190,0,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(char,"Metrostroi_ASNP",(x+i)*20.5+5,y*40+40,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

function TRAIN_SYSTEM:ASNPScreen(Train)
    local State = self.Train:GetNW2Int("CabActive",0)
    if State == 1 then
        surface.SetDrawColor(140,190,0,self.Warm and 130 or 255)
        self.Warm = true
    else
        surface.SetDrawColor(20,50,0,230)
        self.Warm = false
    end
    surface.DrawRect(0,0,512,128)
    if State == false then
        return
    end


    if State == -2 then
        self:PrintText(0,0,"IFIS ERROR")
        self:PrintText(0,1,"Map is missing dataset")
        return
    end

    local Menu = self.Menu

    if State == 1 then

        if Menu == 1 then
            self:PrintText(0,0,"Ziel:")
            return 
        end

        if Menu == 2 then
            self:PrintText(0,0,"Linie/Kurs:")
            return 
        end

        if Menu == 3 then
            self:PrintText(0,0,"Route:")
            return 
        end

        if Menu == 0 then
        self:PrintText(2,1,self.Destination)
        self:PrintText(4,1,self.Course)
        self:PrintText(8,1,self.Route)
        return 
        end
    end

    if self.Debug == 1 then
        self:PrintText(2,1,"This is a Test")
    end
    return
end

function TRAIN_SYSTEM:Think()


    
    local Train = self.Train

    Train:SetNW2Int("IBIS:State",self.State)
    Train:SetNW2Int("IBIS:Route",self.Route)
    Train:SetNW2Int("IBIS:Destination",self.Destination)
    Train:SetNW2Int("IBIS:Course",self.Course)
    Train:SetNW2Int("Menu",self.Menu)

    --Add together all variables to one string


    if self.Menu == 1 then

        if self.DestinationChar3 == nil and self.DestinationChar2 == nil and self.DestinationChar1 == nil then

            if self.DestinationChar3 == nil and self.DestinationChar2 == nil and self.DestinationChar1 == nil then
                self.DestinationChar3 = self.KeyInput
            end

            if not self.DestinationChar3 == nil and self.DestinationChar2 == nil and self.DestinationChar1 == nil then
                self.DestinationChar2 = self.DestinationChar3
                self.DestinationChar3 = self.KeyInput
            end
            if not self.DestinationChar3 == nil and not self.DestinationChar2 == nil and self.DestinationChar1 == nil then
               self.DestinationChar2 = self.DestinationChar3
                self.DestinationChar1 = self.DestinationChar2
                self.DestinationChar3 = self.KeyInput
            end

        elseif not self.DestinationChar3 == nil and not self.DestinationChar2 == nil and not self.DestinationChar1 == nil then
            
                self.DestinationChar3 = nil 
                self.DestinationChar2 = nil 
                self.DestinationChar1 = nil 

                if self.DestinationChar3 == nil and self.DestinationChar2 == nil and self.DestinationChar1 == nil then
                    self.DestinationChar3 = self.KeyInput
                end
    
                if not self.DestinationChar3 == nil and self.DestinationChar2 == nil and self.DestinationChar1 == nil then
                    self.DestinationChar2 = self.DestinationChar3
                    self.DestinationChar3 = self.KeyInput
                end
                if not self.DestinationChar3 == nil and not self.DestinationChar2 == nil and self.DestinationChar1 == nil then
                   self.DestinationChar2 = self.DestinationChar3
                    self.DestinationChar1 = self.DestinationChar2
                    self.DestinationChar3 = self.KeyInput
                end
            
        end
    end    

    if self.Menu == 3 then

        if  self.RouteChar2 == nil and self.RouteChar1 == nil then
            if self.RouteChar2 == nil then
                self.RouteChar2 = self.KeyInput
            end
            if not self.RouteChar2 == nil then
                self.RouteChar1 = self.DestinationChar2
                self.RouteChar2 = self.KeyInput
            end

        elseif not self.RouteChar2 == nil and not self.RouteChar1 == nil then

            self.RouteChar2 = nil 
            self.RouteChar1 = nil

            if self.RouteChar2 == nil then
                self.RouteChar2 = self.KeyInput
            end
            if not self.RouteChar2 == nil then
                self.RouteChar1 = self.DestinationChar2
                self.RouteChar2 = self.KeyInput
            end
        end
    end

    if self.Menu == 2 then
        if not self.CourseChar4 and not self.CourseChar3 and not self.CourseChar2 and not self.CourseChar1 then
            if self.CourseChar4 == nil then
                self.CourseChar4 = self.KeyInput
            end
            if self.CourseChar4 ~= nil then
                self.CourseChar3 = self.CourseChar4
                self.CourseChar4 = self.KeyInput
            end
            if self.CourseChar3 ~=nil then
                self.CourseChar2 = self.CourseChar3
                self.CourseChar3 = self.KeyInput
            end
            if self.CourseChar2 ~=nil then
                self.CourseChar1 = self.CourseChar2
                self.CourseChar2 = self.KeyInput
            end
            if self.CourseChar1 ~=nil then
                self.CourseChar1 = self.KeyInput
            end

        else

        if self.CourseChar4 ~= nil and self.CourseChar3 ~= nil and self.CourseChar2 ~=nil and self.CourseChar1 ~= nil then

            self.CourseChar4 = nil
            self.CourseChar3 = nil
            self.CourseChar2 = nil 
            self.CourseChar1 = nil

            if self.CourseChar4 == nil then
                self.CourseChar4 = self.KeyInput
            end
            if self.CourseChar4 ~= nil then
                self.CourseChar3 = self.CourseChar4
                self.CourseChar4 = self.KeyInput
            end
            if self.CourseChar3 ~= nil then
                self.CourseChar2 = self.CourseChar3
                self.CourseChar3 = self.KeyInput
            end
            if self.CourseChar2 ~=nil then
                self.CourseChar1 = self.CourseChar2
                self.CourseChar2 = self.KeyInput
            end
            if self.CourseChar1 ~=nil then
                self.CourseChar1 = self.KeyInput
            end
        end
    end


    if not self.RouteChar1 == nil and not self.RouteChar2 == nil then self.Route = self.Routechar1..self.RouteChar2 end
    if not self.CourseChar1 == nil and not self.CourseChar2 == nil and not self.CourseChar3 == nil and not self.CourseChar4 == nil then self.Course = self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4 end
    if not self.DestinationChar1 == nil and not self.DestinationChar2 == nil and not self.DestinationChar3 == nil then self.Destination = self.DestinationChar1..self.DestinationChar2..self.DestinationChar3 end



end
end

function TRAIN_SYSTEM:AnnQueue(msg)
    local Announcer = self.Train.Announcer
    if msg and type(msg) ~= "table" then
        Announcer:Queue{msg}
    else
        Announcer:Queue(msg)
    end
end

function TRAIN_SYSTEM:Play(dep,not_last)
    local message
    local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
    local stbl = tbl[self.Station]
    local last,lastst
    local path = self.Path and 2 or 1
    if tbl.Loop then
        last = self.LastStation
        lastst = not dep and self.LastStation > 0 and self.Station == last and tbl[last].arrlast
    else
        last = self.Path and self.FirstStation or self.LastStation
        lastst = not dep and self.Station == last and tbl[last].arrlast
    end
    if dep then
        message = stbl.dep[path]
    else
        if lastst then
            message = stbl.arrlast[path]
        else
            message = stbl.arr[path]
        end
    end
    self:AnnQueue{"click1","buzz_start"}
    if lastst and not stbl.ignorelast then self:AnnQueue(-1) end


    self:AnnQueue(message)
    local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line][self.Station]
    if self.LastStation > 0 and not dep and self.Station ~= last and tbl[last].not_last and (stbl.have_interchange or math.abs(last-self.Station) <= 3) then
        local ltbl = tbl[last]
        if stbl.not_last_c then
            local patt = stbl.not_last_c[path]
            self:AnnQueue(ltbl[patt] or ltbl.not_last)
        else
            self:AnnQueue(ltbl.not_last)
        end
    end
    self:AnnQueue{"buzz_end","click2"}
    self:UpdateBoards()
end

