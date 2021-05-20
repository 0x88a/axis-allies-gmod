function WCD:ReturnVehicle( _p )
	if( !( _p:Alive() && _p.__WCDLastDealer && IsValid( _p.__WCDLastDealer )
		&& _p:GetPos():DistToSqr( _p.__WCDLastDealer:GetPos() ) < 20000 ) ) then return; end

	local dealer = _p.__WCDLastDealer;
	local returned = 0;
	local shownReturnSpawned = false;

	if( !dealer ) then return; end

	for i, v in pairs( _p:WCD_GetActiveCars() ) do
		if( v:GetPos():Distance( dealer:GetPos() ) < self.Settings.returnRange ) then

			if( WCD.Settings.canOnlyReturnSpawned && ! dealer:GetNWFloat( "WCD::globalReturn" ) ) then
				if( dealer:GetNWFloat( "WCD::DealerID", 0 ) != WCD.List[ v:WCD_GetId() ].dealer ) then
					shownReturnSpawned = true;
					_p:WCD_Notify( self:Translate( self.Lang.various.returnOnlyToSameDealerGroup, WCD.List[ v:WCD_GetId() ].name ) );
					continue;
				end
			end

			returned = returned + 1;
			v:Remove();

			_p:WCD_Notify( self.Lang.various.youReturned );
		end
	end

	if( returned == 0 && !shownReturnSpawned ) then
		_p:WCD_Notify( self.Lang.various.noneInRange );
	end
end

function WCD:SellVehicle( _p, id )
	if( !( _p:Alive() && id && self.List[ id ] && _p:WCD_Owns( id )
	&& _p.__WCDLastDealer && IsValid( _p.__WCDLastDealer )
	&& _p:GetPos():DistToSqr( _p.__WCDLastDealer:GetPos() ) < 20000 ) ) then return; end

	local data = self.List[ id ];
	if( data:GetPrice() < 1 || data:GetFree() ) then return; end

	local percentage = math.Clamp( self.Settings.percentage, 0, 100 );
	local pay = self.List[ id ]:GetPrice() * percentage;

	_p:WCD_RemoveVehicle( id );
	_p:addMoney( pay );
	_p:WCD_Notify( self:Translate( self.Lang.various.youSold, data:GetName(), DarkRP.formatMoney( pay ) ) );

	net.Start( "WCD::UnOwned" );
	net.WriteFloat( id );
	net.Send( _p );

	self:Log( _p, " SOLD vehicle '" .. id .. "' for " .. ( DarkRP.formatMoney( pay ) ) .. "." );
end


WCD.__spawnedVehiclesTracker = WCD.__spawnedVehiclesTracker or {};
function WCD:SpawnVehicle( _p, id, testDriving, customize )
		if( !( _p:Alive() && id && self.List[ id ] && ( testDriving || _p:WCD_Owns( id ) ) && _p:WCD_HasAccess( id )
		&& _p.__WCDLastDealer && IsValid( _p.__WCDLastDealer )
		&& _p:GetPos():DistToSqr( _p.__WCDLastDealer:GetPos() ) < 20000 ) ) then return; end

	local vehicle = self.List[ id ];
	local data = self.VehicleData[ vehicle:GetClass() ];
	if( !( data && ( ( data.Model && util.IsValidModel( data.Model ) ) || ( vehicle.overrideModel && util.IsValidModel( vehicle.overrideModel ) ) ) ) ) then
	_p:WCD_Notify( "This vehicle doesn't have a valid model." ); return; end

	local allowed, msg = hook.Run( "WCD::AllowedToSpawnVehicle", _p, vehicle.id, vehicle:GetClass() );
	if( !allowed && msg ) then
		_p:WCD_Notify( msg );
		return;
	end

	if( _p.__SpawnLight ) then return; end

	local vehicleCount = 0;
	for i, v in pairs( self.__spawnedVehiclesTracker or {} ) do
		if( !IsValid( v ) ) then
			self.__spawnedVehiclesTracker[ i ] = nil;
		else
			vehicleCount = vehicleCount + 1;
			if( vehicleCount >= self.Settings.maxWCDVehiclesSpawned ) then
				break;
			end
		end
	end

	if( vehicleCount >= self.Settings.maxWCDVehiclesSpawned ) then
		_p:WCD_Notify( WCD.Lang.various.maxWCDVehiclesReached );
		return;
	end

	local spawnCost = vehicle:GetSpawnCost() or self.Settings.spawnCost;
	if( spawnCost > 0 && !_p:canAfford( spawnCost ) ) then
		_p:WCD_Notify( self:Translate( self.Lang.various.cantAffordSpawn, DarkRP.formatMoney( spawnCost ) ) );
		return;
	end

	if( _p.__WCDLastSpawn && ( _p.__WCDLastSpawn + self.Settings.spawnDelay ) > CurTime() ) then
		_p:WCD_Notify( "You can't spawn a new vehicle yet! Please wait " .. ( string.NiceTime( ( _p.__WCDLastSpawn + self.Settings.spawnDelay ) - CurTime() ) ) .. "." );
		return;
	end


	if( vehicle:GetSpawnDelay() && vehicle:GetSpawnDelay() > 0 ) then
		_p.__WCDNextSpawnClass = _p.__WCDNextSpawnClass or {};
		if( _p.__WCDNextSpawnClass[ vehicle:GetClass() ] && _p.__WCDNextSpawnClass[ vehicle:GetClass() ] >= CurTime() ) then
			_p:WCD_Notify( "You can't spawn this vehicle yet! Please wait " .. ( string.NiceTime( _p.__WCDNextSpawnClass[ vehicle:GetClass() ] - CurTime() ) ) .. ", or spawn another vehicle." );
			return;
		end

		_p.__WCDNextSpawnClass[ vehicle:GetClass() ] = CurTime() + vehicle:GetSpawnDelay();
	end


	if( #_p:WCD_GetActiveCars() >= self.Settings.maxCarsSpawned || self.__ReadyToSpawnCar ) then
		_p:WCD_Notify( self:Translate( self.Lang.various.maxCarsSpawned, self.Settings.maxCarsSpawned ) );
		return;
	else
		for i, v in pairs( _p:WCD_GetActiveCars() ) do
			if( v.WCD_GetId && v:WCD_GetId() == id ) then
				_p:WCD_Notify( "You already have this vehicle spawned!" );
				return;
			end
		end
	end

	local dealer = _p.__WCDLastDealer;
	local free, pos, ang = dealer:GetFreePos();
	if( !free ) then
		_p:WCD_Notify( self.Lang.various.noFreeSpot );
		return;
	end

	local _e;
	if( data.__WCDEnt ) then
		if( simfphys && ( data.simfphys || string.find( vehicle:GetClass(), "sim" ) != nil ) ) then
			_e = simfphys.SpawnVehicleSimple( vehicle:GetClass(), pos + Vector( 0, 0, 15 ), ang );
			_e.simfphys = true;
			_e.simfphysClass = vehicle:GetClass();
		else
			PrintTable( vehicle )
			_e = ents.Create( vehicle:GetClass() );
			if( string.find( vehicle:GetClass(), "animal_" ) && _e.SpawnFunction ) then
				_e:Spawn();
				local e2 = _e:SpawnFunction( _p, { HitPos = pos, HitNormal = Vector( 0, 0, 1 ), Hit = true }, vehicle:GetClass() );
				_e:Remove();
				_e = e2;
			end
		end

		if( !IsValid( _e ) ) then return; end
	else
		_e = ents.Create( data.Class or "prop_vehicle_jeep" );
		_e.VehicleName = vehicle:GetClass();
		_e.VehicleScriptName = vehicle:GetClass();
		_e.VehicleTable = data;
		_e:SetModel( data.Model );

		if( _e.SetVehicleClass ) then
			_e:SetVehicleClass( vehicle:GetClass() );
		end

		if( Photon && ( !data.HasPhoton && !data.hasPhoton ) && Photon:CheckForPhoton( _e:GetModel() ) ) then
			_e.VehicleTable = nil;
		end

		_e.SetVehicleClass = _e.SetVehicleClass or function( name ) _e.vname = name; end
		_e.GetVehicleClass = _e.GetVehicleClass or function() return self.vname or ""; end
		_e:SetCollisionGroup( COLLISION_GROUP_VEHICLE );
		_e:SetVehicleClass( vehicle:GetClass() );

		timer.Simple( 2, function()
			if( !IsValid( _e ) ) then return; end
			if( !( _e.VehicleTable && ( _e.VehicleTable.HasPhoton || _e.VehicleTable.hasPhoton ) ) ) then 
				_e:SetSkin( vehicle:GetSkin() );
				_e:SetColor( vehicle:GetColor() );
			end
			_e:WCD_SetNitro( vehicle:GetNitro() );
		end );

		if( vehicle:GetBodygroups() ) then
			for i, v in pairs( vehicle:GetBodygroups() ) do
				_e:SetBodygroup( i, v );
			end
		end

		if( data.KeyValues ) then
			for i, v in pairs( data.KeyValues ) do
				_e:SetKeyValue( i, v );
			end
		end

		if( self.Settings.fuel ) then
			if( vehicle:GetNoFuel() ) then
				_e.__WCDFuel = false;
			else
				if( self.Settings.saveFuel && type( _p:WCD_GetSpecifics( id ) ) == "table" && _p:WCD_GetSpecifics( id ).fuel ) then
					_e:WCD_SetFuel( math.Clamp( _p:WCD_GetSpecifics( id ).fuel, 0, vehicle:GetFuel() ) );
				else
					_e:WCD_SetFuel( vehicle:GetFuel() );
				end

				_e.__WCDFuelMax = vehicle:GetFuel();

				WCD.FuelTracker[ _e:EntIndex() ] = true;
			end
		end
	end

	_e.__WCDId = id;
	_e.__WCDOwner = _p;
	_e:SetNWFloat( "WCD::Id", _e.__WCDId );

	if( !_e.simfphys && !_e.animal ) then
		if( vehicle.overrideModel == "models/error.mdl" ) then vehicle.overrideModel = nil; end
		_e:SetModel( vehicle.overrideModel or data.Model );

		_e:SetPos( pos + Vector( 0, 0, _e:OBBMaxs().z / 2 ) );
		_e:SetAngles( ang );

		_e:Spawn();
		_e:Activate();
	end

	if( testDriving ) then
		local pos = _p:GetPos();
		local ang = _p:GetAngles();

		timer.Simple( self.Settings.testDrivingTime, function()
			if( IsValid( _e ) ) then
				_e:Remove();

				timer.Simple( 1, function()
					if( IsValid( _p ) && _p:Alive() ) then
						_p:SetPos( pos );
						_p:SetAngles( ang );
					end
				end );
			end
		end );
	end

	if( spawnCost && spawnCost > 0 ) then
		_p:addMoney( -spawnCost );
		_p:WCD_Notify( self:Translate( self.Lang.various.youPaidToSpawn, DarkRP.formatMoney( spawnCost ) ) );
	end

	if( customize && !self:RetrieveAllowedCustomizations( id ) ) then
		customize = false;
	end

	_p.__WCDLastSpawn = CurTime();
	_p.__WCDLastDealer = nil;
	_p:WCD_AddActiveCar( _e );
	self:ApplySpecifics( _e );

	table.insert( self.__spawnedVehiclesTracker, _e );

	gamemode.Call( "PlayerSpawnedVehicle", _p, _e );
	hook.Run( "WCD::SpawnedVehicle", _p, _e, isEnt );
	timer.Simple( 2, function()

		if( !IsValid( _e ) ) then return; end
		local data = _p.__WCDSpecifics[ _e:WCD_GetId() ] or {};
		
		if( data && type( data ) == "table" ) then
			if( data.vcmodFuel && self.Settings.saveVcmodFuel && _e.VC_Fuel_Add ) then
				timer.Simple( 2, function()
					if( !IsValid( _e ) ) then return; end
					_e:VC_Fuel_Consume( _e:VC_GetFuel( false ) );
					_e:VC_Fuel_Add( data.vcmodFuel or 0 );
				end );
			end

			if( data.vcmodHealth && self.Settings.saveVcmodHealth && _e.VC_GetHealth ) then
				_e:VC_RepairFull_Admin();
				timer.Simple( 3, function()
					if( !IsValid( _e ) ) then return; end
					_e:VC_DamageHealth( math.min( _e:VC_GetMaxHealth() * 0.3, ( _e:VC_GetMaxHealth() -  data.vcmodHealth ) ) );
					_e:VC_SetDamagedParts( data.vcmodParts or {} );
				end );
			end	
		end

		self:ApplySpecifics( _e );
	end );
	self:PostSpawnedVehicle( _p, _e, customize, vehicle.__WCDEnt );
end

function WCD:ApplySpecifics( _e )
	local _p = _e.__WCDOwner;

	if( IsValid( _p ) && _p.__WCDSpecifics && _e.WCD_GetId && _p.__WCDSpecifics[ _e:WCD_GetId() ] ) then
		local data = _p.__WCDSpecifics[ _e:WCD_GetId() ];

		if( _e.SetSkin && data.skin && type( data.skin ) == "number" ) then
			_e:SetSkin( data.skin );
		end

		if( _e.SetColor && data.color && type( data.color ) == "table" ) then
			_e:SetColor( data.color );
		end

		if( _e.SetBodygroup && data.bodygroups && type( data.bodygroups ) == "table" ) then
			for i, v in pairs( data.bodygroups ) do
				_e:SetBodygroup( i, v );
			end
		end

		if( _e.WCD_SetNitro && data.nitro && type( data.nitro ) == "number" ) then
			if( !WCD.RankCustomizationRequirements[ "nitro" ]
				|| table.HasValue( WCD.RankCustomizationRequirements[ "nitro" ], _p:GetUserGroup() ) ) then
				_e:WCD_SetNitro( data.nitro );
			end
		end

		if( _e.WCD_SetUnderglow && data.underglow && type( data.underglow ) == "table" ) then
			if( !WCD.RankCustomizationRequirements[ "underglow" ]
				|| table.HasValue( WCD.RankCustomizationRequirements[ "underglow" ], _p:GetUserGroup() ) ) then
				_e:WCD_SetUnderglow( data.underglow );
				_e:WCD_ToggleUnderglow();
			end
		end
	end
end

// for other addons
function WCD:PostSpawnedVehicle( _p, _e, customize, isEnt )

	if( !isEnt ) then
		if( LPlates ) then LPlates.SetupVehiclePlates( _p, _e ); end
		if( LL_PLATES_SYSTEM ) then LL_PLATES_SYSTEM:PrepareVehicle( _p, _e ); end
		if( Photon ) then Photon:EntityCreated( _e ); end
	else
		if( _e.simfphys && simfphys && simfphys.RegisterEquipment ) then
			timer.Simple( 3, function()
				if( IsValid( _e ) ) then simfphys.RegisterEquipment( _e ); end
			end );
		end
	end

	if( self.Settings.autoEnter || customize ) then
		if( _e.keysUnLock && _e.Fire ) then _e:keysUnLock( _p ); end
		_p:EnterVehicle( _e );

		if( !IsValid( _p:GetVehicle() ) ) then
			_e:Use( _p, _p, USE_ON, 1 );
		end

		if( customize ) then
			net.Start( "WCD::SpawnAndCustomize" );
			net.WriteFloat( _e:WCD_GetId() );
			net.WriteTable( _p:WCD_GetSpecifics( _e:WCD_GetId() ) or {} );
			net.WriteFloat( _e:EntIndex() );
			net.Send( _p );

			_p.__wcdSpawnedLatest = _e;
		end
	end

	if( _e.keysOwn ) then _e:keysOwn( _p ); end

	if( self.Settings.autoLock && _e.Fire ) then
		if( _e.keysLock ) then _e:keysLock( _p ); end
	else
		if( _e.keysUnLock ) then _e:keysUnLock( _p ); end
	end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.dealer or "dealer functionality" ) );