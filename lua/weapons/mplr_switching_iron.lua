SWEP.PrintName = "M:PLR Switching Iron" -- The name of the weapon
SWEP.Author = "lillywho"
SWEP.Contact = "https://steamcommunity.com/id/thegladostroll" --Optional
SWEP.Purpose = "Use this to manually switch points."
SWEP.Instructions = "Look at the point motor and left click."
SWEP.Category = "Metrostroi: Project Light Rail"
SWEP.Spawnable = true
SWEP.AdminOnly = false
------------------------------
SWEP.Primary.Damage = 0
SWEP.DrawAmmo = false
-------------------------
SWEP.Slot = 0
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
-------------------------
SWEP.Primary.ClipSize = -1 -- No clip
SWEP.Primary.DefaultClip = -1 -- No default ammo
SWEP.Primary.Automatic = false -- Not automatic
SWEP.Primary.Ammo = "none" -- No ammo
SWEP.UseHands = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
-------------------------
function SWEP:Equip()
	self:SetHoldType( "passive" )
	self.Fired = false
end

if CLIENT then
	function SWEP:PrimaryAttack()
	end

	function SWEP:DoDrawCrosshair()
		return
	end

	function SWEP:DrawHUD()
		local owner = self:GetOwner()
		local trace = owner:GetEyeTrace()
		local dist = owner:GetPos():Distance( trace.HitPos )
		local traceLocal = ents.FindInSphere( trace.HitPos, 5 )
		cam.Start3D()
		for _, v in ipairs( traceLocal ) do
			if v:GetClass() == "gmod_track_uf_switch" and dist < 30 then render.DrawWireframeBox( v:GetPos(), Angle( 0, 0, 0 ), Vector( -10, 0, 0 ), Vector( 10, 10, 10 ), Color( 255, 0, 0 ), true ) end
		end

		cam.End3D()
	end
else
	function SWEP:PrimaryAttack()
		local owner = self:GetOwner()
		local trace = owner:GetEyeTrace()
		local dist = owner:GetPos():Distance( trace.HitPos )
		local traceLocal = ents.FindInSphere( trace.HitPos, 5 )
		for _, ent in ipairs( traceLocal ) do
			if ent:GetClass() ~= "gmod_track_uf_switch" then
				continue
			elseif ent:GetClass() == "gmod_track_uf_switch" and dist < 30 then
				if not ent.Locked then
					owner():PrintMessage( HUD_PRINTTALK, "This switch is still moving." )
				elseif ent.AllowSwitchingIron then
					ent:ManualSwitching( not ent.AlternateTrack, owner )
					return true
				elseif not ent.AllowSwitchingIron then
					owner():PrintMessage( HUD_PRINTTALK, "This switch doesn't support using the switching iron." )
				end
			else
				return false
			end
		end
	end

	function SWEP:Think()
	end
end