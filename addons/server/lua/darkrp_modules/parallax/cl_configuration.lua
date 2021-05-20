F4menu = F4menu or {}
F4menu.configuration = {}

F4menu.configuration.general = {
	banner = " ",
	// The banner to use up top of the F4. Make this value>      false     <to disable.
	// This can be a link to an image (has to start with http:// or https://), a material <Material("banner.png")> or text.
	// Has to be png.
	// Use the dimensions 3488 x 537 or something with the same aspect ratio or it might stretch.

	money_symbol = "$",
	
	time_and_date = false,
	// Whether or not to display the time in the top left corner of the screen.

	theme = "default",

	color = Color(96, 114, 186),

	themes = {
		["default"] = {
			blur_background = true,
			text = Color(235, 235, 235),
			background = Color(28, 28, 27, 230),
			player_background = Color(0, 0, 0, 50),
			job_background = Color(0, 0, 0, 50),
			list_background = Color(0, 0, 0, 50),
			listing_background = Color(0, 0, 0, 50),
			listing_header = Color(0, 0, 0, 150),
		},
	},
}

F4menu.configuration.tabs = {
	jobs = {
		// Whether to enable or not
		enable = true,
		
		// What color to use for the tab in the menu
		color = Color(96, 114, 186),
	},

	ents = {
		enable = false,
		color = Color(255, 175, 50),
	},

	weapons = {
		enable = false,
		color = Color(255, 175, 50),
	},

	shipments = {
		enable = false,
		color = Color(255, 175, 50),
	},

	vehicles = {
		enable = false,
		color = Color(255, 175, 50),
	},

	ammunition = {
		enable = false,
		color = Color(255, 175, 50),
	},
	
	food = {
		enable = false,
		color = Color(255, 175, 50),

		// Since food doesnt categorize properly please add your cook team here so only the cook is able to see the menu.
		// Remove this to make everyone be able to see the food tab
		allowed = {TEAM_COOK},
	},
}

F4menu.configuration.webtabs = {
	--["Website"] = {url = "http://google.com", color = Color(115, 168, 205)},
	["Rules"] = {
		html = [[
			<html>
			<style>
				body {
				  color: #cccccc;
				  font-family: Arial;
				  font-weight: 500;
				}
				
				@keyframes fadeInAnimation {
					0% {
						opacity: 0;
					}
					100% {
						opacity: 1;
					 }
				}
			</style>
			<body>
				<h2> 
					General Rules
				</h2>
					Don't RDM - don't kill someone without a valid reason. <br>
						<a style="margin-left: 15px;"> - Killing minorities is permitted. eg. African Americans, women.</a> <br>
						<a style="margin-left: 15px;"> - You may kill someone in self-defence. <br> </a>
						<a style="margin-left: 15px;"> - You may kill members of the opposite faction, unless under orders not to, eg. cease fire. <br></a>
						NLR applies in non-combat situations, eg. killing someone trying to rat you out. <br>
					Roleplay as the job you are playing. <br>
					Don't metagame - using out of character information in-game. <br>
				
				<h2> Gameplay Rules </h2>
					<b> <i> Breaking gameplay rules may result in demotion, rather than staff punishment </i> </b> <br>
					Upon becoming an officer and all ranks above, you may promote up to 3 ranks below. <br>
					High Command may promote up to one rank below them. <br>
					You may only be promoted once per day. <br>
					Anti-tank roles may only shoot armoured vehicles. <br>
					You may not fake your rank unless you steal a uniform from someone, otherwise, you must wear the rank you are. <br>
					Engineers may not heal tanks during active combat. <br>
			</body>
			</html>
		
		
		
		]],
		color = Color(96, 114, 186)
	},
	
	
	["Ranks"] = {
		html = [[
<html>
  <style>
    body {
      color: #cccccc;
    }
	
  </style>
  <body>
<h2 align="center">
  <span style="font-weight: 400">
    <font face="Arial" size="4">General Officers
    </font>
  </span>
</h2>
  <table border="1" width="100%" id="table11">
    <tbody>
      <tr>
		<th width="25%">
          <p align="center">
            <span style="font-weight: 400">
              <font face="Arial"><br><b>SS Rank</b>
              </font>
            </span>
          </p>
        </th>
        <th width="25%">
          <p align="center">
            <span style="font-weight: 400">
              <font face="Arial"><br><b>Wehrmacht
                Rank </b>
              </font>
            </span>
          </p>
        </th>
        <th width="25%">
          <p align="center">
            <span style="font-weight: 400">
              <font face="Arial"><br><b>American
                Rank</b>
              </font>
            </span>
          </p>
        </th>
        <th width="25%">
          <p align="center">
            <span style="font-weight: 400">
              <font face="Arial"><br><b>British Rank</b>
              </font>
            </span>
          </p>
        </th>
      </tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Der 
              Oberste Führer der
              Schutzstaffel
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Oberste Führer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>President
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <span lang="en-gb">
              <font face="Arial"><br>
                Prime Minister
              </font>
            </span>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Reichsführer-SS
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
      </tr>
	  
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Volksmarschall
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Generalfeldmarschall
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>General of the Army
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Field Marshall
            </font>
          </p>
        </td>
      </tr>
	  
	  
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>
              SS-OberstgruppenFührer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Generaloberst
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>General
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>General
            </font>
          </p>
        </td>
      </tr>
	  
	  
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-ObergruppenFührer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>General der
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Lieutenant General
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Lieutenant General
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-Gruppenführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Generalleutnant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Major General
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Major General
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-Brigadeführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>General major
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Brigadier General
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Brigadier
            </font>
          </p>
        </td>
      </tr>

</table>	  
<h2 align="center">
  <span style="font-weight: 400">
    <font face="Arial" size="4">Commissioned Officers
    </font>
  </span>
</h2>
<table border="1" cellpadding="7" cellspacing="1" width="100%" id="table13">
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-Oberführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>None
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-Standartenführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Oberst
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Colonel
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Colonel
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-ObersturmbannFührer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Oberstleutnant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Lieutenant Colonel
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Lieutenant Colonel
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-Sturmbannführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Major
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Major
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Major
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-HauptsturmFührer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Hauptmann
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Captain
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Captain
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>SS-ObersturmFührer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Oberleutnant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>1st Lieutenant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Lieutenant
            </font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>
              SS-Untersturmführer
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>Leutnant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>2nd Lieutenant
            </font>
          </p>
        </td>
        <td width="25%">
          <p align="center">
            <font face="Arial"><br>2nd Lieutenant
            </font>
          </p>
        </td>
      </tr>
    </tbody>
  </table>
  </div>
  
<h2 align="center">
  <span style="font-weight: 400">
    <font face="Arial" size="4">Non-Commissioned Officers
    </font>
  </span>
</h2>
<table border="1" cellpadding="7" cellspacing="1" width="100%" id="table12">
  <tbody>
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Sturmscharführer
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Stabsfeldwebel
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Sergeant Major
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Regimental Sergeant Major
        </font>
      </td>
    </tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Hauptscharführer
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Oberfeldwebel
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Master Sergeant
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Battalion Sergeant Major
        </font>
      </td>
    </tr>
	
	
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Oberscharführer
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Feldwebel
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Sergeant 
          1st Class
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Company Sergeant Major
        </font>
      </td>
    </tr>
	
	
    
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Scharführer
        </font>
      </td>

      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Unterfeldwebel
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Staff Sergeant
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Platoon Sergeant Major
        </font>
      </td>
    </tr>
	
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Unterscharführer
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Unteroffizier
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Sergeant
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Sergeant
        </font>
      </td>
    </tr>
	
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Rottenführer
        </font>
      </td>

      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Obergefreiter
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Corporal
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Corporal
        </font>
      </td>
    </tr>
  </tbody>
</table>
<h2 align="center">
  <span style="font-weight: 400">
    <font face="Arial" size="4">Enlisted Ranks
    </font>
  </span>
</h2>
<table border="1" cellpadding="7" cellspacing="1" width="100%" id="table13">
  <tbody>
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Sturmmann
        </font>
      </td>

      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Gefreiter
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          None
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Lance Corporal
        </font>
      </td>
    </tr>
	
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Oberschüze
        </font>
      </td>

      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Oberschüze
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Private 
          1st Class
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          None
        </font>
      </td>
    </tr>
	
    <tr>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          SS-Schüze
        </font>
      </td>

      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Schüze
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Private
        </font>
      </td>
      <td valign="top" width="25%" align="center">
        <font face="Arial">
          <br>
          Private
        </font>
      </td>
    </tr>
  </tbody>
</table>
</body>
</html>		
	
		]],
		color = Color(96, 114, 186)
	},
	
	
	["Medals"] = {
		html = [[
		  <style>
			body {
			  color: #cccccc;
			}
			
		  </style>
		  <h3> Axis Medals </h3>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/grand_cross.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Star of the Grand Cross of the Iron Cross </a><br>
			<i style="font-size: 13px;"> A higher class of the Grand Cross of the Iron Cross. </i> <br>
			<i style="font-size: 13px;"> grand_cross </i> <br>
		  </div>
			<br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/knights_oak_leaves_swords_diamonds_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Knight's Cross of the Iron Cross with Golden Oak Leaves, Swords and Diamonds </a><br>
			<i style="font-size: 13px;"> To be awarded after World War II to Germany's 12 greatest war heroes. </i> <br>
			<i style="font-size: 13px;"> knights_oak_leaves_swords_diamonds_gold </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/knights_oak_leaves_swords_diamonds.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Knight's Cross of the Iron Cross with Oak Leaves, Swords and Diamonds </a><br>
			<i style="font-size: 13px;"> For continuous bravery before the enemy or excellence in commanding troops after being awarded all preceding classes of the Knight's Cross/Iron Cross. </i> <br>
			<i style="font-size: 13px;"> knights_oak_leaves_swords_diamonds </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/knights_oak_leaves_swords.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Knight's Cross of the Iron Cross with Oak Leaves and Swords </a><br>
			<i style="font-size: 13px;"> For continuous bravery before the enemy or excellence in commanding troops after being awarded all preceding classes of the Knight's Cross/Iron Cross. </i> <br>
			<i style="font-size: 13px;"> knights_oak_leaves_swords </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/knights_oak_leaves.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Knight's Cross of the Iron Cross with Oak Leaves </a><br>
			<i style="font-size: 13px;"> For continuous bravery before the enemy or excellence in commanding troops after being awarded all preceding classes of the Knight's Cross/Iron Cross. </i> <br>
			<i style="font-size: 13px;"> knights_oak_leaves </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/knights_cross.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Knight's Cross of the Iron Cross </a><br>
			<i style="font-size: 13px;"> For continuous bravery before the enemy or excellence in commanding troops after being awarded all preceding classes of the Knight's Cross/Iron Cross. </i> <br>
			<i style="font-size: 13px;"> knights_cross </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/german_cross_diamonds.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> German Cross in Gold with Diamonds </a><br>
			<i style="font-size: 13px;"> To be awarded for continuous bravery before the enemy or excellence in commanding troops (having already been awarded the German Cross in Gold). </i> <br>
			<i style="font-size: 13px;"> german_cross_diamonds </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/german_cross_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> German Cross in Gold </a><br>
			<i style="font-size: 13px;"> For continuous bravery before the enemy or excellence in commanding troops (not justifying the Knight's Cross of the Iron Cross but having already been awarded the Iron Cross 1st Class). </i> <br>
			<i style="font-size: 13px;"> german_cross_gold </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/german_cross_silver.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> German Cross in Gold </a><br>
			<i style="font-size: 13px;"> For significant performances in aiding the military war effort. (Not justifying the Knight's Cross of either the Iron Cross or the War Merit Cross but having already been awarded the Iron Cross 1st Class or War Merit Cross 1st Class). </i> <br>
			<i style="font-size: 13px;"> german_cross_silver </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/iron_cross_first.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Iron Cross (1st Class) </a><br>
			<i style="font-size: 13px;">  For continuous bravery before the enemy or excellence in commanding troops after being awarded the Iron Cross 2nd class. </i> <br>
			<i style="font-size: 13px;"> iron_cross_first </i> <br>
		  </div>
		  <br> <br> <br>		
		  <div>
			<img src="http://darklight.xyz/gmod/medals/iron_cross_second.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Iron Cross (2nd Class) </a><br>
			<i style="font-size: 13px;"> For bravery before the enemy or excellence in commanding troops. </i> <br>
			<i style="font-size: 13px;"> iron_cross_second </i> <br>	
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/iron_cross_clasp.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> 1939 Clasp to the Iron Cross </a><br>
			<i style="font-size: 13px;"> An award of the Iron Cross, 1st or 2nd class for those who had already received the decoration in World War I. </i> <br>
			<i style="font-size: 13px;"> iron_cross_clasp </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/war_merit.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> War Merit </a><br>
			<i style="font-size: 13px;"> Awarded with and without swords. For meritorious contributions to the war effort. </i> <br>
			<i style="font-size: 13px;"> war_merit </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/w_4.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wehrmacht 4 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to army, navy, and air force for continues service. </i> <br>
			<i style="font-size: 13px;"> w_4 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/w_12.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wehrmacht 12 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to army, navy, and air force for continues service. </i> <br>
			<i style="font-size: 13px;"> w_12 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/w_18.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wehrmacht 18 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to army, navy, and air force for continues service. </i> <br>
			<i style="font-size: 13px;"> w_18 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/w_25.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wehrmacht 25 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to army, navy, and air force for continues service. </i> <br>
			<i style="font-size: 13px;"> w_25 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/w_40.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wehrmacht 40 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to army, navy, and air force for continues service. </i> <br>
			<i style="font-size: 13px;"> w_40 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/ss_4.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> SS 4 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to SS men for continues service. </i> <br>
			<i style="font-size: 13px;"> ss_4 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/ss_8.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> SS 8 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to SS men for continues service. </i> <br>
			<i style="font-size: 13px;"> ss_8 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/ss_12.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> SS 12 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to SS men for continues service. </i> <br>
			<i style="font-size: 13px;"> ss_12 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/ss_25.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> SS 25 Year Long Service Award </a><br>
			<i style="font-size: 13px;"> Awarded to SS men for continues service. </i> <br>
			<i style="font-size: 13px;"> ss_25 </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/infantry_assault.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Infantry Assault Badge </a><br>
			<i style="font-size: 13px;"> To have taken part in at least three: infantry assaults (including counter-attacks) or at least three armed reconnaissance operations or engaged in hand-to-hand combat in an assault position or participated on three separate days in the reestablishment of combat positions. </i> <br>
			<i style="font-size: 13px;"> infantry_assault </i> <br>
		 </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/general_assault.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> General Assault Badge </a><br>
			<i style="font-size: 13px;"> Awarded for participation/support in infantry attacks that did not qualify for the Infantry Assault Badge. </i> <br>
			<i style="font-size: 13px;"> general_assault </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/combat_clasp_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Close Combat Clasp </a><br>
			<i style="font-size: 13px;"> Awarded for continuous combat in three different grades: gold, silver and bronze. </i> <br>
			<i style="font-size: 13px;"> combat_clasp_grade (combat_clasp_gold) etc </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/tank_battle_badge.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Tank Battle Badge </a><br>
			<i style="font-size: 13px;"> Awarded as an award to tank crews who had actively participated in three armoured assaults on different days. Awarded in Gold and Silver. </i> <br>
			<i style="font-size: 13px;"> tank_battle_badge </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/para_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Parachutist Badge </a><br>
			<i style="font-size: 13px;"> Awarded as a badge to qualified parachutists of the Wehrmacht and the Waffen-SS of Nazi Germany. Silver and Gold Versions existed. </i> <br>
			<i style="font-size: 13px;"> para_gold or para_silver </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/tank_destruction_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Tank Destruction Badge </a><br>
			<i style="font-size: 13px;"> Silver badge was awarded for the single-handed destruction of a tank. Gold version for five tanks. </i> <br>
			<i style="font-size: 13px;"> tank_destruction_gold / silver </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/luftwaffe_clasp_one.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Luftwaffe Flying Badge </a><br>
			<i style="font-size: 13px;"> Awarded in various grades- one through six - for exceptional flying. </i> <br>
			<i style="font-size: 13px;"> luftwaffe_clasp_ one-six </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/high_seas_fleet.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> High Seas Fleet Badge </a><br>
			<i style="font-size: 13px;"> To be eligible to receive the badge one must have 12 weeks service on a battleship or cruiser, with proof of distinction and good conduct.  </i> <br>
			<i style="font-size: 13px;"> high_seas_fleet </i> <br>
		  </div>
		  <br> <br> <br>
		  <div>
			<img src="http://darklight.xyz/gmod/medals/flak_badge.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Anti-Aircraft Flak Battle Badge </a><br>
			<i style="font-size: 13px;"> It was awarded after the accumulation of 16 points or could also be awarded outside of the points system for an act of merit or bravery in the performance of air defense duties.  </i> <br>
			<i style="font-size: 13px;"> flak_badge </i> <br>
		  </div>
		  <br> <br> <br>		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/wound_gold.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wound Badges </a><br>
			<i style="font-size: 13px;"> Awarded for being wounded- classes of gold, silver and black were awarded depending on severity of wound. </i> <br>
			<i style="font-size: 13px;"> wound_grade (gold, silver & black)</i> <br>
		  </div>
		  <br> <br> <br> <br> <br>

		<h3> Allied Medals </h3>	

		  <div>
			<img src="http://darklight.xyz/gmod/medals/gb_george_cross.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> George Cross </a><br>
			<i style="font-size: 13px;"> It was the second highest award of the United Kingdom honours system and it’s awarded “for acts of the greatest heroism or for most conspicuous courage in circumstance of extreme danger“, not in the presence of the enemy, to members of the British armed forces and to British civilians. </i> <br>
			<i style="font-size: 13px;"> gb_george_cross </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/gb_george_medal.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> George Medal </a><br>
			<i style="font-size: 13px;"> Awardeed as an award for gallantry “not in the face of the enemy” where the services were not so outstanding as to merit the George Cross. </i> <br>
			<i style="font-size: 13px;"> gb_george_medal </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/gb_wound.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Wounded Medal </a><br>
			<i style="font-size: 13px;"> Was issued to servicemen who, as a result of their injuries, had been discharged from active service. </i> <br>
			<i style="font-size: 13px;"> gb_wound </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/gb_war_service.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> War Service Medal </a><br>
			<i style="font-size: 13px;"> The medal was awarded to subjects of the British Commonwealth who had served full-time (28 days of service) in the Armed Force </i> <br>
			<i style="font-size: 13px;"> gb_war_service </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/gb_victoria_cross.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Victoria Cross </a><br>
			<i style="font-size: 13px;"> The Victoria Cross is the highest award of the United Kingdom honors system. It is awarded for gallantry “in the presence of the enemy” to members of the British armed forces, and it can be awarded posthumously.</i> <br>
			<i style="font-size: 13px;"> gb_victoria_cross </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_purple_heart.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Purple Heart </a><br>
			<i style="font-size: 13px;"> The Purple Heart is a military decoration from the United States awarded in the name of the president to those wounded or killed. </i> <br>
			<i style="font-size: 13px;"> us_purple_heart </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_bronze_star.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Bronze Star </a><br>
			<i style="font-size: 13px;"> Was awarded to members of the United States Armed Forces for either heroic achievement, heroic service, meritorious achievement, or meritorious service in a combat zone. </i> <br>
			<i style="font-size: 13px;"> us_bronze_star </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_legion_of_merit.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> George Corss </a><br>
			<i style="font-size: 13px;"> Given for exceptionally meritorious conduct in the performance of outstanding services and achievements. </i> <br>
			<i style="font-size: 13px;"> us_legion_of_meri </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_legion_of_merit.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> George Corss </a><br>
			<i style="font-size: 13px;"> Given for exceptionally meritorious conduct in the performance of outstanding services and achievements. </i> <br>
			<i style="font-size: 13px;"> us_legion_of_meri </i> <br>
		  </div>
		  <br> <br> <br>

		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_service.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> The Distinguished Service Cross </a><br>
			<i style="font-size: 13px;"> The Distinguished Service Cross is the second highest United States Army military award that can be given for extreme gallantry and risk of life in actual combat with an armed enemy force. </i> <br>
			<i style="font-size: 13px;"> us_service </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  <div>
			<img src="http://darklight.xyz/gmod/medals/us_moh.png" style="float: left; width: 85; height: 85;border-radius: 5%; margin-left: -15; margin-right: 5;">
			<a style="font-size: 17px;"> Medal of Honor </a><br>
			<i style="font-size: 13px;"> The Medal of Honor is the United States of America’s highest and most prestigious personal military decoration. It may be awarded to recognize U.S. military service members who distinguished themselves by acts of valor. </i> <br>
			<i style="font-size: 13px;"> us_moh </i> <br>
		  </div>
		  <br> <br> <br>
		  
		  ]],
		color = Color(96, 114, 186)
	},
}


