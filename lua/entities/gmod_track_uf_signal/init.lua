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
	self.Name2 = "B2"
	self.Name = self.Name1.."/"..self.Name2
	self:SetPos(self:GetPos() - Vector(0,0,15))
	self.TrackPosition = Metrostroi.GetPositionOnTrack(self:GetPos(),self:GetAngles())[1]

	self.Aspect = "H0"
	self.SpeedLimit = 0

	self.Left = false
end

function ENT:OpenRoute(route)
	self.LastOpenedRoute = route
	if self.Routes[route].Manual then self.Routes[route].IsOpened = true end
	if not self.Routes[route].Switches then return end
	local Switches = string.Explode(",",self.Routes[route].Switches)

	for i1 =1, #Switches do
		if not Switches[i1] or Switches[i1] == "" then continue end

		local SwitchState = Switches[i1]:sub(-1,-1) == "-"
		local SwitchName = Switches[i1]:sub(1,-2)
		--if not self.Switches[SwitchName] then self.Switches[SwitchName] = Metrostroi.GetSwitchByName(SwitchName) end
		if not Metrostroi.GetSwitchByName(SwitchName) then print(self.Name,"switch not found") continue end
		--If route go right from this switch - add it
		if SwitchState ~= (Metrostroi.GetSwitchByName(SwitchName):GetSignal() ~= 0) then
			Metrostroi.GetSwitchByName(SwitchName):SendSignal(SwitchState and "alt" or "main",nil,true)
			--RunConsoleCommand("say","changing",SwitchName)
		end
	end
end

function ENT:CloseRoute(route)
	if self.Routes[route].Manual then self.Routes[route].IsOpened = false end
	if not self.Routes[route].Switches then return end

	local Switches = string.Explode(",",self.Routes[route].Switches)
	for i1 =1, #Switches do
		if not Switches[i1] or Switches[i1] == "" then continue end

		--local SwitchState = Switches[i1]:sub(-1,-1) == "-"
		local SwitchName = Switches[i1]:sub(1,-2)
		--if not self.Switches[SwitchName] then self.Switches[SwitchName] = Metrostroi.GetSwitchByName(SwitchName) end
		if not Metrostroi.GetSwitchByName(SwitchName) then print(self.Name,"switch not found") continue end
		--If route go right from this switch - add it
		if SwitchState ~= (Metrostroi.GetSwitchByName(SwitchName):GetSignal() ~= 0) then
			Metrostroi.GetSwitchByName(SwitchName):SendSignal("main",nil,true)
			--RunConsoleCommand("say","changing",SwitchName)
		end
	end
end




function ENT:PreInitalize()


	self.NextSignals = {}
	--self.Switches = {}
	for k,v in ipairs(self.Routes) do
		if v.NextSignal == "" then
			self.NextSignals[""] = nil--self
		elseif v.NextSignal == "*" then
		else
			if not v.NextSignal then
				ErrorNoHalt(Format("MPLR: No next signal name in signal %s! Check it now!\n", self.Name))
			else
				self.NextSignals[v.NextSignal] = Metrostroi.GetSignalByName(v.NextSignal)
				if not self.NextSignals[v.NextSignal] then
					print(Format("MPLR: Signal %s, signal not found(%s)", self.Name, v.NextSignal))
				end
			end
		end
	end
end
function ENT:PostInitalize()
	if not self.Routes or #self.Routes == 0 then print(self, "NEEDS SETUP") return end
	for k,v in ipairs(self.Routes) do
		if v.NextSignal == "*" and self.TrackPosition then
			local sig
			local cursig = self
			while true do
				cursig = Metrostroi.GetARSJoint(cursig.TrackPosition.node1,cursig.TrackPosition.x,cursig.TrackDir,false)
				if not IsValid(cursig) then break end
				sig = cursig
				if not cursig.PassOcc then break end
			end
			if IsValid(sig) then
				self.NextSignals["*"] = sig
			else
				self.AutostopOverride = true
				print(Format("MPLR: Signal %s, cant automaticly find signal", self.Name))
			end
		end
	end
	local pos = self.TrackPosition
	local node = pos and pos.node1 or nil
	self.Node = node

	self.SwitchesFunction = {}
	self.Switches = {}
	for i = 1,#self.Routes do
		if not self.Routes[i].Switches then continue end

		local Switches = string.Explode(",",self.Routes[i].Switches)
		local SwitchesTbl = {}
		--local GoodSwitches = true
		--Checking all route switches
		for i1 =1, #Switches do
			if not Switches[i1] or Switches[i1] == "" then continue end

			local SwitchState = Switches[i1]:sub(-1,-1) == "-"
			local SwitchName = Switches[i1]:sub(1,-2)
			if not Metrostroi.GetSwitchByName(SwitchName) then
				print(Format("MPLR: %s, switch not found(%s)", self.Name, SwitchName))
				continue
			end
			--If route go right from this switch - add it
			table.insert(SwitchesTbl,{n = SwitchName,s = SwitchState})
		end
		self.Switches[i] = SwitchesTbl
		if #SwitchesTbl == 0 then continue end
		self.SwitchesFunction[i] = function()
			local GoodSwitches = true
			for i1 = 1,#self.Switches[i] do
				if not self.Switches[i][i1] or not IsValid(Metrostroi.GetSwitchByName(self.Switches[i][i1].n)) then continue end
				if self.Switches[i][i1].s ~= (Metrostroi.GetSwitchByName(self.Switches[i][i1].n):GetSignal() > 0) then
					GoodSwitches = false
					break
				end
			end
			return GoodSwitches
		end
	end
	for k,v in pairs(self.Routes) do
		if not v.Lights then continue end
		v.LightsExploded = string.Explode("-",v.Lights)
	end


	self.PostInitalized = false

end

function ENT:OnRemove()
	Metrostroi.UpdateSignalEntities()
	Metrostroi.PostSignalInitialize()
end

function ENT:GetARS(ARSID,Force1_5,Force2_6)
	if self.OverrideTrackOccupied then return ARSID == 2 end
	if not self.ARSSpeedLimit then return false end
	local nxt = self.ARSNextSpeedLimit == 2 and 0 or self.ARSNextSpeedLimit ~= 1 and self.ARSNextSpeedLimit
	return self.ARSSpeedLimit == ARSID or ((self.TwoToSix and not Force1_5 or Force2_6) and nxt and nxt == ARSID and self.ARSSpeedLimit > nxt)
end


function ENT:GetRS()
	if self.OverrideTrackOccupied or not self.TwoToSix or not self.ARSSpeedLimit then return false end
	--if self.ARSSpeedLimit == 1 or self.ARSSpeedLimit == 2 then return false end
	if self.ARSSpeedLimit ~= 0 and self.ARSSpeedLimit== 2 then return false end
	if self.ControllerLogic and self.ControllerLogicOverride325Hz then return self.Override325Hz end
	return (self.ARSSpeedLimit > 4 or self.ARSSpeedLimit == 4 and self.Approve0) and (not self.ARSNextSpeedLimit or self.ARSNextSpeedLimit >= self.ARSSpeedLimit)
end

function ENT:Get325HzAproove0()
	if self.OverrideTrackOccupied or not self.ARSSpeedLimit then return false end
	return self.ARSSpeedLimit == 0 and self.Approve0
end

function ENT:GetMaxARS()
	local ARSCodes = self.Routes[1].ARSCodes
	if not self.Routes[1] or not ARSCodes then return 1 end
	return tonumber(ARSCodes[#ARSCodes]) or 1
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

	if self.Node and self.TrackPosition then
		self.Occupied,self.OccupiedBy,self.OccupiedByNow = Metrostroi.IsTrackOccupied(self.Node, self.TrackPosition.x,self.TrackPosition.forward,self.ARSOnly and "ars" or "light", self)
	end

end
function ENT:ARSLogic(tim)


	if not self.Routes or not self.NextSignals then return end
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


	self:SetNW2String("Type",self.SignalType)


	self:SendUpdate()
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

