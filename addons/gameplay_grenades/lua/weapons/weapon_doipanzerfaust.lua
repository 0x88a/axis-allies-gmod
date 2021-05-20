if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/weapon_doipanzerfaust")
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
end

SWEP.PrintName = "Panzerfaust"

SWEP.Category = "DoI Sweps"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/doi/v_panzerfaust.mdl" 
SWEP.WorldModel = "models/weapons/doi/w_panzerfaust.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 4
SWEP.SlotPos = 0
 
SWEP.UseHands = true

SWEP.HoldType = "rpg" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"

SWEP.CSMuzzleFlashes = true

SWEP.Sprint = 0
SWEP.Shoot = 0
SWEP.IronSightsPos = Vector(-2.635, 0, 0.239)
SWEP.IronSightsAng = Vector(0.3, 0, 7.034)
SWEP.Primary.Cone = 0.02

SWEP.Primary.Sound = Sound("weapons/panzerfaust/panzerfaust_fp.wav")
SWEP.Primary.Damage = 0
SWEP.Primary.TakeAmmo = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Deploy()
if SERVER and self:Ammo1() <= 0 then
self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
end
if self:Ammo1() > 0 then
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
Sprint = 0
Throw = 0
LowThrow = 0
end
end

function SWEP:Holster()
if Shoot == 3 then
self:Remove()
end
Sprint = 0
Shoot = 0
return true
end

function SWEP:PrimaryAttack()
if not(Shoot == 0) and not(Sprint == 0) then return end
self:Shoot()
self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
end

function SWEP:Shoot()
if Shoot == 0 then
Shoot = 1
end
if Shoot == 1 then
if not(self.Weapon:GetNetworkedBool( "Ironsights" )) then
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
if self.Weapon:GetNetworkedBool( "Ironsights" ) then
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_DEPLOYED )
end
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self:EmitSound(Sound(self.Primary.Sound))
self.Owner:ViewPunch( Angle( math.Rand(-1,-0.8) * self.Primary.Recoil, math.Rand(-0.5,0.5) *self.Primary.Recoil, 0 ) )
self.Owner:SetEyeAngles(self.Owner:EyeAngles()+Angle(-2,math.random(-0.5,0.5),0))
if (!SERVER) then return end
local Forward = self.Owner:EyeAngles():Forward()
local Right = self.Owner:EyeAngles():Right()
local Up = self.Owner:EyeAngles():Up()
local ent = ents.Create( "ent_doipanzerfaustrocket" )
ent:SetOwner( self.Owner )
if ( IsValid( ent ) ) then
ent:SetPos( self.Owner:GetShootPos() + Forward * 24 + Right * 8 + Up * -4)
ent:SetAngles( self.Owner:EyeAngles() )
ent:Spawn()
local phys = ent:GetPhysicsObject()
phys:SetVelocity(self.Owner:GetAimVector() * 10000)
ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end
end
timer.Simple(1, function()
if Shoot == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
Shoot = 3
end
end)
end

local IRONSIGHT_TIME = 0.2

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.1
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	if (bIron) then
	self.DrawCrosshair = false
	end
	if not(bIron) then
	self.DrawCrosshair = true
	end
	return pos, ang
	
end

function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.2
	
end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	self.DrawCrosshair = true
	
end

function SWEP:Reload()
self.Weapon:DefaultReload( ACT_VM_RELOAD )
self.NextSecondaryAttack = 0
self:SetIronsights( false )
self.DrawCrosshair = true
Sprint = 0
Shoot = 0
end

function SWEP:Think()
if SERVER then
if (Sprint == 0) and (Shoot == 0) then
if self.Owner:KeyDown(IN_SPEED) and (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT)) then
Sprint = 1
self.NextSecondaryAttack = 0
self:SetIronsights( false )
self.DrawCrosshair = true
end
end
if (Sprint == 1) then
self.Weapon:SendWeaponAnim(ACT_VM_SPRINT_IDLE)
Sprint = 2
end
if (Sprint == 2) then
if self.Owner:KeyReleased(IN_SPEED) then
self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
Sprint = 0
end
end
end
end