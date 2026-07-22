-- Generated using RoadToGlory's Converter v1.1 (RoadToGlory#9879)

-- Instances:

local Converted = {
	["_NotificationSystem"] = Instance.new("ScreenGui");
	["_NotificationHandler"] = Instance.new("Frame");
	["_UICorner"] = Instance.new("UICorner");
	["_UIShadow"] = Instance.new("UIShadow");
	["_NotificationHeader"] = Instance.new("TextLabel");
	["_UICorner1"] = Instance.new("UICorner");
	["_UIShadow1"] = Instance.new("UIShadow");
	["_NotificationBody"] = Instance.new("TextLabel");
	["_UIShadow2"] = Instance.new("UIShadow");
	["_UICorner2"] = Instance.new("UICorner");
}

-- Properties:

Converted["_NotificationSystem"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_NotificationSystem"].Name = "NotificationSystem"
Converted["_NotificationSystem"].Parent = game:GetService("CoreGui")

Converted["_NotificationHandler"].BackgroundColor3 = Color3.fromRGB(50.000000819563866, 50.000000819563866, 50.000000819563866)
Converted["_NotificationHandler"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationHandler"].BorderSizePixel = 0
Converted["_NotificationHandler"].Position = UDim2.new(0.270932078, 0, 0, 0)
Converted["_NotificationHandler"].Size = UDim2.new(0.430489719, 0, 0.10844893, 0)
Converted["_NotificationHandler"].Name = "NotificationHandler"
Converted["_NotificationHandler"].Parent = Converted["_NotificationSystem"]

Converted["_UICorner"].Parent = Converted["_NotificationHandler"]

Converted["_UIShadow"].BlurRadius = UDim.new(0, 30)
Converted["_UIShadow"].Color = Color3.fromRGB(30.00000201165676, 10.000000353902578, 255)
Converted["_UIShadow"].Parent = Converted["_NotificationHandler"]

Converted["_NotificationHeader"].Font = Enum.Font.SourceSans
Converted["_NotificationHeader"].RichText = true
Converted["_NotificationHeader"].Text = "Notification Header Example"
Converted["_NotificationHeader"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationHeader"].TextScaled = true
Converted["_NotificationHeader"].TextSize = 14
Converted["_NotificationHeader"].TextWrapped = true
Converted["_NotificationHeader"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_NotificationHeader"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationHeader"].BorderSizePixel = 0
Converted["_NotificationHeader"].Position = UDim2.new(0.0165137611, 0, 0.0813953504, 0)
Converted["_NotificationHeader"].Size = UDim2.new(0.961467862, 0, 0.232558146, 0)
Converted["_NotificationHeader"].Name = "NotificationHeader"
Converted["_NotificationHeader"].Parent = Converted["_NotificationHandler"]

Converted["_UICorner1"].Parent = Converted["_NotificationHeader"]

Converted["_UIShadow1"].BlurRadius = UDim.new(0, 20)
Converted["_UIShadow1"].Parent = Converted["_NotificationHeader"]

Converted["_NotificationBody"].Font = Enum.Font.SourceSans
Converted["_NotificationBody"].RichText = true
Converted["_NotificationBody"].Text = "Text Body Example"
Converted["_NotificationBody"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationBody"].TextScaled = true
Converted["_NotificationBody"].TextSize = 14
Converted["_NotificationBody"].TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationBody"].TextWrapped = true
Converted["_NotificationBody"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_NotificationBody"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationBody"].BorderSizePixel = 0
Converted["_NotificationBody"].Position = UDim2.new(0, 9, 0, 39)
Converted["_NotificationBody"].Size = UDim2.new(0, 524, 0, 40)
Converted["_NotificationBody"].Name = "NotificationBody"
Converted["_NotificationBody"].Parent = Converted["_NotificationHandler"]

Converted["_UIShadow2"].BlurRadius = UDim.new(0, 20)
Converted["_UIShadow2"].Parent = Converted["_NotificationBody"]

Converted["_UICorner2"].Parent = Converted["_NotificationBody"]

local Gui = Converted["_NotificationSystem"]
local Handler = Converted["_NotificationHandler"]

Gui.Enabled = false

local Queue = {}
local Processing = false

local function Notify(Header, Body, Time)
	table.insert(Queue, {
		Header = Header,
		Body = Body,
		Time = Time or 3
	})

	if Processing then
		return
	end

	Processing = true

	while #Queue > 0 do
		local Data = table.remove(Queue, 1)

		Handler.NotificationHeader.Text = Data.Header
		Handler.NotificationBody.Text = Data.Body

		Gui.Enabled = true
		task.wait(Data.Time)
		Gui.Enabled = false

		task.wait(0.2)
	end

	Processing = false
end

return Notify
