ENT.Type = "ai";
ENT.Base = "base_ai";
ENT.AutomaticFrameAdvance = true;
ENT.PrintName = "Car Dealer";
ENT.Author = "William";
ENT.Category = "William's Car Dealer";
ENT.Spawnable = false;

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim;
end

function ENT:DisableGarage( bool )
	self:SetNWBool( "WCD::disableGarage", bool );
	self.disableGarage = bool;
end

function ENT:DisableShop( bool )
	self:SetNWBool( "WCD::disableShop", bool );
	self.disableShop = bool;
end

function ENT:GlobalReturn( bool )
	self:SetNWBool( "WCD::globalReturn", bool );
	self.globalReturn = bool;
end

function ENT:GlobalSpawn( bool )
	self:SetNWBool( "WCD::globalSpawn", bool );
	self.globalSpawn = bool;
end

function ENT:DisableCustomization( bool )
	self:SetNWBool( "WCD::disableCustomization", bool );
	self.disableCustomization = bool;
end