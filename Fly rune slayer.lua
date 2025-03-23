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
        -- เปิด Hover เมื่อเริ่มบิน
        isHovering = true -- เปิด Hover เมื่อเริ่มบิน
    else
        tpwalking = false
        -- ปิด Hover เมื่อไม่ได้บิน
        isHovering = false
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Z then
            updateFlyState(not isFlying)
            -- ปิด Hover เมื่อเปิด/ปิด Fly (เป็นการตั้งค่าใหม่ทั้งหมด)
            if not isFlying then
                isHovering = false
            end
        elseif input.KeyCode == Enum.KeyCode.Space and isFlying then
            isSpaceHeld = true
            isHovering = false  -- ปิด hover เมื่อเริ่มบินขึ้น
        elseif input.KeyCode == Enum.KeyCode.LeftControl and isFlying then
            isCtrlHeld = true
            isHovering = false  -- ปิด hover เมื่อเริ่มบินลง
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

-- ตรวจสอบว่าเมื่อไหร่ตัวละครใหม่ถูกสร้าง และรีเซ็ตสคริปต์
speaker.CharacterAdded:Connect(function()
    -- เมื่อ Character ถูกสร้างใหม่ รีเซ็ตสคริปต์
    wait(1)  -- รอให้ Character ใหม่ถูกสร้างเสร็จ
    resetScript()
end)
