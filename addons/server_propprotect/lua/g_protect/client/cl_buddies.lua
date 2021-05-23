gProtect = gProtect or {}
gProtect.BuddiesData = gProtect.BuddiesData or {}

if(file.Exists( "gp_buddies.txt", "DATA" )) then
	local data = file.Read( "gp_buddies.txt")
	data = util.JSONToTable(data)

	if !data then return end
	gProtect.BuddiesData = data
end

local classtoInt = {
	["weapon_physcannon"] = 1,
	["weapon_physgun"] = 2,
	["gmod_tool"] = 3,
	["canProperty"] = 4
}

local permissions = {
	[1] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "toolgun"), classname = "gmod_tool", int = 3},
	[2] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "gravity-gun"), classname = "weapon_physcannon", int = 1},
	[3] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "physgun"), classname = "weapon_physgun", int = 2},
	[4] = {title = slib.getLang("gprotect", gProtect.config.SelectedLanguage, "canproperty"), classname = "canProperty", int = 4}
}

local function handleBuddies(ply, weapon, int, forced)
	if !IsValid(ply) or !weapon or !int then return end

	local sid = ply:SteamID()
	local lsid = LocalPlayer():SteamID()

	gProtect.BuddiesData[lsid] = gProtect.BuddiesData[lsid] or {}
	gProtect.BuddiesData[lsid][weapon] = gProtect.BuddiesData[lsid][weapon] or {}

	local isBuddy = forced and forced or !gProtect.BuddiesData[lsid][weapon][sid]

	net.Start("gP:Buddies")
	net.WriteInt(ply:EntIndex(), 15)
	net.WriteUInt(int, 3)
	net.WriteBool(isBuddy)
	net.SendToServer()

	if !isBuddy then isBuddy = nil end

	gProtect.BuddiesData[lsid][weapon][sid] = isBuddy

	if(file.Exists( "gp_buddies.txt", "DATA" )) then
		local data = file.Read( "gp_buddies.txt")
		data = util.JSONToTable(data)

		data[lsid] = data[lsid] or {}
		data[lsid][weapon] = data[lsid][weapon] or {}
		data[lsid][weapon][sid] = isBuddy
		
		file.Write("gp_buddies.txt", util.TableToJSON(data))
	else
		local data = {[lsid] = {[weapon] = {[sid] = isBuddy}}}
		file.Write("gp_buddies.txt", util.TableToJSON(data))
	end
end

local function openBuddies()
	local buddies = vgui.Create("SFrame")
    buddies:SetSize(slib.getScaledSize(400, "x"),slib.getScaledSize(370, "y"))
    :setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "buddies-title"))
    :Center()
    :addCloseButton()
    :MakePopup()

	local player_list = vgui.Create("SListPanel", buddies.frame)
    player_list:setTitle(slib.getLang("gprotect", gProtect.config.SelectedLanguage, "player-list"))
	:addSearchbar()
	:Dock(FILL)
	:DockMargin(slib.getTheme("margin"),slib.getTheme("margin"),slib.getTheme("margin"),slib.getTheme("margin"))

    for k,v in pairs(player.GetAll()) do
        if v:IsBot() or v == LocalPlayer() then continue end
		local _, entry = player_list:addEntry(v)
		if v:GetFriendStatus() == "friend" then entry:SetZPos(-10) end
	end
	
	for k,v in ipairs(permissions) do
		local _, bttn = player_list:addButton(v.title, function() handleBuddies(player_list.selected, v.classname, v.int) end)
		bttn:setToggleable(true)

		bttn.toggleCheck = function()
			local lply = LocalPlayer()
			local ply = player_list.selected

			if !ply or !lply then return slib.getTheme("maincolor", 20) end

			local lsid = lply:SteamID()
			local sid = ply:SteamID()

			return (gProtect.BuddiesData[lsid] and gProtect.BuddiesData[lsid][v.classname] and gProtect.BuddiesData[lsid][v.classname][sid] and true or false)
		end
	end
end

hook.Add("Think", "gP:WaitOnLocalPlayer", function()
	if !IsValid(LocalPlayer()) then return end
	hook.Add("OnEntityCreated", "gP:HandleJoinedFriends", function(ent)
		if ent:IsPlayer() then
			local lply = LocalPlayer()
			
			if !IsValid(lply) then return end
	
			local lsid = lply:SteamID()
			local sid = ent:SteamID()
			if !gProtect.BuddiesData[lsid] then return end
			for k,v in pairs(gProtect.BuddiesData[lsid]) do
				if v[sid] then
					handleBuddies(ent, k, classtoInt[k], true)
				end
			end
		end
	end)
	
	for k,ply in ipairs(player.GetAll()) do
		local lsid = LocalPlayer():SteamID()
		local sid = ply:SteamID()
		if !gProtect.BuddiesData[lsid] then return end
		for k,v in pairs(gProtect.BuddiesData[lsid]) do
			if v[sid] then
				handleBuddies(ply, k, classtoInt[k], true)
			end
		end
	end

	hook.Remove("Think", "gP:WaitOnLocalPlayer")
end)

list.Set(
    "DesktopWindows", "buddies",
    {
        title = "gP: Buddies",
        icon = "gProtect/buddies.png",
        onewindow = false,
        init = function(icn, pnl)
            openBuddies()
        end
    }
)

concommand.Add("buddies", function( ply, cmd, args )
    openBuddies()
end)