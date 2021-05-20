
util.AddNetworkString("Conquest_MapOpen")


hook.Add( "PlayerSay", "Conquest_OpenMap", function( ply, text, team )
    local mapCommand = Conquest.Config.get("mapChatCommand", "/map")

    if (text:lower() == mapCommand:lower()) then

        net.Start("Conquest_MapOpen")
        net.Send(ply)

        return ""

    end
    
end)