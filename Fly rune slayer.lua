-- สร้างตัวแปรเพื่อควบคุมสถานะของสคริปต์
local scriptEnabled = false

-- สร้างตัวแปรการบินและสถานะอื่นๆ
local isFlying = false
local isSpaceHeld = false
local isCtrlHeld = false
local currentUpwardVelocity = 0
local currentDownwardVelocity = 0
local speaker = game:GetService("Players").LocalPlayer
local chr = speaker.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

-- ฟังก์ชันการเริ่มต้นใหม่ของสคริปต์เมื่อรีสปาวน์ตัวละคร
local function resetScript()
    isFlying = false
    isSpaceHeld = false
    isCtrlHeld = false
    currentUpwardVelocity = 0
    currentDownwardVelocity = 0
    speaker = game:GetService("Players").LocalPlayer
    chr = speaker.Character
    hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
end

-- ฟังก์ชันสำหรับการอัปเดตสถานะการบิน
local function updateFlyState(enabled)
    isFlying = enabled
    if enabled then
        -- เปิดฟังก์ชันการบิน
        print("Fly Script Enabled.")
        speaker.Character.Animate.Disabled = true
    else
        -- ปิดการบิน
        print("Fly Script Disabled.")
        speaker.Character.Animate.Disabled = false
    end
end

-- ฟังก์ชันสำหรับเปิด/ปิดสคริปต์ทั้งหมด (toggle)
local function toggleScript(state)
    scriptEnabled = state
    if scriptEnabled then
        -- เปิดฟังก์ชันการบิน
        updateFlyState(true)
        -- กำหนดการเชื่อมต่อ Input Events สำหรับการบิน
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent then
                if input.KeyCode == Enum.KeyCode.Z then
                    updateFlyState(not isFlying)  -- สลับสถานะการบิน
                elseif input.KeyCode == Enum.KeyCode.Space and isFlying then
                    isSpaceHeld = true
                elseif input.KeyCode == Enum.KeyCode.LeftControl and isFlying then
                    isCtrlHeld = true
                end
            end
        end)

        -- ตรวจสอบการสิ้นสุดของปุ่ม
        game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent then
                if input.KeyCode == Enum.KeyCode.Space then
                    isSpaceHeld = false
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    isCtrlHeld = false
                end
            end
        end)

        -- ตรวจสอบการเคลื่อนไหวของตัวละครในทุกๆ frame
        game:GetService("RunService").Heartbeat:Connect(function()
            if isFlying then
                if isSpaceHeld then
                    -- เพิ่มความเร็วในการบินขึ้นเมื่อกด Space ค้าง
                    currentUpwardVelocity = math.min(currentUpwardVelocity + 2, 50)  -- จำกัดความเร็วสูงสุดที่ 50
                    if hum and hum.RootPart then
                        hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, currentUpwardVelocity, hum.RootPart.Velocity.Z)
                    end
                elseif isCtrlHeld then
                    -- เพิ่มความเร็วในการบินลงเมื่อกด Left Control ค้าง
                    currentDownwardVelocity = math.min(currentDownwardVelocity + 2, 50)  -- จำกัดความเร็วสูงสุดที่ 50
                    if hum and hum.RootPart then
                        hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, -currentDownwardVelocity, hum.RootPart.Velocity.Z)
                    end
                else
                    -- ถ้าไม่ได้กดปุ่ม Space หรือ Left Control ให้ตั้งค่า Velocity เป็น 0 (Hover)
                    currentUpwardVelocity = 0
                    currentDownwardVelocity = 0
                    if hum and hum.RootPart then
                        hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, 0, hum.RootPart.Velocity.Z)
                    end
                end
            end
        end)
    else
        -- ปิดฟังก์ชันการบิน
        updateFlyState(false)
        -- ลบ event ที่เกี่ยวข้องทั้งหมด
        print("Fly Script Disabled.")
    end
end
