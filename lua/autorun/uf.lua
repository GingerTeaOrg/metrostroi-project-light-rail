
if not UF then
    -- Global library
    UF = {}
    print("UF Library starting")
    -- Supported train classes
    UF.TrainClasses = {}
    UF.IsTrainClass = {}
    UF.SpawnedTrains = {}
    -- Supported train classes
    UF.TrainSpawnerClasses = {}
    timer.Simple(0.05, function()
        for name in pairs(scripted_ents.GetList()) do
            local prefix = "gmod_subway_uf_"
            if string.sub(name,1,#prefix) == prefix and scripted_ents.Get(name).Base == "gmod_subway_base" and not scripted_ents.Get(name).NoTrain then
                table.insert(UF.TrainClasses,name)
                UF.IsTrainClass[name] = true
            end
        end
        
        
        
        
    end)
    
end

timer.Create("RBLHousekeeping", 30, 0, function()
    for name in pairs(ents.GetAll()) do
        local prefix = "gmod_subway_uf_"
        if string.sub(name,1,#prefix) == prefix and name ~= "gmod_subway_uf_u2_section_b" then --fixme: don't hardcode entity names!
            print("Did housekeeping on entity", name)
            UF.IBISRegisteredTrains[name] = name.IBIS.Course
            
        end
    end
end)

hook.Add("EntityRemoved","UFTrains",function(ent)
    --[[if UF.SpawnedTrains[ent] then
    UF.SpawnedTrains[ent] = nil
    
end]]
for i, v in pairs(UF.IBISRegisteredTrains) do
    if i == ent then
        UF.SpawnedTrains[ent] = nil
        print("Cleared entity at index: ", i)
    end
end

end)
if SERVER then
    hook.Add("OnEntityCreated","UFTrains",function(ent)
        local prefix = "gmod_subway_uf_"
        if string.sub(ent:GetClass(), 1, #prefix) == prefix then
            UF.SpawnedTrains[ent] = true
        end
    end)
else
    hook.Add("OnEntityCreated","UFTrains",function(ent)
        if ent:GetClass() == "gmod_subway_uf" then
            UF.SpawnedTrains[ent] = true
        end
    end)
end

UF.IBISAnnouncementFiles = {}
UF.IBISAnnouncementScript = {}
UF.IBISCommonFiles = {}
UF.SpecialAnnouncementsIBIS = {}
UF.IBISSetup = {}
UF.IBISDestinations = {}
UF.IBISRoutes = {}
UF.IBISLines = {}
UF.TrainPositions = {}
UF.Stations = {}
UF.TrainCountOnPlayer = {}
UF.IBISRegisteredTrains = {}
UF.IBISAnnouncementMetadata = {}

function UF.checkDuplicateTrain(train, LC)
    local foundDuplicate = false -- Initialize variable to track duplicate value
    for key, value in pairs(UF.IBISRegisteredTrains) do
        -- Check if the value is equal to the target
        if key ~= train and LC == value then
            foundDuplicate = true -- Found a duplicate value
            break -- Exit the loop since a duplicate value is found
        elseif key==train and value ~= LC or key==train and value == LC then
            foundDuplicate = false
            break
        end
    end
    
    return foundDuplicate -- Return true if no duplicate value found, false otherwise
end



function UF.RegisterTrain(LineCourse, train) --Registers a train for the RBL simulation
    
    local output
    -- Step 1: Check if LineCourse and train are falsy values
    if not LineCourse and not train then
        -- Print statement for Step 1
        print("LineCourse and train are falsy values. Exiting function.")
            return -- Return without performing any further actions
        end
        if LineCourse == "0000" and next(UF.IBISRegisteredTrains) ~= nil then
            -- If the input is all zeros, we delete ourselves from the table
            for i, v in pairs(UF.IBISRegisteredTrains) do
                if i == train then
                    UF.IBISRegisteredTrains[i] = nil
                    print("RBL: Logging IBIS off")
                end
            end
            output = "logoff"
            return output     
            -- Step 2: Check if UF.IBISRegisteredTrains table is empty
        elseif next(UF.IBISRegisteredTrains) == nil and LineCourse ~= "0000" and train.IBIS.LineTable[string.sub(LineCourse,1,2)] ~= nil then
            -- Print statement for Step 2
            print("RBL: Table is empty. Registering train.")
            
            -- Step 3a: Insert train into UF.IBISRegisteredTrains table
            --local line = table.insert(UF.IBISRegisteredTrains, train)
            
            -- Step 3b: Assign LineCourse to the LineCourse field of the newly inserted train
            
            UF.IBISRegisteredTrains[train] = LineCourse
            print(train, LineCourse)
            -- Print statement for Step 3
            print("RBL: Train registered successfully with LineCourse:", LineCourse)
            
            output = true -- Return true to indicate successful registration
            return output
        elseif LineCourse ~= "0000" and #LineCourse == 4 and UF.IBISRegisteredTrains[train] == LineCourse then
            
            print("Train is already registered by this exact Course. Doing Nothing.")
            output = true
            return output
            
        elseif LineCourse ~= "0000" and train.IBIS.LineTable[string.sub(LineCourse,1,2)] ~= nil and #LineCourse == 4 and UF.IBISRegisteredTrains[train] ~= LineCourse and UF.checkDuplicateTrain(train, LineCourse) == true then
            -- Print statement for Step 4
            print("UF.IBISRegisteredTrains table is not empty. Checking for existing registrations.")
            --local complete
            --if not complete then
            
            -- Step 4: Iterate over UF.IBISRegisteredTrains table
            
            -- Print statement for Step 4b
            print("RBL: Another train is already registered on the same line course. Registration failed.")
            
            output = false -- Return false if the train is already registered on the same line course
            return output
        elseif LineCourse ~= "0000" and train.IBIS.LineTable[string.sub(LineCourse,1,2)] ~= nil and #LineCourse == 4 and UF.IBISRegisteredTrains[train] ~= LineCourse and UF.checkDuplicateTrain(train, LineCourse) == false then
            UF.IBISRegisteredTrains[train] = LineCourse
            print("RBL: No conflicting train with LineCourse found. Registering new train.", LineCourse)
            output = true
            return output
        end
        --print(output)
        --print(LineCourse)
        return output
end
    
    
    
    function UF.AddIBISCommonFiles(name,datatable)
        if not datatable then return end
        for k,v in pairs(UF.IBISCommonFiles) do
            if v.name == name then
                UF.IBISCommonFiles[k] = datatable
                UF.IBISCommonFiles[k].name = name
                print("Light Rail: Changed \""..name.."\" IBIS announcer common files.")
                return
            end
        end
        local id = table.insert(UF.IBISCommonFiles,datatable)
        UF.IBISCommonFiles[id].name = name
        
        print("Light Rail: Added \""..name.."\" IBIS announcer common files.")
    end

    function UF.AddIBISAnnouncementMetadata(name,datatable)
        if not name and not datatable then return end
        for k,v in pairs(UF.IBISAnnouncementMetadata) do
            if v.name == name then
                UF.IBISAnnouncementMetadata[k] = datatable
                UF.IBISAnnouncementMetadata[k].name = name
                print("Light Rail: Changed \""..name.."\" IBIS announcer Metadata.")
                return
            end
        end
        local id = table.insert(UF.IBISAnnouncementMetadata,datatable)
        UF.IBISAnnouncementMetadata[id].name = name
        
        print("Light Rail: Added \""..name.."\" IBIS announcer Metadata.")
    end

    function UF.AddIBISAnnouncementScript(name,datatable)
        if not name and not datatable then return end
        for k,v in pairs(UF.IBISAnnouncementScript) do
            if v.name == name then
                UF.IBISAnnouncementScript[k] = datatable
                UF.IBISAnnouncementScript[k].name = name
                print("Light Rail: Changed \""..name.."\" IBIS announcer script.")
                return
            end
        end
        local id = table.insert(UF.IBISAnnouncementScript,datatable)
        UF.IBISAnnouncementScript[id].name = name
        
        print("Light Rail: Added \""..name.."\" IBIS announcer script.")
    end
    
    function UF.AddIBISDestinations(name,index)
        if not index or not name then return end
        for k,v in pairs(UF.IBISDestinations) do
            if v.name == name then
                UF.IBISDestinations[k] = index
                UF.IBISDestinations[k].name = name
                print("Light Rail: Loaded \""..name.."\" IBIS station index.")
                return
            end
        end
        local id = table.insert(UF.IBISDestinations,index)
        UF.IBISDestinations[id].name = name
        print("Light Rail: Loaded \""..name.."\" IBIS station index.")
    end
    
    function UF.AddIBISRoutes(name,routes)
        if not name or not routes then return end
        for k,v in pairs(UF.IBISRoutes) do
            if v.name == name then
                UF.IBISRoutes[k] = routes
                UF.IBISRoutes[k].name = name
                
                print("Light Rail: Reloaded \""..name.."\" IBIS Route index.")
                return
            end
        end
        local id = table.insert(UF.IBISRoutes,routes)
        UF.IBISRoutes[id].name = name
        print("Light Rail: Loaded \""..name.."\" IBIS Route index.")
    end
    
    
    
    function UF.AddIBISLines(name,lines)
        if not name or not lines then return end
        for k,v in pairs(UF.IBISLines) do
            if v.name == name then
                UF.IBISLines[k] = lines
                UF.IBISLines[k].name = name
                
                print("Light Rail: Reloaded \""..name.."\" IBIS line index.")
                return
            end
        end
        local id = table.insert(UF.IBISLines,lines)
        UF.IBISLines[id].name = name
        print("Light Rail: Loaded \""..name.."\" IBIS line index.")
    end
    function UF.AddU2Rollsigns(name,lines)
        if not name or not lines then return end
        for k,v in pairs(UF.U2Rollsigns) do
            if v.name == name then
                UF.U2Rollsigns[k] = lines
                UF.U2Rollsigns[k].name = name
                
                print("Light Rail: Reloaded \""..name.."\" U2 Rollsigns.")
                return
            end
        end
        local id = table.insert(UF.U2Rollsigns,lines)
        UF.U2Rollsigns[id].name = name
        print("Light Rail: Loaded \""..name.."\" U2 Rollsigns.")
    end
    
    function UF.AddSpecialAnnouncements(name,soundtable)
        if not name or not soundtable then return end
        
        for k,v in pairs(UF.SpecialAnnouncementsIBIS) do
            if v.name == name then
                UF.SpecialAnnouncementsIBIS[k] = soundtable
                UF.SpecialAnnouncementsIBIS[k].name = name
                
                print("Light Rail: Changed \""..name.."\" IBIS Service Announcements.")
                return
            end
        end
        local id = table.insert(UF.SpecialAnnouncementsIBIS,soundtable)
        UF.SpecialAnnouncementsIBIS[id].name = name
        print("Light Rail: Added \""..name.."\" IBIS Service announcement set.")
    end
    
    
    
    function UF.AddRollsignTex(id,stIndex,texture)
        if not UF.Skins[id] then
            UF.Skins[id] = {}
            if defaults[id] then
                if type(defaults[id]) == "table" then
                    UF.Skins[id].default = defaults[id][1]
                    for i=2,#defaults[id] do
                        UF.AddRollsignTex(id:sub(1,-8),1000+(i-1),defaults[id][i])
                        print("Light Rail: Added Rollsign texture")
                    end
                else
                    UF.Skins[id].default = defaults[id]
                end
            end
        end
        local tbl = UF.Skins[id]
        for k,v in pairs(tbl) do
            if k == index then
                tbl[v] = texture
                return
            end
        end
        tbl[stIndex] = table.insert(tbl,texture)
    end
    
    
    if SERVER then
        if Metrostroi.Paths then
            local options = { z_pad = 256 }
            if Metrostroi.IgnoreEntityUpdates then return end
            print("[!] LIGHT RAIL: Injecting Light Rail Signal Entities into Railnetwork")
            local entities = ents.FindByClass("gmod_track_uf_signal")
            for k,v in pairs(entities) do
                local pos = Metrostroi.GetPositionOnTrack(v:GetPos(),v:GetAngles() - Angle(0,90,0),options)[1]
                if pos then -- FIXME make it select proper path
                    Metrostroi.SignalEntitiesForNode[pos.node1] = 
                    Metrostroi.SignalEntitiesForNode[pos.node1] or {}
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
        
    end


    files = file.Find("uf/IBIS/*.lua","LUA")
    for _,filename in pairs(files) do
        AddCSLuaFile("uf/IBIS/"..filename)
        include("uf/IBIS/"..filename)
    end
function UF.GetTravelTime(src,dest)
	-- Determine direction of travel
	--assert(src.path == dest.path)
	local direction = src.x < dest.x

	-- Accumulate travel time
	local travel_time = 0
	local travel_dist = 0
	local travel_speed = 20
	local iter = 0
	function scan(node,path)
		local oldx
		local oldars
		while (node) and (node ~= dest) do
			local ars_speed
			local ars_joint = Metrostroi.GetARSJoint(node,node.x+0.01,path or true)
			if ars_joint then
				--[[if oldx and oldx ~= ars_joint.TrackPosition.x then
					print(string.format("\t\t\t%.2f:\t%s->%s",(ars_joint.TrackPosition.x - oldx)/18.8,oldars.Name,ars_joint.Name))
				end
				oldx = ars_joint.TrackPosition.x
				oldars = ars_joint]]
				--print(ars_joint.Name)
				local ARSLimit = ars_joint:GetMaxARS()
				--print(ARSLimit)
				if ARSLimit >= 4  then
					ars_speed = ARSLimit*10
				end
				--print(ars_speed)
			end
			if ars_speed then travel_speed = ars_speed end
			--print(string.format("[%03d] %.2f m   V = %02d km/h",node.id,node.length,ars_speed or 0))

			-- Assume 70% of travel speed
			local speed = travel_speed * 0.82

			-- Add to travel time
			travel_dist = travel_dist + node.length
			travel_time = travel_time + (node.length / (speed/3.6))
			node = node.next
			if not node then break end
			if src.path == dest.path and node.branches and node.branches[1][2].path == src.path then scan(node,src.x > node.branches[1][2].x) end
			if src.path == dest.path and node.branches and  node.branches[2] and node.branches[2][2].path == src.path then scan(node,src.x > node.branches[1][1].x) end
			assert(iter < 10000, "OH SHI~")
			iter = iter + 1
		end
	end
	scan(src)

	return travel_time,travel_dist
end
function UF.PredictTrainPositions()
    for train in pairs(Metrostroi.SpawnedTrains) do
        if not IsValid(train) then Metrostroi.SpawnedTrains[train] = nil return end
        local localSpeed = train:GetVelocity():Dot(train:GetAngles():Forward()) * 0.01905
        local pos = Metrostroi.TrainPositions[train];pos = pos and pos[1]
        if not pos then continue end
        if Metrostroi.TrainDirections[train] then
            train.PosX = train.PosX + localSpeed*FrameTime()
        else
            train.PosX = train.PosX - localSpeed*FrameTime()
        end
        train.OldPos = pos.x+train.PosX
    end
end

if Metrostroi.Stations then --inject UF station entities because Metrostroi has its entities hardcoded
    local platforms = ents.FindByClass("gmod_track_uf_platform")
    for _,platform in pairs(platforms) do
        local station = Metrostroi.Stations[platform.StationIndex] or {}
        Metrostroi.Stations[platform.StationIndex] = station

        -- Position
        local dir = platform.PlatformEnd - platform.PlatformStart
        local pos1 = Metrostroi.GetPositionOnTrack(platform.PlatformStart,dir:Angle())[1]
        local pos2 = Metrostroi.GetPositionOnTrack(platform.PlatformEnd,dir:Angle())[1]
        if pos1 and pos2 then
            -- Add platform to station
            local platform_data = {
                x_start = pos1.x,
                x_end = pos2.x,
                length = math.abs(pos2.x - pos1.x),
                node_start = pos1.node1,
                node_end = pos2.node1,
                ent = platform,
            }
            if station[platform.PlatformIndex] then
                print(Format("Metrostroi: Error, station %03d has two platforms %d with same index!",platform.StationIndex,platform.PlatformIndex))
            else
                station[platform.PlatformIndex] = platform_data
            end

            -- Print information
            print(Format("\t[%03d][%d] %.3f-%.3f km (%.1f m) on path %d",
                platform.StationIndex,platform.PlatformIndex,pos1.x*1e-3,pos2.x*1e-3,
                platform_data.length,platform_data.node_start.path.id))
        else
            print(Format("Metrostroi: Error, station %03d platform %d, cant find pos! \n\tStart%s \n\tEnd:%s",platform.StationIndex,platform.PlatformIndex,platform.PlatformStart,platform.PlatformEnd))
        end
    end
end

if SERVER then
    files = file.Find("uf/sv*.lua","LUA")
    for _,filename in pairs(files) do
        AddCSLuaFile("uf"..filename)
        include("uf"..filename)
    end
end