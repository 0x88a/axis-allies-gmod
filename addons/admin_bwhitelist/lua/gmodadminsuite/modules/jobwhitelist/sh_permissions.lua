function GAS.JobWhitelist:CanAccessJob(ply, job_identifier)
	return OpenPermissions:HasPermission(ply, {
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/enable_disable",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/enable_disable",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/steamids",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/usergroups",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/lua_functions",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/lua_functions",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/steamids",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/usergroups",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/lua_functions",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/lua_functions"
	})
end
function GAS.JobWhitelist:CanModifyWhitelist(ply, job_identifier)
	return OpenPermissions:HasPermission(ply, {
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/add_to/lua_functions",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/whitelist/remove_from/lua_functions"
	})
end

function GAS.JobWhitelist:CanModifyBlacklist(ply, job_identifier)
	return OpenPermissions:HasPermission(ply, {
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/add_to/lua_functions",

		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/steamids",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/usergroups",
		"gmodadminsuite_jobwhitelist/" .. job_identifier .. "/blacklist/remove_from/lua_functions"
	})
end

function GAS.JobWhitelist:ModificationPermissionCheck(ply, job_identifier, add_to, blacklist, data_type)
	local permission_id = "gmodadminsuite_jobwhitelist/" .. job_identifier .. "/"
	if (blacklist) then
		permission_id = permission_id .. "blacklist/"
	else
		permission_id = permission_id .. "whitelist/"
	end
	if (add_to) then
		permission_id = permission_id .. "add_to/"
	else
		permission_id = permission_id .. "remove_from/"
	end
	if (data_type == GAS.JobWhitelist.LIST_TYPE_STEAMID) then
		permission_id = permission_id .. "steamids"
	elseif (data_type == GAS.JobWhitelist.LIST_TYPE_USERGROUP) then
		permission_id = permission_id .. "usergroups"
	elseif (data_type == GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION) then
		permission_id = permission_id .. "lua_functions"
	end
	return OpenPermissions:HasPermission(ply, permission_id)
end