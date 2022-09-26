AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/lilly/uf/station_equipment/lumina.mdl")
	self:SetSolid( SOLID_NONE )

	self.TargetDisplay = NULL
	self.TargetDisplays = {}
	self.TargetDisplays = ents.FindByName(self.RonVMF.TargetDisplay)
	self.TrainList = {}
	self.TriggerIndicator = NULL
	self.TriggerArrive = NULL
	self.TriggerDepart = NULL
	self.ActiveIndicator = true
	self.ActiveArrive = true
	self.ActiveDepart = true
	self.StationNumber = self.RonVMF.StationNumber
	self.TrackNumber = self.TargetDisplays[1].RonVMF.TrackNumber
	self.Lines = Metrostroi.RonDaisyLines
	self.Announces = Metrostroi.RonDaisyAnnounces
	self.isSoundPlaying = false
	self.Schedule = 1
	self.SoundTable = {}
	
	self.TriggerIndicator = self:GetNWEntity("1")
	self.TriggerArrive = self:GetNWEntity("2")
	self.TriggerDepart = self:GetNWEntity("3")
end



--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue(key, value)
    self.RonVMF = self.RonVMF or {}
    self.RonVMF[key] = value
end

function ENT:Think()
	if not self.TriggerIndicator then return end
	if not self.TriggerArrive then return end
	if not self.TriggerDepart then return end
	
	if self.ActiveIndicator then
		self.TriggerIndicatorEntity = self:GetNWEntity("1 Trace")
	end
	if self.ActiveArrive then
		self.TriggerArriveEntity = self:GetNWEntity("2 Trace")
	end
	if self.ActiveDepart then
		self.TriggerDepartEntity = self:GetNWEntity("3 Trace")
	end
	if IsValid(self.TriggerIndicatorEntity) then
		if self.TrainList[table.Count(self.TrainList)] != self.TriggerIndicatorEntity then
			self.TrainList[table.Count(self.TrainList)+1] = self.TriggerIndicatorEntity
			self:UpdateDisplay()
			self:SetDisplayText("TextDepartA")
		end		
	end
		
	if IsValid(self.TriggerArriveEntity) and self.TriggerArriveEntity == self.TrainList[1] and table.Count(self.SoundTable) == 0  then
		self:UpdateDisplay()
		self:SetDisplayText("TextDepartA", "   sofort")
		if tonumber(self:GetTrainDestinationIndex(self.TriggerArriveEntity)) == tonumber(self.StationNumber) then
			self.SoundTable = {self.Announces["gong"], self.Announces["g"..self.TrackNumber], self.Announces[self.Lines[self:GetTrainLine(self.TriggerArriveEntity)]], self.Announces["zug_endet"] }
		elseif tonumber(self:GetTrainDestinationIndex(self.TriggerArriveEntity)) != tonumber(self.StationNumber) then
			self.SoundTable = {self.Announces["gong"], self.Announces["g"..self.TrackNumber], self.Announces[self.Lines[self:GetTrainLine(self.TriggerArriveEntity)]], self.Announces["nach"], self.Announces[tostring(self:GetTrainDestinationIndex(self.TriggerArriveEntity))]}
		end
		self:DisplaySoundFunnel(self.SoundTable)
	end
	if IsValid(self.TriggerDepartEntity) and self.TriggerDepartEntity == self.TrainList[1] then
		if self.ActiveIndicator == true then
			if self.TrainList[1] == self.TriggerDepartEntity then
				table.remove(self.TrainList, 1)
			end
		elseif self.ActiveIndicator == false then
			table.Empty(self.TrainList)
			end
		self:UpdateDisplay("in kürze")
	end
	local WagCount = table.Count(ents.FindByClass("gmod_subway_uf*"))
	for i=1, table.Count(self.TrainList) do
		if self.TrainList[i] == NULL then
			table.remove(self.TrainList, i)
			self:UpdateDisplay()
		end
	end
end



function ENT:AcceptInput(name, activator, called, data)
	if tostring(name) == "DisableContact" then
		if tonumber(data) == 1 then
			self.ActiveIndicator = false
			self.TriggerIndicatorEntity = NULL
		elseif tonumber(data) == 2 then
			self.ActiveArrive = false
			self.ActiveArrive = NULL
		elseif tonumber(data) == 3 then
			self.ActiveDepart = false
			self.ActiveDepart = NULL
		elseif tonumber(data) > 3 then
			print("ERROR Contact ID Invalid")
		end
	elseif name == "EnableContact" then
		if tonumber(data) == 1 then
			self.ActiveIndicator = true
		elseif tonumber(data) == 2 then
			self.ActiveArrive = true
		elseif tonumber(data) == 3 then
			self.ActiveDepart = true
		elseif tonumber(data) > 3 then
			print("ERROR Contact ID Invalid")
		end
	end
end

function ENT:UpdateDisplay(Depart)
	if !self.TrainList then return end

	local Depart = Depart or ""
	if table.Count(self.TrainList) == 1 then
		local LastStation = self:GetTrainDestination(self.TrainList[1])
		local Line = self.Lines[self:GetTrainLine(self.TrainList[1])]
		self:SetDisplayText("TextDepartA", Depart)
		self:SetDisplayText("TextDestA", LastStation)
		self:SetDisplayText("TextLineA", Line)
		self:SetDisplayText("TextDepartB", "")
		self:SetDisplayText("TextDestB", "")
		self:SetDisplayText("TextLineB", "")
	elseif table.Count(self.TrainList) > 1 then
		local LastStation = self:GetTrainDestination(self.TrainList[2])
		local Line = self.Lines[self:GetTrainLine(self.TrainList[2])]
		self:SetDisplayText("TextDepartB", Depart)
		self:SetDisplayText("TextDestB", LastStation)
		self:SetDisplayText("TextLineB", Line)
	elseif table.Count(self.TrainList) == 0 then
		self:SetDisplayText("TextDepartA", "")
		self:SetDisplayText("TextDestA", "")
		self:SetDisplayText("TextDepartB", "")
		self:SetDisplayText("TextDestB", "")
		self:SetDisplayText("TextLineA", "Zurzeit kein Zugverkehr!")
		self:SetDisplayText("TextLineB", "Out of Service!")
	end
end

function ENT:GetTrainDestination(Train)
	local LastStation
	if Train:GetNW2Int("LastStation") != 0 then
		//Found Any kind of train except the 81-722
		if tonumber(Train:GetNW2Int("LastStation")) != tonumber(self.StationNumber) then
			LastStation = Metrostroi.StationConfigurations[Train:GetNW2Int("LastStation")]["names"][1]
		elseif tonumber(Train:GetNW2Int("LastStation")) == tonumber(self.StationNumber) then
			LastStation = "Nicht Einsteigen"
		end
		elseif(Train:GetNW2String("RouteNumberLastStation")) != "" then
		//Found 81-722
		Train.Line = Train:GetNW2Int("SarmatLine")
		if Train:GetNW2Int("LastStation") != self.StationNumber then
			local last
			if Train.SarmatUPO and Metrostroi.SarmatUPOSetup then
				local sarmat = Train.SarmatUPO
				local stbl = Metrostroi.SarmatUPOSetup[self.TrainList[1]:GetNW2Int("Announcer", 1)]
				local stbll = stbl[sarmat.Line]
				local lastSt = (sarmat.Path and not stbll.Loop) and sarmat.StartStation or sarmat.EndStation
				last = stbll[lastSt][1]
			end
			LastStation = Metrostroi.StationConfigurations[last]["names"][1]
		elseif Train:GetNW2Int("LastStation") == self.StationNumber then
			LastStation = "Nicht Einsteigen"
		end
	else return end
	return LastStation
end

function ENT:GetTrainDestinationIndex(Train)

	local LastStation
	if Train:GetNW2Int("LastStation") != 0 then
		//Found Any kind of train except the 81-722
		LastStation = Train:GetNW2Int("LastStation")
	elseif(Train:GetNW2String("RouteNumberLastStation")) != "" then
		//Found 81-722
		if Train:GetNW2Int("LastStation") != self.StationNumber then
		local last
			if Train.SarmatUPO and Metrostroi.SarmatUPOSetup then
				local sarmat = Train.SarmatUPO
				local stbl = Metrostroi.SarmatUPOSetup[self.TrainList[1]:GetNW2Int("Announcer", 1)]
				local stbll = stbl[sarmat.Line]
				local lastSt = (sarmat.Path and not stbll.Loop) and sarmat.StartStation or sarmat.EndStation
				last = stbll[lastSt][1]
			end
			LastStation = last
		end
	end
	return LastStation
end

function ENT:GetTrainLine(Train)

	local Line
	if Train:GetNW2Int("LastStation") != 0 then
		//Found Any kind of train except the 81-722
		Line = Train.ASNP.Line
	elseif(Train:GetNW2String("RouteNumberLastStation")) != "" then
		//Found 81-722
		Line = Train:GetNW2Int("SarmatLine")
	end
	return Line
end

function ENT:DisplaySoundFunnel(SoundTable)
	if !SoundTable then return end
	if(self.Schedule <= table.Count(SoundTable)) then
		if self.isSoundPlaying == false then
			self.isSoundPlaying = true
			self:PlayDisplaySound(SoundTable[self.Schedule][1])
			timer.Simple(SoundTable[self.Schedule][2] , function() self.isSoundPlaying = false self.Schedule=self.Schedule+1 self:DisplaySoundFunnel(SoundTable) if self.Schedule == table.Count(SoundTable) then return end end)
		end
	end
	if self.Schedule > table.Count(SoundTable) then
		self.Schedule = 1
	end
end

function ENT:PlayDisplaySound(SoundPath)
	if !SoundPath then return end
	if !self.TargetDisplays then return end
	local Displays = self.TargetDisplays
	for i=1, table.Count(Displays) do
		-- print("Playing "..SoundPath)
		sound.Play(SoundPath, Displays[i]:GetPos(), 75, 100, 1)
	end
end

function ENT:SetDisplayText(Adress, Text)
	if !Adress then return end
	if !Text then return end
	if !self.TargetDisplays then return end

	local Displays = self.TargetDisplays
	for i=1, table.Count(Displays) do
		if !IsValid(Displays[i]) then print("failed!") return end
		Displays[i]:SetNWString(Adress, Text)
	end
end

-- function ENT:IsInConsist(Train)
	-- if !IsValid(Train) then return end
	-- local consist = Train.WagonList
	-- local trainlist = self.TrainList
	-- for i in table.Count(consist) do
		-- if consist[i] == trainlist[table.Count(trainlist)] then print("true") return true end
		-- if consist[i] != trainlist[table.Count(trainlist)] then return false end
	-- end

-- end
