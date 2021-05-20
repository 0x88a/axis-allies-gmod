AddCSLuaFile();
local lang = WCD.Lang.adminGun;

SWEP.Author			= "William";
SWEP.Instructions	= lang.instructions;

SWEP.Spawnable			= true;
SWEP.AdminOnly			= true;
SWEP.UseHands			= true;
SWEP.Category 			= 	"William's Car Dealer";

SWEP.ViewModel			= "models/weapons/c_pistol.mdl";
SWEP.WorldModel			= "models/weapons/w_Pistol.mdl";

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";

SWEP.AutoSwitchTo			= false;
SWEP.AutoSwitchFrom			= false;

SWEP.PrintName			= "Administrator Tool";
SWEP.Slot				= 0;
SWEP.SlotPos			= 0;
SWEP.DrawAmmo			= false;

function SWEP:Initialize()
	if( CLIENT && self.Owner == LocalPlayer() ) then WCD.__StopDealer = CurTime() + 30; end
	if( SERVER ) then self.Owner.__WCDCanPhys = CurTime() + 60; end
	self:SetHoldType( "pistol" );
end

function SWEP:Deploy()
	if( CLIENT && self.Owner == LocalPlayer() ) then WCD.__StopDealer = CurTime() + 30;  LocalPlayer():ChatPrint( lang.instructions ); end
	if( SERVER ) then self.Owner.__WCDCanPhys = CurTime() + 60; end
	return true;
end

function SWEP:Holster()
	 return true;
end

function SWEP:Reload()
end

function SWEP:DrawHUD()
end

function SWEP:PrimaryAttack()
	if( !IsFirstTimePredicted() ) then
		return;
	end

	if( !WCD:IsOwner( self.Owner ) ) then if( CLIENT ) then WCD:Notification( lang.invalidRank ); end return; end
	local tr = self.Owner:GetEyeTrace();

	if( tr && tr.Entity ) then
		local _e = tr.Entity;
		if( tr.Entity:GetClass() == "wcd_dealer" ) then
			if( CLIENT ) then
				WCD:OpenDealerMenu( _e );
			end
		elseif( tr.Entity:GetClass() == "wcd_pump" ) then
			if( SERVER ) then
				WCD:Save( "pumps" );
			else
				WCD:Notification( lang.savedPump );
			end
		elseif( tr.Entity == game.GetWorld() ) then
			if( CLIENT ) then return; end
			local _e = ents.Create( "wcd_dealer" );
			_e:SetPos( tr.HitPos + Vector( 0, 0, 10 ) );
			_e:Spawn();
		else
			if( CLIENT ) then
				WCD:Notification( lang.aimHelp );
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if( !IsFirstTimePredicted() ) then
		return;
	end

	if( !WCD:IsOwner( self.Owner ) ) then if( CLIENT ) then WCD:Notification( lang.invalidRank ); end return; end
	local tr = self.Owner:GetEyeTrace();
	local dealer = false;

	if( tr && tr.Entity  ) then
		local _e = tr.Entity;
		if( tr.Entity:GetClass() == "wcd_pump" ) then
			if( SERVER ) then
				_e:Remove();
				timer.Simple( 1, function()
					WCD:Save( "pumps" );
				end );
			else
				WCD:Notification( lang.deletedPump );
			end
		elseif( tr.Entity == game.GetWorld() ) then
			if( CLIENT ) then return; end
			local _e = ents.Create( "wcd_pump" );
			_e:SetPos( tr.HitPos + Vector( 0, 0, 10 ) );
			_e:Spawn();
		else
			if( CLIENT ) then
				WCD:Notification( lang.aimHelp );
			end
		end
	end
end

if( CLIENT ) then
local c = WCD.Colors;

function WCD:OpenDealerMenu( dealer )
	if( self.DealerMenu && IsValid( self.DealerMenu ) ) then
		self.DealerMenu:Remove();
	end

	if( !IsValid( dealer ) ) then return; end

	self.DealerMenu = vgui.Create( "EditablePanel" );
	local a = self.DealerMenu;
	a:SetSize( 450, 400 );
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

		draw.SimpleTextOutlined( "Dealer Configuration", "WCD::FontFrameSubTitle",
			w / 2, 5, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black );

		surface.SetDrawColor( color_black );
		surface.DrawOutlinedRect( 0, 0, w, h );
	end

	a.left = a:Add( "DScrollPanel" );
	a.left:SetSize( a:GetWide() - 10, a:GetTall() - 40 );
	a.left:SetPos( 5, 35 );
	a.left:GetVBar():SetWide( 0 );
	local w = a.left:GetWide();

	function a.left:Paint( w, h )
		surface.SetDrawColor( color_black );
		surface.DrawRect( 0, h - 1, w, 1 );
	end


	a.left.items = a.left:Add( "DIconLayout" );
	a.left.items:Dock( FILL );
	local values = {};

	for i, v in pairs( lang.settings ) do
		if( i == "globalReturn" && !WCD.Settings.canOnlyReturnSpawned ) then continue; end
		
		local q = a.left.items:Add( "EditablePanel" );
		q:SetSize( w, 30 );
		q.Paint = WCD.ListPaint;

		if( v.type != "button" ) then
			q.label = q:Add( "WCD::TooltipLabel" );
			q.label:SetText( v.name or "Unknown" );
			q.label:SetTall( 30 );
			q.label:SizeToContents();
			q.label:SetPos( 1, q:GetTall() - q.label:GetTall() - 3 );
		end

		if( v.values ) then
			q.choice = q:Add( "WCD::DComboBox" );
			q.choice:SetSize( 150, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );

			local ref = {};
			if( v.values == "DealerGroups" ) then
				for i, v in pairs( WCD.DealerGroups ) do
					ref[ v ] = i;
					q.choice:AddChoice( v );
				end
			end
			q.choice:SetText( ref[ dealer:GetNWFloat( "group", -1 ) ] or WCD.Lang.none );

			function q.choice:GetValue()
				return ref[ q.choice:GetText() ] or false;
			end

		elseif( v.type == "string" ) then
			q.choice = q:Add( "WCD::DTextEntry" );
			q.choice:SetSize( 250, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );

			function q.choice:GetValue()
				return q.choice:GetText();
			end

			if( v.key == "model" ) then
				q.choice:SetDefaultText( dealer:GetModel() );
			elseif( v.key == "name" ) then
				q.choice:SetDefaultText( dealer:GetNWString( "WCD::Name", "Unknown Name" ) );
			end

		elseif( v.type == "checkbox" ) then
			q.choice = q:Add( "WCD::DCheckBox" );
			q.choice:SetSize( 24, 24 );
			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1, q:GetTall() / 2 - q.choice:GetTall() / 2 );
		
			if( v.nwbool ) then
				q.choice:SetChecked( dealer:GetNWBool( "WCD::" .. v.key ) );
			end

			function q.choice:GetValue()
				return q.choice:GetChecked();
			end
		elseif( v.type == "button" ) then
			q.choice = q:Add( "WCD::VariousButton" );
			q.choice:SetSize( q:GetWide(), 24 );
			q.choice:SetFont( "WCD::FontGenericSmall" );

			q.choice:SetPos( q:GetWide() - q.choice:GetWide() - 1,
			q:GetTall() / 2 - q.choice:GetTall() / 2 );
			q.choice:SetNewText( v.name );

			if( v.key == "newPlatform" ) then
				q.choice:SetButtonColor( c.saveButton );

				function q.choice:DoClick()
					net.Start( "WCD::NewPlatform" );
					net.WriteFloat( dealer:EntIndex() );
					net.SendToServer();

					WCD.__StopDealer = CurTime() + 60;
					a:Remove();
				end
			elseif( v.key == "deleteAllPlatform" ) then
				local count = 0;
				for i, v in pairs( ents.FindByClass( "wcd_platform" ) ) do
					if( v:GetNWFloat( "WCD::DealerID", 0 ) == dealer:EntIndex() ) then
						count = count + 1;
					end
				end

				q.choice:SetNewText( WCD:Translate( v.name, count ) );

				function q.choice:DoClick()
					net.Start( "WCD::DeleteAllPlatforms" );
					net.WriteFloat( dealer:EntIndex() );
					net.SendToServer();

					a:Remove();
				end
			end
		end

		if( i == 3 ) then
			q.open = q:Add( "WCD::VariousButton" );
			q.open:SetFont( "WCD::FontGenericSmall" );
			q.open:SetNewText( "Open", true, 10 );
			q.open:SetPos( q:GetWide() - q.choice:GetWide() - q.open:GetWide() - 5, q:GetTall() / 2 - q.open:GetTall() / 2 );
			q.open:SetButtonColor( Color( 168, 168, 0, 120 ) );

			function q.open:DoClick()
				local a = WCD:OpenDealerHelper( nil, q, true );
				function a:OnRemove()
					WCD:OpenDealerMenu( dealer );
				end
			end
		end

		if( v.type != "button" ) then
			values[ v.key ] = q.choice;
		end
	end

	a.save = a:Add( "WCD::VariousButton" );
	a.save:SetNewText( "OK", true );
	a.save:SetButtonColor( c.saveButton );
	a.save:Dock( BOTTOM );
	function a.save:DoClick()
		WCD.__StopDealer = CurTime() + 60;

		local data = {};
		for i, v in pairs( values ) do
			data[ i ] = v:GetValue();
		end

		net.Start( "WCD::EditDealer" );
		net.WriteFloat( dealer:EntIndex() );
		net.WriteTable( data );
		net.SendToServer();
		WCD:Notification( lang.saved );

		a:Remove();
	end


	a.del = a:Add( "WCD::VariousButton" );
	a.del:SetNewText( "Delete Dealer", true );
	a.del:Dock( BOTTOM );
	a.del:DockMargin( 0, 0, 0, 5 );

	function a.del:DoClick()
		if( self.text == "Delete Dealer" ) then
			self.text = WCD.Lang.sure;
			return;
		end

		net.Start( "WCD::DeleteDealer" );
		net.WriteFloat( dealer:EntIndex() );
		net.SendToServer();

		WCD:Notification( lang.deleted );
		a:Remove();
	end
end

--	WCD:OpenDealerMenu( LocalPlayer():GetEyeTrace().Entity )
	--WCD:OpenDealerMenu( LocalPlayer():GetEyeTrace().Entity );
end
