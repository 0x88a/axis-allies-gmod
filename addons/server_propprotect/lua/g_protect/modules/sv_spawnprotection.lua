local cfg = gProtect.GetConfig(nil, "spawnrestriction")

gProtect = gProtect or {}

gProtect.HandleSpawnPermission = function(ply, model, type)
    if cfg.enabled then
        local handle = cfg[type]
        local blockedmodels = cfg.blockedModels
        local bypassgroups = cfg.bypassGroups
        local isBlacklist = cfg.blockedModelsisBlacklist
        
        if model then
            model = string.lower(model)

            local result = blockedmodels[model] or false

            if !bypassgroups[ply:GetUserGroup()] and (isBlacklist == result) then
                slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "model-restricted"), ply)
                return false
            end
        end

        if handle[ply:GetUserGroup()] then
            return true
        elseif handle["*"] then
            return true
        else
            slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "insufficient-permission"), ply)
            return false
        end
    end
end

gProtect.HandleSENTSpawnPermission = function(ply, class)
    if cfg.enabled then
        local group = ply:GetUserGroup()
        local blockedclasses = cfg.blockedSENTs
        local bypassgroups = cfg.bypassGroups
        local result = blockedclasses[class] and blockedclasses[class] or false

        if !bypassgroups[group] and (cfg.blockedEntityIsBlacklist == result) then
            slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "classname-restricted"), ply)
            return false
        end
    end
end


hook.Add("gP:ConfigUpdated", "gP:UpdateSpawnProtection", function(updated)
    if updated ~= "spawnrestriction" then return end
	cfg = gProtect.GetConfig(nil,"spawnrestriction")
end)