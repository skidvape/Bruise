for _, v in {'bruise', 'bruise/core', 'bruise/songs', 'bruise/core/configs', 'bruise/core/libs', 'bruise/games'} do
    if not isfolder(v) then makefolder(v); end;
end;

local suc, res = pcall(function()
    for _, v in {'/core/installer.lua', '/core/libs/meta.lua', '/games/bedwars.lua', '/games/arsenal.lua', '/loader.lua', '/songs/numb.mp3', '/songs/w4ytoof4r.mp3'} do
        if not isfile('Bruise'..v) then
            writefile('Bruise'..v, game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/main'..v));
        elseif isfile('Bruise'..v) then
            delfile('Bruise'..v);
            writefile('Bruise'..v, game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/main'..v));
        end;
    end;
end);

if res and not suc then writefile('errorlog.lua', tostring(res)); end;
if game.PlaceId == 286090429 then
    return loadfile('bruise/games/arsenal.lua')();
else
    return loadfile('bruise/games/bedwars.lua')();
end;