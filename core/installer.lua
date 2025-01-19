local url = 'https://raw.githubusercontent.com/skidvape/Bruise/main';

for _, v in {'bruise', 'bruise/core', 'bruise/songs'} do
    if not isfolder(v) then makefolder(v); end;
end;

local files = {
    '/core/installer.lua',
    '/core/meta.lua',
    '/core/src.lua',
    '/loader.lua'   
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
return loadstring(game:HttpGet('https://github.com/skidvape/Bruise/raw/main/core/src.lua'))();