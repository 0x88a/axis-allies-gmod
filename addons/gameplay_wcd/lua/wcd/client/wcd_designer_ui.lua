local downGradient = Material( "vgui/gradient_down" );
local upGradient = Material( "vgui/gradient_up" );
local rightGradient = Material( "vgui/gradient-l" );
local leftGradient = Material( "vgui/gradient-r" );

function WCD:OpenDesigner( _e )
	if( self.DesignerUI && IsValid( self.DesignerUI ) ) then
		self.DesignerUI:Remove();
	end

	local lang = self.Lang.designer;
	local veh = _e or LocalPlayer():GetVehicle();
	local id = veh:GetNWFloat( "WCD::Id", 0 );

	if( id == 0 && IsValid( LocalPlayer():GetVehicle() ) && IsValid( LocalPlayer():GetVehicle():GetParent() ) ) then
		id = LocalPlayer():GetVehicle():GetParent():GetNWFloat( "WCD::Id", 0 );
	end

	if( !self:RetrieveAllowedCustomizations( id ) ) then
		self:Notification( lang.cantBeCustomized );
		return;
	end

	local startPos = veh:GetPos();
	local allowed = self:RetrieveAllowedCustomizations( id, LocalPlayer() );
	if( !allowed ) then self:Notification( lang.cantBeCustomized ); return; end

	local c = WCD.Colors;
	local changes = {};
	local data = self.List[ id ];

	self.DesignerUI = vgui.Create( "EditablePanel" );
	local a = self.DesignerUI;
	a.children = {};
	local old = {};
	a.total = 0;
	a.hasBeenPriced = { bodygroups = {} };

	function a:OnRemove()
		for i, v in pairs( self.children or {} ) do
			if( IsValid( v ) ) then
				v:Remove();
			end
		end

		if( IsValid( veh ) && !a.paid ) then
			if( old.skin ) then
				veh:SetSkin( old.skin );
			end

			if( old.color ) then
				veh:SetColor( old.color );
			end

			if( old.underglow ) then
				veh:WCD_SetUnderglow( old.underglow );
			end

			if( old.bodygroups ) then
				for i, v in pairs( old.bodygroups ) do
					veh:SetBodygroup( i, v );
				end
			end
		end

		if( WCD.CursorIsShown ) then
			gui.EnableScreenClicker( false );
		end
	end

	a.nextDistanceThink = CurTime();
	function a:Think()
		if( !IsValid( veh )  || !( IsValid( LocalPlayer():GetVehicle() || LocalPlayer():GetVehicle() != veh ) ) ) then
			a:OnRemove();
			a:Remove();
			return;
		elseif( self.nextDistanceThink <= CurTime() ) then
			if( veh:GetPos():DistToSqr( startPos ) > 35000 ) then
				a:OnRemove();
				a:Remove();
				return;
			end
			self.nextDistanceThink = CurTime() + 1;
		end
	end

	gui.EnableScreenClicker( false );
	WCD.CursorIsShown = false;


	a:SetSize( ScrW(), 60 );
	a:SetPos( 0, ScrH() + 60 );
	a:MoveTo( 0, ScrH() - 60, 0.5, 0, -1, function()
		if( !IsValid( a ) ) then return; end
	end );

	a.children.finish = vgui.Create( "EditablePanel" );
	a.children.finish:SetSize( 310, 60 );
	a.children.finish:SetPos( ScrW() / 2 - a.children.finish:GetWide() / 2,
		ScrH() + 60 );
	a.children.finish:DockPadding( 10, 10, 10, 0 );
	a.children.finish:MoveTo( ScrW() / 2 - a.children.finish:GetWide() / 2, ScrH() - 120, 0.5 );

	function a.children.finish:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );
	end

	a.finish = a.children.finish:Add( "WCD::VariousButton" );
	a.finish:Dock( FILL );
	a.finish:SetNewText( lang.purchase );
	a.finish:SetButtonColor( c.saveButton );

	local sp = LocalPlayer():WCD_GetSpecifics( veh:WCD_GetId() );
	if( sp && type( sp ) == "table" && table.Count( sp ) > 0 ) then

	a.children.resetToDefault = vgui.Create( "EditablePanel" );
	a.children.resetToDefault:SetSize( 310, 60 );
	a.children.resetToDefault:SetPos( ScrW() - a.children.resetToDefault:GetWide() / 2,
		ScrH() + 60 );
	a.children.resetToDefault:DockPadding( 10, 10, 10, 0 );
	a.children.resetToDefault:MoveTo( ScrW() - a.children.resetToDefault:GetWide(), ScrH() - 120, 0.5 );

	function a.children.resetToDefault:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );
	end


		a.resetToDefault = a.children.resetToDefault:Add( "WCD::VariousButton" );
		a.resetToDefault:Dock( FILL );
		a.resetToDefault:SetNewText( lang.reset or "Full Reset" );
		a.resetToDefault:SetButtonColor( c.closeButton );


		a.resetToDefault.DoClick = function()
			if( a.resetToDefault.clicked || ( !WCD.Settings.fullResetCost || WCD.Settings.fullResetCost < 1 ) ) then
				a.resetToDefault.clicked = nil;

				if( !LocalPlayer():canAfford( WCD.Settings.fullResetCost ) ) then
					WCD:Notification( WCD:Translate( lang.cantAfford, DarkRP.formatMoney( WCD.Settings.fullResetCost ) ) );
					return;
				end

				net.Start( "WCD::FullReset" );
				net.SendToServer();

				a:OnRemove();
				a:Remove();
			else
				a.resetToDefault:SetNewText( string.Replace( lang.confirmReset, "[x]", DarkRP.formatMoney( WCD.Settings.fullResetCost ) ) );
				a.resetToDefault.clicked = true;
			end
		end
	end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( upGradient );
		surface.DrawTexturedRect( 0, h - WCD.Settings.ShadowSize, w, WCD.Settings.ShadowSize );
	end
	a:DockPadding( 10, 10, 10, 10 );

	local btnLayout = a:Add( "DIconLayout" );
	btnLayout:Dock( FILL );
	btnLayout:SetSpaceX( 0 );
	local w = ( a:GetWide() - 20 ) / ( table.Count( allowed ) )

	local showBodygroup = false;
	if( veh.GetBodyGroups ) then
		for i, v in pairs( veh:GetBodyGroups() ) do
			if( v.submodels && #v.submodels > 0 ) then
				showBodygroup = true;
				break;
			end
		end
	end

	for i, v in pairs( lang.buttons ) do
		if( !allowed[ v.key ] ) then continue; end
		if( ( v.key == "skin" && ( !veh.GetSkin || veh:SkinCount() == 1 ) )
		|| ( v.key == "color" && !veh.GetColor )
		|| ( v.key == "bodygroups" && !showBodygroup )
		|| ( v.key == "underglow" && !veh.WCD_SetUnderglow )
		|| ( v.key == "nitro" && !veh.WCD_SetNitro ) ) then continue; end

		local btn = btnLayout:Add( "WCD::MenuButton" );
		btn:SetSize( w, 50 );
		btn:SetText( v.name );

		a.children[ v.key ] = vgui.Create( "DFrame" );
		a.children[ v.key ]:SetVisible( false );
		a.children[ v.key ]:SetTitle( "" );
		a.children[ v.key ]:ShowCloseButton( false );

		if( v.windowTitle ) then
			a.children[ v.key ].title = v.windowTitle;
		else
			a.children[ v.key ].title = v.name;
		end

		function btn:DoClick()
			local c = a.children[ v.key ];

			if( c ) then
				local x, y = self:GetPos();

				if( c:IsVisible() ) then
					c:MoveTo( x + self:GetWide() / 2 - c:GetWide() / 2,
						ScrH(), 0.3, 0, -1, function() c:SetVisible( false ); end );

					return;
				end

				c:SetPos( x + self:GetWide() / 2 - c:GetWide() / 2,
					ScrH() - self:GetTall() );
				x, y = c:GetPos();

				c:MoveTo( x, 0, 0.3 );

				c:SetVisible( true );
			end
		end
	end

	local paintFunc = function( self, w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( self.title, "WCD::FontGenericSmall", 3, 3,
			color_white, 0, 0, 1, color_black );


		surface.SetDrawColor( c.line );
		surface.DrawRect( 0, 22, w, 1 );

		if( self.none ) then return; end
		local m = lang.price;
		if( self.multi ) then m = lang.pricePerChange; end

		draw.SimpleTextOutlined( WCD:Translate( m, self.price ), "WCD::FontGenericSmall", w - 3, 3,
			color_white, TEXT_ALIGN_RIGHT, 0, 1, color_black );
	end

	local skin = a.children[ "skin" ];
	if( skin && veh.GetSkin ) then
		old.skin = veh:GetSkin();

		skin:SetSize( 300, 60 );
		skin.Paint = paintFunc;
		skin.price = DarkRP.formatMoney( data:GetSkinCost() );
		skin.currentSkin = veh:GetSkin() or 0;
		skin.maxSkins = veh:SkinCount() or 0;
		function skin:GetValues()
			return ( skin.currentSkin != old.skin && skin.currentSkin );
		end

		skin.left = skin:Add( "WCD::VariousButton" );
		skin.left:SetNewText( "<<", true, 10, - 5 );
		skin.left:SetPos( 3, skin:GetTall() - skin.left:GetTall() - 3 );
		skin.left:SetButtonColor( c.mainColor );

		skin.right = skin:Add( "WCD::VariousButton" );
		skin.right:SetNewText( ">>" );
		skin.right:SetSize( skin.left:GetSize() );
		skin.right:SetButtonColor( c.mainColor );
		skin.right:SetPos( skin:GetWide() - skin.right:GetWide() - 3,
			skin:GetTall() - skin.left:GetTall() - 3 );

		skin.skin = skin:Add( "DLabel" );
		skin.skin:SetText( WCD:Translate( lang.skinCounter, skin.currentSkin, skin.maxSkins ) );
		skin.skin:SetFont( "WCD::FontGenericSmall" );
		skin.skin:SizeToContents();
		skin.skin:SetPos( skin:GetWide() / 2 - skin.skin:GetWide() / 2,
			skin:GetTall() / 2 + skin.skin:GetTall() / 2 - 5 );

		if( skin.currentSkin == 1 ) then
			skin.left:SetVisible( false );
		elseif( skin.currentSkin == skin.maxSkins ) then
			skin.right:SetVisible( false );
		end

		function skin:update()
				veh:SetSkin( skin.currentSkin );
				skin.skin:SetText( WCD:Translate( lang.skinCounter, skin.currentSkin, skin.maxSkins ) );
				skin.skin:SizeToContents();
				skin.skin:SetPos( skin:GetWide() / 2 - skin.skin:GetWide() / 2,
					skin:GetTall() / 2 + skin.skin:GetTall() / 2 - 5 );


				if( skin.right:IsVisible() && skin.currentSkin >= skin.maxSkins ) then
					skin.right:SetVisible( false );
				elseif( !skin.right:IsVisible() && skin.currentSkin < skin.maxSkins ) then
					skin.right:SetVisible( true );
				end
				if( skin.currentSkin == 0 ) then
					skin.left:SetVisible( false );
				elseif( !skin.left:IsVisible() && skin.currentSkin > 0 ) then
					skin.left:SetVisible( true );
				end

			if( skin.currentSkin == old.skin ) then
				if( a.hasBeenPriced[ "skin" ] ) then
					a.total = a.total - data:GetSkinCost();

					a.hasBeenPriced[ "skin" ] = nil;
				end
			else
				if( !a.hasBeenPriced[ "skin" ] ) then
					a.total = a.total + data:GetSkinCost();
					a.hasBeenPriced[ "skin" ] = true;
				end
			end

		end

		function skin.left:DoClick()
			skin.currentSkin = skin.currentSkin - 1;
			skin:update();
		end

		function skin.right:DoClick()
			skin.currentSkin = skin.currentSkin + 1;
			skin:update();
		end
	end

 	local color = a.children[ "color" ];
	if( color && veh.SetColor ) then
		old.color = veh:GetColor();
		color.edited = false;

		color:SetSize( 300, 250 );
		color.Paint = paintFunc;
		color.price = DarkRP.formatMoney( data:GetColorCost() );
		color:DockMargin( 5, 5, 40, 5 );
		function color:GetValues()
			if( !self.edited ) then return; end

			local a = veh:GetColor();
			return ( a.r != old.color.r || a.b != old.color.b || a.c != old.color.c ) and a or nil;
		end

		color.reset = color:Add( "WCD::VariousButton" );
		color.reset:SetFont( "WCD::FontGenericSmall" );
		color.reset:SetNewText( "Reset" );
		color.reset:SetButtonColor( c.mainColor );
		color.reset:Dock( BOTTOM );
		color.reset:DockMargin( 0, 5, 0, 0 );
		function color.reset:DoClick()
			if( a.hasBeenPriced[ "color" ] ) then
				color.picker:SetColor( old.color );
				color.edited = false;
				a.total = a.total - data:GetColorCost();
				a.hasBeenPriced[ "color" ] = nil;
				veh:SetColor( old.color );
			end
		end
		color.picker = color:Add( "DColorMixer" );
		color.picker:Dock( FILL );
		color.picker:SetPalette( true );
		color.picker:SetAlphaBar( false );
		color.picker:SetWangs( false );
		color.picker:SetColor( veh:GetColor() );

		color.picker.nextSound = CurTime();
		function color.picker:ValueChanged( x )
			veh:SetColor( x );
			if( !a.hasBeenPriced[ "color" ] ) then
				a.hasBeenPriced[ "color" ] = true;
				a.total = a.total + data:GetColorCost();
				color.edited = true;
			end

			if( self.nextSound < CurTime() ) then
				surface.PlaySound( "wcd/spray.wav" );
				self.nextSound = CurTime() + 0.95;
			end
		end
	end

 	local bg = a.children[ "bodygroups" ];
	if( bg && veh.GetBodyGroups ) then
		old.bodygroups = {};

		for i, v in pairs( veh:GetBodyGroups() ) do
			old.bodygroups[ v.id ] = veh:GetBodygroup( v.id );
		end
		local edits = {};

		bg:SetSize( 300, 250 );
		bg.Paint = paintFunc;
		bg.multi = true;
		bg.price = DarkRP.formatMoney( data:GetBodygroupCost() );
		bg:DockMargin( 5, 5, 40, 5 );
		function bg:GetValues()
			return ( table.Count( edits ) > 0 && edits );
		end


		bg.scroll = bg:Add( "DScrollPanel" );
		bg.scroll:Dock( FILL );
		bg.scroll:GetVBar():SetVisible( false );

		bg.layout = bg.scroll:Add( "DIconLayout" );
		bg.layout:Dock( FILL );

		for i, v in pairs( veh:GetBodyGroups() ) do
			if( !v.submodels || table.Count( v.submodels ) < 2 ) then continue; end

			local q = bg.layout:Add( "EditablePanel" );
			q:SetSize( bg:GetWide() - 10, 30 );
			q.Paint = WCD.ListPaint;

			q.label = q:Add( "DLabel" );
			q.label:SetColor( color_white );
			q.label:SetText( v.name:sub( 1, 1 ):upper() .. v.name:sub( 2 ) );
			q.label:SetFont( "WCD::FontGenericSmall" );
			q.label:SetPos( 1, q:GetTall() - q.label:GetTall() - 3 );
			q.label:SizeToContents();

			if( table.Count( v.submodels ) == 2 ) then
				q.choice = q:Add( "WCD::DCheckBox" );
				q.choice:SetSize( 24, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );

				q.choice:SetChecked( veh:GetBodygroup( v.id ) or false );

				local current = veh:GetBodygroup( v.id );
				function q.choice:OnChange()
					local current = veh:GetBodygroup( v.id );

					if( a.hasBeenPriced[ "bodygroups" ][ v.id ] ) then
						a.total = a.total - data:GetBodygroupCost();
						a.hasBeenPriced[ "bodygroups" ][ v.id ] = nil;
					else
						a.hasBeenPriced[ "bodygroups" ][ v.id ] = true;
						a.total = a.total + data:GetBodygroupCost();
					end

					if( current == 0 ) then
						veh:SetBodygroup( v.id, 1 );
						edits[ v.id ] = 1;
					else
						veh:SetBodygroup( v.id, 0 );
						edits[ v.id ] = nil;
					end

					surface.PlaySound( "wcd/drill.wav" );
				end
			else
				q.choice = q:Add( "WCD::DComboBox" );
				q.choice:SetSize( 150, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );

				local choiceRef = {};
				local reverseRef = {};
				for i, v in pairs( v.submodels ) do
					if( v == "" ) then v = "Off"; end
					v = string.Replace( v, ".smd", "" );

					reverseRef[ i ] = v;
					choiceRef[ v ] = i;
					q.choice:AddChoice( v );
				end
				q.choice.default = veh:GetBodygroup( v.id );
				q.choice:SetText( reverseRef[ q.choice.default ] or "Off" );

				function q.choice:OnSelect( choice )
					veh:SetBodygroup( v.id, choiceRef[ q.choice:GetText() ] );
					surface.PlaySound( "wcd/drill.wav" );

					edits[ v.id ] = choiceRef[ q.choice:GetText() ];

					if( !a.hasBeenPriced[ "bodygroups" ][ v.id ] ) then
						a.hasBeenPriced[ "bodygroups" ][ v.id ] = true;
						a.total = a.total + data:GetBodygroupCost();
					elseif( choiceRef[ q.choice:GetText() ] == self.default ) then
						a.total = a.total - data:GetBodygroupCost();
						a.hasBeenPriced[ "bodygroups" ][ v.id ] = nil;
					end
				end
			end
		end
	end

 	local underglow = a.children[ "underglow" ];
	if( underglow && veh.WCD_GetUnderglow ) then
		old.underglow = veh:WCD_GetUnderglow();

		underglow:SetSize( 300, 250 );
		underglow.Paint = paintFunc;
		underglow.price = DarkRP.formatMoney( data:GetUnderglowCost() );
		underglow:DockMargin( 5, 5, 40, 5 );

		underglow.reset = underglow:Add( "WCD::VariousButton" );
		underglow.reset:SetFont( "WCD::FontGenericSmall" );
		underglow.reset:SetNewText( "Reset" );
		underglow.reset:SetButtonColor( c.mainColor );
		underglow.reset:Dock( BOTTOM );
		underglow.reset:DockMargin( 0, 5, 0, 0 );

		function underglow.reset:DoClick()
			if( a.hasBeenPriced[ "underglow" ] ) then
				a.total = a.total - data:GetUnderglowCost();
				a.hasBeenPriced[ "underglow" ] = false;
				veh.__DesignUnderglow = nil;
			end
		end

		function underglow:GetValues()
			if( !self.changed ) then return false; end

			local a =  veh.__DesignUnderglow;
			local b = ( old.underglow or veh:WCD_GetUnderglow() );

			if( type( b ) == "boolean" ) then return a; end
			return( a.r != b.r || a.g != b.g || a.b != b.b ) or nil;
		end

		underglow.picker = underglow:Add( "DColorMixer" );
		underglow.picker:Dock( FILL );
		underglow.picker:SetPalette( true );
		underglow.picker:SetAlphaBar( false );
		underglow.picker:SetWangs( false );
		--underglow.picker:SetColor( ( veh:WCD_GetUnderglow() ) or color_white );

		underglow.picker.nextSound = CurTime();
		function underglow:Think()
			veh:WCD_ProcessUnderglow( underglow.picker:GetColor() );
		end

		function underglow.picker:ValueChanged( x )
			if( !a.hasBeenPriced[ "underglow" ] ) then
				a.hasBeenPriced[ "underglow" ] = true;
				a.total = a.total + data:GetUnderglowCost();
			end

			veh:WCD_SetUnderglow( x );
			veh.__DesignUnderglow = x;
			underglow.changed = true;
		end
	end

 	local nitro = a.children[ "nitro" ];
	if( nitro && veh.WCD_GetNitro ) then
		old.nitro = LocalPlayer():WCD_GetSpecifics( veh:WCD_GetId() ).nitro or veh:WCD_GetNitro() or 0;
		veh.__DesignNitro = old.nitro;

		nitro:SetSize( 300, 125 );
		nitro.Paint = paintFunc;
		nitro.none = true;
		nitro:DockMargin( 5, 5, 40, 5 );

		function nitro:GetValues()
			return  ( veh.__DesignNitro != old.nitro ) and veh.__DesignNitro;
		end

		nitro.scroll = nitro:Add( "DScrollPanel" );
		nitro.scroll:Dock( FILL );
		nitro.scroll:GetVBar():SetVisible( false );

		nitro.layout = nitro.scroll:Add( "DIconLayout" );
		nitro.layout:Dock( FILL );

		local prices = {
			data:GetNitroOneCost(),
			data:GetNitroTwoCost(),
			data:GetNitroThreeCost()
		};

		local buttons = {};
		local currentNitroBtn;
		for i = 1, 3 do
			local q = nitro.layout:Add( "EditablePanel" );
			q:SetSize( nitro:GetWide() - 10, 30 );
			q.Paint = WCD.ListPaint;

			q.label = q:Add( "DLabel" );
			q.label:SetColor( color_white );
			q.label:SetText( WCD:Translate( lang.nitroLevel, i ) );
			q.label:SetFont( "WCD::FontGenericSmall" );
			q.label:SetPos( 1, q:GetTall() - q.label:GetTall() - 3 );
			q.label:SizeToContents();

			q.button = q:Add( "WCD::VariousButton" );
			q.button:SetFont( "WCD::FontGenericSmaller" );
			q.button:SetNewText( DarkRP.formatMoney( prices[ i ] or 0 ) );
			q.button:SetSize( q:GetWide() / 2, 28 );
			q.button:SetButtonColor( c.mainColor );
			q.button:SetPos( q:GetWide() - q.button:GetWide() - 1, 1 );
			buttons[ i ] = q.button;

			function q.button:DoClick()
				if( self.active ) then
					self:SetButtonColor( c.mainColor );
					veh.__DesignNitro = old.nitro;
				end

				if( a.hasBeenPriced[ "nitro" ] && veh.__DesignNitro ) then
					veh.__DesignNitro = nil;
					a.total = a.total - a.hasBeenPriced[ "nitro" ];
					a.hasBeenPriced[ "nitro" ] = nil;
				end

				if( self.active ) then
					self.active = false;
					return;
				end

				for i, v in pairs( buttons ) do
					v:SetButtonColor( c.mainColor );
					v.active = false;

					if( i == old.nitro && !veh.__DesignNitro ) then
						v:DoClick();
					else
						v:SetNewText( DarkRP.formatMoney( prices[ i ] or 0 ) );
					end
				end
				veh.__DesignNitro = i;

				a.hasBeenPriced[ "nitro" ] = prices[ i ];
				a.total = a.total + prices[ i ];
				self:SetButtonColor( c.saveButton );
				self.active = true;

				surface.PlaySound( "wcd/drill.wav" );
			end

			if( i == old.nitro ) then
				q.button:SetNewText( lang.uninstall );
				q.button:SetButtonColor( c.closeButton );

				currentNitroBtn = q.button;

				function q.button:DoClick()
					for i, v in pairs( buttons ) do
						v.active = false;
					end

					if( a.hasBeenPriced[ "nitro" ] ) then
						a.total = a.total - a.hasBeenPriced[ "nitro" ];
						a.hasBeenPriced[ "nitro" ] = nil;
					end

					if( veh.__DesignNitro == 0 ) then
						self:SetNewText( lang.uninstall );
						self:SetButtonColor( c.closeButton );
						veh.__DesignNitro = old.nitro;

						for i, v in pairs( buttons ) do
							if( v != self ) then
								v:SetButtonColor( c.mainColor );
							end
						end
					else
						if( veh.__DesignNitro && veh.__DesignNitro != 0 ) then
							buttons[ veh.__DesignNitro ].active = false;
							buttons[ veh.__DesignNitro ]:SetColor( c.mainColor );
						end

						veh.__DesignNitro = 0;

						self:SetNewText( DarkRP.formatMoney( 0 ) );
						self:SetButtonColor( c.mainColor );
					end
				end
			end
		end
	end

	function a.finish:DoClick()
		local changes = {};

		for i, v in pairs( a.children ) do
			if( i == "finish" || i =="resetToDefault" || type( v:GetValues() ) == "nil" || !v:GetValues() ) then continue; end

			changes[ i ] = v:GetValues();
		end

		local price, newData = WCD:CalculateCustomization( LocalPlayer(), veh, changes );
		if( !LocalPlayer():canAfford( price ) ) then
			WCD:Notification( WCD:Translate( lang.cantAfford, DarkRP.formatMoney( price ) ) );
			return;
		end

		a.paid = true;

		net.Start( "WCD::BuyDesign" );
		net.WriteTable( changes );
		net.SendToServer();

		for i, v in pairs( a.children ) do
			if( !IsValid( v ) ) then continue; end

			local x, y = v:GetPos();
			v:MoveTo( x, y + ScrH(), 0.25, 0, -1, function() v:Remove(); end );
		end
		a:MoveTo( 0, ScrH(), 0.3, 0, -1, function() a:Remove(); end );

		if( WCD.CursorIsShown ) then
			gui.EnableScreenClicker( false );
		end
	end
end
net.Receive( "WCD::SpawnAndCustomize", function()
	LocalPlayer():WCD_SetSpecifics( net.ReadFloat(), net.ReadTable() );
	local _e = net.ReadFloat();

	timer.Simple( 0.5, function()
		WCD:OpenDesigner( Entity( _e ) );
	end );
end );

hook.Add( "HUDPaint", "WCD::CursorStatus", function()

	if( IsValid( WCD.DesignerUI ) ) then
		draw.SimpleTextOutlined( WCD.Lang.designer.spaceToToggleMouse, "WCD::FontDealer", ScrW() / 2, ScrH() - 150, color_white,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );

		draw.SimpleTextOutlined( WCD:Translate( WCD.Lang.designer.totalPrice, DarkRP.formatMoney( WCD.DesignerUI.total ) ), "WCD::FontDealer", ScrW() / 2, ScrH() - 250, color_white,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );

		draw.SimpleTextOutlined( WCD:Translate( WCD.Lang.dealerVarious.wallet, DarkRP.formatMoney( LocalPlayer():getDarkRPVar( "money" ) ) ), "WCD::FontDealer", ScrW() / 2, ScrH() - 280, color_white,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );

		if( WCD.DesignerUI.children[ "underglow" ]
			&& WCD.DesignerUI.children[ "underglow" ]:IsVisible() ) then
		draw.SimpleTextOutlined( WCD.Lang.designer.underglow, "WCD::FontDealer", ScrW() / 2, ScrH() - 190, color_white,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );
		end
	end

end );

local last = CurTime();
hook.Add( "KeyPress", "WCD::ToggleCursor", function( _p, key )
	if( key == IN_JUMP && IsValid( WCD.DesignerUI ) && last < CurTime() ) then
		WCD.CursorIsShown = !WCD.CursorIsShown;
		gui.EnableScreenClicker( WCD.CursorIsShown );
		WCD.DesignerUI:SetZPos( 32767 );
		WCD.DesignerUI:MoveToFront();
		
		last = CurTime() + 0.3;
	end
end );

--WCD:OpenDesigner();
WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.designer or "designer" ) );