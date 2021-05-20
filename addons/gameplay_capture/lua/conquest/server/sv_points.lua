util.AddNetworkString("conquest_sync")
util.AddNetworkString("conquest_delete")
util.AddNetworkString("conquest_resetall")
util.AddNetworkString("conquest_reset")
util.AddNetworkString("conquest_create")
util.AddNetworkString("conquest_delete")
util.AddNetworkString("conquest_editflag")
util.AddNetworkString("conquest_openMain")

net.Receive("conquest_delete", function(len, pPlayer)

	if !Conquest.Config.canEdit(pPlayer) then return end

	local index = net.ReadInt(16)
	if !index then return end


	Conquest.DeleteFlag(index)
end)

net.Receive("conquest_resetall", function(len, pPlayer)
	if !Conquest.Config.canEdit(pPlayer) then return end
	Conquest.ResetFlags()
end)

net.Receive("conquest_reset", function(len, pPlayer)
	if !Conquest.Config.canEdit(pPlayer) then return end

	local index = net.ReadInt(16)

	if !index then return end 

	Conquest.ResetFlag(index)
end)

net.Receive("conquest_create", function(len, pPlayer)
	if !Conquest.Config.canEdit(pPlayer) then return end

	local tblData = net.ReadTable()

	if !tblData then return end

	Conquest.CreateFlag(pPlayer, tblData.name, tblData)
end)

net.Receive("conquest_editflag", function(len, pPlayer)
	if !Conquest.Config.canEdit(pPlayer) then return end

	local index = net.ReadInt(16)
	local data = net.ReadTable()

	if table.Count(data.noTeams) <= 0 then
		data.noTeams = {}
	end

	if (index) and (data) then
		local flag = Conquest.cache[index]

		if (flag) then
			local bool = Conquest.EditFlag(index, data)
			if (bool) then
				pPlayer:PrintMessage(HUD_PRINTTALK, 'Flag was succesfully editted')
			end
		end
	end
end)

function Conquest.CreateFlag(pPlayer, name, tblData)
	if !Conquest.Config.canEdit(pPlayer) then return end
	if not tblData then return end
	

	local index = table.insert(Conquest.cache, {
		name = name,
		radius = tonumber(tblData.radius) or 150,
		noTeams = tblData.teams or {},
		category = tobool(tblData.category) or false,
		time = tonumber(tblData.time) or 7,
		tag = tblData.tag,
		shape = tostring(tblData.shape) or "circle",
		reward = tonumber(tblData.reward) or false,
		teamBased = tblData.teamBased or false,
		position = pPlayer:GetPos(),
		// Set up default data
		isCapturing = nil,
		Owner = nil,
		CapturingTeams = {},
		CapturingPlayers = {},
	})

	Conquest.Database.Write()

	local spawnFlag = Conquest.Config.get("enableFlags", false)

	if (spawnFlag) then
		for k,v in pairs(Conquest.cache) do
			if v.flagent then continue end 

			//local angles = Conquest.FindValidFlag(v.position)

        	local ent = ents.Create("prop_physics")
            ent:SetModel("models/sterling/flag.mdl")
            ent:SetPos(v.position)
           // ent:SetAngles(angles)
            ent:Spawn()
            local phys = ent:GetPhysicsObject()
 
        	if phys and phys:IsValid() then
                phys:EnableMotion(false)
            end
 
            ent.ID = k

            Conquest.cache[k].flagent = ent
		end
	end


	Conquest.FlagNetworkVars()

end

function Conquest.DeleteFlag(intIndex)

	if !Conquest.cache[intIndex] then
		print("[CONQUEST] Flag doesn't exist.")
		return false, "@noExist"
	end

	local data = Conquest.cache[intIndex]

	if data.flagent and IsValid(data.flagent) then
		SafeRemoveEntity(data.flagent)
	end

	Conquest.cache[intIndex] = nil

	print("[CONQUEST] Point deleted successfuly.")


	Conquest.Database.Delete()
	Conquest.FlagNetworkVars()

	return true, "@successDeleted"
end

function Conquest.EditFlag(index, tblData)
	if !Conquest.cache[index] then
		print("[CONQUEST] Flag doesn't exist.")
		return false
	end	

	Conquest.cache[index].noTeams = {}
	table.Merge(Conquest.cache[index], tblData)

	Conquest.Database.Write()
	
	Conquest.FlagNetworkVars()

	return true
end

function Conquest.FindValidFlag(position)
	local pos = position 


	local tr = {
		start = pos + Vector(0, 0, 10),
		endpos = Vector(pos.x, pos.y, pos.z * (-10000)),
		filter = function(ent) if (ent:IsWorld()) then return true end end
	}

	tr = util.TraceLine(tr)

	local angles = tr.HitNormal:Angle()
	angles.pitch = angles.pitch + 90
	angles:Normalize()

	return angles
end


function Conquest.LoadFlags()
	timer.Simple(2, function()
		local cache = Conquest.Database.FetchFlags()
	end)
end
hook.Add("PostGamemodeLoaded", "PostGamemodeLoaded_Conquest", Conquest.LoadFlags)


function Conquest.FlagNetworkVars(pPlayer)
	if pPlayer then
		net.Start("conquest_sync")
			net.WriteTable(Conquest.cache)
		net.Send(pPlayer)
	else
		net.Start("conquest_sync")
			net.WriteTable(Conquest.cache)
		net.Broadcast()
	end
end

function Conquest.ResetFlag(index)
	local point = Conquest.cache[index]

	if (point) then
		point.owner = nil

		if (point.flagent) then
			point.flagent:SetColor(Color(255, 255, 255))
		end

		Conquest.FlagNetworkVars()
	end
end

function Conquest.ResetFlags()
	local network = false

	for k,v in pairs(Conquest.cache) do
		if v.owner then
			network = true
			v.owner = nil

			if (v.flagent) then
				v.flagent:SetColor(Color(255, 255, 255))
			end
		end
	end

	// don't network if nothing changed //
	if (network) then
		Conquest.FlagNetworkVars()
	end
end

function Conquest.FlagSyncSpawn(pPlayer)
	timer.Simple(2, function()
		Conquest.FlagNetworkVars(pPlayer)
	end)
end
hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn_Conquest", Conquest.FlagSyncSpawn)


// returns the first key
// Table is unordered so this is the only way
// Only used when 1 team is capturing
function Conquest.FlagFirstKey(flag)
	for k,v in pairs(flag.CapturingTeams) do
		return k
	end
end

function Conquest.FlagFirstTeamCapture(flag)
	local teams = flag.capturingTeams or {}
	for k,v in pairs(teams) do
		return k
	end
end

function Conquest.FlagRemovePlayers()
	for k,v in pairs(Conquest.cache) do
		v.CapturingPlayers = {}
		v.capturingTeams = {}
	end
end

function Conquest.FlagRemoveTeams()
	for k,v in pairs(Conquest.cache) do
		v.CapturingTeams = {}
		v.capturingTeams = {}
	end
end