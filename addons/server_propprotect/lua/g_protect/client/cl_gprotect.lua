gProtect = gProtect or {}

gProtect.TouchPermission = gProtect.TouchPermission or {}
gProtect.LoadedModules = gProtect.LoadedModules or {}
gProtect.CachedPlayers = gProtect.CachedPlayers or {}

local highLighted = {}
local highlightedPlys = {}

local function doPlayerAction(ply, channel, int)
	net.Start("gP:Networking")
	net.WriteUInt(1, 2)
	net.WriteUInt(channel, 2)
	net.WriteUInt(int, 3)
	if ply then
		net.WriteEntity(ply)
	end
	net.SendToServer()
end

local generalActions = {
	["ghost-everyones-props"] = {zpos = -99, option = function() doPlayerAction(nil, 2, 1) end},
	["freeze-everyones-props"] = {zpos = -98, option = function() doPlayerAction(nil, 2, 2) end},
	["remove-disconnected-entities"] = {zpos = -97, option = function() doPlayerAction(nil, 2, 3) end}
}

local playerActions = {
	[1] = {name = "ghost-props", option = function(ply) doPlayerAction(ply, 1, 3) end},
	[2] = {name = "freeze-props", option = function(ply) doPlayerAction(ply, 1, 1) end},
	[3] = {name = "remove-props", option = function(ply) doPlayerAction(ply, 1, 2) end},
	[4] = {name = "remove-entities", option = function(ply) doPlayerAction(ply, 1, 4) end}
}

local function openSettingsMenu()
	local gprotect_menu = vgui.Create("SFrame")
	:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "title"))
	:SetSize(slib.getScaledSize(gProtect.config.FrameSize.x, "x"),slib.getScaledSize(gProtect.config.FrameSize.y, "y"))
    :Center()
    :addCloseButton()
	:MakePopup()

	for k, v in pairs(gProtect.config.modules) do
		local _, tab = gprotect_menu:addTab(slib.getLang("gprotect", gProtect.config.SelectedLanguage, k), "gprotect/tabs/"..k..".png")
		tab:SetZPos(gProtect.config.ModuleCoordination[k])
		
		local scroller = vgui.Create("SScrollPanel", tab:getFrame())
		:Dock(FILL)

		scroller:GetCanvas():DockPadding(0,slib.getTheme("margin"),0,slib.getTheme("margin"))

		for option, data in pairs(v) do
			data = gProtect.LoadedModules[k][option] == nil and gProtect.config.modules[k][option] or gProtect.LoadedModules[k][option]
			if data == nil then continue end
			if isbool(gProtect.config.modules[k][option]) then data = tobool(data) end
			local setting = vgui.Create("SStatement", scroller)
            local _, element = setting:SetZPos(gProtect.config.sortOrders[k][option])
			:addStatement(slib.getLang("gprotect", gProtect.config.SelectedLanguage, k.."_"..option), data)

			local statement = slib.getStatement(data)

			if statement == "int" then
				if gProtect.config.valueRules[k] and gProtect.config.valueRules[k][option] and gProtect.config.valueRules[k][option].intLimit then
					element:SetMin(gProtect.config.valueRules[k][option].intLimit.min)
					element:SetMax(gProtect.config.valueRules[k][option].intLimit.max)
				end
			end

			if statement == "table" then
					element.onElementOpen = function(s)
						if !gProtect.HasPermission(LocalPlayer(), "gProtect_Settings") then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "insufficient-permission")) s:Remove() return end
						local tbl
						if gProtect.config.valueRules[k] and gProtect.config.valueRules[k][option] and gProtect.config.valueRules[k][option].tableAlternatives then
							tbl = gProtect.config.valueRules[k][option].tableAlternatives
							if isfunction(gProtect.config.valueRules[k][option].tableAlternatives) then
								tbl = gProtect.config.valueRules[k][option].tableAlternatives()
							end
						end

						s:addSuggestions(tbl)
						s:sortValues(s.viewer)
						s:sortValues(s.suggestions)
						s:addEntry()
						s:addSearch(s.viewbox, s.viewer)
						s:addSearch(s.suggestionbox, s.suggestions)
						s:setIdentifiers(k, option)
						if gProtect.config.valueRules[k] and gProtect.config.valueRules[k][option] then
							if gProtect.config.valueRules[k][option].toggleableValue then
								s:setToggleable(k, option, gProtect.config.valueRules[k][option].toggleableValue)
							end

							if gProtect.config.valueRules[k][option].onlymodifytable then
								s:setOnlyModifyTable(true)
							end

							if gProtect.config.valueRules[k][option].undeleteableTable then
								s:setundeleteableTable(k, option, gProtect.config.valueRules[k][option].undeleteableTable)
							end

							if gProtect.config.valueRules[k][option].addRules then
								s:setAddRules(gProtect.config.valueRules[k][option].addRules)
							end

							if gProtect.config.valueRules[k][option].tableDeletable then
								s:setTableDeletable(true)
							end

							if gProtect.config.valueRules[k][option].customTable == "int" then
								s:setCustomValues(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "submit"), slib.getLang("gprotect", gProtect.config.SelectedLanguage, "input_number"), true)
							end
						end

						s.OnRemove = function()
							if s.modified then
								element.onValueChange(s.viewer.tbl)
							end
						end
					end

			end
			
			element.onValueChange = function(value)
				if !gProtect.HasPermission(LocalPlayer(), "gProtect_Settings") then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "insufficient-permission")) return false end

				net.Start("gP:Networking")
				net.WriteUInt(3, 2)
				net.WriteString(k)
				net.WriteString(option)

				local statement = slib.getStatement(value)

				if statement == "bool" then
					net.WriteBool(value)
				elseif statement == "int" then
					net.WriteInt(value, 18)
				elseif statement == "color" or statement == "table" then
					value = util.Compress(util.TableToJSON(value))
					net.WriteUInt(#value, 32)
					net.WriteData(value, #value)
				end
				
				net.SendToServer()
			end

			local tooltip = slib.getLang("gprotect", gProtect.config.SelectedLanguage, k.."_"..option.."_tooltip")

			if tooltip then
				slib.createTooltip(tooltip, setting)
			end
		end
		
		if k ~= "general" then
			local search = vgui.Create("SSearchBar", tab:getFrame())
			search:addIcon()
			
			search.entry.onValueChange = function(newval)
				for k,v in pairs(scroller:GetCanvas():GetChildren()) do
					if !v.name then continue end
					if !string.find(string.lower(v.name), string.lower(newval)) then
						v:SetVisible(false)
					else
						v:SetVisible(true)
					end
		
					scroller:GetCanvas():InvalidateLayout(true)
				end
			end
		end
	end

	gprotect_menu:setActiveTab(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "general"))

	local generalScroller = gprotect_menu.tab[slib.getLang("gprotect", gProtect.config.SelectedLanguage, "general")]:GetChildren()[1]

	local player_list = vgui.Create("SListPanel", generalScroller)
	player_list:SetZPos(-100)
    player_list:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "player-list"))
    :addSearchbar()
	:SetZPos(-200)

	for k, v in ipairs(playerActions) do
		player_list:addButton(slib.getLang("gprotect", gProtect.config.SelectedLanguage, v.name), function(s)
			if !s.selected or !IsValid(s.selected) then return end
			v.option(s.selected)
		end)
	end

	player_list:addButton(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "highlight-ents"), function(s)
		if !s.selected or !IsValid(s.selected) then return end
		highlightedPlys[s.selected] = !highlightedPlys[s.selected]
		for k,v in pairs(ents.GetAll()) do
			if gProtect.GetOwner(v) == s.selected then
				if highlightedPlys[s.selected] then
					table.insert(highLighted, v)
				else
					table.RemoveByValue(highLighted, v)
				end
			end
		end
	end,
    function(s, bttn)
        if !s.selected or !IsValid(s.selected) then
            bttn:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "highlight-ents"))    
        return end
		if highlightedPlys[s.selected] then 
            bttn:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "unhighlight-ents")) 
        else 
            bttn:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "highlight-ents")) 
        end
    end)

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() then continue end
        player_list:addEntry(v)
	end
	
	for k,v in pairs(generalActions) do
		local action = vgui.Create("SStatement", generalScroller)
		local _, element = action:SetZPos(v.zpos)
		:addStatement(slib.getLang("gprotect", gProtect.config.SelectedLanguage, k), v.option)
	end
end

local ent

timer.Create("gP:updateLookAt", .05, 0, function()
	local ply = LocalPlayer()
	if !IsValid(ply) then return end

	local detected

	local trace = ply:GetEyeTraceNoCursor()
	local foundent = trace and trace.Entity

	if foundent and IsValid(foundent) then
		detected = foundent
	else
		local raytrace = ents.FindAlongRay(trace.StartPos, trace.HitPos)
		if raytrace then
			for k,v in ipairs(raytrace) do
				if !IsValid(v) or v:IsWeapon() or v == ply then continue end
				detected = v
			end
		end
	end

	ent = detected
end)

hook.Add("OnEntityCreated", "gP:CachePlayerNames", function(ent)
	if ent:IsPlayer() then
		gProtect.CachedPlayers[ent:SteamID()] = ent:Nick()
	end

	timer.Simple(.1, function()
		if highlightedPlys[gProtect.GetOwner(ent)] then
			table.insert(highLighted, ent)
		end
	end)
end )

local permissionColor = slib.getTheme("successcolor")
hook.Add("HUDPaint", "gP:EntInfo", function()
	if !gProtect.config.EnableOwnershipHUD or !ent or !IsValid(ent) then return end
	local ply = LocalPlayer()
	
	local info = gProtect.GetOwner(ent)
	if !info then
		local result = ent:GetNWString("gPOwner", "")
		info = (string.find(result, "STEAM") and "Disconnected") or "World"
	end

	if isstring(info) then
		local translation = slib.getLang("gprotect", gProtect.config.SelectedLanguage, string.lower(info))
		if !translation then return end
		info = translation
		local cachedPly = gProtect.CachedPlayers[ent:GetNWString("gPOwner", "")]

		if cachedPly then
			info = info.." ("..cachedPly..")"
		end
	end

	local wantedcolor = gProtect.HandlePermissions(ply, ent) and slib.getTheme("successcolor", -60) or slib.getTheme("failcolor", -60)
	draw.SimpleTextOutlined( !isstring(info) and info:Nick() or info, slib.createFont("Roboto", 16), slib.getTheme("margin"), ScrH() * .5, slib.getTheme("textcolor"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, slib.lerpColor("gP:PermissionDisplay", wantedcolor))
end)

net.Receive("gP:Networking", function()
	local action = net.ReadBool()

	if action then
		local data = net.ReadString()
		data = util.JSONToTable(data)
	
		local exclusive = net.ReadString()

		gProtect.TouchPermission[exclusive] = data
	else
		local len = net.ReadUInt(32)
		local data = net.ReadData(len)
		local module = net.ReadString()
		
		data = util.JSONToTable(util.Decompress(data))
		if module and module ~= "" then
			gProtect.LoadedModules[module] = data
		else
			gProtect.LoadedModules = data
		end
	end
end)

local grn_col = Color(0, 200, 0)

hook.Add( "PreDrawHalos", "gP:HighLightPlyEnts", function()
	halo.Add( highLighted, grn_col, 5, 5, 2 )
end )

concommand.Add("gprotect_settings", function( ply, cmd, args )
	if !gProtect.HasPermission(LocalPlayer(), "gProtect_Settings") and !gProtect.HasPermission(LocalPlayer(), "gProtect_DashboardAccess") then return end
	if table.IsEmpty(gProtect.LoadedModules) then RunConsoleCommand("say", "!gprotect") return end
    openSettingsMenu()
end)