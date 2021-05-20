local _allowedRanks = {
	[ "superadmin" ] = true,
	[ "admin" ] = true,
	[ "owner" ] = true,
	[ "founder" ] = true,
	[ "Owner" ] = true,
};

hook.Add( "CanTool", "WCD::DisableTool", function( _p, tr, _ )
	local _e = tr.Entity;
	if( _e && IsValid( _e ) && _e.WCD_GetId && _e:WCD_GetId() != -1 ) then
		return _allowedRanks[ _p:GetUserGroup() ] == true;
	end
end );

hook.Add( "PhysgunPickup", "WCD::DisablePhysgun", function( _p, _e )
	if( _e.WCD_GetId && _e:WCD_GetId() != -1 ) then
		return _allowedRanks[ _p:GetUserGroup() ] == true;
	elseif( _e:GetClass() == "wcd_platform" ) then
		if( ( _p.__WCDCanPhys && _p.__WCDCanPhys > CurTime() ) ) then
			return true;
		else
			return false;
		end
	end
end );

WCD:Print( WCD:Translate( "loadedFile", WCD.Lang.fileNames.phystool or "Physics & Toolgun restrictions" ) );