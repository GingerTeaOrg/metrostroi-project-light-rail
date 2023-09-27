AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	
	if not UF then return end
	
	self:SetModel("models/lilly/uf/stations/dfi.mdl")
	
	self.ValidLines = {["01"] = true, ["02"] = true, ["03"] = true, ["08"] = true}
	
	self.DisplayedTrains = {}
	
	self.LastRefresh = CurTime()
	self.HasRefreshed = true
	
	self.NearestNodes = Metrostroi.NearestNodes(self:GetPos())
	self.Position = self:GetPos()
	
	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos(),self:GetAngles()) --Based on the Metrostroi tracking system, where is the display?
	
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
	self:SetNW2Int("Mode", 1)
	
	local ScannedTrains = {}
	
	local Mode = self:GetNW2Int("Mode", 1)
	if Mode == 1 then
		
		if CurTime() - self.LastRefresh > 60 then
			self.LastRefresh = CurTime()
			print("Refreshing DFI")
			ScannedTrains = self:ScanForTrains()
		end
	end
	if not next(UF.IBISRegisteredTrains) then
		self:SetNW2Bool("NothingRegistered", true)
	else
		self:SetNW2Bool("NothingRegistered", false)
	end
	
	--process everything into the list to be displayed on screen
	local subtables = {}
	-- Extract key-value pairs from the table and store them as subtables
	for key, value in pairs(ScannedTrains) do
		local subtable = {}
		subtable[key] = value
		table.insert(subtables, subtable)
	end
	
	self.Train1, self.Train2, self.Train3, self.Train4 = unpack(subtables)  --take apart that table

	for k,v in (self.Train1) do
		self.Train1Line = string.sub(self.Train1[k].IBIS.Course,1,2)
		self.Train1Destination = self.Train1[k]:GetNW2String("IBIS:DestinationText","ERROR")
		self.Train1ETA = self.Train1[k]
	end

	for k,v in (self.Train2) do
		self.Train2Line = string.sub(self.Train2[k].IBIS.Course,1,2)
		self.Train2Destination = self.Train2[k]:GetNW2String("IBIS:DestinationText","ERROR")
		self.Train2ETA = self.Train2[k]
	end

	for k,v in (self.Train3) do
		self.Train3Line = string.sub(self.Train3[k].IBIS.Course,1,2)
		self.Train3Destination = self.Train3[k]:GetNW2String("IBIS:DestinationText","ERROR")
		self.Train3ETA = self.Train1[k]
	end

	for k,v in (self.Train4) do
		self.Train4Line = string.sub(self.Train4[k].IBIS.Course,1,2)
		self.Train4Destination = self.Train4[k]:GetNW2String("IBIS:DestinationText","ERROR")
		self.Train4ETA = self.Train4[k]
	end

	self:SetNW2String("Train1Line",self.Train1Line)
	self:SetNW2String("Train1Destination",self.Train1Destination)
	self:SetNW2String("Train1Time",self.Train1ETA)

	self:SetNW2String("Train2Line",self.Train2Line)
	self:SetNW2String("Train2Destination",self.Train2Destination)
	self:SetNW2String("Train12Time",self.Train2ETA)

	self:SetNW2String("Train3Line",self.Train3Line)
	self:SetNW2String("Train3Destination",self.Train3Destination)
	self:SetNW2String("Train3Time",self.Train3ETA)

	self:SetNW2String("Train4Line",self.Train4Line)
	self:SetNW2String("Train4Destination",self.Train4Destination)
	self:SetNW2String("Train4Time",self.Train4ETA)
	
end

function ENT:ScanForTrains() --scrape all trains that have been logged into RBL, sort by distance, and display sorted by ETA
	
	
	if not next(UF.IBISRegisteredTrains) then return end --No point in doing anything if there isn't a single train registered / table is empty
	local WorkTable = {} -- Copy a simple list of registered trains
	for key in pairs(UF.IBISRegisteredTrains) do
		for k,v in pairs(WorkTable) do
			if WorkTable[key] ~= v then --only insert into work table when it isn't already there
				table.insert(WorkTable,key)
			else
				break
			end
		end
	end
	
	local FilteredTable = {} --open a filtered table. there should be some mechanism for defining which lines the display responds to
	
	for k,v in pairs(WorkTable) do
		local FilteredTrain = v
		if self.ValidLines[string.sub(FilteredTrain.IBIS.Course,1,2)] then
			table.insert(FilteredTable,FilteredTrain)
		end
	end
	
	local SortedTable = {}
	if next(FilteredTable) then
		for k,v in pairs(FilteredTable) do
			if not SortedTable[v] then
				SortedTable[v] = self.TrackETA(v) --insert a train and its ETA into the table
			else
				break
			end
		end
	else
		return
	end
	
	if next(SortedTable) then --now actually sort the table if it exists
		table.sort(SortedTable,compare())
	else
		return
	end
	
	if #SortedTable > 4 then --We've got it sorted so let's cut it short
		
		-- Desired number of pairs to keep
		local desiredPairCount = 4
		
		-- Iterate through the table and remove excess pairs
		local currentPairCount = 0
		for key, value in pairs(SortedTable) do
			currentPairCount = currentPairCount + 1
			if currentPairCount > desiredPairCount then
				SortedTable[key] = nil
			end
		end
		
		
	end
	return SortedTable --return the shite
	
end

function ENT:TrackETA(train) --universal function for having Metrostroi calculate the ETA
	
	if train then
		local TrainPosOnTrack = Metrostroi.GetPositionOnTrack(train:GetPos()) --input the train's world vector and get its position on the node system
		return Metrostroi.GetTravelTime(TrainPosOnTrack,self.Position) --return the travel time between the train and the display
	end
	
	return nil
	
	
end

local function compare(a, b)
	return a < b
end