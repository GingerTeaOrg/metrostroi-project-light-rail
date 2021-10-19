// Created by Crowbar 0.71

$modelname "lilly/uf/u2/cab/kombihebel.mdl"

$staticprop

$bodygroup "body"
{
	studio "kombihebel.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0.021 0 1.5

$mostlyopaque

$cdmaterials "models\lilly\uf\u2\cab\"

$cbox 0 0 0 0 0 0

$bbox -0.722 -1.903 -1.913 0.722 1.945 4.913

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$poseparameter "position" 0 3 loop 0

$animation "p1" "kombihebel_anims\p1.smd" {
	fps 30
}

$sequence "throttle" {
	"p1"
}
