hook.Add( "PlayerSay", "AutoSalute", function( ply, text, public )
	text = string.lower( text ) 
	
	if ply:InVehicle() == true then return end

	if ( text == "/me salutes." or text == "/me salutes" or text == "/me salutes!" or text == "/me salute." ) then
		ply:DoAnimationEvent(ACT_GMOD_TAUNT_SALUTE) -- salute anim
	end
	
	if ( text == "/me waves." or text == "/me waves" or text == "/me wave" or text == "/me wave." ) then
		ply:DoAnimationEvent(ACT_GMOD_GESTURE_WAVE) -- wave anim
	end
	
	if ( text == "/me cheers." or text == "/me cheers" or text == "/me cheer" or text == "/me cheer." ) then
		ply:DoAnimationEvent(ACT_GMOD_TAUNT_CHEER) -- cheer anim
	end
	
	if ( text == "/me laughs." or text == "/me laughs" or text == "/me laugh" or text == "/me laugh." ) then
		ply:DoAnimationEvent(ACT_GMOD_TAUNT_LAUGH) -- laugh anim
	end

	if ( text == "/me bows!" or text == "/me bows" or text == "/me bows." or text == "/me bows with honor and respect." ) then
		ply:DoAnimationEvent(ACT_GMOD_GESTURE_BOW) -- bow anim
	end

	if ( text == "/me dances." or text == "/me dances" or text == "/me dance" or text == "/me dance." ) then
		ply:DoAnimationEvent(ACT_GMOD_TAUNT_MUSCLE) -- dance anim
	end
		
end )

hook.Add("Think", "Don't send client shit", function()
    concommand.Remove( "lua_run" )
    concommand.Remove( "lua_run_cl" )
    concommand.Remove( "lua_openscript" )
    concommand.Remove( "lua_openscript_cl" )
end)

function CW20_DropWeapon(ply, com, args) -- makes you drop your CW 2.0 weapon with all attachments stored on it
	return
end

concommand.Add("cw_dropweapon", CW20_DropWeapon)

concommand.Remove("kill")