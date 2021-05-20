surface.CreateFont("SAM.Tabs", {
	font = "Roboto Regular",
	size = sam.menu.scale(17),
	weight = 200,
	antialias = true,
})

local Panel = {}

function Panel:Init()
	self.items = {}

	local tab_scroller = self:Add("DHorizontalScroller")
	tab_scroller:Dock(TOP)
	tab_scroller:SetTall(sam.menu.scale(26))

	self.tab_scroller = tab_scroller
end

local tab_bg = Color(60, 60, 60, 200)
local tab_text = Color(150, 150, 150)
local tab_active = Color(65, 185, 255)
local tab_Paint = function(s, w, h)
	surface.SetDrawColor(tab_bg)
	surface.DrawRect(0, 0, w, h)

	if s.property_sheet:GetActiveTab() == s then
		s:SetTextColor(tab_active)
		draw.RoundedBox(0, 0, h - 1, w, 1, tab_active)
	else
		s:SetTextColor(tab_text)
	end
end

function Panel:AddSheet(name, load_func)
	local tab = vgui.Create("DButton")
	tab:SetFont("SAM.Tabs")
	tab:SetText(name)
	tab:SetTextInset(10, 0)
	tab:SizeToContents()
	tab.Paint = tab_Paint

	function tab.DoClick()
		self:SetActiveTab(tab)
	end

	tab.load_func = load_func
	tab.property_sheet = self

	self.tab_scroller:AddPanel(tab)

	if not self:GetActiveTab() then
		self:SetActiveTab(tab)
	end

	return tab
end

function Panel:GetActiveTab()
	return self.active_tab
end

function Panel:SetActiveTab(new_tab)
	if not IsValid(new_tab.panel) then
		local panel = new_tab.load_func()
		panel:SetParent(self)
		panel:SetVisible(false)

		panel.tab = new_tab
		new_tab.panel = panel
	end

	if self.active_tab and IsValid(self.active_tab.panel) then
		self.active_tab.panel:SetVisible(false)
	end

	new_tab.panel:SetVisible(true)
	self.active_tab = new_tab
end

vgui.Register("SAM.PropertySheet", Panel, "Panel")