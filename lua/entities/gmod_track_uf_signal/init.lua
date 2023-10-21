AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "mplr-signal"
util.AddNetworkString "mplr-signal-state"

function ENT:Initialize()
	self.SignalTypes = {["Overground_Large"] = "lilly/uf/signals/signal-bostrab-overground.mdl", ["Underground_Small_Pole"] = "models/lilly/uf/signals/Underground_Small_Pole.mdl", }
	self.SignalType = self.SignalTypes[self:GetInternalVariable("Type") or "Underground_Small_Pole"]
	
	self.Sprites = {}
	self:SetModel("models/lilly/uf/signals/Underground_Small_Pole.mdl" or self.SignalType)
	self.Name1 = "Tbf"
	self.Name2 = "B1"
	self.Name = self.Name1.."/"..self.Name2
	self:SetPos(self:GetPos() - Vector(0,0,15))
	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos(),self:GetAngles())[1]
	self.Node = self.TrackPosition.node1

	self.BlockSegment = Metrostroi.GetARSJoint(self.TrackPosition.node1,self.TrackPosition.x,self.TrackPosition.forward,false)
	self.Aspect = "H0"
	self.SpeedLimit = 0

	self.Left = false
	UF.UpdateSignalEntities()
end





function ENT:OnRemove()
	Metrostroi.UpdateSignalEntities()
	Metrostroi.PostSignalInitialize()
end


function ENT:GetRS()
	if self.OverrideTrackOccupied or not self.TwoToSix or not self.ARSSpeedLimit then return false end
	--if self.ARSSpeedLimit == 1 or self.ARSSpeedLimit == 2 then return false end
	if self.ARSSpeedLimit ~= 0 and self.ARSSpeedLimit== 2 then return false end
	if self.ControllerLogic and self.ControllerLogicOverride325Hz then return self.Override325Hz end
	return (self.ARSSpeedLimit > 4 or self.ARSSpeedLimit == 4 and self.Approve0) and (not self.ARSNextSpeedLimit or self.ARSNextSpeedLimit >= self.ARSSpeedLimit)
end



function ENT:GetMaxARS()
	local ARSCodes = self.Routes[1].ARSCodes
	if not self.Routes[1] or not ARSCodes then return 1 end
	return tonumber(ARSCodes[#ARSCodes]) or 1
end
function ENT:GetSpeedLimit() --for compatibility reasons, we need to maintain the original function name. That doesn't mean we can't make a proxy with a more memorable name.
	self:GetMaxArs()
end
function ENT:GetMaxARSNext()
	local Routes = self.NextSignalLink and self.NextSignalLink.Routes or self.Routes
	local ARSCodes = Routes[1] and Routes[1].ARSCodes
	local code = tonumber(ARSCodes[#ARSCodes]) or 1
	local This = self:GetMaxARS()
	if not ARSCodes then return This end
	if code > This then return This end

	return tonumber(ARSCodes[#ARSCodes]) or 1
end

function ENT:CheckOccupation()
	--print(self.FoundedAll)
	--if not self.FoundedAll then return end

	if self.Node and  self.TrackPosition then
		self.Occupied,self.OccupiedBy,self.OccupiedByNow = Metrostroi.IsTrackOccupied(self.Node, self.TrackPosition.x,self.TrackPosition.forward,"light", self)
	end
	if self.OccupiedByNowOld ~= self.OccupiedByNow then
		self.OccupiedByNowOld = self.OccupiedByNow
	end

end

function ENT:ARSLogic(tim)


	if not self.NextSignals then return end
	-- Check track occuping
	if not self.Routes[self.Route or 1].Repeater  then
		self:CheckOccupation()
		if self.Occupied then
			if self.Routes[self.Route or 1].Manual then self.Routes[self.Route or 1].IsOpened = false end
		end
		if self.Occupied or not self.NextSignalLink or not self.NextSignalLink.FreeBS then
			self.FreeBS = 0
		else
			self.FreeBS = math.min(30,self.NextSignalLink.FreeBS + 1) -- old 10 freebs - костыль
		end
		if self.FreeBS - (self.OldBSState or self.FreeBS) > 1 then
			local Free = self.FreeBS
			timer.Simple(tim+0.1,function()
				if not IsValid(self) then return end
				if self.NextSignalLink and self.NextSignalLink.FreeBS + 1 - self.OldBSState > 1 then
					self.FreeBS = Free
					self.OldBSState = Free
				end
			end)
			self.FreeBS = self.OldBSState
		end
		self.OldBSState = self.FreeBS
		if self.FreeBS == 1 then
			self.OccupiedBy = self
		elseif self.FreeBS > 1 then
			self.AutostopEnt = nil
		end
		if self.OccupiedByNow ~= self.AutostopEnt and self.AutostopEnt ~= self.CurrentAutostopEnt then
			self.AutostopEnt = nil
		end
	end
	if self.OldRoute ~= self.Route then
		self.InvationSignal = false
		self.AODisabled = false
		self.OldRoute = self.Route
	end
	--Removing NSL
	self.NextSignalLink = nil
	--Set the first route, if no switches in route or no switches
	--or not self.Switches
	if #self.Routes == 1 and (self.Routes[1].Switches == "" or not self.Routes[1].Switches) then
		self.NextSignalLink = self.NextSignals[self.Routes[1].NextSignal]
		self.Route = 1
	else
		local route
		--Finding right route
		for i = 1,#self.Routes do

			--If all switches right - get this route!
			if self.SwitchesFunction[i] and self.SwitchesFunction[i]() and (not self.Routes[i].Manual and not self.Routes[i].Emer or self.Routes[i].IsOpened) then
				--if self.Route ~= i then
				route = i
					--self.NextSignalLink = nil
				--end
			elseif not self.SwitchesFunction[i] and (not self.Routes[i].Manual and not self.Routes[i].Emer or self.Routes[i].IsOpened) then
				route = i
				--self.NextSignalLink = nil
			end
		end
		if self.Route ~= route and (not self.Routes[route] or not self.Routes[route].Emer) then
			self.Route = route
			self.NextSignalLink = false
		else
			if self.Route ~= route then self.Route = route end
			self.NextSignalLink = self.Routes[route] and self.NextSignals[self.Routes[route].NextSignal]
		end
	end
	if self.NextSignalLink == nil then
		if self.Occupied then
			self.NextSignalLink = self
			self.FreeBS = 0
			--self.Route = 1
		end
	end
	if self.Routes[self.Route] then
		if self.Routes[self.Route or 1].Repeater then
			self.RealName = IsValid(self.NextSignalLink) and self.NextSignalLink.RealName or self.Name
		else
			self.RealName = self.Name
		end
		if self.Routes[self.Route or 1].Repeater then
			self.RealName = IsValid(self.NextSignalLink) and self.NextSignalLink.Name or self.Name
			self.ARSSpeedLimit = IsValid(self.NextSignalLink) and self.NextSignalLink.ARSSpeedLimit or 1
			self.ARSNextSpeedLimit = IsValid(self.NextSignalLink) and self.NextSignalLink.ARSNextSpeedLimit or 1
			self.FreeBS = IsValid(self.NextSignalLink) and self.NextSignalLink.FreeBS or 0
		elseif self.Routes[self.Route].ARSCodes then
			local ARSCodes = self.Routes[self.Route].ARSCodes
			self.ARSNextSpeedLimit = IsValid(self.NextSignalLink) and self.NextSignalLink.ARSSpeedLimit or tonumber(ARSCodes[1])
			self.ARSSpeedLimit = tonumber(ARSCodes[math.min(#ARSCodes, self.FreeBS+1)]) or 0
			if self.AODisabled and self.ARSSpeedLimit ~= 2 then self.AODisabled = false end
			if (self.InvationSignal or self.AODisabled) and self.ARSSpeedLimit == 2 then self.ARSSpeedLimit = 1 end
		end
	end
	if self.NextSignalLink ~= false and (self.Occupied or not self.NextSignalLink or not self.NextSignalLink.FreeBS) then
		if self.Routes[self.Route or 1].Manual then self.Routes[self.Route or 1].IsOpened = false end
	end
end

function ENT:Think()
	self.Aspect = "H0"

	self:SetNW2String("Type",self.SignalType)

	timer.Simple(30,function()self:SendUpdate()end)

	self:NextThink(CurTime() + 0.25)
end

--Net functions
--Send update, if parameters have been changed
function ENT:SendUpdate(ply)
	net.Start("mplr-signal")
		net.WriteEntity(self)
		net.WriteString(self.Name or "NOT LOADED")
		net.WriteString(self.Name1)
		net.WriteString(self.Name2)
		net.WriteString(self.Aspect)
		net.WriteBool(self.Left)
	if ply then net.Send(ply) else net.Broadcast() end
end

--On receive update request, we send update
net.Receive("mplr-signal", function(_, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) or not ent.SendUpdate then return end
	ent:SendUpdate(ply)
end)

