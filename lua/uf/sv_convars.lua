CreateConVar("uf_current_limit",4000,FCVAR_ARCHIVE)
CreateConVar("uf_train_requirewire",1,FCVAR_ARCHIVE,"Whether or not Light Rail trains require power from the overhead wire.")

function Metrostroi.GetEnergyCost(kWh)
    return kWh*0.08
end

