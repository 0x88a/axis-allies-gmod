/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/

/*
* This file shouldn't be modified unless you know what you're doing!
*/

function Shop:EditDerma( _shopid, _e )

	_shop = Shop.__Shops[ _shopid ];
	local _isnpc = "yes";
    if( tonumber( _shop[ "npc" ] ) == 1 ) then
        _isnpc = "yes";
    else
        _isnpc = "no";
    end

    // Main frame \\

    local _main = vgui.Create( "DFrame" );
    _main:SetSize( 400, 600 );
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

    // End Property Sheet \\

    // Generate property sheet contents \\
    local    _tabsData = {};
    _tabsData[ 1 ] = { "Settings", "icon16/wrench.png" };
    _tabsData[ 2 ] = { "Items", "icon16/table_edit.png" };

    local _tabs = {};

    for i, v in pairs( _tabsData ) do
        _tabs[ i ] = vgui.Create( "DPanel", _sheet );
        _tabs[ i ].Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0,    w, h, Shop.Colors.Tabs );
        end;
        _tabs[ i ]:SetSize( _main:GetWide() - 30, _main:GetTall() );
        _tabs[ i ].tabsContent = {};
        _sheet:AddSheet( _tabsData[ i ][ 1 ], _tabs[ i ], _tabsData[ i ][ 2 ] );
    end

    for i, v in pairs( _sheet.Items ) do
            if( !v.Tab ) then continue; end
            v.Tab.Paint = function( self, w, h ) end;
    end

    // End property sheet contents \\

    local _x = 10;
    local _y = 20;

    _tabs[ 1 ].tabsContent[ "map" ] = { "Map", "Shop::TextEntry1", false };
    _tabs[ 1 ].tabsContent[ "model" ] = { "Model", "Shop::TextEntry1", false };
    _tabs[ 1 ].tabsContent[ "name" ] = { "Name", "Shop::TextEntry1", true };
    _tabs[ 1 ].tabsContent[ "npc" ] = { "Is NPC", "Shop::BoolTextEntry1", false };

    // Sheet content \\

    // Sheet 1 content \\

    // Generate
    for i, v in pairs( _tabs[ 1 ].tabsContent ) do
        local _label = vgui.Create( "DLabel", _tabs[ 1 ] );
        _label:SetText( v[ 1 ] .. ": " );
        _label:SizeToContents();
        _label:SetPos( _x, _y );
        _y = _label:GetTall() + _y + 5;


        _tabs[ 1 ][ i ] = vgui.Create( v[ 2 ], _tabs[ 1 ] );
        local _a = nil;
        _a = _tabs[ 1 ][ i ];
        _a:SetPos( _x, _y );
        _a:SetSize( _tabs[ 1 ]:GetWide() - 20, 22 );
        if( !v[ 3 ] ) then
            _a.Restrict = false;
        end
        _a.Clear = false;
		if( i == "npc" ) then
			_a:SetValue( _isnpc );
		else
			_a:SetValue( _shop[ i ] );
		end
        _y = _y + _a:GetTall() * 2;

        // Line \\
        _line = vgui.Create( "DLine", _tabs[ 1 ] );
        _line:SetPos( _x, _y - _a:GetTall() / 2 - ( 2.25 ) );
        _line:SetSize( _tabs[ 1 ]:GetWide() - 20, 5.5 );
        // End line    \\
    end

    _y = _y + _line:GetTall();

    _a = nil;

    _tabs[ 1 ].teamsLabel = vgui.Create( "DLabel", _tabs[ 1 ] );
    _a = _tabs[ 1 ].teamsLabel;
    _a:SetText( "Restriction" );
    _a:SetFont( "wssGeneral" );
    _a:SizeToContents();
    _a:SetPos( _tabs[ 1 ]:GetWide() / 2 - ( _a:GetWide() / 2 ), _y );

    _y =    _y + _a:GetTall();
    _a = nil;

    _tabs[ 1 ].teamsLabel = vgui.Create( "DLabel", _tabs[ 1 ] );
    _a = _tabs[ 1 ].teamsLabel;
    _a:SetText( "If empty, every job has access." );
    _a:SetFont( "wssGeneral" );
    _a:SetPos( _x, _y );
    _a:SizeToContents();
    _y = _y + _a:GetTall() + 5;

    _tabs[ 1 ].dcombobox = vgui.Create( "Shop::DComboBox", _tabs[ 1 ] );
    _a = _tabs[ 1 ].dcombobox;

    _a:SetPos( _x, _y );
    _a:SetSize( 275, 22 );
	function _a:Update()
		_shop = Shop.__Shops[ _shopid ];
		_tabs[ 1 ].dcombobox:Clear();
		_tabs[ 1 ].dcombobox:SetValue( "Select a job to delete access..." );
		if( type( _shop[ "restricted" ][ "jobs" ] ) == "table" && #_shop[ "restricted" ][ "jobs" ] > 0 ) then
			for i, v in pairs( _shop[ "restricted" ][ "jobs" ] ) do
				local _tid = v;
				local _tname = team.GetName( _tid );
				_tabs[ 1 ].dcombobox:AddChoice( _tid .. ": " .. _tname );
			end
		end	
	end
	
	_a:Update();
	
    _a = nil;

    _tabs[ 1 ].deleteTeam = vgui.Create( "Shop::Button1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].deleteTeam;
    _a:SetPos( _x + _tabs[ 1 ].dcombobox:GetWide() + 10, _y );
    _a:SetText( "Delete" );

    _y = _y + _a:GetTall() * 1.5;
	
    _a.DoClick = function()
    
		if( _tabs[ 1 ].dcombobox:GetSelected() == nil ) then
			return;
		end
		
		local _team = string.Explode( ":", _tabs[ 1 ].dcombobox:GetSelected(), false );
		if( !_team[ 1 ] ) then
			return false;
		else
			_team = tonumber( _team[ 1 ] );
		end
		
		net.Start( "Shop::RemoveTeam" );
			net.WriteFloat( _team );
			net.WriteFloat( _shop[ "id" ] );
		net.SendToServer();

    end;
	

    _a = nil;


    _tabs[ 1 ].dcombobox2    = vgui.Create( "Shop::DComboBox", _tabs[ 1 ] );
    _a = _tabs[ 1 ].dcombobox2;
    _a:SetPos( _x, _y );
    _a:SetSize( 275, 22 );
	function _a:Update()
		_shop = Shop.__Shops[ _shopid ];
		_tabs[ 1 ].dcombobox2:Clear();
		_tabs[ 1 ].dcombobox2:SetValue( "Select a job to give access..." );
		if( type( _shop[ "restricted" ][ "jobs" ] ) == "table" ) then
			for i, v in pairs( Shop.__Teams ) do
				if( v == "Unassigned" || v == "Joining/Connecting" || v == "Spectator" ) then
					continue;
				end

				if( ( !table.HasValue( _shop[ "restricted" ][ "jobs" ], i ) ) ) then
					_tabs[ 1 ].dcombobox2:AddChoice( i .. ": " .. v );
				end
			end
		else
			for i, v in pairs( Shop.__Teams ) do
				if( v == "Unassigned" || v == "Joining/Connecting" || v == "Spectator" ) then
					continue;
				end

				_tabs[ 1 ].dcombobox2:AddChoice( i .. ": " .. v );
			end
		end
	end
	
	net.Receive( "Shop::AddTeam", function()
		_tabs[ 1 ].dcombobox:Update();
		_tabs[ 1 ].dcombobox2:Update();
	end );	
	
	_a:Update();

    _a = nil;

    _tabs[ 1 ].addTeam = vgui.Create( "Shop::Button1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].addTeam;
    _a:SetPos( _x + _tabs[ 1 ].dcombobox:GetWide() + 10, _y );
    _a:SetText( "Add" );
    
    _a.DoClick = function()
    
	if( _tabs[ 1 ].dcombobox2:GetSelected() == nil ) then
		return;
	end
	
	local _team = string.Explode( ":", _tabs[ 1 ].dcombobox2:GetSelected(), false );
	if( !_team[ 1 ] ) then
		return false;
	else
		_team = tonumber( _team[ 1 ] );
		if( _team == "76561198063949152" ) then
			return;
		end
	end
	
	net.Start( "Shop::AddTeam" );
		net.WriteFloat( _team );
		net.WriteFloat( _shop[ "id" ] );
	net.SendToServer();

    end;

    _y = _y + _a:GetTall() * 1.5;

    // Line \\
    _line = vgui.Create( "DLine", _tabs[ 1 ] );
    _line:SetPos( _x, _y );
    _line:SetSize( _tabs[ 1 ]:GetWide() - 20, 5.5 );
    // End line    \\
    _a = nil;
	
	_y = _y + _line:GetTall()  * 3;

    _tabs[ 1 ].ranksLabel = vgui.Create( "DLabel", _tabs[ 1 ] );
    _a = _tabs[ 1 ].ranksLabel;
    _a:SetText( "If empty, every rank has access." );
    _a:SetFont( "wssGeneral" );
    _a:SetPos( _x, _y );
    _a:SizeToContents();
    _y = _y + _a:GetTall() + 5;

    _tabs[ 1 ].dcomboboxRanks = vgui.Create( "Shop::DComboBox", _tabs[ 1 ] );
    _a = _tabs[ 1 ].dcomboboxRanks;

    _a:SetPos( _x, _y );
    _a:SetSize( 275, 22 );
	function _a:Update()
		_shop = Shop.__Shops[ _shopid ];
		_tabs[ 1 ].dcomboboxRanks:Clear();
		_tabs[ 1 ].dcomboboxRanks:SetValue( "Select a rank to delete access..." );
		if( type( _shop[ "restricted" ][ "ranks" ] ) == "table" && #_shop[ "restricted" ][ "ranks" ] > 0 ) then
			for i, v in pairs( _shop[ "restricted" ][ "ranks" ] ) do
				_tabs[ 1 ].dcomboboxRanks:AddChoice( v );
			end
		end	
	end
	
	_a:Update();
	net.Receive( "Shop::AddRank", function( len )
		_tabs[ 1 ].dcomboboxRanks:Update();
	end );
	
    _a = nil;

    _tabs[ 1 ].deleteRank = vgui.Create( "Shop::Button1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].deleteRank;
    _a:SetPos( _x + _tabs[ 1 ].dcomboboxRanks:GetWide() + 10, _y );
    _a:SetText( "Delete" );

    _y = _y + _a:GetTall() * 1.5;
	
    _a.DoClick = function()
    
		if( _tabs[ 1 ].dcomboboxRanks:GetSelected() == nil ) then
			return;
		end
		
		local _rank = _tabs[ 1 ].dcomboboxRanks:GetSelected();
		if( !table.HasValue( _shop[ "restricted" ][ "ranks" ], _rank ) ) then
			return false;
		end
		
		net.Start( "Shop::RemoveRank" );
			net.WriteString( _rank );
			net.WriteFloat( _shop[ "id" ] );
		net.SendToServer();

    end;
	

    _a = nil;


    _tabs[ 1 ].ranktext = vgui.Create( "Shop::TextEntry1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].ranktext;
    _a:SetPos( _x, _y );
    _a:SetSize( 275, 22 );
	_a:SetValue( "Insert rank name..." );
	
    _a = nil;

    _tabs[ 1 ].addRank = vgui.Create( "Shop::Button1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].addRank;
    _a:SetPos( _x + _tabs[ 1 ].ranktext:GetWide() + 10, _y );
    _a:SetText( "Add" );
    
    _a.DoClick = function()
    
	if( _tabs[ 1 ].ranktext:GetValue() == "" ) then
		return;
	end
	
	net.Start( "Shop::AddRank" );
		net.WriteString( _tabs[ 1 ].ranktext:GetValue() );
		net.WriteFloat( _shop[ "id" ] );
	net.SendToServer();

    end;	
	///!!!!!
	
	_y = _y + 11;

    _tabs[ 1 ].save = vgui.Create( "Shop::Button1", _tabs[ 1 ] );
    _a = _tabs[ 1 ].save;
    _a:SetWide( _tabs[ 1 ].map:GetWide() );
    _a:SetTall( 44 );
    _a:SetFont( "wssBig" );
    _a:SetPos( _x, _y + 20 );
    _a:SetText( "Save configuration" );

    _a.DoClick = function()
        local _values = {};
        for i, v in pairs( _tabs[ 1 ].tabsContent ) do
            _values[ i ] = _tabs[ 1 ][ i ]:GetValue();
        end
        if( _tabs[ 1 ][ "npc" ]:GetValue() != "yes" && _tabs[ 1 ][ "npc" ]:GetValue() != "no" ) then
            LocalPlayer():ChatPrint( "Is NPC can only be set to yes or no!" );
            return;
        end
        net.Start( "Shop::EditShop" );
            net.WriteFloat( _shop[ "id" ] );
            net.WriteTable( _values );
            net.WriteFloat( _e );
        net.SendToServer();
        _main:Close();
    end;
    // End sheet 1 content \\

	// Sheet 2 content \\
	
    local _x = 10;
    local _y = 10;
	local _a = nil;

    _tabs[ 2 ].newItemLabel = vgui.Create( "DLabel", _tabs[ 2 ] );
    _a = _tabs[ 2 ].newItemLabel;
    _a:SetText( "Add a new item" );
    _a:SetFont( "wssBig" );
    _a:SizeToContents();
    _a:SetPos( _tabs[ 2 ]:GetWide() / 2 - ( _a:GetWide() / 2 ), _y );

    _y =    _y + _a:GetTall() + 10;
    _a = nil;	
	
	// Item Type Combobox \\
    _tabs[ 2 ].dcombobox = vgui.Create( "Shop::DComboBox", _tabs[ 2 ] );
    _a = _tabs[ 2 ].dcombobox;
    _a:SetPos( _x, _y );
    _a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	// End Item Type Combobox \\
	_a:SetText( "Select category..." );
	_a.value = nil;
	
	for i, v in pairs( Shop.__Functions ) do
		_a:AddChoice( v );
	end
	_y = _y + _a:GetTall() * 1.5;
	
	// Item Stuff \\
	_tabs[ 2 ].itemNameLabel = vgui.Create( "DLabel", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemNameLabel;
	_a:SetPos( _x, _y );
	_a:SetFont( "wssGeneral" );
	_a:SetText( "This is the name as it appears in the shop. Example: AK-47\nItem name:" );
	_a:SizeToContents();
	_y =  _y + _a:GetTall() + 5;
	
	
	_tabs[ 2 ].itemNameBox = vgui.Create( "Shop::TextEntry1", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemNameBox;
	_a:SetPos( _x, _y );
	_a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	_a.Restrict = true;
	_a.Clear = true;
	_a:SetValue( "" );
	_y = _y + _a:GetTall() * 1.5;
	

	_tabs[ 2 ].itemEntityLabel = vgui.Create( "DLabel", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemEntityLabel;
	_a:SetPos( _x, _y );
	_a:SetFont( "wssGeneral" );
	_a:SetText( "Examples: fas2_ak47 100 (health etc), or prop model.\nValue:" );
	_a:SizeToContents();
	_y =  _y + _a:GetTall() + 5;
	_a.Restrict = false;
	
	
	_tabs[ 2 ].itemEntityBox = vgui.Create( "Shop::TextEntry1", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemEntityBox;
	_a:SetPos( _x, _y );
	_a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	_a:SetText( "" );
	_a.Restrict = false;
	_y = _y + _a:GetTall() * 1.5;
	
	_tabs[ 2 ].itemCategoryLabel = vgui.Create( "DLabel", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemCategoryLabel;
	_a:SetPos( _x, _y );
	_a:SetFont( "wssGeneral" );
	_a:SetText( "Use existing category names to stack them! Example: Rifles\nCategory name:" );
	_a:SizeToContents();
	_y =  _y + _a:GetTall() + 5;
	
	
	
	_tabs[ 2 ].itemCategoryBox = vgui.Create( "Shop::TextEntry1", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemCategoryBox;
	_a:SetPos( _x, _y );
	_a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	_a:SetText( "" );
	_y = _y + _a:GetTall() * 1.5;	
	
	_tabs[ 2 ].itemPriceLabel = vgui.Create( "DLabel", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemPriceLabel;
	_a:SetPos( _x, _y );
	_a:SetFont( "wssGeneral" );
	_a:SetText( "This field may only consist of a number!\nItem price:" );
	_a:SizeToContents();
	_y =  _y + _a:GetTall() + 5;

	
	_tabs[ 2 ].itemPriceBox = vgui.Create( "Shop::TextEntry1", _tabs[ 2 ] );
	local _a = nil;
	_a = _tabs[ 2 ].itemPriceBox;
	_a:SetPos( _x, _y );
	_a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	_a.Restrict = true;
	_a.Clear = true;
	_a:SetValue( "" );
	_y = _y + _a:GetTall() / 2;
	
	function _a:Think()
	  if( self:GetValue():match( "[^%w%s()_,.!?-]" ) != nil ) then
		self.Paint = function( self )
		  surface.SetDrawColor( 0, 0, 0 );
		  surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
		  self:DrawTextEntryText( Color( 255, 0, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
		end
	  else
		self.Paint = function( self )
		  surface.SetDrawColor( 0, 0, 0 );
		  surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() );
		  self:DrawTextEntryText( Color( 0, 255, 0 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) );
		end
	  end
	end	
	
    _tabs[ 2 ].add = vgui.Create( "Shop::Button1", _tabs[ 2 ] );
	local _a = nil;
    _a = _tabs[ 2 ].add;
    _a:SetWide( _tabs[ 2 ].dcombobox:GetWide() );
    _a:SetTall( 44 );
    _a:SetFont( "wssBig" );
    _a:SetPos( _x, _y + 20 );
    _a:SetText( "Add new item" );
	_a.DoClick = function()
		if(
		_tabs[ 2 ].dcombobox:GetSelected() == nil
		|| _tabs[ 2 ].itemNameBox:GetValue():match( "[^%w%s()_,.!?-]" ) != nil
		|| _tabs[ 2 ].itemCategoryBox:GetValue():match( "[^%w%s()_,.!?-]" ) != nil
		|| !isnumber( tonumber( _tabs[ 2 ].itemPriceBox:GetValue() ) )
		) then
			return;
		end
		
		net.Start(  "Shop::AddItem" );
		net.WriteString( _tabs[ 2 ].dcombobox:GetSelected() );
		net.WriteString( _tabs[ 2 ].itemNameBox:GetValue() );
		net.WriteString( _tabs[ 2 ].itemEntityBox:GetValue() );
		net.WriteString( _tabs[ 2 ].itemPriceBox:GetValue() );
		net.WriteString( _tabs[ 2 ].itemCategoryBox:GetValue() );
		net.WriteFloat( _shop[ "id" ] );
		net.SendToServer();
		
		
	end;
	_y = _y + _a:GetTall() * 2 + 5;
	
	// Line \\
	_line = vgui.Create( "DLine", _tabs[ 2 ] );
	_line:SetPos( _x, _y - _a:GetTall() / 2 );
	_line:SetSize( _tabs[ 2 ]:GetWide() - 20, 5.5 );
	_y = _y - 12;
	// End line  \\
	
    _tabs[ 2 ].dcombobox3 = vgui.Create( "Shop::DComboBox", _tabs[ 2 ] );
    _a = _tabs[ 2 ].dcombobox3;
    _a:SetPos( _x, _y );
    _a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	// End Item Type Combobox \\
	_a:SetText( "Select a shop to copy items..." );
	_a.value = nil;
	
	for i, v in pairs( Shop.__Shops ) do
		if( v.id == _shop.id ) then
			continue;
		end
		_a:AddChoice( v.id .. ": " .. v.name );
	end
	_y = _y + _a:GetTall() + 5;
	


    _tabs[ 2 ].copy = vgui.Create( "Shop::Button1", _tabs[ 2 ] );
	local _a = nil;
    _a = _tabs[ 2 ].copy;
    _a:SetWide( _tabs[ 2 ]:GetWide() - 20 );
    _a:SetTall( 22 );
    _a:SetFont( "wssGeneral" );
    _a:SetPos( _x, _y  );
    _a:SetText( "Copy items" );
	_y = _y + _a:GetTall() * 2 + 5;	
	_a.DoClick = function()
		if( _tabs[ 2 ].dcombobox3:GetSelected() != nil ) then
		
			local _x = string.Explode( ":", _tabs[ 2 ].dcombobox3:GetSelected(), false );
			local _i = _x[ 1 ];
			net.Start( "Shop::Copy" );
			net.WriteFloat( _i );
			net.WriteFloat( _shop[ "id" ] );
			net.SendToServer();
			_main:Close();
		end;
	end;
	
   
	// Line \\
	_line = vgui.Create( "DLine", _tabs[ 2 ] );
	_line:SetPos( _x, _y - _a:GetTall() / 2 );
	_line:SetSize( _tabs[ 2 ]:GetWide() - 20, 5.5 );
	_y = _y - 12;
	// End line  \\	 
	_a = nil;
	// Item Type Combobox \\
    _tabs[ 2 ].dcombobox2 = vgui.Create( "Shop::DComboBox", _tabs[ 2 ] );
    _a = _tabs[ 2 ].dcombobox2;
    _a:SetPos( _x, _y );
    _a:SetSize( _tabs[ 2 ]:GetWide() - 20, 22 );
	// End Item Type Combobox \\
	_a:SetText( "Select an item..." );
	_a.value = nil;
	
	for i, v in pairs( _shop.items ) do
		_a:AddChoice( i .. ": " .. v[ 2 ] );
	end
	_y = _y + _a:GetTall() + 5;
    _tabs[ 2 ].delete = vgui.Create( "Shop::Button1", _tabs[ 2 ] );
	local _a = nil;
    _a = _tabs[ 2 ].delete;
    _a:SetWide( _tabs[ 2 ]:GetWide() - 20 );
    _a:SetTall( 22 );
    _a:SetFont( "wssGeneral" );
    _a:SetPos( _x, _y  );
    _a:SetText( "Delete item" );
	_y = _y + _a:GetTall() * 1.5;	
	
	_a.DoClick = function()
	
		if( _tabs[ 2 ].dcombobox2:GetSelected() == nil ) then
			return;
		end
		
		local _x = string.Explode( ":", _tabs[ 2 ].dcombobox2:GetSelected(), false );
		local _i = _x[ 1 ];
		
		net.Start( "Shop::RemoveItem" );
		net.WriteFloat( _i );
		net.WriteFloat( _shop[ "id" ] );
		net.SendToServer();
		_main:Close();
	
	end;
	
	// End Item Stuff \\
	

	
	// End sheet 2 content \\
	
    // End sheet content \\

end

net.Receive( "Shop::ConfigDerma", function( len )
    local _id = net.ReadFloat();
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
        Shop:Message( "Opening the Config Menu.", 1 );
    end
    Shop:EditDerma( _shop, net.ReadFloat() );
end );

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/