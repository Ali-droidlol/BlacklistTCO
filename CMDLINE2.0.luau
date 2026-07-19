--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP
]=]

if _G.SCRIPTLOADEDCMDLINE == true then
	warn('Local player already executed the script')
end

_G.SCRIPTLOADEDCMDLINE = true

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

	-- ============================================================
	-- STATE
	-- ============================================================
	local antiFreeze = false
	local aleT = false
	local spychat = false
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

	-- ============================================================
	-- TCO COLOR TABLES
	-- ============================================================
	local isog = workspace:FindFirstChild("Cubes") ~= nil

	local namecolors = {
		peasant  = {150, 103, 102},
		arken    = {4,   175, 236},
		admin    = {245, 205, 48},
		hidden   = {255, 0,   0},
	}
	if isog then
		namecolors.peasant = {128, 128, 128}
	end

	local namecolorshex = {}
	for i, v in pairs(namecolors) do
		namecolorshex[i] = "#" .. Color3.fromRGB(table.unpack(v)):ToHex()
	end

	-- ============================================================
	-- SEND CHAT HELPER
	-- ============================================================
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

	-- ============================================================
	-- ALE T / CHARACTER SETUP
	-- ============================================================
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

	-- ============================================================
	-- SPYCHAT — OnIncomingMessage
	-- ============================================================
	local TCO_PLACE_IDS = {
		11137575513,
		12943245078,
		12943247001,
		108097274488844,
	}

	local isTCO = false
	for _, id in ipairs(TCO_PLACE_IDS) do
		if game.PlaceId == id then isTCO = true; break end
	end

	if isTCO then
		TextChatService.OnIncomingMessage = function(mdata)
			local plr = mdata.TextSource
				and mdata.TextSource.UserId
				and Players:GetPlayerByUserId(mdata.TextSource.UserId)
			if not plr then return end

			-- Determine player colour category
			local cn
			if plr.Neutral == true then
				if plr:GetAttribute("Arken") == true then
					cn = "arken"
				else
					cn = "peasant"
				end
			else
				cn = "admin"
			end

			local muted = plr:HasTag("Muted")

			-- Handle muted players
			if muted then
				cn = "hidden"
				if not spychat then
					mdata.Text = ""
				end
			end

			-- Handle silent (;) commands
			local hidden = false
			if string.sub(mdata.Text, 1, 1) == ";" then
				if spychat then
					cn = "hidden"
					hidden = true
				else
					mdata.Text = ""
				end
			end

			-- Build icon
			local icon = ""
			if spychat then
				if hidden then
					icon = "🚫 "
				elseif muted then
					icon = "🤐 "
				end
			end

			-- Apply coloured name prefix
			local r   = namecolors[cn][1]
			local g   = namecolors[cn][2]
			local b   = namecolors[cn][3]
			local hex = namecolorshex[cn]
			local displayName = plr.DisplayName

			if isog then
				mdata.PrefixText = "<font color=\"" .. hex .. "\"><b><font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. icon .. "[" .. displayName .. "]: </font></b></font>"
			else
				mdata.PrefixText = "<font color=\"" .. hex .. "\"><i><font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. icon .. "(" .. displayName .. ") </font></i></font>"
			end
		end
	end

	-- ============================================================
	-- EXECUTE COMMAND
	-- ============================================================
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
			print("ALE F: OFF")

		-- ---- SPYCHAT ----
		elseif text == "spychat true" or text == "spychat t" then
			spychat = true
			print("SpyChat: ON")

		elseif text == "spychat false" or text == "spychat f" then
			spychat = false
			print("SpyChat: OFF")

		elseif text == "close" then
			_G.SCRIPTLOADEDCMDLINE = false
			task.wait(0.2)
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
