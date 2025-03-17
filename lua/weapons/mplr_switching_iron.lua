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
    if CLIENT then hook.Add( "PostDrawTranslucentRenderables", "SwitchingIronTarget", SWEP.DrawBox ) end
end

function SWEP:Holster()
    if CLIENT then
        hook.Remove( "PostDrawTranslucentRenderables", "SwitchingIronTarget" )
        return true
    end
    return true
end

if CLIENT then
    function SWEP:PrimaryAttack()
    end

    function SWEP:DoDrawCrosshair()
        return
    end

    function SWEP:DrawBox()
        local owner = self:GetOwner()
        local trace = util.TraceLine( util.GetPlayerTrace( owner ) )
        local traceLocal = ents.FindInSphere( trace.HitPos, 30 )
        cam.Start3D()
        for _, v in ipairs( traceLocal ) do
            if v:GetClass() == "gmod_track_uf_switch" then render.DrawWireframeBox( trace.HitPos, Angle( 0, 0, 0 ), Vector( -24, 0, 0 ), Vector( 24, 24, 24 ), Color( 255, 0, 0 ), true ) end
        end

        cam.End3D()
    end
else
    function SWEP:PrimaryAttack()
        local owner = self:GetOwner()
        local trace = util.TraceLine( util.GetPlayerTrace( owner ) )
        local traceLocal = ents.FindInSphere( trace.HitPos, 30 )
        for _, v in ipairs( traceLocal ) do
            local ent = v
            if ent.AllowSwitchingIron then ent:ManualSwitching( not ent.AlternateTrack, owner ) end
        end
    end

    function SWEP:Think()
    end
end