
gProtect = gProtect or {}
gProtect.TouchPermission = gProtect.TouchPermission or {}
gProtect.data = gProtect.data or {}
local syncedQueue = {}

local spawnedents = {}
local disconnectedPly, disconnectSessions = {}, {}

util.AddNetworkString("gP:Networking")

local function setSpawnedEnt(ply, ent)
	local sid = ply:SteamID()
	spawnedents[sid] = spawnedents[sid] or {}
	spawnedents[sid][ent] = true
end

gProtect.SetOwner = function(ply, ent)
	local sid = ply:SteamID()

	if sid then
		ent:SetNWString("gPOwner", sid)
	end

	setSpawnedEnt(ply, ent)
end

local limitrequests = {}

gProtect.GetConfig = function(info, modul)
	local data = gProtect.data

	if !data[modul] or (info and !data[modul][info]) then data = table.Copy(gProtect.config.modules) end

	return info and data[modul][info] or data[modul]
end

local miscscfg = gProtect.GetConfig(nil,"miscs")
local generalcfg = gProtect.GetConfig(nil,"general")
local gravityguncfg = gProtect.GetConfig(nil,"gravitygunsettings")
local physguncfg = gProtect.GetConfig(nil,"physgunsettings")
local toolguncfg = gProtect.GetConfig(nil,"toolgunsettings")

gProtect.NetworkData = function(ply, moduleedited)
	local settings = gProtect.data

	if moduleedited then
		settings = settings[moduleedited]
	else
		moduleedited = ""
	end
	
	settings = util.TableToJSON(settings)
	settings = util.Compress(settings)

	if ply then
		if limitrequests[ply:SteamID()] then return end
		limitrequests[ply:SteamID()] = true

		net.Start("gP:Networking")
		net.WriteBool(false)
		net.WriteUInt(#settings, 32)
		net.WriteData(settings, #settings)
		net.WriteString(moduleedited)
		net.Send(ply)
	return end

	for k,v in pairs(player.GetAll()) do
		if !gProtect.HasPermission(v, "gProtect_Settings") then continue end

		net.Start("gP:Networking")
		net.WriteBool(false)
		net.WriteUInt(#settings, 32)
		net.WriteData(settings, #settings)
		net.WriteString(moduleedited)
		net.Send(v)
	end
end

gProtect.networkTouchPermissions = function(ply, exclusive)
	if exclusive then
		net.Start("gP:Networking")
		net.WriteBool(true)
		net.WriteString(util.TableToJSON(gProtect.TouchPermission[exclusive]))
		net.WriteString(exclusive)
		
		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	else
		for k,v in pairs(gProtect.TouchPermission) do
			gProtect.networkTouchPermissions(ply, k)
		end
	end
end

gProtect.BlacklistModel = function(list, todo, ply)
	if todo == false then todo = nil end

	local data = gProtect.data
	local count = table.Count(list)

	for mdl, v in pairs(list) do
		data["spawnrestriction"]["blockedModels"][string.lower(mdl)] = todo

		if count <= 3 then
			slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, todo and "added-blacklist" or "removed-blacklist", mdl), ply)
		end
	end

	gProtect.updateSetting("spawnrestriction", "blockedModels")

	if count > 3 then
		slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, todo and "blacklisted-multiple" or "unblacklisted-multiple", count), ply)
	end


	gProtect.NetworkData(nil, "spawnrestriction")

	hook.Run("gP:ConfigUpdated", "spawnrestriction")
end

gProtect.BlacklistEntity = function(list, todo, ply)
	if todo == false then todo = nil end

	local data = gProtect.data
	local count = table.Count(list)

	for classname, v in pairs(list) do
		data["general"]["blacklist"][string.lower(classname)] = todo

		if count <= 3 then
			slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, todo and "added-blacklist-ent" or "removed-blacklist-ent", classname), ply)
		end
	end

	gProtect.updateSetting("general", "blacklist")

	if count > 3 then
		slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, todo and "blacklisted-multiple-ent" or "unblacklisted-multiple-ent", count), ply)
	end

	gProtect.NetworkData(nil, "general")

	hook.Run("gP:ConfigUpdated", "general")
end

gProtect.ObscureDetection = function(ent, method)
	if method == 1 then
		local pos = ent:GetPos()
		
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos
		tracedata.filter = ent
		tracedata.mins = ent:OBBMins()
		tracedata.maxs = ent:OBBMaxs()
		local trace = util.TraceHull( tracedata )
		
		if trace.Entity and IsValid(trace.Entity) then
			return {trace.Entity}
		end
	end
	
	return ents.FindInBox( ent:LocalToWorld(ent:OBBMins()), ent:LocalToWorld(ent:OBBMaxs()) )
end

local notifydelay = {}

gProtect.NotifyStaff = function(ply, msg, delay)
	if !IsValid(ply) or !ply:IsPlayer() then return end

	if delay then
		if notifydelay[ply] and notifydelay[ply][msg] and CurTime() - notifydelay[ply][msg] < delay then return end
		notifydelay[ply] = notifydelay[ply] or {}
		notifydelay[ply][msg] = CurTime()
	end

	for k,v in pairs(player.GetAll()) do
		if v == ply then continue end
		if gProtect.HasPermission(v, "gProtect_StaffNotifications") then
			slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, msg, ply:Nick()), v)
		end
	end
end

hook.Add("gP:UndoAdded", "gP:handleOwnership", function(ply, ent)
	gProtect.SetOwner(ply, ent)
end)


hook.Add("BaseWars_PlayerBuyEntity", "gP:handleOwnership", function(ply, ent)
	setSpawnedEnt(ply, ent)
end)

hook.Add("BaseWars_PlayerBuyProp", "gP:handleOwnership", function(ply, ent)
	setSpawnedEnt(ply, ent)
end)

hook.Add("BaseWars_PlayerBuyGun", "gP:handleOwnership", function(ply, ent)
	setSpawnedEnt(ply, ent)
end)

hook.Add("BaseWars_PlayerBuyDrug", "gP:handleOwnership", function(ply, ent)
	setSpawnedEnt(ply, ent)
end)

hook.Add("PlayerSpawnedProp", "gP:handleSpawning", function(ply, model, ent)
	if IsValid(ent) then
		if IsValid(ply) and ply:IsPlayer() then 
			if miscscfg.enabled and miscscfg.freezeOnSpawn then 
				local physobj = ent:GetPhysicsObject()
				if IsValid(physobj) then 
					physobj:EnableMotion(false) 
				end 
			end 
		end

		if generalcfg.maxModelSize > 0 then
			local vec1, vec2 = ent:GetModelBounds()

			local size = vec1:Distance(vec2)
			local scale = ent:GetModelScale()

			size = size * (isnumber(scale) and scale or 1)

			if size > generalcfg.maxModelSize then 
				ent:Remove()
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "too-big-prop"), ply)
			end
		end

		local obstructed = gProtect.HandleMaxObstructs(ent, ply)

		if !obstructed then
			gProtect.GhostHandler(ent)
		end
	end
end)

hook.Add("CanTool", "gP:CanToolHandeler", function(ply, tr, tool)
	local miscresult = gProtect.HandleMiscToolGun(ply, tr, tool)
	local advdupe2result = gProtect.HandleAdvDupe2ToolGun(ply, tr, tool)
	local toolgunsettingsresult = gProtect.HandleToolgunPermissions(ply, tr, tool)
	if miscresult == false or advdupe2result == false then return false end
	if tr.Entity.sppghosted and tool ~= "remover" then return false end

	if toolgunsettingsresult == false then return false end
	local finalresult = toolgunsettingsresult ~= nil and (toolgunsettingsresult or gProtect.HandlePermissions(ply, tr.Entity, "gmod_tool")) or nil

	if finalresult then
		hook.Run("OnTool", ply, tr, tool)
	end
	
	return finalresult
end)

hook.Add("PlayerSpawnProp", "gP:CanSpawnPropLogic2", function(ply, model)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "propSpawnPermission")
	
	if spawnpermissionresult == false then return false end
end)

hook.Add("PlayerSpawnSENT", "gP:CanSpawnSENTSLogic", function(ply, class)
	local spawnsentresult = gProtect.HandleSENTSpawnPermission(ply, class)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, nil, "SENTSpawnPermission")

	if spawnpermissionresult == false or spawnsentresult == false then return false end
end)

hook.Add("PlayerSpawnSWEP", "gP:CanSpawnSWEPLogic", function(ply, weapon, swep)
	local model = swep.WorldModel
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "SWEPSpawnPermission")

	if spawnpermissionresult == false then return false end
end)

hook.Add("PlayerGiveSWEP", "gP:CanGiveSWEPLogic", function(ply, weapon, swep)
	local model = swep.WorldModel
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "SWEPSpawnPermission")

	if isbool(spawnpermissionresult)  then return spawnpermissionresult end
end)


hook.Add("PlayerSpawnVehicle", "gP:CanSpawnVehicleLogic", function(ply, model)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "vehicleSpawnPermission")

	if spawnpermissionresult == false then return false end
end)

hook.Add("PlayerSpawnNPC", "gP:CanSpawnNPCLogic", function(ply)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, nil, "NPCSpawnPermission")

	if spawnpermissionresult == false then return false end
end)

hook.Add("PlayerSpawnRagdoll", "gP:CanSpawnRagdollLogic", function(ply, model)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "ragdollSpawnPermission")

	if spawnpermissionresult == false then return false end
end)

hook.Add("PlayerSpawnEffect", "gP:CanSpawnEffectLogic", function(ply, model)
	local spawnpermissionresult = gProtect.HandleSpawnPermission(ply, model, "effectSpawnPermission")

	if spawnpermissionresult == false then return false end
end)

hook.Add("MotionChanged", "gP:HandleDroppedEntities", function(phys, enabledmotion)
	if !IsValid(phys) then return end
	local ent = phys:GetEntity()
	if IsValid(ent) then
		if !ent.gPOldCollisionGroup then
			if generalcfg.protectedFrozenEnts[ent:GetClass()] and !enabledmotion and !ent.BeingPhysgunned and !ent.sppghosted and ent:GetCollisionGroup() == COLLISION_GROUP_NONE then
				ent.gPOldCollisionGroup = ent:GetCollisionGroup()
				ent:SetCollisionGroup(generalcfg.protectedFrozenGroup)
			end
		elseif enabledmotion then
			ent:SetCollisionGroup(ent.gPOldCollisionGroup)
			ent.gPOldCollisionGroup = nil
		end

	end
end)

hook.Add("OnTool", "gP:HandleChangedCollision", function(ply, tr, tool)
	local ent = ply:GetEyeTrace().Entity

	if IsValid(ent) and tool == "nocollide" and generalcfg.protectedFrozenEnts[ent:GetClass()] and ent.gPOldCollisionGroup then
		timer.Simple(.1, function()
			ent.gPOldCollisionGroup = ent:GetCollisionGroup()
		end)
	end
end)

hook.Add("OnProperty", "gP:HandleChangedCollisionProperty", function(ply, property, ent)
	if IsValid(ent) and property == "collision" and generalcfg.protectedFrozenEnts[ent:GetClass()] and ent.gPOldCollisionGroup then
		timer.Simple(.1, function()
			ent.gPOldCollisionGroup = ent:GetCollisionGroup()
		end)
	end
end)

hook.Add("PhysgunDrop", "gP:HandlePhysgunDropping", function(ply, ent)
	local obstructed = gProtect.HandleMaxObstructs(ent, ply)
	gProtect.PhysgunSettingsOnDrop(ply, ent, obstructed)
	
	hook.Run("PhysgunDropped", ply, ent, obstructed)
end)

hook.Add("OnPhysgunPickup", "gP:HandlePickups", function(ply, ent)
    if IsValid(ent) then
        ent.BeingPhysgunned = ent.BeingPhysgunned or {}
        ent.BeingPhysgunned[ply] = true
    end
end)

hook.Add("GravGunPunt", "gP:GravGunPuntingLogic", function(ply, ent)
	if gravityguncfg.enabled and gravityguncfg.DisableGravityGunPunting then return false end
end)


hook.Add("GravGunPickupAllowed", "gP:HandleGravgunPickup", function(ply, ent, norun)
	if TCF and TCF.Config and ent:GetClass() == "cocaine_cooking_pot" and IsValid(ent:GetParent()) or !gravityguncfg.enabled then return nil end

	if isbool(gProtect.HandleGravitygunPermission(ply, ent)) then return gProtect.HandleGravitygunPermission(ply, ent) end

	return gProtect.HandlePermissions(ply, ent, "weapon_physcannon")
end)

hook.Add("CanProperty", "gP:HandleCanProperty", function(ply, property, ent)
	if IsValid(ent) and ent.sppghosted and property ~= "remover" then return false end
	local result = gProtect.CanPropertyPermission(ply, property, ent)

	if !isbool(result) then result = gProtect.HandlePermissions(ply, ent, "canProperty") end

	if result then
		hook.Run("OnProperty", ply, property, ent)

		timer.Simple(0, function() gProtect.GhostHandler(ent) end)
	end

    return result
end)

hook.Add("playerBoughtCustomEntity", "gP:DarkRPEntitesHandler", function(ply, enttbl, ent, price)
	if IsValid(ply) then 
		local sid = ply:SteamID()

		spawnedents[sid] = spawnedents[sid] or {}
		spawnedents[sid][ent] = true

		if IsValid(ent) and isfunction(ent.Setowning_ent) then
			ent:Setowning_ent(ply)
		end
	end
end)

hook.Add("PlayerSpawnedSENT", "gP:HandleSpawningEntities", function(ply, ent)
	if IsValid(ent) and isfunction(ent.Setowning_ent) and IsValid(ply) then
		ent:Setowning_ent(ply)
	end
end)

hook.Add("onPocketItemDropped", "gP:HandlePocketDropping", function(ply, ent, item, id)
	if !ply or !ply.darkRPPocket or !ply.darkRPPocket[item] or !ply.darkRPPocket[item].DT then return end

	for k,v in pairs(ply.darkRPPocket[item].DT) do
        if k == "owning_ent" and IsValid(v) and v:IsPlayer() then
			gProtect.SetOwner(v, ent)
			
			if isfunction(ent.Setowning_ent) then
				ent:Setowning_ent(v)
			end
        end
    end
end)


hook.Add( "PlayerSay", "gP:OpenMenu", function( ply, text, public )
	if (( string.lower( text ) == "!gprotect" )) then
		if !gProtect.HasPermission(ply, "gProtect_Settings") and !gProtect.HasPermission(ply, "gProtect_DashboardAccess") then
			return text
		end

		if !limitrequests[ply:SteamID()] then gProtect.NetworkData(ply) end
		
		ply:ConCommand("gprotect_settings")

		return ""
	end
end )

hook.Add("gP:ConfigUpdated", "gP:UpdateCoreConfig", function(updated)
	if !updated or updated == "miscs" or updated == "general" or updated == "gravitygunsettings" or updated == "physgunsettings" or updated == "toolgunsettings" then
		miscscfg = gProtect.GetConfig(nil,"miscs")
		generalcfg = gProtect.GetConfig(nil,"general")
		gravityguncfg = gProtect.GetConfig(nil,"gravitygunsettings")
		physguncfg = gProtect.GetConfig(nil,"physgunsettings")
		toolguncfg = gProtect.GetConfig(nil,"toolgunsettings")
	end
end)

hook.Add("PlayerInitialSpawn", "gP:FirstJoiner", function(ply)
	local sid = ply:SteamID()
	disconnectSessions[sid] = disconnectSessions[sid] or 0
	disconnectSessions[sid] = disconnectSessions[sid] + 1

	if sid and timer.Exists("gP:RemoveDisconnectedEnts_"..sid) then timer.Remove("gP:RemoveDisconnectedEnts_"..sid) end
end)

local function deleteDisconnectedEntities(sid, force)
	if sid then
		if !spawnedents[sid] then return end
		for k,v in pairs(spawnedents[sid]) do
			if !IsValid(k) then continue end
			local class = k:GetClass()
			if gProtect.GetOwner(k) or (generalcfg.remDiscPlyEntSpecific[class] and !force) then continue end
			k:Remove()

			spawnedents[k] = nil
		end
		
		disconnectedPly[sid] = nil
	else
		if !disconnectedPly then return end
		for k, v in pairs(disconnectedPly) do
			if !spawnedents[k] then continue end
			for i, z in pairs(spawnedents[k]) do
				if !IsValid(i) then continue end
				local class = i:GetClass()
				if generalcfg.remDiscPlyEntSpecific[class] then continue end
				i:Remove()

				spawnedents[i] = nil
			end

			disconnectedPly[k] = nil
		end
	end
end

hook.Add("PlayerDisconnected", "gP:HandleDisconnects", function(ply)
	local sid = ply:SteamID()
	limitrequests[sid] = nil

	local session = disconnectSessions[sid]

	disconnectedPly[sid] = true
	if !spawnedents[sid] then return end
	for k,v in pairs(spawnedents[sid]) do
		if IsValid(k) then
			local time = tonumber(generalcfg.remDiscPlyEntSpecific[k:GetClass()])

			if time and time >= 0 then
				timer.Simple(time, function()
					if session ~= disconnectSessions[sid] then return end
					if IsValid(k) then k:Remove() end
				end)
			end
		end
	end
	
	if (tonumber(generalcfg.remDiscPlyEnt) or 0) < 0 then return end

	timer.Create("gP:RemoveDisconnectedEnts_"..sid, generalcfg.remDiscPlyEnt, 1, function()
		deleteDisconnectedEntities(sid)
	end)
end)

concommand.Add("gprotect_transfer_fpp_blockedmodels", function( ply, cmd, args )
	if IsValid(ply) and !gProtect.HasPermission(ply, "gProtect_Settings") then return end
	local data = gProtect.data

	if args[1] == "1" then
		for k,v in pairs(FPP.BlockedModels) do
			data["spawnrestriction"]["blockedModels"][string.lower(k)] = true
		end
	else
		local fppblockedmodels = sql.Query("SELECT * FROM FPP_BLOCKEDMODELS1;")
	
		if !istable(fppblockedmodels) then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "unsuccessfull-transfer"), ply) return end
	
		for k,v in pairs(fppblockedmodels) do
			data["spawnrestriction"]["blockedModels"][string.lower(v.model)] = true
		end
	end

	gProtect.updateSetting("spawnrestriction", "blockedModels")

	gProtect.NetworkData(nil, "spawnrestriction")
	slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "successfull-fpp-blockedmodels"), ply)
end)

concommand.Add("gprotect_transfer_fpp_grouptools", function( ply, cmd, args )
	if IsValid(ply) and !gProtect.HasPermission(ply, "gProtect_Settings") then return end
	local grouptools = sql.Query("SELECT * FROM FPP_GROUPTOOL;")

	local data = gProtect.data

	if !istable(grouptools) then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "unsuccessfull-transfer"), ply) return end

	for k,v in pairs(grouptools) do
		if !v.groupname or !v.tool then continue end
		data["toolgunsettings"]["groupToolRestrictions"][v.groupname] = data["toolgunsettings"]["groupToolRestrictions"][v.groupname] or {list = {}, isBlacklist = true}
		data["toolgunsettings"]["groupToolRestrictions"][v.groupname]["list"] = data["toolgunsettings"]["groupToolRestrictions"][v.groupname]["list"] or {}
		if data["toolgunsettings"]["groupToolRestrictions"][v.groupname].isBlacklist == nil then data["toolgunsettings"]["groupToolRestrictions"][v.groupname].isBlacklist = true end

		data["toolgunsettings"]["groupToolRestrictions"][v.groupname]["list"][v.tool] = true
	end

	gProtect.updateSetting("toolgunsettings", "groupToolRestrictions")

	gProtect.NetworkData(nil, "toolgunsettings")
	slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "successfull-fpp-grouptools"), ply)
end)

net.Receive("gP:Networking", function(_, ply)
	local perm_config, perm_dashboard = gProtect.HasPermission(ply, "gProtect_Settings"), gProtect.HasPermission(ply, "gProtect_DashboardAccess")
	if !perm_config and !perm_dashboard then return end
	local action = net.ReadUInt(2)

	if !perm_config and action ~= 1 then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "insufficient-permission"), ply) return end

	if action == 1 then
		local mode = net.ReadUInt(2)
		local todo = net.ReadUInt(3)
		if mode == 1 then
			local victim = net.ReadEntity()
			if !IsValid(victim) or !victim:IsPlayer() then return end

			spawnedents[victim:SteamID()] = spawnedents[victim:SteamID()] or {}

			if todo == 1 then
				if !spawnedents[victim:SteamID()] then return end
				for k,v in pairs(spawnedents[victim:SteamID()]) do
					if !IsValid(k) or !string.find(k:GetClass(), "prop") then continue end
					local physob = k:GetPhysicsObject()
					if IsValid(physob) then
						physob:EnableMotion(false)
					end
				end

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "you-frozen-props", victim:Nick()), ply)
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "props-frozen"), victim)

			elseif todo == 2 then
				for k,v in pairs(spawnedents[victim:SteamID()]) do
					if !IsValid(k) or !string.find(k:GetClass(), "prop") then continue end
					k:Remove()
				end
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "you-removed-props", victim:Nick()), ply)
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "props-removed"), victim)
			elseif todo == 3 then
				for k,v in pairs(spawnedents[victim:SteamID()]) do
					if !IsValid(k) or !string.find(k:GetClass(), "prop") then continue end
					gProtect.GhostHandler(k, true, nil, nil, true)
				end

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "you-ghosted-props", victim:Nick()), ply)
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "props-ghosted"), victim)
			elseif todo == 4 then
				for k,v in pairs(spawnedents[victim:SteamID()]) do
					if !IsValid(k) then continue end
					k:Remove()
				end

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "you-removed-ents", victim:Nick()), ply)
				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "ents-removed"), victim)
			end
		elseif mode == 2 then
			if todo == 1 then
				for k, v in pairs(player.GetAll()) do
					if !IsValid(v) or !spawnedents[v:SteamID()] then continue end
					for i, z in pairs(spawnedents[v:SteamID()]) do
						if !IsValid(i) or !string.find(i:GetClass(), "prop") then continue end
						gProtect.GhostHandler(i, true, nil, nil, true)
					end
				end

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "everyones-props-ghosted"))
			elseif todo == 2 then
				for k, v in pairs(player.GetAll()) do
					if !IsValid(v) or !spawnedents[v:SteamID()] then continue end
					for i, z in pairs(spawnedents[v:SteamID()]) do
						if !IsValid(i) or !string.find(i:GetClass(), "prop") then continue end
						local physob = i:GetPhysicsObject()
						if IsValid(physob) then
							physob:EnableMotion(false)
						end
					end
				end

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "everyones-props-frozen"))
			elseif todo == 3 then
				deleteDisconnectedEntities(nil, true)

				slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "disconnected-ents-removed"), ply)
			end
		end
	elseif action == 2 then
		local mode = net.ReadUInt(2)
		local list = net.ReadString()
		local todo = net.ReadBool()

		if !list then return end
		
		list = util.JSONToTable(list)

		local count = #list

		if mode == 1 then
			gProtect.BlacklistModel(list, todo, ply)
		elseif mode == 2 then
			gProtect.BlacklistEntity(list, todo, ply)
		end
	elseif action == 3 then
		local module = net.ReadString()
		local variable = net.ReadString()
		
		if !module or !variable then return end

		local statement = slib.getStatement(gProtect.config.modules[module][variable])

		local value

		if statement == "string" then
			value = net.ReadString()
		elseif statement == "bool" then
			value = net.ReadBool()
		elseif statement == "int" then
			value = net.ReadInt(18)
		elseif statement == "table" or statement == "color" then
			local len = net.ReadUInt(32)
			value = net.ReadData(len)
			value = util.JSONToTable(util.Decompress(value))
		end
		
		gProtect.data[module][variable] = value

		gProtect.updateSetting(module, variable)
		gProtect.NetworkData(nil, module)

		hook.Run("gP:ConfigUpdated", module, variable, value)
	end
end)

local function verifyData()
	local data = gProtect.data
	local modified = {}

	for k, v in pairs(gProtect.config.modules) do
		if data[k] == nil then
			data[k] = v
			modified[k] = true
			continue
		end
		
		if istable(v) then
			for i, z in pairs(v) do
				if data[k][i] == nil or slib.getStatement(data[k][i]) ~= slib.getStatement(z) then
					data[k][i] = z
					modified[k] = true
				end
			end
		end
	end

	for k, v in pairs(data) do
		if gProtect.config.modules[k] == nil then
			data[k] = nil
		end
		
		if istable(v) then
			for i, z in pairs(v) do
				if gProtect.config.modules[k][i] == nil then
					data[k][i] = nil
				end
			end
		end
	end

	for k, v in pairs(modified) do
		gProtect.updateSetting(k)
		
		hook.Run("gP:ConfigUpdated", k)
	end

	local toolgun = {toolguncfg.targetWorld, toolguncfg.targetPlayerOwned}
	local physgun = {physguncfg.targetWorld, physguncfg.targetPlayerOwned}
	local gravitygun = {gravityguncfg.targetWorld, gravityguncfg.targetPlayerOwned}

	gProtect.TouchPermission["targetWorld"] = gProtect.TouchPermission["targetWorld"] or {}
	gProtect.TouchPermission["targetWorld"]["gmod_tool"] = toolgun[1]
	gProtect.TouchPermission["targetWorld"]["weapon_physgun"] = physgun[1]
	gProtect.TouchPermission["targetWorld"]["weapon_physcannon"] = gravitygun[1]

	gProtect.TouchPermission["targetPlayerOwned"] = gProtect.TouchPermission["targetPlayerOwned"] or {}
	gProtect.TouchPermission["targetPlayerOwned"]["gmod_tool"] = toolgun[2]
	gProtect.TouchPermission["targetPlayerOwned"]["weapon_physgun"] = physgun[2]
	gProtect.TouchPermission["targetPlayerOwned"]["weapon_physcannon"] = gravitygun[2]
end

hook.Add("gP:ConfigUpdated", "gP:RegisterTouchPermissions", function(module, variable, value)
	if variable == "targetWorld" or variable == "targetPlayerOwned" then
		local type

		if module == "toolgunsettings" then
			type = "gmod_tool"
		elseif module == "physgunsettings" then
			type = "weapon_physgun"
		elseif module == "gravitygunsettings" then
			type = "weapon_physcannon"
		end

		if type then
			gProtect.TouchPermission[variable] = gProtect.TouchPermission[variable] or {}
			gProtect.TouchPermission[variable][type] = value

			gProtect.networkTouchPermissions(nil, variable)
		end
	end
end)

hook.Add("gP:SQLConnected", "gP:SyncData", function()
	gProtect.syncConfig()
end)

hook.Add("gP:SQLSynced", "gP:TransferOldData", function()
	gProtect.transferOldSettings()

	verifyData()
end)

function constraint.NoCollide() end