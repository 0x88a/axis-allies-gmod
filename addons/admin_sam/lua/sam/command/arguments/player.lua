if SAM_LOADED then return end

local sam, command = sam, sam.command

local can_target_player = function(arg, admin, target, cmd, input)
	if not IsValid(target) or not target:IsPlayer() or not target:sam_get_nwvar("is_authed") then
		if input then
			admin:sam_send_message("cant_find_target", {
				S = input
			})
		end
		return false
	end

	if not arg.allow_higher_target and not admin:CanTarget(target) then
		if cmd then
			admin:sam_send_message("cant_target_player", {
				S = target:Name()
			})
		end
		return false
	end

	if arg.cant_target_self and admin == target then
		if cmd then
			admin:sam_send_message("cant_target_self", {
				S = cmd.name
			})
		end
		return false
	end

	return true
end

local check_text_match = function(text, ply)
	if ply:Name():lower():find(text, 1, true) then return true end
	if ply:GetUserGroup():lower():find(text, 1, true) then return true end
	if team.GetName(ply:Team()):lower():find(text, 1, true) then return true end

	if not ply:IsBot() then
		return ply:SteamID():lower():find(text, 1, true) or ply:SteamID64():lower():find(text, 1, true)
	end

	return false
end

command.new_argument("player")
	:OnExecute(function(arg, input, ply, cmd, result)
		if input == nil and arg.optional then
			if sam.isconsole(ply) then
				ply:sam_send_message("cant_target_self", {
					S = cmd.name
				})
				return false
			end
			table.insert(result, {ply, admin = ply, input = input})
			return
		end

		local single_target = arg.single_target
		local targets = {admin = ply, input = input}

		if input == "*" then
			if single_target then
				ply:sam_send_message("cant_target_multi_players")
				return false
			end
			local players = player.GetAll()
			for i = 1, #players do
				local v = players[i]
				if can_target_player(arg, ply, v) then
					table.insert(targets, v)
				end
			end
		elseif input:sub(1, 1) == "#" and not single_target then
			local tmp = {}
			for _, v in ipairs(input:sub(2):Trim():Split(",")) do
				v = tonumber(v)
				if not sam.isnumber(v) then continue end
				local target = Entity(v)
				if not tmp[target] and IsValid(target) and target:IsPlayer() then
					tmp[target] = true
					if can_target_player(arg, ply, target) then
						table.insert(targets, target)
					end
				end
			end
		else
			local target
			if input == "^" then
				target = ply
			elseif input == "@" and not sam.isconsole(ply) then
				target = ply:GetEyeTrace().Entity
			elseif sam.is_steamid(input) then
				target = player.GetBySteamID(input)
			elseif sam.is_steamid64(input) then
				target = player.GetBySteamID64(input)
			elseif input:sub(1, 1) == "#" then
				local index = input:sub(2):Trim()
				index = tonumber(index)

				if not isnumber(index) then
					ply:sam_send_message("invalid_id", {
						S = input
					})
					return false
				end

				target = Entity(index)

				if not IsValid(target) or not target:IsPlayer() then
					ply:sam_send_message("player_id_not_found", {
						S = index
					})
					return false
				end
			else
				if input:sub(1, 1) == "%" and #input > 1 then
					input = input:sub(2)
				end

				target = sam.player.find_by_name(input)
				if sam.istable(target) then
					if single_target then
						ply:sam_send_message("found_multi_players", {T = target})
						return false
					else
						for k, v in ipairs(target) do
							if can_target_player(arg, ply, v) then
								table.insert(targets, v)
							end
						end
						goto _end
					end
				end
			end

			if not can_target_player(arg, ply, target, cmd, input) then
				return false
			end

			table.insert(targets, target)
		end

		::_end::

		if #targets == 0 then
			ply:sam_send_message("cant_find_target", {
				S = input
			})
			return false
		end
		table.insert(result, targets)
	end)

	:Menu(function(set_result, body, buttons, argument)
		if body.ply_list then
			local ply_list = body.ply_list
			ply_list:SetMultiSelect(argument.single_target ~= true)
			ply_list.argument = argument
			ply_list.set_result = set_result

			if argument.single_target == true and #ply_list:GetSelected() > 1 then
				ply_list:ClearSelection()
			end

			ply_list:OnRowSelected()
			ply_list:GetParent():SetVisible(true)

			return
		end

		local left_body = body:Add("Panel")
		left_body:Dock(LEFT)
		left_body:DockMargin(0, 0, 1, 0)
		left_body:SetWide(sam.menu.scale(242))
		left_body.no_remove = true

		local ply_list = left_body:Add("SAM.ListView")
		ply_list:Dock(FILL)
		ply_list:SetMultiSelect(argument.single_target ~= true)
		ply_list.argument = argument
		ply_list.set_result = set_result

		ply_list:AddColumn("Name")
		ply_list:AddColumn("Rank")

		function ply_list:OnRowSelected()
			local plys = {}
			for k, v in ipairs(ply_list:GetSelected()) do
				plys[k] = v.ply:EntIndex()
			end
			if #plys == 0 then
				self.set_result(nil)
			else
				self.set_result("#" .. table.concat(plys, ","))
			end
		end

		function ply_list:OnRowRightClick(_, line)
			local d_menu = DermaMenu()

			local steamid = line.ply:SteamID()
			d_menu:AddOption("Copy SteamID", function()
				SetClipboardText(steamid)
			end)

			local name = line.ply:Name()
			d_menu:AddOption("Copy Name", function()
				SetClipboardText(name)
			end)

			d_menu:Open()
		end

		local added_players = {}

		local add_player = function(ply, i)
			if can_target_player(ply_list.argument, LocalPlayer(), ply) then
				local line = ply_list:AddLine(ply:Name(), ply:GetUserGroup())
				line:SetZPos(i)
				line.ply = ply
				line.userid = ply:UserID()
				body.search_entry:OnValueChange()

				added_players[ply] = true
			end
		end

		function ply_list:Think()
			local players = player.GetAll()
			for i = 1, #players do
				local ply = players[i]
				if not added_players[ply] then
					add_player(ply, i)
				end
			end

			local argument = ply_list.argument
			local lines = ply_list.lines

			for i = 1, #lines do
				local line = lines[i]
				local ply = line.ply

				if not can_target_player(argument, LocalPlayer(), ply) then
					line:Remove()
					added_players[ply] = nil
					body.search_entry:OnValueChange()
					break
				end

				local childs = line:GetChildren()

				local name_child = childs[1]
				local rank_child = childs[2]

				if name_child:GetText() ~= ply:Name() or rank_child:GetText() ~= ply:GetUserGroup() then
					childs[1]:SetText(ply:Name())
					childs[2]:SetText(ply:GetUserGroup())
					body.search_entry:OnValueChange()
				end
			end
		end

		local search_entry = left_body:Add("SAM.TextEntry")
		search_entry:Dock(TOP)
		search_entry:DockMargin(0, 0, 0, 1)
		search_entry:SetHint("Search players - name/steamid/rank/job")

		function search_entry:OnValueChange(text)
			if text == nil then
				text = self:GetValue()
			end
			text = text:lower()
			for i, line in ipairs(ply_list.lines) do
				local ply = line.ply
				if not IsValid(ply) then continue end

				if check_text_match(text, ply) then
					line:SetVisible(true)
				else
					line:SetVisible(false)
					if line.selected then
						line.selected = nil
						ply_list:OnRowSelected()
					end
				end
			end
			ply_list.canvas:GetCanvas():InvalidateLayout(true)
		end

		body.ply_list = ply_list
		body.search_entry = search_entry
	end)

	:AutoComplete(function(arg, result, name)
		local ply = LocalPlayer()
		for k, v in ipairs(player.GetAll()) do
			if can_target_player(arg, ply, v) and v:Name():lower():find(name, 1, true) then
				table.insert(result, "%" .. v:Name())
			end
		end
	end)
:End()