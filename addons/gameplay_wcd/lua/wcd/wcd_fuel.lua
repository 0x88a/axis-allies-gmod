local meta = FindMetaTable( "Vehicle" );
function meta:WCD_SetFuel( x )
	self.__WCDFuel = math.Clamp( x, 0, 999999 );
end

function meta:WCD_GetFuel()
	return self.__WCDFuel or -1;
end

function meta:WCD_AddFuel( x )
	self.__WCDFuel = math.Clamp( ( self.__WCDFuel or 0 ) + x, 0, self:WCD_GetFuelMax() );

	if( x > 0 ) then
		self:Fire( "TurnOn", true, 0 );
	end
end

function meta:WCD_GetId()
	return self:GetNWFloat( "WCD::Id", -1 );
end

function meta:WCD_SetFuelMax( x )
	self.__WCDFuelMax = math.Clamp( x, 0, 999 );
end

function meta:WCD_GetFuelMax()
	if( self:WCD_GetId() == -1 || !WCD.List[ self:WCD_GetId() ] ) then return -1; end
	if( !self.__WCDFuelMax ) then self.__WCDFuelMax = WCD.List[ self:WCD_GetId() ]:GetFuel(); end
	return self.__WCDFuelMax or self.__WCDFuel or 0;
end

function meta:WCD_ProcessFuel()
	if( ( SERVER && !IsValid( self:GetDriver()  ) ) || self:WCD_GetId() == -1 || self:WCD_GetFuel() < 0 ) then return; end
	if( SERVER && self:WCD_GetFuel() <= 0.2 ) then
		self:Fire( "TurnOff", true, 0 );
	elseif( SERVER && ( !self.__WCDLastFuel || self.__WCDLastFuel < 1 ) ) then
		self:Fire( "TurnOn", true, 0 );
	end

	local oldPos = self.__WCDOldPos or self:GetPos();
	local newPos = self:GetPos();

	local dist = oldPos:Distance( newPos ) / 15000;
	dist = dist * ( WCD.List[ self:WCD_GetId() ] && WCD.List[ self:WCD_GetId() ].fuelMulti or WCD.Settings.fuelMulti );
	dist = dist * WCD.Settings.fuelMultiplier;

	self:WCD_AddFuel( -dist );
	self.__WCDLastFuel = self:WCD_GetFuel();

	self.__WCDOldPos = self:GetPos();
end

if( SERVER ) then
	WCD.FuelTracker = WCD.FuelTracker or {};

	util.AddNetworkString( "WCD::SyncFuel" );
	hook.Add( "PlayerEnteredVehicle", "WCD::SyncFuel", function( _p, veh, _ )
		if( WCD.FuelTracker[ veh:EntIndex() ] ) then
			net.Start( "WCD::SyncFuel" );
			net.WriteFloat( veh:WCD_GetFuel() );
			net.Send( _p );

			veh:WCD_ProcessFuel();
		end
	end );
else
	net.Receive( "WCD::SyncFuel", function()
		local fuel = net.ReadFloat();

		timer.Simple( 0.5, function()
			if( IsValid( LocalPlayer():GetVehicle() ) ) then
				LocalPlayer():GetVehicle():WCD_SetFuel( fuel );
			end
		end );
	end );
end

function WCD:ProcessFuel()
	if( self.Settings.fuel ) then
		timer.Create( "WCD::ProcessFuel", 2, 0, function()
			if( SERVER ) then
				for i, v in pairs( WCD.FuelTracker ) do
					if( !IsValid( Entity( i ) ) ) then
						WCD.FuelTracker[ i ] = nil;
						continue;
					end

					if( !( Entity( i ):GetDriver() && IsValid( Entity( i ):GetDriver() ) ) ) then
						continue;
					end

					Entity( i ):WCD_ProcessFuel();
				end
			else
				if( IsValid( LocalPlayer():GetVehicle() ) && LocalPlayer():GetVehicle().WCD_ProcessFuel ) then
					LocalPlayer():GetVehicle():WCD_ProcessFuel();
				end
			end
		end );
	else
		timer.Destroy( "WCD::ProcessFuel" );
	end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.fuel or "fuel" ) );