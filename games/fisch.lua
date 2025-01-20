--// init
local uilib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

--// services
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
run = function(v)
    local suc, res = pcall(function()
        return v;
    end);
    
    if res then writefile('errorlog.txt', tostring(res)); end;
end;

--// ui definition

local Window = uilib:Window({
	Title = "Bruise",
	Subtitle = "A free, fully open-source solara supported script for Roblox Arsenal.",
	Size = UDim2.fromOffset(868, 650),
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.RightShift,
	AcrylicBlur = true,
})

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Notifications",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " Notifications",
				Lifetime = 5
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5
			})
		end,
	})
};

local tabs = {
	modules = Window:TabGroup(),
    configs = Window:TabGroup()
};

local uitabs = {
    combat = tabs.modules:Tab({
        Name = "Combat",
        Image = "rbxassetid://14368312652"
    }),
    movement = tabs.modules:Tab({
        Name = "Movement",
        Image = "rbxassetid://14368306745"
    }),
    render = tabs.modules:Tab({
        Name = "Render",
        Image = "rbxassetid://14368350193"
    }),
    utility = tabs.modules:Tab({
        Name = "Utility",
        Image = "rbxassetid://14368359107"
    }),
    settings = tabs.configs:Tab({
        Name = "Config Settings",
        Image = "rbxassetid://10734950309"
    })
};

local sections = {
	combat = {
		left = uitabs.combat:Section({
			Side = 'Left'
		}),
		right = uitabs.combat:Section({
			Side = 'Right'
		})
	},
	movement = {
		left = uitabs.movement:Section({
			Side = 'Left'
		}),
		right = uitabs.movement:Section({
			Side = 'Right'
		})
	},
	render = {
		left = uitabs.render:Section({
			Side = 'Left'
		}),
		right = uitabs.render:Section({
			Side = 'Right'
		})
	},
	utility = {
		left = uitabs.utility:Section({
			Side = 'Left'
		}),
		right = uitabs.utility:Section({
			Side = 'Right'
		})
	}
};

--// modules

run(function()
	local MusicPlayer
	local audios = {};
	local path = 'bruise/songs';
	local audiolist = {}
	for i, v in pairs(listfiles(path)) do
		local name = v:match("^.+/(.+)%.mp3$");
		audios[name] = getcustomasset(v);
	end;
	for i,v in audios do table.insert(audiolist, i); end;
	local SongOption
	MusicPlayer = sections.utility.left:Toggle({
		Name = "MusicPlayer",
		Default = false,
		Callback = function(callback)
			if callback then
				newAudio = Instance.new("Sound", workspace)
				newAudio.SoundId = audios[SongOption.Option]
				newAudio:Play()
				newAudio.Looped = true
			else
				newAudio:Stop()
				newAudio = nil
			end
		end,
	}, "MusicPlayer")
	SongOption = sections.combat.left:Dropdown({
		Name = "Dropdown",
		Multi = false,
		Required = true,
		Options = audiolist,
		Default = 1,
		Callback = function(value)
			if value then
				value = SongOption.Option;
			end;
		end,
	}, "SongOption")
end)

uilib:SetFolder("bruise/core/configs");
uitabs.settings:InsertConfigSection("Left");

for i,v in ipairs(uitabs) do v:Select(); end;
uilib:LoadAutoLoadConfig();

warn('Bruise IS STILL in development, and thus is NOT finished yet!');