AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 1100

ENT.SyncTable = {
	"ReduceBrake",
	"Highbeam",
	"SetHoldingBrake",
	"DoorsLock",
	"DoorsUnlock",
	"PantographRaise",
	"PantographLower",
	"Headlights",
	"WarnBlink",
	"Microphone",
	"BellEngage",
	"Horn",
	"WarningAnnouncement",
	"PantoUp",
	"DoorsCloseConfirm",
	"ReleaseHoldingBrake",
	"PassengerOverground",
	"PassengerUnderground",
	"SetPointRight",
	"SetPointLeft",
	"ThrowCoupler",
	"Door1",
	"UnlockDoors",
	"DoorCloseSignal",
	"Number1",
	"Number2",
	"Number3",
	"Number4",
	"Number6",
	"Number7",
	"Number8",
	"Number9",
	"Number0",
	"Destination",
	"Delete",
	"Route",
	"DateAndTime",
	"SpecialAnnouncements"
}

function ENT:Initialize()
    self.BaseClass.Initialize(self)
    self:SetModel("models/lilly/mplr/ruhrbahn/b_1970/section-a.mdl")

end