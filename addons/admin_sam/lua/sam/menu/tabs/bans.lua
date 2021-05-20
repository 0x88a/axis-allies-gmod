if SAM_LOADED then return end

local sam = sam
local SQL = sam.SQL
local netstream = sam.netstream

local get_pages_count = function(bans_count)
	bans_count = bans_count / 35
	local i2 = math.floor(bans_count)
	return bans_count ~= i2 and i2 + 1 or bans_count
end

sam.permissions.add("manage_bans", nil, "superadmin")

if SERVER then
	local check = function(ply)
		return ply:HasPermission("manage_bans") and ply:sam_check_cooldown("MenuManageBans", 0.1)
	end

	local limit = 35

	local get_page_count = function(res, callback, page, order_by, keyword)
		local current_time = os.time()
		local query = [[
			SELECT
				COUNT(`steamid`) AS `count`
			FROM
				`sam_bans`
			WHERE
				(`unban_date` >= %d OR `unban_date` = 0)]]

		query = query:format(current_time)

		if keyword then
			query = query .. " AND `steamid` LIKE " .. SQL.Escape(keyword .. "%")
		end

		SQL.Query(query, callback, true, {res, page, order_by, keyword, current_time})
	end

	local resolve_promise = function(data, arguments)
		local res = arguments[1]
		arguments[1] = data
		res(arguments)
	end

	local get_bans = function(count_data, arguments)
		local res, page, order_by, keyword, current_time = unpack(arguments)
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
				`sam_bans`.*,
				IFNULL(`p1`.`name`, '') AS `name`,
				IFNULL(`p2`.`name`, '') AS `admin_name`
			FROM
				`sam_bans`
			LEFT OUTER JOIN
				`sam_players` AS `p1`
			ON
				`sam_bans`.`steamid` = `p1`.`steamid`
			LEFT OUTER JOIN
				`sam_players` AS `p2`
			ON
				`sam_bans`.`admin` = `p2`.`steamid`
			WHERE
				(`sam_bans`.`unban_date` >= %d OR `sam_bans`.`unban_date` = 0)]]

		query = query:format(current_time)

		if keyword then
			query = query .. " AND `sam_bans`.`steamid` LIKE " .. SQL.Escape(keyword .. "%")
		end

		local offset = math.abs(limit * (page - 1))
		query = query .. ([[
			ORDER BY
				`sam_bans`.`id` %s
			LIMIT
				%d OFFSET %d]]):format(order_by, limit, offset)

		SQL.Query(query, resolve_promise, nil, {res, count, current_page})
	end

	netstream.async.Hook("SAM.GetBans", function(res, ply, page, order_by, keyword)
		if not isnumber(page) then return end
		if order_by ~= "ASC" and order_by ~= "DESC" then return end
		if keyword ~= nil and not sam.isstring(keyword) then return end

		get_page_count(res, get_bans, page, order_by, keyword)
	end, check)
end

if CLIENT then
	sam.menu.add_tab("Bans", function()
		local pages = 0
		local d_menu = nil
		local refresh = nil
		local current_page, current_order, keyword = nil, "DESC", nil

		local bans_body = vgui.Create("Panel")
		bans_body:Dock(FILL)
		bans_body:DockMargin(0, 1, 0, 0)

		local toggle_loading, is_loading = sam.menu.add_loading_panel(bans_body)

		local top_panel = bans_body:Add("Panel")
		top_panel:Dock(TOP)
		top_panel:DockMargin(0, 0, 0, 1)
		top_panel:SetTall(sam.menu.scale(20))

		local search_entry = top_panel:Add("SAM.TextEntry")
		search_entry:Dock(FILL)
		search_entry:SetHint("Search bans - steamid")
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

		local ban_list = bans_body:Add("SAM.ListView")
		ban_list:Dock(FILL)
		ban_list:SetMultiSelect(false)

		ban_list:AddColumn("Name/SteamID", sam.menu.scale(140))
		ban_list:AddColumn("Reason")
		ban_list:AddColumn("Time Left", sam.menu.scale(110))
		ban_list:AddColumn("Admin", sam.menu.scale(140))

		function ban_list:OnRowRightClick(_, line)
			d_menu = DermaMenu()

			if line.info.name ~= "" then
				d_menu:AddOption("Copy Name", function()
					SetClipboardText(line.info.name)
				end)
			end

			d_menu:AddOption("Copy SteamID", function()
				SetClipboardText(line.info.steamid)
			end)

			d_menu:AddOption("Copy Reason", function()
				SetClipboardText(line.info.reason)
			end)

			if line.info.admin_name ~= "" then
				d_menu:AddOption("Copy Admin Name", function()
					SetClipboardText(line.info.admin_name)
				end)
			end

			d_menu:AddOption("Copy Admin SteamID", function()
				SetClipboardText(line.info.admin)
			end)

			d_menu:AddOption("Copy Time Left", function()
				SetClipboardText(line.info.time_left)
			end)

			if LocalPlayer():HasPermission("unban") then
				d_menu:AddSpacer()
				d_menu:AddOption("Unban", function()
					RunConsoleCommand("sam", "unban", line.info.steamid)
					line:Remove()
				end)
			end

			d_menu:Open()
		end

		local set_bans_data = function(data)
			if IsValid(d_menu) then
				d_menu:Remove()
			end

			ban_list:Clear()

			local bans, bans_count, current_page_2 = unpack(data)

			pages = get_pages_count(bans_count)
			current_page.i = pages == 0 and 0 or current_page_2 or current_page.i
			current_page:SetText(current_page.i .. "/" .. pages)

			for _, v in ipairs(bans) do
				local name = v.name
				local unban_date = tonumber(v.unban_date)
				local time_left = unban_date == 0 and "never" or sam.reverse_parse_length((unban_date - os.time()) / 60)

				local line = ban_list:AddLine(name ~= "" and name or v.steamid, v.reason, time_left, v.admin_name ~= "" and v.admin_name or v.admin)
				line:SetTooltip(([[
					Name: %s
					SteamID: %s
					Reason: %s
					Time Left: %s
					Admin: %s
					Admin SteamID: %s]]):format(name, v.steamid, v.reason, time_left, v.admin == "Console" and "Console" or v.admin_name, v.admin))

				line.info = v
				line.info.time_left = time_left
			end
		end

		refresh = function()
			if not is_loading() and LocalPlayer():HasPermission("manage_bans") then
				local refresh_query = netstream.async.Start("SAM.GetBans", toggle_loading, current_page.i, current_order, keyword)
				refresh_query:done(set_bans_data)
			end
		end

		local bottom_panel = bans_body:Add("Panel")
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

		for k, v in ipairs({"SAM.BannedPlayer", "SAM.BannedSteamID", "SAM.EditedBan", "SAM.UnbannedSteamID"}) do
			hook.Add(v, "SAM.MenuBans", function()
				if IsValid(ban_list) then
					refresh()
				end
			end)
		end

		refresh()

		return bans_body
	end, function()
		return LocalPlayer():HasPermission("manage_bans")
	end, 4)
end