local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- **สมมติว่าคุณได้ require หรือ loadstring Library Leny ไว้แล้ว**
-- แทนที่ ... ด้วย path หรือ code ของ Library Leny ของคุณ
local Library = require(...) -- หรือ local Library = loadstring(...)()

-- Boss names to track
local bossNamesToTrack = {"Rune Golem", "Slime King", "Elder Treant", "Dire Bear"}

-- Notification title (อาจจะไม่จำเป็นถ้า Leny กำหนดได้)
local notificationTitle = "Boss Alert!"

-- Table to store the notification status of each boss type
local bossNotified = {}

-- Key for the toggle setting in UserSettings
local notifyToggleKey = "BossNotifyEnabled"

-- Variable to store the notification toggle state
local notifyEnabled = UserSettings():GetSetting(notifyToggleKey) ~= false -- Default to true

-- Function to send notification using Leny Library
local function sendLenyNotification(bossName)
    if notifyEnabled and Library and Library.Notification then
        Library.Notification({
            Title = notificationTitle,
            Text = "พบ: " .. bossName .. " เกิดแล้ว!",
            Duration = 5 -- ระยะเวลาแสดงผล (วินาที)
        })
    end
end

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

-- Function to toggle the notification system
local function toggleNotify()
    notifyEnabled = not notifyEnabled
    UserSettings():SetSetting(notifyToggleKey, notifyEnabled)
    -- คุณอาจจะเพิ่ม Feedback UI ตรงนี้ เช่น แสดงข้อความว่าเปิด/ปิด Notify แล้ว
end

-- Bind a key to toggle the notification (example: N key)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.N then
        toggleNotify()
    end
end)

-- Check for bosses periodically
RunService.Heartbeat:Connect(function()
    if notifyEnabled then
        for _, bossName in ipairs(bossNamesToTrack) do
            local isPresent = isBossPresent(bossName)

            if isPresent then
                if not bossNotified[bossName] then
                    sendLenyNotification(bossName)
                    bossNotified[bossName] = true
                end
            else
                bossNotified[bossName] = nil
            end
        end
    end
