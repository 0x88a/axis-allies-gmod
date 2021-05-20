include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Use(ply)
	
	ply:ConCommand("bodyman_openmenu")
	self:EmitSound("doors/door1_move.wav", 100, math.random(75,100))
end

function ENT:OnTakeDamage( dmginfo )
	self.health = self.health - dmginfo:GetDamage()

	if self.health <= 0 and BODYMAN.ClosetsCanBreak == true then
		local ed = EffectData()
		ed:SetOrigin( self:GetPos() + self:OBBCenter() )

		util.Effect( "Explosion", ed )

		SafeRemoveEntity( self )
	end
end