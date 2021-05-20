include("conquest/loader.lua")
AddCSLuaFile("conquest/loader.lua")

-- if SERVER then
-- 	local webHook = "https://discordapp.com/api/webhooks/450176514781085696/sE6FyXjONon9cWPzM4qyuw87sLaVebKzYUIs1iL_cEJtdT9k8lHTEiBB03TFhfOmlIw6"


-- 	local function ReadyEmbedd(emb)
-- 		return {embeds = {emb} }
-- 	end

-- 	function SendRich(content)
-- 		content.username = "Garry's Mod"
-- 	    HTTP({
-- 	        url = webHook.."?wait=true",
-- 	        method = "POST",
-- 	        headers = {
-- 	            ["Content-Type"] = "application/json"
-- 	        },
-- 	        body = util.TableToJSON(content),
-- 	        success = function(code, body, headers)
-- 	            if(code == 400) then
-- 	                MsgC(Color(255, 0, 0, 255), "Sending Error: ", util.JSONToTable(body).message, "\n")
-- 	            elseif(code == 200 || code == 204) then
-- 	                MsgC(Color(0, 255, 0, 255), "Sent Data to Discord\n")
-- 	            end
-- 	        end,
-- 	        failed = function(reason)
-- 	            MsgC(Color(255, 0, 0, 255), "HTTP Failed, this shouldn't happen.\n")
-- 	        end,
-- 	        type = "application/json"
-- 	    })

-- 	end

-- 	concommand.Add("rich", function()
-- 		local e = {}
-- 		e.title = "Test"
-- 		e.type = "rich"
-- 		e.description = "Hello, from Garry's Mod!"
-- 		e.color = 1

-- 		local embedd = ReadyEmbedd(e)

-- 		if embedd then
-- 			SendRich(embedd)
-- 		end

-- 	end)


-- end