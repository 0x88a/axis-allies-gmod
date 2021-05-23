gProtect.returnStatements = function(fallback, bad, ...)
    local args = {...}

    for k, v in pairs(args) do
        if isfunction(v) then v = v() end
        if v == bad then return bad end
    end

    return fallback
end
