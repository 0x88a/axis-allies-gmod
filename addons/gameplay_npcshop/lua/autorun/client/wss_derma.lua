/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

/*
* This file shouldn't be modified unless you know what you're doing!
*/

function Shop:ShopDerma( _shop, _entindex )

	local _cats = {};
	local _items = {};
	
    // Main frame \\
	local _data = Shop.__Shops[ _shop ];
	if( !_data ) then
		return;
	end
	
    local _main = vgui.Create( "DFrame" );
    _main:SetSize( Shop.Width, Shop.Height );
    _main:SetTitle( "" );
    _main:SetDraggable( false );
    _main:Center();
    _main:MakePopup();
    _main.Init = function( self )
        self.startTime = SysTime();
    end

	local _title = vgui.Create( "DLabel", _main );
	_title:SetText( _data.name );
	_title:SizeToContents();
	_title:SetColor( Shop.Colors.Title );
	_title:SetPos( _main:GetWide() / 2 - ( _title:GetWide() / 2 ), 5 );
	

	
    _main.Paint = function( self, w, h )
       if( Shop.Blur ) then
			Derma_DrawBackgroundBlur( self, self.startTime );
		end
		draw.RoundedBox( 0, 0, 0, w, h, Shop.Colors.Panel );
    end;

    // End main frame \\
	
	// Menu Bar \\
	local _menubar = vgui.Create( "DScrollPanel", _main );
	local _a = _menubar;
	_a:SetSize( _main:GetWide() / 4, _main:GetTall() );
	_a:SetPos( -10000 , 22 );
	_a.Paint = function( self, w, h )
		//draw.RoundedBox( 0, 0, 0, w, h, Shop.Colors.MenuPanel ); 
	end;
	
	_a = nil;
	
	local _list = vgui.Create( "DIconLayout", _menubar );
	_a = _list;
	_a:SetSize( _main:GetWide() / 4, _main:GetTall() );
	_a:SetSpaceY( 3 );
	
	// End Menu Bar \\
	
	// Generate menu buttons \\
	

	
	// Generated menu buttons \\
	
	// Items panels \\
	_a = nil;
	
	local _itemsPanel = vgui.Create( "DScrollPanel", _main );
	_a = _itemsPanel;
	_a:SetSize( _main:GetWide(), _main:GetTall() - 40 );
	_a:SetPos(0, 22);
	_a.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h,Shop.Colors.ItemsPanel ); 
	end;
	
	
	_a = nil;
	local _itemsLists = {};
	local _buttons = {};
	local _c = 0;

	for i, v in pairs( _data.items ) do
		if( _itemsLists[ v[ 4 ] ] ) then
			continue;
		end
		_c = _c + 1;

		_itemsLists[ v[ 4 ] ] = vgui.Create( "DIconLayout", _itemsPanel );
		_a = _itemsLists[ v[ 4 ] ];
		_a:SetSize( _itemsPanel:GetWide(), _itemsPanel:GetTall() );
		_a:SetSpaceY( 3 );
		if( _c > 1 ) then
			_a:SetVisible( false );
		end
		
		_buttons[ i ] = _list:Add( "Shop::Button2" );
		_buttons[ i ]:SetSize( _menubar:GetWide()-5, 50 );
		_buttons[ i ]:SetFont( "wssBig" );
		_buttons[ i ]:SetText( v[ 4 ] );
		if( _c == 1 ) then
			_buttons[ i ]:SetState( true );
		end
		_buttons[ i ].DoClick = function( self )
			for i2, v2 in pairs( _buttons ) do
				_buttons[ i2 ]:SetState( false );
			end
			
			for i2, v2 in pairs( _itemsLists ) do
				v2:SetVisible( false );
			end
			
			_itemsLists[ v[ 4 ] ]:SetVisible( true );
			self:SetState( true );
			_buttons[ i ]:SetState( true );
			
			if( Shop.PlaySounds ) then
				surface.PlaySound( Shop.ButtonSounds );
			end
		end	
	end
	
	for i1, v1 in pairs( _itemsLists ) do
		local _c = 0;
		for i, v in pairs( _data.items ) do
			if( v[ 4 ] == i1 ) then
				_c = _c + 1;
				_items[ i ] = _itemsLists[ v[ 4 ] ]:Add( "DPanel" );
				_items[ i ]:SetSize( _itemsLists[ v[ 4 ] ]:GetWide(), 50 );
				if( _c % 2 == 0 ) then
					_items[ i ].Paint = function( self, w, h )
						draw.RoundedBox( 0, 0, 0, w, h, Shop.Colors.Even );
					end
				else
					_items[ i ].Paint = function( self, w, h )
						draw.RoundedBox( 0, 0, 0, w, h, Shop.Colors.Uneven );
					end
				end
				
				_items[ i ].label1 = vgui.Create( "DLabel", _items[ i ] );
				_items[ i ].label1:SetText( v[ 2 ] );
				_items[ i ].label1:SetFont( "wssBig" );
				_items[ i ].label1:SetColor( Shop.Colors.ItemColor );
				_items[ i ].label1:SetPos( 10, 16 );
				_items[ i ].label1:SizeToContents();
				
				_items[ i ].label2 = vgui.Create( "DLabel", _items[ i ] );
				_items[ i ].label2:SetText( "$".. v[ 5 ] );
				_items[ i ].label2:SetFont( "wssBig" );
				_items[ i ].label2:SetColor( Shop.Colors.ItemColor );
				local _x, _y = _items[ i ].label1:GetPos();
				_items[ i ].label2:SizeToContents();
				_items[ i ].label2:SetPos( _items[ i ]:GetWide() - _items[ i ].label2:GetWide() - 100, _items[ i ]:GetTall() / 2 - _items[ i ].label2:GetTall() / 2 );
				
				
				_items[ i ].buy = vgui.Create( "DButton", _items[ i ] );
				_items[ i ].buy:SetSize( 70, _items[ i ]:GetTall() / 2 );
				_items[ i ].buy:SetText( "Purchase" );
				_items[ i ].label2:SetFont( "wssBig" );
				_items[ i ].buy:SetColor( Shop.Colors.FontBuyButton );
				_items[ i ].buy:SetPos( _items[ i ]:GetWide() - _items[ i ].buy:GetWide() - 10, 
				_items[ i ]:GetTall() / 2 - ( _items[ i ].buy:GetTall() / 2 ) );
				_items[ i ].buy.Paint = function( self, w, h )
					draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BuyButton );
				end

				_items[ i ].buy.OnCursorEntered = function()
					local _a = _items[ i ].buy;
					function _a:Paint( w, h )
						draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BuyButtonHover );
					end;
				end;

				_items[ i ].buy.OnCursorExited = function()
					local _a = _items[ i ].buy;
					function _a:Paint( w, h )
						draw.RoundedBox( Shop.Colors.BtnRound, 0, 0, w, h, Shop.Colors.BuyButton );
					end;
				end;
				
				_items[ i ].buy.DoClick = function()
					net.Start( "Shop::BuyItem" );
						net.WriteFloat( i );
						net.WriteFloat( _data.id );
						net.WriteFloat( _entindex );
					net.SendToServer();
					if( Shop.PlaySounds ) then
						surface.PlaySound( Shop.ButtonSounds );
					end
				end;
			end
		end
	end
	// End items panels \\
	
	
	// Create menu buttons \\

	
	// Created menu buttons \\
	
end

net.Receive( "Shop::UserDerma", function( len )
    local _id = net.ReadFloat();
	local _entindex = net.ReadFloat();
	
    local _shop = nil;

    for i, v in pairs( Shop.__Shops ) do
        if( tonumber( v[ "id" ] ) == ( _id ) ) then
            _shop = i;
            break;
        end
    end

    if( _shop == nil ) then
        Shop:Message( "Received a shop without clientside data!", 0 );
        return;
    end

    if( Shop.Settings.FullInfo ) then
        Shop:Message( "Opening shop.", 1 );
    end
    Shop:ShopDerma( _shop, _entindex );
end );
/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/