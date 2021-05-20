/*
* This file shouldn't be modified unless you know what you're doing!
*/

function Shop:AdminDerma()

    // Main frame \\

    local _main = vgui.Create( "DFrame" );
    _main:SetSize( 300, 200 );
    _main:SetTitle( Shop.Settings.AdminWindow );
    _main:SetDraggable( false );
    _main:Center();
    _main:MakePopup();
    _main.Init = function( self )
        self.startTime = SysTime();
    end

    _main.Paint = function( self, w, h )
        Derma_DrawBackgroundBlur( self, self.startTime );
    end;

    // End main frame \\

    // Property sheet \\

    local _sheet = vgui.Create( "DPropertySheet", _main );
    _sheet:Dock( FILL );
    _sheet.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0,    w, h, Shop.Colors.BG );
    end;


    // End property sheet \\

    // Generate property sheet contents \\
    local    _tabsData = {};
    //_tabsData[ 1 ] = { "Categories", "icon16/application_view_tile.png" };
    _tabsData[ 2 ] = { "Actions", "icon16/table_edit.png" };

    local _tabs = {};

    for i, v in pairs( _tabsData ) do
        _tabs[ i ] = vgui.Create( "DPanel", _sheet );
	_tabs[ i ].content = {};
        _tabs[ i ].Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0,    w, h, Shop.Colors.Tabs );
        end;
        _tabs[ i ]:SetSize( _main:GetWide() - 30, _main:GetTall() );

        _sheet:AddSheet( _tabsData[ i ][ 1 ], _tabs[ i ], _tabsData[ i ][ 2 ] );
    end

    for i, v in pairs( _sheet.Items ) do
            if( !v.Tab ) then continue; end
            v.Tab.Paint = function( self, w, h ) end;
    end

    // End property sheet contents \\

    // Categories content \\

    local _a;
    local _y = 10;
    local _x = 10;

    // Delete shop combobox
 
    _tabs[ 2 ].content.dcombobox = vgui.Create( "Shop::DComboBox", _tabs[ 2 ] );
    _a = _tabs[ 2 ].content.dcombobox;
	local _test = _tabs[ 2 ].content.dcombobox;
    _a:SetPos( 10, _y );
    _a:SetSize( 180, 22 );
    _a:SetValue( "Select a shop..." );

    if( type( self.__Shops ) == "table" && #self.__Shops > 0 ) then
        for i, v in pairs( self.__Shops ) do
            _a:AddChoice( v[ "id" ] .. ": " .. v[ "name" ] );
        end
    end

    _a._choice = nil;
    _a.OnSelect = function( _p, _i, _v )
        _a._choice = _v;
    end;

    local _a;
    _tabs[ 2 ].content.btn =    vgui.Create( "Shop::Button1", _tabs[ 2 ] );
    _a = _tabs[ 2 ].content.btn;
    _a:SetText( "Delete" );
    _a:SetPos( 10 + _tabs[ 2 ].content.dcombobox:GetWide() + _x, _y );

        _tabs[ 2 ].content.btn.DoClick = function()
        if( _test._choice != nil ) then
		local _shopid = string.Explode( ":", _test._choice, false );
		_shopid = tonumber( _shopid[ 1 ] );
		net.Start( "Shop::RemoveShop" );
		net.WriteFloat( _shopid );
		net.SendToServer();
		_main:Close();
        end
    end;

    _y =    _y + _a:GetTall() * 2;

    // Line 1
    _tabs[ 2 ].content.line = vgui.Create( "Shop::DPanelLowAlpha", _tabs[ 2 ] );
    _tabs[ 2 ].content.line:SetPos( _x, _y - _a:GetTall() / 2 - ( 2.25 ) );
    _tabs[ 2 ].content.line:SetSize( _tabs[ 2 ]:GetWide() - 20, 5.5 );

    // Respawn all shops button
    _tabs[ 2 ].content = {};
    _tabs[ 2 ].content.btn1 = vgui.Create( "Shop::Button1", _tabs[ 2 ] );
    _a = _tabs[ 2 ].content.btn1;

    _a:SetPos( _x, _y );
    _a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
    _a:SetText( "Respawn all shops" );

    _a.DoClick = function()
        net.Start( "Shop::RespawnAllShops" );
        net.SendToServer();
        _main:Close();
    end;
    _y =    _y + _a:GetTall() * 2;

    // Line 1
    _tabs[ 2 ].content.line = vgui.Create( "Shop::DPanelLowAlpha", _tabs[ 2 ] );
    _tabs[ 2 ].content.line:SetPos( _x, _y - _a:GetTall() / 2 - ( 2.25 ) );
    _tabs[ 2 ].content.line:SetSize( _tabs[ 2 ]:GetWide() - 20, 5.5 );



    _a = nil;
    // Remove all shops button
    _tabs[ 2 ].content.btn2 = vgui.Create( "Shop::Button1", _tabs[ 2 ] );
    _a = _tabs[ 2 ].content.btn2;
    _a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
    _a:SetPos( _x, _y );
    _a:SetText( "Delete all shops" );
    _a.DoClick = function()
        net.Start( "Shop::RemoveAllShops" );
        net.SendToServer();
        _main:Close();
    end;
    _y =    _y + _a:GetTall() * 2;

    // Line 2
    _tabs[ 2 ].content.line = vgui.Create( "Shop::DPanelLowAlpha", _tabs[ 2 ] );
    _tabs[ 2 ].content.line:SetPos( _x, _y - _a:GetTall() / 2 - ( 2.25 ) );
    _tabs[ 2 ].content.line:SetSize( _tabs[ 2 ]:GetWide() - 20, 5.5 );

    // Delete shop DComboBox

    // End other content \\
end

net.Receive( "Shop::AdminDerma", function( len )
    if( Shop.Settings.FullInfo ) then
        Shop:Message( "Opening the Admin Menu.", 1 );
    end
    Shop:AdminDerma();
end );
