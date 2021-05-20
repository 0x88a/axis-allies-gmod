surface.CreateFont( "Conquest_Button1", {
	font = "Open Sans", 
	extended = true,
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

Conquest = Conquest or {}

local circle = Material("nykez/circle.png", "noclamp smooth")
local square = Material("nykez/square.png", "noclamp smooth")

local getMaterials = {}
getMaterials["circle"] = circle
getMaterials["square"] = square

net.Receive("conquest_sync", function()
	Conquest.cache = net.ReadTable()
end)

local function formatScreenVector(scrw, scrh)
	return Vector(scrw/2, 45/2 + 10)
end

local function getTeamCommand(command)
	for k,v in pairs(RPExtraTeams) do

			if v.command == command then

				return v

			end

	end
end

function GetIconColor(flag)
	if (flag.teamBased and flag.teamBased == true) then

		return Conquest.TeamManager.cache[flag.owner] and Conquest.TeamManager.cache[flag.owner].color or Color(255, 255, 255, 255)

	end

	local darkrp = Conquest.Config.get("darkrp", false)
	if (flag.category) then

		if (darkrp) then
			local categories = DarkRP.getCategories().jobs

			for _, cat in pairs(categories) do
				if cat.name == flag.owner then
					return cat.color
				end
			end
		
		else
			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0, 255)
		end
	else
		if (darkrp == true) then

			local team = getTeamCommand(flag.owner)

			if (team) then
				return team.color
			end

			
		else

			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0)

		end
	end

	return Color(255, 0, 0)
end

local function GetLocalColor()
	local ply = LocalPlayer()
	if Conquest.Config.get("darkrp", false) then

		local job = RPExtraTeams[ply:Team()]
		return job.color

	else

		return team.GetColor(ply:Team())

	end
end

function Conquest.Render(point, x, y, distance, visible)
	
	// Player is at/on the flag ?

	-- if type(distance) != "number" or type(point.radius) != "number" then
		
	-- 	print("[[CONQUEST ERROR -> SHOW DEVELOPER]]")
	-- 	print(distance, point.radius)
	-- 	print(game.GetMap())

	-- end


	distance = tonumber(distance)
	point.radius = tonumber(point.radius)

	local atFlag = distance <= point.radius 

	if (atFlag) then
		local fixedVectors = formatScreenVector(ScrW(), ScrH())
		x = fixedVectors.x
		y = fixedVectors.y
	end

	local tx, ty, tw, th = 0, 0, 0, 0
	tw = 45
	th = 45
	tx = x + -tw/2
	ty = y + -th/2

	local outerCircleRadius = (45/2) + 5

	if visible or (not visible and atFlag) then
		if atFlag and point.isCapturing ~= nil then
			local timeCounter = CurTime() - point.isCapturing
			local lerpNormalize = timeCounter / point.time

			if lerpNormalize <= 1 then
				render.ClearStencil()
				render.SetStencilEnable(true)
					render.SetStencilWriteMask( 1 )
					render.SetStencilTestMask( 1 )

					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
					render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilReferenceValue(1)

					surface.SetDrawColor(1, 1, 1)
					Conquest.Circle(x, y, outerCircleRadius+100, 300, lerpNormalize * 360)


					-- draw actual texture
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
					render.SetStencilReferenceValue(1)
					render.SetStencilFailOperation(STENCILOPERATION_ZERO)
					render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)

	
					if !point.shape then
						surface.SetDrawColor(GetLocalColor())
						surface.SetMaterial(square)
						surface.DrawTexturedRect(tx - 5,ty - 5, tw + 10,th + 10)
					else
						surface.SetDrawColor(Color(109, 133, 242))
						surface.SetMaterial(getMaterials[tostring(point.shape)])
						surface.DrawTexturedRect(tx - 5,ty - 5, tw + 10,th + 10)
					end

				
				render.SetStencilEnable(false)

			end
		end
	end



	if point.owner != nil then
		surface.SetDrawColor(GetIconColor(point))
	else
		surface.SetDrawColor(color_white)
	end

	local mat = getMaterials[tostring(point.shape)]

	if !mat or !point.shape then
		mat = square
	end
	
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(tx,ty, tw,th) 

	local outline = Conquest.Config.get("colorOutline", Color(255, 255, 255))
	local name_c = Conquest.Config.get("colorName", Color(255, 255, 255))
	local distance_c = Conquest.Config.get("colorDistance", Color(255, 255, 255))

	draw.SimpleTextOutlined(point.tag,
		Conquest.Config.get("fontTag"),
		x, y,
		outline,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
	1, Color(0,0,0,255))


	if visible or (not visible and atPoint) then

		draw.SimpleTextOutlined(point.name,
			Conquest.Config.get("fontName"),
			x, y + (45/2) + (5),
			name_c,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, Color(0,0,0,255))

		draw.SimpleTextOutlined(math.Round(distance / 100) .. "m",
			Conquest.Config.get("fontDistance"),
			x, y + (45/2) + (10) + (5* 2),
			distance_c,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
			1, Color(0,0,0,255))
	end

end

function Conquest.SetupRender(flag, width, height)
	if !(Conquest.CanVisible(flag)) then return end

	if (LocalPlayer().rendering) then return end

	local screenVectors = flag.position:ToScreen()

	local x, y, visible = screenVectors.x, screenVectors.y, screenVectors.visible

	local plyLook = LocalPlayer():GetAimVector()
	plyLook:Normalize()

	local pos = flag.position

	local pointLook = Vector(pos.x, pos.y, pos.z)
	// Subtract the vector//repalce
	pointLook:Sub(LocalPlayer():GetPos())
	local distance = pointLook:Length()

	pointLook:Normalize()

	// visbile angle checker
	local dotPoint = plyLook:Dot(pointLook) / pointLook:Length()
	local visible = math.deg(math.acos(dotPoint)) < 65

	// Gonna see if this fixes flags not rendering when inside the radius
	local playersInside = ents.FindInSphere(flag.position, flag.radius)

	for k,v in pairs(playersInside) do
		if v:IsPlayer() and v == LocalPlayer() then
			Conquest.Render(flag, x, y, distance, visible)

			return
		end
	end

	if visible then
		// Render the Icon
		Conquest.Render(flag, x, y, distance, visible)
	else

		local useSmart = Conquest.Config.get("useSmartIcons", false)

		if !(useSmart) then return end
		
		local plyLookY = plyLook:Angle().y
		local plyToPointY = pointLook:Angle().y

		local angDiff = math.AngleDifference(plyLookY, plyToPointY)

		-- convert -180 < x < 180 to 0 < x < 360
		if (angDiff < 0) then
			angDiff = 180 + (angDiff + 180)
		end

		-- rotate according to view
		angDiff = angDiff - 90

		local horiz, vert
		local offsetSize = 3

		vert = (height/2) + (( (height-(offsetSize*1.4)) / 2) * math.sin(math.rad(angDiff)))
		horiz = (width/2) + (( (width-offsetSize) / 2) * math.cos(math.rad(angDiff)))

		Conquest.Render(flag, horiz, vert, distance, visible)
	end
end

local function CanDistant(point)
	local maxDistance = Conquest.Config.get("intRenderDist", 1200)

	local dist = point.position:Distance(LocalPlayer():GetPos())

	if dist >= maxDistance then
		return true
	end

end

function Conquest.CanVisible(point)
	local canSeeThrough = Conquest.Config.get("seethrough", false)
	local canRender = Conquest.Config.get("useRenderDist", false)

	if (canSeeThrough) then
		return true
	end

	if (canRender) then
		local canDist = CanDistant(point)

		if (canDist) then
			return false
		end

		return true
	end


	local tr = util.TraceLine( {
		start = EyePos(),
		endpos = point.pos,
		filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
	} )

	return not tr.Hit
	
end

-- thanks for this function <>
function Conquest.Circle( x, y, radius, seg, angle )
	local cir = {}
	if angle == nil then angle = 360 end

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )

		if math.deg(a)*-1 <= angle then
			table.insert( cir, {
				x = x + math.sin( a ) * radius,
				y = y + math.cos( a ) * radius,
				u = math.sin( a ) / 2 + 0.5,
				v = math.cos( a ) / 2 + 0.5
			} )
		end
	end

	if angle ~= 360 then

		table.insert(cir, {
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		})

	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, {
		x = x + math.sin( a ) * radius,
		y = y + math.cos( a ) * radius,
		u = math.sin( a ) / 2 + 0.5,
		v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ConquestCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

hook.Add("PostDrawTranslucentRenderables", 'Conquest_Render', function(dept, sky)

	if (sky) then return end 

	if CONQUEST_MAP and CONQUEST_MAP == true then return end

	local oW, oH = ScrW(), ScrH()

	cam.Start2D()

		for k,v in pairs(Conquest.cache) do


			Conquest.SetupRender(v, oW, oH)

			
		end

	cam.End2D()

	local showRadius = Conquest.Config.get("showRadiusCircle", false)
	local filledCircle = Conquest.Config.get("filledCircleRadius", false)

	if (showRadius) then
	
		for k,v in pairs(Conquest.cache) do

			cam.Start3D2D(v.position + Vector(0, 0, 2), Angle(0, 0, 0), 1 )

				if filledCircle then

					surface.SetDrawColor(GetIconColor(v))
					draw.NoTexture()
					ConquestCircle(0, 0, v.radius, 64 )

				else

					surface.DrawCircle( 0, 0, v.radius, GetIconColor(v))
				end

			cam.End3D2D()

		end

	end


end)
