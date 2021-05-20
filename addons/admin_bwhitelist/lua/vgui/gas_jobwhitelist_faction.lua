local PANEL = {}

function PANEL:Init()
	self:SetSize(128 + 20, 128 + 20 + 10 + 14)
	self:DockPadding(10,10,10,10)

	self:SetLoading(true)

	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.Image = self.Image or vgui.Create("DImage", self)
	self.Image:SetSize(128,128)
	self.Image:SetPos(10,10)

	self.r = 0
	self.g = 0
	self.b = 0
end

file.CreateDir("gas_jobwhitelist_faction_imgs")
function PANEL:SetImage(url)
	local crc = util.CRC(os.date("%d%m%Y") .. url) .. ".png"

	GAS.JobWhitelist.Factions.ImageCRCs[crc] = true

	if (file.Exists("gas_jobwhitelist_faction_imgs/" .. crc, "DATA")) then
		self.Image:SetMaterial(Material("data/gas_jobwhitelist_faction_imgs/" .. crc))
	else
		http.Fetch(url, function(body, size, headers, code)
			if (body:find("^.PNG")) then
				file.Write("gas_jobwhitelist_faction_imgs/" .. crc, body)
				self.Image:SetMaterial(Material("data/gas_jobwhitelist_faction_imgs/" .. crc))
			else
				GAS:print("[JobWhitelist Factions] Faction image is not a PNG, from: " .. url, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
			end
		end, function()
			GAS:print("[JobWhitelist Factions] Failed to get faction image from " .. url, GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_FAIL)
		end)
	end
end

function PANEL:SetName(name)
	self.Label = self.Label or vgui.Create("DLabel", self)
	self.Label:Dock(BOTTOM)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 14))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(name)
	self.Label:SizeToContents()
	self.Label:SetContentAlignment(5)
end

function PANEL:SetDescription(description)
	self.Description = description
end

function PANEL:OnCursorEntered()
	surface.PlaySound(GAS.JobWhitelist.Factions.Config.OnHoverSound)
	if (IsValid(GAS.JobWhitelist.Factions.Menu.Description)) then
		GAS.JobWhitelist.Factions.Menu.Description:Update(self.Description)
	end
end
function PANEL:OnCursorExited()
	if (IsValid(GAS.JobWhitelist.Factions.Menu.Description)) then
		GAS.JobWhitelist.Factions.Menu.Description:Update(GAS.JobWhitelist.Factions.Config.HelpText)
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self.MOUSE_LEFT = true
	end
end
function PANEL:OnMouseReleased(m)
	if (m == MOUSE_LEFT) then
		if (self.MOUSE_LEFT) then
			self.MOUSE_LEFT = nil
			if (self.DoClick) then
				self:DoClick()
			end
		end
	end
end

function PANEL:Paint(w,h)
	if (self:IsHovered()) then
		self.r, self.g, self.b = Lerp(0.05, self.r, 50), Lerp(0.05, self.g, 50), Lerp(0.05, self.b, 50)
	else
		self.r, self.g, self.b = Lerp(0.05, self.r, 0), Lerp(0.05, self.g, 0), Lerp(0.05, self.b, 0)
	end
	surface.SetDrawColor(self.r, self.g, self.b, 100)
	surface.DrawRect(0,0,w,h)
end

derma.DefineControl("GAS.JobWhitelist.Faction", nil, PANEL, "bVGUI.LoadingPanel")