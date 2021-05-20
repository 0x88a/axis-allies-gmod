if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/weapon_doimills")
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
end

SWEP.PrintName = "Mills Bomb"

SWEP.Category = "DoI Sweps"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/doi/v_mills.mdl" 
SWEP.WorldModel = "models/weapons/doi/w_mills.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 4
SWEP.SlotPos = 0
 
SWEP.UseHands = true

SWEP.HoldType = "grenade" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"

SWEP.CSMuzzleFlashes = true

SWEP.Sprint = 0
SWEP.Throw = 0
SWEP.LowThrow = 0

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"

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
if SERVER and self:Ammo1() <= 0 then
self:Remove()
end
Sprint = 0
Throw = 0
LowThrow = 0
return true
end

function SWEP:PrimaryAttack()
if self:Ammo1() <= 0 || not(Throw == 0) || not(Sprint == 0) then return end
self:Throw()
self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
end

function SWEP:SecondaryAttack()
if self:Ammo1() <= 0 || not(LowThrow == 0) || not(Sprint == 0) then return end
self:LowThrow()
self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
end

function SWEP:Throw()
if Throw == 0 then
Throw = 1
end
if Throw == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
Throw = 2
end
if Throw == 2 then
timer.Simple(1.2, function()
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
self:TakePrimaryAmmo(1)
if (!SERVER) then return end
local Forward = self.Owner:EyeAngles():Forward()
local Right = self.Owner:EyeAngles():Right()
local Up = self.Owner:EyeAngles():Up()
local ent = ents.Create( "ent_doimills" )
ent:SetOwner( self.Owner )
if ( IsValid( ent ) ) then
ent:SetPos( self.Owner:GetShootPos() + Forward * 24 + Right * 4 + Up * 2)
ent:SetAngles( self.Owner:EyeAngles() )
ent:Spawn()
local phys = ent:GetPhysicsObject()
phys:SetVelocity(self.Owner:GetAimVector() * 1500)
phys:AddAngleVelocity(Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000)))
ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end
timer.Simple(0.3, function()
if self:Ammo1() > 0 then
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
Throw = 0
end
end)
timer.Simple(0.3, function()
if self:Ammo1() <= 0 then
self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
Throw = 0
end
end)
end)
end
end

function SWEP:LowThrow()
if LowThrow == 0 then
LowThrow = 1
end
if LowThrow == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
LowThrow = 2
end
if LowThrow == 2 then
timer.Simple(1.2, function()
self.Owner:SetAnimation( PLAYER_ATTACK1 )
self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
self:TakePrimaryAmmo(1)
if (!SERVER) then return end
local Forward = self.Owner:EyeAngles():Forward()
local Right = self.Owner:EyeAngles():Right()
local Up = self.Owner:EyeAngles():Up()
local ent = ents.Create( "ent_doimills" )
ent:SetOwner( self.Owner )
if ( IsValid( ent ) ) then
ent:SetPos( self.Owner:GetShootPos() + Forward * 24 + Right * 4 + Up * -10)
ent:SetAngles( self.Owner:EyeAngles() )
ent:Spawn()
local phys = ent:GetPhysicsObject()
phys:SetVelocity(self.Owner:GetAimVector() * 750)
phys:AddAngleVelocity(Vector(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000)))
ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end
timer.Simple(0.3, function()
if self:Ammo1() > 0 then
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
LowThrow = 0
end
end)
timer.Simple(0.3, function()
if self:Ammo1() <= 0 then
self.Weapon:SendWeaponAnim( ACT_VM_HOLSTER )
LowThrow = 0
end
end)
end)
end
end

function SWEP:Reload()
end

function SWEP:Think()
if SERVER then
if (Sprint == 0) and Throw == 0 and LowThrow == 0 and self:Ammo1() > 0 then
if self.Owner:KeyDown(IN_SPEED) and (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT)) then
Sprint = 1
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