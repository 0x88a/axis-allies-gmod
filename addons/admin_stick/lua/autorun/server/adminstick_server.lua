function ADMINSTICK_GiveStick( ply )
	timer.Simple( 0.5, function()
		if ply:IsAdmin() then
			ply:Give( "admin_stick" )
		end
		if CH_AdminStick.Config.UseULX then
			if table.HasValue( CH_AdminStick.Config.ULXRanks, ply:GetUserGroup() ) then
				ply:Give( "admin_stick" )
			end
		end
	end )
end
hook.Add( "PlayerSpawn", "ADMINSTICK_GiveStick", ADMINSTICK_GiveStick )
hook.Add( "OnPlayerChangedTeam", "ADMINSTICK_GiveStick", ADMINSTICK_GiveStick ) -- DarkRP Special Hook (2.5.0+ Only)
