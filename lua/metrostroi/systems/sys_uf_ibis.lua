Metrostroi.DefineSystem("IBIS")
TRAIN_SYSTEM.DontAccelerateSimulation = false

function TRAIN_SYSTEM:Initialize()
    

    
    if self.Train.WagNum then self.SerialNum = self.Train.WagNum..math.random(1000,2000) end
    self.Route = 0 --Route index number
    self.RouteChar1 = " "
    self.RouteChar2 = " "
    self.DisplayedRouteChar1 = 0
    self.DisplayedRouteChar2 = 0
    
    self.DestinationText = ""
    self.Destination = ""
    self.FirstStation = 0
    self.FirstStationString = ""
    self.CurrentStatonString = ""
    self.CurrentStation = 0
    self.NextStationString = ""
    self.NextStation = 0
    
    self.LineTable = UF.IBISLines[1]

    self.LineLookupComplete = false
    self.DestinationLookupComplete = false
    self.RouteLookupComplete = false
    
    self.RBLRegisterFailed = false
    self.RBLRegistered = false
    self.RBLSignedOff = true
    
    self.RouteTable = UF.IBISRoutes[1]
    
    self.DestinationTable = UF.IBISDestinations[1]
    self.ServiceAnnouncements = UF.SpecialAnnouncementsIBIS[1]
    
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
    self.Course = "0" --Course index number, format is LineLineCourseCourse
    self.CourseChar1 = " "
    self.CourseChar2 = " "
    self.CourseChar3 = " "
    self.CourseChar4 = " "
    self.CourseChar5 = " "
    self.DisplayedCourseChar1 = 0
    self.DisplayedCourseChar2 = 0
    self.DisplayedCourseChar3 = 0
    self.DisplayedCourseChar4 = 0
    self.DisplayedCourseChar5 = 0
    
    self.IndexValid = false

    self.PhonedHome = false
    
    self.DefectChance = math.random(0,100)
    self.LastRoll = CurTime()
    
    self.Destination = 0 --Destination index number
    self.DestinationChar1 = " "
    self.DestinationChar2 = " "
    self.DestinationChar3 = " "
    self.DisplayedDestinationChar1 = 0
    self.DisplayedDestinationChar2 = 0
    self.DisplayedDestinationChar3 = 0
    
    self.AnnouncementChar1 = 0
    self.AnnouncementChar2 = 0
    self.SpecialAnnouncement = 0
    
    self.CurrentStationInternal = 0
    
    self.TrainID = math.random(9999,1)
    
    self.KeyInput = nil
    
    self.KeyRegistered = false
    
    self.ErrorMoment = 0
    
    self.ErrorAcknowledged = false
    
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
    
    
    
end

if TURBOSTROI then return end



function TRAIN_SYSTEM:Inputs()
    return {"KeyInput","Power"}
end
function TRAIN_SYSTEM:Outputs()
    return {"Course","Route","Destination","State"}
end

function TRAIN_SYSTEM:Trigger(name,time)
    
    if self.State > 0 then
        
        
        if name == "Number0"  then
            if self.KeyRegistered == false then
                self.KeyInput = "0"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
        elseif name == "Number1"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "1"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number2"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "2"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number3"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "3"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
            
        elseif name == "Number4"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "4"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number5"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "5"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number6"  then
            if self.KeyRegistered == false then
                self.KeyInput = "6"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number7"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "7"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number8"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "8"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number9"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "9"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Number0"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "0"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Delete"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "Delete"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Enter"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "Enter"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == "Destination"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "Destination"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
        elseif name == "SpecialAnnouncement"  then
            
            if self.KeyRegistered == false then
                self.KeyInput = "SpecialAnnouncements"
                self.KeyRegistered = true
            else
                self.KeyInput = nil
            end
            
        elseif name == nil then
            self.KeyInput = nil
            self.KeyRegistered = false
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
    --local DestinationText = self.Train:GetNW2String("IBIS:DestinationText"," ")
    local CurrentStation = self.Train:GetNW2String("CurrentStation",0)
    local SpecialAnnouncement = self.Train:GetNW2String("IBIS:SpecialAnnouncement"," ")
    ----print(Route)
    ----print(Course)
    
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
            if self.CourseChar4 == " " then
                self:BlinkText(true, "Linie-Kurs:")
                self:PrintText(11.5,1.5,Course)
            elseif self.CourseChar4 ~= " " then
                self:PrintText(0,1.5,"Linie-Kurs:")
                self:PrintText(11.5,1.5,Course)
                
            end
            
            
            
            return
        end
        
        if Menu == 5 then
            if self.RouteChar1 == " " then
                self:BlinkText(true,"Route :")
                self:PrintText(13.5,1.5,Route)
                
            elseif self.RouteChar1 ~= " " then
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
        
        if Menu == 6 then
            self:PrintText(0,1.5,"Ansage      :")
            self:PrintText(13.5,1.5,SpecialAnnouncement)
            return
        end
        
        if Menu == 0 then
            self:PrintText(1.5,6,Destination)
            self:PrintText(5.6,6,Course)
            self:PrintText(10.5,6,Route)
            self:PrintText(0,1,CurrentStation)
            ----print(self.Train:GetNW2Int("IBIS:Route"))
            return 
        end
    end
    if State == 3 then
        
        if Menu == 1 then
            self:BlinkText(true,"Ung. Linie")
            
            return 
        end
        
        if Menu == 2 then
            self:BlinkText(true,"Ung. Route")
            
            return 
        end
        
        if Menu == 3 then
            self:BlinkText(true,"Ung. Ziel")
            
            return 
        end
        if Menu == 4 then
            self:BlinkText(true,"Ung. Linie")
            
            return
        end
        if Menu == 5 then
            self:BlinkText(true,"Ung. Route")
            
            return  
        end
        if Menu == 6 then
            self:PrintText(0,1,"Ung. Ansage")
            return
        end
    end
    if State == 4 then
        self:BlinkText(true,self.DefectString[self.Train:GetNW2Int("Defect",1)])
    end
    if State == 5 and Menu == 4 or State == 5 and Menu == 1 then
        self:BlinkText(true,"Kurs besetzt")
    end
    
    return
end

function TRAIN_SYSTEM:Think()
    
    if self.Menu > 0 then
        self:ReadDataset()
    end
    
    if self.Menu == 0 and self.State > 0 then
        self.LineLookupComplete = false
    end

    
    
    
    --Index number abstractions. An unset value is stored as -1, but we don't want the display to print -1. Instead, print a string of nothing.
 

    self.DisplayedRouteChar1 = self.RouteChar1
    self.DisplayedRouteChar2 = self.RouteChar2

    self.DisplayedDestinationChar1 = self.DestinationChar1
    self.DisplayedDestinationChar2 = self.DestinationChar2
    self.DisplayedDestinationChar3 = self.DestinationChar3

    self.DisplayedCourseChar1 = self.CourseChar1
    self.DisplayedCourseChar2 = self.CourseChar2
    self.DisplayedCourseChar3 = self.CourseChar3
    self.DisplayedCourseChar4 = self.CourseChar4

    
    
    if self.KeyInput ~= nil then
        --print("Key Input"..self.KeyInput)
    end
    ----print("Course Number:"..self.Train:GetNW2String("IBIS:CourseChar1",nil)..self.Train:GetNW2String("IBIS:CourseChar2")..self.Train:GetNW2String("IBIS:CourseChar3")..self.Train:GetNW2String("IBIS:CourseChar4")..self.Train:GetNW2String("IBIS:CourseChar5"))
    local Train = self.Train
    
    ----print("IBIS loaded")
    if self.Train.BatteryOn == true then
        self.PowerOn = 1
        self.Train:SetNW2Bool("IBISPowerOn",true)
        ----print("IBIS powered")
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
        if self.KeyInput == "Enter" and self.IndexValid == true and self.RBLRegistered == true then
            self.Menu = 5
            print("Got past RBL and index lookup")
        elseif self.KeyInput == "Enter" and self.IndexValid == false then
            self.Menu = 4
            self.State = 3
            --print("Index Number invalid")
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
        elseif self.KeyInput == "Enter" and self.RBLRegisterFailed == true and self.IndexValid == true then
            self.State = 5
            self.Menu = 4
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
        elseif self.KeyInput == "Enter" and self.RBLRegistered == false and self.RBLSignedOff == true then
            print("IBIS logged off RBL")
            self.CourseChar1 = 0
            self.CourseChar2 = 0
            self.CourseChar3 = 0
            self.CourseChar4 = 0
            self.RouteChar1 = 0
            self.RouteChar2 = 0
            self.DestinationChar1 = 0
            self.DestinationChar2 = 0
            self.DestinationChar3 = 0
            self.State = 1
            self.Menu = 0
        end
    end
    
    if self.State == 5 and self.Menu == 4 then
        self.Train:SetNW2Bool("IBISError",false)
        if CurTime() - self.ErrorMoment > 2 then
            if self.KeyInput == "Enter" then
                self.State = 2
                self.Menu = 4
            end
        end
    end
    
    if self.State == 2 and self.Menu == 5 and self.Route ~= 0 then
        if self.KeyInput == "Enter" and self.IndexValid == true then
            self.State = 1
            self.Menu  = 0
        elseif self.KeyInput == "Enter" and self.IndexValid == false then
            self.Menu = 5
            self.State = 3
            --print("Index Number invalid")
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
        end
        
        
    end
    
    if self.State == 3 then --IBIS ran into a missing index number of any sort, bumb the current state to 3
        self.LineLookupComplete = false
        if CurTime() - self.ErrorMoment > 5 then
            if self.KeyInput == "Enter" then
                self.State = 2
                self.Train:SetNW2Bool("IBISError",false)
                self.RBLRegisterFailed = false
                self.PhonedHome = false
            end
            
        end
    end
    
    if self.State == 4 then --We're in the defect state
        
        if self.KeyInput == "Enter" then --just confirm. Some IBIS devices just thought stuff was broken while it wasn't.
            self.State = 1
        end
    end
    
    if self.State == 1 and self.Menu == 0 then
        self.SpecialAnnouncement = " "
        self.AnnouncementChar1 = " "
        self.AnnouncementChar2 = " "
        self.Train:SetNW2String("ServiceAnnouncement","")
        self.LineLookupComplete = false
        --self.PhonedHome = false
        if self.KeyInput == "7" then
            self.Menu = 2
        elseif self.KeyInput == "0" then
            self.Menu = 1
        elseif self.KeyInput == "Destination" then
            self.Menu = 3
        elseif self.KeyInput == "3" then
            local indexlength = #self.RouteTable[self.CourseChar1..self.CourseChar2][self.RouteChar1..self.RouteChar2]
            if indexlength > self.CurrentStationInternal then
                self.CurrentStationInternal = self.CurrentStationInternal + 1
                
                self.CurrentStation = self.RouteTable[self.CourseChar1..self.CourseChar2][self.RouteChar1..self.RouteChar2][self.CurrentStationInternal]
            end
            --print indexlength
        elseif self.KeyInput == "6" then
            if self.CurrentStationInternal > 1 then
                self.CurrentStationInternal = self.CurrentStationInternal - 1
                
                self.CurrentStation = self.RouteTable[self.CourseChar1..self.CourseChar2][self.RouteChar1..self.RouteChar2][self.CurrentStationInternal]
            end
        elseif self.KeyInput == "SpecialAnnouncements" then
            self.Menu = 6
        end
    elseif self.State == 1 and self.Menu == 1 then
        self.RBLSignedOff = false

        if self.KeyInput == "Enter" and self.IndexValid == true and self.RBLRegisterFailed == false then
            self.Menu = 0
            self.RBLSignedOff = false
            self.LineLookupComplete = false
            self.DestinationChar1 = " "
            self.DestinationChar2 = " "
            self.DestinationChar3 = " "
            self.RouteChar1 = " "
            self.RouteChar2 = " "
            self.CurrentStation = 0
            self.CurrentStationInternal = 0
            self.PhonedHome = false
        elseif self.KeyInput == "Enter" and self.IndexValid == false then
            self.Menu = 4
            self.State = 3
            --print("Index Number invalid")
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
            self.LineLookupComplete = false
        elseif self.KeyInput == "Enter" and self.RBLRegisterFailed == true and self.IndexValid == true then
            self.State = 5
            self.Menu = 4
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
            self.LineLookupComplete = false
        elseif self.KeyInput == "Enter" and self.RBLRegistered == false and self.RBLSignedOff == true then
            self.CourseChar1 = "0"
            self.CourseChar2 = "0"
            self.CourseChar3 = "0"
            self.CourseChar4 = "0"
            self.RouteChar1 = "0"
            self.RouteChar2 = "0"
            self.DestinationChar1 = "0"
            self.DestinationChar2 = "0"
            self.DestinationChar3 = "0"
            self.State = 1
            self.Menu = 0
            self.CurrentStation = 0
            self.CurrentStationInternal = 0
            self.LineLookupComplete = false
            self.RBLSignedOff = false
        end
    elseif self.State == 1 and self.Menu == 2 then
        if self.KeyInput == "Enter" and self.IndexValid == true then
            self.State = 1
            self.Menu  = 0
        elseif self.KeyInput == "Enter" and self.IndexValid == false then
            self.Menu = 5
            self.State = 3
            --print("Index Number invalid")
            self.Train:SetNW2Bool("IBISError",true)
            self.ErrorMoment = CurTime()
        end
    elseif self.State == 1 and self.Menu == 3 then
        if self.KeyInput == "Enter" then
            self.Menu = 0
        end
    elseif self.State == 1 and self.Menu == 6 then
        if self.KeyInput == "Enter" then
            if self.ServiceAnnouncement ~= "00" and self.Menu == 6 and self.IndexValid == true then
                self.Train:SetNW2String("ServiceAnnouncement",self.ServiceAnnouncements[self.ServiceAnnouncement])
                self.Menu = 0
            elseif self.ServiceAnnouncement ~= "00" then
                self.Menu = 0
            else
                self.State = 3
                self.Train:SetNW2Bool("IBISError",true)
                self.ErrorMoment = CurTime()
            end
        end
    end
    --print(self.State, self.Menu)
    if self.State == 0 then
        self.LineLookupComplete = false
        self.BootupComplete = false
        self.Course = 0 --Course index number, format is LineLineCourseCourse
        self.CourseChar1 = " "
        self.CourseChar2 = " "
        self.CourseChar3 = " "
        self.CourseChar4 = " "
        self.CourseChar5 = " "
        self.DisplayedCourseChar1 = 0
        self.DisplayedCourseChar2 = 0
        self.DisplayedCourseChar3 = 0
        self.DisplayedCourseChar4 = 0
        self.DisplayedCourseChar5 = 0
        
        self.Route = 0 --Route index number
        self.RouteChar1 = " "
        self.RouteChar2 = " "
        self.DisplayedRouteChar1 = 0
        self.DisplayedRouteChar2 = 0
        
        self.DestinationText = ""
        self.Destination = " "
        self.FirstStation = 0
        self.FirstStationString = ""
        self.CurrentStatonString = ""
        self.CurrentStation = 0
        self.NextStationString = ""
        self.NextStation = 0
        self.JustBooted = false
        self.PowerOn = 0
        self.Destination = 0 --Destination index number
        self.DestinationChar1 = " "
        self.DestinationChar2 = " "
        self.DestinationChar3 = " "
        self.DisplayedDestinationChar1 = 0
        self.DisplayedDestinationChar2 = 0
        self.DisplayedDestinationChar3 = 0
        
        self.AnnouncementChar1 = 0
        self.AnnouncementChar2 = 0
        self.SpecialAnnouncement = 0
        
        self.CurrentStationInternal = 0
    end
    
    
    
    ----print(self.Route)
    
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
    Train:SetNW2String("IBIS:SpecialAnnouncement",self.ServiceAnnouncement)
    
    --if self.KeyInput ~=nil then
        self:InputProcessor(self.KeyInput)
    --end

    self.Course = self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4
    --print(self.Course)
    if self.KeyInput ~= nil then
        --print(self.KeyInput)
    end
    
    --SetGlobal2Int("TrainID"..self.TrainID,self.Course..self.Route..self.TrainID)
    if self.Train.Duewag_U2.LeadingCab == 1 then
        self:SyncIBIS()
    else
    end
    
    if self.CurrentStation ~= -1 and self.CurrentStation ~= nil and self.CurrentStation ~= 0 then
        self.Train:SetNW2String("CurrentStation",self.DestinationTable[self.CurrentStation])
    elseif self.CurrentStation == 0 then
        self.Train:SetNW2String("CurrentStation"," ")
    end
    
    --print(self.CurrentStationInternal)
    --print(self.ServiceAnnouncements[1])
    --print(self.CurrentStation)
    --print(self.RBLSignedOff, "rbl signed off")
    --print(self.LineLookupComplete, "line lookup complete")
    --print(self.Course)
    if self.RouteChar1..self.RouteChar2 == "00" and self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4 == "0000" then --forget the current station if we're not on line anymore
        self.CurrentStation = 0
    end
end

function TRAIN_SYSTEM:RBLPhoneHome()
    if UF.RegisterTrain(self.Course,self.Train) == true and self.PhonedHome == false then
        self.PhonedHome = true
    end
    if self.PhonedHome == true then
        return true
    else
        return false
    end
end

function TRAIN_SYSTEM:ReadDataset()
    ----print(tonumber(self.CourseChar1..self.CourseChar2,10))
    ----print(self.LineTable[1])
    ----print(tonumber(string.sub(self.Course, 1, 2)))
    --print(self.LineTable["01"])
    if self.Menu == 1 and self.State == 1 or self.Menu == 4 and self.State < 3 then
        if self.CourseChar1 ~= " " and self.CourseChar2 ~= " " and self.CourseChar3 ~= " " and self.CourseChar4 ~= " " then --reference the Line number with the provided dataset, self.Course contains the line number as part of the first two digits of the variable
            local line = self.CourseChar1..self.CourseChar2
            if self.LineTable[line] ~=nil then
                self.IndexValid = true
                --print("Line Lookup succeeded", self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4)
                --print(self:RBLPhoneHome())
                if UF.RegisterTrain(self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4,self.Train) and self.RBLRegistered == false then
                    
                    self.RBLRegistered = true
                    self.RBLSignedOff = false
                    print("IBIS logged onto RBL")
                end
                if self.RBLRegistered == true then
                    
                    self.RBLRegisterFailed = false
                    self.RBLSignedOff = false
                    print("IBIS logged onto RBL", self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4)
                end
                if UF.RegisterTrain(self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4,self.Train) == false then
                    
                    self.RBLRegisterFailed = true
                    self.RBLRegistered = false
                    
                end
            elseif UF.RegisterTrain(self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4,self.Train) == "logoff" and self.RBLRegistered == true and self.KeyInput == "Enter" then
                self.IndexValid = true
                self.RBLSignedOff = true
                self.RBLRegistered = false
                self.RBLRegisterFailed = false
                self.LineLookupComplete = true
                print("RegisterTrain logged off")
                self.RouteChar1 = "0"
                self.RouteChar2 = "0"
            elseif self.LineTable[line] == nil and self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4 ~= "0000" then
                if self.KeyInput == "Enter" then
                    self.IndexValid = false
                    print("Index invalid")
                    print(self.CourseChar1..self.CourseChar2..self.CourseChar3..self.CourseChar4)
                end
            end
            
        end
        self.LineLookupComplete = true
    elseif self.Menu == 2 and self.State < 3 or self.Menu == 5 and self.State < 3 then
        if self.RouteChar1 ~= " " and self.RouteChar2 ~= " " then
            local line = self.CourseChar1..self.CourseChar2
            if self.RouteTable[line] then
                if self.RouteTable[line][self.RouteChar1..self.RouteChar2] then
                    local destchars = self.RouteTable[line][self.RouteChar1..self.RouteChar2][#self.RouteTable[line][self.RouteChar1..self.RouteChar2]]
                    self.DestinationChar1 = string.sub(destchars,1,1)
                    self.DestinationChar2 = string.sub(destchars,2,2)
                    self.DestinationChar3 = string.sub(destchars,3,3)
                    self.FirstStation = self.RouteTable[line][self.RouteChar1..self.RouteChar2][1]
                    self.CurrentStation = self.FirstStation
                    self.CurrentStationInternal = 1
                    self.NextStation = self.RouteTable
                    --print(self.Destination.."Destination index")
                    self.IndexValid = true      
                else
                    --self.State = 3
                    self.Route = 0
                    self.IndexValid = false
                end
            elseif self.RouteChar1..self.RouteChar2 == "00" then
                self.IndexValid = true
                self.Route = 0
                self.CurrentStation = 0
                self.CurrentStationInternal = 0
            end
        end
    elseif self.Menu == 1 and self.State < 3 or self.Menu == 4 and self.State < 3 then
        if self.RouteChar1..self.RouteChar2 == "00" then
                self.IndexValid = true
                self.Route = 0
                self.CurrentStation = 0
                self.CurrentStationInternal = 0
        end
    elseif self.Menu == 3 and self.State < 3 then
        
        if self.Destination ~= "   " then --reference the destination index number with the dataset
            
            if self.DestinationTable[self.Destination] then
                self.Destination = self.Destination
                self.IndexValid = true
            elseif self.DestinationChar1..self.DestinationChar2..self.DestinationChar3 == "000" then
                self.IndexValid = true
            else
                self.IndexValid = false
            end
        end
    elseif self.Menu == 6 and self.State < 3 then
        
        if self.ServiceAnnouncements[self.ServiceAnnouncement] then
            self.ServiceAnnouncement = self.ServiceAnnouncement
            self.IndexValid = true
        else
            
            self.IndexValid = false
        end
    end
    
end

if CLIENT then
    function TRAIN_SYSTEM:ClientInitialize()
        self.LastBlinkTime = 0
        self.BlinkingText = false
        self.DefectStrings = { 
            [1] = "IFIS FEHLER",
            [2] = "FUNK DEFEKT",
            [3] = "ENTWERTER 1 DEFEKT",
            [4] = "WEICHENST DEFEKT"
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
        
        if self.State == 1 and self.Menu == 4 or self.Menu == 1 and self.State == 1 or self.State == 2 and self.Menu == 4 then
            
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" then
                if self.CourseChar4 == " " and self.CourseChar3 == " " and self.CourseChar2 == " " and self.CourseChar1 == " " then
                    
                    if self.KeyInput ~= nil then
                        self.CourseChar4 = self.KeyInput
                    end    
                    
                    
                    
                elseif self.CourseChar4 ~= " " and self.CourseChar3 == " " and self.CourseChar2 == " " and self.CourseChar1 == " " then
                    
                    
                    self.CourseChar3 = self.CourseChar4
                    if self.KeyInput ~= nil then
                        self.CourseChar4 = self.KeyInput
                    end
                    
                    
                elseif self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 == " " and self.CourseChar1 == " " then
                    
                    self.CourseChar2 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar4
                    if self.KeyInput ~= nil then
                        self.CourseChar4 = self.KeyInput
                    end
                elseif self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 ~= " " and self.CourseChar1 == " " then
                    
                    self.CourseChar1 = self.CourseChar2
                    self.CourseChar2 = self.CourseChar3						
                    self.CourseChar3 = self.CourseChar4
                    if self.KeyInput ~= nil then
                        self.CourseChar4 = self.KeyInput
                    else
                        self.CourseChar4 = self.CourseChar4
                    end
                elseif self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 ~= " " and self.CourseChar1 ~= " " then
                    
                    self.CourseChar1 = self.CourseChar2
                    self.CourseChar2 = self.CourseChar3						
                    self.CourseChar3 = self.CourseChar4
                    if self.KeyInput ~= nil then
                        self.CourseChar4 = self.KeyInput
                    else
                        self.CourseChar4 = self.CourseChar4
                    end
                end
                
                
                
            elseif Input ~= nil and Input == "Delete" then
                if self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 ~= " " and self.CourseChar1 ~= " " then
                    
                    self.CourseChar4 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar2
                    self.CourseChar1 = " "
                elseif self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 ~= " " and self.CourseChar1 == " " then
                    self.CourseChar4 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar2
                    self.CourseChar2 = " "
                elseif self.CourseChar4 ~= " " and self.CourseChar3 ~= " " and self.CourseChar2 == " " and self.CourseChar1 == " " then
                    self.CourseChar4 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar2
                    self.CourseChar3 = " "
                elseif self.CourseChar4 ~= " " and self.CourseChar3 == " " and self.CourseChar2 == " " and self.CourseChar1 == " " then
                    self.CourseChar4 = self.CourseChar3
                    self.CourseChar3 = self.CourseChar2
                    self.CourseChar4 = " "
                end
                
            end
        elseif self.State == 1 and self.Menu == 5 or self.Menu == 2 and self.State == 1 or self.Menu == 5 and self.State == 2 then
            self.Route = self.RouteChar1..self.RouteChar2
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" then
                if self.RouteChar2 == " " and self.RouteChar1 == " " then
                    self.RouteChar2 = self.KeyInput
                    
                    
                elseif self.RouteChar2 ~= " " and self.RouteChar1 == " " then
                    
                    self.RouteChar1 = self.RouteChar2					
                    
                    if self.KeyInput ~= nil then
                        self.RouteChar2 = self.KeyInput
                    end
                elseif self.RouteChar2 ~= " " and self.RouteChar1 ~= " " then
                    self.RouteChar1 = self.RouteChar2					
                    
                    if self.KeyInput ~= nil then
                        self.RouteChar2 = self.KeyInput
                    end
                end
                
            elseif Input ~= nil and Input == "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" and not tonumber(Input,10) then
                if self.RouteChar2 ~= " " and self.RouteChar1 ~= " " then
                    self.RouteChar1 = self.RouteChar2
                    self.RouteChar1 = " "
                elseif self.RouteChar2 ~= " " and self.RouteChar1 == " " then
                    self.RouteChar1 = " "
                end
            end
        elseif self.Menu == 3 and self.State == 1 then
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "SpecialAnnouncements" then
                if self.DestinationChar3 == " " and self.DestinationChar2 == " " and self.DestinationChar1 == " " then
                    
                    if self.KeyInput ~=nil then
                        self.DestinationChar3 = self.KeyInput
                    end
                    
                elseif self.DestinationChar3 ~= " " and self.DestinationChar2 == " " and self.DestinationChar1 == " " then
                    
                    self.DestinationChar2 = self.DestinationChar3					
                    
                    if self.KeyInput ~= nil then
                        self.DestinationChar3 = self.KeyInput
                    end
                elseif self.DestinationChar3 ~= " " and self.DestinationChar2 ~= " " and self.DestinationChar1 == " " then
                    
                    self.DestinationChar1 = self.DestinationChar2					
                    
                    if self.KeyInput ~= nil then
                        self.DestinationChar3 = self.KeyInput
                    end
                elseif self.DestinationChar3 ~= " " and self.DestinationChar2 ~= " " and self.DestinationChar1 ~= " " then
                    self.DestinationChar1 = self.DestinationChar2					
                    self.DestinationChar2 = self.DestinationChar3
                    if self.KeyInput ~= nil then
                        self.DestinationChar3 = self.KeyInput
                    end
                end
                self.Destination = self.DestinationChar1..self.DestinationChar2..self.DestinationChar3
            elseif Input ~= nil and Input == "Delete" and Input ~= "TimeAndDate" and Input ~= "SpecialAnnouncements" then
                if self.DestinationChar3 ~= " " and self.DestinationChar2 ~= " " and self.DestinationChar1 ~= " " then
                    
                    self.DestinationChar1 = self.DestinationChar2
                    self.DestinationChar1 = " "					
                    self.DestinationChar3 = self.DestinationChar2
                elseif self.DestinationChar3 ~= " " and self.DestinationChar2 ~= " " and self.DestinationChar1 == " " then
                    self.DestinationChar2 = self.DestinationChar3
                    self.DestinationChar2 = " "					
                elseif self.DestinationChar3 ~= " " and self.DestinationChar2 == " " and self.DestinationChar1 == " " then
                    self.DestinationChar3 = " "
                end
            end
        elseif self.Menu == 6 and self.State == 1 then
            self.ServiceAnnouncement = self.AnnouncementChar1..self.AnnouncementChar2
            if Input ~= nil and Input ~= "Delete" and Input ~= "TimeAndDate" and Input ~= "Enter" and Input ~= "SpecialAnnouncements" then
                if self.AnnouncementChar2 == " " and self.AnnouncementChar1 == " " then
                    self.AnnouncementChar2 = self.KeyInput
                    
                    
                elseif self.AnnouncementChar2 ~= " " and self.AnnouncementChar1 == " " then
                    
                    self.AnnouncementChar1 = self.AnnouncementChar2					
                    
                    self.AnnouncementChar2 = self.KeyInput
                    
                elseif self.AnnouncementChar2 ~= " " and self.AnnouncementChar1 ~= " " then
                    self.AnnouncementChar1 = self.AnnouncementChar2					
                    self.AnnouncementChar2 = self.KeyInput
                    
                end
            end
        end    
    end
end

function TRAIN_SYSTEM:DisasterTicker() --Generate a random chance for defect simulation
    
    if CurTime() - self.LastRoll > 10 and self.State ~= 4 then
        local randomNumber = math.random(1, 10000)
        if randomnumber == 1 then
            self.State = 4
            self.Train:SetNW2Int("Defect",math.random(1,4))
        end
        self.LastRoll = CurTime()
    end
end

function TRAIN_SYSTEM:CANReceive(sourceid,target,targetdata)
    if sourceid == self.Train:GetWagonNumber() then return end
    if target == "Course" then self.Course = targetdata end
    if target == "Route" then self.Route = targetdata end
    if target == "CurrentStation" then self.CurrentStation = targetdata end
    if target == "Destination" then self.Destination = targetdata end
    if target == "ServiceAnnouncement" then self.ServiceAnnouncement = targetdata end

end


function TRAIN_SYSTEM:CANWrite(sourceid,targetid,target,targetdata)
    for i=1,#self.WagonList do
        local train = self.WagonList[i]
        if not targetid or targetid == train:GetWagonNumber() then
            local sys = train[target]
            if sys and sys.CANReceive then
                sys:CANReceive(sourceid,target,targetdata)
            end
            if targetid then return end
        end
    end
end