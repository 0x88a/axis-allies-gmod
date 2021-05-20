print("Initializing Darkrp Bodygroups Manager")

BODYMAN = {}

if SERVER then
	include("bodyman/bodyman_server.lua")
	include("bodyman/bodyman_server_hooks.lua")
	include("bodyman/bodyman_config.lua")

	AddCSLuaFile("bodyman/bodyman_client.lua")
	AddCSLuaFile("bodyman/arizard_derma.lua")
	AddCSLuaFile("bodyman/bodyman_config.lua")
else
	include("bodyman/bodyman_config.lua")
	include("bodyman/bodyman_client.lua")
	include("bodyman/arizard_derma.lua")
end

function InverseLerp( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end

function BODYMAN:HasSkin( ply, skindex )
	local has = true
	local skincount = ply:SkinCount()
	-- skins start at 0 but lua tables start at 1
	-- skincount-1 is last skin
	-- therefore skindex must be between 0 and skincount-1 inclusive
	if skindex > skincount-1 then has = false end
	if skindex < 0 then has = false end

	return has
end

-- need an algorithm which checks if a bodygroups exists for a player
function BODYMAN:HasBodyGroup( ply, name, idx )
	-- PLAYER ply, STRING name, INT idx
	local modelgroups = ply:GetBodyGroups()
	local has = false
	local bgid = -1

	for k,v in ipairs( modelgroups ) do
		if v.name == name then
			bgid = v.id
		end
	end

	if bgid >= 0 then
		-- add 1 to the bgid to get the table index
		-- because lua tables start at 1
		-- but bg ids start at 0

		-- we already know that it exists, because it's been set by the previous for loop.
		-- lets make sure the submodel (idx) exists
		if modelgroups[bgid + 1].submodels[idx] then
			has = true -- we can set it to true if we know it exists
		end
	end

	return has
end

-- For when we are Closets-only
function BODYMAN:CloseEnoughCloset( ply )
	-- check if a player is A) looking at a closet and B) within 128 units.
	local range = 128
	local tr = ply:GetEyeTrace()
	local dist = ply:EyePos():Distance( tr.HitPos )

	if tr.Entity then
		if tr.Entity:GetClass() == "bodyman_closet" then
			if dist <= range then
				return true
			end
		end
	end

	return false

end

function BODYMAN:GetAccessLevel( ply )
	if not ply or not IsValid( ply ) then
		return 100
	end
	local access = BODYMAN.Ranks[ ply:GetUserGroup() ] or 10

	local id64 = ply:SteamID64()
	local id = ply:SteamID()

	if BODYMAN.PlayerAccess[id] then
		access = BODYMAN.PlayerAccess[id]
	end

	if BODYMAN.PlayerAccess[id64] then
		access = BODYMAN.PlayerAccess[id64]
	end
	
	return access or 1
end

function BODYMAN:CanAccessCommand( ply, cmd )
	local access = BODYMAN:GetAccessLevel( ply )
	local perm = BODYMAN.Permissions[ cmd ] or 99
	if access >= perm then
		return true
	else
		return false
	end
end