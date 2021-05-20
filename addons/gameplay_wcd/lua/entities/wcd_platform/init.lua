AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate3x7.mdl" );
	self:DrawShadow( false );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_WORLD );

	self:GetPhysicsObject():Sleep();
	self:GetPhysicsObject():EnableMotion( false );
	self:SetMaterial( "models/debug/debugwhite" );
end