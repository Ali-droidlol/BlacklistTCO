Dark UI Library

A dark, Roblox-style UI library designed for client-side projects.

Features

Dark modern interface

Automatic UI scaling

Draggable window

Minimize button

Close button

Tabs

Sections

Buttons

Toggles

Sliders

Textboxes

Notifications

Programmatic control of toggles and sliders

Simple Lua API

Loading the library

If your environment supports your client-side loadstring setup, load the hosted library like this:

local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

local Window = Library:CreateWindow({
    Title = "My UI",
    Subtitle = "My Project",
    Size = UDim2.fromOffset(700, 500)
})

The hosted library must finish with:

return Library

Automatic scaling

The library uses a UIScale on the window.

The base design is:

700 x 500

The library compares the current viewport size against that base size and automatically reduces the scale when the available screen is smaller.

For example:

Large PC screen  -> ~1.0 scale
Smaller window   -> scales down
Tablet           -> scales down
Phone            -> scales down further

The scale is clamped so the UI does not become excessively large or tiny.

Recommended scaling code

Place this immediately after creating the main window frame:

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = Main

local BASE_WIDTH = 700
local BASE_HEIGHT = 500

local MIN_SCALE = 0.65
local MAX_SCALE = 1.15

local function UpdateScale()
    local Camera = workspace.CurrentCamera

    if not Camera then
        return
    end

    local Viewport = Camera.ViewportSize

    local WidthScale = Viewport.X / BASE_WIDTH
    local HeightScale = Viewport.Y / BASE_HEIGHT

    local Scale = math.min(WidthScale, HeightScale)

    Scale = math.clamp(
        Scale,
        MIN_SCALE,
        MAX_SCALE
    )

    UIScale.Scale = Scale
end

UpdateScale()

local Camera = workspace.CurrentCamera

if Camera then
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera

    if Camera then
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
        UpdateScale()
    end
end)

Creating tabs

local MainTab = Window:AddTab("Main", "⌂")
local SettingsTab = Window:AddTab("Settings", "⚙")

The first tab is automatically selected.

Sections

MainTab:AddSection("General")

Buttons

MainTab:AddButton({
    Name = "Hello World",
    Description = "Click this button",

    Callback = function()
        print("Hello World!")
    end
})

Toggles

local Toggle = MainTab:AddToggle({
    Name = "Example Toggle",
    Description = "Enable or disable something",
    Default = false,

    Callback = function(Value)
        print("Toggle:", Value)
    end
})

You can change it programmatically:

Toggle:SetValue(true)

Read its current state:

print(Toggle:GetValue())

Sliders

local Slider = MainTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 16,
    Increment = 1,

    Callback = function(Value)
        print("Value:", Value)
    end
})

Change it from code:

Slider:SetValue(50)

Read its current value:

print(Slider:GetValue())

Textboxes

local Textbox = MainTab:AddTextbox({
    Name = "Username",
    Placeholder = "Enter username...",

    Callback = function(Text)
        print("Entered:", Text)
    end
})

Set the text:

Textbox:SetValue("Player")

Get the text:

print(Textbox:GetValue())

Notifications

Library:Notify({
    Title = "Success",
    Description = "The operation completed.",
    Duration = 3
})

Notification options

Option

Type

Default

Title

string

"Notification"

Description

string

""

Duration

number

3

Window controls

Destroy the entire UI:

Window:Destroy()

Toggle the UI:

Window:Toggle()

Select a tab:

Window:SelectTab(MainTab)

Theme

The library exposes its theme through:

Library.Theme

Example:

Library.Theme.Accent = Color3.fromRGB(255, 80, 120)

The main theme values include:

Library.Theme.Background
Library.Theme.Sidebar
Library.Theme.Element
Library.Theme.ElementHover
Library.Theme.Accent
Library.Theme.AccentDark
Library.Theme.Text
Library.Theme.SubText
Library.Theme.Border
Library.Theme.Slider
Library.Theme.ToggleOff
Library.Theme.White

Example

local Library = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

local Window = Library:CreateWindow({
    Title = "My Project",
    Subtitle = "Dark UI",
    Size = UDim2.fromOffset(700, 500)
})

local MainTab = Window:AddTab("Main", "⌂")

MainTab:AddSection("General")

MainTab:AddButton({
    Name = "Test Button",
    Description = "Click me",

    Callback = function()
        Library:Notify({
            Title = "Clicked",
            Description = "You clicked the button.",
            Duration = 3
        })
    end
})

MainTab:AddToggle({
    Name = "Enabled",
    Default = false,

    Callback = function(Value)
        print("Enabled:", Value)
    end
})

MainTab:AddSlider({
    Name = "Amount",
    Min = 0,
    Max = 100,
    Default = 50,

    Callback = function(Value)
        print("Amount:", Value)
    end
})

MainTab:AddTextbox({
    Name = "Name",
    Placeholder = "Enter a name...",

    Callback = function(Text)
        print(Text)
    end
})

Notes

The library is designed around a 700 x 500 base window. Automatic scaling changes the visual size using UIScale; it does not change the underlying layout dimensions.

If you add custom UI elements outside the library, parent them under the scaled window so they inherit the same scaling behavior.

Version

Current documentation: Dark UI Library v1.0.0
