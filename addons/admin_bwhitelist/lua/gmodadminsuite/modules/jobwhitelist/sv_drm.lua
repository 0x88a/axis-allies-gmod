-- why billy
-- XEON.include("b755893e1b0a7892ba03e9e21a67e0de")

-- local function init_permissions()
-- 	XEON.include("b01866f0faebfbfee93362b0d1985f09")
-- end
-- if (GAS_JobWhitelist_DarkRPReady) then
-- 	init_permissions()
-- else
-- 	GAS:hook("gmodadminsuite:jobwhitelist:DarkRPReady", "jobwhitelist:DarkRPReady:DRM", init_permissions)
-- end

-- FILE #1
GAS:netInit("jobwhitelist:getjobdata")

GAS:ReceiveNetworkTransaction("jobwhitelist:getjobdata", function(transaction_id, ply)
	local job_index = net.ReadUInt(16)
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	GAS:netStart("jobwhitelist:getjobdata")
		net.WriteUInt(transaction_id, 16)
		net.WriteBool(GAS.JobWhitelist:IsWhitelistEnabled(job_index))
		net.WriteBool(GAS.JobWhitelist:IsBlacklistEnabled(job_index))
		net.WriteBool(GAS.JobWhitelist.Config.AutoSwitch_Disabled[job_id] or false)
		net.WriteBool(GAS.JobWhitelist.Config.DefaultWhitelisted[job_id] or false)
		net.WriteBool(GAS.JobWhitelist.Config.DefaultBlacklisted[job_id] or false)
		net.WriteBool(GAS.JobWhitelist.Config.AutoSwitch or false)
	net.Send(ply)
end)

GAS:netInit("jobwhitelist:ChangeSetting:bool")
GAS:netInit("jobwhitelist:ChangeSetting:string")
GAS:netInit("jobwhitelist:GetClientsideSetting:string")
GAS:netInit("jobwhitelist:GetClientsideSetting:bool")

GAS:netReceive("jobwhitelist:ChangeSetting:string", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local key = net.ReadString()
	local val = net.ReadString()
	if (GAS.JobWhitelist.Config[key] ~= nil) then
		GAS.JobWhitelist.Config[key] = val
		GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
		if (GAS.JobWhitelist.ClientsideConfigKeys[key]) then
			GAS:netStart("jobwhitelist:GetClientsideSetting:string")
				net.WriteString(key)
				net.WriteString(val)
			net.Broadcast()
		end
	else
		GAS:print("[JobWhitelist] Tried to change a config setting that doesn't exist (" .. key .. ")", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
	end
end)

GAS:netReceive("jobwhitelist:ChangeSetting:bool", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local key = net.ReadString()
	local val = net.ReadBool()
	if (GAS.JobWhitelist.Config[key] ~= nil) then
		GAS.JobWhitelist.Config[key] = val
		GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
		if (GAS.JobWhitelist.ClientsideConfigKeys[key]) then
			GAS:netStart("jobwhitelist:GetClientsideSetting:bool")
				net.WriteString(key)
				net.WriteBool(val)
			net.Broadcast()
		end
	else
		GAS:print("[JobWhitelist] Tried to change a config setting that doesn't exist (" .. key .. ")", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
	end
end)

GAS:netInit("jobwhitelist:getwhitelistpage")
GAS:netInit("jobwhitelist:getblacklistpage")
local function get_page_data(is_blacklist, transaction_id, ply)
	local job_index = net.ReadUInt(16)
	if (not RPExtraTeams[job_index]) then return end
	local page = net.ReadUInt(8)
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)

	if (not is_blacklist and not GAS.JobWhitelist:CanModifyWhitelist(ply, job_id)) then
		return
	elseif (is_blacklist and not GAS.JobWhitelist:CanModifyBlacklist(ply, job_id)) then
		return
	end

	local msg
	if (is_blacklist) then
		msg = "jobwhitelist:getblacklistpage"
	else
		msg = "jobwhitelist:getwhitelistpage"
	end

	local offset = (page - 1) * 50

	local rows_store
	local pages_store
	local function data_returned(rows, pages)
		if (rows) then
			rows_store = rows
		end
		if (pages) then
			pages_store = pages
		end
		if (rows_store and pages_store) then
			local data = util.Compress(GAS:SerializeTable(rows_store))
			local data_num = #data
			GAS:netStart(msg)
				net.WriteUInt(transaction_id, 16)
				net.WriteUInt(pages_store, 8)
				net.WriteUInt(data_num, 16)
				net.WriteData(data, data_num)
			net.Send(ply)
		end
	end

	GAS.Database:Prepare("SELECT COUNT(*) AS 'count' FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=? AND `job_id`=?", {GAS:BoolToBit(is_blacklist), job_id, offset}, function(rows)
		data_returned(nil, math.ceil(rows[1].count / 50))
	end)
	GAS.Database:Prepare([[
		SELECT `]] .. GAS.Database.ServerTablePrefix .. [[gas_jobwhitelist_listing`.`account_id` AS 'a', `]] .. GAS.Database.ServerTablePrefix .. [[gas_jobwhitelist_listing`.`usergroup` AS 'b', `lua_function` AS 'c', added_by.`account_id` AS 'd', added_by.`nick` AS 'e', user.`nick` AS 'f'
		FROM `]] .. GAS.Database.ServerTablePrefix .. [[gas_jobwhitelist_listing`
		LEFT JOIN gas_offline_player_data AS added_by ON added_by.`account_id`=`]] .. GAS.Database.ServerTablePrefix .. [[gas_jobwhitelist_listing`.`added_by` AND added_by.`server_id`=?
		LEFT JOIN gas_offline_player_data AS user ON user.`account_id`=`]] .. GAS.Database.ServerTablePrefix .. [[gas_jobwhitelist_listing`.`account_id` AND user.`server_id`=?
		WHERE `blacklist`=? AND `job_id`=?
		LIMIT ?,50
	]], {GAS.ServerID, GAS.ServerID, GAS:BoolToBit(is_blacklist), job_id, offset}, function(rows)
		if (not rows or #rows == 0) then
			GAS:TransactionNoData(msg, transaction_id, ply)
		else
			data_returned(rows)
		end
	end)
end
GAS:ReceiveNetworkTransaction("jobwhitelist:getwhitelistpage", function(...)
	get_page_data(false, ...)
end)
GAS:ReceiveNetworkTransaction("jobwhitelist:getblacklistpage", function(...)
	get_page_data(true, ...)
end)

GAS:netInit("jobwhitelist:enable_list")
GAS:netReceive("jobwhitelist:enable_list", function(ply)
	local blacklist = net.ReadBool()
	local enabled = net.ReadBool()
	local job_index = net.ReadUInt(16)
	if (not RPExtraTeams[job_index]) then return end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (blacklist) then
		if (OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/" .. job_id .. "/blacklist/enable_disable")) then
			if (enabled) then
				GAS.JobWhitelist:EnableBlacklist(job_index, ply)
			else
				GAS.JobWhitelist:DisableBlacklist(job_index, ply)
			end
		end
	else
		if (OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/" .. job_id .. "/whitelist/enable_disable")) then
			if (enabled) then
				GAS.JobWhitelist:EnableWhitelist(job_index, ply)
			else
				GAS.JobWhitelist:DisableWhitelist(job_index, ply)
			end
		end
	end
end)

GAS:netInit("jobwhitelist:add_to_list")
GAS:netReceive("jobwhitelist:add_to_list", function(ply)
	local blacklist = net.ReadBool()
	local job_index = net.ReadUInt(16)
	local data_type = net.ReadUInt(4)
	local value
	if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
		value = net.ReadUInt(31)
	else
		value = net.ReadString()
	end
	if (not RPExtraTeams[job_index]) then return end
	if (not GAS.JobWhitelist:ModificationPermissionCheck(ply, OpenPermissions:GetTeamIdentifier(job_index), true, blacklist, data_type)) then return end
	if (blacklist) then
		GAS.JobWhitelist:AddToBlacklist(job_index, data_type, value, ply)
	else
		GAS.JobWhitelist:AddToWhitelist(job_index, data_type, value, ply)
	end
end)

GAS:netInit("jobwhitelist:delete_from_list")
GAS:netReceive("jobwhitelist:delete_from_list", function(ply)
	local blacklist = net.ReadBool()
	local job_index = net.ReadUInt(16)
	local data_type = net.ReadUInt(4)
	local value
	if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
		value = net.ReadUInt(31)
	else
		value = net.ReadString()
	end
	if (not RPExtraTeams[job_index]) then return end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (not GAS.JobWhitelist:ModificationPermissionCheck(ply, OpenPermissions:GetTeamIdentifier(job_index), false, blacklist, data_type)) then return end
	if (blacklist) then
		GAS.JobWhitelist:RemoveFromBlacklist(job_index, data_type, value, ply)
	else
		GAS.JobWhitelist:RemoveFromWhitelist(job_index, data_type, value, ply)
	end
end)

GAS:netInit("jobwhitelist:disable_autoswitch")
GAS:netReceive("jobwhitelist:disable_autoswitch", function(ply)
	local job_index = net.ReadUInt(16)
	local disable_autoswitch = net.ReadBool()
	if (not OpenPermissions:IsOperator(ply)) then return end
	if (not RPExtraTeams[job_index]) then return end
	GAS.JobWhitelist.Config.AutoSwitch_Disabled[OpenPermissions:GetTeamIdentifier(job_index)] = disable_autoswitch or nil
	GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
end)

GAS:netInit("jobwhitelist:default_whitelisted")
GAS:netReceive("jobwhitelist:default_whitelisted", function(ply)
	local job_index = net.ReadUInt(16)
	local default_whitelisted = net.ReadBool()
	if (not OpenPermissions:IsOperator(ply)) then return end
	if (not RPExtraTeams[job_index]) then return end
	GAS.JobWhitelist.Config.DefaultWhitelisted[OpenPermissions:GetTeamIdentifier(job_index)] = default_whitelisted or nil
	GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
end)

GAS:netInit("jobwhitelist:default_blacklisted")
GAS:netReceive("jobwhitelist:default_blacklisted", function(ply)
	local job_index = net.ReadUInt(16)
	local default_blacklisted = net.ReadBool()
	if (not OpenPermissions:IsOperator(ply)) then return end
	if (not RPExtraTeams[job_index]) then return end
	GAS.JobWhitelist.Config.DefaultBlacklisted[OpenPermissions:GetTeamIdentifier(job_index)] = default_blacklisted or nil
	GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
end)

GAS:netInit("jobwhitelist:contextmenu:add_to_all_whitelists")
GAS:netInit("jobwhitelist:contextmenu:add_to_all_blacklists")
GAS:netInit("jobwhitelist:contextmenu:remove_from_all_whitelists")
GAS:netInit("jobwhitelist:contextmenu:remove_from_all_blacklists")

GAS:netReceive("jobwhitelist:contextmenu:add_to_all_whitelists", function(ply)
	local account_id = net.ReadUInt(31)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/add_to_all_whitelists")) then return end
	
	local added_by_account_id = ply:AccountID()
	
	for job_index in pairs(GAS.JobWhitelist.EnabledWhitelists) do
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] or {}
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id][job_index] = true
		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id][job_index] = nil
		end
		
		GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " (`blacklist`,`job_id`,`account_id`,`added_by`) VALUES(0,?,?,?)", {OpenPermissions:GetTeamIdentifier(job_index), account_id, added_by_account_id})
	end
end)

GAS:netReceive("jobwhitelist:contextmenu:add_to_all_blacklists", function(ply)
	local account_id = net.ReadUInt(31)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/add_to_all_blacklists")) then return end
	
	local added_by_account_id = ply:AccountID()
	
	for job_index in pairs(GAS.JobWhitelist.EnabledBlacklists) do
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] or {}
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id][job_index] = true
		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id][job_index] = nil
		end
		
		GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " (`blacklist`,`job_id`,`account_id`,`added_by`) VALUES(1,?,?,?)", {OpenPermissions:GetTeamIdentifier(job_index), account_id, added_by_account_id})
	end
end)

GAS:netReceive("jobwhitelist:contextmenu:remove_from_all_whitelists", function(ply)
	local account_id = net.ReadUInt(31)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/remove_from_all_whitelists")) then return end
	
	if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id]) then
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] = {}
	end
	GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " WHERE `account_id`=" .. account_id .. " AND `blacklist`=0")
end)

GAS:netReceive("jobwhitelist:contextmenu:remove_from_all_blacklists", function(ply)
	local account_id = net.ReadUInt(31)
	if (not OpenPermissions:HasPermission(ply, "gmodadminsuite_jobwhitelist/remove_from_all_blacklists")) then return end
	
	if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id]) then
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][account_id] = {}
	end
	GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " WHERE `account_id`=" .. account_id .. " AND `blacklist`=1")
end)

GAS:netInit("jobwhitelist:clear_whitelist")
GAS:netInit("jobwhitelist:clear_blacklist")
GAS:netReceive("jobwhitelist:clear_whitelist", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local job_id = net.ReadUInt(16)
	GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " WHERE `blacklist`=0 AND `job_id`=" .. OpenPermissions:GetTeamIdentifier(job_id))
	for _,list_type in pairs(GAS.JobWhitelist.Whitelists) do
		for _,account_id_tbl in pairs(list_type) do
			account_id_tbl[job_id] = nil
		end
	end
end)
GAS:netReceive("jobwhitelist:clear_blacklist", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	local job_id = net.ReadUInt(16)
	GAS.Database:Query("DELETE FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " WHERE `blacklist`=1 AND `job_id`=" .. OpenPermissions:GetTeamIdentifier(job_id))
	for _,list_type in pairs(GAS.JobWhitelist.Blacklists) do
		for _,account_id_tbl in pairs(list_type) do
			account_id_tbl[job_id] = nil
		end
	end
end)

-- FILE #2
local function OpenPermissions_Init()
	GAS:unhook("OpenPermissions:Ready", "jobwhitelist:OpenPermissions")

	GAS.JobWhitelist.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_jobwhitelist", {
		Name = "Billy's Whitelist",
		Color = Color(0,130,255),
		Icon = "icon16/vcard_edit.png",
		Logo = {
			Path = "gmodadminsuite/bwhitelist.vtf",
			Width = 256,
			Height = 256
		}
	})

	local bulk_category = GAS.JobWhitelist.OpenPermissions:AddToTree({
		Label = "Bulk Actions",
		Icon = "icon16/cog.png",
	})

	bulk_category:AddToTree({
		Label = "ADD to all whitelists",
		Value = "add_to_all_whitelists",
		Tip = "Can this group ADD a player to ALL whitelists in bulk?",
		Default = OpenPermissions.CHECKBOX.CROSSED,
		Icon = "icon16/user_green.png",
	})

	bulk_category:AddToTree({
		Label = "ADD to all blacklists",
		Value = "add_to_all_blacklists",
		Tip = "Can this group ADD a player to ALL blacklists in bulk?",
		Default = OpenPermissions.CHECKBOX.CROSSED,
		Icon = "icon16/user_red.png",
	})

	bulk_category:AddToTree({
		Label = "REMOVE from all whitelists",
		Value = "remove_from_all_whitelists",
		Tip = "Can this group REMOVE a player from ALL whitelists in bulk?",
		Default = OpenPermissions.CHECKBOX.CROSSED,
		Icon = "icon16/user_green.png",
	})

	bulk_category:AddToTree({
		Label = "REMOVE from all blacklists",
		Value = "remove_from_all_blacklists",
		Tip = "Can this group REMOVE a player from ALL blacklists in bulk?",
		Default = OpenPermissions.CHECKBOX.CROSSED,
		Icon = "icon16/user_red.png",
	})
	
	GAS.Teams:Ready(function()
		for category_index, category in pairs(DarkRP.getCategories().jobs) do
			local op_category_item
			for _,job in pairs(category.members) do
				if ((GM or GAMEMODE).DefaultTeam == job.team) then continue end
				if (not op_category_item) then
					op_category_item = GAS.JobWhitelist.OpenPermissions:AddToTree({
						Label = category.name,
						Color = category.color
					})
				end
				local op_job_category = op_category_item:AddToTree({
					Label = job.name,
					Color = job.color,
					Value = OpenPermissions:GetTeamIdentifier(job.team)
				})
	
				local whitelist = op_job_category:AddToTree({
					Label = "Whitelist",
					Color = Color(76,216,76),
					Value = "whitelist",
				})
	
					whitelist:AddToTree({
						Label = "Enable/Disable",
						Value = "enable_disable",
						Icon  = "icon16/wand.png",
					})
	
					local add_to_whitelist = whitelist:AddToTree({
						Label = "Add to Whitelist",
						Value = "add_to",
						Icon  = "icon16/add.png",
					})
						add_to_whitelist:AddToTree({
							Label = "Add SteamIDs",
							Value = "steamids",
							Icon = "icon16/user_gray.png"
						})
						add_to_whitelist:AddToTree({
							Label = "Add Usergroups",
							Value = "usergroups",
							Icon = "icon16/group.png"
						})
						add_to_whitelist:AddToTree({
							Label = "Add Lua Functions",
							Value = "lua_functions",
							Icon = "icon16/script.png"
						})
	
					local remove_from_whitelist = whitelist:AddToTree({
						Label = "Remove from Whitelist",
						Value = "remove_from",
						Icon  = "icon16/delete.png",
					})
						remove_from_whitelist:AddToTree({
							Label = "Remove SteamIDs",
							Value = "steamids",
							Icon = "icon16/user_gray.png"
						})
						remove_from_whitelist:AddToTree({
							Label = "Remove Usergroups",
							Value = "usergroups",
							Icon = "icon16/group.png"
						})
						remove_from_whitelist:AddToTree({
							Label = "Remove Lua Functions",
							Value = "lua_functions",
							Icon = "icon16/script.png"
						})
	
				local blacklist = op_job_category:AddToTree({
					Label = "Blacklist",
					Color = Color(216,76,76),
					Value = "blacklist"
				})
	
					blacklist:AddToTree({
						Label = "Enable/Disable",
						Value = "enable_disable",
						Icon  = "icon16/wand.png"
					})
	
					local add_to_blacklist = blacklist:AddToTree({
						Label = "Add to Blacklist",
						Value = "add_to",
						Icon  = "icon16/add.png",
					})
						add_to_blacklist:AddToTree({
							Label = "Add SteamIDs",
							Value = "steamids",
							Icon = "icon16/user_gray.png"
						})
						add_to_blacklist:AddToTree({
							Label = "Add Usergroups",
							Value = "usergroups",
							Icon = "icon16/group.png"
						})
						add_to_blacklist:AddToTree({
							Label = "Add Lua Functions",
							Value = "lua_functions",
							Icon = "icon16/script.png"
						})
	
					local remove_from_blacklist = blacklist:AddToTree({
						Label = "Remove from Blacklist",
						Value = "remove_from",
						Icon  = "icon16/delete.png"
					})
						remove_from_blacklist:AddToTree({
							Label = "Remove SteamIDs",
							Value = "steamids",
							Icon = "icon16/user_gray.png"
						})
						remove_from_blacklist:AddToTree({
							Label = "Remove Usergroups",
							Value = "usergroups",
							Icon = "icon16/group.png"
						})
						remove_from_blacklist:AddToTree({
							Label = "Remove Lua Functions",
							Value = "lua_functions",
							Icon = "icon16/script.png"
						})
			end
		end
	end)

	function GAS.JobWhitelist.Factions:ReloadPermissions()
		GAS.JobWhitelist.Factions.OpenPermissions = OpenPermissions:RegisterAddon("gmodadminsuite_jobwhitelist_factions", {
			Name = "Billy's Whitelist Factions",
			Color = Color(0,130,255),
			Icon = "icon16/flag_red.png"
		})
	
		for index, faction in pairs(GAS.JobWhitelist.Factions.Config.Factions) do
			GAS.JobWhitelist.Factions.OpenPermissions:AddToTree({
				Label = faction.Name,
				Value = faction.ID,
				Tip = "Can join faction?",
				Default = OpenPermissions.CHECKBOX.TICKED
			})
		end
	end
	GAS.JobWhitelist.Factions:ReloadPermissions()
end

if (OpenPermissions_Ready == true) then
	OpenPermissions_Init()
else
	GAS:hook("OpenPermissions:Ready", "jobwhitelist:OpenPermissions", OpenPermissions_Init)
end