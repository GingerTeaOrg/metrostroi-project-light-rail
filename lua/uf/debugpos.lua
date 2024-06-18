local ply = ents.GetByIndex(1)
if not ply then return end
local pos = Metrostroi.GetPositionOnTrack(ply:GetPos(), ply:GetAngles())

local function printTableLimited(table, depth)
	if depth == nil then depth = 0 end
	if depth >= 2 or type(table) ~= "table" then
		print(table)
		return
	end

	for key, value in pairs(table) do
		print(key, value)
		if type(value) == "table" then
			print("    Subtable:", value)
			for k, v in pairs(value) do print("     ", k, v) end
		end
	end
end
pos[1].node1["speedlimitForward"] = "40"
printTableLimited(pos[1])
