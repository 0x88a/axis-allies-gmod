local cfg = gProtect.GetConfig(nil,"toolgunsettings")

gProtect = gProtect or {}

local spamProtection = {}

gProtect.HandleToolgunPermissions = function(ply, tr, tool)
    if cfg.enabled then
        local ent = tr.Entity
        local owner = gProtect.GetOwner(ent)

        if !owner then
            local result = ent:GetNWString("gPOwner", "")
            owner = (string.find(result, "STEAM") and "Disconnected") or "World"
        end
        
        local usergroup = ply:GetUserGroup()
        local secondary_usergroup = ply.GetSecondaryUserGroup and ply:GetSecondaryUserGroup()
        local team = ply:Team()
        local team_name = RPExtraTeams and RPExtraTeams[team] and RPExtraTeams[team].name

        local limit = tonumber(cfg.antiSpam[tool]) or 0
        if limit > 0 then
            spamProtection[ply] = spamProtection[ply] or {}
            spamProtection[ply][tool] = spamProtection[ply][tool] or {}
            if !spamProtection[ply][tool].timer or CurTime() >= (spamProtection[ply][tool].timer or 0) then
                spamProtection[ply][tool].timer = CurTime() + 1
                spamProtection[ply][tool].count = 0
            end

            spamProtection[ply][tool].count = spamProtection[ply][tool].count or {}
            if spamProtection[ply][tool].count >= limit then
                if IsValid(ply) then
                    slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "ratelimited_toolgun"), ply)
                end
            return false end
            spamProtection[ply][tool].count = spamProtection[ply][tool].count + 1
        end

        if !cfg.groupToolRestrictions[usergroup] and !cfg.bypassGroups[usergroup] and cfg.groupToolRestrictions["default"] then usergroup = "default" end

        if cfg.entityTargetability and cfg.entityTargetability["list"] and !cfg.bypassGroups[usergroup] and IsValid(ent) and !cfg.bypassTargetabilityTools[tool] then
            if cfg.entityTargetability["isBlacklist"] == tobool(cfg.entityTargetability["list"][ent:GetClass()]) then return false end
        end
        
        if cfg.groupToolRestrictions[usergroup] and cfg.groupToolRestrictions[usergroup]["list"] then
            if cfg.groupToolRestrictions[usergroup]["isBlacklist"] == tobool(cfg.groupToolRestrictions[usergroup]["list"][tool]) then return false end
        end

        if cfg.groupToolRestrictions[team_name] and cfg.groupToolRestrictions[team_name]["list"] then
            if cfg.groupToolRestrictions[team_name]["isBlacklist"] == tobool(cfg.groupToolRestrictions[team_name]["list"][tool]) then return false end
        end

        if cfg.groupToolRestrictions[secondary_usergroup] and cfg.groupToolRestrictions[secondary_usergroup]["list"] then
            if cfg.groupToolRestrictions[secondary_usergroup]["isBlacklist"] == tobool(cfg.groupToolRestrictions[secondary_usergroup]["list"][tool]) then return false end
        end

        if cfg.restrictTools[tool] and !cfg.bypassGroups[usergroup] then
            return false
        end

        if !isstring(owner) and IsValid(owner) and owner:IsPlayer() or owner == "Disconnected" then
            if cfg.targetPlayerOwned["*"] or cfg.targetPlayerOwned[usergroup] then return true end
        end
       
        if ent:IsWorld() then
            return nil
        end

        if owner == "World" then
            if cfg.targetWorld["*"] or cfg.targetWorld[usergroup] then return true end

            return false
        end
    end
end

hook.Add("gP:ConfigUpdated", "gP:UpdateToolgunSettings", function(updated)
    if updated ~= "toolgunsettings" then return end
	cfg = gProtect.GetConfig(nil,"toolgunsettings")
end)