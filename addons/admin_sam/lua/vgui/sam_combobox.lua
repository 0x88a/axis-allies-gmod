surface.CreateFont("SAM.ComboBox", {
	font = "Roboto Regular",
	size = sam.menu.scale(13),
	weight = 200,
	antialias = true,
})

local Panel = {}

function Panel:Init()
	self:SetFont("SAM.ComboBox")
	self:SetTextColor(Color(210, 210, 210))
	self:SetTall(sam.menu.scale(22))
	self:SetSortItems(false)
end

function Panel:PerformLayout()
	self.DropButton:SetSize(sam.menu.scale(15), sam.menu.scale(15))
	self.DropButton:AlignRight(4)
	self.DropButton:CenterVertical()
end

local bg = Color(255, 255, 255, 10)
local disabled = Color(0, 0, 0, 100)
function Panel:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, bg)

	if not self:IsMouseInputEnabled() then
		draw.RoundedBox(0, 0, 0, w, h, disabled)
	end
end

function Panel:SetDisabled(bool)
	self:SetMouseInputEnabled(not bool)
end

vgui.Register("SAM.ComboBox", Panel, "DComboBox")
