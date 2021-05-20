surface.CreateFont("SAM.CommandsTabs", {
	font = "Roboto",
	size = sam.menu.scale(15),
	weight = 200,
	antialias = true,
})

surface.CreateFont("SAM.CommandsItems", {
	font = "Roboto",
	size = sam.menu.scale(14),
	weight = 200,
	antialias = true,
})

local Panel = {}

function Panel:Init()
	self.items = {}
	self.categories = {}
	self:SAM_TDLib()
		:Background(Color(60, 60, 60, 200))
end

function Panel:select_item(item)
	if self.selected_item ~= item then
		if IsValid(self.selected_item) then
			self.selected_item.selected = false
		end
		item.selected = true
		self.selected_item = item
		self:item_selected(item)
	end
end

function Panel:item_selected()
end

local item_DoClick = function(s)
	s.category:GetParent():GetParent():select_item(s)
end

local item_hover = function(s)
	return s:IsHovered() and not s.selected
end

local item_OnRemove = function(s)
	local category = s.category
	local parent = category:GetParent():GetParent()

	local items = category.items

	for k, v in ipairs(items) do
		if v == s then
			table.remove(items, k)
			break
		end
	end

	for k, v in ipairs(parent.items) do
		if v == s then
			table.remove(parent.items, k)
			break
		end
	end

	if #items == 0 then
		category:Remove()
		parent.categories[category.name] = nil
	end
end

local accent = Color(65, 185, 255, 100)
local item_selected = function(s, w, h)
	if s.selected then
		surface.SetDrawColor(accent)
		surface.DrawRect(0, 0, w, h)
	end
end

function Panel:get_category(name)
	local category = self.categories[name]
	if not category then
		category = self:Add("Panel")
		category:Dock(TOP)
		category:DockMargin(0, 0, 0, 1)
		category.name = name

		category.items = {}
		category.expanded = false

		local parent = self
		function category:SetExpanded(expanded)
			if category.expanded == expanded then return end
			if sam.isbool(expanded) then
				category.expanded = expanded
			else
				category.expanded = not category.expanded
			end
			if category.expanded then
				parent:OnCategoryExpanded(category)
			end
			category:InvalidateLayout(true)
		end

		local header = category:Add("DButton")
		header:Dock(TOP)
		header:SetFont("SAM.CommandsTabs")
		header:SetText(name)
		header:SetTextColor(Color(200, 200, 200))
		header:SizeToContents()

		header:SAM_TDLib()
			:ClearPaint()
			:Background(Color(255, 255, 255, 10))

		header.DoClick = category.SetExpanded

		function category:PerformLayout()
			local h
			if self.expanded then
				local _
				_, h = self:ChildrenSize()
			else
				h = header:GetTall()
			end
			if self.h ~= h then
				self:Stop()
				self:SizeTo(-1, h, 0.15)
				self.h = h
			end
		end

		self.categories[name] = category

		category:SetTall(header:GetTall())
		category:SetExpanded(false)
		category.header = header
	end
	return category
end

function Panel:add_item(name, category_name)
	local category = self:get_category(category_name)

	if sam.ispanel(name) then
		name:SetParent(category)
		name:Dock(TOP)
		name.category = category
		return name
	end

	local item = category:Add("DButton")
	item:Dock(TOP)
	item:SetFont("SAM.CommandsItems")
	item:SetText(name)
	item:SetTextColor(Color(200, 200, 200))
	item:SizeToContents()

	item:SAM_TDLib()
		:ClearPaint()
		:Background(Color(255, 255, 255, 18))
		:On("Paint", item_selected)
		:FadeHover(Color(255, 255, 255, 30), nil, nil, item_hover)

	item.OnRemove = item_OnRemove
	item.DoClick = item_DoClick
	item.category = category

	table.insert(self.items, item)
	table.insert(category.items, item)

	return item
end

function Panel:OnCategoryExpanded(category)
end

vgui.Register("SAM.CollapseCategory", Panel, "SAM.ScrollPanel")