WCD.DealerUI = WCD.DealerUI or nil;
local c = WCD.Colors;

local downGradient = Material( "vgui/gradient_down" );
local upGradient = Material( "vgui/gradient_up" );
local rightGradient = Material( "vgui/gradient-l" );
local leftGradient = Material( "vgui/gradient-r" );

function WCD:OpenDealer( dealer )
	if( IsValid( self.DealerUI ) ) then
		self.DealerUI:Remove();
	end
	
	-- if( !self.ClientSideSettingsFound ) then
		-- WCD:OpenClientSettings( function() WCD:OpenDealer( dealer ); end );
		-- self.ClientSideSettingsFound = true;
		-- return;
	-- end

	if( !IsValid( dealer ) || dealer:GetNWFloat( "WCD::Group", -1 ) == -1 ) then return; end
	data = data or {};
	data.dealerName = dealer:GetNWString( "WCD::Name", "No Name" ) or "Unknown Dealer";
	data.accessGroup = dealer:GetNWFloat( "WCD::Group", 1 ) or 1;

	local m = ( self.Client.Settings.Fullscreen and 1 ) or 0.85;
	local w, h = ScrW() * m, ScrH() * m;
	local frame = vgui.Create( "EditablePanel" );

	local percentageSides = 0.13;
	local percentageTopBottom = 0.11;

	local bottomW = w - ( w * percentageSides ) * 2;

	self.DealerUI = frame;
	frame:SetSize( w, h );
	frame:Center();
	frame:MakePopup();
	function frame:Think()
		if( input.IsKeyDown( KEY_ESCAPE ) ) then
			if( WCD.__FavoriteChange ) then
				WCD:SaveFavorites();
				WCD.__FavoriteChange = false;
			end

			frame:Remove();
		end
	end

	frame.active = 1;
	frame.car = nil;

	function frame:Paint( w, h )
		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w , h );
	end

	frame.left = frame:Add( "EditablePanel" );
	frame.left:Dock( LEFT );
	frame.left:SetWide( w * percentageSides );

	frame.right = frame:Add( "EditablePanel" );
	frame.right:Dock( RIGHT );
	frame.right:SetWide( frame.left:GetWide() );

	frame.top = frame:Add( "EditablePanel" );
	frame.top:Dock( TOP );
	frame.top:SetTall( h * percentageTopBottom );

	frame.bottom = frame:Add( "EditablePanel" );
	frame.bottom:SetTall( frame.top:GetTall() );
	frame.bottom:Dock( BOTTOM );

	frame.middleBack = frame:Add( "EditablePanel" );
	frame.middleBack:Dock( FILL );

	frame.middle = frame.middleBack:Add( "EditablePanel" );
	frame.middle:Dock( FILL );

	if( self.Client.Settings.MoveableModel ) then
		frame.middle.model = frame.middle:Add( "DAdjustableModelPanel" );
	else
		frame.middle.model = frame.middle:Add( "DModelPanel" );
	end

	if( !WCD.Client.Settings.SpinModel ) then
		function frame.middle.model:LayoutEntity() end
	end

	frame.middle.model:Dock( FILL );


	/* BASE CONTAINERS CREATED */

	function frame.right:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );
	end

	function frame.top:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( rightGradient );
		surface.DrawTexturedRect( 0, 0, WCD.Settings.ShadowSize, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( leftGradient );
		surface.DrawTexturedRect( w - WCD.Settings.ShadowSize, 0, WCD.Settings.ShadowSize, h );

		-- draw.SimpleTextOutlined( dealer:GetNWString( "WCD::Name", "No Name" ), "WCD::FontFrameTitle", w / 2, h / 2 - 36,
		-- color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );

		-- draw.SimpleTextOutlined( WCD.DealerGroups[ data.accessGroup ] or "", "WCD::FontFrameSubTitle", w / 2, h / 2 + 15,
		-- color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	end

	function frame.bottom:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( rightGradient );
		surface.DrawTexturedRect( 0, 0, WCD.Settings.ShadowSize, h );

		surface.SetMaterial( leftGradient );
		surface.DrawTexturedRect( w - WCD.Settings.ShadowSize, 0, WCD.Settings.ShadowSize, h );
	end


	function frame.middleBack:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( downGradient );
		surface.DrawTexturedRect( 0, 0, w, WCD.Settings.ShadowSize );

		surface.SetMaterial( upGradient );
		surface.DrawTexturedRect( 0, h - WCD.Settings.ShadowSize, w, WCD.Settings.ShadowSize );

		surface.SetMaterial( rightGradient );
		surface.DrawTexturedRect( 0, 0, WCD.Settings.ShadowSize, h );

		surface.SetMaterial( leftGradient );
		surface.DrawTexturedRect( w - WCD.Settings.ShadowSize, 0, WCD.Settings.ShadowSize, h );

		-- if( self.text ) then
			-- draw.SimpleTextOutlined( self.text, "WCD::FontGenericSmall", 13, 13,
				-- color_white, 0, 0, 1, color_black );
		-- end

		-- if( self.text2 ) then
			-- draw.SimpleTextOutlined( self.text2, "WCD::FontGenericSmall", 13, ( self.text and 26 ) or 13,
				-- color_white, 0, 0, 1, color_black );
		-- end

		-- draw.SimpleTextOutlined( WCD:Translate( WCD.Lang.dealerVarious.wallet, DarkRP.formatMoney( LocalPlayer():getDarkRPVar( "money" ) ) ), "WCD::FontGenericSmall", 13, h - 14 - 13,
			-- color_white, 0, 0, 1, color_black );
	end

	function frame.left:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );
	end

	/* CONTAINERS DONE */


	/* LEFT CONTAINER CHILDREN */
	frame.left.top = frame.left:Add( "EditablePanel" );
	frame.left.top:Dock( TOP );
	frame.left.top:SetTall( frame.top:GetTall() );
	frame.left.top.returnVehicles = frame.left.top:Add( "WCD::VariousButton" );
	frame.left.top.returnVehicles:SetSize( frame.left:GetWide(), 30 );
	frame.left.top.returnVehicles:Dock( TOP );
	frame.left.top.returnVehicles:SetFont( "WCD::FontGenericSmall" );
	frame.left.top.returnVehicles:SetNewText( WCD.Lang.returnVehicles );
	frame.left.top.returnVehicles:SetButtonColor( Color(28, 28, 27, 120) );
	function frame.left.top.returnVehicles:DoClick()
		net.Start( "WCD::Return" );
		net.SendToServer();
	end


	frame.left.middle = frame.left:Add( "DIconLayout" );
	frame.left.middle:Dock( TOP );
	frame.left.middle:SetTall( h - frame.top:GetTall() * 2 );
	local menuButtonH = frame.left.middle:GetTall() / #WCD.Lang.dealerButtonsLeft;

	frame.left.bottom = frame.left:Add( "EditablePanel" );
	frame.left.bottom:Dock( FILL );

	/* END LEFT CONTAINER CHILDREN */

	/* RIGHT CONTAINER CHILDREN */
	frame.right.top = frame.right:Add( "EditablePanel" );
	frame.right.top:Dock( TOP );
	frame.right.top:SetTall( frame.top:GetTall() );

	frame.right.middle = frame.right:Add( "EditablePanel" );
	frame.right.middle:Dock( TOP );
	frame.right.middle:SetTall( h - frame.top:GetTall() * 2 );

	frame.right.bottom = frame.right:Add( "EditablePanel" );
	frame.right.bottom:Dock( FILL );

	local menuButtons = {};
	frame.lists = {};
	frame.scrolls = {};
	frame.middles = {};

	local chosenList = 1;
	local chosenCar = 1;
	local boxes = {};
	local count = 1;

	local showPage = dealer:GetNWBool( "WCD::disableShop", false ) && 2;
	if( WCD.Client.Settings.DefaultDealerTab && WCD.Client.Settings.DefaultDealerTab != 1 ) then
		showPage = WCD.Client.Settings.DefaultDealerTab;
	end
	for i, v in pairs( WCD.Lang.dealerButtonsLeft ) do
		local btn = frame.left.middle:Add( "WCD::MenuButton" );
		btn:SetSize( frame.left:GetWide(), menuButtonH );
		btn:SetText( v );
		btn.icon = WCD.Icons.DealerButtons[ i  ];

		if( i == 1 ) then
			btn:SetVisible( false );
		end

		if( i == 3 ) then
			btn:SetVisible( false );
		end
		
		if( i == 4 ) then
			btn:SetVisible( false );
		end		

		frame.middles[ count ] = frame.right.middle:Add( "EditablePanel" );
		frame.middles[ count ]:Dock( TOP );
		frame.middles[ count ]:SetTall( h - frame.top:GetTall() * 2 );
		boxes[ count ] = {};

		btn.list = frame.lists[ count ];
		btn.middle = frame.middles[ count ];

		table.insert( menuButtons, btn );
		function btn:DoClick()
			chosenList = i;
			chosenCar = 1;

			if( boxes && boxes[ chosenList ] && boxes[ chosenList ][ 1 ] && boxes[ chosenList ][ 1 ].DoClick ) then
				boxes[ chosenList ][ 1 ]:DoClick();
			else
				if( frame.SelectedCar ) then
					frame:SelectedCar();
				end
			end

			for i, v in pairs( menuButtons ) do
				v:SetActive( false );
				v.middle:SetVisible( false );
			end

			self:SetActive( true );
			self.middle:SetVisible( true );
		end

		if( count == showPage ) then
			btn:DoClick();
		end

		count = count + 1;
	end

	/* END RIGHT CONTAINER CHILDREN */


	/* START BOTTOM CONTAINER CHILDREN */
	frame.bottom.mainAction = frame.bottom:Add( "WCD::ActionButton" );
	frame.bottom.mainAction:SetDefault( WCD.Lang.dealerActionButtons.buy );
	frame.bottom.mainAction:SetSize( 300, 40 );
	frame.bottom.mainAction:SetPos( bottomW / 2 - frame.bottom.mainAction:GetWide() / 2,
		frame.bottom:GetTall() / 2 - frame.bottom.mainAction:GetTall() );

	frame.bottom.subAction = frame.bottom:Add( "WCD::ActionButton" );
	frame.bottom.subAction:SetFont( "WCD::FontGenericSmall" );
	frame.bottom.subAction:SetSize( frame.bottom.mainAction:GetWide() * 0.7, 30 );
	frame.bottom.subAction:SetPos( bottomW / 2 - frame.bottom.subAction:GetWide() / 2,
		frame.bottom:GetTall() / 2 + 10 );

	frame.bottom.customize = frame.bottom:Add( "WCD::MenuButton" );
	frame.bottom.customize:SetFont( "WCD::FontGenericSmall" );
	frame.bottom.customize:SetSize( 64, 64 );
	frame.bottom.customize.icon = WCD.Icons.DealerButtons[ 5 ];
	frame.bottom.customize.round = 32;
	frame.bottom.customize:SetCoolTip( WCD.Lang.dealerVarious.customize, frame.bottom );
	frame.bottom.customize:SetPos( 5,
		frame.bottom:GetTall() / 2 - frame.bottom.customize:GetTall() / 2 );
	frame.bottom.customize:SetVisible( false );

	function frame.bottom.customize:DoClick()
		if( !self.id ) then return; end

		net.Start( "WCD::SpawnAndCustomize" );
		net.WriteFloat( self.id );
		net.SendToServer();

		frame.right.top.close:DoClick();
	end

	function frame.bottom:Build( id )
		frame.bottom.customize:SetVisible( false );
		frame.middleBack.text2 = nil;

		if( !id || !LocalPlayer():WCD_HasAccess( id ) ) then
			frame.bottom.mainAction:SetVisible( false );
			frame.bottom.subAction:SetVisible( false );
			frame.middleBack.text = nil;

			if( id && !LocalPlayer():WCD_HasAccess( id ) ) then
				frame.middleBack.text2 = "No Access: " .. ( ( WCD.List[ id ] && WCD.List[ id ]:GetAccess() ) or "" );
			end
			return;
		end

		-- if( WCD.Settings.spawnCost && WCD.Settings.spawnCost > 0 ) then
			-- frame.middleBack.text2 = "Price to spawn: " .. DarkRP.formatMoney( WCD.Settings.spawnCost );
		-- end
		-- if( WCD.List[ id ].spawnCost && WCD.List[ id ].spawnCost > 0 ) then
			-- frame.middleBack.text2 = "Price to spawn: " .. DarkRP.formatMoney( WCD.List[ id ].spawnCost );
		-- end

		frame.bottom.mainAction:SetVisible( true );
		frame.bottom.subAction:SetVisible( true );
		frame.bottom.customize.id = id;
		if( WCD:RetrieveAllowedCustomizations( id ) ) then
			if( LocalPlayer():WCD_Owns( id ) && LocalPlayer():WCD_HasAccess( id ) && !dealer:GetNWBool( "WCD::disableCustomization", false ) ) then
				frame.middleBack.text = nil;
				frame.bottom.customize:SetVisible( true );
			else
				frame.middleBack.text = WCD.Lang.dealerVarious.canBeCustomized;
			end
		else
			frame.middleBack.text = WCD.Lang.dealerVarious.canNotBeCustomized;
		end

		if( !LocalPlayer():WCD_Owns( id ) ) then
			frame.bottom.mainAction:SetDefault( WCD.Lang.dealerActionButtons.buy );
			frame.bottom.subAction:SetDefault( WCD.Lang.dealerActionButtons.test );
			if( !WCD.Settings.testDriving ) then frame.bottom.subAction:SetVisible( false ); end

			function frame.bottom.mainAction:DoClick()
				if( self.text == self:GetDefault() ) then
					self.text = WCD.Lang.dealerActionButtons.sure;
					return;
				end

				self.text = self:GetDefault();
				if( !LocalPlayer():canAfford( WCD.List[ id ]:GetPrice() ) ) then
					--WCD:Notification( WCD.Lang.dealerActionButtons.noAfford );
					return;
				end

				net.Start( "WCD::BuyVehicle" );
				net.WriteFloat( id );
				net.SendToServer();
			end

			function frame.bottom.subAction:DoClick()
				net.Start( "WCD::Spawn" );
				net.WriteFloat( id );
				net.WriteBool( true );
				net.SendToServer();

				frame.right.top.close:DoClick();
			end
		else
			frame.bottom.mainAction:SetDefault( WCD.Lang.dealerActionButtons.spawn );
			frame.bottom.subAction:SetDefault( WCD:Translate( WCD.Lang.dealerActionButtons.sell, WCD.Settings.percentage .. "%" ) );

			-- if( WCD.List[ id ]:GetPrice() == 0 || WCD.List[ id ]:GetFree() ) then
				-- frame.bottom.subAction:SetVisible( false );
			-- end

			function frame.bottom.mainAction:DoClick()
				net.Start( "WCD::Spawn" );
				net.WriteFloat( id );
				net.WriteBool( false );
				net.SendToServer();

				frame.right.top.close:DoClick();
			end

			function frame.bottom.subAction:DoClick()
				if( self.text == self:GetDefault() ) then
					self.text = WCD.Lang.dealerActionButtons.sure;
					return;
				end

				self:SetText( self:GetDefault() );

				net.Start( "WCD::SellVehicle" );
				net.WriteFloat( id );
				net.SendToServer();
			end
		end
	end
	/* END BOTTOM CONTAINER CHILDREN */


	-- frame.right.top.settings = frame.right.top:Add( "WCD::VariousButton" );
	-- frame.right.top.settings:SetSize( frame.right:GetWide() - 26, 30 );
	-- frame.right.top.settings:SetPos( 0, 0 );
	-- frame.right.top.settings.text = WCD.Lang.clientSettings;
	-- frame.right.top.settings:SetButtonColor( WCD.Colors.configureButton );
	-- frame.right.top.settings.icon = WCD.Icons.Wrench;
	-- function frame.right.top.settings:DoClick()
		-- frame:Remove();
		-- WCD:OpenClientSettings( function() WCD:OpenDealer( dealer ); end );
	-- end

	frame.right.top.close = frame.right.top:Add( "WCD::VariousButton" );
	frame.right.top.close:SetSize( 210, 30 );
	frame.right.top.close.text = "Close";

	frame.right.top.close:SetPos( frame.right:GetWide() - frame.right.top.close:GetWide() );
	function frame.right.top.close:DoClick()
		if( WCD.__FavoriteChange ) then
			WCD:SaveFavorites();
			WCD.__FavoriteChange = false;
		end

		frame:Remove();
	end


	/* START INPUT CONTENT */
	// ADD CARS TO RIGHT SIDE MENU

	function frame:SelectedCar( id )
		if( !id ) then
			frame.middle:SetVisible( false );
			frame.bottom:Build();
			return;
		end
		frame.middle:SetVisible( true );

		local data = WCD.List[ id ];
		local ref = WCD.VehicleData[ data:GetClass() ];
		--if( !data || !ref ) then WCD:Notification( "BUG: No Vehicle Data!" ); return; end
		--if( !ref.Model && !data.overrideModel ) then WCD:Notification( "BUG: No model for " .. id .. "!" );  return; end

		if( data.overrideModel == "models/error.mdl" ) then data.overrideModel = ref.Model; end

		frame.middle.model:SetModel( data.overrideModel or ref.Model );

		local mn, mx = frame.middle.model.Entity:GetRenderBounds();
		local size = 0;
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) );
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) );
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) );

		frame.middle.model:SetFOV( 45 );
		frame.middle.model:SetCamPos( Vector( size, size, size * 0.5 ) );
		frame.middle.model:SetLookAt( ( mn + mx ) * 0.5 );
		frame.middle.model:SetPos( Vector( 0, 0, 300 ) );

		if( frame.middle.model.CaptureMouse ) then
			local mouseX, mouseY = input.GetCursorPos();
			local x, y = frame.middle.model:GetPos();
			x = x + frame.middle.model:GetWide() / 2;
			y = y + frame.middle.model:GetTall() / 2;

			frame.middle.model:OnMousePressed( MOUSE_FIRST );
			timer.Simple( 0.25, function()
				frame.middle.model:OnMouseReleased( MOUSE_FIRST );
			end );
		end

		local specifics = LocalPlayer():WCD_GetSpecifics( id );
		specifics = specifics or {};
		local m = frame.middle.model;

		if( m.SetColor ) then
			m:SetColor( specifics.color or data:GetColor() or color_white );
		end

		if( m.Entity.SetSkin ) then
			m.Entity:SetSkin( specifics.skin or data:GetSkin() or 0 );
		end

		if( m.Entity.SetBodygroup ) then
			for i, v in pairs( specifics.bodygroups or data:GetBodygroups() or {} ) do
				m.Entity:SetBodygroup( i, v );
			end
		end

		if( WCD.VehicleData && WCD.VehicleData[ data:GetClass() ] && WCD.VehicleData[ data:GetClass() ].HasPhoton ) then
			local ph = WCD.VehicleData[ data:GetClass() ];

			if( ph.EMV ) then
				if( ph.EMV.Color ) then
					m.Entity:SetColor( ph.EMV.Color );
				end

				if( ph.EMV.Skin ) then
					m.Entity:SetSkin( ph.EMV.Skin );
				end
			end
		end


		frame.bottom:Build( id );
	end

	local boxHeight = 54;
	function frame:RebuildList( id )

		if( IsValid( frame.lists[ id ] ) ) then
			frame.lists[ id ]:Remove();
		end

		if( IsValid( frame.scrolls[ id ] ) ) then
			frame.scrolls[ id ]:Remove();
		end

		if( boxes[ id ] ) then
			for i, v in pairs( boxes ) do
				if( IsValid( v ) ) then
					v:Remove();
				end

				boxes[ id ][ i ] = nil;
			end
		end

		frame.scrolls[ id ] = frame.middles[ id ]:Add( "DScrollPanel" );
		frame.scrolls[ id ]:Dock( FILL );
		frame.scrolls[ id ]:GetVBar():SetWide( 0 );

		frame.lists[ id ] = frame.scrolls[ id ]:Add( "DIconLayout" );
		frame.lists[ id ]:Dock( FILL );

		if( clean ) then
			WCD.__Change = true;
			chosenCar = 1;
		end

		local tbl = WCD:GetSortedDealerTable( id, data.accessGroup or 1 );
		if( id == chosenList && table.Count( tbl ) < 1 ) then
			frame:SelectedCar();
		end

		for i2, v2 in pairs( tbl ) do
			if( dealer:GetNWBool( "WCD::disableShop", false )
				&& !LocalPlayer():WCD_Owns( v2 ) ) then
				continue;
			end

			local box = frame.lists[ id ]:Add( "WCD::CarBox" );
			box:SetSize( frame.right:GetWide(), boxHeight );
			box:Setup();
			box:SetVehicle( v2 );
			table.insert( boxes[ id ], box );

			function box:DoClick()
				chosenList = id;
				chosenCar = i2;
				frame:SelectedCar( v2 );
				for i, v in pairs( boxes[ chosenList ] ) do
					if( IsValid( v ) ) then
						v.active = false;
					end
				end

				self.active = true;
			end

			if( id == chosenList && i2 == chosenCar ) then box:DoClick(); end
		end
	end

	for i = 1, 4 do
		frame:RebuildList( i );
	end

	/* END INPUT CONTENT */
end

net.Receive( "WCD::OpenDealer", function()
	WCD:OpenDealer( Entity( net.ReadFloat() ) );
end );

timer.Simple( 0, function()
	--WCD:OpenDealer(LocalPlayer():GetEyeTrace().Entity);
end );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.dealerui or "dealer UI" ) );