DarkRP = {};
DarkRP.formatMoney = function( x )
	return '$' .. string.Comma( x );
end

local meta = FindMetaTable( "Player" );
function meta:canAfford( x )
	return self:GetCharacter():HasMoney( x );
end

function meta:addMoney( x )
	if( x < 0 ) then
		self:GetCharacter():TakeMoney( x );
	else
		self:GetCharacter():GiveMoney( x );
	end
end

function meta:getDarkRPVar()
	return self:GetCharacter():GetMoney();
end

meta = FindMetaTable( "Vehicle" );
function meta:keysLock()
	self:Fire( "lock" );
end

function meta:keysUnLock()
	self:Fire( "unlock" );
end

function meta:keysOwn( _p )
	self.nutAccess = self.nutAccess or {};
	self.nutAccess[ _p ] = 3;
end

meta = FindMetaTable( "Entity" );
function meta:isDoor()
	if( self.__WCDOwner ) then return true;
	else return self:GetClass():find("door"); end
end

hook.Add( "CanPlayerAccessDoor", "WCD::NutscriptDoor", function( _p, veh, _ )
	if( veh.__WCDOwner ) then
		return veh.__WCDOwner == _p;
	end
end );