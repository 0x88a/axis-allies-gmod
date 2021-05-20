local sam, command = sam, sam.command

command.set_category("Medals")

command.new("givemedal")
    :SetPermission("givemedal", "admin")
    :AddArg("player")
    :AddArg("text", {
        hint = "medal-id",
        check = function(inp)
            return medalsys && medalsys.conf && medalsys.conf.medals && medalsys.conf.medals[inp] && true || false
        end
    })
    :Help("Assigns a medal to a player")
    :OnExecute(function(ply, targets, medal)
        for i = 1, #targets do
            local v = targets[i]
            medalsys:NewMedal(v, medal, true)
        end
        sam.player.send_message(nil, "{A} assignmed medal \"{V}\" to {T}", {A = ply, V = medal, T = targets})
    end)
:End()

command.new("removemedal")
    :SetPermission("removemedal", "admin")
    :AddArg("player", {single_target = true})
    :AddArg("text", {
        hint = "medal-id",
        check = function(inp)
            return medalsys && medalsys.conf && medalsys.conf.medals && medalsys.conf.medals[inp] && true || false
        end
    })
    :Help("Remove a medal from a player")
    :OnExecute(function(ply, targets, medal)
        for i = 1, #targets do
            local v = targets[i]
            if !v.medals || !v.medals[medal] then continue end
            v.medals[medal]:Remove()
        end
        sam.player.send_message(nil, "{A} removed medal \"{V}\" from {T}", {A = ply, V = medal, T = targets})
    end)
:End()