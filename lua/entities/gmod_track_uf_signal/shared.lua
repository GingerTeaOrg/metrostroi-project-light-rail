ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Signalling Element"
ENT.Category = "Metrostroi: Project Light Rail"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PhysgunDisabled = true
ENT.Lenses = {
    R = Color( 200, 0, 0 ),
    O = Color( 204, 116, 0 ),
    G = Color( 27, 133, 0 ),
    W = Color( 200, 200, 200 ),
}

ENT.SignalTypes = {
    [ "Overground_Large" ] = "lilly/uf/signals/signal-bostrab-overground.mdl",
    [ "Underground_Small_Pole" ] = "models/lilly/uf/signals/Underground_Small_Pole.mdl",
}