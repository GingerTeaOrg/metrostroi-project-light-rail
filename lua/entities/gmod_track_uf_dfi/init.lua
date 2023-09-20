AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()

	self:SetModel("models/lilly/uf/stations/dfi.mdl")

	self.ValidLines = {"01", "02", "03", "08"}

	self.DisplayedTrains = {}

	self.LastRefresh = CurTime()
	self.HasRefreshed = true

	self.NearestNodes = Metrostroi.NearestNodes(self:GetPos())
	self.Position = self:GetPos()

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

	local Mode = self:GetNW2Int("Mode", 1)
	if Mode == 1 then

		if CurTime() - self.LastRefresh > 60 then
			self.LastRefresh = CurTime()
			print("Refreshing DFI")
		end
	end
	if not next(UF.IBISRegisteredTrains) then
		self:SetNW2Bool("NothingRegistered", true)
	else
		self:SetNW2Bool("NothingRegistered", false)
	end
	self:TrackETA()
end

function ENT:TrackETA(train)
	local trackpos = Metrostroi.GetPositionOnTrack(self:GetPos())

	if train then end

end

