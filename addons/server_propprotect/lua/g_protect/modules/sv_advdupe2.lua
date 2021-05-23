local cfg = gProtect.GetConfig(nil,"advdupe2")

gProtect = gProtect or {}

gProtect.HandleAdvDupe2ToolGun = function(ply, tr, tool)
	if cfg.enabled then
		if tool == "advdupe2" then
			if cfg.PreventUnfreezeAll then
				local toolgun = ply:GetTool(tool)
				if tobool(toolgun:GetClientInfo("paste_unfreeze")) then
				if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-unfreeze-all", 3) end
				return false end
			end

			if ply.AdvDupe2 and ply.AdvDupe2.Entities and (cfg.PreventScaling > 0 or cfg.PreventNoGravity > 0) then
				for k, v in pairs(ply.AdvDupe2.Entities) do
					if v.ModelScale then
						if cfg.PreventScaling == 1 then
							if v.ModelScale > 1 then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-upscaled-ent", 3) end return false end
						end
						
						if cfg.PreventScaling == 2 then
							if v.ModelScale > 1 then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-upscaled-ent", 3) end ply.AdvDupe2.Entities[k].ModelScale = 1 end
						end
					end

					if istable(v.BoneMods) then
						for i, z in pairs(v.BoneMods) do
							if z.physprops and !z.physprops.GravityToggle then 
								if cfg.PreventNoGravity == 1 then
									if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-no-gravity", 3) end return false
								end

								if cfg.PreventNoGravity == 2 then
									ply.AdvDupe2.Entities[k].BoneMods[i].physprops.GravityToggle = true
									if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-no-gravity", 3) end
								end	
							end
						end
					end

					if v.EntityMods and v.EntityMods.trail then
						if cfg.PreventTrail == 1 then
							if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-trail", 3) end return false
						end

						if cfg.PreventTrail == 2 then
							ply.AdvDupe2.Entities[k].EntityMods.trail = nil
							if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-trail", 3) end
						end	
					end

					if v.CollisionGroup then
						if cfg.BlacklistedCollisionGroups[v.CollisionGroup] then
							ply.AdvDupe2.Entities[k].CollisionGroup = 0
						end
					end
				end
			end
			
			if ply.AdvDupe2 and ply.AdvDupe2.Constraints and cfg.PreventRopes > 0 then
				if istable(ply.AdvDupe2.Constraints) then					
					for k, v in pairs(ply.AdvDupe2.Constraints) do
						if !v.Type then continue end

						if !cfg.WhitelistedConstraints[string.lower(v.Type)] then
							ply.AdvDupe2.Constraints[k] = nil
						end

						if string.lower(v.Type) == "rope" then
							if cfg.PreventRopes == 1 then
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-rope-spawning", 3) end
								return false
							end
							if cfg.PreventRopes == 2 then
								ply.AdvDupe2.Constraints[k] = nil 
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-rope-spawning", 3) end
							end
						end
					end
				end
			end
		end
	end
	return true
end

hook.Add("gP:ConfigUpdated", "gP:UpdateAdvDupe2", function(updated)
	if updated ~= "advdupe2" then return end
	cfg = gProtect.GetConfig(nil,"advdupe2")
end)