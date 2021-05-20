include( "shared.lua" );
function ENT:Draw()
	self:DrawModel();

	if( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 500000 ) then return; end
	local name = self:GetNWString( "WCD::Name", "Unknown name" );
	self.up = self.up or self:OBBMaxs().z + 6;

	local pos = self:GetPos() + self:GetUp() * self.up;
	local ang = LocalPlayer():GetAngles();
	ang:RotateAroundAxis( ang:Forward(), 90 );
	ang:RotateAroundAxis( ang:Right(), 90 );

	cam.Start3D2D( pos, ang, 0.1 );
		draw.SimpleTextOutlined( name, "WCD::FontDealer", 0, 0, color_white,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );
	cam.End3D2D();
end