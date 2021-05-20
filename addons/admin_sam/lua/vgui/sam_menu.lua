local TDLib = sam.TDLib

local Panel = {}

function Panel:Init()
	TDLib.Start()

	self:SetSize(sam.menu.scale(520), sam.menu.scale(364))
	self:Center()

	self:Blur()
		:Background(Color(30, 30, 30, 240))

	local header = self:Add("Panel")
	header:Dock(TOP)
	header:SetTall(sam.menu.scale(27))
	header:Background(Color(60, 60, 60, 200))
	header:SetCursor("sizeall")

	function header.Think(s)
		local w, h = ScrW(), ScrH()

		local x = self.x
		local y = self.y

		if x < 5 then
			self.x = 5
		end

		if y < 5 then
			self.y = 5
		end

		local wide = w - self:GetWide() - 5
		if x > wide then
			self.x = wide
		end

		local t = h - self:GetTall() - 5
		if y > t then
			self.y = t
		end

		if s.dragging then
			local mousex = math.Clamp(gui.MouseX(), 1, w - 1)
			local mousey = math.Clamp(gui.MouseY(), 1, h - 1)

			x = mousex - s.dragging[1]
			y = mousey - s.dragging[2]

			self:SetPos(x, y)
			self:InvalidateLayout(true)
		end
	end

	function header.OnMousePressed(s)
		s.dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}
		s:MouseCapture(true)
	end

	function header:OnMouseReleased()
		self.dragging = nil
		self:MouseCapture(false)
	end

	self.header = header

	local close = header:Add("DButton")
	close:SetText("")
	close:Dock(RIGHT)
	close:DockMargin(0, 4, 4, 4)
	close:InvalidateParent(true)
	close:SetWide(close:GetTall())

	self.close = close

	local circle = {}
	local mat = Material("materials/sam/close.png", "noclamp smooth")

	local bg = Color(200, 200, 200)
	local hover = Color(255, 60, 60)
	local press = Color(255, 255, 255, 30)

	function close:Paint(w, h)
		if self:IsHovered() then
			sam.TDLib.DrawCircle(circle, w / 2, h / 2, w / 2, hover)
		end
		if self.Depressed then
			sam.TDLib.DrawCircle(circle, w / 2, h / 2, w / 2, press)
		end
		surface.SetDrawColor(bg)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectRotated(w / 2, h / 2, w / 1.42, h / 1.42, 0)
	end

	function close.DoClick()
		self:Remove()
	end

	TDLib.End()
end

vgui.Register("SAM.Frame", Panel, "EditablePanel")