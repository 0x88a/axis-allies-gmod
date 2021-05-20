if (GAS.JobWhitelist.Factions and IsValid(GAS.JobWhitelist.Factions.Menu)) then
	GAS.JobWhitelist.Factions.Menu:Close()
end

local function L(phrase, ...)
	if (#({...}) == 0) then
		return GAS:Phrase(phrase, "jobwhitelist")
	else
		return GAS:PhraseFormat(phrase, "jobwhitelist", ...)
	end
end

GAS.JobWhitelist.Factions = {}

if (SERVER) then
	GAS.JobWhitelist.Factions.DefaultConfig = {
		Enabled = false,

		Factions = {},

		ShowOnFirstJoin = true,
		ShowOnEveryJoin = false,
		ShowOnEverySpawn = false,

		ShowForJobs = {},
		ShowForJobsOnce = true,

		ShowForUsergroups = {},
		ShowForUsergroupsOnce = true,

		ChatCommand = false,
		ConsoleCommand = false,

		HelpText = "Please select a faction you want to play as",

		OnPopupSound = "gmodadminsuite/popup.ogg",
		OnHoverSound = "gmodadminsuite/btn_light.ogg",
		OnSelectionSound = "gmodadminsuite/success.ogg",
		PermissionDeniedSound = "gmodadminsuite/error.ogg",
	}
	GAS.JobWhitelist.Factions.Config = GAS:GetConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.DefaultConfig)

	function GAS.JobWhitelist:GetPlayerFaction(ply)
		local fac_index = GAS.JobWhitelist.PlayerFactions[ply]
		if (fac_index == nil) then return nil end
		return GAS.JobWhitelist.Factions.Config.Factions[fac_index]
	end

	GAS.JobWhitelist.Factions.Authenticated = {}
	GAS.JobWhitelist.Factions.ShowOnEveryJoin = {}
	GAS.JobWhitelist.Factions.ShowForUsergroupsOnce = {}
	GAS.JobWhitelist.Factions.ShowForJobsOnce = {}
	GAS:hook("PlayerDisconnect", "jobwhitelist:CleanupDisconnect", function(ply)
		GAS.JobWhitelist.Factions.ShowForJobsOnce[ply] = nil
		GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply] = nil
		GAS.JobWhitelist.Factions.ShowOnEveryJoin[ply] = nil
		GAS.JobWhitelist.Factions.Authenticated[ply] = nil
	end)

	function GAS.JobWhitelist.Factions:ShowMenu(ply)
		GAS.JobWhitelist.Factions.Authenticated[ply] = true
		GAS:netStart("factions:Init")
		net.Send(ply)
	end

	GAS:netInit("factions:Init")
	GAS:netReceive("factions:Init", function(ply)
		if (not GAS.JobWhitelist.Factions.Config.Enabled) then return end

		if (GAS.JobWhitelist.Factions.Config.ShowOnFirstJoin) then
			if (ply:GetPData("GAS:JobWhitelist:Factions:ShowOnFirstJoin", "0") == "1") then
				return
			end
		end

		if (GAS.JobWhitelist.Factions.Config.ShowOnEveryJoin) then
			if (GAS.JobWhitelist.Factions.ShowOnEveryJoin[ply] ~= true) then
				return
			else
				GAS.JobWhitelist.Factions.ShowOnEveryJoin[ply] = nil
			end
		end

		GAS.JobWhitelist.Factions:ShowMenu(ply)
	end)

	function GAS.JobWhitelist.Factions:ConfigRefresh()
		if (GAS.JobWhitelist.Factions.Config.Enabled) then
			if (GAS.JobWhitelist.Factions.Config.ChatCommand) then
				GAS:hook("PlayerSay", "factions:ChatCommand", function(ply, txt)
					if (txt:lower() == GAS.JobWhitelist.Factions.Config.ChatCommand) then
						GAS.JobWhitelist.Factions:ShowMenu(ply)
						return ""
					end
				end)
			else
				GAS:unhook("PlayerSay", "factions:ChatCommand")
			end

			if (GAS.JobWhitelist.Factions.Config.ConsoleCommand) then
				GAS_JobWhitelist_Factions_ConsoleCommand = GAS.JobWhitelist.Factions.Config.ConsoleCommand
				concommand.Add(GAS_JobWhitelist_Factions_ConsoleCommand, function(ply)
					GAS.JobWhitelist.Factions:ShowMenu(ply)
				end)
			elseif (GAS_JobWhitelist_Factions_ConsoleCommand ~= nil) then
				concommand.Remove(GAS_JobWhitelist_Factions_ConsoleCommand)
				GAS_JobWhitelist_Factions_ConsoleCommand = nil
			end

			if (GAS.JobWhitelist.Factions.Config.ShowOnEveryJoin) then
				GAS:hook("PlayerInitialSpawn", "jobwhitelist:factions:ShowOnEveryJoin", function(ply)
					GAS.JobWhitelist.Factions.ShowOnEveryJoin[ply] = true
				end)
			else
				GAS:unhook("PlayerInitialSpawn", "jobwhitelist:factions:ShowOnEveryJoin")
			end

			local ShowForJobs = not GAS:table_IsEmpty(GAS.JobWhitelist.Factions.Config.ShowForJobs)
			local ShowForUsergroups = not GAS:table_IsEmpty(GAS.JobWhitelist.Factions.Config.ShowForUsergroups)
			if (GAS.JobWhitelist.Factions.Config.ShowOnEverySpawn or ShowForJobs or ShowForUsergroups) then
				GAS:hook("PlayerSpawn", "jobwhitelist:factions:PlayerSpawn", function(ply)
					if (GAS.JobWhitelist.Factions.ShowOnEveryJoin[ply]) then return end

					local show = GAS.JobWhitelist.Factions.Config.ShowOnEverySpawn

					if (not show and ShowForJobs) then
						if (GAS.JobWhitelist.Factions.Config.ShowForJobs[OpenPermissions:GetTeamIdentifier(ply:Team())]) then
							if (GAS.JobWhitelist.Factions.Config.ShowForJobsOnce) then
								if (GAS.JobWhitelist.Factions.ShowForJobsOnce[ply] == nil or GAS.JobWhitelist.Factions.ShowForJobsOnce[ply][ply:Team()] == nil) then
									GAS.JobWhitelist.Factions.ShowForJobsOnce[ply] = GAS.JobWhitelist.Factions.ShowForJobsOnce[ply] or {}
									GAS.JobWhitelist.Factions.ShowForJobsOnce[ply][ply:Team()] = true
									show = true
								end
							else
								show = true
							end
						end
					end

					if (not show and ShowForUsergroups) then
						for usergroup in pairs(OpenPermissions:GetUserGroups(ply)) do
							if (GAS.JobWhitelist.Factions.Config.ShowForUsergroups[usergroup]) then
								if (GAS.JobWhitelist.Factions.Config.ShowForUsergroupsOnce) then
									if (GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply] == nil or GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply][usergroup] == nil) then
										GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply] = GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply] or {}
										GAS.JobWhitelist.Factions.ShowForUsergroupsOnce[ply][usergroup] = true
										show = true
										break
									end
								else
									show = true
									break
								end
							end
						end
					end

					if (show) then
						GAS.JobWhitelist.Factions:ShowMenu(ply)
					end
				end)
			else
				GAS:unhook("PlayerSpawn", "jobwhitelist:factions:PlayerSpawn")
			end
		else
			if (GAS_JobWhitelist_Factions_ConsoleCommand ~= nil) then
				concommand.Remove(GAS_JobWhitelist_Factions_ConsoleCommand)
				GAS_JobWhitelist_Factions_ConsoleCommand = nil
			end
			GAS:unhook("PlayerSay", "factions:ChatCommand")
			GAS:unhook("PlayerInitialSpawn", "jobwhitelist:factions:ShowOnEveryJoin")
			GAS:unhook("PlayerSpawn", "jobwhitelist:factions:PlayerSpawn")
		end

		if (GAS.JobWhitelist.Factions.ReloadPermissions) then
			GAS.JobWhitelist.Factions:ReloadPermissions()
		end
	end
	GAS.JobWhitelist.Factions:ConfigRefresh()

	GAS:netInit("factions:choose")
	GAS:netReceive("factions:choose", function(ply)
		local faction_index = net.ReadUInt(6)

		if (not GAS.JobWhitelist.Factions.Authenticated[ply]) then return end
		GAS.JobWhitelist.Factions.Authenticated[ply] = nil

		local faction = GAS.JobWhitelist.Factions.Config.Factions[faction_index]
		if (faction == nil) then return end

		ply:SetPData("GAS:JobWhitelist:Factions:ShowOnFirstJoin", "1")

		GAS.JobWhitelist.PlayerFactions[ply] = faction_index

		GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_factions") .. " (`account_id`, `faction`) VALUES(?,?)", {ply:AccountID(), faction.ID}, function()
			local changeTeam = OpenPermissions:GetTeamFromIdentifier(faction.SetTeam)
			if (changeTeam ~= nil) then
				ply:changeTeam(changeTeam)
				GAS.JobWhitelist:SendPlayerAccessibleJobs(ply)
			else
				GAS:print("[JobWhitelist Factions] Faction " .. faction.Name .. " has a missing/invalid job for SetTeam, please correct this", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			end
		end)
	end)

	GAS:netInit("factions:new")
	GAS:netReceive("factions:new", function(ply)
		local Name = net.ReadString()
		local Description = net.ReadString()
		local Logo = net.ReadString()
		local ShowIfNotPermitted = net.ReadBool()
		local SetTeam = net.ReadUInt(8)

		local WhitelistTo = {}
		for i=1,net.ReadUInt(8) do
			WhitelistTo[#WhitelistTo + 1] = net.ReadUInt(8)
		end

		local BlacklistFrom = {}
		for i=1,net.ReadUInt(8) do
			BlacklistFrom[#BlacklistFrom + 1] = net.ReadUInt(8)
		end

		local is_editing_faction = net.ReadBool()
		local editing_faction
		if (is_editing_faction) then
			editing_faction = net.ReadUInt(16)
		end

		if (not OpenPermissions:IsOperator(ply)) then return end

		local faction_tbl = {
			Name = Name,
			Description = Description,
			Logo = Logo,
			ShowIfNotPermitted = ShowIfNotPermitted,
			WhitelistTo = {},
			BlacklistFrom = {},
			SetTeam = OpenPermissions:GetTeamIdentifier(SetTeam)
		}
		for _,t in ipairs(WhitelistTo) do
			if (not RPExtraTeams[t]) then continue end
			faction_tbl.WhitelistTo[OpenPermissions:GetTeamIdentifier(t)] = true
		end
		for _,t in ipairs(BlacklistFrom) do
			if (not RPExtraTeams[t]) then continue end
			faction_tbl.BlacklistFrom[OpenPermissions:GetTeamIdentifier(t)] = true
		end

		if (editing_faction) then
			for i, faction in pairs(GAS.JobWhitelist.Factions.Config.Factions) do
				if (faction.ID == editing_faction) then
					faction_tbl.ID = faction.ID
					GAS.JobWhitelist.Factions.Config.Factions[i] = faction_tbl
					break
				end
			end

			GAS:SaveConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.Config)
			GAS.JobWhitelist.Factions:ConfigRefresh()

			GAS:netStart("factions:new")
			net.Send(ply)
		else
			local local_max_id = 0
			for i, faction in pairs(GAS.JobWhitelist.Factions.Config.Factions) do
				if (faction.ID > local_max_id) then
					local_max_id = faction.ID
				end
			end
			GAS.Database:Query("SELECT MAX(`faction`) AS 'max_faction_id' FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_factions"), function(rows)
				local new_faction_id
				if (not rows or #rows == 0 or rows[1].max_faction_id == nil) then
					new_faction_id = math.max(local_max_id + 1, 1)
				else
					local remote_max_id = tonumber(rows[1].max_faction_id)
					new_faction_id = math.max(remote_max_id + 1, local_max_id + 1)
				end
				faction_tbl.ID = new_faction_id
				table.insert(GAS.JobWhitelist.Factions.Config.Factions, faction_tbl)

				GAS:SaveConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.Config)
				GAS.JobWhitelist.Factions:ConfigRefresh()

				GAS:netStart("factions:new")
				net.Send(ply)
			end)
		end
	end)

	GAS:netInit("factions:delete")
	GAS:netReceive("factions:delete", function(ply)
		local faction_id = net.ReadUInt(16)
		if (not OpenPermissions:IsOperator(ply)) then return end

		for index, faction in pairs(GAS.JobWhitelist.Factions.Config.Factions) do
			if (faction.ID == faction_id) then
				GAS.JobWhitelist.Factions.Config.Factions[index] = nil
				GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_factions") .. " WHERE `faction`=" .. faction_id)
				break
			end
		end

		GAS:SaveConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.Config)
		GAS.JobWhitelist.Factions:ConfigRefresh()
	end)

	GAS:netInit("factions:ChangeConfig:string")
	GAS:netInit("factions:ChangeConfig:bool")

	GAS:netReceive("factions:ChangeConfig:string", function()
		GAS.JobWhitelist.Factions.Config[net.ReadString()] = net.ReadString()
		
		GAS:SaveConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.Config)
		GAS.JobWhitelist.Factions:ConfigRefresh()
	end)

	GAS:netReceive("factions:ChangeConfig:bool", function()
		GAS.JobWhitelist.Factions.Config[net.ReadString()] = net.ReadBool()
		
		GAS:SaveConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.Config)
		GAS.JobWhitelist.Factions:ConfigRefresh()
	end)
else
	GAS.JobWhitelist.Factions.ImageCRCs = {}
	function GAS.JobWhitelist.Factions:ShowMenu()
		if (IsValid(GAS.JobWhitelist.Factions.Menu)) then
			GAS.JobWhitelist.Factions.Menu:Close()
		end

		surface.PlaySound(GAS.JobWhitelist.Factions.Config.OnPopupSound)

		GAS.JobWhitelist.Factions.Menu = vgui.Create("bVGUI.Frame")
		GAS.JobWhitelist.Factions.Menu:SetVisible(false)
		GAS.JobWhitelist.Factions.Menu:SetSize(225,200 + 24 + 16)
		GAS.JobWhitelist.Factions.Menu:ShowFullscreenButton(false)
		GAS.JobWhitelist.Factions.Menu:ShowCloseButton(false)
		GAS.JobWhitelist.Factions.Menu:SetTitle(L"choose_faction")
		GAS.JobWhitelist.Factions.Menu:Center()
		GAS.JobWhitelist.Factions.Menu:MakePopup()
		GAS.JobWhitelist.Factions.Menu:DockPadding(10,24 + 10,10,10)

		GAS.JobWhitelist.Factions.Menu.FactionContainer = vgui.Create("bVGUI.BlankPanel", GAS.JobWhitelist.Factions.Menu)
		GAS.JobWhitelist.Factions.Menu.FactionContainer:Dock(FILL)

		local faction_pnls = {}
		function GAS.JobWhitelist.Factions.Menu.FactionContainer:LayoutFactions()
			local w = 0
			for _,faction_pnl in ipairs(faction_pnls) do
				faction_pnl:AlignLeft(w)
				w = w + faction_pnl:GetWide() + 10
			end
			GAS.JobWhitelist.Factions.Menu:SetWide((w - 10) + 20)
		end

		GAS.JobWhitelist.Factions.Menu.Description = vgui.Create("DLabel", GAS.JobWhitelist.Factions.Menu)
		GAS.JobWhitelist.Factions.Menu.Description:SetContentAlignment(5)
		GAS.JobWhitelist.Factions.Menu.Description:SetTextColor(bVGUI.COLOR_WHITE)
		GAS.JobWhitelist.Factions.Menu.Description:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
		GAS.JobWhitelist.Factions.Menu.Description:Dock(BOTTOM)
		GAS.JobWhitelist.Factions.Menu.Description:SetAutoStretchVertical(true)
		GAS.JobWhitelist.Factions.Menu.Description:SetWrap(true)
		function GAS.JobWhitelist.Factions.Menu.Description:PerformLayout()
			GAS.JobWhitelist.Factions.Menu:SetTall(200 + 24 + self:GetTall())
			if (self:GetTall() == 16) then
				self:SetWrap(false)
				self:SetAutoStretchVertical(false)
			end
		end
		function GAS.JobWhitelist.Factions.Menu.Description:Update(txt)
			self:SetText(txt)
			self:SetWrap(true)
			self:SetAutoStretchVertical(true)
		end
		GAS.JobWhitelist.Factions.Menu.Description:Update(GAS.JobWhitelist.Factions.Config.HelpText)

		local is_operator = OpenPermissions:IsOperator(LocalPlayer())
		local created_faction = false
		for index, selection in ipairs(GAS.JobWhitelist.Factions.Config.Factions) do
			local permitted = is_operator or OpenPermissions:HasPermission(LocalPlayer(), "gmodadminsuite_jobwhitelist_factions/" .. selection.ID)
			if (not selection.ShowIfNotPermitted and not permitted) then continue end
			created_faction = true

			local faction = vgui.Create("GAS.JobWhitelist.Faction", GAS.JobWhitelist.Factions.Menu.FactionContainer)
			table.insert(faction_pnls, faction)
			faction:SetImage(selection.Logo)
			faction:SetName(selection.Name)

			if (permitted) then
				faction:SetDescription(selection.Description)
				function faction:DoClick()
					GAS:netStart("factions:choose")
						net.WriteUInt(index, 6)
					net.SendToServer()

					surface.PlaySound(GAS.JobWhitelist.Factions.Config.OnSelectionSound)

					GAS.JobWhitelist.Factions.Menu:Close()
				end
			else
				faction:SetDescription(L"faction_not_permitted" .. "\n" .. selection.Description)
				function faction:DoClick()
					surface.PlaySound(GAS.JobWhitelist.Factions.Config.PermissionDeniedSound)
				end
			end
		end

		local fs = file.Find("gas_jobwhitelist_faction_imgs/*.png", "DATA")
		for _,f in ipairs(fs) do
			if (GAS.JobWhitelist.Factions.ImageCRCs[f] == nil) then
				file.Delete("gas_jobwhitelist_faction_imgs/" .. f)
			end
		end

		if (created_faction) then
			GAS.JobWhitelist.Factions.Menu:SetVisible(true)
			GAS.JobWhitelist.Factions.Menu.FactionContainer:LayoutFactions()
		else
			GAS.JobWhitelist.Factions.Menu:Close()
			GAS:print("[JobWhitelist Factions] There are no factions available for you to choose", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
		end
	end

	GAS:InitPostEntity(function()
		GAS:GetConfig("jobwhitelist_factions", function(config)
			GAS.JobWhitelist.Factions.Config = config
			if (config.Enabled and (config.ShowOnFirstJoin or config.ShowOnEveryJoin)) then
				GAS:netStart("factions:Init")
				net.SendToServer()
			end
		end)
	end)
	GAS:netReceive("factions:Init", function()
		GAS.JobWhitelist.Factions:ShowMenu()
	end)
end

GAS:print("[JobWhitelist] Factions initialized")