local panel = {};
function panel:Init()
	self:SetFont( "WCD::FontFrameTitle" );
	self:SetColor( color_white );
	self:SetText( '' );

	self.clr = color_white;
	self.hover = 0;
end

function panel:SetButtonColor( clr )
	self.clr = table.Copy( clr );
end

function panel:SetNewText( text, scale, addw, addh )
	self.text = text;

	if( scale ) then
		addw = addw or 0;
		addh = addh or 0;

		surface.SetFont( self:GetFont() );
		local tw, th = surface.GetTextSize( text );

		self:SetSize( tw + 6 + addw, th + 6 + addh );
	end
end

function panel:Paint( w, h )
	local action = "SimpleText";
	if( self:IsHovered() || self.alwaysHover ) then
		self.hover = Lerp( WCD.Settings.Lerp, self.hover, 150 );
		action = "SimpleTextOutlined";
	else
		self.hover = Lerp( WCD.Settings.Lerp, self.hover, 0 );
	end

	surface.SetDrawColor( self.clr );
	surface.DrawRect( 0, 0, w, h );

	surface.SetDrawColor( Color( 0, 0, 0, 60 ) );
	surface.DrawRect( 0, h - WCD.Settings.ButtonDepth, w, WCD.Settings.ButtonDepth );

	if( self.icon ) then
		surface.SetDrawColor( color_white );
		surface.SetMaterial( self.icon );
		local x = WCD.Settings.ButtonDepth;
		if( self.iconRight ) then
			x = w - x - 16;
		end

		surface.DrawTexturedRect( x, h / 2 - 8 - WCD.Settings.ButtonDepth / 2, 16, 16 );
	end

	surface.SetDrawColor( Color( 0, 0, 0, self.hover ) );
	surface.DrawRect( 0, 0, w, h );

	if( self.text != "" ) then
		local x = WCD.Settings.ButtonDepth / 2;
		if( self.icon ) then
			if( self.iconRight ) then
				x = WCD.Settings.ButtonDepth;
			else
				x = WCD.Settings.ButtonDepth * 1.5 + 16;
			end
		end

		draw[ action ]( self.text, self:GetFont(), w / 2, h / 2 - WCD.Settings.ButtonDepth / 4,
		color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black );
	end
end
vgui.Register( "WCD::HoverButton", panel, "DButton" );









panel = {};
function panel:Init()
	self:SetText( "" );
	self:SetFont( "WCD::FontMenuButton" );

	local colors = table.Copy( WCD.Colors.menuButton );
	self.color = colors.hover;
	self.default = colors.default;
	self.hover = colors.hover;
end

function panel:SetText( x )
	self.text = x;
end

function panel:SetActive( bool )
	self.active = bool;
end

function panel:IsActive()
	return self.active or false;
end

function panel:Paint( w, h )
	if( self:IsHovered() || self:IsActive() ) then
		self.color = LerpVector( WCD.Settings.Lerp, self.color, self.hover );
	else
		self.color = LerpVector( WCD.Settings.Lerp, self.color, self.default );
	end

	local clr = {
		r = self.color.x,
		g = self.color.y,
		b = self.color.z
	};

	if( self.round ) then
		draw.RoundedBox( self.round, 0, 0, w, h, clr );
	else
		surface.SetDrawColor( clr );
		surface.DrawRect( 0, 0, w, h );
	end

	if( self.icon ) then
		draw.SimpleTextOutlined( self.text or "", self:GetFont(), w / 2, h - 18, color_white, TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER, 1, color_black );

		surface.SetDrawColor( color_white );
		surface.SetMaterial( self.icon );

		if( self.text != "" ) then
			surface.DrawTexturedRect( w / 2 - 32, h / 2 - 32 - 8, 64, 64 );
		else
			surface.DrawTexturedRect( w / 2 - 32, h / 2 - 32, 64, 64 );
		end
	else
		draw.SimpleTextOutlined( self.text or "", self:GetFont(), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER, 1, color_black );
	end

	surface.SetDrawColor( Color( 0, 0, 0, 30 ) );
	surface.DrawRect( 0, h - WCD.Settings.ButtonDepth, w, WCD.Settings.ButtonDepth );


	--surface.DrawRect( w / 2 - 1, 0, 1, h );
end

function panel:SetCoolTip( text, parent )
	self.tooltip = vgui.Create( "WCD::Tooltip", ( parent or WCD.AdminUI ) );
	self.tooltip:SetTrigger( self );
	self.tooltip:SetText( text );
end

vgui.Register( "WCD::MenuButton", panel, "WCD::HoverButton" );




panel = {};
function panel:Init()
	self:SetText( "" );
	self:SetFont( "WCD::FontActionButton" );

	local colors = table.Copy( WCD.Colors.actionButton );
	self.color = colors.default;
	self.default = colors.default;
	self.hover = colors.hover;

	self:SetTall( self:GetParent():GetTall() * 0.66 );
end

function panel:SetDefault( x )
	self.defaultText = x;
	self.text = x;
end

function panel:GetDefault()
	return self.defaultText or "";
end
vgui.Register( "WCD::ActionButton", panel, "WCD::MenuButton" );




panel = {};
function panel:Init()
	self:SetText( "" );
	self:SetSize( 16, 16 );
	self:SetTooltip( WCD.Lang.addFavorite );

	local colors = WCD.Colors.starButton;
	self.color = colors.default;
	self.default = colors.default;
	self.hover = colors.hover;
end

function panel:SetFilled( x )
	self.filled = x;

	if( x ) then
		self:SetTooltip( WCD.Lang.removeFavorite );
	else
		self:SetTooltip( WCD.Lang.addFavorite );
	end
end

function panel:Paint( w, h )
	surface.SetDrawColor( color_white );
	surface.SetMaterial( WCD.Icons.Star );
	surface.DrawTexturedRect( 0, 0, w, h );

	if( !self.filled ) then
		if( self:IsHovered() ) then
			self.color = LerpVector( WCD.Settings.Lerp, self.color, self.hover );
		else
			self.color = LerpVector( WCD.Settings.Lerp, self.color, self.default );
		end

		local clr = {
			r = self.color.x,
			g = self.color.y,
			b = self.color.z
		};

		surface.SetDrawColor( clr );
		surface.DrawTexturedRect( 2, 2, w - 4, h - 4 );
	end
end

vgui.Register( "WCD::Star", panel, "DButton" );


panel = {};
function panel:Init()
	self.star = self:Add( "WCD::Star" );
	self:SetText( "" );

	self.name = self:Add( "DLabel" );
	self.name:SetFont( "WCD::FontVehicleName" );
	self.name:SetText( "" );

	self.price = self:Add( "DLabel" );
	self.price:SetFont( "WCD::FontVehicleName" );
	self.price:SetText( "" );

	local colors = table.Copy( WCD.Colors.menuButton );
	self.color = colors.default;
	self.default = colors.default;
	self.hover = colors.hover;
end

function panel:Setup()
	self.star:SetPos( self:GetWide() - 19, self:GetTall() - self.star:GetTall() - 5 );
end

function panel:SetVehicle( id )
	local data = WCD.List[ id ];
	if( !data ) then LocalPlayer():ChatPrint( "TRIED SETTING UP A CAR THAT ISN'T IN WCD.LIST!" ); return; end

	self.name:SetText( data:GetName() );
	self.name:SizeToContents();
	self.name:SetPos( 5, 5 );
	if( data:GetFree() ) then
		self.price:SetText( WCD.Lang.free );
	else
		self.price:SetText( DarkRP.formatMoney( data:GetPrice() ) );
	end
	self.price:SizeToContents();
	self.price:SetPos( 5, self:GetTall() - self.name:GetTall() - 5 );

	if( WCD.Client.Favorites && WCD.Client.Favorites[ id ] ) then
		self.star:SetFilled( true );
	end

	function self.star:DoClick()
		self:SetFilled( !self.filled );
		WCD.Client.Favorites[ id ] = self.filled;
		WCD.__FavoriteChange = true;
		WCD.__NotYetSorted[ 4 ] = true;
	end
end

function panel:Paint( w, h )
	if( self:IsHovered() || self.star:IsHovered() || self.active ) then
		self.color = LerpVector( WCD.Settings.Lerp, self.color, self.hover );
	else
		self.color = LerpVector( WCD.Settings.Lerp, self.color, self.default );
	end

	local clr = {
		r = self.color.x,
		g = self.color.y,
		b = self.color.z
	};

	surface.SetDrawColor( clr );
	surface.DrawRect( 0, 0, w, h );

	surface.SetDrawColor( Color( 0, 0, 0, 30 ) );
	surface.DrawRect( 0, h - WCD.Settings.ButtonDepth, w, WCD.Settings.ButtonDepth );
end


vgui.Register( "WCD::CarBox", panel, "DButton" );




panel = {};
function panel:Init()
	self.text = "";
	self:SetFont( "WCD::FontVariousButton" );
	self:SetColor( color_white );
	self:SetButtonColor( WCD.Colors.closeButton );
end

vgui.Register( "WCD::VariousButton", panel, "WCD::HoverButton" );

panel = {};
function panel:SetFont( x )
	self.font = x;
end

function panel:GetFont()
	return self.font;
end

function panel:Init()
	self:SetFont( "WCD::FontGenericSmall" );
	self:SetZPos( 100 );
	self:SetVisible( false );
end

function panel:SetTrigger( panel, manual )
	self.trigger = panel;

	if( manual ) then
		self.manual = manual;
	end
end

function panel:SetText( text )
	if( !IsValid( self:GetParent() ) ) then self:Remove(); end

	surface.SetFont( self:GetFont() );
	rows = string.Explode( "\n", text );
	local tW, tH = surface.GetTextSize( text );
	oldTh = 18;

	tH = math.max( oldTh * table.Count( rows ), oldTh );
	tw = 0;



	if( #rows > 1 ) then
		for i, v in pairs( rows ) do
			local otherW, _ = surface.GetTextSize( v );
			if( tW < otherW ) then
				tW = otherW;
			end
		end
	end

	tW = tW + 6;
	tH = tH + 6;
	self:SetSize( tW, tH );
	self.text = text;
	self.rows = rows;
	self.oldTh = oldTh;

	if( !self.manual && self.trigger && IsValid( self.trigger ) ) then
		self.trigger.OnCursorEntered = function()
			self:SetVisible( true );
		end

		self.trigger.OnCursorExited = function()
			self:SetVisible( false );
		end
	end
end

function panel:Paint( w, h )
	if( !self.text ) then return; end
	surface.SetDrawColor( WCD.Colors.tooltipBg );
	surface.DrawRect( 0, 0, w, h );

	surface.SetTextColor( color_white );
	surface.SetFont( "WCD::FontGenericSmall" );
	if( self.rows && table.Count( self.rows ) > 1 ) then
		for i, v in pairs( self.rows ) do
			local m = 1;
			if( i > 1 ) then m = i; end

			surface.SetTextPos( 3, m * self.oldTh - self.oldTh + 3 );
			surface.DrawText( v );
		end
	else
		surface.SetTextPos( 3, 3 );
		surface.DrawText( self.text );
	end
end

function panel:Think()
	if( self:IsVisible() && ( !self.trigger || self.trigger:IsHovered() ) ) then
		local x, y = self:GetParent():LocalCursorPos();
		if( self.manual ) then
			y = y - self.trigger:GetTall() - 18;
			x = x - 10 - self:GetWide() / 2;
		end

		self:SetPos( x + 10, y + 8 );
	end
end

vgui.Register( "WCD::Tooltip", panel, "EditablePanel" );

panel = {};
function panel:Init()
	self:SetFont( "WCD::FontGenericSmall" );
	self:SetColor( color_white );
end

function panel:SetCoolTip( text, parent )
	self:SizeToContents();
	self.tooltip = vgui.Create( "WCD::Tooltip", ( parent or WCD.AdminUI ) );
	self.tooltip:SetTrigger( self );
	self.tooltip:SetText( text );
end

function panel:Paint() end
vgui.Register( "WCD::TooltipLabel", panel, "DButton" );


panel = {};
function panel:Init()
	self.hover = 20;
end

function panel:Paint( w, h )
	if( self:IsHovered() ) then
		self.hover = Lerp( WCD.Settings.Lerp, self.hover, 70 );
	else
		self.hover = Lerp( WCD.Settings.Lerp, self.hover, 20 );
	end

	draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 255, 255, self.hover ) );

	surface.SetDrawColor( Color( 255, 255, 255, 120 ) );
	if( self:GetChecked() ) then
		surface.SetMaterial( WCD.Icons.Tick );
	else
		surface.SetMaterial( WCD.Icons.Cross );
	end
	surface.DrawTexturedRect( w / 2 - 8, h / 2 - 8, 16, 16 );
end
vgui.Register( "WCD::DCheckBox", panel, "DCheckBox" );

panel = {};
function panel:Init()
	self:SetFont( "WCD::FontGenericSmall" );
	self.focus = false;
end

function panel:OnGetFocus()
	self.focus = true;

	if( self.default && self:GetText() == self.default ) then
		self:SetText( "" );
	end
end

function panel:OnLoseFocus()
	self.focus = false;

	if( self.default && self:GetText() == "" ) then
		self:SetText( self.default );
	end
end

function panel:SetDefaultText( text )
	self.default = text;
	self:SetText( text );
end

function panel:SetAllowed( valType, valMin, valMax )
	if( valType == "number" ) then
		function self:IsAllowed()
			local input = tonumber( self:GetText() );

			if( type( input ) != "number" || input < ( valMin or 0 ) || input > ( valMax or 999999999 ) ) then
				self.wrong = true;
			else
				self.wrong = false;
			end
		end
	elseif( valType == "string" ) then
		function self:IsAllowed()
			local input = self:GetText();

			if( string.len( input ) < 1 || string.len( input ) > 120 ) then
				self.wrong = true;
			else
				self.wrong = false;
			end
		end
	end

	self:IsAllowed();
end

function panel:OnChange()
	if( self.IsAllowed ) then
		self:IsAllowed( self:GetText() );
	end
end

function panel:Paint( w, h )
	local show = false;

	if( self.focus || self:IsSelected() || self:IsHovered() ) then
		surface.SetDrawColor( color_white );
		show = true;
	else
		surface.SetDrawColor( Color( 255, 255, 255, 20 ) );
	end
	surface.DrawRect( 0, 0, w, h );

	local clr = Color( 0, 168, 0 );
	if( self.wrong ) then
		show = true;
		clr = Color( 168, 0, 0 );
	end

	if( show ) then
		surface.SetDrawColor( clr );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end
	self:DrawTextEntryText( color_black, color_black, color_black );
end
vgui.Register( "WCD::DTextEntry", panel, "DTextEntry" );


panel = {};
function panel:Init()
	self:SetFont( "WCD::FontGenericSmall" );
	self:SetTextColor( color_black );
	self.focus = false;
end

function panel:OnGetFocus()
	self.focus = true;
end

function panel:OnLoseFocus()
	self.focus = false;
end

function panel:Paint( w, h )
	if( self.focus || self:IsSelected() || self:IsHovered() ) then
		surface.SetDrawColor( color_white );
	else
		surface.SetDrawColor( Color( 255, 255, 255, 20 ) );
	end
	surface.DrawRect( 0, 0, w, h );

	if( self.focus ) then
		surface.SetDrawColor( clr );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	self:DrawTextEntryText( color_black, color_black, color_black );
end
vgui.Register( "WCD::DComboBox", panel, "DComboBox" );
--include( "wcd_dealer_ui.lua" );
--include( "wcd_admin_ui.lua" );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.vgui or "VGUI" ) );
