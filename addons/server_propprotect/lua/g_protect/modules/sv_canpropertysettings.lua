local cfg = gProtect.GetConfig(nil,"canpropertysettings")

gProtect = gProtect or {}

gProtect.CanPropertyPermission = function(ply, property, ent)
    if cfg.enabled then
        local owner = gProtect.GetOwner(ent)

        if !owner then
            local result = ent:GetNWString("gPOwner", "")
            owner = (string.find(result, "STEAM") and "Disconnected") or "World"
        end

        local usergroup = ply:GetUserGroup()

        if IsValid(ent) and ent:IsPlayer() then return nil end

        if !cfg.bypassGroups[usergroup] and ((tobool(cfg.blockedProperties[property]) == cfg.blockedPropertiesisBlacklist) or cfg.blockedEntities[ent:GetClass()]) then return false end
        
        if owner == "World" then
            if cfg.targetWorld["*"] or cfg.targetWorld[usergroup] then return true end
        end

        if !isstring(owner) and IsValid(owner) and owner:IsPlayer() then
            if cfg.targetPlayerOwned["*"] or cfg.targetPlayerOwned[usergroup] or ply == owner then return true end
        end
    end

    return nil
end

hook.Add("gP:ConfigUpdated", "gP:UpdateCanPropertySettings", function(updated)
	if updated ~= "canpropertysettings" then return end
	cfg = gProtect.GetConfig(nil,"canpropertysettings")
end)