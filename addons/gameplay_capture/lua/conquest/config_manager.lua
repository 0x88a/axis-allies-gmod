
Conquest.Config = Conquest.Config or {}
Conquest.Config.cache = Conquest.Config.cache or {}
Conquest.Config.loaded = Conquest.Config.loaded or false


local information = {
    owner = "76561198202578143",
    scriptID = "5458",
    scriptVersion = "1.3.5",
    scriptHash = "38ec7953d0d0926b61721903a565bd43",
}

local function client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

local function server(file)
	if SERVER then
		return include(file)
	end
end

local function shared(file)
	return client(file) or server(file)
end

function Conquest.Config.canEdit(pPlayer)
    local bool = false

    if table.HasValue(Conquest.Config.Ranks, pPlayer:GetUserGroup()) then
        bool = true
    end


    return bool
end

// This is slow, but it is the only way I know of without seralization/bytes 
function Conquest.Config.getType(value)
    local ourType = type(value)

    if (ourType) then
        if ourType == "string" then
            return net.WriteString(value)
        elseif ourType == "number" then
            return net.WriteInt(value, 16)
        elseif ourType == "boolean" then
            return net.WriteBool(value)
        end
    end
end

function Conquest.Config.new(key, value, desc, callback, cat)
    local cachedConfig = Conquest.Config.cache[key]

    if cachedConfig then
        // This keeps the value (if changed) the same, but changing other things. Such as defaults, descriptions.
        // So we can use .OnValueChanged without errors/corrupted data //
        Conquest.Config.cache[key] = {value = cachedConfig.value, desc = desc, default = value, callback = callback, cat = cat }
    elseif (!cachedConfig) then
        Conquest.Config.cache[key] = {value = value, desc = desc, default = value, callback = callback, cat = cat }
    end

end 

function Conquest.Config.change(key, value)
    local ourConfig = Conquest.Config.cache[key]


    if (ourConfig) then
        ourConfig.value = value

        if (SERVER) then
            local newValue = value
            local value = {}
            value[key] = ourConfig.value

            if ourConfig.callback then
                ourConfig.callback(newValue)
            end


            if (value) then
                net.Start("conquest_config_syncall")
                    net.WriteTable(value)
                net.Broadcast()

                Conquest.Config.write()
            end
        end
    end
end

function Conquest.Config.get(key, default)
    local ourConfig = Conquest.Config.cache[key]

    if (ourConfig) then
        if (ourConfig.value) != nil then
            return ourConfig.value
        elseif (ourConfig.default) != nil then
            return ourConfig.default
        end
    end

    return default
end

function Conquest.Config.load()
    if (SERVER) then
    	if Conquest.Config.loaded then return end
        // Only load the file from the server, but load the config shared. Once we've loaded
        MsgC(Color(236, 240, 241), ".............................................\n")
        MsgC(Color(255, 0, 0), "[Conquest] Loading config file\n")

        local data = file.Read("conquest/config.txt", "DATA")

        if (data) then
            local newData = util.JSONToTable(data)
            
            for k, v in pairs(newData) do
                Conquest.Config.cache[k] = Conquest.Config.cache[k] or {}
                Conquest.Config.cache[k].value = v
            end
        end

        Conquest.Config.loaded = true

        MsgC(Color(0, 255, 0), "[Conquest] Successfully loaded script.\n")
        if (information) then
            print("[script].......... Conquest")
            print("[version]......... ".. information.scriptVersion)
            print("[author].......... Nykez-#Nykez0001")
            print("[owner]........... ".. information.owner)
            print("[server-ip]....... ".. game.GetIPAddress())
            print("[hash]............ ".. information.scriptHash)

            MsgC(Color(0, 0, 255), "Thank you for using the script <3\n")
            MsgC(Color(236, 240, 241), ".............................................\n")
        end


    end

    // include config file 
   shared("config.lua")

end


if (SERVER) then
    util.AddNetworkString("conquest_config_write")
    util.AddNetworkString("conquest_config_sync")
    util.AddNetworkString("conquest_config_syncall")

    function Conquest.Config.moddedValues()
        local data = {}

        for k,v in pairs(Conquest.Config.cache) do
            if (v.value != v.default) then 
                data[k] = v.value
            end
        end

        return data
    end

    function Conquest.Config.sync(pPlayer)
        net.Start("conquest_config_sync") 
            net.WriteTable(Conquest.Config.moddedValues())
        net.Send(pPlayer)
    end
    hook.Add("PlayerInitialSpawn", "Conquest_SyncConfig", Conquest.Config.sync)

    function Conquest.Config.write()
        local data = Conquest.Config.moddedValues()

        if (data) then
            file.CreateDir("conquest")
            file.Write("conquest/config.txt", util.TableToJSON(data))
        end
    end

    net.Receive("conquest_config_write", function(len, pPlayer)

        local data = net.ReadTable()

        if !table.HasValue(Conquest.Config.Ranks, pPlayer:GetUserGroup()) then return end

        for k,v in pairs(data) do
            Conquest.Config.change(k, v)
        end

    end)

    concommand.Add("conquest_flushconfig", function(pPlayer)
        if !table.HasValue(Conquest.Config.Ranks, pPlayer:GetUserGroup()) then return end

        if file.Exists("conquest/config.txt", 'DATA') then
            file.Delete("conquest/config.txt")

            pPlayer:PrintMessage(HUD_PRINTTALK, "Conquest config flushed. Please restart your server.")
        else
            pPlayer:PrintMessage(HUD_PRINTTALK, "No configuration file exists.")
        end
    end)

end

if (CLIENT) then

    net.Receive("conquest_config_sync", function()
        local tbl = net.ReadTable()

        for k,v in pairs(tbl) do
            if Conquest.Config.cache[k] then
                Conquest.Config.cache[k].value = v
            end
        end
    end)

    net.Receive("conquest_config_syncall", function()
        local data = net.ReadTable()

        for k,v in pairs(data) do
            Conquest.Config.change(k, v)
        end
    end)
end
