--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP
]=]

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

if localPlayer.Name == "hotdogn_back" or localPlayer.Name == 'TCORAIDS' then

	-- ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CmdLine2.0"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "CMDLINEMAIN"
	mainFrame.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
	mainFrame.BorderSizePixel = 0
	mainFrame.Size = UDim2.new(0.17996, 0, 0.14124, 0)
	mainFrame.Position = UDim2.new(0.82004, 0, 0, 0)
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", mainFrame)

	-- Title Label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = "CMDLINE2.0"
	titleLabel.Size = UDim2.new(1, 0, 0.23214, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextScaled = true
	titleLabel.RichText = true
	titleLabel.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
	titleLabel.Parent = mainFrame

	-- TextBox
	local textBox = Instance.new("TextBox")
	textBox.Name = "EnterCommands"
	textBox.PlaceholderText = "Put Command Here"
	textBox.Text = ""
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	textBox.BorderSizePixel = 0
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.TextScaled = true
	textBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
	textBox.Size = UDim2.new(0.81301, 0, 0.28571, 0)
	textBox.Position = UDim2.new(0.0935, 0, 0.36607, 0)
	textBox.Parent = mainFrame

	Instance.new("UICorner", textBox)

	-- Execute Button
	local execButton = Instance.new("TextButton")
	execButton.Name = "EnterCommandButton"
	execButton.Text = "Execute Command"
	execButton.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	execButton.BorderSizePixel = 0
	execButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	execButton.TextScaled = true
	execButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	execButton.Size = UDim2.new(0.63008, 0, 0.1875, 0)
	execButton.Position = UDim2.new(0.18293, 0, 0.75, 0)
	execButton.Parent = mainFrame

	Instance.new("UICorner", execButton)

	-- State
	local antiFreeze = false
	local aleT = false
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

	local function sendChat(msg)
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and (
			channels:FindFirstChild("RBXGeneral")
			or channels:FindFirstChild("General")
			or channels:FindFirstChildWhichIsA("TextChannel")
		)
		if general then
			general:SendAsync(msg)
		else
			local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
			if chatEvents then
				local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
				if sayMessage then
					sayMessage:FireServer(msg, "All")
				end
			end
		end
	end

	local function onDied()
		if not aleT then return end

		task.wait(0.1)

		local char = localPlayer.Character
		if not char then return end

		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		local tool = (backpack and backpack:FindFirstChild("The Arkenstone"))
			or char:FindFirstChild("The Arkenstone")

		if tool then
			local humanoid = char:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid:EquipTool(tool)
			end
		end

		task.wait(0.1)
		sendChat(";r6")
	end

	local function setupCharacter(char)
		char.ChildAdded:Connect(function(child)
			if child.Name == "Hielo" and antiFreeze then
				print("Player is frozen — killing")
				local humanoid = char:FindFirstChild("Humanoid")
				if humanoid then humanoid.Health = 0 end
			end
		end)

		local humanoid = char:WaitForChild("Humanoid")
		humanoid.Died:Connect(onDied)
	end

	setupCharacter(character)

	localPlayer.CharacterAdded:Connect(function(char)
		character = char
		setupCharacter(char)
	end)

	local function executeCommand()
		local text = textBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")

		if text == "fly" then
			localPlayer:SetAttribute("Flying", true)

		elseif text == "unfly" then
			localPlayer:SetAttribute("Flying", false)

		elseif text == "reset" then
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			if humanoid then humanoid.Health = 0 end

		elseif text == "rejoin" or text == "rj" then
			TeleportService:Teleport(game.PlaceId, localPlayer)
			queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()')

		elseif text == "getjobid" or text == "jobid" or text == "getjob" then
			setclipboard(game.JobId)
			print("Job ID copied:", game.JobId)

		elseif text == "antifreeze true" or text == "antifreeze t" then
			antiFreeze = true
			print("Anti Freeze: ON")

		elseif text == "antifreeze false" or text == "antifreeze f" then
			antiFreeze = false
			print("Anti Freeze: OFF")

		elseif text == "antiblind true" or text == "antiblind t" then
			local blind = playerGui:FindFirstChild("Blind")
			if blind and blind:FindFirstChild("Frame") then
				blind.Frame.Visible = false
			end

		elseif text == "antiblind false" or text == "antiblind f" then
			local blind = playerGui:FindFirstChild("Blind")
			if blind and blind:FindFirstChild("Frame") then
				blind.Frame.Visible = true
			end

		elseif text == "antimyopic true" or text == "antimyopic t" then
			local blur = Lighting:FindFirstChild("Blur")
			if blur then blur.Enabled = false end

		elseif text == "antimyopic false" or text == "antimyopic f" then
			local blur = Lighting:FindFirstChild("Blur")
			if blur then blur.Enabled = true end

		elseif text == "ale t" then
			aleT = true
			print("ALE T: ON")

		elseif text == "ale f" then
			aleT = false
			print("ALE T: OFF")

		elseif text == "close" then
			screenGui:Destroy()
			return
		end

		textBox.Text = ""
	end

	execButton.MouseButton1Click:Connect(executeCommand)

	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			executeCommand()
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.LeftControl
			or input.KeyCode == Enum.KeyCode.RightControl then
			mainFrame.Visible = not mainFrame.Visible

		elseif input.KeyCode == Enum.KeyCode.Semicolon then
			mainFrame.Visible = true
			task.wait()
			textBox:CaptureFocus()
		end
	end)

end
