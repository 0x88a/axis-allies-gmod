------------------------------------------------------------------------*/

/*
* This file shouldn't be modified unless you know what you're doing!
*/

hook.Add( "HUDPaint", "DrawWSSNames", function()

	for i, v in pairs( ents.FindByClass( "wss_*" ) ) do
		if( v:GetPos():Distance( LocalPlayer():GetPos() ) < 200 ) then
			local _pos = v:GetPos() + Vector( 0, 0, 80 );
			_pos = _pos:ToScreen();
			if( LocalPlayer():IsLineOfSightClear( v:GetPos() + Vector( 0, 0, 80 ) ) ) then
				local _name = v:GetNWString( "ShopName", "Unnamed" );
				
				surface.SetFont( "NPC1" );
				local _w, _h = surface.GetTextSize( _name );
				draw.DrawText( _name, "NPC1", _pos.x - ( _w / 2 ) - 3, _pos.y, Color( 0, 0, 0, 255 ), ALIGN_CENTER );
				draw.DrawText( _name, "NPC2", _pos.x - ( _w / 2 ), _pos.y, Color( 255, 255, 255, 255 ), ALIGN_CENTER );
			end
		end
	end

end );

surface.CreateFont( "wssGeneral", { font = "Arial", size = 16, weight = 500 } );
surface.CreateFont( "wssBig", { font = "Arial", size = 16, weight = 550 } );
Shop.__Teams = {};
Shop.__Shops = {};
Shop.__Functions = {};

net.Receive( "Shop::Update", function( len )
    Shop.__Shops = net.ReadTable();
	Shop.__Functions = net.ReadTable();
	
    if( type( Shop.__Shops ) != "table" || #Shop.__Shops == 0 ) then
        Shop.__Shops = {};
    end

    if( Shop.Settings.FullInfo ) then
        Shop:Message( "Shop data received!", 1 );
        Shop:Message( #Shop.__Shops .. " shops", 3 );
    end

    for i, v in pairs( team.GetAllTeams() ) do
        Shop.__Teams[ i ] = team.GetName( i );
    end
end );

for i, v in pairs( team.GetAllTeams() ) do
    Shop.__Teams[ i ] = team.GetName( i );
end

if( Shop.Settings.DrawHalos ) then
	hook.Add( "PreDrawHalos", "ShopHalos", function()
		local _ents = {};
		for i, v in pairs( ents.FindInCone( LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(), 3000, 90 ) ) do
			if( v:GetClass() == "wss_prop" || v:GetClass() == "wss_npc" ) then
				_ents[ #_ents + 1 ] = v;
			end
		end

		if( #_ents > 0 ) then
			halo.Add( _ents, Shop.Colors.HaloColor, 1, 1, 1, true );
		end
	end );
end
/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/