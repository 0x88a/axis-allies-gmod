/* This file contains the english version of the addon.
Any language files loaded on top, can replace part of the language,
while other parts would still use the baselang (english) */

WCD.Lang 												= WCD.Lang or {};

/* SHARED VARIABLES */
WCD.Lang.fileNames										= WCD.Lang.fileNames or {};

WCD.Lang.fileNames.utility 								= "Utility";
WCD.Lang.fileNames.color								= "Couleur";
WCD.Lang.fileNames.settings								= "Settings";
WCD.Lang.fileNames.adminui								= "Admin UI";
WCD.Lang.fileNames.dealerui								= "Dealer UI";
WCD.Lang.fileNames.various								= "Various";
WCD.Lang.fileNames.vgui									= "VGUI";
WCD.Lang.fileNames.net									= "Networking";
WCD.Lang.fileNames.clientsettings						= "Client Settings";
WCD.Lang.fileNames.storage								= "Storage";
WCD.Lang.fileNames.main									= "Main";
WCD.Lang.fileNames.vehicledata							= "Vehicle Data";
WCD.Lang.fileNames.minimal								= "Minimal Helpers";
WCD.Lang.fileNames.dealer								= "Dealer Functionality";
WCD.Lang.fileNames.customization						= "Customization Functionality";
WCD.Lang.fileNames.fuel									= "Fuel Control";
WCD.Lang.fileNames.visual								= "Visual";
WCD.Lang.fileNames.designer								= "Designer View";
WCD.Lang.fileNames.phystool								= "Physics & Toolgun restrictions";

WCD.Lang.loadedLang										= "Language loaded!";
WCD.Lang.loadedWrapper									= "Wrapper: '[1]' has been loaded!";
WCD.Lang.loadedFile										= "File: '[1]' has been loaded!";

WCD.Lang.invalidSetting									= "Setting with key '[1]' doesn't exist!";
WCD.Lang.invalidTypeSetting								= "Setting with key '[1]' sent as type '[2]', expected type '[3]'!";
WCD.Lang.updatedSetting									= "Setting '[1]' changed to '[2]'";

WCD.Lang.files											= WCD.Lang.files or {};
WCD.Lang.files.startCreate								= "Going to create 'wcd' data folder..";
WCD.Lang.files.failCreate								= "COULD NOT CREATE: 'wcd'! No data will be saved!";
WCD.Lang.files.informOne								= "Failed to create data folder 'wcd'! No data will be saved!";
WCD.Lang.files.informTwo								= "Please try to manually create it in your server's garrysmod/data/!";
WCD.Lang.files.successCreate							= "Successfully created the 'wcd' data folder.";
WCD.Lang.files.fileLoaded								= "Loaded data file '[1]', containing [2] values.";
WCD.Lang.files.fileNotFound								= "File '[1]' was not found, it should be created when necessary.";
WCD.Lang.files.beginLoading								= "Going to load all settings...";
WCD.Lang.files.savingTable								= "Saving table: '[1]'";

// this refers to the HUD positioning setting
WCD.Lang.Positions										= WCD.Lang.Positions or {};
WCD.Lang.Positions[ 1 ]									= "Top";
WCD.Lang.Positions[ 2 ]									= "Bottom";
WCD.Lang.Positions[ 3 ]									= "Left";
WCD.Lang.Positions[ 4 ]									= "Right";

// hud speedometer setting
WCD.Lang.Units											= WCD.Lang.Units or {};
WCD.Lang.Units[ 1 ] 									= "km/h";
WCD.Lang.Units[ 2 ] 									= "mp/h";

WCD.Lang.adminGun										= WCD.Lang.adminGun or {};
WCD.Lang.adminGun.instructions 							= "Left Click on Dealer: Edit Dealer\nLeft Click on Ground: Spawn new Dealer\nRight Click On Ground: Spawn new Pump\nLeft Click on Pump: Save\nRight click on Pump: Unsave";
WCD.Lang.adminGun.invalidRank 							= "You're not allowed to use this tool.";
WCD.Lang.adminGun.aimHelp 								= "Aim at empty ground, dealer or pump.";
WCD.Lang.adminGun.saved 								= "New Dealer Data and Platforms has been saved!";
WCD.Lang.adminGun.savedPump								= "Pump has been saved.";
WCD.Lang.adminGun.deletedPump 							= "Pump has been deleted.";
WCD.Lang.adminGun.deleted 								= "Dealer and related data has been deleted.";

WCD.Lang.adminGun.settings 								=	WCD.Lang.adminGun.settings or {};
WCD.Lang.adminGun.settings[ 1 ]							=	{ key = "name", name = "Name", tooltip = "The dealer's name", type = "string" };
WCD.Lang.adminGun.settings[ 2 ] 						=	{ key = "model", name = "Model", tooltip = "The dealer's model", type = "string" };
WCD.Lang.adminGun.settings[ 3 ] 						=	{ key = "group", name = "Group", tooltip = "Which dealer group this dealer is assigned to", type = "combobox", values = "DealerGroups" };
WCD.Lang.adminGun.settings[ 4 ] 						=	{ key = "disableGarage", nwbool = true, name = "Disable Garage", tooltip = "Check this to stop the dealer from Spawning vehicles", type = "checkbox" };
WCD.Lang.adminGun.settings[ 5 ] 						=	{ key = "disableShop", nwbool = true, name = "Disable Shop", tooltip = "Check this to stop the dealer from Selling vehicles", type = "checkbox" };
WCD.Lang.adminGun.settings[ 6 ] 						=	{ key = "globalReturn", nwbool = true, name = "Global Return", tooltip = "Can all cars be returned to this dealer?", type = "checkbox" };
WCD.Lang.adminGun.settings[ 7 ] 						=	{ key = "disableCustomization", nwbool = true, name = "Disallow Customizations", tooltip = "Disallow customizations", type = "checkbox" };

WCD.Lang.adminGun.settings[ 8 ] 						=	{ key = "newPlatform", name = "New Spawn Platform", tooltip = "Create a new spawn platform", type = "button" };
WCD.Lang.adminGun.settings[ 9 ] 						=	{ key = "deleteAllPlatform", name = "Delete All Platforms (count: [1])", tooltip = "Delete all platforms tied to this dealer", type = "button" };


if( SERVER ) then
	WCD.Lang.initPlayer									= WCD.Lang.initPlayer or {};
	WCD.Lang.initPlayer.begin							= "Initiating player [1]";

	WCD.Lang.various									= WCD.Lang.various or {};
	WCD.Lang.various.noGroup 							= "I have not been assigned a group yet!";
	WCD.Lang.various.cantAffordSpawn 					= "You can't afford to spawn a vehicle. ([1])";
	WCD.Lang.various.noFreeSpot 						= "There's no free spot for your vehicle, please wait for the area to clear.";
	WCD.Lang.various.customizationBought 				= "You paid [1] for the customization.";
	WCD.Lang.various.maxCarsSpawned 					= "You need to return a vehicle first.";
	WCD.Lang.various.youReturned 						= "You returned your vehicle.";
	WCD.Lang.various.youPaidToSpawn 					= "You paid [1] to spawn your vehicle.";
	WCD.Lang.various.noneInRange 						= "None of your vehicles are within range.";
	WCD.Lang.various.initializing 						= "Requesting dealer specific vehicles from server.. (one time)";
	WCD.Lang.various.loadingDone 						= "Initialization complete!";
	WCD.Lang.various.youSold 							= "You sold [1] for [2].";
	WCD.Lang.various.youBought 							= "You bought [1] for [2].";
	WCD.Lang.various.inUse 								= "This pump is currently in use, please wait.";
	WCD.Lang.various.cantAffordFuel 					= "You can't afford any fuel!";
	WCD.Lang.various.noPlayerFound 						= "No player or player data found!";
	WCD.Lang.various.vehiclesEdited 					= "Targets' vehicles has been updated.";
	WCD.Lang.various.yourVehiclesUpdated 				= "Your vehicles were updated by [1].";
	WCD.Lang.various.speedingWantedReason 				= "Going over the speed limit";
	WCD.Lang.various.refundedVehicleRemoved 			= "You were refunded [1] due to a vehicle you owned has been removed.";
	WCD.Lang.various.returnOnlyToSameDealerGroup		= "You need to return your [1] to a dealer of the same type that spawned it.";
	WCD.Lang.various.maxWCDVehiclesReached				= "Server-vehicle limit reached, please try again later.";
else

	WCD.Lang.dealerButtonsLeft							= WCD.Lang.dealerButtonsLeft or {};
	WCD.Lang.dealerButtonsLeft							= {
		"Store", "Owned", "No Access", "Favorites"
	};

	WCD.Lang.dealerActionButtons						= WCD.Lang.dealerActionButtons or {};
	WCD.Lang.dealerActionButtons.buy 					= "Purchase";
	WCD.Lang.dealerActionButtons.sell 					= "Sell for [1]";
	WCD.Lang.dealerActionButtons.test 					= "Test-drive";
	WCD.Lang.dealerActionButtons.spawn 					= "Spawn";
	WCD.Lang.dealerActionButtons.spawnCustomize 		= "Spawn & Customize";
	WCD.Lang.dealerActionButtons.sure 					= "Are you sure?";
	WCD.Lang.dealerActionButtons.noAfford 				= "You can't afford this vehicle!";
	WCD.Lang.dealerActionButtons.sold 					= "You sold the vehicle for [1].";

	WCD.Lang.dealerVarious								= WCD.Lang.dealerVarious or {};
	WCD.Lang.dealerVarious.canBeCustomized 				= "This vehicle can be customized!";
	WCD.Lang.dealerVarious.canNotBeCustomized 			= "This vehicle can not be customized.";
	WCD.Lang.dealerVarious.customize 					= "Spawn & customize";
	WCD.Lang.dealerVarious.wallet 						= "Wallet: [1]";

	WCD.Lang.adminMenuButtons							= WCD.Lang.adminMenuButtons or {
		"Settings",
		"Vehicles",
		"Users"
	};

	WCD.Lang.pump										= WCD.Lang.pump or {};
	WCD.Lang.pump.title 								= "FUEL STATION";
	WCD.Lang.pump.info 									= {
		"Accept to unlock the hose,",
		"place the hose on your vehicle",
		"to begin filling it with fuel.",
	};

	WCD.Lang.pump.price 								= "Each litre will cost [1].";
	WCD.Lang.pump.start 								= "I accept";
	WCD.Lang.pump.cancel 								= "Cancel";

	WCD.Lang.clientSettingsPanel						= WCD.Lang.clientSettingsPanel or {};
	WCD.Lang.clientSettingsPanel.desc 					= 
[[These are the clientside settings for WCD!
Please hover your cursor over a label to read the tooltip.
You can change these settings later from the dealer menu.]];

	WCD.Lang.clientSettingsPanel.save 					= "Settings has been updated!";
	WCD.Lang.clientSettingsPanel.data 					= WCD.Lang.clientSettingsPanel.data or {};
	WCD.Lang.clientSettingsPanel.data[ 1 ] 				= { key = "CacheOnReceive", name = "Cache all models when received", tooltip = "Should all cars be cached when received from the server?\nIf checked, opening a dealer\ncould freeze your game for a few moments.\nLeave this unchecked if you have a weak computer.", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 2 ] 				= { key = "MoveableModel", name = "Adjustable preview model", tooltip = "Do you want to be able to move the car model around\nwith your mouse, in the dealer menu? (no performance impact)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 3 ] 				= { key = "SpinModel", name = "Spin preview model", tooltip = "Do you want the car to spin?\n(no effect if using Adjustable model)", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 4 ] 				= { key = "SortAsc", name = "Sort cars ascending (cheapest first)", tooltip = "Do you want to see the\ncheapest cars at the top?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 5 ] 				= { key = "Language", name = "Language", tooltip = "Your preferred language.", type = "combobox", values ="Languages" };
	WCD.Lang.clientSettingsPanel.data[ 6 ]				= { key = "Fullscreen", name = "Fullscreen Dealer UI", tooltip = "Do you want the dealer UI to be in fullscreen?", type = "bool" };
	WCD.Lang.clientSettingsPanel.data[ 7 ] 				= { key = "DefaultDealerTab", name = "Default DealerTab", tooltip = "Which tab would you like to be shown by default?", type = "combobox", values = "dealerButtonsLeft", global = true };

	WCD.Lang.invalidSettingValue						= "Field '[1]' has an invalid value! Please edit this before proceeding.";
	WCD.Lang.clientSettings								= "Settings";
	WCD.Lang.dealerTop									= "Vehicle Dealership";
	WCD.Lang.addFavorite								= "Add to Favorites";
	WCD.Lang.removeFavorite								= "Remove from Favorites";
	WCD.Lang.save										= "Save";
	WCD.Lang.select 									= "Select";
	WCD.Lang.delete										= "Delete";
	WCD.Lang.sureShort									= "Sure?";
	WCD.Lang.edit										= "Edit";
	WCD.Lang.choiceSaved								= "Your choice has been saved.";
	WCD.Lang.active										= "Active value: [1]";
	WCD.Lang.unselect									= "Unselect";
	WCD.Lang.none										= "None";
	WCD.Lang.free										= "Free";
	WCD.Lang.sure										= "Are you sure?";
	WCD.Lang.returnVehicles								= "Return vehicles";
	WCD.Lang.fuel										= " litres";
	WCD.Lang.nitroActivated 							= "Nitro Activated";
	WCD.Lang.nitroReady									= "Nitro Ready";

	WCD.Lang.requestingAllVehicles						= "Requesting vehicles from server..";
	WCD.Lang.visibleFor									= "Visible for: ";

	WCD.Lang.settingsSent								= "Settings sent to server.";
	WCD.Lang.settingsReceived							= "New settings received.";

	WCD.Lang.noSettingsChanged							= "No settings were changed!";

	WCD.Lang.designer									= WCD.Lang.designer or {};
	WCD.Lang.designer.cantBeCustomized 					= "This vehicle can't be customized.";
	WCD.Lang.designer.purchase 							= "Purchase";
	WCD.Lang.designer.reset 							= "Full Reset";
	WCD.Lang.designer.confirmReset 						= "Pay: [x]?";
	WCD.Lang.designer.spaceToToggleMouse 				= "Press Space to toggle cursor";
	WCD.Lang.designer.price 							= "[1]";
	WCD.Lang.designer.pricePerChange 					= "[1] per change";
	WCD.Lang.designer.skinCounter 						= "[1] of [2]";
	WCD.Lang.designer.underglow 						= "Underglow is toggled with 'G'";
	WCD.Lang.designer.nitroLevel 						= "Nitro level [1]";
	WCD.Lang.designer.uninstall 						= "Uninstall";
	WCD.Lang.designer.totalPrice 						= "Total price: [1]";
	WCD.Lang.designer.cantAfford 						= "You can't afford [1] to pay for the modifications.";

	WCD.Lang.designer.buttons 							= WCD.Lang.designer.buttons or {};
	WCD.Lang.designer.buttons[ 1 ] 						= { key = "skin", name = "Skin" };
	WCD.Lang.designer.buttons[ 2 ] 						= { key = "color", name = "Color" };
	WCD.Lang.designer.buttons[ 3 ] 						= { key = "bodygroups", name = "Bodygroups" };
	WCD.Lang.designer.buttons[ 4 ] 						= { key = "underglow", name = "Underglow" };
	WCD.Lang.designer.buttons[ 5 ] 						= { key = "nitro", name = "Nitro" };

	WCD.Lang.allowedInputs								= WCD.Lang.allowedInputs or {};
	WCD.Lang.allowedInputs.string						= "text only";
	WCD.Lang.allowedInputs.numberMinMax		 			= "number between [1] - [2]";
	WCD.Lang.allowedInputs.seconds		 				= "number, seconds";
	WCD.Lang.allowedInputs.number						= "0 or higher";

	WCD.Lang.AccessHelper								= WCD.Lang.AccessHelper or {};
	WCD.Lang.AccessHelper.create 						= "New access group";
	WCD.Lang.AccessHelper.editing 						= "Editing [1]";
	WCD.Lang.AccessHelper.jobs 							= "Select jobs";
	WCD.Lang.AccessHelper.ranks 						= "Select ranks";
	WCD.Lang.AccessHelper.needBoth 						= "Require both rank + job";
	WCD.Lang.AccessHelper.newGroupName 					= "New Group Name";
	WCD.Lang.AccessHelper.needName 						= "You need to insert a name for the group!";
	WCD.Lang.AccessHelper.existingGroups 				= "Existing access groups";

	WCD.Lang.DealerHelper								= WCD.Lang.DealerHelper or {};
	WCD.Lang.DealerHelper.create 						= "New dealer group";
	WCD.Lang.DealerHelper.editing 						= "Editing [1]";
	WCD.Lang.DealerHelper.needName 						= "You need to insert a name for the group!";
	WCD.Lang.DealerHelper.newGroupName 					= "New Group Name";
	WCD.Lang.DealerHelper.existingGroups 				= "Existing dealer groups";

	WCD.Lang.adminTabs									= WCD.Lang.adminTabs or {};
	WCD.Lang.adminTabs.settings							= WCD.Lang.adminTabs.settings or {};
	WCD.Lang.adminTabs.settings.title 					= "Settings";
	WCD.Lang.adminTabs.settings.desc 					=
[[These are all the settings that can be edited! Edit them here, not via the wcd_settings.lua file (they might be overridden).
Only MySQL settings and ranks that has access to !wcd has to be edited via files: wcd_settings.lua(ranks) and server/wcd_storage.lua(MySQL).
Hover your mouse over a label to get more information about the setting!
OBS: You can scroll up/down!]];

	WCD.Lang.adminTabs.settings.content 				= WCD.Lang.adminTabs.settings.content or {};
	WCD.Lang.adminTabs.settings.content[ 1 ] 			= { key = "header", text = "General Settings" };
	WCD.Lang.adminTabs.settings.content[ 2 ] 			= { key = "fuel", name = "Enable fuel", tooltip = "Should WCD fuel be used?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 3 ] 			= { key = "fuelMultiplier", name = "Global Fuel consumption multiplier", tooltip = "1 = default. 0.5 = 50% less fuel consumed. 1.5 = 50% more, etc", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 4 ] 			= { key = "nitro", name = "Enable nitro", tooltip = "Can nitro be bought/used?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 5 ] 			= { key = "nitroPower", name = "Nitro Power modifier", tooltip = "1 = normal, 1.5 = 50% higher more, 0.5 = 50% less etc", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 6 ] 			= { key = "nitroCooldown", name = "Nitro Cooldown", tooltip = "Seconds between nitro can be used", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 7 ] 			= { key = "fuelCost", name = "Fuel Cost per 1L", tooltip = "How much 1L of fuel costs", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 8 ] 			= { key = "logData", name = "Log purchases/sells", tooltip = "Should purchases/sells be logged to the data folder?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 9 ] 			= { key = "showFuel", name = "Show fuel-meter", tooltip = "Should fuel meter be shown on the HUD?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 10 ] 			= { key = "showSpeed", name = "Show speed-meter", tooltip = "Should speed meter be shown on the HUD?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 11 ] 			= { key = "speedUnits", name = "Speed meter units", tooltip = "What speed meter units should be used?", type = "combobox", values = "Units" };
	WCD.Lang.adminTabs.settings.content[ 12 ] 			= { key = "fuelPos", name = "HUD position", tooltip = "The fuel meter can be:\ntop/bottom = horizontal,\nleft/right = vertical", type = "combobox", values = "Positions" };
	WCD.Lang.adminTabs.settings.content[ 13 ] 			= { key = "autoEnter", name = "Auto-Enter vehicle", tooltip = "Should players automatically be placed in their vehicle when spawned?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 14 ] 			= { key = "disallowCustomization", name = "Disallow customization", tooltip = "This means all vehicles by default are disallowed to be customized,\nbut you can manually allow specific vehicles", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 15 ] 			= { key = "autoLock", name = "Auto-Lock vehicle", tooltip = "Should cars spawn locked?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 16 ] 			= { key = "autoWantSpeed", name = "[SpeedChecker SWEP] Auto-want at speed", tooltip = "at what speed should a driver get wanted?", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 17 ]			= { key = "maxCarsSpawned", name = "Max spawned vehicles Per Player", tooltip = "How many vehicles a player can have out.", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 18 ] 			= { key = "fuelTankAmount", name = "Fuel tank-fuel", tooltip = "How much fuel the fuel-tank entity gives to a vehicle", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 19 ] 			= { key = "canOnlyReturnSpawned", name = "Returns only to same Dealer Group", tooltip = "Should cars only be returnable to a dealer that is of the same dealer group which the vehicle belongs to?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 20 ] 			= { key = "maxWCDVehiclesSpawned", name = "Map-Total WCD vehicles spawned", tooltip = "If you want a limit of vehicles(only from WCD dealers)", type = "number", input = "number" };

	WCD.Lang.adminTabs.settings.content[ 21 ] 			= { key = "saveFuel", name = "Save fuel", tooltip = "Should cars spawn with the amount of fuel they had when removed?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 22 ] 			= { key = "language", name = "Language", tooltip = "This is only SERVER-language!\nPlayers can select their own language in the Dealer menu/first time join", type = "combobox", values = "Languages" };
	WCD.Lang.adminTabs.settings.content[ 23 ] 			= { key = "returnRange", name = "Return Distance", tooltip = "From how far a player can return a vehicle", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 24 ] 			= { key = "saveVcmodHealth", name = "Save/Apply VCMod Health", tooltip = "(only works if you have vcmod), cars will save health/damaged parts", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 25 ] 			= { key = "saveVcmodFuel", name = "Save/Apply VCMod Fuel", tooltip = "(only works if you have vcmod), cars will save vcmod fuel", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 26 ] 			= { key = "autoSellCarsWhenRemoved", name = "Refund cars that are removed", tooltip = "Automatically refund cars(as if players Sold the car), when you remove a car.", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 27 ]			= { key = "allowEntityCustomization", name = "Allow customization of Entities", tooltip = "(CONSIDER THIS experimental)", type = "bool" };

	WCD.Lang.adminTabs.settings.content[ 28 ] 			= { key = "header", text = "Dealer Settings" };
	WCD.Lang.adminTabs.settings.content[ 29 ] 			= { key = "testDriving", name = "Allow test drive", tooltip = "Can players test-drive vehicles?", type = "bool" };
	WCD.Lang.adminTabs.settings.content[ 30 ] 			= { key = "testDrivingTime", name = "Test drive time", tooltip = "How long can a vehicle be test-driven for?", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 31 ] 			= { key = "spawnDelay", name = "Spawn delay", tooltip = "Cooldown (in seconds) between spawning vehicles", type = "number", input = "seconds" };
	WCD.Lang.adminTabs.settings.content[ 32 ] 			= { key = "spawnCost", name = "Spawn cost", tooltip = "Price to spawn a vehicle", type = "number", input = "number" };
	WCD.Lang.adminTabs.settings.content[ 33 ] 			= { key = "percentage", name = "Sell percentage", tooltip = "How many % does a player get back from selling a vehicle?", type = "number", input = "numberMinMax", min = 0, max = 100 };

	WCD.Lang.adminTabs.settings.content[ 34 ] 			= { key = "header", text = "Vehicle Defaults (when adding a new vehicle)" };
	WCD.Lang.adminTabs.settings.content[ 35 ] 			= { key = "fuelTank", name = "Default fuel tank size", tooltip = "Default fuel tank size", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 36 ] 			= { key = "skinCost", name = "Price to customize skin", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 37 ] 			= { key = "bodygroupCost", name = "Price to customize bodygroups", tooltip = "(Price is per bodygroup)", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 38 ] 			= { key = "colorCost", name = "Price to customize color", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 39 ] 			= { key = "nitroOneCost", name = "Price for Nitro level one", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 40 ] 			= { key = "nitroTwoCost", name = "Price for Nitro level two", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 41 ]			= { key = "nitroThreeCost", name = "Price for Nitro level three", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 42 ] 			= { key = "underGlowCost", name = "Price for Underglow", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.settings.content[ 43 ] 			= { key = "fullResetCost", name = "Full reset cost", tooltip = "", type = "number" };

	WCD.Lang.adminTabs.vehicles							= WCD.Lang.adminTabs.vehicles or {};
	WCD.Lang.adminTabs.vehicles.selectVehicle 			= "Select a vehicle base";
	WCD.Lang.adminTabs.vehicles.editVehicle 			= "Select a vehicle to edit";
	WCD.Lang.adminTabs.vehicles[ "or" ] 				= "or";
	WCD.Lang.adminTabs.vehicles.select 					= "Create new vehicle";
	WCD.Lang.adminTabs.vehicles.edit 					= "Edit";
	WCD.Lang.adminTabs.vehicles.editing 				= "Editing vehicle";
	WCD.Lang.adminTabs.vehicles.selecting 				= "Creating vehicle (base: [1])";
	WCD.Lang.adminTabs.vehicles.active					= "Active: [1]";
	WCD.Lang.adminTabs.vehicles.invalidSelection 		= "Invalid selection!";
	WCD.Lang.adminTabs.vehicles.invalidValues 			= "Field '[1]' contains invalid values!";

	WCD.Lang.adminTabs.vehicles.content 				= WCD.Lang.adminTabs.vehicles.content or {};
	WCD.Lang.adminTabs.vehicles.content[ 1 ] 			= { key = "header", text = "[1]" };
	WCD.Lang.adminTabs.vehicles.content[ 2 ] 			= { key = "name", name = "Display name", tooltip = "Under which name the vehicle will be displayed", type = "string" };
	WCD.Lang.adminTabs.vehicles.content[ 3 ] 			= { key = "free", name = "Free", tooltip = "Should the vehicle be free? (good for police cars etc)", type = "bool", default = false };
	WCD.Lang.adminTabs.vehicles.content[ 4 ] 			= { key = "fuel", name = "Fuel tank size", tooltip = "Maximum fuel in the vehicle", type = "number", min = 0, default = 70, notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 5 ] 			= { key = "fuelMulti", name = "Fuel consumption multiplier", tooltip = "If you want the vehicle to consume more/less fuel than others(1 is default, 0.75 = 25% less etc)", type = "number", input = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 6 ] 			= { key = "price", name = "Purchase price", tooltip = "How much a player pays for the vehicle", type = "number", min = 0 };
	WCD.Lang.adminTabs.vehicles.content[ 7 ] 			= { key = "noFuel", name = "Unlimited fuel", tooltip = "Should the vehicle have unlimited fuel?", type = "bool", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 8 ] 			= { key = "nitro", name = "Pre-installed nitro", tooltip = "Nitro level that comes pre-installed", type="combobox", values = { 0, 1, 2, 3 }, notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 9 ] 			= { key = "ownedPriority", name = "Owner priority", tooltip = "Checked = people can spawn this vehicle aslong as they own it,\neven if they don't have access anymore.", type="bool" };

	WCD.Lang.adminTabs.vehicles.content[ 10 ] 			= { key = "header", text = "Customization Pricing" };
	WCD.Lang.adminTabs.vehicles.content[ 11 ] 			= { key = "bodygroupCost", name = "Price per bodygroup change", tooltip = "How much it costs to change a bodygroup", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 12 ] 			= { key = "skinCost", name = "Price to customize skin", tooltip = "How much it costs to edit the skin", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 13 ] 			= { key = "nitroOneCost", name = "Price for Nitro level one", tooltip = "How much it costs to upgrade to Nitro level one", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 14 ] 			= { key = "nitroTwoCost", name = "Price for Nitro level two", tooltip = "How much it costs to upgrade to Nitro level two", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 15 ] 			= { key = "nitroThreeCost", name = "Price for Nitro level three", tooltip = "How much it costs to upgrade to Nitro level three", type = "number", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 16 ] 			= { key = "colorCost", name = "Price to edit the color", tooltip = "How much it costs to edit the color of the vehicle", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 17 ] 			= { key = "underglowCost", name = "Price to edit underglow", tooltip = "How much it costs to edit underglow of the vehicle", type = "number", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 18 ] 			= { key = "spawnCost", name = "Price to Spawn", tooltip = "", type = "number" };
	WCD.Lang.adminTabs.vehicles.content[ 19 ] 			= { key = "spawnDelay", name = "Spawn Delay", tooltip = "Vehicle-specific delay between spawning", type = "number" };

	WCD.Lang.adminTabs.vehicles.content[ 20 ] 			= { key = "header", text = "Various" };
	WCD.Lang.adminTabs.vehicles.content[ 21 ] 			= { key = "color", name = "Default color", tooltip = "If you want the vehicle to spawn with a certain color", type = "display_color" };
	WCD.Lang.adminTabs.vehicles.content[ 22 ] 			= { key = "bodygroups", name = "Default bodygroups", tooltip = "If you want the vehicle to spawn with certain bodygroups", type = "display_bodygroups", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 23 ] 			= { key = "skin", name = "Default skin", tooltip = "If you want the vehicle to spawn with a certain skin", type = "display_skin", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 24 ] 			= { key = "access", name = "Access", tooltip = "What ranks/jobs can access this vehicle. LEAVE EMPTY FOR ALL!", type = "display_access" };
	WCD.Lang.adminTabs.vehicles.content[ 25 ] 			= { key = "dealer", name = "Dealers", tooltip = "Which dealers sells this vehicle?", type = "display_dealers" };

	WCD.Lang.adminTabs.vehicles.content[ 26 ] 			= { key = "header", text = "Allowed customizations", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 27 ] 			= { key = "disallowCustomization", name = "Disallow all customization", tooltip = "With this checked, all the other allow are automatically false.", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 28 ] 			= { key = "disallowNitro", name = "Disallow nitro upgrade", tooltip = "Can the nitro upgrade be bought/used?", type = "bool", notForEnt = true, neverForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 29 ] 			= { key = "disallowSkin", name = "Disallow skin-change", tooltip = "Can the skin be customized?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 30 ] 			= { key = "disallowColor", name = "Disallow color-change", tooltip = "Can the color be customized?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 31 ] 			= { key = "disallowBodygroup", name = "Disallow bodygroup-change", tooltip = "Can bodygroups be changed?", type = "bool", notForEnt = true };
	WCD.Lang.adminTabs.vehicles.content[ 32 ] 			= { key = "disallowUnderglow", name = "Disallow underglow-change", tooltip = "Can underglow be changed?", type = "bool", notForEnt = true };

	WCD.Lang.adminTabs.users							= WCD.Lang.adminTabs.users or {};
	WCD.Lang.adminTabs.users.selectUser 				= "Select an online player";
	WCD.Lang.adminTabs.users.inputSteam 				= "Input Steam ID (32 format)";
	WCD.Lang.adminTabs.users[ "or" ] 					= "or";
	WCD.Lang.adminTabs.users.selectUserButton 			= "Select player";
	WCD.Lang.adminTabs.users.inputSteamButton 			= "Retrieve player data";
end
