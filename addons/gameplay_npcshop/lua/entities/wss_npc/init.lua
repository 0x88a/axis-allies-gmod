/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel( "models/mossman.mdl" );
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:SetSolid(  SOLID_BBOX );
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD );
	self:SetUseType( SIMPLE_USE );
	self:DropToFloor();
	self.nextClick = CurTime();
	self:SetMaxYawSpeed( 90 );
	self._items = {};
	self._spawnpos = self:GetPos() + self:GetForward() * 35;
	self._restricted  = {};	
	self._restricted[ "jobs" ] = {};
	self._restricted[ "ranks" ] = {};	
	self._spawnang = self:GetAngles();
	self._spawnent = nil;	

end
function ENT:DefinePos()

	
	if( self._spawnent && self._spawnent != nil && IsValid( self._spawnent ) ) then
		self:RemovePos();
		return;
	end
	
	local _e = ents.Create( "prop_physics" );
	_e:SetModel( "models/maxofs2d/cube_tool.mdl" );
	_e:SetMoveType( MOVETYPE_NONE );
	if( _e:GetPhysicsObject() && IsValid( _e:GetPhysicsObject() ) ) then
		_e:GetPhysicsObject():Sleep();
		_e:GetPhysicsObject():EnableMotion( false );
	end
	_e:SetPos( self._spawnpos );
	_e:SetAngles( self._spawnang );
	_e:Spawn();
	self._spawnent = _e;

end

function ENT:RemovePos()

	if( self._spawnent && IsValid( self._spawnent ) ) then
		self._spawnent:Remove();
		self._spawnent = nil;
	end

end

function ENT:OnRemove()

	self:RemovePos();

end
function ENT:IsShop()
  return true;
end

function ENT:Setup( _restricted, _items )

	if( type( _restricted ) == "table" && ( #_restricted[ "jobs" ] > 0 || #_restricted[ "ranks" ] > 0 ) ) then
		self._restricted = _restricted;
	end

	if( type( _items ) == "table"  && #_items > 0 ) then
		self._items = _items;
	end

end
function ENT:AcceptInput( _event, _a, _p )
	if( _event == "Use" )  then
		if( #self._restricted[ "jobs" ] > 0 || #self._restricted[ "ranks" ] > 0 ) then
			if( #self._restricted[ "ranks" ] > 0 ) then
				if( !table.HasValue( self._restricted[ "ranks" ],  _p:GetUserGroup() )  ) then
					_p:ChatPrint( Shop.Messages.Restricted );
					self.nextClick = CurTime() + 1;
					return;
				else
					net.Start( "Shop::UserDerma" );
					net.WriteFloat( self.shopID );
					net.WriteFloat( self:EntIndex() );
					net.Send( _p );
				end			
			elseif( #self._restricted[ "jobs" ] > 0 ) then
				if( !table.HasValue( self._restricted[ "jobs" ], _p:Team() ) ) then
					_p:ChatPrint( Shop.Messages.Restricted );
				else
					net.Start( "Shop::UserDerma" );
					net.WriteFloat( self.shopID );
					net.WriteFloat( self:EntIndex() );
					net.Send( _p );
				end			
			end
		else
			net.Start( "Shop::UserDerma" );
			net.WriteFloat( self.shopID );
			net.WriteFloat( self:EntIndex() );
			net.Send( _p );
		end
		self.nextClick = CurTime() + 1;
	end
end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/