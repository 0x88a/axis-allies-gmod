if SAM_LOADED then return end

local sam, command = sam, sam.command

command.new_argument("text")
	:OnExecute(function(argument, input, ply, _, result)
		if sam.isstring(input) then
			input = input:sub(1, 255)
		end

		local invalid = false
		if input == nil then
			if not argument.optional then
				invalid = true
			end
		elseif argument.check and not argument.check(input, ply) then
			invalid = true
		end

		if invalid then
			ply:sam_send_message("invalid", {
				S = argument.hint or "text", S_2 = input
			})
			return false
		end

		table.insert(result, input)
	end)
	:Menu(function(set_result, body, buttons, argument)
		local text_entry = buttons:Add("SAM.TextEntry")

		local default = argument.default
		function text_entry:OnValueChange(text)
			local invalid = false
			if text == "" then
				if default then
					text = default
				elseif not argument.optional then
					invalid = true
				end
			elseif argument.check and not argument.check(text, LocalPlayer()) then
				invalid = true
			end

			if invalid then
				self:SetBackgroundColor(Color(244, 67, 54, 30))
			else
				self:SetBackgroundColor()
			end

			set_result(not invalid and text or nil)
		end
		text_entry:OnValueChange("")

		local hint = argument.hint or "text"
		if default then
			hint = hint .. " | " .. tostring(default)
		end

		text_entry:SetHint(hint)
	end)
:End()