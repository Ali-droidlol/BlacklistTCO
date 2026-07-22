--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

-- Instances: 10 | Scripts: 0 | Modules: 0 | Tags: 0
local G2L = {};

-- StarterGui.NotificationSystem
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["Name"] = [[NotificationSystem]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


-- StarterGui.NotificationSystem.NotificationHandler
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
G2L["2"]["Size"] = UDim2.new(0.43049, 0, 0.10845, 0);
G2L["2"]["Position"] = UDim2.new(0.27093, 0, 0, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["Name"] = [[NotificationHandler]];


-- StarterGui.NotificationSystem.NotificationHandler.UICorner
G2L["3"] = Instance.new("UICorner", G2L["2"]);



-- StarterGui.NotificationSystem.NotificationHandler.UIShadow
G2L["4"] = Instance.new("UIShadow", G2L["2"]);



-- StarterGui.NotificationSystem.NotificationHandler.NotificationHeader
G2L["5"] = Instance.new("TextLabel", G2L["2"]);
G2L["5"]["TextWrapped"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["TextSize"] = 14;
G2L["5"]["TextScaled"] = true;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["RichText"] = true;
G2L["5"]["Size"] = UDim2.new(0.96147, 0, 0.23256, 0);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Text"] = [[Notification Header Example]];
G2L["5"]["Name"] = [[NotificationHeader]];
G2L["5"]["Position"] = UDim2.new(0.01651, 0, 0.0814, 0);


-- StarterGui.NotificationSystem.NotificationHandler.NotificationHeader.UICorner
G2L["6"] = Instance.new("UICorner", G2L["5"]);



-- StarterGui.NotificationSystem.NotificationHandler.NotificationHeader.UIShadow
G2L["7"] = Instance.new("UIShadow", G2L["5"]);



-- StarterGui.NotificationSystem.NotificationHandler.NotificationBody
G2L["8"] = Instance.new("TextLabel", G2L["2"]);
G2L["8"]["TextWrapped"] = true;
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["TextSize"] = 14;
G2L["8"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8"]["TextScaled"] = true;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
G2L["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["8"]["RichText"] = true;
G2L["8"]["Size"] = UDim2.new(0.96147, 0, 0.46512, 0);
G2L["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["Text"] = [[Text Body Example]];
G2L["8"]["Name"] = [[NotificationBody]];
G2L["8"]["Position"] = UDim2.new(0.01651, 0, 0.45349, 0);


-- StarterGui.NotificationSystem.NotificationHandler.NotificationBody.UIShadow
G2L["9"] = Instance.new("UIShadow", G2L["8"]);



-- StarterGui.NotificationSystem.NotificationHandler.NotificationBody.UICorner
G2L["a"] = Instance.new("UICorner", G2L["8"]);

local Gui = G2L["1"]

local function Notify(Header, Body, Time)
	Time = Time or 3

	Gui.Enabled = true
	Gui.NotificationHandler.NotificationHeader.Text = Header
	Gui.NotificationHandler.NotificationBody.Text = Body

	task.delay(Time, function()
		Gui.Enabled = false
	end)
end

return Notify
