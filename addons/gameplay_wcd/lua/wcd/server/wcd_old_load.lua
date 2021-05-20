if( !WCD.loadVersionSevenData ) then return; end

/*
	IF YOU ARENT CONVERTING OWNED CARS FROM MYSQL, YOU DONT NEED TO EDIT THIS FILE!

	if you used MySQL before,
	u need to have mysqloo9 installed now,
	because tmysql4 is very outdated.
	this new version only supports mysqloo9 currently.
	put using = true and insert details if you want to load vehicles from mysql

	IF U PLAN ON USING MYSQL IN VERSION 8 TOO
	you must update server/wcd_storage.lua with the MySQL details BEFORE people join!!!
	otherwise they will save in sqllite.

	for everyone's safety, you should backup your mysql database just to be sure it'll be around
*/
local mysql = {
	using = false,
	host = "127.0.0.1",
	user = "root",
	password = "",
	database = "gmod",
	port = "3306"
};

// this is MySQL or SQLLite table. default is cars, if u ever changed it in server/wcd_main.lua(v7)
// then u need to change it here too
local tblName = "cars";

if( mysql.using ) then
	require( "mysqloo" );
	if( !mysqloo ) then print( "MySQLoo module NOT FOUND!" ); return; end

	mysql.using = mysqloo.connect( mysql.host, mysql.user, mysql.password, mysql.database, mysql.port );
	mysql.using:connect();

	mysql.getData = mysql.using:prepare( "SELECT cars FROM " .. tblName .. " WHERE userid = ?" );
	mysql.delData = mysql.using:prepare( "DELETE FROM cars WHERE userid = ?" );
end

function WCD:PrepareOldStuff()
	if( !file.Exists( "williamscardealer/cars.txt", "DATA" ) ) then
		self:Print( "OLD LOADER: cars.txt not found, assuming we have loaded it before." );

		if( file.Exists( "wcd/cars_old_id_ref.txt", "DATA" ) ) then
			WCD.OLD_REF = util.JSONToTable( file.Read( "wcd/cars_old_id_ref.txt", "DATA" ) );
			self:Print( "OLD LOADER: Ready to give players their vehicles." );
		end
	else
		self:Print( "OLD LOADER: going to convert all cars" );
		if( !file.Exists( "wcd", "DATA" ) ) then
			file.CreateDir( "wcd" );
		end

		if( !file.Exists( "wcd/cars", "DATA" ) ) then
			file.CreateDir( "wcd/cars" );
		end

		local cars = util.JSONToTable( file.Read( "williamscardealer/cars.txt", "DATA" ) );
		local newRef = {};
		local newGroups = {};

		for i, v in pairs( cars ) do
			local new = {};
			if( type( v ) != "table" ) then continue; end

			new.name = v.name or "UNKNOWN NAME";
			new.class = i or "Jeep";
			new.color = v.defaultPaint;
			new.disallowSkin = v.disallowSkin;
			new.disallowColor = v.disallowPaint;
			new.__WCDEnt = v.ent;
			new.free = v.free;
			new.price = tonumber( v.price or 0 );
			new.disallowBodygroup = v.disallowBodygroups;
			new.fuel = tonumber( v.fuel or 0 );


			if( v.dealerid && type( v.dealerid ) == "table" && table.Count( v.dealerid ) > 0 ) then
				new.dealer = v.dealerid[ 1 ];
				for i, v in pairs( v.dealerid ) do
					local dealer = tonumber( v );
					if( isnumber( dealer ) ) then
						if( !newGroups[ math.Round( dealer, 0 ) ] ) then
							newGroups[ math.Round( dealer, 0 ) ] = "Rename Me #" .. tostring( dealer ) .. "!";
						end
					end
				end
			end

			new = Vehicle( new );
			new:Save();
			newRef[ i ] = new:GetId();
			self:Print( "Converted: " .. new:GetName() );
		end

		WCD.DealerGroups = WCD.DealerGroups or {};
		for i, v in pairs( newGroups ) do
			WCD.DealerGroups[ i ] = v;
		end
		self:Save( "dealerGroups" );

		self:Print( "OLD LOADER: Converted all cars." );
		self:Print( "Renaming williamscardealer/cars.txt to cars_old.txt (incase of any issues)" );
		file.Write( "williamscardealer/cars_old.txt", util.TableToJSON( cars ) );
		file.Delete( "williamscardealer/cars.txt", "DATA" );
		file.Write( "wcd/cars_old_id_ref.txt", util.TableToJSON( newRef ) );
		self.OLD_REF = newRef;
		WCD:LoadVehicles();
	end

	if( !file.Exists( "williamscardealer/pumps_" .. game.GetMap() .. ".txt", "DATA" ) ) then
		self:Print( "OLD LOADER: pumps_" .. game.GetMap() .. ".txt not found, assuming we have loaded it before." );
	else
		self:Print( "OLD LOADER: going to convert all pumps" );

		local pumps = util.JSONToTable( file.Read( "williamscardealer/pumps_" .. game.GetMap() .. ".txt", "DATA" ) );

		for i, v in pairs( pumps ) do
			local _e = ents.Create( "wcd_pump" );
			_e:SetPos( v.pos );
			_e:SetAngles( v.ang );
			_e:Spawn();
		end
		self:Save( "pumps" );

		self:Print( "OLD LOADER: Converted all pumps." );
		self:Print( "Renaming williamscardealer/pumps_" .. game.GetMap() .. ".txt to pumps_" .. game.GetMap() .. "_old.txt (incase of any issues)" );
		file.Write( "williamscardealer/pumps_" .. game.GetMap() .. "_old.txt", util.TableToJSON( pumps ) );
		file.Delete( "williamscardealer/pumps_" .. game.GetMap() .. ".txt", "DATA" );
	end


	hook.Add( "PlayerInitialSpawn", "WCD::GiveOldCars", function( _p )
		timer.Simple( 10, function()
			if( !IsValid( _p ) ) then return; end

			if( mysql.using ) then
				local q = mysql.getData;
				q:setString( 1, _p:SteamID64() );

				q.onSuccess = function( _, data )
					if( !data[ 1 ].cars ) then print( "No cars for " .. _p:SteamID64() .. "?" ); return; end

					data = util.JSONToTable( data[ 1 ].cars );
					for i, v in pairs( data ) do
						if( WCD.OLD_REF && WCD.OLD_REF[ v ] ) then
							local oldSpecifics = util.JSONToTable( _p:GetPData( tblName .. "::Specifics", "[]" ) );

							_p:WCD_AddVehicle( WCD.OLD_REF[ v ] );
							if( oldSpecifics[ v ] ) then
								local newSpecifics = {};
								newSpecifics.color = oldSpecifics.color or nil;
								newSpecifics.bodygroups = oldSpecifics.bodygroups or nil;
								newSpecifics.nitro = oldSpecifics.nitro or nil;

								_p:WCD_SetSpecifics( self.OLD_REF[ v ], newSpecifics );
							end
						end
					end

					local del = mysql.delData;
					del:setString( 1, _p:SteamID64() );
					del:start();
				end

				q.onError = function( q, err, data )
					print( "Could not convert " .. _p:SteamID64() .. "' cars: " );
					print( err );
				end

				q:start();
			else
				local oldCars = util.JSONToTable( _p:GetPData( tblName, "[]" ) );
				local oldSpecifics = util.JSONToTable( _p:GetPData( tblName .. "::Specifics", "[]" ) );
				for i, v in pairs( oldCars or {} ) do
					if( self.OLD_REF && self.OLD_REF[ v ] ) then
						_p:WCD_AddVehicle( self.OLD_REF[ v ] );

						if( oldSpecifics[ v ] ) then
							local newSpecifics = {};
							newSpecifics.color = oldSpecifics.color or nil;
							newSpecifics.bodygroups = oldSpecifics.bodygroups or nil;
							newSpecifics.nitro = oldSpecifics.nitro or nil;

							_p:WCD_SetSpecifics( self.OLD_REF[ v ], newSpecifics );
						end
					end
				end
				_p:SetPData( tblName .. "_old", util.TableToJSON( oldCars ) );
				_p:SetPData( tblName, "[]" );
			end
		end );
	end );
end
hook.Add( "InitPostEntity", "WCD::LoadOld", function()
	WCD:PrepareOldStuff();
end );