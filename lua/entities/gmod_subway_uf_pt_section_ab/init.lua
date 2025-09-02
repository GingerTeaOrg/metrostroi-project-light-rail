AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
ENT.KeyMap = {
	[ KEY_A ] = "ThrottleUp",
	[ KEY_D ] = "ThrottleDown",
	[ KEY_H ] = "BellEngageSet",
	[ KEY_SPACE ] = "DeadmanSet",
	[ KEY_W ] = "ReverserUpSet",
	[ KEY_S ] = "ReverserDownSet",
	[ KEY_P ] = "PantoUpSet",
	[ KEY_O ] = "DoorsUnlockSet",
	[ KEY_I ] = "DoorsLockSet",
	[ KEY_K ] = "DoorsCloseConfirmSet",
	[ KEY_Z ] = "WarningAnnouncementSet",
	[ KEY_J ] = "DoorsSelectLeftToggle",
	[ KEY_L ] = "DoorsSelectRightToggle",
	[ KEY_B ] = "BatteryToggle",
	[ KEY_V ] = "HeadlightsToggle",
	[ KEY_M ] = "Mirror",
	[ KEY_1 ] = "Throttle10Pct",
	[ KEY_2 ] = "Throttle20Pct",
	[ KEY_3 ] = "Throttle30Pct",
	[ KEY_4 ] = "Throttle40Pct",
	[ KEY_5 ] = "Throttle50Pct",
	[ KEY_6 ] = "Throttle60Pct",
	[ KEY_7 ] = "Throttle70Pct",
	[ KEY_8 ] = "Throttle80Pct",
	[ KEY_9 ] = "Throttle90Pct",
	[ KEY_PERIOD ] = "WarnBlinkToggle",
	[ KEY_COMMA ] = "BlinkerLeftToggle",
	[ KEY_PAGEUP ] = "Rollsign1+",
	[ KEY_PAGEDOWN ] = "Rollsign1-",
	-- [KEY_0] = "KeyTurnOn",
	[ KEY_LSHIFT ] = {
		[ KEY_0 ] = "ReverserInsert",
		[ KEY_A ] = "ThrottleUpFast",
		[ KEY_D ] = "ThrottleDownFast",
		[ KEY_S ] = "ThrottleZero",
		[ KEY_H ] = "Horn",
		[ KEY_V ] = "DriverLightToggle",
		[ KEY_COMMA ] = "BlinkerRightToggle",
		[ KEY_B ] = "BatteryDisableToggle",
		[ KEY_PAGEUP ] = "Rollsign+",
		[ KEY_PAGEDOWN ] = "Rollsign-",
		[ KEY_O ] = "OpenDoor1Set"
	},
	[ KEY_LALT ] = {
		[ KEY_PAD_1 ] = "Number1Set",
		[ KEY_PAD_2 ] = "Number2Set",
		[ KEY_PAD_3 ] = "Number3Set",
		[ KEY_PAD_4 ] = "Number4Set",
		[ KEY_PAD_5 ] = "Number5Set",
		[ KEY_PAD_6 ] = "Number6Set",
		[ KEY_PAD_7 ] = "Number7Set",
		[ KEY_PAD_8 ] = "Number8Set",
		[ KEY_PAD_9 ] = "Number9Set",
		[ KEY_PAD_0 ] = "Number0Set",
		[ KEY_PAD_ENTER ] = "EnterSet",
		[ KEY_PAD_DECIMAL ] = "DeleteSet",
		[ KEY_PAD_DIVIDE ] = "DestinationSet",
		[ KEY_PAD_MULTIPLY ] = "SpecialAnnouncementsSet",
		[ KEY_PAD_MINUS ] = "TimeAndDateSet",
		[ KEY_V ] = "PassengerLightsSet",
		[ KEY_D ] = "EmergencyBrakeSet",
		[ KEY_O ] = "HighFloorSet",
		[ KEY_I ] = "LowFloorSet"
	}
}

function ENT:Initialize()
	-- Set model and initialize
	self:SetModel( "models/lilly/uf/pt/section-ab.mdl" )
	self.BaseClass.Initialize( self )
	-- self:SetPos(self:GetPos() + Vector(0,0,0))
	-- Create seat entities
	self.DriverSeat = self:CreateSeat( "driver", Vector( 366, 4, 40 ) )
	self.DriverSeat:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.DriverSeat:SetColor( Color( 0, 0, 0, 0 ) )
	self.FrontStepR = self:CreateFoldingSteps( "front_r" )
	self.Lights = {
		-- Headlight glow
		-- [1] = { "headlight",      Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100, farz=6144,brightness = 4},
		-- Head (type 1)
		[ 2 ] = {
			"glow",
			Vector( 365, -40, -20 ),
			Angle( 0, 0, 0 ),
			Color( 255, 220, 180 ),
			brightness = 1,
			scale = 1.0
		},
		[ 3 ] = {
			"glow",
			Vector( 365, -30, -25 ),
			Angle( 0, 0, 0 ),
			Color( 255, 220, 180 ),
			brightness = 1,
			scale = 1.0
		},
		[ 4 ] = {
			"glow",
			Vector( 365, 30, -25 ),
			Angle( 0, 0, 0 ),
			Color( 255, 220, 180 ),
			brightness = 1,
			scale = 1.0
		},
		[ 5 ] = {
			"glow",
			Vector( 365, 40, -20 ),
			Angle( 0, 0, 0 ),
			Color( 255, 220, 180 ),
			brightness = 1,
			scale = 1.0
		},
		[ 6 ] = {
			"glow",
			Vector( 335, 40, 56 ),
			Angle( 0, 0, 0 ),
			Color( 199, 0, 0 ),
			brightness = 0.5,
			scale = 0.7
		},
		[ 7 ] = {
			"glow",
			Vector( 335, -40, 56 ),
			Angle( 0, 0, 0 ),
			Color( 199, 0, 0 ),
			brightness = 0.5,
			scale = 0.7
		},
		[ 8 ] = {
			"glow",
			Vector( 365, 40, -60 ),
			Angle( 0, 0, 0 ),
			Color( 199, 0, 0 ),
			brightness = 0.5,
			scale = 0.7
		},
		[ 9 ] = {
			"glow",
			Vector( 365, -40, -60 ),
			Angle( 0, 0, 0 ),
			Color( 199, 0, 0 ),
			brightness = 0.5,
			scale = 0.7
		},
		-- Cabin
		[ 10 ] = {
			"dynamiclight",
			Vector( 300, 0, 60 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			distance = 450,
			brightness = 0.3
		},
		-- Salon
		[ 11 ] = {
			"dynamiclight",
			Vector( 0, 0, 60 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			distance = 450,
			brightness = 2
		},
		[ 12 ] = {
			"dynamiclight",
			Vector( 200, 0, 60 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			distance = 450,
			brightness = 2
		},
		[ 13 ] = {
			"dynamiclight",
			Vector( -200, 0, 60 ),
			Angle( 0, 0, 0 ),
			Color( 216, 161, 92 ),
			distance = 450,
			brightness = 2
		}
	}

	self.Anims = {}
end

function ENT:Think()
	if not self.CoreSys and IsValid( self.SectionC ) then self.CoreSys = self.SectionC.CoreSys end
	self:NextThink( CurTime() )
	self.BaseClass.Think( self )
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = CurTime() - self.PrevTime
	self.PrevTime = CurTime()
	self.Speed = math.abs( -self:GetVelocity():Dot( self:GetAngles():Forward() ) * 0.06858 )
	local poseValue = self:Animate( "front_r", 100, 100, 100, 1, 4, false )
	--print( "Pose Value: ", poseValue )
	--print( self.FrontStepR )
	-- Apply pose parameter
	--if IsValid( self.FrontStepR ) then self.FrontStepR:SetPoseParameter( "position", poseValue ) end
	return true
end

--------------------------------------------------------------------------------
-- Animation function
--------------------------------------------------------------------------------
function ENT:Animate( Prop, targetValue, min, max, speed, damping )
	local id = Prop
	local function sign( x )
		if x > 0 then
			return 1
		elseif x < 0 then
			return -1
		else
			return 0
		end
	end

	if not self.Anims then self.Anims = {} end
	if not self.Anims[ id ] then
		-- Initialize only once
		self.Anims[ id ] = {
			val = targetValue,
			V = 0.0
		}
	end

	-- Ensure DeltaTime is not zero
	if self.DeltaTime <= 0 then
		self.DeltaTime = 0.016 -- Default to 16ms (60 FPS) if DeltaTime is zero or negative
	end

	-- Animation logic
	local currentValue = self.Anims[ id ].val
	local deltaValue = targetValue - currentValue
	-- Increase responsiveness by adjusting the factor
	local interpolationSpeed = speed * self.DeltaTime
	local dampingFactor = damping * self.DeltaTime
	local lerpFactor = math.Clamp( interpolationSpeed, 0, 1 )
	-- Linear interpolation
	self.Anims[ id ].val = currentValue + deltaValue * lerpFactor
	-- Apply damping to reduce overshooting
	self.Anims[ id ].val = self.Anims[ id ].val - ( self.Anims[ id ].val - targetValue ) * dampingFactor
	-- Clamp and return result
	local result = math.Clamp( self.Anims[ id ].val, min, max )
	return result
end

function ENT:OnButtonRelease( button, ply )
end

function ENT:OnButtonPress( button, ply )
	local sys = self.SectionC.CoreSys
	local p = self.Panel
	if sys.ReverserInsertedA then end
	----THROTTLE CODE -- Initial Concept credit Toth Peter
	if sys.ThrottleRate == 0 then
		if button == "ThrottleUp" then sys.ThrottleRate = 3 end
		if button == "ThrottleDown" then sys.ThrottleRate = -3 end
	end

	if sys.ThrottleRate == 0 then
		if button == "ThrottleUpFast" then sys.ThrottleRate = 8 end
		if button == "ThrottleDownFast" then sys.ThrottleRate = -8 end
	end

	if sys.ThrottleRate == 0 then
		if button == "ThrottleUpReallyFast" then sys.ThrottleRate = 10 end
		if button == "ThrottleDownReallyFast" then sys.ThrottleRate = -10 end
	end

	if sys.ReverserLeverState == 0 then
		if button == "ReverserInsert" then
			if self.ReverserInserted == false then
				self.ReverserInserted = true
				self.CoreSys.ReverserInserted = true
				self:SetNW2Bool( "ReverserInserted", true )
				-- PrintMessage(HUD_PRINTTALK, "Reverser is in")
			elseif self.ReverserInserted == true then
				self.ReverserInserted = false
				self.CoreSys.ReverserInserted = false
				self:SetNW2Bool( "ReverserInserted", false )
				-- PrintMessage(HUD_PRINTTALK, "Reverser is out")
			end
		end
	end

	if button == "ReverserUpSet" then
		if not sys.ThrottleEngaged == true then
			if sys.ReverserInserted == true then
				sys.ReverserLeverState = sys.ReverserLeverState + 1
				sys.ReverserLeverState = math.Clamp( sys.ReverserLeverState, -1, 3 )
				-- self.CoreSys:TriggerInput("ReverserLeverState",self.ReverserLeverState)
				-- PrintMessage(HUD_PRINTTALK,self.CoreSys.ReverserLeverState)
			end
		end
	end

	if button == "ReverserDownSet" then
		if not sys.ThrottleEngaged == true and sys.ReverserInserted == true then
			-- self.ReverserLeverState = self.ReverserLeverState - 1
			math.Clamp( sys.ReverserLeverState, -1, 3 )
			-- self.CoreSys:TriggerInput("ReverserLeverState",self.ReverserLeverState)
			sys.ReverserLeverState = sys.ReverserLeverState - 1
			sys.ReverserLeverState = math.Clamp( sys.ReverserLeverState, -1, 3 )
			-- PrintMessage(HUD_PRINTTALK,self.CoreSys.ReverserLeverState)
		end
	end

	if button == "Rollsign1+" then self:SetNW2Bool( "Rollsign1Scroll+" ) end
	if button == "Rollsign1-" then self:SetNW2Bool( "Rollsign1Scroll-" ) end
	if button == "Rollsign+" then self:SetNW2Bool( "RollsignScroll+" ) end
	if button == "Rollsign-" then self:SetNW2Bool( "RollsignScroll-" ) end
end

function ENT:CreateFoldingSteps( pos )
	if pos == "front_r" then
		local step = ents.Create( "prop_dynamic" )
		step:SetModel( "models/lilly/uf/pt/step_r.mdl" )
		step:SetPos( self:LocalToWorld( Vector( 237, 0, 0 ) ) )
		step:SetAngles( self:GetAngles() )
		--step:SetMoveType( MOVETYPE_VPHYSICS )
		step:Spawn()
		step:Activate()
		step:SetCollisionGroup( COLLISION_GROUP_NONE )
		step:PhysicsInit( SOLID_VPHYSICS )
		step:SetSolid( SOLID_VPHYSICS )
		local phys = step:GetPhysicsObject()
		phys:Wake()
		--
		constraint.NoCollide( self, step )
		constraint.Weld( step, self, 0, 0, 0, true, false )
		--step.SpawnPos = self:LocalToWorld( Vector( 0, 0, 0 ) )
		--step.SpawnAng = Angle( 0, 0, 0 )
		table.insert( self.TrainEntities, step )
		return step
	elseif pos == "front_r_back" then
		local step = ents.Create( "prop_physics" )
		step:SetModel( "models/lilly/uf/pt/step_r_back.mdl" )
		constraint.NoCollide( self, step )
		constraint.Weld( step, self, 0, 0, 0, true, false )
		--step.SpawnPos = self:LocalToWorld( Vector( 0, 0, 0 ) )
		step:SetPos( self:LocalToWorld( Vector( 237, 0, 0 ) ) )
		--step.SpawnAng = Angle( 0, 0, 0 )
		step:SetAngles( self:GetAngles() )
		local phys = step:GetPhysicsObject()
		phys:EnableCollisions( true )
		table.insert( self.TrainEntities, step )
		return step
	elseif pos == "front_l" then
		local step = ents.Create( "prop_physics" )
		step:SetModel( "models/lilly/uf/pt/step_r.mdl" )
		constraint.NoCollide( self, step )
		constraint.Weld( step, self, 0, 0, 0, true, false )
		--step.SpawnPos = self:LocalToWorld( Vector( 0, 0, 0 ) )
		step:SetPos( self:LocalToWorld( Vector( 237, 0, 0 ) ) )
		--step.SpawnAng = Angle( 0, 0, 0 )
		step:SetAngles( self:GetAngles() )
		local phys = step:GetPhysicsObject()
		phys:EnableCollisions( true )
		table.insert( self.TrainEntities, step )
		return step
	elseif pos == "front_l_back" then
		local step = ents.Create( "prop_physics" )
		step:SetModel( "models/lilly/uf/pt/step_r_back.mdl" )
		constraint.NoCollide( self, step )
		constraint.Weld( step, self, 0, 0, 0, true, false )
		--step.SpawnPos = self:LocalToWorld( Vector( 0, 0, 0 ) )
		step:SetPos( self:LocalToWorld( Vector( 237, 0, 0 ) ) )
		--step.SpawnAng = Angle( 0, 0, 0 )
		step:SetAngles( self:GetAngles() )
		local phys = step:GetPhysicsObject()
		phys:EnableCollisions( true )
		table.insert( self.TrainEntities, step )
		return step
	end
end