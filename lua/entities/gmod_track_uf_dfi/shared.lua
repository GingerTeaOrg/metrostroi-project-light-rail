ENT.Type            = "anim"
ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category        = "Metrostroi: Project Light Rail"
ENT.PrintName 		= "Lumino Platform Display (Frankfurt)"

ENT.Spawnable       = true
ENT.AdminOnly       = true
ENT.DoNotDuplicate = true
ENT.AdminSpawnable  = true

ENT.Panel1 = {Vector(100,0,0),Vector(200,-50,0)}
ENT.Panel1Angle = {Angle(0,15,0)}

ENT.Panel2 = {Vector(100,0,0),Vector(200,-50,0)}
ENT.Panel2Angle = {Angle(0,15,0)}


function ENT:PlayOnceFromPos(id,sndname,volume,pitch,min,max,location)
		if self.StopSounds then return end
		self:DestroySound(self.Sounds[id],true)
		self.Sounds[id] = nil
		if sndname == "_STOP" then return end
		self.SoundPositions[id] = {min,max,location}
		self:CreateBASSSound(sndname,function(snd)
			self.Sounds[id] = snd
			self:SetBassParameters(self.Sounds[id],pitch,volume,self.SoundPositions[id],false)
			snd:Play()
		end)
end
function ENT:CreateBASSSound(name,callback,noblock,onerr)
	if self.StopSounds then return end
	--if self.SoundSpawned and name:find(".wav") then return end
	--self.SoundSpawned = true
	sound.PlayFile(Sound("sound/"..name), "3d noplay mono"..(noblock and " noblock" or ""), function( snd,err,errName )
		if not IsValid(self) then destroySound(snd) return end
		if err then
			self:DestroySound(snd)
			if err == 4 or err == 37 then self.StopSounds = true end
			if err ~= 41 then
				MsgC(Color(255,0,0),Format("Sound:%s\n\tErrCode:%s, ErrName:%s\n",name,err,errName))
				if onerr then callback(false) end
			elseif GetConVar("metrostroi_drawdebug"):GetInt() ~= 0 then
				MsgC(Color(255,255,0),Format("Sound:%s\n\tBASS_ERROR_UNKNOWN (it's normal),ErrCode:%s, ErrName:%s\n",name,err,errName))
				self:CreateBASSSound(name,callback)
			end
			return
		elseif not self.Sounds then
			self:DestroySound(snd)
			if onerr then callback(false) end
		else
			callback(snd)
		end
	end )
end