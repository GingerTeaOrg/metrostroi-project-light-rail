include( "shared.lua" )
-- Bogey-related sounds
ENT.SoundNames = {}
ENT.SoundNames[ "u2_1" ] = "lilly/uf/bogeys/u2/test/downpitch/engine_loop_primary.mp3"
ENT.SoundNames[ "u2_2" ] = "lilly/uf/bogeys/u2/test/downpitch/engine_loop_combined.mp3"
--ENT.SoundNames["u2_3"]  = "lilly/uf/u2/overhaul/u2_engine_secondary.mp3"
ENT.SoundNames[ "u3_1" ] = "lilly/uf/bogeys/u2/motor_primary.wav"
ENT.SoundNames[ "u3_2" ] = "lilly/uf/u3/chopper1.mp3"
--*0.975
--*1.025
ENT.SoundNames[ "flangea" ] = "lilly/uf/bogeys/u2/curvesqueal_a.mp3"
ENT.SoundNames[ "flangeb" ] = "lilly/uf/bogeys/u2/curvesqueal_b.mp3"
ENT.SoundNames[ "flange1" ] = "lilly/uf/bogeys/u2/curvesqueal.mp3"
ENT.SoundNames[ "flange2" ] = "lilly/uf/bogeys/u2/curvesqueal2.mp3"
ENT.SoundNames[ "brakea_loop1" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brakea_loop2" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_loop1" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_loop2" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_loop3" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_loop4" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_loopb" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake2_loop1" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake2_loop2" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_squeal1" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.SoundNames[ "brake_squeal2" ] = "lilly/uf/bogeys/u2/brake_squeal.mp3"
ENT.EngineSNDConfig = {
	{
		{
			"u2_1", --initial speed, 
			80,
			0,
			80,
			1
		},
		{ "u2_2", 40, 30, 80, 1 },
	},
	{
		{
			"u3_1", --initial speed, 
			80,
			10,
			80,
			1
		},
	},
}

--------------------------------------------------------------------------------
function ENT:ReinitializeSounds()
	-- Remove old sounds
	if self.Sounds then
		for k, v in pairs( self.Sounds ) do
			v:Stop()
		end
	end

	-- Create sounds
	self.Sounds = {}
	for k, v in pairs( MPLR.BogeySounds.SoundNames ) do
		--[[local e = self
        if (k == "brake3a") and IsValid(self:GetNW2Entity("TrainWheels")) then
            e = self:GetNW2Entity("TrainWheels")
        end]]
		self.Sounds[ k ] = CreateSound( self, Sound( v ) )
	end

	self.MotorSoundType = nil
end

function ENT:SetSoundState( sound, volume, pitch, name, level )
	if not self.Sounds[ sound ] then
		if MPLR.BogeySounds.SoundNames[ name or sound ] and ( not wheels or IsValid( self:GetNW2Entity( "TrainWheels" ) ) ) then
			self.Sounds[ sound ] = CreateSound( wheels and self:GetNW2Entity( "TrainWheels" ) or self, Sound( MPLR.BogeySounds.SoundNames[ name or sound ] ) )
		else
			return
		end
	end

	local snd = self.Sounds[ sound ]
	if ( volume <= 0 ) or ( pitch <= 0 ) then
		if snd:IsPlaying() then
			snd:ChangeVolume( 0.0, 0 )
			snd:Stop()
		end
		return
	end

	local pch = math.floor( math.max( 0, math.min( 255, 100 * pitch ) ) + math.random() )
	local vol = math.max( 0, math.min( 255, 2.55 * volume ) ) + ( 0.001 / 2.55 ) + ( 0.001 / 2.55 ) * math.random()
	if name ~= false and not snd:IsPlaying() or name == false and snd:GetVolume() == 0 then
		--if not self.Playing[sound] or name~=false and not snd:IsPlaying() or name==false and snd:GetVolume()==0 then
		if level and snd:GetSoundLevel() ~= level then
			snd:Stop()
			snd:SetSoundLevel( level )
		end

		snd:PlayEx( vol, pch + 1 )
	end

	--snd:SetDSP(22)
	snd:ChangeVolume( vol, 0 )
	snd:ChangePitch( pch + 1, 0 )
	--snd:SetDSP(22)
end

function ENT:RegisterCustomSoundFunc( func, name )
	if not type( func ) == "function" or not func and not name then
		assert( "No name given to register under, exiting and falling back to default." )
		return
	end

	self[ name ] = func
	self:SetNW2String( "SoundFunc", name )
end

function ENT:Initialize()
	local customFuncName = self:GetNW2String( "SoundFunc", "none" )
	self.CustomSoundFunc = customFuncName ~= nil and self[ customFuncName ] or nil
	self.MotorPowerSound = 0
	self.PlayTime = { 0, 0 }
	self.SmoothAngleDelta = 0
	self.CurrselfBrakeSqueal = 0
	self:ReinitializeSounds()
end

function ENT:OnRemove()
	if self.Sounds then
		for k, v in pairs( self.Sounds ) do
			v:Stop()
		end

		self.Sounds = {}
	end
end

--------------------------------------------------------------------------------
function ENT:Think()
	self.DeltaTime = RealFrameTime()
	local train = self:GetNW2Entity( "TrainEntity" )
	if self.CustomSoundFunc then
		self:CustomSoundFunc()
	else
		self:DefaultSoundFunc()
	end

	self:FlangeSqueal()
end

function ENT:DefaultSoundFunc()
	-- Get interesting parameters
	local soundsmul = 1
	--[[local streetC,tunnelC = 1,0
    if IsValid(train) then
        
        soundsmul = math.Clamp(tunnelC^0.5+(streetC^0.5)*0.2,0,1)
    end]]
	streetC, tunnelC = 0, 0 --train.StreetCoeff or 0,train.TunnelCoeff or 1
	--soundsmul = math.Clamp(tunnelC^1.5+(streetC^0.5)*0.2,0,1)
	local speed = self:GetSpeed()
	local temp = self.EngineSNDConfig[ self.MotorSoundType ]
	-- Engine sound
	local motorPower = self:GetMotorPower() * ( 1 + math.max( 0, ( speed - 55 ) / 35 ) * 0.4 )
	if self.MotorSoundType ~= self:GetNWString( "MotorSoundType", "u2" ) or self.DisableEngines ~= self:GetNWBool( "DisableEngines" ) then
		if self.MotorSoundType then
			for _, snd in ipairs( self.EngineSNDConfig[ self.MotorSoundType + 1 ] ) do
				self:SetSoundState( snd[ 1 ], 0, 0 )
			end
		end

		self.MotorSoundType = self:GetNWInt( "MotorSoundType", 0 )
		self.DisableEngines = self:GetNWBool( "DisableEngines" )
		self.MotorSoundArr = MPLR.BogeySounds.EngineSNDConfig[ self.MotorSoundType ]
	end

	self.MotorSoundArr = MPLR.BogeySounds.EngineSNDConfig[ self.MotorSoundType ]
	if not self.DisableEngines and self.MotorSoundArr then
		self.MotorPowerSound = math.Clamp( self.MotorPowerSound + ( motorPower - self.MotorPowerSound ) * self.DeltaTime * 3, -1.5, 1.5 )
		local t = RealTime() * 2.5
		local modulation = math.max( 0, ( speed - 60 ) / 30 ) * 0.7 + ( 0.2 + 1.0 * math.max( 0, 0.2 + math.sin( t ) * math.sin( t * 3.12 ) * math.sin( t * 0.24 ) * math.sin( t * 4.0 ) ) ) * math.Clamp( ( speed - 15 ) / 60, 0, 1 )
		local mod2 = 1.0 - math.min( 1.0, math.abs( self.MotorPowerSound ) / 0.1 )
		if ( speed > -1.0 ) and ( math.abs( self.MotorPowerSound ) + modulation ) >= 0.0 then
			local powerVolRamp
			if self.MotorSoundType == 2 then
				powerVolRamp = 0.2 * modulation * mod2 + 6 * math.abs( self.MotorPowerSound )
			else
				powerVolRamp = 0.3 * modulation * mod2 + 2 * math.abs( self.MotorPowerSound )
			end

			local volumemul = math.min( 1, ( speed / 4 ) ^ 3 )
			local motorsnd = math.min( 1.0, math.max( 0.0, 1.25 * math.abs( self.MotorPowerSound ) ) )
			local motorvol = ( soundsmul ^ 0.3 ) * math.Clamp( motorsnd + powerVolRamp, 0, 1 ) * volumemul
			for i, snd in ipairs( self.MotorSoundArr ) do
				local prev = self.MotorSoundArr[ i - 1 ]
				local next = self.MotorSoundArr[ i + 1 ]
				local volume = 1
				if prev and speed <= prev[ 4 ] then
					volume = math.max( 0, 1 - ( prev[ 4 ] - speed ) / ( prev[ 4 ] - snd[ 3 ] ) )
				elseif next and speed > next[ 3 ] then
					volume = math.max( 0, ( snd[ 4 ] - speed ) / ( snd[ 4 ] - next[ 3 ] ) )
				end

				local pitch = math.max( 0, speed / snd[ 2 ] ) + 0.12
				self:SetSoundState( snd[ 1 ], motorvol * volume * ( snd[ 5 ] or 1 ), math.Clamp( pitch, 0, 2 ) )
			end
		end
	end

	--Stop old sounds when we changind brake squeal type
	if self.Async ~= self:GetNWBool( "Async" ) then
		self:SetSoundState( "brake_loop1", 0, 0 )
		self:SetSoundState( "brake_loop2", 0, 0 )
		self:SetSoundState( "brake_loop3", 0, 0 )
		self:SetSoundState( "brake_loop4", 0, 0 )
		self:SetSoundState( "brake_loopb", 0, 0 )
		self:SetSoundState( "brake2_loop1", 0, 0 )
		self:SetSoundState( "brake2_loop2", 0, 0 )
		self:SetSoundState( "brakea_loop1", 0, 0 )
		self:SetSoundState( "brakea_loop2", 0, 0 )
		self.Async = self:GetNWBool( "Async" )
	end

	if self.Async then
		local brakeSqueal = self:GetNW2Float( "BrakeSqueal", 0 )
		if brakeSqueal > 0.0 then
			local nominalSqueal = self:GetNWFloat( "SqualPitch", 1 )
			local secondSqueal = math.Clamp( 1 - ( speed - 2 ) / 5, 0, 1 )
			local squealPitch = nominalSqueal + secondSqueal * 0.05
			local squealVolume = math.Clamp( speed / 2, 0, 1 )
			local volume = brakeSqueal * squealVolume * math.Clamp( 1 - ( speed - 2 ) / 3, 0, 1 )
			self:SetSoundState( "brakea_loop1", volume * ( 1 - secondSqueal * 0.5 ) * 0.4, squealPitch, false, 75 )
			self:SetSoundState( "brakea_loop2", volume * secondSqueal * 0.4, squealPitch, false, 75 )
		elseif self.CurrselfBrakeSqueal > 0 then
			self:SetSoundState( "brakea_loop1", 0, 0 )
			self:SetSoundState( "brakea_loop2", 0, 0 )
		end

		self.CurrselfBrakeSqueal = brakeSqueal
	else
		local brakeSqueal1 = math.max( 0.0, math.min( 2, self:GetNW2Float( "BrakeSqueal1" ) ) )
		if not self.SquealVolume or brakeSqueal1 <= 0 and self.CurrselfBrakeSqueal > 0 or self.SquealType ~= self:GetNW2Int( "SquealType", 1 ) then
			self.SquealType = self:GetNW2Int( "SquealType", 1 )
			self.SquealSound1 = "brake_loop" .. self.SquealType
			self.SquealVolume = self.SquealType == 1 and 0.2 or 1
			self:SetSoundState( "brake_loop1", 0, 0 )
			self:SetSoundState( "brake_loop2", 0, 0 )
			self:SetSoundState( "brake_loop3", 0, 0 )
			self:SetSoundState( "brake_loop4", 0, 0 )
			self:SetSoundState( "brake_loopb", 0, 0 )
			self:SetSoundState( "brake2_loop1", 0, 0 )
			self:SetSoundState( "brake2_loop2", 0, 0 )
		elseif brakeSqueal1 > 0 then
			--local brakeRamp1 = math.min(1.0,math.max(0.0,(speed-10)/50.0))^1.5
			local brakeRamp2 = math.min( 1.0, math.max( 0.0, speed / 3.0 ) )
			local ramp = 0.3 + math.Clamp( ( 40 - speed ) / 40, 0, 1 ) * 0.7
			if self.SquealType <= 4 then
				self:SetSoundState( self.SquealSound1, brakeSqueal1 * ramp * self.SquealVolume, 1 + 0.05 * ( 1.0 - brakeRamp2 ) )
				--[[self:SetSoundState("brake_loop1",typ==1 and soundsmul*brakeSqueal1*ramp*0.2 or 0,1+0.05*(1.0-brakeRamp2))
                self:SetSoundState("brake_loop2",typ==2 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
                self:SetSoundState("brake_loop3",typ==3 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
                self:SetSoundState("brake_loop4",typ==4 and soundsmul*brakeSqueal1*ramp or 0,1+0.05*(1.0-brakeRamp2))
                self:SetSoundState("brake_loopb",typ<=4 and 0*soundsmul*brakeSqueal1*ramp*0.4 or 0,1+0.05*(1.0-brakeRamp2))]]
			elseif self.SquealType <= 7 then
				local loop_h = soundsmul * brakeSqueal1 * ramp * 0.5
				if loop_h > 0.1 and speed > 1.5 then
					if not self.HighLoop then self.HighLoop = math.random() > 0.5 and "brake_squeal2" or "brake_squeal1" end
					self:SetSoundState( self.HighLoop, loop_h * 1.5, 1 )
				elseif loop_h < 0.02 and self.HighLoop then
					self:SetSoundState( self.HighLoop, 0, 0 )
					self.HighLoop = false
				end

				self.StartLoopStrength = loop_h
				if self.SquealType <= 6 then self:SetSoundState( "brake2_loop1", math.Clamp( loop_h * 0.5, 0, 0.5 ), 1 + 0.06 * ( 1.0 - brakeRamp2 ) ) end
				if self.SquealType >= 6 then self:SetSoundState( "brake2_loop2", loop_h * 0.3, 1 + 0.06 * ( 1.0 - brakeRamp2 ) ) end
			end
		end

		self.CurrselfBrakeSqueal = brakeSqueal1
	end
end

function ENT:FlangeSqueal()
	local speed = self:GetSpeed()
	local soundsmul = 1
	-- Generate procedural landscape thingy
	local a = self:GetPos().x
	local b = self:GetPos().y
	local c = self:GetPos().z
	local f = math.sin( c / 200 + a * c / 3e7 + b * c / 3e7 ) --math.sin(a/3000)*math.sin(b/3000)
	-- Calculate flange squeal
	self.PreviousAngles = self.PreviousAngles or self:GetAngles()
	local deltaAngleYaw = math.abs( self:GetAngles().yaw - self.PreviousAngles.yaw )
	deltaAngleYaw = deltaAngleYaw % 360
	if deltaAngleYaw >= 180 then deltaAngleYaw = deltaAngleYaw - 360 end
	local speedAdd = math.max( 1, math.min( 2, 1 - ( speed - 60 ) / 40 ) )
	local deltaAngle = deltaAngleYaw / math.max( 0.1, self.DeltaTime ) * speedAdd
	deltaAngle = math.max( math.min( 1.0, f * 10 ) * math.abs( deltaAngle ), 0 )
	self.PreviousAngles = self:GetAngles()
	-- Smooth it out
	self.SmoothAngleDelta = math.min( 7, self.SmoothAngleDelta + ( deltaAngle - self.SmoothAngleDelta ) * 2 * self.DeltaTime )
	-- Create sound
	local speed_mod = math.min( 1.0, math.max( 0.0, speed / 8 ) )
	local flangea = math.Clamp( ( speed - 18 ) / 25, 0, 1 )
	local x = self.SmoothAngleDelta
	local f1 = math.max( 0, x - 0.5 ) * 0.1
	local f2 = math.max( 0, x - 3 - flangea * 1 ) * 0.6
	local f3 = math.max( 0, x - 4.0 - flangea * 1.5 ) * 0.6
	local t = RealTime()
	local modulation = 1.5 * math.max( 0, 0.2 + math.sin( t ) * math.sin( t * 3.12 ) * math.sin( t * 0.24 ) * math.sin( t * 4.0 ) )
	local pitch40 = math.max( 0.9, 1.0 + ( speed - 40.0 ) / 160.0 )
	--local pitch60 = math.max(0.9,1.0+(speed-60.0)/160.0)
	-- Play it
	self:SetSoundState( "flangea", ( 0.3 + soundsmul * 0.7 ) * speed_mod * math.Clamp( f2, 0, 1 ), pitch40 )
	self:SetSoundState( "flangeb", ( 0.3 + soundsmul * 0.7 ) * speed_mod * math.Clamp( f3 * modulation, 0, 1 ), pitch40 )
	self:SetSoundState( "flange1", ( 0.3 + soundsmul * 0.7 ) * speed_mod * f1 * modulation, pitch40 )
	self:SetSoundState( "flange2", ( 0.3 + soundsmul * 0.7 ) * speed_mod * f1, pitch40 )
end

function ENT:Draw()
	self:DrawModel()
end