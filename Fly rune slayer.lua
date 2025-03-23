local speeds = 0.1
local maxSpeed = 10
local isFlying = false
local tpwalking = false
local isHovering = false -- เพิ่มตัวแปรสถานะการ Hover
local speaker = game:GetService("Players").LocalPlayer
local chr = speaker.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

local isSpaceHeld = false
local isCtrlHeld = false
local currentUpwardVelocity = 0
local currentDownwardVelocity = 0

-- ตัวแปรสถานะเปิด/ปิดสคริปต์
local scriptEnabled = false

-- ฟังก์ชันการเริ่มต้นใหม่ของสคริปต์เมื่อรีสปาวน์ตัวละคร
local function resetScript()
    -- รีเซ็ตตัวแปร
    isFlying = false
    tpwalking = false
    isHovering = false
    isSpaceHeld = false
    isCtrlHeld = false
    currentUpwardVelocity = 0
    currentDownwardVelocity = 0

    -- ปิด/เปิดการฟังก์ชันต่างๆ อีกครั้ง
    speaker = game:GetService("Players").LocalPlayer
    chr = speaker.Character
    hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
end

-- ฟังก์ชันเปิด/ปิดการบิน
local function updateFlyState(enabled)
    isFlying = enabled
    if enabled then
        for i = 0.1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
        speaker.Character.Animate.Disabled = true
        isHovering = true
    else
        tpwalking = false
        isHovering = false
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    end
end
