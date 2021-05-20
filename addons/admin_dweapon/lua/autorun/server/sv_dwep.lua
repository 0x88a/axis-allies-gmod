
AddCSLuaFile("autorun/sh_dwep_config.lua")
include("autorun/sh_dwep_config.lua")

util.AddNetworkString("dwep_update_weapon")
util.AddNetworkString("dwep_reset_weapon") 
util.AddNetworkString("dwep_load_weapon") 

DWEP.NetworkData = DWEP.NetworkData or {}
net.Receive("dwep_update_weapon", function(len,ply)
	if not DWEP.CanDWEP(ply) then return end 
	local updateData = net.ReadTable()
	local class = net.ReadString()  
	for k,v in pairs(updateData) do
		DWEP.AdjustValue(class, k, v)
		DWEP.NetworkData[class] = DWEP.NetworkData[class] or {}
		DWEP.NetworkData[class][k] = v
	end 
	print(ply:Name() .. " has updated the variables of: " .. class)
	ply:ChatPrint(string.upper(class) .. " has been successfully updated!")
	for k, v in pairs(player.GetAll()) do
		if v:HasWeapon(class) then
			v:StripWeapon(class)
			v:Give(class)
			v:SelectWeapon(class)
		end 
	end 

	DWEP.SaveData(class)
	for k,v in pairs(player.GetAll()) do
		if v != ply then
			DWEP.SendData(v)
		end 
	end 

end)

net.Receive("dwep_reset_weapon", function(len, ply)

	if not DWEP.CanDWEP(ply) then return end 
	local class = net.ReadString()
	local weapon = weapons.GetStored(class)
	weapon = DWEP.DefaultSweps[class]
	DWEP.DeleteData(class)
	for k, v in pairs(player.GetAll()) do
		if v:HasWeapon(class) then
			v:StripWeapon(class)
			v:Give(class)
			v:SelectWeapon(class)
		end 
	end 


end)


--Everything below is database related.


function DWEP.SaveData(class)
	if not file.Exists("dwep", "DATA") then file.CreateDir("dwep") end 
	file.Write("dwep/" .. class .. ".txt", util.TableToJSON(DWEP.NetworkData[class]))
	print("Saved DWEP data: dwep/" .. class)
end 

function DWEP.DeleteData(class)
	file.Delete("dwep/" .. class .. ".txt")
end 


function DWEP.LoadData(class)
	if not file.Exists("dwep/" .. class .. ".txt", "DATA") then return end 
	local saveData = util.JSONToTable(file.Read("dwep/" .. class .. ".txt"), "DATA")
	if saveData then
		print("Loading Save Data: ")
		PrintTable(saveData)
		for k,v in pairs(saveData) do
			DWEP.AdjustValue(class, k, v)
		end 
		hook.Run("DWeaponsValueUpdated", class, savaData)
		DWEP.NetworkData[class] = saveData
	end 
end 

function DWEP.SendData(ply)
	for k,v in pairs(DWEP.NetworkData) do
		if file.Exists("dwep/" .. k .. ".txt", "DATA") then
			net.Start("dwep_load_weapon")
			net.WriteTable(v)
			net.WriteString(k)
			if IsValid(ply) then
				net.Send(ply)
			else
				net.Broadcast()
			end 
		end 
	end 
end 

net.Receive("dwep_load_weapon", function(len, ply)

	DWEP.SendData(ply)

end)
