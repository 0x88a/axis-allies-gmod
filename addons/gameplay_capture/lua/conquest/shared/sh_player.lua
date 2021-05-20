
Conquest.player = Conquest.player or {}


local function getTeamCommand(command)
	for k,v in pairs(RPExtraTeams) do

			if v.command == command then

				return v

			end

	end
end

function Conquest.player:GetIconColor(flag)
	local darkrp = Conquest.Config.get("darkrp", false)
	if (flag.category) then

		if (darkrp) then
			local categories = DarkRP.getCategories().jobs

			for _, cat in pairs(categories) do
				if cat.name == flag.owner then
					return cat.color
				end
			end
		
		else
			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0, 255)
		end
	else
		if (darkrp == true) then

			local team = getTeamCommand(flag.owner)

			if (team) then
				return team.color
			end

			
		else

			for k,v in pairs(team.GetAllTeams()) do

				if v.Name == flag.owner then

					return v.Color

				end

			end

			return Color(255, 0, 0)

		end
	end

	return Color(255, 0, 0)
end

function Conquest.player:GetLocalColor(ply)

	if Conquest.Config.get("darkrp", false) then

		local job = RPExtraTeams[ply:Team()]
		return job.color

	else

		return team.GetColor(ply:Team())

	end
end

