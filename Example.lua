local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anzzckc/UI-Library-XuanAn/refs/heads/main/XuanAn-UI.lua"))()

local Window = Library:Window({
    Title = "XuanAn UI Example",
    Size = UDim2.new(0, 300, 0, 200),
    Position = UDim2.new(0, 100, 0, 50),
})

local MainTab = Window:Tab({Name = "Main"})

local espToggle = MainTab:Toggle({
    Text = "ESP",
    Default = true,
    Callback = function(value)
        print("ESP:", value)
    end
})

local speedToggle = MainTab:Toggle({
    Text = "Speed Hack",
    Default = false,
    Callback = function(value)
        print("Speed Hack:", value)
    end
})

MainTab:Button({
    Text = "Farm Cash",
    Callback = function()
        print("Bắt đầu farm cash")
    end
})

MainTab:Button({
    Text = "Teleport to Map",
    Callback = function()
        print("Teleport to map")
    end
})

local speedSlider = MainTab:Slider({
    Text = "Speed Value",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        print("Speed changed to:", value)
    end
})

local targetDropdown = MainTab:Dropdown({
    Text = "Target Player",
    Options = {"Player1", "Player2", "Player3", "All"},
    Default = "All",
    Callback = function(selected)
        print("Selected target:", selected)
    end
})

local UtilTab = Window:Tab({Name = "Utilities"})

UtilTab:Toggle({
    Text = "NoClip",
    Default = false,
    Callback = function(value)
        print("NoClip:", value)
    end
})

UtilTab:Toggle({
    Text = "FlyJump",
    Default = false,
    Callback = function(value)
        print("FlyJump:", value)
    end
})

UtilTab:Button({
    Text = "Open Event",
    Callback = function()
        print("Opening event...")
    end
})

UtilTab:Button({
    Text = "Open Limited",
    Callback = function()
        print("Opening limited...")
    end
})

local SettingsTab = Window:Tab({Name = "Settings"})

SettingsTab:Toggle({
    Text = "Anti AFK",
    Default = true,
    Callback = function(value)
        print("Anti AFK:", value)
    end
})

SettingsTab:Slider({
    Text = "Refresh Rate",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        print("Refresh rate:", value)
    end
})

print("ESP current value:", espToggle.Value)
