/*
* This file shouldn't be modified unless you know what you're doing!
*/


resource.AddFile( "resource/fonts/OpenSans-Regular.ttf" );
resource.AddFile( "resource/fonts/Roboto-Regular.ttf" );

// This should only be run once, on server start.
// Purpose: Populate the __Shops table.
function Shop:Initialize()
	local _q;
	Shop:Message( "Initializing the shop system...", 1 );

	if( !self.__Shops || type( self.__Shops ) != "table" || #self.__Shops == 0 ) then
			_q = sql.Query( "SELECT * FROM " .. self.Settings.Database.ShopTable );
			if( _q == nil ) then
				self:Message( "No shops found!", 2 );
				self:Update();
			else
				self.__Shops = _q;
				self:Message( "Found " .. #self.__Shops .. " shops!", 1 );
			end
	end

	if( type( self.__Shops ) == "table"
		&& #self.__Shops > 0 ) then

		timer.Simple( 5, function() self:SpawnShops() end );

	end
end

// This function informs either a single player(if provided), or
// broadcasts the two tables. This should only be done on:
// PlayerInitialSpawn
// __Shops
function Shop:Update( _p )

	if( self.__Shops == nil ) then
		self.__Shops = {};
	end

	net.Start( "Shop::Update" );
	net.WriteTable( self.__Shops );
	
	local _funcTable = {};
	
	for i, v in pairs( Shop.Functions ) do
		_funcTable[ i ] = v.name;
	end
	
	net.WriteTable( _funcTable );
	
	if( _p && _p != nil && IsValid( _p ) && _p:IsPlayer() ) then
		net.Send( _p );
		if( self.Settings.FullInfo ) then
			self:Message( "Sent shop data to " .. _p:Nick() .. "." );
		end
	else
		net.Broadcast();
		if( self.Settings.FullInfo ) then
			self:Message( "Shop data has been broadcasted." );
		end
	end

end

// Hooks \\

hook.Add( "PlayerInitialSpawn", "Shop::UpdatePlayer", function( _p ) timer.Simple( 5, function() Shop:Update( _p ) end );  end );
hook.Add( "Shop::Update", "Shop::Update", function() Shop:Update() end );

// End hooks \\

// Database Related Functions \\
function Shop:DeleteAll()

	sql.Query( "DROP TABLE " .. self.Settings.Database.ShopTable );
	self:Message( "Tables has been removed." );

end

function Shop:SetUpDatabase()
	
	self.Active = true;
	self:Message( "Initiating database...", 3 );
	
	//SHOP TABLE
	if( !sql.TableExists( self.Settings.Database.ShopTable ) ) then
		self:Message( self.Settings.Database.ShopTable .. " not found, attempting to create!", 2 );
			sql.Query( [[CREATE TABLE "]] .. self.Settings.Database.ShopTable .. [[" (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			`position` varchar(256) NOT NULL,
			`angle` varchar(256) NOT NULL,
			`map` varchar(64) NOT NULL,
			`npc` INTEGER DEFAULT 0,
			`model` varchar(255) NOT NULL,
			`items` varchar(51200) NOT NULL,
			`restricted` varchar(512) NOT NULL,
			`name` varchar(64) NOT NULL,
			`spawnpos` varchar(64),
			`spawnang` varchar(64))]] );
			// exec time: 76561198063949152
			if( !sql.TableExists( self.Settings.Database.ShopTable ) ) then
				self.Active = false;
				self:Message( "TABLE: " .. self.Settings.Database.ShopTable .. " could not be created!", 0 );
				self:Message( "SQL Error: ", 0 );
				self:Message( sql.LastError(), 0 );
		else
				self:Message( "TABLE: " .. self.Settings.Database.ShopTable .. " was successfully created!", 1 );
		end
	else
		self:Message( "TABLE: " .. self.Settings.Database.ShopTable .. " was found!", 1 );
	end

	if( !self.Active ) then
			self:Message( "SHOP SYSTEM DISABLED - NO DATABASE!", 0 );
		else
			self:Message( "SHOP SYSTEM DATABASE CONNECTED!\n", 1 );
			self:Initialize();
		end

end


hook.Add( "InitPostEntity", "wss::Initialize", timer.Simple( 5, function() Shop:SetUpDatabase() end ) );

local META_ANGLE	= FindMetaTable( "Angle" );
local META_COLOR	= FindMetaTable( "Color" );
local META_VECTOR	= FindMetaTable( "Vector" );

function META_ANGLE:Serialize( _delimiter, _postfix )
	local _delimiter = ( isstring( _delimiter ) ) && _delimiter || " ";
	local _postfix = ( isstring( _postfix ) ) && _postfix || "";
	return string.format( "%d%s%d%s%d%s", self.p, _delimiter, self.y, _delimiter, self.r, _postfix );
end

function META_COLOR:Serialize( _delimiter, _postfix )
	local _delimiter = ( isstring( _delimiter ) ) && _delimiter || " ";
	local _postfix = ( isstring( _postfix ) ) && _postfix || "";
	return string.format( "%d%s%d%s%d%s%d%s", self.r, _delimiter, self.g, _delimiter, self.b, _delimiter, self.a, _postfix );
end

function META_VECTOR:Serialize( _delimiter, _postfix )
	local _delimiter = ( isstring( _delimiter ) ) && _delimiter || " ";
	local _postfix = ( isstring( _postfix ) ) && _postfix || "";
	return string.format( "%d%s%d%s%d%s", self.x, _delimiter, self.y, _delimiter, self.z, _postfix );
end

