AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/metrostroi/signals/box.mdl")
	Metrostroi.DropToFloor(self)
	
	self.ID = self:GetInternalVariable("SwitchID") or self.ID or 000
	-- Initial state of the switch
	self.AlternateTrack = false
	self.AlreadyLocked = false

	self.InhibitSwitching = false
	self.SignalCaller = {}
	self.LastSignalTime = 0

	--self.OpenDoorEqualsSwitchState = self.OpenDoorEqualsSwitchState or self:GetInternalVariable("OpenDoorEqualsSwitchState")

	self.Left = self:GetInternalVariable("PositionCorrespondance") or "alt"

	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos())[1]
	self.TrackPosition = self.TrackPosition.x

	self.TrackSwitches = {}
	table.insert(self.TrackSwitches,self:GetInternalVariable("Blade1"))
	table.insert(self.TrackSwitches,self:GetInternalVariable("Blade2"))

	UF.UpdateSignalEntities()
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end

function ENT:Occupied()
	local pos = self.TrackPosition
	local trackOccupied = Metrostroi.IsTrackOccupied(pos.node1,pos.x,pos.forward,"switch")
	if pos then
		self.InhibitSwitching = trackOccupied
	end
end
function ENT:Think()

	if not self.TrackSwitches then return end
	self:Occupied()
	self:Switching()
	-- Process logic
	self:NextThink(CurTime() + 1.0)
	return true
end
function ENT:Switching()
	if self.Left == "alt" and self.AlternateTrack then
		for k,v in ipairs(self.TrackSwitches) do
			v:Fire("Open","",0,self,self)
		end
	elseif self.Left == "main" and self.AlternateTrack then
		for k,v in ipairs(self.TrackSwitches) do
			v:Fire("Close","",0,self,self)
		end
	elseif self.Left == "main" and not self.AlternateTrack then
		for k,v in ipairs(self.TrackSwitches) do
			v:Fire("Close","",0,self,self)
		end
	elseif self.Left == "alt" and not self.AlternateTrack then
		for k,v in ipairs(self.TrackSwitches) do
			v:Fire("Close","",0,self,self)
		end
	end
end
function ENT:TriggerSwitch(direction,ent)
	if self.InhibitSwitching then return false end
	if direction == "Left" and self.Left == "alt" then
		self.AlternateTrack = true
	elseif direction == "Left" and self.Left == "main" then
		self.AlternateTrack = false
	elseif direction == "Right" and self.Left == "alt" then
		self.AlternateTrack = false
	elseif direction == "Right" and self.Left == "main" then
		self.AlternateTrack = false
	end
end