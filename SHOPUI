local ServerHop = {}

function ServerHop.Show()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local existing = LocalPlayer.PlayerGui:FindFirstChild("ServerHopGUI")
if existing then
    existing.Enabled = true
    return
end

local gui = Instance.new("ScreenGui")
gui.Name = "ServerHopGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 360)
main.Position = UDim2.new(0.5, -160, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(45,45,45)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Server Hop"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(1,-20,0,35)
refresh.Position = UDim2.new(0,10,0,45)
refresh.BackgroundColor3 = Color3.fromRGB(65,65,65)
refresh.BorderSizePixel = 0
refresh.Text = "Refresh"
refresh.Font = Enum.Font.GothamBold
refresh.TextColor3 = Color3.new(1,1,1)
refresh.TextSize = 15
refresh.Parent = main

Instance.new("UICorner", refresh).CornerRadius = UDim.new(0,8)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-90)
scroll.Position = UDim2.new(0,10,0,85)
scroll.BackgroundColor3 = Color3.fromRGB(35,35,35)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.Parent = main

Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)
end)

local function createServer(server)

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,-8,0,55)
    holder.BackgroundColor3 = Color3.fromRGB(55,55,55)
    holder.BorderSizePixel = 0
    holder.Parent = scroll

    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,10,0,0)
    label.Size = UDim2.new(1,-95,1,0)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = string.format("%d/%d Players", server.playing, server.maxPlayers)
    label.Parent = holder

    local join = Instance.new("TextButton")
    join.Size = UDim2.new(0,70,0,30)
    join.Position = UDim2.new(1,-80,0.5,-15)
    join.BackgroundColor3 = Color3.fromRGB(90,90,90)
    join.BorderSizePixel = 0
    join.Text = "Join"
    join.Font = Enum.Font.GothamBold
    join.TextSize = 14
    join.TextColor3 = Color3.new(1,1,1)
    join.Parent = holder

    Instance.new("UICorner", join).CornerRadius = UDim.new(0,6)

    join.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            server.id,
            LocalPlayer
        )
    end)
end

local function clearList()
    for _,v in ipairs(scroll:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
end

local function loadServers()

    clearList()

    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
    )

    print("Fetching:", url)

    local success,response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("HttpGet failed:",response)
        return
    end

    local decoded

    success,response = pcall(function()
        decoded = HttpService:JSONDecode(response)
    end)

    if not success then
        warn("JSON Decode failed")
        return
    end

    print("Servers:", #(decoded.data or {}))

    local count = 0

    for _,server in ipairs(decoded.data or {}) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            createServer(server)
            count += 1
        end
    end

    if count == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0,40)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Text = "No servers found."
        lbl.Parent = scroll
    end
end

refresh.MouseButton1Click:Connect(loadServers)

loadServers()

end

function ServerHop.Hide()
    local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ServerHopGUI")
    if gui then
        gui.Enabled = false
    end
end

function ServerHop.Toggle()
    local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ServerHopGUI")

    if gui then
        gui.Enabled = not gui.Enabled
    else
        ServerHop.Show()
    end
end

return ServerHop
