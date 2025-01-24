--// init
local uilib = loadfile('bruise/core/ui/interface.lua')();

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
local workspace = cloneref(game:GetService('Workspace'));
local lplr = playersService.LocalPlayer;
run = function(v)
    local suc, res = pcall(function()
        v();
    end);
    
    if res then writefile('errorlog.lua', tostring(res)); end;
end;

--// ui definition

local Window = uilib:Window({
	Title = "Bruise",
	Subtitle = "A free, fully open-source solara supported script for Arsenal.",
	Size = UDim2.fromOffset(960, 426),
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
	}),
    FPSCap = Window:GlobalSetting({
		Name = "Unlock FPS",
		Default = false,
		Callback = function(bool)
            setfpscap(bool and 9e9 or 60);
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
	local SongOption
	local audios = {}
	local path = 'bruise/songs'
	local suc, err = pcall(function()
		for i, v in pairs(listfiles(path)) do
			local name = v:match("^.+/(.+)%.mp3$")
			audios[name] = getcustomasset(v)
		end
	end)
	
	if err then
		audios = {
			numb = getcustomasset("bruise/songs/numb.mp3"),
			w4ytoof4r = getcustomasset("bruise/songs/w4ytoof4r.mp3"),
			drift = getcustomasset("bruise/songs/drift.mp3")
		}
		warn(err)
	end
	
	local audiolist = {}
	for i, v in audios do
		table.insert(audiolist, i)
	end
	local newAudio
    local Volume
    local Loop
	MusicPlayer = sections.utility.left:Toggle({
		Name = "MusicPlayer",
		Default = false,
		Callback = function(callback)
			if callback then
				newAudio = Instance.new("Sound", workspace);
				newAudio.SoundId = audios[SongOption.Value] or "";
				if newAudio.SoundId and newAudio.SoundId ~= "" then
					newAudio:Play();
					newAudio.Looped = Loop.Value;
                    newAudio.Volume = Volume.Value;
				else
					warn("executor issue LOL (p.s your exec is buns)");
				end;
			else
				newAudio:Stop();
				newAudio = nil;
			end;
		end,
	}, "MusicPlayer")
    Volume = sections.utility.left:Slider({
        Name = "Volume",
        Default = 1,
        Minimum = 0,
        Maximum = 1,
        DisplayMethod = "Percent",
        Callback = function(value)
            Volume.Value = value
            if value then newAudio.Volume = value end
        end,
    }, "Volume")
    Loop = sections.utility.left:Toggle({
        Name = "Loop",
        Default = false,
        Callback = function(value)
            Loop.Value = value;
            if value then newAudio.Looped = value end
        end,
    }, "Loop")
	SongOption = sections.utility.left:Dropdown({
		Name = "Dropdown",
		Multi = false,
		Required = true,
		Options = audiolist,
		Default = 1,
		Callback = function(value)
			if newAudio then
				newAudio:Stop();
				newAudio.SoundId = audios[value] or "";
				if newAudio.SoundId and newAudio.SoundId ~= "" then
					newAudio:Play();
				end;
			end;
			SongOption.Value = value;
		end,
	}, "SongOption")
end)

run(function()
    local HumanoidPartService = {};
    local oldsize = {};
    local SilentAim = {};
    local TorsoSize = {};
    --[[local getplrname = function()
        for i,v in pairs(game:GetChildren()) do
            if v.ClassName == "Players" then
                return v.Name;
            end;
        end
    end
    local plr = game[getplrname()];]]
    SilentAim = sections.combat.left:Toggle({
        Name = "SilentAim",
        Default = false,
        Callback = function(value)
            if value then
                task.spawn(function()
                    repeat task.wait()
                        for i,v in pairs(playersService:GetPlayers()) do
                            task.wait()
                            HumanoidPartService = {
                                RightLeg = v.Character.RightUpperLeg,
                                LeftLeg = v.Character.LeftUpperLeg,
                                Head = v.Character.Head,
                                HumanoidRootPart = v.Character.HumanoidRootPart
                            }
                            oldsize = {
                                RightLeg = HumanoidPartService.RightLeg.Size,
                                LeftLeg = HumanoidPartService.LeftLeg.Size,
                                Head = HumanoidPartService.Head.Size,
                                HumanoidRootPart = HumanoidPartService.Head.Size
                            }
							if v.Character and v.Team ~= lplr.Team and lplr.Name ~= v.Name then
								for i,v in pairs(HumanoidPartService) do
									v.CanCollide = false;
									v.Transparency = 10;
									v.Size = Vector3.new(TorsoSize.Value, TorsoSize.Value, TorsoSize.Value);
								end
							end
                        end
                    until not value
                end)
            else
                for i,v in pairs(playersService:GetPlayers()) do
					if v.Team ~= lplr.Team and v.Name ~= lplr.Name and v.Character then
						for i,v in pairs(HumanoidPartService) do
							v.CanCollide = true;
							v.Transparency = 0;
							v.Size = oldsize[i];
							HumanoidPartService = nil;
							oldsize = nil;
						end
					end
                end
            end
        end
    })
    TorsoSize = sections.combat.left:Slider({
        Name = "Torso Size",
        Default = 15,
        Minimum = 10,
        Maximum = 50,
        DisplayMethod = "Value",
        Callback = function(value)
            TorsoSize.Value = value
            for i,v in pairs(playersService:GetPlayers()) do
                if v.Team ~= lplr.Team and v.Name ~= lplr.Name and v.Character then
                    for i,v in pairs(HumanoidPartService) do
                        v.Size = Vector3.new(value, value, value);
                    end
                end
            end
        end,
    })
end)

uilib:SetFolder("bruise/core/configs");
uitabs.settings:InsertConfigSection("Left");

for i,v in ipairs(uitabs) do v:Select(); end;
uilib:LoadAutoLoadConfig();