if SAM_LOADED then return end

local sam, command = sam, sam.command

local get_number = function(argument, input, gsub)
	if (input == "" or input == nil) and argument.optional then
		if argument.default ~= nil then
			return argument.default
		end
		return ""
	end

	local number = tonumber(input)
	if gsub ~= false and not isnumber(number) then
		number = tonumber(input:gsub("%D", ""), 10 /*gsub returns two args*/)
	end

	return number
end

command.new_argument("number")
	:OnExecute(function(argument, input, ply, _, result)
		local number = get_number(argument, input)
		if number == "" then
			table.insert(result, nil)
		elseif not number then
			ply:sam_send_message("invalid", {
				S = argument.hint or "number", S_2 = input
			})
			return false
		else
			if argument.min then
				number = math.max(number, argument.min)
			end

			if argument.max then
				number = math.min(number, argument.max)
			end

			if argument.round then
				number = math.Round(number)
			end

			table.insert(result, number)
		end
	end)
	:Menu(function(set_result, body, buttons, argument)
		local number_entry = buttons:Add("SAM.TextEntry")
		number_entry:SetUpdateOnType(true)
		number_entry:SetNumeric(true)

		local hint = argument.hint or "number"
		if argument.default then
			hint = hint .. " | " .. tostring(argument.default)
		end

		number_entry:SetHint(hint)

		function number_entry:OnValueChange(number)
			number = get_number(argument, number, false)

			if not number then
				self:SetBackgroundColor(Color(244, 67, 54, 30))
			else
				self:SetBackgroundColor()
			end

			set_result(number)
		end

		number_entry:OnValueChange("")
	end)
:End()