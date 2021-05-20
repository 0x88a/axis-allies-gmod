--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", 
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100, 
}


Add new categories under the next line!
---------------------------------------------------------------------------]]
DarkRP.createCategory{
	name = "Recruits", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(150, 0, 150, 255),
	canSee = function(ply) return true end,
	sortOrder = 0,
}

DarkRP.createCategory{
	name = "Axis: High Command", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(163, 13, 13, 255),
	canSee = function(ply) return true end,
	sortOrder = 1, 
}

DarkRP.createCategory{
	name = "Axis: 2nd SS Panzer Division", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(163, 13, 13, 255),
	canSee = function(ply) return true end,
	sortOrder = 2, 
}

DarkRP.createCategory{
	name = "Axis: 3rd Wehrmacht Infantry Division", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(163, 13, 13, 255),
	canSee = function(ply) return true end,
	sortOrder = 3, 
}

DarkRP.createCategory{
	name = "Axis: Luftwaffe", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(163, 13, 13, 255),
	canSee = function(ply) return true end,
	sortOrder = 4, 
}

----------------------------------------

DarkRP.createCategory{
	name = "Allies: High Command", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(46, 161, 255, 255),
	canSee = function(ply) return true end,
	sortOrder = 5, 
}

DarkRP.createCategory{
	name = "Allies: US 4th Infantry Division", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(46, 161, 255, 255),
	canSee = function(ply) return true end,
	sortOrder = 6, 
}

DarkRP.createCategory{
	name = "Allies: US 101st Airbourne Division", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(46, 161, 255, 255),
	canSee = function(ply) return true end,
	sortOrder = 7, 
}

DarkRP.createCategory{
	name = "Allies: British Commonwealth", 
	categorises = "jobs",
	startExpanded = false,
	color = Color(46, 161, 255, 255),
	canSee = function(ply) return true end,
	sortOrder = 8, 
}