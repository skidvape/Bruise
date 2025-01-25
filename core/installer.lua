for _, v in {'bruise', 'bruise/core', 'bruise/core/ui', 'bruise/songs', 'bruise/core/configs', 'bruise/games', 'bruise/errors'} do
    if not isfolder(v) then makefolder(v); end;
end;

local res, err = pcall(function()
    for _, v in {'/core/installer.lua', '/core/ui/interface.lua', '/games/universal.lua', '/games/arsenal.lua', '/games/fisch.lua', '/loader.lua', '/songs/numb.mp3', '/songs/w4ytoof4r.mp3', '/songs/drift.mp3'} do
        if not isfile('bruise'..v) then
            writefile('bruise'..v, game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/main'..v));
        elseif isfile('bruise'..v) then
            delfile('bruise'..v);
            writefile('bruise'..v, game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/main'..v));
        end;
    end;
end);

if err then
    if not isfile('bruise/errors/errorlog.lua') then
        warn(tostring(err));
        writefile('bruise/errors/errorlog.lua', debug.traceback(tostring(err)));
    elseif isfile('bruise/errors/errorlog.lua') then
        delfile('bruise/errors/errorlog.lua');
        warn(tostring(err));
        writefile('bruise/errors/errorlog.lua', debug.traceback(tostring(err)));
    end;
end;

if res then
    if game.PlaceId == 286090429 then
        return loadfile('bruise/games/arsenal.lua')();
    elseif game.PlaceId == 16732694052 then
        return loadfile('bruise/games/fisch.lua')();
    else
        return loadfile('bruise/games/universal.lua')();
    end;
end;