--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP
]=]

if _G.SCRIPTLOADEDCMDLINE == true then
	warn("Local player already executed the script")
	return
end

_G.SCRIPTLOADEDCMDLINE = true

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local antiinvis = false

local SPAWN_POS = Vector3.new(1.979060471057892e-09, 26.699996948242188, 7.257767720147967e-10)

local GLITCH_POS = Vector3.new(1234566.625, 1234470.375, 1234566.625)

local GLITCH_RADIUS = 100000

-- ============================================================
-- STASH SYSTEM (copied verbatim from your other script)
-- ============================================================
local seed = string.sub(game.JobId:gsub("%D+", ""), 1, 10)
local rng = Random.new(seed)
function randomoutlier(positiveonly)
	local ro = rng:NextInteger(5000, 10000)
	if positiveonly or rng:NextNumber() >= 0.5 then
		return ro
	else
		return -ro
	end
end

getgenv().stashposition = getgenv().stashposition or Vector3.new(
	randomoutlier(),
	randomoutlier(true) + 40,
	randomoutlier()
)

local invisstashplatform = getgenv().invisstashplatform or Instance.new("Part")
invisstashplatform.CFrame = CFrame.new(getgenv().stashposition - Vector3.new(0, 10, 0))
invisstashplatform.Anchored = true
invisstashplatform.Transparency = 0.9
invisstashplatform.Color = Color3.fromRGB(0, 255, 0)
invisstashplatform.Size = Vector3.new(200, 0, 1000)
invisstashplatform.CanCollide = true
invisstashplatform.Parent = workspace
getgenv().invisstashplatform = invisstashplatform

local stopstash = false
local isog = workspace:FindFirstChild("Cubes") ~= nil
local adminteam = (isog and game.Teams.Admin) or game.Teams.Chosen

-- ============================================================
-- HELPER FUNCTIONS FOR STASH (copied from your other script)
-- ============================================================
local function gcp(p, plr) -- get character part
	local c = (plr ~= nil and plr.Character) or localPlayer.Character
	p = p:lower()
	if p == "hrp" then
		p = "HumanoidRootPart"
	elseif p == "hum" then
		p = "Humanoid"
	end
	if c and c:FindFirstChild(p) then
		return c:FindFirstChild(p)
	else
		return false
	end
end

local function teleportto(cframe)
	local hrp = gcp("hrp")
	if hrp then
		if typeof(cframe) == "Vector3" then
			cframe = CFrame.new(cframe)
		end
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
		hrp.CFrame = cframe
	end
end

function henl()
	if localPlayer.Character:FindFirstChild("The Arkenstone") then
		return true
	else
		if localPlayer.Backpack:FindFirstChild("The Arkenstone") then
			return true
		end
	end
	return false
end

function eenl(unequipothers, equipenlighten)
	if not equipenlighten and localPlayer.Team == adminteam then
		return true
	end
	if unequipothers then
		for i, v in pairs(localPlayer.Character:GetChildren()) do
			if v:IsA("Tool") and v.Name ~= "The Arkenstone" then
				v.Parent = localPlayer.Backpack
			end
		end
	end
	if localPlayer.Character:FindFirstChild("The Arkenstone") then
		return true, localPlayer.Character["The Arkenstone"]
	else
		if localPlayer.Backpack:FindFirstChild("The Arkenstone") then
			localPlayer.Backpack["The Arkenstone"].Parent = localPlayer.Character
			return true, localPlayer.Character["The Arkenstone"]
		end
	end
	return false
end

function eb()
	if localPlayer.Character:FindFirstChild("BlueBucket") then
		return true, localPlayer.Character["BlueBucket"]
	else
		if localPlayer.Backpack:FindFirstChild("BlueBucket") then
			localPlayer.Backpack["BlueBucket"].Parent = localPlayer.Character
			return true, localPlayer.Character["BlueBucket"]
		end
	end
	return false
end

-- ============================================================
-- ORIGINAL SCRIPT STARTS HERE
-- ============================================================
if localPlayer.Name == "hotdogn_back" or localPlayer.Name == "TCORAIDS" or localPlayer.Name == "blacklistv2tco" then
	local Event = game:GetService("ReplicatedStorage").System
	firesignal(
		Event.OnClientEvent,
		"<font color='#4488ff'> This script is made by hot dogn and partially by TCORAIDS do cmds in the execute command box to get started | discord.gg/M8AzezvrsH </font>"
	)

	-- ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CmdLine2.0"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

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

	local textBox = Instance.new("TextBox")
	textBox.Name = "EnterCommands"
	textBox.PlaceholderText = "Put Command Here"
	textBox.Text = ""
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	textBox.BorderSizePixel = 0
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.TextScaled = true
	textBox.FontFace =
		Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
	textBox.Size = UDim2.new(0.81301, 0, 0.28571, 0)
	textBox.Position = UDim2.new(0.0935, 0, 0.36607, 0)
	textBox.Parent = mainFrame
	Instance.new("UICorner", textBox)

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
	local autoPickup = false
	local autoDelCubesAll = false
	local antiGlitch = false
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local isog = workspace:FindFirstChild("Cubes") ~= nil
	local ranksEnabled = true -- Default: ON

	-- ============================================================
	-- TCO COLOR TABLES
	-- ============================================================
	local namecolors = {
		peasant = { 150, 103, 102 },
		arken = { 4, 175, 236 },
		admin = { 245, 205, 48 },
		hidden = { 255, 0, 0 },
	}
	if isog then
		namecolors.peasant = { 128, 128, 128 }
	end

	local namecolorshex = {}
	for i, v in pairs(namecolors) do
		namecolorshex[i] = "#" .. Color3.fromRGB(table.unpack(v)):ToHex()
	end

	-- ============================================================
	-- SEND CHAT HELPER
	-- ============================================================
	local function sendChat(msg)
		local success = false
		pcall(function()
			local channels = TextChatService:FindFirstChild("TextChannels")
			if channels then
				local general = channels:FindFirstChild("RBXGeneral")
				if general then
					general:SendAsync(msg)
					success = true
				end
			end
		end)
		if not success then
			pcall(function()
				local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
				if chatEvents then
					local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
					if sayMessage then
						sayMessage:FireServer(msg, "All")
						success = true
					end
				end
			end)
		end
		if not success then
			pcall(function()
				localPlayer:Chat(msg)
			end)
		end
		print("sendChat:", msg, "| success:", success)
	end

	-- ============================================================
	-- STASH HELPER (uses sendChat and globals)
	-- ============================================================
	local function checkStash()
		if not henl() then
			stopstash = true
			return false
		end
		if not localPlayer:HasTag("Muted") then
			task.wait(0.5)
			sendChat(";mute me")
			task.wait(3.5)
		end
		return true
	end

	local function stashCommand(stashAmount)
		if not henl() then
			sendChat("You need enlighten to make a stash!")
			return
		end
		
		local oldAntiGlitch = antiGlitch
		antiGlitch = false
		task.wait(0.5)
		
		local lhrp = gcp("hrp")
		if not lhrp then
			return
		end
		
		local op = lhrp.CFrame
		local c = lhrp.Parent
		c:PivotTo(CFrame.new(getgenv().stashposition + Vector3.new(0, 30, 0)))
		
		if not localPlayer:HasTag("Muted") then
			task.wait(0.5)
			sendChat(";mute me")
		end
		task.wait(0.5)
		
		for i = 1, stashAmount do
			local cloneamt = #workspace.Clones[localPlayer.Name]:GetChildren()
			local fullstashamt = math.floor(cloneamt)
			local x = (fullstashamt % 4) * 10
			local y = math.floor(fullstashamt / 4) * 10
			
			c:PivotTo(CFrame.new(getgenv().stashposition + Vector3.new(x, 0, y)))
			task.wait(1)
			
			if not checkStash() then
				break
			end
			
			eenl(false, true)
			if not eb() then
				sendChat(";gear me 25162389")
				task.wait(1)
				eb()
				eenl(false, true)
			end
			
			if not checkStash() then
				break
			end
			
			sendChat(";freeze me")
			task.wait(1)
			
			if not checkStash() then
				break
			end
			
			sendChat(";clone me")
			task.wait(1)
			
			if not checkStash() then
				break
			end
			
			sendChat(";unfreeze me")
			c:PivotTo(CFrame.new(getgenv().stashposition + Vector3.new(x, 15, y)))
			
			for i = 1, 10 do
				task.wait(1)
				if not checkStash() then
					break
				end
			end
		end
		
		task.wait(1)
		sendChat(";unmute me")
		
		if gcp("hum") then
			task.wait(1)
			gcp("hum"):UnequipTools()
			task.wait(0.5)
			teleportto(op)
		end
		
		antiGlitch = oldAntiGlitch
	end

	-- ============================================================
	-- ALE T / CHARACTER SETUP
	-- ============================================================
	local function onDied()
		if not aleT then
			return
		end

		local char = localPlayer.Character
		if not char then
			return
		end

		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		local tool = char:FindFirstChild("The Arkenstone") or (backpack and backpack:FindFirstChild("The Arkenstone"))

		if not tool then
			return
		end

		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid:EquipTool(tool)
		end

		task.wait(0.3)
		sendChat(";r6")
	end

	local diedConnection = nil

	local function setupCharacter(char)
		char.ChildAdded:Connect(function(child)
			if child.Name == "Hielo" and antiFreeze then
				print("Player is frozen — killing")
				local humanoid = char:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.Health = 0
				end
			end
		end)

		local humanoid = char:WaitForChild("Humanoid")

		if diedConnection then
			diedConnection:Disconnect()
			diedConnection = nil
		end

		diedConnection = humanoid.Died:Connect(onDied)
	end

	setupCharacter(character)

	localPlayer.CharacterAdded:Connect(function(char)
		character = char
		setupCharacter(char)
	end)

	-- ============================================================
	-- AUTO PICKUP LOOP
	-- ============================================================
	task.spawn(function()
		while true do
			task.wait(0.1)
			if autoPickup then
				local char = localPlayer.Character
				if char then
					for _, v in pairs(workspace:GetChildren()) do
						if v:IsA("Tool") then
							local handle = v:FindFirstChild("Handle")
							if handle then
								firetouchinterest(handle, char.HumanoidRootPart, 0)
							end
						end
					end
				end
			end
		end
	end)

	-- ============================================================
	-- ANTI GLITCH LOOP
	-- ============================================================
	task.spawn(function()
		while task.wait(0.5) do
			if not antiGlitch then
				continue
			end
			local char = localPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp and (hrp.Position - GLITCH_POS).Magnitude <= GLITCH_RADIUS then
				warn("Glitch dimension detected!")
				hrp.CFrame = CFrame.new(SPAWN_POS)
			end
		end
	end)

	-- ============================================================
	-- AUTO DELCUBES ALL
	-- ============================================================
	local adaFired = false

	task.spawn(function()
		local hadArken = false
		while true do
			task.wait(1.5)
			if autoDelCubesAll and not adaFired then
				local char = localPlayer.Character
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				if not char or not backpack then
					hadArken = false
					continue
				end
				local inChar = char:FindFirstChild("The Arkenstone")
				local inBackpack = backpack:FindFirstChild("The Arkenstone")
				local hasNow = inChar ~= nil or inBackpack ~= nil
				if hasNow and not hadArken then
					hadArken = true
					adaFired = true
					local humanoid = char:FindFirstChildWhichIsA("Humanoid")
					if inBackpack and humanoid then
						humanoid:EquipTool(inBackpack)
						task.wait(1.75)
					end
					sendChat(";delcubes a")
					print("ADA: sent ;delcubes a")
				elseif not hasNow then
					hadArken = false
				end
			end
		end
	end)

	-- ============================================================
	-- ANTI INVIS LOOP
	-- ============================================================
	task.spawn(function()
		while task.wait(1) do
			if antiinvis then
				local char = localPlayer.Character
				if char then
					local head = char:FindFirstChild("Head")
					if head and (head.Transparency >= 1 or head.LocalTransparencyModifier >= 1) then
						print("Player is invisible - resetting")
						local humanoid = char:FindFirstChildWhichIsA("Humanoid")
						if humanoid then
							humanoid.Health = 0
						end
					end
				end
			end
		end
	end)

	-- ============================================================
	-- SPYCHAT
	-- ============================================================
	local TCO_PLACE_IDS = {
		11137575513,
		12943245078,
		12943247001,
		108097274488844,
	}

	local isTCO = false
	for _, id in ipairs(TCO_PLACE_IDS) do
		if game.PlaceId == id then
			isTCO = true
			break
		end
	end

	if isTCO then
		TextChatService.OnIncomingMessage = function(mdata)
			local plr = mdata.TextSource
				and mdata.TextSource.UserId
				and Players:GetPlayerByUserId(mdata.TextSource.UserId)
			if not plr then
				return
			end

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
			if muted then
				cn = "hidden"
				if not spychat then
					mdata.Text = ""
				end
			end

			local hidden = false
			if string.sub(mdata.Text, 1, 1) == ";" then
				if spychat then
					cn = "hidden"
					hidden = true
				else
					if plr ~= localPlayer then
						mdata.Text = ""
					end
				end
			end

			local icon = ""
			if spychat then
				if hidden then
					icon = "🚫 "
				elseif muted then
					icon = "🤐 "
				end
			end

			local r = namecolors[cn][1]
			local g = namecolors[cn][2]
			local b = namecolors[cn][3]
			local hex = namecolorshex[cn]
			local displayName = plr.DisplayName

			if isog then
				mdata.PrefixText = '<font color="'
					.. hex
					.. "\"><b><font color='rgb("
					.. r
					.. ","
					.. g
					.. ","
					.. b
					.. ")'>"
					.. icon
					.. "["
					.. displayName
					.. "]: </font></b></font>"
			else
				mdata.PrefixText = '<font color="'
					.. hex
					.. "\"><i><font color='rgb("
					.. r
					.. ","
					.. g
					.. ","
					.. b
					.. ")'>"
					.. icon
					.. "("
					.. displayName
					.. ") </font></i></font>"
			end
		end
	end

	-- ============================================================
	-- FLING
	-- ============================================================
	local flingActive = false
	getgenv().OldPos = getgenv().OldPos or nil
	getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight

	local function SkidFling(targetPlayer)
		local char = localPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = hum and hum.RootPart
		local tChar = targetPlayer.Character
		if not tChar then
			return
		end

		local tHum = tChar:FindFirstChildOfClass("Humanoid")
		local tRoot = tHum and tHum.RootPart
		local tHead = tChar:FindFirstChild("Head")
		local accessory = tChar:FindFirstChildOfClass("Accessory")
		local handle = accessory and accessory:FindFirstChild("Handle")

		if not (char and hum and root) then
			return
		end

		if root.Velocity.Magnitude < 50 then
			getgenv().OldPos = root.CFrame
		end

		if tHum and tHum.Sit then
			return
		end

		if tHead then
			workspace.CurrentCamera.CameraSubject = tHead
		elseif handle then
			workspace.CurrentCamera.CameraSubject = handle
		elseif tHum then
			workspace.CurrentCamera.CameraSubject = tHum
		end

		if not tChar:FindFirstChildWhichIsA("BasePart") then
			return
		end

		local function FPos(basePart, pos, ang)
			root.CFrame = CFrame.new(basePart.Position) * pos * ang
			char:SetPrimaryPartCFrame(CFrame.new(basePart.Position) * pos * ang)
			root.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end

		local function SFBasePart(basePart)
			local timeToWait = 2
			local t = tick()
			local angle = 0
			repeat
				if root and tHum then
					if basePart.Velocity.Magnitude < 50 then
						angle = angle + 100
						FPos(
							basePart,
							CFrame.new(0, 1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25,
							CFrame.Angles(math.rad(angle), 0, 0)
						)
						task.wait()
						FPos(
							basePart,
							CFrame.new(0, -1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25,
							CFrame.Angles(math.rad(angle), 0, 0)
						)
						task.wait()
						FPos(
							basePart,
							CFrame.new(0, 1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25,
							CFrame.Angles(math.rad(angle), 0, 0)
						)
						task.wait()
						FPos(
							basePart,
							CFrame.new(0, -1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25,
							CFrame.Angles(math.rad(angle), 0, 0)
						)
						task.wait()
						FPos(basePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
						task.wait()
						FPos(
							basePart,
							CFrame.new(0, -1.5, 0) + tHum.MoveDirection,
							CFrame.Angles(math.rad(angle), 0, 0)
						)
						task.wait()
					else
						FPos(basePart, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, -1.5, -tHum.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(basePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				end
			until t + timeToWait < tick() or not flingActive
		end

		workspace.FallenPartsDestroyHeight = 0 / 0

		local bv = Instance.new("BodyVelocity")
		bv.Parent = root
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if tRoot then
			SFBasePart(tRoot)
		elseif tHead then
			SFBasePart(tHead)
		elseif handle then
			SFBasePart(handle)
		end

		bv:Destroy()
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = hum

		if getgenv().OldPos then
			repeat
				root.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
				char:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
				hum:ChangeState("GettingUp")
				for _, part in pairs(char:GetChildren()) do
					if part:IsA("BasePart") then
						part.Velocity = Vector3.new()
						part.RotVelocity = Vector3.new()
					end
				end
				task.wait()
			until (root.Position - getgenv().OldPos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		end
	end

	-- ============================================================
	-- BTOOLS HELPER
	-- ============================================================
	local function findbtoolsGlobal(name)
		local btools = {}
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		local char = localPlayer.Character
		if backpack then
			for _, v in pairs(backpack:GetChildren()) do
				if
					v:IsA("Tool")
					and v:FindFirstChild("Script")
					and v.Script:FindFirstChild("Event")
					and v.Name == name
				then
					table.insert(btools, { bt = v, e = v.Script.Event })
				end
			end
		end
		if char then
			for _, v in pairs(char:GetChildren()) do
				if
					v:IsA("Tool")
					and v:FindFirstChild("Script")
					and v.Script:FindFirstChild("Event")
					and v.Name == name
				then
					table.insert(btools, { bt = v, e = v.Script.Event })
				end
			end
		end
		return btools
	end

	-- ============================================================
	-- GRIEF / DELETE AURA
	-- ============================================================
	local griefActive = false

	local function startGriefAura()
		griefActive = true
		local cfolder = isog and workspace:FindFirstChild("Cubes") or workspace:FindFirstChild("Bricks")
		task.spawn(function()
			while griefActive do
				local s, e = pcall(function()
					local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp and cfolder then
						local dtools = findbtoolsGlobal("Delete")
						if #dtools > 0 then
							for _, p in pairs(Players:GetPlayers()) do
								if p ~= localPlayer and p.Character then
									local hrp2 = p.Character:FindFirstChild("HumanoidRootPart")
									if hrp2 then
										local cubes = {}
										for _, v in pairs(cfolder:GetDescendants()) do
											if v:IsA("BasePart") then
												table.insert(cubes, { v, (v.Position - hrp2.Position).Magnitude })
											end
										end
										table.sort(cubes, function(a, b)
											return a[2] < b[2]
										end)
										for _, v in pairs(cubes) do
											if not griefActive then
												break
											end
											local dt = dtools[math.random(#dtools)]
											dt.bt.Parent = localPlayer.Character
											if isog then
												dt.e:FireServer(
													hrp.Position,
													Enum.NormalId.Top,
													v[1],
													Color3.new(0, 0, 0),
													"Smooth"
												)
											else
												dt.e:FireServer(v[1], hrp.Position)
											end
											task.wait(0.1)
										end
									end
								end
							end
						end
					end
				end)
				if not s then
					warn(e)
				end
				task.wait()
			end
		end)
	end

	-- ============================================================
	-- SIGN AURA
	-- ============================================================
	local signAuraActive = false

	local function startSignAura()
		signAuraActive = true
		task.spawn(function()
			local sti = 0
			while signAuraActive do
				local s, e = pcall(function()
					local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						local signs = findbtoolsGlobal("Sign")
						while #signs > 0 and signAuraActive do
							sti = sti + 1
							local randompos = hrp.Position
								+ CFrame.lookAt(
										Vector3.zero,
										Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
									).LookVector
									* 20
							local st = signs[(sti % #signs) + 1]
							st.bt.Parent = localPlayer.Character
							if isog then
								st.e:FireServer(
									randompos,
									Enum.NormalId.Top,
									workspace:FindFirstChild("Trrain") and workspace.Trrain:FindFirstChild("Mesh", true)
										or workspace.Terrain,
									Color3.new(1, 1, 1),
									"Smooth"
								)
							else
								st.e:FireServer(workspace.Terrain, Enum.NormalId.Top, randompos)
							end
							task.wait(0.1)
							signs = findbtoolsGlobal("Sign")
						end
					end
				end)
				if not s then
					warn(e)
				end
				task.wait()
			end
		end)
	end

	-- ============================================================
	-- UNANCHOR AURA
	-- ============================================================
	local unanchorAuraActive = false

	local function startUnanchorAura()
		unanchorAuraActive = true
		local cfolder = isog and workspace:FindFirstChild("Cubes") or workspace:FindFirstChild("Bricks")
		task.spawn(function()
			local pti = 0
			while unanchorAuraActive do
				local s, e = pcall(function()
					local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp and cfolder then
						local paints = findbtoolsGlobal("Paint")
						if #paints > 0 then
							local cubes = {}
							for _, v in pairs(cfolder:GetDescendants()) do
								if v:IsA("BasePart") and v.Anchored == true then
									table.insert(cubes, { v, (v.Position - hrp.Position).Magnitude })
								end
							end
							table.sort(cubes, function(a, b)
								return a[2] < b[2]
							end)
							for _, v in pairs(cubes) do
								if not unanchorAuraActive then
									break
								end
								pti = pti + 1
								local pt = paints[(pti % #paints) + 1]
								pt.bt.Parent = localPlayer.Character
								pt.e:FireServer(
									v[1],
									Enum.NormalId.Top,
									hrp.Position,
									"material",
									Color3.new(0, 0, 0),
									"anchor",
									""
								)
								task.wait(0.1)
							end
						end
					end
				end)
				if not s then
					warn(e)
				end
				task.wait()
			end
		end)
	end

	-- ============================================================
	-- SPRAY AURA
	-- ============================================================
	local sprayAuraActive = false

	local function startSprayAura()
		sprayAuraActive = true
		local cfolder = isog and workspace:FindFirstChild("Cubes") or workspace:FindFirstChild("Bricks")
		task.spawn(function()
			local pti = 0
			while sprayAuraActive do
				local s, e = pcall(function()
					local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp and cfolder then
						local paints = findbtoolsGlobal("Paint")
						if #paints > 0 then
							local cubes = {}
							for _, v in pairs(cfolder:GetDescendants()) do
								if v:IsA("BasePart") then
									table.insert(cubes, { v, (v.Position - hrp.Position).Magnitude })
								end
							end
							table.sort(cubes, function(a, b)
								return a[2] < b[2]
							end)
							local sides = {
								Enum.NormalId.Front,
								Enum.NormalId.Back,
								Enum.NormalId.Left,
								Enum.NormalId.Right,
								Enum.NormalId.Top,
							}
							for _, v in pairs(cubes) do
								if not sprayAuraActive then
									break
								end
								pti = pti + 1
								local pt = paints[(pti % #paints) + 1]
								pt.bt.Parent = localPlayer.Character
								pt.e:FireServer(
									v[1],
									sides[math.random(#sides)],
									hrp.Position,
									"both \u{1F91D}",
									Color3.fromRGB(30, 245, 2),
									"spray",
									"raided by hotdogn and tcoraids"
								)
								task.wait(0.1)
							end
						end
					end
				end)
				if not s then
					warn(e)
				end
				task.wait()
			end
		end)
	end

	-- ============================================================
	-- IY BANG
	-- ============================================================
	local bangAnim = nil
	local bangTrack = nil
	local bangDied = nil
	local bangLoop = nil

	local function stopBang()
		if bangDied then
			bangDied:Disconnect()
			bangDied = nil
		end
		if bangLoop then
			bangLoop:Disconnect()
			bangLoop = nil
		end
		if bangTrack then
			bangTrack:Stop()
			bangTrack = nil
		end
		if bangAnim then
			bangAnim:Destroy()
			bangAnim = nil
		end
	end

	local function startBang(targetName, speed)
		stopBang()
		task.wait()

		local char = localPlayer.Character
		local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
		if not humanoid then
			return
		end

		local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15

		bangAnim = Instance.new("Animation")
		bangAnim.AnimationId = not isR15 and "rbxassetid://148840371" or "rbxassetid://5918726674"
		bangTrack = humanoid:LoadAnimation(bangAnim)
		bangTrack:Play(0.1, 1, 1)
		bangTrack:AdjustSpeed(speed or 3)

		bangDied = humanoid.Died:Connect(function()
			stopBang()
		end)

		if targetName then
			local target = nil
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= localPlayer then
					if
						p.Name:lower():sub(1, #targetName) == targetName:lower()
						or p.DisplayName:lower():sub(1, #targetName) == targetName:lower()
					then
						target = p
						break
					end
				end
			end

			if target then
				local bangOffset = CFrame.new(0, 0, 1.1)
				bangLoop = RunService.Stepped:Connect(function()
					pcall(function()
						local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
						local otherHrp = target.Character
							and (
								target.Character:FindFirstChild("HumanoidRootPart")
								or target.Character:FindFirstChild("Torso")
							)
						if myHrp and otherHrp then
							myHrp.CFrame = otherHrp.CFrame * bangOffset
						end
					end)
				end)
			end
		end
	end

	-- ============================================================
	-- FIXED PRESENCE + BILLBOARD
	-- ============================================================

	local HttpService = game:GetService("HttpService")
	local RunService = game:GetService("RunService")

	local SERVER_URL = "http://82.30.76.135:3000"
	local BILLBOARD_NAME = "PremiumBillboard"

	local specialUsers = {
		["hotdogn_back"] = { color = Color3.fromRGB(255, 215, 0), text = "👑 OWNER" },
		["TCORAIDS"] = { color = Color3.fromRGB(0, 255, 255), text = "⭐ NIGGER" },
	}

	-- userId (string) -> true, populated by polling /presence
	local activePresence = {}

	local function escapeRichText(s)
		return tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	end

	-- ── Billboard ────────────────────────────────────────────────
	local function removeBillboard(player)
		if not player.Character then
			return
		end
		local head = player.Character:FindFirstChild("Head")
		if not head then
			return
		end
		local old = head:FindFirstChild(BILLBOARD_NAME)
		if old then
			old:Destroy()
		end
	end

	local function createBillboard(player)
		if not ranksEnabled then
			return
		end
		if not player.Character then
			return
		end
		local head = player.Character:FindFirstChild("Head")
		if not head then
			return
		end

		-- Only show billboard if: it's the local player, OR they appear in /presence
		local isLocal = (player == localPlayer)
		local hasPresence = activePresence[tostring(player.UserId)] == true

		if not isLocal and not hasPresence then
			return
		end

		-- Remove stale one first
		local old = head:FindFirstChild(BILLBOARD_NAME)
		if old then
			old:Destroy()
		end

		local billboard = Instance.new("BillboardGui")
		billboard.Name = BILLBOARD_NAME
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, 300, 0, 95)
		billboard.StudsOffset = Vector3.new(0, 5.5, 0)
		billboard.AlwaysOnTop = true

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 0.35
		frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
		frame.Parent = billboard

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 16)
		corner.Parent = frame

		local special = specialUsers[player.Name]
		local displayText = special and special.text or "🟢 ONLINE"
		local textColor = special and special.color or Color3.fromRGB(0, 255, 140)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0.55, 0)
		label.Position = UDim2.new(0, 0, 0.08, 0)
		label.BackgroundTransparency = 1
		label.Text = displayText
		label.TextColor3 = textColor
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.TextStrokeTransparency = 0.2
		label.Parent = frame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, 0, 0.45, 0)
		nameLabel.Position = UDim2.new(0, 0, 0.55, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = "@" .. escapeRichText(player.Name)
		nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.Parent = frame

		billboard.Parent = head
	end

	-- ── Heartbeat: send localPlayer presence every 8s ────────────
	task.spawn(function()
		while true do
			pcall(function()
				local payload = HttpService:JSONEncode({
					userId = tostring(localPlayer.UserId),
					username = localPlayer.Name,
					status = "playing",
					placeId = tostring(game.PlaceId),
					jobId = game.JobId or "N/A",
					playerCount = #Players:GetPlayers(),
					lastHeartbeat = tick() * 1000,
				})
				request({
					Url = SERVER_URL .. "/presence",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = payload,
				})
			end)
			task.wait(8)
		end
	end)

	-- ── Poll /presence every 6s, refresh all billboards on change ─
	task.spawn(function()
		while true do
			pcall(function()
				local raw = game:HttpGet(SERVER_URL .. "/presence")
				local data = HttpService:JSONDecode(raw)

				local newPresence = {}
				for _, entry in ipairs(data) do
					if entry.userId then
						newPresence[tostring(entry.userId)] = true
					end
				end

				-- Detect changes — only redraw if the set changed
				local changed = false
				for k in pairs(newPresence) do
					if not activePresence[k] then
						changed = true
						break
					end
				end
				if not changed then
					for k in pairs(activePresence) do
						if not newPresence[k] then
							changed = true
							break
						end
					end
				end

				activePresence = newPresence

				if changed then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= localPlayer then
							if activePresence[tostring(p.UserId)] then
								createBillboard(p)
							else
								removeBillboard(p)
							end
						end
					end
				end
			end)
			task.wait(6)
		end
	end)

	-- ── Wire up existing and future players ──────────────────────
	local function onCharacterAdded(player)
		task.wait(1.5)
		createBillboard(player)
	end

	for _, p in ipairs(Players:GetPlayers()) do
		createBillboard(p)
		p.CharacterAdded:Connect(function()
			onCharacterAdded(p)
		end)
	end

	Players.PlayerAdded:Connect(function(p)
		createBillboard(p)
		p.CharacterAdded:Connect(function()
			onCharacterAdded(p)
		end)
	end)

	Players.PlayerRemoving:Connect(function(p)
		-- Nothing to clean up; character is gone by the time this fires
	end)

	print("✅ Presence Billboard System Loaded")

	-- ── Remote kick polling loop ──────────────────────────────────
	task.spawn(function()
		while true do
			pcall(function()
				local raw = game:HttpGet(SERVER_URL .. "/kick")
				print("[KICK POLL RAW]", raw)
				local data = HttpService:JSONDecode(raw)
				if data.pending and data.pending.target then
					local query = data.pending.target:lower()
					for _, p in ipairs(Players:GetPlayers()) do
						if p.Name:lower() == query or p.DisplayName:lower() == query then
							p:Kick("You have been kicked by this experience or its moderators")
							print("[REMOTE KICK]", p.Name)
							warn("Broke Anti Cheat (Fake Fly via Atribute)")
							break
						end
					end
				end
			end)
			task.wait(3)
		end
	end)

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
			if humanoid then
				humanoid.Health = 0
			end
		elseif text == "rejoin" or text == "rj" then
			TeleportService:Teleport(game.PlaceId, localPlayer)
			queue_on_teleport(
				'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()'
			)
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
			if blur then
				blur.Enabled = false
			end
		elseif text == "antimyopic false" or text == "antimyopic f" then
			local blur = Lighting:FindFirstChild("Blur")
			if blur then
				blur.Enabled = true
			end
		elseif text == "ale t" then
			aleT = true
			print("ALE T: ON")
		elseif text == "ale f" then
			aleT = false
			print("ALE F: OFF")
		elseif text:sub(1, 6) == "speed " then
			local speed = tonumber(text:sub(7))
			if speed then
				local char = localPlayer.Character
				local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = speed
					print("WalkSpeed set to", speed)
				end
			else
				warn("Usage: speed <number>")
			end
		elseif text:sub(1, 4) == "bang" then
			local parts = text:sub(6):gsub("^%s+", ""):gsub("%s+$", "")
			local args = string.split(parts, " ")
			local targetName = args[1] ~= "" and args[1] or nil
			local speed = tonumber(args[2]) or 3
			startBang(targetName, speed)
			print("Bang: ON")
		elseif text == "unbang" then
			stopBang()
			print("Bang: OFF")
		elseif text == "antiglitch true" or text == "antiglitch t" or text == "ag true" or text == "ag t" then
			antiGlitch = true
			print("Anti Glitch: ON")
		elseif text == "antiglitch false" or text == "antiglitch f" or text == "ag false" or text == "ag f" then
			antiGlitch = false
			print("Anti Glitch: OFF")
		elseif text == "dela" then
			startGriefAura()
			print("DeleteAura: ON")
		elseif text == "undela" then
			griefActive = false
			print("DeleteAura: OFF")
		elseif text == "ranksenable t" or text == "re t" or text == "ranks t" then
			ranksEnabled = true
			print("Ranks / Billboards: ENABLED")
			for _, p in ipairs(Players:GetPlayers()) do
				createBillboard(p)
			end
		elseif text == "ranksenable f" or text == "re f" or text == "ranks f" then
			ranksEnabled = false
			print("Ranks / Billboards: DISABLED")
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character then
					local head = p.Character:FindFirstChild("Head")
					if head then
						local old = head:FindFirstChild(BILLBOARD_NAME)
						if old then
							old:Destroy()
						end
					end
				end
			end
		elseif text:sub(1, 5) == "kick " then
			local query = text:sub(6):gsub("^%s+", ""):gsub("%s+$", "")
			pcall(function()
				request({
					Url = SERVER_URL .. "/kick",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService:JSONEncode({ target = query }),
				})
			end)
			print("Kick queued:", query)
		elseif text == "sia" or text == "signaura" then
			startSignAura()
			print("SignAura: ON")
		elseif text == "unsia" or text == "unsignaura" then
			signAuraActive = false
			print("SignAura: OFF")
		elseif text == "uaa" or text == "unanchoraura" then
			startUnanchorAura()
			print("UnanchorAura: ON")
		elseif text == "unuaa" or text == "ununanchoraura" then
			unanchorAuraActive = false
			print("UnanchorAura: OFF")
		elseif text == "spray" or text == "sprayaura" then
			startSprayAura()
			print("SprayAura: ON")
		elseif text == "unspray" or text == "unsprayaura" then
			sprayAuraActive = false
			print("SprayAura: OFF")
		elseif text:sub(1, 5) == "fling" then
			local query = text:sub(7):gsub("^%s+", ""):gsub("%s+$", "")
			local lowerQuery = query:lower()
			local target = nil
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= localPlayer then
					if p.Name:lower() == lowerQuery or p.DisplayName:lower() == lowerQuery then
						target = p
						break
					end
				end
			end
			if not target then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= localPlayer then
						if
							p.Name:lower():sub(1, #lowerQuery) == lowerQuery
							or p.DisplayName:lower():sub(1, #lowerQuery) == lowerQuery
						then
							target = p
							break
						end
					end
				end
			end
			if target then
				flingActive = true
				task.spawn(function()
					SkidFling(target)
					flingActive = false
				end)
				print("Flinging:", target.Name)
			else
				print("fling: no target for '" .. query .. "'")
			end
		elseif text == 'fixvamp' then
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			workspace.CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character.Humanoid
			local StarterGui = game:GetService("StarterGui")

			pcall(function()
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			end)
		elseif text == "fling stop" or text == "unfling" then
			flingActive = false
			print("Fling stopped")
		elseif text == "autopickup true" or text == "autopickup t" then
			autoPickup = true
			print("Auto Pickup: ON")
		elseif text == "autopickup false" or text == "autopickup f" then
			autoPickup = false
			print("Auto Pickup: OFF")
		elseif text == "autodelcubesall true" or text == "autodelcubesall t" or text == "ada t" then
			autoDelCubesAll = true
			print("Auto DelCubes All: ON")
		elseif text == "autodelcubesall false" or text == "autodelcubesall f" or text == "ada f" then
			autoDelCubesAll = false
			print("Auto DelCubes All: OFF")
		elseif text:sub(1, 5) == "goto " then
			local query = text:sub(6):gsub("^%s+", ""):gsub("%s+$", "")
			local lowerQuery = query:lower()
			local found = nil
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= localPlayer then
					if p.Name:lower() == lowerQuery or p.DisplayName:lower() == lowerQuery then
						found = p
						break
					end
				end
			end
			if not found then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= localPlayer then
						if
							p.Name:lower():sub(1, #lowerQuery) == lowerQuery
							or p.DisplayName:lower():sub(1, #lowerQuery) == lowerQuery
						then
							found = p
							break
						end
					end
				end
			end
			if found then
				local targetChar = workspace:FindFirstChild(found.Name)
				local myChar = localPlayer.Character
				if targetChar and myChar then
					local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
					local myRoot = myChar:FindFirstChild("HumanoidRootPart")
					if targetRoot and myRoot then
						myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 3)
					end
				end
			else
				print("goto: player not found for query '" .. query .. "'")
			end
		elseif text == "cmds" then
			local Event = game:GetService("ReplicatedStorage").System
			pcall(function()
				firesignal(
					Event.OnClientEvent,
					"<font color='#4488ff'>fly, unfly, reset, rejoin, getjobid, speed, goto, fling, unfling, bang, unbang, dela(Delete aura), undela, sia(sign aura), unsia, uaa(anchor aura), unuaa(unanchor aura), spray(gives credits to TCORAIDS and hotdogn), unspray, autopickup(usecase autopickup t), ada(when get enlighten it delcubes), antifreeze, antiblind, antimyopic, antiglitch, antiinvis, spychat, ale(anti loose death on enlighten), ranks(enable/disable billboards), stash, stopstash, tostash, stashplatform, unstashplatform, close, cmds</font>"
				)
			end)
			textBox.Text = ""
			return
		elseif text == "spychat true" or text == "spychat t" then
			spychat = true
			print("SpyChat: ON")
		elseif text == "spychat false" or text == "spychat f" then
			spychat = false
			print("SpyChat: OFF")
		elseif
			text == "antiinvis true"
			or text == "antiinvis t"
			or text == "antiinvisible true"
			or text == "antiinvisible t"
		then
			antiinvis = true
			print("Anti Invisible: ON")
		elseif
			text == "antiinvis false"
			or text == "antiinvis f"
			or text == "antiinvisible false"
			or text == "antiinvisible f"
		then
			antiinvis = false
			print("Anti Invisible: OFF")
		elseif text == "jerkoff" or text == "goon" then
			local speaker = localPlayer
			local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local backpack = speaker:FindFirstChildWhichIsA("Backpack")
			if not humanoid or not backpack then
				return
			end

			local function r15(player)
				local character = player.Character
				local hum = character and character:FindFirstChildOfClass("Humanoid")
				return hum and hum.RigType == Enum.HumanoidRigType.R15
			end

			local tool = Instance.new("Tool")
			tool.Name = "Jerk Off"
			tool.RequiresHandle = false
			tool.Parent = backpack

			local jorkin = false
			local track = nil

			local function stopTomfoolery()
				jorkin = false
				if track then
					track:Stop()
					track = nil
				end
			end

			tool.Equipped:Connect(function()
				jorkin = true
			end)
			tool.Unequipped:Connect(stopTomfoolery)
			humanoid.Died:Connect(stopTomfoolery)

			task.spawn(function()
				while task.wait() do
					if not jorkin then
						continue
					end
					local isR15 = r15(speaker)
					if not track then
						local anim = Instance.new("Animation")
						anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
						track = humanoid:LoadAnimation(anim)
					end
					track:Play()
					track:AdjustSpeed(isR15 and 0.7 or 0.65)
					track.TimePosition = 0.6
					task.wait(0.1)
					while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do
						task.wait(0.1)
					end
					if track then
						track:Stop()
						track = nil
					end
				end
			end)


elseif text == "shop" then
	task.spawn(function()
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local universeId = game.GameId -- or use game.PlaceId? Actually placeId is the asset ID, but for servers we need universeId. Use game.GameId which is the universe ID.
		local url = "https://games.roblox.com/v1/games/" .. universeId .. "/servers/Public?limit=100"
		local success, data = pcall(function()
			return HttpService:GetAsync(url)
		end)
		if success and data then
			local decoded = HttpService:JSONDecode(data)
			local servers = decoded.data
			if servers and #servers > 0 then
				-- filter out current server (jobId)
				local currentJobId = game.JobId
				local otherServers = {}
				for _, s in ipairs(servers) do
					if s.id ~= currentJobId then
						table.insert(otherServers, s)
					end
				end
				if #otherServers == 0 then
					-- fallback to any server
					otherServers = servers
				end
				local chosen = otherServers[math.random(1, #otherServers)]
				local accessCode = chosen.accessCode or chosen.id -- sometimes accessCode is provided
				if accessCode then
					TeleportService:TeleportToPrivateServer(game.PlaceId, accessCode, {localPlayer})
					queue_on_teleport(
						'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()'
					)
					print("Hopping to server:", chosen.id)
				else
					-- fallback to regular teleport
					TeleportService:Teleport(game.PlaceId, localPlayer)
					queue_on_teleport(
						'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()'
					)
					print("Fallback teleport to new server")
				end
			else
				-- fallback
				TeleportService:Teleport(game.PlaceId, localPlayer)
				queue_on_teleport(
					'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()'
				)
			end
		else
			-- fallback
			TeleportService:Teleport(game.PlaceId, localPlayer)
			queue_on_teleport(
				'loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/CMDLINE2.0.luau"))()'
			)
		end
	end)
	print("Attempting to hop to a different server...")

		elseif text == "close" then
			_G.SCRIPTLOADEDCMDLINE = false
			task.wait(0.2)
			screenGui:Destroy()
			return
		-- ============================================================
		-- STASH COMMANDS (exactly as in your other script)
		-- ============================================================
		elseif text == "stash" or text:sub(1, 6) == "stash " then
			local amount = 2
			if text:sub(1, 6) == "stash " then
				local num = tonumber(text:sub(7))
				if num and num > 0 then
					amount = num
				end
			end
			task.spawn(function()
				stashCommand(amount)
			end)
			print("Stash started with amount:", amount)
		elseif text == "stopstash" or text == "unstash" then
			stopstash = true
			print("Stash stopped")
		elseif text == "tostash" or text == "gotostash" then
			local hrp = gcp("hrp")
			if hrp then
				teleportto(CFrame.new(getgenv().stashposition + Vector3.new(-20, 30, -20)))
			end
		elseif text == "stashplatform" then
			invisstashplatform.Transparency = 0.9
			invisstashplatform.CanCollide = true
			print("Stash platform: ON")
		elseif text == "unstashplatform" then
			invisstashplatform.Transparency = 1
			invisstashplatform.CanCollide = false
			print("Stash platform: OFF")
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
		if gameProcessed then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			mainFrame.Visible = not mainFrame.Visible
		elseif input.KeyCode == Enum.KeyCode.Semicolon then
			mainFrame.Visible = true
			task.wait()
			textBox:CaptureFocus()
		end
	end)
end
