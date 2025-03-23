local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local bossNamesToTrack = {"Rune Golem", "Slime King", "Elder Treant", "Dire Bear","Vangar","Razor Fang"}
local bossPresentStatus = {}
local bossCheckEnabled = false
local bossCheckConnection
local bossNotificationId = nil -- Store the ID of the boss notification

local function isBossPresent(bossName)
    local aliveFolder = Workspace:FindFirstChild("Alive")
    if aliveFolder then
        for _, instance in pairs(aliveFolder:GetChildren()) do
            -- เปลี่ยนเป็นตรวจสอบว่าลงท้ายด้วยจุดแล้วตามด้วยตัวเลขอย่างน้อย 1 หลัก
            if string.match(instance.Name, "^" .. bossName .. "%.%d+$") then
                return true
            end
        end
    end
    return false
end

local function updateBossNotification()
    local presentBosses = {}
    for bossName, isPresent in pairs(bossPresentStatus) do
        if isPresent then
            table.insert(presentBosses, bossName)
        end
    end

    local notificationText = table.concat(presentBosses, "\n")

    if #presentBosses > 0 then
        if bossNotificationId == nil then
            bossNotificationId = Library:notify({
                title = "Boss Alert!",
                text = notificationText,
                maxSizeX = 300,
                scaleX = 0.165,
                sizeY = 200,
                duration = 10, -- กำหนด duration สูงๆ เพื่อให้แสดงจนกว่าจะถูกปิด
            })
        else
            Library:updateNotification(bossNotificationId, {text = notificationText})
        end
    else
        if bossNotificationId then
            Library:closeNotification(bossNotificationId)
            bossNotificationId = nil
        end
    end
end

local function checkBosses()
    local currentPresentBosses = {}
    for _, bossName in ipairs(bossNamesToTrack) do
        if isBossPresent(bossName) then
            currentPresentBosses[bossName] = true
            if not bossPresentStatus[bossName] then
                print("Boss found: " .. bossName)
                bossPresentStatus[bossName] = true
                updateBossNotification()
                if shared.BossFoundCallback then
                    shared.BossFoundCallback(bossName)
                end
            end
        else
            if bossPresentStatus[bossName] then
                print("Boss lost: " .. bossName)
                bossPresentStatus[bossName] = nil
                updateBossNotification()
                if shared.BossLostCallback then
                    shared.BossLostCallback(bossName)
                end
            end
        end
    end

    -- ตรวจสอบว่ามีบอสใหม่เกิดซ้อนหรือไม่
    local numberOfPresentBosses = 0
    for _ in pairs(currentPresentBosses) do
        numberOfPresentBosses = numberOfPresentBosses + 1
    end

    local previousNumberOfPresentBosses = 0
    for _ in pairs(bossPresentStatus) do
        previousNumberOfPresentBosses = previousNumberOfPresentBosses + 1
    end

    if numberOfPresentBosses > 0 and numberOfPresentBosses ~= previousNumberOfPresentBosses and bossNotificationId then
        Library:closeNotification(bossNotificationId)
        bossNotificationId = nil
        updateBossNotification() -- สร้าง Notification ใหม่
    end
end

local function toggleBossCheck(state)
    bossCheckEnabled = state
    if state then
        if not bossCheckConnection then
            bossCheckConnection = RunService.Heartbeat:Connect(checkBosses)
            print("Boss check enabled.")
            updateBossNotification() -- Initial check and notification
        end
    else
        if bossCheckConnection then
            bossCheckConnection:Disconnect()
            bossCheckConnection = nil
            bossPresentStatus = {} -- Reset status when disabled
            if bossNotificationId then
                Library:closeNotification(bossNotificationId)
                bossNotificationId = nil
            end
            print("Boss check disabled.")
        end
    end
end
