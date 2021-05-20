Conquest.Config = Conquest.Config or {}


// Ranks allowed to open the Conquest-Manager menu //
Conquest.Config.Ranks = {
    "owner",
    "super-admin",
    "superadmin",
    "founder",
}


--[[ Don't touch below this -- ]]
--[[ Editting these values here will corrupt your entire configuration file and will break the script.-- ]]
--[[ Editting these values here will corrupt your entire configuration file and will break the script.-- ]]
--[[ Editting these values here will corrupt your entire configuration file and will break the script.-- ]]
--[[ Don't touch below this -- ]]

// These functions are used to declare configuration options in game //
// It is not recommend to change them here, but change them in game. //
// Changing them here can corrupt the configuration file, and will need to be reinstalled //
// If your configuration file becomes corrupted use the 'Reset Config' ingame //
Conquest.Config.new("chatCommand", "/conquest", "Chat command used to open up the menu.", nil, "Chat")


Conquest.Config.new("darkrp", false, "Enables support for darkrp", nil, "DarkRP")
Conquest.Config.new("colorusecategory", false, "Use the color of category for icon color", nil, "DarkRP")


Conquest.Config.new("spawning", false, "Enables spawning on captured points", nil, "Spawning")
Conquest.Config.new("spawnTimer", 0, "Cooldown on spawn timer. 0 = no cooldown", nil, "Spawning")

Conquest.Config.new("reward", false, "Give money on point captured.", nil, "Rewards")
Conquest.Config.new("reward_cat", false, "Give team/category money on point captured", nil, "Rewards")

Conquest.Config.new("rewardTickAmount", 25, "Give team/category money for holding, each tick.", nil, "Rewards")
Conquest.Config.new("rewardTick", 0, "The timer between each holding tick. 0 = disabled. (In seconds)", function(value)
    if (value) <= 0 then

        timer.Remove("Conquest_HoldTick")

        return
    end

    if (value) >= 0 then
        if timer.Exists("Conquest_HoldTick") then
            timer.Adjust("Conquest_HoldTick", value, 0, function()
                Conquest.HoldTick()
            end)
        else
            Conquest.TickCreate()
        end

        return
    end 

end, 
"Rewards")

Conquest.Config.new("seethrough", false, "Enables seeing points through walls", nil, "Visibility")


Conquest.Config.new("useSmartIcons", true, "Show the flags on the hud even if the player isn't looking at them.", nil, "Visibility")

Conquest.Config.new("useRenderDist", false, "Only renders the flags if players are in the distance.", nil, "Visibility")
Conquest.Config.new("intRenderDist", 1200, "The distance to render the flag from.", nil, "Visibility")

Conquest.Config.new("colorOutline", Color(255, 255, 255), "Color of the point tag.", nil, "Fonts")
Conquest.Config.new("colorName", Color(255, 255, 255), "Color of the point name.", nil, "Fonts")
Conquest.Config.new("colorDistance", Color(255, 255, 255), "Color of the distance from point to player.", nil, "Fonts")

Conquest.Config.new("fontTag", "DermaLarge", "Font for the point tag. (Font must exist!)", nil, "Fonts")
Conquest.Config.new("fontName", "DermaDefaultBold", "Font for the point name. (Font must exist!)", nil, "Fonts")
Conquest.Config.new("fontDistance", "DermaDefaultBold", "Font of the distance from point to player (Font must exist!)", nil, "Fonts")


Conquest.Config.new("enableFlags", false, "This will spawn capturable flags on each point.", function(value)
    if (value == true) then
        for k,v in pairs(Conquest.cache) do
            if v.flagent then continue end 

            local ent = ents.Create("prop_physics")
            ent:SetModel("models/sterling/flag.mdl")
            ent:SetPos(v.position)

            ent:Spawn()
            local phys = ent:GetPhysicsObject()
 
            if phys and phys:IsValid() then
                phys:EnableMotion(false)
            end
 
            ent.ID = k

            Conquest.cache[k].flagent = ent

        end
    else
        for k,v in pairs(Conquest.cache) do
            if v.flagent and IsValid(v.flagent) then
                SafeRemoveEntity(v.flagent)
                v.flagent = nil
            end
        end
    end
end,
"Misc")

Conquest.Config.new("annouceCaptures", false, "Annouce to defending team/category when they lost a flag.", nil, "Misc")


Conquest.Config.new("noSaveFlags", false, "When this is set to true, flags will not be saved.", nil, "Misc")

Conquest.Config.new("showRadiusCircle", false, "Show a visual aid of the radius of the flag. Does have FPS impact!", nil, "Misc")

Conquest.Config.new("filledCircleRadius", false, "Makes the circle fill instead of hallow. Does have FPS impact!", nil, "Misc")

Conquest.Config.new("enabledMap", false, "Enable/disables the useage of the Conquest map", nil, "Map")

Conquest.Config.new("mapChatCommand", "/map", "The chat command used to open the map.", nil, "Map")

Conquest.Config.new("showTeammates", false, "Show the player's teamates on the map.", nil, "Map")

Conquest.Config.new("nocontestedSpawns", false, "Enable to disable spawning on flags being captured.", nil, "Map")