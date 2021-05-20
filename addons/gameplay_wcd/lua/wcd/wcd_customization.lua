function WCD:RetrieveAllowedCustomizations( id, _p )
	local ref = self.List[ id ];
	if( !ref ) then return false; end
	if( ref.__WCDEnt && !self.Settings.allowEntityCustomization ) then return false; end

	--if( !ref || self.List[ id ].__WCDEnt ) then return false; end

	if( !ref.GetDisallowCustomization || ref:GetDisallowCustomization() ) then return false; end

	local tbl = {
		nitro = !ref:GetDisallowNitro(),
		skin = !ref:GetDisallowSkin(),
		color = !ref:GetDisallowColor(),
		bodygroups = !ref:GetDisallowBodygroup(),
		underglow = !ref:GetDisallowUnderglow()
	};

	if( ref.__WCDEnt || !WCD.Settings.nitro || ref:GetDisallowNitro() ) then
		tbl.nitro = false;
	end
	
	for i, v in pairs( tbl ) do
		if( !v ) then
			tbl[ i ] = nil;
		elseif(_p && WCD.RankCustomizationRequirements[ i ]
			&& !table.HasValue( WCD.RankCustomizationRequirements[ i ], _p:GetUserGroup() ) ) then
				tbl[ i ] = nil;
			end
	end

	return ( table.Count( tbl ) > 0 && tbl ) or false;
end

function WCD:CalculateCustomization( _p, _e, data, oldData )
	if( !( _e && IsValid( _e ) && _e:WCD_GetId() ) ) then return; end
	local ref = self.List[  _e:WCD_GetId() ];
	if( !ref ) then return; end

	local oldData = oldData or ( _p.__WCDSpecifics && _p.__WCDSpecifics[  _e:WCD_GetId() ] ) or {};
	local newData = {};
	local price = 0;
	local allowed = self:RetrieveAllowedCustomizations( _e:WCD_GetId(), _p ) or {};

	if( data.color && allowed.color && !ref:GetDisallowColor() ) then
		for i, v in pairs( data.color ) do
			if( !( i == 'r' || i == 'g' || i == 'b' ) ) then
				data.color[ i ] = nil;
			end
		end

		data.color.a = 255;
		if( ref:GetColor().r != data.color.r || ref:GetColor().g != data.color.g
		|| ref:GetColor().b != data.color.b ) then
			newData.color = data.color;
			price = price + ref:GetColorCost();
			self:Print( "Color Change" );
		end
	end

	if( data.bodygroups && allowed.bodygroups && !ref:GetDisallowBodygroup() ) then
		if( oldData.bodygroups ) then
			for i, v in pairs( oldData.bodygroups ) do
				if( data.bodygroups[ i ] != v ) then
					price = price + ref:GetBodygroupCost();
					self:Print( "Bodygroup Change" );
				end
			end
		else
			for i, v in pairs( data.bodygroups ) do
				if( v != _e:GetBodygroup( i ) ) then
					price = price + ref:GetBodygroupCost();
					self:Print( "Bodygroup Change" );
				end
			end
		end

		newData.bodygroups = data.bodygroups;
	end

	if( data.skin && allowed.skin && !ref:GetDisallowSkin() ) then
		data.skin = math.Clamp( data.skin, 0, _e:SkinCount() or 1 );

		local active = oldData.skin || _e:GetSkin();

		if( data.skin != active ) then
			price = price + ref:GetSkinCost();
			newData.skin = data.skin;

			self:Print( "Skin Change" );
		end
	end

	if( data.nitro && allowed.nitro && !ref:GetDisallowNitro() && data.nitro != ( oldData.nitro ) ) then
		data.nitro = math.Clamp( data.nitro, 0, 3 );
		WCD:Print( "Nitro Change" );

		if( data.nitro >= 0 ) then
			if( data.nitro == 1 ) then
				price = price + ref:GetNitroOneCost();
			elseif( data.nitro == 2 ) then
				price = price + ref:GetNitroTwoCost();
			elseif( data.nitro == 3 ) then
				price = price + ref:GetNitroThreeCost();
			end
		end
		newData.nitro = data.nitro;
	end

	if( data.underglow && allowed.underglow && !ref:GetDisallowUnderglow() ) then
		local a = data.underglow;
		local b = ( oldData.underglow or _e:WCD_GetUnderglow() );

		for i, v in pairs( data.underglow ) do
			if( !( i == 'r' || i == 'g' || i == 'b' ) ) then
				data.underglow[ i ] = nil;
			end
		end

		newData.underglow = a;
		newData.underglow[ "a" ] = 255;
		price = price + ref:GetUnderglowCost();

		self:Print( "Underglow Change" );
	end
	return price, newData;
end

if( SERVER ) then
	function WCD:PurchaseCustomization( _p, _e, data )
		if( !( IsValid( _p ) && IsValid( _e ) && data && _e.__WCDId && !self.List[ _e.__WCDId ]:GetDisallowCustomization() ) ) then return; end

		local price, data = self:CalculateCustomization( _p, _e, data );
		if( !( price && data ) || ! _p:canAfford( price ) ) then return; end

		_p:addMoney( -price );
		_p.__WCDSpecifics[ _e.__WCDId ] = data;
		_p:WCD_Notify( self:Translate( customizationBought, DarkRP.formatMoney( price ) ) );

		self:ApplySpecifics( _e );
		self:SavePlayerData( "specifics", _p, _p.__WCDSpecifics );
	end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.customization or "customization functionality" ) );