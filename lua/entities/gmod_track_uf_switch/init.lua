AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/metrostroi/signals/box.mdl")
	Metrostroi.DropToFloor(self)
	
	self.ID = 000
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false

	self.InhibitSwitching = false
	self.SignalCaller = {}
	self.LastSignalTime = 0

	self.Left = GetInternalVariable("MetrostroiValueForLeft") or UF.SwitchTable[self.ID["left"]]
	self.Right = self.Left == "main" and "alt" or self.Left == "alt" and "main"

	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos())

	-- Find rotating parts which belong to this switch
	local list = ents.FindInSphere(self:GetPos(),256)
	self.TrackSwitches = {}
	for k,v in pairs(list) do
		if (v:GetClass() == "prop_door_rotating") and (string.find(v:GetName(),"switch")) then
			table.insert(self.TrackSwitches,v)

			timer.Simple(0.05,function()
				debugoverlay.Line(v:GetPos(),self:GetPos(),10,Color(255,255,0),true)
			end)
		end
	end

	UF.UpdateSignalEntities()
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end

function ENT:SendSignal(index,train)
	
	for _,v in pairs(self.SignalCaller) do --insert the train that called the command into a table in order to maintain a precedence of sorts
		if v == train then
			break
		else
			table.insert(self.SignalCaller,train)
		end
	end

	if train ~= self.SignalCaller[1] then return false end --first come, first serve. Only get your command heeded when you're top of the list

	-- Switch to alternate track
	if index == "alt" then self.AlternateTrack = true end
	-- Switch to main track
	if index == "main" then self.AlternateTrack = false end
	
	-- Remember this signal
	self.LastSignal = index
	self.LastSignalTime = CurTime()
	self.LastSignalCaller = self.SignalCaller[1]

end

function ENT:IsTrainInRange(train)
	local pos = self.TrackPosition --the switch coordinates on the node system

	local SwitchVector = Vector(pos.x,pos.y,pos.z) --Get the x y z coordinates and express them as a vector
	local Train = Metrostroi.GetPositionOnTrack(self.SignalCaller[1]:GetPos()) --same for the train
	local TrainVector = Vector(Train.x,Train.y,Train.z)

	if SwitchVector:Distance(TrainVector) <= 10 then
		return true
	end

	return false

end

function ENT:GetSignal()
	if self.InhibitSwitching and self.AlternateTrack then return 1 end
	if self.AlternateTrack then return 3 end
	return 0
end

function ENT:Think()
	-- Reset
	self.InhibitSwitching = false
	
	-- Check if local section of track is occupied or no
	local pos = self.TrackPosition
	if pos then
		local trackOccupied = Metrostroi.IsTrackOccupied(pos.node1,pos.x,pos.forward,"switch")
		if trackOccupied then -- Prevent track switches from working when there's a train on segment
			self.InhibitSwitching = true
		end
	end
	
	-- Force door state state
	if self.AlternateTrack then
		for k,v in pairs(self.TrackSwitches) do v:Fire("Open","","0") end
	else
		for k,v in pairs(self.TrackSwitches) do v:Fire("Close","","0") end
	end
	
	-- Force signal
	if self.LockedSignal then
		self:SendSignal(self.LockedSignal)
	end
	
	-- Return switch to original position
	if (self.InhibitSwitching == false) and (self.AlternateTrack == true) and
	   (CurTime() - self.LastSignalTime > 20.0) then
		self:SendSignal("main")
	end

	if self:IsTrainInRange(self.LastSignalCaller) == false then
		table.remove(self.SignalCaller,1) --at the end of it all, remove the train from the list
	end
	
	-- Process logic
	self:NextThink(CurTime() + 1.0)
	return true
end