local function init()
	
	axisTeams = {
			'Wehrmacht High Command: Oberst',
			'SS High Command: Oberfuhrer',
			'Luftwaffe High Command: Oberst',
			
			'3rd Infantry: Enlisted',
			'3rd Infantry: NCO',
			'3rd Infantry: Officer',
			'3rd Infantry: Maschinengewehrschütze',
			'3rd Infantry: Sanitater',
			
			'2nd SS Panzer: Enlisted',
			'2nd SS Panzer: NCO',
			'2nd SS Panzer: Officer';
			'2nd SS Panzer: Panzeringenieur',
			'2nd SS Panzer: Panzerjäger',
			
			'Luftwaffe Fliegerkorps: Enlisted',
			'Luftwaffe Fliegerkorps: NCO',
			'Luftwaffe Fliegerkorps: Officer',
			'Luftwaffe Fallschirmjäger Korps: Fallschirmjäger',
			'Luftwaffe Fallschirmjäger Korps: Officer',		
	}
	
	alliesTeams = {
		'US Army: Colonel',
		'US Airbourne: Colonel',
		'Commonwealth: Colonel',
		
		'US 4th Infantry: Enlisted',
		'US 4th Infantry: NCO',
		'US 4th Infantry: Officer',
		'US Army: Medic',
		'US Army: Sniper',
		
		'US 101st Airbourne: Enlisted',
		'US 101st Airbourne: NCO',
		'US 101st Airbourne: Officer',
		'US 101st Airbourne: Paratrooper',
		'US 101st Airbourne: Paratrooper Officer',
		
		'11th Armoured: Enlisted',
		'11th Armoured: NCO',
		'11th Armoured: Officer',
		'11th Armoured: REME',
		'11th Armoured: Tank Destroyer',
		'6th Parachute Battalion: Officer',
		}
	
	DarkRP.removeChatCommand("axis")
	DarkRP.removeChatCommand("allies")
	DarkRP.removeChatCommand("advert")
	
	DarkRP.declareChatCommand({
		command = "axis",
		description = "Send comms message to axis.",
		delay = 1.5
	})
	DarkRP.declareChatCommand({
		command = "allies",
		description = "Send comms message to allies.",
		delay = 1.5
	})

	DarkRP.declareChatCommand({
		command = "advert",
		description = "Displays an advertisement to everyone in chat.",
		delay = 1.5
	})	
	
	function contains(list, x)
		for _, v in pairs(list) do
			if v == x then return true end
		end
		return false
	end
	
	
	if SERVER then
		DarkRP.defineChatCommand("axis",function(ply,args)
			-- make sure they have entered a message
			if args == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end
			
			local DoSay = function(text)
			
				if text == "" then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
					return
				end
				
				if not contains(axisTeams, ply:getDarkRPVar("job")) then
					DarkRP.notify(ply, 1, 4, "You are not the right job.")
					return ""
				end
				
				for k,v in pairs(player.GetAll()) do
					local job = v:getDarkRPVar("job")
					local col = team.GetColor(ply:Team())
					if contains(axisTeams, job) then
						DarkRP.talkToPerson(v, Color(163, 32, 32), "[Axis] " .. ply:Nick(), Color(235, 235, 235), text, ply)
					end
				end
			end
			return args, DoSay
		end, 1.5)
		
		--
		
		DarkRP.defineChatCommand("allies",function(ply,args)
			-- make sure they have entered a message
			if args == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end
			
			local DoSay = function(text)
			
				if text == "" then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
					return
				end
				
				if not contains(alliesTeams, ply:getDarkRPVar("job")) then
					DarkRP.notify(ply, 1, 4, "You are not the right job.")
					return ""
				end
				
				for k,v in pairs(player.GetAll()) do
					local job = v:getDarkRPVar("job")
					local col = team.GetColor(ply:Team())
					if contains(alliesTeams, job) then
						DarkRP.talkToPerson(v, Color(62, 88, 193), "[Allies] " .. ply:Nick(), Color(235, 235, 235), text, ply)
					end
				end
			end
			return args, DoSay
		end, 1.5)
		
		DarkRP.defineChatCommand("advert",function(ply,args)
			if args == "" then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
				return ""
			end
			local DoSay = function(text)
				if text == "" then
					DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
					return
				end
				for k,v in pairs(player.GetAll()) do
					local col = team.GetColor(ply:Team())
					DarkRP.talkToPerson(v, col, "[Advert] " .. ply:Nick(), Color(239, 93, 86, 255), text, ply)
				end
			end
			hook.Call("playerAdverted", nil, ply, args)
			return args, DoSay
		end, 1.5)
	end
end

if SERVER then
	if #player.GetAll() > 0 then
		init()
	else
		hook.Add("PlayerInitialSpawn", "dfca-load", init)
	end
else
	hook.Add("InitPostEntity", "dfca-load", init)
end
