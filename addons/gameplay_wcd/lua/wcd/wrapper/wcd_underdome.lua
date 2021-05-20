DarkRP = {};
DarkRP.formatMoney = function( x )
	return '$' .. string.Comma( x );
end

local meta = FindMetaTable( "Player" );
function meta:canAfford( x )
	return self:getDarkRPVar() >= x;
end

function meta:addMoney( x )
	if( x < 0 ) then
		self:RemoveItem( "money", -x );
	else
		self:AddItem( "money", x );
	end
end

function meta:getDarkRPVar()
	return self.Data.Inventory[ "money" ];
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
	else return self:GetClass():find("door"); end
end