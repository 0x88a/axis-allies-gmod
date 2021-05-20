WCD.Client 							= WCD.Client or {};
WCD.Client.Settings 				= WCD.Client.Settings or {};
WCD.Client.Settings.MoveableModel	= false;
WCD.Client.Settings.SpinModel		= false;
WCD.Client.Settings.CacheOnReceive	= false;
WCD.Client.Settings.Language		= "English";
WCD.Client.Settings.DefaultDealerTab= 1;
WCD.Client.Settings.SortAsc			= false;

WCD.Client.Favorites				= {};
WCD.Client.Frame					= WCD.Client.Frame or nil;

function WCD:SaveFavorites()
	file.Write( "wcd/favorites/" .. self.Settings.serverString .. ".txt", util.TableToJSON( self.Client.Favorites ) );
end

function WCD:SaveClientSettings()
	file.Write( "wcd/settings.txt", util.TableToJSON( self.Client.Settings ) );
	self:LoadLang( self.Client.Settings.Language );
	self.__Change = true;
end

function WCD:LoadClientSettings()
	if( !file.Exists( "wcd", "DATA" ) ) then
		file.CreateDir( "wcd" );
	end

	if( !file.Exists( "wcd/favorites/", "DATA" ) ) then
		file.CreateDir( "wcd/favorites/" );
	end

	if( file.Exists( "wcd/settings.txt", "DATA" ) ) then
		self.Client.Settings = util.JSONToTable( file.Read( "wcd/settings.txt", "DATA" ) );
		self.ClientSideSettingsFound = true;
	else
		self.ClientSideSettingsFound = false;
	end

	self:LoadLang( self.Client.Settings.Language, true );
	if( file.Exists( "wcd/favorites/" .. self.Settings.serverString .. ".txt", "DATA" ) ) then
		self.Client.Favorites = util.JSONToTable( file.Read( "wcd/favorites/" .. self.Settings.serverString .. ".txt", "data" ) );
	end
end

function WCD:OpenClientSettings( func )
	if( self.Client.Frame && IsValid( self.Client.Frame ) ) then
		self.Client.Frame:Remove();
	end
	local c = self.Colors;

	if( !WCD.Languages[ self.Client.Settings.Language ] ) then
		self.Client.Settings.Language = "english";
	end

	self.Client.Frame = vgui.Create( "EditablePanel" );
	local a = self.Client.Frame;
	a:SetSize( 600, 400 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 35, 5, 5 );
	if( parent && IsValid( parent ) ) then
		a:SetParent( parent );
	end

	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetSize( 26, 30 );
	a.close.text = "x";

	a.close:SetPos( a:GetWide() - a.close:GetWide() );
	function a.close:DoClick()
		a:Remove();
	end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Clientside Settings", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	local lang = WCD.Lang.clientSettingsPanel;
	a.desc = a:Add( "DLabel" );
	a.desc:SetFont( "ChatFont" );
	a.desc:SetText( lang.desc );
	a.desc:SetMultiline( true );
	a.desc:SizeToContents();
	a.desc:Dock( TOP );
	a.desc:DockMargin( 0, 0, 0, 15 );

	a.scroll = a:Add( "DScrollPanel" );
	a.scroll:Dock( FILL );
	a.scroll:GetVBar():SetWide( 0 );

	local w = a:GetWide() - 10;
	a.items = a.scroll:Add( "DIconLayout" );
	a.items:Dock( FILL );

	for i, v in pairs( lang.data ) do
		local q = a.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		q.Paint = WCD.ListPaint;

		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( v.name or "Unknown" );
		q.label:SetCoolTip( v.tooltip, a );
		q.label:SetTall( 30 );
		q.label:SizeToContents();
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() - 3 );

		if( v.type == "bool" ) then
			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetChecked( WCD.Client.Settings[ v.key ] or false );

			function q.choice:OnChange()
				WCD.Client.Settings[ v.key ] = self:GetChecked();
			end
		elseif( v.type == "combobox" ) then
			q.choice = q:Add( "WCD::DComboBox" );
			q.choice:SetSize( 92, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );

			local choices = {};
			if( type( v.values ) == "table" ) then
				choices = v.values;
			elseif( v.global ) then
				choices = WCD.Lang[ v.values ];
			else
				choices = ( WCD[ v.values ] );
			end

			local ref = WCD.Client.Settings;

			if( type( WCD.Client.Settings[ v.key ] ) == "number" ) then
				q.choice.default = choices[ WCD.Client.Settings[ v.key ] ];
				q.choice:SetText( choices[ WCD.Client.Settings[ v.key ] ] );
			else

				q.choice.default = choices[ string.lower( WCD.Client.Settings[ v.key ] or "Unknown" ) ];
				q.choice:SetText( choices[ string.lower( WCD.Client.Settings[ v.key ] or "Unknown" ) ] );
			end

			local choiceKeys = {};
			for i, v in pairs( choices or {} ) do
				choiceKeys[ v ] = i;
				q.choice:AddChoice( v );
			end

			function q.choice:OnSelect()
				if( type( WCD.Client.Settings[ v.key ] ) == "number" ) then
					WCD.Client.Settings[ v.key ] = tonumber( choiceKeys[ q.choice:GetText() ] );
				else
					WCD.Client.Settings[ v.key ] = string.lower( q.choice:GetText() );
				end
			end
		end
	end

	a.save = a:Add( "WCD::VariousButton" );
	a.save:SetNewText( "Save", true );
	a.save:SetButtonColor( c.saveButton );
	a.save:Dock( BOTTOM );

	function a.save:DoClick()
		WCD:Notification( lang.save, a );
		a:MoveTo( ScrW() / 2 - a:GetWide() / 2, -a:GetTall(), 0.3, 2, -1, function()
			a:Remove();
			timer.Simple( 0, function() WCD:SaveClientSettings(); if( func && type( func == "function" ) ) then func(); end end );
		end );
	end
end

timer.Simple( 0, function() WCD:LoadClientSettings(); end );
WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.clientsettings or "client settings" ) );
