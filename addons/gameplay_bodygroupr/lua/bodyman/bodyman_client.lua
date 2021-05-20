include("bodyman/bodyman_config.lua")



function BODYMAN:UseEnglish()
	BODYMAN.HelpText = BODYMAN.HelpText_En
	BODYMAN.ClosetHelpText = BODYMAN.ClosetHelpText_En
	BODYMAN.strings = BODYMAN.strings_en
	BODYMAN.ClosetName = BODYMAN.ClosetName_En
	BODYMAN.CurrentLang = "En"
end

function BODYMAN:UseFrench()
	BODYMAN.HelpText = BODYMAN.HelpText_Fr
	BODYMAN.ClosetHelpText = BODYMAN.ClosetHelpText_Fr
	BODYMAN.strings = BODYMAN.strings_fr
	BODYMAN.ClosetName = BODYMAN.ClosetName_Fr
	BODYMAN.CurrentLang = "Fr"
end

function BODYMAN:UseGerman()
	BODYMAN.HelpText = BODYMAN.HelpText_De
	BODYMAN.ClosetHelpText = BODYMAN.ClosetHelpText_De
	BODYMAN.strings = BODYMAN.strings_de
	BODYMAN.ClosetName = BODYMAN.ClosetName_De
	BODYMAN.CurrentLang = "De"
end

BODYMAN.CurrentLang = "En"
BODYMAN:UseEnglish() -- default to english


if BODYMAN.French == true then
	BODYMAN:UseFrench()
end

if BODYMAN.German == true then
	BODYMAN:UseGerman()
end

surface.CreateFont("Bodygroups_Small", {
	font = "Roboto",
	size = 18,
	antialias = true,
	weight = 800
})

surface.CreateFont("Bodygroups_Medium", {
	font = "Roboto",
	size = 24,
	antialias = true,
	weight = 800
})

surface.CreateFont("Bodygroups_Large", {
	font = "Roboto",
	size = 42,
	antialias = true,
	weight = 800
})

function InverseLerp( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end

include("bodyman/arizard_derma.lua")

function BODYMAN:Chat( msg )
	chat.AddText(HexColor("#3498db"), "[bodyGroupr] ", Color(255,255,255), msg)
end

net.Receive("bodyman_chatprint", function()
	local msg = net.ReadString()
	BODYMAN:Chat( msg )
	-- 76561198096742115
end)

BODYMAN.MenuIsOpen = false
BODYMAN.Menu = nil

timer.Create("IsBodyGrouprMenuStillValid", 3, 0, function()
	if BODYMAN.MenuIsOpen == true and BODYMAN.ClosetsOnly == true then
		if not BODYMAN:CloseEnoughCloset( LocalPlayer() ) then
			if IsValid(BODYMAN.Menu) then
				BODYMAN.Menu:Close()
			end
		end
	end
end)

function BODYMAN:OpenMenu()

	self.MenuIsOpen = true

	if self.ClosetsOnly == true then
		if self:CloseEnoughCloset( LocalPlayer() ) == false then
			return false
		end
	end

	local frame = vgui.Create("arizard_window")
	frame:SetSize( ScrW()*.75, ScrH()*.85 )
	frame:Center()
	frame:SetPrimaryColor( HexColor("#3498db") )
	frame:SetSecondaryColor( HexColor("#ecf0f1", 4) )
	frame:SetTitle("bodyGroupr")
	frame:MakePopup()

	self.Menu = frame

	function frame:OnClose()
		BODYMAN.MenuIsOpen = false
		BODYMAN.ClientModelPanel:Remove()
	end

	local pmodel = vgui.Create("DModelPanel", frame)
	pmodel:SetSize( pmodel:GetParent():GetWide()*(2/3) - 8, pmodel:GetParent():GetTall() - 40 )
	pmodel:SetPos( 4, 32 )

	pmodel:SetModel( LocalPlayer():GetModel() )

	pmodel:SetLookAt( Vector(0,0,72/2) )
	pmodel:SetCamPos( Vector(64,0,72/2))
	--pmodel:SetLookAng( Angle(0,0,0) )

	pmodel.Entity:SetEyeTarget( pmodel.Entity:GetPos() + Vector(200,0,64) )

	pmodel:SetAmbientLight( Color(10,15,50) )
	pmodel:SetDirectionalLight( BOX_TOP, Color(220,190,100) )

	pmodel.rot = 110
	pmodel.fov = 20
	pmodel:SetFOV( pmodel.fov )
	pmodel.dragging = false -- left click
	pmodel.dragging2 = false -- right click
	pmodel.ux = 0
	pmodel.uy = 0
	pmodel.spinmul = 0.4
	pmodel.zoommul = 0.09

	pmodel.xmod = 0
	pmodel.ymod = 0

	BODYMAN.ClientModelPanel = pmodel

	pmodel.Entity:SetSkin( LocalPlayer():GetSkin() )

	-- set pmodel's bodygroups
	local curgroups = LocalPlayer():GetBodyGroups()
	--PrintTable( curgroups )

	for k,v in pairs( curgroups ) do
		local ent = pmodel.Entity
		local cur_bgid = LocalPlayer():GetBodygroup( v.id )
		ent:SetBodygroup( v.id, cur_bgid )
	end

	function pmodel.Entity:GetPlayerColor()
		return LocalPlayer():GetPlayerColor()
	end

	function pmodel:PaintOver( w, h )
		--surface.SetDrawColor( Color(255,255,255) )
		--surface.DrawOutlinedRect(0,0,w,h)
		ArizardShadowText(BODYMAN.HelpText, "Bodygroups_Medium", 0,0, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1 )
	end

	function pmodel:LayoutEntity( ent )

		local newrot = self.rot
		local newfov = self:GetFOV()

		if self.dragging == true then
			newrot = self.rot + (gui.MouseX() - self.ux)*self.spinmul
			newfov = self.fov + (self.uy - gui.MouseY()) * self.zoommul
			if newfov < 20 then newfov = 20 end
			if newfov > 75 then newfov = 75 end
		end

		local newxmod, newymod = self.xmod, self.ymod

		if self.dragging2 == true then
			newxmod = self.xmod + (self.ux - gui.MouseX())*0.02
			newymod = self.ymod + (self.uy - gui.MouseY())*0.02
		end

		newxmod = math.Clamp( newxmod, -16, 16 )
		newymod = math.Clamp( newymod, -16, 16 )

		ent:SetAngles( Angle(0,0,0) )
		self:SetFOV( newfov )

		-- calculate if we should look at the face
		local height = 72/2
		-- fov between 20 and 75,
		-- height between 72/2 and 72
		local frac = InverseLerp( newfov, 75, 20 )
		height = Lerp( frac, 72/2, 64 )

		-- calculate look ang
		local norm = (self:GetCamPos() - Vector(0,0,64))
		norm:Normalize()
		local lookAng = norm:Angle()

		self:SetLookAt( Vector(0,0,height-(2*frac) ) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )
		self:SetCamPos( Vector( 64*math.sin( newrot * (math.pi/180)), 64*math.cos( newrot * (math.pi/180)), height + 4*(1-frac)) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )

	end

	function pmodel:OnMousePressed( k )
		self.ux = gui.MouseX()
		self.uy = gui.MouseY()
		self.dragging = (k == MOUSE_LEFT) or false 
		self.dragging2 = (k == MOUSE_RIGHT) or false 
	end

	function pmodel:OnMouseReleased( k )
		if self.dragging == true then
			self.rot = self.rot + (gui.MouseX() - self.ux)*self.spinmul
			self.fov = self.fov + (self.uy - gui.MouseY()) * self.zoommul
			self.fov = math.Clamp( self.fov, 20, 75 )
		end

		if self.dragging2 == true then
			self.xmod = self.xmod + (self.ux - gui.MouseX())*0.02
			self.ymod = self.ymod + (self.uy - gui.MouseY())*0.02

			self.xmod = math.Clamp( self.xmod, -16, 16 )
			self.ymod = math.Clamp( self.ymod, -16, 16 )
		end

		self.dragging = false 
		self.dragging2 = false
	end

	function pmodel:OnCursorExited()
		if self.dragging == true or self.dragging2 == true then
			self:OnMouseReleased()
		end
	end

	-- now for the controls
	local cpan = vgui.Create("DPanel", frame)
	cpan:SetSize( cpan:GetParent():GetWide()*(1/3)-4, cpan:GetParent():GetTall() - 44 )
	cpan:SetPos( 4+4+cpan:GetParent():GetWide()*(2/3)-8, 32)
	function cpan:Paint() end

	local cpanscroll = vgui.Create("DScrollPanel", cpan)
	cpanscroll:SetSize( cpanscroll:GetParent():GetWide(), cpanscroll:GetParent():GetTall() - 32 )
	cpanscroll:SetPos(0,0)

	function cpanscroll:Paint(w,h)
		-- surface.SetDrawColor(Color(255,0,0))
		-- surface.DrawRect(0,0,w,h)
	end

	-- style the scroll button:
	local sbar = cpanscroll:GetVBar()
	sbar:SetWide( 6 )
	function sbar:Paint( w, h )
	end
	function sbar.btnUp:Paint( w, h )
	end
	function sbar.btnDown:Paint( w, h )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox((w-1)/2, 1,0,w-1,h,Color(0,0,0,200))
	end

	local cpanlist = vgui.Create("DIconLayout", cpanscroll)
	cpanlist:SetSize( cpanscroll:GetWide()-8, cpanscroll:GetTall() - 8 )
	cpanlist:SetPos( 4, 4 )
	cpanlist:SetSpaceX( 4 )
	cpanlist:SetSpaceY( 4 )

	langselect = vgui.Create("DComboBox", cpan)
	langselect:SetSize(cpanscroll:GetWide(), 28)
	langselect:SetPos(0,cpanscroll:GetTall()+4)

	langselect:AddChoice("English",BODYMAN.UseEnglish,BODYMAN.CurrentLang == "En")
	langselect:AddChoice("Francais",BODYMAN.UseFrench,BODYMAN.CurrentLang == "Fr")
	langselect:AddChoice("Deutsche",BODYMAN.UseGerman,BODYMAN.CurrentLang == "De")

	function langselect:OnSelect(index, value, data)
		data()
		BODYMAN:RefreshAppearanceMenu( )
	end

	self.cpanlist = cpanlist
	self.cpanscroll = cpanscroll



	self:RefreshAppearanceMenu( )
	
end

function BODYMAN:RefreshAppearanceMenu( )

	local cpanlist, cpanscroll = self.cpanlist, self.cpanscroll

	if ( not IsValid( cpanlist ) ) or ( not IsValid( cpanscroll ) ) then return end

	-- reload the bodygropes
	self.ClientModelPanel.Entity:SetSkin( LocalPlayer():GetSkin() )

	local job = LocalPlayer():getJobTable()

	-- set pmodel's bodygroups
	local curgroups = LocalPlayer():GetBodyGroups()
	--PrintTable( curgroups )
	local bgroups = job.bodygroups or {}

	for k,v in pairs( curgroups ) do
		local ent = self.ClientModelPanel.Entity
		local cur_bgid = LocalPlayer():GetBodygroup( v.id )

		if bgroups[v.name] then
			if not table.HasValue(bgroups[v.name], cur_bgid) then
				cur_bgid = table.Random(bgroups[v.name])
			end
		end

		ent:SetBodygroup( v.id, cur_bgid )
	end

	self.ClientModelPanel.Entity:SetEyeTarget( self.ClientModelPanel.Entity:GetPos() + Vector(200,0,64) )

	cpanlist:Clear()

	local title = cpanlist:Add( "DLabel" )
	title:SetText( BODYMAN.strings.Appearance )
	title:SetFont("Bodygroups_Large")
	title:SetTextColor( HexColor("#ffffff") )
	title:SizeToContents()
	title:SetWide( cpanscroll:GetWide() )
	title:SetExpensiveShadow(1,Color(0,0,0))

	-- -- thiccnes sliders
	-- local thicctitle = cpanlist:Add("DLabel")
	-- thicctitle:SetText( BODYMAN.strings.Physique)
	-- thicctitle:SetFont("Bodygroups_Medium")
	-- thicctitle:SetTextColor( HexColor("#eeeeee") )
	-- thicctitle:SizeToContents()
	-- thicctitle:SetWide( cpanscroll:GetWide() )
	-- thicctitle:SetExpensiveShadow(1,Color(0,0,0))
	--[[
	local bones = {
		["Chest"] = {"ValveBiped.Bip01_Spine2","ValveBiped.Bip01_R_Trapezius","ValveBiped.Bip01_L_Trapezius"},
		["Gut"] = {"ValveBiped.Bip01_Spine","ValveBiped.Bip01_Spine1","ValveBiped.Bip01_Pelvis"},
		["Forearms"] = {"ValveBiped.Bip01_R_Forearm","ValveBiped.Bip01_L_Forearm"},
		["Biceps"] = {"ValveBiped.Bip01_R_Bicep","ValveBiped.Bip01_L_Bicep","ValveBiped.Bip01_R_Shoulder","ValveBiped.Bip01_R_Shoulder","ValveBiped.Bip01_R_UpperArm","ValveBiped.Bip01_L_UpperArm","ValveBiped.Bip01_R_Clavicle","ValveBiped.Bip01_L_Clavicle"},
		["Thighs"] = {"ValveBiped.Bip01_R_Thigh","ValveBiped.Bip01_L_Thigh"},
		["Calves"] = {"ValveBiped.Bip01_R_Calf","ValveBiped.Bip01_L_Calf"},
	}

	local bonescales = {
		["Chest"] = 1,
		["Gut"] = 1,
		["Forearms"] = 1,
		["Biceps"] = 1,
		["Thighs"] = 1,
		["Calves"] = 1,
	}

	bonescales = BODYMAN:GetBoneScales(LocalPlayer())

	local preview = self.ClientModelPanel.Entity
	for k,v in pairs(bones) do
		local slid = cpanlist:Add("DNumSlider")
		slid:SetText(k)
		slid:SetWide(cpanscroll:GetWide()-16)
		slid:SetMin(0.75)
		slid:SetMax(1.25)
		slid:SetValue(bonescales[k])
		slid.v = v

		function slid:OnValueChanged(val)
			for _, v2 in pairs(self.v) do
				local bid = preview:LookupBone(v2)
				if bid then
					preview:ManipulateBoneScale(bid,Vector(1,1,1)*val)
				end
				BODYMAN:CopyBoneScales(preview, LocalPlayer())
				BODYMAN:SendBoneScales(LocalPlayer())
			end
		end

		slid:OnValueChanged(bonescales[k])
	end ]]

	-- do models
	local playermodels = job.model

	if type( playermodels ) == "table" then
		local modeltitle = cpanlist:Add("DLabel")
		modeltitle:SetText( BODYMAN.strings.Playermodels )
		modeltitle:SetFont("Bodygroups_Medium")
		modeltitle:SetTextColor( HexColor("#eeeeee") )
		modeltitle:SizeToContents()
		modeltitle:SetWide( cpanscroll:GetWide() )
		modeltitle:SetExpensiveShadow(1,Color(0,0,0))

		for k=1,#playermodels do
			local mdl = playermodels[k]

			local btn = cpanlist:Add( "arizard_button" )
			btn:SetWide( (cpanlist:GetWide()-8)/2 - 8 )
			btn:SetTall( 28 )

			-- reduce the filepath to it's model name, without extension
			local args = string.Split( mdl, "/" )
			local mdlname = args[ #args ]
			mdlname = string.sub( mdlname, 1, -5)

			btn:SetText( mdlname )
			btn.mdlpath = mdl
			btn.mdlidx = k

			btn:SetColors( HexColor("#2980b9"), HexColor("#3498db"))

			function btn:DoClick()
				BODYMAN.ClientModelPanel:SetModel( self.mdlpath )

				net.Start("bodyman_model_change")
				net.WriteInt( self.mdlidx, 8 )
				net.SendToServer()

				BODYMAN:RefreshAppearanceMenu( )
			end
		end

	end

	-- do skins
	
	local skintable = {}
	local vipskintable = {}

	if job.skins then
		skintable = table.Copy( job.skins )
	else
		skintable = {}
		for i=0,LocalPlayer():SkinCount()-1 do
			table.insert( skintable, i )
		end
	end

	if job.vipskins then
		vipskintable = table.Copy(job.vipskins)
		if BODYMAN:IsVip(LocalPlayer()) then
			for k,v in ipairs(vipskintable) do
				table.insert(skintable,v)
			end
		end
	end
	
	
	if skintable ~= {} then
		local skintitle = cpanlist:Add("DLabel")
		skintitle:SetText( BODYMAN.strings.Skins )
		skintitle:SetFont("Bodygroups_Medium")
		skintitle:SetTextColor( HexColor("#eeeeee") )
		skintitle:SizeToContents()
		skintitle:SetWide( cpanscroll:GetWide() )
		skintitle:SetExpensiveShadow(1,Color(0,0,0))

		for k,i in ipairs(skintable) do
			if BODYMAN:HasSkin( LocalPlayer(), i ) then
				local btn = cpanlist:Add( "arizard_button" )
				btn:SetSize( cpanlist:GetWide()/4 - 16, 28 )
				btn:SetText( tostring(i) )
				btn.skinNumber = i

				btn:SetColors( HexColor("#2980b9"), HexColor("#3498db"))

				function btn:DoClick()
					print("Attempting to switch skin", self.skinNumber)
					BODYMAN.ClientModelPanel.Entity:SetSkin( self.skinNumber )

					net.Start("skins_change")
					net.WriteInt(self.skinNumber, 8)
					net.SendToServer()
				end
			end
		end

		local spacer = cpanlist:Add("DPanel")
		spacer:SetSize(cpanlist:GetWide(), 2)
		function spacer:Paint() end
	end

	local allowedbodygroups = {}
	
	if job.bodygroups then
		allowedbodygroups = job.bodygroups 
	else
		local ply = LocalPlayer()
		for i = 2, #ply:GetBodyGroups() do
			local bg = ply:GetBodyGroups()[i]
			if bg then
				for k,v in pairs( bg ) do
					if k == "name" then
						allowedbodygroups[v] = {}
						for k2, v2 in pairs( bg["submodels"] ) do
							table.insert( allowedbodygroups[v], k2 )
						end
					end
				end	
			end
		end

		--PrintTable( allowedbodygroups )
	end

	local vipallowedbodygroups = {}
	
	if job.vipbodygroups then
		vipallowedbodygroups = job.vipbodygroups

	end

	if allowedbodygroups ~= {} then
		local bgtitle = cpanlist:Add("DLabel")
		bgtitle:SetText( BODYMAN.strings.Bodygroups )
		bgtitle:SetFont("Bodygroups_Medium")
		bgtitle:SetTextColor( HexColor("#eeeeee") )
		bgtitle:SizeToContents()
		bgtitle:SetWide( cpanscroll:GetWide() )
		bgtitle:SetExpensiveShadow(1,Color(0,0,0))

		for bgname, bgtable in pairs( allowedbodygroups ) do
			local bglabel = cpanlist:Add("DLabel")
			bglabel:SetFont("Bodygroups_Small")
			bglabel:SetText(string.upper(bgname))
			bglabel:SetTextColor( HexColor("#dddddd") )
			bglabel:SizeToContents()
			bglabel:SetWide( cpanscroll:GetWide() )
			bglabel:SetExpensiveShadow(1,Color(0,0,0))

			for _,i in ipairs(bgtable) do

				if BODYMAN:HasBodyGroup( LocalPlayer(), bgname, i ) then

					local btn = cpanlist:Add( "arizard_button" )
					btn:SetSize( cpanlist:GetWide()/4 - 16, 28 )
					btn:SetText( tostring(i) )
					btn.bg_name = bgname
					btn.bg_num = i

					btn:SetColors( HexColor("#2980b9"), HexColor("#3498db"))

					function btn:DoClick()
						local ent = BODYMAN.ClientModelPanel.Entity
						local bgid = ent:FindBodygroupByName( self.bg_name )
						if bgid ~= -1 then
							ent:SetBodygroup( bgid, self.bg_num )

							net.Start("bodygroups_change")
							net.WriteTable( { bgid, self.bg_num } )
							net.SendToServer()
						end
					end

				end
			end

			local spacer = cpanlist:Add("DPanel")
			spacer:SetSize(cpanlist:GetWide(), 2)
			function spacer:Paint() end

		end

		local spacer = cpanlist:Add("DPanel")
		spacer:SetSize(cpanlist:GetWide(), 2)
		function spacer:Paint() end
	end
end

concommand.Add("bodyman_openmenu", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		BODYMAN:OpenMenu()
	end
end)

-- add to context menu
-- list.Set( "DesktopWindows", "BodyManEditor", {

	-- icon = "icon16/user_gray.png",
	-- title = "bodyGroupr",
	-- width = 100,
	-- height = 100,
	-- onewindow = true,
	-- init = function( icon, window )
		-- window:Close()		
		-- RunConsoleCommand("bodyman_openmenu")
	-- end

	-- }
-- )

--if LocalPlayer():IsSuperAdmin() then
-- list.Set( "DesktopWindows", "BodyManAdmin", {

	-- icon = "icon16/user_gray.png",
	-- title = "bodyGroupr Admin Menu",
	-- width = 100,
	-- height = 100,
	-- onewindow = true,
	-- init = function( icon, window )
		-- window:Close()
		-- RunConsoleCommand("bodyman_adminmenu")
	-- end

	-- }
-- )
--end

function BODYMAN:AdminMenu()
	local frame = vgui.Create("arizard_window")
	frame:SetSize( 456, 300 ) -- usable: 348 x 556
	frame:Center()
	frame:SetPrimaryColor( HexColor("#3498db") )
	frame:SetSecondaryColor( HexColor("#ecf0f1", 4) )
	frame:SetTitle("bodyGroupr Admin Menu")
	frame:MakePopup()

	frame.scr = vgui.Create("DScrollPanel", frame)
	frame.scr:SetSize( frame:GetWide() - 8, frame:GetTall()-44 )
	frame.scr:SetPos(4,32)

	frame.scr.list = vgui.Create("DIconLayout", frame.scr)
	frame.scr.list:SetSize( frame.scr:GetWide()-8, frame.scr:GetTall() - 8 )
	frame.scr.list:SetPos( 4, 4 )
	frame.scr.list:SetSpaceX( 4 )
	frame.scr.list:SetSpaceY( 4 )

	-- style the scroll button:
	local sbar = frame.scr:GetVBar()
	sbar:SetWide( 6 )
	function sbar:Paint( w, h )
	end
	function sbar.btnUp:Paint( w, h )
	end
	function sbar.btnDown:Paint( w, h )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox((w-1)/2, 1,0,w-1,h,Color(0,0,0,200))
	end

	local commandbuttons = {
		["bodyman_saveclosets"] = BODYMAN.strings.Save.." "..BODYMAN.ClosetName,
		["bodyman_loadclosets"] = (BODYMAN.French and "Restaurer uniquement les "..BODYMAN.ClosetName.."s sauvegardées" or BODYMAN.strings.Load.." "..BODYMAN.ClosetName),
		["bodyman_removeclosets"] = BODYMAN.strings.Remove_All.." "..BODYMAN.ClosetName.."s "..BODYMAN.strings.Without_Saving,
		["bodyman_spawncloset"] = BODYMAN.strings.Spawn_a.." "..BODYMAN.ClosetName,
	}

	for cmd, desc in pairs( commandbuttons ) do
		local b = frame.scr.list:Add("arizard_button")
		b:SetSize( frame.scr.list:GetWide(), 28 )
		b:SetText( desc )

		b.cmd = cmd

		function b:DoClick()
			RunConsoleCommand( self.cmd )
		end
	end


end
concommand.Add("bodyman_adminmenu", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		BODYMAN:AdminMenu()
	end
end)

