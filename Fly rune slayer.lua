-- สร้างตัวแปรเพื่อควบคุมสถานะของสคริปต์
local scriptEnabled = false
local isFlying = false
local tpwalking = false
local isHovering = false
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
    tpwalking = false
    isHovering = false
    isSpaceHeld = false
    isCtrlHeld = false
    currentUpwardVelocity = 0
    currentDownwardVelocity = 0
    speaker = game:GetService("Players").LocalPlayer
    chr = speaker.Character
    hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
end

-- ฟังก์ชันสำหรับการอัปเดตสถานะของการบิน
local function updateFlyState(enabled)
    isFlying = enabled
    if enabled then
        for i = 0.1, 10 do
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
        isHovering = true
    else
        tpwalking = false
        isHovering = false
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    end
end

-- ฟังก์ชันสำหรับเปิด/ปิดสคริปต์ทั้งหมด
local function toggleScript(state)
    scriptEnabled = state
    if scriptEnabled then
        -- เปิดฟังก์ชันการบินและการควบคุมการบิน
        updateFlyState(true)
        -- เพิ่ม event ฟังก์ชันต่างๆ ที่เกี่ยวข้องกับการบิน
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent then
                if input.KeyCode == Enum.KeyCode.Z then
                    updateFlyState(not isFlying)
                    if not isFlying then
                        isHovering = false
                    end
                elseif input.KeyCode == Enum.KeyCode.Space and isFlying then
                    isSpaceHeld = true
                    isHovering = false
                elseif input.KeyCode == Enum.KeyCode.LeftControl and isFlying then
                    isCtrlHeld = true
                    isHovering = false
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

        -- ตรวจสอบตำแหน่งการเคลื่อนไหวในทุกๆ frame
        game:GetService("RunService").Heartbeat:Connect(function()
            if isFlying then
                if isSpaceHeld then
                    currentUpwardVelocity = math.min(currentUpwardVelocity + 2, 50)
                    if hum and hum.RootPart then
                        hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, currentUpwardVelocity, hum.RootPart.Velocity.Z)
                    end
                elseif isCtrlHeld then
                    currentDownwardVelocity = math.min(currentDownwardVelocity + 2, 50)
                    if hum and hum.RootPart then
                        hum.RootPart.Velocity = Vector3.new(hum.RootPart.Velocity.X, -currentDownwardVelocity, hum.RootPart.Velocity.Z)
                    end
                else
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
    end
end

-- สร้าง Toggle UI สำหรับเปิด/ปิด Fly Script
Section:createToggle({
    text = "Enable Fly",
    state = false,  -- ตั้งค่าเริ่มต้นเป็น OFF
    callback = function(state)
        toggleScript(state)  -- เรียกใช้ฟังก์ชัน toggleScript เพื่อเปิด/ปิด Fly Script
    end
})

-- สร้าง Keybind UI สำหรับเปิด/ปิด Fly Script
Section:createKeybind({
    text = "Fly (Press Z)",
    default = "Z",
    callback = function()
        toggleScript(not scriptEnabled)  -- เปลี่ยนสถานะของ Toggle
    end
})
