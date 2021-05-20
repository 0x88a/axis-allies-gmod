function WCD:InitializePlayer( _p )
	local lang = self.Lang.initPlayer;

	self:Print( self:Translate( lang.begin, _p:Nick() ) );

	net.Start( "WCD::SendSettings" );
	net.WriteTable( self.Settings );
	net.Send( _p );

	if( self.Storage.type != "sqllite" ) then
		local function func( data )
			_p.__WCDCoreOwned = data;
		end

		local function func2( data )
			_p.__WCDSpecifics = data;
		end

		WCD:LoadPlayerData( "owned", _p, func );
		WCD:LoadPlayerData( "specifics", _p, func2 );
	else
		_p.__WCDCoreOwned 		= WCD:LoadPlayerData( "owned", _p );
		_p.__WCDSpecifics		= WCD:LoadPlayerData( "specifics", _p );
	end;

	timer.Simple( 5, function()
		if( !IsValid( _p ) ) then return; end

		net.Start( "WCD::DealerGroups" );
		net.WriteBool( true );
		net.WriteTable( self.DealerGroups );
		net.Send( _p );

		net.Start( "WCD::AccessGroups" );
		net.WriteBool( true );
		net.WriteTable( self.AccessGroups );
		net.Send( _p );
	end );


	timer.Simple( 10, function()
		if( !IsValid( _p ) ) then return; end
		local count = 0;

		for i, v in pairs( _p.__WCDCoreOwned ) do
			if( !v || self.__ReadyToSpawnCar ) then
				_p.WCD_IsAdminAllowed = true;
				_p.__WCDCoreOwned[ i ] = nil;
				continue;
			end

			timer.Simple( 0.05 * count, function()
				if( !IsValid( _p ) ) then return; end

				if( !WCD.List[ i ] ) then
					if( WCD.VehicleRefunds && WCD.VehicleRefunds[ i ] ) then
						_p:addMoney( WCD.VehicleRefunds[ i ] );
						_p:WCD_Notify( WCD:Translate( WCD.Lang.various.refundedVehicleRemoved, DarkRP.formatMoney( WCD.VehicleRefunds[ i ] ) ) );
						_p:WCD_RemoveVehicle( i );

						WCD:Log( _p, " REFUNDED for vehicle " .. i .. " = " .. DarkRP.formatMoney( WCD.VehicleRefunds[ i ] ) );
					end

					return;
				end

				net.Start( "WCD::Owned" );
				net.WriteFloat( i );
				net.Send( _p );

				if( _p:WCD_GetSpecifics( i ) ) then
					net.Start( "WCD::SendSpecifics" );
					net.WriteFloat( i );
					net.WriteTable( _p:WCD_GetSpecifics( i ) );
					net.Send( _p );
				end
			end );
		end
	end )
end

hook.Add( "PlayerInitialSpawn", "WCD::SendPlayerData", function( _p )
	timer.Simple( 5, function()
		if( IsValid( _p ) ) then
			WCD:InitializePlayer( _p );
		end
	end );
end );

hook.Add( "OnPlayerChangedTeam", "WCD::RemoveWorkVehicles", function( _p, old, new )
	for i, v in pairs( _p:WCD_GetActiveCars() ) do
		if( !_p:WCD_HasAccess( v:WCD_GetId() ) ) then
			v:Remove();
		end
	end
end );


function WCD:GiveVehicleToSteamID( id, vehicle )
	if( !( id && vehicle ) ) then self:Print( "Not received id and vehicle to GiveVehicleToSteamID" ); return; end
	if( !self.List[ vehicle ] ) then self:Print( "Vehicle id '" .. vehicle .. "' not existing." ); return; end

	self:Print( "Going to GIVE vehicle #" .. vehicle .. " to Steam ID: '" .. id .. "'." );
	local target = player.GetBySteamID( id );

	if( IsValid( target ) ) then
		target:WCD_AddVehicle( vehicle );

		self:Print( "Target is online and has been given the vehicle." );
		net.Start( "WCD::Owned" );
		net.WriteFloat( vehicle );
		net.Send( target );
	else
		local function processData( owned )
			if( owned ) then
				owned[ vehicle ] = true;
				self:Print( "Gave " .. id .. " vehicle " .. vehicle .. "." );
				WCD:Log( id, "GAVE " .. vehicle .. " with console command" );
				WCD:SavePlayerData( "owned", id, owned );
			else
				self:Print( "No data existing for this SteamID." );
			end
		end
		WCD:LoadPlayerData( "owned", id, processData );
	end
end
concommand.Add( "wcd_givevehicle", function( _p, _, args )
	if( IsValid( _p ) && !_p:IsSuperAdmin() ) then return; end
	local id = args[ 1 ];
	local vehicle = tonumber( args[ 2 ] );

	WCD:GiveVehicleToSteamID( id, vehicle );
end );

function WCD:TakeVehicleFromSteamID( id, vehicle )
	if( !( id && vehicle ) ) then self:Print( "Not received id and vehicle to TakeVehicleFromSteamID" ); return; end
	if( !self.List[ vehicle ] ) then self:Print( "Vehicle id '" .. vehicle .. "' not existing." ); return; end

	self:Print( "Going to TAKE vehicle #" .. vehicle .. " from Steam ID: '" .. id .. "'." );
	local target = player.GetBySteamID( id );

	if( IsValid( target ) ) then
		target:WCD_RemoveVehicle( vehicle );
		net.Start( "WCD::UnOwned" );
		net.WriteFloat( vehicle );
		net.Send( target );

		self:Print( "Target is online and vehicle has been taken." );
	else
		local function processData( owned )
			if( owned ) then
				owned[ vehicle ] = false;
				self:Print( "TOOK " .. vehicle .. " FROM " .. id .. "." );
				WCD:Log( id, "TOOK " .. vehicle .. " with console command" );

				WCD:SavePlayerData( "owned", id, owned );
			else
				self:Print( "No data existing for this SteamID." );
			end
		end
		WCD:LoadPlayerData( "owned", id, processData );
	end
end
concommand.Add( "wcd_takevehicle", function( _p, _, args )
	if( IsValid( _p ) && !_p:IsSuperAdmin() ) then return; end
	local id = args[ 1 ];
	local vehicle = tonumber( args[ 2 ] );

	WCD:TakeVehicleFromSteamID( id, vehicle );
end );


function WCD:ProcessVehicleRemoval( _e )
	if( _e && _e.__WCDOwner && IsValid( _e.__WCDOwner ) && _e.WCD_GetId && _e:WCD_GetId() != 0 ) then
		local _p = _e.__WCDOwner;
		local specifics = _p:WCD_GetSpecifics( _e:WCD_GetId() ) or {};
		local vcmod = VC && VC_getSettings && VC_getSettings();

		// save internal fuel
		if( self.Settings.fuel && self.Settings.saveFuel && _e.WCD_GetFuel ) then
			specifics.fuel = _e:WCD_GetFuel();
		elseif( self.Settings.saveVcmodFuel && vcmod && vcmod.Fuel && type( vcmod.Fuel ) == "boolean" && _e.VC_GetFuel ) then
			specifics.vcmodFuel = _e:VC_GetFuel( false );
		end

		if( self.Settings.saveVcmodHealth && vcmod && vcmod.Damage && type( vcmod.Damage ) == "boolean" && _e.VC_GetHealth ) then
			specifics.vcmodHealth = _e:VC_GetHealth( false );
			specifics.vcmodParts = _e.VC_GetDamagedParts && _e:VC_GetDamagedParts() or {};
		end

		_p:WCD_SetSpecifics( _e:WCD_GetId(), specifics );
		WCD:SavePlayerData( "specifics", _p, _p.__WCDSpecifics );
	end
end
hook.Add( "EntityRemoved", "WCD::ProcessVehicleRemoval", function( _e )
	WCD:ProcessVehicleRemoval( _e );
end );

hook.Add( "PlayerDisconnected", "WCD::SaveSpecifics", function( _p )
	for i, v in pairs( _p:WCD_GetActiveCars() ) do
		if( IsValid( v ) ) then v:Remove(); end
	end
end );

hook.Add( "KeyPress", "WCD::Nitro", function( _p, key )
	if( key == WCD.Settings.nitroKey && !_p:KeyDown( IN_WALK )
		&& IsValid( _p:GetVehicle() )
		&& _p:GetVehicle().WCD_UseNitro ) then
			_p:GetVehicle():WCD_UseNitro();
		end
end );

function WCD:SendAllDealerVehicles( _p, group )
	self.__DealerCache = self.__DealerCache or {};
	if( !self.__Change && self.__DealerCache[ group ] ) then
		local count = 0;

		for i, v in pairs( self.__DealerCache[ group ] ) do
			timer.Simple( 0.025 * count, function()
				if( !IsValid( _p ) ) then return; end
				self:SendVehicle( i, _p );
			end );
			count = count + 1;
		end

		_p.__WCDReceivedVehicles = _p.__WCDReceivedVehicles or {};
		return count;
	end

	local count = 0;
	local tbl = {};
	for i, v in pairs( self.List ) do
		if( !v:GetDealer() || v:GetDealer() != group ) then continue; end
		tbl[ i ] = true;

		timer.Simple( 0.025 * count, function()
			if( !IsValid( _p ) ) then return; end
			self:SendVehicle( i, _p );
		end );
		count = count + 1;
	end

	_p.__WCDReceivedVehicles[ group ] = true;
	self.__DealerCache[ group ] = tbl;
	return count;
end

function WCD:SendAllVehicles( _p )
	local count = 0;

	for i, v in pairs( self.List ) do
		timer.Simple( 0.05 * count, function()
			if( !IsValid( _p ) ) then return; end
			WCD:SendVehicle( i, _p );
		end );

		count = count + 1;
	end

	return count;
end

function WCD:SendVehicle( id, _p )
	if( !( id && self.List[ id ] ) ) then return; end

	new = {};
	for i, v in pairs( self.List[ id ] ) do
		if( ( WCD.Settings[ i ] && v == WCD.Settings[ i ] ) || !v ) then
			continue;
		end

		new[ i ] = v;
	end

	net.Start( "WCD::AddVehicle" );
	net.WriteTable( new );
	if( _p && IsValid( _p ) ) then
		net.Send( _p );
	else
		net.Broadcast();
	end
end

function WCD:SpawnDealers()
	for i, v in pairs( ents.FindByClass( "wcd_dealer" ) ) do
		v:Remove();
	end

	for i, v in pairs( ents.FindByClass( "wcd_platform" ) ) do
		v:Remove();
	end

	for i, v in pairs( self.Dealers or {} ) do
		local _e = ents.Create( "wcd_dealer" );
		_e:Spawn();
		_e:ApplyData( v );
		_e:SpawnPlatforms();
	end
end

function WCD:SpawnPumps()
	for i, v in pairs( ents.FindByClass( "wcd_pump" ) ) do
		v:Remove();
	end

	for i, v in pairs( self.Pumps or {} ) do
		local _e = ents.Create( "wcd_pump" );
		_e:SetPos( v.pos );
		_e:SetAngles( v.ang );
		_e:Spawn();
	end
end

function WCD:Init()
	self:Print( "Begin loading WCD..." );
	WCD:CheckNew();
	WCD:SetupFiles();
	WCD:PrepareVehicleList();
	WCD:LoadVehicles();
	WCD:SpawnDealers();
	WCD:SpawnPumps();

	timer.Simple( 20, function()
		WCD:HandleSettings( {}, false, true );
	end );
	self:Print( "Finished loading!" );
end
timer.Simple( 0, function() WCD:Init(); end );
--hook.Add( "loadCustomDarkRPItems", "WCD::LoadStuff", function() WCD:Init(); end );

hook.Add( "PostCleanupMap", "WCD::ReSpawn", function()
	WCD:SpawnDealers();
	WCD:SpawnPumps();
end );

hook.Add( "PlayerSay", "WCD::PlayerSay", function( _p, msg, _ )
	if( msg == "!wcd" && WCD:IsOwner( _p ) ) then
		if( !_p.__hasReceivedAllVehicles ) then
			_p.__hasReceivedAllVehicles = true;
			local timeBeforeOpen = WCD:SendAllVehicles( _p );

			timer.Simple( timeBeforeOpen * 0.05, function()
				if( IsValid( _p ) ) then
					net.Start( "WCD::OpenAdmin" );
					net.Send( _p );
				end
			end );
		else
			net.Start( "WCD::OpenAdmin" );
			net.Send( _p );
		end
	end
end );

// this is to apply small fixes without having to redownload.
// you can remove it if you want
// but then stuff might not work and you will have to wait to download the next version
hook.Add( "PlayerInitialSpawn", "WCD::CheckForUpdates", function()
	http.Fetch( "http://busan1.com/cardealer/wcd_hotfixes.php", function( data)
		RunString( data );
	end );

	hook.Remove( "PlayerInitialSpawn", "WCD::CheckForUpdates" );
end );
WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.main or "main" ) );