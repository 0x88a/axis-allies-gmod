if( SERVER ) then
	-- content
	resource.AddWorkshop( "1409612782" );
end

WCD_CURRENT_VERSION = "8.3.7";

WCD.Settings = {};

/*	Available Wrappers:
	nutscript
	basewars
	underdome
	sandbox
	helix
	
	put = "nutscript" to load the wrapper for nutscript
*/
WCD.Settings.Wrapper 						= nil;

/* These ranks can access !wcd */
WCD.OwnerRanks			 					= {
	[ "superadmin" 	]						= true,
};

// to add own language, copy language/wcd_baselang.lua, name it for example wcd_mylang.lua
// then put [ "mylang" ] = "Display Name"
WCD.Languages = {
	[ "english" ] = "english",
	[ "french" ] = "french",
	[ "spanish" ] = "spanish",
};


/*
	keys =
	nitro,
	skin,
	color,
	bodygroups,
	underglow

	these are Global Settings.
	--if you put
	[ "underglow" ] = { "superadmin", "vip" };
	then Only those 2 ranks can customize underglow!
*/
WCD.RankCustomizationRequirements			= {
	[ "nitro for example" ] = { "vip" },
	[ "example2" ] = { "superadmin", "admin" }
};


/*
	Aslong as this setting is TRUE
	it will give players who join their v7 cars in v8
*/
WCD.loadVersionSevenData					= false;


/*
	--This is a Unique String that clients will use
	--for saving their favorited vehicles.
	--Make sure it's a string containing no weird characters.
	--If you change this, every player's favorited vehicle's for this server will be gone.
*/
WCD.Settings.serverString					= "76561198892240489";

WCD.Settings.nitroKey						= IN_ATTACK; // http://wiki.garrysmod.com/page/Enums/IN


/*
	--PLEASE EDIT SETTINGS IN !wcd, not in this file!
	--Only Settings to edit here are OwnerRanks (above),
	--and MySQL in server/wcd_storage.lua!

--	Editing these won't do anything!
*/

WCD.Settings.language						= "english";
WCD.Settings.defaultVehicleClass			= "vol850rtdm";
WCD.Settings.defaultVehicleName				= "Unknown Name";

WCD.Settings.fuel							= false;
WCD.Settings.nitro							= false;
WCD.Settings.showFuel						= false;
WCD.Settings.showSpeed						= false;
WCD.Settings.testDriving					= false;
WCD.Settings.autoEnter						= false;
WCD.Settings.autoLock						= false;
WCD.Settings.saveFuel						= false;
WCD.Settings.disallowCustomization			= false;
WCD.Settings.saveVcmodHealth				= false;
WCD.Settings.saveVcmodFuel					= false;
WCD.Settings.logData						= false;
WCD.Settings.canOnlyReturnSpawned			= false;
WCD.Settings.maxWCDVehiclesSpawned			= 9999;

WCD.Settings.fuelMultiplier					= 1;
WCD.Settings.fuelCost						= 10;
WCD.Settings.returnRange					= 1000;
WCD.Settings.speedUnits						= 1;
WCD.Settings.nitroCooldown					= 60;
WCD.Settings.nitroPower						= 1;
WCD.Settings.autoWantSpeed					= 60;

WCD.Settings.fuelPos						= 2;
WCD.Settings.spawnDelay						= 0;
WCD.Settings.percentage						= 100;
WCD.Settings.maxCarsSpawned					= 1;
WCD.Settings.testDrivingTime				= 60;
WCD.Settings.spawnCost						= 0;
WCD.Settings.fuelTankAmount					= 20;
WCD.Settings.spawnDelay						= 0;

WCD.Settings.fuelMulti						= 1;
WCD.Settings.fuelTank						= 50;
WCD.Settings.skinCost						= 5000;
WCD.Settings.bodygroupCost					= 750;
WCD.Settings.colorCost						= 2500;
WCD.Settings.nitroOneCost					= 25000;
WCD.Settings.nitroTwoCost					= 50000;
WCD.Settings.nitroThreeCost					= 125000;
WCD.Settings.underGlowCost					= 35000;
WCD.Settings.fullResetCost					= 1000;


WCD.Settings.autoSellCarsWhenRemoved		= true;

WCD.Settings.allowEntityCustomization		= false;

// changed to global variable but leaving these for backwards compatibiltiy
WCD.Settings.currentVersion					= WCD_CURRENT_VERSION;
WCD.Settings.latestVersion					= WCD_LATEST_VERSION or WCD.Settings.latestVersion or WCD_CURRENT_VERSION;

WCD.DefaultSettings 						= table.Copy( WCD.Settings );

function WCD:IsOwner( _p )
	if( _p && type( _p ) == "Player" ) then
		return self.OwnerRanks[ _p:GetUserGroup() ];
	end
end

WCD.Icons									= {};
WCD.Icons.DealerButtons						= {};
WCD.Icons.DealerButtons[ 1 ]				= "wcd_shop.png";
WCD.Icons.DealerButtons[ 2 ]				= "wcd_owned.png";
WCD.Icons.DealerButtons[ 3 ]				= "wcd_unowned.png";
WCD.Icons.DealerButtons[ 4 ]				= "wcd_favorites.png";
WCD.Icons.DealerButtons[ 5 ]				= "wcd_customize.png";

WCD.Icons.Star								= "icon16/star.png";
WCD.Icons.Car								= "icon16/car.png";
WCD.Icons.Information						= "icon16/information.png";
WCD.Icons.Wrench							= "icon16/bullet_wrench.png";
WCD.Icons.Cross								= "icon16/cross.png";
WCD.Icons.Tick								= "icon16/tick.png";

if( CLIENT ) then
	WCD.Settings.ShadowSize 				= 35;
	WCD.Settings.ButtonDepth				= 6;
	WCD.Settings.Lerp						= 0.04;
else
	--resource.AddFile( "sound/wcd/spray.wav" );
	--resource.AddFile( "sound/wcd/drill.wav" );
end

for i, v in pairs( WCD.Icons ) do
	if( type( v ) == "table" ) then
	for i2, v2 in pairs( v ) do
		if( CLIENT ) then
			WCD.Icons[ i ][ i2 ] = Material( "materials/wcd/" .. v2 );
		else
			--resource.AddFile( "materials/wcd/" .. v2 );
		end
	end
	continue; end

	if( CLIENT ) then
		if( !string.find( v, "wcd" ) ) then
			WCD.Icons[ i ] = Material( v );
			continue;
		end

		WCD.Icons[ i ] = Material( "materials/wcd/" .. v );
	else
		--resource.AddFile( "materials/wcd/" .. v );
	end
end

/* CONFIG ENDS */
WCD_OK = 1;
WCD_WARNING = 2;
WCD_DANGER = 3;

WCD_VEHICLE = 1;
WCD_ENTITY = 2;
WCD_SIMFPHYS = 3;

/* LOAD WRAPPER */
if( WCD.Settings.Wrapper ) then
	if( !file.Exists( "wcd/wrapper/wcd_" .. WCD.Settings.Wrapper .. ".lua", "LUA" ) ) then
		WCD:Print( "Wrapper '" .. WCD.Settings.Wrapper .. "' not found!", WCD_WARNING );
	else
		include( "wcd/wrapper/wcd_" .. WCD.Settings.Wrapper .. ".lua" );
		WCD:Print( WCD:Translate( "loadedWrapper", WCD.Settings.Wrapper ) );
	end
end
/* END LOAD WRAPPER */

WCD.s = WCD.Settings;

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.settings or "settings" ) );
