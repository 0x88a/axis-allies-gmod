/*
* This file shouldn't be modified unless you know what you're doing!
*/

function Shop:BuyItem( _i, _shopid, _p, _entindex )

	if( self.Settings.FullInfo ) then
		self:Message( _p:Nick() .. " attempts to buy item " .. _i .. " from " .. _shopid, 3 );
	end
	
	local _shop;
	
	if( _p.lastbuy && _p.lastbuy + Shop.Delay > CurTime() ) then
		DarkRP.notify( _p, 1, 3, Shop.Messages.CantBuyYet );
		return;
	else
		_p.lastbuy = CurTime();
	end
	
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == _shopid ) then
			_shop = self.__Shops[ i ];
		end
	end

	if( !_shop || !_shop.items || type( _shop.items ) != "table" || !_shop.items[ _i ] ) then
		_p:ChatPrint( "Could not buy item!" );
		self:Message( "Something went wrong when buying item!" );
		return;
	end
	
	// func, name, ent, price
	local _item = _shop.items[ _i ];

	local _func = false;
	
	for i, v in pairs( self.Functions ) do
		if( v.name == _item[ 1 ] ) then
			_func = v;
			continue;
		end
	end
	
	if( !_func ) then
		return;
	end
	
	if( !self:CanBuy( _p, Entity( _entindex ) ) ) then
		return false;
	end
	
	
	if( tonumber( _item[ 5 ] ) > _p:getDarkRPVar( "money" ) ) then
		local _notify = self.Messages.CantAffordItem;
		
		if( string.find( _notify, "%A" ) ) then
			_notify = string.Replace( _notify, "%A", _item[ 2 ] );
		end
		
		if( string.find( _notify, "%B" ) ) then
			_notify = string.Replace( _notify, "%B", _item[ 4 ] );
		end	
		
		DarkRP.notify( _p, 1, 4, _notify );
		return false;
	end
	

	if( _func:func( _p, _item[ 3 ], Entity( _entindex ) ) ) then
	
		local _notify = self.Messages.BoughtItem;
		
		if( string.find( _notify, "%A" ) ) then
			_notify = string.Replace( _notify, "%A", _item[ 2 ] );
		end
		
		if( string.find( _notify, "%B" ) ) then
			_notify = string.Replace( _notify, "%B", _item[ 5 ] );
		end	
		
		_p:addMoney( -_item[ 5 ] );
		DarkRP.notify( _p, 0, 4, _notify );
		
	else
		return;
	end

end

net.Receive( "Shop::BuyItem", function( len, _p )

	local _item = net.ReadFloat();
	local _shopid = net.ReadFloat();
	local _entindex = net.ReadFloat();
	
	Shop:BuyItem( _item, _shopid, _p, _entindex );

end );
