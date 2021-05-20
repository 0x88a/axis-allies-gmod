ENT.Type = "anim"

ENT.PrintName = "Closet"
ENT.Purpose = "Opens the bodyGroupr menu"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Category = "bodyGroupr"

ENT.WorldModel = "models/props_wasteland/controlroom_storagecloset001a.mdl"

function ENT:Initialize()

	self:SetModel( self.WorldModel )
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
 	
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass( 50 )
	end

	if SERVER then
		self:SetUseType( SIMPLE_USE )
		self.health = BODYMAN.ClosetHealth or 100
	end

end