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
	return
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

local antiinvis = false

local SPAWN_POS = Vector3.new(
    1.979060471057892e-09,
    26.699996948242188,
    7.257767720147967e-10
)

local GLITCH_POS = Vector3.new(
    1234566.625,
    1234470.375,
    1234566.625
)

local GLITCH_RADIUS = 100000 -- 100k studs

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
	local autoPickup = false
	local autoPickupLoop = nil
	local autoDelCubesAll = false
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local antiGlitch = false
	local griefaround = nil

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
-- ============================================================
	-- SEND CHAT HELPER
	-- ============================================================
	local function sendChat(msg)
		local success = false

		pcall(function()
			local tcs = game:GetService("TextChatService")
			local channels = tcs:FindFirstChild("TextChannels")
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
				local rs = game:GetService("ReplicatedStorage")
				local chatEvents = rs:FindFirstChild("DefaultChatSystemChatEvents")
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
				game:GetService("Players").LocalPlayer:Chat(msg)
			end)
		end

		print("sendChat:", msg, "| success:", success)
	end

	-- ============================================================
	-- ALE T / CHARACTER SETUP
	-- ============================================================
	local antiGlitch = false

	
	local function setupCharacter(char)
		char.ChildAdded:Connect(function(child)
			if child.Name == "Hielo" and antiFreeze then
				print("Player is frozen — killing")
				local humanoid = char:FindFirstChild("Humanoid")
				if humanoid then humanoid.Health = 0 end
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

	task.spawn(function()
    while task.wait(0.5) do
        if not antiGlitch then
            continue
        end

        local char = game.Players.LocalPlayer.Character
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

				-- only trigger when player JUST got it (didnt have it before)
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
					if plr ~= localPlayer then
						mdata.Text = ""
					end
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


	-- paste this above the executeCommand function
local flingActive = false
getgenv().OldPos = getgenv().OldPos or nil
getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight

local function SkidFling(targetPlayer)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = hum and hum.RootPart
    local tChar = targetPlayer.Character
    if not tChar then return end

    local tHum = tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tHum and tHum.RootPart
    local tHead = tChar:FindFirstChild("Head")
    local accessory = tChar:FindFirstChildOfClass("Accessory")
    local handle = accessory and accessory:FindFirstChild("Handle")

    if not (char and hum and root) then return end

    if root.Velocity.Magnitude < 50 then
        getgenv().OldPos = root.CFrame
    end

    if tHum and tHum.Sit then return end

    if tHead then
        workspace.CurrentCamera.CameraSubject = tHead
    elseif handle then
        workspace.CurrentCamera.CameraSubject = handle
    elseif tHum then
        workspace.CurrentCamera.CameraSubject = tHum
    end

    if not tChar:FindFirstChildWhichIsA("BasePart") then return end

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
                    FPos(basePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    FPos(basePart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    FPos(basePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    FPos(basePart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    FPos(basePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    FPos(basePart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
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

    workspace.FallenPartsDestroyHeight = 0/0

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

local function findbtoolsGlobal(name)
		local btools = {}
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		local char = localPlayer.Character
		if backpack then
			for _, v in pairs(backpack:GetChildren()) do
				if v:IsA("Tool") and v:FindFirstChild("Script") and v.Script:FindFirstChild("Event") and v.Name == name then
					table.insert(btools, {bt=v, e=v.Script.Event})
				end
			end
		end
		if char then
			for _, v in pairs(char:GetChildren()) do
				if v:IsA("Tool") and v:FindFirstChild("Script") and v.Script:FindFirstChild("Event") and v.Name == name then
					table.insert(btools, {bt=v, e=v.Script.Event})
				end
			end
		end
		return btools
	end

	local griefActive = false

local function startGriefAura()
		griefActive = true
		local isog = workspace:FindFirstChild("Cubes") ~= nil
		local cfolder = isog and workspace.Cubes or workspace:FindFirstChild("Bricks")
		task.spawn(function()
			while griefActive do
				local s, e = pcall(function()
					local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if hrp and cfolder then
						local dtools = findbtoolsGlobal("Delete")
						if #dtools > 0 then
							-- gather and sort cubes by distance to each player
							for _, p in pairs(Players:GetPlayers()) do
								if p ~= localPlayer and p.Character then
									local hrp2 = p.Character:FindFirstChild("HumanoidRootPart")
									if hrp2 then
										local cubes = {}
										for _, v in pairs(cfolder:GetDescendants()) do
											if v:IsA("BasePart") then
												table.insert(cubes, {v, (v.Position - hrp2.Position).Magnitude})
											end
										end
										table.sort(cubes, function(a, b) return a[2] < b[2] end)
										for _, v in pairs(cubes) do
											if not griefActive then break end
											local dt = dtools[math.random(#dtools)]
											dt.bt.Parent = localPlayer.Character
											if isog then
												dt.e:FireServer(hrp.Position, Enum.NormalId.Top, v[1], Color3.new(0,0,0), "Smooth")
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
				if not s then warn(e) end
				task.wait()
			end
		end)
	end

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
							local randompos = hrp.Position + CFrame.lookAt(Vector3.zero, Vector3.new(math.random(-1,1), 0, math.random(-1,1)).Unit).LookVector * 20
							local st = signs[(sti % #signs) + 1]
							st.bt.Parent = localPlayer.Character
							if isog then
								st.e:FireServer(randompos, Enum.NormalId.Top, workspace.Trrain and workspace.Trrain:FindFirstChild("Mesh", true) or workspace.Terrain, Color3.new(1,1,1), "Smooth")
							else
								st.e:FireServer(workspace.Terrain, Enum.NormalId.Top, randompos)
							end
							task.wait(0.1)
							signs = findbtoolsGlobal("Sign")
						end
					end
				end)
				if not s then warn(e) end
				task.wait()
			end
		end)
	end

	local unanchorAuraActive = false

	local function startUnanchorAura()
		unanchorAuraActive = true
		local cfolder = isog and workspace.Cubes or workspace:FindFirstChild("Bricks")
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
									table.insert(cubes, {v, (v.Position - hrp.Position).Magnitude})
								end
							end
							table.sort(cubes, function(a, b) return a[2] < b[2] end)
							for _, v in pairs(cubes) do
								if not unanchorAuraActive then break end
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
				if not s then warn(e) end
				task.wait()
			end
		end)
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

			elseif text == "chattest" then
             sendChat("hello")

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

	elseif text == "antiglitch true"
    or text == "antiglitch t"
    or text == "ag true"
    or text == "ag t" then

    antiGlitch = true
    print("Anti Glitch: ON")

elseif text == "antiglitch false"
    or text == "antiglitch f"
    or text == "ag false"
    or text == "ag f" then

    antiGlitch = false
    print("Anti Glitch: OFF")

	elseif text == 'jerkoff' or text == 'goon' then
		local speaker = game.Players.LocalPlayer
local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	local backpack = speaker:FindFirstChildWhichIsA("Backpack")
      local function r15(player)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    return humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
end

	if not humanoid or not backpack then return end

	local tool = Instance.new("Tool")
	tool.Name = "Jerk Off"
	tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
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

	tool.Equipped:Connect(function() jorkin = true end)
	tool.Unequipped:Connect(stopTomfoolery)
	humanoid.Died:Connect(stopTomfoolery)

	while task.wait() do
		if not jorkin then continue end

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
		while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do task.wait(0.1) end
		if track then
			track:Stop()
			track = nil
		end
	end

elseif text == "dela" then
			startGriefAura()
			print("DeleteAura: ON")

		elseif text == "undela" then
			griefActive = false
			print("DeleteAura: OFF")

			elseif text == "delatest" then
			local dtools = findbtoolsGlobal("Delete")
			print("Delete tools found:", #dtools)
			for _, dt in pairs(dtools) do
				print("Tool:", dt.bt.Name, "Event:", dt.e)
			end

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
                if p.Name:lower():sub(1, #lowerQuery) == lowerQuery
                    or p.DisplayName:lower():sub(1, #lowerQuery) == lowerQuery then
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

elseif text == "fling stop" or text == "unfling" then
    flingActive = false
    print("Fling stopped")
	

		-- ---- AUTOPICKUP ----
		elseif text == "autopickup true" or text == "autopickup t" then
			autoPickup = true
			print("Auto Pickup: ON")

		elseif text == "autopickup false" or text == "autopickup f" then
			autoPickup = false
			print("Auto Pickup: OFF")

			elseif text == "uaa" or text == "unanchoraura" then
			startUnanchorAura()
			print("UnanchorAura: ON")

		elseif text == "unuaa" or text == "ununanchoraura" then
			unanchorAuraActive = false
			print("UnanchorAura: OFF")
			
		-- ---- AUTO DELCUBES ALL ----
		elseif text == "autodelcubesall true" or text == "autodelcubesall t" or text == "ada t" then
			autoDelCubesAll = true
			print("Auto DelCubes All: ON")

		elseif text == "autodelcubesall false" or text == "autodelcubesall f" or text == "ada f" then
			autoDelCubesAll = false
			print("Auto DelCubes All: OFF")

		-- ---- GOTO ----
		elseif text:sub(1, 5) == "goto " then
			local query = text:sub(6):gsub("^%s+", ""):gsub("%s+$", "")
			local lowerQuery = query:lower()
			local found = nil
			-- first pass: exact match on username or displayname
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= localPlayer then
					if p.Name:lower() == lowerQuery or p.DisplayName:lower() == lowerQuery then
						found = p
						break
					end
				end
			end
			-- second pass: partial match (starts with)
			if not found then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= localPlayer then
						if p.Name:lower():sub(1, #lowerQuery) == lowerQuery
							or p.DisplayName:lower():sub(1, #lowerQuery) == lowerQuery then
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

		-- ---- SPYCHAT ----
		elseif text == "spychat true" or text == "spychat t" then
			spychat = true
			print("SpyChat: ON")

		elseif text == "spychat false" or text == "spychat f" then
			spychat = false
			print("SpyChat: OFF")

			elseif text == "sia" or text == "signaura" then
			startSignAura()
			print("SignAura: ON")

		elseif text == "unsia" or text == "unsignaura" then
			signAuraActive = false
			print("SignAura: OFF")

		elseif text == "antiinvis true"
    or text == "antiinvis t"
    or text == "antiinvisible true"
    or text == "antiinvisible t" then

    antiinvis = true
    print("Anti Invisible: ON")

elseif text == "antiinvis false"
    or text == "antiinvis f"
    or text == "antiinvisible false"
    or text == "antiinvisible f" then

    antiinvis = false
    print("Anti Invisible: OFF")

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
