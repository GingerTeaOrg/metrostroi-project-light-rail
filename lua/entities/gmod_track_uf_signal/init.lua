AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("flux.lua")
include("shared.lua")
util.AddNetworkString "mplr-signal"
util.AddNetworkString "mplr-signal-state"

function ENT:Initialize()
	self.SignalTypes = {["Overground_Large"] = "lilly/uf/signals/signal-bostrab-overground.mdl", ["Underground_Small_Pole"] = "models/lilly/uf/signals/Underground_Small_Pole.mdl", }
	self.SignalType = self.SignalTypes[self:GetInternalVariable("Type") or "Underground_Small_Pole"]

	self:SetModel("models/lilly/uf/signals/Underground_Small_Pole.mdl" or self.SignalType)
	

	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos(),self:GetAngles())[1]
	self.Node = self.TrackPosition.node1

	self.SpeedLimit = 0
	self.Left = false
end

function ENT:FindNextSignalAhead(signal_name)
	--print("Searching for signal", signal_name)
	return Metrostroi.GetSignalByName(signal_name)
end

function ENT:UpdateDistantSignalEnt()
	if IsValid(self.DistantSignalEnt) then return end

	return self:FindNextSignalAhead(self.DistantSignal)
end

function ENT:UpdateSignalAspect()
	
	if not IsValid(self.DistantSignalEnt) then self.Aspect = "H0" return end
	local DistantAspect = self.DistantSignalEnt.Aspect
	
	local Occupied = self:CheckOccupation()
	if not Occupied then
		if DistantAspect == "H0" then --if next signal is danger, we display caution
			self.Aspect = "H2"
		elseif DistantAspect == "H2" then --if next signal is caution, we can display clear
			self.Aspect = "H1"
		elseif DistantAspect == "H1" then --if next signal is clear, we're also clear
			self.Aspect = "H1"
		end	
	elseif Occupied then
		self.Aspect = "H0"
	end
end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end




function ENT:GetMaxARS() --for compatibility reasons, we need to maintain the original function name. That doesn't mean we can't make a proxy with a more memorable name.
	return self:GetSpeedLimit()
end
function ENT:GetSpeedLimit() 
	
end


function ENT:CheckOccupation()

	if not IsValid(self.DistantSignalEnt) then return true end
	local DistantPos = self.DistantSignalEnt.TrackPosition.x
	local MyPos = self.TrackPosition

	for train,_ in pairs(Metrostroi.TrainPositions) do
		local TrainPos = Metrostroi.TrainPositions[train][1].x
		if MyPos.forward then
			if MyPos.x < TrainPos and DistantPos > TrainPos then
				return true
			end
		elseif not MyPos.forward then
			if MyPos.x > TrainPos and DistantPos < TrainPos then
				return true
			end
		end
	end
	return false
end



function ENT:Think()

	self:UpdateSignalAspect()
	self:CheckOccupation()
	self:SetNW2String("Type",self.SignalType)
	
	self:SetNW2String("Aspect",self.Aspect)
	
	if self.Name == "Tbf/A1" then print(self.Occupied,self.DistantSignalEnt,self.DistantSignalEnt.Aspect) end
	self:NextThink(CurTime() + 0.25)
end

--Net functions
--Send update, if parameters have been changed
function ENT:SendUpdate(ply)
	net.Start("mplr-signal")
	net.WriteEntity(self)
	net.WriteString(self.Name)
	net.WriteString(self.Name1)
	net.WriteString(self.Name2)
	net.WriteString(self.DistantSignal)
	net.WriteEntity(self.DistantSignalEnt)
	net.WriteBool(self.Left)
	if ply then net.Send(ply) else net.Broadcast() end
end

--On receive update request, we send update
net.Receive("mplr-signal", function(_, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) or not ent.SendUpdate then return end
	ent:SendUpdate(ply)
end)

