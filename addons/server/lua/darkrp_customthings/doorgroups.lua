--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)


AddDoorGroup(
	"Axis", 
	TEAM_WEHRMACHT_GENERALMAJOR, 
	TEAM_WEHRMACHT_OBERST,
	TEAM_SS_BRIGADEFUHRER,
	TEAM_SS_OBERFUHRER,
	TEAM_SS_ENLISTED,
	TEAM_SS_NCO,
	TEAM_SS_OFFICER,
	TEAM_SS_FELD,
	TEAM_SS_FELD_OFFICER,
	TEAM_W_ENLISTED,
	TEAM_W_NCO,
	TEAM_W_OFFICER,
	TEAM_W_MG,
	TEAM_W_MEDIC
)

AddDoorGroup(
	"Allies", 
	TEAM_US_MAJORGENERAL,
	TEAM_US_COLONEL,
	TEAM_US_ENLISTED,
	TEAM_US_NCO,
	TEAM_US_OFFICER,
	TEAM_US_MEDIC,
	TEAM_US_SNIPER,
	TEAM_US_MG,
	TEAM_US_MP_ENLISTED
)


AddDoorGroup(
	"Axis: High Command", 
	TEAM_WEHRMACHT_GENERALMAJOR, 
	TEAM_WEHRMACHT_OBERST,
	TEAM_SS_BRIGADEFUHRER,
	TEAM_SS_OBERFUHRER
)

AddDoorGroup(
	"Allies: High Command", 
	TEAM_US_MAJORGENERAL,
	TEAM_US_COLONEL
)