Conquest.TeamManager = Conquest.TeamManager or {}
Conquest.TeamManager.cache = Conquest.TeamManager.cache or {}

net.Receive("conquest.team.sync", function()
    local teams = net.ReadTable()
    local cache = net.ReadTable()

    if (teams) then
    
        Conquest.TeamManager.cache = teams or {}

    end

    if (cache) then
        Conquest.TeamManager.QuickCache = cache or {}
    end

end)