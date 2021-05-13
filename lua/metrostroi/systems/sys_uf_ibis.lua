Metrostroi.DefineSystem("IBIS_Prototype")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
    self.route{}
	self.line{}
	self.destination{}
	
	 self.TriggerNames = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
		"7",
		"8",
		"9",
		"0",
		"Route",
		"Line",
		"Dest",
    }
    self.Triggers = {}
    self.State = 0
end
self.Triggers = {}

    self.State = 0

    self.Line = 1
    self.Path = false
    self.Station = 1
    self.Arrived = true

    self.Route = 0

    self.Line = 0

    if not self.Train.R_IBISOn then
		self.Train:LoadSystem("1","Relay","Switch",{bass = true })
		self.Train:LoadSystem("2","Relay","Switch",{bass = true })
		self.Train:LoadSystem("3","Relay","Switch",{bass = true })
		self.Train:LoadSystem("4","Relay","Switch",{bass = true })
		self.Train:LoadSystem("5","Relay","Switch",{bass = true })
		self.Train:LoadSystem("6","Relay","Switch",{bass = true })
		self.Train:LoadSystem("7","Relay","Switch",{bass = true })
		self.Train:LoadSystem("8","Relay","Switch",{bass = true })
		self.Train:LoadSystem("9","Relay","Switch",{bass = true })
		self.Train:LoadSystem("0","Relay","Switch",{bass = true })
		self.Train:LoadSystem("Route","Relay","Switch",{bass = true })
		self.Train:LoadSystem("Line","Relay","Switch",{bass = true })
		self.Train:LoadSystem("Dest","Relay","Switch",{bass = true })
    end
    self.K1 = 0
    self.K2 = 0
    --self.Train:LoadSystem("R_Program1","Relay","Switch",{bass = true })
    --self.Train:LoadSystem("R_Program2","Relay","Switch",{bass = true })



function TRAIN_SYSTEM:Outputs()
    return {"K1","K2","LineOut"}
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
    createFont("IBIS","Liquid Crystal Display",30,400)
    function TRAIN_SYSTEM:ClientThink()
        if not self.DrawTimer then
            render.PushRenderTarget(self.Train.IBIS,0,0,512, 128)
            render.Clear(0, 0, 0, 0)
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
                draw.SimpleText(string.char(0x7f),"Metrostroi_IBIS",(x+i)*20.5+5,y*40+40,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                draw.SimpleText(char,"Metrostroi_IBIS",(x+i)*20.5+5,y*40+40,Color(140,190,0,150),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(char,"Metrostroi_IBIS",(x+i)*20.5+5,y*40+40,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
        end
    end

    TRAIN_SYSTEM.LoadSeq = "---------"
    function TRAIN_SYSTEM:IBISScreen(Train)
        local State = self.Train:GetNW2Int("IBIS:State",-1)
        if State ~= 0 then
            surface.SetDrawColor(0, 31, 7,self.Warm and 130 or 255)
            self.Warm = true
        else
            surface.SetDrawColor(0, 87, 20,230)
            self.Warm = false
        end
        surface.DrawRect(0,0,512,128)
        if State == 0 then
            return
        end


        if State == -2 then
            self:PrintText(0,0,"IFIS Error")
            self:PrintText(0,1,"Карта не поддерживается")
            return
        end
		
        if State > 1 and not Metrostroi.IBISSetup then
            self:PrintText(0,0,"Client error")
            self:PrintText(0,1,"No announcer at client")
            return
        end
        if State == 2 then
            local Route = Format("%02d",Train:GetNW2Int("IBIS:Route",0))
            local sel = Train:GetNW2Int("IBIS:Selected",0)
            self:PrintText(0,0,"Номер маршрута:")
            if sel == 2 then
                self:PrintText(4,1,"\"+-\" отм \"MENU\" ввод")
            else
                self:PrintText(4,1,"\"+-\" выб \"MENU\" след")
            end

            if sel~=0 or RealTime()%1 > 0.5 then self:PrintText(0,1,Route[1]) end
            if sel~=1 or RealTime()%1 > 0.5 then self:PrintText(1,1,Route[2]) end
        end

        local stbl = Metrostroi.IBISSetup and Metrostroi.IBISSetup[Train:GetNW2Int("Announcer",1)]
        if State > 2 and not stbl then
            self:PrintText(0,0,"Client error")
            self:PrintText(0,1,"No line at client")
            return
        end

        if State == 3 then
            local Line = self.Train:GetNW2Int("IBIS:Line",1)
            local ltbl = stbl[Line]
            local St,En = ltbl[1],ltbl[#ltbl]
            self:PrintText(0,0,ltbl.Loop and "Маршрут (кол)" or "Маршрут")
            self:PrintText(20,0,"-")
            if RealTime()%0.8 > 0.4 then
                self:PrintText(17,0,Format("%03d",St[1]))
                self:PrintText(21,0,Format("%03d",En[1]))
            end
            local timer = math.ceil(RealTime()%6/1.5)
            if timer == 1 then self:PrintText(0,1,(ltbl.Name or "Нет названия"))
            elseif timer == 2 then self:PrintText(0,1,"От:") self:PrintText(3,1,St[2])
            elseif timer == 3 then self:PrintText(0,1,"До:") self:PrintText(3,1,En[2])
            elseif timer == 4 then self:PrintText(0,1,"\"+-\" выбор   \"MENU\" ввод") end
        end

        if State == 4 then
            local Line = Train:GetNW2Int("IBIS:Line",1)
            local ltbl = stbl[Line]
            if ltbl.Loop then
                local Route = Train:GetNW2Bool("IBIS:Route")
                self:PrintText(0,0,"Путь")
                self:PrintText(0,1,Route and "II" or "I")
                self:PrintText(2,1,Route and "(второй)" or "(первый)")
                if RealTime()%0.8 > 0.4 then self:PrintText(18,0,Train:GetNW2Bool("IBIS:Route")) end
                self:PrintText(20,0,"-")
            else
                local St = ltbl[Train:GetNW2Int("IBIS:FirstStation",1)]
                self:PrintText(0,0,"Начальная ст.")
                self:PrintText(0,1,St[1]..":"..St[2])
                self:PrintText(20,0,"-")
                if RealTime()%0.8 > 0.4 then
                    self:PrintText(17,0,Format("%03d",St[1]))
                end
            end
        end

        if State == 5 then
            local Line = Train:GetNW2Int("IBIS:Line",1)
            local ltbl = stbl[Line]
            if ltbl.Loop then
                local station = Train:GetNW2Int("IBIS:LastStation",1)
                local En = ltbl[station]
                self:PrintText(0,0,"Конечная ст.")
                if station == 0 then
                    self:PrintText(0,1," ():".."Кольцевой")
                else
                    self:PrintText(0,1,En[1]..":"..En[2])
                end
                local Path = Train:GetNW2Bool("IBIS:Path") and "II" or "I"
                self:PrintText(18,0,Path)
                self:PrintText(20,0,"-")
                if RealTime()%0.8 > 0.4 then
                    if En then
                        self:PrintText(21,0,Format("%03d",En[1]))
                    else
                        self:PrintText(22,0,Path)
                    end
                end
            else
                local St = ltbl[Train:GetNW2Int("IBIS:FirstStation",1)]
                local En = ltbl[Train:GetNW2Int("IBIS:LastStation",1)]
                self:PrintText(0,0,"Конечная станция")
                self:PrintText(0,1,En[1]..":"..En[2])
                self:PrintText(20,0,"-")
                self:PrintText(17,0,Format("%03d",St[1]))
                if RealTime()%0.8 > 0.4 then
                    self:PrintText(21,0,Format("%03d",En[1]))
                end
            end
        end

        if State == 6 then
            local Line = Train:GetNW2Int("IBIS:Line",1)
            local ltbl = stbl[Line]
            local Path = Train:GetNW2Bool("IBIS:Path")
            self:PrintText(0,0,"Проверьте данные")
            self:PrintText(17,0,Format("%02d",Line))
            self:PrintText(20,0,Format("%02d",Train:GetNW2Int("IBIS:Route",0)))
            self:PrintText(23,0,Path and "II" or "I")
            if ltbl.Loop then
                local station = Train:GetNW2Int("IBIS:LastStation",1)
                local En = ltbl[station]
                --self:PrintText(20,0,"()")
                local timer = math.ceil(RealTime()%4.5/1.5)
                if timer == 1 then self:PrintText(0,1,"(кол) "..(ltbl.Name or "Нет названия"))
                elseif timer == 2 and station > 0 then self:PrintText(0,1,"До:");self:PrintText(3,1,En[2]);self:PrintText(21,1,tostring(En[1]))
                elseif timer == 2 and station == 0 then self:PrintText(0,1,"Без конечной")
                elseif timer == 3 then self:PrintText(0,1,"\"+-\" отмена    \"MENU\" ок") end
            else
                local St = ltbl[Train:GetNW2Int("IBIS:FirstStation",1)]
                local En = ltbl[Train:GetNW2Int("IBIS:LastStation",1)]
                if Path then
                    local StT = En;En=St;St=StT
                end
                local timer = math.ceil(RealTime()%6/1.5)
                if timer == 1 then self:PrintText(0,1,(ltbl.Name or "Нет названия"))
                elseif timer == 2 then self:PrintText(0,1,"От:");self:PrintText(3,1,St[2]);self:PrintText(21,1,tostring(St[1]))
                elseif timer == 3 then self:PrintText(0,1,"До:");self:PrintText(3,1,En[2]);self:PrintText(21,1,tostring(En[1]))
                elseif timer == 4 then self:PrintText(0,1,"\"+-\" выб     \"MENU\" ввод") end
            end
        end
        if State == 7 then
            local Line = Train:GetNW2Int("IBIS:Line",1)
            local ltbl = stbl[Line]

            local Path = Train:GetNW2Bool("IBIS:Path")

            local St = ltbl[Train:GetNW2Int("IBIS:FirstStation",1)]
            local En
            if Path and not ltbl.Loop then
                En = ltbl[Train:GetNW2Int("IBIS:FirstStation",1)]
            else
                En = ltbl[Train:GetNW2Int("IBIS:LastStation",1)]
            end

            local Station = ltbl[Train:GetNW2Int("IBIS:Station",1)]
            if not Station then return end
            local Dep = self.Train:GetNW2Bool("IBIS:Arrived",false)


            if Dep then self:PrintText(0,0,"Отпр.") else self:PrintText(0,0,"Приб.") end
            self:PrintText(6,0,Station[2])
            if Train:GetNW2Bool("IBIS:Playing",false) then
                self:PrintText(0,1,"<<<  ИДЕТ ОБЪЯВЛЕНИЕ  >>>")
            --elseif Station == En then
            --  self:PrintText(0,1,"<<<      КОНЕЧАЯ      >>>")
            else
                --self:PrintText(0,1,string.rep("I",Path and 2 or 1))
                if Path then
                    self:PrintText(-0.2,1,"I")
                    self:PrintText( 0.2,1,"I")
                else
                    self:PrintText(0,1,"I")
                end
                self:PrintText(2,1,string.format("% 2d.",Train:GetNW2Int("IBIS:Route",0)))
                if ltbl.Loop and Train:GetNW2Int("IBIS:LastStation",1) == 0 then
                    self:PrintText(6,1,"Кольцевой")
                else
                    self:PrintText(6,1,En[2]:upper())
                end
                if Train:GetNW2Bool("IBIS:CanLocked",false) then
                    if Train:GetNW2Bool("IBIS:LockedL",false) then self:PrintText(20,0,"Бл.Л") end
                    if Train:GetNW2Bool("IBIS:LockedR",false) then self:PrintText(20,1,"Бл.П") end
                end
            end
        end
    end
    return
end

function TRAIN_SYSTEM:Zero()
    self.Station = self.Path and self.LastStation or self.FirstStation
    self.Arrived = true
    self:UpdateBoards()
end

function TRAIN_SYSTEM:Next()
    local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
    if tbl.Loop then
        if self.Arrived then
            if self.Path then
                self.Station = self.Station - 1
            else
                self.Station = self.Station + 1
            end
            if self.Station == 0 or self.Station > #tbl then
                self.Station = self.Station == 0 and #tbl or 1
            end
            if self.Station == 0 or self.Station > #tbl then
                self.Station = self.Station == 0 and (self.LastStation > 0 and self.LastStation or #tbl) or 1
            end
            self.Arrived = false
            --self.Station = 1
        else
            self.Arrived = true
        end
    else
        if self.Arrived then
                if self.Station ~= (self.Path and self.FirstStation or self.LastStation) then
                if self.Path then
                    self.Station = math.max(self.FirstStation,self.Station - 1)
                else
                    self.Station = math.min(self.LastStation,self.Station + 1)
                end
                self.Arrived = false
            end
        else
            self.Arrived = true
        end
    end
    self:UpdateBoards()
end
function TRAIN_SYSTEM:Prev()
    local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
    if tbl.Loop then
        if not self.Arrived then
            if self.Path then
                self.Station = self.Station + 1
            else
                self.Station = self.Station - 1
            end
            if self.Station == 0 or self.Station > #tbl then
                self.Station = self.Station == 0 and (self.LastStation > 0 and self.LastStation or #tbl) or 1
            end
            --self.Station = 1
            self.Arrived = true
        else
            self.Arrived = false
        end
    else
        if not self.Arrived then
            if self.Path then
                self.Station = math.min(self.LastStation,self.Station + 1)
            else
                self.Station = math.max(self.FirstStation,self.Station - 1)
            end
            self.Arrived = true
        else
            if self.Station ~= (self.Path and self.LastStation or self.FirstStation) then
                self.Arrived = false
            end
        end
    end
    self:UpdateBoards()
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
    --local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line][self.Station]
    if self.LastStation > 0 and not dep and self.Station ~= last and tbl[last].not_last and (stbl.have_inrerchange or math.abs(last-self.Station) <= 3) then
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
function TRAIN_SYSTEM:CANReceive(source,sourceid,target,targetid,textdata,numdata)
    if sourceid == self.Train:GetWagonNumber() then return end
    if textdata == "Route" then self.Route = numdata end
    if textdata == "Path" then self.Path = numdata > 0 end
    if textdata == "Line" then self.Line = numdata end
    if textdata == "FirstStation" then self.FirstStation = numdata end
    if textdata == "LastStation" then self.LastStation = numdata end
    if textdata == "Activate" then
        local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        self.Station = tbl.Loop and 1 or self.Path and self.LastStation or self.FirstStation
        self.Arrived = true
        self.State = 7
        --[[local last = self.Path and not tbl.Loop and self.FirstStation or self.LastStation
        local lastst = tbl[last] and tbl[last][1]
        if lastst then self.Train:SetNW2Int("LastStation",lastst) end
        self.Train:SetNW2Int("Route",self.Route)]]
    end
end
function TRAIN_SYSTEM:SyncIBIS()
    --[[ local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
    local last = self.Path and self.FirstStation or self.LastStation
    local lastst = tbl[last] and tbl[last][1]
    if lastst then self.Train:SetNW2Int("LastStation",lastst) end
    self.Train:SetNW2Int("Route",self.Route)]]
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Route",self.Route)
	self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Dest",self.Dest)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Line",self.Line)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"FirstStation",self.FirstStation)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"LastStation",self.LastStation)
    self.Train:CANWrite("IBIS",self.Train:GetWagonNumber(),"IBIS",nil,"Activate")
end
function TRAIN_SYSTEM:UpdateBoards()
    if not self.PassSchemeWork then return end
    local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
    local stbl = tbl.LED
    local last = self.Path and self.FirstStation or self.LastStation

    local curr = 0
    if self.Path then
        for i=#stbl,self.Station+1,-1 do
            if stbl[i] then
                curr = curr + stbl[i]
            end
        end
    else
        for i=1,self.Station-1 do
            if stbl[i] then
                curr = curr + stbl[i]
            end
        end
    end
    local nxt = 0
    if self.Arrived then
        curr = curr + stbl[self.Station]
    else
        nxt = stbl[self.Station]
    end
end

function TRAIN_SYSTEM:Trigger(name,value)
    local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)]
    if (name == "Line") then
        self.State = 2
	end
	
		if (name == "0") then
			if self.LineNum1 == nil then
				self.LineNum1 = 0
				else
					if self.LineNum2 == nil then
						self.LineNum2 = 0
						else
						if self.LineNum3 == nil then
							self.LineNum3 = 0
							else 
							if self.LineNum4 == nil then
								self.LineNum = 0
								else
								if self.LineNum5 == nil then
									self.LineNum5 = 0
								end
							end
						end
					end
				end
			end
		end
		
		if (name == "1") then
			if self.LineNum1 == nil then
				self.LineNum1 = 0
				else
					if self.LineNum2 == nil then
						self.LineNum2 = 1
						else
						if self.LineNum3 == nil then
							self.LineNum3 = 1
							else 
							if self.LineNum4 == nil then
								self.LineNum = 1
								else
								if self.LineNum5 == nil then
									self.LineNum5 = 1
								end
							end
						end
					end
				end
			end
		end
		if (name == "2") then
			if self.LineNum1 == nil then
				self.LineNum1 = 2
				else
					if self.LineNum2 == nil then
						self.LineNum2 = 2
						else
						if self.LineNum3 == nil then
							self.LineNum3 = 2
							else 
							if self.LineNum4 == nil then
								self.LineNum = 2
								else
								if self.LineNum5 == nil then
									self.LineNum5 = 2
								end
							end
						end
					end
				end
			end
		end
		if (name == "3") then
			if self.LineNum1 == nil then
				self.LineNum1 = 3
				elseif self.LineNum2 == nil then
						self.LineNum2 = 3
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 3
							elseif self.LineNum4 == nil then
								self.LineNum = 3
								elseif self.LineNum5 == nil then
									self.LineNum5 = 3
								end
							end
						end
					end
				end
			end
		end
		
		if (name == "4") then
			if self.LineNum1 == nil then
				self.LineNum1 = 4
				elseif self.LineNum2 == nil then
						self.LineNum2 = 4
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 4
							elseif self.LineNum4 == nil then
								self.LineNum = 4
								elseif self.LineNum5 == nil then
									self.LineNum5 = 4
								end
							end
						end
					end
				end
			end
		end
		if (name == "5") then
			if self.LineNum1 == nil then
				self.LineNum1 = 5
				elseif self.LineNum2 == nil then
						self.LineNum2 = 5
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 5
							elseif self.LineNum4 == nil then
								self.LineNum = 5
								elseif self.LineNum5 == nil then
									self.LineNum5 = 5
								end
							end
						end
					end
				end
			end
		end
		if (name == "6") then
			if self.LineNum1 == nil then
				self.LineNum1 = 6
				elseif self.LineNum2 == nil then
						self.LineNum2 = 6
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 6
							elseif self.LineNum4 == nil then
								self.LineNum = 6
								elseif self.LineNum5 == nil then
									self.LineNum5 = 6
		if (name == "7") then
			if self.LineNum1 == nil then
				self.LineNum1 = 7
				elseif self.LineNum2 == nil then
						self.LineNum2 = 7
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 7
							elseif self.LineNum4 == nil then
								self.LineNum = 7
								elseif self.LineNum5 == nil then
									self.LineNum5 = 7
		end
		if (name == "8") then
			if self.LineNum1 == nil then
				self.LineNum1 = 8
				elseif self.LineNum2 == nil then
						self.LineNum2 = 8
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 8
							elseif self.LineNum4 == nil then
								self.LineNum = 8
								elseif self.LineNum5 == nil then
									self.LineNum5 = 8
		end
									
		if (name == "9") then
			if self.LineNum1 == nil then
				self.LineNum1 = 9
				elseif self.LineNum2 == nil then
						self.LineNum2 = 9
						
						elseif self.LineNum3 == nil then
							self.LineNum3 = 9
							elseif self.LineNum4 == nil then
								self.LineNum = 9
								elseif self.LineNum5 == nil then
									self.LineNum5 = 9
		end
									

		if (name == "Delete") then
			if not self.LineNum1 == nil then
				self.LineNum1 = nil
				elseif not self.LineNum2 == nil then
						self.LineNum2 = nil
						
						elseif not self.LineNum3 == nil then
							self.LineNum3 = nil
							elseif not self.LineNum4 == nil then
								self.LineNum = nil
								elseif not self.LineNum5 == nil then
									self.LineNum5 = nil ----BOOKMARK
		end
									

							
			
            if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
            self:AnnQueue{"click1","buzz_start"}
            self:AnnQueue(-1)
            self:AnnQueue(tbl[self.Line].spec_last)
            self:AnnQueue{"buzz_end","click2"}
        elseif self.State == 7 then
            local ltbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
            local stbl = ltbl[self.Station]
            local last,lastst
            if self.Arrived then
                if tbl.Loop then
                    ltbl = self.LastStation
                    lastst = self.LastStation > 0 and self.Station == last and ltbl[last].arrlast
                else
                    last = self.Path and self.FirstStation or self.LastStation
                    lastst = self.Station == last and ltbl[last].arrlast
                end
            end
            if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
            if lastst and not ltbl[last].ignorelast then
                self:AnnQueue{"click1","buzz_start"}
                self:AnnQueue(-1)
                if stbl.spec_last_c then
                    local patt = stbl.spec_last_c[self.Path and 2 or 1]
                    self:AnnQueue(ltbl[patt] or ltbl.spec_last)
                else
                    self:AnnQueue(ltbl.spec_last)
                end
                self:AnnQueue{"buzz_end","click2"}
            else
                self.StopMessage = not self.StopMessage
                self:AnnQueue{"click1","buzz_start"}
                if stbl.spec_wait_c then
                    local patt = stbl.spec_wait_c[self.Path and 2 or 1]
                    self:AnnQueue((ltbl[patt] or ltbl.spec_wait)[self.StopMessage and 1 or 2])
                else
                    self:AnnQueue(ltbl.spec_wait[self.StopMessage and 1 or 2])
                end
                self:AnnQueue{"buzz_end","click2"}
            end
        end
    end
    if self.State == 1 and name == "R_IBISMenu" and value then
        self.State = 2
        self.Selected = 0
    elseif self.State == 2 and value then
        if name == "R_IBISMenu" then
            self.Selected = self.Selected + 1
            if self.Selected > 2 then
                self.State = 3
            end
        end
        if (name == "R_IBISUp" or name == "R_IBISDown") and self.Selected < 2 then
            local sel = 1-self.Selected
            local num = Format("%02d",self.Route)[self.Selected+1]
            if name == "R_IBISUp" then if num == "9" then self.Route = self.Route - 10^sel*9 else self.Route = self.Route + 10^sel end end
            if name == "R_IBISDown" then if num == "0" then self.Route = self.Route + 10^sel*9 else self.Route = self.Route - 10^sel end end
        end
        if (name == "R_IBISUp" or name == "R_IBISDown") and self.Selected == 2 then self.Selected = 0 end
    elseif self.State == 3 and value then
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)]
        if name == "R_IBISDown" and value then
            self.Line =self.Line + 1
            if self.Line > #tbl then self.Line = 1 end
        end
        if name == "R_IBISUp" and value then
            self.Line = math.max(1,self.Line - 1)
            if self.Line < 1 then self.Line = #tbl end
        end
        if name == "R_IBISMenu" and value then
            if not tbl[self.Line].Loop then
                self.FirstStation = 1
            end
            self.State = 4
        end
    elseif self.State == 4 and value and not tbl[self.Line].Loop then --Не кольцевой
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        if name == "R_IBISDown" then
            local found = false
            for i=self.FirstStation+1,#stbl do
                if stbl[i].arrlast then self.FirstStation = i;found=true;break end
            end
            if not found then
                for i=1,#stbl do
                    if stbl[i].arrlast then self.FirstStation = i;break end
                end
            end
        end
        if name == "R_IBISUp" then
            local found = false
            for i=self.FirstStation-1,1,-1 do
                if stbl[i].arrlast then self.FirstStation = i;found=true;break end
            end
            if not found then
                for i=#stbl,1,-1 do
                    if stbl[i].arrlast then self.FirstStation = i;break end
                end
            end
        end
        if name == "R_IBISMenu" then
            self.State = 5
            self.LastStation = 1
            while stbl[self.LastStation] and not stbl[self.LastStation].arrlast or self.LastStation == self.FirstStation do
                self.LastStation = self.LastStation - 1
                if self.LastStation < 1 then self.LastStation = #stbl end
            end
        end
    elseif self.State == 4 and value and tbl[self.Line].Loop then --Кольцевой
        if name == "R_IBISDown" or name == "R_IBISUp" then
            self.Path = not self.Path
        end
        if name == "R_IBISMenu" then
            self.LastStation = 0
            self.FirstStation = 0
            self.State = 5
        end
    elseif self.State == 5 and value and not tbl[self.Line].Loop then --Не кольцевой
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        if name == "R_IBISDown" then
            local found = false
            for i=self.LastStation+1,#stbl do
                if i ~= self.FirstStation and stbl[i].arrlast then self.LastStation = i;found=true;break end
            end
            if not found then
                for i=1,#stbl do
                    if i ~= self.FirstStation and stbl[i].arrlast then self.LastStation = i;break end
                end
            end
        end
        if name == "R_IBISUp" then
            local found = false
            for i=self.LastStation-1,1,-1 do
                if i ~= self.FirstStation and stbl[i].arrlast then self.LastStation = i;found=true;break end
            end
            if not found then
                for i=#stbl,1,-1 do
                    if i ~= self.FirstStation and stbl[i].arrlast then self.LastStation = i;break end
                end
            end
        end
        if name == "R_IBISMenu" then
            self.Path = self.FirstStation > self.LastStation
            self.Station = self.FirstStation
            if self.Path then
                local first = self.LastStation
                self.LastStation = self.FirstStation
                self.FirstStation = first
            end
            self.Arrived = true
            self.State = 6
        end
    elseif self.State == 5 and value and tbl[self.Line].Loop then --Кольцевой
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        if name == "R_IBISDown" then
            local found = false
            for i=self.LastStation+1,#stbl do
                if stbl[i].arrlast then self.LastStation = i;found=true;break end
            end
            if not found and self.LastStation ~= 0 then
                self.LastStation = 0
            end
        end
        if name == "R_IBISUp" then
            local found = false
            if self.LastStation == 1 then
                self.LastStation = 0
                found = true
            end
            for i=self.LastStation-1,1,-1 do
                if stbl[i].arrlast and stbl[i].arrlast[self.Path and 2 or 1] then self.LastStation = i;found=true;break end
            end
            if not found then
                for i=#stbl,1,-1 do
                    if stbl[i].arrlast and stbl[i].arrlast[self.Path and 2 or 1] then self.LastStation = i;break end
                end
            end
        end
        if name == "R_IBISMenu" then
            self.State = 6
            self.Station = 1
            self.Arrived = true
        end
    elseif self.State == 6 and value then
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        if name == "R_IBISDown" or name == "R_IBISUp" then
            self.State = 2
            self.Selected = 0
        end
        if name == "R_IBISMenu" then
            if self.FirstStation ~= 0 then
                if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
                if self.Path then
                    self:AnnQueue{"click1","buzz_start","announcer_ready",stbl[self.LastStation].arrlast[3],stbl[self.FirstStation].arrlast[3],"buzz_end","click2"}
                else
                    self:AnnQueue{"click1","buzz_start","announcer_ready",stbl[self.FirstStation].arrlast[3],stbl[self.LastStation].arrlast[3],"buzz_end","click2"}
                end
            end
            self.State = 7
            self:UpdateBoards()
            self:SyncIBIS()
            self.StopMessage = false
        end
    elseif self.State == 7 then
        local stbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)][self.Line]
        if name == "R_IBISMenu" and value then self.ReturnTimer = CurTime() end
        if name == "R_IBISMenu" and not value and self.ReturnTimer and self.ReturnTimer - CurTime() < 0.7 then
            self.ReturnTimer = nil
        end
        if name == "R_IBISDown" and value then self:Next() end
        if name == "R_IBISUp" and value then self:Prev() end
        if (name == "R_Program1" or name == "R_Program1H") and value then
            if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
            if self.Arrived and self.Station == (self.Path and self.FirstStation or self.LastStation) then
                self:Zero()
            end
            self:Play(self.Arrived)
            self:Next()
        end
    end
end

--States:
-- -2 - Loaded in another cab
-- -1 - Starting up
--nil - First setUp and get settings from last
--1   - Welcome Screen
--2   - Route Choose
--3   - Choose start station
--4   - Choose end station
--5   - Choose path
--6   - Choose style of playing
--7   - Normal state
--8   - Confim a settings (on last stations)
function TRAIN_SYSTEM:Think()
    if self.Disable then return end
    local Train = self.Train
    local Power = BatteryOn > 0.5
    if not Power and self.State ~= 0 then
        self.State = 0
        self.IBISTimer = nil
        if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
    end
    if Power and self.State == 0 then
        self.State = -1
        self.IBISTimer = CurTime()-math.Rand(-0.3,0.3)
    end
    if self.State == -1 and self.IBISTimer and CurTime()-self.IBISTimer > 1 then
        self.State = Metrostroi.IBISSetup and 1 or -2
    end
    if Power and self.State > -1  then
        for k,v in pairs(self.TriggerNames) do
            if Train[v] and (Train[v].Value > 0.5) ~= self.Triggers[v] then
                self:Trigger(v,Train[v].Value > 0.5)
                self.Triggers[v] = Train[v].Value > 0.5
            end
        end
    end
    if not Metrostroi.IBISSetup and self.State > 0 then
        self.State = -2
    end
    local PSWork = Train.Panel.PassSchemeControl and Train.Panel.PassSchemeControl>0 and self.State==7
    if PSWork~=self.PassSchemeWork then
        self.PassSchemeWork = PSWork
        if self.PassSchemeWork then self:UpdateBoards() end
    end

    if self.ReturnTimer and CurTime()-self.ReturnTimer > 0.7 then
        if self.State == 7 then
            self.State = 6
            if self.LineOut>0 then self:AnnQueue{-2,"buzz_end","click2"} end
        end
        self.ReturnTimer = nil
    end
    Train:SetNW2Int("IBIS:State",self.State)
    Train:SetNW2Int("IBIS:Route",self.Route)

    Train:SetNW2Int("IBIS:Selected",self.Selected)
    Train:SetNW2Int("IBIS:Line",self.Line)
    Train:SetNW2Int("IBIS:FirstStation",self.FirstStation)
    Train:SetNW2Int("IBIS:LastStation",self.LastStation)
    Train:SetNW2Bool("IBIS:Path",self.Path)

    Train:SetNW2Bool("IBIS:Station",self.Station)
    Train:SetNW2Bool("IBIS:Arrived",self.Arrived)
    self.LineOut = #Train.Announcer.Schedule>0 and 1 or 0
    Train:SetNW2Bool("IBIS:Playing",self.LineOut>0)
    if Train.VBD and self.State>0 then
        Train:SetNW2Bool("IBIS:CanLocked",true)
        if self.State<6 then
            self.K1 = 1
            self.K2 = 1
            self.StopTimer = nil
        elseif Train.ALSCoil.Speed>1 then
            self.K1 = 0
            self.K2 = 0
            self.StopTimer = nil
        else
            if self.StopTimer==nil then self.StopTimer = CurTime() end
            if self.StopTimer and CurTime()-self.StopTimer >= 10 then
                self.StopTimer = false
            end
            local tbl = Metrostroi.IBISSetup[self.Train:GetNW2Int("Announcer",1)]
            local stbl = tbl[self.Line] and tbl[self.Line][self.Station]
            if not stbl or not tbl[self.Line].BlockDoors or self.Arrived and self.Station == (self.Path and self.FirstStation or self.LastStation) then
                self.K1 = 1
                self.K2 = 1
            elseif self.Arrived then
                self.K1 = (stbl.both_doors or not stbl.right_doors) and 1 or 0
                self.K2 = (stbl.both_doors or     stbl.right_doors) and 1 or 0
            elseif self.StopTimer~=false then
                self.K1 = 0
                self.K2 = 0
            else
                self.K1 = 1
                self.K2 = 1
            end
        end
        Train:SetNW2Bool("IBIS:LockedL",self.K1==0)
        Train:SetNW2Bool("IBIS:LockedR",self.K2==0)
    else
        Train:SetNW2Bool("IBIS:CanLocked",false)
        self.K1 = 0
        self.K2 = 0
        self.StopTimer = false
    end

end