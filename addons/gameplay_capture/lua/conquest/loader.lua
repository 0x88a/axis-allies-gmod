
-- No need to touch this file --
-- Loads the addons --

Conquest = Conquest or {}
Conquest.config = Conquest.config or {}
Conquest.cache = Conquest.cache or {}

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


server("server/sv_points.lua")
server("server/sv_main.lua")
server('server/sv_player.lua')
//server('server/mysql.lua')
server('server/sv_db.lua')
server('server/sv_spawns.lua')
server("server/sv_teams.lua")
server("server/sv_map.lua")



shared("config_manager.lua")
shared("shared/sh_player.lua")

client("client/cl_main.lua")
client("client/cl_tdlib.lua")
client("client/cl_menu.lua")
client("client/cl_spawns.lua")
client("client/cl_teams.lua")

client("client/cl_map.lua")

client('client/derma/cl_sheet.lua')
client('client/derma/cl_textentry.lua')


Conquest.Config.load()

shared("plugin.lua")