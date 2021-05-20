hook.Run("DarkRPStartedLoading")

GM.Version = "2.7.0"
GM.Name = "Axis VS Allies"
GM.Author = ""

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")
GM.Sandbox = BaseClass


local function LoadModules()
    local root = GM.FolderName .. "/gamemode/modules/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        if DarkRP.disabledDefaults["modules"][folder] then continue end

        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            if File == "sh_interface.lua" then continue end
            include(root .. folder .. "/" .. File)
        end

        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            if File == "cl_interface.lua" then continue end
            include(root .. folder .. "/" .. File)
        end
    end
end

hook.Add( "SpawnMenuOpen", "SpawnMenuCheckGroup", function()
	spawnmenu.GetCreationTabs()["#spawnmenu.category.dupes"] = nil
	spawnmenu.GetCreationTabs()["#spawnmenu.category.npcs"] = nil
	spawnmenu.GetCreationTabs()["#spawnmenu.category.vehicles"] = nil
	spawnmenu.GetCreationTabs()["#spawnmenu.category.saves"] = nil
	spawnmenu.GetCreationTabs()["#spawnmenu.category.postprocess"] = nil
	
	if (LocalPlayer():IsUserGroup( "superadmin" ) or LocalPlayer():IsUserGroup( "admin" )) then
		return true
	else
		return false
	end
	--g_SpawnMenu.CustomizableSpawnlistNode:SetExpanded( false )
	--g_SpawnMenu.CustomizableSpawnlistNode:SetEnabled( true )
	--g_SpawnMenu.CustomizableSpawnlistNode.SMContentPanel:SwitchPanel()
end )

-- list.Set( "DesktopWindows", "PlayerEditor", { nil } )
-- list.Set( "DesktopWindows", "GmodLegsEditor", { nil} )
-- list.Set( "DesktopWindows", "GredwitchOptionsMenu", { nil} )

RunConsoleCommand("mat_disable_bloom", "1")
RunConsoleCommand("mat_bloomscale", "0")
concommand.Remove("kill")

GM.Config = {} -- config table
GM.NoLicense = GM.NoLicense or {}

include("config/config.lua")
include("libraries/sh_cami.lua")
include("libraries/simplerr.lua")
include("libraries/fn.lua")
include("libraries/tablecheck.lua")
include("libraries/interfaceloader.lua")
include("libraries/disjointset.lua")

include("libraries/modificationloader.lua")

hook.Call("DarkRPPreLoadModules", GM)

LoadModules()

DarkRP.DARKRP_LOADING = true
include("config/jobrelated.lua")
--include("config/addentities.lua")
include("config/ammotypes.lua")
DarkRP.DARKRP_LOADING = nil

DarkRP.finish()

hook.Call("DarkRPFinishedLoading", GM)
