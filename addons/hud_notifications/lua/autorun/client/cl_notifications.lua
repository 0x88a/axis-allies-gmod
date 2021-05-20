surface.CreateFont( "NotiFont", {
	font = "Roboto",
	size = 16,
} )

local ScreenPos = ScrH() - 250

local ForegroundColor = Color( 230, 230, 230 )
local BackgroundColor = Color( 27, 27, 28, 180 )

local Colors = {}
Colors[ NOTIFY_GENERIC ] = Color( 52, 73, 94 )
Colors[ NOTIFY_ERROR ] = Color( 192, 57, 43 )
Colors[ NOTIFY_UNDO ] = Color( 41, 128, 185 )
Colors[ NOTIFY_HINT ] = Color( 39, 174, 96 )
Colors[ NOTIFY_CLEANUP ] = Color( 243, 156, 18 )

local LoadingColor = Color( 0, 0, 0, 0 )

local Notifications = {}

local function DrawNotification( x, y, w, h, text, icon, col, progress )
	draw.RoundedBoxEx( 4, x + 30, y, w - 30, h, BackgroundColor, false, true, false, true )

	if progress then
		draw.RoundedBoxEx( 4, x + 26, y, h + ( w - h ) * progress, h, col, true, false, true, false )
	else
		draw.RoundedBoxEx( 4, x + 26, y, h-28, h, col, true, false, true, false )
	end

	draw.SimpleText( text, "NotiFont", x + 32 + 10, y + h / 2, ForegroundColor,
		TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

end

function notification.AddLegacy( text, type, time )
	surface.SetFont( "NotiFont" )

	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		time = CurTime() + time,

		progress = nil,
	} )
end

function notification.AddProgress( id, text, frac )
	for k, v in ipairs( Notifications ) do
		if v.id == id then
			v.text = text
			v.progress = frac
			
			return
		end
	end

	surface.SetFont( "NotiFont" )

	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		time = math.huge,

		progress = math.Clamp( frac or 0, 0, 1 ),
	} )	
end

function notification.Kill( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add( "HUDPaint", "DrawNotifications", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.Icon, v.col, v.progress )

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )
