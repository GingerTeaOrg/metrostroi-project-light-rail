function UF.DebugMyPos()
	local ply = ents.GetByIndex( 1 )
	if not ply then return end
	local pos = Metrostroi.GetPositionOnTrack( ply:GetPos(), ply:GetAngles() )
	local function printTableLimited( table, depth )
		if depth == nil then depth = 0 end
		if depth >= 2 or type( table ) ~= "table" then
			print( table )
			return
		end

		for key, value in pairs( table ) do
			print( key, value )
			if type( value ) == "table" then
				print( "    Subtable:", value )
				for k, v in pairs( value ) do
					print( "     ", v )
					if k == "branches" then
						for id, path in pairs( v ) do
							print( "     ", "     ", id, path )
							for j, y in pairs( path[ 2 ] ) do
								print( "     ", "     ", "     ", j, y )
							end
						end
					end
				end
			end
		end
	end

	printTableLimited( pos[ 1 ], 1 )
end

function UF.DebugPlyPaths()
	local ply = ents.GetByIndex( 1 )
	if not ply then return end
	local pos = Metrostroi.GetPositionOnTrack( ply:GetPos(), ply:GetAngles() )
	local current_path = pos[ 1 ].path.id
	local adjacent_paths = {}
	-- Extract adjacent paths from branches
	local function collectBranchPaths( node )
		if node.branches then
			for _, branch in pairs( node.branches ) do
				local branch_path = branch[ 2 ] and branch[ 2 ].path
				if branch_path and branch_path ~= current_path then table.insert( adjacent_paths, branch_path ) end
			end
		end
	end

	-- Add current path and branches from node1 and node2
	collectBranchPaths( pos[ 1 ].node1 )
	collectBranchPaths( pos[ 1 ].node2 )
	-- Output results
	print( "Current Path:", current_path )
	print( "Adjacent Paths:" )
	for i, adj_path in ipairs( adjacent_paths ) do
		print( "    Adjacent Path [" .. adj_path.id .. "]:" )
	end
end

concommand.Add( mplr_debug_trackpos, UF.DebugMyPos(), nil, "Debug the first player's position on track, for debugging purposes" )