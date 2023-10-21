AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString "MPLRTrainSpawner"
util.AddNetworkString "MPLRTrainCount"
util.AddNetworkString "MPLRMaxWagons"
local function MaxWagonsChangeCallback()
	SetGlobalInt("mplr_maxtrains",GetConVar("mplr_maxtrains"):GetInt())
	SetGlobalInt("mplr_maxtrains_onplayer",GetConVar("mplr_maxtrains_onplayer"):GetInt())
	SetGlobalInt("mplr_maxwagons",GetConVar("mplr_maxwagons"):GetInt())
	timer.Simple(0,function()
		net.Start("MPLRMaxWagons")
		net.Broadcast()
	end)
end

cvars.AddChangeCallback("mplr_maxtrains", MaxWagonsChangeCallback)
cvars.AddChangeCallback("mplr_maxtrains_onplayer", MaxWagonsChangeCallback)
cvars.AddChangeCallback("mplr_maxwagons", MaxWagonsChangeCallback)
local function ShowWindowOnCL(ply, id)
	SetGlobalInt("mplr_train_count",Metrostroi.TrainCount())
	timer.Simple(0,function()
		net.Start("MPLRTrainSpawner")
		--net.WriteTable(Metrostroi.Skins)
		net.Send(ply)
	end)
end
timer.Create("mplr-maxtrains-hook",5,0,MaxWagonsChangeCallback)
function ENT:SpawnFunction(ply, tr)
	if not ply:HasWeapon("gmod_tool") then
		--ply:Give("gmod_tool")
		return
	end
	ShowWindowOnCL(ply)
end
