if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("User Management")

command.new("setrank")
	:Aliases("adduser", "changerank", "giverank")

	:SetPermission("setrank")

	:AddArg("player", {single_target = true})
	:AddArg("rank", {check = function(rank, ply)
		return ply:CanTargetRank(rank)
	end})
	:AddArg("length", {optional = true, default = 0})

	:Help(language.get("setrank_help"))

	:OnExecute(function(ply, targets, rank, length)
		targets[1]:sam_set_rank(rank, length)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "setrank", {
			A = ply, T = targets, V = rank, V_2 = sam.format_length(length)
		})
	end)
:End()

command.new("setrankid")
	:Aliases("adduserid", "changerankid", "giverankid")

	:SetPermission("setrankid")

	:AddArg("steamid")
	:AddArg("rank", {check = function(rank, ply)
		return ply:CanTargetRank(rank)
	end})
	:AddArg("length", {optional = true, default = 0})

	:Help(language.get("setrankid_help"))

	:OnExecute(function(ply, promise, rank, length)
		local a_name = ply:Name()
		local silent = sam.is_command_silent

		promise:done(function(data)
			local steamid, target = data[1], data[2]
			if target then
				target:sam_set_rank(rank, length)

				if silent then return end
				sam.player.send_message(nil, "setrank", {
					A = ply, T = {target, admin = ply}, V = rank, V_2 = sam.format_length(length)
				})
			else
				sam.player.set_rank_id(steamid, rank, length)

				if silent then return end
				sam.player.send_message(nil, "setrank", {
					A = a_name, T = steamid, V = rank, V_2 = sam.format_length(length)
				})
			end
		end)
	end)
:End()

command.new("addrank")
	:SetPermission("manage_ranks")

	:AddArg("text", {hint = "rank name", check = function(rank)
		return not sam.ranks.is_rank(rank)
	end})
	:AddArg("rank", {hint = "inherit from"})
	:AddArg("number", {hint = "immunity", min = 2, max = 99, optional = true})
	:AddArg("length", {hint = "ban limit", optional = true})

	:Help(language.get("addrank_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, inherit, immunity, ban_limit)
		sam.ranks.add_rank(rank, inherit, immunity, ban_limit)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "addrank", {
			A = ply, V = rank
		})
	end)
:End()

command.new("removerank")
	:SetPermission("manage_ranks")

	:AddArg("rank", {check = function(rank)
		return not sam.ranks.is_default_rank(rank)
	end})

	:Help(language.get("removerank_help"))

	:MenuHide()

	:OnExecute(function(ply, rank)
		sam.ranks.remove_rank(rank)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "removerank", {
			A = ply, V = rank
		})
	end)
:End()

command.new("renamerank")
	:SetPermission("manage_ranks")

	:AddArg("rank", {check = function(rank)
		return not sam.ranks.is_default_rank(rank)
	end})
	:AddArg("text", {hint = "new name", check = function(rank)
		return not sam.ranks.is_rank(rank)
	end})

	:Help(language.get("renamerank_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, new_name)
		sam.ranks.rename_rank(rank, new_name)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "renamerank", {
			A = ply, T = rank, V = new_name
		})
	end)
:End()

command.new("changeinherit")
	:SetPermission("manage_ranks")

	:AddArg("rank", {check = function(rank)
		return rank ~= "user" and rank ~= "superadmin"
	end})
	:AddArg("rank", {hint = "inherits from"})

	:Help(language.get("changeinherit_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, inherit)
		if rank == inherit then return end

		sam.ranks.change_inherit(rank, inherit)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "changeinherit", {
			A = ply, T = rank, V = inherit
		})
	end)
:End()

command.new("changerankimmunity")
	:SetPermission("manage_ranks")

	:AddArg("rank", {check = function(rank)
		return rank ~= "user" and rank ~= "superadmin"
	end})
	:AddArg("number", {hint = "new immunity", min = 2, max = 99})

	:Help(language.get("changerankimmunity_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, new_immunity)
		sam.ranks.change_immunity(rank, new_immunity)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "rank_immunity", {
			A = ply, T = rank, V = new_immunity
		})
	end)
:End()

command.new("changerankbanlimit")
	:SetPermission("manage_ranks")

	:AddArg("rank", {check = function(rank)
		return rank ~= "superadmin"
	end})
	:AddArg("length")

	:Help(language.get("changerankbanlimit_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, new_limit)
		sam.ranks.change_ban_limit(rank, new_limit)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "rank_ban_limit", {
			A = ply, T = rank, V = sam.format_length(new_limit)
		})
	end)
:End()

command.new("givepermission")
	:SetPermission("manage_ranks")

	:AddArg("rank")
	:AddArg("text", {hint = "permission"})

	:Help(language.get("givepermission_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, permission)
		if rank == "superadmin" then
			return ply:sam_send_message("super_admin_access")
		end

		sam.ranks.give_permission(rank, permission)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "giveaccess", {
			A = ply, V = permission, T = rank
		})
	end)
:End()

command.new("takepermission")
	:SetPermission("manage_ranks")

	:AddArg("rank")
	:AddArg("text", {hint = "permission"})

	:Help(language.get("takepermission_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, permission)
		if rank == "superadmin" then
			return ply:sam_send_message("super_admin_access")
		end

		sam.ranks.take_permission(rank, permission)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "takeaccess", {
			A = ply, V = permission, T = rank
		})
	end)
:End()

command.new("changeranklimit")
	:SetPermission("manage_ranks")

	:AddArg("rank")
	:AddArg("text", {hint = "limit", check = function(input)
		for k, v in ipairs(sam.limit_types) do
			if v == input then
				return true
			end
		end
		return false
	end})
	:AddArg("number", {hint = "value"})

	:Help(language.get("changeranklimit_help"))

	:MenuHide()

	:OnExecute(function(ply, rank, limit, value)
		if rank == "superadmin" then
			return ply:sam_send_message("super_admin_access")
		end

		sam.ranks.set_limit(rank, limit, value)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "changeranklimit", {
			A = ply, T = rank, V = limit, V_2 = value
		})
	end)
:End()