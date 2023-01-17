ENT.Type            = "anim"

ENT.PrintName       = "Train Wheels"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

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