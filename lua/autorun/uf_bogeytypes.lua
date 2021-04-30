if SERVER then
    local OldENT

    local function AddUFBogey()
        OldENT = ENT
        local ent = scripted_ents.GetStored("gmod_train_bogey")
        if not ent then
            error("Injecting bogey types Failed!")
        else
            ENT = ent.t
        end
		
		ENT.Types.u2joint=
			{
				"models/lilly/uf/u2/jointbogey.mdl",
				Vector(0,0.0,0),Angle(0,0,0), "models/lilly/uf/wheelset.mdl",
				Vector(0,-61,-14),Vector(0,61,-14),
				nil,
				Vector(4.3,-63,-3.3),Vector(4.3,63,-3.3),
			}
			
			ENT.Types.u2=
		{
			"models/lilly/uf/bogey.mdl",
			Vector(0,0.0,0),Angle(0,0,0), "models/lilly/uf/wheelset.mdl",
			Vector(0,-61,-14),Vector(0,61,-14),
			nil,
			Vector(4.3,-63,-3.3),Vector(4.3,63,-3.3),
		}
		
		
        ENT = OldENT
    end
    hook.Add("OnGamemodeLoaded","UFBogeyLoader",AddUFBogey)
end