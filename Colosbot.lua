setfpscap(30)
spawn(function()
	task.wait(600)
	game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
end)
pcall(function()
	repeat
		wait()
	until game:IsLoaded()
	if game.PlaceId == 99995671928896 then
		repeat wait() until game.Players.LocalPlayer ~= nil
		repeat wait() until game.Players.LocalPlayer.Character ~= nil
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart"
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"CharacterHandler"
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"CharacterHandler":FindFirstChild"Input"
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"CharacterHandler":FindFirstChild"Input":FindFirstChild"Events"
		repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"CharacterHandler":FindFirstChild"Input":FindFirstChild"Events":FindFirstChild"MasterEvent"
		wait(.5)
		local CurrentCheck = 0
		for _,v in pairs(game.Players:GetPlayers()) do
			if v:IsA("Player") then
				spawn(function()
					if v:IsDescendantOf(game.Players) and v and v:GetRankInGroup(15431531) >= 1 then
						CurrentCheck = CurrentCheck + 1
						wait()
						game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
					else
						CurrentCheck = CurrentCheck + 1
					end
				end)
			end
		end


		--CheckAddedPlayer
		game.Players.PlayerAdded:Connect(function(v)
			wait()
			if v:IsDescendantOf(game.Players) and v and v:GetRankInGroup(15431531) >= 1 then
				game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end
		end)

		local MainTick = tick()
		repeat wait() until CurrentCheck >= #game.Players:GetChildren() or tick() - MainTick >= 4
		print"done check mod"
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
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")

		-- Target position
		local targetPosition = Vector3.new(1013.8218383789062, -239.08447265625, 1572.6201171875)
		local teleportRadius = 500
		local destinationPlaceId = 10290054819

		-- Function to check and teleport other players
		local function checkAndTeleport()
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local playerPosition = player.Character.HumanoidRootPart.Position
					local distance = (playerPosition - targetPosition).magnitude

					if distance <= teleportRadius then
						-- Teleport player to the target place
						TeleportService:Teleport(destinationPlaceId, game.Players.LocalPlayer)
					end
				end
			end
		end

		--CheckAFK
		spawn(function()
			while wait(1) do
				repeat wait() until game.Players.LocalPlayer.Character ~= nil
				local humanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
				local initialCFrame = humanoidRootPart.CFrame

				task.wait(8)

				if humanoidRootPart.Parent ~= nil and humanoidRootPart.CFrame == initialCFrame then
					game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
				end
			end
		end)

		--Check CF
		spawn(function()
			while wait(2) do
				local player = game.Players.LocalPlayer
				local infoOverlays = player:WaitForChild("PlayerGui"):WaitForChild("InfoOverlays")
				local confirmFrame = infoOverlays:FindFirstChild("ConfirmFrame")

				if confirmFrame then
					task.delay(5, function()
						if infoOverlays:FindFirstChild("ConfirmFrame") then
							return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
						end
					end)
				end
			end
		end)
			
		_G.Botting = function()
			repeat wait() until game.Players.LocalPlayer ~= nil
			repeat wait() until game.Players.LocalPlayer.Character ~= nil
			repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart"
			checkAndTeleport()
			game.Workspace.InvisibleParts.ColosseumEntrance.CFrame = CFrame.new(-311.4093933105469, 358.6604919433594, -689.0089111328125)
			repeat 
				game.Workspace.Camera.CFrame = CFrame.new(1023.71997, -225.121262, 1501.48669, -0.948263526, -0.312660873, 0.0551318303, 0, 0.173652112, 0.984807014, -0.317484409, 0.933856547, -0.164667949)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.InvisibleParts.ColosseumEntrance.CFrame
				game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
				game:GetService("RunService").Heartbeat:Wait()
				game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
			until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(937.6810913085938, -217.88751220703125, 1686.1224365234375)
			repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(937.6810913085938, -217.88751220703125, 1686.1224365234375)).magnitude < 5
			local statValue = game:GetService("Players").LocalPlayer.PlayerGui.InventoryGui.MainBackpack.SearchBar.Weight.StatValue.Text

			-- Extract numbers using pattern matching
			local currentWeight, maxWeight = string.match(statValue, "(%d+)/(%d+)")

			-- Convert them to numbers
			currentWeight = tonumber(currentWeight)
			maxWeight = tonumber(maxWeight)
			if currentWeight >= maxWeight then
				repeat 
					game.Workspace.Camera.CFrame = CFrame.new(1023.71997, -225.121262, 1501.48669, -0.948263526, -0.312660873, 0.0551318303, 0, 0.173652112, 0.984807014, -0.317484409, 0.933856547, -0.164667949)
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.InvisibleParts.ColosseumEntrance.CFrame
					game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					game:GetService("RunService").Heartbeat:Wait()
					game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-386.4886779785156, 154.18463134765625, -955.7117309570312)
				game.Workspace.Camera.CFrame = CFrame.new(-375.058167, 161.526382, -955.592163, 0.00871383399, -0.464894921, 0.885323048, 0, 0.885356724, 0.464912534, -0.999962091, -0.00405117078, 0.00771485083)
				wait(1)
				game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
				wait()
				game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				wait(1)
				for i = 1,12 do
					local player = game:GetService("Players").LocalPlayer
					local backpack = player.Backpack
					local sellEvent = player.Character.CharacterHandler.Input.Events.SellEvent

					local itemsToSell = {
						"Intellect Rune",
						"Agility Rune",
						"Spirit Rune",
						"Stamina Rune",
						"Strength Rune",
						"Thick Leather",
						"Lesser Strength Rune",
						"Lesser Agility Rune",
						"Lesser Intellect Rune",
						"Lesser Spirit Rune",
						"Lesser Stamina Rune"
					}

					for _, itemName in ipairs(itemsToSell) do
						local item = backpack:FindFirstChild(itemName)
						if item then
							sellEvent:FireServer(item, nil, true)
						end
					end
					wait(.2)
				end
				repeat 
					game.Workspace.Camera.CFrame = CFrame.new(1023.71997, -225.121262, 1501.48669, -0.948263526, -0.312660873, 0.0551318303, 0, 0.173652112, 0.984807014, -0.317484409, 0.933856547, -0.164667949)
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.InvisibleParts.ColosseumEntrance.CFrame
					game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					game:GetService("RunService").Heartbeat:Wait()
					game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(1025.1005859375, -197.8874969482422, 1363.8944091796875)).magnitude < 10
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(937.6810913085938, -217.88751220703125, 1686.1224365234375)
				repeat wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(937.6810913085938, -217.88751220703125, 1686.1224365234375)).magnitude < 5
			end

			wait(.5)
			local vim = game:GetService("VirtualInputManager")
			local chatFrame = game.Players.LocalPlayer.PlayerGui.ChatGui.MainFrame

			repeat wait()
				vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
				wait()
				vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
			until chatFrame.Visible == true
			wait(.5)
			--Check Again
			if chatFrame.Visible == false then
				repeat wait()
					vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					wait()
					vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				until chatFrame.Visible == true
			end
			wait(.5)
			--Check Again
			if chatFrame.Visible == false then
				repeat wait()
					vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
					wait()
					vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
				until chatFrame.Visible == true
			end
			--Close
			repeat wait()
				vim:SendKeyEvent(true, Enum.KeyCode.One, false, nil)
				wait()
				vim:SendKeyEvent(false, Enum.KeyCode.One, false, nil)
			until chatFrame.Visible == false
			wait(.5)
			--Check Again
			if chatFrame.Visible == true then
				repeat wait()
					vim:SendKeyEvent(true, Enum.KeyCode.One, false, nil)
					wait()
					vim:SendKeyEvent(false, Enum.KeyCode.One, false, nil)
				until chatFrame.Visible == false
			end
			wait(.5)
			--Check Again
			if chatFrame.Visible == true then
				repeat wait()
					vim:SendKeyEvent(true, Enum.KeyCode.One, false, nil)
					wait()
					vim:SendKeyEvent(false, Enum.KeyCode.One, false, nil)
				until chatFrame.Visible == false
			end
			--Start
			local start = false
			local starttime = tick()
			repeat
				task.wait()
				local player = game:GetService("Players").LocalPlayer
				if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local hrp = player.Character.HumanoidRootPart
					if (hrp.Position - Vector3.new(1022.8798828125, -239.4728240966797, 1610.608642578125)).magnitude < 30 then
						start = true
					end
				end
			until start == true or (tick() - starttime) >= 2
			wait()
			local rs = game:GetService("ReplicatedStorage")
			local plr = game:GetService("Players").LocalPlayer
			local netModule = require(rs.Modules.Network)

			local tradeData = {
				Config = "EquipWeapon",
			}

			netModule.connect("MasterEvent", "FireServer", plr.Character, tradeData)
			local Drogar = nil
			function TP(Object) -- Object = part teleporting to.
				local tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Object).magnitude/110,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
				local tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(Object + Vector3.new(0,0,0))})
				tween:Play()
				tween.Completed:Wait()
			end
			local endscript = false
			repeat wait()
				for i,v in pairs(workspace.Alive:GetChildren()) do
					if v.Name:find"Drogar" then
						Drogar = v
					end
				end
			until Drogar ~= nil

			TP(Drogar.HumanoidRootPart.Position)
			repeat
				if game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart" and Drogar:FindFirstChild"HumanoidRootPart" then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Drogar.HumanoidRootPart.CFrame*CFrame.new(0,-6,7)
				end
				wait()
				local rs = game:GetService("ReplicatedStorage")
				local plr = game:GetService("Players").LocalPlayer
				local netModule = require(rs.Modules.Network)

				local tradeData = {
					Config = "Button1Down",
				}

				netModule.connect("MasterEvent", "FireServer", plr.Character, tradeData)
				local rs = game:GetService("ReplicatedStorage")
				local plr = game:GetService("Players").LocalPlayer
				local netModule = require(rs.Modules.Network)

				local tradeData = {
					Config = "Button1Up",
				}

				netModule.connect("MasterEvent", "FireServer", plr.Character, tradeData)
				if Drogar:FindFirstChild"Humanoid" then
					if Drogar.Humanoid.Health <= Drogar.Humanoid.MaxHealth*0.9 then
						local StartTick = tick()
						local Safe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,100,0)
						if not game.Players.LocalPlayer.Character:FindFirstChild"Float" then
							local Float = Instance.new('Part', game.Players.LocalPlayer.Character)
							Float.Name = 'Float'
							Float.Transparency = 1
							Float.Size = Vector3.new(6,1,6)
							Float.Anchored = true
							Float.CFrame = Safe * CFrame.new(0,-3.5,0)
						else
							game.Players.LocalPlayer.Character:FindFirstChild"Float".CFrame = Safe * CFrame.new(0,-3.5,0)
						end
						repeat task.wait()
							if game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart" then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Safe
							end
							if Drogar.Parent ~= nil then
								Drogar.Humanoid.Health = 0
								Drogar.Humanoid.Health = -math.huge
							end
							if tick() - StartTick >= 3 then
								endscript = true
							end
						until Drogar.Parent == nil or endscript == true
						if game.Players.LocalPlayer.Character:FindFirstChild"Float" then
							game.Players.LocalPlayer.Character:FindFirstChild"Float":Destroy()
						end
					end
				end
				task.wait()
			until Drogar.Parent == nil or endscript == true
			if game.Players.LocalPlayer.Character:FindFirstChild"Humanoid" and game.Players.LocalPlayer.Character:FindFirstChild"Humanoid".Health > 0 then
				repeat wait()
					game.Players.LocalPlayer.Character.Humanoid.Health = 0
				until game.Players.LocalPlayer.Character.Humanoid.Health == 0
			end
			local VirtualInputManager = game:GetService("VirtualInputManager")
			local Players = game:GetService("Players")

			local player = Players.LocalPlayer
			local gui = player:WaitForChild("PlayerGui"):WaitForChild("InfoOverlays", 5) -- Wait for InfoOverlays with a timeout

			if not gui then
				warn("InfoOverlays not found")
				return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end

			local confirmFrame = gui:WaitForChild("ConfirmFrame", 5)
			if not confirmFrame then
				warn("ConfirmFrame not found")
				return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end

			local mainFrame = confirmFrame:WaitForChild("MainFrame", 5)
			if not mainFrame then
				warn("MainFrame not found")
				return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end

			local buttonFrame = mainFrame:WaitForChild("ButtonFrame", 5)
			if not buttonFrame then
				warn("ButtonFrame not found")
				return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end

			local confirmButton = buttonFrame:WaitForChild("ConfirmButton", 5)
			if not confirmButton then
				warn("ConfirmButton not found")
				return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
			end

			repeat
				if confirmButton then
					local absPos = confirmButton.AbsolutePosition
					local absSize = confirmButton.AbsoluteSize

					-- Calculate the center of the button
					local clickPos = absPos + (absSize / 2)

					-- Simulate a left mouse click at the button's position
					VirtualInputManager:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, true, game, 0) -- Mouse down
					VirtualInputManager:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, false, game, 0) -- Mouse up
				end
				task.wait()
			until not gui:FindFirstChild("ConfirmFrame")

			repeat wait() until game.Players.LocalPlayer.Character:IsDescendantOf(game.Workspace.Alive)
			wait(0.5)
			_G.Botting()
		end
		spawn(function()
			local targetPosition = Vector3.new(1025.451416015625, -217.9293212890625, 1421.5732421875)
			local radius = 10

			function checkProximity()
				local player = game.Players.LocalPlayer
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local playerPosition = player.Character.HumanoidRootPart.Position
					local distance = (playerPosition - targetPosition).magnitude

					if distance <= radius then
						return game:GetService("TeleportService"):Teleport(10290054819, game.Players.LocalPlayer)
					end
				end
			end

			-- Run the check periodically
			while true do
				checkProximity()
				wait(1) -- Adjust the interval as needed
			end
		end)
		_G.Botting()
	elseif game.PlaceId == 10290054819 then
		local players = game:GetService("Players")
		local player = players.LocalPlayer
		local gui = player:WaitForChild("PlayerGui") -- Ensure PlayerGui exists

		-- Wait for Menu and its children
		local menu = gui:WaitForChild("Menu")
		local cosmeticButton = menu:WaitForChild("CosmeticButton")

		-- Simulate space key press
		wait(1)
		local virtualInput = game:GetService("VirtualInputManager")
		virtualInput:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
		game:GetService("RunService").Heartbeat:Wait()
		virtualInput:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)

		-- Wait for PlayButton to appear
		local buttonFrame = menu:WaitForChild("ButtonFrame")
		local playButton = buttonFrame:WaitForChild("PlayButton")
		local absPos = playButton.AbsolutePosition
		local absSize = playButton.AbsoluteSize

		-- Click PlayButton
		local clickPos = absPos + (absSize / 2)
		virtualInput:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, true, game, 0)
		virtualInput:SendMouseButtonEvent(clickPos.X, clickPos.Y + 65, 0, false, game, 0)
		wait(1)
		-- Wait for CharacterSlots UI
		local slots = gui:WaitForChild("Slots")
		local characterSlots = slots:WaitForChild("CharacterSlots")
		local scrollingFrame = characterSlots:WaitForChild("ScrollingFrame")
		local slot1 = scrollingFrame:WaitForChild("Slot_1")
		local slotPos = slot1.AbsolutePosition
		local slotSize = slot1.AbsoluteSize

		-- Click Slot_1
		local slotClickPos = slotPos + (slotSize / 2)
		virtualInput:SendMouseButtonEvent(slotClickPos.X, slotClickPos.Y + 65, 0, true, game, 0)
		virtualInput:SendMouseButtonEvent(slotClickPos.X, slotClickPos.Y + 65, 0, false, game, 0)
		wait(1)
		-- Wait for Server List UI
		local serverList = gui:WaitForChild("ServerList")
		local mainFrame = serverList:WaitForChild("MainFrame")
		local browser = mainFrame:WaitForChild("Browser")
		local serverScrollFrame = browser:WaitForChild("ScrollingFrame")

		-- Wait until at least 3 server entries exist with a timeout of 10 seconds
		local startTime = tick()
		while #serverScrollFrame:GetChildren() < 3 do
			if tick() - startTime > 10 then
				warn("Timeout: Not enough server entries found within 10 seconds")
				-- Click QuickJoin button
				local quickJoinButton = mainFrame:WaitForChild("QuickJoin")
				local quickJoinPos = quickJoinButton.AbsolutePosition
				local quickJoinSize = quickJoinButton.AbsoluteSize
				local quickJoinClickPos = quickJoinPos + (quickJoinSize / 2)

				virtualInput:SendMouseButtonEvent(quickJoinClickPos.X, quickJoinClickPos.Y + 65, 0, true, game, 0)
				virtualInput:SendMouseButtonEvent(quickJoinClickPos.X, quickJoinClickPos.Y + 65, 0, false, game, 0)
			end
			wait()
		end


		while true do
			wait()
			local children = serverScrollFrame:GetChildren()
			if #children >= 3 then
				local randomIndex = math.random(3, #children)
				local randomChild = children[randomIndex]
				local playerCountText = randomChild:FindFirstChild("PlayerCount")

				if playerCountText and playerCountText:IsA("TextLabel") then
					local currentPlayers = tonumber(playerCountText.Text:match("(%d+)/%d+"))

					if currentPlayers and currentPlayers <= 7 then
						local searchBar = mainFrame:WaitForChild("SearchBar")
						randomChild.Parent = searchBar
						local childPos = randomChild.AbsolutePosition
						local childSize = randomChild.AbsoluteSize
						local childClickPos = childPos + (childSize / 2)

						-- Click on selected server
						virtualInput:SendMouseButtonEvent(childClickPos.X, childClickPos.Y + 65, 0, true, game, 0)
						wait()
						virtualInput:SendMouseButtonEvent(childClickPos.X, childClickPos.Y + 65, 0, false, game, 0)
						wait(0.5)
						randomChild.Parent = serverScrollFrame
						game.GuiService:ClearError()
					end
				end
			end
		end
	end
end)
