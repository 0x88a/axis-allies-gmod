AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()

	self:SetModel( "models/props_junk/metalgascan.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:PhysWake();

end


function ENT:Touch( _e )
	if( _e:IsVehicle() && _e.WCD_GetFuel ) then
		_e:WCD_AddFuel( WCD.Settings.fuelTankAmount );
		self:Remove();
	end
end