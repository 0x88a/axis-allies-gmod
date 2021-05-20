medalsys.core = medalsys.core || {}
net.Receive("medalsys_proccess", function()
    local op = net.ReadUInt(4)
    if op == 1 then
        local id = net.ReadUInt(16)
        local ply = Entity(id)
        local len = net.ReadUInt(32)
        local medals = net.ReadData(len)
        medals = util.Decompress(medals)
        medals = util.JSONToTable(medals)
        if ply.medals then
            table.Empty(ply.medals)
        end
        for k in pairs(medals) do
            medalsys:NewMedal(ply, k)
        end
    end
end)

hook.Add("medalsys_conf", "createMats", function()
    medalsys.core.mats = {}
    for k, v in pairs(medalsys.conf.medals) do
        medalsys.core.mats[k] = Material("medalsys/" .. v.img)
    end
end)

hook.Add("InitPostEntity", "medalsys_ready", function()
    net.Start("medalsys_ready")
    net.SendToServer()
end)