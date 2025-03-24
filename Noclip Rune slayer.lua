local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local speaker = game.Players.LocalPlayer
local Clip = true
local Noclipping

-- Function to start noclip
local function StartNC()
    Clip = false
    local function NoclipLoop()
        if Clip == false and speaker.Character ~= nil then
            for _, child in pairs(speaker.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true then
                    child.CanCollide = false
                end
            end
        end
    end
    Noclipping = RunService.Stepped:Connect(NoclipLoop)
end

-- Function to stop noclip
local function StopNC()
    if Noclipping then
        Noclipping:Disconnect()
        Clip = true
    end
end

-- Function to toggle noclip when pressing N
local function ToggleNoclip(input)
    if input.KeyCode == Enum.KeyCode.N then
        if Clip then
            StartNC()
        else
            StopNC()
        end
    end
end

-- Listen for keypresses
UserInputService.InputBegan:Connect(ToggleNoclip)
