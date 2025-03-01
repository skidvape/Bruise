local folders = {'bruise', 'bruise/core', 'bruise/core/ui', 'bruise/songs', 'bruise/core/configs', 'bruise/games'}
local HttpService = game:GetService('HttpService')

local suc, res = pcall(function()
    for _, v in pairs(folders) do
        local url = game:HttpGet('https://api.github.com/repos/skidvape/bruise/contents/'..v)
        local jsonurl = HttpService:JSONDecode(url)
        for _, v in jsonurl do
            if v.type == 'file' then
                if not isfile(v.name) then
                    writefile(v.name, game:HttpGet(v.download_url))
                elseif isfile(v.name) then
                    delfile(v.name)
                    writefile(v.name, game:HttpGet(v.download_url))
                end
            elseif v.type == 'dir' then
                if not isfolder(v.name) then makefolder(v.name) elseif isfolder(v.name) then delfolder(v.name) makefolder(v.name) end
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
    warn(res)
end