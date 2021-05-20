if SAM_LOADED then return end
if SERVER then return end

local sam = sam
local scale = sam.menu.scale
local TDLib = sam.TDLib

surface.CreateFont("SAM.RankTabLabels", {
	font = "Roboto Regular",
	size = sam.menu.scale(13),
	weight = 500,
	antialias = true,
})

sam.menu.add_tab("Ranks", function()
	local ranks_body = vgui.Create("Panel")
	ranks_body:Dock(FILL)
	ranks_body:DockMargin(0, 1, 0, 0)

	local left_body = ranks_body:Add("Panel")
	left_body:Dock(LEFT)
	left_body:SetWide(scale(126))

	local ranks_list = left_body:Add("SAM.ListView")
	ranks_list:Dock(FILL)
	ranks_list.columns:Hide()

	function ranks_list:OnRowRightClick(_, line)
		if sam.ranks.is_default_rank(line.name) then return end
		local menu = DermaMenu()
		menu:AddOption("Remove Rank", function()
			RunConsoleCommand("sam", "removerank", line.name)
		end)
		menu:Open()
	end

	local search_ranks = left_body:Add("SAM.TextEntry")
	search_ranks:Dock(TOP)
	search_ranks:DockMargin(0, 0, 0, 1)
	search_ranks:SetHint("Search ranks...")

	function search_ranks:OnValueChange(text)
		text = text:lower()
		for _, line in ipairs(ranks_list.lines) do
			for _, child in ipairs(line:GetChildren()) do
				if child:GetText():lower():find(text, nil, true) then
					line:SetVisible(true)
				else
					line:SetVisible(false)
				end
			end
		end
		ranks_list.canvas:GetCanvas():InvalidateLayout(true)
	end

	local body = ranks_body:Add("Panel")
	body:Dock(FILL)
	body:DockMargin(1, 0, 0, 0)
	body:SetVisible(false)

	local show_permissions

	local show = body:Add("DButton")
	show:Dock(BOTTOM)
	show:DockMargin(0, 1, 0, 0)
	show:SetTall(sam.menu.scale(23))
	show:SetFont("SAM.RankTabLabels")
	show:SetText("Show Permissions")
	show:SetTextColor(Color(200, 200, 200))
	show:SAM_TDLib()
		:ClearPaint()
		:Background(Color(255, 255, 255, 18))
		:FadeHover()
		:On("DoClick", function()
			show_permissions()
		end)

	local rank_info_body = body:Add("Panel")
	rank_info_body:Dock(FILL)

	local current_rank, current_inherit, current_immunity, current_ban_limit

	local added_count = -32767
	local add_child = function(class, label)
		if label then
			local child_label = rank_info_body:Add("DLabel")
			child_label:Dock(TOP)
			child_label:DockMargin(1, 0, 0, -3)
			child_label:SetFont("SAM.RankTabLabels")
			child_label:SetText(label)
			child_label:SetTextInset(0, 0)
			child_label:SetZPos(added_count)

			added_count = added_count + 1
		end

		local child = rank_info_body:Add(class)
		child:Dock(TOP)
		child:DockMargin(2, 0, 0, 0)
		child:SetZPos(added_count)

		added_count = added_count + 1

		return child
	end

	local added_ranks = {}

	local add_rank = function(name, info)
		if name == "superadmin" or not IsValid(ranks_list) then return end

		local line = added_ranks[name] or ranks_list:AddLine(name)
		line:SetZPos(-info.immunity)
		line.name = name

		for _, child in ipairs(line:GetChildren()) do
			child:SetTextInset(0, 0)
			child:SetContentAlignment(5)
		end

		added_ranks[name] = line
	end

	local refresh_permissions
	local set_rank = function(name)
		current_rank = name
		refresh_permissions()
	end

	local remove_rank = function(name)
		local line = added_ranks[name]
		if not line then return end
		line:Remove()
		added_ranks[name] = nil
		set_rank(nil)
	end

	for name, info in pairs(sam.ranks.get_ranks()) do
		add_rank(name, info)
	end

	hook.Add("SAM.AddedRank", "SAM.RefreshRanksList", function(name, rank)
		add_rank(name, rank)
	end)

	hook.Add("SAM.RemovedRank", "SAM.RefreshRanksList", function(name)
		remove_rank(name)
	end)

	local invalid_color = Color(244, 67, 54, 30)

	local rank_name = add_child("SAM.TextEntry", "Name")

	function rank_name:OnEnter()
		if self:GetBackgroundColor() == invalid_color then return end

		local new_name = self:GetValue()
		if new_name == current_rank then return end

		RunConsoleCommand("sam", "renamerank", current_rank, new_name)

		local line = ranks_list:GetSelectedLine()
		line.name = new_name
		line:GetChildren()[1]:SetText(new_name)

		added_ranks[new_name], added_ranks[current_rank] = line, nil
		set_rank(new_name)
	end

	function rank_name:OnValueChange(value)
		if value == current_rank or (value ~= "" and not sam.ranks.is_rank(value)) then
			self:SetBackgroundColor()
		else
			self:SetBackgroundColor(invalid_color)
		end
	end

	hook.Add("SAM.RankNameChanged", "SAM.RefreshRanksList", function(name, new_name)
		if IsValid(added_ranks[name]) then
			if current_rank == name then
				rank_name:SetText(new_name)
			end

			local line = added_ranks[name]
			line.name = new_name
			line:GetChildren()[1]:SetText(new_name)

			added_ranks[new_name], added_ranks[name] = line, nil
			set_rank(new_name)
		end
	end)

	local rank_inherit = add_child("SAM.ComboBox", "Inherits from")
	rank_inherit:SetTall(sam.menu.scale(20))

	function rank_inherit:OnSelect(_, value)
		if value ~= current_inherit then
			RunConsoleCommand("sam", "changeinherit", current_rank, value)
			current_inherit = value
		end
	end

	function rank_inherit:DoClick()
		if self:IsMenuOpen() then
			return self:CloseMenu()
		end

		self:Clear()
		self:SetValue(current_inherit)

		for name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
			if current_rank ~= name and not sam.ranks.inherits_from(name, current_rank) then
				self:AddChoice(name)
			end
		end

		self:OpenMenu()
	end

	local rank_immunity = add_child("SAM.TextEntry", "Immunity | 2 ~ 99")
	rank_immunity:SetNumeric(true)
	rank_immunity:DisallowNegative()
	rank_immunity:DisallowFloats()

	function rank_immunity:OnEnter()
		if self:GetBackgroundColor() == invalid_color then return end

		local new_immunity = math.Clamp(self:GetValue(), 2, 99)
		if new_immunity == current_immunity then return self:SetValue(new_immunity) end

		RunConsoleCommand("sam", "changerankimmunity", current_rank, new_immunity)
		current_immunity = new_immunity
	end

	function rank_immunity:OnValueChange(value)
		value = tonumber(value) or value
		if value == current_immunity or value ~= "" then
			self:SetBackgroundColor()
		else
			self:SetBackgroundColor(invalid_color)
		end
	end

	hook.Add("SAM.RankImmunityChanged", "SAM.RefreshRanksList", function(name, immunity)
		if IsValid(added_ranks[name]) then
			if current_rank == name then
				rank_immunity:SetValue(immunity)
			end
			added_ranks[name]:SetZPos(-immunity)
		end
	end)

	local rank_ban_limit = add_child("SAM.TextEntry", "Ban Limit (eg. 1y 1mo 1w 1d 1h 1m)")

	function rank_ban_limit:OnEnter()
		if self:GetBackgroundColor() == invalid_color then return end

		local new_limit = self:GetValue()
		if new_limit == current_ban_limit then return self:SetValue(sam.reverse_parse_length(sam.parse_length(current_ban_limit))) end

		RunConsoleCommand("sam", "changerankbanlimit", current_rank, new_limit)

		current_ban_limit = new_limit
	end

	function rank_ban_limit:OnValueChange(value)
		if value == current_ban_limit or sam.parse_length(value) then
			self:SetBackgroundColor()
		else
			self:SetBackgroundColor(invalid_color)
		end
	end

	hook.Add("SAM.RankBanLimitChanged", "SAM.RefreshRanksList", function(name, new_limit)
		if current_rank == name and IsValid(added_ranks[name]) then
			rank_ban_limit:SetValue(sam.reverse_parse_length(new_limit))
		end
	end)

	local update_limits
	if GAMEMODE.IsSandboxDerived then
		local limits_list = add_child("SAM.ScrollPanel", "Limits | -1 ~ 1000")
		limits_list:Dock(FILL)
		limits_list:DockMargin(2, 0, 0, 2)

		local limit_OnEnter = function(self)
			local limit = math.Clamp(self:GetValue(), -1, 1000)
			if limit ~= sam.ranks.get_limit(current_rank, self.limit_type) then
				RunConsoleCommand("sam", "changeranklimit", current_rank, self.limit_type, limit)
			else
				self:SetText(tostring(sam.ranks.get_limit(current_rank, self.limit_type)))
			end
		end

		local limit_values = {}
		for k, v in ipairs(sam.limit_types) do
			local line = limits_list:Add("DPanel")
			line:Dock(TOP)
			line:SetTall(sam.menu.scale(20))
			line:SetZPos(-k)
			line:SAM_TDLib()
				:ClearPaint()
				:Background(Color(255, 255, 255, 18))
				:FadeHover(Color(255, 255, 255, 30))

			local child = line:Add("DLabel")
			child:Dock(LEFT)
			child:SetFont("SAM.ListViewLine")
			child:SetText(v)
			child:SetTextInset(6, 0)

			local limit_value = line:Add("SAM.TextEntry")
			limit_value:Dock(RIGHT)
			limit_value:SetWide(sam.menu.scale(40))
			limit_value:SetNumeric(true)
			limit_value:DisallowFloats()

			limit_value.OnEnter = limit_OnEnter

			limit_value.limit_type = v

			table.insert(limit_values, limit_value)
		end

		update_limits = function()
			for k, v in ipairs(limit_values) do
				v:SetText(tostring(sam.ranks.get_limit(current_rank, v.limit_type)))
			end
		end

		for _, v in ipairs({"SAM.RankChangedLimit", "SAM.ChangedInheritRank"}) do
			hook.Add(v, "SAM.RefreshRankLimits", update_limits)
		end
	end

	function ranks_list:OnRowSelected(id, line)
		if not line then
			body:SetVisible(false)
			return
		end

		if current_rank == line.name then return end

		set_rank(line.name)

		local rank = sam.ranks.get_rank(current_rank)
		current_inherit = rank.inherit
		current_immunity = rank.immunity
		current_ban_limit = rank.ban_limit

		body:SetVisible(true)

		rank_name:SetValue(current_rank)
		rank_inherit:SetValue(current_inherit or "user")
		rank_immunity:SetValue(current_immunity)
		rank_ban_limit:SetValue(sam.reverse_parse_length(current_ban_limit))

		rank_name:SetEditable(not sam.ranks.is_default_rank(current_rank))
		rank_inherit:SetDisabled(current_rank == "user")
		rank_immunity:SetEditable(current_rank ~= "user")

		if update_limits then
			update_limits()
		end

		body:InvalidateLayout(true)
	end

	local permissions_body = body:Add("Panel")
	permissions_body:Dock(FILL)
	permissions_body:Hide()

	show_permissions = function()
		if permissions_body:IsVisible() then
			show:SetText("Show Permissions")
			permissions_body:Hide()
			rank_info_body:Show()
		else
			show:SetText("Hide Permissions")
			permissions_body:Show()
			rank_info_body:Hide()
		end
	end

	local permissions_list = permissions_body:Add("SAM.CollapseCategory")
	permissions_list:Dock(FILL)

	local search_permissions = permissions_body:Add("SAM.TextEntry")
	search_permissions:Dock(TOP)
	search_permissions:DockMargin(0, 0, 0, 1)
	search_permissions:SetHint("Search permissions...")

	function search_permissions:OnValueChange(text)
		text = text:lower()
		for _, v in pairs(permissions_list.categories) do
			local has_items = false

			if v.was_expanded == nil then
				v.was_expanded = v.expanded
			end

			local items = v.items
			for i = 1, #items do
				local item = items[i]
				if item.name:lower():find(text, nil, true) then
					item:SetVisible(true)
					has_items = true
				else
					item:SetVisible(false)
				end
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

	function permissions_list:OnCategoryExpanded(category)
		for _, v in pairs(self.categories) do
			if v.expanded and v ~= category and search_permissions:GetValue() == "" then
				v:SetExpanded(false)
			end
		end
	end

	local item_click = function(s)
		if not sam.ranks.has_permission(current_rank, s.name) then
			RunConsoleCommand("sam", "givepermission", current_rank, s.name)
		else
			RunConsoleCommand("sam", "takepermission", current_rank, s.name)
		end
	end

	refresh_permissions = function()
		for k, v in ipairs(permissions_list.items) do
			v.img:SetVisible(sam.ranks.has_permission(current_rank, v.name))
		end
	end

	for k, v in ipairs({"SAM.ChangedInheritRank", "SAM.RankPermissionGiven", "SAM.RankPermissionTaken"}) do
		hook.Add(v, "SAM.Menu.RefreshPermissions ", refresh_permissions)
	end

	local check_mark = Material("materials/sam/check_mark.png", "noclamp smooth")
	local load_permissions = function()
		for k, v in ipairs(permissions_list.items) do
			v:Remove()
		end

		for k, v in ipairs(sam.permissions.get()) do
			local item = permissions_list:add_item(v.name, v.category)
			item:SetContentAlignment(4)
			item:SetTextInset(6, 0)
			item:SetZPos(k)

			item.category.header:SetContentAlignment(4)
			item.category.header:SetTextInset(4, 0)

			local img = item:Add("DImage")
			img:Dock(RIGHT)
			img:DockMargin(3, 3, 3, 3)
			img:InvalidateParent(true)
			img:SetWide(img:GetTall())
			img:SetImageColor(Color(68, 253, 48))
			img:SetMaterial(check_mark)

			item.name = v.name
			item.img = img

			item:ClearPaint()
				:Background(Color(255, 255, 255, 18))
				:FadeHover(Color(255, 255, 255, 30), nil, nil, TDLib.HoverFunc)

			item.DoClick = item_click
		end

		refresh_permissions()

		search_permissions:OnValueChange(search_permissions:GetValue())
	end

	load_permissions()

	for k, v in ipairs({"SAM.AddedPermission", "SAM.PermissionModified", "SAM.RemovedPermission"}) do
		hook.Add(v, "SAM.Menu.RefreshPermissions ", load_permissions)
	end

	local create_rank = left_body:Add("DButton")
	create_rank:Dock(BOTTOM)
	create_rank:DockMargin(0, 1, 0, 0)
	create_rank:SetFont("SAM.RankTabLabels")
	create_rank:SetText("Create Rank")
	create_rank:SetTextColor(Color(200, 200, 200))
	create_rank:SetTall(scale(23))

	create_rank:SAM_TDLib()
		:ClearPaint()
		:Background(Color(65, 185, 255, 70))
		:FadeHover()
		:On("DoClick", function()
			local start_time = SysTime()

			local bg_panel = vgui.Create("EditablePanel")
			bg_panel:SetPos(0, 0)
			bg_panel:SetSize(ScrW(), ScrH())
			bg_panel:MakePopup()

			function bg_panel:Paint(w, h)
				Derma_DrawBackgroundBlur(self, start_time)
			end

			local create_menu = bg_panel:Add("SAM.Frame")
			create_menu:SetSize(scale(340), scale(140))
			create_menu:Center()
			create_menu:DockPadding(3, 3, 3, 3)

			function create_menu:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 240))
			end

			function create_menu.close.DoClick()
				bg_panel:Remove()
			end

			create_menu.header:DockMargin(-3, -3, -3, 3)

			local new_rank = create_menu:Add("SAM.TextEntry")
			new_rank:Dock(TOP)
			new_rank:DockMargin(0, 0, 0, 3)
			new_rank:SetHint("Rank Name")

			function new_rank:OnValueChange(value)
				self:SetBackgroundColor(value ~= "" and not sam.ranks.is_rank(value) or invalid_color)
			end
			new_rank:OnValueChange("")

			local create = create_menu:Add("DButton")
			create:Dock(TOP)
			create:SetTall(new_rank:GetTall())
			create:SetFont("SAM.RankTabLabels")
			create:SetText("Create Rank")
			create:SetTextColor(Color(200, 200, 200))
			create:SetMouseInputEnabled(false)
			create:SAM_TDLib()
				:ClearPaint()
				:Background(Color(65, 185, 255, 70))
				:FadeHover()
				:On("Paint", function(s, w, h)
					if not s:IsMouseInputEnabled() then
						draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 130))
					end
				end)
				:On("DoClick", function()
					RunConsoleCommand("sam", "addrank", new_rank:GetValue(), "user")
					bg_panel:Remove()
				end)
				:On("Think", function(self)
					if new_rank:GetValue() ~= "" and not sam.ranks.is_rank(new_rank:GetValue()) then
						self:SetMouseInputEnabled(true)
					else
						self:SetMouseInputEnabled(false)
					end

					create_menu:SizeToChildren(false, true)
				end)
		end)

	return ranks_body
end, function()
	return LocalPlayer():HasPermission("manage_ranks")
end, 3)