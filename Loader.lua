repeat task.wait() until game.GameId ~= 0
if Matr1x and Matr1x.Loaded then
    Matr1x.Utilities.UI:Notification({
        Title = "Matr1x Hub",
        Description = "Script already executed!",
        Duration = 5
    })
    return
end

getgenv().Matr1x = {Loaded = false,Debug = false,Current = "Loader",Utilities = {}}
Matr1x.Utilities.Misc = Matr1x.Debug and loadfile("Matr1xHub/Utilities/Misc.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Utilities/Misc.lua"))()
Matr1x.Utilities.UI = Matr1x.Debug and loadfile("Matr1xHub/Utilities/UI.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Utilities/UI.lua"))()
Matr1x.Utilities.Drawing = Matr1x.Debug and loadfile("Matr1xHub/Utilities/Drawing.lua")()
or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Utilities/Drawing.lua"))()

Matr1x.Games = {
    ["1054526971"] = {
        Name = "Blackhawk Rescue Mission 5",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/BRM5.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/BRM5.lua")
    },
    ["580765040"] = {
        Name = "RAGDOLL UNIVERSE",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/RU.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/RU.lua")
    },
    ["1168263273"] = {
        Name = "Bad Business",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/BB.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/BB.lua")
    },
    ["807930589"] = {
        Name = "The Wild West",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/TWW.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/TWW.lua")
    },
    ["187796008"] = {
        Name = "Those Who Remain",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/TWR.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/TWR.lua")
    },
    ["1586272220"] = {
        Name = "Steel Titans",
        Script = Matr1x.Debug and readfile("Matr1xHub/Games/ST.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Games/ST.lua")
    }
}

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local function IfGameSupported()
    for Id, Info in pairs(Matr1x.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end
end

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
        QueueOnTeleport(Matr1x.Debug and readfile("Matr1xHub/Loader.lua")
        or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Loader.lua"))
    end
end)

local SupportedGame = IfGameSupported()
if SupportedGame then
    Matr1x.Current = SupportedGame.Name
    loadstring(SupportedGame.Script)()
    Matr1x.Utilities.UI:Notification({
        Title = "Matr1x Hub",
        Description = Matr1x.Current .. " loaded!",
        Duration = 5
    }) Matr1x.Loaded = true
else
    Matr1x.Current = "Universal"
    loadstring(Matr1x.Debug and readfile("Matr1xHub/Universal.lua")
    or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/Universal.lua"))()
    Matr1x.Utilities.UI:Notification({
        Title = "Matr1x Hub",
        Description = Matr1x.Current .. " loaded!",
        Duration = 5
    }) Matr1x.Loaded = true
end
