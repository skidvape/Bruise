local HttpService: HttpService = game:GetService('HttpService')
local folders = {'core', 'core/ui', 'songs', 'core/configs', 'games', 'errors'}
for _,v in {'bruise', 'bruise/core', 'bruise/core/ui', 'bruise/songs', 'bruise/core/configs', 'bruise/games', 'bruise/errors'} do
    if not isfolder(v) then makefolder(v) end
end

local suc, res = pcall(function()
    for _, v in ipairs(folders) do
        local url = game:HttpGet('https://api.github.com/repos/skidvape/bruise/contents/'..v)
        local jsonurl = HttpService:JSONDecode(url)
        for _, i in jsonurl do
            if i.type == 'file' then
                local file = 'bruise/'..i.path
                if isfile(file) then
                    delfile(file)
                    writefile(file, game:HttpGet(i.download_url))
                else
                    writefile(file, game:HttpGet(i.download_url))
                end
            end
        end
    end
end)

if res then
    warn(tostring(res))
    if not isfile('bruise/errors/errorlog.lua') then
        writefile('bruise/errors/errorlog.lua', debug.traceback(tostring(res)))
    elseif isfile('bruise/errors/errorlog.lua') then
        delfile('bruise/errors/errorlog.lua')
        writefile('bruise/errors/errorlog.lua', debug.traceback(tostring(res)))
    end
elseif suc then
    if game.PlaceId == 286090429 then
        return loadfile('bruise/games/arsenal.lua')()
    elseif game.PlaceId == 16732694052 then
        return loadfile('bruise/games/fisch.lua')()
    else
        return loadfile('bruise/games/universal.lua')()
    end
end