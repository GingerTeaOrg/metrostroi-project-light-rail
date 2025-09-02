CreateConVar( "mplr_current_limit", 4000, FCVAR_ARCHIVE )
CreateConVar( "mplr_train_requirewire", 1, FCVAR_NOTIFY, "Whether or not Light Rail trains require power from the overhead wire.", 0, 1 )
CreateConVar( "mplr_maxtrains", 3, { FCVAR_ARCHIVE }, "Maximum of allowed trains" )
CreateConVar( "mplr_maxwagons", 1, { FCVAR_ARCHIVE }, "Maximum of allowed wagons in 1 train" )
CreateConVar( "mplr_maxtrains_onplayer", 3, { FCVAR_ARCHIVE }, "Maximum of allowed trains by player" )
CreateConVar( "mplr_verbose", 1, { FCVAR_ARCHIVE }, "Enable or disable verbose console logging.", 0, 1 )
CreateConVar( "mplr_rerail_debug", 1, { FCVAR_ARCHIVE }, "Enable or disable rerailer debug", 0, 1 )
CreateConVar( "mplr_signalling_editing_mode", 0, { FCVAR_ARCHIVE }, "Enable or disable signalling editing mode, forcing signals to refresh switch and signal entities ahead of them.", 0, 1 )
cvars.AddChangeCallback( "mplr_voltage", function() MPLR.VoltageChanged() end )
function MPLR.GetEnergyCost( kWh )
    return kWh * 0.08
end

concommand.Add( "mplr_trackinfo_save", function()
    Metrostroi.Save()
    MPLR.Save()
end, nil, "Saves the currently loaded track data to the data file for the current map." )