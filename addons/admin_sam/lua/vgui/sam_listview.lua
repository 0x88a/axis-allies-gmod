surface.CreateFont("SAM.ListViewColumn", {
	font = "Roboto Regular",
	size = sam.menu.scale(15),
	weight = 200,
	antialias = true,
})

surface.CreateFont("SAM.ListViewLine", {
	font = "Roboto Regular",
	size = sam.menu.scale(14),
	weight = 200,
	antialias = true,
})

-- ListViewDraggerBar
do
	local Panel = {}

	function Panel:Init()
		self:SetCursor("sizewe")
		self:SetText("")
		self:SAM_TDLib()
			:ClearPaint()
			:Background(Color(50, 50, 50))
	end

	function Panel:OnCursorMoved()
		if self.Depressed then
			local column = self:GetParent()
			local x = column:CursorPos()
			if x == column:GetWide() then return end
			column:ResizeColumn(x)
		end
	end

	vgui.Register("SAM.ListViewColumnDraggerBar", Panel, "DButton")
end

-- ListViewColumn
do
	local Panel = {}

	function Panel:Init()
		self:Dock(LEFT)
		self:SetFont("SAM.ListViewColumn")
		self:SetTextColor(Color(200, 200, 200))
		self:SAM_TDLib()
			:ClearPaint()
			:Background(Color(255, 255, 255, 10))

		self.dragger_bar = self:Add("SAM.ListViewColumnDraggerBar")
	end

	function Panel:ResizeColumn(size, right)
		self:GetParent():GetParent():OnRequestResize(self, size)
	end

	function Panel:PerformLayout()
		self.dragger_bar:SetWide(2)
		self.dragger_bar:StretchToParent(nil, 0, nil, 0)
		self.dragger_bar:AlignRight()
	end

	vgui.Register("SAM.ListViewColumn", Panel, "DButton")
end

-- ListViewLine
do
	local Panel = {}

	function Panel:Init()
		self:Dock(TOP)
		self:SetText("")

		self:SAM_TDLib()
			:ClearPaint()
			:Background(Color(255, 255, 255, 18))
			:On("Paint", self.OnSelected)
			:FadeHover(Color(255, 255, 255, 30), nil, nil, self.is_hovered)
	end

	function Panel:DoClick()
		self.list_view:OnClickLine(self, true)
	end

	function Panel:OnCursorMoved()
		if input.IsMouseDown(MOUSE_LEFT) then
			self.list_view:OnClickLine(self)
		end
	end

	function Panel:DoRightClick()
		if not self.selected then
			self.list_view:OnClickLine(self, true)
		end
		self.list_view:OnRowRightClick(self.id, self)
	end

	function Panel:GetColumnText(column)
		local childs = self:GetChildren()
		return childs[column]:GetText()
	end

	function Panel:OnRemove()
		local lines = self.list_view.lines
		table.remove(lines, self.id)
		for k, v in ipairs(lines) do
			v.id = k
		end
		self.list_view:OnRowSelected()
	end

	function Panel:is_hovered()
		return self:IsHovered() and not self.selected
	end

	local accent = Color(65, 185, 255, 100)
	function Panel:OnSelected(w, h)
		if self.selected then
			surface.SetDrawColor(accent)
			surface.DrawRect(0, 0, w, h)
		end
	end

	vgui.Register("SAM.ListViewLine", Panel, "DButton")
end

local Panel = {}

AccessorFunc(Panel, "m_bHeaderHeight", "HeaderHeight")
AccessorFunc(Panel, "m_bDataHeight", "DataHeight")
AccessorFunc(Panel, "m_bMultiSelect", "MultiSelect")

function Panel:Init()
	self:SetHeaderHeight(sam.menu.scale(20))
	self:SetDataHeight(sam.menu.scale(18))
	self:SetMultiSelect(false)

	local columns = self:Add("Panel")
	columns:Dock(TOP)
	self.columns = columns

	local canvas = self:Add("SAM.ScrollPanel")
	canvas:Dock(FILL)
	self.canvas = canvas

	self.lines = {}
	self.line_max = 0
end

function Panel:AddColumn(column_name, wide)
	local columns = self.columns:GetChildren()
	if #columns > 0 then
		columns[#columns].dragger_bar:Show()
	end

	local column = self.columns:Add("SAM.ListViewColumn")
	column:SetText(column_name)
	column.dragger_bar:Hide()

	if wide then
		column.wide = wide
		column:SetWide(wide)
	end

	self.column_added = true
	self:InvalidateLayout(true)
end

function Panel:OnClickLine(line, clear)
	local multi_select = self:GetMultiSelect()
	if not multi_select and not clear then return end

	if multi_select and input.IsKeyDown(KEY_LCONTROL) then
		if line.selected then
			line.selected = false
			self.main_selected_line = nil
			self:OnRowSelected()
			return
		end
		clear = false
	end

	if multi_select and input.IsKeyDown(KEY_LSHIFT) then
		local selected = self:GetSelectedLine()
		if selected then
			self.main_selected_line = self.main_selected_line or selected

			if clear then
				self:ClearSelection()
			end

			local first = math.min(self.main_selected_line.id, line.id)
			local last = math.max(self.main_selected_line.id, line.id)

			for id = first, last do
				local line_2 = self.lines[id]
				local was_selected = line_2.selected

				line_2.selected = true

				if not was_selected then
					self:OnRowSelected(line_2.id, line_2)
				end
			end

			return
		end
	end

	if not multi_select or clear then
		self:ClearSelection()
	end

	line.selected = true

	self.main_selected_line = line
	self:OnRowSelected(line.id, line)
end

function Panel:OnRequestResize(sizing_column, size)
	local passed, a_column = false, nil, false

	local get_right = size > sizing_column:GetWide()

	for k, column in ipairs(self.columns:GetChildren()) do
		if passed then
			if right and column:GetWide() == 15 then continue end
			a_column = column
			break
		end

		if sizing_column == column then
			passed = true
		end
	end

	if get_right then
		if a_column then
			local size_change = sizing_column:GetWide() - size
			size_change = a_column:GetWide() + size_change
			if size_change <= 15 then return end
			a_column:SetWide(size_change)
		end
		sizing_column:SetWide(size)
	else
		if size <= 15 then return end
		if a_column then
			local size_change = sizing_column:GetWide() - size
			a_column:SetWide(a_column:GetWide() + size_change)
		end
		sizing_column:SetWide(size)
	end

	self:InvalidateLayout(true)
end

function Panel:GetSelected()
	local ret = {}
	for _, v in ipairs(self.lines) do
		if v.selected then
			table.insert(ret, v)
		end
	end
	return ret
end

function Panel:GetSelectedLine()
	for _, line in ipairs(self.lines) do
		if line.selected then return line end
	end
end

function Panel:GetSortedID(line)
	for k, v in ipairs(self.lines) do
		if v == line then return k end
	end
end

function Panel:ClearSelection()
	for _, line in pairs(self.lines) do
		line.selected = false
	end
end

function Panel:AddLine(...)
	local line = self.canvas:Add("SAM.ListViewLine")
	line:SetTall(self:GetDataHeight())

	for k, v in ipairs({...}) do
		local child = line:Add("DLabel")
		child:Dock(LEFT)
		child:SetFont("SAM.ListViewLine")
		child:SetText(v)
		child:SetTextInset(8, 0)

		self.line_max = math.max(k, self.line_max)
	end

	line.list_view = self
	line.id = table.insert(self.lines, line)

	self:InvalidateLayout(true)

	return line
end

function Panel:PerformLayout(w, h)
	local columns = self.columns
	columns:SetTall(self:GetHeaderHeight())

	columns = columns:GetChildren()

	if self.column_added or (self.last_w and self.last_w ~= w) then
		local w, _columns = w, 0

		self.column_added = nil

		for _, _column in ipairs(columns) do
			if _column.wide then
				w = w - _column.wide
			else
				_columns = _columns + 1
			end
		end

		local new_wide = math.Round(w / _columns)

		for _, _column in ipairs(columns) do
			if not _column.wide then
				_column:SetWide(new_wide)
			end
		end
	end

	if #columns == 0 then
		local wide = math.Round(w / self.line_max)
		for _, line in ipairs(self.lines) do
			for _, child in ipairs(line:GetChildren()) do
				child:SetWide(wide)
			end
		end
	else
		for _, line in ipairs(self.lines) do
			for id, child in ipairs(line:GetChildren()) do
				child:SetWide(columns[id]:GetWide())
			end
		end
	end

	self.last_w = w
end

function Panel:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 200))
end

function Panel:OnRowSelected()
end

function Panel:OnRowRightClick()
end

function Panel:Clear()
	for k, v in ipairs(self.lines) do
		v:Remove()
	end
end

vgui.Register("SAM.ListView", Panel, "Panel")