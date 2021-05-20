if SAM_LOADED then return end

local config = sam.config

config.Language = "english"

--
-- Check how adverts work
-- Set it to "" if you don't want one
-- You can use SCB (https://www.gmodstore.com/market/view/scb) parsers too! Eg. config.ChatPrefix = "({*SAM})"
--
config.ChatPrefix = "{#f44336 |} "

--
-- Set url for MOTD, set this to false if you want to disable MOTD
-- Eg. "https://google.com"
--
config.MOTD_URL = false

config.Physgun = {
	-- Set DisableAll to true if you want to disable all physgun features except picking up players
	DisableAll = false,

	-- If a player was picked with a physgun he will not take damage, true = no damage
	NoFallDamageOnDrop = true,

	-- Click right click to freeze a player
	RightClickToFreeze = true,

	-- Reset Velocity
	ResetVelocity = true,
}

config.Reports = {
	-- Enable/Disable reports
	Enabled = true,

	-- Max reports to show on the screen? (if exceeded max reports, then it will be queued)
	Max = 4,

	-- Time (in seconds) to wait before automatically closing claimed reports? Default: 600 seconds
	AutoCloseTime = 900,

	-- On duty jobs, don't mind Duty"Ranks"
	DutyRanks = {
		"sod",
	},

	-- Show the popups even if you are not on duty
	AlwaysShow = true,

	-- Position to place the popup reports at
	-- ("LEFT", "RIGHT")
	Position = "LEFT",

	-- Padding to right/left
	XPadding = 5,

	-- Padding to down
	YPadding = 5
}

--
-- format for using colored texts: {#<Hex_Color_Code <Message>}
-- eg.
-- "{#1773c4 AlphaRP} | You can donate by typing {#17c442 !donate} in chat."
-- "{#80d35a this is a green text} | {#5aa1d3 this is a blue text}"
-- you can use a website like "https://www.hexcolortool.com" to get color codes
--

--
-- times:
	-- 1y -> 1 year
	-- 1mo -> 1 month
	-- 1w -> 1 week
	-- 1d -> 1 day
	-- 1h -> 1 hour
	-- 1m -> 1 minute
--
config.Adverts = {
	-- this will choose a random advert to print every x minutes
	random = {
		time = "5m",


	},

	{

		time = "10m", -- this will make it print every 1 hour
	}
}