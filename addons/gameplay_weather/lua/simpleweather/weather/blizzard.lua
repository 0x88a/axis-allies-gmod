WEATHER.ID = "blizzard";
WEATHER.Sound = "wind";
WEATHER.FogStart = -256;
WEATHER.FogEnd = 512;
WEATHER.FogMaxDensity = 0.7;
WEATHER.FogColor = Color( 255, 255, 255, 255 );
WEATHER.ConVar = { "sw_blizzard", "Blizzard" };

function WEATHER:Think()
	
	if( CLIENT ) then

		if( SW.ShowWeather ) then

			if( GetConVar( "sw_blizzard" ):GetBool() ) then

				local drop = EffectData();
					drop:SetOrigin( SW.ViewPos );
				util.Effect( "sw_blizzard", drop );

			end

		end

	end

end