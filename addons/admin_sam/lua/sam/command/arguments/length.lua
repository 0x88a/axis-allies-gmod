if SAM_LOADED then return end

local sam, command = sam, sam.command

local get_length = function(arg, input)
	if (input == "" or input == nil) and arg.optional then
		if arg.default ~= nil then
			return arg.default
		end

		return ""
	end

	return sam.parse_length(input)
end

command.new_argument("length")
	:OnExecute(function(arg, input, ply, _, result)
		local length = get_length(arg, input)
		if length == "" then
			table.insert(result, nil)
		elseif not length then
			ply:sam_send_message("invalid", {
				S = "length", S_2 = input
			})
			return false
		else
			if arg.min and length ~= 0 then
				length = math.max(length, arg.min)
			end

			if arg.max then
				if length == 0 then
					length = arg.max
				else
					length = math.min(length, arg.max)
				end
			end

			table.insert(result, length)
		end
	end)

	:Menu(function(set_result, body, buttons, argument)
		local length_input = buttons:Add("SAM.TextEntry")

		local hint = argument.hint or "length"
		if argument.default then
			hint = hint .. " | " .. tostring(argument.default)
		end

		length_input:SetHint(hint)

		function length_input:OnValueChange(new_limit)
			new_limit = get_length(argument, new_limit)

			if not new_limit then
				self:SetBackgroundColor(Color(244, 67, 54, 30))
			else
				self:SetBackgroundColor()
			end

			set_result(new_limit and new_limit or nil)
		end

		length_input:OnValueChange("")
	end)
:End()