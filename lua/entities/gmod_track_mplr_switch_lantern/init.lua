AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:KeyValue( key, value )
	if not self.VMF then self.VMF = {} end
	self.VMF[ key ] = value
end

function ENT:Initialize()
	self:SetModel( self.PoleModel )
	self.PairedSwitch = self:GetNW2Entity( "PairedSwitch", self.VMF and ents.FindByName( self.VMF.PairedSwitch ) )
	self.StraightPosition = self:GetNW2String( "StraightPosition", self.VMF and self.VMF.StraightPosition or "left" )
	self.YOffset = self:GetNW2Float( "Horizontal", self.VMF and tonumber( self.VMF.HorizontalOffset, 10 ) or 0 )
	self.ZOffset = self:GetNW2Float( "Vertical", self.VMF and tonumber( self.VMF.VerticalOffset, 10 ) or 0 )
	self.Rotation = self:GetNW2Float( "Rotation", self.VMF and tonumber( self.VMF.Rotation, 10 ) or 0 )
	self.TrackPos = MPLR.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
	self.Forward = not self.TrackPos.forward
	self.SignalName = self:GetNW2Float( "Name", self.VMF.SignalName )
end

local iter = 0
function ENT:FindNextSwitch( node, iter )
	local iter = iter and iter + 1 or 1
	if iter >= 10 then return MPLR.SwitchEntitiesByNode[ self.TrackPos and self.TrackPos.node1 ] end
	if not self.TrackPos or table.IsEmpty( self.TrackPos ) then
		self.TrackPos = MPLR.GetPositionOnTrack( self:GetPos(), self:GetAngles() )[ 1 ]
		if not self.TrackPos then
			print( "Track position could not be determined!" )
			return
		end

		self.Forward = not self.TrackPos.forward
	end

	if not node or ( not node.next and not node.prev ) then
		print( "NODE NOT VALID! QUITTING!!" )
		return
	end

	debugoverlay.Sphere( node.pos, 10, 5, Color( 255, 0, 0 ), true )
	local nextNode = self.Forward and node.next or node.prev
	local switchNode = MPLR.SwitchEntitiesByNode[ node ]
	if not switchNode then
		print( self, "No switch found at current node. Moving", self.Forward and "forward" or "backward" )
		return self:FindNextSwitch( nextNode, iter )
	else
		print( self, "Found switch at node:", switchNode )
		return switchNode
	end
end

function ENT:Think()
	self:NextThink( CurTime() )
	if not IsValid( self.PairedSwitch ) then
		self.PairedSwitch = self:FindNextSwitch( self.TrackPos.node1 )
		if not IsValid( self.PairedSwitch ) then -- quit if the paired switch ent doesn't actually exist
			return
		end
	end

	local left = self.PairedSwitch.Left
	local statusAlt = self.PairedSwitch.AlternateTrack
	local straight = self.StraightPosition
	local direction = "null"
	if statusAlt then
		if left == "alt" then
			direction = "left"
		elseif left == "main" then
			direction = "right"
		end
	else
		if left == "main" then
			direction = "left"
		elseif left == "alt" then
			direction = "right"
		end
	end

	if direction == straight then
		direction = "straight"
	elseif direction == straight then
		direction = "straight"
	end

	self:SetNW2String( "Direction", direction )
	return true
end