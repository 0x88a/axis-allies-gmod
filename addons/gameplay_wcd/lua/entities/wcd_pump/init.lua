AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/gaspump001a.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self.nextUse = CurTime() + 0.5;

	self:GetPhysicsObject():Sleep();
	self:GetPhysicsObject():EnableMotion( false );

	self.handleData = {
		pos = Vector( 0.067935, -17.483, 45.267 ),
		ang = Angle( -3.78, -90.113, 89.474 ),
		ropeSelf = Vector( 0, 6.15, 0 ),
		ropePump = Vector( 0, -17.6, 56 ),
	};
	self:SetupHandle();
end

function ENT:OnRemove()
	if( IsValid( self.handle ) ) then
		self.handle:Remove();
	end
end

function ENT:UnHitchHandle()
	if( !IsValid( self.handle ) ) then return; end
	self.handle:GetPhysicsObject():EnableMotion( true );
	self.handle:GetPhysicsObject():Wake();
	self.handle:SetParent( nil );

	self.unhitchedAt = CurTime();
	self.hitched = false;
end

function ENT:HitchHandle()
	if( !IsValid( self.handle ) ) then return; end
	if( self.handle.weld && IsValid( self.handle.weld ) ) then
		self.handle.weld:Remove();
		self.handle.weld = nil;
	end

	self.hitched = true;
	timer.Simple( 0.25, function()
		self.handle:SetPos( self:LocalToWorld( self.handleData.pos ) );
		self.handle:SetAngles( self:LocalToWorldAngles( self.handleData.ang ) );

		self.handle:SetParent( self );
	end );
end

function ENT:SetupHandle()
	self.handle = ents.Create( "wcd_handle" );
	self.handle:SetPos( self:GetPos() );
	self.handle.parent = self;
	self.handle:Spawn();

	self.rope = constraint.Rope( self.handle, self, 0, 0, self.handleData.ropeSelf,
		self.handleData.ropePump, 250, 0, 0, 0.75, "cable/cable", false );

	self:HitchHandle();
end

function ENT:Stop()
	if( self.sound ) then
		self.sound:Stop();
	end

	self.pumper = nil;
	self.vehicle = nil;

	self:SetNWBool( "WCD::Busy", false );
	self:HitchHandle();
end

function ENT:Start()
	if( self.sound ) then
		self.sound:Stop();
	end

	self:SetNWBool( "WCD::Busy", true );
	self.sound = CreateSound( self.handle, "ambient/waterrun.wav" );
	self:UnHitchHandle();
end

function ENT:Think()
	if( !self.hitched ) then
		if( self.vehicle && IsValid( self.vehicle ) && self.vehicle:GetPos():DistToSqr( self:GetPos() ) < 35000 ) then
			if( !self.pumper:canAfford( WCD.Settings.fuelCost ) ) then
				self.pumper:WCD_Notify( WCD.Lang.various.cantAffordFuel );
				self:Stop();
				return;
			end

			if( self.vehStart && self.vehicle:GetPos():DistToSqr( self.vehStart ) > 10000 ) then
				self:Stop();
				return;
			end

			self.pumper:addMoney( -WCD.Settings.fuelCost );
			self.vehicle:WCD_AddFuel( 1 );

			if( IsValid( self.vehicle:GetDriver() ) ) then
				net.Start( "WCD::SyncFuel" );
				net.WriteFloat( self.vehicle:WCD_GetFuel() );
				net.Send( self.vehicle:GetDriver() );
			end

			if( self.vehicle:WCD_GetFuel() >= self.vehicle:WCD_GetFuelMax() ) then
				self:Stop();
			end
		else
			if( self.unhitchedAt + 10 <= CurTime() ) then
				self:Stop();
			end
		end
	end

	self:NextThink( CurTime() + 0.5 );
	return true;
end

function ENT:Use( _p )
	if( self.nextUse > CurTime() ) then return; end

	self.nextUse = CurTime() + 0.35;
	if( self:GetNWBool( "WCD::Busy", false ) ) then
		if( _p != self.pumper ) then
			_p:WCD_Notify( WCD.Lang.various.inUse );
			return;
		end
	end

	if( self:GetNWBool( "WCD::Busy", false ) ) then
		self:Stop();
	else
		self:Start();
		self.pumper = _p;
	end
end