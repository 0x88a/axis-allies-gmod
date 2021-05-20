AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	self:SetModel( "models/props_c17/TrapPropeller_Lever.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	self:GetPhysicsObject():Sleep();
	self:GetPhysicsObject():EnableMotion( false );
end

function ENT:Think()
	if( !( self.parent && IsValid( self.parent ) ) ) then self:Remove(); return; end

	if( self.parent.hitched ) then return; end

	return true;
end

function ENT:Touch( _e )
	if( !self.parent.hitched && !self.parent.vehicle && _e.WCD_SetFuel && _e:GetPos():DistToSqr( self.parent:GetPos() ) < 35000 ) then
		self.parent.vehicle = _e;
		self.parent.sound:Play();
		self.parent.vehStart = _e:GetPos();
		self.weld = constraint.Weld( self, _e, 0, 0, 0, true, false );
	end
end