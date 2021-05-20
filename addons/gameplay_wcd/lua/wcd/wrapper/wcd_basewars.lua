DarkRP = {};
DarkRP.formatMoney = function( x )
	return '$' .. string.Comma( x );
end

local meta = FindMetaTable( "Player" );
function meta:canAfford( x )
	return self:GetMoney() >= x;
end

function meta:addMoney( x )
	if( x < 0 ) then
		self:TakeMoney( x );
	else
		self:GiveMoney( x );
	end
end

function meta:getDarkRPVar()
	return self:GetMoney();
end

meta = FindMetaTable( "Vehicle" );
function meta:keysLock()
	self:Fire( "lock" );
end

function meta:keysUnLock()
	self:Fire( "unlock" );
end

function meta:keysOwn( _p )

end

meta = FindMetaTable( "Entity" );
function meta:isDoor()
	if( self.__WCDOwner ) then return true;
	else return self:GetClass():find( "door" ); end
end
