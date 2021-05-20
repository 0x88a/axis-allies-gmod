
-- No need to touch this file --
-- Loads the addons --


Conquest = Conquest or {}
Conquest.config = Conquest.config or {}
Conquest.config.category = false

// Returns the player point, if they're capturing one.
function Conquest.GetPointCapturing(pPlayer)
	local pos = pPlayer:GetPos()

	for k,v in pairs(Conquest.cache) do
		local pointFrom = math.Distance(pos.x, pos.y, v.position.x, v.position.y)

		if tonumber(pointFrom) <= tonumber(v.radius) then
			local yDeg = pos.z - v.position.z

			if (yDeg <= 100 and yDeg >= -30) then

				return v

			end
		end
	end
end

function Conquest.Tick()

	// The easy to tell if the player has moved off the flag //
	Conquest.FlagRemoveTeams()
	Conquest.FlagRemovePlayers()


	for k,v in ipairs(player.GetAll()) do
		local capturePoint = Conquest.GetPointCapturing(v)

		if (!v:Alive()) then continue end

		if (capturePoint) then

			// Team Based flag
			if (capturePoint.teamBased and capturePoint.teamBased == true) then
				
				// It's team based capture. Create whole new function for this
				local capturingTeam = Conquest.player:GetCacheTeam(v)

				if (!capturingTeam) then return end


				capturePoint.capturingTeams[capturingTeam] = true

			else

				// gets player string to contest with (DarkRP: command || Team Name (non darkrp) )
				local playerTeam = Conquest.player:getTeam(v)

				// Prepare tests to see if they can capture
				local canCapture = true


				if (capturePoint.category) then
					local playerCat = Conquest.player:getCategory(v)

					for key, value in pairs(capturePoint.CapturingTeams) do
						if key == playerCat then
							// Already being captured, so whats the point?
							canCapture = true
						end
					end

					// Check to see if its owned by the category already //

					if capturePoint.owner and capturePoint.owner == playerCat then
						canCapture = false
					end

					if (capturePoint.noTeams) then
						for key, value in pairs(capturePoint.noTeams) do
							if value == playerTeam then
								canCapture = false
							end
						end
					end

					// Lazy way of getting a unique indentify capturing by //
					playerTeam = playerCat
					local useCat = true

				end

				if (!useCat) then
					// Repeat function. eh
					if (capturePoint.noTeams) then
						for _, teams in pairs(capturePoint.noTeams) do
							if teams == playerTeam then
								canCapture = false
							end
						end
					end

					for key, value in pairs(capturePoint.CapturingTeams) do
						if key == playerTeam then
							// Already being captured, so whats the point?
							canCapture = true
						end
					end
				end

				if (canCapture) then

					if !capturePoint.CapturingTeams[playerTeam] then
						capturePoint.CapturingTeams[playerTeam] = true
					end

					// Add the player to a cache. For future use.

					table.insert(capturePoint.CapturingPlayers, v)
				end
			end
		end
	end

	for k,v in pairs(Conquest.cache) do
		
		// Check to see if multiple teams exist. They're fighting over it. 
		if (v.owner != nil) then
			hook.Run("Conquest_TickFlag", v.owner, v.name, v)
		end

		if (v.teamBased and v.teamBased == true) then

			local count = table.Count(v.capturingTeams) or 0

			// Only one team on point. We can capture
			if (count == 1) then

				local teamCapturing = Conquest.FlagFirstTeamCapture(v)

				if (teamCapturing != v.owner) then
					
					if (v.isCapturing == nil) then

						v.isCapturing = CurTime()

						hook.Run("Conquest_FlagBeingCaptured", teamCapturing, v)

					else
						local captureTimeLeft = CurTime() - v.isCapturing

						if (tonumber(v.time) <= captureTimeLeft) then

							if (v.owner != nil) then
								hook.Run('Conquest_FlagLost', v.owner, v.name, v)
							end

							v.realOwner = teamCapturing
							v.owner = teamCapturing

							if (Conquest.Config.get("annouceCaptures", false)) then

								PrintMessage( HUD_PRINTTALK, "" .. v.name .. " has been captured by " .. v.owner.. "!")
								
							end


							if (Conquest.Config.get("reward", false)) and (v.reward) then
								

								for j,d in pairs(player.GetAll()) do
									if Conquest.TeamManager.QuickCache[d:Team()] == v.realOwner then

										d:addMoney(v.reward)


										d:PrintMessage(HUD_PRINTTALK, "Your team has been awarded $" .. v.reward .. " for capturing " .. v.name .. "!")

									end
								end

							end

							// Nil flag capturing
							v.isCapturing = nil

							// Set flag color
							if (v.flagent and IsValid(v.flagent)) then
								local clr = Conquest.TeamManager.cache[teamCapturing].color

								if (clr) then

									v.flagent:SetColor(Color(clr.r, clr.g, clr.b, 255))

								end
							end

							hook.Run("Conquest_FlagCaptured", v.owner, v.name, v)


						end


					end

				end

			elseif (count > 1) then

				v.teamIsCapturing = nil
				v.isCapturing = nil
			
			elseif (count == 0) then

				v.teamIsCapturing = nil
				v.isCapturing = nil
			
			end

		else

			local teamsTotal = table.Count(v.CapturingTeams)

			if (teamsTotal > 1) then

				v.isCapturing = nil

			elseif (teamsTotal == 1) then

				local teamCapturing = Conquest.FlagFirstKey(v)

				// they haven't captured the point yet
				if (teamCapturing != v.owner) then
					if (v.isCapturing == nil) then

						v.isCapturing = CurTime()
					else
						// The point has a timer -- being captured
						local captureTimeLeft = CurTime() - v.isCapturing


						if (tonumber(v.time) <= captureTimeLeft) then

							if (v.owner != nil) then
								hook.Run('Conquest_FlagLost', v.owner, v.name, v)
							end

							if DarkRP then

								local jobTbl, jobIndex = DarkRP.getJobByCommand(teamCapturing)
								v.realOwner = jobIndex

							else
								v.realOwner = teamCapturing
							end

							v.owner = teamCapturing

							if (Conquest.Config.get("annouceCaptures", false)) then

								PrintMessage( HUD_PRINTTALK, "" .. v.name .. " has been captured by " .. v.owner.. "!")
								
							end

							v.isCapturing = nil

							v.CapturingPlayers[1]:PrintMessage(HUD_PRINTTALK, "Point captured")

							if v.flagent and IsValid(v.flagent) then
								local color = Conquest.player:GetIconColor(v)
								v.flagent:SetColor(color)
							end

							if (Conquest.Config.get("reward", false)) and (v.reward) then

								print("[Conquest] Awarding player(s) with money.")

								local players = team.GetPlayers(teamCapturing)

								if (DarkRP) then
									players = Conquest.player:getPlayersByTeam(teamCapturing)
								end


									if (players) then

										for i,ply in pairs(players) do

											ply:addMoney(v.reward)

											ply:PrintMessage(HUD_PRINTTALK, "You have been awarded $" .. v.reward .. " for capturing " .. v.name .. "!")


										end

										print("[Conquest][Team Payout] Awarded " .. #players .. " players with a total payout of $" .. (#players * v.reward) .. "!")

									end

								if (Conquest.Config.get("reward_cat", false)) then

									local cat = Conquest.player:getPlayersByCat(teamCapturing)

									if !v.noTeams then return end

									if (cat) then

										for i,ply in pairs(cat) do
											if ply.addingPayout then continue end

											ply.addingPayout = true

											ply:addMoney(v.reward)

											ply:PrintMessage(HUD_PRINTTALK, "You have been awarded $" .. v.reward .. " for capturing " .. v.name .. "!")

											ply.addingPayout = nil

										end

										print("[Conquest][Category Payout] Awarded " .. #cat .. " players with a total payout of $" .. (#cat * v.reward) .. "!")
									end

								end
							end
						end

						hook.Run("Conquest_FlagCaptured", v.owner, v.name)
					end
				end
				
			elseif (teamsTotal == 0) then
				v.isCapturing = nil
			end
		end
	end

	Conquest.FlagNetworkVars()
end


function Conquest.HoldTick()

	local darkrp = Conquest.Config.get("darkrp", false)


	if (darkrp) then
		local rewards = Conquest.Config.get("rewardTickAmount", 25)

		for k,v in pairs(Conquest.cache) do
			if (v.realOwner != nil) then

				if (v.teamBased and v.teamBased == true) then

					local ownedTeam = v.realOwner
					local name = v.name

					local compiledTeams = {}

					for k,v in pairs(Conquest.TeamManager.QuickCache) do
						if (v == ownedTeam) then
							

							table.insert(compiledTeams, k)

						end
						
					end

					for k,v in pairs(player.GetAll()) do
						for i, g in pairs(compiledTeams) do

							if (v:Team() == g ) then
								
								v:addMoney(rewards)

								
								v:PrintMessage(HUD_PRINTTALK, "You have been given $" .. rewards .. " for holding point " .. name .. "!")
								
							end

						end

					end


					continue
				end

				local ourTeam = v.realOwner

				local isTeam = team.Valid(ourTeam)


				if (isTeam) then
					local players = team.GetPlayers(ourTeam)

					if (players) then

						for k,v in pairs(players) do

							v:addMoney(rewards)

						end

					end
					
					continue
				end

				if (!isTeam) then
					// So it's not a team. Check if its a category? 

					local players = Conquest.player:getPlayersByCat(ourTeam)


					if (players) then
						for k,v in pairs(players) do

							v:addMoney(rewards)

						end

					end

				end
			end

		end

	end
end

function Conquest.TickCreate()
	
	if timer.Exists("Conquest_Tick") then
		timer.Remove("Conquest_Tick")
	end

	timer.Create("Conquest_Tick", 1, 0, function()
		Conquest.Tick()
	end) 

	local useTick = Conquest.Config.get("rewardTick", 0)

	if (useTick >= 1) then
		if !timer.Exists("Conquest_HoldTick") then

			timer.Create("Conquest_HoldTick", useTick, 0, function()
				Conquest.HoldTick()
			end)

		end

	end
end

function Conquest.TickRemove()
	if timer.Exists("Conquest_Tick") then
		timer.Remove("Conquest_Tick")
	end
end

hook.Add("PostGamemodeLoaded", "Conquest_Ticker", function()
	Conquest.TickCreate()
end)


resource.AddFile("materials/nykez/settings.png")
resource.AddFile("materials/nykez/tools.png")
resource.AddFile("materials/nykez/plus.png")
resource.AddFile("materials/nykez/edit.png")
resource.AddFile("materials/nykez/clear.png")
resource.AddFile("materials/nykez/circle.png")
resource.AddFile("materials/nykez/square.png")
resource.AddFile("resource/fonts/OpenSans-Bold.ttf")
