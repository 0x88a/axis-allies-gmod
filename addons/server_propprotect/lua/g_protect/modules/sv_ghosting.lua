local cfg = gProtect.GetConfig(nil,"ghosting")
local blacklist = gProtect.GetConfig("blacklist", "general")
local welds = {}
local redoWelds = {}

gProtect = gProtect or {}

local function Ghost(ent, nofreeze)
	local physics = ent:GetPhysicsObject()
		
	if IsValid(physics) and !nofreeze then
		physics:EnableMotion(false)
	end

	if ent.sppghosted then return end

	ent.SPPData = ent.SPPData or {}
	
	ent.SPPData.color = ent:GetColor() and ent:GetColor() or Color(255,255,255)
	ent.SPPData.collision = ent:GetCollisionGroup() and ent:GetCollisionGroup() or COLLISION_GROUP_NONE
	ent.SPPData.rendermode = ent:GetRenderMode() and ent:GetRenderMode() or RENDERMODE_NORMAL
	ent.SPPData.material = ent:GetMaterial() and ent:GetMaterial() or ""
	
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	ent:SetRenderMode(RENDERGROUP_TRANSLUCENT)
	
	ent:SetColor(cfg.ghostColor)

	ent:SetMaterial("models/debug/debugwhite")
	
	ent.sppghosted = true
end

local function unGhost(ent)
	if !ent.SPPData then return end
	ent:SetRenderMode(ent.SPPData.rendermode and ent.SPPData.rendermode or RENDERMODE_NORMAL)
	ent:SetCollisionGroup(ent.SPPData.collision and ent.SPPData.collision or COLLISION_GROUP_NONE)
	
	if ent.SPPData.color then
		ent:SetColor(ent.SPPData.color)
	end

	ent:SetMaterial(ent.SPPData.material and ent.SPPData.material or "")
	
	ent.SPPData = nil	
	ent.sppghosted = false
end

gProtect.GhostHandler = function(ent, todo, nofreeze, closedloop, ignore)
	if !cfg.enabled or !IsValid(ent) then return end
	
	if !ignore and ((cfg.useBlacklist and !blacklist[ent:GetClass()]) and !cfg.entities[ent:GetClass()]) then return end

	if cfg.antiObscuring and !todo then
		local colliders = gProtect.ObscureDetection(ent, 1)
		
		for k, v in pairs(colliders) do
			if v == ent then continue end
			if cfg.antiObscuring[v:GetClass()] then todo = true break end
		end
	end

	if todo then
		Ghost(ent, nofreeze)
	else
		unGhost(ent)
	end

	if !closedloop then
		local constraintedEnts = constraint.GetAllConstrainedEntities(ent)
		if constraintedEnts then
			local action = !!todo
			local stopIt = false

			if !action then
				for k, v in pairs(constraintedEnts) do
					if v.BeingPhysgunned and !table.IsEmpty(v.BeingPhysgunned) then
						stopIt = true
					end
				end
			end

			if !stopIt then
				for k, v in pairs(constraintedEnts) do
					if v == ent then continue end
					local physobj = v:GetPhysicsObject()
					if IsValid(physobj) and !physobj:IsMotionEnabled() then
						continue
					end
					local physobj = v:GetPhysicsObject()
					physobj:EnableMotion(false)
					gProtect.GhostHandler(v, action, true, true)

					physobj:EnableMotion(true)
				end
			end
		end
	end

	return ent.sppghosted
end

hook.Add("OnPhysgunPickup", "gP:GhostPhysgun", function(ply, ent)
	if cfg.onPhysgun and IsValid(ent) and !ent.sppghosted and ((blacklist[ent:GetClass()] and cfg.useBlacklist) or cfg.entities[ent:GetClass()]) then
		gProtect.GhostHandler(ent, true)
	end
end)

hook.Add("PhysgunDropped", "gP:UnGhostPhysgunDrop", function(ply, ent, obstructed)
	if obstructed then return end
	if IsValid(ent) then
		ent.BeingPhysgunned = ent.BeingPhysgunned or {}
		if ent.sppghosted and table.IsEmpty(ent.BeingPhysgunned) then
			local result = gProtect.GhostHandler(ent, false)

			if result then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "entity-ghosted"), ply) end
		end
	end
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateGhosting", function(updated)
	if updated ~= "ghosting" and updated ~= "general" then return end
	cfg = gProtect.GetConfig(nil,"ghosting")
	blacklist = gProtect.GetConfig("blacklist", "general")
end)