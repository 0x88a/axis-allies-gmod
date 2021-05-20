
CreateClientConVar( "sw_showweather", "1" )

CreateClientConVar( "sw_colormod", "1" , true , false , "Enable colormod when it's cloudy (true/false)" , "0" , "1" )
CreateClientConVar( "sw_colormod_indoors", "0" , true , false , "Enable colormod indoors (true/false)" , "0" , "1" )
CreateClientConVar( "sw_showparticles", "1" , true , false , "Draw particles (true/false)" , "0" , "1" )
CreateClientConVar( "sw_showrainimpact", "1" , true , false , "Draw rain impacts (true/false)" , "0" , "1" )
CreateClientConVar( "sw_rainimpactquality", "1" , true , false , "Rain impact quality (1-4)" , "1" , "4" )
CreateClientConVar( "sw_rainonscreen", "1" , true , false , "Show rain on screen (true/false)" , "0" , "1" )
CreateClientConVar( "sw_vehicleraindrops", "0" , true , false , "Show rain on screen when in vehicles (true/false)" , "0" , "1" )
CreateClientConVar( "sw_showclock", "1" , true , false , "Draw clock (true/false)" , "0" , "1" )
CreateClientConVar( "sw_clocktop", "1" , true , false , "Show HUD at top of screen instead of bottom (true/false)" , "0" , "1" )
CreateClientConVar( "sw_clockstyle", "1" , true , false , "24 hour clock (true/false)" , "0" , "1" )
CreateClientConVar( "sw_playsounds", "1" , true , false , "Play sounds (true/false)" , "0" , "1" )
CreateClientConVar( "sw_volume", "0.3" , true , false , "Volume (0-1) sounds should play at (0-1)" , "0" , "1" )
CreateClientConVar( "sw_lightning_hud", "1" , true , false , "Enable lightning flashes (true/false)" , "0" , "1" )

CreateConVar( "sw_autoweather_minstart" , "1" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Minimum time in hours before weather begins." , "1" , "8" )
CreateConVar( "sw_autoweather_maxstart" , "3" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Maximum time in hours before weather begins." , "1" , "8" )
CreateConVar( "sw_autoweather_minstop" , "0.2" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Minimum time in hours before weather stops." , "0" , "8" )
CreateConVar( "sw_autoweather_maxstop" , "8" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Maximum time in hours before weather stops." , "1" , "8" )


-- CreateConVar( "sw_starrotatespeed" , "0.01" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Set the rotation speed of stars" , "0.01" , "5" )
CreateConVar( "sw_mapoutputs" , "1" , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } , "Enable any map-based effects." , "0" , "1" )

local function SWAdminMessage( ply, msg )
	
	if( ply and ply:IsValid() ) then
		
		ply:PrintMessage( 2, msg )
		
	else
		
		MsgN( msg )
		
	end
	
end

------------------------------

local function Weather( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist , string.lower( game.GetMap( ) ) ) ) then return end

	if( ply and ply:IsValid( ) and !ply:IsAdmin( ) ) then

		ply:PrintMessage( 2 , "You need to be admin to do this!" )
		return

	end

	if( args[1] == "none" ) then

		args[1] = ""

	end

	if( args[1] == "" or SW.Weathers[args[1]] ) then

		SW.SetWeather( args[1] )

	else

		SWAdminMessage( ply , "ERROR: invalid weather type \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_weather", Weather, function( )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist , string.lower( game.GetMap( ) ) ) ) then return { } end

	local tab = { }

	for k, _ in pairs( SW.Weathers ) do

		table.insert( tab , "sw_weather " .. k )

	end

	table.insert( tab, "sw_weather none" )

	return tab

end , "Change the weather." , { FCVAR_DONTRECORD } )

------------------------------

local function StopWeather( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist , string.lower( game.GetMap( ) ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin( ) ) then

		ply:PrintMessage( 2 , "You need to be admin to do this!" )
		return

	end

	SW.SetWeather( "" )

end
concommand.Add( "sw_stopweather" , StopWeather , function( ) return { } end , "Stop the weather." , { FCVAR_DONTRECORD } )

------------------------------

local function AlwaysOutside( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap() ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end

	if( args[1] == "0" ) then

		SW.AlwaysOutside = false

	elseif( args[1] == "1" ) then

		SW.AlwaysOutside = true

	else

		SWAdminMessage( ply, "ERROR: invalid always outside status \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_alwaysoutside" , AlwaysOutside , function( ) return { "sw_alwaysoutside 0" , "sw_alwaysoutside 1" } end, "Always outside on or off." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function AutoWeather( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap() ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end

	if( args[1] == "0" ) then

		SW.AutoWeatherEnabled = false

	elseif( args[1] == "1" ) then

		SW.AutoWeatherEnabled = true

	else

		SWAdminMessage( ply, "ERROR: invalid auto-weather status \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_autoweather", AutoWeather, function( ) return { "sw_autoweather 0", "sw_autoweather 1" } end, "Change auto-weather on or off." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function SetTime( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap() ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end
	
	if( tonumber( args[1] ) and tonumber( args[1] ) >= 0 and tonumber( args[1] ) <= 23 ) then

		SW.SetTime( tonumber( args[1] ) )

	else

		SWAdminMessage( ply, "ERROR: invalid time \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_settime", SetTime, function() return { "sw_settime (0-24)" } end, "Set the time of day." , { FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function RealTime( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap( ) ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end

	if( args[1] == "0" ) then

		SW.Realtime = false

	elseif( args[1] == "1" ) then

		SW.Realtime = true

	else

		SWAdminMessage( ply, "ERROR: invalid real-time status \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_realtime", RealTime, function() return { "sw_realtime 0" , "sw_realtime 1" } end, "Set real-time on or off." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

concommand.Add( "sw_realtimeoffset", RealTimeOffset, function()

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap() ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end
	
	if( tonumber( args[1] ) and tonumber( args[1] ) >= 0 and tonumber( args[1] ) <= 23 ) then

		SW.RealtimeOffset( tonumber( args[1] ) )

	else

		SWAdminMessage( ply, "ERROR: invalid offset time \"" .. tostring( args[1] ) .. "\" specified." )

	end

end , "Set real-time offset." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function StartTime( ply, cmd, args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap() ) ) ) then return end

	if( ply and ply:IsValid() and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end
	
	if( tonumber( args[1] ) and tonumber( args[1] ) >= 0 and tonumber( args[1] ) <= 23 ) then

		SW.StartTime( tonumber( args[1] ) )

	else

		SWAdminMessage( ply, "ERROR: invalid start time \"" .. tostring( args[1] ) .. "\" specified." )

	end

end

concommand.Add( "sw_starttime", StartTime, function()

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist , string.lower( game.GetMap( ) ) ) ) then return { } end

	local tab = { }

	for k, _ in pairs( SW.StartTime ) do

		table.insert( tab , "sw_starttime " .. k )

	end

	table.insert( tab, "sw_starttime 10" )

	return tab

end , "Set start time." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function EnableTime( ply , cmd , args )

	if( CLIENT ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap( ) ) ) ) then return end

	if( ply and ply:IsValid( ) and !ply:IsAdmin() ) then

		ply:PrintMessage( 2, "You need to be admin to do this!" )
		return

	end

	if( args[1] == "0" ) then

		SW.PauseTime( true )

	elseif( args[1] == "1" ) then

		SW.PauseTime( false )

	else

		SWAdminMessage( ply , "ERROR: invalid value \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_enabletime" , EnableTime , function( ) return { "sw_enabletime 0" , "sw_enabletime 1" } end , "Change the passage of time on or off." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD } )

------------------------------

local function ShowWeather( ply , cmd , args )

	if( SERVER ) then return end
	if( table.HasValue( SW.MapBlacklist, string.lower( game.GetMap( ) ) ) ) then return end

	if( args[1] == "0" ) then

		SW.ShowWeather = false

	elseif( args[1] == "1" ) then

		SW.ShowWeather = true

	else

		SWAdminMessage( ply , "ERROR: invalid value \"" .. tostring( args[1] ) .. "\" specified." )

	end

end
concommand.Add( "sw_showweather" , ShowWeather , function( ) return { "sw_showweather 0" , "sw_showweather 1" } end , "Display weather on client." , { FCVAR_ARCHIVE , FCVAR_NEVER_AS_STRING , FCVAR_DONTRECORD , FCVAR_CLIENTCMD_CAN_EXECUTE , FCVAR_CLIENTDLL } )

------------------------------
