
gProtect = gProtect or {}
gProtect.overrides = gProtect.overrides or {}


local function overrideCPPI()
    if gProtect.overrides["CPPI"] then return end
    gProtect.overrides["CPPI"] = true
    
    local meta = FindMetaTable("Entity")

    meta.oldCPPIGetOwner = meta.CPPIGetOwner
    function meta:CPPIGetOwner()
        local result = gProtect.GetOwner(self)
        
        if isstring(result) and isfunction(meta.oldCPPIGetOwner) then result = self:oldCPPIGetOwner() end

        return (isstring(result) and nil or result), 200
    end


    if SERVER then
        meta.oldCPPISetOwner = meta.CPPISetOwner
        function meta:CPPISetOwner(ply)
            if isfunction(meta.oldCPPISetOwner) then
                self:oldCPPISetOwner(ply)
            end

            if !IsValid(ply) then return end
            gProtect.SetOwner(ply, self)
        end

        function meta:CPPICanTool(ply, tool)            
            return gProtect.HandlePermissions(ply, self, "gmod_tool")
        end
    
        function meta:CPPICanPhysgun(ply)
            return gProtect.HandlePermissions(ply, self, "weapon_physgun")
        end
    
        function meta:CPPICanPickup(ply)
            return gProtect.HandlePermissions(ply, self, "weapon_physcannon")
        end
    
        function meta:CPPICanPunt(ply)
            return !gProtect.GetConfig("DisableGravityGunPunting", "gravitygunsettings")
        end
    end
end

timer.Simple(3, function()
    overrideCPPI()
end)