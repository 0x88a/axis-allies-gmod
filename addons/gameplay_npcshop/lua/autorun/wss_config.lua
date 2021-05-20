if( !Shop || !type( Shop ) == "table" ) then
	Shop =  {};
end


Shop.Settings = {};
Shop.Colors = {};
Shop.Messages = {};
Shop.Derma = {};

/*
* Please read this file carefully!
* Any invalid settings will result in the addon not working.
* If you need help, you can add me on Steam:
* www.steamcommunity.com/id/busan1/
*/

/*
* This is general settings and you should read it through
* atleast once and make sure it's as you want it to be.
*/

// Shared settings

// If true, it will print "non necessary" information to console.
// Such as "sending shop data to playername"
// While false, it will only show important things.
Shop.Settings.FullInfo = false;

// Show Shop names above them?
Shop.Settings.ShowNames = true;

// These things are only required to be known by the server.
if( SERVER ) then
	Shop.Settings.Database = {};
	// There's no need to change these two.
	Shop.Settings.Database.ShopTable = "wss_shops";
	// Who are allowed to use admin commands?
	Shop.Settings.Admin = { "superadmin", "owner" };

	// the (admin) command to create a shop
	Shop.Settings.CommandAddShop = "!addshop";
	// the (admin) command to edit a shop
	Shop.Settings.CommandEditShop = "!editshop";
	// the (admin) command to open the shop admin menu
	Shop.Settings.CommandAdmin  = "!adminshop";
	// Command to change a shops entity spawn position
	Shop.Settings.CommandSpawnPos = "!editspawnpos";


	// This is for example shown if player is dead/out of range when clicking Buy
	Shop.Messages.Unable = "You are unable to purchase this item right now.";
	// If player tries to use any of  the three commands without access
	Shop.Messages.CommandNoAccess = "You don't have access to this command!";
	// If an admin uses !addshop or !editshop while not looking at a shop
	Shop.Messages.CommandNoShop = "You need to be looking at a shop!";
	// If user doesn't have access to the shop(wrong job)
	Shop.Messages.Restricted = "You don't have access to purchase from this shop.";
	// When player bought item with name %A for price %B
	Shop.Messages.BoughtItem = "You bought %A for $%B.";
	// Can't afford item
	Shop.Messages.CantAffordItem = "You can't afford %A for $%B!";
	// Player has weapon
	Shop.Messages.PlayerHasWeapon = "You already have this weapon!";
	// Buy delay
	Shop.Delay = 1.5;
	// Message if trying to buy
	Shop.Messages.CantBuyYet = "You can't purchase another item yet!";
	// Max food limit
	Shop.Settings.MaxFoodItems = 10;
	// Message if buying food at limit
	Shop.Messages.TooManyFoods = "You can't buy more food now!";
	
	// Insert more ammo-types if you want
	Shop.Settings.AmmoTypes = { "grenade" };
end

// Client part
if( CLIENT ) then	

	// Draw HALO(outline) around shops?
	Shop.Settings.DrawHalos = false;
	// Color of halo?
	Shop.Colors.HaloColor = Color( 255, 255, 255 );
	// The title of the !adminshop window
	Shop.Settings.AdminWindow = "Shop System Configuration";
	// The title of the !editshop window
	Shop.Settings.AdminWindow = "Shop Configuration";
	// Window of all shop stuff
	Shop.Colors.BG = Color( 50, 50, 50, 255 );
	// Tabs in each window color
	Shop.Colors.Tabs = Color(  62, 72, 75, 255 );
	// Color of general buttons Text
	Shop.Colors.BtnText = Color( 0, 255, 50, 255 );
	// Color of general buttons
	Shop.Colors.Btn = Color( 75, 72, 69, 40 );
	// Color of general buttons background
	Shop.Colors.BtnBg = Color( 255, 255, 255, 20 );
	// Color of general buttons mouse hover
	Shop.Colors.BtnHover = Color( 70, 155, 70, 225 );
	
	// Actual shop(when clicking E on it!)
	Shop.Width = 600;
	Shop.Height = 250;
	// Blur background?
	Shop.Blur = true;
	// Color of the title
	Shop.Colors.Title = Color( 240, 240, 240, 255 );
	// Entire shop panel
	Shop.Colors.Panel = Color( 28, 28, 27, 255 );
	// Menu panel
	Shop.Colors.MenuPanel = Color( 0, 0, 0, 55 );
	// Items panel
	Shop.Colors.ItemsPanel = Color( 240, 240, 240	, 0 );
	// Every even panel color
	Shop.Colors.Even = Color( 31, 31, 32, 120 );
	// Every uneven panel color
	Shop.Colors.Uneven = Color( 35, 35, 36, 80 );
	// Color of Menu buttons Text
	Shop.Colors.BtnTextShop = Color( 255, 255, 255, 255 );
	// Color of Menu buttons
	Shop.Colors.BtnShop = Color( 14, 13, 43, 245 );
	// Color of Menu buttons background
	Shop.Colors.BtnBgShop = Color( 160, 197, 95, 255 );
	// Color of Menu buttons mouse hover
	Shop.Colors.BtnHoverShop = Color( 41, 128, 185, 225 );	
	// Buy button
	Shop.Colors.BuyButton = Color( 35, 35, 36, 255 );
	// Hover buy button
	Shop.Colors.BuyButtonHover = Color( 42, 42, 43, 225 );
	// Font color of button
	Shop.Colors.FontBuyButton = Color( 240, 240, 240, 255 );
	// Color of the item text
	Shop.Colors.ItemColor = Color( 240, 240, 240, 250 );
	// Button sounds
	Shop.ButtonSounds = "buttons/button9.wav";
	// Should sound be played?
	Shop.PlaySounds = true;
	
	/*
	Shop.Colors.Panel = Color( 255, 255, 255, 5 );
	// Menu panel
	Shop.Colors.MenuPanel = Color( 0, 0, 0, 85 );
	// Items panel
	Shop.Colors.ItemsPanel = Color( 62, 65, 71, 0 );
	// Every even panel color
	Shop.Colors.Even = Color(  0, 0, 0, 160 );
	// Every uneven panel color
	Shop.Colors.Uneven = Color( 0, 0, 0, 95 );
	// Color of Menu buttons Text
	Shop.Colors.BtnTextShop = Color( 255, 255, 255, 255 );
	// Color of Menu buttons
	Shop.Colors.BtnShop = Color( 0, 0, 0, 0 );
	// Color of Menu buttons background
	Shop.Colors.BtnBgShop = Color( 160, 197, 95, 0 );
	// Color of Menu buttons mouse hover
	Shop.Colors.BtnHoverShop = Color( 70, 155, 70, 225 );	
	// Buy button
	Shop.Colors.BuyButton = Color( 171, 220, 179, 15 );
	// Hover buy button
	Shop.Colors.BuyButtonHover = Color( 70, 155, 70, 225 );
	// Font color of button
	Shop.Colors.FontBuyButton = Color( 255, 255, 255, 255 );
	// Button sounds
	Shop.ButtonSounds = "buttons/button9.wav";
	*/
	// How much to round corners of button(0 is square)
	Shop.Colors.BtnRound = 0;

	// Draw a halo around the shops?
	Shop.DrawHalo = true;
	// Advanced users can edit the skin in client/skins.lua
	
		surface.CreateFont( "NPC1", {
			font = "Roboto-Regular",
			size = 22,
			weight = 900,
		} );

		surface.CreateFont( "NPC2", {
			font = "Roboto-Regular",
			size = 22,
			weight = 700,
		} );	
end

// Editing done! \\
// Shared functions \\
function Shop:Message( _msg, _type )

	if( !_type ) then
		_type = 3;
	end

	// _type: 0 error 1 success 2 warning 3 default
	local _clr = Color( 255, 255, 255 );

	if( _type == 0 ) then
		_clr = Color( 255, 0, 0 );
	elseif( _type == 1 ) then
		_clr = Color( 0, 255, 0 );
	elseif( _type == 2 ) then
		_clr = Color( 255, 255, 0 );
	else
		_clr = Color( 255, 255, 255 );
	end

	MsgC( _clr, "##Shop System: " .. _msg .. "\n" );

end
