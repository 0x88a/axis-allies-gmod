
if CLIENT then
	
	include( "simpleweather/cl_init.lua" )

	-- local function SimpleWeather_Client( CPanel )

		-- CPanel:AddControl("ComboBox", {

			-- ["MenuButton"] = 1 ,
			-- ["Folder"] = "sw_client" ,
			-- ["Options"] = {

				-- ["default"] = {

					-- ["sw_colormod"] = "1",
					-- ["sw_colormod_indoors"] = "0",
					-- ["sw_showparticles"] = "1",
					-- ["sw_showclock"] = "1",
					-- ["sw_clocktop"] = "1",
					-- ["sw_clockstyle"] = "1",
					-- ["sw_playsounds"] = "1",
					-- ["sw_volume"] = "0.3",

				-- }

			-- },

			-- ["CVars"] = {

				-- "sw_colormod" ,
				-- "sw_colormod_indoors" ,
				-- "sw_showparticles" ,
				-- "sw_showclock" ,
				-- "sw_clocktop" ,
				-- "sw_clockstyle" ,
				-- "sw_playsounds" ,
				-- "sw_volume" ,

			-- }

		-- } )

		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Color Mod" , ["Command"] = "sw_colormod" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Color Mod Indoors" , ["Command"] = "sw_colormod_indoors" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Particles" , ["Command"] = "sw_showparticles" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Show Clock" , ["Command"] = "sw_rainimpactquality" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Top Clock" , ["Command"] = "sw_clocktop" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "24 Hour Clock" , ["Command"] = "sw_clockstyle" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Play Sounds" , ["Command"] = "sw_playsounds" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Volume" , ["Command"] = "sw_volume" , ["Min"] = "0" , ["Max"] = "1" , ["Type"] = "float" } )

	-- end

	-- local function SimpleWeather_Rain( CPanel )

		-- CPanel:AddControl("ComboBox", {
			-- ["MenuButton"] = 1 ,
			-- ["Folder"] = "sw_client" ,
			-- ["Options"] = {
				-- ["default"] = {
					-- ["sw_showrainimpact"] = "1",
					-- ["sw_rainimpactquality"] = "1",
					-- ["sw_rainonscreen"] = "1",
					-- ["sw_vehicleraindrops"] = "0",
					-- ["sw_lightning_hud"] = "1",
				-- }
			-- },
			-- ["CVars"] = {
				-- "sw_showrainimpact",
				-- "sw_rainimpactquality",
				-- "sw_rainonscreen",
				-- "sw_vehicleraindrops",
				-- "sw_lightning_hud",
			-- }
		-- } )

		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Impact Particles" , ["Command"] = "sw_showrainimpact" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Screen Effects" , ["Command"] = "sw_rainonscreen" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Vehicle Screen Effects" , ["Command"] = "sw_vehicleraindrops" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Lighting Flashes" , ["Command"] = "sw_lightning_hud" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Rain Quality" , ["Command"] = "sw_rainimpactquality" , ["Min"] = "1" , ["Max"] = "4" , ["Type"] = "int" } )

	-- end

	-- local function SimpleWeather_Time( CPanel )

		-- CPanel:AddControl("ComboBox", {

			-- ["MenuButton"] = 1 ,
			-- ["Folder"] = "sw_time" ,
			-- ["Options"] = {

				-- ["default"] = {

					-- -- ["sw_starrotatespeed"] = "0.01" ,
					-- -- ["sw_starttime"] = "10" ,
					-- -- ["sw_realtime"] = "0" ,
					-- -- ["sw_realtimeoffset"] = "0" ,
					-- ["sw_enabletime"] = "1" ,
					-- ["sw_mapoutputs"] = "1" ,

				-- }

			-- },

			-- ["CVars"] = {

				-- -- "sw_starrotatespeed" ,
				-- -- "sw_starttime" ,
				-- -- "sw_realtime" ,
				-- -- "sw_realtimeoffset" ,
				-- "sw_enabletime" ,
				-- "sw_mapoutputs" ,

			-- }

		-- } )

		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Enable Time" , ["Command"] = "sw_enabletime" } )
		-- -- CPanel:AddControl( "slider" , { ["Label"] = "Start Time" , ["Command"] = "sw_starttime" , ["Min"] = "0" , ["Max"] = "23" , ["Type"] = "int" } )
		-- -- CPanel:AddControl( "checkbox" , { ["Label"] = "Real-Time Clock" , ["Command"] = "sw_realtime" } )
		-- -- CPanel:AddControl( "slider" , { ["Label"] = "Real-Time Offset" , ["Command"] = "sw_realtimeoffset" , ["Min"] = "-12" , ["Max"] = "12" , ["Type"] = "int" } )
		-- -- CPanel:AddControl( "slider" , { ["Label"] = "Star Rotate Speed" , ["Command"] = "sw_starrotatespeed" , ["Min"] = "0.01" , ["Max"] = "3" , ["Type"] = "float" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Map Outputs" , ["Command"] = "sw_mapoutputs" } )

	-- end

	-- local function SimpleWeather_Weather( CPanel )

		-- CPanel:AddControl( "button" , { ["Label"] = "Clear" , ["Command"] = "sw_stopweather" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Fog" , ["Command"] = "sw_weather fog" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Smog" , ["Command"] = "sw_weather smog" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Sandstorm" , ["Command"] = "sw_weather sandstorm" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Rain" , ["Command"] = "sw_weather rain" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Storm" , ["Command"] = "sw_weather storm" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Lightning" , ["Command"] = "sw_weather lightning" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Snow" , ["Command"] = "sw_weather snow" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Blizzard" , ["Command"] = "sw_weather blizzard" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Acid Rain" , ["Command"] = "sw_weather acidrain" } )
		-- CPanel:AddControl( "button" , { ["Label"] = "Meteor Storm" , ["Command"] = "sw_weather meteor" } )

	-- end

	-- local function SimpleWeather_RNGWeather( CPanel )

		-- CPanel:AddControl("ComboBox", {

			-- ["MenuButton"] = 1 ,
			-- ["Folder"] = "sw_weather" ,
			-- ["Options"] = {

				-- ["default"] = {

					-- ["sw_autoweather"] = "1" ,
					-- ["sw_acidrain"] = "0" ,
					-- ["sw_blizzard"] = "0" ,
					-- ["sw_fog"] = "1" ,
					-- ["sw_lightning"] = "0" ,
					-- ["sw_meteor"] = "0" ,
					-- ["sw_rain"] = "1" ,
					-- ["sw_sandstorm"] = "0" ,
					-- ["sw_smog"] = "0" ,
					-- ["sw_snow"] = "0" ,
					-- ["sw_storm"] = "1" ,
					-- ["sw_autoweather_minstart"] = "1" ,
					-- ["sw_autoweather_maxstart"] = "3" ,
					-- ["sw_autoweather_minstop"] = "0.2" ,
					-- ["sw_autoweather_maxstop"] = "8" ,

				-- }

			-- } ,

			-- ["CVars"] = {

				-- "sw_autoweather" ,
				-- "sw_autoweather_minstart" ,
				-- "sw_autoweather_maxstart" ,
				-- "sw_autoweather_minstop" ,
				-- "sw_autoweather_maxstop" ,
				-- "sw_acidrain" ,
				-- "sw_blizzard" ,
				-- "sw_fog" ,
				-- "sw_lightning" ,
				-- "sw_meteor" ,
				-- "sw_rain" ,
				-- "sw_sandstorm" ,
				-- "sw_smog" ,
				-- "sw_snow" ,
				-- "sw_storm" ,

			-- }

		-- } )

		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Auto-Weather" , ["Command"] = "sw_autoweather" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Min. Before Start" , ["Command"] = "sw_autoweather_minstart" , ["Min"] = "1" , ["Max"] = "8" , ["Type"] = "int" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Max Before Start" , ["Command"] = "sw_autoweather_maxstart" , ["Min"] = "1" , ["Max"] = "8" , ["Type"] = "int" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Min. Before Stopping" , ["Command"] = "sw_autoweather_minstop" , ["Min"] = "0" , ["Max"] = "8" , ["Type"] = "float" } )
		-- CPanel:AddControl( "slider" , { ["Label"] = "Max Before Stopping" , ["Command"] = "sw_autoweather_maxstop" , ["Min"] = "1" , ["Max"] = "8" , ["Type"] = "float" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Fog" , ["Command"] = "sw_fog" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Smog" , ["Command"] = "sw_smog" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Sandstorm" , ["Command"] = "sw_sandstorm" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Rain" , ["Command"] = "sw_rain" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Storm" , ["Command"] = "sw_storm" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Heavy Storm" , ["Command"] = "sw_heavystorm" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Lightning" , ["Command"] = "sw_lightning" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Snow" , ["Command"] = "sw_snow" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Blizzard" , ["Command"] = "sw_blizzard" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Acid Rain" , ["Command"] = "sw_acidrain" } )
		-- CPanel:AddControl( "checkbox" , { ["Label"] = "Meteor Storm" , ["Command"] = "sw_meteor" } )

	-- end

	-- hook.Add( "PopulateToolMenu" , "SimpleWeather_Options" , function( )
		-- spawnmenu.AddToolMenuOption( "Options" , "Simple Weather" , "SimpleWeather_Client" , "Client" , "" , "" , SimpleWeather_Client )
		-- spawnmenu.AddToolMenuOption( "Options" , "Simple Weather" , "SimpleWeather_Time" , "Time" , "" , "" , SimpleWeather_Time )
		-- spawnmenu.AddToolMenuOption( "Options" , "Simple Weather" , "SimpleWeather_Weather" , "Weather" , "" , "" , SimpleWeather_Weather )
		-- spawnmenu.AddToolMenuOption( "Options" , "Simple Weather" , "SimpleWeather_RNGWeather" , "Auto-Weather" , "" , "" , SimpleWeather_RNGWeather )
		-- spawnmenu.AddToolMenuOption( "Options" , "Simple Weather" , "SimpleWeather_Rain" , "Rain" , "" , "" , SimpleWeather_Rain )
	-- end )

	-- hook.Add( "PopulateMenuBar", "SimpleWeather_MenuBar", function( menubar )

		-- local m = menubar:AddOrGetMenu( "Simple Weather" )

		-- local hud = m:AddSubMenu( "HUD..." )

		-- hud:SetDeleteSelf( false )

		-- hud:AddCVar( "Show Clock" , "sw_showclock" , "1" , "0" )
		-- hud:AddCVar( "Clock on Top" , "sw_clocktop" , "1" , "0" )
		-- hud:AddCVar( "24-Hour Clock" , "sw_clockstyle" , "1" , "0" )
		-- hud:AddCVar( "Screen effects" , "sw_rainonscreen" , "1" , "0" )
		-- hud:AddCVar( "Screen effects in vehicles" , "sw_vehicleraindrops" , "1" , "0" )
		-- hud:AddCVar( "Lightning Flashes" , "sw_lightning_hud" , "1" , "0" )
		-- hud:AddCVar( "Color Mod" , "sw_colormod" , "1" , "0" )
		-- hud:AddCVar( "Color Mod while Indoors" , "sw_colormod_indoors" , "1" , "0" )

		-- m:AddSpacer( )

		-- -- m:AddCVar( "Pause Time", "sw_enabletime" , "1" , "0" )

		-- local times = m:AddSubMenu( "Time..." )

		-- times:SetDeleteSelf( false )

		-- -- times:AddOption( "Real-Time", function( ) RunConsoleCommand( "sw_realtime" ) end )
		-- times:AddOption( "0000", function( ) RunConsoleCommand( "sw_settime" , "0" ) end )
		-- times:AddOption( "0200", function( ) RunConsoleCommand( "sw_settime" , "2" ) end )
		-- times:AddOption( "0400", function( ) RunConsoleCommand( "sw_settime" , "4" ) end )
		-- times:AddOption( "0600", function( ) RunConsoleCommand( "sw_settime" , "6" ) end )
		-- times:AddOption( "0800", function( ) RunConsoleCommand( "sw_settime" , "8" ) end )
		-- times:AddOption( "1000", function( ) RunConsoleCommand( "sw_settime" , "10" ) end )
		-- times:AddOption( "1200", function( ) RunConsoleCommand( "sw_settime" , "12" ) end )
		-- times:AddOption( "1400", function( ) RunConsoleCommand( "sw_settime" , "14" ) end )
		-- times:AddOption( "1600", function( ) RunConsoleCommand( "sw_settime" , "16" ) end )
		-- times:AddOption( "1800", function( ) RunConsoleCommand( "sw_settime" , "18" ) end )
		-- times:AddOption( "2000", function( ) RunConsoleCommand( "sw_settime" , "20" ) end )
		-- times:AddOption( "2200", function( ) RunConsoleCommand( "sw_settime" , "22" ) end )

		-- -- local timeoffset = m:AddSubMenu( "Time Offset..." )

		-- -- timeoffset:SetDeleteSelf( false )

		-- -- timeoffset:AddOption( "-12", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-12" ) end )
		-- -- timeoffset:AddOption( "-11", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-11" ) end )
		-- -- timeoffset:AddOption( "-10", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-10" ) end )
		-- -- timeoffset:AddOption( "-9", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-9" ) end )
		-- -- timeoffset:AddOption( "-8", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-8" ) end )
		-- -- timeoffset:AddOption( "-7", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-7" ) end )
		-- -- timeoffset:AddOption( "-6", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-6" ) end )
		-- -- timeoffset:AddOption( "-5", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-5" ) end )
		-- -- timeoffset:AddOption( "-4", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-4" ) end )
		-- -- timeoffset:AddOption( "-3", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-3" ) end )
		-- -- timeoffset:AddOption( "-2", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-2" ) end )
		-- -- timeoffset:AddOption( "-1", function( ) RunConsoleCommand( "sw_realtimeoffset" , "-1" ) end )
		-- -- timeoffset:AddOption( "0", function( ) RunConsoleCommand( "sw_realtimeoffset" , "0" ) end )
		-- -- timeoffset:AddOption( "1", function( ) RunConsoleCommand( "sw_realtimeoffset" , "1" ) end )
		-- -- timeoffset:AddOption( "2", function( ) RunConsoleCommand( "sw_realtimeoffset" , "2" ) end )
		-- -- timeoffset:AddOption( "3", function( ) RunConsoleCommand( "sw_realtimeoffset" , "3" ) end )
		-- -- timeoffset:AddOption( "4", function( ) RunConsoleCommand( "sw_realtimeoffset" , "4" ) end )
		-- -- timeoffset:AddOption( "5", function( ) RunConsoleCommand( "sw_realtimeoffset" , "5" ) end )
		-- -- timeoffset:AddOption( "6", function( ) RunConsoleCommand( "sw_realtimeoffset" , "6" ) end )
		-- -- timeoffset:AddOption( "7", function( ) RunConsoleCommand( "sw_realtimeoffset" , "7" ) end )
		-- -- timeoffset:AddOption( "8", function( ) RunConsoleCommand( "sw_realtimeoffset" , "8" ) end )
		-- -- timeoffset:AddOption( "9", function( ) RunConsoleCommand( "sw_realtimeoffset" , "9" ) end )
		-- -- timeoffset:AddOption( "10", function( ) RunConsoleCommand( "sw_realtimeoffset" , "10" ) end )
		-- -- timeoffset:AddOption( "11", function( ) RunConsoleCommand( "sw_realtimeoffset" , "11" ) end )
		-- -- timeoffset:AddOption( "12", function( ) RunConsoleCommand( "sw_realtimeoffset" , "12" ) end )

		-- -- m:AddCVar( "Map Outputs", "sw_mapoutputs" , "1" , "0" )

		-- m:AddSpacer( )

		-- local volume = m:AddSubMenu( "Sounds..." )

		-- volume:SetDeleteSelf( false )

		-- volume:AddCVar( "Sounds" , "sw_playsounds" , "1" , "0" )
		-- volume:AddOption( "33%", function( ) RunConsoleCommand( "sw_volume" , "0.3" ) end )
		-- volume:AddOption( "66%", function( ) RunConsoleCommand( "sw_volume" , "0.6" ) end )
		-- volume:AddOption( "100%", function( ) RunConsoleCommand( "sw_volume" , "1" ) end )

		-- local perf = m:AddSubMenu( "Performance..." )

		-- perf:SetDeleteSelf( false )

		-- perf:AddCVar( "Particles" , "sw_showparticles" , "1" , "0" )
		-- perf:AddCVar( "Rain Impacts" , "sw_showrainimpact" , "1" , "0" )

		-- local rainquality = perf:AddSubMenu( "Rain Quality..." )

		-- rainquality:SetDeleteSelf( false )

		-- rainquality:AddOption( "Low", function( ) RunConsoleCommand( "sw_rainimpactquality" , "1" ) end )
		-- rainquality:AddOption( "Medium", function( ) RunConsoleCommand( "sw_rainimpactquality" , "2" ) end )
		-- rainquality:AddOption( "High", function( ) RunConsoleCommand( "sw_rainimpactquality" , "3" ) end )
		-- rainquality:AddOption( "Ultra", function( ) RunConsoleCommand( "sw_rainimpactquality" , "4" ) end )

		-- m:AddSpacer( )

		-- local rng = m:AddSubMenu( "Start Weather..." )

		-- rng:SetDeleteSelf( false )

		-- rng:AddOption( "Fog", function( ) RunConsoleCommand( "sw_weather" , "fog" ) end )
		-- rng:AddOption( "Smog", function( ) RunConsoleCommand( "sw_weather" , "smog" ) end )
		-- rng:AddOption( "Sandstorm", function( ) RunConsoleCommand( "sw_weather" , "sandstorm" ) end )

		-- rng:AddSpacer( )

		-- rng:AddOption( "Rain", function( ) RunConsoleCommand( "sw_weather" , "rain" ) end )
		-- rng:AddOption( "Storm", function( ) RunConsoleCommand( "sw_weather" , "storm" ) end )
		-- rng:AddOption( "Heavy Storm", function( ) RunConsoleCommand( "sw_weather" , "heavystorm" ) end )
		-- rng:AddOption( "Lightning", function( ) RunConsoleCommand( "sw_weather" , "lightning" ) end )
		
		-- rng:AddSpacer( )

		-- rng:AddOption( "Snow", function( ) RunConsoleCommand( "sw_weather" , "snow" ) end )
		-- rng:AddOption( "Blizzard", function( ) RunConsoleCommand( "sw_weather" , "blizzard" ) end )

		-- rng:AddSpacer( )

		-- rng:AddOption( "Acid Rain", function( ) RunConsoleCommand( "sw_weather" , "acidrain" ) end )
		-- rng:AddOption( "Meteor Storm", function( ) RunConsoleCommand( "sw_weather" , "meteor" ) end )

		-- m:AddOption( "Stop Current Weather", function( ) RunConsoleCommand( "sw_stopweather" ) end )

		-- local rng = m:AddSubMenu( "Auto-Weather..." )

		-- rng:SetDeleteSelf( false )

		-- -- rng:AddCVar( "Enable", "sw_autoweather" , "1" , "0" )

		-- rng:AddSpacer( )

		-- rng:AddCVar( "Fog", "sw_fog" , "1" , "0" )
		-- rng:AddCVar( "Smog", "sw_smog" , "1" , "0" )
		-- rng:AddCVar( "Sandstorm", "sw_sandstorm" , "1" , "0" )

		-- rng:AddSpacer( )

		-- rng:AddCVar( "Rain", "sw_rain" , "1" , "0" )
		-- rng:AddCVar( "Storm", "sw_storm" , "1" , "0" )
		-- rng:AddCVar( "Heavy Storm", "sw_heavystorm" , "1" , "0" )
		-- rng:AddCVar( "Lightning", "sw_lightning" , "1" , "0" )
		
		-- rng:AddSpacer( )

		-- rng:AddCVar( "Snow", "sw_snow" , "1" , "0" )
		-- rng:AddCVar( "Blizzard", "sw_blizzard" , "1" , "0" )

		-- rng:AddSpacer( )

		-- rng:AddCVar( "Acid Rain", "sw_acidrain" , "1" , "0" )
		-- rng:AddCVar( "Meteor Storm", "sw_meteor" , "1" , "0" )

	--end )

else
	
	AddCSLuaFile( )
	include( "simpleweather/sv_init.lua" )
	resource.AddWorkshop( 531458635 )
	
end
