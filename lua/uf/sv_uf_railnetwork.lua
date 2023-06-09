if Metrostroi.Paths then
    
	
	-- List of PZB subsections
	Metrostroi.PZBSubSections = {}
	
	-- Should position updates in switches and signals be ignores
	Metrostroi.IgnoreEntityUpdates = false
end




--------------------------------------------------------------------------------
-- Update list of signal entities and signal positions on track
--------------------------------------------------------------------------------
function UF.UpdateSignalEntities()
	local options = { z_pad = 256 }
	if Metrostroi.IgnoreEntityUpdates then return end
	Metrostroi.SignalEntitiesForNode = {}
	Metrostroi.SignalEntityPositions = {}
	
	local entities = ents.FindByClass("gmod_track_uf_signal")
	for k,v in pairs(entities) do
		local pos = Metrostroi.GetPositionOnTrack(v:GetPos(),v:GetAngles() - Angle(0,90,0),options)[1]
		if pos then -- FIXME make it select proper path
			Metrostroi.SignalEntitiesForNode[pos.node1] = Metrostroi.SignalEntitiesForNode[pos.node1] or {}
			table.insert(Metrostroi.SignalEntitiesForNode[pos.node1],v)

			-- A signal belongs only to a single track
			Metrostroi.SignalEntityPositions[v] = pos
			v.TrackPosition = pos
			v.TrackX = pos.x
		--else
			--print("position not found",k,v)
		end
	end
end


function UF.AddPZBSubSection(node,source)
	local ent = ents.Create("gmod_track_uf_signal")
	if not IsValid(ent) then return end
	
	local tr = Metrostroi.RerailGetTrackData(node.pos - node.dir*32,node.dir)
	if not tr then return end
	
	ent:SetPos(tr.centerpos - tr.up * 9.5)
	ent:SetAngles((-tr.right):Angle())
	ent:Spawn()
	ent:SetLightsStyle(0)
	ent:SetTrafficLights(0)
	ent:SetSettings(0)
	ent:SetIsolatingLight(false)
	ent:SetIsolatingSwitch(false)
	
	-- Add to list of ARS subsections
	UF.PZBSubSections[ent] = true
	UF.PZBSubSectionCount = UF.PZBSubSectionCount + 1
end


--------------------------------------------------------------------------------
-- Update ARS sections (and add additional subsections
--------------------------------------------------------------------------------
function Metrostroi.UpdateARSSections()
	UF.PZBSubSections = {}
	UF.PZBSubSectionCount = 0

	print("Light Rail: Updating ARS subsections...")
	Metrostroi.IgnoreEntityUpdates = true
	for k,v in pairs(Metrostroi.SignalEntityPositions) do
		-- Find signal which sits BEFORE this signal
		local signal = UF.GetPZBJoint(v.node1,v.x,false)
		
		--Metrostroi.GetNextTrafficLight(v.node1,v.x,not v.forward,true)
		if IsValid(k) and signal then
			local pos = Metrostroi.SignalEntityPositions[signal]
			--debugoverlay.Line(k:GetPos(),signal:GetPos(),10,Color(0,0,255),true)

			-- Interpolate between two positions and add intermediates
			local count = 0
			local offset = 0
			local delta_offset = 120 --100
			if (v.path == pos.path) and (pos.x < v.x) then
				--print(Format("Metrostroi: Adding ARS sections between [%d] %.0f -> %.0f m",pos.path.id,pos.x,v.x))
				local node = pos.node1
				while (node) and (node ~= v.node1) do
					if (offset > delta_offset) and (math.abs(node.x - v.x) > delta_offset) then
						UF.AddPZBSubSection(node,signal)
						offset = offset - delta_offset
						count = count + 1
					end
	
					node = node.next
					if node then
						offset = offset + node.length
					end
				end
			end
			--if count == 0 then
				--print("Could not add any signals for",k)
			--end
		end
	end
	Metrostroi.IgnoreEntityUpdates = false
	UF.UpdateSignalEntities()
	
	print(Format("Light Rail: Added %d PZB rail joints",UF.PZBSubSectionCount))
end






--------------------------------------------------------------------------------
-- Get one next traffic light within current isolated segment. Ignores PZB sections.
--------------------------------------------------------------------------------
function UF.GetNextTrafficLight(src_node,x,dir,include_ars_sections,override_type)
	return Metrostroi.ScanTrack(override_type or "light",src_node,function(node,min_x,max_x)
		-- If there are no signals in node, keep scanning
		if (not Metrostroi.SignalEntitiesForNode[node]) or (#Metrostroi.SignalEntitiesForNode[node] == 0) then
			return
		end

		-- For every signal entity in node, check if it rests on path
		for k,v in pairs(Metrostroi.SignalEntitiesForNode[node]) do
			if IsValid(v) and
				(((v:GetTrafficLights() > 0) or include_ars_sections) and (v.TrackX ~= x) and 
				 (v.TrackX >= min_x) and (v.TrackX <= max_x)) then
				return v
			end
		end
	end,x,dir)
end


--------------------------------------------------------------------------------
-- Get next/previous ARS section
--------------------------------------------------------------------------------
function UF.GetPZBJoint(src_node,x,dir)
	return Metrostroi.ScanTrack("pzb",src_node,function(node,min_x,max_x)
		-- If there are no signals in node, keep scanning
		if (not Metrostroi.SignalEntitiesForNode[node]) or (#Metrostroi.SignalEntitiesForNode[node] == 0) then
			return
		end

		-- For every signal entity in node, check if it rests on path
		for k,v in pairs(Metrostroi.SignalEntitiesForNode[node]) do
			if IsValid(v) and
				((not v:GetNoPZB()) and (v.TrackX ~= x) and 
				 (v.TrackX >= min_x) and (v.TrackX <= max_x)) then
				if dir and (v.TrackX > x) then return v end
				if (not dir) and (v.TrackX < x) then return v end
			end
		end
	end,x,dir)
end

--------------------------------------------------------------------------------
-- Get travel time between two nodes in seconds
--------------------------------------------------------------------------------
function UF.GetTravelTime(src,dest)
	-- Determine direction of travel
	assert(src.path == dest.path)
	local direction = src.x < dest.x
	
	-- Accumulate travel time
	local travel_time = 0
	local travel_dist = 0
	local travel_speed = 20
	local node = src
	while (node) and (node ~= dest) do
		local ars_speed
		local ars_joint = UF.GetPZBJoint(node,node.x+0.01,false)
		if ars_joint then
			if ars_joint:GetNominalSignalsBit(14) then ars_speed = 20 end
			if ars_joint:GetNominalSignalsBit(13) then ars_speed = 40 end
			if ars_joint:GetNominalSignalsBit(12) then ars_speed = 60 end
			if ars_joint:GetNominalSignalsBit(11) then ars_speed = 70 end
			if ars_joint:GetNominalSignalsBit(10) then ars_speed = 80 end
		end
		if ars_speed then travel_speed = ars_speed end
		--print(Format("[%03d] %.2f m   V = %02d km/h",node.id,node.length,ars_speed or 0))
		
		-- Assume 70% of travel speed
		local speed = travel_speed * 0.82

		-- Add to travel time
		travel_dist = travel_dist + node.length
		travel_time = travel_time + (node.length / (speed/3.6))
		node = node.next
	end
	
	return travel_time,travel_dist
end


concommand.Add("uf_cleanup_signals", function(ply, _, args)
	if (ply:IsValid()) and (not ply:IsAdmin()) then return end
	
	Metrostroi.IgnoreEntityUpdates = true
	local signals_ents = ents.FindByClass("gmod_track_uf_signal")
	for k,v in pairs(signals_ents) do SafeRemoveEntity(v) end
	local switch_ents = ents.FindByClass("gmod_track_switch")
	for k,v in pairs(switch_ents) do SafeRemoveEntity(v) end
	Metrostroi.IgnoreEntityUpdates = false
end)