local deleteNames = {
	["#spawnmenu.menu.delete"] = true,
	["#collision_off"] = true,
	["#spawnmenu.menu.spawn_with_toolgun"] = true
}

local function addOptions(menu, type, tbl, copy, prespacer, postspacer)
	tbl = util.TableToJSON(tbl)
	if prespacer then
		menu:AddSpacer()
	end

	menu:AddOption( gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, type == "model" and "add-blocked-models" or "add-blacklisted-ents"), function()
		net.Start("gP:Networking")
		net.WriteUInt(2,2)
		net.WriteUInt(type == "model" and 1 or 2, 2)
		net.WriteString(tbl)
		net.WriteBool(true)
		net.SendToServer()
	end ):SetIcon("icon16/add.png")

	menu:AddOption( gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, type == "model" and "remove-blocked-models" or "remove-blacklisted-ents"), function()
		net.Start("gP:Networking")
		net.WriteUInt(2,2)
		net.WriteUInt(type == "model" and 1 or 2, 2)
		net.WriteString(tbl)
		net.WriteBool(false)
		net.SendToServer()
	end ):SetIcon("icon16/delete.png")

	if copy then
		menu:AddOption( gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "copy-clipboard"), function()
			SetClipboardText(copy)
		end ):SetIcon("icon16/page_copy.png")
	end

	if postspacer then
		menu:AddSpacer()
	end
end

local function HandleMenuOptions(state, menu, name)
	local hovered = vgui.GetHoveredPanel()
	local data = IsValid(hovered) and hovered:GetTable() or {}
	local ply = LocalPlayer()
	if IsValid(hovered) and deleteNames[name] then
		if state == "pre" then
			if data.m_strModelName and name ~= "#spawnmenu.menu.spawn_with_toolgun" then
				addOptions(menu, "model", {[data.m_strModelName] = true}, data.m_strModelName, false, true)
			end
		else
			if data.m_Type == "entity" then
				addOptions(menu, "entity", {[data.m_SpawnName] = true}, data.m_SpawnName, true, true)
			end

			if hovered.ClassName == "ContextMenu" then
				local ent = ply:GetEyeTrace().Entity
				if IsValid(ent) then
					if string.find(ent:GetClass(), "prop_") then
						local mdl = ent:GetModel()
						addOptions(menu, "model", {[mdl] = true}, mdl, true)
					else
						local classname = ent:GetClass()
						addOptions(menu, "entity", {[classname] = true}, classname, true, true)
					end
				end
			end
		end
	end
end

hook.Add("gP:PreAddedDMenuOption", "tester", HandleMenuOptions)
hook.Add("gP:PostAddedDMenuOption", "tester", HandleMenuOptions)

timer.Simple(1, function()
	local dmenu = baseclass.Get("DMenu")
	slib.wrapFunction(dmenu, "AddOption", function(menu, str) hook.Run("gP:PreAddedDMenuOption", "pre", menu, str) end, function(menu, str) hook.Run("gP:PostAddedDMenuOption", "post", menu, str) end)

	hook.Add( "SpawnlistOpenGenericMenu", "DragAndDropSelectionMenu", function( canvas )

		local selected = canvas:GetSelectedChildren()
		local allow = {}

		for k, v in pairs(selected) do
			if !IsValid(v) then continue end
			local data = v:GetTable()
			if data.m_Type == "entity" then allow["entity"] = true end
			if data.m_strModelName then allow["prop"] = true break end
		end

		local menu = DermaMenu()
	
		-- This is less than ideal
		local spawnicons = 0
		local icon = nil
		for id, pnl in pairs( selected ) do
			if ( pnl.InternalAddResizeMenu ) then
				spawnicons = spawnicons + 1
				icon = pnl
			end
		end
	
		if ( spawnicons > 0 ) then
			icon:InternalAddResizeMenu( menu, function( w, h )
	
				for id, pnl in pairs( selected ) do
					if ( !pnl.InternalAddResizeMenu ) then continue end
					pnl:SetSize( w, h )
					pnl:InvalidateLayout( true )
					pnl:GetParent():OnModified()
					pnl:GetParent():Layout()
					pnl:SetModel( pnl:GetModelName(), pnl:GetSkinID(), pnl:GetBodyGroup() )
				end
	
			end, language.GetPhrase( "spawnmenu.menu.resizex" ):format( spawnicons ) )
	
			menu:AddOption( language.GetPhrase( "spawnmenu.menu.rerenderx" ):format( spawnicons ), function()
				for id, pnl in pairs( selected ) do
					if ( !pnl.RebuildSpawnIcon ) then continue end
					pnl:RebuildSpawnIcon()
				end
			end ):SetIcon( "icon16/picture.png" )
		end

		if allow["prop"] and gProtect.HasPermission(LocalPlayer(), "gProtect_Settings") then
			local models = {}
			for k, v in pairs( selected ) do
				if !IsValid(v) then continue end
				local data = v:GetTable()
				if !data.m_strModelName then continue end
				models[data.m_strModelName] = true
			end

			addOptions(menu, "model", models, false, true, true)
		end

		if allow["entity"] and gProtect.HasPermission(LocalPlayer(), "gProtect_Settings") then
			local entities = {}
			for k, v in pairs( selected ) do
				if !IsValid(v) then continue end
				local data = v:GetTable()
				if !data.m_SpawnName then continue end
				entities[data.m_SpawnName] = true
			end

			addOptions(menu, "entity", entities, false, true, true)
		end

		menu:AddOption( language.GetPhrase( "spawnmenu.menu.deletex" ):format( #selected ), function()

			for k, v in pairs( selected ) do
				v:Remove()
			end
	
			hook.Run( "SpawnlistContentChanged" )
	
		end ):SetIcon( "icon16/bin_closed.png" )

		menu:Open()

	end )
end)