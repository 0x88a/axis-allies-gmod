if SAM_LOADED then return end

local sam, command = sam, sam.command

local is_good_rank = function(rank, argument, ply)
	if argument.check and not argument.check(rank, ply) then
		return false
	end
	return true
end

command.new_argument("rank")
	:OnExecute(function(argument, input, ply, _, result)
		if not sam.ranks.is_rank(input) or not is_good_rank(input, argument, ply) then
			ply:sam_send_message("invalid", {
				S = argument.hint or "rank", S_2 = input
			})
			return false
		end

		table.insert(result, input)
	end)

	:Menu(function(set_result, body, buttons, argument)
		local current_rank = argument.hint or "select rank"

		local ranks = buttons:Add("SAM.ComboBox")
		ranks:SetValue(current_rank)

		function ranks:OnSelect(_, value)
			set_result(value)
			current_rank = value
		end

		function ranks:DoClick()
			if self:IsMenuOpen() then
				return self:CloseMenu()
			end

			self:Clear()
			self:SetValue(current_rank)

			for rank_name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
				if is_good_rank(rank_name, argument, LocalPlayer()) then
					self:AddChoice(rank_name)
				end
			end

			self:OpenMenu()
		end
	end)

	:AutoComplete(function(argument, result, name)
		for rank_name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
			if rank_name:lower():find(name, 1, true) and is_good_rank(rank_name, argument, LocalPlayer()) then
				table.insert(result, rank_name)
			end
		end
	end)
:End()