local speeds = 1.5
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

-- ฟังก์ชันหลักในการเปิด/ปิดสคริปต์ทั้งหมด
local function toggleScript(state)
    if state then
        -- เปิดสคริปต์
        scriptEnabled = true
        updateFlyState(true)
        print("Fly script enabled")
    else
        -- ปิดสคริปต์และลบ
        scriptEnabled = false
        updateFlyState(false)
        print("Fly script disabled")
        
        -- ทำลายทุกอย่างที่เกี่ยวข้องกับสคริปต์นี้
        speaker.Character:FindFirstChild("Humanoid").StateChanged:Disconnect()  -- Disconnect event ที่เกี่ยวข้อง
        game:GetService("RunService").Heartbeat:Disconnect()  -- Disconnect Heartbeat event
        game:GetService("UserInputService").InputBegan:Disconnect()  -- Disconnect InputBegan event
        game:GetService("UserInputService").InputEnded:Disconnect()  -- Disconnect InputEnded event
    end
end

-- ฟังก์ชันที่เชื่อมต่อกับ InputBegan และ InputEnded เพื่อรับข้อมูลจากผู้เล่น
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Z then
            -- เมื่อกด Z ให้ toggle การบิน
            toggleScript(not scriptEnabled)
        elseif input.KeyCode == Enum.KeyCode.Space and isFlying then
            isSpaceHeld = true
            isHovering = false
        elseif input.KeyCode == Enum.KeyCode.LeftControl and isFlying then
            isCtrlHeld = true
            isHovering = false
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Space then
            isSpaceHeld = false
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            isCtrlHeld = false
        end
    end
end)

-- ฟังก์ชันในการคำนวณความเร็วการบินตามที่กดปุ่ม
game:GetService("RunService").Heartbeat:Connect(function()
    if isFlying then
        if isSpaceHeld then
            currentUpwardVelocity = math.min(currentUpwardVelocity + 2, 150)  -- จำกัดความเร็วสูงสุดที่ 50
            if hum and hum.RootPart then
                hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, currentUpwardVelocity, hum.RootPart.Velocity.Z)
            end
        elseif isCtrlHeld then
            currentDownwardVelocity = math.min(currentDownwardVelocity + 2, 150)  -- จำกัดความเร็วสูงสุดที่ 50
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

-- ตรวจสอบเมื่อ Character ถูกสร้างใหม่และรีเซ็ตสคริปต์
speaker.CharacterAdded:Connect(function()
    wait(1)  -- รอให้ Character ใหม่ถูกสร้างเสร็จ
    resetScript()
end)
