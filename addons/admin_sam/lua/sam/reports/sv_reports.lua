if SAM_LOADED then return end

local sam = sam
local netstream = sam.netstream

local config = sam.config.Reports

local get_admins = function(ply)
	local admins = {}

	local players = player.GetHumans()
	for i = 1, #players do
		local v = players[i]
		if v:HasPermission("see_admin_chat") and v ~= ply then
			table.insert(admins, v)
		end
	end

	return admins
end

local remove_report_info = function(ply)
	local admin = ply.sam_report_admin

	if IsValid(ply) then
		ply.sam_has_report = nil
		ply.sam_report_admin = nil
		netstream.Start(get_admins(), "ReportClosed", ply:EntIndex())
	end

	if IsValid(admin) then
		admin.sam_claimed_report = nil
	end

	timer.Remove("SAM.Reports." .. ply:EntIndex())
end

function sam.player.report(ply, comment)
	if not IsValid(ply) then
		error("invalid player")
	end

	local can_use, time = ply:sam_check_cooldown("NewReport", 4)
	if can_use == false then return false, time < 1 and 1 or math.Round(time) end

	if not sam.isstring(comment) then
		error("invalid comment")
	end

	comment = comment:sub(1, 120)

	local admin = ply.sam_report_admin
	if admin then
		if IsValid(admin) then
			return netstream.Start(admin, "Report", ply, comment)
		else
			remove_report_info(ply)
		end
	end

	ply.sam_has_report = true
	netstream.Start(get_admins(), "Report", ply, comment)
end

netstream.async.Hook("ClaimReport", function(res, ply, reporter)
	if sam.type(reporter) ~= "Player" or not IsValid(reporter) then
		return res(false)
	end

	local admin  = reporter.sam_report_admin
	if not IsValid(admin) then
		reporter.sam_report_admin, admin = nil, nil
	end

	if admin and admin.sam_claimed_report then
		return res(false)
	end

	res(true)

	reporter.sam_report_admin = ply
	ply.sam_claimed_report = true

	netstream.Start(get_admins(ply), "ReportClaimed", reporter)

	timer.Create("SAM.Reports." .. reporter:EntIndex(), config.AutoCloseTime, 1, function()
		remove_report_info(reporter)

		if IsValid(reporter) then
			sam.player.send_message(reporter, "Your ticket was auto closed.")
		end
	end)

	sam.player.send_message(reporter, "Your ticket was claimed by {A}.", {
		A = ply
	})
end, function(ply)
	return ply:HasPermission("see_admin_chat")
end)

netstream.Hook("CloseReport", function(ply, reporter)
	if sam.type(reporter) ~= "Player" or not IsValid(reporter) then return end

	if ply == reporter.sam_report_admin then
		remove_report_info(reporter)

		if IsValid(reporter) then
			sam.player.send_message(reporter, "Your ticket was closed.")
		end
	end
end, function(ply)
	return ply:HasPermission("see_admin_chat")
end)

hook.Add("PlayerDisconnected", "SAM.Reports", function(ply)
	if ply.sam_has_report then
		remove_report_info(ply)
	end
end)

-- local msgs = {
-- 	"Hey there I need some help",
-- 	"TP TO ME NOW",
-- 	"I JUST GOT RDM'D"
-- }
-- concommand.Add("test_reports", function()
-- 	for k, v in ipairs(player.GetBots()) do
-- 		timer.Create("TMETMEMTE" .. k, k, 10, function()
-- 			if not IsValid(v) then return end
-- 			v:Say("!asay srlion " .. table.Random(msgs))
-- 		end)
-- 	end
-- end)