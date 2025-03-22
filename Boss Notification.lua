local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Boss names to track (ต้องตรงกับ UI Script)
local bossNamesToTrack = {"Rune Golem", "Slime King", "Elder Treant"}

-- Get the BossStatus UI elements from the UI Script
local BossUI = require(game:GetService("StarterGui"):WaitForChild("YourUIScriptName")).BossStatus
-- **สำคัญ:** เปลี่ยน "YourUIScriptName" เป็นชื่อ LocalScript ที่คุณวางโค้ด UI Leny ไว้

-- Get the Leny Library
local shared = shared or {}
local Library = shared.LenyLibrary

local function isBossPresent(bossName)
    local aliveFolder = Workspace:FindFirstChild("Alive")
    if aliveFolder then
        for _, instance in pairs(aliveFolder:GetChildren()) do
            if string.find(instance.Name, "^" .. bossName .. "%.") then
                return true
            end
        end
    end
    return false
end

-- Check for bosses periodically and update UI
RunService.Heartbeat:Connect(function()
    for _, bossName in ipairs(bossNamesToTrack) do
        local isPresent = isBossPresent(bossName)

        if BossUI and BossUI[bossName] then
            if isPresent then
                BossUI[bossName]:updateText({ text = "✔" })
                -- Send Leny Notification when boss spawns
                if Library and Library.notify and not bossNotified[bossName] then
                    Library:notify({
                        title = "Boss Spawned!",
                        text = bossName .. " has appeared!",
                        duration = 10, -- Show for 10 seconds
                        position = "topLeft", -- Try to position at top-left (may depend on Leny implementation)
                        sizeX = 200, -- Adjust size if needed
                        sizeY = 50,
                    })
                    bossNotified[bossName] = true
                end
            else
                BossUI[bossName]:updateText({ text = "" })
                bossNotified[bossName] = nil -- Reset notification status when boss is gone
            end
        end
    end
end)