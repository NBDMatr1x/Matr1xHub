repeat task.wait() until game.GameId ~= 0
if Matr1x and Matr1x.Loaded then
    Matr1x.Utilities.UI:Notification({
        Title = "Matr1x Hub",
        Description = "Script already executed!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local function GetSupportedGame() local Game
    for Id,Info in pairs(Matr1x.Games) do
        if tostring(game.GameId) == Id then
            Game = Info break
        end
    end if not Game then
        Game = Matr1x.Games.Universal
    end return Game
end

local function GetScript(Script)
    return Matr1x.Debug and readfile("Matr1x/" .. Script .. ".lua")
    or game:HttpGetAsync("https://raw.githubusercontent.com/AlexR32/Matr1x/main/" .. Script .. ".lua")
end

local function LoadScript(Script)
    return loadstring(Matr1x.Debug and readfile("Matr1x/" .. Script .. ".lua")
    or game:HttpGetAsync("https://raw.githubusercontent.com/NBDMatr1x/Matr1xHub/main/" .. Script .. ".lua"))()
end

getgenv().Matr1x = {
    Loaded = false,
    Debug = false,
    Utilities = {},
    Games = {
        ["Universal"] = {
            Name = "Universal",
            Script = "Universal"
        },
        ["1054526971"] = {
            Name = "Blackhawk Rescue Mission 5",
            Script = "Games/BRM5"
        },
        ["580765040"] = {
            Name = "RAGDOLL UNIVERSE",
            Script = "Games/RU"
        },
        ["1168263273"] = {
            Name = "Bad Business",
            Script = "Games/BB"
        },
        ["807930589"] = {
            Name = "The Wild West",
            Script = "Games/TWW"
        },
        ["187796008"] = {
            Name = "Those Who Remain",
            Script = "Games/TWR"
        },
        ["1586272220"] = {
            Name = "Steel Titans",
            Script = "Games/ST"
        },
        ["358276974"] = {
            Name = "Apocalypse Rising 2",
            Script = "Games/AR2"
        }
    }
}

Matr1x.Utilities.Misc = LoadScript("Utilities/Misc")
Matr1x.Utilities.UI = LoadScript("Utilities/UI")
Matr1x.Utilities.Drawing = LoadScript("Utilities/Drawing")

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
        QueueOnTeleport(GetScript("Loader"))
    end
end)

local SupportedGame = GetSupportedGame()
if SupportedGame then
    Matr1x.Game = SupportedGame.Name
    LoadScript(SupportedGame.Script)
    Matr1x.Utilities.UI:Notification({
        Title = "Matr1x Hub",
        Description = Matr1x.Game .. " loaded!",
        Duration = 5
    }) Matr1x.Loaded = true
end
