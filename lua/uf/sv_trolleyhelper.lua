if not Trolleybus_System and not MPLR.TrolleybusInstalled then return end
-- This code has been derived from the Trolleybus Simulator add-on for Garry's Mod under CreativeCommons-NonCommercial-Attribution-ShareAlike
function MPLR.ReadDataFile( type )
	return file.Read( "uf/trolleybus/data/" .. game.GetMap() .. "/" .. "trafficlights" .. ".txt" ) or file.Read( "uf/trolleybus/data/" .. game.GetMap() .. "/" .. "trafficlights" .. ".lua", "LUA" )
end

function MPLR.LoadTrolleyTrafficLights()
	local data = MPLR.ReadDataFile()
	local entClass
	if data then
		for i = 1, #data do
			entClass = data[ i ].class
			local ent = ents.Create( entClass )
			ent:SetPos( data[ i ].pos )
			ent:SetAngles( data[ i ].ang )
			ent:Spawn()
			if entClass == "gmod_track_mplr_trafficlight_controller" then
				ent:LoadBehaviour( data[ i ].data )
			else
				local controllerID = data[ i ].controllerID
				local controllerEnts = ents.FindByClass( "gmod_track_mplr_trafficlight_controller" )
				for _, v in ipairs( controllerEnts ) do
					if controllerID == v.ID then
						ent.Controller = v
						ent:SetNW2Entity( "Controller", v )
					end
				end
			end
		end
	end
end

function Trolleybus_System.SaveTrafficLights()
	local data = {}
	local entClass = "gmod_track_mplr_trafficlight_controller"
	for k, v in ipairs( ents.FindByClass( entClass ) ) do
		if not v.Data or v.ToRemove then continue end
		local pos, ang = v:GetPos(), v:GetAngles()
		local baseindex = Trolleybus_System.NetworkSystem.GetNWVar( v, "TrafficLightBase" )
		if baseindex then
			local base = Entity( baseindex )
			if IsValid( base ) then pos, ang = base:GetPos(), base:GetAngles() end
		end

		table.insert( data, {
			class = entClass,
			pos = pos,
			ang = ang,
			data = v.Data,
		} )
	end

	entClass = "gmod_track_mplr_trafficlight"
	for k, v in ipairs( ents.FindByClass( entClass ) ) do
		if not v.Data or v.ToRemove then continue end
		local pos, ang = v:GetPos(), v:GetAngles()
		local baseindex = Trolleybus_System.NetworkSystem.GetNWVar( v, "TrafficLightBase" )
		if baseindex then
			local base = Entity( baseindex )
			if IsValid( base ) then pos, ang = base:GetPos(), base:GetAngles() end
		end

		table.insert( data, {
			class = entClass,
			controllerID = v.Controller.ID,
			pos = pos,
			ang = ang,
			data = v.Data,
		} )
	end

	Trolleybus_System.WriteDataFile( "trafficlights", util.TableToJSON( data, true ) )
end