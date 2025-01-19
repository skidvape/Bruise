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
};

ui.Window:Center();