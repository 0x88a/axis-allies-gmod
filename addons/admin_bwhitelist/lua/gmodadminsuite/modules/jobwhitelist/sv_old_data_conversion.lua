local function ConvertOldData()
	print("Converting bWhitelist data...")

	local enabled_whitelists
	local enabled_blacklists

	local function async_clock()
		if (enabled_whitelists ~= nil and enabled_blacklists ~= nil) then
			GAS.Database:Query("SELECT * FROM bwhitelist", function(rows)
				GAS.Database:BeginTransaction()

				for team_name in pairs(enabled_whitelists) do
					local found = false
					for i,job in ipairs(RPExtraTeams) do
						if (job.name == team_name) then
							found = i
							break
						end
					end
					if (found ~= false) then
						GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_enabled_lists") .. " (`job_id`, `blacklist`) VALUES(?,0)", {OpenPermissions:GetTeamIdentifier(found)})
						print("[Enabled Whitelists] " .. team_name)
					else
						print("[Enabled Whitelists] Job does not exist: " .. team_name .. ", skipping")
					end
				end

				for team_name in pairs(enabled_blacklists) do
					local found = false
					for i,job in ipairs(RPExtraTeams) do
						if (job.name == team_name) then
							found = i
							break
						end
					end
					if (found ~= false) then
						GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_enabled_lists") .. " (`job_id`, `blacklist`) VALUES(?,1)", {OpenPermissions:GetTeamIdentifier(found)})
						print("[Enabled Blacklists] " .. team_name)
					else
						print("[Enabled Blacklists] Job does not exist: " .. team_name .. ", skipping")
					end
				end

				for _,row in ipairs(rows) do
					local is_blacklist = enabled_blacklists[row.name] ~= nil
					
					local found = false
					for i,job in ipairs(RPExtraTeams) do
						if (job.name == row.name) then
							found = i
							break
						end
					end
					if (found ~= false) then
						local job_id = OpenPermissions:GetTeamIdentifier(found)
						local account_id = NULL
						local usergroup = NULL
						if (tonumber(row.type) == 0) then
							account_id = GAS:SteamIDToAccountID(row.value)
							if (is_blacklist) then
								print("[Blacklist] Added SteamID " .. row.value .. " to " .. row.name)
							else
								print("[Whitelist] Added SteamID " .. row.value .. " to " .. row.name)
							end
						else
							usergroup = row.value
							if (is_blacklist) then
								print("[Blacklist] Added usergroup " .. row.value .. " to " .. row.name)
							else
								print("[Whitelist] Added usergroup " .. row.value .. " to " .. row.name)
							end
						end
						GAS.Database:Prepare("REPLACE INTO " .. GAS.Database:ServerTable("gas_jobwhitelist_listing") .. " (`blacklist`, `job_id`, `account_id`, `usergroup`) VALUES(?,?,?,?)", {GAS:BoolToBit(is_blacklist), job_id, account_id, usergroup})
					else
						local _type
						if (is_blacklist == true) then
							_type = "Blacklist Data"
						elseif (is_blacklist == false) then
							_type = "Whitelist Data"
						else
							_type = "Listing Data"
						end
						print("[" .. _type .. "] Job does not exist: " .. row.name .. ", skipping")
					end
				end

				GAS.Database:CommitTransaction(function()
					print("Finished converting bWhitelist data")
					GAS.JobWhitelist:CacheListData()
				end)
			end)
		end
	end

	GAS.Database:Query("SELECT * FROM bwhitelist_teams", function(rows)
		enabled_whitelists = {}
		for _,row in ipairs(rows) do
			enabled_whitelists[row.name] = true
		end
		async_clock()
	end)
	GAS.Database:Query("SELECT * FROM bwhitelist_blacklists", function(rows)
		enabled_blacklists = {}
		for _,row in ipairs(rows) do
			enabled_blacklists[row.name] = true
		end
		async_clock()
	end)
end

if (GAS.Database.MySQLDatabase) then
	GAS.Database:Query("SHOW TABLES LIKE 'bwhitelist'", function(rows)
		if (rows and #rows > 0) then
			GAS.JobWhitelist.Config.OldDataPresent = true
		else
			GAS.JobWhitelist.Config.OldDataPresent = false
		end
		GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
	end)
else
	GAS.Database:Query("SELECT NULL FROM sqlite_master WHERE type='table' AND name='bwhitelist'", function(rows)
		if (rows and #rows > 0) then
			GAS.JobWhitelist.Config.OldDataPresent = true
		else
			GAS.JobWhitelist.Config.OldDataPresent = false
		end
		GAS:SaveConfig("jobwhitelist", GAS.JobWhitelist.Config)
	end)
end

GAS:netInit("jobwhitelist:ConvertOldData")
GAS:netReceive("jobwhitelist:ConvertOldData", function(ply)
	if (not OpenPermissions:IsOperator(ply)) then return end
	ConvertOldData()
end)