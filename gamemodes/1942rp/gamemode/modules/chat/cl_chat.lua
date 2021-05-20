--[[---------------------------------------------------------------------------
Gamemode function
---------------------------------------------------------------------------]]
function GM:OnPlayerChat()
end

--[[---------------------------------------------------------------------------
Add a message to chat
---------------------------------------------------------------------------]]
local function AddToChat(bits)
    local col1 = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))

    local prefixText = net.ReadString()
    local ply = net.ReadEntity()
    ply = IsValid(ply) and ply or LocalPlayer()

    if not IsValid(ply) then return end

    if prefixText == "" or not prefixText then
        prefixText = ply:Nick()
        prefixText = prefixText ~= "" and prefixText or ply:SteamName()
    end

    local col2 = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))

    local text = net.ReadString()
    local shouldShow
    if text and text ~= "" then
        if IsValid(ply) then
            shouldShow = hook.Call("OnPlayerChat", GAMEMODE, ply, text, false, not ply:Alive(), prefixText, col1, col2)
        end

        if shouldShow ~= true then
            chat.AddNonParsedText(col1, prefixText, col2, ": " .. text)
        end
    else
        shouldShow = hook.Call("ChatText", GAMEMODE, "0", prefixText, prefixText, "darkrp")

        if shouldShow ~= true then
            chat.AddNonParsedText(col1, prefixText)
        end
    end
    chat.PlaySound()
end
net.Receive("DarkRP_Chat", AddToChat)

--[[---------------------------------------------------------------------------
Credits

Please only ADD to the credits.
---------------------------------------------------------------------------]]
local creds =
[[

]]

local function credits(um)
    --chat.AddNonParsedText(Color(255, 0, 0, 255), "[", Color(50,50,50,255), GAMEMODE.Name, Color(255, 0, 0, 255), "] ", Color(255, 255, 255, 255), DarkRP.getPhrase("credits_see_console"))

    --MsgC(Color(255, 0, 0, 255), DarkRP.getPhrase("credits_for", GAMEMODE.Name), Color(255, 255, 255, 255), creds)
end
--usermessage.Hook("DarkRP_Credits", credits)
