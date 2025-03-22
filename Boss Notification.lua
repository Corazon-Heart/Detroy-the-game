local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Boss names to track
local bossNamesToTrack = {"Rune Golem", "Slime King", "Elder Treant","Dire Bear"}

-- Table to store the presence status of each boss
local bossPresentStatus = {}

local function isBossPresent(bossName)
    local aliveFolder = Workspace:FindFirstChild("Alive")
    if aliveFolder then
        for _, instance in pairs(aliveFolder:GetChildren()) do
            -- Check if the instance name starts with the specified boss name
            -- and has a dot followed by 4 digits at the end
            if string.match(instance.Name, "^" .. bossName .. "%.%d%d%d%d$") then
                return true
            end
        end
    end
    return false
end

-- Check for bosses periodically
RunService.Heartbeat:Connect(function()
    for _, bossName in ipairs(bossNamesToTrack) do
        local isPresent = isBossPresent(bossName)

        if isPresent then
            if not bossPresentStatus[bossName] then
                print("Boss found: " .. bossName) -- Optional: Print to console when boss is found
                bossPresentStatus[bossName] = true
                -- You can add your callback function here if needed
                if shared.BossFoundCallback then
                    shared.BossFoundCallback(bossName)
                end
            end
        else
            if bossPresentStatus[bossName] then
                print("Boss lost: " .. bossName) -- Optional: Print to console when boss is lost
                bossPresentStatus[bossName] = nil
                -- You can add your callback function here if needed
                if shared.BossLostCallback then
                    shared.BossLostCallback(bossName)
                end
            end
        end
    end
end)
