return function(setNoClipStateCallback, setNoClipKeybindCallback)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local localPlayer = Players.LocalPlayer
    local character
    local humanoid
    local isNoClipping = false
    local noClipToggleKey = Enum.KeyCode.N

    local function setNoClip(enabled)
        if not character then return end
        isNoClipping = enabled
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = not enabled
            end
        end
    end

    local function onCharacterAdded(char)
        character = char
        humanoid = char:WaitForChild("Humanoid")
        setNoClip(isNoClipping)

        humanoid.StateChanged:Connect(function(oldState, newState)
            if isNoClipping and (newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall or newState == Enum.HumanoidStateType.Landed) then
                setNoClip(true)
            end
        end)
    end

    if localPlayer.Character then
        onCharacterAdded(localPlayer.Character)
    end
    localPlayer.CharacterAdded:Connect(onCharacterAdded)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == noClipToggleKey then
            isNoClipping = not isNoClipping
            setNoClip(isNoClipping)
            if setNoClipStateCallback then
                setNoClipStateCallback(isNoClipping) -- Call the external callback for UI toggle
            end
        end
    end)

    -- ฟังก์ชันสำหรับตั้งค่าสถานะจาก UI (เรียกผ่าน Callback ที่ส่งมา)
    local function externalSetNoClipState(state)
        isNoClipping = state
        setNoClip(isNoClipping)
    end

    -- ฟังก์ชันสำหรับเปลี่ยน Keybind จาก UI (เรียกผ่าน Callback ที่ส่งมา)
    local function externalSetNoClipKeybind(keyName)
        local newKey = Enum.KeyCode[keyName:upper()]
        if newKey then
            noClipToggleKey = newKey
        else
            warn("Invalid Key for No-Clip:", keyName)
        end
    end

    -- เรียก Callback ที่ส่งมาเพื่อส่งคืนฟังก์ชันควบคุมไปยัง Script หลัก
    if setNoClipStateCallback then
        setNoClipStateCallback(externalSetNoClipState)
    end
    if setNoClipKeybindCallback then
        setNoClipKeybindCallback(externalSetNoClipKeybind)
    end
end
