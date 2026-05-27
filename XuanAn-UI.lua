-- UI Library by XuanAn
-- TikTok:@x.an3929

local Library = {}
Library.__index = Library

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- TẠO SCREENGUI CHÍNH
local gui = Instance.new("ScreenGui")
gui.Name = "XuanLib"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- HÀM TẠO FRAME CÓ THỂ KÉO THẢ
local function MakeDraggable(frame)
    local dragging = false
    local dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- TẠO BUTTON CÓ CORNER
local function MakeButton(text, color, size, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    return btn
end

-- ============ CLASS WINDOW ============
function Library:Window(config)
    local self = setmetatable({}, Library)
    self.Title = config.Title or "Window"
    self.Size = config.Size or UDim2.new(0, 260, 0, 130)
    self.Position = config.Position or UDim2.new(0, 70, 0, 7)
    self.Color = config.Color or Color3.fromRGB(30,30,30)
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- MAIN FRAME
    self.Frame = Instance.new("Frame")
    self.Frame.Size = self.Size
    self.Frame.Position = self.Position
    self.Frame.BackgroundColor3 = self.Color
    self.Frame.Active = true
    self.Frame.Parent = gui
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 6)
    MakeDraggable(self.Frame)
    
    -- TITLE BAR
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 25)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    self.TitleBar.BackgroundTransparency = 0.5
    self.TitleBar.Parent = self.Frame
    Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 6)
    
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -30, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Color3.new(1,1,1)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- TOGGLE BUTTON (thu gọn)
    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.Size = UDim2.new(0, 20, 1, -4)
    self.ToggleBtn.Position = UDim2.new(1, -25, 0, 2)
    self.ToggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    self.ToggleBtn.Text = "-"
    self.ToggleBtn.TextColor3 = Color3.new(1,1,1)
    self.ToggleBtn.Font = Enum.Font.GothamBold
    self.ToggleBtn.TextSize = 14
    self.ToggleBtn.Parent = self.TitleBar
    Instance.new("UICorner", self.ToggleBtn).CornerRadius = UDim.new(1,0)
    
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self.Visible = not self.Visible
        self.ToggleBtn.Text = self.Visible and "-" or "+"
    end)
    
    -- TAB CONTAINER
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 0, 25)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 25)
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(35,35,35)
    self.TabContainer.BackgroundTransparency = 0.3
    self.TabContainer.Parent = self.Frame
    
    -- CONTENT CONTAINER
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, 0, 1, -50)
    self.Content.Position = UDim2.new(0, 0, 0, 50)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Frame
    
    self.Visible = true
    return self
end

-- HIỆN/ẨN WINDOW
function Library:SetVisible(visible)
    self.Visible = visible
    self.Frame.Visible = visible
    self.ToggleBtn.Text = visible and "-" or "+"
end

-- ============ CLASS TAB ============
function Library:Tab(config)
    local tab = {}
    tab.Name = config.Name or "Tab"
    tab.Parent = self
    tab.Button = nil
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, -10, 1, -10)
    tab.Content.Position = UDim2.new(0, 5, 0, 5)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 4
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tab.Content
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- TẠO NÚT TAB
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, -4)
    btn.Position = UDim2.new(0, 5 + (#self.Tabs * 85), 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = tab.Name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = self.TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            if t.Button then t.Button.BackgroundColor3 = Color3.fromRGB(50,50,50) end
        end
        tab.Content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(80,80,200)
    end)
    
    tab.Button = btn
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tab.Content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(80,80,200)
    end
    
    return tab
end

-- ============ CLASS TOGGLE ============
function Library:Toggle(config)
    local toggle = {}
    toggle.Parent = config.Parent
    toggle.Text = config.Text or "Toggle"
    toggle.Default = config.Default or false
    toggle.Callback = config.Callback or function() end
    toggle.Value = toggle.Default
    
    -- FRAME
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = config.Parent.Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    -- LABEL
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = toggle.Text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- BUTTON
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -45, 0.5, -11)
    btn.BackgroundColor3 = toggle.Value and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    btn.Text = toggle.Value and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    btn.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        btn.BackgroundColor3 = toggle.Value and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        btn.Text = toggle.Value and "ON" or "OFF"
        toggle.Callback(toggle.Value)
    end)
    
    return toggle
end

-- ============ CLASS BUTTON ============
function Library:Button(config)
    local btn = {}
    btn.Text = config.Text or "Button"
    btn.Callback = config.Callback or function() end
    btn.Parent = config.Parent
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = config.Parent.Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 1, -4)
    button.Position = UDim2.new(0, 5, 0, 2)
    button.BackgroundColor3 = Color3.fromRGB(60,100,200)
    button.Text = btn.Text
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)
    
    button.MouseButton1Click:Connect(btn.Callback)
    
    return btn
end

-- ============ CLASS SLIDER ============
function Library:Slider(config)
    local slider = {}
    slider.Text = config.Text or "Slider"
    slider.Min = config.Min or 0
    slider.Max = config.Max or 10
    slider.Default = config.Default or 1
    slider.Callback = config.Callback or function() end
    slider.Value = slider.Default
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = config.Parent.Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = slider.Text .. ": " .. slider.Value
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,150,200)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    
    local function update(posX)
        local percent = math.clamp((posX - 10) / (bar.AbsoluteSize.X - 20), 0, 1)
        local newValue = slider.Min + (slider.Max - slider.Min) * percent
        slider.Value = math.floor(newValue * 2) / 2
        fill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
        label.Text = slider.Text .. ": " .. slider.Value
        slider.Callback(slider.Value)
    end
    
    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return slider
end

-- ============ CLASS DROPDOWN ============
function Library:Dropdown(config)
    local dropdown = {}
    dropdown.Text = config.Text or "Dropdown"
    dropdown.Options = config.Options or {}
    dropdown.Default = config.Default or dropdown.Options[1]
    dropdown.Callback = config.Callback or function() end
    dropdown.Expanded = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = config.Parent.Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dropdown.Text .. ": " .. dropdown.Default
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -45, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,200)
    btn.Text = "▼"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 0, 30)
    listFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    listFrame.BackgroundTransparency = 0.3
    listFrame.Visible = false
    listFrame.Parent = frame
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 5)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame
    
    local buttons = {}
    for i, opt in ipairs(dropdown.Options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -10, 0, 25)
        optBtn.Position = UDim2.new(0, 5, 0, 2 + (i-1)*27)
        optBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 10
        optBtn.Parent = listFrame
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 3)
        
        optBtn.MouseButton1Click:Connect(function()
            dropdown.Default = opt
            label.Text = dropdown.Text .. ": " .. opt
            dropdown.Callback(opt)
            listFrame.Visible = false
            dropdown.Expanded = false
            btn.Text = "▼"
            frame.Size = UDim2.new(1, -10, 0, 30)
        end)
        table.insert(buttons, optBtn)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Expanded = not dropdown.Expanded
        listFrame.Visible = dropdown.Expanded
        btn.Text = dropdown.Expanded and "▲" or "▼"
        if dropdown.Expanded then
            local height = #dropdown.Options * 27 + 5
            frame.Size = UDim2.new(1, -10, 0, 30 + height)
            listFrame.Size = UDim2.new(1, 0, 0, height)
        else
            frame.Size = UDim2.new(1, -10, 0, 30)
        end
    end)
    
    return dropdown
end

return Library
