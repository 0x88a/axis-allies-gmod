if( RBCI ) then
	CarDealer = CarDealer or {};
	CarDealer.Settings = {};	
	CarDealer.Impounded = CarDealer.Impounded or {};

	local function saveImpoundList()
		local list = {};

		for i, v in pairs( CarDealer.Impounded ) do
			table.insert( list, { id = i, classes = v } );
		end

		file.Write( "wcd/rbci_impound.txt", util.TableToJSON( list ) );
	end

	local function loadImpoundList()
		if( file.Exists( "wcd/rbci_impound.txt", "DATA" ) ) then
			local list = util.JSONToTable( file.Read( "wcd/rbci_impound.txt", "DATA" ) );
			
			for i, v in pairs( list ) do
				CarDealer.Impounded[ v.id ] = v.classes;
			end
		end
	end

	hook.Add( "WCD::AllowedToSpawnVehicle", "WCD::RBCI::ImpoundCheck", function( _p, id, class )
		if( CarDealer.Impounded[ _p:SteamID64() ] && CarDealer.Impounded[ _p:SteamID64() ][ class ] ) then
			return false, "This vehicle is impounded!";
		end
	end );

	hook.Add( "ShutDown", "saveImpoundList", function( _p )
		saveImpoundList();
	end );

	timer.Simple( 0, function()
		loadImpoundList();
	end );
end