include('shared.lua')

local m = Material( "models/props_c17/frostedglass_01a" );
function ENT:Initialize()
	self:SetNoDraw( true );
	 WCD.__StopDealer =  WCD.__StopDealer or 0;
end

function ENT:Think()
	if(  WCD.__StopDealer ) then
		if( WCD.__StopDealer >= CurTime() && self:GetNoDraw() ) then
			self:SetNoDraw( false );
		elseif( WCD.__StopDealer <= CurTime() && !self:GetNoDraw() ) then
			self:SetNoDraw( true );
		end
	end
end

local mat = Material( "models/props_combine/com_shield001a" );
function ENT:Draw()
	if( self:GetNoDraw() ) then return; end
	self:DrawModel();

	local _e = self;

	local mins = _e:OBBMins();
	local maxs = _e:OBBMaxs();
	local startpos = _e:GetPos();
	local dir = _e:GetUp();
	local len = 128;
	local dealer = Entity( self:GetNWFloat( "WCD::DealerID" ) );

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = _e
	} )

	local clr = color_white
	if ( tr.Hit ) then
		clr = Color( 255, 0, 0 );
	end

	local pos = self:GetPos() + self:GetUp() * 90;

	local ang = LocalPlayer():GetAngles();
	ang:RotateAroundAxis( ang:Forward(), 90 );
	ang:RotateAroundAxis( ang:Right(), 90 );

	if( dealer && IsValid( dealer ) ) then
		render.SetMaterial( mat );
		render.DrawBeam( self:GetPos(), dealer:GetPos() + Vector( 0, 0, 50 ), 2, 1, 1, color_white );
	end

	cam.Start3D2D( pos, ang, 0.1 );
		draw.SimpleTextOutlined( WCD.Lang.visibleFor .. math.Round( WCD.__StopDealer - CurTime() ) .. "s",
			"WCD::FontVeryLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, color_black );
	cam.End3D2D();

	render.DrawWireframeBox( startpos, self:GetAngles(), mins + Vector( 0, 0, 120 ), maxs, Color( 0, 0, 0, 255 ), true );
	render.DrawWireframeBox( startpos, self:GetAngles(), Vector( mins.x, 160, 118 ), maxs, Color( 0, 0, 0, 255 ), false );
	render.SetMaterial( Material( "color" ) )
	render.DrawBox( startpos, self:GetAngles(), Vector( mins.x, 160, 118 ), maxs, Color( 0, 255, 0, 50 ), false );
	render.DrawBox( startpos, self:GetAngles(), mins, Vector( maxs.x, -maxs.y, 118 ), Color( 255, 0, 0, 120 ), false );
end