AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "uf-signal"
util.AddNetworkString "uf-signal-state"

function ENT:Initialize()
	self:SetModel("models/lilly/uf/signals/trafficlight_standard3lens.mdl")
end

function ENT:PreInitalize()
	self.AutostopOverride = nil
	if not self.Routes or self.Routes[1].NextSignal == "" then
		self.AutostopOverride = true
	end
	if self.Sprites then
		for k,v in pairs(self.Sprites) do
			SafeRemoveEntity(v)
			self.Sprites[k] = nil
		end
	end
	self.NextSignals = {}
	--self.Switches = {}
	for k,v in ipairs(self.Routes) do
		if v.NextSignal == "" then
			self.NextSignals[""] = nil--self
		elseif v.NextSignal == "*" then
		else
			if not v.NextSignal then
				ErrorNoHalt(Format("UF: No next signal name in signal %s! Check it now!\n", self.Name))
				self.AutostopOverride = true
			else
				self.NextSignals[v.NextSignal] = Metrostroi.GetSignalByName(v.NextSignal)
				if not self.NextSignals[v.NextSignal] then
					print(Format("UF: Signal %s, signal not found(%s)", self.Name, v.NextSignal))
					self.AutostopOverride = true
				end
			end
		end
	end
	self.MU = false
	for k,v in ipairs(self.Lenses) do
		if v:find("M") then self.MU = true break end
	end
end
function ENT:PostInitalize()
	if not self.Routes or #self.Routes == 0 then print(self, "NEED SETUP") return end
	for k,v in ipairs(self.Routes) do
		if v.NextSignal == "*" and self.TrackPosition then
			local sig
			local cursig = self
			while true do
				cursig = Metrostroi.GetPZBJoint(cursig.TrackPosition.node1,cursig.TrackPosition.x,cursig.TrackDir,false)
				if not IsValid(cursig) then break end
				sig = cursig
				if not cursig.PassOcc then break end
			end
			if IsValid(sig) then
				self.NextSignals["*"] = sig
			else
				self.AutostopOverride = true
				print(Format("UF: Signal %s, cant automaticly find signal", self.Name))
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
				print(Format("UF: %s, switch not found(%s)", self.Name, SwitchName))
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
	if not self.RouteNumberSetup or not self.RouteNumberSetup:find("W") then
		self.GoodInvationSignal = 0
		local index = 1
		for k,v in ipairs(self.Lenses) do
			if v ~= "M" then
				for i = 1,#v do
					if v[i] == "W" then self.GoodInvationSignal = index end
					index = index + 1
				end
			end
		end
	else
		self.GoodInvationSignal = -1
	end
	if self.Left then
		self:SetModel(self.TrafficLightModels[self.SignalType or 0].PZBBoxMittor.model)
	else
		self:SetModel(self.TrafficLightModels[self.SignalType or 0].PZBBox.model)
	end
	self.PostInitalized = false

end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end