repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer ~= nil
repeat wait() until game.Players.LocalPlayer.Character ~= nil
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Corazon-Heart/Detroy-the-game/refs/heads/main/uilib"))()
local Window = Library.Window('KR4K Library')
local Test1 = Window.CreateTab('Main')
local Boss = Window.CreateTab('TP Boss')
local Ingredient = Window.CreateTab('Item')
local NPC = Window.CreateTab('NPC')
local MOB = Window.CreateTab('Entity')
-- NoFall
local mt = getrawmetatable(game)
local oldMeta = mt.__namecall

-- Function to make metatables writeable (for bypassing the protection)
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	-- Check if method is "FireServer" and the arguments match our criteria
	if method == "FireServer" and #args == 1 and typeof(args[1]) == "table" then
		-- Check if Config is FallDamage
		if args[1]["Config"] == "FallDamage" then
			return false  -- Block the remote event
		end
	end

	-- Call the original method if the condition is not met
	return oldMeta(self, ...)
end)

-- Make the metatable read-only again to avoid further modifications
setreadonly(mt, true)
for i,v in pairs(workspace:GetDescendants()) do
	if (v.Name:find"Lava" or v.Name:find"lava") and v:IsA"Part" then
		v.CFrame = CFrame.new(math.huge,math.huge,math.huge)
	end
end

pcall(function()
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local teleporting = false

	local function getNearestEntity()
		local closestEntity = nil
		local shortestDistance = 30

		for _, entity in pairs(workspace.Alive:GetChildren()) do
			if entity:IsA("Model") and entity ~= game.Players.LocalPlayer.Character then
				local rootPart = entity:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
					if distance < shortestDistance then
						shortestDistance = distance
						closestEntity = rootPart
					end
				end
			end
		end

		return closestEntity
	end

	local function toggleTeleport()
		teleporting = not teleporting

		if teleporting then
			local renderConnection
			renderConnection = RunService.RenderStepped:Connect(function()
				if not teleporting then
					renderConnection:Disconnect()
					return
				end

				local target = getNearestEntity()
				if game.Players:FindFirstChild(target.Parent.Name) then return end
				if target and not target.Parent:FindFirstChild("Grabbing") then
					if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 7)
					end
				end
			end)

			task.spawn(function()
				local netModule = require(game.ReplicatedStorage.Modules.Network)
				while teleporting do
					netModule.connect("MasterEvent", "FireServer", game.Players.LocalPlayer.Character, { Config = "Button1Down" })
					task.wait(0.05)
					netModule.connect("MasterEvent", "FireServer", game.Players.LocalPlayer.Character, { Config = "Button1Up" })
					task.wait(0.05)
				end
			end)
		end
	end
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.G then
			toggleTeleport()
		end
	end)
end)

spawn(function()
	while wait() do
		game.Lighting.Brightness = 0.7
		game.Lighting.GlobalShadows = false
		game.Lighting.Ambient = Color3.new(1,1,1)
		game.Lighting.FogStart = 0
		game.Lighting.FogEnd = 100000
		for i,v in pairs(game.Lighting:GetChildren()) do
			if v.Parent == game.Lighting then
				v:Destroy()
			end
		end
	end
end)
--Instant Kill
spawn(function()
	local Player = game.Players.LocalPlayer

	local Connections = {}

	local function MakeConnection(Mob)
		if not Connections[Mob] and Mob:FindFirstChildOfClass("Humanoid") then
			local tbl = game.Players:GetPlayers()
			for i,v in pairs(tbl) do
				if Mob == v.Character then
					return
				end
			end
			Connections[Mob] = Mob.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				if Mob:FindFirstChild"HumanoidRootPart" and Mob.Humanoid.Health <= Mob.Humanoid.MaxHealth*0.9 and isnetworkowner(Mob.HumanoidRootPart) then
					for i = 1, 20 do
						Mob.Humanoid.Health = 0
					end
				end
			end)
		end
	end

	for i,v in pairs(game.Workspace:GetDescendants()) do
		local Hum = v:FindFirstChild("Humanoid")
		if Hum then
			MakeConnection(v)
		end
	end

	game.Workspace.DescendantAdded:Connect(function(Child)
		local Hum = Child:FindFirstChild("Humanoid") or Child:WaitForChild("Humanoid", 10)
		if Hum then
			MakeConnection(Child)
		end
	end)
end)

Boss.CreateButton("Licht King", function()
	--Licht King
	local function fireProximityAndWait()
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1721.454345703125, 422.90582275390625, -3894.0126953125)
		task.wait()
	end

end)
Boss.CreateButton("Elder Treant Location", function()
	--Elder Treant
	local function fireProximityAndWait()
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1028.5682373046875, 155.67971801757812, -1482.1468505859375)
		task.wait()
	end
end)
Boss.CreateButton("Elder Treant (Body)", function()
	for i,v in pairs(game.Workspace.Alive:GetChildren()) do

		if v.Name:find"Elder T"then
			A = v.HumanoidRootPart.CFrame
		end
	end
	if A == nil then return end
	local function fireProximityAndWait()

		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = A
		task.wait()
	end
end)
Boss.CreateButton("Rune Golem", function()
	for i,v in pairs(game.Workspace.Alive:GetChildren()) do

		if v.Name:find"Rune Golem"then
			A = v.HumanoidRootPart.CFrame
		end
	end
	if A == nil then return end
	local function fireProximityAndWait()

		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = A
		task.wait()
	end
end)
Boss.CreateButton("Goblin King", function()
	--Goblin King
	local function fireProximityAndWait()
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1416.1436767578125, -5.341595649719238, -1903.239013671875)
		task.wait()
	end

end)
Test1.CreateButton("TP Blacksmith", function()
	local function fireProximityAndWait()
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Effects.NPCS.WinfridTheBlacksmith.HumanoidRootPart.CFrame
		task.wait()
	end
end)
Test1.CreateButton("TP Fiend", function()
	local A = CFrame.new(-618.617981, -62.6995506, -358.526367, -0.972720742, -3.17664082e-08, -0.231979266, -2.41212317e-09, 1, -1.26822059e-07, 0.231979266, -1.22802874e-07, -0.972720742)
	local function fireProximityAndWait()
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
				startTime = tick()
			end
			wait(0.1)
		end
	end


	fireProximityAndWait()
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = A
		task.wait()
	end
end)
Test1.CreateButton("TP Drogar", function()
	fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
end)
Test1.CreateButton("Instant Heal", function()
	spawn(function()
		local Last = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
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
			fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
			wait(.1)
		until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
		for i = 1,5 do
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Last
			task.wait()
		end
		local rs = game:GetService("ReplicatedStorage")
		local plr = game:GetService("Players").LocalPlayer
		local netModule = require(rs.Modules.Network)
		local tradeData = {
			Config = "EquipWeapon",
		}
		netModule.connect("MasterEvent", "FireServer", plr.Character, tradeData)
	end)
end)

Test1.CreateButton("Respawn", function()
	spawn(function()
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
	end)
end)

Test1.CreateButton("TP to all NPC", function()
	for i,v in pairs(game.Workspace.Effects.NPCS:GetChildren()) do
		if v:FindFirstChild"HumanoidRootPart" and v:FindFirstChild"Quest1" then
			local NpcName = tostring(v.Name)
			repeat wait()
				fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
			until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
			for i = 1,10 do
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Effects.NPCS[NpcName].HumanoidRootPart.CFrame
				task.wait()
			end
			wait(1)
		end
	end
end)

Test1.CreateButton("Server Hop", function()
	game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Server Hopping", Text = "Wait....", Duration = 30 })
	local PlaceID = 99995671928896
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	local File = pcall(function()
		AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
	end)
	if not File then
		table.insert(AllIDs, actualHour)
		writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
	end
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								delfile("NotSameServers.json")
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end

	function Teleport()
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end

	-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
	Teleport()
end)
Test1.CreateKeybind("Toggle UI", Enum.KeyCode.LeftAlt, function()
	Library:ToggleUI()
end)

--flyscript
pcall(function()
	local speeds = 2
	local maxSpeed = 30
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
	function TP(Object) 
		local tweenService = game:GetService("TweenService")
		local rootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not rootPart then return end

		local tweenInfo = TweenInfo.new(
			(rootPart.Position - Object).magnitude / 70, 
			Enum.EasingStyle.Linear, 
			Enum.EasingDirection.In, 
			0, false, 0
		)

		local tween = tweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(Object)})
		tween:Play()

		-- ตรวจสอบการยกเลิก Tween ทันทีเมื่อ Space หรือ Ctrl ไม่ถูกกด
		spawn(function()
			while tween.PlaybackState == Enum.PlaybackState.Playing do
				if not isSpaceHeld and not isCtrlHeld then
					tween:Cancel()
					break
				end
				task.wait()
			end
		end)

		tween.Completed:Wait()
	end

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

	local heartbeatConnection
	local inputBeganConnection
	local inputEndedConnection
	local stateChangedConnection

	local function toggleScript(state)
		if state then
			-- เปิดสคริปต์
			scriptEnabled = true
			updateFlyState(true)

			-- เชื่อมต่อเหตุการณ์
			stateChangedConnection = speaker.Character:FindFirstChild("Humanoid").StateChanged:Connect(function() end)
			heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function() end)
			inputBeganConnection = game:GetService("UserInputService").InputBegan:Connect(function() end)
			inputEndedConnection = game:GetService("UserInputService").InputEnded:Connect(function() end)

		else
			-- ปิดสคริปต์
			scriptEnabled = false
			updateFlyState(false)

			-- ตรวจสอบและยกเลิกการเชื่อมต่ออย่างปลอดภัย
			if stateChangedConnection then stateChangedConnection:Disconnect() end
			if heartbeatConnection then heartbeatConnection:Disconnect() end
			if inputBeganConnection then inputBeganConnection:Disconnect() end
			if inputEndedConnection then inputEndedConnection:Disconnect() end
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
					TP(hum.RootPart.Position+Vector3.new(0,5,0))
					hum.RootPart.Velocity = Vector3.new(0,0,0)
				end
			elseif isCtrlHeld then
				currentDownwardVelocity = math.min(currentDownwardVelocity + 2, 150)  -- จำกัดความเร็วสูงสุดที่ 50
				if hum and hum.RootPart then
					TP(hum.RootPart.Position+Vector3.new(0,-5,0))
					hum.RootPart.Velocity = Vector3.new(0,0,0)
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
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart"
		resetScript()
		scriptEnabled = false
		updateFlyState(false)

		if stateChangedConnection then stateChangedConnection:Disconnect() end
		if heartbeatConnection then heartbeatConnection:Disconnect() end
		if inputBeganConnection then inputBeganConnection:Disconnect() end
		if inputEndedConnection then inputEndedConnection:Disconnect() end
		wait(.1)
		scriptEnabled = true
		updateFlyState(true)

		stateChangedConnection = speaker.Character:FindFirstChild("Humanoid").StateChanged:Connect(function() end)
		heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function() end)
		inputBeganConnection = game:GetService("UserInputService").InputBegan:Connect(function() end)
		inputEndedConnection = game:GetService("UserInputService").InputEnded:Connect(function() end)
	end)
end)
--ESP
pcall(function()
	local esp_lib = "https://raw.githubusercontent.com/Corazon-Heart/Detroy-the-game/refs/heads/main/esplibboss.lua"
	local esp_lib_init = loadstring(game:HttpGet(esp_lib))()

	-- ESP Settings
	esp_lib_init.Players = false
	esp_lib_init.Boxes = false
	esp_lib_init.AutoRemove = true
	esp_lib_init.FaceCamera = true

	local AliveFolder = workspace:FindFirstChild("Alive")
	if not AliveFolder then
		warn("Workspace.Alive folder not found!")
		return
	end

	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local espEnabled = true -- ESP is enabled by default
	local entityESP = {} -- Store ESP objects for updating

	local function ToggleESP()
		espEnabled = not espEnabled
		esp_lib_init:Toggle(espEnabled)
	end

	local function CleanName(name)
		return name:gsub("%d", "") -- Remove all numbers from non-player names
	end

	local function AddEntityESP(entity)
		if entity:IsA("Model") and entity:FindFirstChild("HumanoidRootPart") and entity:FindFirstChild("Humanoid") then
			local isPlayer = Players:GetPlayerFromCharacter(entity) ~= nil

			if isPlayer and entity == LocalPlayer.Character then
				return
			end

			local color = isPlayer and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 105, 180)
			local entityName = isPlayer and entity.Name or CleanName(entity.Name)
			local humanoid = entity.Humanoid

			local espObject = esp_lib_init:Add(
				entity.HumanoidRootPart,
				{
					Name = entityName .. " [" .. math.floor(humanoid.Health) .. "]", 
					Color = color
				}
			)

			entityESP[entity] = {espObject = espObject, humanoid = humanoid}
		end
	end

	local function UpdateEntityESP()
		for entity, data in pairs(entityESP) do
			if entity and data.humanoid and data.espObject then
				data.espObject.Name = CleanName(entity.Name) .. " [" .. math.floor(data.humanoid.Health) .. "]"
			end
		end
	end

	-- Apply ESP to existing entities
	for _, entity in pairs(AliveFolder:GetChildren()) do
		AddEntityESP(entity)
	end

	-- Detect new entities and apply ESP
	AliveFolder.ChildAdded:Connect(function(entity)
		local startTime = tick()  -- Store the current time
		repeat wait()
			if tick() - startTime > 5 then return print("Failed to ESP", tostring(entity.Name)) end
		until entity:FindFirstChild("HumanoidRootPart")
		if entity:FindFirstChild("HumanoidRootPart") and entity:FindFirstChild("Humanoid") then
			AddEntityESP(entity)
		end
	end)

	-- Update ESP every 0.1 seconds instead of every frame to reduce lag
	local RunService = game:GetService("RunService")
	task.spawn(function()
		while true do
			UpdateEntityESP()
			task.wait(0.1) -- Update every 0.1 seconds to reduce lag
		end
	end)

	esp_lib_init:Toggle(true) -- Enable ESP by default

	-- Create a button to toggle ESP
	local UserInputService = game:GetService("UserInputService")
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Enum.KeyCode.F3 then -- Press 'E' to toggle ESP
			ToggleESP()
		end
	end)

end)
--NOCLIP
spawn(function()
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

	-- Function to toggle noclip when pressing X
	local function ToggleNoclip(input)
		if input.KeyCode == Enum.KeyCode.C then
			if Clip then
				StartNC()
			else
				StopNC()
			end
		end
	end

	-- Listen for keypresses
	UserInputService.InputBegan:Connect(ToggleNoclip)
end)
--UIIn
local createdButtons = {}

local function fireProximityAndWait(part)
	local prompt = workspace.InvisibleParts.ColosseumEntrance.InteractPrompt
	fireproximityprompt(prompt)

	local startTime = tick()
	local targetPos = Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)

	while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos).magnitude >= 10 do
		if tick() - startTime > 2 then
			fireproximityprompt(prompt)
			startTime = tick()
		end
		wait(0.1)
	end

	local harvestables = game.Workspace.Harvestable:GetChildren()
	local matchingParts = {}

	for _, v in ipairs(harvestables) do
		if v.Name:find(tostring(part.Name)) then
			table.insert(matchingParts, v)
		end
	end

	if #matchingParts > 0 then
		local randomPart = matchingParts[math.random(1, #matchingParts)]
		if randomPart:IsA("Model") and #randomPart:GetChildren() >= 2 then
			for i = 1,5 do
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPart:GetChildren()[3].CFrame
				task.wait()
			end
		else
			for i = 1,5 do
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPart.CFrame
				task.wait()
			end
		end
	end
end

-- Collect and sort harvestables
local harvestables = game.Workspace.Harvestable:GetChildren()
local sortedHarvestables = {}

for _, harvest in ipairs(harvestables) do
	table.insert(sortedHarvestables, harvest)
end

table.sort(sortedHarvestables, function(a, b)
	return a.Name:lower() < b.Name:lower()  -- Sorting in case-sensitive A-Z order
end)

-- Create buttons in sorted order
for _, harvest in ipairs(sortedHarvestables) do
	if not createdButtons[harvest.Name] then
		Ingredient.CreateButton(harvest.Name, function()
			fireProximityAndWait(harvest)
		end)
		createdButtons[harvest.Name] = true
	end
end

--UINPC
local NPCButton = {}

local function tppart(part)
	local prompt = workspace.InvisibleParts.ColosseumEntrance.InteractPrompt
	fireproximityprompt(prompt)

	local startTime = tick()
	local targetPos = Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)

	while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos).magnitude >= 10 do
		if tick() - startTime > 2 then
			fireproximityprompt(prompt)
			startTime = tick()
		end
		wait(0.1)
	end
	local TPING = part:FindFirstChildOfClass"Part"
	local TPIN = part:FindFirstChildOfClass"MeshPart"
	for i = 1,5 do
		if part:IsA("Model") and TPING then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TPING.CFrame
		elseif part:IsA("Model") and TPIN then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TPIN.CFrame
		end
		task.wait()
	end
end

local npcsort = workspace.Effects.NPCS:GetChildren()
local npcalphabet = {}

for _, harvest in ipairs(npcsort) do
	table.insert(npcalphabet, harvest)
end

table.sort(npcalphabet, function(a, b)
	return a.Name:lower() < b.Name:lower()
end)

-- Create buttons in sorted order
for _, npc in ipairs(npcalphabet) do
	if not NPCButton[npc.Name] then
		NPC.CreateButton(npc.Name, function()
			tppart(npc)
		end)
		NPCButton[npc.Name] = true
	end
end

local createdButtons = {}  -- Store already created buttons to avoid duplicates

function extractText(inputString)
	-- Remove the period from the input string
	local extracted = inputString:match("([%a%s]+)")  -- Match only alphabets and spaces
	extracted = extracted:gsub("%.$", "")  -- Remove the period at the end, if present
	return extracted
end

local function tpnewpos(newpos)
	fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

	local startTime = tick()
	while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude >= 10 do
		if tick() - startTime > 2 then
			fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)
			startTime = tick()
		end
		wait(0.1)
	end
	for i = 1,5 do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = newpos
		task.wait()	
	end
end


-- TPEN
local function TPEN(keyword)

	local candidates = {}
	for _, model in pairs(game.Workspace.Alive:GetChildren()) do
		if model:IsA("Model") and model.Name:find(keyword) and (model:FindFirstChildOfClass("Part") or model:FindFirstChildOfClass("MeshPart")) then
			table.insert(candidates, model)
		end
	end

	-- Choose a random model from the list
	if #candidates > 0 then
		local chosenModel = candidates[math.random(1, #candidates)]
		local TPING = chosenModel:FindFirstChildOfClass("Part")
		local TPIN = chosenModel:FindFirstChildOfClass("MeshPart")
		if TPIN or TPING then
			fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

			local startTime = tick()
			local targetPos = Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)

			while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos).magnitude >= 10 do
				if tick() - startTime > 2 then
					fireproximityprompt(prompt)
					startTime = tick()
				end
				wait(0.1)
			end
			for i = 1, 5 do
				if TPING then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TPING.CFrame
				elseif TPIN then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TPIN.CFrame
				end
				task.wait()
			end
		end
	else
		fireproximityprompt(workspace.InvisibleParts.ColosseumEntrance.InteractPrompt)

		local startTime = tick()
		local targetPos = Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)

		while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - targetPos).magnitude >= 10 do
			if tick() - startTime > 2 then
				fireproximityprompt(prompt)
				startTime = tick()
			end
			wait(0.1)
		end
		if keyword:find"Banshee" or keyword:find"Braelor" or keyword:find"Gralthar" then
			tpnewpos(CFrame.new(-806.375732421875, 243.05555725097656, -983.061767578125))
		elseif keyword:find"Mandrake King" then
			tpnewpos(CFrame.new(1220.371337890625, -134.1096649169922, 246.6413116455078))
		elseif keyword:find"Mandrake" and not keyword:find"King" then
			tpnewpos(CFrame.new(1288.796875, 115.93772888183594, 160.29010009765625))
		elseif keyword:find"Deer" then
			tpnewpos(CFrame.new(1584.0882568359375, 127.94346618652344, 590.7007446289062))
		elseif keyword:find"Goblin" then
			tpnewpos(CFrame.new(1670.3717041015625, 116.17381286621094, 35.1649284362793))
		elseif keyword:find"Wolf" or keyword:find"Boar" then
			tpnewpos(CFrame.new(249.7513885498047, 127.84239959716797, 1068.0750732421875))
		elseif keyword:find"Bear" then
			tpnewpos(CFrame.new(-348.0965270996094, 134.1508331298828, 745.5266723632812))
		elseif keyword:find"Serpent" then
			tpnewpos(CFrame.new(429.8319091796875, 163.46481323242188, -1087.7958984375))
		elseif keyword:find"Panther" then
			tpnewpos(CFrame.new(408.46112060546875, 161.25692749023438, -1055.7154541015625))
		elseif keyword:find"Amphi" then
			tpnewpos(CFrame.new(944.6209716796875, 152.2188720703125, -1501.6416015625))
		elseif keyword:find"Mud C" or keyword:find"Croc" then
			tpnewpos(CFrame.new(2304.920166015625, 167.76004028320312, -1398.9019775390625))
		elseif keyword:find"Spider" then
			tpnewpos(CFrame.new(1926.3221435546875, 182.06520080566406, -852.291259765625))
		elseif keyword:find"Rat" then
			tpnewpos(CFrame.new(-574.9901123046875, 173.21730041503906, 1116.95361328125))
		else
			game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Invalid Database", Text = keyword, Duration = 2 })
		end
	end
end

-- Create a function to handle new children added to workspace.Alive
local function onModelAdded(model)
	-- Skip the local player's character and any other player's character
	if model:IsA("Model") and not game.Players:GetPlayerFromCharacter(model) then
		local mobname = extractText(model.Name)
		-- Check if the button for this model already exists
		if not createdButtons[mobname] then
			MOB.CreateButton(mobname, function()
				TPEN(mobname)
			end)
			createdButtons[mobname] = true  -- Mark this mobname as having a button created
		end
	end
end

-- Connect the ChildAdded event to detect new models
workspace.Alive.ChildAdded:Connect(onModelAdded)

-- Also, handle existing models (if any) in workspace.Alive when the script starts
for _, model in pairs(workspace.Alive:GetChildren()) do
	-- Skip the local player's character and any other player's character
	if model:IsA("Model") and not game.Players:GetPlayerFromCharacter(model) then
		onModelAdded(model)  -- Ensure any pre-existing models in workspace.Alive also get buttons created
	end
end
