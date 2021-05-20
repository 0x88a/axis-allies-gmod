local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "jobwhitelist")
	else
		return GAS:PhraseFormat(phrase, "jobwhitelist", ...)
	end
end

if (CLIENT) then
	GAS:ContextProperty("gas_jobwhitelist", {
		MenuLabel = L"module_name",
		MenuIcon = "icon16/group_edit.png",
		MenuOpen = function(self, option, ply, tr)
			GAS.JobWhitelist:OpenContextMenu(option, ply, true)
		end,
		Filter = function(self, ent, ply)
			return GAS.JobWhitelist.Config ~= nil and GAS.JobWhitelist.Config.ContextMenu == true and ent:IsPlayer() and not ent:IsBot() and OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite/jobwhitelist")
		end
	})
	
	function GAS.JobWhitelist:OpenContextMenu(option, target_ply, open_menu_btn)
		local target_ply_account_id = target_ply:AccountID()

		local is_operator = OpenPermissions:IsOperator(LocalPlayer())

		if (open_menu_btn) then
			option:AddOption(L"open_menu", function()
				RunConsoleCommand("gmodadminsuite", "jobwhitelist")
			end):SetIcon("icon16/application_form_magnify.png")

			option:AddSpacer()
		end

		local add_to_whitelist, add_to_whitelist_pnl = option:AddSubMenu(L"add_to_whitelist")
		add_to_whitelist_pnl:SetIcon("icon16/report_add.png")

		add_to_whitelist_pnl.LoadingOption = add_to_whitelist:AddOption(L"loading_ellipsis")
		add_to_whitelist_pnl.LoadingOption:SetIcon("icon16/transmit_blue.png")

		local add_to_blacklist, add_to_blacklist_pnl = option:AddSubMenu(L"add_to_blacklist")
		add_to_blacklist_pnl:SetIcon("icon16/report_delete.png")

		add_to_blacklist_pnl.LoadingOption = add_to_blacklist:AddOption(L"loading_ellipsis")
		add_to_blacklist_pnl.LoadingOption:SetIcon("icon16/transmit_blue.png")

		local function OnCursorEntered(self, network_str, is_refresh)
			self:GAS_OLD_OnCursorEntered()

			if (not IsValid(self.LoadingOption)) then return end

			GAS:StartNetworkTransaction("jobwhitelist:contextmenu:" .. network_str, function(transaction_id)
				self.LoadingOption.GAS_transaction_id = transaction_id
				net.WriteEntity(target_ply, 31)
			end, function()
				local data = {}
				for i=1,net.ReadUInt(16) do
					local category_index = net.ReadUInt(16)
					data[category_index] = {}
					for x=1,net.ReadUInt(16) do
						local index = net.ReadUInt(16)
						table.insert(data[category_index], {index = index, name = RPExtraTeams[index].name, listed = net.ReadBool()})
					end
				end

				if (not IsValid(self.LoadingOption)) then return end
				self.LoadingOption:Remove()

				if (GAS:table_IsEmpty(data)) then
					if (network_str == "add_to_whitelist") then
						add_to_whitelist:AddOption(L"no_whitelists_available"):SetIcon("icon16/cancel.png")
					else
						add_to_blacklist:AddOption(L"no_blacklists_available"):SetIcon("icon16/cancel.png")
					end
					return
				end

				self.ListData = data
				self.JobOptions = {{},{}}

				local categories = DarkRP.getCategories().jobs
				for category_index, members in pairs(self.ListData) do
					local submenu, _submenu
					if (network_str == "add_to_whitelist") then
						submenu, _submenu = add_to_whitelist:AddSubMenu(categories[category_index].name)
					else
						submenu, _submenu = add_to_blacklist:AddSubMenu(categories[category_index].name)
					end
					bVGUI_DermaMenuOption_ColorIcon(_submenu, categories[category_index].color)

					table.SortByMember(members, "name", true)
					for _,v in ipairs(members) do
						local job_index = v.index
						local job_name = v.name
						local listed = v.listed
						
						local job_id = OpenPermissions:GetTeamIdentifier(job_index)

						local option = submenu:AddOption(job_name)
						if (network_str == "add_to_whitelist") then
							self.JobOptions[1][job_index] = option
						else
							self.JobOptions[2][job_index] = option
						end

						local perm_str = "whitelist"
						if (network_str == "add_to_blacklist") then perm_str = "blacklist" end
						local can_add = is_operator or OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_jobwhitelist/" .. job_id .. "/" .. perm_str .. "/add_to/steamids")
						local can_remove = is_operator or OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_jobwhitelist/" .. job_id .. "/" .. perm_str .. "/remove_from/steamids")

						function option:OnMouseReleased(m)
							DButton.OnMouseReleased(self, m)
							if (m ~= MOUSE_LEFT or not self.m_MenuClicking) then return end
							self.m_MenuClicking = false

							if (not is_operator and ((self.IsListed and not can_remove) or (not self.IsListed and not can_add))) then
								GAS:PlaySound("error")
								notification.AddLegacy(L"no_permission_action", NOTIFY_ERROR, 2)
								return
							end

							self.IsListed = not self.IsListed
							if (self.IsListed) then
								if (network_str == "add_to_whitelist") then
									if (add_to_blacklist_pnl.JobOptions and IsValid(add_to_blacklist_pnl.JobOptions[2][job_index]) and add_to_blacklist_pnl.JobOptions[2][job_index].IsListed) then
										add_to_blacklist_pnl.ListData[category_index][job_index] = false
										add_to_blacklist_pnl.JobOptions[2][job_index].IsListed = false
										add_to_blacklist_pnl.JobOptions[2][job_index]:SetIcon("icon16/cross.png")
									end
								else
									if (add_to_whitelist_pnl.JobOptions and IsValid(add_to_whitelist_pnl.JobOptions[1][job_index]) and add_to_whitelist_pnl.JobOptions[1][job_index].IsListed) then
										add_to_whitelist_pnl.ListData[category_index][job_index] = false
										add_to_whitelist_pnl.JobOptions[1][job_index].IsListed = false
										add_to_whitelist_pnl.JobOptions[1][job_index]:SetIcon("icon16/cross.png")
									end
								end

								GAS:PlaySound("success")

								self:SetIcon("icon16/tick.png")

								GAS:netStart("jobwhitelist:add_to_list")
									net.WriteBool(network_str == "add_to_blacklist")
									net.WriteUInt(job_index, 16)
									net.WriteUInt(GAS.JobWhitelist.LIST_TYPE_STEAMID, 4)
									net.WriteUInt(target_ply_account_id, 31)
								net.SendToServer()
							else
								GAS:PlaySound("delete")

								self:SetIcon("icon16/cross.png")

								GAS:netStart("jobwhitelist:delete_from_list")
									net.WriteBool(network_str == "add_to_blacklist")
									net.WriteUInt(job_index, 16)
									net.WriteUInt(GAS.JobWhitelist.LIST_TYPE_STEAMID, 4)
									net.WriteUInt(target_ply_account_id, 31)
								net.SendToServer()
							end
						end
						option.IsListed = listed
						if (option.IsListed) then
							option:SetIcon("icon16/tick.png")
						else
							option:SetIcon("icon16/cross.png")
						end
					end
				end
			end)
		end
		local function OnCursorExited(self, network_str)
			self:GAS_OLD_OnCursorExited()

			if (IsValid(self.LoadingOption) and self.LoadingOption.GAS_transaction_id) then
				GAS:CancelNetworkTransaction("jobwhitelist:contextmenu:" .. network_str, self.LoadingOption.GAS_transaction_id)
			end
		end

		add_to_whitelist_pnl.GAS_OLD_OnCursorEntered = add_to_whitelist_pnl.OnCursorEntered
		add_to_whitelist_pnl.GAS_OLD_OnCursorExited = add_to_whitelist_pnl.OnCursorExited
		function add_to_whitelist_pnl:OnCursorEntered()
			OnCursorEntered(self, "add_to_whitelist")
		end
		function add_to_whitelist_pnl:OnCursorExited()
			OnCursorExited(self, "add_to_blacklist")
		end

		add_to_blacklist_pnl.GAS_OLD_OnCursorEntered = add_to_blacklist_pnl.OnCursorEntered
		add_to_blacklist_pnl.GAS_OLD_OnCursorExited = add_to_blacklist_pnl.OnCursorExited
		function add_to_blacklist_pnl:OnCursorEntered()
			OnCursorEntered(self, "add_to_blacklist")
		end
		function add_to_blacklist_pnl:OnCursorExited()
			OnCursorExited(self, "add_to_blacklist")
		end

		if (OpenPermissions:HasPermission(LocalPlayer(), {
			"gmodadminsuite_jobwhitelist/add_to_all_whitelists",
			"gmodadminsuite_jobwhitelist/add_to_all_blacklists",
			"gmodadminsuite_jobwhitelist/remove_from_all_whitelists",
			"gmodadminsuite_jobwhitelist/remove_from_all_blacklists"
		})) then
			option:AddSpacer()

			local bulk_sub, _ = option:AddSubMenu(L"bulk_actions")
			_:SetIcon("icon16/cog.png")

			bulk_sub:AddOption(L"add_to_all_whitelists", function()

				GAS:netStart("jobwhitelist:contextmenu:add_to_all_whitelists")
					net.WriteUInt(target_ply_account_id, 31)
				net.SendToServer()

				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
				GAS:PlaySound("success")

			end):SetIcon("icon16/user_green.png")

			bulk_sub:AddOption(L"add_to_all_blacklists", function()
				
				GAS:netStart("jobwhitelist:contextmenu:add_to_all_blacklists")
					net.WriteUInt(target_ply_account_id, 31)
				net.SendToServer()

				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
				GAS:PlaySound("success")

			end):SetIcon("icon16/user_red.png")

			bulk_sub:AddSpacer()

			bulk_sub:AddOption(L"remove_from_all_whitelists", function()
				
				GAS:netStart("jobwhitelist:contextmenu:remove_from_all_whitelists")
					net.WriteUInt(target_ply_account_id, 31)
				net.SendToServer()

				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
				GAS:PlaySound("success")

			end):SetIcon("icon16/user_green.png")

			bulk_sub:AddOption(L"remove_from_all_blacklists", function()
				
				GAS:netStart("jobwhitelist:contextmenu:remove_from_all_blacklists")
					net.WriteUInt(target_ply_account_id, 31)
				net.SendToServer()

				bVGUI.MouseInfoTooltip.Create(L"done_exclamation")
				GAS:PlaySound("success")

			end):SetIcon("icon16/user_red.png")
		end
	end
else
	GAS:netInit("jobwhitelist:contextmenu:add_to_whitelist")
	GAS:ReceiveNetworkTransaction("jobwhitelist:contextmenu:add_to_whitelist", function(transaction_id, ply)
		local target_ply = net.ReadEntity()
		if (not IsValid(target_ply)) then return end

		local is_operator = OpenPermissions:IsOperator(ply)

		local data = {}
		for category_index, category in pairs(DarkRP.getCategories().jobs) do
			if (#category.members == 0) then continue end
			for _,job in ipairs(category.members) do
				local job_index = job.team
				if (job_index == (GM or GAMEMODE).DefaultTeam) then continue end
				if (not GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then continue end

				local is_whitelisted = false
				if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][target_ply:AccountID()]) then
					if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][target_ply:AccountID()][job_index]) then
						is_whitelisted = true
					end
				end
				if (not is_operator) then
					local job_id = OpenPermissions:GetTeamIdentifier(job_index)
					if (not OpenPermissions:HasPermission(ply, {"gmodadminsuite_jobwhitelist/" .. job_id .. "/whitelist/add_to/steamids", "gmodadminsuite_jobwhitelist/" .. job_id .. "/whitelist/remove_from/steamids"})) then
						continue
					end
				end

				data[category_index] = data[category_index] or {}
				data[category_index][job_index] = is_whitelisted
			end
		end

		GAS:netStart("jobwhitelist:contextmenu:add_to_whitelist")
			net.WriteUInt(transaction_id, 16)

			net.WriteUInt(table.Count(data), 16)
			for category_index, members in pairs(data) do
				net.WriteUInt(category_index, 16)
				net.WriteUInt(table.Count(members), 16)
				for job_index, is_whitelisted in pairs(members) do
					net.WriteUInt(job_index, 16)
					net.WriteBool(is_whitelisted)
				end
			end
		net.Send(ply)
	end)

	GAS:netInit("jobwhitelist:contextmenu:add_to_blacklist")
	GAS:ReceiveNetworkTransaction("jobwhitelist:contextmenu:add_to_blacklist", function(transaction_id, ply)
		local target_ply = net.ReadEntity()
		if (not IsValid(target_ply)) then return end

		local is_operator = OpenPermissions:IsOperator(ply)

		local data = {}
		for category_index, category in pairs(DarkRP.getCategories().jobs) do
			if (#category.members == 0) then continue end
			for _,job in ipairs(category.members) do
				local job_index = job.team
				if (job_index == (GM or GAMEMODE).DefaultTeam) then continue end
				if (not GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then continue end

				local is_blacklisted = false
				if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][target_ply:AccountID()]) then
					if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][target_ply:AccountID()][job_index]) then
						is_blacklisted = true
					end
				end
				if (not is_operator) then
					local job_id = OpenPermissions:GetTeamIdentifier(job_index)
					if (not OpenPermissions:HasPermission(ply, {"gmodadminsuite_jobwhitelist/" .. job_id .. "/blacklist/add_to/steamids", "gmodadminsuite_jobwhitelist/" .. job_id .. "/blacklist/remove_from/steamids"})) then
						continue
					end
				end

				data[category_index] = data[category_index] or {}
				data[category_index][job_index] = is_blacklisted
			end
		end

		GAS:netStart("jobwhitelist:contextmenu:add_to_blacklist")
			net.WriteUInt(transaction_id, 16)

			net.WriteUInt(table.Count(data), 16)
			for category_index, members in pairs(data) do
				net.WriteUInt(category_index, 16)
				net.WriteUInt(table.Count(members), 16)
				for job_index, is_blacklisted in pairs(members) do
					net.WriteUInt(job_index, 16)
					net.WriteBool(is_blacklisted)
				end
			end
		net.Send(ply)
	end)
end