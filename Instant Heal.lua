local A = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game.Players.LocalPlayer.Character.Humanoid.Health = 0
local VirtualInputManager = game:GetService("VirtualInputManager")
game.Players.LocalPlayer.PlayerGui.InfoOverlays:WaitForChild"ConfirmFrame"
game.Players.LocalPlayer.PlayerGui.InfoOverlays:WaitForChild"ConfirmFrame":WaitForChild"MainFrame"
game.Players.LocalPlayer.PlayerGui.InfoOverlays:WaitForChild"ConfirmFrame":WaitForChild"MainFrame":WaitForChild"ButtonFrame"
game.Players.LocalPlayer.PlayerGui.InfoOverlays:WaitForChild"ConfirmFrame":WaitForChild"MainFrame":WaitForChild"ButtonFrame":WaitForChild"ConfirmButton"
wait()
local player = game:GetService("Players").LocalPlayer
repeat
	if player.PlayerGui.InfoOverlays:FindFirstChild("ConfirmFrame") then
		local button = player.PlayerGui.InfoOverlays.ConfirmFrame.MainFrame.ButtonFrame.ConfirmButton

		if button then
			local absPos = button.AbsolutePosition
			local absSize = button.AbsoluteSize

			local clickPos = absPos + (absSize / 2)

			VirtualInputManager:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, true, game, 0) -- Mouse down
			VirtualInputManager:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, false, game, 0) -- Mouse up
		end
	end
	wait()
until not player.PlayerGui.InfoOverlays:FindFirstChild("ConfirmFrame")
repeat wait() until game.Players.LocalPlayer.Character:IsDescendantOf(game.Workspace.Alive)
repeat 
	game.Workspace.Camera.CFrame = CFrame.new(-830.033813, 194.463806, -1291.0896, -0.707096815, -0.15533042, 0.689845383, 7.4505806e-09, 0.97557497, 0.219667271, -0.707116842, 0.155326024, -0.689825892)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-830.7783813476562, 192.71054077148438, -1290.3441162109375)
	game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
	game:GetService("RunService").Heartbeat:Wait()
	game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = A
