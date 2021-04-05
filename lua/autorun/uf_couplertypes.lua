if SERVER then
    local OldENT

    local function AddUFCoupler()
        OldENT = ENT
        local ent = scripted_ents.GetStored("gmod_train_coupler")
        if not ent then
            error("Injecting bogey types Failed!(")
        else
            ENT = ent.t
        end
		
		ENT.Types.u4=
			{
				"models/lilly/uf/coupler.mdl",
				Vector(0,0.0,0),Angle(0,0,0),
				nil,
				Vector(4.3,-63,-3.3),Vector(4.3,63,-3.3),
			}
			
			ENT.Types.u2=
		{
			"models/lilly/uf/coupler.mdl",
			Vector(0,0.0,0),Angle(0,0,0),
			nil,
			Vector(4.3,-63,-3.3),Vector(4.3,63,-3.3),
		}
		
		
        ENT = OldENT
    end
    hook.Add("OnGamemodeLoaded","UFCouplerLoader",AddUFCoupler)
end