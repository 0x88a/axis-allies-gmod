medalsys.storage = medalsys.storage || {}
local stor = medalsys.storage

sql.Query("CREATE TABLE IF NOT EXISTS medalsys(sid VARCHAR(20) NOT NULL PRIMARY KEY, medals TEXT)")
sql.Query("CREATE TABLE IF NOT EXISTS medalsys_active(sid VARCHAR(20) NOT NULL PRIMARY KEY, active TEXT)")

function stor.SaveMedals(ply)
    if !ply || !ply:IsValid() then return end
    local sid = sql.SQLStr(ply:SteamID64())
    if !ply.medals || table.Count(ply.medals) < 1 then
        sql.Query("DELETE FROM medalsys WHERE sid=" .. sid)
    else
        local medals = ply.medals
        local sqlDat = {}
        for k in pairs(medals) do
            table.insert(sqlDat, k)
        end
        sqlDat = util.TableToJSON(sqlDat)
        sql.Query("REPLACE INTO medalsys(sid, medals) VALUES(" .. sid .. ", '" .. sqlDat .. "')")
    end
end

function stor.GetMedals(ply)
    if !ply || !ply:IsValid() then return end
    local sid = sql.SQLStr(ply:SteamID64())
    local dat = sql.Query("SELECT medals FROM medalsys WHERE sid=" .. sid)
    if !dat then return end
    dat = dat[1]
    local medals = dat.medals
    medals = util.JSONToTable(medals)
    for _, v in ipairs(medals) do
        medalsys:NewMedal(ply, v)
    end
    -- medalsys.core.BroadcastMedals(ply)
end

function stor.SaveActive(ply)
    print("called")
    if !ply || !ply:IsValid() then return end
    local sid = sql.SQLStr(ply:SteamID64())
    if !ply.activeMedals || table.Count(ply.activeMedals) < 1 then
        print("first")
        sql.Query("DELETE FROM medalsys_active WHERE sid=" .. sid)
    else
        print("second")
        local active = ply.activeMedals
        local sqlDat = {}
        for k in pairs(active) do
            table.insert(sqlDat, k)
        end
        sqlDat = util.TableToJSON(sqlDat)
        print(sqlDat)
        sql.Query("REPLACE INTO medalsys_active(sid, active) VALUES(" .. sid .. ", '" .. sqlDat .. "')")
    end
end

function stor.GetActive(ply)
    if !ply || !ply:IsValid() then return end
    local sid = sql.SQLStr(ply:SteamID64())
    local dat = sql.Query("SELECT active FROM medalsys_active WHERE sid=" .. sid)
    if !dat then return end
    dat = dat[1]
    local active = dat.active
    active = util.JSONToTable(active)
    ply.activeMedals = ply.activeMedals || {}
    for _, v in ipairs(active) do
        ply.activeMedals[v] = ply.medals[v]
    end
    medalsys.core.BroadcastMedals(ply)
end