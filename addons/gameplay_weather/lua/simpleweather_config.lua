
AddCSLuaFile( )

-- Weather settings

SW.ShowWeather 				= true 	-- Display weathers (true/false).
SW.AutoWeatherEnabled 		= false 	-- Enable auto-weather (i.e. automatically cycling between weather) (true/false).
SW.AutoMinTimeStartWeather 	= 1 	-- Minimum time in hours before weather begins.
SW.AutoMaxTimeStartWeather 	= 3 	-- Maximum time in hours before weather begins.
SW.AutoMinTimeStopWeather 	= 0.2 	-- Minimum time in hours before weather stops.
SW.AutoMaxTimeStopWeather 	= 1 	-- Maximum time in hours before weather stops.
SW.AutoWeatherTypes = {
	-- "acidrain" ,
	-- "blizzard" ,
	-- "fog" ,
	-- "lightning" ,
	-- "meteor" ,
	"rain" ,
	-- "sandstorm" ,
	-- "smog" ,
	-- "snow" ,
	"storm" ,
} -- What weather to automatically start. All are on by default.

SW.MapBlacklist = { -- What maps to not run the addon on.
	"act_airport" , -- Indoor
	"act_city" , -- Night
	"act_corp" , -- Night
	"act_crash" , -- Rain
	"act_metro" , -- Indoor
	"act_plaza" , -- Indoor
	"act_rails" , -- Indoor
	"act_snowmax" , -- Snow
	"ahl2_amuse" , -- Night
	"ahl2_canalwar" , -- Night
	"ahl2_icetown" , -- Snow
	"ancientdust_thc16c2" , -- Indoor
	"credits" , -- Special
	"d1_town_04" , -- Indoor
	"d3_citadel_02" , -- Indoor
	"d3_citadel_03" , -- Indoor
	"d3_citadel_04" , -- Indoor
	"d3_citadel_05" , -- Indoor
	"de_crookcounty" , -- Fog
	"de_shanty_v3_fix" , -- Rain
	"de_vangogh_s" , -- Special
	"dod_colmar" , -- Snow
	"dod_wn71" , -- Special
	"dm_agoge_b2" , -- Night
	"dm_arctic_vendetta_sun_v3" , -- Snow
	"dm_arctic_vendetta_snow_v3" , -- Night
	"dm_zeus_redux" , -- Night
	"ep1_c17_00" , -- Indoor
	"ep1_c17_00a" , -- Indoor
	"ep1_citadel_01" , -- Indoor
	"ep1_citadel_02" , -- Indoor
	"ep1_citadel_02b" , -- Indoor
	"ep1_citadel_03" , -- Indoor
	"ep1_citadel_04" , -- Indoor
	"ep2_outland_02" , -- Indoor
	"ep2_outland_03" , -- Indoor
	"ep2_outland_04" , -- Indoor
	"gm_arid_valley_v2_night" , -- Night
	"gm_arena_submerge" , -- Indoor
	"gm_black" , -- Special
	"gm_black_v2" , -- Special
	"gm_black_v2_reflective" , -- Special
	"gm_black_v3" , -- Special
	"gm_black_v3_reflective" , -- Special
	"gm_black_v3_colourable" , -- Special
	"gm_blackmesasigma_night" , -- Night
	"gm_downtown" , -- Night
	"gm_dddustbowl_night" , -- Night
	"gm_dddustbowl2night" , -- Night
	"gm_excess_island_night" , -- Night
	"gm_galactic_rc1" , -- Special
	"gm_geekroom_v2" , -- Indoor
	"gm_greenland" , -- Indoor
	"gm_floatingworlds_ii_night" , -- Night
	"gm_holygarden" , -- Night
	"gm_holygarden_cataclysm" , -- Night
	"gm_longentrepot" , -- Indoor
	"gm_skylife_v1" , -- Night
	"gm_stormfront" , -- Rain
	"gm_sunsetgulch_night" , -- Night
	"gm_traincity_v2_rain" , -- Rain
	"gm_traincity_v2_night" , -- Night
	"fs_gs-teamspeak" , -- Indoor
	"fs_shining" , -- Indoor
	"haj_vinoridge" , -- Night
	"holo_wreck_v3" , -- Special
	"intro" , -- Special
	"proxy_museum" , -- Special
	"rp_cc_caves_01" , -- Indoor
	"rp_ineu_pass_v1b_night" , -- Night
	"rp_junglestorm" , -- Night
	"rp_necro_torrington_v2" , -- Night
	"rp_necro_urban_v1" , -- Snow
	"rp_necro_urban_v2" , -- Snow
	"rp_necro_urban_v3a" , -- Rain
	"rp_necro_urban_v3b" , -- Rain
	"rp_wildwest_sup" , -- Night
	"steamclub_v1" , -- Indoor
	"tetsu0_comp33" , -- Night
	"trp_coastal-sub-facility_v2" , -- Night
	"v92_airship" , -- Indoor
	"v92_auditorium" , -- Indoor
	"v92_basementdweller" , -- Indoor
	"v92_brainarchives" , -- Indoor
	"v92_cyberapartment" , -- Indoor
	"v92_cyberapartment_blue" , -- Indoor
	"v92_cyberapartment_green" , -- Indoor
	"v92_ratloft" , -- Indoor
	"v92_steptest" , -- Special
	"v92_toysoldiers" , -- Indoor
	"v92_toyhouse_night" , -- Indoor
}

SW.AlwaysOutside			= false	-- Should players be considered outside at all times (ie. if you want snow in an indoor map)? (true/false)

SW.RainOnScreen				= true 	-- Show rain on screen (true/false).
SW.RainOnScreenMinSize		= 20 	-- Minimum size of the raindrops on screen.
SW.RainOnScreenMaxSize		= 40 	-- Maximum size of the raindrops on screen.
SW.VehicleRaindrops			= false	-- Show rain on screen when in vehicles (true/false).

SW.RainSplashes 			= true 	-- Make rain splash particle effect (true/false).
SW.RainSmoke 				= true 	-- Make rain steam particle effect (true/false).

SW.ThunderMinDelay 			= 10	-- Minimum delay in seconds to cause lightning/thunder while stormy.
SW.ThunderMaxDelay 			= 30 	-- Maximum delay in seconds to cause lightning/thunder while stormy.
SW.LightningEnabled			= true 	-- Enable lightning flashes (true/false).

SW.ColormodEnabled			= true 	-- Enable colormod when it's cloudy (true/false).
SW.ColormodIndoors			= false	-- Enable colormod when there's a roof over your head (true/false).

SW.VolumeMultiplier			= 1 	-- Volume (0-1) sounds should play at. Change it if the rain's too loud!

SW.FogDayDensity			= 0.2		-- Fog max density (0-1) during the day.
SW.FogNightDensity			= 0.1	-- Fog max density (0-1) during the night.
SW.FogIndoors				= false	-- Enable fog when you have a roof over your head (true/false).
SW.FogSpeed					= 0.01	-- Speed at which fog appears and disappears (default 0.01). Decrease to make fog changes slower.


-- Day/Night settings

SW.StartTime				= 10	-- What time to start at on server launch (0-24).

SW.Realtime					= false	-- Should time pass according to the server's time. (true/false)
SW.RealtimeOffset			= 0		-- If realtime is on, add this many timezones. For example, if the server was GMT and you set this to -5, it'd be EST ingame.
SW.DayTimeMul 				= 0.01	-- Multiplier of time during the day. Make this bigger for time to go faster, and smaller for time to go slower.
SW.NightTimeMul 			= 0.02	-- Multiplier of time during the night. Make this bigger for time to go faster, and smaller for time to go slower.

SW.UpdateLighting			= true	-- Enable map lighting updates (true/false). Turn this off if the map's a night map already!
SW.UpdateSun				= true	-- Enable sun moving through the sky (true/false).
SW.UpdateSkybox				= true	-- Enable the skybox to change color through the day (true/false).
SW.UpdateFog				= true	-- Turn off fog at night. Prevents weird light fog at night - turn it off if weird stuff happens.
SW.FireOutputs				= true	-- Enable any map-based effects, like lampposts turning off and on (true/false).

SW.ClientUpdateDelay		= 1		-- Delay in seconds between updating the time on the client.
SW.SunUpdateDelay			= 1		-- Delay in seconds between updating the sun position. Setting this to a smaller number will allow smoother sun movement, but doing this also causes lag.
SW.SkyUpdateDelay			= 0.1	-- Delay in seconds between updating the sky colors. Setting this to a smaller number will allow smoother transitions, but doing this also causes lag.

SW.MaxDarkness				= "b"	-- Maximum darkness level during night. Increase to add light. "a" is darkest, "z" is lightest (a-z).
SW.MaxLightness				= "y"	-- Maximum lightness level at noon on a clear day. Decrease to decrease light. "a" is darkest, "z" is lightest (a-z).
SW.MaxLightnessStorm		= "j"	-- Maximum lightness level at noon on a stormy day. Decrease to decrease light. "a" is darkest, "z" is lightest (a-z).

SW.StarRotateSpeed			= 0.01	-- How fast to rotate the stars at night. Make this smaller for slower rotation (0-1).

-- Clock HUD

SW.ShouldDrawClock			= false	-- Should draw clock at all
SW.ClockTop					= true	-- Show HUD at top of screen instead of bottom
SW.Clock24					= false -- 24 hour clock

-- Misc settings

SW.ChatCommand 				= "!weatheroptions" -- Chat command to use to open client config window.
SW.DisplayAtStart			= false -- Show info on opening config when a player joins the server

SW.ULXPermission			= { "admin" , "superadmin" , "owner" }	-- Group(s) to give ULX permissions by default, if using ULX

-- Particle configuration settings
-- Messing with this can make some weather work incorrectly... Be sure to make a backup if you change these!

SW.MaxParticles				= 1500 	-- Maximum number of particles to create at any one time.

SW.RainRadius				= 500 	-- Radius of rain effect.
SW.RainCount				= 20 	-- Amount of particles in rain effect. Make this smaller to increase performance.
SW.RainDieTime				= 3 	-- Time in seconds until rain vanishes.

SW.StormRadius				= 500 	-- Radius of storm effect.
SW.StormCount				= 120 	-- Amount of particles in storm effect. Make this smaller to increase performance.
SW.StormDieTime				= 1 	-- Time in seconds until rain vanishes.

SW.RainHeightMax			= 300 	-- Maximum height to make rain.

SW.SnowRadius				= 1200 	-- Radius of snow effect.
SW.SnowCount				= 20 	-- Amount of particles in snow effect. Make this smaller to increase performance.
SW.SnowDieTime				= 5 	-- Time in seconds until snow vanishes.

SW.SnowHeightMax			= 200 	-- Maximum height to make snow.

SW.BlizzardRadius			= 1000 	-- Radius of blizzard effect.
SW.BlizzardCount			= 30 	-- Amount of particles in blizzard effect. Make this smaller to increase performance.
SW.BlizzardDieTime			= 2 	-- Time in seconds until blizzard vanishes.
SW.BlizzardHeightMax		= 100 	-- Maximum height to make blizzard snow.

SW.LeaveSnowOnGround		= true	-- Leave snow on the ground (true/false).
