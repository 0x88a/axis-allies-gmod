--## Old bWhitelist Data ##--

include("gmodadminsuite/modules/jobwhitelist/sv_old_data_conversion.lua")

--## Notifications ##--

GAS:netInit("jobwhitelist:notifywhitelisted")
GAS:netInit("jobwhitelist:notifyunwhitelisted")
GAS:netInit("jobwhitelist:notifyblacklisted")
GAS:netInit("jobwhitelist:notifyunblacklisted")

--## Debug ##--

GAS.JobWhitelist.Debug = false
function GAS.JobWhitelist:PrintDebug(str)
	if (not GAS.JobWhitelist.Debug) then return end
	GAS:print("[JobWhitelist] " .. str, GAS_PRINT_TYPE_DEBUG)
end

--## Cache Data ##--

local template = {
	[GAS.JobWhitelist.LIST_TYPE_STEAMID] = {},
	[GAS.JobWhitelist.LIST_TYPE_USERGROUP] = {},
	[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION] = {}
}

function GAS.JobWhitelist:CachePlayerAccessData(ply)
	if (GAS.JobWhitelist.EnabledWhitelists == nil) then return end

	GAS.Database:Query("SELECT `faction` FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_factions") .. " WHERE `account_id`=" .. ply:AccountID(), function(rows)
		if (not rows or #rows == 0) then return end
		for index,faction in ipairs(GAS.JobWhitelist.Factions.Config.Factions) do
			if (faction.ID == tonumber(rows[1].faction)) then
				GAS.JobWhitelist.PlayerFactions[ply] = index
				break
			end
		end
	end)
	GAS.Database:Query("SELECT * FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `account_id`=" .. ply:AccountID(), function(rows)
		if (not rows) then return end
		for _,v in ipairs(rows) do
			if (not tonumber(v.job_id)) then continue end
			local job_index = OpenPermissions:GetTeamFromIdentifier(tonumber(v.job_id))
			if (not job_index) then continue end
			if (tostring(v.blacklist) == "1") then
				GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()] = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()] or {}
				GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()][job_index] = true
			else
				GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()] or {}
				GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()][job_index] = true
			end
		end
	end)
end

function GAS.JobWhitelist:CacheListData()
	GAS.JobWhitelist.EnabledWhitelists = {}
	GAS.JobWhitelist.EnabledBlacklists = {}

	GAS.JobWhitelist.Whitelists = table.Copy(template)
	GAS.JobWhitelist.Blacklists = table.Copy(template)

	GAS.JobWhitelist.PlayerFactions = {}

	GAS.Database:Query("SELECT * FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists`", function(rows)
		if (not rows) then return end
		for _,v in ipairs(rows) do
			if (not tonumber(v.job_id)) then continue end
			local job_index = OpenPermissions:GetTeamFromIdentifier(tonumber(v.job_id))
			if (not job_index) then continue end
			if (tostring(v.blacklist) == "1") then
				GAS.JobWhitelist.EnabledBlacklists[job_index] = true
			else
				GAS.JobWhitelist.EnabledWhitelists[job_index] = true
			end
		end
	end)
	GAS.Database:Query("SELECT * FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `usergroup` IS NOT NULL OR `lua_function` IS NOT NULL", function(rows)
		if (not rows) then return end
		for _,v in ipairs(rows) do
			if (not tonumber(v.job_id)) then continue end
			local job_index = OpenPermissions:GetTeamFromIdentifier(tonumber(v.job_id))
			if (not job_index) then continue end
			if (tostring(v.blacklist) == "1") then
				if (v.usergroup ~= nil) then
					GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup] or {}
					GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup][job_index] = true
				elseif (v.lua_function ~= nil) then
					GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] or {}
					GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][v.lua_function] = true
				end
			else
				if (v.usergroup ~= nil) then
					GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup] or {}
					GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v.usergroup][job_index] = true
				elseif (v.lua_function ~= nil) then
					GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] or {}
					GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][v.lua_function] = true
				end
			end
		end
	end)

	for _,ply in pairs(player.GetHumans()) do
		GAS.JobWhitelist:CachePlayerAccessData(ply)
	end
end

GAS:hook("PlayerInitialSpawn", "jobwhitelist:CachePlayerAccessData", function(ply)
	GAS.JobWhitelist:CachePlayerAccessData(ply)

	if (cookie.GetNumber("gmodadminsuite:jobwhitelist:DefaultWhitelisted:" .. ply:AccountID(), 0) == 0) then
		cookie.Set("gmodadminsuite:jobwhitelist:DefaultWhitelisted:" .. ply:AccountID(), 1)
		for job_id, enabled in pairs(GAS.JobWhitelist.Config.DefaultWhitelisted) do
			local job_index = OpenPermissions:GetTeamFromIdentifier(job_id)
			if (job_index) then
				GAS.JobWhitelist:AddToWhitelist(job_index, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:AccountID())
			end
		end
	end
	if (cookie.GetNumber("gmodadminsuite:jobwhitelist:DefaultBlacklisted:" .. ply:AccountID(), 0) == 0) then
		cookie.Set("gmodadminsuite:jobwhitelist:DefaultBlacklisted:" .. ply:AccountID(), 1)
		for job_id, enabled in pairs(GAS.JobWhitelist.Config.DefaultBlacklisted) do
			local job_index = OpenPermissions:GetTeamFromIdentifier(job_id)
			if (job_index) then
				GAS.JobWhitelist:AddToBlacklist(job_index, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:AccountID())
			end
		end
	end
end)
GAS:hook("PlayerDisconnected", "jobwhitelist:ClearPlayerAccessDataCache", function(ply)
	for job_index,data in pairs(GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID]) do
		if (data[ply:AccountID()] ~= nil) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()][job_index] = nil
		end
	end
	for job_index,data in pairs(GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID]) do
		if (data[ply:AccountID()] ~= nil) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()][job_index] = nil
		end
	end
end)

--## Setup Tables ##--

local function sql_init()
	GAS.JobWhitelist:CacheListData()
end
if (GAS.Database.MySQLDatabase) then
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_enabled_lists") .. [[ (
			`job_id` smallint(5) unsigned NOT NULL,
			`blacklist` tinyint(1) NOT NULL,
			PRIMARY KEY (`job_id`,`blacklist`),
			CONSTRAINT `jobwhitelist_enabled_lists_team_persistence` FOREIGN KEY (`job_id`) REFERENCES `gas_teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
		);

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. [[ (
			`blacklist` tinyint(1) unsigned NOT NULL,
			`job_id` smallint(5) unsigned NOT NULL,
			`account_id` int(11) unsigned DEFAULT NULL,
			`usergroup` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
			`lua_function` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
			`added_by` int(11) unsigned DEFAULT NULL,
			UNIQUE KEY `job_id` (`job_id`,`account_id`),
			UNIQUE KEY `job_id_2` (`job_id`,`usergroup`),
			UNIQUE KEY `job_id_3` (`job_id`,`lua_function`),
			CONSTRAINT `jobwhitelist_listing_team_persistence` FOREIGN KEY (`job_id`) REFERENCES `gas_teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
		);

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_factions") .. [[ (
			`account_id` int(11) unsigned NOT NULL,
			`faction` smallint(5) unsigned NOT NULL,
			PRIMARY KEY (`account_id`)
		);

	]], sql_init)
else
	GAS.Database:Query([[

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_enabled_lists") .. [[ (
			"job_id" INTEGER NOT NULL,
			"blacklist" INTEGER NOT NULL,
			PRIMARY KEY ("job_id","blacklist"),
			FOREIGN KEY ("job_id") REFERENCES "gas_teams" ("id") ON DELETE NO ACTION ON UPDATE CASCADE
		);

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. [[ (
			"blacklist" INTEGER NOT NULL,
			"job_id" INTEGER NOT NULL,
			"account_id" INTEGER DEFAULT NULL,
			"usergroup" TEXT DEFAULT NULL,
			"lua_function" TEXT DEFAULT NULL,
			"added_by" INTEGER DEFAULT NULL,
			UNIQUE ("job_id","account_id"),
			UNIQUE ("job_id","usergroup"),
			UNIQUE ("job_id","lua_function"),
			FOREIGN KEY ("job_id") REFERENCES "gas_teams" ("id") ON DELETE NO ACTION ON UPDATE CASCADE
		);

		CREATE TABLE IF NOT EXISTS ]] .. GAS.Database:ServerTable("gas_jobwhitelist_factions") .. [[ (
			"account_id" INTEGER NOT NULL,
			"faction" INTEGER NOT NULL,
			PRIMARY KEY ("account_id")
		);

	]], sql_init)
end

--## IsWhitelistEnabled, IsBlacklistEnabled ##--

function GAS.JobWhitelist:IsWhitelistEnabled(job_index)
	return (GM or GAMEMODE).DefaultTeam ~= job_index and GAS.JobWhitelist.EnabledWhitelists[job_index] == true
end

function GAS.JobWhitelist:IsBlacklistEnabled(job_index)
	return (GM or GAMEMODE).DefaultTeam ~= job_index and GAS.JobWhitelist.EnabledBlacklists[job_index] == true
end

--## EnableWhitelist, DisableWhitelist ##--

function GAS.JobWhitelist:EnableWhitelist(job_index, ply)
	if ((GM or GAMEMODE).DefaultTeam == job_index) then return end

	GAS.JobWhitelist.EnabledWhitelists[job_index] = true
	GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` (`blacklist`, `job_id`) VALUES(0, ?)", {OpenPermissions:GetTeamIdentifier(job_index)})

	for _,ply in ipairs(player.GetHumans()) do
		GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
			net.WriteUInt(job_index, 16)
			net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
		net.Send(ply)
	end

	local by_account_id
	if (IsValid(ply)) then
		by_account_id = ply:AccountID()
	end
	hook.Run("bWhitelist:WhitelistEnabled", job_index, by_account_id)
end

function GAS.JobWhitelist:DisableWhitelist(job_index, ply)
	GAS.JobWhitelist.EnabledWhitelists[job_index] = nil
	GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` WHERE `blacklist`=0 AND `job_id`=?", {OpenPermissions:GetTeamIdentifier(job_index)})

	if (GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
		for _,ply in ipairs(player.GetHumans()) do
			GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
				net.WriteUInt(job_index, 16)
				net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
			net.Send(ply)
		end
	else
		GAS:netStart("jobwhitelist:RemovePlayerAccessibleJob")
			net.WriteUInt(job_index, 16)
		net.Broadcast()
	end

	local by_account_id
	if (IsValid(ply)) then
		by_account_id = ply:AccountID()
	end
	hook.Run("bWhitelist:WhitelistDisabled", job_index, by_account_id)
end

--## EnableBlacklist, DisableBlacklist ##--

function GAS.JobWhitelist:EnableBlacklist(job_index, ply)
	if ((GM or GAMEMODE).DefaultTeam == job_index) then return end

	GAS.JobWhitelist.EnabledBlacklists[job_index] = true
	GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` (`blacklist`, `job_id`) VALUES(1, ?)", {OpenPermissions:GetTeamIdentifier(job_index)})

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		for _,ply in ipairs(player.GetHumans()) do
			if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
				GAS:netStart("jobwhitelist:CanAccessAllJobs")
				net.Send(ply)
			else
				GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
					net.WriteUInt(job_index, 16)
					net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
				net.Send(ply)
			end
		end
	end

	local by_account_id
	if (IsValid(ply)) then
		by_account_id = ply:AccountID()
	end
	hook.Run("bWhitelist:BlacklistEnabled", job_index, by_account_id)
end

function GAS.JobWhitelist:DisableBlacklist(job_index, ply)
	GAS.JobWhitelist.EnabledBlacklists[job_index] = nil
	GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` WHERE `blacklist`=1 AND `job_id`=?", {OpenPermissions:GetTeamIdentifier(job_index)})

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		if (GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
			for _,ply in ipairs(player.GetHumans()) do
				if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
					GAS:netStart("jobwhitelist:CanAccessAllJobs")
					net.Send(ply)
				else
					GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
						net.WriteUInt(job_index, 16)
						net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
					net.Send(ply)
				end
			end
		else
			GAS:netStart("jobwhitelist:RemovePlayerAccessibleJob")
				net.WriteUInt(job_index, 16)
			net.Broadcast()
		end
	end

	local by_account_id
	if (IsValid(ply)) then
		by_account_id = ply:AccountID()
	end
	hook.Run("bWhitelist:BlacklistDisabled", job_index, by_account_id)
end

--## AddToWhitelist, AddToBlacklist ##--

function GAS.JobWhitelist:AddToWhitelist(job_index, list_type, value, ply)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID and type(value) == "string") then
		if (value:find("^STEAM_%d:%d:%d+$")) then
			value = GAS:SteamIDToAccountID(value)
		elseif (value:find("^7656119%d+$")) then
			value = GAS:SteamID64ToAccountID(value)
		elseif (value == "BOT" or (tonumber(value) and tonumber(value) >= 90071996842377216)) then
			return
		elseif (tonumber(value)) then
			value = tonumber(value)
		end
	end

	local added_by_account_id = NULL
	local added_by_account_id_hook
	if (IsValid(ply)) then
		added_by_account_id, added_by_account_id_hook = ply:AccountID(), ply:AccountID()
	end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then

		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value] or {}
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = true
		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`account_id`,`added_by`) VALUES(0,?,?,?)", {job_id, value, added_by_account_id})

		local affected_ply = player.GetByAccountID(value)
		if (IsValid(affected_ply)) then
			if (GAS.JobWhitelist.Config.AutoSwitch == true and GAS.JobWhitelist.Config.AutoSwitch_Disabled[job_id] ~= true) then
				affected_ply:changeTeam(job_index)
			end
			if (GAS.JobWhitelist.Config.NotifyWhitelisted == true) then
				GAS:netStart("jobwhitelist:notifywhitelisted")
					net.WriteUInt(job_index, 12)
				net.Send(affected_ply)
			end
		end

		hook.Run("bWhitelist:SteamIDAddedToWhitelist", value, job_index, added_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_USERGROUP) then

		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value] or {}
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = true
		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`usergroup`,`added_by`) VALUES(0,?,?,?)", {job_id, value, added_by_account_id})

		hook.Run("bWhitelist:UsergroupAddedToWhitelist", value, job_index, added_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION and GAS.LuaFunctions[value] ~= nil) then

		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] or {}
		GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = true
		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`lua_function`,`added_by`) VALUES(0,?,?,?)", {job_id, value, added_by_account_id})

		hook.Run("bWhitelist:LuaFunctionAddedToWhitelist", value, job_index, added_by_account_id_hook)

	end

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		for _,ply in ipairs(player.GetHumans()) do
			if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
				GAS:netStart("jobwhitelist:CanAccessAllJobs")
				net.Send(ply)
			else
				GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
					net.WriteUInt(job_index, 16)
					net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
				net.Send(ply)
			end
		end
	end
end

function GAS.JobWhitelist:AddToBlacklist(job_index, list_type, value, ply)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID and type(value) == "string") then
		if (value:find("^STEAM_%d:%d:%d+$")) then
			value = GAS:SteamIDToAccountID(value)
		elseif (value:find("^7656119%d+$")) then
			value = GAS:SteamID64ToAccountID(value)
		elseif (value == "BOT" or (tonumber(value) and tonumber(value) >= 90071996842377216)) then
			return
		elseif (tonumber(value)) then
			value = tonumber(value)
		end
	end

	local added_by_account_id = NULL
	local added_by_account_id_hook
	if (IsValid(ply)) then
		added_by_account_id, added_by_account_id_hook = ply:AccountID(), ply:AccountID()
	end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then

		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value] = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value] or {}
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = true
		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`account_id`,`added_by`) VALUES(1,?,?,?)", {job_id, value, added_by_account_id})

		local affected_ply = player.GetByAccountID(value)
		if (IsValid(affected_ply)) then
			if (GAS.JobWhitelist.Config.SwitchJobOnBlacklist == true and affected_ply:Team() == job_index) then
				affected_ply:changeTeam((GM or GAMEMODE).DefaultTeam, true)
			end
			if (GAS.JobWhitelist.Config.NotifyBlacklisted == true) then
				GAS:netStart("jobwhitelist:notifyblacklisted")
					net.WriteUInt(job_index, 12)
				net.Send(affected_ply)
			end
		end

		hook.Run("bWhitelist:SteamIDAddedToBlacklist", value, job_index, added_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_USERGROUP) then

		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value] = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value] or {}
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = true
		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`usergroup`,`added_by`) VALUES(1,?,?,?)", {job_id, value, added_by_account_id})

		hook.Run("bWhitelist:UsergroupAddedToBlacklist", value, job_index, added_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION and GAS.LuaFunctions[value] ~= nil) then

		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index] or {}
		GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = true
		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = nil
		end

		GAS.Database:Prepare("REPLACE INTO `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` (`blacklist`,`job_id`,`lua_function`,`added_by`) VALUES(1,?,?,?)", {job_id, value, added_by_account_id})

		hook.Run("bWhitelist:LuaFunctionAddedToBlacklist", value, job_index, added_by_account_id_hook)

	end

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		for _,ply in ipairs(player.GetHumans()) do
			if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
				GAS:netStart("jobwhitelist:CanAccessAllJobs")
				net.Send(ply)
			else
				GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
					net.WriteUInt(job_index, 16)
					net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
				net.Send(ply)
			end
		end
	end
end

--## RemoveFromWhitelist, RemoveFromBlacklist ##--

function GAS.JobWhitelist:RemoveFromWhitelist(job_index, list_type, value, ply)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID and type(value) == "string") then
		if (value:find("^STEAM_%d:%d:%d+$")) then
			value = GAS:SteamIDToAccountID(value)
		elseif (value:find("^7656119%d+$")) then
			value = GAS:SteamID64ToAccountID(value)
		elseif (value == "BOT" or (tonumber(value) and tonumber(value) >= 90071996842377216)) then
			return
		elseif (tonumber(value)) then
			value = tonumber(value)
		end
	end

	local removed_by_account_id_hook
	if (IsValid(ply)) then
		removed_by_account_id_hook = ply:AccountID()
	end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then

		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=0 AND `job_id`=? AND `account_id`=?", {job_id, value})

		local affected_ply = player.GetByAccountID(value)
		if (IsValid(affected_ply)) then
			if (GAS.JobWhitelist.Config.SwitchJobOnUnwhitelist == true and affected_ply:Team() == job_index and (hook.Run("playerCanChangeTeam", affected_ply, job_index) or true) ~= true) then
				affected_ply:changeTeam((GM or GAMEMODE).DefaultTeam, true)
			end
			if (GAS.JobWhitelist.Config.NotifyUnwhitelisted == true) then
				GAS:netStart("jobwhitelist:notifyunwhitelisted")
					net.WriteUInt(job_index, 12)
				net.Send(affected_ply)
			end
		end

		hook.Run("bWhitelist:SteamIDRemovedFromWhitelist", value, job_index, removed_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_USERGROUP) then

		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=0 AND `job_id`=? AND `usergroup`=?", {job_id, value})

		hook.Run("bWhitelist:UsergroupRemovedFromWhitelist", value, job_index, removed_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION and GAS.LuaFunctions[value] ~= nil) then

		if (GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]) then
			GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=0 AND `job_id`=? AND `lua_function`=?", {job_id, value})

		hook.Run("bWhitelist:LuaFunctionRemovedFromWhitelist", value, job_index, removed_by_account_id_hook)

	end

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		for _,ply in ipairs(player.GetHumans()) do
			if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
				GAS:netStart("jobwhitelist:CanAccessAllJobs")
				net.Send(ply)
			else
				GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
					net.WriteUInt(job_index, 16)
					net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
				net.Send(ply)
			end
		end
	end
end

function GAS.JobWhitelist:RemoveFromBlacklist(job_index, list_type, value, ply)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID and type(value) == "string") then
		if (value:find("^STEAM_%d:%d:%d+$")) then
			value = GAS:SteamIDToAccountID(value)
		elseif (value:find("^7656119%d+$")) then
			value = GAS:SteamID64ToAccountID(value)
		elseif (value == "BOT" or (tonumber(value) and tonumber(value) >= 90071996842377216)) then
			return
		elseif (tonumber(value)) then
			value = tonumber(value)
		end
	end

	local removed_by_account_id_hook
	if (IsValid(ply)) then
		removed_by_account_id_hook = ply:AccountID()
	end
	local job_id = OpenPermissions:GetTeamIdentifier(job_index)
	if (list_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then

		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][value][job_index] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=1 AND `job_id`=? AND `account_id`=?", {job_id, value})

		local affected_ply = player.GetByAccountID(value)
		if (IsValid(affected_ply)) then
			if (GAS.JobWhitelist.Config.NotifyUnblacklisted == true) then
				GAS:netStart("jobwhitelist:notifyunblacklisted")
					net.WriteUInt(job_index, 12)
				net.Send(affected_ply)
			end
		end

		hook.Run("bWhitelist:SteamIDRemovedFromBlacklist", value, job_index, removed_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_USERGROUP) then

		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][value][job_index] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=1 AND `job_id`=? AND `usergroup`=?", {job_id, value})

		hook.Run("bWhitelist:UsergroupRemovedFromBlacklist", value, job_index, removed_by_account_id_hook)

	elseif (list_type == GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION and GAS.LuaFunctions[value] ~= nil) then

		if (GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]) then
			GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index][value] = nil
		end
		GAS.Database:Prepare("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing` WHERE `blacklist`=1 AND `job_id`=? AND `lua_function`=?", {job_id, value})

		hook.Run("bWhitelist:LuaFunctionRemovedFromBlacklist", value, job_index, removed_by_account_id_hook)

	end

	if (GAS.JobWhitelist.Config.ShowUnjoinableJobs ~= true) then
		for _,ply in ipairs(player.GetHumans()) do
			if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
				GAS:netStart("jobwhitelist:CanAccessAllJobs")
				net.Send(ply)
			else
				GAS:netStart("jobwhitelist:GetPlayerAccessibleJob")
					net.WriteUInt(job_index, 16)
					net.WriteBool(GAS.JobWhitelist:CanAccessJob(ply, job_index))
				net.Send(ply)
			end
		end
	end
end

--## IsWhitelisted, IsBlacklisted ##--

function GAS.JobWhitelist:IsWhitelisted(ply, job_index, faction_insensitive)
	GAS.JobWhitelist:PrintDebug("Checking if " .. ply:Nick() .. " [" .. ply:SteamID() .. "] is whitelisted for job " .. RPExtraTeams[job_index].name .. " [" .. OpenPermissions:GetTeamIdentifier(job_index) .. "]...")

	if (not GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
		GAS.JobWhitelist:PrintDebug("Whitelist is disabled!")
		return false
	end
	if (faction_insensitive ~= true and GAS.JobWhitelist.Factions.Config.Enabled) then
		local faction_index = GAS.JobWhitelist.PlayerFactions[ply]
		if (faction_index ~= nil) then
			local faction = GAS.JobWhitelist.Factions.Config.Factions[faction_index]
			if (faction ~= nil and not GAS:table_IsEmpty(faction.WhitelistTo)) then
				local job_id = OpenPermissions:GetTeamIdentifier(job_index)
				if (faction.WhitelistTo[job_id]) then
					GAS.JobWhitelist:PrintDebug("User is WHITELISTED by faction: " .. faction.Name)
					return true
				end
			end
		end
	end
	local account_id_data = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()]
	if (account_id_data and account_id_data[job_index]) then
		GAS.JobWhitelist:PrintDebug("User is WHITELISTED by SteamID")
		return true
	end
	for v in pairs(OpenPermissions:GetUserGroups(ply)) do
		local usergroup_data = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v]
		if (usergroup_data and usergroup_data[job_index]) then
			GAS.JobWhitelist:PrintDebug("User is WHITELISTED by usergroup")
			return true
		end
	end
	local lua_function_data = GAS.JobWhitelist.Whitelists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]
	if (lua_function_data) then
		for lua_function_name,_ in pairs(lua_function_data) do
			local lua_function = GAS.LuaFunctions[lua_function_name]
			if (lua_function) then
				if (lua_function(ply, job_index) == true) then
					GAS.JobWhitelist:PrintDebug("User is WHITELISTED by Lua function: " .. lua_function_name)
					return true
				end
			end
		end
	end
	GAS.JobWhitelist:PrintDebug("User is not whitelisted.")
	return false
end

function GAS.JobWhitelist:IsBlacklisted(ply, job_index, faction_insensitive)
	GAS.JobWhitelist:PrintDebug("Checking if " .. ply:Nick() .. " [" .. ply:SteamID() .. "] is blacklisted for job " .. RPExtraTeams[job_index].name .. " [" .. OpenPermissions:GetTeamIdentifier(job_index) .. "]...")

	if (not GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
		GAS.JobWhitelist:PrintDebug("Blacklist is disabled!")
		return false
	end
	if (faction_insensitive ~= true and GAS.JobWhitelist.Factions.Config.Enabled) then
		local faction_index = GAS.JobWhitelist.PlayerFactions[ply]
		if (faction_index ~= nil) then
			local faction = GAS.JobWhitelist.Factions.Config.Factions[faction_index]
			if (faction ~= nil and not GAS:table_IsEmpty(faction.BlacklistFrom)) then
				local job_id = OpenPermissions:GetTeamIdentifier(job_index)
				if (faction.BlacklistFrom[job_id]) then
					GAS.JobWhitelist:PrintDebug("User is BLACKLISTED by faction: " .. faction.Name)
					return true
				end
			end
		end
	end
	local account_id_data = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_STEAMID][ply:AccountID()]
	if (account_id_data and account_id_data[job_index]) then
		GAS.JobWhitelist:PrintDebug("User is BLACKLISTED by SteamID")
		return true
	end
	for v in pairs(OpenPermissions:GetUserGroups(ply)) do
		local usergroup_data = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_USERGROUP][v]
		if (usergroup_data and usergroup_data[job_index]) then
			GAS.JobWhitelist:PrintDebug("User is BLACKLISTED by usergroup")
			return true
		end
	end
	local lua_function_data = GAS.JobWhitelist.Blacklists[GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION][job_index]
	if (lua_function_data) then
		for lua_function_name,_ in pairs(lua_function_data) do
			local lua_function = GAS.LuaFunctions[lua_function_name]
			if (lua_function) then
				if (lua_function(ply, job_index) == true) then
					GAS.JobWhitelist:PrintDebug("User is BLACKLISTED by Lua function: " .. lua_function_name)
					return true
				end
			end
		end
	end
	GAS.JobWhitelist:PrintDebug("User is not blacklisted.")
	return false
end

--## CanAccessJob ##--

function GAS.JobWhitelist:CanAccessJob(ply, job_index, _is_operator)
	GAS.JobWhitelist:PrintDebug("CanAccessJob function called")

	local operators_skip_blacklists = GAS.JobWhitelist.Config.OperatorsSkipBlacklists
	local operators_skip_whitelists = GAS.JobWhitelist.Config.OperatorsSkipWhitelists
	local is_operator = _is_operator
	if (is_operator == nil and (operators_skip_blacklists or operators_skip_whitelists)) then
		is_operator = OpenPermissions:IsOperator(ply)
	end

	if (GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
		if (is_operator and operators_skip_blacklists) then
			GAS.JobWhitelist:PrintDebug("Player is an OPERATOR and OperatorsSkipBlacklists is ON. Skipping blacklist!")
		elseif (GAS.JobWhitelist:IsBlacklisted(ply, job_index) == true) then
			GAS.JobWhitelist:PrintDebug("Player is blacklisted from this job!")
			return false, GAS.JobWhitelist.Config.BlacklistedMsg
		else
			GAS.JobWhitelist:PrintDebug("Player is NOT blacklisted from this job")
		end
	else
		GAS.JobWhitelist:PrintDebug("Blacklist not enabled!")
	end
	if (GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
		if (is_operator and operators_skip_whitelists) then
			GAS.JobWhitelist:PrintDebug("Player is an OPERATOR and OperatorsSkipWhitelists is ON. Skipping whitelist!")
		elseif (GAS.JobWhitelist:IsWhitelisted(ply, job_index) == false) then
			GAS.JobWhitelist:PrintDebug("Player is not whitelisted to this job!")
			return false, GAS.JobWhitelist.Config.NotWhitelistedMsg
		else
			GAS.JobWhitelist:PrintDebug("Player is whitelisted to this job")
		end
	else
		GAS.JobWhitelist:PrintDebug("Whitelist not enabled!")
	end

	return true
end

--## playerCanChangeTeam ##--

GAS:hook("playerCanChangeTeam", "jobwhitelist:playerCanChangeTeam", function(ply, job_index, force)
	GAS.JobWhitelist:PrintDebug("playerCanChangeTeam hook called")
	if (force) then
		GAS.JobWhitelist:PrintDebug("Skipping because team change was FORCED.")
		return
	end

	GAS.JobWhitelist:PrintDebug("Calling CanAccessJob")
	local allow, msg = GAS.JobWhitelist:CanAccessJob(ply, job_index)
	if (allow == false) then
		GAS.JobWhitelist:PrintDebug("CanAccessJob returned false and " .. (msg or "no reason message"))
		return false, msg
	else
		GAS.JobWhitelist:PrintDebug("CanAccessJob returned true")
	end
	GAS.JobWhitelist:PrintDebug("Running other playerCanChangeTeam hooks...")
end)

--# Command #--

GAS:RegisterCommand("!bwhitelist", "jobwhitelist")

--## FunctionMenuKey ##--

GAS:hook("ShowHelp", "jobwhitelist:FunctionMenuKey:F1", function(ply)
	if (GAS.JobWhitelist.Config.FunctionMenuKey == "F1") then
		ply:ConCommand("gmodadminsuite jobwhitelist")
	end
end)
GAS:hook("ShowTeam", "jobwhitelist:FunctionMenuKey:F2", function(ply)
	if (GAS.JobWhitelist.Config.FunctionMenuKey == "F2") then
		ply:ConCommand("gmodadminsuite jobwhitelist")
	end
end)
GAS:hook("ShowSpare1", "jobwhitelist:FunctionMenuKey:F3", function(ply)
	if (GAS.JobWhitelist.Config.FunctionMenuKey == "F3") then
		ply:ConCommand("gmodadminsuite jobwhitelist")
	end
end)
GAS:hook("ShowSpare2", "jobwhitelist:FunctionMenuKey:F4", function(ply)
	if (GAS.JobWhitelist.Config.FunctionMenuKey == "F4") then
		ply:ConCommand("gmodadminsuite jobwhitelist")
	end
end)

--## Get player's relevant whitelisted and blacklisted jobs ##--

function GAS.JobWhitelist:GetPlayerAccessibleJobs(ply)
	local operators_skip_whitelists = GAS.JobWhitelist.Config.OperatorsSkipWhitelists
	local operators_skip_blacklists = GAS.JobWhitelist.Config.OperatorsSkipBlacklists
	local is_operator
	if (operators_skip_whitelists or operators_skip_blacklists) then
		is_operator = OpenPermissions:IsOperator(ply)
	end
	local accessible = {}
	local count = 0
	for job_index,job in ipairs(RPExtraTeams) do
		if (GAS.JobWhitelist:CanAccessJob(ply, job_index, is_operator)) then
			accessible[job_index] = true
			count = count + 1
		end
	end
	return accessible, count
end

--## Resets ##--

GAS:netInit("jobwhitelist:reset_config")
GAS:netInit("jobwhitelist:reset_factions_config")
GAS:netInit("jobwhitelist:disable_all_whitelists")
GAS:netInit("jobwhitelist:disable_all_blacklists")
GAS:netInit("jobwhitelist:destroy_all_data")
GAS:netInit("jobwhitelist:destroy_faction_data")
GAS:netInit("jobwhitelist:reset_everything")

GAS:netInit("jobwhitelist:CloseMenu")

local kicked_msg = "Kicked by GmodAdminSuite: you are not permitted to perform this dangerous operation"

GAS:netReceive("jobwhitelist:reset_config", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS:DeleteConfig("jobwhitelist")
	GAS.JobWhitelist.Config = GAS:GetConfig("jobwhitelist", GAS.JobWhitelist.DefaultConfig)
	
	GAS:netStart("jobwhitelist:CloseMenu")
	net.Broadcast()
end)

GAS:netReceive("jobwhitelist:reset_factions_config", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS:DeleteConfig("jobwhitelist_factions")
	GAS.JobWhitelist.Factions.Config = GAS:GetConfig("jobwhitelist_factions", GAS.JobWhitelist.Factions.DefaultConfig)
	GAS.JobWhitelist.Factions:ConfigRefresh()
	
	GAS:netStart("jobwhitelist:CloseMenu")
	net.Broadcast()
end)

GAS:netReceive("jobwhitelist:disable_all_whitelists", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` WHERE `blacklist`=0")

	GAS.JobWhitelist:CacheListData()
end)
GAS:netReceive("jobwhitelist:disable_all_blacklists", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists` WHERE `blacklist`=1")

	GAS.JobWhitelist:CacheListData()
end)

GAS:netReceive("jobwhitelist:destroy_all_data", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing`")
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists`")

	GAS.JobWhitelist:CacheListData()
end)

GAS:netReceive("jobwhitelist:destroy_faction_data", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_factions`")

	GAS.JobWhitelist:CacheListData()
end)

GAS:netReceive("jobwhitelist:reset_everything", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then ply:Kick(kicked_msg) return end
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_listing`")
	GAS.Database:Query("DELETE FROM `" .. GAS.Database.ServerTablePrefix .. "gas_jobwhitelist_enabled_lists`")

	GAS:DeleteConfig("jobwhitelist")
	GAS.JobWhitelist.Config = GAS:GetConfig("jobwhitelist", GAS.JobWhitelist.DefaultConfig)
	
	GAS:netStart("jobwhitelist:CloseMenu")
	net.Broadcast()

	GAS.JobWhitelist:CacheListData()
end)

--## Concommands ##--

concommand.Add("gas_jobwhitelist", function(ply, cmd, args)
	if (IsValid(ply)) then return end
	if (#args == 0) then
		GAS:print("[JobWhitelist] gas_jobwhitelist debug 1/0 - turns on verbose debugging information about who can/can't join jobs and why")
		GAS:print("[JobWhitelist] gas_jobwhitelist add/remove steamid32/64 whitelist/blacklist TEAM_VARIABLE")
		GAS:print("[JobWhitelist] gas_jobwhitelist enable/disable whitelist/blacklist TEAM_VARIABLE")
	elseif (args[1] == "debug") then
		if (not args[2]) then
			GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
		elseif (args[2] == "0") then
			GAS:print("[JobWhitelist] Debug turned off")
			GAS.JobWhitelist.Debug = false
		elseif (args[2] == "1") then
			GAS:print("[JobWhitelist] Debug turned on")
			GAS.JobWhitelist.Debug = true
		end
	elseif (args[1] == "enable" or args[1] == "disable") then
		local is_blacklist
		if (args[2] == "whitelist") then
			is_blacklist = false
		elseif (args[2] == "blacklist") then
			is_blacklist = true
		end
		if (is_blacklist ~= nil) then
			local job_index
			if (not args[3]) then
				GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (invalid TEAM_VARIABLE)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
			elseif (_G[args[3]] ~= nil and tonumber(_G[args[3]]) ~= nil and RPExtraTeams[tonumber(_G[args[3]])]) then
				job_index = tonumber(_G[args[3]])
			else
				GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (TEAM_VARIABLE not found)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
			end
			if (job_index ~= nil) then
				if (is_blacklist) then
					if (args[1] == "enable") then
						if (GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
							GAS:print("[JobWhitelist] The blacklist for this job is already enabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						else
							GAS.JobWhitelist:EnableBlacklist(job_index)
							GAS:print("[JobWhitelist] Enabled blacklist successfully", GAS_PRINT_COLOR_GOOD)
						end
					else
						if (GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
							GAS.JobWhitelist:DisableBlacklist(job_index)
							GAS:print("[JobWhitelist] Disabled blacklist successfully", GAS_PRINT_COLOR_GOOD)
						else
							GAS:print("[JobWhitelist] The blacklist for this job is already disabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						end
					end
				else
					if (args[1] == "enable") then
						if (GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
							GAS:print("[JobWhitelist] The whitelist for this job is already enabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						else
							GAS.JobWhitelist:EnableWhitelist(job_index)
							GAS:print("[JobWhitelist] Enabled whitelist successfully", GAS_PRINT_COLOR_GOOD)
						end
					else
						if (GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
							GAS.JobWhitelist:DisableWhitelist(job_index)
							GAS:print("[JobWhitelist] Disabled whitelist successfully", GAS_PRINT_COLOR_GOOD)
						else
							GAS:print("[JobWhitelist] The whitelist for this job is already disabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						end
					end
				end
			end
		else
			GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
		end
	elseif (args[1] == "add" or args[1] == "remove") then
		local account_id
		if (args[2] ~= nil) then
			if (args[2]:find("^STEAM_%d:%d:%d+$")) then
				account_id = GAS:SteamIDToAccountID(args[2])
			elseif (args[2]:find("^7656119%d+$")) then
				account_id = GAS:SteamID64ToAccountID(args[2])
			end
		end
		if (not account_id) then
			GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (invalid SteamID32/64)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
		else
			local is_blacklist
			if (not args[3]) then
				GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (invalid whitelist/blacklist)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
			elseif (args[3] == "whitelist") then
				is_blacklist = false
			elseif (args[3] == "blacklist") then
				is_blacklist = true
			else
				GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (invalid whitelist/blacklist)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
			end
			if (is_blacklist ~= nil) then
				local job_index
				if (not args[4]) then
					GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (invalid TEAM_VARIABLE)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
				elseif (_G[args[4]] ~= nil and tonumber(_G[args[4]]) ~= nil and RPExtraTeams[tonumber(_G[args[4]])]) then
					job_index = tonumber(_G[args[4]])
				else
					GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help (TEAM_VARIABLE not found)", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
				end
				if (job_index ~= nil) then
					if (is_blacklist) then
						if (not GAS.JobWhitelist:IsBlacklistEnabled(job_index)) then
							GAS:print("[JobWhitelist] The blacklist for this job is not enabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						else
							GAS.JobWhitelist:AddToBlacklist(job_index, GAS.JobWhitelist.LIST_TYPE_STEAMID, account_id)
							GAS:print("[JobWhitelist] Added to blacklist successfully", GAS_PRINT_COLOR_GOOD)
						end
					else
						if (not GAS.JobWhitelist:IsWhitelistEnabled(job_index)) then
							GAS:print("[JobWhitelist] The whitelist for this job is not enabled", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
						else
							GAS.JobWhitelist:AddToWhitelist(job_index, GAS.JobWhitelist.LIST_TYPE_STEAMID, account_id)
							GAS:print("[JobWhitelist] Added to whitelist successfully", GAS_PRINT_COLOR_GOOD)
						end
					end
				end
			end
		end
	else
		GAS:print("[JobWhitelist] Invalid arguments, type \"gas_jobwhitelist\" for help", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
	end
end)

hook.Run("bWhitelist:Init")