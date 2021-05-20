WCD.ListPaint = function( q, w, h )
	q.hover = q.hover or 60;

	if( q:IsHovered() ) then
		q.hover = Lerp( FrameTime() * 3, q.hover, 200 );
	else
		q.hover = Lerp( FrameTime() * 3, q.hover, 60 );
	end
	surface.SetDrawColor( Color( 0, 0, 0, q.hover ) );
	surface.DrawRect( 0, h - WCD.Settings.ButtonDepth / 2, w, WCD.Settings.ButtonDepth / 2 );
end

function WCD:LoadFonts()
	surface.CreateFont( "WCD::FontVeryLarge", {
		font = "Arial",
		size = 124,
		weight = 800
	} );

	surface.CreateFont( "WCD::FontFrameTitle", {
		font = "Arial",
		size = 54
	} );

	surface.CreateFont( "WCD::FontDealer", {
		font = "Verdana",
		size = 40
	} );

	surface.CreateFont( "WCD::FontFrameSubTitle", {
		font = "Arial",
		size = 22
	} );

	surface.CreateFont( "WCD::FontVariousButton", {
		font = "Arial",
		size = 24
	} );

	surface.CreateFont( "WCD::FontGenericMedium", {
		font = "Arial",
		size = 22
	} );

	surface.CreateFont( "WCD::FontVehicleName", {
		font = "Arial",
		size = 18
	} );

	surface.CreateFont( "WCD::FontGenericSmall", {
		font = "Arial",
		size = 18
	} );

	surface.CreateFont( "WCD::FontGenericSmaller", {
		font = "Arial",
		size = 14
	} );


	surface.CreateFont( "WCD::FontMenuButton", {
		font = "Arial",
		size = 24
	} );

	surface.CreateFont( "WCD::FontActionButton", {
		font = "Arial",
		size = 36
	} );

	surface.CreateFont( "WCD::FontHUD", {
		font = "Arial",
		size = 16
	} );

	surface.CreateFont( "WCD::FontNitro", {
		font = "Arial",
		size = 46
	} );


	surface.CreateFont( "WCD::FontPumpTitle", {
		font = "Arial",
		size = 28
	} );

	surface.CreateFont( "WCD::FontPumpInfo", {
		font = "Arial",
		size = 14
	} );

	surface.CreateFont( "WCD::FontPumpButton", {
		font = "Arial",
		size = 18
	} );
end


timer.Simple( 0, function() WCD:LoadFonts(); end );
hook.Add( "InitPostEntity", "WCD::LoadFonts", function() WCD:LoadFonts(); end );

function WCD:GetSortedDealerTable( menuId, dealerGroup )
	self.__NotYetSorted = self.__NotYetSorted or {};
	self.__Cached = self.__Cached or {};
	self.__CachedTables = self.__CachedTables or {};
	self.__TeamChange = self.__TeamChange or LocalPlayer():Team();
	if( !self.__TeamChange && LocalPlayer():Team() != self.TeamChange ) then
		self.__TeamChange = true;
	end

	if( self.__Change || self.__TeamChange ) then
		self.__NotYetSorted = { true, true, true, true };
	end

	if( self.__CachedTables && self.__CachedTables[ menuId ] && !self.__NotYetSorted[ menuId ] ) then
		return self.__CachedTables[ menuId ];
	end

	local tbl = {};
	local new = {};
	if( menuId == 1 ) then
		tbl = LocalPlayer():WCD_GetUnOwned();
	elseif( menuId == 2 ) then
		tbl = LocalPlayer():WCD_GetOwned();
	elseif( menuId == 3 ) then
		tbl = LocalPlayer():WCD_GetNoAccess();
	else
		tbl = LocalPlayer():WCD_GetFavorites();
	end

	for i, v in pairs( tbl ) do
		if( !self.List[ i ] || ( dealerGroup && dealerGroup != self.List[ i ]:GetDealer() ) ) then continue; end
		table.insert( new, { id = i, price = ( self.List[ i ]:GetFree() == true && 0 ) || self.List[ i ]:GetPrice() || 0 } );

		if( self.Client.Settings.CacheOnReceive && !self.__Cached[ self.VehicleData[ self.List[ i ]:GetClass() ].Model ] ) then
			util.PrecacheModel( self.VehicleData[ self.List[ i ]:GetClass() ].Model );
			self.__Cached[ self.VehicleData[ self.List[ i ]:GetClass() ].Model ] = true;
			self:Print( "Cached: " .. self.VehicleData[ self.List[ i ]:GetClass() ].Model );
		end
	end

	local asc = tobool( WCD.Client.Settings.SortAsc );
	if( type( asc ) != "boolean" ) then
		asc = true;
	end

	table.SortByMember( new, "price", asc );
	for i, v in pairs( new ) do
		if( type( v ) != "table" ) then continue; end
		new[ i ] = v.id;
	end

	self.__Change = false;
	self.__NotYetSorted[ menuId ] = nil;
	self.__CachedTables[ menuId ] = table.Copy( new );
	return new;
end

local c = WCD.Colors;
function WCD:OpenDealerHelper( current, parent, hideButtons )
	if( self.DealerHelper && IsValid( self.DealerHelper ) ) then
		self.DealerHelper:Remove();
	end

	local lang = WCD.Lang.DealerHelper;

	current = current or nil;
	self.DealerHelper = vgui.Create( "EditablePanel" );
	local a = self.DealerHelper;
	a:SetSize( 600, 330 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 5, 5, 5 );
	a.current = current;
	a.parent = parent;
	if( parent && IsValid( parent ) ) then
		a:SetParent( parent );
	end
	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetNewText( "x", true );
	a.close:SetPos( a:GetWide() - a.close:GetWide() - 5, 5 );
	a.close:SetZPos( 9999 );
	function a.close:Think() if( !IsValid( a ) ) then self:Remove(); end end
	function a.close:DoClick() a:Remove(); self:Remove(); end


	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Dealer Helper", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	a.left = a:Add( "DScrollPanel" );
	a.left:SetSize( a:GetWide() - 10, a:GetTall() - 95 );
	a.left:SetPos( 5, 5 );
	a.left:GetVBar():SetWide( 0 );
	local w = a.left:GetWide();

	function a.left:Paint( w, h )
		surface.SetDrawColor( color_black );
		surface.DrawRect( 0, h - 1, w, 1 );
	end


	a.left.items = a.left:Add( "DIconLayout" );
	a.left.items:Dock( FILL );

	local q = a.left.items:Add( "EditablePanel" );
	q:SetSize( w, 40 );
	q.title = q:Add( "DLabel" );
	q.title:SetFont( "WCD::FontFrameSubTitle" );
	q.title:SetText( lang.existingGroups );
	q.title:SizeToContents();
	q.title:SetColor( c.mainColor );
	q.title:SetPos( q:GetWide() / 2 - q.title:GetWide() / 2,
	q:GetTall() - q.title:GetTall() );
	q.hover = 60;
	q.Paint = function( self, w, h ) WCD.ListPaint( self, w, h ); end

	for i, v in pairs( WCD.DealerGroups ) do
		local q = a.left.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		q.Paint = WCD.ListPaint;

		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( v or "Unknown" );
		q.label:SetTall( 30 );
		q.label:SizeToContents();
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() );

		q.select = q:Add( "WCD::VariousButton" );
		q.select:SetFont( "WCD::FontGenericSmaller" );
		q.select:SetNewText( WCD.Lang.select, true );
		q.select:SetButtonColor( c.saveButton );

		q.select:SetPos( q:GetWide() - q.select:GetWide(),
			q:GetTall() / 2 - q.select:GetTall() / 2 );
		function q.select:DoClick()
			if( parent && IsValid( parent ) ) then
				parent.value = i;
			end

			WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
			a:Remove();
		end

		if( current && i == current ) then
			q.select:SetNewText( WCD.Lang.unselect, true );
			q.select:SetPos( q:GetWide() - q.select:GetWide(),
				q:GetTall() / 2 - q.select:GetTall() / 2 );

			function q.select:DoClick()
				if( parent && IsValid( parent ) ) then
					parent.value = nil;
				end

				WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
				a:Remove();
			end
		end

		q.edit = q:Add( "WCD::VariousButton" );
		q.edit:SetFont( "WCD::FontGenericSmaller" );
		q.edit:SetNewText( WCD.Lang.edit, true );
		q.edit.default = WCD.Lang.edit;
		q.edit:SetButtonColor( c.editButton );

		q.edit:SetPos( q:GetWide() - q.edit:GetWide() - q.select:GetWide() - 3,
			q:GetTall() / 2 - q.edit:GetTall() / 2 );
		function q.edit:DoClick()
			a:Build( i );
		end

		q.delete = q:Add( "WCD::VariousButton" );
		q.delete:SetFont( "WCD::FontGenericSmaller" );
		q.delete:SetNewText( WCD.Lang.delete, true );
		q.delete.default = WCD.Lang.delete;

		q.delete:SetPos( q:GetWide() - q.delete:GetWide() - q.select:GetWide() - q.edit:GetWide() - 6,
			q:GetTall() / 2 - q.delete:GetTall() / 2 );

		if( hideButtons ) then
			q.select:SetVisible( false );
			q.edit:SetVisible( false );
			q.delete:SetVisible( false );
		end

		function q.delete:DoClick()
			if( self.text == self.default ) then
				self:SetNewText( WCD.Lang.sureShort );
				return;
			end

			net.Start( "WCD::DeleteDealerGroup" );
			net.WriteFloat( i );
			net.SendToServer();
		end
	end

	a.right = a:Add( "EditablePanel" );
	a.right:SetSize( a:GetWide() - 10, 70 );
	a.right:SetPos( a:GetWide() - a.right:GetWide() - 5, a:GetTall() - a.right:GetTall() - 10 );

	a.right.btn = a.right:Add( "WCD::VariousButton" );
	a.right.btn:SetNewText( "Save", true );
	a.right.btn:SetButtonColor( c.saveButton );
	a.right.btn:Dock( BOTTOM );
	a.right.btn:DockMargin( 0, 10, 0, 0 );

	a.right.scroll = a.right:Add( "DScrollPanel" );
	a.right.scroll:Dock( FILL );
	a.right.scroll:GetVBar():SetWide( 0 );

	a.right.items = a.right.scroll:Add( "DIconLayout" );
	a.right.items:Dock( FILL );
	local w = a.right:GetWide();

	function a:Build( target )
		a.right.items:Clear();

		local data = WCD.DealerGroups[ target ];

		local q = a.right.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		local name = q:Add( "WCD::DTextEntry" );
		name:SetSize( w * 0.8, 28 );
		name:SetPos( q:GetWide() / 2 - name:GetWide() / 2 );

		if( target ) then
			name:SetDefaultText( WCD.DealerGroups[ target ] or "UNKNOWN" );
		else
			name:SetDefaultText( lang.newGroupName );
		end

		function a.right.btn:DoClick()
			local name = name:GetText();
			if( string.len( name ) < 1 || string.len( name ) > 90 || name == lang.newGroupName ) then
				LocalPlayer():WCD_Notify( lang.needName );
				return;
			end

			net.Start( "WCD::DealerGroups" );
			if( target ) then
				net.WriteBool( true );
				net.WriteFloat( target );
			else
				net.WriteBool( false );
			end

			net.WriteString( name );
			net.SendToServer();
		end
	end
	a:Build();

	return a;
end


function WCD:OpenAccessHelper( current, parent )
	if( self.AccessHelper && IsValid( self.AccessHelper ) ) then
		current = self.AccessHelper.current;
		parent = self.AccessHelper.parent;
		self.AccessHelper:Remove();
	end

	local lang = WCD.Lang.AccessHelper;

	current = current or nil;
	self.AccessHelper = vgui.Create( "EditablePanel" );
	local a = self.AccessHelper;
	a:SetSize( 700, 400 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 5, 5, 5 );
	a.current = current;
	a.parent = parent;
	if( parent && IsValid( parent ) ) then
		a:SetParent( parent );
	end
	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetNewText( "x", true );
	a.close:SetPos( a:GetWide() - a.close:GetWide() - 5, 5 );
	a.close:SetZPos( 9999 );
	function a.close:Think() if( !IsValid( a ) ) then self:Remove(); end end
	function a.close:DoClick() a:Remove(); self:Remove(); end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Access Helper", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	a.left = a:Add( "DScrollPanel" );
	a.left:SetSize( a:GetWide() * 0.5 - 5, a:GetTall() - 40 );
	a.left:SetPos( 5, 35 );
	a.left:GetVBar():SetWide( 0 );
	local w = a.left:GetWide();

	a.left.items = a.left:Add( "DIconLayout" );
	a.left.items:Dock( FILL );

	local q = a.left.items:Add( "EditablePanel" );
	q:SetSize( w, 40 );
	q.title = q:Add( "DLabel" );
	q.title:SetFont( "WCD::FontFrameSubTitle" );
	q.title:SetText( lang.existingGroups );
	q.title:SizeToContents();
	q.title:SetColor( c.mainColor );
	q.title:SetPos( q:GetWide() / 2 - q.title:GetWide() / 2,
	q:GetTall() - q.title:GetTall() );
	q.hover = 60;
	q.Paint = function( self, w, h ) WCD.ListPaint( self, w, h ); end

	for i, v in pairs( WCD.AccessGroups ) do
		local q = a.left.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		q.Paint = WCD.ListPaint;

		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( i or "Unknown" );
		q.label:SetTall( 30 );
		q.label:SizeToContents();
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() );

		q.select = q:Add( "WCD::VariousButton" );
		q.select:SetFont( "WCD::FontGenericSmaller" );
		q.select:SetNewText( WCD.Lang.select, true );
		q.select:SetButtonColor( c.saveButton );

		q.select:SetPos( q:GetWide() - q.select:GetWide(),
			q:GetTall() / 2 - q.select:GetTall() / 2 );
		function q.select:DoClick()
			if( parent && IsValid( parent ) ) then
				parent.value = i;
			end

			WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
			a:Remove();
		end

		if( current && i == current ) then
			q.select:SetNewText( WCD.Lang.unselect, true );
			q.select:SetPos( q:GetWide() - q.select:GetWide(),
				q:GetTall() / 2 - q.select:GetTall() / 2 );

			function q.select:DoClick()
				if( parent && IsValid( parent ) ) then
					parent.value = nil;
				end

				WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
				a:Remove();
			end
		end

		q.edit = q:Add( "WCD::VariousButton" );
		q.edit:SetFont( "WCD::FontGenericSmaller" );
		q.edit:SetNewText( WCD.Lang.edit, true );
		q.edit.default = WCD.Lang.edit;
		q.edit:SetButtonColor( c.editButton );

		q.edit:SetPos( q:GetWide() - q.edit:GetWide() - q.select:GetWide() - 3,
			q:GetTall() / 2 - q.edit:GetTall() / 2 );
		function q.edit:DoClick()
			a:Build( i );
		end

		q.delete = q:Add( "WCD::VariousButton" );
		q.delete:SetFont( "WCD::FontGenericSmaller" );
		q.delete:SetNewText( WCD.Lang.delete, true );
		q.delete.default = WCD.Lang.delete;

		q.delete:SetPos( q:GetWide() - q.delete:GetWide() - q.select:GetWide() - q.edit:GetWide() - 6,
			q:GetTall() / 2 - q.delete:GetTall() / 2 );

		function q.delete:DoClick()
			if( self.text == self.default ) then
				self:SetNewText( WCD.Lang.sureShort );
				return;
			end

			net.Start( "WCD::DeleteAccessGroup" );
			net.WriteString( i );
			net.SendToServer();
		end
	end

	a.right = a:Add( "EditablePanel" );
	a.right:SetSize( a:GetWide() * 0.5 - 10, a.left:GetTall() );
	a.right:SetPos( a:GetWide() - a.right:GetWide() - 5, 35 );

	a.right.btn = a.right:Add( "WCD::VariousButton" );
	a.right.btn:SetNewText( "Save", true );
	a.right.btn:SetButtonColor( c.saveButton );
	a.right.btn:Dock( BOTTOM );
	a.right.btn:DockMargin( 0, 10, 0, 0 );

	a.right.scroll = a.right:Add( "DScrollPanel" );
	a.right.scroll:Dock( FILL );
	a.right.scroll:GetVBar():SetWide( 0 );

	a.right.items = a.right.scroll:Add( "DIconLayout" );
	a.right.items:Dock( FILL );
	local w = a.right:GetWide();

	function a:Build( target )
		a.right.items:Clear();

		local data = WCD.AccessGroups[ target ] or { name = "No name", jobs = {}, ranks = {}, needBoth = false };

		local q = a.right.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		local name = q:Add( "WCD::DTextEntry" );
		name:SetSize( w * 0.8, 28 );
		name:SetPos( q:GetWide() / 2 - name:GetWide() / 2 );

		if( target ) then
			name:SetDefaultText( "[NO EDIT] " .. WCD.AccessGroups[ target ].name );
			name:SetDisabled( true );
		else
			name:SetDefaultText( lang.newGroupName );
		end

		q = a.right.items:Add( "EditablePanel" );
		q:SetSize( w, 40 );
		q.ranks = q:Add( "DLabel" );
		q.ranks:SetFont( "WCD::FontFrameSubTitle" );
		q.ranks:SetText( lang.ranks );
		q.ranks:SizeToContents();
		q.ranks:SetColor( c.mainColor );
		q.ranks:SetPos( q:GetWide() / 2 - q.ranks:GetWide() / 2,
		q:GetTall() - q.ranks:GetTall() );
		q.hover = 60;
		q.Paint = function( self, w, h ) WCD.ListPaint( self, w, h ); end

		for i, v in pairs( WCD:GetAllRanks() ) do
			q = a.right.items:Add( "EditablePanel" );
			q:SetSize( w, 30 );
			q.Paint = WCD.ListPaint;
			q.label = q:Add( "WCD::TooltipLabel" );
			q.label:SetText( v or "Unknown" );
			q.label:SetTall( 30 );
			q.label:SizeToContents();
			q.label:SetPos( 1, q:GetTall() - q.label:GetTall() );

			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetChecked( data.ranks[ v ] or false );

			function q.choice:OnChange()
				if( !self:GetChecked() ) then
					data.ranks[ v ] = nil;
				else
					data.ranks[ v ] = true;
				end
			end
		end

		q = a.right.items:Add( "EditablePanel" );
		q:SetSize( w, 40 );
		q.jobs = q:Add( "DLabel" );
		q.jobs:SetFont( "WCD::FontFrameSubTitle" );
		q.jobs:SetText( lang.jobs );
		q.jobs:SizeToContents();
		q.jobs:SetColor( c.mainColor );
		q.jobs:SetPos( q:GetWide() / 2 - q.jobs:GetWide() / 2,
		q:GetTall() - q.jobs:GetTall() );
		q.hover = 60;
		q.Paint = function( self, w, h ) WCD.ListPaint( self, w, h ); end

		for i, v in pairs( WCD:GetAllJobs() ) do
			q = a.right.items:Add( "EditablePanel" );
			q:SetSize( w, 30 );
			q.Paint = WCD.ListPaint;
			q.label = q:Add( "WCD::TooltipLabel" );
			q.label:SetText( v or "Unknown" );
			q.label:SetTall( 30 );
			q.label:SetPos( 1, 1 );
			q.label:SizeToContents();

			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetChecked( data.jobs[ v ] or false );

			function q.choice:OnChange()
				if( !self:GetChecked() ) then
					data.jobs[ v ] = nil;
				else
					data.jobs[ v ] = true;
				end
			end
		end

		q = a.right.items:Add( "EditablePanel" );
		q:SetSize( w, 50 );
		q.Paint = WCD.ListPaint;
		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( lang.needBoth );
		q.label:SetTall( 30 );
		q.label:SizeToContents();
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() );

		local needBoth = q:Add( "WCD::DCheckBox" );
		needBoth:SetSize( 24, 24 );
		needBoth:SetPos( q:GetWide() - needBoth:GetWide() - 1,
		q:GetTall()- needBoth:GetTall() - 5 );
		needBoth:SetChecked( data.needBoth or false );

		function needBoth:OnChange()
			if( !needBoth:GetChecked() ) then
				data.needBoth = false;
			else
				data.needBoth = true;
			end
		end

		function a.right.btn:DoClick()
			local name = name:GetText();
			if( string.len( name ) < 1 || string.len( name ) > 90 || name == lang.newGroupName ) then
				LocalPlayer():WCD_Notify( lang.needName );
				return;
			end

			data.name = string.Replace( name, "[NO EDIT] ", "" );
			data.needBoth = needBoth:GetChecked();

			net.Start( "WCD::AccessGroups" );
			net.WriteTable( data );
			net.SendToServer();
		end
	end
	a:Build();
end

function WCD:OpenBodygroupsHelper( model, current, parent )
	if( self.BodygroupsHelper && IsValid( self.BodygroupsHelper ) ) then
		self.BodygroupsHelper:Remove();
	end

	model = model or "models/tdmcars/242turbo.mdl";
	current = current or {};

	self.BodygroupsHelper = vgui.Create( "EditablePanel" );
	local a = self.BodygroupsHelper;
	a:SetSize( 400, 500 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 5, 5, 5 );
	a:SetZPos( 999 );
	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetNewText( "x", true );
	a.close:SetPos( a:GetWide() - a.close:GetWide() - 5, 5 );
	a.close:SetZPos( 9999 );
	function a.close:Think() if( !IsValid( a ) ) then self:Remove(); end end
	function a.close:DoClick() a:Remove(); self:Remove(); end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Bodygroups Helper", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	a.model = a:Add( "DModelPanel" );
	a.model:SetModel( model );
	a.model:SetTall( a:GetTall() / 2 - 40 );
	a.model:Dock( TOP );
	--a.model.LayoutEntity = function() end;
	a.model:DockMargin( 0, 0, 0, 20 );
	for i, v in pairs( current ) do
		a.model.Entity:SetBodygroup( i, v );
	end

	local mn, mx = a.model.Entity:GetRenderBounds();
	local size = 0;
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) );
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) );
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) );

	a.model:SetFOV( 45 );
	a.model:SetCamPos( Vector( size, size, size ) );
	a.model:SetLookAt( ( mn + mx ) * 0.5 );

	a.scroll = a:Add( "DScrollPanel" );
	a.scroll:SetTall( a.model:GetTall() );
	a.scroll:Dock( TOP );
	a.scroll:GetVBar():SetWide( 0 );

	local w = a:GetWide() - 10;
	a.items = a.scroll:Add( "DIconLayout" );
	a.items:Dock( FILL );

	local values = {};
	for i, v in pairs( a.model.Entity:GetBodyGroups() ) do
		if( !v.submodels || table.Count( v.submodels ) < 2 ) then continue; end

		local q = a.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );

		q.hover = 60;
		function q:Paint( w, h )

			if( self:IsHovered() ) then
				self.hover = Lerp( FrameTime() * 3, self.hover, 200 );
			else
				self.hover = Lerp( FrameTime() * 3, self.hover, 60 );
			end
			surface.SetDrawColor( Color( 0, 0, 0, self.hover ) );
			surface.DrawRect( 0, h - WCD.Settings.ButtonDepth / 2, w, WCD.Settings.ButtonDepth / 2 );
		end

		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( v.name or "Unknown" );
		q.label:SetTall( 30 );
		q.label:SetPos( 1, 1 );
		q.label:SizeToContents();
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() - 3 );

		if( table.Count( v.submodels ) == 2 ) then
			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetChecked( a.model.Entity:GetBodygroup( v.id ) or false );

			function q.choice:OnChange()
				local current = a.model.Entity:GetBodygroup( v.id );

				if( current == 0 ) then
					a.model.Entity:SetBodygroup( v.id, 1 );
				else
					a.model.Entity:SetBodygroup( v.id, 0 );
				end

				values[ v.id ] = a.model.Entity:GetBodygroup( v.id );
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
				reverseRef[ i ] = v;
				choiceRef[ v ] = i;
				q.choice:AddChoice( v );
			end
			q.choice:SetText( reverseRef[ a.model.Entity:GetBodygroup( v.id ) ] or "Off" );

			function q.choice:OnSelect( choice )
				a.model.Entity:SetBodygroup( v.id, choiceRef[ q.choice:GetText() ] );
				values[ v.id ] = a.model.Entity:GetBodygroup( v.id );
			end
		end
	end

	a.save = a:Add( "WCD::VariousButton" );
	a.save:SetNewText( "OK", true );
	a.save:SetButtonColor( c.saveButton );
	a.save:Dock( BOTTOM );

	function a.save:DoClick()
		if( parent && IsValid( parent ) ) then
			parent.value = values;
		end

		WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
		a:Remove();
	end
end



function WCD:OpenColorHelper( model, color, buttonToReceiveValue )
	if( self.ColorHelper && IsValid( self.ColorHelper ) ) then
		self.ColorHelper:Remove();
	end

	model = model or "models/tdmcars/242turbo.mdl";

	self.ColorHelper = vgui.Create( "EditablePanel" );
	local a = self.ColorHelper;

	a:SetSize( 300, 400 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 5, 5, 5 );
	a:SetZPos( 999 );
	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetNewText( "x", true );
	a.close:SetPos( a:GetWide() - a.close:GetWide() - 5, 5 );
	a.close:SetZPos( 9999 );
	function a.close:Think() if( !IsValid( a ) ) then self:Remove(); end end
	function a.close:DoClick() a:Remove(); self:Remove(); end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Color Helper", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	a.model = a:Add( "DModelPanel" );
	a.model:SetModel( model );
	a.model:SetTall( a:GetTall() / 2 - 40 );
	a.model:Dock( TOP );
	a.model.LayoutEntity = function() end;
	a.model:DockMargin( 0, 0, 0, 20 );


	local mn, mx = a.model.Entity:GetRenderBounds();
	local size = 0;
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) );
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) );
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) );

	a.model:SetFOV( 45 );
	a.model:SetCamPos( Vector( size, size, size ) );
	a.model:SetLookAt( ( mn + mx ) * 0.5 );

	a.color = a:Add( "DColorMixer" );
	a.color:SetTall( a.model:GetTall() );
	a.color:Dock( TOP );
	a.color:SetAlphaBar( false );
	a.color:SetWangs( false );
	a.color:SetPalette( false );

	function a.color:ValueChanged( x )
		a.model:SetColor( x );

		if( buttonToReceiveValue && IsValid( buttonToReceiveValue ) ) then
			buttonToReceiveValue:SetButtonColor( a.model:GetColor() );
		end
	end

	if( color ) then
		a.color:SetColor( color );
	else
		a.color:SetColor( color_white );
	end

	a.save = a:Add( "WCD::VariousButton" );
	a.save:SetNewText( "OK", true );
	a.save:SetButtonColor( c.saveButton );
	a.save:Dock( BOTTOM );

	function a.save:DoClick()
		if( buttonToReceiveValue && IsValid( buttonToReceiveValue ) ) then
			buttonToReceiveValue:SetButtonColor( a.model:GetColor() );
			buttonToReceiveValue.value = a.model:GetColor();
		end

		WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
		a:Remove();
	end
end


function WCD:OpenSkinHelper( model, current, buttonToReceiveValue )
	if( self.SkinHelper && IsValid( self.SkinHelper ) ) then
		self.SkinHelper:Remove();
	end

	model = model or "models/tdmcars/242turbo.mdl";
	current = current or 0;

	self.SkinHelper = vgui.Create( "EditablePanel" );
	local a = self.SkinHelper;

	a:SetSize( 300, 300 );
	a:Center();
	a:MakePopup();
	a:DockPadding( 5, 5, 5, 5 );
	a.close = a:Add( "WCD::VariousButton" );
	a.close:SetNewText( "x", true );
	a.close:SetPos( a:GetWide() - a.close:GetWide() - 5, 5 );
	a.close:SetZPos( 9999 );
	function a.close:Think() if( !IsValid( a ) ) then self:Remove(); end end
	function a.close:DoClick() a:Remove(); self:Remove(); end

	function a:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		draw.SimpleTextOutlined( "Skin Helper", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h )
	end

	a.model = a:Add( "DModelPanel" );
	a.model:SetModel( model );
	a.model:SetTall( a:GetTall() - 70 );
	a.model:Dock( TOP );
	a.model:DockMargin( 0, 0, 0, 20 );

	local mn, mx = a.model.Entity:GetRenderBounds();
	local size = 0;
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) );
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) );
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) );

	a.model:SetFOV( 45 );
	a.model:SetCamPos( Vector( size, size, size ) );
	a.model:SetLookAt( ( mn + mx ) * 0.5 );

	a.left = a:Add( "WCD::VariousButton" );
	a.left:SetNewText( "<<" );
	a.left:SetButtonColor( c.editButton );
	a.left:SetSize( 32, 32 );
	a.left:SetPos( 5, a:GetTall() - a.left:GetTall() * 2 - 10 );
	a.left:SetVisible( false );
	function a.left:DoClick() a:Click(); end

	a.text = a:Add( "DLabel" );
	a.text:SetFont( "WCD::FontGenericMedium" );

	a.right = a:Add( "WCD::VariousButton" );
	a.right:SetNewText( ">>" );
	a.right:SetButtonColor( c.selectButton );
	a.right:SetSize( 32, 32 );
	a.right:SetPos( a:GetWide() - a.right:GetWide() - 5, a:GetTall() - a.left:GetTall() * 2 - 10 );
	a.right:SetVisible( false );
	function a.right:DoClick() a:Click( true ); end

	local maxSkins = a.model.Entity:SkinCount();
	function a:Click( forward, force )
		if( force && force != 0 ) then
			current = force;
		else
			if( forward && current < maxSkins ) then
				current = current + 1;
			else
				current = current - 1;
			end
		end

		if( current >= maxSkins ) then
			a.right:SetVisible( false );
		else
			a.right:SetVisible( true );
		end

		if( current == 0 ) then
			a.left:SetVisible( false );
		else
			a.left:SetVisible( true );
		end

		a.text:SetText( current .. "/" .. maxSkins );
		a.text:SizeToContents();
		a.text:SetPos( a:GetWide() / 2 - a.text:GetWide() / 2,
			a:GetTall() - a.right:GetTall() * 2 );

		a.model.Entity:SetSkin( current );
	end
	a:Click( true, current );

	a.save = a:Add( "WCD::VariousButton" );
	a.save:SetNewText( "OK", true );
	a.save:SetButtonColor( c.saveButton );
	a.save:Dock( BOTTOM );

	function a.save:DoClick()
		if( buttonToReceiveValue && IsValid( buttonToReceiveValue ) ) then
			buttonToReceiveValue.value = a.model.Entity:GetSkin();
		end

		WCD:Notification( WCD.Lang.choiceSaved, WCD.AdminUI );
		a:Remove();
	end
end

WCD.Notifications = WCD.Notifications or {};
function WCD:Notification( text, popup )
	if( IsValid( WCD.AdminUI ) ) then popup = WCD.AdminUI;
	elseif( IsValid( WCD.DealerUI ) ) then popup = WCD.DealerUI;
	end

	if( !text ) then return; end
	for i, v in pairs( self.Notifications ) do
		if( !IsValid( v ) ) then
			self.Notifications[ i ] = nil;
		end
	end

	surface.SetFont( "WCD::FontGenericSmall" );
	local tw, th = surface.GetTextSize( text );
	local w, h = math.max( tw + 44, 300 ), math.max( th + 6, 22 );
	local targetX, targetY = ScrW() / 2 - w / 2, ScrH() / 4 - ( #self.Notifications * h );
	local dur = 1 + string.len( text ) / 8;

	local frame = vgui.Create( "EditablePanel" );
	if( popup ) then
		frame:SetZPos( 999 );
		frame:MakePopup();
	end


	table.insert( self.Notifications, frame );
	frame:SetSize( w, h );
	frame:SetPos( ScrW() / 2 - w / 2, -h );
	frame:MoveTo( targetX, targetY, 0.6 );
	frame.RemoveAt = CurTime() + dur;
	frame.Think = function( self )
		if( IsValid( self ) && self.RemoveAt <= CurTime() || ( popup && !IsValid( popup ) ) ) then
			self:Remove();
		end
	end
	frame.Paint = function( self, w, h )
		local x = 12;

		draw.RoundedBox( 32, 0, 0, w, h, WCD.Colors.frameBg );

		--surface.SetMaterial( WCD.Icons.Information );
		--surface.SetDrawColor( color_white );
		--surface.DrawTexturedRect( h / 2 - 8 + x, h / 2 - 8, 16, 16 );

		surface.SetFont( "WCD::FontGenericSmall" );
		surface.SetTextColor( color_white );
		surface.SetTextPos( w / 2 - tw / 2 + 9, h / 2 - th / 2 + 1 );
		surface.DrawText( text );
	end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.various or "Various" ) );
