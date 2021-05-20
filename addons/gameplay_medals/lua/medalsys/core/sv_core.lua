medalsys.core = medalsys.core || {}
local core = medalsys.core
util.AddNetworkString("medalsys_ready")
util.AddNetworkString("medalsys_proccess")

function core.BroadcastMedals(ply, recipient)
    if !ply || !ply:IsValid() then return end
    local medals = util.TableToJSON(ply.activeMedals || ply.medals)
    medals = util.Compress(medals)
    net.Start("medalsys_proccess")
    net.WriteUInt(1, 4)
    net.WriteUInt(ply:EntIndex(), 16)
    net.WriteUInt(#medals, 32)
    net.WriteData(medals, #medals)
    -- net.WriteString(ply.activeMedal && ply.activeMedal:GetID() || "*")
    net.Send(recipient || player.GetAll())
end

function core.SendCurrentMedals(ply)
    if !ply || !ply:IsValid() then return end
    for _, v in pairs(player.GetAll()) do
        if !v.medals && !v.activeMedals then continue end
        core.BroadcastMedals(v, ply)
    end
end

net.Receive("medalsys_ready", function(_, ply)
    if ply.medalReady then return end
    ply.medalReady = true

    core.SendCurrentMedals(ply)
    medalsys.storage.GetMedals(ply)
    medalsys.storage.GetActive(ply)
    print("medals")
    PrintTable(ply.medals || {})
    print("active")
    PrintTable(ply.activeMedals || {})
end)

hook.Add("medalsys_conf", "addResources", function()
    for k, v in pairs(medalsys.conf.medals) do
        resource.AddSingleFile("materials/medalsys/" .. v.img)
    end
end)

hook.Add("PlayerSay", "medalsys_chat", function(ply, msg, tc)
    if !ply || !ply:IsValid() || tc then return end
    local cmd = "!setmedal"
    if ply.medals && string.Left(msg, #cmd) == cmd && msg[#cmd + 1] == " " then
        local medal = string.Right(msg, #msg - #cmd - 1)
        if medal == "*" then
            ply.activeMedals = nil
            medalsys.storage.SaveActive(ply)
            core.BroadcastMedals(ply)
        else
            if !medalsys.conf.medals[medal] || !ply.medals[medal] then return end
            local oMedal = ply.medals[medal]
            if ply.activeMedals && ply.activeMedals[medal] then
                ply.activeMedals[medal] = nil
                if table.Count(ply.activeMedals) < 1 then
                    ply.activeMedals = nil
                end
                ply:PrintMessage(3, "Disabled " .. medal)
            else
                ply.activeMedals = ply.activeMedals || {}
                ply.activeMedals[medal] = oMedal
                ply:PrintMessage(3, "Enabled " .. medal)
            end
            medalsys.storage.SaveActive(ply)
            core.BroadcastMedals(ply)
        end
        return ""
    end
    cmd = "!medals"
    if ply.medals && string.Left(msg, #cmd) == cmd then
        local active = ply.activeMedals
        if active then
            local medals = {}
            for k in pairs(ply.activeMedals) do
                table.insert(medals, k)
            end
            medals = table.concat(medals, ", ")
            ply:PrintMessage(3, "Active medal(s): " .. medals)
        end
        ply:PrintMessage(3, "Medals:")
        for k, v in pairs(ply.medals) do
            ply:PrintMessage(3, v:GetID())
        end
        return ""
    end
end)