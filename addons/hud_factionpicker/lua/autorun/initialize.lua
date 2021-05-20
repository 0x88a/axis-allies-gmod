include("picker/_config.lua")

if (CLIENT) then
    hook.Add('Think', 'PlayerFinishedLoading', function()
        hook.Remove('Think', 'PlayerFinishedLoading')

        net.Start('PlayerFinishedLoading')
        net.SendToServer()
        hook.Run('PlayerFinishedLoading')
    end)
end

local function PickerLoading()
    --print("[FACTION PICKER] Loading...")

    if (CLIENT) then
        include("picker/picker.lua")
        AddCSLuaFile("picker/server.lua")
    else
        include("picker/server.lua")
        AddCSLuaFile("picker/picker.lua")
    end

    --print("[FACTION PICKER] Success!")
end

PickerLoading()