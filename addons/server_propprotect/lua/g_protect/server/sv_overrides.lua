gProtect = gProtect or {}
gProtect.Overridden = gProtect.Overrides or {}

if undo and !gProtect.Overridden["undo"] then
    local oldSetPlayer, oldFinish, oldAddEntity = undo.SetPlayer, undo.Finish, undo.AddEntity
    local spawnedEnts = {}
	local undoPly
	
    function undo.AddEntity(ent, ...)
        if IsValid(ent) then spawnedEnts[ent] = true end
        oldAddEntity(ent, ...)
	end
	
    function undo.SetPlayer(ply, ...)
        undoPly = ply
        oldSetPlayer(ply, ...)
    end

    function undo.Finish(...)
		if IsValid(undoPly) then
            for k, v in pairs(spawnedEnts) do
                hook.Run("gP:UndoAdded", undoPly, k)
            end
        end
        spawnedEnts = {}
        undoPly = nil

        oldFinish(...)
    end

    gProtect.Overridden["undo"] = true
end

if cleanup and !gProtect.Overridden["cleanup"] then
    local oldCleanup = cleanup.Add
    function cleanup.Add(ply, Type, ent)
        if not IsValid(ply) or not IsValid(ent) then return oldCleanup(ply, Type, ent) end

        hook.Run("gP:CleanupAdded", ply, ent, Type)

        return oldCleanup(ply, Type, ent)
    end

    gProtect.Overridden["cleanup"] = true
end

if numpad and !gProtect.Overridden["numpad"] then
    local oldRegister = numpad.Register
    function numpad.Register( name, func )
        local result = hook.Run("gP:NumpadRegistered", name, func)

        if result and isfunction(result) then func = result end

        oldRegister(name, func)
    end

    gProtect.Overridden["numpad"] = true
end

if !gProtect.Overridden["physobj"] then
    local physobj = FindMetaTable("PhysObj")

    local oldEnableMotion = physobj.EnableMotion

    function physobj:EnableMotion(boolean)
        if !IsValid(self) then return end
        oldEnableMotion(self, boolean)

        hook.Run("MotionChanged", self, boolean)
    end

    gProtect.Overridden["physobj"] = true
end

if !gProtect.Overridden["getinfo"] then
    local meta = FindMetaTable("Player")

    local oldGetInfo = meta.GetInfo

    function meta:GetInfo(cvar)
        if cvar == "advdupe2_paste_unfreeze" and gProtect.GetConfig("PreventUnfreezeAll", "advdupe2") then return 0 end

        return oldGetInfo(self, cvar)
    end

    gProtect.Overridden["getinfo"] = true
end