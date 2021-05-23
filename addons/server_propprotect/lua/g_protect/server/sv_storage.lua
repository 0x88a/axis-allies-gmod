local query, db
local escape_str = function(str) return SQLStr(str, true) end

local create_queries = {
    [1] = [[CREATE TABLE IF NOT EXISTS gprotect_config(
        id INTEGER PRIMARY KEY %s,
        module VARCHAR(32),
        setting VARCHAR(32),
        value VARCHAR(8)
    )]],
    [2] = [[CREATE TABLE IF NOT EXISTS gprotect_tbl(
        id INTEGER PRIMARY KEY %s,
        module VARCHAR(32),
        setting VARCHAR(32),
        kval TEXT,
        value TEXT
    )]]
}

local function makeTables()
    for i = 1, #create_queries do
        query(string.format(create_queries[i], gProtect.config.StorageType == "sql_local" and "AUTOINCREMENT" or "AUTO_INCREMENT"))
    end
end

if gProtect.config.StorageType == "mysql" then
    require( "mysqloo" )

    query = function() end

    local dbinfo = gProtect.config["mysql_info"]

    db = mysqloo.connect(dbinfo.host, dbinfo.username, dbinfo.password, dbinfo.database, dbinfo.port)

    function db:onConnected()
        print(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "mysql_successfull"))

        query = function(str, func)
            local q = db:query(str)
            q.onSuccess = function(_, data)
                if func then
                    func(data)
                end
            end

            q.onError = function(_, err) end

            q:start()
        end

        escape_str = function(str) return db:escape(str) end
        
        makeTables()

        query([[INSERT INTO gprotect_tbl(id, module, setting, kval, value)
        SELECT id, module, setting, kval, value
        FROM gprotect_tables; DROP TABLE gprotect_tables]])

        hook.Run("gP:SQLConnected")
    end

    function db:onConnectionFailed(err)
        print(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "mysql_failed"))
        print( "Error:", err )
    end

    db:connect()
else
    local oldFunc = sql.Query
    query = function(str, func)
        local result = oldFunc(str)

        if func then
            func(result)
        end
    end

    makeTables()
end

gProtect.transferOldSettings = function()
    local modified = false

	local data = file.Read("gprotect/settings.txt", "DATA")
	if data then
		data = util.JSONToTable(data)
		gProtect.data = data

		file.Delete("gprotect/settings.txt")

        modified = true
	end

    local files = file.Find("gprotect/data/*", "DATA")
	if files and #files > 0 then
		for k,v in ipairs(files) do
            local data = file.Read("gprotect/data/"..v, "DATA")

            if data then
                data = util.JSONToTable(data)
                gProtect.data[string.gsub(v, ".json", "")] = data
        
                file.Delete("gprotect/data/"..v)
        
                modified = true
            end
        end
	end

    query("SELECT * FROM gProtect_data", function(result)
        if !result or table.IsEmpty(result) then return end
        for k,v in ipairs(result) do
            if !v.id or !v.data then continue end
            gProtect.data[v.id] = util.JSONToTable(v.data)
        end

        modified = true
        
        query("DROP TABLE gProtect_data")
    end)

    if modified then
        for k,v in pairs(gProtect.data) do
            gProtect.updateSetting(k)
            hook.Run("gP:ConfigUpdated", k)
        end
    end
end

gProtect.updateSetting = function(module, setting)
    if !module then
        for k,v in pairs(gProtect.data) do
            gProtect.updateSetting(k)
        end
    return end

    if !setting then
        if !gProtect.data[module] then return end
        for k,v in pairs(gProtect.data[module]) do
            gProtect.updateSetting(module, k)
        end
    return end

    local value = gProtect.data[module][setting]

    if istable(value) then
        query(string.format("DELETE FROM gprotect_tbl WHERE module = '%s' AND setting = '%s'", module, setting))

        for k,v in pairs(value) do
            query(string.format("INSERT INTO gprotect_tbl(module, setting, kval, value) VALUES('%s', '%s', '%s', '%s')", module, setting, k, util.TableToJSON(v) or v))
        end
    else
        query(string.format("DELETE FROM gprotect_config WHERE module = '%s' AND setting = '%s';INSERT INTO gprotect_config(module, setting, value) VALUES('%s', '%s', '%s')", module, setting, module, setting, value))
    end
end

local checkLoaded = function(count, modifiedModules)
    if count < 2 then return end

    for k,v in pairs(gProtect.config.modules) do
        for i, z in pairs(v) do
            if gProtect.data[k][i] == nil then
                gProtect.data[k][i] = istable(z) and {} or z
                modifiedModules[k] = true
            end
        end
    end

    for k,v in pairs(modifiedModules) do
        hook.Run("gP:ConfigUpdated", k)
    end


    hook.Run("gP:SQLSynced")
end

local function transformType(val)
    if val == "false" or val == "true" then
        return val == "true" and true or false
    end

    if tonumber(val) then return tonumber(val) end

    return val
end

gProtect.syncConfig = function()
    local modifiedModules, count = {}, 0
    query("SELECT * FROM gprotect_config", function(result)
        if result and result[1] then
            for k,v in ipairs(result) do
                gProtect.data[v.module] = gProtect.data[v.module] or {}
                gProtect.data[v.module][v.setting] = transformType(v.value)

                modifiedModules[v.module] = true
            end
        else
            gProtect.data = table.Copy(gProtect.config.modules)

            gProtect.updateSetting()
        end

        count = count + 1

        checkLoaded(count, modifiedModules)
    end)

    query("SELECT * FROM gprotect_tbl", function(result)
        if result then
            for k,v in ipairs(result) do
                gProtect.data[v.module] = gProtect.data[v.module] or {}
                gProtect.data[v.module][v.setting] = gProtect.data[v.module][v.setting] or {}

                gProtect.data[v.module][v.setting][v.kval] = util.JSONToTable(v.value) or transformType(v.value)

                modifiedModules[v.module] = true
            end
        end

        count = count + 1
        
        checkLoaded(count, modifiedModules)
    end)
end

if gProtect.config.StorageType == "sql_local" then
    query([[INSERT INTO gprotect_tbl(id, module, setting, kval, value)
    SELECT id, module, setting, kval, value
    FROM gprotect_tables; DROP TABLE gprotect_tables]])

    hook.Run("gP:SQLConnected")
end