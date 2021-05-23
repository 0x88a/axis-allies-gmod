local cfg = gProtect.GetConfig(nil,"anticollide")
local blacklist = gProtect.GetConfig("blacklist", "general")

gProtect = gProtect or {}

local collidedCounter = {}
local timeout = {}

hook.Add("playerBoughtCustomEntity", "gP:AntiColliderDarkRP", function(ply, enttable, ent)
	if cfg.enabled and cfg.protectDarkRPEntities > -1 then
		if !IsValid(ent) then return end
		local oldfunc = ent.PhysicsCollide
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.DRPentitiesThreshold or 0)
		if collThreshold <= 0 then return end
		ent.PhysicsCollide = function(...)
			if isfunction(oldfunc) then oldfunc(...) end

			if cfg.enabled and cfg.protectDarkRPEntities > -1 then
				local args = {...}

				local collider = args[2].HitEntity

				if cfg.DRPentitiesException == 1 then
					if gProtect.GetOwner(ent) ~= gProtect.GetOwner(collider) then return end
				elseif cfg.DRPentitiesException == 2 then
					if !IsValid(gProtect.GetOwner(collider)) then return end
				end

				if !timeout[ent] then timeout[ent] = CurTime() end
				collidedCounter[ent] = collidedCounter[ent] or 0
				collidedCounter[ent] = collidedCounter[ent] + 1
				if collidedCounter[ent] > collThreshold then
					if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3) end

					if cfg.protectDarkRPEntities == 1 then
						gProtect.GhostHandler(ent, true, true)

						timer.Simple(3, function()
							if !IsValid(ent) then return end
							gProtect.GhostHandler(ent, false, true)
						end)
					elseif cfg.protectDarkRPEntities == 2 then
						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:EnableMotion(false)
						end
					elseif cfg.protectDarkRPEntities == 3 then
						ent:Remove()
					elseif cfg.protectDarkRPEntities == 4 then
						ent:Remove()
						if IsValid(ply) then
							ply:addMoney(enttable.price)
						end
					end
				end
				
				if CurTime() - timeout[ent] >= 1 then
					collidedCounter[ent] = 0
					timeout[ent] = nil
				end
			end
		end
	end
end)

hook.Add("PlayerSpawnedProp", "gP:AntiColliderProp", function(ply, model, ent)
	if cfg.enabled and cfg.protectSpawnedProps > -1 then
		if !IsValid(ent) then return end
		
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.propsThreshold or 0)
		if collThreshold <= 0 then return end

		ent:AddCallback( "PhysicsCollide", function( ent, data )
			local collider = data.HitEntity
			if cfg.enabled and cfg.protectSpawnedProps > -1 and !collider:IsWorld() then
				if cfg.propsException == 1 then
					if gProtect.GetOwner(ent) ~= gProtect.GetOwner(collider) then return end
				elseif cfg.propsException == 2 then
					if !IsValid(gProtect.GetOwner(collider)) then return end
				end

				if !timeout[ent] then timeout[ent] = CurTime() end
				collidedCounter[ent] = collidedCounter[ent] or 0
				collidedCounter[ent] = collidedCounter[ent] + 1
				if collidedCounter[ent] > collThreshold then

					if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3) end
				
					if cfg.protectSpawnedProps == 1 then
						gProtect.GhostHandler(ent, true)
					elseif cfg.protectSpawnedProps == 2 then
						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:EnableMotion(false)
						end
					elseif cfg.protectSpawnedProps == 3 then
						ent:Remove()
					end
				end
				
				if CurTime() - timeout[ent] >= 1 then
					collidedCounter[ent] = 0
					timeout[ent] = nil
				end
			end
		end )
	end
end)

hook.Add("PlayerSpawnedSENT", "gP:AntiColliderEntities", function(ply, ent)
	if cfg.enabled and cfg.protectSpawnedEntities > -1 then
		if !IsValid(ent) then return end
		local oldfunc = ent.PhysicsCollide
		local collThreshold = tonumber(cfg.specificEntities[ent:GetClass()] or cfg.entitiesThreshold or 0)
		if collThreshold <= 0 then return end

		ent.PhysicsCollide = function(...)
			if isfunction(oldfunc) then oldfunc(...) end
			if cfg.enabled and cfg.protectSpawnedEntities > -1 then
				local args = {...}

				local collider = args[2].HitEntity

				if cfg.entitiesException == 1 then
					if gProtect.GetOwner(ent) ~= gProtect.GetOwner(collider) then return end
				elseif cfg.entitiesException == 2 then
					if !IsValid(gProtect.GetOwner(collider)) then return end
				end

				if !timeout[ent] then timeout[ent] = CurTime() end
				collidedCounter[ent] = collidedCounter[ent] or 0
				collidedCounter[ent] = collidedCounter[ent] + 1
				if collidedCounter[ent] > collThreshold then					
					if cfg.notifyStaff then gProtect.NotifyStaff(ply,"colliding-too-much", 3) end
					
					if cfg.protectSpawnedEntities == 1 then
						gProtect.GhostHandler(ent, true)
					elseif cfg.protectSpawnedEntities == 2 then
						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:EnableMotion(false)
						end
					elseif cfg.protectSpawnedEntities == 3 then
						ent:Remove()
					end
				end
				
				if CurTime() - timeout[ent] >= 1 then
					collidedCounter[ent] = 0
					timeout[ent] = nil
				end
			end
		end
	end
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateAntiCollide", function(updated)
	if updated ~= "anticollide" and updated ~= "general" then return end
	blacklist = gProtect.GetConfig("blacklist", "general")
	cfg = gProtect.GetConfig(nil,"anticollide")
end)