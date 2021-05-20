AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/Characters/Hostage_01.mdl" );
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:SetSolid(  SOLID_BBOX );
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD );
	self:SetUseType( SIMPLE_USE );
	self:DropToFloor();
	self.nextClick = CurTime() + 1;
	self:SetMaxYawSpeed( 90 );

	self.platforms = {};
end

function ENT:OnRemove()
	for i, v in pairs( self.platforms ) do
		if( v.ent && IsValid( v.ent ) ) then
			v.ent:Remove();
		end
	end
end

function ENT:ApplyData( data )
	self:SetNWString( "WCD::Name", data.name or "Unknown Name" );
	self:SetNWFloat( "WCD::Group", data.group or self.group or -1 );
	self:SetModel( data.model or self:GetModel() or "models/Characters/Hostage_01.mdl" );
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetSolid(  SOLID_BBOX );

	self.group = data.group or self.group or false;
	self.platforms = data.platforms or self.platforms or {};
	local q = self:GetPos();
	self:SetPos( Vector( 0, 0, 0 ) );

	timer.Simple( 0.25, function()
		if( data.pos ) then
			self:SetPos( data.pos );
		else
			self:SetPos( q );
		end

		if( data.disableShop ) then
			self:DisableShop( true );
		end

		if( data.disableGarage ) then
			self:DisableGarage( true );
		end

		if( data.globalReturn ) then
			self:GlobalReturn( true );
		end

		if( data.disableCustomization ) then
			self:DisableCustomization( true );
		end
		
		self:SetPos( self:GetPos() + Vector( 0, 0, 20 ) );

		if( data.ang ) then
			self:SetAngles( data.ang );
		end

		self:SpawnPlatforms();
		self:DropToFloor();
		timer.Simple( 1, function()
			if( !IsValid( self ) ) then return; end

			self:DropToFloor();
			local tr = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Vector( 0, 0, -500 ), filter = self } );
			if( tr.HitWorld ) then
				self:SetPos( tr.HitPos );
			end
		end );
	end );
end

function ENT:AddPlatform()
	local _e = ents.Create( "wcd_platform" );
	_e:SetPos( self:GetPos() + self:GetUp() * ( self:OBBMaxs().z + 15 ) );
	_e:SetNWFloat( "WCD::DealerID", self:EntIndex() );
	_e.__WCDDealer = self;
	_e:Spawn();

	table.insert( self.platforms, { pos = _e:GetPos(), ang = _e:GetAngles(), ent = _e } );
end

function ENT:DeleteAllPlatforms()
	for i, v in pairs( self.platforms ) do
		if( v.ent && IsValid( v.ent ) ) then
			v.ent:Remove();
		end
	end

	self.platforms = {};
end

function ENT:SpawnPlatforms()
	for i, v in pairs( ents.FindByClass( "wcd_platform" ) ) do
		if( v.__WCDDealer == self ) then
			v:Remove();
		end
	end

	for i, v in pairs( self.platforms ) do
		local _e = ents.Create( "wcd_platform" );
		_e:SetPos( v.pos );
		_e:SetAngles( v.ang );
		_e:SetNWFloat( "WCD::DealerID", self:EntIndex() );
		_e.__WCDDealer = self;
		_e:Spawn();
		self.platforms[ i ].ent = _e;

		_e.__WCDNoPhys = true;
	end
end

function ENT:GetSaveData()
	local tbl = {};
	tbl.platforms = {};

	for i, v in pairs( self.platforms ) do
		if( !v.ent || !IsValid( v.ent ) ) then
			self.platforms[ i ] = nil;
			continue;
		end

		tbl.platforms[ i ] = { pos = v.ent:GetPos(), ang = v.ent:GetAngles() };
	end

	tbl.pos = self:GetPos();
	tbl.ang = self:GetAngles();
	tbl.model = self:GetModel();
	tbl.group = self.group;
	tbl.name = self:GetNWString( "WCD::Name", "Unknown Name" );
	tbl.disableShop = self.disableShop;
	tbl.disableGarage = self.disableGarage;
	tbl.globalReturn = self.globalReturn;
	tbl.disableCustomization = self.disableCustomization;

	return tbl;
end

function ENT:GetFreePos()
	local free, pos, ang;
	free = false;

	for i, v in pairs( self.platforms ) do
		if( IsValid( v.ent ) ) then
			local tr = util.TraceHull( {
				start = v.ent:GetPos(),
				endpos = v.ent:GetPos() + self:GetUp() * 60,
				filter = v.ent,
				mins = v.ent:OBBMins(),
				maxs = v.ent:OBBMaxs(),
			} );

			if( !IsValid( tr.Entity ) ) then
				return true, v.ent:GetPos(), v.ent:GetAngles();
			end
		end
	end

	return false;
end

function ENT:AcceptInput( _event, _a, _p )
	if( _p.__WCDLastClick && _p.__WCDLastClick + 0.75 > CurTime() ) then return; end
	_p.__WCDLastClick = CurTime();

	if( !self.group ) then
		_p:WCD_Notify( WCD.Lang.various.noGroup );
		return;
	end

	if( WCD.updateReady && !_p.WCD_HasAdminNotifications && _p:GetUserGroup() ) then
		_p.__SpawnLight = true;
	end

	_p.__WCDLastDealer = self;
	_p.__WCDReceivedVehicles = _p.__WCDReceivedVehicles or {};

	if( !_p.__WCDReceivedVehicles[ self.group ] ) then
		_p:WCD_Notify( WCD.Lang.various.initializing );
		local count = WCD:SendAllDealerVehicles( _p, self.group );
		_p.__WCDReceivedVehicles[ self.group ] = true;

		timer.Simple( math.max( 0.075 * count, 1 ), function()
			net.Start( "WCD::OpenDealer" );
			net.WriteFloat( self:EntIndex() );
			net.Send( _p );
		end );
	else
		net.Start( "WCD::OpenDealer" );
		net.WriteFloat( self:EntIndex() );
		net.Send( _p );
	end
end