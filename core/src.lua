-- init
local uilib = loadstring(game:HttpGet('https://github.com/depthso/Roblox-ImGUI/raw/main/ImGui.lua'))();

-- services
local cloneref = cloneref or function(v) return v; end;
local playersService = cloneref(game:GetService('Players'));
local Lighting = cloneref(game:GetService('Lighting'));
local RunService = cloneref(game:GetService('RunService'));
local TextService = cloneref(game:GetService('TextService'));
local HttpService = cloneref(game:GetService('HttpService'));
local TweenService = cloneref(game:GetService('TweenService'));
local UserInputService = cloneref(game:GetService('UserInputService'));
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'));
local CollectionService = cloneref(game:GetService('CollectionService'));
local VirtualUser = cloneref(game:GetService('VirtualUser'));
local lplr = playersService.LocalPlayer;

-- functions/tables
local swordmeta = loadstring(game:HttpGet('https://github.com/skidvape/Bruise/raw/main/core/meta.lua'))();
local ui = {
    Window = uilib:CreateWindow({
        Title = "Bruise",
        Size = UDim2.new(0, 350, 0, 370),
        Position = UDim2.new(0.5, 0, 0, 70)
    });
    tabs = {
        ConsoleTab = ui.Window:CreateTab({
            Name = "Console"
        })
    };
};

--// console

ui.Window:Center();

ui.Window:ShowTab(ui.tabs.ConsoleTab) 
        
local Row2 = ui.tabs.ConsoleTab:Row()

ui.tabs.ConsoleTab:Separator({
    Text = "Console Example:"
})

local Console = ui.tabsConsoleTab:Console({
    Text = "Console example",
    ReadOnly = true,
    LineNumbers = false,
    Border = false,
    Fill = true,
    Enabled = true,
    AutoScroll = true,
    RichText = true,
    MaxLines = 50
})

Row2:Button({
    Text = "Clear",
    Callback = Console.Clear
})
Row2:Button({
    Text = "Copy"
})
Row2:Button({
    Text = "Pause",
    Callback = function(self)
        local Paused = shared.Pause
        Paused = not (Paused or false)
        shared.Pause = Paused
        
        self.Text = Paused and "Paused" or "Pause"
        Console.Enabled = not Paused
    end,
})
Row2:Fill()

coroutine.wrap(function()
    while wait() do
        local Date = DateTime.now():FormatLocalTime("h:mm:ss A", "en-us")
        
        Console:AppendText(
            `<font color="rgb(240, 40, 10)">[Random Math]</font>`, 
            math.random()
        )
        Console:AppendText(
            `[{Date}] {Console}`
        )
    end
end)()

run = function(v)
    local suc, res = pcall(function()
        return v;
    end);
    
    if res then writefile('errorlog.txt', tostring(res)); end;
end;