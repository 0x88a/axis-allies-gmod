surface.CreateFont("SAM.TextEntry", {
	font = "Roboto Regular",
	size = sam.menu.scale(13),
	weight = 200,
	antialias = true,
})

local Panel = {}

AccessorFunc(Panel, "m_bHint", "Hint", FORCE_STRING)
AccessorFunc(Panel, "m_bBackgroundColor", "BackgroundColor")
AccessorFunc(Panel, "m_bEditable", "Editable", FORCE_BOOL)

function Panel:Init()
	self:SetBackgroundColor(Color(255, 255, 255, 10))

	self:SetTall(sam.menu.scale(20))
	self:SetFont("SAM.TextEntry")
	self:SetUpdateOnType(true)

	self:SetHint("")
	self.allowed_numeric_characters = "1234567890.-"
	self:SetEditable(true)
end

function Panel:DisallowFloats(disallow)
	if not sam.isbool(disallow) then
		disallow = true
	end

	if disallow then
		self.allowed_numeric_characters = self.allowed_numeric_characters:gsub("%.", "", 1)
	elseif not string.find(self.allowed_numeric_characters, ".", 1, true) then
		self.allowed_numeric_characters = self.allowed_numeric_characters .. "."
	end
end

function Panel:DisallowNegative(disallow)
	if not sam.isbool(disallow) then
		disallow = true
	end

	if disallow then
		self.allowed_numeric_characters = self.allowed_numeric_characters:gsub("%-", "", 1)
	elseif not string.find(self.allowed_numeric_characters, "-", 1, true) then
		self.allowed_numeric_characters = self.allowed_numeric_characters .. "-"
	end
end

function Panel:CheckNumeric(value)
	if not self:GetNumeric() then return false end

	if not string.find(self.allowed_numeric_characters, value, 1, true) then
		return true
	end

	local new_value = ""
	local current_value = tostring(self:GetValue())

	local caret_pos = self:GetCaretPos()
	for i = 0, #current_value do
		new_value = new_value .. current_value:sub(i, i)
		if i == caret_pos then
			new_value = new_value .. value
		end
	end

	if #current_value ~= 0 and not tonumber(new_value) then
		return true
	end

	return false
end

function Panel:SetBackgroundColor(color)
	self.m_bBackgroundColor = IsColor(color) and color or Color(255, 255, 255, 10)
end

local old_editable = Panel.SetEditable
function Panel:SetEditable(b)
	old_editable(self, b)
	self:SetKeyboardInputEnabled(self:GetEditable())
	self:SetMouseInputEnabled(self:GetEditable())
end

local text = Color(210, 210, 210)
local disabled, disabled_2 = Color(210, 210, 210, 180), Color(0, 0, 0, 100)
local highlight = Color(20, 200, 250, 255)
local cursor = Color(210, 210, 210)
local hint = Color(165, 165, 165)
function Panel:Paint(w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(0, 0, w, h)

	if self:GetText() == "" then
		draw.SimpleText(self:GetHint(), "SAM.TextEntry", 4, h / 2, hint, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	if not self:GetEditable() then
		self:DrawTextEntryText(disabled, highlight, cursor)
		surface.SetDrawColor(disabled_2)
		surface.DrawRect(0, 0, w, h)
	else
		self:DrawTextEntryText(text, highlight, cursor)
	end
end

vgui.Register("SAM.TextEntry", Panel, "DTextEntry")