local medalObj = {}

local function medal(ply, medalENUM)
    local ref = medalsys.conf.medals[medalENUM]
    local new = {
        id = medalENUM,
        name = ref.name,
        img = ref.img,
        holder = ply,
    }
    setmetatable(new, {__index = medalObj})
    return new
end

function medalObj.GetImage(self)
    local imgN = self.img
    return "medalsys/" .. imgN:lower()
end

function medalObj.GetID(self)
    return self.id
end

function medalObj.Remove(self)
    medalsys:RemoveMedal(self.holder, self.id)
end

function medalsys.NewMedal(self, ply, medalENUM, store)
    if !ply || !ply:IsValid() || !medalENUM || !self.conf.medals[medalENUM] then return end
    ply.medals = ply.medals || {}
    local newMedal = medal(ply, medalENUM)
    ply.medals[medalENUM] = newMedal
    if SERVER && store then
        self.core.BroadcastMedals(ply)
        self.storage.SaveMedals(ply)
    end
end

function medalsys.RemoveMedal(self, ply, medalENUM)
    if !ply || !ply:IsValid() || !medalENUM || !self.conf.medals[medalENUM] || !ply.medals || !ply.medals[medalENUM] then return end
    ply.medals[medalENUM] = nil
    if SERVER then
        self.core.BroadcastMedals(ply)
        self.storage.SaveMedals(ply)
    end
end

-- if SERVER then
--     concommand.Add("medal_check", function(ply)
--         local them = ply:GetEyeTrace().Entity
--         hook.Run("PlayerSay", them, "!setmedal epic", false)
--         if them.activeMedals then
--             PrintTable(them.activeMedals)
--         end
--     end)
-- end