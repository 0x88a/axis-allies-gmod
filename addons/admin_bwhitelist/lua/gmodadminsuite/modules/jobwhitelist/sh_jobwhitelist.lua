GAS.JobWhitelist = {}

include("gmodadminsuite/modules/jobwhitelist/sh_factions.lua")

GAS.JobWhitelist.LIST_TYPE_STEAMID      = 0
GAS.JobWhitelist.LIST_TYPE_USERGROUP    = 1
GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION = 2

if (CLIENT) then
	local function L(phrase, ...)
		if (#({...}) == 0) then
			return GAS:Phrase(phrase, "jobwhitelist")
		else
			return GAS:PhraseFormat(phrase, "jobwhitelist", ...)
		end
	end
	
	function GAS.JobWhitelist:GetListType(str)
		if (str == L"steamid") then
			return GAS.JobWhitelist.LIST_TYPE_STEAMID
		elseif (str == L"usergroup") then
			return GAS.JobWhitelist.LIST_TYPE_USERGROUP
		elseif (str == L"lua_function") then
			return GAS.JobWhitelist.LIST_TYPE_LUA_FUNCTION
		end
	end

	function GAS.JobWhitelist:GetJobData(job_index, callback)
		GAS:StartNetworkTransaction(
			"jobwhitelist:getjobdata",

			function()
				net.WriteUInt(job_index, 16)
			end,

			function()
				callback(net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool(), net.ReadBool())
			end
		)
	end

	function GAS.JobWhitelist:GetListDataPage(is_blacklist, job_index, page, callback)
		local msg
		if (is_blacklist) then
			msg = "jobwhitelist:getblacklistpage"
		else
			msg = "jobwhitelist:getwhitelistpage"
		end
		GAS:StartNetworkTransaction(
			msg,

			function()
				net.WriteUInt(job_index, 16)
				net.WriteUInt(page, 8)
			end,

			function(data_received)
				if (data_received) then
					local page_count = net.ReadUInt(8)
					local page_data_num = net.ReadUInt(16)
					local page_data = net.ReadData(page_data_num)
					callback(true, GAS:DeserializeTable(util.Decompress(page_data)), page_count)
				else
					callback(false)
				end
			end
		)
	end

	local function SetupCustomChecks()
		for job_index,job in pairs(RPExtraTeams) do
			if (job.GAS_JobWhitelist_customCheck == nil) then
				job.GAS_JobWhitelist_customCheck = job.customCheck or false
			end
			job.customCheck = function(ply)
				return ((not GAS.JobWhitelist.Config or not GAS.JobWhitelist.AccessibleJobs) or (GAS.JobWhitelist.Config.ShowUnjoinableJobs == true or GAS.JobWhitelist.AccessibleJobs[job_index] == true)) and (job.GAS_JobWhitelist_customCheck == false or job.GAS_JobWhitelist_customCheck(ply))
			end
		end
	end

	GAS:netReceive("jobwhitelist:CanAccessAllJobs", function()
		GAS.JobWhitelist.AccessibleJobs = {}
		for job_index in ipairs(RPExtraTeams) do
			GAS.JobWhitelist.AccessibleJobs[job_index] = true
		end
	end)
	GAS:netReceive("jobwhitelist:GetPlayerAccessibleJobs", function(l)
		GAS.JobWhitelist.AccessibleJobs = {}
		local jobs = net.ReadUInt(16)
		for i=1,jobs do
			GAS.JobWhitelist.AccessibleJobs[net.ReadUInt(16)] = true
		end
	end)
	GAS:netReceive("jobwhitelist:GetPlayerAccessibleJob", function()
		GAS.JobWhitelist.AccessibleJobs = GAS.JobWhitelist.AccessibleJobs or {}
		GAS.JobWhitelist.AccessibleJobs[net.ReadUInt(16)] = net.ReadBool() or nil
	end)
	GAS:netReceive("jobwhitelist:RemovePlayerAccessibleJob", function()
		GAS.JobWhitelist.AccessibleJobs = GAS.JobWhitelist.AccessibleJobs or {}
		GAS.JobWhitelist.AccessibleJobs[net.ReadUInt(16)] = true
	end)

	GAS:netReceive("jobwhitelist:GetClientsideSettings", function(l)
		local data = net.ReadData(l)
		data = GAS:DeserializeTable(util.Decompress(data))
		GAS.JobWhitelist.Config = data
	end)
	GAS:netReceive("jobwhitelist:GetClientsideSetting:string", function(l)
		local key = net.ReadString()
		local val = net.ReadString()
		GAS.JobWhitelist.Config[key] = val
	end)
	GAS:netReceive("jobwhitelist:GetClientsideSetting:bool", function(l)
		local key = net.ReadString()
		local val = net.ReadBool()
		GAS.JobWhitelist.Config[key] = val

		if (key == "ShowUnjoinableJobs" and val == false) then
			GAS:netStart("jobwhitelist:GetPlayerAccessibleJobs")
			net.SendToServer()
		end
	end)

	GAS:InitPostEntity(function()
		GAS:netStart("jobwhitelist:GetClientsideSettings")
		net.SendToServer()

		GAS:netStart("jobwhitelist:GetPlayerAccessibleJobs")
		net.SendToServer()

		SetupCustomChecks()
	end)

	include("sh_permissions.lua")
	include("sh_contextmenu.lua")
	include("cl_menu.lua")
else
	GAS.JobWhitelist.DefaultConfig = {
		AutoSwitch_Disabled = {},
		DefaultWhitelisted = {},
		DefaultBlacklisted = {},

		NotifyWhitelisted = true,
		NotifyWhitelisted_Msg = "You have been whitelisted to %job%!",

		NotifyUnwhitelisted = true,
		NotifyUnwhitelisted_Msg = "You have been unwhitelisted from %job%!",

		NotifyBlacklisted = true,
		NotifyBlacklisted_Msg = "You have been blacklisted from %job%!",

		NotifyUnblacklisted = true,
		NotifyUnblacklisted_Msg = "You have been unblacklisted from %job%!",

		NotWhitelistedMsg = "You are not whitelisted to this job!",
		BlacklistedMsg = "You are blacklisted from this job!",

		OperatorsSkipWhitelists = true,
		OperatorsSkipBlacklists = true,
		ShowUnjoinableJobs = false,
		AutoSwitch = false,
		ContextMenu = true,
		FunctionMenuKey = "Off",
		SwitchJobOnUnwhitelist = true,
		SwitchJobOnBlacklist = true,
	}
	GAS.JobWhitelist.Config = GAS:GetConfig("jobwhitelist", GAS.JobWhitelist.DefaultConfig)

	GAS.JobWhitelist.ClientsideConfigKeys = {
		NotifyWhitelisted_Msg = true,
		NotifyUnwhitelisted_Msg = true,
		NotifyBlacklisted_Msg = true,
		NotifyUnblacklisted_Msg = true,
		ShowUnjoinableJobs = true,
		ContextMenu = true
	}
	
	GAS:hook("gmodadminsuite:jobwhitelist:DarkRPReady", "jobwhitelist:DarkRPReady", function()
		GAS.Teams:Ready(function()
			include("gmodadminsuite/modules/jobwhitelist/sv_jobwhitelist.lua")
		end)
		include("gmodadminsuite/modules/jobwhitelist/sh_permissions.lua")
		include("gmodadminsuite/modules/jobwhitelist/sh_contextmenu.lua")
	end)
	if (GAS_JobWhitelist_DarkRPReady) then hook.Run("gmodadminsuite:jobwhitelist:DarkRPReady") end

	function GAS.JobWhitelist:SendPlayerAccessibleJobs(ply)
		if (GAS.JobWhitelist.Config.ShowUnjoinableJobs == true) then return	end
		if (GAS.JobWhitelist.Config.OperatorsSkipBlacklists and GAS.JobWhitelist.Config.OperatorsSkipWhitelists and OpenPermissions:IsOperator(ply)) then
			GAS:netStart("jobwhitelist:CanAccessAllJobs")
			net.Send(ply)
		else
			local accessible, count = GAS.JobWhitelist:GetPlayerAccessibleJobs(ply)
			GAS:netStart("jobwhitelist:GetPlayerAccessibleJobs")
				net.WriteUInt(count, 16)
				for job_index in pairs(accessible) do
					net.WriteUInt(job_index, 16)
				end
			net.Send(ply)
		end
	end

	GAS:netInit("jobwhitelist:CanAccessAllJobs")
	GAS:netInit("jobwhitelist:RemovePlayerAccessibleJob")
	GAS:netInit("jobwhitelist:GetPlayerAccessibleJob")
	GAS:netInit("jobwhitelist:GetPlayerAccessibleJobs")
	GAS:netReceive("jobwhitelist:GetPlayerAccessibleJobs", function(ply)
		GAS.JobWhitelist:SendPlayerAccessibleJobs(ply)
	end)

	GAS:netInit("jobwhitelist:GetClientsideSetting")
	GAS:netInit("jobwhitelist:GetClientsideSettings")
	function GAS.JobWhitelist:GetClientsideSettings()
		local clientside_settings = {}
		for key in pairs(GAS.JobWhitelist.ClientsideConfigKeys) do
			clientside_settings[key] = GAS.JobWhitelist.Config[key]
		end
		return clientside_settings
	end
	GAS:netReceive("jobwhitelist:GetClientsideSettings", function(ply)
		local data = util.Compress(GAS:SerializeTable(GAS.JobWhitelist:GetClientsideSettings()))
		GAS:netStart("jobwhitelist:GetClientsideSettings")
			net.WriteData(data, #data)
		net.Send(ply)
	end)
end