if SAM_LOADED then return end

local sam, command = sam, sam.command

command.new_argument("map")
	:OnExecute(function(_, input, ply, _, result)
		local map_name = sam.is_valid_map(input)
		if not map_name then
			ply:sam_send_message("invalid", {
				S = "map", S_2 = input
			})
			return false
		end

		table.insert(result, map_name)
	end)

	:Menu(function(set_result, _, buttons)
		local maps = buttons:Add("SAM.ComboBox")
		maps:SetValue(game.GetMap())

		for _, map_name in ipairs(sam.get_global("Maps")) do
			maps:AddChoice(map_name)
		end

		function maps:OnSelect(_, value)
			set_result(value)
		end

		maps:OnSelect(nil, game.GetMap())
	end)

	:AutoComplete(function(_, result, name)
		for _, map_name in ipairs(sam.get_global("Maps")) do
			if map_name:lower():find(name, 1, true) then
				table.insert(result, map_name)
			end
		end
	end)
:End()