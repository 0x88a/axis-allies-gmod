local cfg = gProtect.GetConfig(nil, "physgunsettings")
local blacklist = gProtect.GetConfig("blacklist","general")

gProtect = gProtect or {}

gProtect.HandlePhysgunPermission = function(ply, ent)
    if IsValid(ent) and cfg.blockMultiplePhysgunning and ent.BeingPhysgunned and !table.IsEmpty(ent.BeingPhysgunned) then return false end

    if cfg.enabled then
        local owner = gProtect.GetOwner(ent)

        if !owner then
            local result = ent:GetNWString("gPOwner", "")
            owner = (string.find(result, "STEAM") and "Disconnected") or "World"
        end
        
        local usergroup = ply:GetUserGroup()

        if IsValid(ent) and ent:IsPlayer() then return nil end
        
        if !cfg.PickupVehiclePermission[usergroup] and !cfg.PickupVehiclePermission["*"] then
            if ent:IsVehicle() then return false end
        end

        if cfg.blockedEntities[ent:GetClass()] and !cfg.bypassGroups[ply:GetUserGroup()] and !cfg.bypassGroups["*"] then return false end

        if owner == "World" then
            if cfg.targetWorld["*"] or cfg.targetWorld[usergroup] then return true end
        end
        
        if !isstring(owner) and IsValid(owner) and owner:IsPlayer() or owner == "Disconnected" then
            if cfg.targetPlayerOwned["*"] or cfg.targetPlayerOwned[usergroup] or ply == owner then return true end
        end
    end
end

gProtect.HandleMaxObstructs = function(ent, ply)
    if IsValid(ent) and blacklist[ent:GetClass()] and cfg.enabled and (cfg.maxDropObstructs > 0) then
        local physobj = ent:GetPhysicsObject()

        if IsValid(physobj) then
            if !physobj:IsMotionEnabled() then return false end
        end

		local obscuring = gProtect.ObscureDetection(ent)
		if obscuring then
			local count = -1

			for k,v in pairs(obscuring) do
				if blacklist[v:GetClass()] then
					count = count + 1
				end
			end

            if count >= cfg.maxDropObstructs then
                local result = true

				if IsValid(physobj) then
					physobj:EnableMotion(false)
				end
                
				if cfg.maxDropObstructsAction == 1 then
                    gProtect.GhostHandler(ent, true)
				elseif cfg.maxDropObstructsAction == 2 then
					if IsValid(physobj) then
						physobj:EnableMotion(false)
                    end
                    
                    result = false
				elseif cfg.maxDropObstructsAction == 3 then
                    ent:Remove()
                end

                gProtect.NotifyStaff(ply, "too-many-obstructs", 3)

                return result
			end
		end
    end    
end

gProtect.PhysgunSettingsOnDrop = function(ply, ent, obstructed)
    if cfg.enabled and cfg.StopMotionOnDrop and !obstructed then
        timer.Simple(.01, function()
            if !IsValid(ent) then return end
            local physobj = ent:GetPhysicsObject()
            if IsValid(physobj) then
                if physobj:IsMotionEnabled() then
                    physobj:EnableMotion(false)
                    physobj:EnableMotion(true)
                end
            end
        end)
    end
    
    if IsValid(ent) then
        ent.BeingPhysgunned = ent.BeingPhysgunned or {}
        ent.BeingPhysgunned[ply] = nil
    end
end

hook.Add( "CanPlayerUnfreeze", "gP:PreventUnfreezeAll", function(ply, ent)
	if cfg.enabled and cfg.DisableReloadUnfreeze then
		return false
    end
    
    return gProtect.HandlePermissions(ply, ent, "weapon_physgun")
end )

hook.Add("gP:ConfigUpdated", "gP:UpdatePhysgunSettings", function(updated)
    if updated ~= "physgunsettings" and updated ~= "general" then return end
    cfg = gProtect.GetConfig(nil,"physgunsettings")
    blacklist = gProtect.GetConfig("blacklist","general")
end)