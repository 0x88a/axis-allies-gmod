if SAM_LOADED then return end

local FAILED = false

local types = {
	sv_ = SERVER and include or function() end,
	cl_ = SERVER and AddCSLuaFile or include,
	sh_ = function(name)
		if SERVER then
			AddCSLuaFile(name)
		end
		return include(name)
	end
}

local load_file = function(name, type)
	if FAILED then return end

	local func = types[name:GetFileFromFilename():sub(1, 3)] or types[type] or types["sh_"]
	if func then
		local rets = {func(name)}
		if rets[1] == false then
			FAILED = true
			sam.print("Failed to load!")
		end
		return unpack(rets)
	end
end

local version = tonumber("133") or 133

sam = {
	config = {},
	language = {},
	player = {},
	ranks = {},
	permissions = {},
	version = version,
	author = "Srlion"
}

sam.load_file = load_file

function sam.print(...)
	MsgC(
		Color(236, 240, 241), "(",
		Color(244, 67, 54), "SAM",
		Color(236, 240, 241), ") ",
		Color(236, 240, 241), ...
	) Msg("\n")
end

sam.print("Loading...")

load_file("sam/libs/sh_types.lua")
load_file("sam/libs/sh_pon.lua")
load_file("sam/libs/sh_mp.lua")
load_file("sam/libs/sh_netstream.lua")
load_file("sam/libs/sh_async_netstream.lua")
load_file("sam/libs/sh_globals.lua")
load_file("sam/libs/sql/sv_init.lua")
sam.Promise = load_file("sam/libs/sh_promises.lua")
load_file("sam/libs/tdlib/cl_tdlib.lua")

if SERVER then
	AddCSLuaFile("sam_config.lua")
end include("sam_config.lua")

load_file("sam/sh_colors.lua")

load_file("sam/sh_util.lua")
load_file("sam/sh_lang.lua")
load_file("sam/sv_sql.lua")
load_file("sam/sh_permissions.lua")

load_file("sam/ranks/sh_ranks.lua")
load_file("sam/ranks/sv_ranks.lua")

load_file("sam/player/sh_player.lua")
load_file("sam/player/sh_nw_vars.lua")
load_file("sam/player/sv_player.lua")
load_file("sam/player/sv_ranks.lua")
load_file("sam/player/sv_auth.lua")
load_file("sam/player/sv_bans.lua")

load_file("sam/command/sh_command.lua")
load_file("sam/command/sv_command.lua")
load_file("sam/command/cl_command.lua")

for _, f in ipairs(file.Find("sam/command/arguments/*.lua", "LUA")) do
	load_file("sam/command/arguments/" .. f, "sh")
end

load_file("sam/sh_restrictions.lua")

load_file("sam/menu/sh_init.lua")
load_file("sam/menu/cl_init.lua")

local modules = file.Find("sam/modules/*.lua", "LUA")
for _, module in ipairs(modules) do
	load_file("sam/modules/" .. module, "sh")
end

if sam.config.Reports.Enabled then
	load_file("sam/reports/cl_reports.lua")
	load_file("sam/reports/sv_reports.lua")
end

load_file("sam/sh_motd.lua")

if SERVER then
	resource.AddWorkshop("1877081587")
end

if not FAILED then
	sam.print("Loaded!")
end

SAM_LOADED = true