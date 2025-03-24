local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local isInstantKillEnabled = false
local checkedMobs = {} -- Track checked mobs globally across all iterations
local CHECK_FREQUENCY = 0.5  -- Check every 0.5 seconds instead of every frame

local function performInstantKill()
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local radius = 200
    local damagePercentage = 0.1 -- 10%

    if not localPlayer or not character or not humanoidRootPart then
        return -- Exit if essential player components are missing
    end

    local playerPosition = humanoidRootPart.Position

    -- Loop through all entities in the workspace
    for _, entity in pairs(Workspace.Alive:GetChildren()) do
        -- Skip if already checked
        if checkedMobs[entity] then continue end
        checkedMobs[entity] = true -- Mark mob as checked

        local humanoid = entity:FindFirstChildOfClass("Humanoid")
        local rootPart = entity:FindFirstChild("HumanoidRootPart")

        -- Make sure it's not a player and it has a humanoid and root part
        local isPlayer = Players:GetPlayerFromCharacter(entity) ~= nil

        if humanoid and rootPart and not isPlayer and humanoid.Health > 0 then
            local distance = (playerPosition - rootPart.Position).Magnitude
            if distance <= radius then
                local maxHealth = humanoid.MaxHealth
                local currentHealth = humanoid.Health
                local healthLostPercentage = (maxHealth - currentHealth) / maxHealth

                if healthLostPercentage >= damagePercentage then
                    humanoid.Health = 0
                    -- print("Mob: " .. entity.Name .. " ถูกทำให้ตายเนื่องจาก HP ลดลง 10% ในรัศมี.")
                end
            end
        end
    end
end

local function ToggleInstantKill(state)
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end

    isInstantKillEnabled = state
    if isInstantKillEnabled then
        print("Turn on Instant Kill")
        
        -- Coroutine for running the instant kill loop
        coroutine.wrap(function()
            while isInstantKillEnabled and localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") do
                performInstantKill()
                task.wait(CHECK_FREQUENCY) -- Wait for a set period before checking again
            end
            print("Turn off Instant Kill") -- Output when the loop is turned off
        end)()
    else
        print("Turn off Instant Kill")
        -- Reset checked mobs when instant kill is disabled
        checkedMobs = {} -- Clear checked mobs so the next time the toggle is enabled it starts fresh
    end
end

-- Automatically turn on Instant Kill when the script runs
