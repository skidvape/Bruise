--// init
local uilib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

--// services
local cloneref = cloneref or function(v) return v; end;
local playersService = cloneref(game:GetService('Players'));
local workspace = cloneref(game:GetService('Workspace'));
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
local weaponMeta = loadstring(game:HttpGet('https://github.com/skidvape/Bruise/raw/main/core/libs/meta.lua'))();
run = function(v)
    local suc, res = pcall(function()
        v();
    end);
    
    if res then writefile('errorlog.txt', tostring(res)); end;
end;

--// ui definition

local Window = uilib:Window({
	Title = "Bruise",
	Subtitle = "A free, fully open-source solara supported script for Roblox Bedwars.",
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

--// modules/functions

newRay = function(begin, dir)
	local p = RaycastParams.new();
	p.FilterType = Enum.RaycastFilterType.Exclude;
    p.FilterDescendantsInstances = {lplr.Character, workspace.CurrentCamera};
	return workspace:Raycast(begin, dir, p);
end;

getInv = function()
	return lplr.Character.InventoryFolder.Value or Instance.new("Folder");
end;

hasItem = function(item)
	if getInv():FindFirstChild(item) then
		return true;
	end;
	return false;
end;

local function getBestWeapon()
	local Sword;
	local swordMeta = 0;
	for i, sword in ipairs(weaponMeta) do
		local name = sword[1];
		local meta = sword[2];
		if meta > swordMeta and hasItem(name) then
			Sword = name;
			swordMeta = meta;
		end;
	end;
	return getInv():FindFirstChild(Sword);
end;

local getNearestPlayer = function(range)
	local nearest
	local nearestDist = math.huge
	for i,v in pairs(playersService:GetPlayers()) do
		pcall(function()
			if v == lplr or v.Team == lplr.Team then return; end;
			if v.Character.Humanoid.health > 0 and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
				nearest = v;
				nearestDist = (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
			end;
		end);
	end;
	for i, v in pairs(CollectionService:GetTagged('DiamondGuardian')) do
		pcall(function()
			if v.PrimaryPart then
				if (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
					nearest = v;
					nearestDist = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
				end;	
			end;
		end);
	end;
	for i, v in pairs(CollectionService:GetTagged('GolemBoss')) do
		pcall(function()
			if v.PrimaryPart then
				if (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
					nearest = v;
					nearestDist = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
				end;	
			end;
		end);
	end;
	for i, v in pairs(CollectionService:GetTagged('Monster')) do
		pcall(function()
			if v.PrimaryPart then
				if (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
					nearest = v;
					nearestDist = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
				end;	
			end;
		end);
	end;
	for i, v in pairs(CollectionService:GetTagged('GuardianOfDream')) do
		pcall(function()
			if v.PrimaryPart then
				if (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
					nearest = v;
					nearestDist = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
				end;	
			end;
		end);
	end;
	for i, v in pairs(CollectionService:GetTagged('jellyfish')) do
		pcall(function()
			if v.PrimaryPart then
				if (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
					nearest = v;
					nearestDist = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude;
				end;	
			end;
		end);
	end;
	return nearest;
end;

local getRemote = function(Name)
	for i, v in pairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") and v.Name == Name then
			return v;
		end;
	end;
	return Instance.new("RemoteEvent");
end;

local Bedwars = {
	SwordHit = getRemote("SwordHit"),
	GroundHit = getRemote("GroundHit"),
	ProjectileFire = getRemote("ProjectileFire"),
	ConsumeItem = getRemote("ConsumeItem"),
	PickupItemDrop = getRemote("PickupItemDrop"),
	Chest = getRemote("Inventory/ChestGetItem"),
	SetInvItem = getRemote("SetInvItem"),
	PlaceBlock = getRemote("PlaceBlock"),
};

getchargeRatio = function()
	local weapon = getBestWeapon();
	if weapon.Name:lower():find("hammer") then
		return 0.2 or nil;
	elseif weapon.Name:lower():find("scythe") then
		return 0.0001 or nil;
	else
		return 0 or nil;
	end;
end;

local AuraNear
local AttackPlayer = function(Player)
    local weapon = getBestWeapon();
    local primaryPart, targetPos;
    AuraNear = true;

    primaryPart = playersService.Character and playersService.Character.PrimaryPart;
    targetPos = playersService.Character and playersService.Character.PrimaryPart.Position;
    if not primaryPart or not targetPos then return; end;

    Bedwars.SwordHit:FireServer({
        chargedAttack = {
            chargeRatio = getchargeRatio()
        },
        entityInstance = playersService:IsA("Player") and playersService.Character or playersService,
        validate = {
            raycast = {
                cameraPosition = {
                    value = targetPos
                },
                cursorDirection = {
                    value = CFrame.new(lplr.Character.PrimaryPart.Position, targetPos).LookVector
                },
            },
            targetPosition = {
                value = targetPos
            },
            selfPosition = {
                value = lplr.Character.PrimaryPart.Position
            },
        },
        weapon = weapon
    });
end;

getViewmodel = function()
	return workspace.Camera.Viewmodel.RightHand.RightWrist or nil
end

run(function()
	local Aura;
	local weld = getViewmodel().C0;
	local oldweld = getViewmodel().C0;
	local AuraCon;
	local LastHP = 100;
	local Tick = 0;
	local AuraRange;
	local AuraMethod;
	local AntiHit;
	Aura = sections.combat.left:Toggle({
		Name = "Aura",
		Default = false,
		Callback = function(callback)
			if callback then
				AuraCon = RunService.Heartbeat:Connect(function()
					local nearest = getNearestPlayer(AuraRange.Value)
					if nearest then
						if AuraMethod.Option == "Normal" then
							AttackPlayer(nearest)
						elseif AuraMethod.Option == "Tick" then
							if Tick > 24 then
								AttackPlayer(nearest)
							end
						end
						getViewmodel().C0 = oldweld * CFrame.new(0.7, -0.4, 0.1) * CFrame.Angles(math.rad(-65), math.rad(55), math.rad(-50))
					else
						getViewmodel().C0 = oldweld
						AuraNear = false
					end
					if AntiHit.Option == "TeleportBehind" and LastHP < lplr.Character.Humanoid.Health then
						lplr.Character.PrimaryPart.CFrame = nearest.Character.PrimaryPart.CFrame + nearest.Character.PrimaryPart.CFrame.LookVector * -7 + Vector3.new(0,6,0)
					end
					LastHP = lplr.Character.Humanoid.Health
					Tick += 1
				end)
			else
				AuraNear = false
				AuraCon:Disconnect()
				Tick = 0
			end
		end,
	}, "Aura");
	AuraRange = sections.combat.left:Slider({
		Name = "Range",
		Default = 18,
		Minimum = 0,
		Maximum = 18,
		DisplayMethod = "Percent",
		Precision = 0,
		Callback = function(value)
			if value then
				value = AuraRange.Option;
			end;
		end,
	}, "Slider")
	AuraMethod = sections.combat.left:Dropdown({
		Name = "Method",
		Multi = false,
		Required = true,
		Options = {'Normal', 'Tick'},
		Default = 1,
		Callback = function(value)
			if value then
				value = AuraMethod.Option;
			end;
		end,
	}, "AuraMethod")
	AntiHit = sections.combat.left:Dropdown({
		Name = "Dropdown",
		Multi = false,
		Required = true,
		Options = {'TeleportBehind', 'SpoofPos'},
		Default = 1,
		Callback = function(value)
			if value then
				value = AntiHit.Option;
			end;
		end,
	}, "AntiHit")
end)

uilib:SetFolder("bruise/core/configs");
uitabs.settings:InsertConfigSection("Left");

for i,v in ipairs(uitabs) do v:Select(); end;
uilib:LoadAutoLoadConfig();