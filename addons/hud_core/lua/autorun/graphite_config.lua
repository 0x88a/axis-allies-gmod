GraphiteConfig = {}

----------------------------------------------
-- LEVEL
----------------------------------------------
GraphiteConfig.LevelPos = 0                       -- Additional position for level window

                                                  -- Set it to 1 for LevelUp (https://scriptfodder.com/scripts/view/801/levelup-add-an-rpg-element-to-your-server)
GraphiteConfig.LevelType = 0                      -- Set it to 2 for Advanced Leveling System (https://scriptfodder.com/scripts/view/55/darkrp-advanced-leveling-system)
                                                  -- Set it to 3 for Vrondakis Leveling System (https://github.com/vrondakis/Leveling-System)
----------------------------------------------
-- HUNGER
----------------------------------------------
GraphiteConfig.EnableLowHungerNotification = true -- Enable low hunger notification?
GraphiteConfig.LowHungerValue = 15                -- Of what hunger value should be draw low hunger notification
----------------------------------------------
-- APPEARANCE SETTINGS
----------------------------------------------
GraphiteConfig.PlayerIconType = "model"           -- Choose from model panel or avatar panel, this panel will be draw in left top hud corner. (choose "model" or "avatar")
GraphiteConfig.JobColorIsTeamColor = false        -- Job Label color should be same as job color?
GraphiteConfig.DrawLicenceOnHeadHud = true        -- When player looking on the other player, should be drawn licence info?
GraphiteConfig.DrawRankOnHeadHud = true           -- When player looking on the other player, should be drawn player rank info?
GraphiteConfig.DrawSalary = true                  -- Salary should be draw on the hud? eg. $2000 ($SALARY)
GraphiteConfig.DrawJobOnHeadHud = true            -- When player looking on the other player, should be drawn job info?
GraphiteConfig.TopBarPosition = 40                -- Distance from top bar to down rectangle ( I recommend to do not set it under 36 :) )
GraphiteConfig.DrawDoorOwnableInfo = true         -- Disable default door notification?
GraphiteConfig.EnableLeftLightColorSquare = false -- Enable black panel on the left side of hud
GraphiteConfig.EnableWantedOnHeadHud = true       -- Enable wanted notification above player
GraphiteConfig.EnableWantedReasonOnHeadHud = true -- Enable wanted reason under wanted notification
GraphiteConfig.IgnoredRanks = {"user", "example_rank", "example_rank2"} -- This table allow you to disable drawing this ranks on head hud
GraphiteConfig.ForceHeadHud = true                -- Force drawing head hud when player model is invisible etc.
----------------------------------------------
-- DISABLE PANEL ELEMENTS
----------------------------------------------
GraphiteConfig.DisableGraphiteHUD = false
GraphiteConfig.DisableLeftBottomHud = false
GraphiteConfig.EnableHunger = false
GraphiteConfig.EnableLevel = false
GraphiteConfig.HeadHud = true
GraphiteConfig.AgendaPanel = true
GraphiteConfig.EnableLockdownInfo = true
----------------------------------------------
-- LANGUAGE
----------------------------------------------
GraphiteConfig.Language = {
  lockdown_first_line = "The Mayor has initiated a Lockdown",
  lockdown_second_line = "Please return to your homes!",
}
----------------------------------------------
-- LANGUAGE
----------------------------------------------
GraphiteConfig.EnableAutoResourceDownload = true  -- Automatically download resources from server
GraphiteConfig.AutoAddWorkshopAddon = true -- Automatically add workshop addon to your server
