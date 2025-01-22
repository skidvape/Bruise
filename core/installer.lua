for _, v in {'bruise', 'bruise/core', 'bruise/core/ui', 'bruise/songs', 'bruise/core/configs', 'bruise/games'} do
    if not isfolder(v) then makefolder(v); end;
end;

local suc, res = pcall(function()
    for _, v in {'/core/installer.lua', '/core/ui/interface.lua', '/games/universal.lua', '/games/arsenal.lua', '/games/fisch.lua', '/loader.lua', '/songs/numb.mp3', '/songs/w4ytoof4r.mp3', '/songs/drift.mp3'} do
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
elseif game.PlaceId == 16732694052 then
    return loadfile('bruise/games/fisch.lua')();
else
    return loadfile('bruise/games/universal.lua')();
end;