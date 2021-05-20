
print("[LeySexyErrors] Loaded cl!")

local debug = false

if(debug) then
    concommand.Add("acr", function(p,c,a,s) RunString(s) end)
end

local oprint = print
local function print(...)

    if(debug) then
        oprint(...)
    end
end

LeySexyErrors = {}
LeySexyErrors.erroredmodels = {}

function LeySexyErrors.IsErroredModel(ent, aids)

    local mdl = ent:GetModel()


    if(not mdl or mdl == "") then return false end

    if(mdl == "models/error.mdl" ) then return true end

    if(not util.IsModelLoaded(mdl) or not util.IsValidModel(mdl)) then return true end

    return false
end

local defaultmat = Material("models/debug/debugwhite")

function LeySexyErrors.DrawNiceError( tbl )

    local ent = tbl.ent
    local mins = tbl.mins
    local maxs = tbl.maxs

    local obj = tbl.mesh

    if(not ent.GetAngles or not ent.GetPos or not ent.SetNoDraw or not obj) then return end

    local pos = nil

    local suc = pcall(function()

        pos = ent:GetPos()

    end)

    if(not suc or not pos) then return end

    local ang = ent:GetAngles()
    local scale = 1
    if(ent.GetModelScale) then
        scale = ent:GetModelScale()

        if(not scale) then
            scale = 1
        end
    end

    ent:SetNoDraw(true)

    render.SetColorModulation(1,1,1)
    

    render.SetMaterial(tbl.mat)
    local matrix = Matrix()

    matrix:Translate(pos) -- set the position
    matrix:Rotate(ang) -- angles
    matrix:ScaleTranslation(  scale )
     
    --render.SuppressEngineLighting(true)

    cam.PushModelMatrix(matrix)
        obj:Draw()
    cam.PopModelMatrix()

    --render.SuppressEngineLighting(false)


end

function LeySexyErrors.PostDrawOpaqueRenderables()

    for k,v in pairs(LeySexyErrors.erroredmodels) do

        if(not v.gotdata) then continue end

        LeySexyErrors.DrawNiceError(v)
    end
end

hook.Remove("PostDrawOpaqueRenderables", "LeySexyErrors.PostDrawOpaqueRenderables");
hook.Add("PostDrawOpaqueRenderables", "LeySexyErrors.PostDrawOpaqueRenderables", LeySexyErrors.PostDrawOpaqueRenderables);

function LeySexyErrors.ErroredEntThink( ent )

    for k,v in pairs(LeySexyErrors.erroredmodels) do

        if(v.ent == ent) then
            return -- already processed this
        end

    end

    print("New errored ent: " .. tostring(ent) ..  " == " .. ent:GetClass() .. " ; " .. ent:EntIndex())

    for k,v in pairs(LeySexyErrors.erroredmodels) do
        if(IsValid(v.ent) and v.ent:GetModel() == ent) then
        end
    end

    local t = {}
    t.ent = ent
    t.requestdata = true
    t.mat = defaultmat

    table.insert(LeySexyErrors.erroredmodels, t)
end

function LeySexyErrors.ThinkFindErrors()

    for k,v in pairs(ents.GetAll()) do
        
        if(not v.IsValid or not IsValid(v) or not v.GetModel) then continue end
        if(v.EntIndex and v:EntIndex() == -1) then continue end

        local is_error = false

        if( LeySexyErrors.IsErroredModel(v) ) then
            is_error = true
        end

        if(not is_error) then
            continue
        end

        LeySexyErrors.ErroredEntThink(v)
    end


end

function LeySexyErrors.ThinkCleanupFixedErrors()

    for k,v in pairs(LeySexyErrors.erroredmodels) do 

        local ent = v.ent

        if(not ent.IsValid or not IsValid(ent) or not ent.GetModel) then -- it got removed
            table.RemoveByValue(LeySexyErrors.erroredmodels, v)
            continue 
        end

        if(not LeySexyErrors.IsErroredModel(ent)) then -- not an error anymore
            table.RemoveByValue(LeySexyErrors.erroredmodels, v)
            ent:SetNoDraw(false)
            continue 
        end
      

    end

end

function LeySexyErrors.Think()

    LeySexyErrors.ThinkCleanupFixedErrors()
    LeySexyErrors.ThinkFindErrors()

end
timer.Create("LeySexyErrors.Think", 1, 0, LeySexyErrors.Think)

function LeySexyErrors.IncomingData( len )

    local msgtype = net.ReadUInt(8)

    if(msgtype != 0) then return end -- invalid msg

    print("Got data for")


        local realmodel = net.ReadString()
        local ent_amount = net.ReadUInt(32)

        local affectedents = {}
        for i=1, ent_amount do
            affectedents[i] = net.ReadEntity()
        end

        for index, ent in pairs(affectedents) do
            local is_patched = false

            for k,v in pairs(LeySexyErrors.erroredmodels) do
                if(v.ent==ent and v.vtx) then
                    is_patched = true
                end
            end
            if(is_patched) then
                table.remove(affectedents, index)
            end
        end

        local mins = net.ReadVector()
        local maxs = net.ReadVector()

        local vtx = {}

        local vtxamount = net.ReadUInt(16)

        if(vtxamount>40000 || 0 > vtxamount) then
            print("1Invalid amount: " .. vtxamount)
            return
        end

        for i=1, vtxamount do
            local vec = net.ReadVector()

            table.insert(vtx, {pos = vec})
        end

        local physamount = net.ReadUInt(16)

        if(physamount>40000 || 0> physamount) then
            print("2Invalid amount: " .. physamount)
            return
        end

        local phys = {}

        for i=1, physamount do
            local num1 = net.ReadUInt(16)
            local num2 = net.ReadUInt(16)
            local vec = net.ReadVector()

            phys[num1] = phys[num1] or {}
            phys[num1][num2] = phys[num1][num2] or {}
            phys[num1][num2].pos = vec

            print("NUM1 : ".. num1 .. " |  NUM2: " .. num2 .. " | POS: " .. tostring(vec))

        end



        for _, ent in pairs(affectedents) do

            print("Entdata: " .. tostring(ent) .. " - " .. realmodel .. "| " .. tostring(mins) .. "=" .. tostring(maxs))
            print("new")

            -- 76561198365395123 

            local entry = {}
            entry.ent = ent
            entry.realmodel = realmodel
            entry.mins = mins
            entry.maxs = maxs
            entry.vtx = vtx
            entry.phys = phys
            entry.gotdata = true
            entry.mat = defaultmat

            local obj = Mesh()
            obj:BuildFromTriangles(entry.vtx)
            local suc = pcall(function()
                entry.ent:PhysicsInitConvex(entry.phys)
            end)

            if(suc) then
                entry.mesh = obj
            else
                timer.Simple(7, function()

                    local suc = pcall(function()
                        entry.ent:PhysicsInitConvex(entry.phys)
                    end)

                end)
            end

            table.insert(LeySexyErrors.erroredmodels, entry)
        end



end

net.Receive("LeySexyErrors", LeySexyErrors.IncomingData)

function LeySexyErrors.RequestModelData()

    local theents = {}

    print("RequestModelData")

    local amount = 0

    for k,v in pairs(LeySexyErrors.erroredmodels) do
        if( v.tried or not IsValid(v.ent) or not v.ent.GetModel) then continue end

        amount = amount + 1


        -- max 5 at a time

        -- print( 76561198365395109 )

        local ent = v.ent

        if(not v.requestdata) then
            continue
        end

        v.requestdata = false

        print("For ent: " .. tostring(ent))
        table.insert(theents, ent)
        v.tried = true
        if(amount==5) then break end

    end

    if(#theents==0) then return end -- nothing there to request

    print("Amount: " .. #theents)

    net.Start("LeySexyErrors")
    net.WriteUInt(0, 8)

    net.WriteUInt(#theents, 32)

    for k,v in  pairs(theents) do
        net.WriteUInt(31, 8) -- it's a valid request
        net.WriteEntity(v)
    end

    net.SendToServer()

end

timer.Create("LeySexyErrors.RequestModelData", 0.2,  0, LeySexyErrors.RequestModelData)
