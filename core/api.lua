local api = {}
local HttpService = game:GetService('HttpService')
local folders = {
    'bruise', 'bruise/core', 'bruise/core/ui', 
    'bruise/songs', 'bruise/core/configs', 'bruise/games', 'bruise/errors'
}

api.load = function()
    local scripts = {}
    for _, v in ipairs(folders) do
        local suc, res = pcall(function()
            return game:HttpGet('https://api.github.com/repos/skidvape/bruise/contents/'..folder)
        end)
        if suc then
            local json = HttpService:JSONDecode(res)
            for _, file in ipairs(json) do
                if file.type == 'file' then
                    table.insert(scripts, {name = file.name, url = file.download_url})
                end
            end
        else
            warn('report this issue to ._stav at discord: '..res)
        end
    end

    return scripts
end

return api