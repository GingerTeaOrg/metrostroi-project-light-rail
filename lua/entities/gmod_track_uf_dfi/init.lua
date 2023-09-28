AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	
	if not UF then return end
	
	self:SetModel("models/lilly/uf/stations/dfi.mdl")
	self:DropToFloor()
	self.ValidLines = {["01"] = true, ["02"] = true, ["03"] = true, ["08"] = true}
	
	self.DisplayedTrains = {}
	
	self.LastRefresh = CurTime()
	self.HasRefreshed = true
	
	self.NearestNodes = Metrostroi.NearestNodes(self:GetPos())
	self.Position = self:GetPos()
	
	self.TrackPosition = Metrostroi.GetPositionOnTrack(self.Position,self:GetAngles())[1] --Based on the Metrostroi tracking system, where is the display?
	self.ScannedTrains = {}
	
	self.Mode = 0
	
	self.WorkTable = {}
	self.FilteredTable = {}
	self.SortedTable = {}
	self.Themes = {[1] = "Frankfurt", [2] = "Duesseldorf", [3] = "Essen", [4] = "Hannover"}
	self.CurrentTheme = self.Themes[1]
end

function ENT:DumpTable(table, indent)
	indent = indent or 0
	for key, value in pairs(table) do
		if type(value) == "table" then
			print(string.rep("  ", indent) .. key .. " = {")
			self:DumpTable(value, indent + 1)
			print(string.rep("  ", indent) .. "}")
		else
			print(string.rep("  ", indent) .. key .. " = " .. tostring(value))
		end
	end
end

function ENT:Think()
	self.BaseClass:Think()
	self.TrackPosition = Metrostroi.GetPositionOnTrack(self.Position,self:GetAngles())[1]
	self:SetNW2Int("Mode", self.Mode)
	self:SetNW2String("Theme",self.CurrentTheme)
	



	
	if not next(UF.IBISRegisteredTrains) then --either fall back to idle, train list, or current train display
		self.Mode = 0
	elseif self.Mode == 0 and next(UF.IBISRegisteredTrains) then
		self.Mode = 1
	end

	
	
	
	if self.Mode > 0 then
		
		if CurTime() - self.LastRefresh > 20 then
			self.LastRefresh = CurTime()
			print("Refreshing DFI")
			self.ScannedTrains = self:ScanForTrains()
		end
	end

	if not self.ScannedTrains then return end --just quit if there's nothing to work with
	--process everything into the list to be displayed on screen
	local subtables = {}
	-- Extract key-value pairs from the table and store them as subtables
	for key, value in pairs(self.ScannedTrains) do
		--self.ScannedTrains[k] = math.abs(k)
		local subtable = {}
		subtable[key] = value
		table.insert(subtables, subtable)
	end
	self.Train1, self.Train2, self.Train3, self.Train4 = unpack(subtables)  --take apart that table
	if self.Train1 then
		for k,v in pairs(self.Train1) do
			local Train = k
			self.Train1Line = string.sub(Train.IBIS.Course,1,2)
			self.Train1Destination = Train:GetNW2String("IBIS:DestinationText","ERROR")
			self.Train1ETA = tostring(math.Round(math.Round(self.Train1[k] / 60)))
			self.Train1ConsistLength = #Train.WagonList
			self.Train1Vector = Train:GetPos()
		end
	end
	if self.Train2 then
		for k,v in pairs(self.Train2) do
			local Train = k
			self.Train2Line = string.sub(Train.IBIS.Course,1,2)
			self.Train2Destination = Train:GetNW2String("IBIS:DestinationText","ERROR")
			self.Train2ETA = tostring(math.Round(math.Round(self.Train2[k] / 60)))
			self.Train2ConsistLength = #Train.WagonList
		end
	else
		self.Train2Line = " " 
		self.Train2Destination = " "
		self.Train2ETA = " "
	end
	if self.Train3 then
		for k,v in pairs(self.Train3) do
			local Train = k
			self.Train3Line = string.sub(Train.IBIS.Course,1,2)
			self.Train3Destination = Train:GetNW2String("IBIS:DestinationText","ERROR")
			self.Train3ETA = tostring(math.Round(math.Round(self.Train3[k] / 60)))
			self.Train3ConsistLength = #Train.WagonList
		end
	else
		self.Train3Line = " " 
		self.Train3Destination = " "
		self.Train3ETA = " "
	end
	if self.Train4 then
		for k,v in pairs(self.Train4) do
			local Train = k
			self.Train4Line = string.sub(Train.IBIS.Course,1,2)
			self.Train4Destination = Train:GetNW2String("IBIS:DestinationText","ERROR")
			self.Train4ETA = tostring(math.Round(math.Round(self.Train4[k] / 60)))
			self.Train4ConsistLength = #Train.WagonList
		end
	else
		self.Train4Line = " " 
		self.Train4Destination = " "
		self.Train4ETA = " "
	end
	
	self:SetNW2String("Train1Line",self.Train1Line)
	self:SetNW2String("Train1Destination",self.Train1Destination)
	self:SetNW2String("Train1Time",self.Train1ETA)
	self:SetNW2Int("Train1ConsistLength",self.Train1ConsistLength)
	
	self:SetNW2String("Train2Line",self.Train2Line)
	self:SetNW2String("Train2Destination",self.Train2Destination)
	self:SetNW2String("Train12Time",self.Train2ETA)
	
	self:SetNW2String("Train3Line",self.Train3Line)
	self:SetNW2String("Train3Destination",self.Train3Destination)
	self:SetNW2String("Train3Time",self.Train3ETA)
	
	self:SetNW2String("Train4Line",self.Train4Line)
	self:SetNW2String("Train4Destination",self.Train4Destination)
	self:SetNW2String("Train4Time",self.Train4ETA)

	if not next(UF.IBISRegisteredTrains) then --either fall back to idle, train list, or current train display
		self.Mode = 0
		
	elseif tonumber(self.Train1ETA) > 0 then
		self.Mode = 1
	elseif tonumber(self.Train1ETA) == 0 or self.Train1Vector and self.Position:Distance(self.Train1Vector) < 2 then
		self.Mode = 2
	end
	
end

function ENT:ScanForTrains() --scrape all trains that have been logged into RBL, sort by distance, and display sorted by ETA
	
	
	if not next(UF.IBISRegisteredTrains) then return end --No point in doing anything if there isn't a single train registered / table is empty
	self.SortedTable = {}
	-- Copy a simple list of registered trains
	if not next(self.WorkTable) then
		for k,_ in pairs(UF.IBISRegisteredTrains) do
			table.insert(self.WorkTable,k)
			--print("insert to worktable",k)
		end
	end
	
	if #self.WorkTable > 4 then --let's cut it short. The display only ever does four different trains.
		
		-- Desired number of pairs to keep
		local desiredPairCount = 4
		
		-- Iterate through the table and remove excess pairs
		local currentPairCount = 0
		for key, value in pairs(self.WorkTable) do
			currentPairCount = currentPairCount + 1
			if currentPairCount > desiredPairCount then
				self.WorkTable[key] = nil
			end
		end
	end
	
	for k,v in pairs(self.WorkTable) do
		--print(k,v)
		if self.WorkTable[k] ~= v then --only insert into work table when it isn't already there
			table.insert(self.WorkTable,key)
		end
	end
	if not next(self.WorkTable) then return end --if nothing came of that, just exit
	
	--open a filtered table. there should be some mechanism for defining which lines the display responds to
	
	for k,v in pairs(self.WorkTable) do
		--print("filtered train",v)
		local FilteredTrain = v
		if self.ValidLines[FilteredTrain.IBIS.CourseChar1..FilteredTrain.IBIS.CourseChar2] then
			table.insert(self.FilteredTable,FilteredTrain)
		end
	end
	
	if next(self.FilteredTable) then
		for k, v in pairs(self.FilteredTable) do
			if not self.SortedTable[k] then
				self.SortedTable[v] = self:TrackETA(v) -- Insert a train and its ETA into the table
			else
				break
			end
		end
	else
		return
	end
	
	
	
	if next(self.SortedTable) then --now actually sort the table if it exists
		table.sort(self.SortedTable,function(a, b) return a[2] > b[2] end)
	else
		return
	end
	
	self.WorkTable = {}--reset the table for next run
	self.FilteredTable = {}
	return self.SortedTable --return the shite
	
end

function ENT:TrackETA(train) --universal function for having Metrostroi calculate the ETA
	
	if train then
		local TrainPosOnTrack = Metrostroi.GetPositionOnTrack(train:GetPos(),train:GetAngles())[1] --input the train's world vector and get its position on the node system
		return Metrostroi.GetTravelTime(TrainPosOnTrack.node1,self.TrackPosition.node1) --return the travel time between the train and the display
	else
		return nil
	end
end

function ENT:Compare(a, b)
	return a < b
end

