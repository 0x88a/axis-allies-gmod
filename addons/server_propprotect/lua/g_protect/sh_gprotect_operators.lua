gProtect = gProtect or {config = {}}
gProtect.config = gProtect.config or {}

gProtect.config.ModuleCoordination = {
	["general"] = -3,
	["ghosting"] = 2,
	["damage"] = 3,
	["anticollide"] = 4,
	["spamprotection"] = 5,
	["spawnrestriction"] = 6,
	["toolgunsettings"] = 7,
	["physgunsettings"] = 8,
	["gravitygunsettings"] = 9,
	["canpropertysettings"] = 10,
	["advdupe2"] = 11,
	["miscs"] = 12
}

gProtect.config.sortOrders = {
	["general"] = {
		["blacklist"] = 0,
		["remDiscPlyEnt"] = 2,
		["remDiscPlyEntSpecific"] = 3,
		["protectedFrozenEnts"] = 4,
		["protectedFrozenGroup"] = 5,
		["maxModelSize"] = 6
	},

	["ghosting"] = {
		["enabled"] = 1,
		["ghostColor"] = 2,
		["antiObscuring"] = 3,
		["onPhysgun"] = 4,
		["useBlacklist"] = 5,
		["entities"] = 6
	},

	["damage"] = {
		["enabled"] = 1,
		["useBlacklist"] = 2,
		["entities"] = 3,
		["blacklistedEntPlayerDamage"] = 4,
		["vehiclePlayerDamage"] = 5,
		["worldPlayerDamage"] = 6,
		["immortalEntities"] = 7,
		["bypassGroups"] = 8,
		["canDamageWorldEntities"] = 9
	},

	["anticollide"] = {
		["enabled"] = 1,
		["notifyStaff"] = 2,
		["protectDarkRPEntities"] = 3,
		["DRPentitiesThreshold"] = 4,
		["DRPentitiesException"] = 5,
		["protectSpawnedEntities"] = 6,
		["entitiesThreshold"] = 7,
		["entitiesException"] = 8,
		["protectSpawnedProps"] = 9,
		["propsThreshold"] = 10,
		["propsException"] = 11,
		["useBlacklist"] = 12,
		["ghostEntities"] = 13,
		["specificEntities"] = 14
	},

	["spamprotection"] = {
		["enabled"] = 1,
		["threshold"] = 2,
		["delay"] = 3,
		["action"] = 4,
		["notifyStaff"] = 5,
		["protectProps"] = 6,
		["protectEntities"] = 7,
	},

	["spawnrestriction"] = {
		["enabled"] = 1,
		["propSpawnPermission"] = 2,
		["SENTSpawnPermission"] = 3,
		["SWEPSpawnPermission"] = 4,
		["vehicleSpawnPermission"] = 5,
		["NPCSpawnPermission"] = 6,
		["ragdollSpawnPermission"] = 7,
		["effectSpawnPermission"] = 8,
		["blockedSENTs"] = 9,
		["blockedEntityIsBlacklist"] = 10,
		["blockedModels"] = 11,
		["blockedModelsisBlacklist"] = 12,
		["bypassGroups"] = 13
	},

	["toolgunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["restrictTools"] = 4,
		["groupToolRestrictions"] = 5,
		["entityTargetability"] = 6,
		["bypassTargetabilityTools"] = 7,
		["bypassGroups"] = 8,
		["antiSpam"] = 9
	},

	["physgunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwned"] = 4,
		["DisableReloadUnfreeze"] = 5,
		["PickupVehiclePermission"] = 6,
		["StopMotionOnDrop"] = 7,
		["blockMultiplePhysgunning"] = 8,
		["maxDropObstructs"] = 9,
		["maxDropObstructsAction"] = 10,
		["blockedEntities"] = 11,
		["bypassGroups"] = 12
	},

	["gravitygunsettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["targetPlayerOwned"] = 4,
		["DisableGravityGunPunting"] = 5,
		["blockedEntities"] = 6,
		["bypassGroups"] = 7
	},

	["canpropertysettings"] = {
		["enabled"] = 1,
		["targetWorld"] = 2,
		["targetPlayerOwned"] = 3,
		["blockedProperties"] = 4,
		["blockedPropertiesisBlacklist"] = 5,
		["blockedEntities"] = 6,
		["bypassGroups"] = 7
	},

	["advdupe2"] = {
		["enabled"] = 1,
		["notifyStaff"] = 2,
		["PreventRopes"] = 3,
		["PreventScaling"] = 4,
		["PreventNoGravity"] = 5,
		["PreventTrail"] = 6,
		["PreventUnfreezeAll"] = 7,
		["BlacklistedCollisionGroups"] = 8,
		["WhitelistedConstraints"] = 9
	},

	["miscs"] = {
		["enabled"] = 1,
		["ClearDecals"] = 2,
		["NoBlackoutGlitch"] = 3,
		["FadingDoorLag"] = 4,
		["DisableReloadUnfreeze"] = 5,
		["DisableMotion"] = 6,
		["DisableGravityGunPunting"] = 7,
		["freezeOnSpawn"] = 8,
		["preventFadingDoorAbuse"] = 9,
		["preventSpawnNearbyPlayer"] = 10,
		["DRPEntForceOwnership"] = 11,
		["DRPMaxObstructsOnPurchaseEnts"] = 12,
		["DRPObstructsFilter"] = 13
	}
}

gProtect.config.valueRules = { --- This is because the tableviewer is modular and coded to be as efficient as possible hence its structure.76561198284194412
	["general"] = {
		["blacklist"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["notifyType"] = {intLimit = {min = 0, max = 2}},
		["remDiscPlyEnt"] = {intLimit = {min = -1, max = 999}},
		["remDiscPlyEntSpecific"] = {customTable = "int", tableAlternatives = function() local tbl = {["prop_physics"] = true} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["protectedFrozenEnts"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["maxModelSize"] = {intLimit = {min = 0, max = 100000}}
	},
	["ghosting"] = {
		["entities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["antiObscuring"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end}
	},
	["damage"] = {
		["entities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["immortalEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["canDamageWorldEntities"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
	},
	["anticollide"] = {
		["ghostEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["threshold"] = {intLimit = {min = 0, max = 100000}},
		["delay"] = {intLimit = {min = 0, max = 30}},
		["action"] = {intLimit = {min = 1, max = 3}},
		["exception"] = {intLimit = {min = 0, max = 2}},
		["protectDarkRPEntities"] = {intLimit = {min = 0, max = 4}},
		["protectSpawnedEntities"] = {intLimit = {min = 0, max = 3}},
		["protectSpawnedProps"] = {intLimit = {min = 0, max = 3}},
		["specificEntities"] = {customTable = "int", tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end}
	},
	["spamprotection"] = {
		["threshold"] = {intLimit = {min = 0, max = 100000}},
		["delay"] = {intLimit = {min = 0, max = 30}},
		["action"] = {intLimit = {min = 0, max = 2}}
 	},
	["spawnrestriction"] = {
		["blockedSENTs"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["propSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["SENTSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["SWEPSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["vehicleSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["NPCSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["ragdollSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["effectSpawnPermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}}
	},
	["toolgunsettings"] = {
		["restrictTools"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(spawnmenu.GetTools()) do for i,z in pairs(v.Items) do for key, data in pairs(z) do if istable(data) and data.ItemName then local tocompare = string.lower(data.ItemName) if data.ItemName ~= tocompare then continue end tbl[data.ItemName] = true end end end end return tbl end},
		["groupToolRestrictions"] = {addRules = {list = {}, isBlacklist = true}, toggleableValue = "isBlacklist", tableDeletable = true, undeleteableTable = "list", tableAlternatives = function() local tbl = {} for k,v in pairs(spawnmenu.GetTools()) do for i,z in pairs(v.Items) do for key, data in pairs(z) do if istable(data) and data.ItemName then local tocompare = string.lower(data.ItemName) if data.ItemName ~= tocompare then continue end tbl[data.ItemName] = true end end end end return tbl end},
		["entityTargetability"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end, toggleableValue = "isBlacklist", onlymodifytable = true},
		["targetWorld"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["targetPlayerOwned"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["blockedEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["bypassTargetabilityTools"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(spawnmenu.GetTools()) do for i,z in pairs(v.Items) do for key, data in pairs(z) do if istable(data) and data.ItemName then local tocompare = string.lower(data.ItemName) if data.ItemName ~= tocompare then continue end tbl[data.ItemName] = true end end end end return tbl end},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["antiSpam"] = {customTable = "int", tableAlternatives = function() local tbl = {} for k,v in pairs(spawnmenu.GetTools()) do for i,z in pairs(v.Items) do for key, data in pairs(z) do if istable(data) and data.ItemName then local tocompare = string.lower(data.ItemName) if data.ItemName ~= tocompare then continue end tbl[data.ItemName] = true end end end end return tbl end},

	},
	["physgunsettings"] = {
		["targetWorld"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["targetPlayerOwned"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["maxDropObstructs"] = {intLimit = {min = 0, max = 10000}},
		["maxDropObstructsAction"] = {intLimit = {min = 1, max = 3}},
		["blockedEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["PickupVehiclePermission"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}}
	},
	["gravitygunsettings"] = {
		["targetWorld"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["targetPlayerOwned"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["blockedEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}}
	},
	["canpropertysettings"] = {
		["blockedProperties"] = {tableAlternatives = function() module( "properties", package.seeall ) local tbl = {} for k,v in pairs(List) do tbl[k] = true end return tbl end or {}},
		["targetWorld"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["targetPlayerOwned"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["bypassGroups"] = {tableAlternatives = CAMI and CAMI.GetUsergroups and function() local tbl = {} for k,v in pairs(CAMI.GetUsergroups()) do tbl[k] = true end return tbl end or {}},
		["blockedEntities"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end}
	},
	["advdupe2"] = {
		["WhitelistedConstraints"] = {tableAlternatives = {["weld"] = true, ["rope"] = true, ["axis"] = true, ["ballsocket"] = true, ["elastic"] = true, ["hydraulic"] = true, ["motor"] = true, ["muscle"] = true, ["pulley"] = true, ["slider"] = true, ["winch"] = true}},
		["PreventRopes"] = {intLimit = {min = 0, max = 2}},
		["PreventScaling"] = {intLimit = {min = 0, max = 2}},
		["PreventNoGravity"] =  {intLimit = {min = 0, max = 2}},
		["PreventTrail"] =  {intLimit = {min = 0, max = 2}}
	},

	["miscs"] = {
		["ClearDecals"] = {intLimit = {min = 0, max = 1200}},
		["NoBlackoutGlitch"] = {intLimit = {min = 0, max = 3}},
		["DRPEntForceOwnership"] = {tableAlternatives = function() local tbl = {} for k,v in pairs(scripted_ents.GetList()) do tbl[v.ClassName or k] = true end return tbl end}
	}
}