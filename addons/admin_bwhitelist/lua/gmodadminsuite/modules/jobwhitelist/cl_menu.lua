local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "jobwhitelist")
	else
		return GAS:PhraseFormat(phrase, "jobwhitelist", ...)
	end
end

if (IsValid(GAS.JobWhitelist.Menu)) then
	GAS.JobWhitelist.Menu:Close()
end

GAS:hook("gmodadminsuite:ModuleSize:jobwhitelist", "jobwhitelist:framesize", function()
	return 800,600
end)

local function CreateListingMenu(tab_content, job_index, is_blacklist)
	local is_operator = OpenPermissions:IsOperator(LocalPlayer())
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	local listing_data_table = vgui.Create("bVGUI.Table", tab_content)
	if (is_blacklist) then
		tab_content:GetParent().BlacklistTable = listing_data_table
	else
		tab_content:GetParent().WhitelistTable = listing_data_table
	end
	listing_data_table:Dock(FILL)
	listing_data_table:AddColumn(L"type", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
	listing_data_table:AddColumn(L"value", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
	listing_data_table:AddColumn(L"name", bVGUI.TABLE_COLUMN_GROW, TEXT_ALIGN_LEFT)
	listing_data_table:AddColumn(L"added_by", bVGUI.TABLE_COLUMN_GROW, TEXT_ALIGN_LEFT)
	listing_data_table:SetLoading(true)
	listing_data_table:SetRowCursor("hand")
	listing_data_table:SetCookieName("gmodadminsuite:jobwhitelist:")
	function listing_data_table:OnColumnHovered(row, column_index)
		local delete_tip = self:GetCookie("delete_tip", "0")
		if (delete_tip == "0") then
			bVGUI.CreateTooltip({
				Text = L"click_delete_entry_tip",
				VGUI_Element = row
			})
		end

		if ((column_index == 2 or column_index == 3) and row.AccountID_1) then
			bVGUI.PlayerTooltip.Create({
				account_id = row.AccountID_1,
				creator = row,
				focustip = L"right_click_to_focus"
			})
		elseif (column_index == 4 and row.AccountID_2) then
			bVGUI.PlayerTooltip.Create({
				account_id = row.AccountID_2,
				creator = row,
				focustip = L"right_click_to_focus"
			})
		else
			bVGUI.PlayerTooltip.Close()
		end
	end
	function listing_data_table:OnRowClicked(row)
		self:SetCookie("delete_tip","1")
		GAS:PlaySound("btn_heavy")
		local menu = DermaMenu()

		local option_lbl
		local option_icon
		if (is_blacklist) then
			option_lbl = L"blacklisted"
			option_icon = "icon16/tag_red.png"
		else
			option_lbl = L"whitelisted"
			option_icon = "icon16/tag_green.png"
		end
		if (row.AccountID_1) then
			local sub,_sub = menu:AddSubMenu(option_lbl)
			_sub:SetIcon(option_icon)

			local value_option = sub:AddOption(GAS:MarkupToPlaintext(row.LabelsData[3]), function()
				bVGUI.PlayerTooltip.Focus()
			end)
			bVGUI_DermaMenuOption_PlayerTooltip(value_option, {focustip = L"click_to_focus", account_id = row.AccountID_1, copiedphrase = L"copied", creator = ply_option})
			
			sub:AddOption(L"copy_steamid", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID(row.AccountID_1))
			end):SetIcon("icon16/user.png")
			sub:AddOption(L"copy_steamid64", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID64(row.AccountID_1))
			end):SetIcon("icon16/user_gray.png")
		else
			local sub,_sub = menu:AddSubMenu(option_lbl)
			_sub:SetIcon(option_icon)

			sub:AddOption(GAS:MarkupToPlaintext(row.LabelsData[2])):SetIcon("icon16/tag_blue.png")
			sub:AddOption(L"copy", function()
				GAS:SetClipboardText(row.LabelsData[3])
			end):SetIcon("icon16/page_copy.png")
		end

		if (row.AccountID_2) then
			local sub,_sub = menu:AddSubMenu(L"added_by")
			_sub:SetIcon("icon16/add.png")

			local ply_option = sub:AddOption(GAS:MarkupToPlaintext(row.LabelsData[4]), function()
				bVGUI.PlayerTooltip.Focus()
			end)
			bVGUI_DermaMenuOption_PlayerTooltip(ply_option, {focustip = L"click_to_focus", account_id = row.AccountID_2, copiedphrase = L"copied", creator = ply_option})
			
			sub:AddOption(L"copy_steamid", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID(row.AccountID_2))
			end):SetIcon("icon16/user.png")
			sub:AddOption(L"copy_steamid64", function()
				GAS:SetClipboardText(GAS:AccountIDToSteamID64(row.AccountID_2))
			end):SetIcon("icon16/user_gray.png")
		end

		local data_type = GAS.JobWhitelist:GetListType(row.LabelsData[1])
		if (GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, false, is_blacklist, data_type)) then
			menu:AddSpacer()

			menu:AddOption(L"delete_entry", function()
				GAS:PlaySound("delete")
				GAS:netStart("jobwhitelist:delete_from_list")
					net.WriteBool(is_blacklist)
					net.WriteUInt(job_index, 16)
					net.WriteUInt(data_type, 4)
					if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
						net.WriteUInt(row.AccountID_1, 31)
					else
						net.WriteString(row.LabelsData[2])
					end
				net.SendToServer()
				self:RemoveRow(row)
			end):SetIcon("icon16/cancel.png")
		end

		menu:Open()
	end
	function listing_data_table:OnRowRightClicked(row)
		if (IsValid(bVGUI.PlayerTooltip.Panel)) then
			bVGUI.PlayerTooltip.Focus()
		else
			self:OnRowClicked(row)
		end
	end

	local pagination
	local function AddToListData(data_type, value_raw)
		GAS:netStart("jobwhitelist:add_to_list")
			net.WriteBool(is_blacklist)
			net.WriteUInt(job_index, 16)
			net.WriteUInt(data_type, 4)
			if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
				net.WriteUInt(value_raw, 31)
			else
				net.WriteString(value_raw)
			end
		net.SendToServer()
		GAS.JobWhitelist.Menu.RequiresRefresh = true
		pagination:SetPage(1)
		pagination:OnPageSelected(1)
	end

	local function RemoveFromListData(data_type, value_raw)
		GAS:netStart("jobwhitelist:delete_from_list")
			net.WriteBool(is_blacklist)
			net.WriteUInt(job_index, 16)
			net.WriteUInt(data_type, 4)
			if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
				net.WriteUInt(value_raw, 31)
			else
				net.WriteString(value_raw)
			end
		net.SendToServer()
		GAS.JobWhitelist.Menu.RequiresRefresh = true
		pagination:SetPage(1)
		pagination:OnPageSelected(1)
	end

	local controls_container = vgui.Create("DPanel", tab_content)
	function controls_container:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_SLATE)
		surface.DrawRect(0,0,w,h)
	end
	controls_container:Dock(BOTTOM)
	controls_container:SetTall(48)
	controls_container:DockPadding(10,10,10,10)

	local add_remove_selector = vgui.Create("bVGUI.OptionSelector", controls_container)
	add_remove_selector:Dock(LEFT)
	add_remove_selector:AddButton(L"add", bVGUI.BUTTON_COLOR_BLUE)
	add_remove_selector:AddButton(L"remove", bVGUI.BUTTON_COLOR_RED)
	add_remove_selector:DockMargin(0,0,10,0)

	function controls_container:PerformLayout()
		add_remove_selector:SizeToButtons()
		for i,v in ipairs(self:GetChildren()) do
			if (i == 1) then continue end
			v:SetWide((self:GetWide() - add_remove_selector:GetWide() - 50) / (#self:GetChildren() - 1))
		end
	end

	local add_player = vgui.Create("bVGUI.Button", controls_container)
	add_player:SetText(L"add_player")
	add_player:Dock(LEFT)
	add_player:DockMargin(0,0,10,0)
	add_player:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	function add_player:DoClick()
		GAS.SelectionPrompts:PromptAccountID(function(account_id)
			if (self:GetText() == L"add_player") then
				AddToListData(GAS.JobWhitelist.LIST_TYPE_STEAMID, account_id)
				GAS:PlaySound("success")
			else
				RemoveFromListData(GAS.JobWhitelist.LIST_TYPE_STEAMID, account_id)
				GAS:PlaySound("delete")
			end
		end, nil, false)
	end
	add_player:SetDisabled(not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_STEAMID))

	local add_usergroup = vgui.Create("bVGUI.Button", controls_container)
	add_usergroup:SetText(L"add_usergroup")
	add_usergroup:Dock(LEFT)
	add_usergroup:DockMargin(0,0,10,0)
	add_usergroup:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	function add_usergroup:DoClick()
		GAS.SelectionPrompts:PromptUsergroup(function(usergroup)
			if (self:GetText() == L"add_usergroup") then
				AddToListData(GAS.JobWhitelist.LIST_TYPE_USERGROUP, usergroup)
				GAS:PlaySound("success")
			else
				RemoveFromListData(GAS.JobWhitelist.LIST_TYPE_USERGROUP, usergroup)
				GAS:PlaySound("delete")
			end
		end, nil, false)
	end
	add_usergroup:SetDisabled(not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_USERGROUP))

	local add_lua_function = vgui.Create("bVGUI.Button", controls_container)
	add_lua_function:SetText(L"add_lua_function")
	add_lua_function:Dock(LEFT)
	add_lua_function:SetColor(bVGUI.BUTTON_COLOR_BLUE)
	if (GAS:table_IsEmpty(GAS.LuaFunctions)) then
		add_lua_function:SetDisabled(true)
		add_lua_function:SetTooltip({
			Text = L"no_lua_functions"
		})
	else
		add_lua_function:SetDisabled(not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION))
	end
	function add_lua_function:DoClick()
		GAS.SelectionPrompts:PromptLuaFunction(function(lua_function_name)
			if (self:GetText() == L"add_lua_function") then
				AddToListData(GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION, lua_function_name)
				GAS:PlaySound("success")
			else
				RemoveFromListData(GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION, lua_function_name)
				GAS:PlaySound("delete")
			end
		end, nil, false)
	end

	function add_remove_selector:OnChange()
		if (self:GetSelectedButton() == L"add") then
			add_player:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			add_player:SetText(L"add_player")
			add_player:SetDisabled(not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_STEAMID))

			add_usergroup:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			add_usergroup:SetText(L"add_usergroup")
			add_usergroup:SetDisabled(not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_USERGROUP))

			add_lua_function:SetColor(bVGUI.BUTTON_COLOR_BLUE)
			add_lua_function:SetText(L"add_lua_function")
			add_lua_function:SetDisabled(GAS:table_IsEmpty(GAS.LuaFunctions) or not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, true, is_blacklist, GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION))
		else
			add_player:SetColor(bVGUI.BUTTON_COLOR_RED)
			add_player:SetText(L"remove_player")
			add_player:SetDisabled(not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, false, is_blacklist, GAS.JobWhitelist.LIST_TYPE_STEAMID))

			add_usergroup:SetColor(bVGUI.BUTTON_COLOR_RED)
			add_usergroup:SetText(L"remove_usergroup")
			add_usergroup:SetDisabled(not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, false, is_blacklist, GAS.JobWhitelist.LIST_TYPE_USERGROUP))

			add_lua_function:SetColor(bVGUI.BUTTON_COLOR_RED)
			add_lua_function:SetText(L"remove_lua_function")
			add_lua_function:SetDisabled(GAS:table_IsEmpty(GAS.LuaFunctions) or (not is_operator and not GAS.JobWhitelist:ModificationPermissionCheck(LocalPlayer(), job_id, false, is_blacklist, GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION)))
		end
	end

	local pagination_container = vgui.Create("DPanel", tab_content)
	function pagination_container:Paint(w,h)
		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawRect(0,0,w,h)
	end
	pagination_container:Dock(BOTTOM)
	pagination_container:SetTall(30)

	pagination = vgui.Create("bVGUI.Pagination", pagination_container)
	pagination:SetPages(1)
	pagination:Dock(FILL)
	pagination:SetLoadingPanel(listing_data_table)
	function pagination:OnPageSelected(page)
		listing_data_table:Clear()
		listing_data_table:SetLoading(true)
		GAS.JobWhitelist:GetListDataPage(is_blacklist, job_index, page, listing_data_table.PopulateTable)
	end

	function pagination_container:PerformLayout()
		pagination:SetTall(self:GetTall())
		pagination:Center()
	end

	listing_data_table.PopulateTable = function(data_received, data, page_count)
		if (not IsValid(listing_data_table)) then return end
		listing_data_table:SetLoading(false)
		if (data_received) then
			pagination:SetPages(math.max(page_count, 1))
			for _,v in ipairs(data) do
				local account_id = tonumber(v.a)
				local usergroup = v.b
				local lua_function = v.c
				local added_by_account_id = tonumber(v.d)
				local added_by_nick = v.e
				local user_nick = v.f

				if (account_id ~= nil) then
					local added_ply = player.GetByAccountID(account_id)
					if (IsValid(added_ply)) then
						user_nick = "<color=" .. GAS:Unvectorize(team.GetColor(added_ply:Team())) .. ">" .. GAS:EscapeMarkup(added_ply:Nick()) .. "</color>"
					elseif (user_nick) then
						user_nick = GAS:EscapeMarkup(user_nick)
					else
						user_nick = GAS:EscapeMarkup(L"offline")
					end
				end

				if (added_by_account_id ~= nil) then
					local added_by_ply = player.GetByAccountID(added_by_account_id)
					if (IsValid(added_by_ply)) then
						added_by_nick = "<color=" .. GAS:Unvectorize(team.GetColor(added_by_ply:Team())) .. ">" .. GAS:EscapeMarkup(added_by_ply:Nick()) .. "</color>"
					elseif (added_by_nick) then
						added_by_nick = GAS:EscapeMarkup(added_by_nick)
					else
						added_by_nick = GAS:EscapeMarkup(L"offline")
					end
				elseif (added_by_nick) then
					added_by_nick = GAS:EscapeMarkup(added_by_nick)
				else
					added_by_nick = ""
				end

				local row
				if (account_id) then -- SteamID64
					row = listing_data_table:AddRow(L"steamid", GAS:AccountIDToSteamID(account_id), user_nick, added_by_nick)
				elseif (usergroup) then -- Usergroup
					row = listing_data_table:AddRow(L"usergroup", GAS:EscapeMarkup(usergroup), "", added_by_nick)
				elseif (lua_function) then -- Lua Function
					row = listing_data_table:AddRow(L"lua_function", GAS:EscapeMarkup(lua_function), "", added_by_nick)
				end
				row.AccountID_1 = account_id
				row.AccountID_2 = added_by_account_id
			end
		else
			pagination:SetPages(1)
		end
	end
	GAS.JobWhitelist:GetListDataPage(is_blacklist, job_index, 1, listing_data_table.PopulateTable)

	return pagination
end

local logo_mat = Material("gmodadminsuite/bwhitelist.vtf")
GAS:hook("gmodadminsuite:ModuleFrame:jobwhitelist", "jobwhitelist:menu", function(ModuleFrame)
	GAS.JobWhitelist.Menu = ModuleFrame

	ModuleFrame.Tabs = vgui.Create("bVGUI.Tabs", ModuleFrame)
	ModuleFrame.Tabs:Dock(TOP)
	ModuleFrame.Tabs:SetTall(40)

	local jobs_tab_content = ModuleFrame.Tabs:AddTab(L"jobs", bVGUI.COLOR_GMOD_BLUE)

	jobs_tab_content.Logo = vgui.Create("DImage", jobs_tab_content)
	jobs_tab_content.Logo:SetSize(256, 256)
	jobs_tab_content.Logo:SetMaterial(logo_mat)

	jobs_tab_content.LogoBtnContainer = vgui.Create("bVGUI.BlankPanel", jobs_tab_content)
	jobs_tab_content.LogoBtnContainer:SetWide(150)

	local script_page = vgui.Create("bVGUI.Button", jobs_tab_content.LogoBtnContainer)
	script_page:SetText(L"script_page")
	script_page:Dock(TOP)
	script_page:DockMargin(0,0,0,10)
	script_page:SetColor(bVGUI.BUTTON_COLOR_RED)
	function script_page:DoClick()
		GAS:OpenURL("https://gmodsto.re/bwhitelist")
	end

	local wiki = vgui.Create("bVGUI.Button", jobs_tab_content.LogoBtnContainer)
	wiki:SetText(L"wiki")
	wiki:Dock(TOP)
	wiki:DockMargin(0,0,0,10)
	wiki:SetColor(bVGUI.BUTTON_COLOR_GREEN)
	function wiki:DoClick()
		GAS:OpenURL("https://gmodsto.re/bwhitelist-wiki")
	end

	local discord = vgui.Create("bVGUI.Button", jobs_tab_content.LogoBtnContainer)
	discord:SetText("Discord")
	discord:Dock(TOP)
	discord:DockMargin(0,0,0,10)
	discord:SetColor(Color(114, 137, 218))
	function discord:DoClick()
		GAS:OpenURL("https://gmodsto.re/gmodadminsuite-discord")
	end

	jobs_tab_content.LogoBtnContainer:SetTall(3 * (30 + 10))

	jobs_tab_content.Categories = vgui.Create("bVGUI.Categories", jobs_tab_content)
	jobs_tab_content.Categories:Dock(LEFT)
	jobs_tab_content.Categories:SetWide(175)
	jobs_tab_content.Categories:EnableSearchBar()
	jobs_tab_content.Categories:SetLoading(true)
	function jobs_tab_content:PerformLayout()
		if (IsValid(self.Logo) and IsValid(self.LogoBtnContainer)) then
			local x,y = self.Categories:GetWide() / 2 + self:GetWide() / 2 - self.Logo:GetWide() / 2, self:GetTall() / 2 - self.Logo:GetTall() / 2 - self.LogoBtnContainer:GetTall() / 2 - 20
			self.Logo:SetPos(x,y)
			self.LogoBtnContainer:SetPos(x + self.Logo:GetWide() / 2 - self.LogoBtnContainer:GetWide() / 2,y + 209 + 20)
		end
	end
	function jobs_tab_content:RemoveLogo()
		if (IsValid(self.Logo) and IsValid(self.LogoBtnContainer)) then
			self.Logo:Remove()
			self.LogoBtnContainer:Remove()
		end
	end
	function jobs_tab_content:PaintOver(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
		surface.DrawTexturedRect(self.Categories:GetWide(),0,10,h)
	end

	function jobs_tab_content.Categories:LoadContent()
		local duplicate_job_names_check, duplicate_jobs = {}, {}
		jobs_tab_content.Categories:SetLoading(false)
		for _,category in ipairs(DarkRP.getCategories().jobs) do
			if (#category.members == 0) then continue end
			local category_vgui
			for _,job in ipairs(category.members) do
				local job_index = job.team
				local perms_job_identifier = OpenPermissions:GetTeamIdentifier(job_index)
				if (not GAS.JobWhitelist:CanAccessJob(LocalPlayer(), perms_job_identifier)) then continue end
				category_vgui = category_vgui or jobs_tab_content.Categories:AddCategory(category.name, category.color)
				if (duplicate_job_names_check[job.name]) then
					duplicate_jobs[job.name] = true
					continue
				else
					duplicate_job_names_check[job.name] = true
				end
				category_vgui:AddItem(job.name, nil, job.color).ItemFunction = function()
					GAS.JobWhitelist.Menu.RequiresRefresh = nil
					jobs_tab_content:RemoveLogo()

					if (IsValid(jobs_tab_content.Content)) then
						jobs_tab_content.Content:Remove()
					end

					jobs_tab_content.Content = vgui.Create("bVGUI.LoadingPanel", jobs_tab_content)
					jobs_tab_content.Content:Dock(FILL)
					jobs_tab_content.Content:SetLoading(true)

					jobs_tab_content.Content.Title = vgui.Create("bVGUI.Header", jobs_tab_content.Content)
					jobs_tab_content.Content.Title:Dock(TOP)
					jobs_tab_content.Content.Title:SetText(job.name)
					jobs_tab_content.Content.Title:SetColor(job.color)

					GAS.JobWhitelist:GetJobData(job_index, function(whitelist_enabled, blacklist_enabled, autoswitch_disabled, is_default_whitelisted, is_default_blacklisted, autoswitch_setting_enabled)
						jobs_tab_content.Content:SetLoading(false)

						local is_operator = OpenPermissions:IsOperator(LocalPlayer())
						local can_enabledisable_whitelist = is_operator or OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_jobwhitelist/" .. perms_job_identifier .. "/whitelist/enable_disable")
						local can_enabledisable_blacklist = is_operator or OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_jobwhitelist/" .. perms_job_identifier .. "/blacklist/enable_disable")
						local can_modify_whitelist        = is_operator or GAS.JobWhitelist:CanModifyWhitelist(LocalPlayer(), perms_job_identifier)
						local can_modify_blacklist        = is_operator or GAS.JobWhitelist:CanModifyBlacklist(LocalPlayer(), perms_job_identifier)

						if ((GM or GAMEMODE).DefaultTeam ~= job_index and ((whitelist_enabled or can_enabledisable_whitelist) or (blacklist_enabled or can_enabledisable_blacklist))) then
							jobs_tab_content.Content.Tabs = vgui.Create("bVGUI.Tabs", jobs_tab_content.Content)
							jobs_tab_content.Content.Tabs:Dock(TOP)
							jobs_tab_content.Content.Tabs:SetTall(40)

							local whitelist_tab_content, whitelist_tab = jobs_tab_content.Content.Tabs:AddTab(L"whitelist", Color(76,218,100), can_modify_whitelist and whitelist_enabled)
							local whitelist_pagination
							if (whitelist_enabled) then
								whitelist_pagination = CreateListingMenu(whitelist_tab_content, job_index, false)
							end
							whitelist_tab:SetFunction(function()
								if (jobs_tab_content.Content.WhitelistTable) then
									jobs_tab_content.Content.WhitelistTable:InvalidateLayout(true)
								else
									whitelist_pagination = CreateListingMenu(whitelist_tab_content, job_index, false)
								end
							end)

							local blacklist_tab_content, blacklist_tab = jobs_tab_content.Content.Tabs:AddTab(L"blacklist", Color(216,75,75), can_modify_blacklist and blacklist_enabled)
							local blacklist_pagination
							if (blacklist_enabled) then
								blacklist_pagination = CreateListingMenu(blacklist_tab_content, job_index, true)
							end
							blacklist_tab:SetFunction(function()
								if (jobs_tab_content.Content.BlacklistTable) then
									jobs_tab_content.Content.BlacklistTable:InvalidateLayout(true)
								else
									blacklist_pagination = CreateListingMenu(blacklist_tab_content, job_index, true)
								end
							end)

							function jobs_tab_content.Content.Tabs:OnTabSelected(prev_tab, tab)
								if (GAS.JobWhitelist.Menu.RequiresRefresh or (tab == whitelist_tab and prev_tab == whitelist_tab) or (tab == blacklist_tab and prev_tab == blacklist_tab)) then
									local pagination
									if (tab == whitelist_tab) then
										pagination = whitelist_pagination
									elseif (tab == blacklist_tab) then
										pagination = blacklist_pagination
									else
										return
									end
									pagination:SetPage(1)
									pagination:OnPageSelected(1)
									GAS.JobWhitelist.Menu.RequiresRefresh = nil
								end
							end

							if (can_enabledisable_whitelist or can_enabledisable_blacklist) then
								local settings_tab_content = jobs_tab_content.Content.Tabs:AddTab(L"settings", bVGUI.COLOR_GMOD_BLUE)
								settings_tab_content:DockPadding(10,10,10,10)
								
								local default_whitelisted, default_blacklisted, clear_wlist, clear_blist

								if (can_enabledisable_whitelist) then
									local whitelist_checkbox = vgui.Create("bVGUI.Switch", settings_tab_content)
									whitelist_checkbox:SetChecked(whitelist_enabled)
									whitelist_checkbox:SetText(L"enable_whitelist")
									whitelist_checkbox:Dock(TOP)
									whitelist_checkbox:DockMargin(0,0,0,10)
									function whitelist_checkbox:OnChange()
										can_modify_whitelist = is_operator or GAS.JobWhitelist:CanModifyWhitelist(LocalPlayer(), perms_job_identifier)
										if (can_modify_whitelist) then
											whitelist_tab:SetEnabled(self:GetChecked())
										end
										GAS:netStart("jobwhitelist:enable_list")
											net.WriteBool(false)
											net.WriteBool(self:GetChecked())
											net.WriteUInt(job_index, 16)
										net.SendToServer()
										if (default_whitelisted) then
											default_whitelisted:SetDisabled(not self:GetChecked())
										end
										if (clear_wlist) then
											clear_wlist:SetDisabled(not self:GetChecked())
										end
									end
								end
								
								if (can_enabledisable_blacklist) then
									local blacklist_switch = vgui.Create("bVGUI.Switch", settings_tab_content)
									blacklist_switch:SetChecked(blacklist_enabled)
									blacklist_switch:SetText(L"enable_blacklist")
									blacklist_switch:Dock(TOP)
									blacklist_switch:DockMargin(0,0,0,10)
									function blacklist_switch:OnChange()
										can_modify_blacklist = is_operator or GAS.JobWhitelist:CanModifyBlacklist(LocalPlayer(), perms_job_identifier)
										if (can_modify_blacklist) then
											blacklist_tab:SetEnabled(self:GetChecked())
										end
										GAS:netStart("jobwhitelist:enable_list")
											net.WriteBool(true)
											net.WriteBool(self:GetChecked())
											net.WriteUInt(job_index, 16)
										net.SendToServer()
										if (default_blacklisted) then
											default_blacklisted:SetDisabled(not self:GetChecked())
										end
										if (clear_blist) then
											clear_blist:SetDisabled(not self:GetChecked())
										end
									end
								end
								
								if (is_operator) then
									default_whitelisted = vgui.Create("bVGUI.Switch", settings_tab_content)
									default_whitelisted:SetChecked(is_default_whitelisted)
									default_whitelisted:SetDisabled(not whitelist_enabled)
									default_whitelisted:SetText(L"default_whitelisted")
									default_whitelisted:Dock(TOP)
									default_whitelisted:DockMargin(0,0,0,10)
									function default_whitelisted:OnChange()
										GAS:netStart("jobwhitelist:default_whitelisted")
											net.WriteUInt(job_index, 16)
											net.WriteBool(self:GetChecked())
										net.SendToServer()
									end
									
									default_blacklisted = vgui.Create("bVGUI.Switch", settings_tab_content)
									default_blacklisted:SetChecked(is_default_blacklisted)
									default_blacklisted:SetDisabled(not blacklist_enabled)
									default_blacklisted:SetText(L"default_blacklisted")
									default_blacklisted:Dock(TOP)
									default_blacklisted:DockMargin(0,0,0,10)
									function default_blacklisted:OnChange()
										GAS:netStart("jobwhitelist:default_blacklisted")
											net.WriteUInt(job_index, 16)
											net.WriteBool(self:GetChecked())
										net.SendToServer()
									end
									
									local disable_autoswitch = vgui.Create("bVGUI.Switch", settings_tab_content)
									disable_autoswitch:SetChecked(autoswitch_disabled)
									disable_autoswitch:SetDisabled(not autoswitch_setting_enabled)
									disable_autoswitch:SetText(L"disable_autoswitch")
									disable_autoswitch:Dock(TOP)
									disable_autoswitch:DockMargin(0,0,0,10)
									function disable_autoswitch:OnChange()
										GAS:netStart("jobwhitelist:disable_autoswitch")
											net.WriteUInt(job_index, 16)
											net.WriteBool(self:GetChecked())
										net.SendToServer()
									end

									local clear_wlist_container = vgui.Create("bVGUI.BlankPanel", settings_tab_content)
									clear_wlist_container:Dock(TOP)
									clear_wlist_container:DockMargin(0,10,0,10)
									clear_wlist_container:SetTall(25)

									clear_wlist = vgui.Create("bVGUI.Button", clear_wlist_container)
									clear_wlist:SetSize(120,25)
									clear_wlist:SetText(L"clear_whitelist")
									clear_wlist:SetColor(bVGUI.BUTTON_COLOR_RED)
									function clear_wlist:DoClick()
										GAS:PlaySound("flash")
										Derma_Query(L"clear_whitelist_confirm", L"clear_whitelist", L"yes", function()
											GAS:PlaySound("delete")
											GAS:netStart("jobwhitelist:clear_whitelist")
												net.WriteUInt(job_index, 16)
											net.SendToServer()
										end, L"no")
									end

									local clear_blist_container = vgui.Create("bVGUI.BlankPanel", settings_tab_content)
									clear_blist_container:Dock(TOP)
									clear_blist_container:DockMargin(0,0,0,10)
									clear_blist_container:SetTall(25)

									clear_blist = vgui.Create("bVGUI.Button", clear_blist_container)
									clear_blist:SetSize(120,25)
									clear_blist:SetText(L"clear_blacklist")
									clear_blist:SetColor(bVGUI.BUTTON_COLOR_RED)
									function clear_blist:DoClick()
										GAS:PlaySound("flash")
										Derma_Query(L"clear_blacklist_confirm", L"clear_blacklist", L"yes", function()
											GAS:PlaySound("delete")
											GAS:netStart("jobwhitelist:clear_blacklist")
												net.WriteUInt(job_index, 16)
											net.SendToServer()
										end, L"no")
									end
								end
							end
						else
							jobs_tab_content.Content.Info = vgui.Create("bVGUI.BlankPanel", jobs_tab_content.Content)
							jobs_tab_content.Content.Info:Dock(FILL)
							jobs_tab_content.Content.Info:DockMargin(0,0,0,24)
							local font = bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 16)
							if ((GM or GAMEMODE).DefaultTeam == job_index) then
								local phrase = L"default_team_error"
								function jobs_tab_content.Content.Info:PaintOver(w,h)
									draw.SimpleText(phrase, font, w / 2, h / 2 - 16 / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
								end
							else
								local phrase = string.Explode("\n", L"insufficient_permissions_jobwhitelist")
								function jobs_tab_content.Content.Info:PaintOver(w,h)
									draw.SimpleText(phrase[1], font, w / 2, h / 2 - 16 / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
									draw.SimpleText(phrase[2], font, w / 2, h / 2 + 16 / 2, bVGUI.COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
							end
						end
					end)
				end
			end
		end

		if (not table.IsEmpty(duplicate_jobs)) then
			Derma_Message("You have duplicate jobs! Please change their names or remove them:\n\n" .. table.concat(table.GetKeys(duplicate_jobs), "\n"), "bWhitelist", "Dismiss")
		end
	end

	local player_tab_content, players_tab = ModuleFrame.Tabs:AddTab(L"players", bVGUI.COLOR_PURPLE)
	players_tab:SetFunction(function()
		if (IsValid(player_tab_content.Content)) then
			player_tab_content.Content:Remove()
		end
		player_tab_content.Content = vgui.Create("bVGUI.BlankPanel", player_tab_content)
		player_tab_content.Content:Dock(FILL)

		local refresh_container = vgui.Create("DPanel", player_tab_content.Content)
		refresh_container:Dock(BOTTOM)
		refresh_container:SetTall(30)
		function refresh_container:Paint(w,h)
			surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
			surface.DrawRect(0,0,w,h)
		end

		local refresh_text = vgui.Create("DLabel", refresh_container)
		refresh_text:SetFont(bVGUI.FONT(bVGUI.FONT_RUBIK, "REGULAR", 14))
		refresh_text:SetTextColor(bVGUI.COLOR_WHITE)
		refresh_text:SetMouseInputEnabled(true)
		refresh_text:SetCursor("hand")
		local o = refresh_text.OnMouseReleased
		function refresh_text:OnMouseReleased(m)
			if (m ~= MOUSE_LEFT) then return end
			GAS:PlaySound("flash")
			player_tab_content.Table.RefreshTime = CurTime()
			o(self, m)
		end

		player_tab_content.Table = vgui.Create("bVGUI.Table", player_tab_content.Content)
		player_tab_content.Table:Dock(FILL)
		player_tab_content.Table:AddColumn(L"name", bVGUI.TABLE_COLUMN_GROW)
		player_tab_content.Table:AddColumn(L"job", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
		player_tab_content.Table:AddColumn(L"usergroup", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
		player_tab_content.Table:AddColumn(L"distance", bVGUI.TABLE_COLUMN_SHRINK, TEXT_ALIGN_CENTER)
		player_tab_content.Table:SetRowCursor("hand")
		player_tab_content.Table:SetCookieName("gmodadminsuite:jobwhitelist:")
		function player_tab_content.Table:OnColumnHovered(row, column_index)
			if (column_index ~= nil) then
				if (self.HoveredPlayer ~= row.Player) then
					self.HoveredPlayer = row.Player
					local options_tip = self:GetCookie("options_tip", "0")
					if (options_tip == "0") then
						bVGUI.CreateTooltip({
							Text = L"click_for_options_tip",
							VGUI_Element = row
						})
					end
					bVGUI.PlayerTooltip.Create({
						player = row.Player,
						copiedphrase = L"copied",
						creator = row,
						focustip = L"right_click_to_focus"
					})
				end
			else
				self.HoveredPlayer = nil
				bVGUI.PlayerTooltip.Close()
			end
		end
		function player_tab_content.Table:OnRowClicked(row)
			player_tab_content.Table:SetCookie("options_tip", "1")
			if (IsValid(row.Player)) then
				GAS:PlaySound("flash")
				local menu = DermaMenu()
				GAS.JobWhitelist:OpenContextMenu(menu, row.Player)
				menu:Open()
			else
				bVGUI.PlayerTooltip.Focus()
			end
		end
		function player_tab_content.Table:OnRowRightClicked(row)
			bVGUI.PlayerTooltip.Focus()
		end
		function player_tab_content.Table:Think()
			if (self.RefreshTime) then
				local seconds_left = math.max(math.Round(self.RefreshTime - CurTime()), 0)
				if (seconds_left == 0) then
					refresh_text:SetText(L"refreshing_ellipsis")
				elseif (seconds_left == 1) then
					refresh_text:SetText(L"refreshing_in_1_second")
				else
					refresh_text:SetText(L("refreshing_in_seconds", seconds_left))
				end
				refresh_text:SizeToContents()
				refresh_text:Center()
			end
			if (not self.RefreshTime or CurTime() >= self.RefreshTime) then
				self.RefreshTime = CurTime() + 20

				self:Clear()
				local distances = {}
				for _,v in ipairs(player.GetHumans()) do
					table.insert(distances, {ply = v, dist = math.Round(v:GetPos():Distance(LocalPlayer():GetPos()) / 16 * 0.3048)})
				end
				table.SortByMember(distances, "dist", true)
				for _,v in ipairs(distances) do
					local job = team.GetName(v.ply:Team())
					local job_col = team.GetColor(v.ply:Team())
					local row = self:AddRow(GAS:EscapeMarkup(v.ply:Nick()), "<color=" .. job_col.r .. "," .. job_col.g .. "," .. job_col.b .. ",255>" .. GAS:EscapeMarkup(job) .. "</color>", GAS:EscapeMarkup(v.ply:GetUserGroup()), v.dist .. "m")
					row.Player = v.ply
				end
			end
		end
	end)	

	if (OpenPermissions:IsOperator(LocalPlayer())) then
		local operator_tab_content, operator_tab = ModuleFrame.Tabs:AddTab(L"operator", Color(216,75,75))
			operator_tab_content.Tabs = vgui.Create("bVGUI.Tabs", operator_tab_content)
			operator_tab_content.Tabs:Dock(TOP)
			operator_tab_content.Tabs:SetTall(40)

			local settings_tab_content, settings_tab = operator_tab_content.Tabs:AddTab(L"settings", Color(216,75,75))
			settings_tab:SetFunction(function()
				if (IsValid(settings_tab_content.Content)) then
					settings_tab_content.Content:Remove()
				end
				settings_tab_content.Content = vgui.Create("bVGUI.LoadingScrollPanel", settings_tab_content)
				settings_tab_content.Content:Dock(FILL)
				settings_tab_content.Content:DockPadding(0,0,0,20)
				settings_tab_content.Content:SetLoading(true)

				GAS:GetConfig("jobwhitelist", function(config)
					settings_tab_content.Content:SetLoading(false)

					if (config.OldDataPresent) then
						local convert_btn_c = vgui.Create("bVGUI.ButtonContainer", settings_tab_content.Content)
						convert_btn_c:Dock(TOP)
						convert_btn_c:SetTall(25)
						convert_btn_c:DockMargin(10,10,0,0)

						local convert_btn = convert_btn_c.Button
						convert_btn:SetColor(bVGUI.BUTTON_COLOR_RED)
						convert_btn:SetText(L"convert_old_data")
						convert_btn:SetSize(175,25)
						function convert_btn:DoClick()
							GAS:PlaySound("success")
							bVGUI.MouseInfoTooltip.Create(bVGUI.L("done_exclamation"))

							GAS:netStart("jobwhitelist:ConvertOldData")
							net.SendToServer()

							self:SetDisabled(true)
						end
					end

					local permissions_btn_c = vgui.Create("bVGUI.ButtonContainer", settings_tab_content.Content)
					permissions_btn_c:Dock(TOP)
					permissions_btn_c:SetTall(25)
					permissions_btn_c:DockMargin(10,10,0,0)

					local permissions_btn = permissions_btn_c.Button
					permissions_btn:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
					permissions_btn:SetText(L"permissions")
					permissions_btn:SetSize(150,25)
					function permissions_btn:DoClick()
						GAS:PlaySound("flash")
						RunConsoleCommand("openpermissions", "gmodadminsuite_jobwhitelist")
					end

					local OperatorsSkipWhitelists = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					OperatorsSkipWhitelists:Dock(TOP)
					OperatorsSkipWhitelists:SetText("OperatorsSkipWhitelists")
					OperatorsSkipWhitelists:DockMargin(10,10,0,0)
					OperatorsSkipWhitelists:SetHelpText(L"OperatorsSkipWhitelists_help")
					OperatorsSkipWhitelists:SetChecked(config.OperatorsSkipWhitelists)
					function OperatorsSkipWhitelists:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("OperatorsSkipWhitelists")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local OperatorsSkipBlacklists = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					OperatorsSkipBlacklists:Dock(TOP)
					OperatorsSkipBlacklists:SetText("OperatorsSkipBlacklists")
					OperatorsSkipBlacklists:DockMargin(10,10,0,0)
					OperatorsSkipBlacklists:SetHelpText(L"OperatorsSkipBlacklists_help")
					OperatorsSkipBlacklists:SetChecked(config.OperatorsSkipBlacklists)
					function OperatorsSkipBlacklists:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("OperatorsSkipBlacklists")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local ShowUnjoinableJobs = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					ShowUnjoinableJobs:Dock(TOP)
					ShowUnjoinableJobs:SetText("ShowUnjoinableJobs")
					ShowUnjoinableJobs:DockMargin(10,20,0,0)
					ShowUnjoinableJobs:SetHelpText(L"ShowUnjoinableJobs_help")
					ShowUnjoinableJobs:SetChecked(config.ShowUnjoinableJobs)
					function ShowUnjoinableJobs:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("ShowUnjoinableJobs")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local ContextMenu = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					ContextMenu:Dock(TOP)
					ContextMenu:SetText("ContextMenu")
					ContextMenu:DockMargin(10,20,0,0)
					ContextMenu:SetHelpText(L"ContextMenu_help")
					ContextMenu:SetChecked(config.ContextMenu)
					function ContextMenu:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("ContextMenu")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local FunctionMenuKey = vgui.Create("bVGUI.OptionSelector", settings_tab_content.Content)
					FunctionMenuKey:Dock(TOP)
					FunctionMenuKey:SetText("FunctionMenuKey")
					FunctionMenuKey:DockMargin(10,20,0,0)
					FunctionMenuKey:AddButton(L"off")
					FunctionMenuKey:AddButton("F1")
					FunctionMenuKey:AddButton("F2")
					FunctionMenuKey:AddButton("F3")
					FunctionMenuKey:AddButton("F4")
					FunctionMenuKey:SetHelpText(L"FunctionMenuKey_help")
					FunctionMenuKey:SetValue(config.FunctionMenuKey)
					function FunctionMenuKey:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("FunctionMenuKey")
							net.WriteString(self:GetValue())
						net.SendToServer()
					end

					local AutoSwitch = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					AutoSwitch:Dock(TOP)
					AutoSwitch:SetText("AutoSwitch")
					AutoSwitch:DockMargin(10,20,0,0)
					AutoSwitch:SetHelpText(L"AutoSwitch_help")
					AutoSwitch:SetChecked(config.AutoSwitch)
					function AutoSwitch:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("AutoSwitch")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local SwitchJobOnUnwhitelist = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					SwitchJobOnUnwhitelist:Dock(TOP)
					SwitchJobOnUnwhitelist:SetText("SwitchJobOnUnwhitelist")
					SwitchJobOnUnwhitelist:DockMargin(10,20,0,0)
					SwitchJobOnUnwhitelist:SetHelpText(L"SwitchJobOnUnwhitelist_help")
					SwitchJobOnUnwhitelist:SetChecked(config.SwitchJobOnUnwhitelist)
					function SwitchJobOnUnwhitelist:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("SwitchJobOnUnwhitelist")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local SwitchJobOnBlacklist = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					SwitchJobOnBlacklist:Dock(TOP)
					SwitchJobOnBlacklist:SetText("SwitchJobOnBlacklist")
					SwitchJobOnBlacklist:DockMargin(10,20,0,0)
					SwitchJobOnBlacklist:SetHelpText(L"SwitchJobOnBlacklist_help")
					SwitchJobOnBlacklist:SetChecked(config.SwitchJobOnBlacklist)
					function SwitchJobOnBlacklist:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("SwitchJobOnBlacklist")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local NotWhitelistedMsg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					NotWhitelistedMsg:Dock(TOP)
					NotWhitelistedMsg:SetLabel("NotWhitelistedMsg")
					NotWhitelistedMsg:DockMargin(10,20,0,0)
					NotWhitelistedMsg:SetHelpText(L"NotWhitelistedMsg_help")
					NotWhitelistedMsg.TextEntry:SetValue(config.NotWhitelistedMsg)
					function NotWhitelistedMsg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("NotWhitelistedMsg")
							net.WriteString(val)
						net.SendToServer()
					end

					local BlacklistedMsg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					BlacklistedMsg:Dock(TOP)
					BlacklistedMsg:SetLabel("BlacklistedMsg")
					BlacklistedMsg:DockMargin(10,20,0,0)
					BlacklistedMsg:SetHelpText(L"BlacklistedMsg_help")
					BlacklistedMsg.TextEntry:SetValue(config.BlacklistedMsg)
					function BlacklistedMsg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("BlacklistedMsg")
							net.WriteString(val)
						net.SendToServer()
					end

					local NotifyWhitelisted = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					NotifyWhitelisted:Dock(TOP)
					NotifyWhitelisted:SetText("NotifyWhitelisted")
					NotifyWhitelisted:DockMargin(10,20,0,0)
					NotifyWhitelisted:SetHelpText(L"NotifyWhitelisted_help")
					NotifyWhitelisted:SetChecked(config.NotifyWhitelisted)
					function NotifyWhitelisted:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("NotifyWhitelisted")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local NotifyWhitelisted_Msg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					NotifyWhitelisted_Msg:Dock(TOP)
					NotifyWhitelisted_Msg:SetLabel("NotifyWhitelisted_Msg")
					NotifyWhitelisted_Msg:DockMargin(10,20,0,0)
					NotifyWhitelisted_Msg:SetHelpText(L"NotifyWhitelisted_Msg_help")
					NotifyWhitelisted_Msg.TextEntry:SetValue(config.NotifyWhitelisted_Msg)
					function NotifyWhitelisted_Msg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("NotifyWhitelisted_Msg")
							net.WriteString(val)
						net.SendToServer()
					end

					local NotifyUnwhitelisted = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					NotifyUnwhitelisted:Dock(TOP)
					NotifyUnwhitelisted:SetText("NotifyUnwhitelisted")
					NotifyUnwhitelisted:DockMargin(10,20,0,0)
					NotifyUnwhitelisted:SetHelpText(L"NotifyUnwhitelisted_help")
					NotifyUnwhitelisted:SetChecked(config.NotifyUnwhitelisted)
					function NotifyUnwhitelisted:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("NotifyUnwhitelisted")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local NotifyUnwhitelisted_Msg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					NotifyUnwhitelisted_Msg:Dock(TOP)
					NotifyUnwhitelisted_Msg:SetLabel("NotifyUnwhitelisted_Msg")
					NotifyUnwhitelisted_Msg:DockMargin(10,20,0,0)
					NotifyUnwhitelisted_Msg:SetHelpText(L"NotifyUnwhitelisted_Msg_help")
					NotifyUnwhitelisted_Msg.TextEntry:SetValue(config.NotifyUnwhitelisted_Msg)
					function NotifyUnwhitelisted_Msg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("NotifyUnwhitelisted_Msg")
							net.WriteString(val)
						net.SendToServer()
					end

					local NotifyBlacklisted = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					NotifyBlacklisted:Dock(TOP)
					NotifyBlacklisted:SetText("NotifyBlacklisted")
					NotifyBlacklisted:DockMargin(10,20,0,0)
					NotifyBlacklisted:SetHelpText(L"NotifyBlacklisted_help")
					NotifyBlacklisted:SetChecked(config.NotifyBlacklisted)
					function NotifyBlacklisted:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("NotifyBlacklisted")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local NotifyBlacklisted_Msg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					NotifyBlacklisted_Msg:Dock(TOP)
					NotifyBlacklisted_Msg:SetLabel("NotifyBlacklisted_Msg")
					NotifyBlacklisted_Msg:DockMargin(10,20,0,0)
					NotifyBlacklisted_Msg:SetHelpText(L"NotifyBlacklisted_Msg_help")
					NotifyBlacklisted_Msg.TextEntry:SetValue(config.NotifyBlacklisted_Msg)
					function NotifyBlacklisted_Msg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("NotifyBlacklisted_Msg")
							net.WriteString(val)
						net.SendToServer()
					end

					local NotifyUnblacklisted = vgui.Create("bVGUI.Switch", settings_tab_content.Content)
					NotifyUnblacklisted:Dock(TOP)
					NotifyUnblacklisted:SetText("NotifyUnblacklisted")
					NotifyUnblacklisted:DockMargin(10,20,0,0)
					NotifyUnblacklisted:SetHelpText(L"NotifyUnblacklisted_help")
					NotifyUnblacklisted:SetChecked(config.NotifyUnblacklisted)
					function NotifyUnblacklisted:OnChange()
						GAS:netStart("jobwhitelist:ChangeSetting:bool")
							net.WriteString("NotifyUnblacklisted")
							net.WriteBool(self:GetChecked())
						net.SendToServer()
					end

					local NotifyUnblacklisted_Msg = vgui.Create("bVGUI.TextEntryContainer", settings_tab_content.Content)
					NotifyUnblacklisted_Msg:Dock(TOP)
					NotifyUnblacklisted_Msg:SetLabel("NotifyUnblacklisted_Msg")
					NotifyUnblacklisted_Msg:DockMargin(10,20,0,0)
					NotifyUnblacklisted_Msg:SetHelpText(L"NotifyUnblacklisted_Msg_help")
					NotifyUnblacklisted_Msg.TextEntry:SetValue(config.NotifyUnblacklisted_Msg)
					function NotifyUnblacklisted_Msg.TextEntry:OnValueChange(val)
						GAS:netStart("jobwhitelist:ChangeSetting:string")
							net.WriteString("NotifyUnblacklisted_Msg")
							net.WriteString(val)
						net.SendToServer()
					end

					local padding = vgui.Create("bVGUI.BlankPanel", settings_tab_content.Content)
					padding:Dock(TOP)
					padding:SetTall(10)
				end)
			end)
			
			local operator_tab_clicked_on = false
			operator_tab:SetFunction(function()
				if (operator_tab_clicked_on) then return end
				operator_tab_clicked_on = true
				settings_tab:OnMouseReleased(MOUSE_LEFT)
			end)

			local factions_content, factions_tab = operator_tab_content.Tabs:AddTab(L"factions", Color(76,76,216))
			factions_content.Tabs = vgui.Create("bVGUI.Tabs", factions_content)
			factions_content.Tabs:Dock(TOP)
			factions_content.Tabs:SetTall(40)

			local factions_settings, factions_settings_tab = factions_content.Tabs:AddTab(L"settings", Color(115,0,255))
			local factions_settings_content
			factions_settings_tab:SetFunction(function()
				if (IsValid(factions_settings_content)) then
					factions_settings_content:Remove()
				end
				factions_settings_content = vgui.Create("bVGUI.LoadingPanel", factions_settings)
				factions_settings_content:Dock(FILL)
				factions_settings_content:SetLoading(true)

				GAS:GetConfig("jobwhitelist_factions", function(config)
					GAS.JobWhitelist.Factions.Config = config
					factions_settings_content:SetLoading(false)

					factions_settings_content.Form = vgui.Create("bVGUI.Form", factions_settings_content)
					factions_settings_content.Form:Dock(FILL)
					factions_settings_content.Form:SetPaddings(15,15)
					factions_settings_content.Form:DockMargin(10,10,10,10)

					factions_settings_content.Form:AddSwitch(L"enable_factions", config.Enabled, "", function(checked)
						config.Enabled = checked
						GAS:netStart("factions:ChangeConfig:bool")
							net.WriteString("Enabled")
							net.WriteBool(checked)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddSwitch(L"factions_ShowOnFirstJoin", config.ShowOnFirstJoin, L"factions_ShowOnFirstJoin_help", function(checked)
						config.ShowOnFirstJoin = checked
						GAS:netStart("factions:ChangeConfig:bool")
							net.WriteString("ShowOnFirstJoin")
							net.WriteBool(checked)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddSwitch(L"factions_ShowOnEveryJoin", config.ShowOnEveryJoin, L"factions_ShowOnEveryJoin_help", function(checked)
						config.ShowOnEveryJoin = checked
						GAS:netStart("factions:ChangeConfig:bool")
							net.WriteString("ShowOnEveryJoin")
							net.WriteBool(checked)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddSwitch(L"factions_ShowOnEverySpawn", config.ShowOnEverySpawn, L"factions_ShowOnEverySpawn_help", function(checked)
						config.ShowOnEverySpawn = checked
						GAS:netStart("factions:ChangeConfig:bool")
							net.WriteString("ShowOnEverySpawn")
							net.WriteBool(checked)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddTextEntry(L"chat_command", config.ChatCommand or "", L"blank_to_disable", function(val)
						if (#val == 0) then
							config.ChatCommand = false
							GAS:netStart("factions:ChangeConfig:bool")
								net.WriteString("ChatCommand")
								net.WriteBool(false)
							net.SendToServer()
						else
							config.ChatCommand = val
							GAS:netStart("factions:ChangeConfig:string")
								net.WriteString("ChatCommand")
								net.WriteString(val)
							net.SendToServer()
						end
					end)
					factions_settings_content.Form:AddTextEntry(L"console_command", config.ConsoleCommand or "", L"blank_to_disable", function(val)
						if (#val == 0) then
							config.ConsoleCommand = false
							GAS:netStart("factions:ChangeConfig:bool")
								net.WriteString("ConsoleCommand")
								net.WriteBool(false)
							net.SendToServer()
						else
							config.ConsoleCommand = val
							GAS:netStart("factions:ChangeConfig:string")
								net.WriteString("ConsoleCommand")
								net.WriteString(val)
							net.SendToServer()
						end
					end)

					factions_settings_content.Form:AddTextEntry(L"factions_HelpText", config.HelpText, L"factions_HelpText_help", function(val)
						config.HelpText = val
						GAS:netStart("factions:ChangeConfig:string")
							net.WriteString("HelpText")
							net.WriteString(val)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddTextEntry(L"factions_OnPopupSound", config.OnPopupSound, L"factions_OnPopupSound_help", function(val)
						config.OnPopupSound = val
						GAS:netStart("factions:ChangeConfig:string")
							net.WriteString("OnPopupSound")
							net.WriteString(val)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddTextEntry(L"factions_OnHoverSound", config.OnHoverSound, L"factions_OnHoverSound_help", function(val)
						config.OnHoverSound = val
						GAS:netStart("factions:ChangeConfig:string")
							net.WriteString("OnHoverSound")
							net.WriteString(val)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddTextEntry(L"factions_OnSelectionSound", config.OnSelectionSound, L"factions_OnSelectionSound_help", function(val)
						config.OnSelectionSound = val
						GAS:netStart("factions:ChangeConfig:string")
							net.WriteString("OnSelectionSound")
							net.WriteString(val)
						net.SendToServer()
					end)

					factions_settings_content.Form:AddTextEntry(L"factions_PermissionDeniedSound", config.PermissionDeniedSound, L"factions_PermissionDeniedSound_help", function(val)
						config.PermissionDeniedSound = val
						GAS:netStart("factions:ChangeConfig:string")
							net.WriteString("PermissionDeniedSound")
							net.WriteString(val)
						net.SendToServer()
					end)
				end)
			end)
			factions_tab:SetFunction(function()
				factions_settings_tab:OnMouseReleased(MOUSE_LEFT)
			end)

			local edit_factions_content, edit_factions_tab = factions_content.Tabs:AddTab(L"edit_factions", Color(255,125,0))
			edit_factions_tab:SetFunction(function()
				if (IsValid(edit_factions_content.Content)) then
					edit_factions_content.Content:Remove()
				end
				edit_factions_content.Content = vgui.Create("bVGUI.BlankPanel", edit_factions_content)
				edit_factions_content.Content:Dock(FILL)

				function edit_factions_content.Content:PaintOver(w,h)
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(bVGUI.MATERIAL_SHADOW)
					surface.DrawTexturedRect(175,0,10,h)
				end

				local content_container, factions_categories, faction_category

				local function populate_faction_content()
					if (IsValid(content_container)) then
						content_container:Remove()
					end

					content_container = vgui.Create("bVGUI.BlankPanel", edit_factions_content.Content)
					content_container:Dock(FILL)
					content_container.Accessors = {}

					local save_faction, delete_faction

					local logo_container = vgui.Create("bVGUI.BlankPanel", content_container)
					logo_container:Dock(TOP)
					logo_container:DockMargin(0,10,0,0)
					logo_container:SetTall(128 + 20)
					function logo_container:Paint(w,h)
						surface.SetDrawColor(0,0,0,200)
						surface.DrawRect((w - (128 + 20)) / 2,0,128 + 20,h)

						if (content_container.URL._Invalid) then
							surface.SetDrawColor(255,0,0,100)
							surface.DrawRect((w - 128) / 2,10,128,h - 20)
						end
					end

					local loading = vgui.Create("bVGUI.LoadingPanel", logo_container)
					loading:Dock(FILL)
					loading:SetLoading(false)

					logo_container.Logo = vgui.Create("DImage", logo_container)
					logo_container.Logo:SetSize(128,128)
					logo_container.Logo:SetMaterial(logo_mat)

					local url_container = vgui.Create("bVGUI.BlankPanel", content_container)
					url_container:Dock(TOP)
					url_container:DockMargin(0,10,0,0)
					url_container:SetTall(25)

					content_container.URL = vgui.Create("bVGUI.TextEntry", url_container)
					content_container.URL:SetPlaceholderText(L"logo_url")
					content_container.URL:SetSize(128 + 20 + 40, 25)
					function content_container.URL:OnLoseFocus()
						self:ResetValidity()
						if (self:GetValue() == "") then
							logo_container.Logo:SetVisible(true)
							logo_container.Logo:SetMaterial(logo_mat)
							return save_faction:DoVerification()
						else
							save_faction:DoVerification()
						end

						logo_container.Logo:SetVisible(false)
						loading:SetLoading(true)

						local crc = util.CRC(os.date("%d%m%Y") .. self:GetValue()) .. ".png"

						http.Fetch(self:GetValue(), function(body, size, headers, code)
							loading:SetLoading(false)
							if (body:find("^.PNG")) then
								file.Write("gas_jobwhitelist_faction_imgs/" .. crc, body)
								logo_container.Logo:SetVisible(true)
								logo_container.Logo:SetMaterial(Material("data/gas_jobwhitelist_faction_imgs/" .. crc))
								self:SetValid(true)
							else
								self:SetInvalid(true)
							end
							save_faction:DoVerification()
						end, function()
							loading:SetLoading(false)
							self:SetInvalid(true)
							save_faction:DoVerification()
						end)
					end

					function logo_container:PerformLayout()
						self.Logo:Center()
					end
					function url_container:PerformLayout()
						content_container.URL:Center()
					end

					save_faction = vgui.Create("bVGUI.Button", content_container)
					save_faction:SetColor(bVGUI.BUTTON_COLOR_GREEN)
					save_faction:SetText(L"save_faction")
					save_faction:SetSize(140,25)
					save_faction:AlignLeft(10)
					save_faction:AlignTop(10)
					save_faction:SetDisabled(true)
					function save_faction:DoClick()
						GAS:PlaySound("success")
						delete_faction:SetDisabled(false)

						GAS:netStart("factions:new")
							net.WriteString(content_container.Accessors.FactionName:GetValue())
							net.WriteString(content_container.Accessors.FactionDescription:GetValue())
							net.WriteString(content_container.Accessors.Logo:GetValue())
							net.WriteBool(content_container.Accessors.ShowIfNotPermitted:GetChecked())
							net.WriteUInt(content_container.Accessors.SetTeam.TeamIndex, 8)

							net.WriteUInt(table.Count(content_container.Accessors.WhitelistedTo), 8)
							for t in pairs(content_container.Accessors.WhitelistedTo) do
								net.WriteUInt(t, 8)
							end

							net.WriteUInt(table.Count(content_container.Accessors.BlacklistedFrom), 8)
							for t in pairs(content_container.Accessors.BlacklistedFrom) do
								net.WriteUInt(t, 8)
							end

							if (content_container.Accessors.DeleteFaction.FactionID ~= nil) then
								net.WriteBool(true)
								net.WriteUInt(content_container.Accessors.DeleteFaction.FactionID, 16)
							else
								net.WriteBool(false)
							end
						net.SendToServer()

						bVGUI.MouseInfoTooltip.Create(L"saved_exclamation")

						GAS:netReceive("factions:new", function()
							if (IsValid(edit_factions_tab)) then
								edit_factions_tab:OnMouseReleased(MOUSE_LEFT)
							end
						end)
					end

					delete_faction = vgui.Create("bVGUI.Button", content_container)
					delete_faction:SetColor(bVGUI.BUTTON_COLOR_RED)
					delete_faction:SetText(L"delete_faction")
					delete_faction:SetSize(140,25)
					delete_faction:AlignLeft(10)
					delete_faction:AlignTop(10 + 25 + 10)
					delete_faction:SetDisabled(true)
					function delete_faction:DoClick()
						GAS:PlaySound("btn_heavy")

						bVGUI.Query(L"delete_faction_confirm", L"confirm_action", L"yes", function()
							GAS:PlaySound("delete")

							content_container:Remove()
							factions_categories:RemoveItem(self.CategoriesItem)

							GAS:netStart("factions:delete")
								net.WriteUInt(self.FactionID, 16)
							net.SendToServer()

							GAS:UncacheConfig("jobwhitelist_factions")
							edit_factions_tab:OnMouseReleased(MOUSE_LEFT)
						end, L"no", function()
							GAS:PlaySound("btn_heavy")
						end)
					end

					local form = vgui.Create("bVGUI.Form", content_container)
					form:Dock(FILL)
					form:DockMargin(10,25,10,10)
					form:SetPaddings(15,15)

					local _, FactionName = form:AddTextEntry(L"faction_name", "", L"faction_name_tip", function()
						save_faction:DoVerification()
					end)

					local _, FactionDescription = form:AddLongTextEntry(L"description", "", L"faction_description_tip", function()
						save_faction:DoVerification()
					end)

					local _, ShowIfNotPermitted = form:AddSwitch(L"ShowIfNotPermitted", true, L"ShowIfNotPermitted_help")

					local _, SetTeam
					_, SetTeam = form:AddButton(L"SetTeam", bVGUI.BUTTON_COLOR_BLUE, L"SetTeam_help", function()
						GAS.SelectionPrompts:PromptTeam(function(team_index)
							SetTeam:SetColor(team.GetColor(team_index))
							SetTeam:SetText(team.GetName(team_index))
							SetTeam.TeamIndex = team_index

							save_faction:DoVerification()
						end)
					end)

					local function WhatDoICallThisFunction(tbl)
						local menu = DermaMenu()

						local categories = {}
						for i,c in ipairs(DarkRP.getCategories().jobs) do
							if (GAS:table_IsEmpty(c.members)) then continue end
							table.insert(categories, {members = c.members, name = c.name, color = c.color})
						end
						table.SortByMember(categories, "name", true)
						for i,v in ipairs(categories) do
							local submenu, _submenu = menu:AddSubMenu(v.name)
							bVGUI_DermaMenuOption_ColorIcon(_submenu, v.color)

							local teams = {}
							for i,t in ipairs(v.members) do
								table.insert(teams, {index = t.team, name = t.name})
							end
							table.SortByMember(teams, "name", true)
							for i,v in ipairs(teams) do
								local op = submenu:AddOption(v.name)
								function op:OnMouseReleased(m)
									DButton.OnMouseReleased(self, m)
									if (m ~= MOUSE_LEFT or not self.m_MenuClicking) then return end
									self.m_MenuClicking = false

									if (tbl[v.index]) then
										GAS:PlaySound("delete")
										tbl[v.index] = nil
										op:SetIcon("icon16/cross.png")
									else
										GAS:PlaySound("success")
										tbl[v.index] = true
										op:SetIcon("icon16/tick.png")
									end
								end
								if (tbl[v.index]) then
									op:SetIcon("icon16/tick.png")
								else
									op:SetIcon("icon16/cross.png")
								end
							end
						end

						menu:Open()
					end

					local WhitelistedTo = {}
					local BlacklistedFrom = {}

					form:AddButton(L"WhitelistedTo", bVGUI.BUTTON_COLOR_GREEN, L"WhitelistedTo_help", function()
						WhatDoICallThisFunction(WhitelistedTo)
					end)

					form:AddButton(L"BlacklistedFrom", bVGUI.BUTTON_COLOR_RED, L"BlacklistedFrom_help", function()
						WhatDoICallThisFunction(BlacklistedFrom)
					end)

					content_container.Accessors = {
						FactionName = FactionName,
						FactionDescription = FactionDescription,
						ShowIfNotPermitted = ShowIfNotPermitted,
						SetTeam = SetTeam,
						WhitelistedTo = WhitelistedTo,
						BlacklistedFrom = BlacklistedFrom,
						Logo = content_container.URL,
						DeleteFaction = delete_faction,
						SaveFaction = save_faction
					}

					function save_faction:DoVerification()
						if (SetTeam.TeamIndex ~= nil and #FactionName:GetValue() > 0 and #FactionDescription:GetValue() > 0 and content_container.URL._Valid) then
							self:SetDisabled(false)
						else
							self:SetDisabled(true)
						end
					end
				end

				local left_container = vgui.Create("bVGUI.BlankPanel", edit_factions_content.Content)
				left_container:Dock(LEFT)
				left_container:SetWide(175)

				factions_categories = vgui.Create("bVGUI.Categories", left_container)
				factions_categories:Dock(FILL)
				factions_categories:SetLoading(true)

				faction_category = factions_categories:AddCategory(L"factions", Color(76,76,216))

				local btn_container = vgui.Create("bVGUI.BlankPanel", factions_categories)
				btn_container:Dock(BOTTOM)
				btn_container:SetTall(25 + 10 + 25 + 20)
				btn_container:DockPadding(10,10,10,10)

				local permissions_btn = vgui.Create("bVGUI.Button", btn_container)
				permissions_btn:Dock(TOP)
				permissions_btn:SetColor(bVGUI.BUTTON_COLOR_ORANGE)
				permissions_btn:SetTall(25)
				permissions_btn:DockMargin(0,0,0,10)
				permissions_btn:SetText(L"permissions")
				function permissions_btn:DoClick()
					GAS:PlaySound("flash")
					RunConsoleCommand("openpermissions", "gmodadminsuite_jobwhitelist_factions")
				end

				local new_faction = vgui.Create("bVGUI.Button", btn_container)
				new_faction:Dock(TOP)
				new_faction:SetTall(25)
				new_faction:SetColor(bVGUI.BUTTON_COLOR_BLUE)
				new_faction:SetText(L"new_faction")
				function new_faction:DoClick()
					populate_faction_content()
				end

				GAS:GetConfig("jobwhitelist_factions", function(config)
					GAS.JobWhitelist.Factions.Config = config
					factions_categories:SetLoading(false)
					
					for i, faction in pairs(GAS.JobWhitelist.Factions.Config.Factions) do
						local faction_item
						faction_item = faction_category:AddItem(faction.Name, function()
							populate_faction_content()

							content_container.Accessors.DeleteFaction.FactionID = faction.ID
							content_container.Accessors.DeleteFaction.CategoriesItem = faction_item

							content_container.Accessors.FactionName:SetValue(faction.Name)
							content_container.Accessors.FactionDescription:SetValue(faction.Description)
							content_container.Accessors.ShowIfNotPermitted:SetChecked(faction.ShowIfNotPermitted)

							local job_index = OpenPermissions:GetTeamFromIdentifier(faction.SetTeam)
							if (job_index ~= nil) then
								content_container.Accessors.SetTeam.TeamIndex = job_index
								content_container.Accessors.SetTeam:SetText(team.GetName(job_index))
								content_container.Accessors.SetTeam:SetColor(team.GetColor(job_index))
							end

							content_container.Accessors.Logo:SetValue(faction.Logo)
							content_container.Accessors.Logo:OnLoseFocus()

							for t_id in pairs(faction.WhitelistTo) do
								local t_index = OpenPermissions:GetTeamFromIdentifier(t_id)
								if (t_index ~= nil) then
									content_container.Accessors.WhitelistedTo[t_index] = true
								end
							end
							for t_id in pairs(faction.BlacklistFrom) do
								local t_index = OpenPermissions:GetTeamFromIdentifier(t_id)
								if (t_index ~= nil) then
									content_container.Accessors.BlacklistedFrom[t_index] = true
								end
							end

							content_container.Accessors.DeleteFaction:SetDisabled(false)
							content_container.Accessors.SaveFaction:DoVerification()
						end)
					end
				end)
			end)

			local resets_content = operator_tab_content.Tabs:AddTab(L"resets", Color(255,0,0))

			local buttons_container = vgui.Create("bVGUI.BlankPanel", resets_content)
			buttons_container:SetWide(225)

			function resets_content:PerformLayout()
				buttons_container:SizeToChildren(false,true)
				buttons_container:CenterHorizontal()
				buttons_container:CenterVertical(0.5 - (10 / self:GetTall()))
			end

			local enable_buttons = vgui.Create("bVGUI.Button", buttons_container)
			enable_buttons:Dock(TOP)
			enable_buttons:SetText(L"enable_buttons")
			enable_buttons:SetColor(bVGUI.BUTTON_COLOR_RED)
			enable_buttons:DockMargin(10,0,10,0)

			local reset_config = vgui.Create("bVGUI.Button", buttons_container)
			reset_config:Dock(TOP)
			reset_config:SetText(L"reset_config")
			reset_config:SetColor(bVGUI.BUTTON_COLOR_RED)
			reset_config:DockMargin(10,10,10,0)
			reset_config:SetDisabled(true)
			function reset_config:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:reset_config")
				net.SendToServer()
			end

			local reset_factions_config = vgui.Create("bVGUI.Button", buttons_container)
			reset_factions_config:Dock(TOP)
			reset_factions_config:SetText(L"reset_factions_config")
			reset_factions_config:SetColor(bVGUI.BUTTON_COLOR_RED)
			reset_factions_config:DockMargin(10,10,10,10)
			reset_factions_config:SetDisabled(true)
			function reset_factions_config:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:reset_factions_config")
				net.SendToServer()
			end

			local disable_all_whitelists = vgui.Create("bVGUI.Button", buttons_container)
			disable_all_whitelists:Dock(TOP)
			disable_all_whitelists:SetText(L"disable_all_whitelists")
			disable_all_whitelists:SetColor(bVGUI.BUTTON_COLOR_RED)
			disable_all_whitelists:DockMargin(10,10,10,0)
			disable_all_whitelists:SetDisabled(true)
			function disable_all_whitelists:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:disable_all_whitelists")
				net.SendToServer()
			end

			local disable_all_blacklists = vgui.Create("bVGUI.Button", buttons_container)
			disable_all_blacklists:Dock(TOP)
			disable_all_blacklists:SetText(L"disable_all_blacklists")
			disable_all_blacklists:SetColor(bVGUI.BUTTON_COLOR_RED)
			disable_all_blacklists:DockMargin(10,10,10,10)
			disable_all_blacklists:SetDisabled(true)
			function disable_all_blacklists:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:disable_all_blacklists")
				net.SendToServer()
			end

			local destroy_whitelist = vgui.Create("bVGUI.Button", buttons_container)
			destroy_whitelist:Dock(TOP)
			destroy_whitelist:SetText(L"destroy_whitelist")
			destroy_whitelist:SetColor(bVGUI.BUTTON_COLOR_RED)
			destroy_whitelist:DockMargin(10,10,10,0)
			destroy_whitelist:SetDisabled(true)
			function destroy_whitelist:DoClick()
				surface.PlaySound("garrysmod/ui_hover.wav")
			end

			local destroy_blacklist = vgui.Create("bVGUI.Button", buttons_container)
			destroy_blacklist:Dock(TOP)
			destroy_blacklist:SetText(L"destroy_blacklist")
			destroy_blacklist:SetColor(bVGUI.BUTTON_COLOR_RED)
			destroy_blacklist:DockMargin(10,10,10,10)
			destroy_blacklist:SetDisabled(true)
			function destroy_blacklist:DoClick()
				surface.PlaySound("garrysmod/ui_hover.wav")
			end

			local destroy_all_data = vgui.Create("bVGUI.Button", buttons_container)
			destroy_all_data:Dock(TOP)
			destroy_all_data:SetText(L"destroy_all_data")
			destroy_all_data:SetColor(bVGUI.BUTTON_COLOR_RED)
			destroy_all_data:SetTooltip({Text = L"destroy_all_data_help"})
			destroy_all_data:DockMargin(10,10,10,0)
			destroy_all_data:SetDisabled(true)
			function destroy_all_data:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:destroy_all_data")
				net.SendToServer()
			end

			local destroy_faction_data = vgui.Create("bVGUI.Button", buttons_container)
			destroy_faction_data:Dock(TOP)
			destroy_faction_data:SetText(L"destroy_faction_data")
			destroy_faction_data:SetColor(bVGUI.BUTTON_COLOR_RED)
			destroy_faction_data:SetTooltip({Text = L"destroy_faction_data_help"})
			destroy_faction_data:DockMargin(10,10,10,0)
			destroy_faction_data:SetDisabled(true)
			function destroy_faction_data:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:destroy_faction_data")
				net.SendToServer()
			end

			local reset_everything = vgui.Create("bVGUI.Button", buttons_container)
			reset_everything:Dock(TOP)
			reset_everything:SetText(L"reset_everything")
			reset_everything:SetColor(bVGUI.BUTTON_COLOR_RED)
			reset_everything:SetTooltip({Text = L"reset_everything_help"})
			reset_everything:DockMargin(10,10,10,0)
			reset_everything:SetDisabled(true)
			function reset_everything:DoClick()
				GAS:PlaySound("success")
				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")

				GAS:netStart("jobwhitelist:reset_everything")
				net.SendToServer()
			end

			function enable_buttons:DoClick()
				if (reset_config:GetDisabled()) then
					GAS:PlaySound("btn_on")
					enable_buttons:SetText(L"disable_buttons")
					enable_buttons:SetColor(bVGUI.BUTTON_COLOR_BLUE)
				else
					GAS:PlaySound("btn_off")
					enable_buttons:SetText(L"enable_buttons")
					enable_buttons:SetColor(bVGUI.BUTTON_COLOR_RED)
				end

				reset_config:SetDisabled(not reset_config:GetDisabled())
				reset_factions_config:SetDisabled(not reset_factions_config:GetDisabled())
				disable_all_whitelists:SetDisabled(not disable_all_whitelists:GetDisabled())
				disable_all_blacklists:SetDisabled(not disable_all_blacklists:GetDisabled())
				destroy_whitelist:SetDisabled(not destroy_whitelist:GetDisabled())
				destroy_blacklist:SetDisabled(not destroy_blacklist:GetDisabled())
				destroy_faction_data:SetDisabled(not destroy_faction_data:GetDisabled())
				destroy_all_data:SetDisabled(not destroy_all_data:GetDisabled())
				reset_everything:SetDisabled(not reset_everything:GetDisabled())
			end
	end

	jobs_tab_content.Categories:LoadContent()
end)

GAS:netReceive("jobwhitelist:CloseMenu", function()
	if (IsValid(GAS.JobWhitelist.Menu)) then
		GAS.JobWhitelist.Menu:Close()
		GAS:chatPrint("[JobWhitelist] Closed menu due to an operator reset.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_INFO)
	end
end)

local function notify_listchange(main_color, text, job_index)
	if (text:find("%%job%%")) then
		local job = RPExtraTeams[job_index]
		local job_col = job.color
		local job_name = job.name

		local args = {main_color}
		local split = string.Explode("%job%", text)
		for i,v in ipairs(string.Explode("%job%", text)) do
			table.insert(args, main_color)
			table.insert(args, v)
			if (i ~= #split) then
				table.insert(args, job_col)
				table.insert(args, job_name)
			end
		end

		chat.AddText(unpack(args))
	else
		chat.AddText(main_color, text)
	end
end
GAS:netReceive("jobwhitelist:notifywhitelisted", function()
	local job_index = net.ReadUInt(12)
	notify_listchange(Color(0,200,0), GAS.JobWhitelist.Config.NotifyWhitelisted_Msg, job_index)
end)
GAS:netReceive("jobwhitelist:notifyunwhitelisted", function()
	local job_index = net.ReadUInt(12)
	notify_listchange(Color(200,0,0), GAS.JobWhitelist.Config.NotifyUnwhitelisted_Msg, job_index)
end)
GAS:netReceive("jobwhitelist:notifyblacklisted", function()
	local job_index = net.ReadUInt(12)
	notify_listchange(Color(200,0,0), GAS.JobWhitelist.Config.NotifyBlacklisted_Msg, job_index)
end)
GAS:netReceive("jobwhitelist:notifyunblacklisted", function()
	local job_index = net.ReadUInt(12)
	notify_listchange(Color(0,200,0), GAS.JobWhitelist.Config.NotifyUnblacklisted_Msg, job_index)
end)