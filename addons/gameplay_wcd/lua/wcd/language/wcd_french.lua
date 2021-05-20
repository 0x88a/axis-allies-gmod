WCD.Lang 												= WCD.Lang or {};

/* SHARED VARIABLES */
WCD.Lang.fileNames										= WCD.Lang.fileNames or {};
WCD.Lang.fileNames.utility 								= "Utility";
WCD.Lang.fileNames.color								= "Couleur";
WCD.Lang.fileNames.settings								= "Paramètres";
WCD.Lang.fileNames.adminui								= "Admin UI";
WCD.Lang.fileNames.dealerui								= "Concessionnaire UI";
WCD.Lang.fileNames.various								= "Divers";
WCD.Lang.fileNames.vgui									= "VGUI";
WCD.Lang.fileNames.net									= "Réseau";
WCD.Lang.fileNames.clientsettings						= "Paramètres Client";
WCD.Lang.fileNames.storage								= "Stockage";
WCD.Lang.fileNames.main									= "Principale";
WCD.Lang.fileNames.vehicledata							= "Données des vehicules";
WCD.Lang.fileNames.minimal								= "Minimal Helpers";
WCD.Lang.fileNames.dealer								= "Fonctionnalité du concessionnaire";
WCD.Lang.fileNames.customization						= "Customisation des fonctionnalitées";
WCD.Lang.fileNames.fuel									= "Control de l'essence";
WCD.Lang.fileNames.visual								= "Visuel";
WCD.Lang.fileNames.designer								= "Vue Concepteur";

WCD.Lang.loadedLang										= "Language loaded!";
WCD.Lang.loadedWrapper									= "Wrapper: '[1]' a été chargé!";
WCD.Lang.loadedFile										= "File: '[1]' a été chargé!";

WCD.Lang.invalidSetting									= "Le paramètre avec la clé '[1]' n'existe pas!";
WCD.Lang.invalidTypeSetting								= "Le paramètre avec la clé '[1]' envoyé comme un type '[2]', type attendu '[3]'!";
WCD.Lang.updatedSetting									= "Paramètre '[1]' à était changé pour '[2]'";

WCD.Lang.files											= WCD.Lang.files or {};
startCreate												= "Recréation du dossier 'wcd'!";
failCreate												= "Le dossier 'wcd' ne peut pas être sauvegarder! Aucune sauvegarde n'a était faite!";
informOne												= "Le dossier 'wcd' ne peut pas être créer! Aucune sauvegarde n'a était faite!";
informTwo												= "S-il vous plait, essayer de créer manuellement de dossier 'wcd' dans garrysmod/data/!";
successCreate											= "Le dossier 'wcd' a était correctement créer!";
fileLoaded												= "Chargement des données '[1]', contient [2] valeurs.";
fileNotFound											= "Fichier '[1]' n'a pas était trouver, il va être créer si nécessaire.";
beginLoading											= "Chargement de tous les paramètres...";
savingTable												= "Sauvegarde de la table : '[1]'";

WCD.Lang.Positions										= WCD.Lang.Positions or {};
WCD.Lang.Positions[ 1 ]									= "Haut";
WCD.Lang.Positions[ 2 ]									= "Bad";
WCD.Lang.Positions[ 3 ]									= "Gauche";
WCD.Lang.Positions[ 4 ]									= "Droite";

WCD.Lang.Units											= WCD.Lang.Units or {};
WCD.Lang.Units[ 1 ] 									= "km/h";
WCD.Lang.Units[ 2 ] 									= "mp/h";

WCD.Lang.adminGun										= WCD.Lang.adminGun or {};
WCD.Lang.adminGun.instructions 							= "Clique gauche sur le concessionaire: Modifier de concessionaire\nClique gauche par terre: Faire apparaître un nouveau concessionaire\nClique droit par terre: Faire apparaître une pompe a essence\nClique gauche sur la pompe a essence : Sauvegarde\nClique droit sur la pompe a essence : Enlever la sauvegarde";
WCD.Lang.adminGun.invalidRank 							= "Tu n'es pas autorisé a utiliser cette outils.";
WCD.Lang.adminGun.aimHelp 								= "Regarde un endroit vide par terre, concessionaire ou pompe a essence.";
WCD.Lang.adminGun.saved 								= "Nouveau concessionaire et plateformes sauvegarder!";
WCD.Lang.adminGun.savedPump 							= "Pompe a essence sauvegarder.";
WCD.Lang.adminGun.deletedPump 							= "Pompe a essence enleve de la sauvegarde.";
WCD.Lang.adminGun.deleted 								= "Concessionaire et les choses relié a lui sont enlevé.";

WCD.Lang.adminGun.settings 								=	WCD.Lang.adminGun.settings or {};
WCD.Lang.adminGun.settings[	1 ]							= { key = "name", name = "Name", tooltip = "Le nom du concessionnaire", type = "string" };
WCD.Lang.adminGun.settings[	2 ]							= { key = "model", name = "Model", tooltip = "Le modèle du concessionnaire", type = "string" };
WCD.Lang.adminGun.settings[	3 ] 						= { key = "group", name = "Group", tooltip = "le groupe de concessionnaires auquel ce concessionnaire est affecté.", type = "combobox", values = "DealerGroups" };

WCD.Lang.adminGun.settings[	6 ]							= { key = "newPlatform", name = "New Spawn Platform", tooltip = "Créer une nouvelle plateforme de spawn", type = "button" };
WCD.Lang.adminGun.settings[	7 ]							= { key = "deleteAllPlatform", name = "Supprimer toutes les plates-formes (Compte: [1])", tooltip = "Supprimer toutes les plates-formes liées à ce concessionnaire.", type = "button" };


if( SERVER ) then
	WCD.Lang.initPlayer									= WCD.Lang.initPlayer or {};
	WCD.Lang.initPlayer.begin							= "Initialisation du joueur [1]";

	WCD.Lang.various									= WCD.Lang.various or {};
	WCD.Lang.various.noGroup 							= "Je n'ai pas encore été assigné à un groupe.!";
	WCD.Lang.various.cantAffordSpawn 					= "Vous ne pouvez pas vous permettre de faire apparaitre un véhicule.. ([1])";
	WCD.Lang.various.noFreeSpot 						= "Il n'y a pas de place libre pour votre véhicule, veuillez attendre que la zone soit dégagée.";
	WCD.Lang.various.customizationBought 				= "Tu as payé [1] pour la customisation.";
	WCD.Lang.various.maxCarsSpawned 					= "Vous devez d'abord rendre un véhicule.";
	WCD.Lang.various.youReturned						= "Vous avez rendu votre véhicule.";
	WCD.Lang.various.youPaidToSpawn						= "Tu as payé [1] pour faire apparaitre ton véhicule.";
	WCD.Lang.various.noneInRange						= "Aucun de vos véhicules n'est à portée.";
	WCD.Lang.various.initializing 						= "Demander des véhicules spécifiques au concessionnaire à partir du serveur... (une fois)";
	WCD.Lang.various.loadingDone 						= "Initialisation fini!";
	WCD.Lang.various.youSold 							= "Tu as vendu [1] pour [2].";
	WCD.Lang.various.inUse 								= "Cette pompe est actuellement utilisé par quelqu'un d'autre, veuillez patienter.";
	WCD.Lang.various.cantAffordFuel						= "Vous n'avez pas les moyens d'acheter du carburant !";
	WCD.Lang.various.noPlayerFound 						= "Aucun joueur ou données de joueur n'a été trouvé !";
	WCD.Lang.various.vehiclesEdited 					= "Cibles' a été mis à jour.";
else

	WCD.Lang.dealerButtonsLeft							= WCD.Lang.dealerButtonsLeft or {};
	WCD.Lang.dealerButtonsLeft							= {
		"Boutique", "Posséder", "Pas accès", "Favoris"
	};


	WCD.Lang.dealerActionButtons						= WCD.Lang.dealerActionButtons or {};
	WCD.Lang.dealerActionButtons.buy 					= "Acheter";
	WCD.Lang.dealerActionButtons.sell 					= "Vend pour [1]";
	WCD.Lang.dealerActionButtons.test 					= "Test-De-Conduite";
	WCD.Lang.dealerActionButtons.spawn 					= "Apparaitre";
	WCD.Lang.dealerActionButtons.spawnCustomize 		= "Apparaitre et customisation";
	WCD.Lang.dealerActionButtons.sure 					= "es tu sûr ?";
	WCD.Lang.dealerActionButtons.noAfford 				= "Tu ne peux pas te le permettre!";
	WCD.Lang.dealerActionButtons.sold 					= "Tu as vendu le véhicule pour [1].";

	WCD.Lang.dealerButtonsLeft							= WCD.Lang.dealerButtonsLeft or {
		"Store", "Owned", "No Access", "Favorites"
	};
	
	WCD.Lang.dealerVarious								= WCD.Lang.dealerVarious or {};
	WCD.Lang.dealerVarious.canBeCustomized 				= "Ce véhicule peut être customisé!";
	WCD.Lang.dealerVarious.canNotBeCustomized 			= "Ce véhicule ne peut pas être customisé.";
	WCD.Lang.dealerVarious.customize 					= "Apparaitre et customisé";
	WCD.Lang.dealerVarious.wallet 						= "Portefeuille: [1]";

	WCD.Lang.adminMenuButtons							= WCD.Lang.adminMenuButtons or {
		"Paramètres",
		"Véhicules",
		"Utilisateurs"
	};

	WCD.Lang.pump										= WCD.Lang.pump or {};
	WCD.Lang.pump.title = "Pompe a essence";
	WCD.Lang.pump.info =  {
		"Accepter de déverrouiller le tuyau.,",
		"placer le tuyau sur votre véhicule",
		"pour commencer à le remplir de carburant.",
	};

	WCD.Lang.pump.price = "Chaque litre coûtera [1].";
	WCD.Lang.pump.start = "J'accepte";
	WCD.Lang.pump.cancel = "Annuler";

	WCD.Lang.clientSettingsPanel						= WCD.Lang.clientSettingsPanel or {};
	WCD.Lang.clientSettingsPanel.desc 					=
[[Il s'agit des paramètres côté client!
Passez votre curseur sur une étiquette pour lire l'info-bulle.
Vous pouvez modifier ces paramètres ultérieurement à partir du menu du concessionnaire.]];

	WCD.Lang.clientSettingsPanel.save 					= "Les réglages ont été mis à jour!";

	WCD.Lang.clientSettingsPanel.data 					= WCD.Lang.clientSettingsPanel.data or {};
	WCD.Lang.clientSettingsPanel.data[ 1 ] 				= { key = "CacheOnReceive", name = "Mettre en cache tous les modèles.", tooltip = "Est-ce que toutes les voitures\ndevraient être mises en cache lorsqu'elles sont reçues du serveur ?\nSi coché, l'ouverture d'un concessionnaire pourrait geler votre jeu\npendant quelques instants.", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 2 ] 				= { key = "MoveableModel", name = "Modèle de prévisualisation ajustable", tooltip = "Voulez-vous pouvoir déplacer le modèle de voiture avec votre souris,\n dans le menu du concessionnaire ? (aucune incidence sur le rendement)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 3 ] 				= { key = "SpinModel", name = "Modèle de prévisualisation de rotation", tooltip = "Voulez-vous que la voiture tourne ?\n(pas d'effet si vous utilisez le modèle Adjustable)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 4 ] 				= { key = "SortAsc", name = "Trier les voitures en montant (le moins cher d'abord)", tooltip = "Tu veux voir les voitures les moins chères au sommet de la liste ?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 5 ] 				= { key = "Language", name = "Langue", tooltip = "Votre langue préférée.", type = "combobox", values ="Languages" };
	WCD.Lang.clientSettingsPanel.data[ 6 ] 				= { key = "Fullscreen", name = "UI du concessionnaire Plein écran", tooltip = "Voulez-vous que l'interface utilisateur\ndu concessionnaire soit en plein écran ?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 7 ] 				= { key = "DefaultDealerTab", name = "Onglet Concessionnaire par défaut", tooltip = "Quel onglet souhaitez-vous voir apparaître par défaut ?", type = "combobox", values = "dealerButtonsLeft", global = true };


	WCD.Lang.invalidSettingValue						= "Champ '[1]' a une valeur invalide ! Veuillez éditer ceci avant de procéder.";
	WCD.Lang.clientSettings								= "Paramètres";
	WCD.Lang.dealerTop									= "Concessionnaire de véhicules";
	WCD.Lang.addFavorite								= "Ajouter aux favoris";
	WCD.Lang.removeFavorite								= "Supprimer des Favoris";
	WCD.Lang.save										= "Sauvegarder";
	WCD.Lang.select 									= "Sélectionner";
	WCD.Lang.delete										= "Effacer";
	WCD.Lang.sureShort									= "Es-tu sûr?";
	WCD.Lang.edit										= "Modifier";
	WCD.Lang.choiceSaved								= "Votre choix a été sauvegardé.";
	WCD.Lang.active										= "valeur active: [1]";
	WCD.Lang.unselect									= "Désélectionner";
	WCD.Lang.none										= "Aucun";
	WCD.Lang.free										= "Gratuit";
	WCD.Lang.sure										= "Vous êtes sûr?";
	WCD.Lang.returnVehicles								= "Renvoyer le véhicule";
	WCD.Lang.fuel										= " litres";
	WCD.Lang.nitroActivated 							= "Nitro Activé";
	WCD.Lang.nitroReady									= "Prêt pour Nitro";

	WCD.Lang.requestingAllVehicles						= "Demande de véhicules à partir du serveur..";
	WCD.Lang.visibleFor									= "Visible pour: ";

	WCD.Lang.settingsSent								= "Paramètres envoyés au serveur.";
	WCD.Lang.settingsReceived							= "Nouveaux réglages reçus.";

	WCD.Lang.noSettingsChanged							= "Aucun réglage n'a été modifié!";

	WCD.Lang.designer									= WCD.Lang.designer or {};
	WCD.Lang.designer.cantBeCustomized 					= "Ce véhicule ne peut pas être personnalisé.";
	WCD.Lang.designer.purchase 							= "Acheter";
	WCD.Lang.designer.reset 							= "Full Reset";
	WCD.Lang.designer.confirmReset 						= "Pay: [x]?";
	WCD.Lang.designer.spaceToToggleMouse 				= "Appuyez sur Espace pour faire basculer le curseur.";
	WCD.Lang.designer.price 							= "[1]";
	WCD.Lang.designer.pricePerChange 					= "[1] par changement";
	WCD.Lang.designer.skinCounter 						= "[1] de [2]";
	WCD.Lang.designer.underglow 						= "'G' pour basculer le Néon";
	WCD.Lang.designer.nitroLevel 						= "Nitro niveau [1]";
	WCD.Lang.designer.uninstall 						= "Désinstaller";
	WCD.Lang.designer.totalPrice 						= "Prix total: [1]";
	WCD.Lang.designer.cantAfford 						= "Vous ne pouvez pas vous permettre [1] pour payer les modifications.";

	WCD.Lang.designer.buttons 							= WCD.Lang.designer.buttons or {};
	WCD.Lang.designer.buttons[ 1 ]						= { key = "skin", name = "Peau" };
	WCD.Lang.designer.buttons[ 2 ]						= { key = "color", name = "Couleur" };
	WCD.Lang.designer.buttons[ 3 ]						= { key = "bodygroups", name = "Groupes de corps" };
	WCD.Lang.designer.buttons[ 4 ]						= { key = "underglow", name = "Néon" };
	WCD.Lang.designer.buttons[ 5 ]						= { key = "nitro", name = "Nitro" };

	WCD.Lang.AccessHelper								= WCD.Lang.AccessHelper or {};
	WCD.Lang.AccessHelper.create 						= "Nouveau groupe d'accès";
	WCD.Lang.AccessHelper.editing 						= "Édition [1]";
	WCD.Lang.AccessHelper.jobs 							= "Sélectionner des métiers";
	WCD.Lang.AccessHelper.ranks 						= "Sélectionner les rangs";
	WCD.Lang.AccessHelper.needBoth 						= "Exiger les deux grades + métiers";
	WCD.Lang.AccessHelper.newGroupName 					= "Nouveau nom de groupe";
	WCD.Lang.AccessHelper.needName 						= "Vous devez insérer un nom pour le groupe!";
	WCD.Lang.AccessHelper.existingGroups 				= "Groupes d'accès existants";

	WCD.Lang.DealerHelper								= WCD.Lang.DealerHelper or {};
	WCD.Lang.DealerHelper.create 						= "Nouveau groupe de concessionnaires";
	WCD.Lang.DealerHelper.editing 						= "Édition [1]";
	WCD.Lang.DealerHelper.needName 						= "Vous devez insérer un nom pour le groupe!";
	WCD.Lang.DealerHelper.newGroupName 					= "Nouveau nom de groupe";
	WCD.Lang.DealerHelper.existingGroups 				= "Groupes de concessionnaires existantss";

	WCD.Lang.adminTabs									= WCD.Lang.adminTabs or {};
	WCD.Lang.adminTabs.settings							= WCD.Lang.adminTabs.settings or {};
	WCD.Lang.adminTabs.settings.title 					= "Réglages";
	WCD.Lang.adminTabs.settings.desc 					=
[[Ce sont tous les réglages qui peuvent être édités ! Editez-les ici, pas via le fichier wcd_settings.lua (ils peuvent être écrasés).
Seuls les paramètres et les rangs MySQL qui ont accès à !wcd doivent être édités via les fichiers : wcd_settings.lua(rangs) et server/wcd_storage.lua(MySQL).
Passez votre souris sur une étiquette pour obtenir plus d'informations sur le réglage !
OBS : Vous pouvez faire défiler vers le haut/bas!]];

	WCD.Lang.adminTabs.settings.content 				= WCD.Lang.adminTabs.settings.content or {};
	WCD.Lang.adminTabs.settings.content[ 1 ]			= { key = "header", text = "Réglages généraux" };
	WCD.Lang.adminTabs.settings.content[ 2 ]			= { key = "fuel", name = "Activer le carburant", tooltip = "Should WCD fuel be used?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 3 ]			= { key = "fuelMultiplier", name = "Multiplicateur de la consommation mondiale de carburant", tooltip = "1 = par défaut. 0,5 = 50% de carburant en moins consommé. 1,5 = 50 % de plus, etc.", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 4 ]			= { key = "nitro", name = "Activer la nitro", tooltip = "La nitro peut-elle être achetée ou utilisée ?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 5 ]			= { key = "nitroPower", name = "Nitro Modificateur de puissance", tooltip = "1 = normal, 1,5 = 50 % plus élevé, 0,5 = 50 % moins, etc.", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 6 ]			= { key = "nitroCooldown", name = "Nitro Rechargement", tooltip = "Les secondes entre chaque nitro.", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 7 ]			= { key = "fuelCost", name = "Coût du carburant par 1L", tooltip = "Combien coûte 1 litre de carburant", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 8 ] 			= { key = "logData", name = "Log purchases/sells", tooltip = "Should purchases/sells be logged to the data folder?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 9 ]			= { key = "showFuel", name = "Afficher le compteur de carburant", tooltip = "Le compteur de carburant doit-il être indiqué sur le HUD ?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 10 ]			= { key = "showSpeed", name = "Afficher le compteur de vitesse", tooltip = "Le compteur de vitesse doit-il être indiqué sur le HUD ?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 11 ]			= { key = "speedUnits", name = "Compteur de vitesse", tooltip = "Quelles unités de compteur de vitesse devraient être utilisées ?", type = "combobox", values = "Units" };
	WCD.Lang.adminTabs.settings.content[ 12 ]			= { key = "fuelPos", name = "Position du HUD", tooltip = "Le compteur de carburant peut être :\nHaut/Bad = horizontal,\nGauche/Droite = vertical", type = "combobox", values = "Positions" };
	WCD.Lang.adminTabs.settings.content[ 13 ]			= { key = "autoEnter", name = "Entré automatiquement dans le véhicule", tooltip = "Les joueurs devraient-ils être automatiquement placés dans leur véhicule lorsqu'ils spawn ?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 14 ]			= { key = "disallowCustomization", name = "Interdire la personnalisation", tooltip = "Cela signifie que tous les véhicules par défaut ne sont pas autorisés à être personnalisés, mais vous pouvez autoriser manuellement des véhicules spécifiques.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 15 ]			= { key = "autoLock", name = "Véhicule à verrouillage automatique", tooltip = "Should cars apparaitre locked?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 16 ]			= { key = "autoWantSpeed", name = "[Contrôleur de vitesse] Auto-Recherché", tooltip = "Si vous utilisez le Contrôleur de vitesse, à quelle vitesse un conducteur devrait-il se faire recherché?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 17 ]			= { key = "maxCarsSpawned", name = "Nombre maximal d'apparition de voiture", tooltip = "Combien de véhicules un joueur peut-il faire apparaitre en même temps ?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 18 ] 			= { key = "fuelTankAmount", name = "Fuel tank-fuel", tooltip = "How much fuel the fuel-tank entity gives to a vehicle", type = "number", input = "number" };


	WCD.Lang.adminTabs.settings.content[ 19 ]			= { key = "saveFuel", name = "Sauvegarder le carburant", tooltip = "Est-ce que les voitures devraient apparaitre avec la quantité de\ncarburant qu'elles avaient lorsqu'elles ont été enlevées ??", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 20 ]			= { key = "language", name = "Langue", tooltip = "C'est seulement SERVER-langage ! Les joueurs peuvent sélectionner leur propre\nlangue dans le menu concessionaire à la première connection.", type = "combobox", values = "Languages" };
	WCD.Lang.adminTabs.settings.content[ 21 ]			= { key = "returnRange", name = "Distance de retour", tooltip = "De la distance à laquelle un joueur peut rendre un véhicule.", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 22 ]			= { key = "saveVcmodHealth", name = "Sauvegarder/Appliquer VCMod Santé", tooltip = "(ne fonctionne que si vous avez vcmod)\nles voitures sauvegarderont la santé endommagées.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 23 ]			= { key = "saveVcmodFuel", name = "Sauvegarder/Appliquer VCMod Carburant", tooltip = "(ne fonctionne que si vous avez vcmod)\nles voitures sauvegarderont le système de carburant du vcmod.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 24 ] 			= { key = "autoSellCarsWhenRemoved", name = "Refund cars that are removed", tooltip = "Automatically refund cars(as if players Sold the car), when you remove a car.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 25 ]			= { key = "allowEntityCustomization", name = "Allow customization of Entities", tooltip = "(CONSIDER THIS experimental)", type = "bool" };


	WCD.Lang.adminTabs.settings.content[ 26 ]			= { key = "header", text = "Paramètres du concessionnaire" };
	WCD.Lang.adminTabs.settings.content[ 27 ]			= { key = "testDriving", name = "Autoriser l'essai", tooltip = "Les joueurs peuvent-ils faire l'essai de véhicules ?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 28 ]			= { key = "testDrivingTime", name = "Temps d'essai", tooltip = "Pendant combien de temps un véhicule peut-il être testé?", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 29 ]			= { key = "spawnDelay", name = "délai d'apparition", tooltip = "Attente (en secondes) entre les apparitions des véhicules.", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 30 ]			= { key = "spawnCost", name = "Coût de l'apparition", tooltip = "Prix pour l'apparition du véhicule", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 31 ]			= { key = "percentage", name = "Pourcentage de vente", tooltip = "Combien de % un joueur récupère-t-il de la vente d'un véhicule ?", type = "number", input = "numberMinMax", min = 0, max = 100 };

	WCD.Lang.adminTabs.settings.content[ 32 ]			= { key = "header", text = "Défauts du véhicule (lors de l'ajout d'un nouveau véhicule)" };
	WCD.Lang.adminTabs.settings.content[ 33 ]			= { key = "fuelTank", name = "Taille du réservoir de carburant par défaut", tooltip = "Taille du réservoir de carburant par défaut", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 34 ]			= { key = "skinCost", name = "Prix pour personnaliser la peau", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 35 ]			= { key = "bodygroupCost", name = "Prix pour personnaliser les groupes de carrosserie", tooltip = "(Le prix est par groupe de corps)", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 36 ]			= { key = "colorCost", name = "Prix pour personnaliser la couleur", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 37 ]			= { key = "nitroOneCost", name = "Prix pour le Nitro level 1", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 38 ]			= { key = "nitroTwoCost", name = "Prix pour le Nitro level 2", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 39 ]			= { key = "nitroThreeCost", name = "Prix pour le Nitro level 3", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 40 ]			= { key = "underGlowCost", name = "Prix pour le néon", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 41 ]			= { key = "fullResetCost", name = "Full reset cost", tooltip = "", type = "number" };

	WCD.Lang.adminTabs.vehicles							= WCD.Lang.adminTabs.vehicles or {};
	WCD.Lang.adminTabs.vehicles.selectVehicle 			= "Sélectionnez une base de véhicule";
	WCD.Lang.adminTabs.vehicles.editVehicle 			= "Sélectionner un véhicule à éditer";
	WCD.Lang.adminTabs.vehicles[ "or" ] 				= "ou";
	WCD.Lang.adminTabs.vehicles.select 					= "Créer un nouveau véhicule";
	WCD.Lang.adminTabs.vehicles.edit 					= "Modifier";
	WCD.Lang.adminTabs.vehicles.editing 				= "Modifie le véhicule";
	WCD.Lang.adminTabs.vehicles.selecting 				= "Création d'un véhicule (base: [1])";
	WCD.Lang.adminTabs.vehicles.active 					= "Actif: [1]";
	WCD.Lang.adminTabs.vehicles.invalidSelection 		= "Sélection non valable!";
	WCD.Lang.adminTabs.vehicles.invalidValues 			= "Champ '[1]' contient des valeurs invalides!";

	WCD.Lang.adminTabs.vehicles.content 				= WCD.Lang.adminTabs.vehicles.content or {};
	WCD.Lang.adminTabs.vehicles.content[ 1 ]			= { key = "header", text = "[1]" };
	WCD.Lang.adminTabs.vehicles.content[ 2 ]			= { key = "name", name = "Afficher le nom", tooltip = "Sous quel nom le véhicule sera affiché", type = "string" };
	WCD.Lang.adminTabs.vehicles.content[ 3 ]			= { key = "free", name = "Gratuit", tooltip = "Le véhicule doit-il être gratuit ? (bon pour les voitures de police, etc.)", type = "bool", default = false };
	WCD.Lang.adminTabs.vehicles.content[ 4 ]			= { key = "fuel", name = "Taille du réservoir de carburant", tooltip = "Carburant maximal dans le véhicule", type = "number", min = 0, default = 70, notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 5 ]			= { key = "fuelMulti", name = "Multiplicateur de consommation de l'essence", tooltip = "Si vous voulez que le véhicule consomme plus\nou moins de carburant que les autres (1 est par défaut, 0,75 = 25% de moins, etc).", type = "number", input = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 6 ]			= { key = "price", name = "Prix d'achat", tooltip = "Combien un joueur paie pour le véhicule ?", type = "number", min = 0 };
	WCD.Lang.adminTabs.vehicles.content[ 7 ]			= { key = "noFuel", name = "Carburant illimité", tooltip = "Le véhicule doit-il avoir une quantité illimitée de carburant ?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 8 ]			= { key = "nitro", name = "Nitro préinstallé", tooltip = "Nitro niveau qui vient pré-installé", type="combobox", values = { 0, 1, 2, 3 }, notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 9 ]			= { key = "ownedPriority", name = "Owner priority", tooltip = "Checked = people can spawn this vehicle aslong as they own it,\neven if they don't have access anymore.", type="bool" };

	WCD.Lang.adminTabs.vehicles.content[ 10 ]			= { key = "header", text = "Prix de personnalisation" };
	WCD.Lang.adminTabs.vehicles.content[ 11 ]			= { key = "bodygroupCost", name = "Prix par changement de groupe de carrosserie", tooltip = "Combien coûte le changement d'un groupe de carrosserie ?", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 12 ]			= { key = "skinCost", name = "Prix pour personnaliser la peau", tooltip = "Combien ça coûte d'éditer la peau", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 13 ]			= { key = "nitroOneCost", name = "Prix pour le Nitro level 1", tooltip = "Combien coûte la mise en oeuvre du Nitro niveau 1", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 14 ]			= { key = "nitroTwoCost", name = "Prix pour le Nitro level 2", tooltip = "Combien coûte la mise en oeuvre du Nitro niveau 2", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 15 ]			= { key = "nitroThreeCost", name = "Prix pour le Nitro level 3", tooltip = "Combien coûte la mise en oeuvre du Nitro niveau 3 ?", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 16 ]			= { key = "colorCost", name = "Prix pour éditer la couleur", tooltip = "Combien coûte l'édition de la couleur du véhicule ?", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 17 ]			= { key = "underglowCost", name = "Prix pour le Neon", tooltip = "Combien il en coûte pour éditer le Neon du véhicule.", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 18 ]			= { key = "spawnCost", name = "Price to Spawn", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 19 ] 			= { key = "spawnDelay", name = "Spawn Delay", tooltip = "Vehicle-specific delay between spawning", type = "number" };


	WCD.Lang.adminTabs.vehicles.content[ 20 ]			= { key = "header", text = "Divers" };
	WCD.Lang.adminTabs.vehicles.content[ 21 ]			= { key = "color", name = "Couleur par défaut", tooltip = "Si vous voulez que le véhicule apparait avec une certaine couleur.", type = "display_color" };
	WCD.Lang.adminTabs.vehicles.content[ 22 ]			= { key = "bodygroups", name = "Groupes de corps par défaut", tooltip = "Si vous voulez que le véhicule apparait avec certains groupes de carrosserie.", type = "display_bodygroups", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 23 ]			= { key = "skin", name = "Skin par défaut", tooltip = "Si vous voulez que le véhicule apparait avec une certaine peau.", type = "display_skin", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 24 ]			= { key = "access", name = "Accès", tooltip = "Quels grades/métiers peuvent accéder à ce véhicule. LAISSEZ VIDE POUR TOUS !", type = "display_access" };
	WCD.Lang.adminTabs.vehicles.content[ 25 ]			= { key = "dealer", name = "Concessionnaires", tooltip = "quels concessionnaires vendent ce véhicule?", type = "display_dealers" };

	WCD.Lang.adminTabs.vehicles.content[ 26 ]			= { key = "header", text = "Personnalisation autorisée", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 27 ]			= { key = "disallowCustomization", name = "Refuser toute personnalisation", tooltip = "Si cette case est cochée, toutes les autres\nautorisations sont automatiquement fausses.", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 28 ]			= { key = "disallowNitro", name = "Désactivé l'amélioration du Nitro", tooltip = "La mise à niveau nitro peut-elle être achetée ou utilisée ?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 29 ]			= { key = "disallowSkin", name = "Désactivé le changement de peau", tooltip = "La peau peut-elle être personnalisée ??", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 30 ]			= { key = "disallowColor", name = "Désactivé le changement de couleur", tooltip = "La couleur peut-elle être personnalisée ?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 31 ]			= { key = "disallowBodygroup", name = "Désactiver le changement au niveau des groupes de carrosserie", tooltip = "Can bodygroups be changed?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 32 ]			= { key = "disallowUnderglow", name = "Désactiver le changement au niveau du Neon", tooltip = "Le Neon peut être changé?", type = "bool", notForEnt = true };

	WCD.Lang.adminTabs.users							= WCD.Lang.adminTabs.users or {};
	WCD.Lang.adminTabs.users.selectUser 				= "Sélectionne un joueur";
	WCD.Lang.adminTabs.users.inputSteam 				= "Entrée un Steam ID (32 format)";
	WCD.Lang.adminTabs.users[ "or" ] 					= "ou";
	WCD.Lang.adminTabs.users.selectUserButton 			= "Selectionne un joueur";
	WCD.Lang.adminTabs.users.inputSteamButton 			= "Récupérer les infos joueurs";
end