local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

repeat task.wait() until Workspace:FindFirstChild("Bots")
local Events = ReplicatedStorage:WaitForChild("Events")
local RemoteEvent = Events:WaitForChild("RemoteEvent")

local LocalPlayer = PlayerService.LocalPlayer
local Aimbot,SilentAim,NPCFolder,Network,
GroundTip,AircraftTip,PredictedVelocity
= false,nil,Workspace.Bots,{},nil,nil,1000

local TI = TweenInfo.new(10,Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut,0,false,0)
local TI2 = TweenInfo.new(5,Enum.EasingStyle.Linear,
Enum.EasingDirection.InOut,0,false,0)

local AFKPlaces = {
    CFrame.new(3853.97021484375, 172.68963623046875, -429.0279541015625), -- City Hall
    CFrame.new(-5125.18359375, 105.015625, 5607.85791015625), -- Iraq
    CFrame.new(-1584.665771484375, 820.1268310546875, -4451.94775390625), -- Mountain Outpost
    CFrame.new(6282.3046875, 125.08175659179688, 2208.153076171875), -- Navalbase
    CFrame.new(469.768310546875, 21.769287109375, 2273.580078125), -- Quary
    CFrame.new(1225.836669921875, 55.94757080078125, -5377.25439453125), -- Power Station
    CFrame.new(6866.8974609375, 181.8929443359375, -1910.042236328125), -- Stronghold
    CFrame.new(497.245361328125, 113.73883056640625, -209.046875) -- Vietnama Village
}

local Window = Matr1x.Utilities.UI:Window({
    Name = "Matr1x Hub — "..Matr1x.Game,
    Position = UDim2.new(0.05,0,0.5,-248)
    }) do Window:Watermark({Enabled = true})

    local AimAssistTab = Window:Tab({Name = "Combat"}) do
        local GlobalSection = AimAssistTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Toggle({Name = "Team Check",Flag = "TeamCheck",Value = false})
            GlobalSection:Dropdown({Name = "Target Mode",Flag = "BRM5/TargetMode",List = {
                {Name = "Player",Mode = "Button"},
                {Name = "NPC",Mode = "Button",Value = true}
            }})
        end
        local AimbotSection = AimAssistTab:Section({Name = "Aimbot",Side = "Left"}) do
            AimbotSection:Toggle({Name = "Enabled",Flag = "Aimbot/Enabled",Value = false})
            AimbotSection:Toggle({Name = "Prediction",Flag = "Aimbot/Prediction",Value = false})
            AimbotSection:Toggle({Name = "Visibility Check",Flag = "Aimbot/WallCheck",Value = false})
            AimbotSection:Toggle({Name = "Dynamic FOV",Flag = "Aimbot/DynamicFOV",Value = false})
            AimbotSection:Keybind({Name = "Keybind",Flag = "Aimbot/Keybind",Value = "MouseButton2",
            Mouse = true,Callback = function(Key,KeyDown) Aimbot = Window.Flags["Aimbot/Enabled"] and KeyDown end})
            AimbotSection:Slider({Name = "Smoothness",Flag = "Aimbot/Smoothness",Min = 0,Max = 100,Value = 25,Unit = "%"})
            AimbotSection:Slider({Name = "Field Of View",Flag = "Aimbot/FieldOfView",Min = 0,Max = 500,Value = 100})
            AimbotSection:Dropdown({Name = "Priority",Flag = "Aimbot/Priority",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle",Value = true}
            }})
        end
        local AFOVSection = AimAssistTab:Section({Name = "Aimbot FOV Circle",Side = "Left"}) do
            AFOVSection:Toggle({Name = "Enabled",Flag = "Aimbot/Circle/Enabled",Value = true})
            AFOVSection:Toggle({Name = "Filled",Flag = "Aimbot/Circle/Filled",Value = false})
            AFOVSection:Colorpicker({Name = "Color",Flag = "Aimbot/Circle/Color",Value = {1,0.75,1,0.5,false}})
            AFOVSection:Slider({Name = "NumSides",Flag = "Aimbot/Circle/NumSides",Min = 3,Max = 100,Value = 100})
            AFOVSection:Slider({Name = "Thickness",Flag = "Aimbot/Circle/Thickness",Min = 1,Max = 10,Value = 1})
        end
        local TFOVSection = AimAssistTab:Section({Name = "Trigger FOV Circle",Side = "Left"}) do
            TFOVSection:Toggle({Name = "Enabled",Flag = "Trigger/Circle/Enabled",Value = true})
            TFOVSection:Toggle({Name = "Filled",Flag = "Trigger/Circle/Filled",Value = false})
            TFOVSection:Colorpicker({Name = "Color",Flag = "Trigger/Circle/Color",Value = {1,0.25,1,0.5,true}})
            TFOVSection:Slider({Name = "NumSides",Flag = "Trigger/Circle/NumSides",Min = 3,Max = 100,Value = 100})
            TFOVSection:Slider({Name = "Thickness",Flag = "Trigger/Circle/Thickness",Min = 1,Max = 10,Value = 1})
        end
        local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Right"}) do
            SilentAimSection:Toggle({Name = "Enabled",Flag = "SilentAim/Enabled",Value = false})
            :Keybind({Mouse = true,Flag = "SilentAim/Keybind"})
            SilentAimSection:Toggle({Name = "Visibility Check",Flag = "SilentAim/WallCheck",Value = false})
            SilentAimSection:Toggle({Name = "Dynamic FOV",Flag = "SilentAim/DynamicFOV",Value = false})
            SilentAimSection:Slider({Name = "Hit Chance",Flag = "SilentAim/HitChance",Min = 0,Max = 100,Value = 100,Unit = "%"})
            SilentAimSection:Slider({Name = "Field Of View",Flag = "SilentAim/FieldOfView",Min = 0,Max = 500,Value = 50})
            SilentAimSection:Dropdown({Name = "Priority",Flag = "SilentAim/Priority",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle"}
            }})
        end
        local SAFOVSection = AimAssistTab:Section({Name = "Silent Aim FOV Circle",Side = "Right"}) do
            SAFOVSection:Toggle({Name = "Enabled",Flag = "SilentAim/Circle/Enabled",Value = true})
            SAFOVSection:Toggle({Name = "Filled",Flag = "SilentAim/Circle/Filled",Value = false})
            SAFOVSection:Colorpicker({Name = "Color",Flag = "SilentAim/Circle/Color",Value = {0.66666668653488,0.75,1,0.5,false}})
            SAFOVSection:Slider({Name = "NumSides",Flag = "SilentAim/Circle/NumSides",Min = 3,Max = 100,Value = 100})
            SAFOVSection:Slider({Name = "Thickness",Flag = "SilentAim/Circle/Thickness",Min = 1,Max = 10,Value = 1})
        end
        local TriggerSection = AimAssistTab:Section({Name = "Trigger",Side = "Right"}) do
            TriggerSection:Toggle({Name = "Enabled",Flag = "Trigger/Enabled",Value = false})
            TriggerSection:Toggle({Name = "Prediction",Flag = "Trigger/Prediction",Value = false})
            TriggerSection:Toggle({Name = "Visibility Check",Flag = "Trigger/WallCheck",Value = true})
            TriggerSection:Toggle({Name = "Dynamic FOV",Flag = "Trigger/DynamicFOV",Value = false})
            TriggerSection:Keybind({Name = "Keybind",Flag = "Trigger/Keybind",Value = "MouseButton2",
            Mouse = true,Callback = function(Key,KeyDown) Trigger = Window.Flags["Trigger/Enabled"] and KeyDown end})
            TriggerSection:Slider({Name = "Field Of View",Flag = "Trigger/FieldOfView",Min = 0,Max = 500,Value = 10})
            TriggerSection:Slider({Name = "Delay",Flag = "Trigger/Delay",Min = 0,Max = 1,Precise = 2,Value = 0.15})
            TriggerSection:Toggle({Name = "Hold Mode",Flag = "Trigger/HoldMode",Value = false})
            TriggerSection:Toggle({Name = "Switch To RMB",Flag = "Trigger/RMBMode",Value = false})
            TriggerSection:Dropdown({Name = "Priority",Flag = "Trigger/Priority",List = {
                {Name = "Head",Mode = "Toggle",Value = true},
                {Name = "HumanoidRootPart",Mode = "Toggle",Value = true}
            }})
        end
    end
    local VisualsTab = Window:Tab({Name = "Visuals"}) do
        local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Ally Color",Flag = "ESP/Player/Ally",Value = {0.33333334326744,0.75,1,0,false}})
            GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/Player/Enemy",Value = {1,0.75,1,0,false}})
            GlobalSection:Toggle({Name = "Team Check",Flag = "ESP/Player/TeamCheck",Value = false})
            GlobalSection:Toggle({Name = "Use Team Color",Flag = "ESP/Player/TeamColor",Value = false})
        end
        local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Box/Enabled",Value = false})
            BoxSection:Toggle({Name = "Filled",Flag = "ESP/Player/Box/Filled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Box/Outline",Value = true})
            BoxSection:Slider({Name = "Thickness",Flag = "ESP/Player/Box/Thickness",Min = 1,Max = 10,Value = 1})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Box/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Text/Enabled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Text/Outline",Value = true})
            BoxSection:Toggle({Name = "Autoscale",Flag = "ESP/Player/Text/Autoscale",Value = true})
            BoxSection:Dropdown({Name = "Font",Flag = "ESP/Player/Text/Font",List = {
                {Name = "UI",Mode = "Button"},
                {Name = "System",Mode = "Button"},
                {Name = "Plex",Mode = "Button"},
                {Name = "Monospace",Mode = "Button",Value = true}
            }})
            BoxSection:Slider({Name = "Size",Flag = "ESP/Player/Text/Size",Min = 13,Max = 100,Value = 16})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
            OoVSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Arrow/Enabled",Value = false})
            OoVSection:Toggle({Name = "Filled",Flag = "ESP/Player/Arrow/Filled",Value = true})
            OoVSection:Slider({Name = "Width",Flag = "ESP/Player/Arrow/Width",Min = 14,Max = 28,Value = 18})
            OoVSection:Slider({Name = "Height",Flag = "ESP/Player/Arrow/Height",Min = 14,Max = 28,Value = 28})
            OoVSection:Slider({Name = "Distance From Center",Flag = "ESP/Player/Arrow/Distance",Min = 80,Max = 200,Value = 200})
            OoVSection:Slider({Name = "Thickness",Flag = "ESP/Player/Arrow/Thickness",Min = 1,Max = 10,Value = 1})
            OoVSection:Slider({Name = "Transparency",Flag = "ESP/Player/Arrow/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HeadSection = VisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Head/Enabled",Value = false})
            HeadSection:Toggle({Name = "Filled",Flag = "ESP/Player/Head/Filled",Value = true})
            HeadSection:Toggle({Name = "Autoscale",Flag = "ESP/Player/Head/Autoscale",Value = true})
            HeadSection:Slider({Name = "Radius",Flag = "ESP/Player/Head/Radius",Min = 1,Max = 10,Value = 8})
            HeadSection:Slider({Name = "NumSides",Flag = "ESP/Player/Head/NumSides",Min = 3,Max = 100,Value = 4})
            HeadSection:Slider({Name = "Thickness",Flag = "ESP/Player/Head/Thickness",Min = 1,Max = 10,Value = 1})
            HeadSection:Slider({Name = "Transparency",Flag = "ESP/Player/Head/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
            TracerSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Tracer/Enabled",Value = false})
            TracerSection:Dropdown({Name = "Mode",Flag = "ESP/Player/Tracer/Mode",List = {
                {Name = "From Bottom",Mode = "Button",Value = true},
                {Name = "From Mouse",Mode = "Button"}
            }})
            TracerSection:Slider({Name = "Thickness",Flag = "ESP/Player/Tracer/Thickness",Min = 1,Max = 10,Value = 1})
            TracerSection:Slider({Name = "Transparency",Flag = "ESP/Player/Tracer/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
            HighlightSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Highlight/Enabled",Value = false})
            HighlightSection:Slider({Name = "Transparency",Flag = "ESP/Player/Highlight/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            HighlightSection:Colorpicker({Name = "Outline Color",Flag = "ESP/Player/Highlight/OutlineColor",Value = {1,1,0,0.5,false}})
        end
    end
    local NPCVisualsTab = Window:Tab({Name = "NPC Visuals"}) do
        local GlobalSection = NPCVisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Civilian Color",Flag = "ESP/NPC/Ally",Value = {0.33333334326744,0.75,1,0,false}})
            GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/NPC/Enemy",Value = {1,0.75,1,0,false}})
            GlobalSection:Toggle({Name = "Hide Civilians",Flag = "ESP/NPC/TeamCheck",Value = true})
        end
        local BoxSection = NPCVisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Box/Enabled",Value = false})
            BoxSection:Toggle({Name = "Filled",Flag = "ESP/NPC/Box/Filled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/NPC/Box/Outline",Value = true})
            BoxSection:Slider({Name = "Thickness",Flag = "ESP/NPC/Box/Thickness",Min = 1,Max = 10,Value = 1})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Box/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Text/Enabled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/NPC/Text/Outline",Value = true})
            BoxSection:Toggle({Name = "Autoscale",Flag = "ESP/NPC/Text/Autoscale",Value = true})
            BoxSection:Dropdown({Name = "Font",Flag = "ESP/NPC/Text/Font",List = {
                {Name = "UI",Mode = "Button"},
                {Name = "System",Mode = "Button"},
                {Name = "Plex",Mode = "Button"},
                {Name = "Monospace",Mode = "Button",Value = true}
            }})
            BoxSection:Slider({Name = "Size",Flag = "ESP/NPC/Text/Size",Min = 13,Max = 100,Value = 16})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local OoVSection = NPCVisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
            OoVSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Arrow/Enabled",Value = false})
            OoVSection:Toggle({Name = "Filled",Flag = "ESP/NPC/Arrow/Filled",Value = true})
            OoVSection:Slider({Name = "Height",Flag = "ESP/NPC/Arrow/Height",Min = 14,Max = 28,Value = 28})
            OoVSection:Slider({Name = "Width",Flag = "ESP/NPC/Arrow/Width",Min = 14,Max = 28,Value = 18})
            OoVSection:Slider({Name = "Distance From Center",Flag = "ESP/NPC/Arrow/Distance",Min = 80,Max = 200,Value = 200})
            OoVSection:Slider({Name = "Thickness",Flag = "ESP/NPC/Arrow/Thickness",Min = 1,Max = 10,Value = 1})
            OoVSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Arrow/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HeadSection = NPCVisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Head/Enabled",Value = false})
            HeadSection:Toggle({Name = "Filled",Flag = "ESP/NPC/Head/Filled",Value = true})
            HeadSection:Toggle({Name = "Autoscale",Flag = "ESP/NPC/Head/Autoscale",Value = true})
            HeadSection:Slider({Name = "Radius",Flag = "ESP/NPC/Head/Radius",Min = 1,Max = 10,Value = 8})
            HeadSection:Slider({Name = "NumSides",Flag = "ESP/NPC/Head/NumSides",Min = 3,Max = 100,Value = 4})
            HeadSection:Slider({Name = "Thickness",Flag = "ESP/NPC/Head/Thickness",Min = 1,Max = 10,Value = 1})
            HeadSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Head/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local TracerSection = NPCVisualsTab:Section({Name = "Tracers",Side = "Right"}) do
            TracerSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Tracer/Enabled",Value = false})
            TracerSection:Dropdown({Name = "Mode",Flag = "ESP/NPC/Tracer/Mode",List = {
                {Name = "From Bottom",Mode = "Button",Value = true},
                {Name = "From Mouse",Mode = "Button"}
            }})
            TracerSection:Slider({Name = "Thickness",Flag = "ESP/NPC/Tracer/Thickness",Min = 1,Max = 10,Value = 1})
            TracerSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Tracer/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HighlightSection = NPCVisualsTab:Section({Name = "Highlights",Side = "Right"}) do
            HighlightSection:Toggle({Name = "Enabled",Flag = "ESP/NPC/Highlight/Enabled",Value = false})
            HighlightSection:Slider({Name = "Transparency",Flag = "ESP/NPC/Highlight/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            HighlightSection:Colorpicker({Name = "Outline Color",Flag = "ESP/NPC/Highlight/OutlineColor",Value = {1,1,0,0.5,false}})
        end
    end
    local GameTab = Window:Tab({Name = Matr1x.Game}) do
        local EnvSection = GameTab:Section({Name = "Environment"}) do
            EnvSection:Toggle({Name = "Enabled",Flag = "BRM5/Lighting/Enabled",Value = false})
            EnvSection:Toggle({Name = "Brightness",Flag = "BRM5/Lighting/Brightness",Value = false,Callback = function(Bool)
                Lighting.GlobalShadows = not Bool
            end})
            EnvSection:Slider({Name = "Clock Time",Flag = "BRM5/Lighting/Time",Min = 0,Max = 24,Value = 12})
            EnvSection:Slider({Name = "Fog Density",Flag = "BRM5/Lighting/Fog",Min = 0,Max = 1,Precise = 2,Value = 0.25})
        end
        local WeaponSection = GameTab:Section({Name = "Weapon"}) do
            WeaponSection:Toggle({Name = "Recoil",Flag = "BRM5/Recoil/Enabled",Value = false})
            WeaponSection:Slider({Name = "Recoil Percent",Flag = "BRM5/Recoil/Value",Min = 0,Max = 100,Value = 0,Unit = "%"})
            WeaponSection:Toggle({Name = "Instant Hit",Flag = "BRM5/BulletDrop",Value = false})
            :ToolTip("silent aim works better with it")
            WeaponSection:Toggle({Name = "Unlock Firemodes",Flag = "BRM5/Firemodes",Value = false})
            :ToolTip("re-equip your weapon to make it work")
            WeaponSection:Toggle({Name = "Rapid Fire",Flag = "BRM5/RapidFire/Enabled",Value = false}):ToolTip("re-equip your weapon to disable")
            WeaponSection:Slider({Name = "Round Per Minute",Flag = "BRM5/RapidFire/Value",Min = 45,Max = 1000,Value = 1000})
        end
        local CharSection = GameTab:Section({Name = "Character"}) do
            CharSection:Toggle({Name = "Anti Fall",Flag = "BRM5/AntiFall",Value = false})
            CharSection:Toggle({Name = "No NVG Effect",Flag = "BRM5/DisableNVG",Value = false})
            CharSection:Toggle({Name = "No NVG Shape",Flag = "BRM5/NVGShape",Value = false})
            CharSection:Toggle({Name = "No Camera Bob",Flag = "BRM5/NoBob",Value = false})
            CharSection:Toggle({Name = "Speedhack",Flag = "BRM5/WalkSpeed/Enabled",Value = false}):Keybind()
            CharSection:Slider({Name = "Speed",Flag = "BRM5/WalkSpeed/Value",Min = 16,Max = 1000,Value = 120})
        end
        local TPSection = GameTab:Section({Name = "Teleports"}) do
            TPSection:Button({Name = "City Hall",Callback = function()
                TeleportCharacter(AFKPlaces[1])
            end})
            TPSection:Button({Name = "Iraq",Callback = function()
                TeleportCharacter(AFKPlaces[2])
            end})
            TPSection:Button({Name = "Mountain Outpost",Callback = function()
                TeleportCharacter(AFKPlaces[3])
            end})
            TPSection:Button({Name = "Navalbase",Callback = function()
                TeleportCharacter(AFKPlaces[4])
            end})
            TPSection:Button({Name = "Quary",Callback = function()
                TeleportCharacter(AFKPlaces[5])
            end})
            TPSection:Button({Name = "Power Station",Callback = function()
                TeleportCharacter(AFKPlaces[6])
            end})
            TPSection:Button({Name = "Stronghold",Callback = function()
                TeleportCharacter(AFKPlaces[7])
            end})
            TPSection:Button({Name = "Vietnama Village",Callback = function()
                TeleportCharacter(AFKPlaces[8])
            end})
        end
        local VehSection = GameTab:Section({Name = "Vehicle"}) do
            VehSection:Toggle({Name = "Enabled",Flag = "BRM5/Vehicle/Enabled",Value = false})
            VehSection:Slider({Name = "Speed",Flag = "BRM5/Vehicle/Speed",Min = 0,Max = 1000,Value = 100})
            VehSection:Slider({Name = "Acceleration",Flag = "BRM5/Vehicle/Acceleration",Min = 1,Max = 50,Value = 1})
            :ToolTip("lower = faster")
        end
        local HeliSection = GameTab:Section({Name = "Helicopter"}) do
            HeliSection:Toggle({Name = "Enabled",Flag = "BRM5/Helicopter/Enabled",Value = false})
            HeliSection:Slider({Name = "Speed",Flag = "BRM5/Helicopter/Speed",Min = 0,Max = 500,Value = 200})
        end
        local AirSection = GameTab:Section({Name = "Aircraft"}) do
            AirSection:Toggle({Name = "Enabled",Flag = "BRM5/Aircraft/Enabled",Value = false}):Keybind()
            AirSection:Slider({Name = "Speed",Flag = "BRM5/Aircraft/Speed",Min = 130,Max = 950,Value = 130})
            AirSection:Toggle({Name = "Enable Fly",Flag = "BRM5/Aircraft/FlyEnabled",Value = false}):Keybind()
            AirSection:Toggle({Name = "Fly Use Camera",Flag = "BRM5/Aircraft/Camera",Value = false})
            AirSection:Slider({Name = "Fly Speed",Flag = "BRM5/Aircraft/FlySpeed",Min = 145,Max = 500,Value = 200})
            AirSection:Button({Name = "Setup Switches/Engines",Callback = function()
                local Aircraft = RequireModule("MovementService")
                if not Aircraft._handler or not Aircraft._handler._main then return end
                EnableSwitch("cicu")
                EnableSwitch("oxygen")
                EnableSwitch("battery")
                EnableSwitch("ac_r")
                EnableSwitch("ac_l")
                EnableSwitch("inverter")
                EnableSwitch("take_apu")
                EnableSwitch("apu")
                EnableSwitch("engine_r")
                EnableSwitch("engine_l")
                EnableSwitch("fuel_r_l")
                EnableSwitch("fuel_l_l")
                EnableSwitch("fuel_r_r")
                EnableSwitch("fuel_l_r")
                Network:FireServer("CallInteraction", "Fire", "Canopy")
                Matr1x.Utilities.UI:Notification({
                    Title = "Aircraft thingy",
                    Description = "Please wait till your engines start up, you dont need to touch anything",
                    Duration = 30
                })
                repeat task.wait() until Aircraft._handler._main.APU.engine.PlaybackSpeed == 1
                Network:FireServer("CallInteraction","Fire","LeftEngine")
                Network:FireServer("CallInteraction","Fire","RightEngine")
            end})
            AirSection:Button({Name = "Unlock Camera",Callback = function()
                local Aircraft = RequireModule("MovementService")
                local CameraMod = RequireModule("CameraService")
                CameraMod:Mount(Aircraft._handler._controller, "Character")
                CameraMod._handler._zoom = 128
            end})
        end
        local MiscSection = GameTab:Section({Name = "Misc"}) do
            MiscSection:Button({Name = "Enable Fake RGE",Callback = function()
                local serverSettings = getupvalue(require(ReplicatedStorage.Packages.server).Get,1)
                if not serverSettings.CHEATS_ENABLED then
                    serverSettings.CHEATS_ENABLED = true
                    for Index,Connection in pairs(getconnections(RemoteEvent.OnClientEvent)) do
                        Connection.Function("InitRGE")
                    end
                end
            end})
            MiscSection:Button({Name = "Force Reset Character",Callback = function()
                Network:FireServer("ResetCharacter")
            end})
        end
    end
    local SettingsTab = Window:Tab({Name = "Settings"}) do
        local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
            MenuSection:Toggle({Name = "Enabled",IgnoreFlag = true,Flag = "UI/Toggle",
            Value = Window.Enabled,Callback = function(Bool) Window:Toggle(Bool) end})
            :Keybind({Value = "RightShift",Flag = "UI/Keybind",DoNotClear = true})
            MenuSection:Toggle({Name = "Open On Load",Flag = "UI/OOL",Value = true})
            MenuSection:Toggle({Name = "Blur Gameplay",Flag = "UI/Blur",Value = false,
            Callback = function() Window:Toggle(Window.Enabled) end})
            MenuSection:Toggle({Name = "Watermark",Flag = "UI/Watermark",Value = true,
            Callback = function(Bool) Window.Watermark:Toggle(Bool) end})
            MenuSection:Toggle({Name = "Custom Mouse",Flag = "Mouse/Enabled",Value = true})
            MenuSection:Colorpicker({Name = "Color",Flag = "UI/Color",Value = {1,0.25,1,0,true},
            Callback = function(HSVAR,Color) Window:SetColor(Color) end})
        end
        SettingsTab:AddConfigSection("Left")
        SettingsTab:Button({Name = "Rejoin",Side = "Left",
        Callback = Matr1x.Utilities.Misc.ReJoin})
        SettingsTab:Button({Name = "Server Hop",Side = "Left",
        Callback = Matr1x.Utilities.Misc.ServerHop})
        SettingsTab:Button({Name = "Join Discord Server",Side = "Left",
        Callback = Matr1x.Utilities.Misc.JoinDiscord})
        :ToolTip("Join for support, updates and more!")
        local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
            BackgroundSection:Dropdown({Name = "Image",Flag = "Background/Image",List = {
                {Name = "Legacy",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://2151741365"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hearts",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073763717"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Abstract",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073743871"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hexagon",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073628839"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Circles",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071579801"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Lace With Flowers",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071575925"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Floral",Mode = "Button",Value = true,Callback = function()
                    Window.Background.Image = "rbxassetid://5553946656"
                    Window.Flags["Background/CustomImage"] = ""
                end}
            }})
            BackgroundSection:Textbox({Name = "Custom Image",Flag = "Background/CustomImage",Placeholder = "rbxassetid://ImageId",
            Callback = function(String) if string.gsub(String," ","") ~= "" then Window.Background.Image = String end end})
            BackgroundSection:Colorpicker({Name = "Color",Flag = "Background/Color",Value = {1,1,0,0,false},
            Callback = function(HSVAR,Color) Window.Background.ImageColor3 = Color Window.Background.ImageTransparency = HSVAR[4] end})
            BackgroundSection:Slider({Name = "Tile Offset",Flag = "Background/Offset",Min = 74, Max = 296,Value = 74,
            Callback = function(Number) Window.Background.TileSize = UDim2.new(0,Number,0,Number) end})
        end
        local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Right"}) do
            CrosshairSection:Toggle({Name = "Enabled",Flag = "Mouse/Crosshair/Enabled",Value = false})
            CrosshairSection:Colorpicker({Name = "Color",Flag = "Mouse/Crosshair/Color",Value = {1,1,1,0,false}})
            CrosshairSection:Slider({Name = "Size",Flag = "Mouse/Crosshair/Size",Min = 0,Max = 20,Value = 4})
            CrosshairSection:Slider({Name = "Gap",Flag = "Mouse/Crosshair/Gap",Min = 0,Max = 10,Value = 2})
        end
        local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
            CreditsSection:Label({Text = "This script was made by Matr1x#5430"})
            CreditsSection:Divider()
            CreditsSection:Label({Text = "Thanks to Jan for awesome Background Patterns"})
            CreditsSection:Label({Text = "Thanks to Infinite Yield Team for Server Hop and Rejoin"})
            CreditsSection:Label({Text = "Thanks to Blissful for Offscreen Arrows"})
            CreditsSection:Label({Text = "Thanks to coasts for Universal ESP"})
            CreditsSection:Label({Text = "Thanks to el3tric for Bracket V2"})
        end
    end
end

Window:LoadDefaultConfig()
Window:SetValue("UI/Toggle",
Window.Flags["UI/OOL"])

Matr1x.Utilities.Misc:SetupWatermark(Window)
--Matr1x.Utilities.Misc:SetupLighting(Window.Flags)
Matr1x.Utilities.Drawing:SetupCursor(Window.Flags)

Matr1x.Utilities.Drawing:FOVCircle("Aimbot",Window.Flags)
Matr1x.Utilities.Drawing:FOVCircle("Trigger",Window.Flags)
Matr1x.Utilities.Drawing:FOVCircle("SilentAim",Window.Flags)

local function FixUnit(Vector)
	if Vector.Magnitude == 0 then
	return Vector3.zero end
	return Vector.Unit
end
local function FlatCameraVector()
    local Camera = Workspace.CurrentCamera
	return Camera.CFrame.LookVector * Vector3.new(1,0,1),
		Camera.CFrame.RightVector * Vector3.new(1,0,1)
end
local function InputToVelocity() local Velocities,LookVector,RightVector = {},FlatCameraVector()
	Velocities[1] = UserInputService:IsKeyDown(Enum.KeyCode.W) and LookVector or Vector3.zero
	Velocities[2] = UserInputService:IsKeyDown(Enum.KeyCode.S) and -LookVector or Vector3.zero
	Velocities[3] = UserInputService:IsKeyDown(Enum.KeyCode.A) and -RightVector or Vector3.zero
	Velocities[4] = UserInputService:IsKeyDown(Enum.KeyCode.D) and RightVector or Vector3.zero
    Velocities[5] = UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0,1,0) or Vector3.zero
    Velocities[6] = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0,-1,0) or Vector3.zero
	return FixUnit(Velocities[1] + Velocities[2] + Velocities[3] + Velocities[4] + Velocities[5] + Velocities[6])
end

local function TeamCheck(Enabled,Player)
    if not Enabled then return true end
    return LocalPlayer.Team ~= Player.Team
end

local function WallCheck(Enabled,Hitbox,Character)
    if not Enabled then return true end
    local Camera = Workspace.CurrentCamera
    return not Camera:GetPartsObscuringTarget({Hitbox.Position},{
        LocalPlayer.Character,
        Character
    })[1]
end

local function GetHitbox(Config)
    if not Config.Enabled then return end
    local Camera = Workspace.CurrentCamera

    local FieldOfView,ClosestHitbox = Config.DynamicFOV and
    ((120 - Camera.FieldOfView) * 4) + Config.FieldOfView
    or Config.FieldOfView,nil

    if Config.TargetMode == "NPC" then
        for Index, NPC in pairs(NPCFolder:GetChildren()) do
            local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
            local IsAlive = Humanoid and Humanoid.Health > 0
            if not NPC:FindFirstChildWhichIsA("ProximityPrompt",true) and IsAlive then
                for Index, HumanoidPart in pairs(Config.Priority) do
                    local Hitbox = NPC:FindFirstChild(HumanoidPart)
                    if Hitbox then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,NPC) then
                            FieldOfView,ClosestHitbox = Magnitude,Hitbox
                        end
                    end
                end
            end
        end
    elseif Config.TargetMode == "Player" then
        for Index, Player in pairs(PlayerService:GetPlayers()) do
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local IsAlive = Humanoid and Humanoid.Health > 0
            if Player ~= LocalPlayer and IsAlive and TeamCheck(Config.TeamCheck,Player) then
                for Index, HumanoidPart in pairs(Config.Priority) do
                    local Hitbox = Character and Character:FindFirstChild(HumanoidPart)
                    if Hitbox then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,Character) then
                            FieldOfView,ClosestHitbox = Magnitude,Hitbox
                        end
                    end
                end
            end
        end
    end

    return ClosestHitbox
end

local function GetHitboxWithPrediction(Config)
    if not Config.Enabled then return end
    local Camera = Workspace.CurrentCamera

    local FieldOfView,ClosestHitbox = Config.DynamicFOV and
    ((120 - Camera.FieldOfView) * 4) + Config.FieldOfView
    or Config.FieldOfView,nil
    
    if Config.TargetMode == "NPC" then
        for Index, NPC in pairs(NPCFolder:GetChildren()) do
            local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
            local IsAlive = Humanoid and Humanoid.Health > 0
            if not NPC:FindFirstChildWhichIsA("ProximityPrompt",true) and IsAlive then
                for Index, HumanoidPart in pairs(Config.Priority) do
                    local Hitbox = NPC:FindFirstChild(HumanoidPart)
                    if Hitbox then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,NPC) then
                            FieldOfView,ClosestHitbox = Magnitude,Hitbox
                        end
                    end
                end
            end
        end
    elseif Config.TargetMode == "Player" then
        for Index, Player in pairs(PlayerService:GetPlayers()) do
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local IsAlive = Humanoid and Humanoid.Health > 0
            if Player ~= LocalPlayer and IsAlive and TeamCheck(Config.TeamCheck,Player) then
                for Index, HumanoidPart in pairs(Config.Priority) do
                    local Hitbox = Character and Character:FindFirstChild(HumanoidPart)
                    if Hitbox then
                        local HitboxDistance = (Hitbox.Position - Camera.CFrame.Position).Magnitude
                        local HitboxVelocityCorrection = (Hitbox.AssemblyLinearVelocity * HitboxDistance) / PredictedVelocity

                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Config.Prediction
                        and Hitbox.Position + HitboxVelocityCorrection or Hitbox.Position)

                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and Magnitude < FieldOfView and WallCheck(Config.WallCheck,Hitbox,Character) then
                            FieldOfView,ClosestHitbox = Magnitude,Hitbox
                        end
                    end
                end
            end
        end
    end

    return ClosestHitbox
end

local function AimAt(Hitbox,Config)
    if not Hitbox then return end
    local Camera = Workspace.CurrentCamera
    local Mouse = UserInputService:GetMouseLocation()

    local HitboxDistance = (Hitbox.Position - Camera.CFrame.Position).Magnitude
    local HitboxVelocityCorrection = (Hitbox.AssemblyLinearVelocity * HitboxDistance) / PredictedVelocity

    local HitboxOnScreen = Camera:WorldToViewportPoint(Config.Prediction
    and Hitbox.Position + HitboxVelocityCorrection or Hitbox.Position)
    mousemoverel(
        (HitboxOnScreen.X - Mouse.X) * Config.Sensitivity,
        (HitboxOnScreen.Y - Mouse.Y) * Config.Sensitivity
    )
end

function RequireModule(Name)
    for Index, Instance in pairs(getloadedmodules()) do
        if Instance.Name == Name then
            return require(Instance)
        end
    end
end
local function HookSignal(Signal,Index,Callback)
    local Connection = getconnections(Signal)[Index]
    local OldConnection = Connection.Function
    if not OldConnection then return end -- cuz shitsploits have broken getconnections
    Connection:Disable()
    Signal:Connect(function(...)
        local Args = Callback({...})
        if not Args then return end
        OldConnection(unpack(Args))
    end)
end
local function HookFunction(ModuleName,Function,Callback)
    local Module,OldFunction = RequireModule(ModuleName)
    while task.wait() do
        if Module and Module[Function] then
            OldFunction = Module[Function]
            break
        end
        Module = RequireModule(ModuleName)
    end
    Module[Function] = function(...)
        local Args = Callback({...})
        if not Args then return end
        return OldFunction(unpack(Args))
    end
end

function TeleportCharacter(Target)
    if not LocalPlayer.Character then return end
    local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end

    local OldValue = Window:GetValue("BRM5/AntiFall")
    Window:SetValue("BRM5/AntiFall",true)
    local Tween = TweenService:Create(HumanoidRootPart,TI2,{
        CFrame = HumanoidRootPart.CFrame + Vector3.new(0,1000,0),
        AssemblyLinearVelocity = Vector3.zero
    }) Tween:Play() Tween.Completed:Wait()
    local Tween = TweenService:Create(HumanoidRootPart,TI,{
        CFrame = Target + Vector3.new(0,1000,0),
        AssemblyLinearVelocity = Vector3.zero
    }) Tween:Play() Tween.Completed:Wait()
    local Tween = TweenService:Create(HumanoidRootPart,TI2,{
        CFrame = Target,
        AssemblyLinearVelocity = Vector3.zero
    }) Tween:Play() Tween.Completed:Wait() task.wait(1)
    Window:SetValue("BRM5/AntiFall",OldValue)
end
function EnableSwitch(Switch)
    local CameraMod = RequireModule("CameraService")
    if not CameraMod._handler._buttons then return end
    for Index,Switches in pairs(CameraMod._handler._buttons) do
        if Switches._id == Switch then
            Switches:Update()
            Switches:Select()
            CameraMod._switch = Switches
            CameraMod._switch:Activate()
            CameraMod._switch:Unselect()
        end
    end
end
local function AircraftFly(Config,Args)
    if not Config.Enabled then return Args end
    local Camera = Workspace.CurrentCamera
    Args[1]._force.MaxForce = Vector3.new(1, 1, 1) * 40000000
    Args[1]._force.Velocity = InputToVelocity() * Config.Speed
    if Config.Camera then
        Args[1]._gyro.MaxTorque = Vector3.new(1, 1, 1) * 4000
        Args[1]._gyro.CFrame = Camera.CFrame * CFrame.Angles(0,math.pi,0)
    end
end

HookFunction("ControllerClass","LateUpdate",function(Args)
    if Window.Flags["BRM5/WalkSpeed/Enabled"] then
        Args[1].Speed = Window.Flags["BRM5/WalkSpeed/Value"]
    end return Args
end)
HookFunction("MovementService","Mount",function(Args)
    if Window.Flags["BRM5/AntiFall"] then
        if Args[3] == "Skydive" or Args[3] == "Parachute" then
            return
        end
    end return Args
end)
HookFunction("CharacterCamera","Update",function(Args)
    if Window.Flags["BRM5/NoBob"] then
        Args[1]._shakes = {}
        Args[1]._bob = 0
    end
    if Window.Flags["BRM5/Recoil/Enabled"] then
        Args[1]._recoil.Velocity = Args[1]._recoil.Velocity * (Window.Flags["BRM5/Recoil/Value"] / 100)
    end return Args
end)
HookFunction("TurretCamera","Update",function(Args)
    if Window.Flags["BRM5/Recoil/Enabled"] then
        Args[1]._recoil.Velocity = Args[1]._recoil.Velocity * (Window.Flags["BRM5/Recoil/Value"] / 100)
    end return Args
end)
HookFunction("FirearmInventory","new",function(Args)
    if Window.Flags["BRM5/Firemodes"] then
        if not table.find(Args[2].Tune.Firemodes,1) then
            table.insert(Args[2].Tune.Firemodes,1)
        end
        if not table.find(Args[2].Tune.Firemodes,2) then
            table.insert(Args[2].Tune.Firemodes,2)
        end
        if not table.find(Args[2].Tune.Firemodes,3) then
            table.insert(Args[2].Tune.Firemodes,3)
        end
        Args[2].Mode = 1
    end return Args
end)
HookFunction("FirearmInventory","_discharge",function(Args)
    if Window.Flags["BRM5/RapidFire/Enabled"] then
        Args[1]._config.Tune.RPM = Window.Flags["BRM5/RapidFire/Value"]
    end
    if Window.Flags["BRM5/BulletDrop"] then
        Args[1]._config.Tune.Velocity = 1e6
    end PredictedVelocity = Args[1]._config.Tune.Velocity
    return Args
end)
HookFunction("GroundMovement","Update",function(Args)
    if Window.Flags["BRM5/Vehicle/Enabled"] then
        Args[1]._tune.Speed = Window.Flags["BRM5/Vehicle/Speed"]
        Args[1]._tune.Accelerate = Window.Flags["BRM5/Vehicle/Acceleration"]
    end return Args
end)
HookFunction("HelicopterMovement","Update",function(Args)
    if Window.Flags["BRM5/Helicopter/Enabled"] then
        Args[1]._tune.Speed = Window.Flags["BRM5/Helicopter/Speed"]
    end return Args
end)
HookFunction("AircraftMovement","_discharge",function(Args)
    if Window.Flags["BRM5/BulletDrop"] then
        Args[1]._tune.Velocity = 1e6
    end PredictedVelocity = Args[1]._tune.Velocity
    AircraftTip = Args[1]._tip return Args
end)
HookFunction("AircraftMovement","Update",function(Args)
    if Window.Flags["BRM5/Aircraft/Enabled"] then
        --[[Args[1]._speed = 1
        Args[1]._gyro.CFrame = Args[1]._gyro.CFrame * CFrame.Angles(math.rad(-Args[3].Y * Args[4] * 50), 0, math.rad(Args[3].X * Args[4] * 50));
		Args[1]._gyro.MaxTorque = Vector3.new(1, 1, 1) * 4000
        Args[1]._force.MaxForce = Vector3.new(1, 1, 1) * 40000000 * Args[1]._speed 
        Args[1]._force.Velocity = Args[1]._main.CFrame.LookVector * -Window.Flags["BRM5/Aircraft/Speed"]]
        Args[1]._model.RPM.Value = Window.Flags["BRM5/Aircraft/Speed"]
    end Args = AircraftFly({
        Enabled = Window.Flags["BRM5/Aircraft/FlyEnabled"],
        Camera = Window.Flags["BRM5/Aircraft/Camera"],
        Speed = Window.Flags["BRM5/Aircraft/FlySpeed"]
    },Args) return Args
end)
HookFunction("TurretMovement","_discharge",function(Args)
    if Window.Flags["BRM5/BulletDrop"] then
        Args[1]._tune.Velocity = 1e6
    end PredictedVelocity = Args[1]._tune.Velocity
    GroundTip = Args[1]._tip return Args
end)
HookFunction("EnvironmentService","Update",function(Args)
    if Window.Flags["BRM5/Lighting/Enabled"] then
        Args[1]._atmoshperes.Default.Density = Window.Flags["BRM5/Lighting/Fog"]
        if Args[1]._atmoshperes.Desert and Args[1]._atmoshperes.Snow then
            Args[1]._atmoshperes.Desert.Density = Window.Flags["BRM5/Lighting/Fog"]
            Args[1]._atmoshperes.Snow.Density = Window.Flags["BRM5/Lighting/Fog"]
        end
    end return Args
end)
HookSignal(RemoteEvent.OnClientEvent,1,function(Args)
    if Args[1] == "ReplicateNVG" then
        if Window.Flags["BRM5/DisableNVG"] then
            Args[2] = false
        end
        if Window.Flags["BRM5/NVGShape"] then
            Args[3] = ""
        end
    elseif Args[1] == "InitInventory" then
        if Window.Flags["BRM5/AntiFall"]
        and Args[2] == true then return end
    end return Args
end)

task.spawn(function()
    for Index,Table in pairs(getgc(true)) do
        if typeof(Table) == "table"
        and rawget(Table,"FireServer")
        and rawget(Table,"InvokeServer") then
            function Network:FireServer(...)
                Table:FireServer(...)
            end
            function Network:InvokeServer(...)
                Table:InvokeServer(...)
            end
            break
        end
    end
end)
task.spawn(function()
    for Index,Table in pairs(getgc(true)) do
        if typeof(Table) == "table"
        and rawget(Table,"FireServer")
        and rawget(Table,"InvokeServer")  then
            local OldFireServer = Table.FireServer
            --local OldInvokeServer = Table.InvokeServer
            Table.FireServer = function(Self, ...) local Args = {...}
                if checkcaller() then return OldFireServer(Self, ...) end
                if Window.Flags["BRM5/AntiFall"] then
                    if Args[1] == "ReplicateSkydive"
                    and (Args[2] == 3 or Args[2] == 2) then
                        return
                    end
                end
                return OldFireServer(Self, ...)
            end
            --[[Table.FireServer = function(Self, ...)
                local Args = {...}
                if Args[1] ~= "UpdateCharacter" then
                    print("Network:FireServer(" .. FormatTable(Args) .. ")")
                end
                return OldFireServer(Self, ...)
            end
            Table.InvokeServer = function(Self, ...)
                local Args = {...}
                print("Network:InvokeServer(" .. FormatTable(Args) .. ")")
                return OldInvokeServer(Self, ...)
            end]]
        end
    end
end)

local OldNamecall
OldNamecall = hookmetamethod(game,"__namecall",function(Self, ...)
    local Method,Args = getnamecallmethod(),{...}
    if Window.Flags["BRM5/AntiFall"] then
        if Method == "TakeDamage" then return end
    end

    if SilentAim and Method == "Raycast" then
        if math.random(0,100) <= Window.Flags["SilentAim/HitChance"] then
            local Camera = Workspace.CurrentCamera
            if Args[1] == Camera.CFrame.Position then
                Args[2] = SilentAim.Position - Camera.CFrame.Position
            elseif AircraftTip and Args[1] == AircraftTip.WorldCFrame.Position then
                Args[2] = SilentAim.Position - AircraftTip.WorldCFrame.Position
            elseif GroundTip and Args[1] == GroundTip.WorldCFrame.Position then
                Args[2] = SilentAim.Position - GroundTip.WorldCFrame.Position
            end
        end
    end

    return OldNamecall(Self, unpack(Args))
end)

RunService.Heartbeat:Connect(function()
    SilentAim = GetHitbox({
        Enabled = Window.Flags["SilentAim/Enabled"],
        WallCheck = Window.Flags["SilentAim/WallCheck"],
        DynamicFOV = Window.Flags["SilentAim/DynamicFOV"],
        FieldOfView = Window.Flags["SilentAim/FieldOfView"],
        Priority = Window.Flags["SilentAim/Priority"],
        TargetMode = Window.Flags["BRM5/TargetMode"][1],
        TeamCheck = Window.Flags["TeamCheck"]
    })
    if Aimbot then AimAt(
        GetHitbox({
            Enabled = Window.Flags["Aimbot/Enabled"],
            WallCheck = Window.Flags["Aimbot/WallCheck"],
            DynamicFOV = Window.Flags["Aimbot/DynamicFOV"],
            FieldOfView = Window.Flags["Aimbot/FieldOfView"],
            Priority = Window.Flags["Aimbot/Priority"],
            TargetMode = Window.Flags["BRM5/TargetMode"][1],
            TeamCheck = Window.Flags["TeamCheck"]
        }),{
            Prediction = Window.Flags["Aimbot/Prediction"],
            Sensitivity = Window.Flags["Aimbot/Smoothness"] / 100
        })
    end

    if Window.Flags["BRM5/Lighting/Enabled"] then
        Lighting.ClockTime = Window.Flags["BRM5/Lighting/Time"]
    end
end)
RunService.RenderStepped:Connect(function()
    if Window.Flags["BRM5/Lighting/Brightness"] then
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
end)
Matr1x.Utilities.Misc:NewThreadLoop(0,function()
    local Press = Window.Flags["BRM5/Aircraft/Trigger"] and mouse2press or mouse1press
    local Release = Window.Flags["BRM5/Aircraft/Trigger"] and mouse2release or mouse1release

    if not Trigger then return end
    local TriggerHB = GetHitboxWithPrediction({
        Enabled = Window.Flags["Trigger/Enabled"],
        WallCheck = Window.Flags["Trigger/WallCheck"],
        Prediction = {
            Enabled = Window.Flags["Trigger/Prediction/Enabled"],
            Velocity = Window.Flags["Trigger/Prediction/Velocity"]
        },
        DynamicFOV = Window.Flags["Trigger/DynamicFOV"],
        FieldOfView = Window.Flags["Trigger/FieldOfView"],
        Priority = Window.Flags["Trigger/Priority"],
        TargetMode = Window.Flags["BRM5/TargetMode"][1],
        TeamCheck = Window.Flags["TeamCheck"]
    })

    if TriggerHB then Press()
        task.wait(Window.Flags["Trigger/Delay"])
        if Window.Flags["Trigger/HoldMode"] then
            while task.wait() do
                TriggerHB = GetHitboxWithPrediction({
                    Enabled = Window.Flags["Trigger/Enabled"],
                    WallCheck = Window.Flags["Trigger/WallCheck"],
                    Prediction = {
                        Enabled = Window.Flags["Trigger/Prediction/Enabled"],
                        Velocity = Window.Flags["Trigger/Prediction/Velocity"]
                    },
                    DynamicFOV = Window.Flags["Trigger/DynamicFOV"],
                    FieldOfView = Window.Flags["Trigger/FieldOfView"],
                    Priority = Window.Flags["Trigger/Priority"],
                    TargetMode = Window.Flags["BRM5/TargetMode"][1],
                    TeamCheck = Window.Flags["TeamCheck"]
                }) if not TriggerHB or not Trigger then break end
            end
        end Release()
    end
end)

for Index,NPC in pairs(NPCFolder:GetChildren()) do
    Matr1x.Utilities.Drawing:AddESP(NPC,"NPC","ESP/NPC",Window.Flags)
end
NPCFolder.ChildAdded:Connect(function(NPC)
    Matr1x.Utilities.Drawing:AddESP(NPC,"NPC","ESP/NPC",Window.Flags)
end)
NPCFolder.ChildRemoved:Connect(function(NPC)
    Matr1x.Utilities.Drawing:RemoveESP(NPC)
end)

for Index,Player in pairs(PlayerService:GetPlayers()) do
    if Player ~= LocalPlayer then
        Matr1x.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
    end
end
PlayerService.PlayerAdded:Connect(function(Player)
    Matr1x.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    Matr1x.Utilities.Drawing:RemoveESP(Player)
end)
