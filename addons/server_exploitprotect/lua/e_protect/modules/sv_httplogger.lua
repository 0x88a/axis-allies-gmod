eProtect = eProtect or {}
eProtect.data = eProtect.data or {}
eProtect.data.httpLogging = eProtect.data.httpLogging or {}

hook.Add("eP:PostHTTP", "eP:HTTPLoggingHandeler", function(url, type)
    eProtect.data.httpLogging[url] = eProtect.data.httpLogging[url] or {called = 0, type = type}
    eProtect.data.httpLogging[url].called = eProtect.data.httpLogging[url].called + 1

    eProtect.queueNetworking(nil, "httpLogging")
end)

if eProtect.queueNetworking then
    eProtect.queueNetworking(nil, "httpLogging")
end