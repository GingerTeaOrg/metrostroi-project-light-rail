AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "uf-signal"
util.AddNetworkString "uf-signal-state"

function ENT:Initialize()
	self.Types = { ["Overground"] = "lilly/uf/signals/signal-bostrab-overground.mdl", ["Underground_Pole"] = "lilly/uf/signals/signal-bostrab-underground-pole.mdl", ["Underground_Wallmount"] = "lilly/uf/signals/signal-bostrab-underground-wallmount.mdl" }
	self:SetModel("lilly/uf/signals/signal-bostrab-overground.mdl")

	self.BlockMode = false
end

function ENT:Think()

end

function ENT:OnRemove()
	UF.UpdateSignalEntities()
end