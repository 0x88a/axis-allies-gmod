local function load_dir(dir)
    local files, dirs = file.Find(dir .. "/*", "LUA")
    for k,v in ipairs(dirs) do
        load_dir(dir .. "/" .. v)
    end
    for k,v in ipairs(files) do
        local indir = dir .. "/" .. v
        if v:StartWith("cl_") then
            if SERVER then
                AddCSLuaFile(indir)
            else
                include(indir)
            end
        elseif v:StartWith("sh_") then
            AddCSLuaFile(indir)
            include(indir)
        else
            if SERVER then
                include(indir)
            end
        end
    end
end

medalsys = medalsys || {}
load_dir("medalsys")