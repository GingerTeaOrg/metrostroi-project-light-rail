AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/ron/gm_metro_u6/station/daisy_contact.mdl")
	self:SetSolid( SOLID_NONE )
	
	self.TraceOutput = {}
	self.Tracedata = {}
	self.Tracedata.output = self.TraceOutput
	self.Tracedata.filter = function( ent )
		if !IsValid( ent ) then return false end
		if ent:IsPlayer() then return false end
		local class = ent:GetClass()
		if class == self:GetClass() then return false end

		return true
	end
	self.TargetController = ents.FindByName(self.RonVMF.TargetController)[1]
	if not self.TargetController then print(tostring(self).." Targetcontroller Missing! Searched Name: "..self.RonVMF.TargetController) return end
	self.TargetController:SetNWEntity(self.RonVMF.TriggerMode, self)
	self.isTrain = false
	
	if self.RonVMF.TargetSwitch != nil then
		self.TargetSwitchTable = ents.FindByName(self.RonVMF.TargetSwitch)
		if table.Count(self.TargetSwitchTable) > 1 then print("More then one Targetswitch found.\n"..PrintTable(self.TargetSwitchTable)) return
		elseif IsValid(self.TargetSwitchTable) and table.Count(self.TargetSwitchTable) == 0 then print("No switch named like that found. "..self.RonVMF.TargetSwitch) return
		else
			self.TargetSwitch = self.TargetSwitchTable[1]
			self.SwitchStateNeed = tonumber(self.RonVMF.SwitchState) or 0
		end
	end
end

--------------------------------------------------------------------------------
-- Load key-values defined in VMF
--------------------------------------------------------------------------------
function ENT:KeyValue(key, value)
    self.RonVMF = self.RonVMF or {}
    self.RonVMF[key] = value
end

function ENT:Think()
	if self.RonVMF.TargetSwitch != nil then
		if IsValid(self.TargetSwitch) then
			if self.TargetSwitch:GetSaveTable().m_eDoorState != self.SwitchStateNeed then return end 
		end 
	end
	self.beam_z = self:GetUp() * 128
	self.attnum = self:LookupAttachment( "Tracer" )
	self.att = self:GetAttachment( self.attnum )
	if !self.att then print("Recompile Contact Model with att qc!") return end 
	self.Tracedata.start = self.att.Pos
	self.Tracedata.endpos = self.att.Pos + self.beam_z
	util.TraceLine(self.Tracedata)
	self.trace = self.TraceOutput
	self.TracedEntity = self.trace.Entity 	
	if IsValid(self.TracedEntity) and string.find(self.TracedEntity:GetClass(), "gmod_subway") and self.isTrain == false then
		self.isTrain = true
		if (self.TracedEntity:GetNW2String("RouteNumberLastStation")) != "" or  self.TracedEntity:GetNW2Int("LastStation") != 0 then
		self.TargetController:SetNWEntity(self.RonVMF.TriggerMode.." Trace", self.TracedEntity)
		end
	elseif self.TracedEntity == NULL and self.isTrain == true then
		self.isTrain = false
		self.TargetController:SetNWEntity(self.RonVMF.TriggerMode.." Trace", self.TracedEntity)
	end
end