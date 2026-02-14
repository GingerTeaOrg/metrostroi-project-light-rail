include( "shared.lua" )
function ENT:ParseLenses( str )
	if not str or #str < 2 then return end
	local result = {}
	-- Use pattern matching to split by space, dash, or underscore
	for token in string.gmatch( str, "[^%s%-%_]+" ) do
		result[ string.lower( token ) ] = true
	end

	if not next( result ) then print( "Signal:", self.SignalName, "has not found any lenses to spawn." ) end
	return result
end

-- format: multiline
net.Receive(
	"UpdateOvergroundSignal", 
	function()
		print( "update" )
		local ent = net.ReadEntity()
		ent.Lenses = net.ReadTable()
	end
)

function ENT:Initialize()
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:DrawShadow( false )
	self.Aspect = {
		[ 1 ] = "F1",
		[ 2 ] = "F4",
		[ 3 ] = "A1_F0"
	}

	self.Columns = self:GetNW2Int( "SignalColumns", 1 )
	local columnString1 = self:GetNW2String( "Column1Lenses" )
	local columnString2 = self:GetNW2String( "Column2Lenses" )
	local columnString3 = self:GetNW2String( "Column3Lenses" )
	local columnString1Processed = string.Explode( "_", columnString1 )
	local columnString2Processed = string.Explode( "_", columnString2 )
	local columnString3Processed = string.Explode( "_", columnString3 )
	local columnTab = {}
	for i = 1, self.Columns do
		local whichTab = i == 1 and columnString1Processed or i == 2 and columnString2Processed or i == 3 and columnString3Processed
		columnTab[ i ] = {}
		for _, v in ipairs( whichTab ) do
			if v ~= "" then -- ignore empties
				columnTab[ i ][ v ] = true
				print( v, columnTab[ i ][ v ] )
			end
		end
	end

	self.Lenses = columnTab
	self.Left = self:GetNW2Bool( "Left", false )
	self.TotalHorizontalOffset = self:GetNW2Float( "HorizontalOffset", 0 )
	self.LateralOffset = self:GetNW2Float( "LateralOffset", 0 )
	self.Rotation = self:GetNW2Float( "Rotation", 0 )
	self.SignalStatesByColumn = {}
	self.LensModels = {}
	self.LensCases = {}
	self.Attachments = {}
	self:SpawnLenses()
end

function ENT:Think()
	local respawnLenses = self:GetNW2Bool( "RespawnLenses", false )
	if respawnLenses then self:RespawnLenses() end
	self:HideShowLenses()
end

function ENT:HideShowLenses()
	local aspect
	for col in ipairs( self.SignalStatesByColumn ) do
		for k in pairs( self.SignalStatesByColumn[ col ] ) do
			aspect = self.Aspect[ col ]
			--print( aspect )
			local lensModel = self.LensModels[ col ][ k ]
			if not IsValid( lensModel ) then self:SpawnLenses() end
			if string.match( aspect, k ) then
				v = true
				lensModel:SetRenderMode( RENDERMODE_NORMAL )
				lensModel:SetColor( Color( 255, 255, 255 ) )
			else
				v = false
				lensModel:SetRenderMode( RENDERMODE_TRANSALPHA )
				lensModel:SetColor( Color( 0, 0, 0, 0 ) )
			end
		end
	end
end

function ENT:RespawnLenses()
	self:OnRemove()
	self:SpawnLenses()
end

function ENT:SpawnLenses()
	-- Init some base model paths
	local lensBasepath = "models/lilly/mplr/signals/trafficlight/sprites/sprite_"
	local lensCase = "models/lilly/mplr/signals/trafficlight/trafficlight_lenscase.mdl"
	-- Add offsets for spawning the actual frames and sprites themselves
	local verticalOffset = 0 -- procedural offset for spawning all signal elements
	local horizontalOffset = 0 -- procedural offset for spawning all signal elements
	local totalHorizontalOffset = self.Left and -50 + self.TotalHorizontalOffset or 50 + self.TotalHorizontalOffset -- offset for the entire signal, to be set by the mapper using the toolgun
	local spriteOffset = -170 --fixed offset for the actual sprites to work off of
	-- loop through columns to spawn frames and sprites 
	self.Columns = self:GetNW2Int( "SignalColumns", 1 )
	for j = 1, self.Columns do
		if not self.SignalStatesByColumn[ j ] then self.SignalStatesByColumn[ j ] = {} end
		for i = 1, #self.LensOrder do
			local lens = self.LensOrder[ i ]
			if self.Lenses[ j ][ lens ] then
				if not self.LensModels[ j ] then self.LensModels[ j ] = {} end
				if not self.LensCases[ j ] then self.LensCases[ j ] = {} end
				self.LensModels[ j ][ lens ] = ents.CreateClientProp( lensBasepath .. lens .. ".mdl" )
				self.SignalStatesByColumn[ j ][ lens ] = false
				table.insert( self.Attachments, self.LensModels[ j ][ lens ] )
				self.LensModels[ j ][ lens ]:SetPos( self:LocalToWorld( Vector( self.LateralOffset + 12.9, totalHorizontalOffset + horizontalOffset, 0 ) ) - Vector( 0, 0, spriteOffset ) )
				spriteOffset = spriteOffset + 15
				self.LensModels[ j ][ lens ]:SetAngles( self:GetAngles() )
				self.LensModels[ j ][ lens ]:Spawn()
				self.LensModels[ j ][ lens ]:SetParent( self )
				self.LensCases[ j ][ lens ] = ents.CreateClientProp( lensCase )
				table.insert( self.Attachments, self.LensCases[ j ][ lens ] )
				self.LensCases[ j ][ lens ]:SetPos( self:LocalToWorld( Vector( self.LateralOffset, totalHorizontalOffset + horizontalOffset, 0 ) ) - Vector( 0, 0, verticalOffset ) )
				self.LensCases[ j ][ lens ]:SetAngles( self:GetAngles() )
				self.LensCases[ j ][ lens ]:Spawn()
				self.LensCases[ j ][ lens ]:SetParent( self )
				verticalOffset = verticalOffset + 15
			end
		end

		-- reset once per column
		verticalOffset = 0
		spriteOffset = -170
		-- move to next column horizontally
		horizontalOffset = horizontalOffset + 18
	end

	-- spawn the pole to attach to
	self.Pole = ents.CreateClientProp( "models/lilly/mplr/signals/trafficlight/trafficlight_pole.mdl" )
	local positionDelta = self.Columns == 1 and 0 or self.Columns == 2 and 7 or self.Columns == 3 and 18
	positionDelta = positionDelta + totalHorizontalOffset
	self.Pole:SetPos( self:LocalToWorld( Vector( self.LateralOffset + 0, positionDelta, 0 ) ) )
	self.Pole:SetAngles( self:GetAngles() )
	self.Pole:SetParent( self )
	self.Pole:Spawn()
	table.insert( self.Attachments, self.Pole )
end

function ENT:OnRemove()
	for _, v in pairs( self.Attachments ) do
		if IsValid( v ) then v:Remove() end
	end
end

function ENT:Draw()
	--self:DrawModel()
end