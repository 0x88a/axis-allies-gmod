--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

TEAM_CIV = DarkRP.createJob("Citizen", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
	},
    description = "Pick your side.",
    weapons = {"keys"},
    command = "civ",
    max = 0,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Recruits",
})

TEAM_AXIS_REC = DarkRP.createJob("Axis Recruit", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_06.mdl",
		},
    description = "Pick your side.",
    weapons = {"keys"},
    command = "axis_rec",
    max = 0,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Recruits",
})

TEAM_ALLIES_REC = DarkRP.createJob("Allied Recruit", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/generic/recruit_s1_06.mdl",
		},
    description = "Pick your side.",
    weapons = {"keys"},
    command = "allies_rec",
    max = 0,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Recruits",
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TEAM_WEHRMACHT_OBERST = DarkRP.createJob("Wehrmacht High Command: Oberst", {
    color = Color(150, 150, 150, 255),
    model = {						
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/co/m38_s1_01.mdl"
	},
    description = "The highest ranking Wehrmacht official. Would have command over the entirety of the Wehrmacht.",
    weapons = { "doi_atow_p08", "gred_artisweps_ww2_axis", "weapon_cuff_elastic"},
    command = "axis_w_oberst",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: High Command",
	sortOrder = 1,
})

TEAM_SS_OBERFUHRER = DarkRP.createJob("SS High Command: Oberfuhrer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/co/m38_s1_01.mdl",
		"models/brot/typhon/ss/baseline/co1.mdl"
	},
    description = "The highest ranking SS official. Would have command over the entirety of the SS.",
    weapons = { "doi_atow_p08", "gred_artisweps_ww2_axis", "weapon_cuff_elastic"},
    command = "axis_ss_oberfuhrer",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: High Command",
	sortOrder = 3,
})

TEAM_LUFT_OBERST = DarkRP.createJob("Luftwaffe High Command: Oberst", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/brot/typhon/luftwaffeco1.mdl"
	},
    description = "The highest ranking Luftwaffe official. Would have command over the entirety of the Luftwaffe.",
    weapons = { "doi_atow_p08", "gred_artisweps_ww2_axis", "weapon_cuff_elastic"},
    command = "axis_luft_oberst",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: High Command",
	sortOrder = 4,
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TEAM_SS_ENLISTED = DarkRP.createJob("2nd SS Panzer: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/en/m40_s1_01.mdl"
	},
    description = "An enlisted-man of the Waffen-SS 2nd Panzer Division- Das Reich.",
    weapons = {"doi_atow_k98k"},
    command = "axis_ss_enlisted",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 2nd SS Panzer Division",
	sortOrder = 1,
})	

TEAM_SS_NCO = DarkRP.createJob("2nd SS Panzer: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/nco/m40_s1_01.mdl"
	},
    description = "An NCO of the Waffen-SS 2nd Panzer Division- Das Reich.",
    weapons = {"doi_atow_k98k", "doi_atow_mp40"},
    command = "axis_ss_nco",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 2nd SS Panzer Division",
	sortOrder = 2,
})	

TEAM_SS_OFFICER = DarkRP.createJob("2nd SS Panzer: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/co/m38_s1_01.mdl"
	},
    description = "An officer of the Waffen-SS 2nd Panzer Division- Das Reich.",
    weapons = {"doi_atow_p38", "doi_atow_binocularsde"},
    command = "axis_ss_officer",
    max = 0,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 2nd SS Panzer Division",
	sortOrder = 3,
})	

TEAM_SS_PANZERJAGER = DarkRP.createJob("2nd SS Panzer: Panzerjäger", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/nco/m42smock_s1_01.mdl"
	},
    description = "A Panzerjäger of the Waffen-SS 2nd Panzer Division- Das Reich. ",
    weapons = {"doi_atow_p38", "tankgewehr", "weapon_doistielhandgranate"},
    command = "axis_ss_panzerjager",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 2nd SS Panzer Division",
	sortOrder = 4,
})	

TEAM_SS_ENGINEER = DarkRP.createJob("2nd SS Panzer: Panzeringenieur", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/wss/infantry/panzer/nco/panzerwrap_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/wss/infantry/panzer/nco/panzerwrap_s1_02.mdl"
	},
    description = "A Panzeringenieur of the Waffen-SS 2nd Panzer Division- Das Reich. ",
    weapons = {"doi_atow_p38", "weapon_simrepair"},
    command = "axis_ss_engineer",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 2nd SS Panzer Division",
	sortOrder = 5,
})	

-------------------------------------------------------------------------------------------

-- TEAM_SS_FELD = DarkRP.createJob("Feldgendarmerie: NCO", {
    -- color = Color(150, 150, 150, 255),
    -- model = {
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_01.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_02.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_03.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_04.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_05.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/nco/m40greatcoat_w1_06.mdl",
	-- },
    -- description = "An NCO of the Feldgendarmerie. Their primary role is to enforce law and order within the SS and Wehrmacht.",
    -- weapons = {"weapon_cuff_elastic", "weapon_cuff_tactical", "doi_atow_g43"},
    -- command = "axis_ss_feld",
    -- max = 0,
    -- salary = 200,
    -- admin = 0,
    -- vote = false,
    -- hasLicense = false,
    -- category = "Axis: 2nd SS Panzer Division",
	-- sortOrder = 4,
-- })	

-- TEAM_SS_FELD_OFFICER = DarkRP.createJob("Feldgendarmerie: Officer", {
    -- color = Color(150, 150, 150, 255),
    -- model = {
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_01.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_02.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_03.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_04.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_05.mdl",
		-- "models/hts/comradebear/pm0v3/player/gd_heer/feldgendarmerie/co/m38coat_s1_06.mdl",
	-- },
    -- description = "An officer of the Feldgendarmerie. Their primary role is to enforce law and order within the SS and Wehrmacht.",
    -- weapons = {"weapon_cuff_elastic", "weapon_cuff_tactical", "doi_atow_p38"},
    -- command = "axis_ss_feld_officer",
    -- max = 0,
    -- salary = 300,
    -- admin = 0,
    -- vote = false,
    -- hasLicense = false,
    -- category = "Axis: 2nd SS Panzer Division",
	-- sortOrder = 5,
-- })	

-------------------------------------------------------------------------------------------

TEAM_LUFT_ENLISTED = DarkRP.createJob("Luftwaffe Fliegerkorps: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/brot/typhon/luftwaffenenlisted1.mdl"
	},
    description = "An enlisted-man of the Luftwaffe's fliegerkorps, tasked with flying and making planes.",
    weapons = {"doi_atow_p38"},
    command = "axis_luft_enlisted",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: Luftwaffe",
	sortOrder = 1,
})

TEAM_LUFT_NCO = DarkRP.createJob("Luftwaffe Fliegerkorps: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/brot/typhon/luftwaffenco1.mdl"
	},
    description = "An NCO of the Luftwaffe's fliegerkorps, tasked with flying and making planes.",
    weapons = {"doi_atow_p38"},
    command = "axis_luft_nco",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: Luftwaffe",
	sortOrder = 2,
})

TEAM_LUFT_OFFICER = DarkRP.createJob("Luftwaffe Fliegerkorps: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/brot/typhon/luftwaffeco1.mdl"
	},
    description = "An officer of the Luftwaffe's fliegerkorps, tasked with flying and making planes.",
    weapons = {"doi_atow_p38", "doi_atow_binocularsde"},
    command = "axis_luft_officer",
    max = 0,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: Luftwaffe",
	sortOrder = 3,
})

TEAM_LUFT_FALSCH = DarkRP.createJob("Luftwaffe Fallschirmjäger Korps: Fallschirmjäger", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/en/m42smock_s1_01.mdl"
	},
    description = "A Fallschirmjäger of the Luftwaffe, tasked with paradropping into and inflitrating locations.",
    weapons = {"doi_atow_fg42", "doi_atow_p38", "doi_atow_binocularsde"},
    command = "axis_falsch_enlisted",
    max = 0,
    salary = 100	,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: Luftwaffe",
	sortOrder = 4,
})

TEAM_LUFT_FALSCH_OFFICER = DarkRP.createJob("Luftwaffe Fallschirmjäger Korps: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/en/m42smock_s1_01.mdl",
		"models/brot/typhon/luftwaffeco1.mdl"
	},
    description = "A Fallschirmjäger Officer of the Luftwaffe, tasked with paradropping into and inflitrating locations.",
    weapons = {"doi_atow_fg42", "doi_atow_p38", "doi_atow_binocularsde"},
    command = "axis_falsch_officer",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: Luftwaffe",
	sortOrder = 5,
})
-------------------------------------------------------------------------------------------

TEAM_W_ENLISTED = DarkRP.createJob("3rd Infantry: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/en/m40_s1_01.mdl"
	},
    description = "An enlisted-man of the 3rd Wehrmacht Light Infantry Division.",
    weapons = {"doi_atow_k98k", "doi_atow_bayonetde"},
    command = "axis_w_enlisted",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 3rd Wehrmacht Infantry Division",
	sortOrder = 1,
})	

TEAM_W_UNTERSCHARFUHRER = DarkRP.createJob("3rd Infantry: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/nco/m40_s1_01.mdl"
	},
    description = "An NCO of the 3rd Wehrmacht Light Infantry Division.",
    weapons = {"doi_atow_g43", "doi_atow_bayonetde"},
    command = "axis_w_nco",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 3rd Wehrmacht Infantry Division",
	sortOrder = 2,
})	

TEAM_W_OFFICER = DarkRP.createJob("3rd Infantry: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/co/m38_s1_01.mdl"
	},
    description = "An officer of the 3rd Wehrmacht Light Infantry Division.",
    weapons = {"doi_atow_p38", "doi_atow_binocularsde"},
    command = "axis_w_officer",
    max = 0,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 3rd Wehrmacht Infantry Division",
	sortOrder = 3,
})	

TEAM_W_MG = DarkRP.createJob("3rd Infantry: Maschinengewehrschütze", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/infantry/en/m40_s1_01.mdl"
	},
    description = "An machinegunner for the 3rd Wehrmacht Light Infantry Division. May hold the maximum rank of Sturmcharfuhrer.",
    weapons = {"doi_atow_mg42", "doi_atow_p38"},
    command = "axis_w_mg",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 3rd Wehrmacht Infantry Division",
	sortOrder = 4,
})	

TEAM_W_MEDIC = DarkRP.createJob("3rd Infantry: Sanitater", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/gd_heer/medic/en/m36_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/gd_heer/medic/en/m36_s1_02.mdl",
	},
    description = "An medic for the 3rd Wehrmacht Light Infantry Division. May hold the maximum rank of Sturmcharfuhrer.",
    weapons = {"fas2_ifak", "doi_atow_p38"},
    command = "axis_w_medic",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Axis: 3rd Wehrmacht Infantry Division",
	sortOrder = 5,
})
	
--[[---------------------------------------------------------------------------
Allies
---------------------------------------------------------------------------]]	
TEAM_US_COLONEL = DarkRP.createJob("US Army: Colonel", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_06.mdl",
	},
    description = "In charge of all operations within the US Army.",
    weapons = {"doi_atow_m1911a1", "gred_artisweps_ww2_allied", "weapon_cuff_elastic"},
    command = "allies_us_colonel",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: High Command",
	sortOrder = 1,
})

TEAM_AIR_COLONEL = DarkRP.createJob("US Airbourne: Colonel", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_06.mdl",
	},
    description = "In charge of all operations within the US Army.",
    weapons = {"doi_atow_m1911a1", "gred_artisweps_ww2_allied", "weapon_cuff_elastic"},
    command = "allies_air_colonel",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: High Command",
	sortOrder = 2,
})

TEAM_GB_COLONEL = DarkRP.createJob("Commonwealth: Colonel", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/commonwealth_redux/co_pm.mdl",
	},
    description = "In charge of all operations within the commonwealth.",
    weapons = {"doi_atow_webley", "gred_artisweps_ww2_allied", "weapon_cuff_elastic"},
    command = "allies_gb_colonel",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: High Command",
	sortOrder = 3,
})

TEAM_US_ENLISTED = DarkRP.createJob("US 4th Infantry: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_06.mdl",
	},
    description = "An enlisted-man of the United States 4th Infantry Division.",
    weapons = {"doi_atow_m1garand", "doi_atow_bayonetus"},
    command = "allies_us_enlisted",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 4th Infantry Division",
	sortOrder = 1,
})	

TEAM_US_NCO = DarkRP.createJob("US 4th Infantry: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_06.mdl",
	},
    description = "An NCO of the United States 4th Infantry Division.",
    weapons = {"doi_atow_m1garand", "doi_atow_bayonetus"},
    command = "allies_us_nco",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 4th Infantry Division",
	sortOrder = 2,
})

TEAM_US_OFFICER = DarkRP.createJob("US 4th Infantry: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_06.mdl",
	},
    description = "An officer of the United States 4th Infantry Division.",
    weapons = {"doi_atow_m1a1", "doi_atow_sw1917", "doi_atow_binocularsus"},
    command = "allies_us_officer",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 4th Infantry Division",
	sortOrder = 3,
})

TEAM_US_MEDIC = DarkRP.createJob("US Army: Medic", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/medic/en/m41_s1_06.mdl",
	},
    description = "A medic of the United States 4th Infantry Division.",
    weapons = {"doi_atow_sw1917", "fas2_ifak"},
    command = "allies_us_medic",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 4th Infantry Division",
	sortOrder = 4,
})	

TEAM_US_SNIPER = DarkRP.createJob("US Army: Sniper", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_06.mdl",
	},
    description = "A sniper of the United States 4th Infantry Division.",
    weapons = {"doi_atow_m1903a3", "doi_atow_sw1917"},
    command = "allies_us_sniper",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 4th Infantry Division",
	sortOrder = 5,
})

---------------------------------------------


TEAM_AIR_ENLISTED = DarkRP.createJob("US 101st Airbourne: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m41_s1_06.mdl",
	},
    description = "An enlisted-man of the United States 101st Airbourne Division.",
    weapons = {"doi_atow_sw1917"},
    command = "allies_air_enlisted",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 101st Airbourne Division",
	sortOrder = 1,
})	

TEAM_AIR_NCO = DarkRP.createJob("US 101st Airbourne: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/nco/m37_s1_06.mdl",
	},
    description = "An NCO of the United States 101st Airbourne Division.",
    weapons = {"doi_atow_sw1917"},
    command = "allies_air_nco",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 101st Airbourne Division",
	sortOrder = 2,
})

TEAM_AIR_OFFICER = DarkRP.createJob("US 101st Airbourne: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/co/m41_s1_06.mdl",
	},
    description = "An officer of the United States 101st Airbourne Division.",
    weapons = {"doi_atow_sw1917", "doi_atow_binocularsus"},
    command = "allies_air_officer",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 101st Airbourne Division",
	sortOrder = 3,
})

TEAM_AIR_PARATROOPER = DarkRP.createJob("US 101st Airbourne: Paratrooper", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_06.mdl",
	},
    description = "A sniper of the United States 4th Infantry Division.",
    weapons = {"doi_atow_sw1917", "doi_atow_m1carbine"},
    command = "allies_air_paratrooper",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 101st Airbourne Division",
	sortOrder = 4,
})

TEAM_AIR_PARATROOPER_OFFICER = DarkRP.createJob("US 101st Airbourne: Paratrooper Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_06.mdl",
	},
    description = "A sniper of the United States 4th Infantry Division.",
    weapons = {"doi_atow_sw1917", "doi_atow_m1carbine", "doi_atow_binocularsus"},
    command = "allies_air_paratrooper_officer",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: US 101st Airbourne Division",
	sortOrder = 6,
})
--[-------------------------------------------------------------------] ---
TEAM_GB_ENLISTED = DarkRP.createJob("11th Armoured: Enlisted", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/player/player_british_01.mdl",
		"models/player/player_british_02.mdl",
		"models/player/player_british_03.mdl",
		"models/player/player_british_04.mdl",
		"models/player/player_british_indian_01.mdl",
		"models/player/player_british_indian_02.mdl",
	},
    description = "A enlisted-man of the commonwealth, serving under the Great British 11th Armoured Division.",
    weapons = {"doi_atow_enfield", "doi_atow_bayonetcw",},
    command = "allies_gb_enlisted",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 1,
})

TEAM_GB_NCO = DarkRP.createJob("11th Armoured: NCO", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/player/player_british_03.mdl",
		"models/player/player_british_02.mdl",
		"models/player/player_british_01.mdl",
		"models/player/player_british_04.mdl",
		"models/player/player_british_indian_01.mdl",
		"models/player/player_british_indian_02.mdl",
	},
    description = "An NCO of the commonwealth, serving under the Great British 11th Armoured Division.",
    weapons = {"doi_atow_enfield", "doi_atow_owen", "doi_atow_bayonetcw"},
    command = "allies_gb_nco",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 2,
})

TEAM_GB_OFFICER = DarkRP.createJob("11th Armoured: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/commonwealth_redux/co_pm.mdl",
	},
    description = "A officer of the Commonwealth, serving under the Great British 11th Armoured Division.",
    weapons = {"doi_atow_welrod", "doi_atow_binocularscw"},
    command = "allies_gb_officer",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 3,
})

TEAM_GB_REME = DarkRP.createJob("11th Armoured: REME", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/player/player_british_02.mdl",
		"models/player/player_british_01.mdl",
		"models/player/player_british_03.mdl",
		"models/player/player_british_04.mdl",
		"models/player/player_british_indian_01.mdl",
		"models/player/player_british_indian_02.mdl",
	},
    description = "A Royal Electrical and Mechanical Engineer of the Commonwealth, serving under the Great British 11th Armoured Division.",
    weapons = {"doi_atow_welrod", "weapon_simrepair", "doi_atow_etoolcw"},
    command = "allies_gb_reme",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 4,
})

TEAM_GB_TANKDESTROYER = DarkRP.createJob("11th Armoured: Tank Destroyer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_01.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_02.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_03.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_04.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_05.mdl",
		"models/hts/comradebear/pm0v3/player/usarmy/infantry/en/m43hbtcamo_s1_06.mdl",
	},
    description = "A Tank destroyer of the Commonwealth, serving under the Great British 11th Armoured Division.",
    weapons = {"doi_atow_welrod", "atr_boys", "weapon_doimills"},
    command = "allies_gb_tankdestroyer",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 4,
})

/*
TEAM_GB_PARATROOPER = DarkRP.createJob("6th Parachute Battalion: Paratrooper", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/britairborne1pm.mdl",
		"models/britairborne2pm.mdl",
		"models/britairborne3pm.mdl",
		"models/britairborne4pm.mdl",
		"models/britairborne5pm.mdl",
		"models/britairborne6pm.mdl",
	},
    description = "A paratrooper of the Commonwealth, serving under the 6th Parachute Division- Royal Welch.",
    weapons = {"doi_atow_owen"},
    command = "allies_gb_paratrooper",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 5,
})

TEAM_GB_PARATROOPER_OFFICER = DarkRP.createJob("6th Parachute Battalion: Officer", {
    color = Color(150, 150, 150, 255),
    model = {
		"models/britairborne1pm.mdl",
		"models/britairborne2pm.mdl",
		"models/britairborne3pm.mdl",
		"models/britairborne4pm.mdl",
		"models/britairborne5pm.mdl",
		"models/britairborne6pm.mdl",
	},
    description = "An officer of the Commonwealth, serving under the 6th Parachute Division- Royal Welch.",
    weapons = {"doi_atow_welrod", "doi_atow_owen", "doi_atow_binocularscw"},
    command = "allies_gb_paratrooper_officer",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Allies: British Commonwealth",
	sortOrder = 6,
})
*/
--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if emoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CIV