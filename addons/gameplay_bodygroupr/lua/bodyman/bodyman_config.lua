BODYMAN.HelpText = [[]]

BODYMAN.HelpText_En = [[Select Bodygroups in the right-hand panel.
Drag horizontally to rotate playermodel.
Drag vertically to zoom.
Right-click and drag to position the camera.]] -- edit this to your liking.

BODYMAN.HelpText_Fr = [[Sélectionnez Bodygroups dans le panneau de droite .
Faites glisser horizontalement pour faire pivoter le joueur.
Faites glisser verticalement pour zoomer.
Faites un clic droit et faites glisser pour positionner la caméra.]]

BODYMAN.HelpText_De = [[Wähle die Körper Gruppe im rechten Feld.
Ziehe Horizontal um das Model zu drehen.
Ziehe Vertikal um an das Model heran/heraus zu zoomen.
Rechts Klick und ziehen um die Kamera zu bewegen.]]

BODYMAN.ClosetViewDistance = 256 -- how far the text can be seen on the closet
BODYMAN.ClosetName = "" -- what should the closet be called?
BODYMAN.ClosetHelpText = [[]]

BODYMAN.ClosetName_En = "Closet" -- what should the closet be called?
BODYMAN.ClosetHelpText_En = [[Press [E] to customize your
appearance.]]

BODYMAN.ClosetName_Fr = "Armoire"
BODYMAN.ClosetHelpText_Fr = [[Appuyez sur [ E ] pour personnaliser votre
apparence.]]

BODYMAN.ClosetName_De = "Kleiderschrank" -- what should the closet be called?
BODYMAN.ClosetHelpText_De = [[Drücke [E] um dein Aussehen zu verändern.]]

BODYMAN.ClosetsOnly = true -- set this to true if you think players MUST use a closet. They will not be able to access the interface normally.

BODYMAN.strings = {
	Appearance = "Appearance",
	Playermodels = "Playermodels",
	Skins = "Skins",
	Bodygroups = "Bodygroups",
	Save = "Save",
	Load = "Load",
	Remove_All = "Remove All",
	Without_Saving = "Without Saving",
	Spawn_a = "Spawn a",
	Physique = "Build",
}
BODYMAN.strings_en = {
	Appearance = "Appearance",
	Playermodels = "Playermodels",
	Skins = "Skins",
	Bodygroups = "Bodygroups",
	Save = "Save",
	Load = "Load",
	Remove_All = "Remove All",
	Without_Saving = "Without Saving",
	Spawn_a = "Spawn a",
	Physique = "Build",
}
BODYMAN.strings_fr = {
	Appearance = "Apparence",
	Playermodels = "Joueur",
	Skins = "Peau",
	Bodygroups = "Bodygroups",
	Save = "Sauvegarder l'",
	Load = "Reapparaître",
	Remove_All = "Retirer toutes les",
	Without_Saving = "sans sauvegarder",
	Spawn_a = "Apparaître",
	Physique = "Physique",
}
BODYMAN.strings_de = {
	Appearance = "Aussehen",
	Playermodels = "Spieler Modelle",
	Skins = "Haut",
	Bodygroups = "Accessoire",
	Save = "Speichern",
	Load = "Laden",
	Remove_All = "Alle entfernen",
	Without_Saving = "Ohne zu speichern",
	Spawn_a = "Erzeugen",
	Physique = "Build",
}

BODYMAN.French = false -- Set this to true if your server speaks French/Francais.
BODYMAN.German = false -- Set this to true if your server speaks German/Deutsche.

BODYMAN.ClosetsCanBreak = false -- set this to true if you want closets to be destroyable with guns
BODYMAN.ClosetHealth = 100 -- default HP of closets. increase this if you want to take more shots to destroy them.

BODYMAN.Ranks = {}

-- !! Note !! the default required access level for changing bodygroups and skins is 10. If you wanted to make bodygroupr VIP only, then you would have to change bodyman_openmenu access level.
-- Players can only access commands when their access level meets or exceeds the command's access level.
-- e.g. admin can access all commands with access level 30 or lower.

-- Any group not found defaults to access level 10.

BODYMAN.Ranks["user"] = 10 -- access levels
BODYMAN.Ranks["admin"] = 30
BODYMAN.Ranks["superadmin"] = 30

BODYMAN.PlayerAccess = {}

BODYMAN.PlayerAccess["owner_steamid"] = 50

BODYMAN.Permissions = {

	-- moderator and admin tools
	["listbodygroups"] = 30,
	["bodyman_saveclosets"] = 30,
	["bodyman_loadclosets"] = 30,
	["bodyman_removeclosets"] = 30,
	["bodyman_spawncloset"] = 30,

	-- playermodel, bodygroup and skin changes
	["bodyman_model_change"] = 10,
	["bodygroups_change"] = 10,
	["skins_change"] = 10,

	-- menus
	["bodyman_openmenu"] = 10,
	["bodyman_adminmenu"] = 30,
}


function BODYMAN:IsVip(ply)
	--edit this to fit your server
	return true
end