if (SERVER) then
	AddCSLuaFile("sh_jobwhitelist.lua")
	AddCSLuaFile("sh_permissions.lua")
	AddCSLuaFile("sh_contextmenu.lua")
	AddCSLuaFile("cl_menu.lua")
	AddCSLuaFile("sh_factions.lua")
end

GAS:hook("gmodadminsuite:LoadModule:jobwhitelist", "LoadModule:jobwhitelist", function(module_info)
	if (SERVER) then
		if (not GAS_JobWhitelist_DarkRPReady) then
			if (ezJobs) then
				GAS:print("[JobWhitelist] Waiting for ezJobs...")
				GAS:hook("ezJobsLoaded","jobwhitelist:ezJobs",function()
					GAS:print("[JobWhitelist] ezJobs Ready", GAS_PRINT_COLOR_GOOD)
					GAS_JobWhitelist_DarkRPReady = true
					hook.Run("gmodadminsuite:jobwhitelist:DarkRPReady")
				end)
			elseif (DConfig) then
				GAS:print("[JobWhitelist] Waiting for DConfig...")
				GAS:hook("DConfigDataLoaded","jobwhitelist:DConfig",function()
					GAS:print("[JobWhitelist] DConfig Ready", GAS_PRINT_COLOR_GOOD)
					GAS_JobWhitelist_DarkRPReady = true
					hook.Run("gmodadminsuite:jobwhitelist:DarkRPReady")
				end)
			else
				GAS:print("[JobWhitelist] Waiting for DarkRP...")
				GAS:hook("loadCustomDarkRPItems","jobwhitelist:loadCustomDarkRPItems",function()
					GAS:print("[JobWhitelist] DarkRP Ready", GAS_PRINT_COLOR_GOOD)
					GAS_JobWhitelist_DarkRPReady = true
					hook.Run("gmodadminsuite:jobwhitelist:DarkRPReady")
				end)
			end
		end
	end
	
	GAS:GMInitialize(function()
		if (not DarkRP) then
			GAS:print("[JobWhitelist] DarkRP is not running, aborting", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_ERROR)
			return
		end

		include("gmodadminsuite/modules/jobwhitelist/sh_jobwhitelist.lua")

		if (SERVER) then
			include("gmodadminsuite/modules/jobwhitelist/sv_drm.lua")
		end
	end)
end)