WCD.AdminUI = WCD.AdminUI or nil;
WCD.DefaultVehicle = WCD.DefaultVehicle or Vehicle();

local c = WCD.Colors;

local downGradient = Material( "vgui/gradient_down" );
local upGradient = Material( "vgui/gradient_up" );
local rightGradient = Material( "vgui/gradient-l" );
local leftGradient = Material( "vgui/gradient-r" );

function WCD:OpenAdmin( data )
	if( IsValid( self.AdminUI ) ) then
		self.AdminUI:Remove();
	end
	WCD.DefaultVehicle = Vehicle();
	
	local frame = vgui.Create( "EditablePanel" );
	self.AdminUI = frame;
	frame:SetSize( 800, 600 );
	frame:Center();
	frame:MakePopup();
	function frame:Think()
		if( input.IsKeyDown( KEY_ESCAPE ) ) then
			frame:OnRemove();
			frame:Remove();
		end
	end

	function frame:Paint( w, h )
		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	function frame:OnRemove()
		if( IsValid( self.title ) ) then
			self.title:Remove();
		end
	end

	frame.title = vgui.Create( "EditablePanel" );
	frame.title:SetSize( 250, 30 );

	frame.title:SetPos( ScrW() / 2 - frame.title:GetWide() / 2,
	ScrH() / 2  + frame:GetTall() / 2 );

	function frame.title:Paint( w, h )
		draw.RoundedBoxEx( 16, 0, 0, w, h, c.frameBg, false, false, true, true );

		draw.SimpleTextOutlined( "WCD::Administration", "WCD::FontFrameSubTitle", w / 2, h / 2,
		color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black );
	end


	frame.menuPanel = frame:Add( "EditablePanel" );
	frame.menuPanel:SetTall( 70 );
	frame.menuPanel:Dock( TOP );
	frame.close = vgui.Create( "WCD::VariousButton" );
	frame.close:SetNewText( "x", true );
	frame.close:SetPos( ScrW() / 2 + frame:GetWide() / 2, ScrH() / 2 - frame:GetTall() / 2  )
	function frame.close:Think() if( !IsValid( frame ) ) then self:Remove(); end end
	function frame.close:DoClick() frame:Remove(); self:Remove(); end
	frame.close:MakePopup();



	frame.content = frame:Add( "EditablePanel" );
	frame.content:Dock( FILL );
	frame.content:DockPadding( 5, 5, 5, 5 );

	function frame.content:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	frame.views = {};
	function frame.content:AddView( name, id )
		local a = self:Add( "EditablePanel" );
		a:Dock( FILL );

		a.top = a:Add( "EditablePanel" );
		a.top:SetTall( 70 );
		a.top:Dock( TOP );

		a.bottom = a:Add( "EditablePanel" );
		a.bottom:SetWide( frame:GetWide() - 10 );
		a.bottom:SetTall( 50 );
		a.bottom:Dock( BOTTOM );

		a.content = a:Add( "DScrollPanel" );
		a.content:GetVBar():SetWide( 0 );
		a.content:Dock( FILL );

		a:SetVisible( false );
		frame.views[ id ] = a;
		return a;
	end


	function frame.menuPanel:Paint( w, h )
		surface.SetDrawColor( c.frameBg );
		surface.DrawRect( 0, 0, w, h );

		surface.SetDrawColor( c.gradient );
		surface.SetMaterial( downGradient );
		surface.DrawTexturedRect( 0, 0, w, h );
	end

	local w = frame:GetWide() / table.Count( self.Lang.adminMenuButtons );
	w = w - table.Count( self.Lang.adminMenuButtons ) * 2.5;

	frame.menuButtons = {};
	for i, v in pairs( self.Lang.adminMenuButtons ) do
		local a = frame.menuPanel:Add( "WCD::MenuButton" );
		a:SetSize( w, 60 );
		a:SetPos( w * ( i - 1 ) + 5 * ( i - 1 ) + 7.5, 5 );
		a:SetText( v );
		table.insert( frame.menuButtons, a );
		a.panel = frame.content:AddView( v, i );

		function a:DoClick()
			for i, v in pairs( frame.menuButtons ) do
				v:SetActive( false );
				v.panel:SetVisible( false );
			end

			self:SetActive( true );
			self.panel:SetVisible( true );
		end

		if( i == 1 ) then
			a:DoClick();
		end
	end

	/* SETTINGS VIEW */
	local lang = self.Lang.adminTabs.settings;
	local a = frame.views[ 1 ];
	a.bottom.save = a.bottom:Add( "WCD::VariousButton" );
	a.bottom.save:SetButtonColor( c.saveButton );
	a.bottom.save:SetFont( "WCD::FontActionButton" );
	a.bottom.save:SetNewText( WCD.Lang.save, true, 150 );
	a.bottom.save:SetTall( 40 );
	a.bottom.save:SetPos( a.bottom:GetWide() / 2 - a.bottom.save:GetWide() / 2, 5 );

	a.top.desc = a.top:Add( "DLabel" );
	a.top.desc:SetFont( "ChatFont" );
	a.top.desc:SetText( lang.desc );
	a.top.desc:SetMultiline( true );
	a.top.desc:SizeToContents();

	local list = a.content:Add( "DIconLayout" );
	list:Dock( FILL );

	local w = frame:GetWide() - 10;
	a.settingsList = {};
	for i, v in pairs( lang.content ) do
		local q = list:Add( "EditablePanel" );
		a.settingsList[ v.key ] = q;
		q:SetSize( w, 32 );

		if( v.key == "header" ) then
			q:SetTall( 60 );

			q.label = q:Add( "DLabel" );
			q.label:SetText( v.text );
			q.label:SetFont( "WCD::FontFrameSubTitle" );
			q.label:SizeToContents();
			q.label:SetColor( c.mainColor );
			q.label:SetPos( q:GetWide() / 2 - q.label:GetWide() / 2,
			q:GetTall() - q.label:GetTall() );
			continue;
		end

		q.hover = 60;
		q.Paint = WCD.ListPaint;

		q.label = q:Add( "WCD::TooltipLabel" );
		q.label:SetText( v.name );
		q.label:SetCoolTip( v.tooltip );
		q.label:SetTall( 30 );
		q.label:SetPos( 1, q:GetTall() - q.label:GetTall() + 3 );

		q.desc = q:Add( "DLabel" );
		q.desc:SetFont( "WCD::FontGenericSmaller" );
		q.desc:SetColor( color_white );
		q.desc:SetText( "" );

		if( v.type == "bool" ) then
			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetChecked( WCD.Settings[ v.key ] or false );

			function q:GetValue()
				return q.choice:GetChecked();
			end
		elseif( v.type == "number" ) then
			q.choice = q:Add( "WCD::DTextEntry" );
			q.choice:SetSize( 92, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetText( WCD.Settings[ v.key ] or "" );

			if( v.min && v.max ) then
				q.choice:SetAllowed( v.type, v.min, v.max );

				q.desc:SetText( WCD:Translate( WCD.Lang.allowedInputs.numberMinMax, v.min, v.max ) );
				q.desc:SizeToContents();
				q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
			else
				q.choice:SetAllowed( v.type );

				if( v.input ) then
					q.desc:SetText( WCD.Lang.allowedInputs[ v.input ] );
					q.desc:SizeToContents();
					q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
				end
			end

			function q:GetValue()
				return tonumber( q.choice:GetText() );
			end
		elseif( v.type == "combobox" ) then
			q.choice = q:Add( "WCD::DComboBox" );
			q.choice:SetSize( 92, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );

			local choices = {};
			if( type( v.values ) == "table" ) then
				choices = v.values;
			else
				choices = ( WCD.Settings[ v.values ] or WCD.Lang[ v.values ] or WCD[ v.values ] );
			end

			q.choice.default = choices[ WCD.Settings[ v.key ] ];
			q.choice:SetText( choices[ WCD.Settings[ v.key ] ] or "unknown" );

			local choiceKeys = {};
			for i, v in pairs( choices or {} ) do
				choiceKeys[ v ] = i;
				q.choice:AddChoice( v );
			end

			function q:GetValue()
				return choiceKeys[ q.choice:GetText() ] or q.choice:GetText();
			end
		end
	end

	function a.bottom.save:DoClick()
		local send = {};

		for i, v in pairs( a.settingsList ) do
			if( i == "header" ) then continue; end

			if( v.choice.wrong ) then
				WCD:Notification( WCD:Translate( "invalidSettingValue", ( v.label && v.label:GetText() ) or i ), WCD.AdminUI );
				return;
			end

			if( v.default && v:GetValue() != v.default || v:GetValue() != WCD.Settings[ i ] ) then
				send[ i ] = v:GetValue();
			end
		end

		if( table.Count( send ) < 1 ) then
			WCD:Notification( WCD.Lang.noSettingsChanged, WCD.AdminUI );
			return;
		end

		net.Start( "WCD::SendSettings" );
		net.WriteTable( send );
		net.SendToServer();

		WCD:Notification( WCD.Lang.settingsSent, WCD.AdminUI );
	end





	/* VEHICLES VIEW */
	local lang = self.Lang.adminTabs.vehicles;
	local a = frame.views[ 2 ];
	local nameRef = {};
	--a.top.Paint = function( self, w, h ) surface.SetDrawColor( Color( 255, 255, 255, 30 ) );surface.DrawRect( 0, 0, w, h ) end
	a.top.selectVehicle = a:Add( "WCD::DComboBox" );
	a.top.selectVehicle:SetSize( w / 2 - 30, 30 );
	a.top.selectVehicle:SetPos( 0, 5 );

	a.top.selectButton = a:Add( "WCD::VariousButton" );
	a.top.selectButton:SetSize( a.top.selectVehicle:GetSize() );
	a.top.selectButton:SetPos( 0, a.top:GetTall() - a.top.selectButton:GetTall() );
	a.top.selectButton:SetButtonColor( c.selectButton );
	a.top.selectButton:SetNewText( lang.select );
	function a.top.selectButton:DoClick()
		if( a.top.selectVehicle:GetText() == lang.selectVehicle ) then
			WCD:Notification( lang.invalidSelection, WCD.AdminUI );
			return;
		end

		a:Build( false, nameRef[ a.top.selectVehicle:GetText() ] );
	end

	a.top.orText = a:Add( "DLabel" );
	a.top.orText:SetText( lang[ "or" ] );
	a.top.orText:SetFont( "WCD::FontGenericMedium" );
	a.top.orText:SizeToContents();
	a.top.orText:SetPos( w / 2 - a.top.orText:GetWide() / 2,
		a.top:GetTall() / 2 - a.top.orText:GetTall() / 2 );

	a.top.editVehicle = a:Add( "WCD::DComboBox" );
	a.top.editVehicle:SetSize( a.top.selectVehicle:GetSize() );
	a.top.editVehicle:SetPos( w - a.top.editVehicle:GetWide(),
		5 );

	function a:RebuildTop()
		nameRef = {};
		a.top.selectVehicle:Clear();
		a.top.editVehicle:Clear();
		a.top.selectVehicle:SetText( lang.selectVehicle );
		a.top.editVehicle:SetText( lang.editVehicle );

		for i, v in pairs( WCD.VehicleData or {} ) do

			local name = v.Name;
			if( WCD.VehicleClassCounter[ i ] ) then
				name = name .. WCD:Translate( lang.activeCount, WCD.VehicleClassCounter[ i ] );
			end

			if( v.__WCDEnt ) then
				if( v.cat ) then
					name = "z[" .. v.cat .. "] " .. name;
				else
					name = "z[ENTITY] " .. name;
				end
			elseif( v.HasPhoton ) then
				name = "z[PHOTON] " .. name;
			end

			a.top.selectVehicle:AddChoice( name );
			nameRef[ name ] = i;
		end

		for i, v in pairs( WCD.List ) do
			nameRef[ v.name .. " (#" .. i .. ")"  ] = i;
			a.top.editVehicle:AddChoice( v.name .. " (#" .. i .. ")" );
		end
	end
	a:RebuildTop();

	a.top.editButton = a:Add( "WCD::VariousButton" );
	a.top.editButton:SetSize( a.top.selectVehicle:GetWide() / 2 - 2.5, a.top.selectVehicle:GetTall() );
	a.top.editButton:SetPos( w - a.top.editVehicle:GetWide(),
		a.top:GetTall() - a.top.editButton:GetTall() );
	a.top.editButton:SetButtonColor( c.editButton );
	a.top.editButton:SetNewText( lang.edit );
	function a.top.editButton:DoClick()
		if( a.top.editVehicle:GetText() == lang.editVehicle ) then
			WCD:Notification( lang.invalidSelection, WCD.AdminUI );
			return;
		end

		a:Build( nameRef[ a.top.editVehicle:GetText() ] );
	end

	a.top.deleteButton = a:Add( "WCD::VariousButton" );
	a.top.deleteButton:SetSize( a.top.selectVehicle:GetWide() / 2 - 2.5, a.top.selectVehicle:GetTall() );
	a.top.deleteButton:SetPos( w - a.top.deleteButton:GetWide(),
		a.top:GetTall() - a.top.deleteButton:GetTall() );

	a.top.deleteButton:SetNewText( WCD.Lang.delete );
	function a.top.deleteButton:DoClick()
		if( a.top.editVehicle:GetText() == lang.editVehicle ) then
			WCD:Notification( lang.invalidSelection, WCD.AdminUI );
			return;
		end

		if( self.text == WCD.Lang.delete ) then
			self.text = WCD.Lang.sureShort;
			return;
		end
		self.text = WCD.Lang.delete;

		net.Start( "WCD::DeleteVehicle" );
		net.WriteFloat( nameRef[ a.top.editVehicle:GetText() ] );
		net.SendToServer();
	end

	a.bottom.save = a.bottom:Add( "WCD::VariousButton" );
	a.bottom.save:SetButtonColor( c.saveButton );
	a.bottom.save:SetFont( "WCD::FontActionButton" );
	a.bottom.save:SetNewText( WCD.Lang.save, true, 150 );
	a.bottom.save:SetTall( 40 );
	a.bottom.save:SetPos( a.bottom:GetWide() / 2 - a.bottom.save:GetWide() / 2, 5 );
	a.bottom.save:SetVisible( false );


	function a:Build( editing, class )
		a.bottom.save:SetVisible( true );
		a.inputList = {};
		if( IsValid( a.list ) ) then a.list:Remove(); end
		a.content:Dock( FILL );
		a.list = a.content:Add( "DIconLayout" );
		a.list:Dock( FILL );

		local ref = WCD.DefaultVehicle;
		local data = WCD.DefaultVehicle;

		if( editing ) then
			data = WCD.List[ editing ];
			ref = data;
		elseif( class ) then
			data = WCD.VehicleData[ class ];
			ref:SetClass( class );
			ref:SetName( data.Name );
		end

		for i, v in pairs( lang.content ) do
			if( data.__WCDEnt && v.notForEnt && ( !WCD.Settings.allowEntityCustomization || v.neverForEnt ) ) then continue; end

			local q = a.list:Add( "EditablePanel" );
			q:SetSize( w, 32 );

			if( v.key == "header" ) then
				q:SetTall( 60 );

				q.label = q:Add( "DLabel" );
				if( i == 1 ) then
					local mode = WCD:Translate( lang.selecting, data.name or data.Name or data:GetName() );
					if( editing ) then mode = lang.editing; end
					q.label:SetText( WCD:Translate( v.text, mode ) );
				else
					q.label:SetText( v.text );
				end

				q.label:SetFont( "WCD::FontFrameSubTitle" );
				q.label:SizeToContents();
				q.label:SetColor( c.mainColor );
				q.label:SetPos( 1, q:GetTall() - q.label:GetTall() );
				continue;
			end
			a.inputList[ v.key ] = q;

			q.Paint = WCD.ListPaint;

			q.label = q:Add( "WCD::TooltipLabel" );
			q.label:SetText( v.name );
			q.label:SetCoolTip( v.tooltip );
			q.label:SetTall( 30 );
			q.label:SetPos( 1, 1 );

			q.desc = q:Add( "DLabel" );
			q.desc:SetFont( "WCD::FontGenericSmaller" );
			q.desc:SetColor( color_white );
			q.desc:SetText( "" );

			if( v.type == "bool" ) then
				q.choice = q:Add( "WCD::DCheckBox" );
				q.choice:SetSize( 24, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );
				q.choice:SetChecked( ref[ v.key ] or false );

				function q:GetValue()
					return q.choice:GetChecked();
				end
			elseif( v.type == "number" || v.type == "string" ) then
				q.choice = q:Add( "WCD::DTextEntry" );
				q.choice:SetSize( 92, 24 );
				if( v.type == "string" ) then
					q.choice:SetWide( 250 );
				end

				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );

				q.choice:SetText( ref[ v.key ] );
				q.choice:SetAllowed( v.type );

				if( v.min && v.max ) then
					q.choice:SetAllowed( v.type, v.min, v.max );

					q.desc:SetText( WCD:Translate( WCD.Lang.allowedInputs.numberMinMax, v.min, v.max ) );
					q.desc:SizeToContents();
					q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
				elseif( v.min ) then
					q.desc:SetText( WCD.Lang.allowedInputs.number );
					q.desc:SizeToContents();
					q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );

				else
					if( v.input ) then
						q.desc:SetText( WCD.Lang.allowedInputs[ v.input ] );
						q.desc:SizeToContents();
						q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
					end
				end

				function q:GetValue()
					if( v.type == "string" ) then return q.choice:GetText(); end

					return tonumber( q.choice:GetText() );
				end
			elseif( v.type == "combobox" ) then
				q.choice = q:Add( "WCD::DComboBox" );
				q.choice:SetSize( 92, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );

				local choices = {};
				if( type( v.values ) == "table" ) then
					choices = v.values;
				else
					choices = ( WCD.Settings[ v.values ] or WCD.Lang[ v.values ] or WCD[ v.values ] );
				end

				q.choice.default = ref[ v.key ] or choices[ 1 ];
				q.choice:SetText( ref[ v.key ] or choices[ 1 ] );

				local choiceKeys = {};
				for i, v in pairs( choices or {} ) do
					choiceKeys[ v ] = i;
					q.choice:AddChoice( v );
				end

				function q:GetValue()
					return choiceKeys[ q.choice:GetText() ] or q.choice:GetText();
				end
			else
				q.choice = q:Add( "WCD::VariousButton" );
				q.choice:SetSize( 92, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
					q:GetTall() / 2 - q.choice:GetTall() / 2 );
				q.choice:SetFont( "WCD::FontGenericSmaller" );
				q.choice:SetNewText( "Edit" );
				q.choice.alwaysHover = true;
				function q:GetValue()
					return self.choice.value;
				end

				if( v.type == "display_color" ) then
					q.choice:SetButtonColor( ref:GetColor() or color_white );
					q.choice.value = ref:GetColor() or color_white;

					function q.choice:DoClick()
						WCD:OpenColorHelper( WCD.VehicleData[ ref:GetClass() ].Model, q.choice.value or q.choice:GetColor(), self );
					end
				else
					if( v.type == "display_bodygroups" ) then
						q.choice.value = ref:GetBodygroups() or {};

						function q.choice:DoClick()
							WCD:OpenBodygroupsHelper( WCD.VehicleData[ ref:GetClass() ].Model, self.value or ref:GetBodygroups() or {}, self );
						end
					elseif( v.type == "display_access" ) then
						q.choice.value = ref:GetAccess() or nil;
						q.desc = q:Add( "DLabel" );
						q.desc:SetFont( "WCD::FontGenericSmaller" );
						q.desc:SetColor( color_white );
						q.desc:SetText( "" );

						q.desc:SetText( WCD:Translate( lang.active, q.choice.value or ref:GetAccess() or WCD.Lang.none ) );
						q.desc:SizeToContents();
						q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
						q.desc.nextThink = 0;
						function q.desc:Think()
							if( self.nextThink > CurTime() ) then return; end
							self.nextThink = CurTime() + 3;

							self:SetText( WCD:Translate( lang.active, q.choice.value or ref:GetAccess() or WCD.Lang.none ) );
							self:SizeToContents();
							self:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
							return;
						end

						function q.choice:DoClick()
							WCD:OpenAccessHelper( self.value or ref:GetAccess() or nil, self );
						end
					elseif( v.type == "display_skin" ) then
						q.choice.value = ref:GetSkin() or nil;
						q.desc = q:Add( "DLabel" );
						q.desc:SetFont( "WCD::FontGenericSmaller" );
						q.desc:SetColor( color_white );
						q.desc:SetText( "" );

						q.desc:SetText( WCD:Translate( lang.active, q.choice.value or ref:GetSkin() or WCD.Lang.none ) );
						q.desc:SizeToContents();
						q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
						q.desc.nextThink = 0;
						function q.desc:Think()
							if( self.nextThink > CurTime() ) then return; end
							self.nextThink = CurTime() + 3;

							self:SetText( WCD:Translate( lang.active, q.choice.value or ref:GetSkin() or WCD.Lang.none ) );
							self:SizeToContents();
							self:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
							return;
						end

						function q.choice:DoClick()
							WCD:OpenSkinHelper( WCD.VehicleData[ ref:GetClass() ].Model, self.value or ref:GetSkin() or nil, self );
						end
					elseif( v.type == "display_dealers" ) then
						q.choice.value = ref:GetDealer() or nil;
						q.desc = q:Add( "DLabel" );
						q.desc:SetFont( "WCD::FontGenericSmaller" );
						q.desc:SetColor( color_white );
						q.desc:SetText( "" );

						q.desc:SetText( WCD:Translate( lang.active, WCD.DealerGroups[ q.choice.value or ref:GetSkin() or WCD.Lang.none ] ) );
						q.desc:SizeToContents();
						q.desc:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );
						q.desc.nextThink = 0;
						function q.desc:Think()
							if( self.nextThink > CurTime() ) then return; end
							self.nextThink = CurTime() + 3;
							local dealergrp = WCD.DealerGroups[ q.choice.value or ref:GetDealer() ];

							self:SetText( WCD:Translate( lang.active, dealergrp or WCD.Lang.none ) );
							self:SizeToContents();
							self:SetPos( q:GetWide() / 2 - q.desc:GetWide() / 2, q:GetTall() / 2 - q.desc:GetTall() / 2 );							return;
						end

						function q.choice:DoClick()
							WCD:OpenDealerHelper( self.value or ref:GetDealer(), self );
						end
					end
					q.choice:SetButtonColor( c.selectButton );
				end
			end
		end

		function a.bottom.save:DoClick()
			local data = {};
			for i, v in pairs( a.inputList ) do

				if( v.choice.wrong ) then
					WCD:Notification( WCD:Translate( lang.invalidValues, i ), self );
					return;
				end

				data[ i ] = v:GetValue();
			end


			data.class = ( editing && ref && ref.GetClass && ref:GetClass() ) or class;
			data.id = ( editing && ref && ref.GetId && ref:GetId() ) or -1;

			net.Start( "WCD::AddVehicle" );
			net.WriteTable( data );
			net.SendToServer();

			a.list:Remove();
			a.bottom.save:SetVisible( false );
		end
	end

	/* USERS VIEW */
	local lang = self.Lang.adminTabs.users;
	local a = frame.views[ 3 ];
	a.top.selectUser = a:Add( "WCD::DComboBox" );
	a.top.selectUser:SetSize( w / 2 - 30, 30 );
	a.top.selectUser:SetPos( 0, 5 );

	a.top.selectButton = a:Add( "WCD::VariousButton" );
	a.top.selectButton:SetSize( a.top.selectUser:GetSize() );
	a.top.selectButton:SetPos( 0, a.top:GetTall() - a.top.selectButton:GetTall() );
	a.top.selectButton:SetButtonColor( c.selectButton );
	a.top.selectButton:SetNewText( lang.selectUserButton );
	function a.top.selectButton:DoClick()
		if( a.top.selectUser:GetText() == lang.selectUser ) then
			WCD:Notification( lang.invalidSelection, WCD.AdminUI );
			return;
		end

		a:Build( a.top.selectUser:GetText() );
	end

	a.top.orText = a:Add( "DLabel" );
	a.top.orText:SetText( lang[ "or" ] );
	a.top.orText:SetFont( "WCD::FontGenericMedium" );
	a.top.orText:SizeToContents();
	a.top.orText:SetPos( w / 2 - a.top.orText:GetWide() / 2,
		a.top:GetTall() / 2 - a.top.orText:GetTall() / 2 );

	a.top.inputSteam = a:Add( "WCD::DTextEntry" );
	a.top.inputSteam:SetSize( a.top.selectUser:GetSize() );
	a.top.inputSteam:SetPos( w - a.top.inputSteam:GetWide(),
		5 );

	function a:RebuildTop()
		a.top.selectUser:Clear();
		a.top.inputSteam:Clear();
		a.top.selectUser:SetText( lang.selectUser );
		a.top.inputSteam:SetDefaultText( lang.inputSteam );

		for i, v in pairs( player.GetAll() ) do
			a.top.selectUser:AddChoice( v:Nick() );
		end
	end
	a:RebuildTop();

	a.top.inputSteamButton = a:Add( "WCD::VariousButton" );
	a.top.inputSteamButton:SetSize( a.top.inputSteam:GetWide(), a.top.inputSteam:GetTall() );
	a.top.inputSteamButton:SetPos( w - a.top.inputSteamButton:GetWide(),
		a.top:GetTall() - a.top.inputSteamButton:GetTall() );
	a.top.inputSteamButton:SetButtonColor( c.saveButton );
	a.top.inputSteamButton:SetNewText( lang.inputSteamButton );
	function a.top.inputSteamButton:DoClick()
		if( a.top.inputSteam:GetText() == lang.inputSteamButton ) then
			WCD:Notification( lang.invalidSelection, WCD.AdminUI );
			return;
		end

		a:Build( a.top.inputSteam:GetText() );
	end

	local lastValue, lastId;
	function a:Build( value, data )
		if( IsValid( a.list ) ) then
			a.list:Clear();
			a.list:Remove();
		end

		a.content:Dock( FILL );
		a.list = a.content:Add( "DIconLayout" );
		a.list:Dock( FILL );
		a.edited = {};

		if( data ) then
			a.bottom.save:SetVisible( true );
			for i, v in pairs( WCD.List ) do
				if( v:GetFree() ) then continue; end
				local q = a.list:Add( "EditablePanel" );
				q:SetSize( w, 32 );
				q.Paint = WCD.ListPaint;

				q.label = q:Add( "WCD::TooltipLabel" );
				q.label:SetText( v:GetName() );
				q.label:SetTall( 30 );
				q.label:SizeToContents();
				q.label:SetPos( 1, q:GetTall() - q.label:GetTall() + 3 );

				q.desc = q:Add( "DLabel" );
				q.desc:SetFont( "WCD::FontGenericSmaller" );
				q.desc:SetColor( color_white );
				q.desc:SetText( "" );

				q.choice = q:Add( "WCD::DCheckBox" );
				q.choice:SetSize( 24, 24 );
				q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
				q:GetTall() / 2 - q.choice:GetTall() / 2 );
				q.choice:SetChecked( data[ i ] or false );
				a.edited[ i ] = data[ i ] or false;

				function q.choice:OnChange( x )
					a.edited[ i ] = x;
				end

				function q:GetValue()
					return q.choice:GetChecked();
				end
			end
		else
			if( !value ) then return; end
			local target = false;
			for i, v in pairs( player.GetAll() ) do
				if( v:Nick() == value ) then
					target = v:SteamID();
					break;
				end
			end

			if( !target ) then
				target = string.sub( value, 0, 20 );
			end

			lastValue = value;
			lastId = target;
			net.Start( "WCD::RequestPlayerVehicles" );
			net.WriteString( target );
			net.SendToServer();
		end
	end

	net.Receive( "WCD::RequestPlayerVehicles", function()
		a:Build( lastValue, net.ReadTable() );
	end );

	a.bottom.save = a.bottom:Add( "WCD::VariousButton" );
	a.bottom.save:SetButtonColor( c.saveButton );
	a.bottom.save:SetFont( "WCD::FontActionButton" );
	a.bottom.save:SetNewText( WCD.Lang.save, true, 150 );
	a.bottom.save:SetTall( 40 );
	a.bottom.save:SetPos( a.bottom:GetWide() / 2 - a.bottom.save:GetWide() / 2, 5 );
	a.bottom.save:SetVisible( false );

	function a.bottom.save:DoClick()
		a.list:Clear();
		a.list:Remove();

		net.Start( "WCD::UpdatePlayerVehicles" );
		net.WriteString( lastId );
		net.WriteTable( a.edited );
		net.SendToServer();
	end
end


/*
WCD.HasReceivedVehicles = false;
hook.Add( "OnPlayerChat", "WCD::OpenAdmin", function( _p, txt )
	if( _p == LocalPlayer() && txt == "!wcd" && WCD:IsOwner( _p ) ) then
		if( !WCD.HasReceivedVehicles ) then
			WCD:Notification( WCD.Lang.requestingAllVehicles );

			net.Start( "WCD::AskForVehicles" );
			net.SendToServer();
		else
			WCD:OpenAdmin();
		end
	end
end );*/

net.Receive( "WCD::OpenAdmin", function()
	WCD:OpenAdmin();
	WCD.HasReceivedVehicles = true;
end );

timer.Simple( 0, function()
	--WCD:OpenAdmin();
end );
WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.adminui or "admin UI" ) );
