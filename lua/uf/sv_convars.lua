CreateConVar("mplr_current_limit",4000,FCVAR_ARCHIVE)
CreateConVar("mplr_train_requirewire",1,FCVAR_NOTIFY,"Whether or not Light Rail trains require power from the overhead wire.",0,1)
CreateConVar("mplr_maxtrains",3,{FCVAR_ARCHIVE},"Maximum of allowed trains")
CreateConVar("mplr_maxwagons",3,{FCVAR_ARCHIVE},"Maximum of allowed wagons in 1 train")
CreateConVar("mplr_maxtrains_onplayer",1,{FCVAR_ARCHIVE},"Maximum of allowed trains by player")
CreateConVar("mplr_verbose",1,{FCVAR_ARCHIVE},"Enable or disable verbose console logging.",0,1)
function UF.GetEnergyCost(kWh)
    return kWh*0.08
end

