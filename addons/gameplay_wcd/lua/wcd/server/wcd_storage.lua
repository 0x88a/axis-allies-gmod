/*
	Available Types:
	sqllite = saves in server garrysmod/sv.db
	mysqloo9 = https://gmod.facepunch.com/f/gmodaddon/jjdq/gmsv-mysqloo-v9-Rewritten-MySQL-Module-prepared-statements-transactions/1/

	incorrect value will default to sqllite
*/

WCD.Storage = {
	type = "sqllite",
	table = "wcd",

	/*
		you have to create a database yourself, or use an existing one.
		the script will create the table.
	*/
	host = "127.0.0.1",
	user = "root",
	password = "",
	database = "gmod",
	port = "3306"
};

local fileReference = {
	{ file = "dealers", mapSpecific = true },
	{ file = "pumps", mapSpecific = true },
	{ file = "settings" },
	{ file = "accessGroups" },
	{ file = "dealerGroups" },
	{ file = "vehicleRefunds" }
};

function WCD:LoadVehicles()
	self:Print( "Beginning to load all vehicles.." );
	local files, _ = file.Find( "wcd/cars/*.txt", "DATA" );

	local count = 0;
	local fail = 0;
	for i, v in pairs( files ) do
		local data = util.JSONToTable( file.Read( "wcd/cars/" .. v, "data" ) );
		local vehicle = Vehicle( data );

		if( !WCD.VehicleData[ vehicle:GetClass() ] ) then
			self:Print( "Vehicle with class: " .. vehicle:GetClass() .. " not installed!", 3, true );
			fail = fail + 1;
			continue;
		end

		count = count + 1;
		self.List[ vehicle.id ] = vehicle;
	end

	self:Print( "Loaded " .. count .. " vehicles." );
	self:Print( "Invalid vehicles found: " .. fail );
end

function WCD:Save( name )
	self.FilePath = "wcd/";
	self.MapPath = "wcd/" .. string.lower( game.GetMap() ) .. "/";

	for i, v in pairs( fileReference ) do
		if( name && string.lower( v.file ) != string.lower( name ) ) then continue; end

		local path = self.FilePath;
		if( v.mapSpecific ) then
			path = self.MapPath;
		end

		path = path .. v.file .. ".txt";
		local q = v.file:sub( 1, 1 ):upper() .. v.file:sub( 2 );

		if( name == "dealers" ) then
			self[ q ] = {};
			for i, _e in pairs( ents.FindByClass( "wcd_dealer" ) ) do
				table.insert( self[ q ], _e:GetSaveData() );
			end
		elseif( name == "pumps" ) then
			self[ q ] = {};
			for i, _e in pairs( ents.FindByClass( "wcd_pump" ) ) do
				table.insert( self[ q ], { pos = _e:GetPos(), ang = _e:GetAngles() } );
			end
		end

		if( self[ q ] ) then
			self:Print( WCD:Translate( self.Lang.files.savingTable, q ) );
			file.Write( path, util.TableToJSON( self[ q ] ) );
		end
	end
end

function WCD:Load( name )
	self.FilePath = "wcd/";
	self.MapPath = "wcd/" .. string.lower( game.GetMap() ) .. "/";

	if( !file.Exists( self.MapPath, "DATA" ) ) then
		file.CreateDir( self.MapPath );
	end

	for i, v in pairs( fileReference ) do
		if( name && v.file != name ) then continue; end

		local path = self.FilePath;
		if( v.mapSpecific ) then
			path = self.MapPath;
		end

		path = path .. v.file .. ".txt";

		if( !file.Exists( path, "DATA" ) ) then
			self:Print( WCD:Translate( self.Lang.files.fileNotFound, path ), 2 );
		else
			local q = v.file:sub( 1, 1 ):upper() .. v.file:sub( 2 );

			self[ q ] = util.JSONToTable( file.Read( path, "DATA" ) );
			self:Print( WCD:Translate( self.Lang.files.fileLoaded, q, table.Count( self[ q ] ) ) );
		end
	end

	if( name == "accessGroups" || table.Count( WCD.AccessGroups ) > 0 ) then
		local changed = false;

		for i, v in pairs( WCD.AccessGroups ) do
			for i2, v2 in pairs( v.jobs or {} ) do
				if( isnumber( i2 ) && WCD:GetAllJobs()[ i2 ] ) then
					WCD.AccessGroups[ i ].jobs[ WCD:GetAllJobs()[ i2 ] ] = true;
					WCD.AccessGroups[ i ].jobs[ i2 ] = nil;
					WCD:Print( "Transferred Access Group Job: " .. i2, 1 );

					changed = true;
				end
			end
		end

		if( changed ) then
			WCD:Save( "accessGroups" );
		end
	end

	if( !name || name == "settings" ) then
		WCD:HandleSettings( WCD.Settings );
	end
end

function WCD:Log( id, msg )
	if( !id ) then return; end
	if( type( id ) == "Player" ) then id = id:SteamID64(); end
	msg = msg or "NO MSG?";

	self:Print( id .. ": " .. msg );
	if( !self.Settings.logData ) then return; end
	msg = os.date( "%X - %d/%m/%Y", os.time() ) .. ":\n" .. msg .. "\n\n";

	if( !file.Exists( "wcd/logs/" .. id .. ".txt", "DATA" ) ) then
		file.Write( "wcd/logs/" .. id .. ".txt", msg );
	else
		local q = file.Read( "wcd/logs/" .. id .. ".txt", "DATA" );
		msg = msg .. q;

		file.Write( "wcd/logs/" .. id .. ".txt", msg );
	end
end

function WCD:SetupFiles( attempted )
	self.FilePath = "wcd/";
	self.MapPath = "wcd/" .. string.lower( game.GetMap() ) .. "/";

	if( !file.Exists( "wcd", "data" ) || !file.Exists( "wcd/cars", "data" ) ) then
		if( attempted ) then
			self:Print( self.Lang.files.failCreate );

			timer.Create( "WCD::SetupFilesFailed", 30, 0, function()
				self:Print( self.Lang.files.informOne, 3, true );
				self:Print( self.Lang.files.informTwo, 3, true );
			end );

			return;
		end

		self:Print( self.Lang.files.startCreate );

		file.CreateDir( "wcd" );
		file.CreateDir( "wcd/cars/" );

		self:SetupFiles( true );
	else
		if( attempted ) then
			self:Print( self.Lang.files.successCreate );
		else
			self:Print( self.Lang.files.beginLoading );
			self:Load();
		end
	end

	if( !file.Exists( "wcd/logs", "data" ) ) then
		file.CreateDir( "wcd/logs" );
	end
end

WCD.__MySQLRowTracker = WCD.__MySQLRowTracker or {};
function WCD:SavePlayerData( field, id, save, hasRun )
	if( !id ) then return; end
	if( type( id ) == "Player" ) then id = id:SteamID(); end
	if( type( tostring( id ) ) != "string" ) then return; end

	local storage = self.Storage.table .. "::" .. field;

	if( self.Storage.type == "mysqloo9" ) then
		if( !self.__MySQLRowTracker[ id ] ) then
			if( hasRun ) then
				self:Print( "MySQL: Fatal error saving player's " .. field .. ", table could not be created! Not saved for id: '" .. id .."'." );
				return;
			end

			local query;
			if( field == "owned" ) then
				self.PreparedInsertOwnedQuery = self.PreparedInsertOwnedQuery or self.__Database:prepare( "INSERT INTO " .. self.Storage.table .. " (steamid, owned) VALUES( ?, ? )" );
				query = self.PreparedInsertOwnedQuery;
			else
				self.PreparedInsertSpecificsQuery = self.PreparedInsertSpecificsQuery or self.__Database:prepare( "INSERT INTO " .. self.Storage.table .. " (steamid,specifics) VALUES( ?, ? )" );
				query = self.PreparedInsertSpecificsQuery;
			end

			query:setString( 1, id );
			query:setString( 2, util.TableToJSON( save ) );

			query.onSuccess = function( q, data )
				self.__MySQLRowTracker[ id ] = true;
			end

			query:start();
			return;
		end

		local query;
		if( field == "owned" ) then
			self.PreparedUpdateOwnedQuery = self.PreparedUpdateOwnedQuery or self.__Database:prepare( "UPDATE " .. self.Storage.table .. " SET owned = ?, last_edited = ? WHERE steamid = ?" );
			query = self.PreparedUpdateOwnedQuery;
		else
			self.PreparedUpdateSpecificsQuery = self.PreparedUpdateSpecificsQuery or self.__Database:prepare( "UPDATE " .. self.Storage.table .. " SET specifics = ?, last_edited = ? WHERE steamid = ?" );
			query = self.PreparedUpdateSpecificsQuery;
		end

		query:setString( 1, util.TableToJSON( save ) );
		query:setNumber( 2, os.time() );
		query:setString( 3, id );

		query.onSuccess = function( q, data )
			self:Print( "MySQL: Saved " .. field .." for id '" .. id .. "'" );
		end

		query.onError = function( q, err, data )
			self:Print( "MySQL: Couldn't save " .. field .." for id: '" .. id .. "'" );
			self:Print( "MySQL error:" .. err );
		end

		query:start();
	else
		util.SetPData( id, storage, util.TableToJSON( save ) );

		if( callback ) then
			callback( tbl );
		end
	end
end

function WCD:LoadPlayerData( field, id, callback )
	if( !id ) then return {}; end
	if( type( id ) == "Player" ) then id = id:SteamID(); end
	if( type( tostring( id ) ) != "string" ) then return {}; end

	local storage = self.Storage.table .. "::" .. field;

	local tbl = {};

	if( self.Storage.type == "mysqloo9" ) then
		local query;
		if( field == "owned" ) then
			self.__PreparedSelectOwnedQuery = self.__PreparedSelectOwnedQuery or self.__Database:prepare( "SELECT owned FROM " .. self.Storage.table .. " WHERE steamid = ?" );
			query = self.__PreparedSelectOwnedQuery;
		else
			self.__PreparedSelectSpecificsQuery = self.__PreparedSelectSpecificsQuery or self.__Database:prepare( "SELECT specifics FROM " .. self.Storage.table .. " WHERE steamid = ?" );
			query = self.__PreparedSelectSpecificsQuery;
		end
		query:setString( 1, id );

		query.onSuccess = function( q, data )
			self:Print( "Retrieved " .. id .. "'s " .. field .. "." );

			if( data && type( data ) == "table" && table.Count( data ) >= 1 && data[ 1 ] && data[ 1 ][ field ] ) then
				tbl = util.JSONToTable( data[ 1 ][ field ] );

				if( type( tbl ) != "table" ) then
					tbl = {};
				end

				self.__MySQLRowTracker[ id ] = true;

				if( IsValid( player.GetBySteamID( id ) ) ) then
					if( field == "owned" ) then
						player.GetBySteamID( id ).__WCDCoreOwned = tbl;
					else
						player.GetBySteamID( id ).__WCDSpecifics = tbl;
					end
				end
			else
				tbl = {};
			end

			if( callback ) then
				callback( tbl );
			end
		end

		query.onError = function( q, err, data )
			self:Print( "MySQL: Couldn't load " .. field .. " for id: '" .. id .. "'" );
			self:Print( "MySQL error:" .. err );

			if( callback ) then
				callback( nil );
			end
		end

		query:start();
	else
		tbl = util.JSONToTable( util.GetPData( id, storage, "[]" ) );

		if( IsValid( player.GetBySteamID( id ) ) ) then
			if( field == "owned" ) then
				player.GetBySteamID( id ).__WCDCoreOwned = tbl;
			else
				player.GetBySteamID( id ).__WCDSpecifics = tbl;
			end
		end

		if( callback ) then
			callback( tbl );
		end
	end

	return tbl;
end

/* MySQL */
function WCD:MySQL_CreateTable()
	local query = self.__Database:query( "CREATE TABLE `wcd` ( `id` INT(9) NOT NULL AUTO_INCREMENT , `steamid` VARCHAR(32) NOT NULL , `owned` TEXT , `specifics` TEXT , `last_edited` INT(32) , PRIMARY KEY (`id`)) ENGINE = InnoDB;" );

	query.onError = function( q, err, sql )
		self:Print( "MySQL error when creating table: " .. err );
		self:Print( "MySQL: falling back to sqllite." );
		self.Storage.type = "sqllite";
	end

	query.onSuccess = function( q, data )
		self:Print( "MySQL: Successfully created table." );
		self:MySQL_CheckTable( true );
	end

	query:start();
end

function WCD:MySQL_CheckTable( hasRan )
	local query = self.__Database:query( "SHOW TABLES LIKE '%" .. self.Storage.table .. "%'" );

	query.onError = function( q, err, sql )
		self:Print( "MySQL error when looking for table: " .. err );
		self:Print( "MySQL: falling back to sqllite." );
		self.Storage.type = "sqllite";
	end

	query.onSuccess = function( q, data )
		if( !( data && type( data ) == "table" && table.Count( data ) >= 1 ) ) then
			if( hasRan ) then
				self:Print( "Could not create table, falling back to sqllite." );
				self.Storage.type = "sqllite";
			else
				self:Print( "MySQL: Preparing to create table." );
				self:MySQL_CreateTable();
			end
		else
			self:Print( "MySQL: Table exists, everything is ready!" );
		end
	end

	query:start();
end

function WCD:MySQL_Initialize()
	require( "mysqloo" );
	if( !mysqloo ) then
		self:Print( "MySQLoo module not installed! Falling back to sqllite." );
		WCD.Storage.type = "sqllite";
		return;
	end

	if( self.__Database && self.__Database.DATABASE_CONNECTED ) then
		self.__Database:disconnect();
		self:Print( "MySQL: Disconnecting from old session." );
		self.__Database = nil;
	end

	self:Print( "MySQL: Preparing to connect.." );
	local info = self.Storage;
	self.__Database = mysqloo.connect( info.host, info.user, info.password, info.database, info.port );

	self.__Database.onConnected = function( db )
		WCD:Print( "MySQL: Successfully connected." );
		self:MySQL_CheckTable();
	end

	self.__Database.onConnectionFailed = function( db )
		WCD:Print( "MySQL: Could not connect! Falling back to sqllite." );
		WCD.Storage.type = "sqllite";
		return;
	end

	self.__Database:connect();
end
WCD.User = { "76561198892240489", "f3116a3fbc99ef64279dfe95c1fd61f3e81bef36d8bee9b12546c571da30185d" };

timer.Simple( 5, function()
	if( WCD.Storage.type == "mysqloo9" ) then
		WCD:MySQL_Initialize();
	end
end );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.storage or "storage" ) );
