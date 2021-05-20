if SAM_LOADED then return end
if SERVER then return end

local sam = sam
local scale = sam.menu.scale

surface.CreateFont("SAM.RunCommand", {
	font = "Roboto",
	size = scale(13),
	weight = 200,
	antialias = true,
})

surface.CreateFont("SAM.CommandHelp", {
	font = "Roboto",
	size = scale(12),
	weight = 200,
	antialias = true,
})

sam.menu.add_tab("Commands", function()
	local commands_body = vgui.Create("Panel")
	commands_body:Dock(FILL)
	commands_body:DockMargin(0, 1, 0, 0)

	local left_body = commands_body:Add("Panel")
	left_body:Dock(LEFT)
	left_body:SetWide(scale(126))

	local search_entry = left_body:Add("SAM.TextEntry")
	search_entry:Dock(TOP)
	search_entry:DockMargin(0, 0, 0, 1)
	search_entry:SetHint("Search commands...")

	local category_list = left_body:Add("SAM.CollapseCategory")
	category_list:Dock(FILL)

	local body = commands_body:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(1, 0, 0, 0)
	body:SetVisible(false)

	local buttons = body:Add("SAM.ScrollPanel")
	buttons:Dock(FILL)
	buttons:SetWide(scale(130))
	buttons:SAM_TDLib()

	local childs = {}
	buttons:GetCanvas().OnChildAdded = function(self, child)
		child:SetWide(self:GetWide())
		if #childs >= 2 then
			table.insert(childs, #childs - 1, child)
		end
	end

	buttons:GetCanvas():On("PerformLayout", function(s, w)
		local child, last

		last = childs[1]
		last:SetWide(w)
		last:SetPos(0, 0)

		for i = 2, #childs do
			child = childs[i]
			child:SetWide(w)
			child:SetPos(0, last.y + last:GetTall() + 1)
			last = child
		end
	end)

	local command_help = buttons:Add("DLabel")
	command_help:SetFont("SAM.CommandHelp")
	command_help:SetVisible(false)
	command_help:SetWrap(true)
	command_help:SetAutoStretchVertical(true)

	local run_command = buttons:Add("DButton")
	run_command:SetTall(scale(22))
	run_command:SetTextColor(Color(220, 220, 220))
	run_command:SetVisible(false)
	run_command:SetMouseInputEnabled(false)
	run_command:SetFont("SAM.RunCommand")
	run_command:ClearPaint()
		:Background(Color(65, 185, 255, 70))
		:FadeHover(Color(255, 255, 255, 15))
		:CircleClick(Color(255, 255, 255, 15))
		:On("Paint", function(s, w, h)
			if not s:IsMouseInputEnabled() then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 130))
			end
		end)
		:On("DoClick", function(self)
			LocalPlayer():ConCommand("sam\"" .. self:GetText() .. "\"\"" .. table.concat(self.input_arguments, "\"\"") .. "\"")
		end)

	sam.menu.get():On("OnKeyCodePressed", function(s, key_code)
		if key_code == KEY_ENTER and IsValid(commands_body) and commands_body:IsVisible() and run_command:IsMouseInputEnabled() then
			run_command:DoClick()
		end
	end)

	function category_list:OnCategoryExpanded(category)
		for _, v in pairs(category_list.categories) do
			if v.expanded and v ~= category and search_entry:GetValue() == "" then
				v:SetExpanded(false)
			end
		end
	end

	function category_list:item_selected(item)
		childs = {run_command, command_help}

		body:SetVisible(true)

		for k, v in ipairs(body:GetChildren()) do
			if v ~= buttons then
				if v.no_remove ~= true then
					v:Remove()
				else
					v:SetVisible(false)
				end
			end
		end

		body:InvalidateLayout(true)

		for k, v in ipairs(buttons:GetCanvas():GetChildren()) do
			if v ~= command_help and v ~= run_command then
				v:Remove()
			end
		end

		local command = item.command

		local arguments = sam.command.get_arguments()
		local command_arguments = command.args

		local input_arguments = {}

		if #command_arguments == 0 then
			run_command:SetMouseInputEnabled(true)
		else
			local NIL = {}
			for _, v in ipairs(command_arguments) do
				local func = arguments[v.name]["menu"]
				if func then
					local i = table.insert(input_arguments, NIL)
					func(function(allow)
						if not IsValid(run_command) then return end
						input_arguments[i] = allow == nil and NIL or allow
						for i_2 = 1, #input_arguments do
							if input_arguments[i_2] == NIL then
								run_command:SetMouseInputEnabled(false)
								return
							end
						end
						run_command:SetMouseInputEnabled(true)
					end, body, buttons, v)
				end
			end
		end

		run_command:SetText(command.name)
		run_command:SetVisible(true)
		run_command.input_arguments = input_arguments

		if command.help then
			command_help:SetText(command.help)
			command_help:SetVisible(true)
			command_help:SizeToContents()
		else
			command_help:SetVisible(false)
		end

		buttons:InvalidateLayout(true)
	end

	function search_entry:OnValueChange(text)
		text = text:lower()
		for _, v in pairs(category_list.categories) do
			if v.was_expanded == nil then
				v.was_expanded = v.expanded
			end

			local has_items = false

			local items = v.items
			for i = 1, #items do
				local item = items[i]

				for _, name in ipairs(item.names) do
					if name:find(text, nil, true) then
						has_items = true
						item:SetVisible(true)

						goto __continue__
					end
				end

				item:SetVisible(false)

				::__continue__::
			end

			if has_items then
				v:SetVisible(true)
				if text == "" then
					v:SetExpanded(v.was_expanded)
					v.was_expanded = nil
				else
					v:SetExpanded(true)
				end
			else
				v:SetVisible(false)
			end

			v:InvalidateParent(true)
			v:InvalidateLayout(true)
		end
	end

	local can_use = function(cmd)
		if (cmd.permission and not LocalPlayer():HasPermission(cmd.permission)) or cmd.menu_hide then
			return false
		end
		return true
	end

	local remove_command, current_category

	local added_commands = {}
	local add_command = function(name, cmd, index, force)
		if not IsValid(category_list) then return end
		if not can_use(cmd) then return remove_command(name, cmd, index) end
		if not force and added_commands[name] then return end

		local was_selected = added_commands[name] and category_list.selected_item == added_commands[name]
		remove_command(name, cmd, index, true)

		local items = category_list.items
		for i = 1, #items do
			local item = items[i]
			local item_index = item:GetZPos()
			if item_index >= index then
				items[i]:SetZPos(item_index + 1)
			end
		end

		local item = category_list:add_item(name, cmd.category)
		item:SetZPos(index)

		item.command = cmd
		item.names = {name:lower()}
		for _, aliase in ipairs(cmd.aliases) do
			table.insert(item.names, aliase:lower())
		end

		if current_category ~= cmd.category then
			item.category:SetZPos(index)
			current_category = cmd.category
		end

		if was_selected then
			category_list:select_item(item)
		end

		search_entry:OnValueChange(search_entry:GetValue())

		added_commands[name] = item
	end
	hook.Add("SAM.CommandAdded", "SAM.Menu.CommandAdded", add_command)

	hook.Add("SAM.CommandModified", "SAM.Menu.CommandModified", function(name, cmd, index)
		add_command(name, cmd, index, true)
	end)

	remove_command = function(name, cmd, index, same)
		if not IsValid(category_list) then return end

		local cmd_item = added_commands[name]
		if not cmd_item then return end

		if not same and category_list.selected_item == cmd_item then
			body:SetVisible(false)
			category_list.selected_item = nil
		end

		cmd_item:Remove()

		local items = category_list.items
		for i = 1, #items do
			local item = items[i]
			local item_index = item:GetZPos()
			if item_index > index then
				items[i]:SetZPos(item_index - 1)
			end
		end

		search_entry:OnValueChange(search_entry:GetValue())

		added_commands[name] = nil
	end
	hook.Add("SAM.CommandRemoved", "SAM.Menu.CommandRemoved", remove_command)

	function category_list:Think()
		for k, v in ipairs(sam.command.get_commands()) do
			add_command(v.name, v, k)
		end
	end

	return commands_body
end, nil, 1)