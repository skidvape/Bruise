local cloneref = cloneref or function(v) return v; end;
local url = 'https://raw.githubusercontent.com/skidvape/Bruise/main/..';

if not isfolder('Bruise') then makefolder('Bruise'); end;
if not isfolder('Bruise/core') then makefolder('Bruise/core'); end;
if not isfolder('Bruise/core/songs') then makefolder('Bruise/core/songs'); end;

local files = {
    '/core/installer.lua',
    '/core/meta.lua',
    '/core/src.lua',
    '/loader.lua'
};

local suc, res = pcall(function()
    for i,v in pairs(files) do
        if not isfile('Bruise'..v) then
            writefile('Bruise'..v, game:HttpGet(url..v));
        end;
    end;
end);

if res and not suc then writefile('errorlog.lua', tostring(res)); end;

return loadstring(game:HttpGet('https://github.com/skidvape/Bruise/raw/main/core/src.lua'))();