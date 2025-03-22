local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Boss names to track (no need for random numbers)
local bossNamesToTrack = {"Rune Golem", "Slime King", "Elder Treant","Dire Bear"}

-- Notification title
local notificationTitle = "Boss Alert!"

-- Table to store the notification status of each boss type
local bossNotified = {}

local function isBossPresent(bossName)
    local aliveFolder = Workspace:FindFirstChild("Alive")
    if aliveFolder then
        for _, instance in pairs(aliveFolder:GetChildren()) do
            -- Check if the instance name starts with the specified boss name
            if string.find(instance.Name, "^" .. bossName .. "%.") then
                return true
            end
        end
    end
    return false
end

local function sendNotification(bossName)
    game.StarterGui:SetCore("SendNotification", {
        Title = notificationTitle;
        Text = "Found " .. bossName .. "!",
        Duration = 9999; -- Set a high duration to keep it displayed
    })
end

-- Check for bosses periodically
RunService.Heartbeat:Connect(function()
    for _, bossName in ipairs(bossNamesToTrack) do
        local isPresent = isBossPresent(bossName)

        if isPresent then
            if not bossNotified[bossName] then
                sendNotification(bossName)
                bossNotified[bossName] = true
            end
        else
            -- If the boss is gone, clear the notification status to allow for future alerts
            bossNotified[bossName] = nil
        end
    end
end)
