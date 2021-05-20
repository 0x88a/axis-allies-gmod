local x, y = 0, 0;
local sizeOne, sizeTwo = 25, 250;
/*
	"Top",
	"Bottom",
	"Left",
	"Right"
*/

local margin = 10;

local positionSpecific = {
	{ x = ScrW() / 2 - sizeTwo / 2, y = margin, w = sizeTwo, h = sizeOne, center = true },
	{ x = ScrW() / 2 - sizeTwo / 2, y = ScrH() - sizeOne - margin, w = sizeTwo, h = sizeOne, center = true },
	{ x = margin, y = ScrH() / 2 - sizeTwo / 2, w = sizeOne, h = sizeTwo },
	{ x = ScrW() - margin - sizeOne, y = ScrH() / 2 - sizeTwo / 2, w = sizeOne, h = sizeTwo }
};

net.Receive( "WCD::NitroUsed", function()
	WCD.__UsedNitro = 0;
end );

net.Receive( "WCD::NitroReady", function()
	WCD.__WCDNitroReady = 0;
end );

local halfScr = ScrH() / 2;
hook.Add( "HUDPaint", "WCD::DrawFuel", function()
	local veh = LocalPlayer():GetVehicle();
	if( !IsValid( veh ) || veh:GetNWFloat( "WCD::Id", 0 ) == 0 ) then return; end

	if( WCD.__UsedNitro && WCD.__UsedNitro < halfScr ) then
		draw.SimpleTextOutlined( WCD.Lang.nitroActivated, "WCD::FontNitro", ScrW() / 2,
			ScrH() / 2 - WCD.__UsedNitro, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, HSVToColor( WCD.__UsedNitro % 360, 1, 1 ) );
		WCD.__UsedNitro = Lerp( FrameTime(),  WCD.__UsedNitro, ScrH() / 2 + 200 );
	end

	if( WCD.__WCDNitroReady && WCD.__WCDNitroReady < halfScr ) then
		draw.SimpleTextOutlined( WCD.Lang.nitroReady, "WCD::FontNitro", ScrW() / 2,
			ScrH() / 2 - WCD.__WCDNitroReady, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, HSVToColor( WCD.__WCDNitroReady  % 360, 1, 1 ) );
		WCD.__WCDNitroReady = Lerp( FrameTime(),  WCD.__WCDNitroReady, ScrH() / 2 + 200 );
	end

	local s = WCD.Settings.fuelPos;
	local c = WCD.Colors.hud;
	local fuelVisible = false;
	if( !positionSpecific[ s ] ) then return; end
	local r = positionSpecific[ s ];

	if( WCD.Settings.showFuel && WCD.Settings.fuel && veh.WCD_GetFuel && veh:WCD_GetFuel() >= 0 ) then
		fuelVisible = true;

		local fuel = veh:WCD_GetFuel();
		local max = veh:WCD_GetFuelMax();
		local text = math.Round( fuel, 1 ) .. "/" .. math.Round( max, 0 ) .. WCD.Lang.fuel;
		local w, percentage;
		percentage = ( fuel / max ) * 100;
		local alpha = ( 255 - 2.5 * percentage );

		surface.SetDrawColor( c.bg );
		surface.DrawRect( r.x, r.y, r.w, r.h );

		surface.SetDrawColor( Color( math.Clamp( 255 - ( 7 * percentage ), 0, 255 ),  percentage * 2.5, 0, alpha ) );
		if( r.center ) then
			w = ( r.w / 2 ) * percentage / 100;
			surface.DrawRect( r.x + r.w / 2, r.y, w, r.h );
			surface.DrawRect( r.x + r.w / 2 - w + 1, r.y, w, r.h );

			local y = r.y + r.h / 2;

			draw.SimpleTextOutlined( text, "WCD::FontHUD",
			r.x + r.w / 2, y, ColorAlpha( color_white, alpha + 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, ColorAlpha( color_black, alpha + 50 ) );
		else
			w = r.h * percentage / 100;

			surface.DrawRect( r.x, r.y + ( r.h - w ), r.w, w );
			draw.SimpleTextOutlined( math.Round( percentage, 0 ) .. "%", "WCD::FontHUD",
			r.x + r.w / 2, r.y + r.h + 10, ColorAlpha( color_white, alpha + 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, ColorAlpha( color_black, alpha + 50 ) );
		end

		surface.SetDrawColor( ColorAlpha( c.border, alpha ) );
		surface.DrawOutlinedRect( r.x, r.y, r.w, r.h );
	end

	if( WCD.Settings.showSpeed ) then
		local x, y = r.x, r.y;

		if( fuelVisible ) then
			if( s == 1 ) then
				y = y + r.h + margin;
			elseif( s == 2 ) then
				y = y - r.h - margin;
			elseif( s == 3 ) then
				x = x + r.w + margin;
			elseif( s == 4 ) then
				x = x - r.w - margin;
			end
		end

		local speed = veh:GetVelocity():Length() * 0.056818181;
		local max = 200;

		if( ( WCD.Settings.speedUnits or 1 ) == 1 ) then
			speed = speed * 1.6093;
			max = max * 1.6093;
		end
		speed = math.Clamp( math.Round( speed, 0 ), 0, max );

		local text = speed .. " " .. WCD.Lang.Units[ WCD.Settings.speedUnits or 1 ];

		local percentage = ( speed / max ) * 100;
		local alpha = ( speed * 3 );

		surface.SetDrawColor( c.bg );
		surface.DrawRect( x, y, r.w, r.h );

		surface.SetDrawColor( ColorAlpha( c.speedmeter, alpha ) );
		if( r.center ) then
			w = ( r.w / 2 ) * percentage / 100;
			surface.DrawRect( x + r.w / 2, y, w, r.h );
			surface.DrawRect( x + r.w / 2 - w + 1, y, w, r.h );

			local y = y + r.h / 2;

			draw.SimpleTextOutlined( text, "WCD::FontHUD",
			x + r.w / 2, y, ColorAlpha( color_white, alpha + 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, ColorAlpha( color_black, alpha + 50 ) );
		else
			w = r.h * percentage / 100;

			surface.DrawRect( x, y + ( r.h - w ), r.w, w );
			draw.SimpleTextOutlined( text, "WCD::FontHUD",
			x + r.w / 2, y - 10, ColorAlpha( color_white, alpha + 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, ColorAlpha( color_black, alpha + 50 ) );
		end

		surface.SetDrawColor( ColorAlpha( c.border, alpha ) );
		surface.DrawOutlinedRect( x, y, r.w, r.h );
	end
end );

WCD.UnderglowTracker = {};
hook.Add( "OnEntityCreated", "WCD::UnderglowTracker", function( _e )
	if( _e:IsVehicle() && _e.WCD_GetId && _e:WCD_GetId() != 0 && _e.WCD_ProcessUnderglow ) then
		WCD.UnderglowTracker[ _e ] = true;
	end
end );

hook.Add( "Think", "WCD::Underglow", function()
	if( !LocalPlayer() ) then return; end

	if( input.IsKeyDown( KEY_G )
		&& ( !LocalPlayer().__WCDLastUnderglowToggle || LocalPlayer().__WCDLastUnderglowToggle + 0.5 < CurTime() )
		&& IsValid( LocalPlayer():GetVehicle() )
		&& LocalPlayer():GetVehicle().WCD_GetUnderglow
		&& LocalPlayer():GetVehicle():WCD_GetUnderglowColor() ) then
			LocalPlayer().__WCDLastUnderglowToggle = CurTime();

			net.Start( "WCD::ToggleUnderglow" );
			net.SendToServer();
		end

	for _e, v in pairs( WCD.UnderglowTracker ) do
		if( !IsValid( _e ) || !_e.WCD_ProcessUnderglow ) then
			WCD.UnderglowTracker[ _e ] = nil;
			continue;
		elseif( LocalPlayer():GetPos():DistToSqr( _e:GetPos() ) > 5000000 ) then
			continue;
		end

		_e:WCD_ProcessUnderglow();
		continue;
	end
end );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.visual or "visual" ) );