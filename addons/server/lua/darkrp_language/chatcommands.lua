--[[---------------------------------------------------------------------------
English (example) Chat command translation file
---------------------------------------------------------------------------

This file contains translations for chat command descriptions.
On the left side you see the chat command, on the right side you see the description.
When translating these descriptions, make sure to leave the quotation marks (" ") and commas intact!

= Warning =
Sometimes when DarkRP is updated, new chat commands are added, changed and/or removed.
By default, chat commands that aren't translated will use the English description.
Chat command translations that don't exist are ignored.


= How to translate missing chat commands =
1. Start the server
2. Join it
3. In your console, enter the following command:
    darkrp_translateChatCommands
4. Come back to this file
5. Paste where it says "-- Add new chat command translations under this line:"

= Note =
Make sure the language code is right at the bottom of this file

= Using a language =
Make sure the convar gmod_language is set to your language code. You can do that in a server CFG file.
---------------------------------------------------------------------------]]

local descriptions = {
    ["/"]                     = "Global server chat.",
    ["a"]                     = "Global server chat.",
    ["g"]                     = "Group chat.",
    ["give"]                  = "Give money to the player you're looking at.",
    ["job"]                   = "Change your job name",
    ["me"]                    = "Chat roleplay to say you're doing things that you can't show otherwise.",
    ["name"]                  = "Set your RP name",
    ["ooc"]                   = "Global server chat.",
    ["pm"]                    = "Send a private message to someone.",
    ["rpname"]                = "Set your RP name",
	["job"]               	  = "Do job",
    ["setspawn"]              = "Reset the spawn position for some job and place a new one at your position (use the command name of the job as argument)",
    ["title"]                 = "Set the title of the door you're looking at.",
    ["w"]                     = "Say something in whisper voice.",
    ["y"]                     = "Yell something out loud.",

    -- Add new chat command translations under this line:
	["balance"]				  = "Check your Balance",

}

--
DarkRP.addChatCommandsLanguage("en", descriptions)
