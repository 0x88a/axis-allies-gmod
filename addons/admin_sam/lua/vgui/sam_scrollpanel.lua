local Panel = {}

function Panel:Init()
	self.VBar:SetHideButtons(true)
	self.VBar:SetWide(sam.menu.scale(5))

	local vbar_color = Color(0, 0, 0, 100)
	function self.VBar:Paint(w, h)
		draw.RoundedBox(2, 0, 0, w, h, vbar_color)
	end

	local grip_color = Color(65, 185, 255)
	function self.VBar.btnGrip:Paint(w, h)
		draw.RoundedBox(2, 0, 0, w, h, grip_color)
	end
end

function Panel:PerformLayout()
	local tall = self.pnlCanvas:GetTall()
	local wide = self:GetWide()

	self:Rebuild()

	self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
	local y_pos = self.VBar:GetOffset()

	if self.VBar.Enabled then
		wide = wide - self.VBar:GetWide() - 1
	end

	self.pnlCanvas:SetPos(0, y_pos)
	self.pnlCanvas:SetWide(wide)

	self:Rebuild()

	if tall != self.pnlCanvas:GetTall() then
		self.VBar:SetScroll(self.VBar:GetScroll())
	end
end

vgui.Register("SAM.ScrollPanel", Panel, "DScrollPanel")