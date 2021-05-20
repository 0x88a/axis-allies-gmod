--[[---------------------------------------------------------------------------
Group chats
---------------------------------------------------------------------------
Team chat for when you have a certain job.
e.g. with the default police group chat, police officers, chiefs and mayors can
talk to one another through /g or team chat.

HOW TO MAKE A GROUP CHAT:
Simple method:
GAMEMODE:AddGroupChat(List of team variables separated by comma)

Advanced method:
GAMEMODE:AddGroupChat(a function with ply as argument that returns whether a random player is in one chat group)
This is for people who know how to script Lua.

---------------------------------------------------------------------------]]
-- Example: GAMEMODE:AddGroupChat(TEAM_MOB, TEAM_GANG)
-- Example: GAMEMODE:AddGroupChat(function(ply) return ply:isCP() end)

-- axis
GAMEMODE:AddGroupChat(
	TEAM_WEHRMACHT_OBERST,
	TEAM_SS_OBERFUHRER,
	TEAM_LUFT_OBERST,
	TEAM_SS_ENLISTED,
	TEAM_SS_NCO,
	TEAM_SS_OFFICER,
	TEAM_SS_PANZERJAGER,
	TEAM_SS_ENGINEER,
	TEAM_LUFT_ENLISTED,
	TEAM_LUFT_NCO,
	TEAM_LUFT_OFFICER,
	TEAM_LUFT_FALSCH,
	TEAM_LUFT_FALSCH_OFFICER,
	TEAM_W_ENLISTED,
	TEAM_W_NCO,
	TEAM_W_OFFICER,
	TEAM_W_MG,
	TEAM_W_MEDIC
)

GAMEMODE:AddGroupChat(
	TEAM_US_COLONEL,
	TEAM_AIR_COLONEL,
	TEAM_GB_COLONEL,
	TEAM_US_ENLISTED,
	TEAM_US_NCO,
	TEAM_US_OFFICER,
	TEAM_US_MEDIC,
	TEAM_US_SNIPER,
	TEAM_AIR_ENLISTED,
	TEAM_AIR_NCO,
	TEAM_AIR_OFFICER,
	TEAM_AIR_PARATROOPER,
	TEAM_AIR_PARATROOPER_OFFICER,
	TEAM_GB_ENLISTED,
	TEAM_GB_NCO,
	TEAM_GB_OFFICER,
	TEAM_GB_REME,
	TEAM_GB_TANKDESTROYER,
	TEAM_GB_PARATROOPER,
	TEAM_GB_PARATROOPER_OFFICER
)