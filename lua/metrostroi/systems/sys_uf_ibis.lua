Metrostroi.DefineSystem("IBIS")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
    self.Route = 0 --Route index number
    self.RouteChar1 = -1
    self.RouteChar2 = -1
    self.DisplayedRouteChar1 = 0
    self.DisplayedRouteChar2 = 0

    self.DestinationText = " "

    self.JustBooted = false
    self.PowerOn = 0
    self.IBISBootupComplete = 0
    self.Debug = 1
    self.BugCheck1 = false
    self.BugCheck2 = false
    self.BlinkText = false
    self.LastBlinkTime = 0

    self.KeyInputDone = false
    
    self.BootupComplete = false
    self.Course = 0 --Course index number, format is LineLineCourseCourse
    self.CourseChar1 = -1
    self.CourseChar2 = -1
    self.CourseChar3 = -1
    self.CourseChar4 = -1
    self.CourseChar5 = -1
    self.DisplayedCourseChar1 = 0
    self.DisplayedCourseChar2 = 0
    self.DisplayedCourseChar3 = 0
    self.DisplayedCourseChar4 = 0
    self.DisplayedCourseChar5 = 0


    self.Destination = 0 --Destination index number
    self.DestinationChar1 = -1
    self.DestinationChar2 = -1
    self.DestinationChar3 = -1
    self.DisplayedDestinationChar1 = 0
	self.DisplayedDestinationChar2 = 0
    self.DisplayedDestinationChar3 = 0

    self.TrainID = math.random(9999,1)

    self.KeyInput = nil

    self.TriggerNames = {
        	"Number1", --1
        	"Number2", --2
        	"Number3", --3
        	"Number4", --4
        	"Number5", --5
        	"Number6", --6
		    "Number7",
		    "Number8",
		    "Number9",
		    "Number0",
		    "Destination", --11
        	"Delete", --12
        	"Enter", --13
        	"SpecialAnnouncements", --14
        	"TimeAndDate" --15
    }
    self.Triggers = {}
    self.State = 0

    self.Menu = 0 -- which menu are we in
    self.Announce = false


    --if not self.Train:GetNW2Int("CabActive",0) == 1 then
        --[[self.Train:LoadSystem("Number1","Relay","Switch",{bass = true })
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
    --end]]

    

end

if TURBOSTROI then return end

function TRAIN_SYSTEM:Inputs()
    return {"KeyInput","Power"}
end
function TRAIN_SYSTEM:Outputs()
    return {"Course","Route","Destination","State"}
end

function TRAIN_SYSTEM:Trigger(name,value)

    if self.State > 0 then


        if name == "Number0" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInputDone = true
                self.KeyInput = "0"
                self.KeyInputDone = true
            end
        end
        if name == "Number1" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "1"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number2" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "2"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number3" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "3"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number4" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "4"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number5" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "5"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number6" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "6"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number7" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "7"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number8" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "8"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number9" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "9"
                
                self.KeyInputDone = true
            end
        end
        if name == "Number0" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "0"
                
                self.KeyInputDone = true
            end
        end
        if name == "Delete" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "Delete"
                
                self.KeyInputDone = true
            end
        end
        if name == "Enter" and value == 1 then
            if self.KeyInputDone == false then
                self.KeyInput = "Enter"
                
                self.KeyInputDone = true
            end
        end

        if name == "Destination" and value == 1 then
            
            if self.KeyInputDone == false then
                self.KeyInput = "Destination"
                
                self.KeyInputDone = true
            end

        end




        


        
    
        if name == "Number0" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Number1" and value == 0 then
            self.KeyInput = nil
        end
        if name == "Number2" and value == 0 then
           self.KeyInput = nil
           self.KeyInputDone = false
        end
        if name == "Number3" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Number4" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Number5" and value == 0 then
           self.KeyInput = nil
           self.KeyInputDone = false
        end
        if name == "Number6" and value == 0 then
          self.KeyInput = nil
          self.KeyInputDone = false
        end
        if name == "Number7" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Number8" and value == 0 then
          self.KeyInput = nil
          self.KeyInputDone = false
        end
        if name == "Number9" and value == 0 then
          self.KeyInput = nil
          self.KeyInputDone = false
        end
        if name == "Destination" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Delete" and value == 0 then
          self.KeyInput = nil
          self.KeyInputDone = false
        elseif name == "Enter" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end
        if name == "Delete" and value == 0 then
            self.KeyInput = nil
            self.KeyInputDone = false
        end

    end

end




function TRAIN_SYSTEM:TriggerInput(name,value)
	if self[name] then self[name] = value end
end

function TRAIN_SYSTEM:TriggerOutput(name,value)
	if self[name] then self[name] = value end
end
if SERVER then
function TRAIN_SYSTEM:SyncIBIS()

    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Announce",self.Announce)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"PowerOn",self.PowerOn)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"TrainID",self.TrainID)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Destination",self.Destination)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Course",self.Course)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Route",self.RouteNumber)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"State",self.State)
end
end

if CLIENT then
    surface.CreateFont("IBIS", { -- main text font
		font = "LCDDot TR Regular",
		size = 55,
		weight = 10,
		blursize = false,
		antialias = true, --can be disabled for pixel perfect font, but at low resolution the font is looks corrupted
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
	surface.CreateFont("IBIS_background", { -- background glow font
		font = "Liquid Crystal Display",
		size = 30,
		weight = 0,
		blursize = 3,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = true,
		outline = true,
		extended = true
	})
end



--createFont("IBIS","Liquid Crystal Display",30,200)



function TRAIN_SYSTEM:ClientThink()

        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.IBIS,0,0,512, 128)
            --render.Clear(0, 0, 0, 0)
            render.PopRenderTarget()
        end
        if self.DrawTimer and CurTime()-self.DrawTimer < 0.1 then return end
        self.DrawTimer = CurTime()
        render.PushRenderTarget(self.Train.IBIS,0,0,512, 128)
        --render.Clear(0, 0, 0, 0)
        cam.Start2D()
            self:IBISScreen(self.Train)
        cam.End2D()
        render.PopRenderTarget()
        if self.DrawTimer and CurTime()-self.DrawTimer < 0.2 then return end
        self.DrawTimer = CurTime()
        render.PushRenderTarget(self.Train.IBIS,0,0,512, 128)
        --render.Clear(0, 0, 0, 0)
        cam.Start2D()
            self:IBISScreen(self.Train)
        cam.End2D()
        render.PopRenderTarget()
end

function TRAIN_SYSTEM:PrintText(x,y,text,inverse)

    local str = {utf8.codepoint(text,1,-1)}
    for i=1,#str do
        local char = utf8.char(str[i])
        if inverse then
            draw.SimpleText(string.char(0x7f),"IBIS",(x+i)*20.5+5,y*40+40,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText(char,"IBIS",(x+i)*20.5+5,y*40+40,Color(140,190,0,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(char,"IBIS",(x+i)*32,y*15+20,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

function TRAIN_SYSTEM:IBISScreen(Train)
    
    local Menu = self.Train:GetNW2Int("IBIS:Menu")
    local State = self.Train:GetNW2Int("IBIS:State")
    local Route = self.Train:GetNW2String("IBIS:RouteChar1")..self.Train:GetNW2String("IBIS:RouteChar2")
    local Course = self.Train:GetNW2String("IBIS:CourseChar1")..self.Train:GetNW2String("IBIS:CourseChar2")..self.Train:GetNW2String("IBIS:CourseChar3")..self.Train:GetNW2String("IBIS:CourseChar4")
    local Destination = self.Train:GetNW2String("IBIS:DestinationChar1")..self.Train:GetNW2String("IBIS:DestinationChar2")..self.Train:GetNW2String("IBIS:DestinationChar3")
    local DestinationText = self.Train:GetNW2String("IBIS:DestinationText"," ")
    --print(Route)
    --print(Course)

    local PowerOn = self.Train:GetNW2Bool("IBISPowerOn",false)

    if PowerOn == true then
        surface.SetDrawColor(140,190,0,self.Warm and 130 or 255)
        surface.DrawRect(0,0,512,128)
        self.Warm = true

        if self.Train:GetNW2Bool("IBISBootupComplete",false) == true then
            --self.State = 2
        elseif self.Train:GetNW2Bool("IBISBootupComplete",false) == false then
            self:PrintText(0,0,"---------------")
            self:PrintText(0,4,"---------------")
        end

    end

    if PowerOn == false then 
        surface.SetDrawColor(37,94,0,230)
        surface.DrawRect(0,0,512,128)
        self.Warm = false
        
    end

    
    if State == 2 then

        if Menu == 4 then
            if self.CourseChar4 == nil then
                self:BlinkText(true, "Linie-Kurs :")
                self:PrintText(11.5,1.5,Course)
            elseif self.CourseChar4 != nil then
                self:PrintText(0,1.5,"Linie-Kurs :")
                self:PrintText(11.5,1.5,Course)
                
            end
            

            
            return
        end

        if Menu == 5 then
            if self.RouteChar1 == nil then
                self:BlinkText(true,"Route :")
                self:PrintText(13.5,1.5,Route)
                
            elseif self.RouteChar1 != nil then
                self:PrintText(13.5,1.5,Route)
                self:PrintText(0,1.5,"Route :")
                
            end
            return
        end
        
    end

    if State == -2 then
        surface.SetDrawColor(140,190,0,self.Warm and 130 or 255)
        self.Warm = true
        self:PrintText(0,0,"IFIS ERROR")
        self:PrintText(0,1,"Map is missing dataset")
        return
    end
    
    if State == 1 then

        if Menu == 1 then
            self:PrintText(0,1.5,"Linie-Kurs:")
            self:PrintText(11.5,1.5,Course)
            return 
        end

        if Menu == 2 then
            self:PrintText(0,1.5,"Route       :")
            self:PrintText(13.5,1.5,Route)
            return 
        end

        if Menu == 3 then
            self:PrintText(0,1,"Ziel      :")
            self:PrintText(11,1.5,Destination)
            return 
        end

        if Menu == 0 then
        self:PrintText(2,6,Destination)
        self:PrintText(5.6,6,Course)
        self:PrintText(10.5,6,Route)
        self:PrintText(0,0,DestinationText)
        --print(self.Train:GetNW2Int("IBIS:Route"))
        return 
        end
    end
    return
end

function TRAIN_SYSTEM:Think()

    --print(self.RouteChar1)
    --print(self.RouteChar2)
    --Index number abstractions. An unset value is stored as -1, but we don't want the display to print -1. Instead, print a string of nothing.
    if self.RouteChar1 < 0 then
        self.DisplayedRouteChar1 = " "
    else
        self.DisplayedRouteChar1 = tostring(self.RouteChar1) --Put it as string for later, if the number is greater than -1. Zero is a valid number.
    end

    if self.RouteChar2 < 0 then
        self.DisplayedRouteChar2 = " "
    else
        self.DisplayedRouteChar2 = tostring(self.RouteChar2)
    end

    if self.DestinationChar1 < 0 then
        self.DisplayedDestinationChar1 = " "
    else self.DisplayedDestinationChar1 = tostring(self.DestinationChar1)
    end
    if self.DestinationChar2 < 0 then
        self.DisplayedDestinationChar2 = " "
    else self.DisplayedDestinationChar2 = tostring(self.DestinationChar2)
    end
    if self.DestinationChar3 < 0 then
        self.DisplayedDestinationChar3 = " "
    else self.DisplayedDestinationChar3 = tostring(self.DestinationChar3)
    end

    if self.CourseChar1 < 0 then
        self.DisplayedCourseChar1 = " "
    else self.DisplayedCourseChar1 = tostring(self.CourseChar1)
    end

    if self.CourseChar2 < 0 then
        self.DisplayedCourseChar2 = " "
    else self.DisplayedCourseChar2 = tostring(self.CourseChar2)
    end

    if self.CourseChar3 < 0 then
        self.DisplayedCourseChar3 = " "
    else self.DisplayedCourseChar3 = tostring(self.CourseChar3)
    end

    if self.CourseChar4 < 0 then
        self.DisplayedCourseChar4 = " "
    else self.DisplayedCourseChar4 = tostring(self.CourseChar4)
    end


    if self.KeyInput ~= nil then
        print("Key Input"..self.KeyInput)
    end
    --print("Course Number:"..self.Train:GetNW2String("IBIS:CourseChar1",nil)..self.Train:GetNW2String("IBIS:CourseChar2")..self.Train:GetNW2String("IBIS:CourseChar3")..self.Train:GetNW2String("IBIS:CourseChar4")..self.Train:GetNW2String("IBIS:CourseChar5"))
    local Train = self.Train
    
    --print("IBIS loaded")
    if self.Train.BatteryOn == true then
        self.PowerOn = 1
        self.Train:SetNW2Bool("IBISPowerOn",true)
        --print("IBIS powered")
    elseif self.Train.BatteryOn == false then
        self.PowerOn = 0
        self.Train:SetNW2Bool("IBISPowerOn",false)
        self.State = 0
        self.Menu = 0
        self.Train:SetNW2Bool("IBISBootupComplete",false)
    end
    
    if self.Train:GetNW2Bool("IBISBootupComplete",false) == true then
        if self.JustBooted == false then
            self.State = 2
            self.Menu = 4
            self.JustBooted = true
        end
    end

    if self.State == 2 and self.Menu == 4 then
        if self.KeyInput == "Enter" then
            self.Menu = 5
        end
    end

    if self.State == 2 and self.Menu == 5 and self.Route ~= 0 then
        if self.KeyInput == "Enter" then
            self.State = 1
            self.Menu  = 0
        end
    end

    if self.State == 1 and self.Menu == 0 then
        if self.KeyInput == "7" then
            self.Menu = 2
        elseif self.KeyInput == "0" then
            self.Menu = 1
        elseif self.KeyInput == "Destination" then
            self.Menu = 3
        end
    elseif self.State == 1 and self.Menu == 1 then
        if self.KeyInput == "Enter" then
            self.Menu = 0
        end
    elseif self.State == 1 and self.Menu == 2 then
        if self.KeyInput == "Enter" then
            self.Menu = 0
        end
    elseif self.State == 1 and self.Menu == 3 then
        if self.KeyInput == "Enter" then
            self.Menu = 0
        end
    end

    

    --print(self.Route)

    --math.Clamp(self.Route,0,99)
    --math.Clamp(tonumber(self.Course),0,99999)
    --math.Clamp(self.Destination,0,999)
    Train:SetNW2Int("IBIS:State",self.State)
    Train:SetNW2Int("IBIS:Route",self.Route)
    Train:SetNW2Int("IBIS:Destination",self.Destination)
    Train:SetNW2Int("IBIS:Course",self.Course)
    Train:SetNW2Int("IBIS:MenuState",self.Menu)
    Train:SetNW2Int("IBIS:Menu",self.Menu)
    Train:SetNW2Int("IBIS:PowerOn",self.PowerOn)
    Train:SetNW2Int("IBIS:Booted",self.IBISBootupComplete)
    Train:SetNW2String("IBIS:KeyInput",self.KeyInput)
    Train:SetNW2String("IBIS:CourseChar4",self.DisplayedCourseChar4)
    Train:SetNW2String("IBIS:CourseChar3",self.DisplayedCourseChar3)
    Train:SetNW2String("IBIS:CourseChar2",self.DisplayedCourseChar2)
    Train:SetNW2String("IBIS:CourseChar1",self.DisplayedCourseChar1)
    Train:SetNW2String("IBIS:RouteChar1",self.DisplayedRouteChar1)
    Train:SetNW2String("IBIS:RouteChar2",self.DisplayedRouteChar2)
    Train:SetNW2String("IBIS:DestinationChar1",self.DisplayedDestinationChar1)
    Train:SetNW2String("IBIS:DestinationChar2",self.DisplayedDestinationChar2)
    Train:SetNW2String("IBIS:DestinationChar3",self.DisplayedDestinationChar3)

    self:InputProcessor(self.KeyInput)
    if self.KeyInput ~= nil then
        print(self.KeyInput)
    end

    --SetGlobal2Int("TrainID"..self.TrainID,self.Course..self.Route..self.TrainID)
    if self.Train.Duewag_U2.LeadingCab == 1 then
        self:SyncIBIS()
    else
    end
end 

if CLIENT then
    function TRAIN_SYSTEM:ClientInitialize()

        self.LastBlinkTime = 0
        self.BlinkingText = false

        self.DefectStrings = { 
            "IFIS FEHLER",
            "FUNK DEFEKT"
        }
    end
	function TRAIN_SYSTEM:BlinkText(enable,Text)
		if not enable then
			self.BlinkingText = false
		elseif CurTime() - self.LastBlinkTime > 1.5 then
			self:PrintText(0,1.5,Text)
            if CurTime() - self.LastBlinkTime > 3 then
			    self.LastBlinkTime = CurTime()
            end
		end
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
end

if SERVER then

    function TRAIN_SYSTEM:InputProcessor(Input)
        if self.Menu == 4 or self.Menu == 1 then
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate"  then
                if self.CourseChar4 == -1 and self.CourseChar3 == -1 and self.CourseChar2 == -1 and self.CourseChar1 == -1 then

                if tonumber(self.KeyInput) ~= nil then
                    self.CourseChar4 = tonumber(self.KeyInput)
                end    
    
    
    
                elseif self.CourseChar4 ~= -1 and self.CourseChar3 == -1 and self.CourseChar2 == -1 and self.CourseChar1 == -1 then
    
                        
                    self.CourseChar3 = self.CourseChar4
                    if tonumber(self.KeyInput) ~= nil then
                        self.CourseChar4 = tonumber(self.KeyInput)
                    end
                    
                    
                elseif self.CourseChar4 ~= -1 and self.CourseChar3 ~= -1 and self.CourseChar2 == -1 and self.CourseChar1 == -1 then
                   
                    self.CourseChar2 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar4
                    if tonumber(self.KeyInput) ~= nil then
                        self.CourseChar5 = tonumber(self.KeyInput)
                    end
                elseif self.CourseChar4 ~= -1 and self.CourseChar3 ~= -1 and self.CourseChar2 ~= -1 and self.CourseChar1 == -1 then
                    
                    self.CourseChar1 = self.CourseChar2
                    self.CourseChar2 = self.CourseChar3						
                    self.CourseChar3 = self.CourseChar4
                    if tonumber(self.KeyInput) ~= nil then
                        self.CourseChar4 = tonumber(self.KeyInput)
                    end
                elseif self.CourseChar4 > -1 and self.CourseChar3 > -1 and self.CourseChar2 > -1 and self.CourseChar1 > -1 then
                    self.CourseChar1 = self.CourseChar2
                    self.CourseChar2 = self.CourseChar3						
                    self.CourseChar3 = self.CourseChar4
                    if tonumber(self.KeyInput) ~= nil then
                        self.CourseChar4 = tonumber(self.KeyInput)
                    end
                end
                self.Course = self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4..self.CourseChar5

               
            elseif Input ~= nil and Input == "Delete" then
                
            end
        elseif self.Menu == 5 or self.Menu == 2 then
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" then
                if self.RouteChar2 == -1 and self.RouteChar1 == -1 then
                    self.RouteChar2 = tonumber(self.KeyInput)
    
    
                elseif self.RouteChar2 ~= -1 and self.RouteChar1 == -1 then
                    
                    self.RouteChar1 = self.RouteChar2					
                
                    if tonumber(self.KeyInput) ~= nil then
                        self.RouteChar2 = tonumber(self.KeyInput)
                    end
                elseif self.RouteChar2 ~= -1 and self.RouteChar1 ~= -1 then
                    self.RouteChar1 = self.RouteChar2					
                
                    if tonumber(self.KeyInput) ~= nil then
                        self.RouteChar2 = tonumber(self.KeyInput)
                    end
                end
                if self.RouteChar1 ~=nil and self.RouteChar2 ~= nil then
                    self.RouteChar1 = self.RouteChar2
                    if tonumber(self.KeyInput) ~= nil then
                        self.RouteChar2 = tonumber(self.KeyInput)
                    end
                end
                self.Route = self.RouteChar1..self.RouteChar2
            end
        elseif self.Menu == 3 then
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" then
                if self.DestinationChar3 == -1 and self.DestinationChar2 == -1 and self.DestinationChar1 == -1 then

                    if tonumber(self.KeyInput) ~=nil then
                        self.DestinationChar3 = tonumber(self.KeyInput)
                    end
    
                elseif self.DestinationChar3 ~= -1 and self.DestinationChar2 == -1 and self.DestinationChar1 == -1 then

                    self.DestinationChar2 = self.DestinationChar3					
                
                    if tonumber(self.KeyInput) ~= nil then
                        self.DestinationChar3 = tonumber(self.KeyInput)
                    end
                elseif self.DestinationChar3 ~= -1 and self.DestinationChar2 ~= -1 and self.DestinationChar1 == -1 then
                    
                    self.DestinationChar1 = self.DestinationChar2					
                
                    if tonumber(self.KeyInput) ~= nil then
                        self.DestinationChar3 = tonumber(self.KeyInput)
                    end
                elseif self.DestinationChar3 ~= -1 and self.DestinationChar2 ~= -1 and self.DestinationChar1 ~= -1 then
                    self.DestinationChar1 = self.DestinationChar2					
                    self.DestinationChar2 = self.DestinationChar3
                    if tonumber(self.KeyInput) ~= nil then
                        self.DestinationChar3 = tonumber(self.KeyInput)
                    end
                end
                self.Destination = self.DestinationChar1..self.DestinationChar2..self.DestinationChar3
            end
        end    
    end
end