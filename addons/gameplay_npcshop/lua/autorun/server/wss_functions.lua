Shop.Functions = {};

/*
* Please read this file carefully!
* Any invalid settings will result in the addon not working.
* If you need help, you can add me on Steam:
* www.steamcommunity.com/id/busan1/
*/

/*

/*
* This file isn't necessary to edit, but if you want to add your own
* functions to the shop, then you can do it here.
* Remember that money is subtracted in wss_buy.lua.
* These functions are only called once the player has enough money.
* If  function returns true, subtracts money.
* If function returns false, Notify Shop.Messages.Unable to player.
*
* Every function  is provided with three arguments:
* _p = player entity
* _e = string name of what was bought
* _s = shop entity

You can change the NAME but do not change the index(  like Shop.Functions.GiveWeapon ).
*/

// Generate ammo
for i, v in pairs( Shop.Settings.AmmoTypes ) do
	Shop.Functions[ v ] = {};
	Shop.Functions[ v ].name = "Give ammo: " .. v;
	local _a = Shop.Functions[ v ];
	function _a:func( _p, _e, _s )
		print( v );
		_p:GiveAmmo( _e, v, true );
		
		return true;
	end
end


// This is the function that is called to give players a weapon.
// Simply done with the Give function.
Shop.Functions.GiveWeapon = {};
Shop.Functions.GiveWeapon.CreatesEntity = true;
Shop.Functions.GiveWeapon.name = "Give a weapon";
function Shop.Functions.GiveWeapon:func( _p, _e, _s )
	
	if( _p:HasWeapon( _e ) ) then
		DarkRP.notify( _p, 0, 4, Shop.Messages.PlayerHasWeapon );
		return false;
	end
	_p:Give( _e );
	_p:SetActiveWeapon( _e );
	return true;

end

// This function gives a player health; if > 100 then it's set to 100.
Shop.Functions.GiveHealth = {};
Shop.Functions.GiveHealth.name = "Give health";
function Shop.Functions.GiveHealth:func( _p, _e, _s )
	
	if( _p:Health() + _e > 100 ) then
		_p:SetHealth( 100 );
	else
		_p:SetHealth( _p:Health() + _e );
	end

	return true;

end

// This function gives a player armor; if > 100 then it's set to 100.
Shop.Functions.GiveArmor = {};
Shop.Functions.GiveArmor.name = "Give armor";
function Shop.Functions.GiveArmor:func( _p, _e, _s )
	
	if( _p:Armor() + _e > 100 ) then
		_p:SetArmor( 100 );
	else
		_p:SetArmor( _p:Armor() + _e );
	end

	return true;

end


// This function spawns an entity infront of the shop.
Shop.Functions.SpawnEnt = {};
Shop.Functions.SpawnEnt.CreatesEntity = true;
Shop.Functions.SpawnEnt.name = "Spawn an entity";
function Shop.Functions.SpawnEnt:func( _p, _e, _s )
	
	local _e = ents.Create( _e );
	_e:SetPos( _s._spawnpos );
	_e:SetAngles(  _s._spawnang );
	_e:Spawn();

	if( !IsValid( _e ) ) then
		return false;
	end

	return true;
	
end

// This is for PointShop points.
Shop.Functions.PSPoints = {};
Shop.Functions.PSPoints.name = "Pointshop points";
function Shop.Functions.PSPoints:func( _p, _e, _s )
	
	_p:PS_GivePoints( _e );
	return true;

end

// This functions spawns food from the food in config.
// Uses default DarkRP spawn food code.
Shop.Functions.SpawnFood = {};
Shop.Functions.SpawnFood.name = "Spawn food";
function Shop.Functions.SpawnFood:func( _p, _e, _s )

	local _foodData = false;
	
	for i, v in pairs( FoodItems ) do
		if( v.name == _e ) then
			_foodData = FoodItems[ i ];
		end
	end
	
	if( !_foodData ) then
		return false;
	end
	
	local _c = 0;
	for i, v in pairs( ents.FindByClass( "spawned_food" ) ) do
		if( v.bought && v.bought == _p ) then
			_c = _c + 1;
		end
	end
	
	if( _c > Shop.Settings.MaxFoodItems ) then
		DarkRP.notify( _p, 1, 5, Shop.Messages.TooManyFoods );
		return false;
	end
	
	local _e = ents.Create( "spawned_food" );
	_e:SetPos( _s._spawnpos );
	_e:SetAngles(  _s._spawnang );
	_e:Setowning_ent( _p  );
	_e.ShareGravgun = true;
	_e.bought = _p;
	_e:SetPos( _s._spawnpos );
	_e:SetAngles( _s._spawnang );
	_e.onlyremover = true;
	_e.SID = _p.SID;
	_e:SetModel( _foodData.model );
	_e.foodItem = {};
	_e.FoodName = _foodData.name;
	_e.FoodEnergy = _foodData.energy;
	_e.FoodPrice = _foodData.price;
	_e:Spawn();
	
	return true;

end
Shop.Functions.ToCoffeInv = {};
Shop.Functions.ToCoffeInv.name = "Put in CoffeeInventory";
function Shop.Functions.ToCoffeInv:func( _p, w, _s )
 
	local _e = ents.Create( "spawned_weapon" );
	_e:Spawn();
	_e.dt.WeaponClass = w;
	_e:SetWeaponClass( w );
	if( !IsValid( _e ) ) then
		return false;
	else
		coffeeInventory.storeItem( _p, _e );
		_p:ChatPrint( "Placed in your inventory! (Access with F1)" );
	end

end

Shop.Functions.ItemStore = {};
Shop.Functions.ItemStore.name = "Put in ItemStore(old version)";
function Shop.Functions.ItemStore:func( _p, _w, _s )
 
	local _e, class;
	local found = false;
	
	for i, v in pairs( weapons.GetList() ) do
		if( v.ClassName && v.ClassName == _w ) then
			found = true;
			break;
		end
	end
	
	if( found ) then
		_e = ents.Create( "spawned_weapon" );
		_e.dt.WeaponClass = _w;
		class = "spawned_weapon";
	else
		_e = ents.Create( _w );
		class = _e:GetClass();
	end
	
	if ( not self.PickupCooldown or self.PickupCooldown < CurTime() ) then
		_e:Spawn();

		if ( IsValid( _e ) and not _e.__Deleted ) then
			


			if ( itemstore.items.CanPickup( class ) ) then

				local item = class == "itemstore_item" and _e:GetItem() or itemstore.items.New( itemstore.items.Pickups[ class ] )
			
				if ( _p:GetInventory():CanFitItem( item ) ) then
					if ( item:Run( "CanPickup", _p, _e ) ) then
						item:Run( "SaveData", _e )
						item:Run( "Pickup", _p, _e )

						_p:EmitSound( "items/itempickup.wav" )

						if ( itemstore.config.PicksupGotoBank ) then
							local bank = ents.FindByClass( "itemstore_bank" )[ 1 ]

							if ( IsValid( bank ) ) then
								if ( not bank.Inventories[ _p ] ) then
									bank:CreateAccount( _p )
								end

								bank.Inventories[ _p ]:AddItem( item )
							end
						else
							_p:AddItem( item )
						end

						_e:Remove()
					end
				else
					_p:PrintMessage( HUD_PRINTTALK, "Your inventory is too full to pick up this item!" )
					return false;
				end
			end
		end

		_p.PickupCooldown = CurTime() + itemstore.config.PickupCooldown
		return true;
	else
		_e:Remove();
		return false;
	end
	
end

Shop.Functions.ItemStoreE = {};
Shop.Functions.ItemStoreE.name = "Put Entity in ItemStore";
function Shop.Functions.ItemStoreE:func( _p, _w, _s )
 
    local ent = ents.Create( _w );
    ent:Spawn();
    
    local class = itemstore.items.Pickups[ ent:GetClass() ]
    if itemstore.config.DisabledItems[ class ] then return false end
    
    local item = itemstore.Item( class )
    if not item then return end
    
    item:SaveData( ent )

    local con = itemstore.config.PickupsGotoBank and _p.Bank or _p.Inventory

    if not con:CanFit( item ) then return false end
    if hook.Call( "ItemStoreCanPickup", GAMEMODE, _p, item, ent ) == false then return false end
    if not item:CanPickup( _p, ent ) then return false end

    local slot = con:AddItem( item )

    if slot then
        item:Pickup( _p, con, slot, ent )
        ent:Remove()

        --self:ChatPrint( itemstore.Translate( "picked_up", item:GetName() ) )
        _p:EmitSound( "items/gunpickup2.wav" )

        return true
    end

    _p.QueueItemStoreSave = true

    
    return false;

    
end

Shop.Functions.SpawnProp = {};
Shop.Functions.SpawnProp.name = "Spawn prop";
function Shop.Functions.SpawnProp:func( _p, model, _s )
	local ent = ents.Create( "prop_physics" );
	ent:SetModel( model );
	ent:Spawn();
	ent:CPPISetOwner( _p );
	ent:SetPos( _s._spawnpos );
	ent:SetAngles( _s._spawnang );
	
	return true;
end

Shop.Functions.ItemStoreW = {};
Shop.Functions.ItemStoreW.name = "Put Weapon in ItemStore";
function Shop.Functions.ItemStoreW:func( _p, _w, _s )
 
    local ent = ents.Create( "spawned_weapon" );
    ent:Spawn();
    ent:SetWeaponClass( _w );
        
    local class = itemstore.items.Pickups[ ent:GetClass() ]
    if itemstore.config.DisabledItems[ class ] then return false end
    
    local item = itemstore.Item( class )
    if not item then return end
    
    item:SaveData( ent )

    local con = itemstore.config.PickupsGotoBank and _p.Bank or _p.Inventory

    if not con:CanFit( item ) then return false end
    if hook.Call( "ItemStoreCanPickup", GAMEMODE, _p, item, ent ) == false then return false end
    if not item:CanPickup( _p, ent ) then return false end

    local slot = con:AddItem( item )

    if slot then
        item:Pickup( _p, con, slot, ent )
        ent:Remove()

        --self:ChatPrint( itemstore.Translate( "picked_up", item:GetName() ) )
        _p:EmitSound( "items/gunpickup2.wav" )

        return true
    end

    _p.QueueItemStoreSave = true

    
    return false;

    
end

// What checks player needs to pass to buy stuff
function Shop:CanBuy( _p, _s )

	// Player and shop needs to exist
	if( !IsValid( _p ) || !IsValid( _s ) ) then
		if( self.Settings.FullInfo ) then
			self:Message( "Invalid player or shop!", 1 );
		end
		return false;
	end

	// Player needs to be alive, and not arrested
	if( !_p:Alive() || _p:isArrested() ) then
		if( self.Settings.FullInfo ) then
			self:Message( "Player tried to buy when dead/arrested!", 1 );
		end	
		return false;
	end

	// Player needs to be in range of the shop
	if( _s:GetPos():Distance( _p:GetPos() ) > 140 ) then
		if( self.Settings.FullInfo ) then
			self:Message( "Player out of range!", 1 );
		end	
		return false;
	end

	return true;
	
end