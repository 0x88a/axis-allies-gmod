include("shared.lua")

surface.CreateFont("bodyman_3d2d_large", {
	font = "Roboto",
	size = 128,
	weight = 800,
	antialias = true
})

surface.CreateFont("bodyman_3d2d_small", {
	font = "Roboto",
	size = 72,
	weight = 800,
	antialias = true
})

function ENT:Draw()
	self:DrawModel()

	local alpha = 255
	local viewdist = BODYMAN.ClosetViewDistance

	-- calculate alpha
	local max = viewdist
	local min = viewdist*0.75

	local dist = LocalPlayer():EyePos():Distance( self:GetPos() )

	if dist > min and dist < max then
		local frac = InverseLerp( dist, max, min )
		alpha = alpha * frac
	elseif dist > max then
		alpha = 0
	end

	local oang = self:GetAngles()
	local opos = self:GetPos()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), -90 )
	ang:RotateAroundAxis( oang:Up(), -4)

	pos = pos + oang:Forward()*14 + oang:Up() * 20 + oang:Right() * 20

	if alpha > 0 then
		cam.Start3D2D( pos, ang, 0.025 )
			draw.SimpleText( BODYMAN.ClosetName, "bodyman_3d2d_large", 0, 0, Color(255,255,255, alpha) )
			draw.DrawText( BODYMAN.ClosetHelpText, "bodyman_3d2d_small", 0, 128, Color(255,255,255, alpha) )
		cam.End3D2D()
	end

end