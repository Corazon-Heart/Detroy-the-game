local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local isInstantKillEnabled = false
local heartbeatConnection
local CHECK_FREQUENCY = 0.5  -- Check every 0.5 seconds instead of every frame

local function performInstantKill()
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local radius = 200
    local damagePercentage = 0.1 -- 10%
    local checkedMobs = {} -- Keep track of checked mobs in this iteration

    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return -- Exit if essential player components are missing
    end
    local playerPosition = localPlayer.Character.HumanoidRootPart.Position

    for _, entity in pairs(Workspace.Alive:GetChildren()) do
        if checkedMobs[entity] then continue end  -- Skip if already checked
        checkedMobs[entity] = true                -- Mark as checked

        local humanoid = entity:FindFirstChildOfClass("Humanoid")
        local rootPart = entity:FindFirstChild("HumanoidRootPart")

        -- ตรวจสอบว่าเป็น Mob (มี Humanoid และไม่ใช่ Player Character)
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
        coroutine.wrap(function()
            while isInstantKillEnabled and localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") do
                performInstantKill()
                task.wait(CHECK_FREQUENCY)
            end
            if not isInstantKillEnabled then
                print("Turn on Instant Kill")
            end
        end)()
    else
        print("Turn off Instant Kill")
        -- ไม่จำเป็นต้อง disconnect heartbeatConnection ใน coroutine นี้
        -- เพราะ loop จะหยุดเองเมื่อ isInstantKillEnabled เป็น false
    end
end

return ToggleInstantKill