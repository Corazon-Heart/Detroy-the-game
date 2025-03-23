
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character
    local humanoid
    local isNoFallEnabled = false
    local isJumping = false
    local freefallStartTime = nil
    local noFallDelay = 0.1 -- ระยะเวลา (วินาที) ที่ต้องอยู่ในสถานะ Freefall หลังกระโดดก่อน No Fall ทำงาน
    local heartbeatConnection
    local stateChangedConnection
    local characterAddedConnection

    local function applyNoFall()
        if not humanoid or not isNoFallEnabled then return end

        local function onStateChanged(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping then
                isJumping = true
                freefallStartTime = nil
            elseif newState == Enum.HumanoidStateType.Freefall then
                if isJumping and not freefallStartTime then
                    freefallStartTime = tick()
                elseif not isJumping then
                    -- กรณีตกจากที่สูงโดยไม่ได้กระโดด (ทำงานทันที)
                    humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                end
            elseif newState == Enum.HumanoidStateType.Landed then
                isJumping = false
                freefallStartTime = nil
            end
        end

        local function onHeartbeat(deltaTime)
            if isJumping and freefallStartTime and tick() - freefallStartTime >= noFallDelay then
                -- ผ่านไประยะเวลา noFallDelay หลังกระโดดและยังไม่ถึงพื้น
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                freefallStartTime = nil -- ป้องกันการทำงานซ้ำ
                isJumping = false -- ถือว่าลงพื้นแล้ว
            end
        end

        stateChangedConnection = humanoid.StateChanged:Connect(onStateChanged)
        heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
    end

    local function disableNoFall()
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        if stateChangedConnection then
            stateChangedConnection:Disconnect()
            stateChangedConnection = nil
        end
        isJumping = false
        freefallStartTime = nil
    end

    local function onCharacterAdded(char)
        character = char
        humanoid = char:WaitForChild("Humanoid")
        if isNoFallEnabled then
            applyNoFall()
        else
            disableNoFall()
        end
    end

    local function toggleNoFall(enabled)
        isNoFallEnabled = enabled
        if character and humanoid then
            if isNoFallEnabled then
                applyNoFall()
            else
                disableNoFall()
            end
        end
        
        end


    if localPlayer.Character then
        onCharacterAdded(localPlayer.Character)
    end
    characterAddedConnection = localPlayer.CharacterAdded:Connect(onCharacterAdded)

    print("No Fall Module Loaded for", localPlayer.Name)
