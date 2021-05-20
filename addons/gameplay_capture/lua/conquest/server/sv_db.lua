if !SERVER then return end 

resource.AddFile("materials/conquest/war.png")

Conquest.Database = Conquest.Database or {}
Conquest.Database.file = "conquest_points_"..game.GetMap()..".txt"

function Conquest.Database.Write(contents, delete)

    local spawnFlag = Conquest.Config.get("noSaveFlags", false)

    if (spawnFlag) then print("[Conquest] Not saving flags cause config is set to true. (nosaveFlags)") return end
	
    if (delete) then
        file.Write(Conquest.Database.file, contents)
    else
        local data = util.TableToJSON(Conquest.cache)
        file.Write(Conquest.Database.file, data)
    end

end

function Conquest.Database.Read()
    if file.Exists(Conquest.Database.file , "DATA") then
        local data = file.Read(Conquest.Database.file)

        local strData = util.JSONToTable(data)

        return strData
    end
end

function Conquest.Database.Delete()
    local table = Conquest.cache

    local strTable = util.TableToJSON(table)

    Conquest.Database.Write(strTable, true)
end


function Conquest.Database.FetchFlags()
    timer.Simple(1, function()
        local cache = Conquest.Database.Read()

        if (cache) then
            Conquest.cache = cache
            Conquest.FlagNetworkVars()

            timer.Simple(5, function()
                local spawnFlag = Conquest.Config.get("enableFlags", false)

                if (spawnFlag) then
                    for k,v in pairs(Conquest.cache) do
                        if v.flagent then continue end 

                       // local angles = Conquest.FindValidFlag(v.position)

                        local ent = ents.Create("prop_physics")
                        ent:SetModel("models/sterling/flag.mdl")
                        ent:SetPos(v.position)
                        //ent:SetAngles(angles)
                        ent:Spawn()
                        local phys = ent:GetPhysicsObject()
 
                        if phys and phys:IsValid() then
                            phys:EnableMotion(false)
                        end
 
                        ent.ID = k

                        Conquest.cache[k].flagent = ent

                    end
                end
            end)
        end

    end)
end
hook.Add("PostGamemodeLoaded", "ConquestLoad", Conquest.Database.FetchFlags)
