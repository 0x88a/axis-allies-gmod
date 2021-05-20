Conquest.Plugins = Conquest.Plugins or {}
Conquest.Plugins.cache = Conquest.Plugins.cache or {}

local FOLDER_NAME = "conquest"

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


function Conquest.Plugins.loadAll()

    local files, directories = file.Find(FOLDER_NAME.."/plugins/*", "LUA" )

    for k,v in pairs(directories) do
        
        local files, directories = file.Find(FOLDER_NAME.."/plugins/"..v.."/shared.lua", "LUA" )
        

        if (files) and (files[1] == "shared.lua") then
           
           shared("plugins/"..v.."/shared.lua")

           Conquest.Plugins.cache[v] = true
        end
        
    end
end

Conquest.Plugins.loadAll()