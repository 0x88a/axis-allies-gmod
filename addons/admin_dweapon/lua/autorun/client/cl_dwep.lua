
include("autorun/sh_dwep_config.lua")

local scrw = ScrW()
local scrh = ScrH()
local colors = DWEP.Config.Colors
local background = colors["background"]
local foreground = colors["foreground"]
local inactiveClr = colors["inactiveClr"]
local theme = colors["theme"] 
local highlight = Color(theme.r, theme.g, theme.b, 10)
surface.CreateFont( "dwep_24", { font = "Roboto", size = 24, weight = 600, bold = true, strikeout = false, outline = false, shadow = false, outline = false,})
surface.CreateFont( "dwep_22", { font = "Roboto", size = 22, weight = 600, bold = true, strikeout = false, outline = false, shadow = false, outline = false,})
surface.CreateFont( "dwep_20", { font = "Roboto", size = 20, weight = 600, bold = true, strikeout = false, outline = false, shadow = false, outline = false,})
surface.CreateFont( "dwep_18", { font = "Roboto", size = 18, weight = 600, bold = true, strikeout = false, outline = false, shadow = false, outline = false,})
surface.CreateFont( "dwep_16", { font = "Roboto", size = 16, weight = 600, bold = true, strikeout = false, outline = false, shadow = false, outline = false,})
DWEP.SearchData = DWEP.SearchData or {
	["search"] = "",
	["results"] = DWEP.Sweps,
	["searchTime"] = 0,
	["searchComplete"] = 0,
}

hook.Add("InitPostEntity", "LoadDWEPData", function()

	net.Start("dwep_load_weapon")
	net.SendToServer()

end)

net.Receive("dwep_load_weapon", function()

	local updateData = net.ReadTable()
	local class = net.ReadString()

	for k,v in pairs(updateData) do
		DWEP.AdjustValue(class, k, v)
	end 

end)

local function generateSearch()

	if not DWEP.Menu then return end 
	local searchResults = DWEP.SearchData["results"]
	local searchScroll = DWEP.Menu.SearchPanel.ScrollPanel
	searchScroll.ypos = 0
	local highlight = Color(theme.r, theme.g, theme.b, 10)
	for k,v in pairs(searchResults) do
		local id = #DWEP.Menu.SearchPanel.Results + 1 or 1
		DWEP.Menu.SearchPanel.Results[id] = vgui.Create("DButton", searchScroll)
		local resultPanel = DWEP.Menu.SearchPanel.Results[id]
		resultPanel.value = v
		resultPanel:SetPos(0,searchScroll.ypos)
		resultPanel:SetSize(searchScroll:GetWide(), 29)
		resultPanel:SetText("")
		local name = weapons.GetStored(v).PrintName or "Missing PrintName"
		local barClr = k % 2 == 0 and foreground or Color(foreground.r, foreground.g, foreground.b, 150)
		resultPanel.Paint = function(me,w,h)
			surface.SetDrawColor(barClr)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText(string.upper(v .. " - " .. name), "dwep_20", w * .05, h / 2, string.find(v, DWEP.SearchData["search"]) and color_white or inactiveClr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if me:IsHovered() then 
				surface.SetDrawColor(highlight)
				surface.DrawRect(0,0,w,h)
			end 

		end 
		resultPanel.DoClick = function()
			OpenDWEPWeapon(v)
		end 
		searchScroll.ypos = searchScroll.ypos + 29 * 1.05
	end 

end 

local oldResults = {}
local function refreshResults()
	if IsValid(DWEP.Menu) and IsValid(DWEP.Menu.SearchPanel) then
		if DWEP.SearchData["results"] != oldResults then 
			DWEP.SearchData["searchTime"] = nil
			local total = #DWEP.Menu.SearchPanel.Results
			for k,v in pairs(DWEP.Menu.SearchPanel.Results) do
				v:Remove()
			end 
			generateSearch()
		end 
	end 

end 

 
local function updateSearch(searchText, forward)

	local searchData = DWEP.SearchData 
	local results = searchData["results"] 
	searchData["search"] = searchText
	local searchTable = DWEP.Sweps

	if #results <= 0 or not forward then
		searchTable = DWEP.Sweps
	elseif #results >= 0 and forward then
		searchTable = results
	end 
	results = {}
	local searchTotal = #searchTable
	timer.Create("dwep_searchtime", .5, 1, function()
		searchData["searchTime"] = CurTime()
	end)
	
	for i = 1 , searchTotal do
		local v = searchTable[i]
		if string.find(v, searchText) and not table.HasValue(results, v) then
			results[#results + 1 or 1] = v
			if i >= searchTotal then
				searchData["results"] = results
			end 
		else
			searchTotal = searchTotal - 1
		end
	end 
end 

local barClr = Color(foreground.r, foreground.g, foreground.b, 150)
local function paintSbar(sbar)

local bar = sbar:GetVBar()

local buttH = 0
function bar.btnUp:Paint( w, h )
	buttH = h
end

function bar:Paint( w, h )
	draw.RoundedBox( 8, w / 2 - w / 2, buttH, w / 2, h - buttH * 2, barClr )
end

function bar.btnDown:Paint( w, h )
	
end
function bar.btnGrip:Paint( w, h )
	draw.RoundedBox( 8, w / 2 - w / 2, 0, w / 2, h , theme )
end
 
end 


function OpenDWEP(refresh)
	if not DWEP.CanDWEP(LocalPlayer()) then return end 
	DWEP.Menu = vgui.Create("DFrame")
	local dmenu = DWEP.Menu
	if not refresh then 
		dmenu:SetPos(scrw / 2 - scrw * .25, scrh * 2)
		dmenu:MoveTo(scrw / 2 - scrw * .25, scrh / 2 - scrh * .3, .5)
	else
		dmenu:SetPos(scrw / 2 - scrw * .25, scrh / 2 - scrh * .3)
	end 
	dmenu:SetSize(scrw * .5, scrh * .6)
	dmenu:SetTitle("")
	dmenu:MakePopup()
	dmenu.Paint = function(me,w,h)
		surface.SetDrawColor(background)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(foreground)
		surface.DrawRect(0,0,w,h * .05)
		draw.SimpleText("DWeapon Editor", "dwep_22", w / 2, h * .025, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end 
	local frameW, frameH = dmenu:GetWide(), dmenu:GetTall()
	DWEP.Menu.SearchPanel = vgui.Create("DPanel", dmenu)
	DWEP.Menu.SearchPanel.Results = DWEP.Menu.SearchPanel.Results or {}
	local searchPanel = DWEP.Menu.SearchPanel
	searchPanel:SetPos(0, frameH * .05)
	searchPanel:SetSize(frameW, frameH * .95)
	local searchData = DWEP.SearchData
	searchPanel.Paint = function(me,w,h)
		--draw.SimpleText("Weapons: ", "dwep_22", frameW * .05, frameH * .025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, w / 2 - w * .25, h * .108, w * .5, h * .025, foreground)
		if searchData["searchTime"] then
			local searchTime = searchData["searchTime"] * 100
			local waitTime = .35 * 100
			draw.RoundedBox(8, w / 2 - w * .25, h * .108, (w * .5) * ( math.Clamp(math.ceil(searchTime - CurTime() * 100) * -1, 0, waitTime) /  waitTime), h * .025, theme)
		end 
		--if searchData["results"] then
			draw.SimpleText(#searchData["results"] .. " Results", "dwep_20", w / 2, h * .97, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--end 
	end 
	local oldstring = DWEP.SearchData["search"]
	local searchBar = vgui.Create("DTextEntry", searchPanel)
	searchBar:SetFont("dwep_20")
	searchBar:SetPos(frameW * .05, frameH * .05)
	searchBar:SetSize(frameW * .9, frameH * .045)
	searchBar:SetUpdateOnType(true)
	searchBar.Paint = function(me,w,h) 
		surface.SetDrawColor(foreground)
		surface.DrawRect(0,0,w,h)
		me:DrawTextEntryText(color_white, theme, theme)
		if string.len(me:GetText()) <= 0 then
			draw.SimpleText("Search Weapons..", "dwep_20", 5, h / 2, Color(80, 80, 80, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end  
	end
	searchBar:SetValue(DWEP.SearchData["search"] or "")
	function searchBar:OnValueChange(value)
		oldstring = DWEP.SearchData["search"]
		local forward = false
		if #value > #oldstring then
			forward = true 
		end 
		updateSearch(value, forward)
	end 
 
	DWEP.Menu.SearchPanel.ScrollPanel = vgui.Create("DScrollPanel", searchPanel)
	local searchScroll = DWEP.Menu.SearchPanel.ScrollPanel
	searchScroll:SetPos(frameW * .05, frameH * .135)
	searchScroll:SetSize(frameW * .9, frameH * .75)
	paintSbar(searchScroll)

	generateSearch()


end 


hook.Add("Think", "DWEP_SearchUpdate", function()

	if DWEP.SearchData["searchTime"] and DWEP.SearchData["searchTime"] + .35 < CurTime() then
		refreshResults()
		DWEP.SearchData["searchTime"] = nil
	end  

end)
local checked = Material("dconfig/checked.png")


local function formatWeapon(weaponData)

	local updateData = {} 
	local function formatWeaponData(tbl, parent)
		for k, v in pairs(tbl) do
			if type(v) != "function" then 
				if type(v) == "table" then
					formatWeaponData(v, parent .. " | " .. k)
				else
					updateData[parent .. " | " .. k] = v
				end 
			end 
		end 

	end 

	for k,v in pairs(weaponData) do
		local valType = type(v)
		if valType == "table" then 
			formatWeaponData(v, k) 
		elseif valType != "Vector" and valType != "function" then 
			updateData[k] = v
		end 
	end 
	return updateData 
end 

local function UpdateWeapon(class, data)

	for k,v in pairs(data) do
		DWEP.AdjustValue(class, k, v)
	end 
	
	net.Start("dwep_update_weapon")
	net.WriteTable(data)
	net.WriteString(class)
	net.SendToServer()
	

end  

local optionButtons = {
	["Delete Data"] = {color = theme, callback = function(class, data)
		local weapon = weapons.GetStored(class) 
		weapon = DWEP.DefaultSweps[class]
		net.Start("dwep_reset_weapon")
		net.WriteString(class)
		net.SendToServer()
		DWEP.Menu:Remove()
		OpenDWEP(true) 
		LocalPlayer():ChatPrint("Deleting data requires a server reset for values to return to default.")
		LocalPlayer():ChatPrint(class .. " data has been deleted.")
	end},
	["Save"] = {color = theme, callback = function(class, data) UpdateWeapon(class, data) end},
	["Close"] = {color = foreground, callback = function() DWEP.Menu:Remove() OpenDWEP(true) end},
}

local function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

function OpenDWEPWeapon(class)

	local parent = DWEP.Menu
	local weapon = weapons.GetStored(class) or nil
	local updateData = {}
	if weapon and IsValid(parent) then 
		local drawData = {
			["name"] = weapon.PrintName or "Missing Printname",
		}
		local searchPanel = DWEP.Menu.SearchPanel 
		searchPanel:Remove()
		DWEP.Menu.WeaponEditor = vgui.Create("DPanel", parent)
		local weaponEditor = DWEP.Menu.WeaponEditor
		weaponEditor:SetPos(0,parent:GetTall() * .05)
		weaponEditor:SetSize(parent:GetWide(), parent:GetTall())
		weaponEditor.Paint = function(me,w,h)

		end 
		local frameW,frameH = weaponEditor:GetWide(), weaponEditor:GetTall()

		local offset = frameW / 2 - frameW * .4
		local count = -1
		for k,v in pairs(optionButtons) do 
			count = count + 1
			local optionButton = vgui.Create("DButton", weaponEditor)
			optionButton:SetPos(offset + frameW * .2 + (count * weaponEditor:GetWide() * .2) + 10, weaponEditor:GetTall() * .15)
			optionButton:SetSize(weaponEditor:GetWide() * .2 , weaponEditor:GetTall() * .05)
			optionButton:SetText("")
			optionButton.Paint = function(me,w,h)
				surface.SetDrawColor(foreground)
				surface.DrawRect(0,0,w,h)
				draw.SimpleText(k, "dwep_20", w / 2, h /2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if me:IsHovered() then 
					surface.SetDrawColor(highlight)
					surface.DrawRect(0,0,w,h)
				end 
			end 
			optionButton.DoClick = function()
				v.callback(class, updateData)
			end 
		end 
		local weaponModel = vgui.Create("DModelPanel", weaponEditor)
		local model = weapon.WorldModel

		if not model or #model <= 0 then
			model = "models/weapons/w_crowbar.mdl"
		end 
		local previewSize = frameW * .4
		weaponModel:SetPos(offset, frameH * .05 )
		weaponModel:SetSize(previewSize * .5, frameH * .15)
		weaponModel:SetModel(model)
		function weaponModel:LayoutEntity( Entity ) return end 
		local CamPos = Vector( 15, -6, 60 )
		local LookAt = Vector( 0, 0, 60 )
		weaponModel.Entity:SetPos( weaponModel.Entity:GetPos() + Vector(0,0,-2))
		weaponModel:SetFOV(50)
		weaponModel:SetCamPos( CamPos )
		weaponModel:SetLookAt( LookAt ) 
		local num = .7
		local min, max = weaponModel.Entity:GetRenderBounds()
		weaponModel:SetCamPos(min:Distance(max) * Vector(num, num, num))
		weaponModel:SetLookAt((max + min) / 2)
		local oldPaint = weaponModel.Paint
		weaponModel.Paint = function(me,w,h)
			surface.SetDrawColor(foreground)
			surface.DrawRect(0,0,w,h)
			oldPaint(me,w,h)
			draw.SimpleText(string.upper(drawData["name"]), "dwep_18", w / 2, h * .1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(string.upper(class), "dwep_18", w / 2, h * .9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end 
		local weaponScroll = vgui.Create("DScrollPanel", weaponEditor)  
		weaponScroll:SetPos(0, frameH * .22)
		weaponScroll:SetSize(frameW, frameH - frameH * .29)
		paintSbar(weaponScroll)

		local ypos = 0
		local inputSize = offset * 4
		local inputColor = Color(foreground.r, foreground.g, foreground.b, 150)
		local parents = {}
		local parentLayer = nil 
		local weaponData = formatWeapon(weapon) 
		for k,v in orderedPairs(weaponData) do
		local defaultValue = ""
			if type(v) == "Vector" or type(v) == "Angle" then continue end
			--if type(v) == "table" then updateData[parentLayer][k] = {value = v, changed = true, parent = parentLayer} targetUpdate = updateData[parentLayer][k]  end 
			local configOption = vgui.Create("DPanel", weaponScroll)
			configOption:SetPos(offset, ypos)
			configOption:SetSize(weaponScroll:GetWide() - offset * 2, 29)
			configOption.Paint = function(me,w,h) 
				surface.SetDrawColor(foreground)
				surface.DrawRect(0,0,w - inputSize - 2,h)
				me:DrawTextEntryText(color_white, theme, theme)
				draw.SimpleText(k .. ":", "dwep_16", 5, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			if type(v) == "string" or type(v) == "number" then
				local configInput = vgui.Create("DTextEntry", weaponScroll)
				configInput:SetPos(weaponScroll:GetWide() - offset - inputSize, ypos)
				configInput:SetSize(inputSize, 29)
				configInput:SetFont("dwep_16")
				configInput:SetUpdateOnType(true)
				configInput.Paint = function(me,w,h)
					surface.SetDrawColor(inputColor)
					surface.DrawRect(0,0,w,h)
					me:DrawTextEntryText(color_white, theme, theme)
					if string.len(me:GetText()) <= 0 and type(defaultValue) == "string" and string.len(defaultValue) > 0 then
						draw.SimpleText("Default: " .. defaultValue, "hub_20", 5, h / 2, Color(80, 80, 80, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end 
				end
				if type(v) == "number" then
					configInput:SetNumeric(true)
				end 
				configInput:SetValue(v)
				function configInput:OnValueChange(value)
					if type(v) == "string" then
						value = tostring(value)
					else
						value = tonumber(value)
					end 
					updateData[k] = value
				end 
			end 
			if type(v) == "boolean" then
				local configInput = vgui.Create("DCheckBox", weaponScroll)
				configInput:SetPos(weaponScroll:GetWide() - offset - inputSize, ypos)
				configInput:SetSize(29, 29)
				configInput.Paint = function(me,w,h)
					surface.SetDrawColor(foreground)
					surface.DrawRect(0,0,w,h) 
					if me:GetChecked() then
						surface.SetDrawColor(theme)
						surface.SetMaterial(checked)
						surface.DrawTexturedRect(0,0,w,h)
					elseif me:IsHovered() then
						surface.SetDrawColor(highlight)
						surface.SetMaterial(checked)
						surface.DrawTexturedRect(0,0,w,h)
					end 

				end

				function configInput:OnChange(value)
					updateData[k] = value
				end 
				configInput:SetChecked(v)
			end
			ypos = ypos + 29 * 1.1
		end
	end
end 



concommand.Add("dwep", OpenDWEP)

