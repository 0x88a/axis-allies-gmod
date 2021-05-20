if SAM_LOADED then return end

sam.menu = {}

function sam.menu.scale(v)
	return ScrH() * (v / 900)
end

surface.CreateFont("SAM.MenuPages", {
	font = "Roboto Regular",
	size = sam.menu.scale(13),
	weight = 500,
	antialias = true,
})

sam.menu.tabs = {}

function sam.menu.add_tab(name, func, check, pos)
	local tab = {
		name = name,
		func = func,
		check = check,
		pos = pos
	}
	for k, v in ipairs(sam.menu.tabs) do
		if v.name == name then
			sam.menu.tabs[k] = tab
			return
		end
	end
	table.insert(sam.menu.tabs, tab)
end

function sam.menu.remove_tab(name)
	for k, v in ipairs(sam.menu.tabs) do
		if v.name == name then
			table.remove(sam.menu.tabs, k)
			break
		end
	end
end

local TDLib = sam.TDLib

local sam_menu
function sam.menu.open_menu()
	if IsValid(sam_menu) then
		return sam_menu:SetVisible(not sam_menu:IsVisible())
	end

	TDLib.Start()

	local frame = vgui.Create("SAM.Frame")
	frame:MakePopup()

	function frame.close.DoClick()
		frame:Hide()
	end

	sam_menu = frame

	local sheets = {}

	local sheet = frame:Add("SAM.PropertySheet")
	sheet:Dock(FILL)
	sheet:DockMargin(4, 4, 4, 4)

	for _, v in SortedPairsByMemberValue(sam.menu.tabs, "pos") do
		sheets[v.name] = sheet:AddSheet(v.name, v.func)
	end

	function frame:Think()
		for _, v in ipairs(sam.menu.tabs) do
			local tab = sheets[v.name]
			if v.check and not v.check() then
				if tab:IsVisible() then
					tab:SetVisible(false)
					if sheet:GetActiveTab() == tab then
						sheet:SetActiveTab(sheets.Commands)
					end
					sheet.tab_scroller:InvalidateLayout(true)
				end
			else
				if not tab:IsVisible() then
					tab:SetVisible(true)
					sheet.tab_scroller:InvalidateLayout(true)
				end
			end
		end
	end

	TDLib.End()
end

function sam.menu.get()
	return sam_menu
end

hook.Add("GUIMouseReleased", "SAM.CloseMenu", function(mouse_code)
	local panel = vgui.GetHoveredPanel()
	if mouse_code == MOUSE_LEFT and panel == vgui.GetWorldPanel() and IsValid(sam_menu) and sam_menu:HasHierarchicalFocus() then
		sam_menu:Hide()
	end
end)

do
	surface.CreateFont("SAM.MenuLoading", {
		font = "Roboto",
		size = sam.menu.scale(26),
		weight = 500,
		antialias = true,
	})

	function sam.menu.add_loading_panel(parent)
		local is_loading = false

		local loading_panel = parent:Add("Panel")
		loading_panel:Hide()
		loading_panel:SetZPos(999999)

		function loading_panel:Paint(w, h)
			draw.RoundedBox(3, 0, 0, w, h, Color(50, 50, 50, 200))
			draw.SimpleText(string.rep(".", (CurTime() * 1.3) % 3), "SAM.MenuLoading", w/2, h/2, Color(200, 200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		parent:SAM_TDLib()
		parent:On("PerformLayout", function(s, w, h)
			loading_panel:SetSize(w, h)
		end)

		local toggle_loading = function(bool)
			is_loading = bool or not is_loading
			loading_panel:SetVisible(is_loading)
		end

		return toggle_loading, function()
			return is_loading
		end
	end
end

for _, f in ipairs(file.Find("sam/menu/tabs/*.lua", "LUA")) do
	include("sam/menu/tabs/" .. f)
end