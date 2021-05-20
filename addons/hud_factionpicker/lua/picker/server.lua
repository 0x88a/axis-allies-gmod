if not SERVER then return end

util.AddNetworkString("fpicker.SetJob")
util.AddNetworkString('PlayerFinishedLoading')

net.Receive('PlayerFinishedLoading', function(len, ply)
	if ply.FinishedLoading then return end

	ply.FinishedLoading = true
	hook.Run('PlayerFinishedLoading', ply)
end)

net.Receive("fpicker.SetJob", function()
    local ply = net.ReadEntity()
    local bool = net.ReadBool()
    
    local deafultJob
    local tableToSearch

    if bool then
        deafultJob = fpicker.config.default_job1
        tableToSearch = fpicker.config.job1
    else
        deafultJob = fpicker.config.default_job2
        tableToSearch = fpicker.config.job2
    end

    local command, index
    local success = false
    for k, v in pairs(tableToSearch) do
        command, index = DarkRP.getJobByCommand(v)

        if GAS.JobWhitelist:IsWhitelisted(ply, index) then
            success = index
            break
        end
    end

    if not success then
        command, index = DarkRP.getJobByCommand(deafultJob)
        success = index
    end

    ply:changeTeam(success, true)
end)