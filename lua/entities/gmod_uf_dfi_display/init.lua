AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/ron/gm_metro_u6/station/daisy_display.mdl")
	self:SetSolid( SOLID_NONE )
	self:SetNWString("TextDepartA", "")
	self:SetNWString("TextDepartB", "")
	self:SetNWString("TextDestA", "")
	self:SetNWString("TextDestB", "")
	self:SetNWString("TextLineA", "Zurzeit kein Zugverkehr!")
	self:SetNWString("TextLineB", "Out of Service!")
end
--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue(key, value)
    self.RonVMF = self.RonVMF or {}
    self.RonVMF[key] = value
	if key == "TrackNumber" then
		self:SetNWInt("TrackNumber", self.RonVMF["TrackNumber"])
	end
end