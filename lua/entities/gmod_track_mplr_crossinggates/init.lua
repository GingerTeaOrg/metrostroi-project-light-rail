AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self.TrackPos = MPLR.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.IsClosed = false
	self.DefectFactor = math.random( 0, 1 )
	self.LastDefectCalc = 0
	self.Defect = false
end

function ENT:Think()
	return true
end

function ENT:DefectCalculator()
	if CurTime() - self.LastDefectCalc < 120 then return end
	self.LastDefectCalc = CurTime()
	self.Defect = math.random( 0, 1 ) == self.DefectFactor
end

function ENT:IsStopSignal()
	return true -- TODO: ADD REAL LOGIC, THIS IS JUST TO DEBUG INJECTING OURSELVES INTO THE TROLLEYBUS TRAFFIC SYSTEM
end