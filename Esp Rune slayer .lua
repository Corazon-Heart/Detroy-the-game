-- คอนเน็คชันหลักที่คอยอัปเดตข้อมูล ESP สำหรับผู้เล่นและมอนสเตอร์ในแต่ละเฟรม
RunService.Heartbeat:Connect(function()
    -- อัปเดตข้อมูล ESP ของผู้เล่น
    if shared.ESP.espEnabledPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updatePlayerInfo(player)  -- อัปเดตข้อมูลของผู้เล่น
            end
        end
    end

    -- อัปเดตข้อมูล ESP ของมอนสเตอร์
    if shared.ESP.espEnabledMonsters then
        updateAllMonsterESP()  -- อัปเดตข้อมูลของมอนสเตอร์
    end
end)

-- ฟังก์ชันในการอัปเดตข้อมูลของ Player ESP
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

-- ฟังก์ชันในการอัปเดตข้อมูลของ Monster ESP
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

-- ฟังก์ชันสำหรับการอัปเดต Monster ESP ทั้งหมดในเกม
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
