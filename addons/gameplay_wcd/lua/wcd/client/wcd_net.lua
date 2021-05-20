net.Receive( "WCD::SetVehicleNitro", function()
	local _e = Entity( net.ReadFloat() );
	local nitro = net.ReadFloat();

	if( IsValid( _e ) && _e.WCD_SetNitro ) then
		_e:WCD_SetNitro( nitro );
	end
end );

net.Receive( "WCD::SendSpecifics", function()
	LocalPlayer():WCD_SetSpecifics( net.ReadFloat(), net.ReadTable() );
end );

net.Receive( "WCD::Owned", function()
	local id = net.ReadFloat();
	LocalPlayer():WCD_AddVehicle( id );
	WCD:Print( "We own vehicle: " .. id );

	if( IsValid( WCD.DealerUI ) ) then
		for i, v in pairs( WCD.DealerUI.lists ) do
			WCD.DealerUI:RebuildList( i );
		end
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::UnOwned", function()
	LocalPlayer():WCD_RemoveVehicle( net.ReadFloat() );

	if( IsValid( WCD.DealerUI ) ) then
		for i, v in pairs( WCD.DealerUI.lists ) do
			WCD.DealerUI:RebuildList( i );
		end
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::Notification", function()
	WCD:Notification( net.ReadString() );
end );

net.Receive( "WCD::SendSettings", function()
	WCD:HandleSettings( net.ReadTable() );
	WCD:ProcessFuel();
	WCD:Notification( WCD.Lang.settingsReceived );
end );

net.Receive( "WCD::AccessGroups", function( _, _p )
	local sendAll = net.ReadBool();

	if( sendAll ) then
		WCD.AccessGroups = net.ReadTable();

		WCD:Print( "Received all access groups." );
	else
		local data = net.ReadTable();
		WCD.AccessGroups[ data.name ] = data;
		WCD:Print( "Received access group '" .. data.name .. "'." );
	end

	if( WCD.AccessHelper && IsValid( WCD.AccessHelper ) ) then
		WCD:OpenAccessHelper();
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::DeleteAccessGroup", function( _, _p )
	local name = net.ReadString();
	WCD.AccessGroups[ name ] = nil;
	WCD:Print( "Deleted access group '" .. name .. "'." );

	if( WCD.AccessHelper && IsValid( WCD.AccessHelper ) ) then
		WCD:OpenAccessHelper();
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::DealerGroups", function( _, _p )
	local sendAll = net.ReadBool();

	if( sendAll ) then
		WCD.DealerGroups = net.ReadTable();

		WCD:Print( "Received all dealer groups." );
	else
		local id = net.ReadFloat();
		local name = net.ReadString();
		WCD.DealerGroups[ id ] = name;

		WCD:Print( "Received dealer group '" .. name .. "'." );
	end

	if( WCD.DealerHelper && IsValid( WCD.DealerHelper ) ) then
		WCD:OpenDealerHelper();
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::DeleteDealerGroup", function( _, _p )
	local id = net.ReadFloat();
	print( id )
	WCD:Print( "Deleted dealer group: " .. ( WCD.DealerGroups[ id ] or "no group" ) .. "." );
	WCD.DealerGroups[ id ] = nil;

	if( WCD.DealerHelper && IsValid( WCD.DealerHelper ) ) then
		timer.Simple( 0.25, function() WCD:OpenDealerHelper(); end );
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::EditDealerGroup", function( _, _p )
	local id = net.ReadFloat();
	local name = net.ReadString();

	WCD.DealerGroups[ id ] = name;
	WCD:Print( "Received edited dealer group with id " .. id .. ", new name: " .. name .. "." );

	if( WCD.DealerHelper && IsValid( WCD.DealerHelper ) ) then
		WCD:OpenDealerHelper();
	end

	WCD.__Change = true;
end );

net.Receive( "WCD::DeleteVehicle", function( _, _p )
	local id = net.ReadFloat();
	if( WCD.List[ id ] ) then
		WCD.List[ id ]:Delete();
	end

	if( IsValid( WCD.AdminUI ) ) then
		WCD.AdminUI.views[ 2 ]:RebuildTop();
	elseif( IsValid( WCD.DealerUI ) ) then
		WCD.DealerUI:Remove();
	end

	WCD.__Change = true;
end );


net.Receive( "WCD::AddVehicle", function( _, _p )
	local data = net.ReadTable();
	WCD.List[ data.id ] = Vehicle( data );

	if( IsValid( WCD.AdminUI ) ) then
		WCD.AdminUI.views[ 2 ]:RebuildTop();
	end

	WCD:Print( "Received data for id " .. data.id );
	WCD.__Change = true;
end );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.net or "net" ) );
