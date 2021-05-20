

-- Variables that are used on both client and server

AddCSLuaFile()

SWEP.Author			= "Busan";
SWEP.Instructions	= "Aim at a vehicle";

SWEP.Spawnable			= true;
SWEP.AdminOnly			= true;
SWEP.UseHands			= true;
SWEP.Category 			= "William's Car Dealer";

SWEP.ViewModel			= "models/weapons/c_pistol.mdl";
SWEP.WorldModel			= "models/weapons/w_Pistol.mdl";

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";

SWEP.AutoSwitchTo		= false;
SWEP.AutoSwitchFrom		= false;

SWEP.PrintName			= "Speed checker";
SWEP.Slot				= 2
SWEP.SlotPos			= 3
SWEP.DrawAmmo			= false

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetHoldType( "pistol" );

end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end


function SWEP:Think()

	self._e = self.Owner:GetEyeTrace().Entity;
	if( self._e && IsValid( self._e ) ) then
		self._speed = self._e:GetVelocity():Length() * 0.056818181;
		if( WCD.Settings.speedUnits == 1 ) then
			self._speed = self._speed * 1.6093;
		end
		self._speed = math.Clamp( math.Round( self._speed, 0 ), 0, 200 );
	end

	if( !SERVER ) then
		return;
	end

	if( self._speed && self._speed >= WCD.Settings.autoWantSpeed && self._e && IsValid( self._e )
		&& self._e.GetDriver && IsValid( self._e:GetDriver() ) && ! ( self._e:GetDriver():isCP() )
		&& !self._e:GetDriver():isWanted() ) then
			self._e:GetDriver():wanted( WCD.Lang.various.speedingWantedReason );
		end

end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:DrawHUD()

	if( self._speed && IsValid( self._e ) ) then
		local text = self._speed .. " " .. WCD.Lang.Units[ WCD.Settings.speedUnits or 1 ];
		local w, h = 250, 25;
		local x, y = ScrW() / 2 - w / 2, ScrH() / 2 + 90;
		local max = 200;
		local percentage = ( self._speed / max );
		local alpha = self._speed * 3;

		surface.SetDrawColor( WCD.Colors.hud.bg );
		surface.DrawRect( x, y, w, h );

		local meter = ( w / 2 ) * percentage;
		surface.SetDrawColor( ColorAlpha( WCD.Colors.hud.speedmeter, alpha ) );
		surface.DrawRect( x + w / 2 - meter, y, meter, h );
		surface.DrawRect( x + w / 2 - 1, y, meter, h );

		surface.SetDrawColor( ColorAlpha( WCD.Colors.hud.border, alpha ) );
		surface.DrawOutlinedRect( x, y, w, h );

		draw.SimpleTextOutlined( text, "WCD::FontHUD", x + w / 2, y + h / 2,
			ColorAlpha( color_white, alpha + 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, ColorAlpha( color_black, alpha + 30 ) );
	end

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	-- Right click does nothing..

end

function SWEP:PrimaryAttack()

	-- Right click does nothing..

end