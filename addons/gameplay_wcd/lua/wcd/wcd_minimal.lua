// just various stuff too small for their own files
WCD.AccessGroups = WCD.AccessGroups or {};
WCD.DealerGroups = WCD.DealerGroups or {};

local meta = FindMetaTable( "Entity" );
function meta:WCD_SetId( x )
	self.__WCDId = x;
	self:SetNWFloat( "WCD::Id", x );
end

function meta:WCD_GetId()
	return self:GetNWFloat( "WCD::Id", -1 );
end


local meta = FindMetaTable( "Vehicle" );
function meta:WCD_SetNitro( x )
	self.__WCDNitro = x;
end

function meta:WCD_GetNitro()
	return self.__WCDNitro or (  WCD.List[ self:WCD_GetId() ] &&  WCD.List[ self:WCD_GetId() ]:GetNitro() ) or 0;
end

function meta:WCD_UseNitro()
	if( CLIENT ) then return; end
	if( self:WCD_GetNitro() == 0 || !WCD.Settings.nitro
		|| ( self.__WCDLastNitro && self.__WCDLastNitro + WCD.Settings.nitroCooldown >= CurTime() ) ) then return; end
	self.__WCDLastNitro = CurTime();

	local phys = self:GetPhysicsObject();
	timer.Create( self:EntIndex() .. "::Boost", 0.025, 50 + ( self:WCD_GetNitro() * 3 ), function()
		phys:ApplyForceCenter( self:GetForward() * phys:GetMass() * ( WCD.Settings.nitroPower * ( 50 +  ( self:WCD_GetNitro() * 10 ) ) ) );
	end );

	net.Start( "WCD::NitroUsed" );
	net.Send( self:GetDriver() );

	timer.Simple( WCD.Settings.nitroCooldown, function()
		if( IsValid( self ) && IsValid( self:GetDriver() ) ) then
			net.Start( "WCD::NitroReady" );
			net.Send( self:GetDriver() );
		end
	end );
end

function meta:WCD_SetId( x )
	self.__WCDId = x;
	self:SetNWFloat( "WCD::Id", x );
end

function meta:WCD_GetId()
	return self:GetNWFloat( "WCD::Id", -1 );
end

if( CLIENT ) then
	timer.Simple( 0, function()
		LocalPlayer().__WCDCoreOwned = LocalPlayer().__WCDCoreOwned or {};
		LocalPlayer().__WCDSpecifics = LocalPlayer().__WCDSpecifics or {};
	end );
else
	util.AddNetworkString( "WCD::OpenAdmin" );
	util.AddNetworkString( "WCD::AskForVehicles" );

	net.Receive( "WCD::AskForVehicles", function( _, _p )
		if( WCD:IsOwner( _p ) ) then
			local timeBeforeOpen = WCD:SendAllVehicles( _p );

			timer.Simple( timeBeforeOpen * 0.05, function()
				if( IsValid( _p ) ) then
					net.Start( "WCD::OpenAdmin" );
					net.Send( _p );
				end
			end );
		end
	end );
end

function meta:WCD_ToggleUnderglow()
	self:SetNWBool( "WCD::Underglow", !( self:GetNWBool( "WCD::Underglow", true ) ) );
end

function meta:WCD_GetUnderglow()
	return self:GetNWBool( "WCD::Underglow", false );
end


function meta:WCD_GetUnderglowColor()
	return ( self:GetNWVector( "WCD::UnderglowColor", Vector( 0, 0, 0 ) ) != Vector( 0, 0, 0 ) && self:GetNWVector( "WCD::UnderglowColor" ) ) or false;
end

function meta:WCD_SetUnderglow( color )
	if( !( color && type( color ) == "table" ) ) then
		self.__WCDUnderglow = false;
		return;
	end

	self.__WCDUnderglowColor = Vector( color.r, color.g, color.b );

	if( SERVER ) then
		self:SetNWBool( "WCD::Underglow", true );
		self:SetNWVector( "WCD::UnderglowColor", self.__WCDUnderglowColor );
	end
end

for i, v in pairs( ents.FindByClass( "prop_vehicle_jeep" ) ) do
	v.__WCDUnderglowData = nil;
end

function meta:WCD_ProcessUnderglow( bypass )
	if( !bypass && !self:WCD_GetUnderglow() ) then return; end

	local up = self:GetUp();
	local right = self:GetRight();
	if( !self.__WCDUnderglowData ) then
		local center = self:OBBCenter();
		local mins = self:OBBMins();
		local maxs = self:OBBMaxs();

		self.__WCDUnderglowData = {
			center = center,
			sizeCenter = maxs.x,

			distToFront = center:Distance( Vector( mins.x, mins.y , center.z ) / 2 ),
			distToBack = center:Distance( Vector( maxs.x, maxs.y, center.z ) / 2 ),
			distToUnder = center:Distance( Vector( 0, 0, mins.z ) ) / 2,
		};

		self.__WCDUnderglowFunc = {
			function()
				return self:LocalToWorld( self.__WCDUnderglowData.center ) + up * -self.__WCDUnderglowData.distToUnder;
			end,


			function()
				return self:LocalToWorld( self.__WCDUnderglowData.center ) + self:GetRight() * -( self.__WCDUnderglowData.distToFront - 10 ) + self:GetUp() * -self.__WCDUnderglowData.distToUnder;
			end,

			function()
				return self:LocalToWorld( self.__WCDUnderglowData.center ) + self:GetRight() * -( self.__WCDUnderglowData.distToFront - 15 ) + self:GetUp() * -self.__WCDUnderglowData.distToUnder;
			end,


			function()
				return self:LocalToWorld( self.__WCDUnderglowData.center ) + self:GetRight() * ( self.__WCDUnderglowData.distToBack + 10 ) + self:GetUp() * self.__WCDUnderglowData.distToUnder;
			end,

			function()
				return self:LocalToWorld( self.__WCDUnderglowData.center ) + self:GetRight() * ( self.__WCDUnderglowData.distToBack + 15 ) + self:GetUp() * -self.__WCDUnderglowData.distToUnder;
			end,
		};
	end

	local color;
	if( bypass ) then
		color = Vector( bypass.r, bypass.g, bypass.b, 255 );
	else
		color = self:WCD_GetUnderglowColor();
	end

	if( type( color ) != "Vector" ) then return; end

	color = Vector( color.r, color.g, color.b, 255 );

	for i, v in pairs( self.__WCDUnderglowFunc ) do
		local light = DynamicLight( self:EntIndex() + i );
		light.pos = v();
		light.nomodel = true;
		light.brightness = 6;
		light.Decay = 1000;
		light.Size = 88;
		light.DieTime = CurTime() + FrameTime() * 4;

		light.r, light.g, light.b = color.x, color.y, color.z;
	end
end

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.minimal or "minimal" ) );