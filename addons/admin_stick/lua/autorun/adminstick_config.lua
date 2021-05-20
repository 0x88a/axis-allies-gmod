-- You can find all the administration tools inside the weapons folder (shared.lua).
-- Lua knowledge is required to modify/add tools! 

CH_AdminStick = CH_AdminStick or {}
CH_AdminStick.Config = CH_AdminStick.Config or {}

CH_AdminStick.Config.UseULX = false -- If you use ULX change this to true. If not, leave it as false! 
CH_AdminStick.Config.UseSteamIDs = false -- If you want to give specific SteamID's the stick change this to true. If not, leave it as false!
CH_AdminStick.Config.UseSpecificTeams = false -- If you want to give specific teams the stick change this to true. If not, leave it as false!

CH_AdminStick.Config.ULXRanks = { -- List of ULX teams that receives the admin stick. 
	"admin",
	"superadmin"
}

CH_AdminStick.Config.SteamIDs = { -- List of SteamIDs that receives the admin stick. 
	"STEAM_0:0:1",
	"STEAM_0:0:1",
	"STEAM_0:0:1" -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

CH_AdminStick.Config.SpecificTeams = { -- List of DarkRP teams that receives the admin stick. 

}