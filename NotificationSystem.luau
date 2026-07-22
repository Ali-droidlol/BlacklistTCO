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
	["_UIAspectRatioConstraint"] = Instance.new("UIAspectRatioConstraint");
	["_NotificationBody"] = Instance.new("TextLabel");
	["_UIShadow2"] = Instance.new("UIShadow");
	["_UICorner2"] = Instance.new("UICorner");
	["_UIAspectRatioConstraint1"] = Instance.new("UIAspectRatioConstraint");
	["_UIAspectRatioConstraint2"] = Instance.new("UIAspectRatioConstraint");
}

-- Properties:

Converted["_NotificationSystem"].IgnoreGuiInset = true
Converted["_NotificationSystem"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_NotificationSystem"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_NotificationSystem"].Name = "NotificationSystem"
Converted["_NotificationSystem"].Parent = game:GetService("CoreGui")

Converted["_NotificationHandler"].AnchorPoint = Vector2.new(0.4417475759983063, 0)
Converted["_NotificationHandler"].BackgroundColor3 = Color3.fromRGB(50.000000819563866, 50.000000819563866, 50.000000819563866)
Converted["_NotificationHandler"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationHandler"].BorderSizePixel = 0
Converted["_NotificationHandler"].Position = UDim2.new(0.474922925, 0, 0, 0)
Converted["_NotificationHandler"].Size = UDim2.new(0.430489719, 0, 0.10844893, 0)
Converted["_NotificationHandler"].Name = "NotificationHandler"
Converted["_NotificationHandler"].Parent = Converted["_NotificationSystem"]

Converted["_UICorner"].BottomLeftRadius = UDim.new(0.0930232555, 0)
Converted["_UICorner"].BottomRightRadius = UDim.new(0.0930232555, 0)
Converted["_UICorner"].CornerRadius = UDim.new(0.0930232555, 0)
Converted["_UICorner"].TopLeftRadius = UDim.new(0.0930232555, 0)
Converted["_UICorner"].TopRightRadius = UDim.new(0.0930232555, 0)
Converted["_UICorner"].Parent = Converted["_NotificationHandler"]

Converted["_UIShadow"].BlurRadius = UDim.new(0.348837197, 0)
Converted["_UIShadow"].Color = Color3.fromRGB(30.00000201165676, 10.000000353902578, 255)
Converted["_UIShadow"].Parent = Converted["_NotificationHandler"]

Converted["_NotificationHeader"].Font = Enum.Font.SourceSans
Converted["_NotificationHeader"].RichText = true
Converted["_NotificationHeader"].Text = "Notification Header Example"
Converted["_NotificationHeader"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationHeader"].TextScaled = true
Converted["_NotificationHeader"].TextSize = 14
Converted["_NotificationHeader"].TextWrapped = true
Converted["_NotificationHeader"].AnchorPoint = Vector2.new(0.47058823704719543, 0.12149316072463989)
Converted["_NotificationHeader"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_NotificationHeader"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationHeader"].BorderSizePixel = 0
Converted["_NotificationHeader"].Position = UDim2.new(0.470588207, 0, 0.133121073, 0)
Converted["_NotificationHeader"].Size = UDim2.new(0.96880734, 0, 0.237883896, 0)
Converted["_NotificationHeader"].Name = "NotificationHeader"
Converted["_NotificationHeader"].Parent = Converted["_NotificationHandler"]

Converted["_UICorner1"].BottomLeftRadius = UDim.new(0.396969706, 0)
Converted["_UICorner1"].BottomRightRadius = UDim.new(0.396969706, 0)
Converted["_UICorner1"].CornerRadius = UDim.new(0.396969706, 0)
Converted["_UICorner1"].TopLeftRadius = UDim.new(0.396969706, 0)
Converted["_UICorner1"].TopRightRadius = UDim.new(0.396969706, 0)
Converted["_UICorner1"].Parent = Converted["_NotificationHeader"]

Converted["_UIShadow1"].BlurRadius = UDim.new(0.99242425, 0)
Converted["_UIShadow1"].Parent = Converted["_NotificationHeader"]

Converted["_UIAspectRatioConstraint"].AspectRatio = 26.200000762939453
Converted["_UIAspectRatioConstraint"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint"].Parent = Converted["_NotificationHeader"]

Converted["_NotificationBody"].Font = Enum.Font.SourceSans
Converted["_NotificationBody"].RichText = true
Converted["_NotificationBody"].Text = "Text Body Example"
Converted["_NotificationBody"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationBody"].TextScaled = true
Converted["_NotificationBody"].TextSize = 20
Converted["_NotificationBody"].TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationBody"].TextWrapped = true
Converted["_NotificationBody"].AnchorPoint = Vector2.new(0.47058823704719543, 0.853491485118866)
Converted["_NotificationBody"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_NotificationBody"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationBody"].BorderSizePixel = 0
Converted["_NotificationBody"].Position = UDim2.new(0.470588237, 0, 0.853491485, 0)
Converted["_NotificationBody"].Size = UDim2.new(0.96880734, 0, 0.475767791, 0)
Converted["_NotificationBody"].Name = "NotificationBody"
Converted["_NotificationBody"].Parent = Converted["_NotificationHandler"]

Converted["_UIShadow2"].BlurRadius = UDim.new(0.496212125, 0)
Converted["_UIShadow2"].Parent = Converted["_NotificationBody"]

Converted["_UICorner2"].BottomLeftRadius = UDim.new(0.198484853, 0)
Converted["_UICorner2"].BottomRightRadius = UDim.new(0.198484853, 0)
Converted["_UICorner2"].CornerRadius = UDim.new(0.198484853, 0)
Converted["_UICorner2"].TopLeftRadius = UDim.new(0.198484853, 0)
Converted["_UICorner2"].TopRightRadius = UDim.new(0.198484853, 0)
Converted["_UICorner2"].Parent = Converted["_NotificationBody"]

Converted["_UIAspectRatioConstraint1"].AspectRatio = 13.100000381469727
Converted["_UIAspectRatioConstraint1"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint1"].Parent = Converted["_NotificationBody"]

Converted["_UIAspectRatioConstraint2"].AspectRatio = 6.337209224700928
Converted["_UIAspectRatioConstraint2"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint2"].Parent = Converted["_NotificationHandler"]



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
