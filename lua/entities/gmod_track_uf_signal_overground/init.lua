AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString "uf-signal"
util.AddNetworkString "uf-signal-state"

function ENT:Initialize()
	self.Types = { ["Standard"] = "lilly/uf/signals/signal-bostrab-overground.mdl" }
	self:SetModel("lilly/uf/signals/signal-bostrab-overground.mdl")

	self.BlockMode = false
end

function ENT:Think()

end



function ENT:OnRemove()
	UF.UpdateSignalEntities()
end