AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
function ENT:Initialize()
    self:SetModel( "models/lilly/mplr/scenery/adscreen/adscreen_stationwall.mdl" )
    self.ComicTimer = 0
end

function ENT:Think()
    self:SetNW2Bool( "ChangeComic", CurTime() - self.ComicTimer > 20 )
    if CurTime() - self.ComicTimer > 20 then
        self.ComicTimer = CurTime()
        self:DownloadRandomComic( math.random( 999 ) )
    end
end

function ENT:DownloadRandomComic( rand )
    self:SetNW2Int( "ComicNumber", rand )
end