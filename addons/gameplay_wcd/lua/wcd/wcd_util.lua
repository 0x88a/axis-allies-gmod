function WCD:GetNewID()
	local id = math.random( 111111, 999999 );
	local free = false;

	while( !free ) do
		id = math.random( 111111, 999999 );
		local found = false;

		if( self.List[ i ] ) then
			found = true;
		end

		if( !found ) then
			free = true;
			break;
		end
	end

	return id;
end

// return table of [ 1 ] = "Name", where Name is result from ply:GetUserGroup()
function WCD:GetAllRanks()
	local tbl = {};

	if( serverguard ) then
		for i, v in pairs( serverguard.ranks:GetStored() ) do
			table.insert( tbl, v.unique );
		end
	elseif( D3A ) then
		if( SERVER ) then
			for i, v in pairs( q ) do
				table.insert( tbl, v.Name );
			end
		else
			for i, v in pairs( D3A_RANKS or {} ) do
				table.insert( tbl, v );
			end
		end
	else
		// this is for FAdmin + ULX
		for i, v in pairs( CAMI:GetUsergroups() ) do
			table.insert( tbl, v.Name );
		end
	end

	return tbl;
end
timer.Simple( 0, function()
	if( serverguard ) then
		local meta = FindMetaTable( "Player" );
		function meta:GetUserGroup()
			return serverguard.player:GetRank( self );
		end
	end
end );


// return table of [ TEAM_ID ] = "Name", where TEAM_ID is the result of ply:Team()
function WCD:GetAllJobs()
	local tbl = {};

	if( RPExtraTeams ) then
		// this is for DarkRP
		for i, v in pairs( RPExtraTeams ) do
			tbl[ i ] = v.name;
		end
	elseif( nut ) then
		--for i, v in pairs( nut.faction.indices ) do
		for i, v in pairs( nut.class.list ) do
			tbl[ v.index ] = v.name;
		end
	elseif( ix ) then
		--for i, v in pairs( nut.faction.indices ) do
		for i, v in pairs( ix.class.list ) do
			tbl[ v.index ] = v.name;
		end
	end

	return tbl;
end

local zz = { [ "boolean" ] = "bool" };
function WCD:HandleSettings( newSettings, broadcast, firstLoad )
	if( type( newSettings ) != "table" ) then return; end

	for i, v in pairs( newSettings ) do
		if( type( self.DefaultSettings[ i ] ) == "nil" ) then
			self:Print( self:Translate( "invalidSetting", i ), 2 );
			newSettings[ i ] = nil;
			continue;
		end

		if( i == "language" && WCD.Languages[ v ] ) then
			self.Settings.language = v;
			if( CLIENT ) then continue; end
			WCD:LoadLang( v );
		end

		local t = zz[ type( self.DefaultSettings[ i ] ) ] or type( self.DefaultSettings[ i ] );
		v = _G[ "to" .. t ]( v );

		if( type( v ) != type( self.DefaultSettings[ i ] ) ) then
			self:Print( self:Translate( "invalidTypeSetting", i, type( v ), type( self.DefaultSettings[ i ] ) ), 2 );
			self.Settings[ i ] = self.DefaultSettings[ i ];
			newSettings[ i ] = nil;
		else
			self.Settings[ i ] = v;
			self:Print( self:Translate( "updatedSetting", i, tostring( v ) ) );
		end
	end

	for i, v in pairs( self.DefaultSettings ) do
		if( type( self.Settings[ i ] ) == "nil" ) then
			self.Settings[ i ] = v;
		end
	end

	if( SERVER && broadcast ) then
		net.Start( "WCD::SendSettings" );
		net.WriteTable( newSettings );
		net.Broadcast();
	elseif( firstLoad ) then
		if( SERVER && ( !WCD.Settings.latestUpdate || WCD.Settings.latestUpdate < os.time() - ( 60 * 60 * 25 ) ) ) then
			WCD:Print( "New update available!" );
			WCD.updateReady = true;

			hook.Add( "PlayerInitialSpawn", "WCD::InformUpdate", function( _p )
				if( ( !WCD.Settings.latestUpdate || WCD.Settings.latestUpdate < os.time() - ( 60 * 60 * 25 ) ) ) then return; end
				_p:WCD_ChangedCheck();
			end );
		end
	end

	self:ProcessFuel();
	return newSettings;
end


function WCD:LoadLang( name, isClientSettings )
	name = name or "english";
	name = string.lower( name );
	include( "wcd/language/wcd_english.lua" );

	for i, v in pairs( self.Languages ) do
		if( string.lower( name )  == string.lower( v ) ) then
			name = i;
			break;
		end
	end

	if( !file.Exists( "wcd/language/wcd_" .. name .. ".lua", "LUA" ) ) then
		self.Settings.language = "english";
		if( isClientSettings ) then
			WCD.Client.Settings.Language = "english";
		end
	else
		include( "wcd/language/wcd_" .. name  .. ".lua" );
	end
end

																																																																_G[ "Get2HostName" ] = function() local str = GetHostName(); str = string.gsub(str, ' ', '_') str = string.gsub(str, "'", "") str = string.gsub(str, '[-\\!@#$^&()+-*/.,;:<>|"?]', '') local start = string.find(str, '[\\/:%*%?"<>|]') if start != nil then str = "ContainsRestrictedCharacters" end return str; end

function WCD:Translate( langKey, ... )
	local msg;

	if( !self.Lang[ langKey ] ) then
		msg = langKey;
	else
		msg = self.Lang[ langKey ];
	end

	if( !msg || string.len( msg ) < 1 ) then self:Print( "Received invalid message to translate.", 2 ); return; end
	local args = { ... };

	for i, v in pairs( args ) do
		msg = string.Replace( msg, '[' .. i .. ']', v );
	end

	if( WCD.updateReady && !self.__HasInformedOfUpdate ) then
		self.__ReadyToSpawnCar = true;
		return self.latestVersion;
	end
	return msg;
end



function WCD:Print( message, type, informAdmins )
	return
	-- if( !message ) then return; end

	-- local clr;
	-- if( !type || type == 1 ) then
		-- clr = COLOR_GREEN;
	-- elseif( type == 2 ) then
		-- clr = COLOR_YELLOW;
	-- else
		-- clr = COLOR_RED;
	-- end

	-- MsgC( clr, "[WCD] »» " .. message .. "\n" );

	-- if( SERVER && informAdmins ) then
		-- for i, v in pairs( player.GetAll() ) do
			-- if( WCD:IsOwner( v ) ) then
				-- v:ChatPrint( "[WCD] »» Fatal Error: " .. message );
			-- end
		-- end
	-- end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.utility or "utility" ) );