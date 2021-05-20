
Conquest.Spawns = Conquest.Spawns or {}

util.AddNetworkString("conquest_spawnon")
util.AddNetworkString("conquest_spawncl")

net.Receive("conquest_spawnon", function(len, pPlayer)

    local point = net.ReadTable()

    if point then
        Conquest.Spawns.PlayerSpawn(pPlayer, point)
    end
end)

// Modified DarkRP functions //
// Credits to contributing darkrp authors //
function Conquest.Spawns.isEmpty(vector, blacklist)
    blacklist = blacklist or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) then
            b = false
            break
        end
    end

    return a and b

end

function Conquest.Spawns.FindOpenSpot(pos, ignore, distance, step, area)
    ignore = ignore or {}

    if Conquest.Spawns.isEmpty(pos, ignore) and Conquest.Spawns.isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do -- alternate in direction
            local k = j * i

            -- Look North/South
            if Conquest.Spawns.isEmpty(pos + Vector(k, 0, 0), ignore) and Conquest.Spawns.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            -- Look East/West
            if Conquest.Spawns.isEmpty(pos + Vector(0, k, 0), ignore) and Conquest.Spawns.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            -- Look Up/Down
            if Conquest.Spawns.isEmpty(pos + Vector(0, 0, k), ignore) and Conquest.Spawns.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

/////

function Conquest.Spawns.GetPlayerSpawns(pPlayer)
    local spawns = {}

    for k, v in pairs(Conquest.cache) do
        if (v.owner != nil) then
            if (v.category) then
                local category = Conquest.player:getCategory(pPlayer)

                if (category) then
                    if v.owner == category then
                        spawns[v.name] = v
                    end
                end
            elseif (v.teamBased) then
                if (v.realOwner) then

                    if Conquest.TeamManager.QuickCache[pPlayer:Team()] == v.realOwner then
                        
                        spawns[v.name] = v

                    end

                end
            else
                local team = Conquest.player:getTeam(pPlayer)

                if (team) then
                    if v.owner == team then
                        spawns[v.name] = v
                    end
                end
            
            end
        end
    end

    return spawns
end

function Conquest.Spawns.CanPlayerSpawn(pPlayer, point)
    if !point then return false end 

    if pPlayer.nextSpawn and pPlayer.nextSpawn > CurTime() then 

        local cooldownLeft = pPlayer.nextSpawn - CurTime()
        cooldownLeft = string.NiceTime(cooldownLeft)

        pPlayer:PrintMessage(HUD_PRINTTALK, "You cannot use the spawning menu yet. Time left: " .. cooldownLeft .. "!")
        
        return false

    end

    local canSpawn = Conquest.Spawns.GetPlayerSpawns(pPlayer)

    local contestedSpawn = Conquest.Config.get("nocontestedSpawns", false)

    if (contestedSpawn) then
        
        if point.isCapturing then

            pPlayer:PrintMessage(HUD_PRINTTALK, "You cannot spawn on this point as its being contested.")
            return false 

        end

    end

    if (canSpawn) then
        if canSpawn[point.name] then
            return true
        end
    end

    return false
end

function Conquest.Spawns.PlayerSpawn(pPlayer, point)
    if !point then return false end 

    if !Conquest.Config.get("spawning", false) then return end

    if !IsValid(pPlayer) then return end

    local canSpawn = Conquest.Spawns.CanPlayerSpawn(pPlayer, point)

    if (canSpawn) then
        local openPos = Conquest.Spawns.FindOpenSpot(point.position, {pPlayer}, 600, 30, Vector(16, 16, 64))

        if (openPos) then
            pPlayer:Spawn()
            pPlayer:SetPos(openPos)
        end

        local cooldown = Conquest.Config.get('spawnTimer', 0)

        pPlayer.nextSpawn = CurTime() + cooldown

        return
    end



end

function Conquest.Spawns.OpenMenu(pPlayer)
    net.Start("Conquest_MapOpen")
    net.Send(pPlayer)
end

hook.Add("PostPlayerDeath", "Conquest_DeathMenu", function(pPlayer)
    if (Conquest.Config.get("spawning", false) == true) then
        Conquest.Spawns.OpenMenu(pPlayer)
    end
end)

hook.Add("PlayerInitialSpawn", "Conquest_DeathMenuSpawn", function(pPlayer)
    timer.Simple(3, function()
        if (Conquest.Config.get("spawning", false) == true) then
            Conquest.Spawns.OpenMenu(pPlayer)
        end
    end)
end)