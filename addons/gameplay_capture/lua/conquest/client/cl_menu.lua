
local function TeamEdit(parent, point, ind)

	local data = point


	if !parent then return end
	local scrollpanel = vgui.Create("DFrame")
	scrollpanel:SetSize(ScrW()*0.5, ScrH() *0.65 )
	scrollpanel:Center()
	scrollpanel:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0)):FadeIn()
	scrollpanel:MakePopup()
	scrollpanel:SetTitle("Team Creator")
	scrollpanel:ShowCloseButton(false)

	local exit = scrollpanel:Add("DButton")
	exit:SetSize(32, 32)
	exit:SetPos(scrollpanel:GetWide() - 38, 2)
	exit:SetText('X')
	exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	exit:SetTextColor(color_white)
	exit:On('DoClick', function()
		scrollpanel:Remove()
	end)

	local new = scrollpanel:Add("DScrollPanel")
	new:Dock(FILL)
	new:DockMargin(5, 20, 5, 5)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Name")
	label:DockMargin(5, 0, 0, 0)

	local container_hold = new:Add("DScrollPanel")
	container_hold:Dock(TOP)
	container_hold:SetTall(31)

	local p_name = container_hold:Add('Conquest_TextEntry')
	p_name:Dock(TOP)
	p_name:SetText(ind)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Color")
	label:DockMargin(5, 0, 0, 0)

	local Mixer = new:Add("DColorMixer")
	Mixer:Dock( TOP )
	Mixer:SetPalette( true )
	Mixer:SetColor( Color( 30, 100, 160 ) )
	Mixer:DockMargin(5, 5, 0, 0)
	Mixer:SetColor(Color(data.color.r, data.color.g, data.color.b))

	local selected = {}

	local container = new:Add("DScrollPanel")
	container:Dock(TOP)
	container:DockMargin(5, 20, 5, 5)
	container:SetTall(200)

	container:InvalidateLayout(true)
    container:InvalidateParent(true)

	local leftbox = container:Add('DScrollPanel')
	leftbox:SetWide(scrollpanel:GetWide() * 0.40)
	leftbox:SetTall(container:GetTall())
	leftbox.Paint = function(s, w, h)
		surface.SetDrawColor(128, 128, 182)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	// build teams

	leftbox:InvalidateLayout(true)

	local rightbox = container:Add('DScrollPanel')
	rightbox:SetWide(scrollpanel:GetWide() * 0.40)
	rightbox:SetTall(container:GetTall())
	rightbox:Dock(RIGHT)
	rightbox.Paint = function(s, w, h)
		surface.SetDrawColor(128, 128, 182)
		surface.DrawOutlinedRect(0, 0, w, h)
	end


	local moveRight = container:Add('DButton')
	moveRight:SetText(">>")
	moveRight:SetSize(32, 32)
	moveRight:SetPos(leftbox:GetWide() + 42, container:GetTall()*0.5)

	local moveLeft = container:Add('DButton')
	moveLeft:SetText("<<")
	moveLeft:SetSize(32, 32)
	moveLeft:SetPos(leftbox:GetWide() + 42, container:GetTall()*0.33)

	rightbox.AddTeam = function(teamIndex, teamName)

		selected[teamIndex] = teamName

		local teamButton = rightbox:Add('DButton')
		teamButton:SetText(teamName or "error")
		teamButton:Dock(TOP)
		teamButton:DockMargin(5, 5, 0, 0)
		teamButton:SetTall(25)
		teamButton.index = teamIndex
		teamButton.teamName = teamName
		teamButton.DoClick = function(s)

			leftbox.AddTeam(s.index, s.teamName)

			selected[s.index] = nil

			s:Remove()

		end

	end

	leftbox.AddTeam = function(teamIndex, teamName)

		local teamButton = leftbox:Add('DButton')
		teamButton:SetText(teamName or "error")
		teamButton:Dock(TOP)
		teamButton:DockMargin(5, 5, 5, 0)
		teamButton:SetTall(25)
		teamButton.index = teamIndex
		teamButton.teamName = teamName
		teamButton.DoClick = function(s)
			rightbox.AddTeam(s.index, s.teamName)

			s:Remove()
		end

	end


	if (DarkRP) then

		for k,v in pairs(RPExtraTeams)do

			if table.HasValue(data.teams, v.name) then continue end

			leftbox.AddTeam(k, v.name)

		end

	else

		local teams = team.GetAllTeams()

		for k,v in pairs(teams) do

			if table.HasValue(data.teams, v.Name) then continue end

			leftbox.AddTeam(k, v.Name)

		end

	end

	for k,v in pairs(data.teams) do
		rightbox.AddTeam(k, v)
	end

	local create_btn = new:Add('DButton')
	create_btn:SetText("Save")
	create_btn:DockMargin(5, 15, 5, 0)
	create_btn:Dock(TOP)
	create_btn:TDLib():Background(Color(76, 175, 80)):FadeHover()
	create_btn:SetTextColor(color_white)
	create_btn.DoClick = function(s)
		local color = Mixer:GetColor()

		net.Start("conquest.team.add")
			net.WriteTable(selected)
			net.WriteString(p_name:GetText())
			net.WriteColor(Color(color.r, color.g, color.b, 255))
		net.SendToServer()

		scrollpanel:Close()
		parent:Remove()
	end

end

local function TeamCreation(parent)
	if !parent then return end

	-- if !table.HasValue(Conquest.cache, point) then return end

	local scrollpanel = vgui.Create("DFrame")
	scrollpanel:SetSize(ScrW()*0.5, ScrH() *0.65 )
	scrollpanel:Center()
	scrollpanel:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0)):FadeIn()
	scrollpanel:MakePopup()
	scrollpanel:SetTitle("Team Creator")
	scrollpanel:ShowCloseButton(false)

	local exit = scrollpanel:Add("DButton")
	exit:SetSize(32, 32)
	exit:SetPos(scrollpanel:GetWide() - 38, 2)
	exit:SetText('X')
	exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	exit:SetTextColor(color_white)
	exit:On('DoClick', function()
		scrollpanel:Remove()
	end)

	local new = scrollpanel:Add("DScrollPanel")
	new:Dock(FILL)
	new:DockMargin(5, 20, 5, 5)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Name")
	label:DockMargin(5, 0, 0, 0)

	local container_hold = new:Add("DScrollPanel")
	container_hold:Dock(TOP)
	container_hold:SetTall(31)

	local p_name = container_hold:Add('Conquest_TextEntry')
	p_name:Dock(TOP)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Color")
	label:DockMargin(5, 0, 0, 0)

	local Mixer = new:Add("DColorMixer")
	Mixer:Dock( TOP )
	Mixer:SetPalette( true )
	Mixer:SetColor( Color( 30, 100, 160 ) )
	Mixer:DockMargin(5, 5, 0, 0)

	local selected = {}

	local container = new:Add("DScrollPanel")
	container:Dock(TOP)
	container:DockMargin(5, 20, 5, 5)
	container:SetTall(200)

	container:InvalidateLayout(true)
    container:InvalidateParent(true)

	local leftbox = container:Add('DScrollPanel')
	leftbox:SetWide(scrollpanel:GetWide() * 0.40)
	leftbox:SetTall(container:GetTall())
	leftbox.Paint = function(s, w, h)
		surface.SetDrawColor(128, 128, 182)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	// build teams

	leftbox:InvalidateLayout(true)

	local rightbox = container:Add('DScrollPanel')
	rightbox:SetWide(scrollpanel:GetWide() * 0.40)
	rightbox:SetTall(container:GetTall())
	rightbox:Dock(RIGHT)
	rightbox.Paint = function(s, w, h)
		surface.SetDrawColor(128, 128, 182)
		surface.DrawOutlinedRect(0, 0, w, h)
	end


	local moveRight = container:Add('DButton')
	moveRight:SetText(">>")
	moveRight:SetSize(32, 32)
	moveRight:SetPos(leftbox:GetWide() + 42, container:GetTall()*0.5)

	local moveLeft = container:Add('DButton')
	moveLeft:SetText("<<")
	moveLeft:SetSize(32, 32)
	moveLeft:SetPos(leftbox:GetWide() + 42, container:GetTall()*0.33)

	rightbox.AddTeam = function(teamIndex, teamName)

		selected[teamIndex] = teamName

		local teamButton = rightbox:Add('DButton')
		teamButton:SetText(teamName or "error")
		teamButton:Dock(TOP)
		teamButton:DockMargin(5, 5, 0, 0)
		teamButton:SetTall(25)
		teamButton.index = teamIndex
		teamButton.teamName = teamName
		teamButton.DoClick = function(s)

			leftbox.AddTeam(s.index, s.teamName)

			selected[s.index] = nil

			s:Remove()

		end

	end

	leftbox.AddTeam = function(teamIndex, teamName)

		local teamButton = leftbox:Add('DButton')
		teamButton:SetText(teamName or "error")
		teamButton:Dock(TOP)
		teamButton:DockMargin(5, 5, 5, 0)
		teamButton:SetTall(25)
		teamButton.index = teamIndex
		teamButton.teamName = teamName
		teamButton.DoClick = function(s)
			rightbox.AddTeam(s.index, s.teamName)

			s:Remove()
		end

	end


	if (DarkRP) then

		for k,v in pairs(RPExtraTeams)do

			leftbox.AddTeam(k, v.name)

		end

	else

		local teams = team.GetAllTeams()

		for k,v in pairs(teams) do

			leftbox.AddTeam(k, v.Name)

		end

	end


	local create_btn = new:Add('DButton')
	create_btn:SetText("Save")
	create_btn:DockMargin(5, 15, 5, 0)
	create_btn:Dock(TOP)
	create_btn:TDLib():Background(Color(76, 175, 80)):FadeHover()
	create_btn:SetTextColor(color_white)
	create_btn.DoClick = function(s)
		local color = Mixer:GetColor()
		net.Start("conquest.team.add")
			net.WriteTable(selected)
			net.WriteString(p_name:GetText())
			net.WriteColor(Color(color.r, color.g, color.b, 255))
		net.SendToServer()

		scrollpanel:Close()
		parent:Remove()
	end

	
end


local function EditPoint(parent, point, ind)
	if !parent then return end

	-- if !table.HasValue(Conquest.cache, point) then return end

	local scrollpanel = vgui.Create("DFrame")
	scrollpanel:SetSize(ScrW()*0.5, ScrH() *0.55 )
	scrollpanel:Center()
	scrollpanel:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0)):FadeIn()
	scrollpanel:MakePopup()
	scrollpanel:SetTitle("Flag Editor")
	scrollpanel:ShowCloseButton(false)

	local boolDarkRP = Conquest.Config.get("darkrp", false)


	local exit = scrollpanel:Add("DButton")
	exit:SetSize(32, 32)
	exit:SetPos(scrollpanel:GetWide() - 38, 2)
	exit:SetText('X')
	exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	exit:SetTextColor(color_white)
	exit:On('DoClick', function()
		scrollpanel:Remove()
	end)

	local data = point 

	local new = scrollpanel:Add("DScrollPanel")
	new:Dock(FILL)
	new:DockMargin(5, 20, 5, 5)
	new.flagData = {}
	new.flagData.noTeams = {}
	new.flagData.category = false
	new.flagData.reward = false


	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Point Name")
	label:DockMargin(5, 0, 0, 0)

	local p_name = new:Add('Conquest_TextEntry')
	p_name:SetParent(new, "name", data.name or "")
	p_name:SetRequirement(4)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Tag (Recommend: 1 char)")
	label:DockMargin(5, 0, 0, 0)

	local p_tag = new:Add('Conquest_TextEntry')
	p_tag:SetParent(new, "tag", data.tag or "")
	p_tag:SetRequirement(1)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Radius (Numeric 150+)")
	label:DockMargin(5, 0, 0, 0)

	local p_num = new:Add('Conquest_TextEntry')
	p_num:SetParent(new, "radius", data.radius or "")
	p_num:SetRequirement(1)
	p_num:SetNumeric(true)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Capture Time (Numeric)")
	label:DockMargin(5, 0, 0, 0)

	local p_num = new:Add('Conquest_TextEntry')
	p_num:SetParent(new, "time", data.time or "")
	p_num:SetRequirement(1)
	p_num:SetNumeric(true)

	if boolDarkRP then
		local label = new:Add("DLabel")
		label:Dock(TOP)
		label:SetText("Reward for Capturing (Not required -- DarkRP)")
		label:DockMargin(5, 0, 0, 0)

		local p_num = new:Add('Conquest_TextEntry')
		p_num:SetParent(new, "reward", data.reward or "")
		p_num:SetRequirement(1)
		p_num:SetNumeric(true)
	end

	if boolDarkRP then
		local label = new:Add("DLabel")
		label:Dock(TOP)
		label:SetText("Category Based (DarkRP)")
		label:DockMargin(5, 0, 0, 0)

		local docker_box = new:Add("DScrollPanel")
		docker_box:DockMargin(5, 0, 0, 0)
		docker_box:Dock(TOP)


		DermaCheckbox = docker_box:Add( "DCheckBox" )
		DermaCheckbox:Dock(LEFT)
		//DermaCheckbox:SetText(" ")
		DermaCheckbox:TDLib()
		:SquareCheckbox(Color(39, 174, 96))
		DermaCheckbox.OnChange = function(s, bVal)
			new.flagData.category = bVal


		end

		if (boolDarkRP and data.category == true) then
			DermaCheckbox:SetValue(true)
			new.flagData.category = true
		end

	end

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Based")
	label:DockMargin(5, 0, 0, 0)

	local docker_box = new:Add("DScrollPanel")
	docker_box:DockMargin(5, 0, 0, 0)
	docker_box:Dock(TOP)


	DermaCheckboxT = docker_box:Add( "DCheckBox" )
	DermaCheckboxT:Dock(LEFT)
		//DermaCheckbox:SetText(" ")
	DermaCheckboxT:TDLib()
	:SquareCheckbox(Color(39, 174, 96))
	DermaCheckboxT.OnChange = function(s, bVal)
		new.flagData.teamBased = bVal

		if DermaCheckbox then
			DermaCheckbox:SetValue(false)
			new.flagData.category = false
		end

	end

	if (data.teamBased == true) then


		DermaCheckboxT:SetValue(true)
		new.flagData.teamBased = true
	end

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Shape")
	label:DockMargin(5, 0, 0, 0)

	local docker_box = new:Add("DScrollPanel")
	docker_box:DockMargin(5, 0, 0, 2)
	docker_box:Dock(TOP)

	local DComboBox = docker_box:Add( "DComboBox" )
	DComboBox:Dock(LEFT)
	DComboBox:DockMargin(0, 0, 0, 0)
	DComboBox:SetValue( "shape" )
	DComboBox:AddChoice( "square" )
	DComboBox:AddChoice( "circle" )
	DComboBox.OnSelect = function( panel, index, value )
		new.flagData.shape = tostring(value)
	end

	if data.shape then
		DComboBox:SetValue(data.shape)
		new.flagData.shape = data.shape
	end

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Blacklist Teams")
	label:DockMargin(5, 0, 0, 0)

	local AppList = new:Add( "DListView")
	AppList:Dock( TOP )
	AppList:SetTall(100)
	AppList:DockMargin(5, 5, 5, 0)
	AppList:SetMultiSelect( true )
	if DarkRP then
		AppList:AddColumn( "Team" )
		AppList:AddColumn( "Category" )
	else
		AppList:AddColumn( "Team" )
	end


	if DarkRP then
		for k,v in pairs(DarkRP.getCategories().jobs) do
			for i,j in pairs(v.members) do

				AppList:AddLine(j.command, j.category)

			end
		end

	else
		local teams = team.GetAllTeams()

		for k,v in pairs(teams) do
			AppList:AddLine(v.Name)
		end
	end

	AppList.OnRowSelected = function( lst, index, pnl )
		table.insert(new.flagData.noTeams, pnl:GetColumnText(1))
	end

	if (data.noTeams) then
		local lines = AppList:GetLines()

		for k,v in pairs(lines) do
			local blacklisted = v:GetValue(1)

			for i, j in pairs(data.noTeams) do
				if blacklisted == j then
					AppList:SelectItem(v)

					table.insert(new.flagData.noTeams, blacklisted)

				end
			end
		end

	end


	local clear_btn = new:Add('DButton')
	clear_btn:SetText("Clear Blacklisted Teams")
	clear_btn:DockMargin(5, 10, 5, 0)
	clear_btn:Dock(TOP)
	clear_btn:TDLib():Background(Color(76, 175, 80)):FadeHover()
	clear_btn:SetTextColor(color_white)
	clear_btn.DoClick = function(s)
		AppList:ClearSelection()

		new.flagData.noTeams = {}
	end

	local create_btn = new:Add('DButton')
	create_btn:SetText("Save")
	create_btn:DockMargin(5, 15, 5, 0)
	create_btn:Dock(TOP)
	create_btn:TDLib():Background(Color(76, 175, 80)):FadeHover()
	create_btn:SetTextColor(color_white)
	create_btn.DoClick = function(s)
		net.Start("conquest_editflag")
			net.WriteInt(ind, 16)
			net.WriteTable(new.flagData)
		net.SendToServer()
		scrollpanel:Close()
		parent:Remove()
	end


end


local PANEL = {}

local newplus = Material("nykez/plus.png", "noclamp smooth")
local settings = Material("nykez/settings.png", "noclamp smooth")
local tools = Material("nykez/tools.png", "noclamp smooth")
local editter = Material("nykez/edit.png", "noclamp smooth")
local teampng = Material("nykez/collaboration.png", "noclamp smooth")

local matBlurScreen = Material( "pp/blurscreen" )

function PANEL:SetBackgroundBlur(bool)

end

function PANEL:Init()

    self:SetWide(ScrW() * 0.65)
	self:SetTall(ScrH() * 0.65)
	self:Center()
	self:MakePopup()
	self:SetBackgroundBlur( true )

	self.startTime = SysTime()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0)):FadeIn()

    self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.08)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Conquest Management")

	self.exit = self:Add("DButton")
	self.exit:SetSize(32, 32)
	self.exit:SetPos(self:GetWide() - 38, 2)
	self.exit:SetText('X')
	self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	self.exit:SetTextColor(color_white)
	self.exit:On('DoClick', function()
		self:Remove()
	end)

	// DColumnSheet
	self.container = self:Add("ConquestSheet")
	self.container:Dock(FILL)

	self:BuildTabs()
end

function PANEL:BuildTabs()
	local new = self.container:Add("DScrollPanel")
	new:Dock(FILL)

	local boolDarkRP = Conquest.Config.get("darkrp", false)

	self.flagData = {}
	self.flagData.teams = {}
	self.flagData.category = false
	self.flagData.reward = false

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Point Name")
	label:DockMargin(5, 0, 0, 0)

	local p_name = new:Add('Conquest_TextEntry')
	p_name:SetParent(self, "name")
	p_name:SetRequirement(4)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Tag (Recommend: 1 char)")
	label:DockMargin(5, 0, 0, 0)

	local p_tag = new:Add('Conquest_TextEntry')
	p_tag:SetParent(self, "tag")
	p_tag:SetRequirement(1)

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Radius (Numeric 150+)")
	label:DockMargin(5, 0, 0, 0)

	local p_num = new:Add('Conquest_TextEntry')
	p_num:SetParent(self, "radius")
	p_num:SetRequirement(1)
	p_num:SetNumeric(true)
	p_num:SetText(150)
	self.flagData.radius = 150

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Capture Time (Numeric)")
	label:DockMargin(5, 0, 0, 0)

	local p_num = new:Add('Conquest_TextEntry')
	p_num:SetParent(self, "time")
	p_num:SetRequirement(1)
	p_num:SetNumeric(true)

	if boolDarkRP then
		local label = new:Add("DLabel")
		label:Dock(TOP)
		label:SetText("Reward for Capturing (Not required -- DarkRP)")
		label:DockMargin(5, 0, 0, 0)

		local p_num = new:Add('Conquest_TextEntry')
		p_num:SetParent(self, "reward")
		p_num:SetRequirement(1)
		p_num:SetNumeric(true)
	end

	if boolDarkRP then
		local label = new:Add("DLabel")
		label:Dock(TOP)
		label:SetText("Category Based (DarkRP)")
		label:DockMargin(5, 0, 0, 0)

		local docker_box = new:Add("DScrollPanel")
		docker_box:DockMargin(5, 0, 0, 0)
		docker_box:Dock(TOP)


		local DermaCheckbox = docker_box:Add( "DCheckBox" )
		DermaCheckbox:Dock(LEFT)
		//DermaCheckbox:SetText(" ")
		DermaCheckbox:TDLib()
		:SquareCheckbox(Color(39, 174, 96))
		DermaCheckbox.OnChange = function(s, bVal)
			self.flagData.category = bVal
		end

	end

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Team Based Capturing")
	label:DockMargin(5, 0, 0, 0)

	local docker_box = new:Add("DScrollPanel")
	docker_box:DockMargin(5, 0, 0, 0)
	docker_box:Dock(TOP)


	local DermaCheckbox = docker_box:Add( "DCheckBox" )
	DermaCheckbox:Dock(LEFT)
		//DermaCheckbox:SetText(" ")
	DermaCheckbox:TDLib()
	:SquareCheckbox(Color(39, 174, 96))
	DermaCheckbox.OnChange = function(s, bVal)
		self.flagData.teamBased = bVal
	end

	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Shape")
	label:DockMargin(5, 0, 0, 0)

	local docker_box = new:Add("DScrollPanel")
	docker_box:DockMargin(5, 0, 0, 2)
	docker_box:Dock(TOP)

	local DComboBox = docker_box:Add( "DComboBox" )
	DComboBox:Dock(LEFT)
	DComboBox:DockMargin(0, 0, 0, 0)
	DComboBox:SetValue( "square" )
	DComboBox:AddChoice( "square" )
	DComboBox:AddChoice( "circle" )
	self.flagData.shape = "square"
	DComboBox.OnSelect = function( panel, index, value )
		self.flagData.shape = tostring(value)
	end



	local label = new:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Blacklist Teams")
	label:DockMargin(5, 0, 0, 0)

	local AppList = new:Add( "DListView")
	AppList:Dock( TOP )
	AppList:SetTall(100)
	AppList:DockMargin(5, 5, 5, 0)
	AppList:SetMultiSelect( true )
	if DarkRP then
		AppList:AddColumn( "Team" )
		AppList:AddColumn( "Category" )
	else
		AppList:AddColumn( "Team" )
	end

	if DarkRP then
		local jobs = DarkRP.getCategories()
		
		if (jobs) then
			jobs = DarkRP.getCategories().jobs

			for k,v in pairs(DarkRP.getCategories().jobs) do
				for i,j in pairs(v.members) do
					AppList:AddLine(j.command, j.category)
				end
			end
		else
			print('[CONQUEST] CRITICAL ERROR. NO DARKRP CATEGORIES EXIST. OR JOBS. ')
			print('[CONQUEST] CRITICAL ERROR. NO DARKRP CATEGORIES EXIST. OR JOBS. ')
			print('[CONQUEST] CRITICAL ERROR. NO DARKRP CATEGORIES EXIST. OR JOBS. ')
		end


	else
		local teams = team.GetAllTeams()

		for k,v in pairs(teams) do
			AppList:AddLine(v.Name)
		end
	end

	AppList.OnRowSelected = function( lst, index, pnl )
		table.insert(self.flagData.teams, pnl:GetColumnText( 1 ))
	end


	local create_btn = new:Add('DButton')
	create_btn:SetText("Create")
	create_btn:DockMargin(5, 15, 5, 0)
	create_btn:Dock(TOP)
	create_btn:TDLib():Background(Color(76, 175, 80)):FadeHover()
	create_btn:SetTextColor(color_white)
	create_btn.DoClick = function(s)
		net.Start("conquest_create")
			net.WriteTable(self.flagData)
		net.SendToServer()
		self:Remove()
	end

	self.container:AddSheet( "Create", new, newplus)

	local edit = self.container:Add("DScrollPanel")
	edit:Dock(FILL)

	local points = Conquest.cache

	local navigation = edit:Add("DIconLayout")
	navigation:Dock(TOP)
	navigation:DockMargin(3, 3, 0, 0)
	navigation:SetSpaceX(5)

	local flush = navigation:Add('DButton')
	flush:SetSize(100, 25)
	flush:SetText("Reset Points")
	flush:TDLib():Background(Color(231, 76, 60)):Outline(Color(0, 0, 0, 200)):FadeHover()
	flush:SetTextColor(color_white)
	flush.DoClick = function(s)
		net.Start("conquest_resetall")
		net.SendToServer()
	end

	local flush = navigation:Add('DButton')
	flush:SetSize(100, 25)
	flush:SetText("Reset Point")
	flush:TDLib():Background(Color(230, 126, 34)):Outline(Color(0, 0, 0, 200)):FadeHover()
	flush:SetTextColor(color_white)
	flush:On("DoClick", function(s)
		if (points) then
			local Menu = DermaMenu()
			for k,v in pairs(points) do
				Menu:AddOption(v.name, function()
					net.Start("conquest_reset")
						net.WriteInt(k, 16)
					net.SendToServer()
				end)
			end	
			Menu:Open()
		end
	end)


	
	if (points) then
		for k,v in pairs(points) do

			local bar = edit:Add('DPanel')
			bar:Dock(TOP)
			bar:DockMargin(5, 5, 5, 0)
			bar:SetTall(40)
			bar:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
			:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
			:FadeHover()
			bar.id = k

			local label = bar:Add('DLabel')
			label:Dock(LEFT)
			label:SetWide(100)
			label:SetText(v.name or "nil")
			label:SetAutoStretchVertical( true )
			label:DockMargin(10, 7, 0, 0)
			label:SetFont('Trebuchet24')
			label:SetTextColor(color_white)

			local edit = bar:Add('DButton')
			edit:Dock(RIGHT)
			edit:DockMargin(1, 5, 3, 5)
			edit:SetText('Edit')
			edit:SetTextColor(color_white)
			edit.DoClick = function(s)
				if !(bar.id) then return end

				EditPoint(self, v, k)

			end
			edit:TDLib():Background(Color(46, 204, 113)):Outline(Color(32, 32, 32)):FadeHover()

			local delete = bar:Add('DButton')
			delete:Dock(RIGHT)
			delete:DockMargin(1, 5, 1, 5)
			delete:SetText("Delete")
			delete:SetTextColor(color_white)
			delete.DoClick = function(s)
				net.Start("conquest_delete")
					net.WriteInt(bar.id, 16)
				net.SendToServer()
				self:Remove()
			end
			delete:TDLib():Background(Color(231, 76, 60)):Outline(Color(32, 32, 32)):FadeHover()


		end
	end

	if table.Count(points) <= 0 then
		local error_nopoint = edit:Add("DLabel")
		error_nopoint:Dock(TOP)
		error_nopoint:DockMargin(5, 5, 5, 0)
		error_nopoint:SetText("No valid capture points. Create one!")
		error_nopoint:SetAutoStretchVertical( true )
		error_nopoint:SetWrap(true)
	end

	self.container:AddSheet( "Edit", edit, settings)

	local docker_c = self.container:Add('DScrollPanel')
	docker_c:Dock(FILL)

	self.properties = docker_c:Add("DProperties")
	self.properties:SetSize(self:GetWide()*0.835, self:GetTall())


	local sorted = {}

	for k,v in pairs(Conquest.Config.cache) do
		sorted[v.cat] = sorted[v.cat] or {}

		sorted[v.cat][k] = v
	end

	for cat, config in SortedPairs(sorted) do

		for k, v in SortedPairs(config) do

			local value = Conquest.Config.cache[k].default
			local form;

			local ourType = type(value)

			if (ourType == "number") then
				form = "Int"
				value = tonumber(Conquest.Config.get(k)) or value
			elseif (ourType == "boolean") then
				form = "Boolean"
				value = util.tobool(Conquest.Config.get(k))
			else
				form = "Generic"
				value = Conquest.Config.get(k) or value
			end

			if (form == "Generic" and type(value) == "table" and value.r and value.g and value.b) then
				value = Vector(value.r / 255, value.g / 255, value.b / 255)
				form = "VectorColor"
			end

			local row = self.properties:CreateRow(cat, k)
			row:SetTooltip(v.desc)
			if form == "Int" then
				row:Setup(form, {min = 0, max = 8000})
			else
				row:Setup(form, {})
			end

			row:SetValue(value)
			row.DataChanged = function(this, value)
				// We have to delay. We're gonna update this menu in real-time //
				self:SetSaving()
				timer.Create("conquest_realtime"..k, 1, 1, function()
					if (IsValid(row)) then

						if (form == "VectorColor") then
							local vector = Vector(value)

							value = Color(math.floor(vector.x * 255), math.floor(vector.y * 255), math.floor(vector.z * 255))

						elseif (form == "Int" or form == "Float") then
							value = tonumber(value)

							if (form == "Int") then
								value = math.Round(value)
							end
						elseif (form == "Generic") then
							value = tostring(value)
						elseif (form == "Boolean") then
							value = util.tobool(value)
						end

						local ourdata = {}
						ourdata[k] = value

						net.Start('conquest_config_write')
							net.WriteTable(ourdata)
						net.SendToServer()
					end
					self:FinishSaving()
				end)
			end
		end

	end

	self.container:AddSheet( "Config", docker_c, tools)


	// Teams //
	local docker_d = self.container:Add('DScrollPanel')
	docker_d:Dock(FILL)

	local current_teams = Conquest.TeamManager.cache

	local navigation = docker_d:Add("DIconLayout")
	navigation:Dock(TOP)
	navigation:DockMargin(3, 3, 0, 0)
	navigation:SetSpaceX(5)

	local flush = navigation:Add('DButton')
	flush:SetSize(100, 25)
	flush:SetText("Rebuild Teams")
	flush:TDLib():Background(Color(231, 76, 60)):Outline(Color(0, 0, 0, 200)):FadeHover()
	flush:SetTextColor(color_white)
	flush.DoClick = function(s)

	end

	local flush = navigation:Add('DButton')
	flush:SetSize(100, 25)
	flush:SetText("Create New Team")
	flush:TDLib():Background(Color(230, 126, 34)):Outline(Color(0, 0, 0, 200)):FadeHover()
	flush:SetTextColor(color_white)
	flush:On("DoClick", function(s)
		TeamCreation(self)
	end)

	if (current_teams) then
		for k,v in pairs(current_teams) do

			local bar = docker_d:Add('DPanel')
			bar:Dock(TOP)
			bar:DockMargin(5, 5, 5, 0)
			bar:SetTall(40)
			bar:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
			:SideBlock(v.color)
			:FadeHover()
			bar.id = k

			local label = bar:Add('DLabel')
			label:Dock(LEFT)
			label:SetWide(100)
			label:SetText(k or "nil")
			label:SetAutoStretchVertical( true )
			label:DockMargin(10, 7, 0, 0)
			label:SetFont('Trebuchet24')
			label:SetTextColor(color_white)
			label:SizeToContents()

			local edit = bar:Add('DButton')
			edit:Dock(RIGHT)
			edit:DockMargin(1, 5, 3, 5)
			edit:SetText('Edit')
			edit:SetTextColor(color_white)
			edit.DoClick = function(s)
				//if !(bar.id) then return end
				
				TeamEdit(self, v, k)

			end
			edit:TDLib():Background(Color(46, 204, 113)):Outline(Color(32, 32, 32)):FadeHover()

			local delete = bar:Add('DButton')
			delete:Dock(RIGHT)
			delete:DockMargin(1, 5, 1, 5)
			delete:SetText("Delete")
			delete:SetTextColor(color_white)
			delete.DoClick = function(s)
				Derma_Query("Are you sure you want to delete this team?", "",
					"Yes",
					function() 

					net.Start("conquest.team.remove")
						net.WriteString(bar.id)
					net.SendToServer()

				self:Remove()
					end,
					"No",

					function() 
				end)


			end
			delete:TDLib():Background(Color(231, 76, 60)):Outline(Color(32, 32, 32)):FadeHover()


		end
	end


	if table.Count(current_teams ) <= 0 then
		local error_nopoint = docker_d:Add("DLabel")
		error_nopoint:Dock(TOP)
		error_nopoint:DockMargin(5, 5, 5, 0)
		error_nopoint:SetText("No valid teams. Create one!")
		error_nopoint:SetAutoStretchVertical( true )
		error_nopoint:SetWrap(true)
	end




	self.container:AddSheet("Teams", docker_d, teampng)
end

function PANEL:SetSaving()
	self.saving = true

	self.exit:SetDisabled(true)

	self.savingMenu = self:Add('DPanel')
	self.savingMenu:SetSize(300, 75)
	self.savingMenu:Center()

	local dbutton = self.savingMenu:Add('DButton')
	dbutton:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	dbutton:Text("Saving Config... Please wait.")
	dbutton:Dock(FILL)

	-- timer.Simple(2, function()
	-- 	if (self.savingMenu) then

	-- 		self.savingMenu:Remove()
	-- 		self.savingMenu = nil
	-- 	end
	-- end)
end

function PANEL:FinishSaving()
	self.saving = false

	self.exit:SetDisabled(false)

	if (self.savingMenu) then

		self.savingMenu:Remove()
		self.savingMenu = nil
	end
end

function PANEL:Think()
    if input.IsKeyDown(KEY_F1) then
        self:Remove()
    end
end

function PANEL:Paint()
	Derma_DrawBackgroundBlur( self, self.startTime )
end

vgui.Register("ConquestMenu", PANEL, 'EditablePanel')


net.Receive("conquest_openMain", function()
	if conquest_main then
		conquest_main:Remove()
	end

	conquest_main = vgui.Create('ConquestMenu')
end)