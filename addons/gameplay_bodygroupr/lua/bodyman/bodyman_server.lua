

util.AddNetworkString("bodygroups_change")
util.AddNetworkString("skins_change")
util.AddNetworkString("bodyman_chatprint")
util.AddNetworkString("bodyman_model_change")

function BODYMAN:ChatPrint( ply, msg )
	if IsValid( ply ) then
		net.Start( "bodyman_chatprint" )
		net.WriteString( msg )
		net.Send( ply )
	else
		self:Log( msg )
	end
end

hook.Add("PlayerInitialSpawn", "GiveBodygroupsTable", function(ply)
	ply.bodygroups = {}

	ply.LastJob_bodygroupr = "none"
	ply.LastPlayermodel = nil

	BODYMAN:RestoreLoadout(ply)

	-- check the allowed bodygroups and apply them

end)

-- sqlite bit
sql.Query("CREATE TABLE IF NOT EXISTS bodyman_persist ( sid64 STRING, mdl STRING, bgs STRING, skn REAL )")

local bodygroupBuffer = {}
function BODYMAN:PushBuffer( ply )
	local groups = {}
	for _,v in ipairs(ply:GetBodyGroups()) do
		table.insert( groups, { id = v.id, val = ply:GetBodygroup( v.id ) } )
	end
	local key = "id64_"..ply:SteamID64()
	bodygroupBuffer[ key ] = bodygroupBuffer[ key ] or {}

	bodygroupBuffer[ key ][ tostring(ply:GetModel()) ] = {
		mdl = tostring( ply:GetModel() ),
		bgs = util.TableToJSON( groups ),
		skn = ply:GetSkin()
	}

	--PrintTable( bodygroupBuffer )
end

function BODYMAN:SaveBuffer()
	print("Saving Bodygroup buffer...")
	--PrintTable(bodygroupBuffer)
	for id64,mdls in pairs( bodygroupBuffer ) do
		for _,data in pairs(mdls) do
			local res = sql.Query("SELECT * FROM bodyman_persist WHERE sid64 = '"..id64.."' AND mdl = '"..data.mdl.."'")
			if res ~= false then
				if res == nil then
					sql.Query("INSERT INTO bodyman_persist VALUES ('"..id64.."', '"..data.mdl.."', '"..data.bgs.."', '"..data.skn.."' )")
				else
					sql.Query("UPDATE bodyman_persist SET bgs = '"..data.bgs.."' WHERE sid64 = '"..id64.."' AND mdl = '"..data.mdl.."'")
					sql.Query("UPDATE bodyman_persist SET skn = '"..data.skn.."' WHERE sid64 = '"..id64.."' AND mdl = '"..data.mdl.."'")
				end
			else
				print("Something went terribly wrong with the SQLite in Bodygroupr.")
			end
		end
	end
	print(sql.LastError())
	bodygroupBuffer = {} -- clear once it's saved
end

function BODYMAN:RestoreLoadout( ply )
	local id64 = "id64_"..ply:SteamID64()
	local mdl = ply:GetModel()
	local res = sql.Query("SELECT * FROM bodyman_persist WHERE sid64 = '"..id64.."' AND mdl = '"..mdl.."'")
	if res ~= false then
		if res ~= nil then
			local skn = res[1].skn
			local bgs = util.JSONToTable(res[1].bgs)
			ply:SetSkin( skn )
			for _,b in ipairs( bgs ) do
				--print(b.id,b.val)
				ply:SetBodygroup(b.id,b.val)
			end
		end
	end
end

net.Receive("bodyman_model_change", function( len, ply )

	if not BODYMAN:CanAccessCommand(ply, "bodyman_model_change") then
		return false
	end

	if (not BODYMAN:CloseEnoughCloset( ply )) and (BODYMAN.ClosetsOnly) then return false end

	local job = ply:getJobTable()

	local playermodels = job.model

	if type( playermodels ) == "table" then
		local idx = net.ReadInt(8)

		if playermodels[idx] then
			ply:SetModel( playermodels[idx] )
		end
	end

	timer.Simple(0.2, function() ply:SendLua( [[BODYMAN:RefreshAppearanceMenu()]] ) end )

	ply.LastJob_bodygroupr = job.command or "none"
	ply.LastPlayermodel = ply:GetModel()

	BODYMAN:RestoreLoadout( ply )
end)

net.Receive("bodygroups_change", function(len, ply)

	if not BODYMAN:CanAccessCommand(ply, "bodygroups_change") then
		return false
	end

	if (not BODYMAN:CloseEnoughCloset( ply )) and (BODYMAN.ClosetsOnly) then return false end

	local data = net.ReadTable()

	ply.bodygroups = ply.bodygroups or {}

	if not ply.bodygroups[ply:GetModel()] then
		ply.bodygroups[ply:GetModel()] = {}
	end
	data[1] = math.Round(data[1])
	data[2] = math.Round(data[2])

	local curgroups = ply:GetBodyGroups()
	if curgroups[data[1]+1] then
		if curgroups[data[1]+1].submodels[data[2]] then
		else
			return false
		end
	else
		return false
	end

		ply.bodygroups[ply:GetModel()][data[1]] = data[2]

		-- check if the bodygroup is allowed --
		local name = ply:GetBodygroupName( data[1] )
		local job = ply:getJobTable()
		local allowedbodygroups = {}
		local allowed = false

		if job.bodygroups then
			allowedbodygroups = job.bodygroups
		else
			for i = 2, #ply:GetBodyGroups() do
				local bg = ply:GetBodyGroups()[i]
				if bg then
					for k,v in pairs( bg ) do
						if k == "name" then
							allowedbodygroups[v] = {}
							for k2, v2 in pairs( bg["submodels"] ) do
								table.insert( allowedbodygroups[v], k2 )
							end
						end
					end	
				end
			end
		end



		if allowedbodygroups ~= {} then
			if allowedbodygroups[name] then
				for k,v in pairs(allowedbodygroups[name]) do
					if v == data[2] then
						allowed = true
					end
				end
			end
		end

		if allowed then
			ply:SetBodygroup(data[1], data[2])
			BodygroupManagerLog( ply:Nick().." changed their bodygroup: ("..ply:GetBodygroupName(data[1])..","..tostring(data[2])..")" )
		end

	ply.LastJob_bodygroupr = job.command or "none"
	ply.LastPlayermodel = ply:GetModel()

	if job.armorbodygroups then

		--PrintTable(job.armorbodygroups)

		local current = ply:GetBodyGroups()
		local armor = 0
		--PrintTable(current)
		for k,g in ipairs(current) do
			if job.armorbodygroups[g.name] then
				for j,arm in ipairs(job.armorbodygroups[g.name]) do
					local set = ply:GetBodygroup(g.id)
					--print(g.name, set, arm[1])
					if arm[1] == set then
						armor = armor + arm[2]
					end
				end
			end
		end

		ply:SetArmor(math.min(armor, ply:Armor()))

	end

	BODYMAN:PushBuffer( ply )
	BODYMAN:SaveBuffer()
end)

net.Receive("skins_change", function(len, ply)

	if not BODYMAN:CanAccessCommand(ply, "skins_change") then
		return false
	end

	if (not BODYMAN:CloseEnoughCloset( ply )) and (BODYMAN.ClosetsOnly) then return false end

	local wants = net.ReadInt(8) -- the skin that they wants

	local job = ply:getJobTable()
	local skins = {}
	if job.skins then
		skins = table.Copy(job.skins)
	else
		local numskins = ply:SkinCount()
		for i = 0, numskins do
			table.insert( skins, i )
		end
	end

	if job.vipskins then
		vipskintable = table.Copy(job.vipskins)
		if BODYMAN:IsVip(ply) then
			for _,v in ipairs(vipskintable) do
				table.insert(skins,v)
			end
		end
	end

	if skins ~= {} then
		local allowed = false
		for k,v in ipairs(skins) do
			if v == wants then
				allowed = true
			end
		end

		if allowed then
			ply:SetSkin(wants)
			BodygroupManagerLog( ply:Nick().." changed their skin: ("..tostring(wants)..")" )
		end
	else
		ply:SetSkin( wants )
		BodygroupManagerLog( ply:Nick().." changed their skin: ("..tostring(wants)..")" )
	end

	ply.LastJob_bodygroupr = job.command or "none"
	ply.LastPlayermodel = ply:GetModel()

	BODYMAN:PushBuffer( ply )
	BODYMAN:SaveBuffer()
end)

