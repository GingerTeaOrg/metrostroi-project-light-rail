AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
	self.Rag = ents.Create( "prop_ragdoll" )
	self.Rag:SetModel( "models/lilly/uf/structures/overhead_wire/wire_standard.mdl" )
	self.Rag:SetPos( self:GetPos() + Vector( 0, 0, 90 ) )
	self.Rag:SetAngles( self:GetAngles() + Angle( 0, -90, 0 ) )
	self.Rag:SetOwner( self )
	self.Rag.PhysgunDisabled = true
	self.Rag:Spawn()
	-- wake all physics bones
	local physCount = self.Rag:GetPhysicsObjectCount()
	for i = 0, physCount - 1 do
		local phys = self.Rag:GetPhysicsObjectNum( i )
		if IsValid( phys ) then
			phys:Sleep()
			phys:EnableMotion( false )
			phys:EnableGravity( false )
		end
	end

	self:DrawShadow( false )
	self.BoneMatrix = {}
	self.BoneNames = {}
	self.BoneLengths = {}
	self.DefaultBonePositions = {}
	self.DefaultBoneAngles = {}
	local count = self.Rag:GetBoneCount()
	for i = 0, count - 1 do
		self.BoneMatrix[ i ] = self.Rag:GetBoneMatrix( i )
		self.BoneNames[ i ] = self.Rag:GetBoneName( i )
		self.BoneLengths[ i ] = self.Rag:BoneLength( i )
		local phys = self.Rag:TranslateBoneToPhysBone( i )
		phys = self.Rag:GetPhysicsObjectNum( phys )
		if IsValid( phys ) then
			self.DefaultBonePositions[ i ] = phys:GetPos()
			self.DefaultBoneAngles[ i ] = phys:GetAngles()
			phys:Wake()
			phys:SetPos( self.DefaultBonePositions[ i ] )
			phys:SetAngles( self.DefaultBoneAngles[ i ] )
		end
	end
	--self:ManipulateGivenBone( "top_end", Angle( 0, 0, 15 ) )
	--self:ManipulateGivenBone( "bottom_end", Angle( 0, 15, 0 ) )
end

function ENT:Think()
	return true
end

function ENT:ManipulateGivenBone( bone, angle, vector )
	local boneFound = -1
	for i in ipairs( self.BoneNames ) do
		if self.BoneNames[ i ] == bone then
			boneFound = i
			break
		end
	end

	if boneFound == -1 then
		print( "No bone found!!" )
		return false
	end

	local phys = self.Rag:GetPhysicsObjectNum( boneFound )
	if IsValid( phys ) then
		if angle then
			local oldAngle = phys:GetAngles()
			local oldLocalAngle = self:WorldToLocalAngles( oldAngle )
			local finalAngle = oldLocalAngle + angle
			finalAngle = self:LocalToWorldAngles( finalAngle )
			phys:SetAngles( finalAngle )
		elseif vector then
			phys:SetPos( phys:LocalToWorld( phys:WorldToLocal( phys:GetPos() ) + vector ) )
		end
	end
end

function ENT:OnRemove()
	if IsValid( self.Rag ) then self.Rag:Remove() end
end