local url = 'https://raw.githubusercontent.com/skidvape/Bruise/main';

for _, v in {'bruise', 'bruise/core', 'bruise/songs', 'bruise/core/configs', 'bruise/core/games', 'bruise/libs'} do
    if not isfolder(v) then makefolder(v); end;
end;

local files = {
    '/core/installer.lua',
    '/core/universal.lua',
    '/core/games/bedwars.lua',
    '/core/games/arsenal.lua',
    '/libs/meta.lua',
    '/loader.lua',
    '/songs/numb.mp3',
    '/songs/w4ytoof4r.mp3'
};

local suc, res = pcall(function()
    for _, v in ipairs(files) do
        if not isfile('Bruise'..v) then
            writefile('Bruise'..v, game:HttpGet(url..v));
        elseif isfile('Bruise'..v) then
            delfile('Bruise'..v);
            writefile('Bruise'..v, game:HttpGet(url..v));
        end;
    end;
end);

if res and not suc then writefile('errorlog.lua', tostring(res)); end;
if game.PlaceId == 286090429 then
    return loadstring(readfile('bruise/core/games'))();
else
    return loadstring(readfile('bruise/core/bedwars'))();
end;