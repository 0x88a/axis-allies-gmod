if SAM_LOADED then return end

local sam, command = sam, sam.command

local url = sam.config.MOTD_URL
if not url or url == "" then return end

command.set_category("Menus")

sam.command.new("motd")
	:Help("Open MOTD menu")
	:OnExecute(function(ply)
		sam.netstream.Start(ply, "OpenMOTD")
	end)
:End()

if CLIENT then
	local motd
	function sam.menu.open_motd()
		if IsValid(motd) then
			return motd:SetVisible(not motd:IsVisible())
		end

		motd = vgui.Create("SAM.Frame")
		motd:Dock(FILL)
		motd:DockMargin(40, 40, 40, 40)
		motd:MakePopup()

		function motd.close.DoClick()
			motd:Hide()
		end

		local html = motd:Add("DHTML")
		html:Dock(FILL)
		html:OpenURL(url)
	end

	sam.netstream.Hook("OpenMOTD", function()
		sam.menu.open_motd()
	end)

	hook.Add("HUDPaint", "SAM.OpenMOTD", function()
		sam.menu.open_motd()
		hook.Remove("HUDPaint", "SAM.OpenMOTD")
	end)
end