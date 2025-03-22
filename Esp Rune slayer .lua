

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- สร้าง shared table ถ้ายังไม่มี
shared.ESP = shared.ESP or {}

-- Settings for Player ESP (now in shared.ESP)
shared.ESP.espEnabledPlayers = false -- เริ่มต้นปิด
shared.ESP.playerFontSize = 16 -- ขนาด Font เริ่มต้น
shared.ESP.playerFont = Enum.Font.SourceSansBold
shared.ESP.playerTextColor = Color3.fromRGB(0, 255, 255) -- สีฟ้าอ่อนสำหรับผู้เล่น
shared.ESP.playerMaxDistance = 10000 -- ระยะ ESP ผู้เล่นเริ่มต้น

-- Settings for Monster ESP (now in shared.ESP)
shared.ESP.espEnabledMonsters = false -- เริ่มต้นปิด
shared.ESP.monsterFontSize = 16 -- ขนาด Font เริ่มต้น
shared.ESP.monsterFont = Enum.Font.ArialBold
shared.ESP.monsterTextColor = Color3.fromRGB(255, 0, 0) -- สีแดงสำหรับมอนสเตอร์
shared.ESP.monsterMaxDistance = 1000 -- ระยะ ESP มอนสเตอร์เริ่มต้น

local function getBaseMonsterName(monsterName)
    local dotPosition = string.find(monsterName, "%.")
    if dotPosition then
        return string.sub(monsterName, 1, dotPosition - 1)
    else
        return monsterName
    end
end

local function createPlayerESP(player)
    if player == LocalPlayer then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")

    if head and rootPart and not head:FindFirstChild("PlayerESP") and shared.ESP.espEnabledPlayers then
        local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance <= shared.ESP.playerMaxDistance then
            local billboardGui = Instance.new("BillboardGui")
            local label = Instance.new("TextLabel")

            billboardGui.Name = "PlayerESP"
            billboardGui.Parent = head
            billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            billboardGui.Active = true
            billboardGui.AlwaysOnTop = true
            billboardGui.LightInfluence = 0
            billboardGui.Size = UDim2.new(0, 150, 0, 20)
            billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

            label.Name = "InfoLabel"
            label.Parent = billboardGui
            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.BackgroundTransparency = 1
            label.BorderColor3 = Color3.fromRGB(0, 0, 0)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Font = shared.ESP.playerFont
            label.TextColor3 = shared.ESP.playerTextColor
            label.TextScaled = true
            label.TextSize = shared.ESP.playerFontSize -- ใช้ขนาด Font จาก shared
            label.TextWrapped = false
            label.TextXAlignment = Enum.TextXAlignment.Center

            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hpText = humanoid and string.format(" HP: %d/%d", humanoid.Health, humanoid.MaxHealth) or " HP: N/A"
            label.Text = player.Name .. hpText .. string.format(" Dist: %.1f", distance)
        end
    end
end

local function removePlayerESP(player)
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local esp = head:FindFirstChild("PlayerESP")
            if esp then
                esp:Destroy()
            end
        end
    end
end

local function updateAllPlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        removePlayerESP(player)
        if shared.ESP.espEnabledPlayers then
            createPlayerESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if shared.ESP.espEnabledPlayers then
        createPlayerESP(player)
    end
end)

Players.PlayerRemoving:Connect(removePlayerESP)

local function updatePlayerInfo(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        local esp = head:FindFirstChild("PlayerESP")
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if esp and rootPart and shared.ESP.espEnabledPlayers then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= shared.ESP.playerMaxDistance then
                local infoLabel = esp:FindFirstChild("InfoLabel")
                if infoLabel then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local hpText = humanoid and string.format(" HP: %d/%d", humanoid.Health, humanoid.MaxHealth) or " HP: N/A"
                    infoLabel.Text = player.Name .. hpText .. string.format(" Dist: %.1f", distance)
                    infoLabel.TextSize = shared.ESP.playerFontSize -- อัปเดตขนาด Font
                end
            else
                removePlayerESP(player)
            end
        elseif esp then
            removePlayerESP(player)
        end
    end
end

-- Monster ESP Functions
local function createMonsterESP(monster)
    if not monster:FindFirstChild("MonsterESP") then
        local billboardGui = Instance.new("BillboardGui")
        local infoLabel = Instance.new("TextLabel")
        local rootPart = monster:FindFirstChild("HumanoidRootPart") or monster:FindFirstChild("Torso")

        if rootPart then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= shared.ESP.monsterMaxDistance then
                billboardGui.Name = "MonsterESP"
                billboardGui.Parent = monster
                billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                billboardGui.Active = true
                billboardGui.AlwaysOnTop = true
                billboardGui.LightInfluence = 0
                billboardGui.Size = UDim2.new(0, 200, 0, 20)
                billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

                infoLabel.Name = "InfoLabel"
                infoLabel.Parent = billboardGui
                infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                infoLabel.BackgroundTransparency = 1
                infoLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                infoLabel.Size = UDim2.new(1, 0, 1, 0)
                infoLabel.Font = shared.ESP.monsterFont
                infoLabel.TextColor3 = shared.ESP.monsterTextColor
                infoLabel.TextScaled = true
                infoLabel.TextSize = shared.ESP.monsterFontSize -- ใช้ขนาด Font จาก shared
                infoLabel.TextWrapped = false
                infoLabel.TextXAlignment = Enum.TextXAlignment.Center

                local baseName = getBaseMonsterName(monster.Name)
                local humanoid = monster:FindFirstChildOfClass("Humanoid")
                local hpText = humanoid and string.format(" HP: %d/%d", humanoid.Health, humanoid.MaxHealth) or " HP: N/A"
                infoLabel.Text = baseName .. hpText .. string.format(" Dist: %.1f", distance)
            end
        end
    end
end

local function removeMonsterESP(monster)
    local esp = monster:FindFirstChild("MonsterESP")
    if esp then
        esp:Destroy()
    end
end

local function updateMonsterInfo(monster)
    local esp = monster:FindFirstChild("MonsterESP")
    if esp then
        local infoLabel = esp:FindFirstChild("InfoLabel")
        local humanoid = monster:FindFirstChildOfClass("Humanoid")
        local rootPart = monster:FindFirstChild("HumanoidRootPart") or monster:FindFirstChild("Torso")

        if infoLabel and rootPart and shared.ESP.espEnabledMonsters then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= shared.ESP.monsterMaxDistance then
                local baseName = getBaseMonsterName(monster.Name)
                local textParts = {}
                table.insert(textParts, baseName)
                local hpText = humanoid and string.format("HP: %d/%d", humanoid.Health, humanoid.MaxHealth) or "HP: N/A"
                table.insert(textParts, hpText)
                table.insert(textParts, string.format("Dist: %.1f", distance))
                infoLabel.Text = table.concat(textParts, " ")
                infoLabel.TextSize = shared.ESP.monsterFontSize -- อัปเดตขนาด Font
            else
                removeMonsterESP(monster)
            end
        elseif esp then
            removeMonsterESP(monster)
        end
    end
end

local function updateAllMonsterESP()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end

    for i, monster in pairs(Workspace.Alive:GetChildren()) do
        local isPlayerName = false
        for _, playerName in pairs(playerNames) do
            if monster.Name == playerName then
                isPlayerName = true
                break
            end
        end

        local rootPart = monster:FindFirstChild("HumanoidRootPart") or monster:FindFirstChild("Torso")
        if shared.ESP.espEnabledMonsters and not isPlayerName and rootPart then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= shared.ESP.monsterMaxDistance then
                if not monster:FindFirstChild("MonsterESP") then
                    createMonsterESP(monster)
                end
                updateMonsterInfo(monster)
            else
                removeMonsterESP(monster)
            end
        else
            removeMonsterESP(monster)
        end
    end
end

Workspace.Alive.ChildAdded:Connect(function(child)
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end

    local isPlayerName = false
    for _, playerName in pairs(playerNames) do
        if child.Name == playerName then
            isPlayerName = true
            break
        end
    end

    local rootPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso")
    if shared.ESP.espEnabledMonsters and not isPlayerName and rootPart then
        local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance <= shared.ESP.monsterMaxDistance then
            createMonsterESP(child)
        end
    end
end)

Workspace.Alive.ChildRemoved:Connect(removeMonsterESP)

-- Function to toggle Player ESP from UI
function shared.ESP:TogglePlayerESP(state)
    shared.ESP.espEnabledPlayers = state
    print("Player ESP Enabled:", shared.ESP.espEnabledPlayers)
    updateAllPlayerESP()
end

-- Function to toggle Monster ESP from UI
function shared.ESP:ToggleMonsterESP(state)
    shared.ESP.espEnabledMonsters = state
    print("Monster ESP Enabled:", shared.ESP.espEnabledMonsters)
    updateAllMonsterESP()
end

-- Function to set Player ESP Distance from UI
function shared.ESP:SetPlayerESPDistance(distance)
    shared.ESP.playerMaxDistance = distance
    print("Player ESP Distance:", shared.ESP.playerMaxDistance)
    updateAllPlayerESP()
end

-- Function to set Monster ESP Distance from UI
function shared.ESP:SetMonsterESPDistance(distance)
    shared.ESP.monsterMaxDistance = distance
    print("Monster ESP Distance:", shared.ESP.monsterMaxDistance)
    updateAllMonsterESP()
end

-- Function to set Player ESP Color from UI
function shared.ESP:SetPlayerESPColor(color)
    shared.ESP.playerTextColor = color
    print("Player ESP Color:", shared.ESP.playerTextColor)
    updateAllPlayerESP()
end

-- Function to set Monster ESP Color from UI
function shared.ESP:SetMonsterESPColor(color)
    shared.ESP.monsterTextColor = color
    print("Monster ESP Color:", shared.ESP.monsterTextColor)
    updateAllMonsterESP()
end

-- Function to set Player ESP Font Size from UI
function shared.ESP:SetPlayerESPFontSize(size)
    shared.ESP.playerFontSize = size
    print("Player ESP Font Size:", shared.ESP.playerFontSize)
    updateAllPlayerESP()
end

-- Function to set Monster ESP Font Size from UI
function shared.ESP:SetMonsterESPFontSize(size)
    shared.ESP.monsterFontSize = size
    print("Monster ESP Font Size:", shared.ESP.monsterFontSize)
    updateAllMonsterESP()
end

-- Continuous update
RunService.Heartbeat:Connect(function()
    if shared.ESP.espEnabledPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updatePlayerInfo(player)
            end
        end
    end
    if shared.ESP.espEnabledMonsters then
        updateAllMonsterESP()
    end
end)

-- Initial ESP setup (disabled by default)
updateAllPlayerESP()
updateAllMonsterESP()