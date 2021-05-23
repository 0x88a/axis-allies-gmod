local cfg = gProtect.GetConfig(nil, "spamprotection")

gProtect = gProtect or {}

local spawnCounts = {}
local timerInfo = {}

local function handleSpawning(ply, ent)
	if !cfg.enabled then return end
	
	spawnCounts[ply] = spawnCounts[ply] or 0
	spawnCounts[ply] = spawnCounts[ply] + 1
	
	if !timerInfo[ply] then
		timerInfo[ply] = true
		
		timer.Simple(cfg.delay, function()
			timerInfo[ply] = false
			
			spawnCounts[ply] = 0
		end)
	end
	
	local result = spawnCounts[ply] < cfg.threshold
	
	if !result then
		if cfg.action == 1 then
			ent:Remove()
		elseif cfg.action == 2 then
			gProtect.GhostHandler(ent, true)
		end

		gProtect.NotifyStaff(ply, "spam-spawning", 3)
	end
end

hook.Add("gP:CleanupAdded", "gP:CountEntities", function(ply, ent, type)
	if type == "sents" or type == "props" then
		handleSpawning(ply, ent)
	end
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateSpamProtection", function(updated)
	if updated ~= "spamprotection" then return end
	cfg = gProtect.GetConfig(nil,"spamprotection")
end)