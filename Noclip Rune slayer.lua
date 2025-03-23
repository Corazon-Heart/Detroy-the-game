[[
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

    local function initializeNoClip(toggleCallback, keybindCallback)
        if localPlayer.Character then
            onCharacterAdded(localPlayer.Character)
        end
        localPlayer.CharacterAdded:Connect(onCharacterAdded)

        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            if input.KeyCode == noClipToggleKey then
                isNoClipping = not isNoClipping
                setNoClip(isNoClipping)
                toggleCallback(isNoClipping)
            end
        end)

        return function(state) -- ฟังก์ชันสำหรับตั้งค่าสถานะจาก UI
            isNoClipping = state
            setNoClip(isNoClipping)
        end, function(keyName) -- ฟังก์ชันสำหรับเปลี่ยน Keybind จาก UI
            local newKey = Enum.KeyCode[keyName:upper()]
            if newKey then
                noClipToggleKey = newKey
            else
                warn("Invalid Key for No-Clip:", keyName)
            end
        end
    end

    return initializeNoClip
]]
