ENT.Type            = "anim"

ENT.Author          = "LillyWho"
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category        = "U-Bahn Frankfurt Metrostroi"
ENT.Spawnable       = true
ENT.AdminSpawnable  = false

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
physenv.AddSurfaceData([[
"gmod_silent"
{
	"impacthard"	"DoorSound.Null"
	"impactsoft"	"DoorSound.Null"
	"audiohardnessfactor" "0.0"
	"audioroughnessfactor" "0.0"
	"scrapeRoughThreshold" "1.0"
	"impactHardThreshold" "1.0"
	"gamematerial"	"X"
}
"gmod_ice"
{
	"friction"	"0.01"
	"elasticity"	"0.01"
	"audioroughnessfactor" "0.1"
	"gamematerial"	"X"
}
]])