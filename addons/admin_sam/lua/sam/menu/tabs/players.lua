if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL
local netstream = sam.netstream

sam.permissions.add("view_players", nil, "superadmin")

local get_pages_count = function(count)
	count = count / 35
	local i2 = math.floor(count)
	return count ~= i2 and i2 + 1 or count
end

if SERVER then
	local check = function(ply)
		return ply:HasPermission("view_players") and ply:sam_check_cooldown("MenuViewPlayers", 0.1)
	end

	local limit = 35

	local get_page_count = function(callback, res, page, order_by, sort_by, keyword)
		local query = [[
			SELECT
				COUNT(`steamid`) AS `count`
			FROM
				`sam_players`]]
		if keyword then
			if sam.is_steamid64(keyword) then
				keyword = util.SteamIDFrom64(keyword)
			end

			if sam.is_steamid(keyword) then
				query = query .. "WHERE `steamid` LIKE " .. SQL.Escape(keyword .. "%")
			else
				query = query .. "WHERE `name` LIKE " .. SQL.Escape(keyword .. "%")
			end
		end
		SQL.Query(query, callback, true, {res, page, order_by, sort_by, keyword})
	end

	local valid_sorts = {
		id = true,
		name = true,
		rank = true,
		play_time = true,
		last_join = true
	}

	local resolve_promise = function(data, arguments)
		local res = arguments[1]
		arguments[1] = data
		res(arguments)
	end

	local get_players = function(count_data, arguments)
		local res, page, order_by, sort_by, keyword = unpack(arguments)
		local count = count_data.count

		local current_page
		if page < 1 then
			page, current_page = 1, 1
		end

		local pages_count = get_pages_count(count)
		if page > pages_count then
			page, current_page = pages_count, pages_count
		end

		local query = [[
			SELECT
				`steamid`,
				`name`,
				`rank`,
				`expiry_date`,
				`first_join`,
				`last_join`,
				`play_time`
			FROM
				`sam_players`
		]]

		local args = {}

		if keyword then
			args[1] = sam.is_steamid(keyword) and "steamid" or "name"
			args[2] = keyword .. "%"

			query = query .. [[
				WHERE
					`{1f}` LIKE {2}
			]]
		end

		args[3] = sort_by
		if order_by == "DESC" then
			query = query .. [[
				ORDER BY `{3f}` DESC
			]]
		else
			query = query .. [[
				ORDER BY `{3f}` ASC
			]]
		end

		args[4] = limit
		args[5] = math.abs(limit * (page - 1))

		query = query .. [[
			LIMIT {4} OFFSET {5}
		]]

		SQL.FQuery(query, args, resolve_promise, false, {res, count, current_page})
	end

	netstream.async.Hook("SAM.GetPlayers", function(res, ply, page, order_by, sort_by, keyword)
		if not isnumber(page) then return end
		if order_by ~= "ASC" and order_by ~= "DESC" then return end
		if not valid_sorts[sort_by] then return end
		if keyword ~= nil and not sam.isstring(keyword) then return end

		get_page_count(get_players, res, page, order_by, sort_by, keyword)
	end, check)
end

if CLIENT then
	sam.menu.add_tab("Players", function()
		local pages = 0
		local d_menu = nil
		local refresh = nil
		local current_page, current_order, current_sort, keyword = nil, "DESC", "id", nil

		local players_body = vgui.Create("Panel")
		players_body:Dock(FILL)
		players_body:DockMargin(0, 1, 0, 0)

		local toggle_loading, is_loading = sam.menu.add_loading_panel(players_body)

		local top_panel = players_body:Add("Panel")
		top_panel:Dock(TOP)
		top_panel:DockMargin(0, 0, 0, 1)
		top_panel:SetTall(sam.menu.scale(20))

		local search_entry = top_panel:Add("SAM.TextEntry")
		search_entry:Dock(FILL)
		search_entry:SetHint("Search players - name/steamid")
		search_entry:SetZPos(0)

		function search_entry:OnEnter()
			local value = self:GetValue()
			if keyword ~= value then
				keyword = value ~= "" and value or nil
				refresh()
			end
		end

		local order_by = top_panel:Add("SAM.ComboBox")
		order_by:Dock(RIGHT)
		order_by:DockMargin(1, 0, 0, 0)
		order_by:SetWide(sam.menu.scale(55))
		order_by:SetZPos(-1)

		order_by:SetValue("Desc")
		order_by:AddChoice("Asc")
		order_by:AddChoice("Desc")

		function order_by:OnSelect(_, value)
			value = value:upper()
			if current_order ~= value then
				current_order = value
				refresh()
			end
		end

		local sort_by = top_panel:Add("SAM.ComboBox")
		sort_by:Dock(RIGHT)
		sort_by:DockMargin(1, 0, 0, 0)
		sort_by:SetWide(sam.menu.scale(75))
		sort_by:SetZPos(-2)

		sort_by:SetValue("ID")
		sort_by:AddChoice("ID")
		sort_by:AddChoice("Name")
		sort_by:AddChoice("Rank")
		sort_by:AddChoice("Play Time")
		sort_by:AddChoice("Last Join")

		function sort_by:OnSelect(_, value)
			value = value:lower():gsub(" ", "_")
			if current_sort ~= value then
				current_sort = value
				refresh()
			end
		end

		local players_list = players_body:Add("SAM.ListView")
		players_list:Dock(FILL)
		players_list:SetMultiSelect(false)

		players_list:AddColumn("Name/SteamID", sam.menu.scale(140))
		players_list:AddColumn("Rank", sam.menu.scale(110))
		players_list:AddColumn("Play Time")
		players_list:AddColumn("Expires In")

		function players_list:OnRowRightClick(_, line)
			d_menu = DermaMenu()

			if line.steamid ~= "BOT" then
				d_menu:AddOption("Copy SteamID", function()
					SetClipboardText(line.steamid)
				end)
			end

			for k, v in ipairs({"Name", "Rank", "Play Time", "Expire Time"}) do
					d_menu:AddOption("Copy " .. v, function()
					SetClipboardText(line:GetColumnText(k))
				end)
			end

			if LocalPlayer():HasPermission("setrankid") and line.steamid ~= "BOT" then
				d_menu:AddSpacer()

				local sub_menu = d_menu:AddSubMenu("Set Rank")

				for name in SortedPairsByMemberValue(sam.ranks.get_ranks(), "immunity", true) do
					sub_menu:AddOption(name, function()
						RunConsoleCommand("sam", "setrankid", line.steamid, name)
					end)
				end
			end

			d_menu:Open()
		end

		local set_players_data = function(data)
			if IsValid(d_menu) then
				d_menu:Remove()
			end

			players_list:Clear()

			local players, players_count, current_page_2 = unpack(data)

			pages = get_pages_count(players_count)
			current_page.i = pages == 0 and 0 or current_page_2 or current_page.i
			current_page:SetText(current_page.i .. "/" .. pages)

			for _, v in ipairs(players) do
				local steamid, name = v.steamid, v.name
				local expiry_date = tonumber(v.expiry_date)
				local time_left = expiry_date == 0 and "never" or sam.reverse_parse_length((expiry_date - os.time()) / 60)
				local play_time = sam.reverse_parse_length(tonumber(v.play_time) / 60)

				local line = players_list:AddLine(name ~= "" and name or steamid, v.rank, play_time, time_left)
				line.steamid = steamid
				line.tool_tip = ([[
						SteamID: %s
						Name: %s
						Rank: %s
						Play Time: {T}
						Expires In: %s
						First Join: %s
						Last Join: %s]]):format(steamid, name, v.rank, time_left, os.date("%I:%M%p - %d/%m/%Y", v.first_join), os.date("%I:%M%p - %d/%m/%Y", v.last_join))
				line:SetTooltip(line.tool_tip:gsub("{T}", play_time))
			end
		end

		refresh = function()
			if IsValid(players_list) and not is_loading() and LocalPlayer():HasPermission("view_players") then
				local refresh_query = netstream.async.Start("SAM.GetPlayers", toggle_loading, current_page.i, current_order, current_sort, keyword)
				refresh_query:done(set_players_data)
			end
		end

		local bottom_panel = players_body:Add("Panel")
		bottom_panel:Dock(BOTTOM)
		bottom_panel:DockMargin(0, 1, 0, 0)
		bottom_panel:SetTall(sam.menu.scale(20))
		bottom_panel:SAM_TDLib()
			:Background(Color(60, 60, 60, 200))

		local previous_page = bottom_panel:Add("DButton")
		previous_page:Dock(LEFT)
		previous_page:SetWide(sam.menu.scale(20))
		previous_page:SetText("<")
		previous_page:SetTextColor(Color(200, 200, 200))
		previous_page:SAM_TDLib()
			:ClearPaint()
			:Background(Color(255, 255, 255, 10))

		function previous_page:DoClick()
			if current_page.i <= 1 then return end
			current_page.i = current_page.i - 1
			refresh()
		end

		current_page = bottom_panel:Add("DLabel")
		current_page:Dock(FILL)
		current_page:SetContentAlignment(5)
		current_page:SetFont("SAM.MenuPages")
		current_page:SetText("loading...")
		current_page.i = 1

		local next_page = bottom_panel:Add("DButton")
		next_page:Dock(RIGHT)
		next_page:SetWide(sam.menu.scale(20))
		next_page:SetText(">")
		next_page:SetTextColor(Color(200, 200, 200))
		next_page:SAM_TDLib()
			:ClearPaint()
			:Background(Color(255, 255, 255, 10))

		function next_page:DoClick()
			if current_page.i == pages then return end
			current_page.i = current_page.i + 1
			refresh()
		end

		hook.Add("SAM.UpdatedPlayTimes", "SAM.UpdatePlayersPlayTime", function()
			for _, line in ipairs(players_list.lines) do
				local ply = player.GetBySteamID(line.steamid)
				if IsValid(ply) and ply:sam_get_nwvar("is_authed") then
					local play_time = sam.reverse_parse_length(ply:sam_get_play_time() / 60)
					line:SetTooltip(line.tool_tip:gsub("{T}", play_time))
					line:GetChildren()[3]:SetText(play_time)
				end
			end
		end)

		do
			local refresh_2 = function()
				timer.Simple(1, refresh)
			end

			for k, v in ipairs({"SAM.AuthedPlayer", "SAM.ChangedPlayerRank", "SAM.ChangedSteamIDRank"}) do
				hook.Add(v, "SAM.MenuPlayers", refresh_2)
			end
		end

		refresh()

		return players_body
	end, function()
		return LocalPlayer():HasPermission("view_players")
	end, 2)
end