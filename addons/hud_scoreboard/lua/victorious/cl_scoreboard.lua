hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
hook.Remove("ScoreboardShow", "FAdmin_scoreboard")

hook.Add("Initialize", "RemoveGamemodeFunctions", function()
    GAMEMODE.ScoreboardShow = nil
    GAMEMODE.ScoreboardHide = nil
end)

local scoreboard

local function DrawBlurRect(x, y, w, h, amount, density)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(VictoriousScoreboardConfig.blur)

    for i = 1, density do
		VictoriousScoreboardConfig.blur:SetFloat("$blur", (i / 3) * (amount or 6))
        VictoriousScoreboardConfig.blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end

local function LerpColor(t, from, to)
    return Color(
        Lerp(t, from.r, to.r),
        Lerp(t, from.g, to.g),
        Lerp(t, from.b, to.b),
        Lerp(t, from.a, to.a)
    )
end

local scrollW = 500
local adminWidth = 205

local function CreatePlayerPanel(ply)
	local panel = vgui.Create("DPanel")//scrollpanel:Add("DPanel")
	panel:SetSize(scrollW * 2 + adminWidth, 36)
	//panel:SetPos(scoreboard:GetWide() / 2 - 215, k * 39 - 39)
	//panel:SetPos(0, k * 39 - 39)
	//panel:SetPos(0, k * 39 - 39)
	panel:SetPlayer(ply)
	local profilebutton = panel:Add("DButton")
	profilebutton:SetPos(205, 2)
	profilebutton:SetSize(32, 32)
	profilebutton:SetPlayer(ply)

	profilebutton.DoClick = function()
		ply:ShowProfile()
		surface.PlaySound("buttons/button9.wav")
	end

	local steambutton = panel:Add("DButton")
	steambutton:SetPos(243, 2)
	steambutton:SetSize(145 + VictoriousScoreboardConfig.namemax, 32)
	steambutton:SetText("")
	steambutton:SetTooltip(string.format(VictoriousScoreboardConfig.CopySteamIDText, ply:Nick(), ply:SteamID()))
	steambutton:SetPlayer(ply)
	steambutton.Color = VictoriousScoreboardConfig.white
	steambutton.text = string.upper(ply:Nick() or "")
	steambutton.Paint = function(self, w, h)
		local nextColor = VictoriousScoreboardConfig.white
		if self.Depressed then
			nextColor = VictoriousScoreboardConfig.grey
		elseif self.Hovered then
			nextColor = VictoriousScoreboardConfig.hover
		end

		self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

		surface.SetDrawColor(self.Color)

		draw.DrawText(self.text, "player", 3, 6, self.Color)
	end

	steambutton.DoClick = function()
		SetClipboardText(ply:SteamID())
		surface.PlaySound("buttons/button9.wav")
	end

	local group = ply:GetUserGroup()
	local AdminButtons = false
	
	if LocalPlayer():IsAdmin() or table.HasValue(VictoriousScoreboardConfig.groups, ply:GetUserGroup()) then
		local adminbutton = panel:Add("DButton")
		adminbutton:SetPos(180, 2)
		adminbutton:SetSize(25, 32)
		adminbutton:SetText("")
		adminbutton:SetPlayer(ply)
		adminbutton.Color = VictoriousScoreboardConfig.white

		adminbutton.Paint = function(self, w, h)
			local nextColor = VictoriousScoreboardConfig.white
			if self.Depressed then
				nextColor = VictoriousScoreboardConfig.grey
			elseif self.Hovered then
				nextColor = VictoriousScoreboardConfig.hover
			end

			self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

			surface.SetDrawColor(self.Color)
			surface.SetMaterial(VictoriousScoreboardConfig.cog)
			surface.DrawTexturedRect(0, 7, 16, 16)
		end

		adminbutton.DoClick = function()
			surface.PlaySound("buttons/button9.wav")

			if !AdminButtons then
				local gotobutton = panel:Add("DButton")
				gotobutton:SetPos(140, 2)
				gotobutton:SetSize(40, 32)
				gotobutton:SetText("")
				gotobutton:SetPlayer(ply)
				gotobutton.Color = Color(255, 255, 255, 0)
				adminbutton.gotobutton = gotobutton

				gotobutton.Paint = function(self, w, h)
					local nextColor = VictoriousScoreboardConfig.white
					local text = ""
					if self.Depressed then
						nextColor = VictoriousScoreboardConfig.grey
						text = VictoriousScoreboardConfig.GotoText
					elseif self.Hovered then
						nextColor = VictoriousScoreboardConfig.hover
						text = VictoriousScoreboardConfig.GotoText
					end

					self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

					surface.SetDrawColor(self.Color)
					surface.SetMaterial(VictoriousScoreboardConfig.tele)
					surface.DrawTexturedRect(6, 5, 20, 20)
					draw.DrawText(text, "player", w / 2 - 5, 4, VictoriousScoreboardConfig.white, TEXT_ALIGN_CENTER)
				end

				gotobutton.DoClick = function()
					VictoriousScoreboardConfig.AdminMod[VictoriousScoreboardConfig.DefaultAdminMod].Goto(ply)
					surface.PlaySound("buttons/button9.wav")
				end


				/*
				local kickbutton = panel:Add("DButton")
				kickbutton:SetPos(104, 3)
				kickbutton:SetSize(40, 32)
				kickbutton:SetText("")
				kickbutton:SetPlayer(ply)
				kickbutton.Color = Color(255, 255, 255, 0)
				adminbutton.kickbutton = kickbutton

				kickbutton.Paint = function(self, w, h)
					local nextColor = VictoriousScoreboardConfig.white
					local text = ""
					if self.Depressed then
						nextColor = VictoriousScoreboardConfig.grey
						text = VictoriousScoreboardConfig.KickText
					elseif self.Hovered then
						nextColor = VictoriousScoreboardConfig.hover
						text = VictoriousScoreboardConfig.KickText
					end

					self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

					surface.SetDrawColor(self.Color)
					surface.SetMaterial(VictoriousScoreboardConfig.kick)
					surface.DrawTexturedRect(3, 3, 22, 22)
					draw.DrawText(text, "player", w / 2 - 7, 4, VictoriousScoreboardConfig.white, TEXT_ALIGN_CENTER)
				end

				kickbutton.DoClick = function()
					VictoriousScoreboardConfig.AdminMod[VictoriousScoreboardConfig.DefaultAdminMod].kick(ply,  VictoriousScoreboardConfig.kreason)
					surface.PlaySound("buttons/button9.wav")
				end
				
				local banbutton = panel:Add("DButton")
				banbutton:SetPos(64, 3)
				banbutton:SetSize(40, 32)
				banbutton:SetText("")
				banbutton:SetPlayer(ply)
				banbutton.Color = Color(255, 255, 255, 0)
				adminbutton.banbutton = banbutton

				banbutton.Paint = function(self, w, h)
					local nextColor = VictoriousScoreboardConfig.white
					local text = ""
					if self.Depressed then
						nextColor = VictoriousScoreboardConfig.grey
						text = VictoriousScoreboardConfig.BanText
					elseif self.Hovered then
						nextColor = VictoriousScoreboardConfig.hover
						text = VictoriousScoreboardConfig.BanText
					end

					self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

					surface.SetDrawColor(self.Color)
					surface.SetMaterial(VictoriousScoreboardConfig.ban)
					surface.DrawTexturedRect(3, 5, 20, 20)
					draw.DrawText(text, "player", w / 2 - 8, 4, VictoriousScoreboardConfig.white, TEXT_ALIGN_CENTER)
				end

				banbutton.DoClick = function()
					VictoriousScoreboardConfig.AdminMod[VictoriousScoreboardConfig.DefaultAdminMod].ban(ply, VictoriousScoreboardConfig.bantime,  string.format(VictoriousScoreboardConfig.breason, VictoriousScoreboardConfig.bantime))
					surface.PlaySound("buttons/button9.wav")
				end
				*/
				
				local jailbutton = panel:Add("DButton")
				jailbutton:SetPos(104, 3)
				jailbutton:SetSize(40, 32)
				jailbutton:SetText("")
				jailbutton:SetPlayer(ply)
				jailbutton.Color = Color(255, 255, 255, 0)
				adminbutton.jailbutton = jailbutton

				jailbutton.Paint = function(self, w, h)
					local nextColor = VictoriousScoreboardConfig.white
					local text = ""
					if self.Depressed then
						nextColor = VictoriousScoreboardConfig.grey
						text = VictoriousScoreboardConfig.JailText
					elseif self.Hovered then
						nextColor = VictoriousScoreboardConfig.hover
						text = VictoriousScoreboardConfig.JailText
					end

					self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)

					surface.SetDrawColor(self.Color)
					surface.SetMaterial(VictoriousScoreboardConfig.jail)
					surface.DrawTexturedRect(3, 5, 20, 20)
					draw.DrawText(text, "player", w / 2 - 8, 4, VictoriousScoreboardConfig.white, TEXT_ALIGN_CENTER)
				end

				jailbutton.DoClick = function()
					if VictoriousScoreboardConfig.xadmin then
						VictoriousScoreboardConfig.AdminMod[VictoriousScoreboardConfig.DefaultAdminMod].jail(ply, VictoriousScoreboardConfig.jailtime, VictoriousScoreboardConfig.jreason )
					else
						VictoriousScoreboardConfig.AdminMod[VictoriousScoreboardConfig.DefaultAdminMod].jail(ply)
					end
					surface.PlaySound("buttons/button9.wav")
				end

			else
				if IsValid(adminbutton.gotobutton) then
					adminbutton.gotobutton:Remove()
				end
				if IsValid(adminbutton.kickbutton) then
					adminbutton.kickbutton:Remove()
				end
				if IsValid(adminbutton.banbutton) then
					adminbutton.banbutton:Remove()
				end
				if IsValid(adminbutton.jailbutton) then
					adminbutton.jailbutton:Remove()
				end
			end
			AdminButtons = !AdminButtons
		end
	end

	local avatar = panel:Add("AvatarImage")
	avatar:SetSize(32, 32)
	avatar:SetPos(205, 2)
	avatar:SetPlayer(ply)
	avatar:SetMouseInputEnabled(false)

	avatar.PaintOver = function(self, w, h)
		surface.SetDrawColor(225, 225, 225)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	panel.Paint = function(self, w, h)
		if !IsValid(ply) then
			scoreboard:Update()

			return
		end

		local kills = ply:Frags()
		local deaths = ply:Deaths()
		local ping = ply:Ping()

		if VictoriousScoreboardConfig.UsingDarkRP == true then
			local job = team.GetName(ply:Team())
			if string.len(job) > 25 then job = string.Left(job, 23) .. "..." end
			draw.SimpleText(string.upper(job), "player", 582.5, h / 2, VictoriousScoreboardConfig.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	
		
		local rankSetting = VictoriousScoreboardConfig.showngroups[ply:GetNWString("usergroup", "")]		
		local rankCol = rankSetting and rankSetting.GroupColor or Color(255,255,255)
		local rankName = rankSetting and rankSetting.ShownName or ""


		
		draw.SimpleText(string.upper(rankName), "player", 745, h / 2, rankCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		if table.HasValue(VictoriousScoreboardConfig.commandgroups, group) then
			surface.SetDrawColor(VictoriousScoreboardConfig.white)
			surface.SetMaterial(VictoriousScoreboardConfig.star)
			surface.DrawTexturedRect(720, h / 2 - 8, 16, 16)
		end


		draw.SimpleText(string.upper(kills), "player", 1005, h / 2, VictoriousScoreboardConfig.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(VictoriousScoreboardConfig.white)
		surface.SetMaterial(VictoriousScoreboardConfig.bullets)
		surface.DrawTexturedRect(965, h / 2 - 10, 20, 20)
		draw.SimpleText(string.upper(deaths), "player", 1075, h / 2, VictoriousScoreboardConfig.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(VictoriousScoreboardConfig.white)
		surface.SetMaterial(VictoriousScoreboardConfig.death)
		surface.DrawTexturedRect(1035, h / 2 - 8, 16, 16)
		draw.SimpleText(ping, "player", 1195, h / 2, VictoriousScoreboardConfig.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(200,200,200,20)
		surface.SetMaterial(VictoriousScoreboardConfig.fullping)
		surface.DrawTexturedRect(1145, h / 2 - 5, 20, 20)				
		 
		if ping > 259 then				
			surface.SetDrawColor(VictoriousScoreboardConfig.pingcol1)
			surface.SetMaterial(VictoriousScoreboardConfig.ping1)
			surface.DrawTexturedRect(1145, h / 2 - 5, 20, 20)					
		end

		if ping < 260 then				
			surface.SetDrawColor(VictoriousScoreboardConfig.pingcol2)
			surface.SetMaterial(VictoriousScoreboardConfig.ping2)
			surface.DrawTexturedRect(1145, h / 2 - 5, 20, 20)
			if ping > 259 then 
				VictoriousScoreboardConfig.pingcol2 = Color (0,0,0,0)
			end					
		end 				
		
		if ping < 170 then				
			surface.SetDrawColor(VictoriousScoreboardConfig.pingcol3)
			surface.SetMaterial(VictoriousScoreboardConfig.ping3)
			surface.DrawTexturedRect(1145, h / 2 - 5, 20, 20)
			if ping > 169 then 
				VictoriousScoreboardConfig.pingcol3 = Color (0,0,0,0)
			end					
		end				
		
		if ping < 100 then 
			surface.SetDrawColor(VictoriousScoreboardConfig.pingcol4)
			surface.SetMaterial(VictoriousScoreboardConfig.fullping)
			surface.DrawTexturedRect(1145, h / 2 - 5, 20, 20)
			if ping > 99 then 
				VictoriousScoreboardConfig.pingcol4 = Color (0,0,0,0)
			end
		end				
	end
	return panel
end



local function CreateScoreboard()
    scoreboard = vgui.Create("DFrame")
    scoreboard:SetSize(ScrW(), ScrH())
    scoreboard:SetAlpha(0)
    scoreboard:AlphaTo(255, 0.1)
    scoreboard:Center()
    scoreboard:SetTitle("")
    scoreboard:ShowCloseButton(false)
    scoreboard:SetDraggable(false)
    scoreboard:MakePopup()
    local ply = LocalPlayer()

    scoreboard.Paint = function(self, w, h)
        DrawBlurRect(0, 0, ScrW(), ScrH(), 3, 6)
        surface.SetDrawColor(15,15,15,50)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(VictoriousScoreboardConfig.servertitle, "title", w / 2, 120, VictoriousScoreboardConfig.servertitlc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor( VictoriousScoreboardConfig.white )
        surface.DrawRect(w / 2 - 500, 202, 1000, 2)
        draw.SimpleText(VictoriousScoreboardConfig.NameText, "score", w / 2 - 457, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
        if VictoriousScoreboardConfig.UsingDarkRP then
            draw.SimpleText(VictoriousScoreboardConfig.ClassText, "score", w / 2 - 144, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
		if VictoriousScoreboardConfig.ShowRank then
			draw.SimpleText(VictoriousScoreboardConfig.RankText, "score", w / 2 + 70, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
		draw.SimpleText(VictoriousScoreboardConfig.Kills, "score", w / 2 + 283, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(VictoriousScoreboardConfig.Deaths, "score", w / 2 + 353, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(VictoriousScoreboardConfig.Ping, "score", w / 2 + 455, 185, VictoriousScoreboardConfig.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local scrollpanel = scoreboard:Add("DScrollPanel")
    scrollpanel:Center()
    //scrollpanel:SetPos(-485, 210)
	scrollpanel:SetPos(scoreboard:GetWide()/2-scrollW - adminWidth, 210)
    //scrollpanel:SetSize(scoreboard:GetWide() + 45, scoreboard:GetTall() - 140)
	scrollpanel:SetSize(scrollW * 2 + adminWidth + 20, scoreboard:GetTall() - 215)//215
	scrollpanel.VBar:SetHideButtons(true)
    scrollpanel.VBar.Paint = function() end
    scrollpanel.VBar.btnUp.Paint = scrollpanel.VBar.Paint
    scrollpanel.VBar.btnDown.Paint = scrollpanel.VBar.Paint
	scrollpanel.VBar.btnGrip.Color = VictoriousScoreboardConfig.grey
	scrollpanel.VBar.btnGrip.Paint = function(self, w, h)
		local nextColor = VictoriousScoreboardConfig.grey
		if self.Depressed then
			nextColor = VictoriousScoreboardConfig.white
			text = VictoriousScoreboardConfig.GotoText
		elseif self.Hovered then
			nextColor = VictoriousScoreboardConfig.hover
			text = VictoriousScoreboardConfig.GotoText
		end

		self.Color = LerpColor(FrameTime() * 10, self.Color, nextColor)
		surface.SetDrawColor(0,0,0,0)
		surface.DrawRect(0, 0, w, h)
	end

    scoreboard.Update = function()
        scrollpanel:Clear()
		
		
		if (VictoriousScoreboardConfig.UsingDarkRP and VictoriousScoreboardConfig.UsingDarkRPCategories) then
			local categories = DarkRP.getCategories().jobs
			
			for k,categ in pairs(categories) do
				local shouldCreate = table.Count(categ.members) > 0
				
				if shouldCreate then
					if VictoriousScoreboardConfig.UsingDarkRPCategoriesTitles then
						local shouldDelete = true
						local dcat = vgui.Create("DCollapsibleCategory", scrollpanel)
						dcat.Header:SetTall(40)
						dcat:SetLabel("")
						dcat.Paint = function() end
						dcat.Header.Paint = function(self, w,h)
							draw.SimpleText(categ.name, "score", adminWidth, h/2, categ.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							
							surface.SetDrawColor(VictoriousScoreboardConfig.white)
							surface.DrawRect(adminWidth, h-5, w-adminWidth, 1)
						end
						
						local contents = vgui.Create("DPanelList", dcat)
						contents:SetPadding(0)
						contents:SetSpacing(4)
						dcat:SetContents(contents)
						
						for k,v in pairs(categ.members) do
							local count = team.NumPlayers(v.team)
							if count > 0 then
								shouldDelete = false
								local plys = team.GetPlayers(v.team)
								for k, ply in pairs(plys) do
									local panel = CreatePlayerPanel(ply)
									//panel:SetParent(scrollpanel)
									contents:AddItem(panel)
									//panel:DockMargin(0, 0, 0, 3)
									//panel:Dock(TOP)
								end
							end
						end
						dcat:Dock(TOP)
						if shouldDelete then
							dcat:Remove()
						end
					else
					
						for k,v in pairs(categ.members) do
							local count = team.NumPlayers(v.team)
							if count > 0 then
								local plys = team.GetPlayers(v.team)
								for k, ply in pairs(plys) do
									local panel = CreatePlayerPanel(ply)
									//panel:SetParent(scrollpanel)
									scrollpanel:AddItem(panel)
									panel:DockMargin(0, 0, 0, 4)
									panel:Dock(TOP)
								end
							end
						end
					end
				end
				
			end
			
		else
			for k, v in pairs(player.GetAll()) do
				
				local panel = CreatePlayerPanel(v)
				//panel:SetParent(scrollpanel)
				scrollpanel:AddItem(panel)
				panel:DockMargin(0, 0, 0, 4)
				panel:Dock(TOP)
			end
		end
    end

    scoreboard:Update()
end

hook.Add("ScoreboardShow", "VictoriousScoreShow", function()
    hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
    hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
    if (scoreboard) then
        scoreboard:Update()
        scoreboard:SetVisible(true)
        scoreboard:SetAlpha(0)
        scoreboard:AlphaTo(255, 0.1)
    else
        CreateScoreboard()
    end
end)

hook.Add("ScoreboardHide", "VictoriousScoreHide", function()
    if (scoreboard) then
        scoreboard:AlphaTo(0, 0.1, 0, function()
            scoreboard:SetVisible(false)
        end)

    end
end)
