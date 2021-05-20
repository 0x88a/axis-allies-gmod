VictoriousScoreboardConfig = VictoriousScoreboardConfig or {}

VictoriousScoreboardConfig.servertitle = " "

VictoriousScoreboardConfig.UsingDarkRP = true

VictoriousScoreboardConfig.UsingDarkRPCategories = true

VictoriousScoreboardConfig.UsingDarkRPCategoriesTitles = false

VictoriousScoreboardConfig.DefaultAdminMod = "sam"

VictoriousScoreboardConfig.ShowRank = true

// UPDATE IMPORTANT FOR XADMIN USERS:
// Set the above adminmod selection text to xadmin

// USING XADMIN
VictoriousScoreboardConfig.xadmin = false

// JAIL REASON
VictoriousScoreboardConfig.jreason = "Fast Jailed"

// JAIL TIME
VictoriousScoreboardConfig.jailtime = 5 // Minutes


// SHOWN RANKS
VictoriousScoreboardConfig.showngroups = {}
VictoriousScoreboardConfig.showngroups["user"] = { ShownName = "User", GroupColor = Color(255,255,255) }
VictoriousScoreboardConfig.showngroups["moderator"] = { ShownName = "Moderator", GroupColor = Color(255,255,255) }
VictoriousScoreboardConfig.showngroups["admin"] = { ShownName = "Admin", GroupColor = Color(255,255,255) }
VictoriousScoreboardConfig.showngroups["superadmin"] = { ShownName = "Superadmin", GroupColor = Color(255,230,0) }


// GROUPS WHO ACCESS THE ADMIN TABLE
VictoriousScoreboardConfig.groups = { "admin", "superadmin", "moderator"}

// GROUPS WHO HAVE THE STAR ICON
VictoriousScoreboardConfig.commandgroups = { "superadmin"}

// MAXIMUM LETTERS OF USER NAME
VictoriousScoreboardConfig.namemax = 18

// ADMIN GROUP COLORS
VictoriousScoreboardConfig.groupcol = Color ( 255,255,255 )

// QUICK BAN BUTTON TIME
VictoriousScoreboardConfig.bantime = 60 // Minutes

// KICK REASON
VictoriousScoreboardConfig.kreason = "You have been kicked!"

// BAN REASON
VictoriousScoreboardConfig.breason = "You have been banned for %s minutes!"

// PING BAR COLORS
VictoriousScoreboardConfig.pingcol4 = Color( 0,255,0 )
VictoriousScoreboardConfig.pingcol3 = Color( 250,255,0 )
VictoriousScoreboardConfig.pingcol2 = Color( 255,155,0 )
VictoriousScoreboardConfig.pingcol1 = Color( 255,100,0 )

// TRANSLATIONS

VictoriousScoreboardConfig.KickText = "Kick"

VictoriousScoreboardConfig.GotoText = "Goto"

VictoriousScoreboardConfig.JailText = "Jail"

VictoriousScoreboardConfig.BanText = "Ban"

VictoriousScoreboardConfig.CopySteamIDText = "Copy SteamID of %s (%s)"

VictoriousScoreboardConfig.NameText = "NAME"
VictoriousScoreboardConfig.ClassText = "CLASS"
VictoriousScoreboardConfig.RankText = "RANK"
VictoriousScoreboardConfig.Kills = "K"
VictoriousScoreboardConfig.Deaths = "D"
VictoriousScoreboardConfig.Ping = "PING"



//______________________________________________________________________
//______________________________________________________________________

// THEME

VictoriousScoreboardConfig.servertitlc = Color ( 255,255,255 )
VictoriousScoreboardConfig.white = Color ( 255,255,255 )
VictoriousScoreboardConfig.grey = Color ( 230,230,230,240 )
VictoriousScoreboardConfig.hover = Color(120, 120, 120)

// MATERIALS

VictoriousScoreboardConfig.blur = Material("pp/blurscreen")
VictoriousScoreboardConfig.fullping = Material("icons/fullping.png")
VictoriousScoreboardConfig.ping3 = Material("icons/3bar.png")
VictoriousScoreboardConfig.ping2 = Material("icons/2bar.png")
VictoriousScoreboardConfig.ping1 = Material("icons/1bar.png")
VictoriousScoreboardConfig.bullets = Material("icons/kills.png")
VictoriousScoreboardConfig.death = Material("icons/death.png")
VictoriousScoreboardConfig.star = Material("icons/group.png")
VictoriousScoreboardConfig.cog = Material("icons/settings.png")
VictoriousScoreboardConfig.kick = Material("icons/kick.png")
VictoriousScoreboardConfig.tele = Material("icons/teleport.png")
VictoriousScoreboardConfig.ban = Material("icons/ban.png")
VictoriousScoreboardConfig.jail = Material("icons/jail.png")


surface.CreateFont("title", {
    font = "Lato",
    size = 72,
    weight = 500,
    extended = true
})

surface.CreateFont("score", {
    font = "Lato",
    size = 20,
    weight = 500,
    extended = true
})

surface.CreateFont("player", {
    font = "Lato",
    size = 18,
    weight = 100,
    extended = true
})

// DONT TOUCH THIS UNLESS YOU KNOW WHAT YOU ARE DOING!

VictoriousScoreboardConfig.AdminMod = {}
VictoriousScoreboardConfig.AdminMod["xadmin2"] = {}
VictoriousScoreboardConfig.AdminMod["xadmin2"].ban = function(ply, time, reason)
    RunConsoleCommand("xadmin", "ban", ply:Nick(), time, reason)
end

VictoriousScoreboardConfig.AdminMod["xadmin2"].kick = function(ply, reason)
    RunConsoleCommand("xadmin", "kick", ply:Nick(), reason)
end

VictoriousScoreboardConfig.AdminMod["xadmin2"].jail = function(ply, time, reason)
    RunConsoleCommand("xadmin", "jail", ply:Nick(), time, reason )
end

VictoriousScoreboardConfig.AdminMod["xadmin2"].Goto = function(ply)
    RunConsoleCommand("xadmin", "goto", ply:Nick())
end

VictoriousScoreboardConfig.AdminMod["xadmin"] = {}
VictoriousScoreboardConfig.AdminMod["xadmin"].ban = function(ply, time, reason)
    RunConsoleCommand("xadmin_ban", ply:Nick(), time, reason)
end

VictoriousScoreboardConfig.AdminMod["xadmin"].kick = function(ply, reason)
    RunConsoleCommand("xadmin_kick", ply:Nick(), reason)
end

VictoriousScoreboardConfig.AdminMod["xadmin"].jail = function(ply, time, reason)
    RunConsoleCommand("xadmin_jail", ply:Nick(), time, reason )
end

VictoriousScoreboardConfig.AdminMod["xadmin"].Goto = function(ply)
    RunConsoleCommand("xadmin_goto", ply:Nick())
end

VictoriousScoreboardConfig.AdminMod["sam"] = {}
VictoriousScoreboardConfig.AdminMod["sam"].ban = function(ply, time, reason)
    RunConsoleCommand("sam", "ban", ply:Nick(), time, reason)
end

VictoriousScoreboardConfig.AdminMod["sam"].kick = function(ply, reason)
    RunConsoleCommand("sam", "kick", ply:Nick(), reason)
end

VictoriousScoreboardConfig.AdminMod["sam"].jail = function(ply)
    RunConsoleCommand("sam", "jail", ply:Nick())
end

VictoriousScoreboardConfig.AdminMod["sam"].Goto = function(ply)
    RunConsoleCommand("sam", "goto", ply:Nick())
end

VictoriousScoreboardConfig.AdminMod["fadmin"] = {}
VictoriousScoreboardConfig.AdminMod["fadmin"].ban = function(ply, time, reason)
    RunConsoleCommand("fadmin", "ban", ply:Nick(), time, reason)
end

VictoriousScoreboardConfig.AdminMod["fadmin"].kick = function(ply, reason)
    RunConsoleCommand("fadmin", "kick", ply:Nick(), reason)
end

VictoriousScoreboardConfig.AdminMod["fadmin"].jail = function(ply)
    RunConsoleCommand("fadmin", "jail", ply:Nick(), "normal")
end

VictoriousScoreboardConfig.AdminMod["fadmin"].Goto = function(ply)
    RunConsoleCommand("fadmin", "goto", ply:Nick())
end

VictoriousScoreboardConfig.AdminMod["serverguard"] = {}
VictoriousScoreboardConfig.AdminMod["serverguard"].ban = function(ply, time, reason)
    RunConsoleCommand("sg", "ban", ply:Nick(), time, reason)
end

VictoriousScoreboardConfig.AdminMod["serverguard"].kick = function(ply, reason)
    RunConsoleCommand("sg", "kick", ply:Nick(), reason)
end

 VictoriousScoreboardConfig.AdminMod["serverguard"].jail = function(ply)
    RunConsoleCommand("sg", "jail", ply:Nick(), 0)
end

VictoriousScoreboardConfig.AdminMod["serverguard"].Goto = function(ply)
    RunConsoleCommand("sg", "goto", ply:Nick())
end
