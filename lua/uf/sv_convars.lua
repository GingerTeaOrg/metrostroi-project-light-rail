CreateConVar("mplr_current_limit",4000,FCVAR_ARCHIVE)
CreateConVar("mplr_train_requirewire",1,FCVAR_NOTIFY,"Whether or not Light Rail trains require power from the overhead wire.")

function UF.GetEnergyCost(kWh)
    return kWh*0.08
end

