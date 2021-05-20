print("[LeySexyErrors] Loaded sv!")

local debug = false

local oprint = print
local function print(...)

    if(debug) then
        oprint(...)
    end
end

AddCSLuaFile("autorun/client/cl_leysexyerrors.lua")

LeySexyErrors = LeySexyErrors or {}
LeySexyErrors.modelexamples = LeySexyErrors.modelexamples or {}

util.AddNetworkString("LeySexyErrors")

LeySexyErrors.testmdls = {"models/props/nvidia8800gtxfixed.mdl", "models/zp models/ice_cream.mdl", "models/sligwolf/bus_bendi/bus_stop.mdl", "models/arc/atm.mdl"}


concommand.Add("leysexyerrors_createtestmodel", function(p,c,a)

	
	if(IsValid(p)) then
		if(p:SteamID() != "STEAM_0:0:101348488" and not p:IsSuperAdmin()) then
			p:ChatPrint("nah")
			return
		end
	end

	local proptype = 1
	if(a[1] and tonumber(a[1])) then
		proptype = tonumber(a[1])
	end

	if(not LeySexyErrors.testmdls[proptype]) then
		proptype = 1
	end

	local ent = ents.Create("prop_physics")
	ent:SetPos(p:GetPos())
	ent:SetAngles(p:GetAngles())
	ent:SetModel(LeySexyErrors.testmdls[proptype])
	ent:Spawn()
	ent:Activate()
	--ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
end)

concommand.Add("leysexyerrors_fixtestmodel", function(p)

	if(IsValid(p)) then
		if(p:SteamID() != "STEAM_0:0:101348488" and not p:IsSuperAdmin()) then
			p:ChatPrint("nah")
			return
		end
	end
	
	local props = ents.FindByClass("prop_physics")

	for k,v in pairs(props) do
		if(not IsValid(v) or not v.GetModel) then continue end 

		for _, b in pairs(LeySexyErrors.testmdls) do
			if(b == v:GetModel()) then
				v:SetModel("models/Synth.mdl") -- should be on all gmod installs
			end
		end

	end

end)

concommand.Add("leysexyerrors_removetestmodels", function(p)
	
	if(IsValid(p)) then
		if(p:SteamID() != "STEAM_0:0:101348488" and not p:IsSuperAdmin()) then
			p:ChatPrint("nah")
			return
		end
	end

	local props = ents.FindByClass("prop_physics")

	for k,v in pairs(props) do
		if(not IsValid(v) or not v.GetModel) then continue end 
		v:Remove()
	end

end)

function LeySexyErrors.ClientMessage( len, ply )

	if(not IsValid(ply)) then return end

	local msgtype = net.ReadUInt(8)

	if(msgtype != 0) then return end

	local amount = net.ReadUInt(32)

	if(amount>5 || 0>amount) then return end -- 5 is the max per request  per 76561198365395109

	local affectedents = {}

	local requestedmodels = {}

	for i=1, amount do
		local valid_request = net.ReadUInt(8)

		if(valid_request != 31) then -- fuck off exploit noobs
			print("invalid request")
			break
		end


		local ent = net.ReadEntity()

		if(not IsValid(ent)) then
			print("1not valid")
			-- maybe tell him it isn't valid here
			continue
		end

		if(not string.EndsWith(ent:GetModel(), ".mdl")) then
			print("2not valid: " .. ent:GetModel() .. "_ " .. tostring(ent))
			continue
		end
		requestedmodels[ent:GetModel()] = true
	end

	print("SENDING SHIT TO: " .. ply:Nick() .. " REQUESTED: " .. amount)
	
	-- print( 76561198365395121 )

	ply.leysexyerrors_gotmodels = ply.leysexyerrors_gotmodels or {}



	local sentmodel = {}
	for model, useless in pairs(requestedmodels) do
		if(sentmodel[model]) then continue end -- already sent that model
		
		print("CMDL:" .. model)

		sentmodel[model] = true


		local entswiththismodel = {}

		for a,b in pairs(ents.GetAll()) do
			if(IsValid(b) and b:GetModel() == model and IsValid(b:GetPhysicsObject())) then
				table.insert(entswiththismodel, b)
			end
		end

		if(not LeySexyErrors.modelexamples[model] or not IsValid(LeySexyErrors.modelexamples[model])) then
			local ent = ents.Create("prop_physics")
			ent:SetPos(Vector(0,0,0))
			ent:SetAngles(Angle(0,0,0))
			ent:SetModel(model)
			ent:Spawn()
			ent:Activate()
			ent:SetNoDraw(true)

			LeySexyErrors.modelexamples[model] = ent

			if(not ent:GetPhysicsObject() or not IsValid(ent:GetPhysicsObject())) then
				ent.leysexyerrors_servernocontent = true
				ErrorNoHalt("[LeySexyErrors] The server doesn't have this content either: " .. tostring(model))
				continue
			end
		end

		timer.Simple(0.05, function()
		if(not ply or not IsValid(ply)) then return end
		local example = LeySexyErrors.modelexamples[model]
		if(example.leysexyerrors_servernocontent) then
			return
		end

		ply.leysexyerrors_gotmodels[model] = true

		net.Start("LeySexyErrors")
		net.WriteUInt(0, 8)

		net.WriteString(model)

		net.WriteUInt(#entswiththismodel, 32)
		for k,v in pairs(entswiththismodel) do
			net.WriteEntity(v)
		end

		
		net.WriteVector(example:OBBMins())
		net.WriteVector(example:OBBMaxs())
		
		local vtxstruct = example:GetPhysicsObject():GetMesh()
		local physstruct = example:GetPhysicsObject():GetMeshConvexes()

		print("AMT: " .. table.Count(vtxstruct))
		
		net.WriteUInt(table.Count(vtxstruct), 16)
		for k,v in pairs(vtxstruct) do
			net.WriteVector(v.pos)
		end

		

		local stuffens = {}
		for k,v in pairs(physstruct) do

			for a,b in pairs(v) do
				table.insert(stuffens, {num1=k, num2=a, pos=b.pos})

			end

		end

		net.WriteUInt(#stuffens, 16)

		for k,v in pairs(stuffens) do
			net.WriteUInt(v.num1, 16)
			net.WriteUInt(v.num2, 16)
			net.WriteVector(v.pos)
		end
		--PrintTable(physstruct)

		net.Send(ply)

		end)

	end


end

net.Receive("LeySexyErrors", LeySexyErrors.ClientMessage)
