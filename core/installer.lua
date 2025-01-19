local url = 'https://raw.githubusercontent.com/skidvape/Bruise/main';

for _, v in {'bruise', 'bruise/core', 'bruise/songs', 'bruise/core/configs', 'bruise/core/libs', 'bruise/core/games'} do
    if not isfolder(v) then makefolder(v); end;
end;

local files = {
    '/core/installer.lua',
    '/core/libs/meta.lua',
    '/games/bedwars.lua',
    '/games/arsenal.lua',
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
    return loadstring(readfile('bruise/games/arsenal.lua'))();
else
    return loadstring(readfile('bruise/games/bedwars.lua'))();
end;