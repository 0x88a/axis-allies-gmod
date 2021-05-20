
DWEP = DWEP or {}
DWEP.Config = {} 
DWEP.Config.Colors ={  
["background"]= Color(28, 28, 27, 200),  
["foreground"]= Color(28, 28, 27, 180), 		
["inactiveClr"] = Color(20, 20, 21, 180), 
["theme"] = Color(28, 28, 27),
}  

DWEP.Config.AccessGroups = {
	"superadmin",
}

DWEP.Config.AccessSteamID = {
	"STEAM_0:0:167730330",
	"STEAM_0:0:105454373",
}


--No configuration below this line: DO NOT TOUCH
 
DWEP.Sweps = DWEP.Sweps or {}
DWEP.DefaultSweps = DWEP.DefaultSweps or {}

function DWEP.CanDWEP(ply)

	return table.HasValue(DWEP.Config.AccessGroups, ply:GetUserGroup()) or table.HasValue( DWEP.Config.AccessSteamID,ply:SteamID())

end 
function DWEP.AdjustValue(weapon, key, value)
	local parents = string.Explode(" | ", key)
	local curTable
	local weapon = weapons.GetStored(weapon)
	if #parents > 1 then 
		for i = 1, #parents  do
			if i != 1 and i < #parents then 
				curTable[parents[i]] = curTable[parents[i]] or {}
				curTable = curTable[parents[i]] 
			elseif i == 1 then
				weapon[parents[1]] = weapon[parents[1]] or {}
				curTable = weapon[parents[1]]
			elseif i == #parents then 
				curTable[parents[i]] = value 
			end  
		end  
	else
		weapon[parents[1]] = value 
	end 
end 

function DWEP.CopyTable(obj, seen)
  -- Handle non-tables and previously-seen tables.
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  -- New table; mark it as seen an copy recursively.
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[DWEP.CopyTable(k, s)] = DWEP.CopyTable(v, s) end
  return res
end


hook.Add("InitPostEntity", "InitializeDWEP", function()
	
	if #DWEP.Sweps <= 0 then 
		for k,v in pairs(weapons.GetList()) do
			if v.ClassName then 
				DWEP.Sweps[#DWEP.Sweps + 1 or 1] = v.ClassName 
				DWEP.DefaultSweps[v.ClassName] = DWEP.CopyTable(v) 
			end 
		end 
	end 
	
	if SERVER then
		for k,v in pairs(weapons.GetList()) do
			DWEP.LoadData(v.ClassName)
		end 
	end 
	
end)

--PrintTable(DWEP.DefaultSweps["cw_p99"])