<div align="center">

# 🌑 Dark UI Library

**A modern, scalable Roblox UI library for client-side projects.**

[![Version](https://img.shields.io/badge/version-1.0.0-8B5CF6?style=for-the-badge)](#)
[![Language](https://img.shields.io/badge/language-Luau-00A2FF?style=for-the-badge)](#)
[![UI](https://img.shields.io/badge/UI-Dark-18181B?style=for-the-badge)](#)
[![Scaling](https://img.shields.io/badge/Auto%20Scale-Enabled-22C55E?style=for-the-badge)](#)

</div>

---

## ✨ Features

| Feature | Status |
| :--- | :---: |
| 🌑 Dark modern interface | ✅ |
| 📐 Automatic scaling | ✅ |
| 🗂️ Tabs | ✅ |
| 📑 Sections | ✅ |
| 🔘 Buttons | ✅ |
| 🔄 Toggles | ✅ |
| 🎚️ Sliders | ✅ |
| 📝 Textboxes | ✅ |
| 🔔 Notifications | ✅ |
| 🖱️ Draggable window | ✅ |
| ➖ Minimize | ✅ |
| ❌ Close | ✅ |
| 🎨 Custom themes | ✅ |
| 📱 Small-screen scaling | ✅ |

---

# 🚀 Getting Started

## Loading the Library

If your Roblox Studio setup supports your client-side `loadstring` implementation, load the hosted library like this:

```lua
local Library = loadstring(
    game:HttpGet("YOUR_RAW_URL_HERE")
)()
```

The hosted library must end with:

```lua
return Library
```

After loading it, create a window:

```lua
local Window = Library:CreateWindow({
    Title = "My UI",
    Subtitle = "My Project",
    Size = UDim2.fromOffset(700, 500)
})
```

> [!IMPORTANT]
> Replace `YOUR_RAW_URL_HERE` with the raw URL serving your `UiLib` Lua file.

---

# 📐 Automatic Scaling

Dark UI uses `UIScale` so the interface can automatically adapt to the player's viewport.

The library uses a **700 × 500** design as its base size.

```text
┌──────────────────────────────┐
│       700 × 500 BASE         │
├──────────────────────────────┤
│                              │
│       Dark UI Window         │
│                              │
└──────────────────────────────┘
```

The scale is calculated from both viewport width and height:

```lua
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

    local Scale = math.min(
        WidthScale,
        HeightScale
    )

    Scale = math.clamp(
        Scale,
        MIN_SCALE,
        MAX_SCALE
    )

    UIScale.Scale = Scale
end
```

### 📱 Example behavior

```text
Large PC
    ↓
Scale ≈ 1.00

Smaller PC window
    ↓
Scale decreases

Tablet
    ↓
Scale decreases further

Phone
    ↓
Scale approaches the minimum
```

The scale is automatically updated when the viewport changes.

---

# 🪟 Creating a Window

```lua
local Window = Library:CreateWindow({
    Title = "My Project",
    Subtitle = "Dark UI Library",

    Size = UDim2.fromOffset(
        700,
        500
    )
})
```

### Window options

| Option | Type | Default |
| :--- | :--- | :--- |
| `Title` | `string` | `"Dark UI"` |
| `Subtitle` | `string` | `"Dark UI Library"` |
| `Size` | `UDim2` | `UDim2.fromOffset(700, 500)` |

---

# 🗂️ Tabs

Create a tab with:

```lua
local MainTab = Window:AddTab(
    "Main",
    "⌂"
)
```

Create multiple tabs:

```lua
local MainTab = Window:AddTab(
    "Main",
    "⌂"
)

local SettingsTab = Window:AddTab(
    "Settings",
    "⚙"
)

local InfoTab = Window:AddTab(
    "Information",
    "i"
)
```

The first tab created is automatically selected.

---

# 📑 Sections

Sections separate controls into groups.

```lua
MainTab:AddSection(
    "General"
)
```

Example:

```lua
MainTab:AddSection("General")

MainTab:AddButton({
    Name = "Test Button",

    Callback = function()
        print("Clicked!")
    end
})

MainTab:AddSection("Settings")

MainTab:AddToggle({
    Name = "Enabled",

    Callback = function(Value)
        print(Value)
    end
})
```

---

# 🔘 Buttons

```lua
MainTab:AddButton({
    Name = "Hello World",

    Description = "Click this button",

    Callback = function()
        print("Hello World!")
    end
})
```

### Button options

| Option | Type | Required |
| :--- | :--- | :---: |
| `Name` | `string` | ❌ |
| `Description` | `string` | ❌ |
| `Callback` | `function` | ❌ |

---

# 🔄 Toggles

```lua
local Toggle = MainTab:AddToggle({
    Name = "Example Toggle",

    Description = "Enable or disable something",

    Default = false,

    Callback = function(Value)
        print("Toggle:", Value)
    end
})
```

## Setting a Toggle

```lua
Toggle:SetValue(true)
```

Turn it off:

```lua
Toggle:SetValue(false)
```

## Getting the current value

```lua
local Enabled = Toggle:GetValue()

print(Enabled)
```

---

# 🎚️ Sliders

```lua
local Slider = MainTab:AddSlider({
    Name = "WalkSpeed",

    Min = 0,
    Max = 100,

    Default = 16,

    Increment = 1,

    Callback = function(Value)
        print("WalkSpeed:", Value)
    end
})
```

## Setting a Slider

```lua
Slider:SetValue(50)
```

## Getting the current value

```lua
local Value = Slider:GetValue()

print(Value)
```

### Slider options

| Option | Type | Example |
| :--- | :--- | :--- |
| `Name` | `string` | `"WalkSpeed"` |
| `Min` | `number` | `0` |
| `Max` | `number` | `100` |
| `Default` | `number` | `16` |
| `Increment` | `number` | `1` |
| `Callback` | `function` | `function(Value)` |

---

# 📝 Textboxes

```lua
local Textbox = MainTab:AddTextbox({
    Name = "Username",

    Placeholder = "Enter username...",

    Default = "",

    Callback = function(Text)
        print("Entered:", Text)
    end
})
```

## Setting textbox text

```lua
Textbox:SetValue(
    "PlayerName"
)
```

## Getting textbox text

```lua
local Text = Textbox:GetValue()

print(Text)
```

---

# 🔔 Notifications

Notifications can be created from anywhere through `Library:Notify()`.

```lua
Library:Notify({
    Title = "Success",

    Description = "The operation completed.",

    Duration = 3
})
```

### Notification options

| Option | Type | Default |
| :--- | :--- | :--- |
| `Title` | `string` | `"Notification"` |
| `Description` | `string` | `""` |
| `Duration` | `number` | `3` |

### Example

```lua
Library:Notify({
    Title = "Welcome!",

    Description = "Dark UI has loaded.",

    Duration = 5
})
```

---

# 🎨 Themes

The library exposes its theme through:

```lua
Library.Theme
```

You can change colors:

```lua
Library.Theme.Accent =
    Color3.fromRGB(
        255,
        80,
        140
    )
```

## Available colors

```lua
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
```

### Example theme

```lua
Library.Theme.Background =
    Color3.fromRGB(10, 10, 12)

Library.Theme.Accent =
    Color3.fromRGB(140, 90, 255)

Library.Theme.Element =
    Color3.fromRGB(25, 25, 30)
```

> [!NOTE]
> Existing UI elements may already contain the previous color values. For a full theme system, the library can be expanded so every existing element updates instantly when the theme changes.

---

# 🧹 Window Controls

## Destroy

Completely remove the UI:

```lua
Window:Destroy()
```

## Toggle

Enable/disable the UI:

```lua
Window:Toggle()
```

## Select a Tab

```lua
Window:SelectTab(
    MainTab
)
```

---

# 📦 Complete Example

```lua
local Library = loadstring(
    game:HttpGet(
        "YOUR_RAW_URL_HERE"
    )
)()

local Window = Library:CreateWindow({
    Title = "My Project",

    Subtitle = "Dark UI",

    Size = UDim2.fromOffset(
        700,
        500
    )
})

--==================================================
-- MAIN TAB
--==================================================

local MainTab = Window:AddTab(
    "Main",
    "⌂"
)

MainTab:AddSection(
    "General"
)

MainTab:AddButton({
    Name = "Hello World",

    Description = "Click me!",

    Callback = function()

        Library:Notify({
            Title = "Hello!",

            Description = "Button clicked.",

            Duration = 3
        })

    end
})

local Enabled = MainTab:AddToggle({
    Name = "Enabled",

    Default = false,

    Callback = function(Value)

        print(
            "Enabled:",
            Value
        )

    end
})

local Amount = MainTab:AddSlider({
    Name = "Amount",

    Min = 0,

    Max = 100,

    Default = 50,

    Increment = 1,

    Callback = function(Value)

        print(
            "Amount:",
            Value
        )

    end
})

local Username = MainTab:AddTextbox({
    Name = "Username",

    Placeholder = "Enter username...",

    Callback = function(Text)

        print(
            "Username:",
            Text
        )

    end
})

--==================================================
-- SETTINGS TAB
--==================================================

local SettingsTab = Window:AddTab(
    "Settings",
    "⚙"
)

SettingsTab:AddSection(
    "Interface"
)

SettingsTab:AddButton({
    Name = "Notification",

    Callback = function()

        Library:Notify({
            Title = "Dark UI",

            Description = "This is a notification.",

            Duration = 3
        })

    end
})
```

---

# 🧩 Recommended Library Structure

The hosted file should follow this general structure:

```lua
local Library = {}

-- Services
-- Theme
-- Utility functions
-- Notification system
-- Window system
-- Tab system
-- Components
-- Scaling system

return Library
```

This allows the loader to receive the library:

```lua
local Library = loadstring(
    game:HttpGet(
        "YOUR_RAW_URL_HERE"
    )
)()
```

instead of the hosted script immediately creating a UI.

---

# 📁 Repository Layout

A simple repository can look like:

```text
BlacklistTCO/
│
├── UiLib
│
└── README.md
```

The raw library can then be loaded from your hosted source.

---

# ⚙️ Recommended Scaling Constants

If you want to adjust the scaling behavior:

```lua
local BASE_WIDTH = 700
local BASE_HEIGHT = 500

local MIN_SCALE = 0.65
local MAX_SCALE = 1.15
```

### More aggressive scaling

```lua
local MIN_SCALE = 0.50
local MAX_SCALE = 1.00
```

### Larger UI

```lua
local MIN_SCALE = 0.75
local MAX_SCALE = 1.25
```

---

# 🛠️ Roadmap

Potential future components:

- ⌨️ Keybinds
- 📋 Dropdowns
- 🔍 Search
- 🎨 Live theme switching
- 📂 Config saving/loading
- 💾 Configuration manager
- 🔔 Notification types
- 📱 Better mobile controls
- 🎛️ Color pickers
- 📜 Rich text labels

---

<div align="center">

### 🌑 Dark UI Library

**Built with Luau • Designed for Roblox**

`v1.0.0`

</div>
