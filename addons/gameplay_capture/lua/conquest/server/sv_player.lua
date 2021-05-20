// Maybe a useless file in the end? //

Conquest.player = Conquest.player or {}

function Conquest.player:getTeam(pPlayer)
	if DarkRP then
		// Better to return a command so we can just use the command to find the category if opton is enabled. //
		return pPlayer:getJobTable().command
	else
		return team.GetName(pPlayer:Team())
	end
end

function Conquest.player:getCategory(pPlayer)
	if !DarkRP then return false end 

	return pPlayer:getJobTable().category or false
end


// This is so heavy
function Conquest.player:GetCacheTeam(pPlayer)
	local playerTeam = pPlayer:Team()

	return Conquest.TeamManager.QuickCache[playerTeam] or false

end

function Conquest.player:getPlayersByCat(strCat)

	local players = {}

	for k,v in pairs(player.GetAll()) do
		if v:getJobTable().category == strCat then
			table.insert(players, v)
		end
	end

	return players
end

function Conquest.player:getPlayersByTeam(strTeam)
	local players = {}

	for k,v in pairs(player.GetAll()) do
		if (v:getJobTable().command == strTeam) then

			table.insert(players, v)

		end

	end

	return players
end

function Conquest.player:getPlayersByCat(strCat)

	local players = {}

	for k,v in pairs(player.GetAll()) do
		if v:getJobTable().category == strCat then
			table.insert(players, v)
		end
	end

	return players
end

hook.Add( "PlayerSay", "Conquest_OpenMenu", function( ply, text, team )
	local txt = Conquest.Config.get("chatCommand", "/conquest")
	if ( string.lower( text ) == txt ) then
		if Conquest.Config.canEdit(ply) then
			net.Start("conquest_openMain")
			net.Send(ply)
			return ""
		end
	end
end )
