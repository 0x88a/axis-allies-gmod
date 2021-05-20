/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

/*
* This file shouldn't be modified unless you know what you're doing!
*/

function Shop:SpawnShops()

    self:Message( "Attempting to spawn shops...", 3 );
    self:GetShops();

    for i, v in pairs( ents.FindByClass( "wss_npc" ) ) do
        v:Remove();
        if( v._spawnent && IsValid( v._spawnent ) ) then
            v._spawnent:Remove();
        end
    end

    for i, v in pairs( ents.FindByClass( "wss_prop" ) ) do
        v:Remove();
        if( v._spawnent && IsValid( v._spawnent ) ) then
            v._spawnent:Remove();
        end
    end

    for i, v in pairs( self.__Shops ) do
        if( v[ "map" ] != game.GetMap() ) then
            continue;
        end
        local _e;
		
        if( tonumber( v[ "npc" ] ) == 1 ) then
            _e = ents.Create( "wss_npc" );
        else
            _e = ents.Create( "wss_prop" );
        end

        local    _ang = string.Explode( " ", tostring( v[ "angle" ] ), false );
        _e:SetPos( v[ "position" ] );

        _e:SetAngles( Angle( tonumber( _ang[ 1 ] ), tonumber( _ang[ 2 ] ), tonumber( _ang[ 3 ] ) ) );

        _e.shopID = v[ "id" ];
        _e:Spawn();
		_e:Setup( v[ "restricted" ], v[ "items" ] );
        _e:SetModel( v[ "model" ] );
		
		if( Shop.Settings.ShowNames ) then
			_e:SetNWString( "ShopName", v[ "name" ] );
		end
		
		timer.Simple( 1, function()
			if( v[ "spawnpos" ] != NULL && v[ "spawnpos" ] != "" && #v[ "spawnpos" ] > 5 ) then
			local _explode = string.Explode( " ", v[ "spawnpos" ], false );
				v[ "spawnpos" ] = Vector( _explode[ 1 ], _explode[ 2 ], _explode[ 3 ] );
				_e._spawnpos = v[ "spawnpos" ];
			end
			
			if( v[ "spawnang" ] != NULL && v[ "spawnang" ] != "" && type( v["spawnang" ] == "userdata" ) ) then
				local _spawnang = string.Explode( " ",    tostring( v[ "spawnang" ] ), false );
				_e._spawnang = Angle( tonumber( _spawnang[ 1 ] ), tonumber( _spawnang[ 2 ] ), tonumber( _spawnang[ 3 ] ) );
			end
		end );
		
    end

end


function Shop:AddShop( _tr, _p )

    local _e = ents.Create( "wss_prop" );
    _e:SetPos( _tr.HitPos );
    _e:SetPos( _e:GetPos() + _e:GetUp() * 50 );
    _e:Spawn();
    local _npc = 0;

    local _pos = _e:GetPos():Serialize();
    local _ang = string.Explode( " ", _e:GetAngles():Serialize(), false );
    local _angles = _ang[ 1 ] .. " " .. _ang[ 2 ] .. " " .. _ang [ 3 ];

    self:Message( "Attempting to create shop...", 3 );
    local _q = sql.Query(
    [[INSERT INTO ]] .. self.Settings.Database.ShopTable ..
    [[(position, angle, map, npc, model, items, restricted, name)
    VALUES("]] .. _pos .. [[",
     "]] .. _angles .. [[",
     "]] .. game.GetMap() .. [[",
        ]] ..    _npc .. [[,
     "]] .. _e:GetModel() .. [[",
    "[]", "[]", "No Name" )]])
    _e:Remove();
    if( _q != true && _q != nil && !_q ) then
        self:Message( "Could not create new shop!", 0 );
        self:Message( "SQL Error: ", 0 );
        _p:ChatPrint( "Could not create new shop! Look in the server console!" );
        self:Message( sql.LastError(), 0 );
        return false;
    end

    self:Message( "New shop created!", 1 );
    _p:ChatPrint( "Shop created!" );

    Shop:SpawnShops();
    _e:Remove();
end


function Shop:EditShop( _p, _shop, _values, _e )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
    if( !_dbid || !_tbid ) then
        self:Message( "Received invalid id for EditShop!", 0 );
        return;
    end

    if( !_values || type( _values ) != "table" ) then
        self:Message( "Received invalid values for editShop!", 0 );
        return;
    end

    _e = Entity( _e );

    if( !IsValid( _e ) ) then
        self:Message( "Invalid shop entity!", 0 );
        return;
    end

    self:Message( "Attempting to edit shop with id " .. _dbid .. "...", 3 );

	local _shop = self.__Shops[ _tbid ];
	
    if( _values[ "npc" ] == "yes" ) then
        _values[ "npc" ] = 1;
    else
        _values[ "npc" ] = 0;
    end

    if( _shop == nil ) then
        self:Message( "No shop found with the edit id provided!", 1 );
        return;
    end
    local _pos = _e:GetPos():Serialize();

    local _ang = string.Explode( " ", _e:GetAngles():Serialize(), false );
    local _angles = _ang[ 1 ] .. " " .. _ang[ 2 ] .. " " .. _ang [ 3 ];

    for i, v in pairs( self.__Shops[ _tbid ] ) do
        if( _values[ i ] ) then
            self.__Shops[ _tbid ][ i ] = _values[ i ];
        end
    end

    local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable .. [[
    SET position = "]] .. _pos .. [[",
    angle = "]] .. _angles .. [[",
    map = "]] .. self.__Shops[ _tbid ][ "map" ] .. [[",
    npc = "]] .. self.__Shops[ _tbid ][ "npc" ] .. [[",
    model = "]] .. self.__Shops[ _tbid  ][ "model" ] .. [[",
    name = "]] .. self.__Shops[ _tbid ][ "name" ] .. [[" WHERE id = ]] .. _dbid );

    if( _q != true && _q != nil && !_q ) then
        self:Message( "Could not edit shop!", 0 );
        self:Message( "SQL Error: ", 0 );
        self:Message( sql.LastError(), 0 );
        return;
    else
        self:Message( "Shop " .. _dbid .. " has been updated!", 1 );
        self:SpawnShops();
    end


end

function Shop:RemoveShop( _shop, _p )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	if( !_dbid || !_tbid ) then
		self:Message( "Couldn't remove shops!", 0 );
		return;
	end

    local _q = sql.Query( "DELETE FROM " .. self.Settings.Database.ShopTable .. " WHERE id = " .. _dbid .. "" );
    if( _q != true && _q != nil && !_q ) then
        self:Message( "Could not delete shop!", 0 );
        self:Message( "SQL Error: ", 0 );
        self:Message( sql.LastError(), 0 );
        return;
    else
        self:Message( "Shop " .. _dbid .. " deleted!", 1 );
		_p:ChatPrint( "Shop deleted!" );
		self:SpawnShops();
    end

end

function Shop:UpdateSpawnPos( _e, _p )

    if( !IsValid( _e ) || _e._spawnent == nil || !IsValid( _e._spawnent ) ) then
        self:Message( "Trying to modify an invalid shop!", 0 );
        return;
    end

    local _id = _e.shopID;
    local _spawnpos = _e._spawnent:GetPos():Serialize();
    local _spawnang = string.Explode( " ", _e._spawnent:GetAngles():Serialize(), false );
    local _angles = _spawnang[ 1 ] .. " " .. _spawnang[ 2 ] .. " " .. _spawnang[ 3 ];
	
    self.Message( "Attempting to update spawn position for " .. _id .. ".", 3 );
    local _q = sql.Query(
    [[UPDATE ]] .. self.Settings.Database.ShopTable .. [[ SET spawnpos = "]]
    .. _spawnpos .. [[", spawnang = "]] .. _angles .. [[" WHERE id = ]] .. _id );

    if( _q != true && _q != nil && !_q ) then
        self:Message( "Could not set spawn position!", 0 );
        self:Message( "SQL Error: ", 0 );
        self:Message( sql.LastError(), 0 );
	_p:ChatPrint( "Could not set spawn position! Look in the server console!" );
        return;
    else
        self:Message( "Updated spawn position for shop " .. _id .. ".", 1 );
	_p:ChatPrint( "Spawn position saved!" );
        _e:RemovePos();
        self:SpawnShops();
    end

end

function Shop:GetShops()
    self:Message( "Getting the shops...", 3 );
    self.__Shops = nil;
    self.__Shops = {};
    local _q = sql.Query(
    [[SELECT * FROM ]] .. self.Settings.Database.ShopTable .. [[ WHERE map = "]] .. game.GetMap() .. [["]] );

    if( _q != true && _q != nil && !_q ) then
        self:Message( "Could not get shops!", 0 );
        self:Message( "SQL Error: ", 0 );
        self:Message( sql.LastError(), 0 );
        return false;
    elseif( _q == nil ) then
        self:Message( "No shops found!", 2 );
        self:Update();
        return false;
    else
        self.__Shops = _q;	
        
        for i, v in pairs( self.__Shops ) do
			
			if( v[ "items" ] == "[]" ) then
				v[ "items" ] = {};
			else
				v[ "items" ] = util.JSONToTable( v[ "items" ] );
			end
			
			if( v[ "restricted" ] == "[]" ) then
				v[ "restricted" ] = {};
				v[ "restricted" ][ "jobs" ] = {};
				v[ "restricted" ][ "ranks" ] = {};
			else
				v[ "restricted" ] = util.JSONToTable( v[ "restricted" ] );
				if( !v[ "restricted" ][ "jobs" ] && !v[ "restricted" ][ "ranks" ] ) then
					v[ "restricted" ] = {};
					v[ "restricted" ][ "jobs" ] = {};
					v[ "restricted" ][ "ranks" ] = {};
				end
			end	
			
            local _explode = string.Explode( " ", v[ "position" ], false );
            v[ "position" ] = Vector( _explode[ 1 ], _explode[ 2 ], _explode[ 3 ] );
 
        end
        self:Message( "Found " .. #self.__Shops .. " shops!", 1 );
    end
    self:Update();
end

function Shop:AddTeam( _t, _shop, _p )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	
	if( !self.__Shops[ _tbid ] ) then
		_p:ChatPrint( "Invalid shop!" );
		return;
	end
	
	self:Message( "Attempting to add team " .. team.GetName( _t ) .. " to shop " ..  _shop, 3 );
	
	local _restricted = self.__Shops[ _tbid ].restricted;
	if( _restricted == nil || type( _restricted ) != "table" ) then
		_restricted = {};
		_restricted[ "jobs" ] = {};
		_restricted[ "ranks" ] = {};
	end
	
	table.insert( _restricted[ "jobs" ], _t );
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET restricted = ']] .. util.TableToJSON( _restricted ) .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not add team to shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		return false;
	end
	
	self:Message( "Team added to shop " ..  _shop .. "!", 1 );
	_p:ChatPrint( "Team added!" );
	self.__Shops[ _tbid ].restricted = _restricted;
	self:SpawnShops();
	net.Start( "Shop::AddTeam" );
	net.Send( _p );
end

function Shop:RemoveTeam( _t, _shop, _p )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	
	if( !self.__Shops[ _tbid ] ) then
		_p:ChatPrint( "Invalid shop!" );
		return;
	end
	
	self:Message( "Attempting to remove team " .. team.GetName( _t ) .. " from shop " ..  _shop, 3 );
	
	local _restricted = self.__Shops[ _tbid ].restricted;
	if( _restricted == nil || type( _restricted ) != "table" ) then
		_restricted = {};
		_restricted[ "jobs" ] = {};
		_restricted[ "ranks" ] = {};
	end
	
	table.RemoveByValue( _restricted[ "jobs" ], _t );
	
	if( #_restricted[ "jobs" ] > 0 || #_restricted[ "ranks" ] > 0 ) then
		_restricted = util.TableToJSON( _restricted );
	else
		_restricted = "[]";
	end
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET restricted = ']] .. _restricted .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not remove team from shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		_p:ChatPrint( "Could not remove team!" );
		return false;
	end
	
	self:Message( "Team removed from shop " ..  _dbid .. "!", 1 );
	_p:ChatPrint( "Team removed!" );
	self.__Shops[ _tbid ].restricted = _restricted;
	self:SpawnShops();
	net.Start( "Shop::AddTeam" );
	net.Send( _p );
end

function Shop:CopyItems( _from, _to, _p )

	local _fromId = false;
	local _toId = false;
	
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _from ) ) then
		
			_fromId = i;
			
		elseif( tonumber( v.id ) == tonumber( _to ) ) then
		
			_toId = i;
		
		end
	end	
	
	if( !_fromId || !_toId ) then
		_p:ChatPrint( "Could not copy!" );
		return;
	end
	
	for i, v in pairs( self.__Shops[ _fromId ].items ) do
		self:AddItem( v[ 1 ], v[ 2 ], v[ 3 ], v[ 5 ], v[ 4 ], _to, _p );
	end

	
end

function Shop:AddItem( _func, _name, _ent, _price, _cat, _shop, _p )
	
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	if( !_tbid ) then
		__p:ChatPrint( "Shop not found!" );
		self:Message( "Shop not found!", 0 );
		return;
	end
	
	self:Message( "Attemping to add a new item to shop " .. _dbid, 3 );
	
	local _funcValid = false;
	
	for i, v in pairs( self.Functions ) do
		if( v.name == _func ) then
			_funcValid = true;
			continue;
		end
	end
	
	if( !_funcValid ) then
		self:Message( "Invalid function set for item!", 0 );
		return;
	end
	
	if( _name:match( "[^%w%s()_,.!?-]" ) != nil ) then
		self:Message( "Invalid item name!", 0 );
		return;
	end
	
	
	if( !isnumber( tonumber( _price ) ) ) then
		self:Message( "Invalid item price!", 0 );
		return;
	end
	
	_shop = self.__Shops[ _tbid ];
	local _items = _shop.items;
	
	if( !_items || type( _items ) != "table" ) then
		_items = {};
	end
	
	
	_items[ #_items + 1 ] = { _func, _name, _ent, _cat, _price };
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET items = ']] .. util.TableToJSON( _items ) .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not add item to shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		_p:ChatPrint( "Could not add item!" );
		return false;
	end
	
	self:Message( "Added item " .. _name .. " successfully!", 1 );
	_p:ChatPrint( "Item added!" );
	
	self:SpawnShops();	

end

function Shop:RemoveItem( _id, _shop, _p )

	
	
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end

	end
	
	if( !_tbid || !_dbid ) then
		print( "Shop id:" .. _shop );
		_p:ChatPrint( "Shop not found!" );
		self:Message( "Shop not found!", 0 );
		return;
	end
	self:Message( "Attempting to remove item with id " .. _id .. " from shop " .. _dbid, 3 );
	local _items = self.__Shops[ _tbid ].items;
	
	if( !_items || !_items[ _id ] ) then
		_p:ChatPrint( "Shop items doesn't exist!" );
		self:Message( "Shop items doesn't exist!", 1 );
		return;
	end
	
	_items[ _id ] = nil;
	
	if( #_items > 0 ) then
		_items = util.TableToJSON( _items );
	else
		_items = "[]";
	end
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET items = ']] .. _items .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not remove item from shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		_p:ChatPrint( "Could not remove item!" );
		return false;
	end
	
	self:Message( "Removed item " .. _id .. " successfully!", 1 );
	_p:ChatPrint( "Item removed!" );
	
	self:SpawnShops();		

end


function Shop:AddRank( _t, _shop, _p )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	
	if( !self.__Shops[ _tbid ] ) then
		_p:ChatPrint( "Invalid shop!" );
		return;
	end
	
	self:Message( "Attempting to add rank " .. _t .. " to shop " ..  _shop, 3 );
	
	local _restricted = self.__Shops[ _tbid ].restricted;
	if( _restricted == nil || type( _restricted ) != "table" ) then
		_restricted = {};
		_restricted[ "jobs" ] = {};
		_restricted[ "ranks" ] = {};
	end
	
	table.insert( _restricted[ "ranks" ], _t );
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET restricted = ']] .. util.TableToJSON( _restricted ) .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not add rank to shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		return false;
	end
	
	self:Message( "Rank added to shop " ..  _shop .. "!", 1 );
	_p:ChatPrint( "Rank added!" );
	self.__Shops[ _tbid ].restricted = _restricted;
	self:SpawnShops();
	net.Start( "Shop::AddRank" );
	net.Send( _p );
end

function Shop:RemoveRank( _t, _shop, _p )

	// Shop is the DB ID
	local _tbid = false;
	local _dbid = false;
	for i, v in pairs( self.__Shops ) do
		if( tonumber( v.id ) == tonumber( _shop ) ) then
		
			_tbid = i;
			_dbid = v.id;
			
		end
	end
	
	
	if( !self.__Shops[ _tbid ] ) then
		_p:ChatPrint( "Invalid shop!" );
		return;
	end
	
	self:Message( "Attempting to remove team " .. team.GetName( _t ) .. " from shop " ..  _shop, 3 );
	
	local _restricted = self.__Shops[ _tbid ].restricted;
	if( _restricted == nil || type( _restricted ) != "table" ) then
		_restricted = {};
		_restricted[ "jobs" ] = {};
		_restricted[ "ranks" ] = {};
	end
	
	table.RemoveByValue( _restricted[ "ranks" ], _t );
	
	if( #_restricted[ "jobs" ] > 0 || #_restricted[ "ranks" ] > 0 ) then
		_restricted = util.TableToJSON( _restricted );
	else
		_restricted = "[]";
	end
	
	local _q = sql.Query( [[UPDATE ]] .. self.Settings.Database.ShopTable ..
	[[ SET restricted = ']] .. _restricted .. [[' WHERE id = ]] .. _dbid );
	
	if( _q != true && _q != nil && !_q ) then
		self:Message( "Could not remove rank from shop!", 0 );
		self:Message( "SQL Error: ", 0 );
		self:Message( sql.LastError(), 0 );
		_p:ChatPrint( "Could not remove rank!" );
		return false;
	end
	
	self:Message( "Rank removed from shop " ..  _dbid .. "!", 1 );
	_p:ChatPrint( "Rank removed!" );
	self.__Shops[ _tbid ].restricted = _restricted;
	self:SpawnShops();
	
	net.Start( "Shop::AddRank" );
	net.Send( _p );
end


// Net.Receive \\

net.Receive( "Shop::AddRank", function( len, _p )
	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	
	local _rank = net.ReadString();
	local _shop = net.ReadFloat();
	Shop:AddRank( _rank, _shop, _p );
end );

net.Receive( "Shop::RemoveRank", function( len, _p )
	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	
	local _rank = net.ReadString();
	local _shop = net.ReadFloat();
	Shop:RemoveRank( _rank, _shop, _p );
end );

net.Receive( "Shop::Copy", function( len, _p )
	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	local _from = net.ReadFloat();
	local _to = net.ReadFloat();
	Shop:CopyItems( _from, _to, _p );
end );

net.Receive( "Shop::RemoveItem", function( len, _p )
	
	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	local _itemIndex = net.ReadFloat();
	local _shopId = net.ReadFloat();
	Shop:RemoveItem( _itemIndex, _shopId, _p );
	
end );

net.Receive( "Shop::AddItem", function( len, _p )

	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	
	Shop:AddItem( net.ReadString(), net.ReadString(), net.ReadString(), net.ReadString(), net.ReadString(), net.ReadFloat(), _p );
	
end );

net.Receive( "Shop::RemoveTeam", function( len, _p )

	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	
	local _team = net.ReadFloat();
	local _shop = net.ReadFloat();
	
	if( !team.GetName( _team ) ) then
		_p:ChatPrint( "Team doesn't exist!" );
		return false;
	end
	
	Shop:RemoveTeam( _team, _shop, _p );

end );

net.Receive( "Shop::AddTeam", function( len, _p )

	if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
		_p:ChatPrint( Shop.Messages.CommandNoAccess );
		return;
	end
	
	local _team = net.ReadFloat();
	local _shop = net.ReadFloat();
	
	if( !team.GetName( _team ) ) then
		_p:ChatPrint( "Team doesn't exist!" );
		return false;
	end
	
	Shop:AddTeam( _team, _shop, _p );

end );

net.Receive( "Shop::RemoveShop", function( len, _p )
    if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
        _p:ChatPrint( Shop.Messages.CommandNoAccess );
        return;
    end

    Shop:RemoveShop( net.ReadFloat(), _p );


end );

net.Receive( "Shop::RemoveAllShops", function( len, _p )
    if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
        _p:ChatPrint( Shop.Messages.CommandNoAccess );
        return;
    end

    if( #Shop.__Shops == 0 ) then
        _p:ChatPrint( "There's no shops to remove!" );
        return;
    end

    if( Shop.Settings.FullInfo ) then
        Shop:Message( "Attempting to remove all " .. #Shop.__Shops .. " shops...", 3 );
    end

    for i, v in pairs( Shop.__Shops ) do
        Shop:RemoveShop( v.id, _p );
    end


end );

net.Receive( "Shop::RespawnAllShops", function( len, _p )
    if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
        _p:ChatPrint( Shop.Messages.CommandNoAccess );
        return;
    end

    if( #Shop.__Shops == 0 ) then
        _p:ChatPrint( "There's no shops to respawn!" );
        return;
    end

    if( Shop.Settings.FullInfo ) then
        Shop:Message( "Attempting to respawn all " .. #Shop.__Shops .. " shops...", 3 );
    end

    Shop:SpawnShops();
end );

net.Receive( "Shop::EditShop", function( len, _p )

    if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
        _p:ChatPrint( Shop.Messages.CommandNoAccess );
        return;
    end

    Shop:EditShop( _p, net.ReadFloat(), net.ReadTable(), net.ReadFloat() );

end );

// End Net.Receive \\



// Hooks \\
hook.Add( "PlayerSay", "Shop::CommandAdmin", function( _p, _t, _tc )

    if( !IsValid( _p ) || !_p:IsPlayer() )    then
        return false;
    end

    if( _t == Shop.Settings.CommandAddShop
        || _t == Shop.Settings.CommandEditShop
        || _t == Shop.Settings.CommandAdmin
        || _t == Shop.Settings.CommandSpawnPos ) then
        if( !table.HasValue( Shop.Settings.Admin, _p:GetUserGroup() ) ) then
            _p:ChatPrint( Shop.Messages.CommandNoAccess );
            return;
        else

            if( _t == Shop.Settings.CommandAddShop ) then
                // Create shop entity
                    local _tr = _p:GetEyeTrace();
                    Shop:AddShop( _tr, _p );

            elseif( _t == Shop.Settings.CommandEditShop ) then
                // Edit shop
                local _tr = _p:GetEyeTrace();

                if( _tr.HitNonWorld && IsValid( _tr.Entity ) && ( _tr.Entity:GetClass() == "wss_npc" || _tr.Entity:GetClass() == "wss_prop" ) ) then

                    net.Start( "Shop::ConfigDerma" );
                        net.WriteFloat( _tr.Entity.shopID );
                        net.WriteFloat( _tr.Entity:EntIndex() );
                    net.Send( _p );
                else
                    _p:ChatPrint( Shop.Messages.CommandNoShop );
                end

            elseif( _t == Shop.Settings.CommandSpawnPos ) then
                // Edit shop
                local _tr = _p:GetEyeTrace();

                if( _tr.HitNonWorld && IsValid( _tr.Entity ) && ( _tr.Entity:GetClass() == "wss_npc" || _tr.Entity:GetClass() == "wss_prop" ) ) then
                    if( _tr.Entity._spawnent != nil ) then
                        Shop:UpdateSpawnPos( _tr.Entity, _p );
                    else
                        _tr.Entity:DefinePos();
			_p:ChatPrint( "Type !editspawnpos while looking at the same shop to save the new spawn position of entities." );
                    end
                else
                    _p:ChatPrint( Shop.Messages.CommandNoShop );
                end
            elseif( _t == Shop.Settings.CommandAdmin ) then

                // Open admin shop
                net.Start( "Shop::AdminDerma" );
                net.Send( _p );

            else
                return false;
            end
            return "";
        end

    end

end );

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/