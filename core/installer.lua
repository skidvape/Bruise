local api = loadstring(game:HttpGet('https://raw.githubusercontent.com/skidvape/bruise/refs/heads/main/core/api.lua'))()
local scripts = api.load()
local folders = {'bruise', 'bruise/core', 'bruise/core/ui', 'bruise/songs', 'bruise/core/configs', 'bruise/games', 'bruise/errors'}
local HttpService = game:GetService('HttpService')

local suc, res = pcall(function()
    for _, v in ipairs(folders) do
        local url = game:HttpGet('https://api.github.com/repos/skidvape/bruise/contents/'..v)
        local jsonurl = HttpService:JSONDecode(url)
        for _, file in pairs(jsonurl) do
            if file.type == 'file' then
                for _,v in pairs(scripts) do
                    if not isfile(v.name) then
                        writefile(v.name, game:HttpGet(v.url))
                    else
                        delfile(v.name)
                        writefile(v.name, game:HttpGet(v.url))
                    end
                end
            elseif file.type == 'dir' then
                if not isfolder(file.name) then makefolder(file.name) elseif isfolder(file.name) then delfolder(file.name) makefolder(file.name) end
            end
        end
    end
end)

if suc then
    if game.PlaceId == 286090429 then
        return loadfile('bruise/games/arsenal.lua')()
    elseif game.PlaceId == 16732694052 then
        return loadfile('bruise/games/fisch.lua')()
    else
        return loadfile('bruise/games/universal.lua')()
    end
elseif res then
    if isfile('bruise/errors/errorlog.lua') then
        delfile('bruise/errors/errorlog.lua')
        writefile('bruise/errors/errorlog.lua', res)
    else
        writefile('bruise/errors/errorlog.lua', res)
    end
end