if SAM_LOADED then return end

local add = not GAMEMODE and hook.Add or function(_, _, fn)
	fn()
end

add("PostGamemodeLoaded", "SAM.Module.Restrictions", function()
	if not GAMEMODE.IsSandboxDerived then return end

	do
		local tools = weapons.GetStored("gmod_tool")
		if not sam.istable(tools) then return end

		for k, v in pairs(tools.Tool) do
			sam.permissions.add(v.Mode, "Tools - " .. (v.Category or "Other"), "user")
		end

		hook.Add("CanTool", "SAM.Module.Restrictions", function(ply, _, tool)
			if not ply:HasPermission(tool) then
				if CLIENT and sam.player.check_cooldown(ply, "ToolNoPermission", 0.1) then
					ply:sam_send_message("You don't have permission to use this tool.")
				end
				return false
			end
		end)
	end

	do
		local PLAYER = FindMetaTable("Player")

		local get_limit = sam.ranks.get_limit
		function PLAYER:GetLimit(limit_type)
			return get_limit(self:GetUserGroup(), limit_type)
		end

		function PLAYER:CheckLimit(limit_type)
			if game.SinglePlayer() then return true end

			local c = self:GetLimit(limit_type)
			if c < 0 then return true end

			if self:GetCount(limit_type) > c - 1 then
				if SERVER then self:LimitHit(limit_type) end
				return false
			end

			return true
		end

		sam.limit_types = {}
		for _, limit_type in SortedPairs(cleanup.GetTable(), true) do
			local cvar = GetConVar("sbox_max" .. limit_type)
			if cvar then
				table.insert(sam.limit_types, limit_type)
			end
		end
	end

	hook.Call("SAM.LoadedRestrictions")
end)