-- // COCONUT HUB v1.1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoconutHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

local HubVisible = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 330)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local BG_Grad = Instance.new("UIGradient")
BG_Grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 10, 32)),
})
BG_Grad.Rotation = 120
BG_Grad.Parent = MainFrame

local TopAccent = Instance.new("Frame")
TopAccent.Size = UDim2.new(1, 0, 0, 2)
TopAccent.BackgroundColor3 = Color3.fromRGB(120, 40, 255)
TopAccent.BorderSizePixel = 0
TopAccent.ZIndex = 6
TopAccent.Parent = MainFrame

local AccGrad = Instance.new("UIGradient")
AccGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 200)),
})
AccGrad.Parent = TopAccent

-- ============================================================
-- // TOGGLE BUTTON
-- ============================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 54, 0, 54)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 200)
ToggleBtn.Text = "HUB"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local TGStroke = Instance.new("UIStroke")
TGStroke.Color = Color3.fromRGB(160, 80, 255)
TGStroke.Thickness = 2
TGStroke.Parent = ToggleBtn

local tgDragging = false
local tgMoved = false
local tgDragStart, tgStartPos

local function GetInputPos(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        tgDragging = true
        tgMoved = false
        tgDragStart = GetInputPos(input)
        tgStartPos = ToggleBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if tgDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = GetInputPos(input) - tgDragStart
            if delta.Magnitude > 6 then tgMoved = true end
            ToggleBtn.Position = UDim2.new(
                tgStartPos.X.Scale, tgStartPos.X.Offset + delta.X,
                tgStartPos.Y.Scale, tgStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        tgDragging = false
    end
end)

local function OpenHub()
    HubVisible = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(
        0, ToggleBtn.AbsolutePosition.X + 27,
        0, ToggleBtn.AbsolutePosition.Y + 27
    )
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 330),
        Position = UDim2.new(0.5, -210, 0.5, -165),
    }):Play()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(140, 60, 255),
    }):Play()
end

local function CloseHub()
    HubVisible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(
            0, ToggleBtn.AbsolutePosition.X + 27,
            0, ToggleBtn.AbsolutePosition.Y + 27
        ),
    }):Play()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(90, 30, 200),
    }):Play()
    task.delay(0.19, function()
        if not HubVisible then
            MainFrame.Visible = false
        end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if tgMoved then tgMoved = false return end
    if HubVisible then CloseHub() else OpenHub() end
end)

-- ============================================================
-- // TOPBAR + DRAG
-- ============================================================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 6
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "COCONUT HUB"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 160, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 7
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 7)
CloseBtn.MouseButton1Click:Connect(CloseHub)

local mDragging, mDragStart, mStartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        mDragging = true
        mDragStart = GetInputPos(input)
        mStartPos = MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if mDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = GetInputPos(input) - mDragStart
            MainFrame.Position = UDim2.new(
                mStartPos.X.Scale, mStartPos.X.Offset + delta.X,
                mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y
            )
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        mDragging = false
    end
end)

-- ============================================================
-- // SIDEBAR + CONTENT
-- ============================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 90, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 6, 16)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 6
Sidebar.Parent = MainFrame

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 4)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.Parent = Sidebar

local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -96, 1, -48)
ContentArea.Position = UDim2.new(0, 94, 0, 44)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 6
ContentArea.Parent = MainFrame

-- ============================================================
-- // TAB SYSTEM
-- ============================================================
local ActiveTab = nil

local function SetActiveTab(tabData)
    if ActiveTab then
        ActiveTab.Scroll.Visible = false
        TweenService:Create(ActiveTab.Button, TweenInfo.new(0.18), {
            BackgroundColor3 = Color3.fromRGB(16, 12, 28),
        }):Play()
        ActiveTab.IconLbl.TextColor3 = Color3.fromRGB(160, 120, 220)
        ActiveTab.NameLbl.TextColor3 = Color3.fromRGB(130, 100, 180)
    end
    ActiveTab = tabData
    ActiveTab.Scroll.Visible = true
    TweenService:Create(ActiveTab.Button, TweenInfo.new(0.18), {
        BackgroundColor3 = Color3.fromRGB(90, 30, 200),
    }):Play()
    ActiveTab.IconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActiveTab.NameLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
end

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 76, 0, 60)
    Btn.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.ZIndex = 7
    Btn.Text = ""
    Btn.Parent = Sidebar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local IconLbl = Instance.new("TextLabel")
    IconLbl.Text = icon
    IconLbl.Size = UDim2.new(1, 0, 0, 28)
    IconLbl.Position = UDim2.new(0, 0, 0, 6)
    IconLbl.BackgroundTransparency = 1
    IconLbl.TextColor3 = Color3.fromRGB(160, 120, 220)
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.TextSize = 20
    IconLbl.ZIndex = 7
    IconLbl.Parent = Btn

    local NameLbl = Instance.new("TextLabel")
    NameLbl.Text = name
    NameLbl.Size = UDim2.new(1, 0, 0, 18)
    NameLbl.Position = UDim2.new(0, 0, 0, 36)
    NameLbl.BackgroundTransparency = 1
    NameLbl.TextColor3 = Color3.fromRGB(130, 100, 180)
    NameLbl.Font = Enum.Font.Gotham
    NameLbl.TextSize = 10
    NameLbl.ZIndex = 7
    NameLbl.Parent = Btn

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 50, 220)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Visible = false
    Scroll.ZIndex = 6
    Scroll.Parent = ContentArea

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Scroll

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 6)
    Pad.PaddingRight = UDim.new(0, 6)
    Pad.Parent = Scroll

    local TabData = {
        Button  = Btn,
        IconLbl = IconLbl,
        NameLbl = NameLbl,
        Scroll  = Scroll,
    }

    Btn.MouseButton1Click:Connect(function()
        SetActiveTab(TabData)
    end)

    return TabData, Scroll
end

-- ============================================================
-- // UI COMPONENTS
-- ============================================================
local function Section(scroll, text)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 20)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(120, 60, 210)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 10
    Lbl.Text = "-- " .. string.upper(text) .. " --"
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 7
    Lbl.Parent = scroll
end

local function Toggle(scroll, label, default, onChange)
    local state = (default == true)

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 38)
    Row.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
    Row.BorderSizePixel = 0
    Row.ZIndex = 7
    Row.Parent = scroll
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 9)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = label
    Lbl.Size = UDim2.new(1, -56, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(195, 170, 225)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 7
    Lbl.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 36, 0, 20)
    Track.Position = UDim2.new(1, -46, 0.5, -10)
    Track.BackgroundColor3 = state and Color3.fromRGB(90,30,200) or Color3.fromRGB(35,25,55)
    Track.BorderSizePixel = 0
    Track.ZIndex = 8
    Track.Parent = Row
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    Knob.BackgroundColor3 = state and Color3.fromRGB(200,150,255) or Color3.fromRGB(100,80,140)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 9
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Hit = Instance.new("TextButton")
    Hit.Size = UDim2.new(1, 0, 1, 0)
    Hit.BackgroundTransparency = 1
    Hit.Text = ""
    Hit.ZIndex = 10
    Hit.Parent = Row

    Hit.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Track, TweenInfo.new(0.16), {
            BackgroundColor3 = state and Color3.fromRGB(90,30,200) or Color3.fromRGB(35,25,55),
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.16), {
            Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3 = state and Color3.fromRGB(200,150,255) or Color3.fromRGB(100,80,140),
        }):Play()
        if onChange then onChange(state) end
    end)
end

local function Dropdown(scroll, label, options, onChange)
    local selected = options[1]
    local open = false

    local Wrap = Instance.new("Frame")
    Wrap.Size = UDim2.new(1, 0, 0, 38)
    Wrap.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
    Wrap.BorderSizePixel = 0
    Wrap.ZIndex = 7
    Wrap.ClipsDescendants = false
    Wrap.Parent = scroll
    Instance.new("UICorner", Wrap).CornerRadius = UDim.new(0, 9)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = label
    Lbl.Size = UDim2.new(0.5, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(195, 170, 225)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 7
    Lbl.Parent = Wrap

    local ValBtn = Instance.new("TextButton")
    ValBtn.Size = UDim2.new(0, 110, 0, 26)
    ValBtn.Position = UDim2.new(1, -118, 0.5, -13)
    ValBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 160)
    ValBtn.Text = selected .. " v"
    ValBtn.TextColor3 = Color3.fromRGB(220, 200, 255)
    ValBtn.Font = Enum.Font.GothamSemibold
    ValBtn.TextSize = 11
    ValBtn.BorderSizePixel = 0
    ValBtn.ZIndex = 8
    ValBtn.Parent = Wrap
    Instance.new("UICorner", ValBtn).CornerRadius = UDim.new(0, 7)

    -- FIX: Parent DropList vào ScreenGui thoat khoi ClipsDescendants
    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(0, 110, 0, #options * 28)
    DropList.BackgroundColor3 = Color3.fromRGB(22, 16, 40)
    DropList.BorderSizePixel = 0
    DropList.Visible = false
    DropList.ZIndex = 50
    DropList.Parent = ScreenGui
    Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 8)
    Instance.new("UIListLayout", DropList).Padding = UDim.new(0, 0)

    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 28)
        OptBtn.BackgroundTransparency = 1
        OptBtn.Text = opt
        OptBtn.TextColor3 = Color3.fromRGB(190, 160, 230)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 11
        OptBtn.ZIndex = 51
        OptBtn.Parent = DropList
        OptBtn.MouseButton1Click:Connect(function()
            selected = opt
            ValBtn.Text = opt .. " v"
            DropList.Visible = false
            open = false
            if onChange then onChange(opt) end
        end)
    end

    -- Update vi tri DropList theo AbsolutePosition cua ValBtn
    RunService.RenderStepped:Connect(function()
        if open then
            local abs = ValBtn.AbsolutePosition
            local sz  = ValBtn.AbsoluteSize
            DropList.Position = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 4)
        end
    end)

    ValBtn.MouseButton1Click:Connect(function()
        open = not open
        DropList.Visible = open
    end)
end

-- ============================================================
-- // ESP CONFIG
-- ============================================================
local ESPConfig = {
    Enabled       = false,
    ShowDistance  = false,
    ShowHighlight = false,
    ShowHP        = false,
    ShowName      = false,
    NameType      = "Display Name",
    Color         = Color3.fromRGB(255, 60, 60),
    FillColor     = Color3.fromRGB(255, 60, 60),
    FillTrans     = 0.7,
    OutlineTrans  = 0,
}

-- ============================================================
-- // ESP TAB
-- ============================================================
local ESPTabData, ESPScroll = CreateTab("ESP", "ESP")

Section(ESPScroll, "ESP Controls")
Toggle(ESPScroll, "Enable ESP",       false, function(v) ESPConfig.Enabled       = v end)
Toggle(ESPScroll, "Show Distance",    false, function(v) ESPConfig.ShowDistance  = v end)
Toggle(ESPScroll, "Show Highlight",   false, function(v) ESPConfig.ShowHighlight = v end)
Toggle(ESPScroll, "Show HP",          false, function(v) ESPConfig.ShowHP        = v end)
Toggle(ESPScroll, "Show Player Name", false, function(v) ESPConfig.ShowName      = v end)
Dropdown(ESPScroll, "Name Type", {"Display Name", "Username"}, function(v)
    ESPConfig.NameType = v
end)

SetActiveTab(ESPTabData)
-- ============================================================
-- // LOCAL PLAYER TAB
-- ============================================================
local LPTabData, LPScroll = CreateTab("Player", "LP")

local LPConfig = {
    Speed    = 16,
    Jump     = 50,
    InfJump  = false,
    Noclip   = false,
}

local function GetChar()
    return LocalPlayer.Character
end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function GetRoot()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- // SLIDER helper
local function Slider(scroll, label, min, max, default, onChange)
    local value = default

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 54)
    Row.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
    Row.BorderSizePixel = 0
    Row.ZIndex = 7
    Row.Parent = scroll
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 9)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -60, 0, 22)
    Lbl.Position = UDim2.new(0, 12, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(195, 170, 225)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Text = label
    Lbl.ZIndex = 7
    Lbl.Parent = Row

    local ValLbl = Instance.new("TextLabel")
    ValLbl.Size = UDim2.new(0, 50, 0, 22)
    ValLbl.Position = UDim2.new(1, -58, 0, 4)
    ValLbl.BackgroundTransparency = 1
    ValLbl.TextColor3 = Color3.fromRGB(160, 120, 255)
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 12
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.Text = tostring(default)
    ValLbl.ZIndex = 7
    ValLbl.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -24, 0, 6)
    Track.Position = UDim2.new(0, 12, 0, 36)
    Track.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    Track.BorderSizePixel = 0
    Track.ZIndex = 8
    Track.Parent = Row
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(90, 30, 200)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 9
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 10
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local sliding = false

    local function UpdateFromInput(input)
        local trackAbs = Track.AbsolutePosition
        local trackSz  = Track.AbsoluteSize
        local relX = math.clamp((input.Position.X - trackAbs.X) / trackSz.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        Fill.Size = UDim2.new(relX, 0, 1, 0)
        Knob.Position = UDim2.new(relX, 0, 0.5, 0)
        ValLbl.Text = tostring(value)
        if onChange then onChange(value) end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateFromInput(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if sliding then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                UpdateFromInput(input)
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

Section(LPScroll, "Movement")

Slider(LPScroll, "Walk Speed", 1, 100, 16, function(v)
    LPConfig.Speed = v
    local hum = GetHum()
    if hum then hum.WalkSpeed = v end
end)

Slider(LPScroll, "Jump Power", 1, 200, 50, function(v)
    LPConfig.Jump = v
    local hum = GetHum()
    if hum then hum.JumpPower = v end
end)

Section(LPScroll, "Abilities")

Toggle(LPScroll, "Infinite Jump", false, function(v)
    LPConfig.InfJump = v
end)

Toggle(LPScroll, "Noclip", false, function(v)
    LPConfig.Noclip = v
end)

-- Apply speed/jump khi character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.1)
        hum.WalkSpeed = LPConfig.Speed
        hum.JumpPower = LPConfig.Jump
    end
end)

-- Inf Jump
local UIS_InfJump = game:GetService("UserInputService")
UIS_InfJump.JumpRequest:Connect(function()
    if not LPConfig.InfJump then return end
    local hum = GetHum()
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip loop
RunService.Stepped:Connect(function()
    if not LPConfig.Noclip then return end
    local char = GetChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end)

-- Re-enable collision khi tat noclip
local wasNoclip = false
RunService.Heartbeat:Connect(function()
    if wasNoclip and not LPConfig.Noclip then
        local char = GetChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    wasNoclip = LPConfig.Noclip
end)
-- ============================================================
-- // ESP CORE
-- ============================================================
local ESPObjects = {}

local function GetHealth(player)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            return math.floor(hum.Health), math.floor(hum.MaxHealth)
        end
    end
    return 0, 100
end

local function GetPlayerName(player)
    return ESPConfig.NameType == "Display Name" and player.DisplayName or player.Name
end

local function BuildBillboard()
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "CoconutESP"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 180, 0, 60)
    Billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    Billboard.Enabled = false

    local NameLbl = Instance.new("TextLabel")
    NameLbl.Name = "NameLbl"
    NameLbl.Size = UDim2.new(1, 0, 0.45, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.TextSize = 13
    NameLbl.Text = ""
    NameLbl.TextStrokeTransparency = 0.35
    NameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NameLbl.Visible = false
    NameLbl.Parent = Billboard

    local InfoLbl = Instance.new("TextLabel")
    InfoLbl.Name = "InfoLbl"
    InfoLbl.Size = UDim2.new(1, 0, 0.55, 0)
    InfoLbl.Position = UDim2.new(0, 0, 0.45, 0)
    InfoLbl.BackgroundTransparency = 1
    InfoLbl.Font = Enum.Font.Gotham
    InfoLbl.TextSize = 11
    InfoLbl.Text = ""
    InfoLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
    InfoLbl.TextStrokeTransparency = 0.35
    InfoLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    InfoLbl.Visible = false
    InfoLbl.Parent = Billboard

    return Billboard, NameLbl, InfoLbl
end

local function BuildHighlight()
    local hl = Instance.new("Highlight")
    hl.Name = "CoconutHL"
    hl.FillColor = ESPConfig.FillColor
    hl.OutlineColor = ESPConfig.Color
    hl.FillTransparency = ESPConfig.FillTrans
    hl.OutlineTransparency = ESPConfig.OutlineTrans
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false
    return hl
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    local data = {}
    local Billboard, NameLbl, InfoLbl = BuildBillboard()
    local Highlight = BuildHighlight()

    data.Billboard = Billboard
    data.NameLbl   = NameLbl
    data.InfoLbl   = InfoLbl
    data.Highlight = Highlight
    ESPObjects[player] = data

    local function Attach(char)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if root then
            Billboard.Adornee = root
            Billboard.Parent  = game:GetService("CoreGui")
            Highlight.Adornee = char
            Highlight.Parent  = char
        end
    end

    if player.Character then
        task.spawn(Attach, player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        task.spawn(function()
            local root = char:WaitForChild("HumanoidRootPart", 5)
            if root then
                Billboard.Adornee = root
                Highlight.Adornee = char
                Highlight.Parent  = char
            end
        end)
    end)
end

local function RemoveESP(player)
    local data = ESPObjects[player]
    if data then
        if data.Billboard then data.Billboard:Destroy() end
        if data.Highlight  then data.Highlight:Destroy() end
        ESPObjects[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(CreateESP, p)
end
Players.PlayerAdded:Connect(function(p)
    task.spawn(CreateESP, p)
end)
Players.PlayerRemoving:Connect(RemoveESP)

-- ============================================================
-- // RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    for player, data in pairs(ESPObjects) do
        if not data.Billboard or not data.Highlight then continue end

        local char = player.Character
        local canShow = ESPConfig.Enabled
            and char ~= nil
            and char:FindFirstChild("HumanoidRootPart") ~= nil

        data.Billboard.Enabled = canShow
        data.Highlight.Enabled = canShow and ESPConfig.ShowHighlight

        if not canShow then
            data.NameLbl.Text = ""
            data.InfoLbl.Text = ""
            continue
        end

        local c = ESPConfig.Color
        data.NameLbl.TextColor3     = c
        data.Highlight.OutlineColor = c
        data.Highlight.FillColor    = c

        if ESPConfig.ShowName then
            data.NameLbl.Text    = GetPlayerName(player)
            data.NameLbl.Visible = true
        else
            data.NameLbl.Text    = ""
            data.NameLbl.Visible = false
        end

        local info = ""
        if ESPConfig.ShowHP then
            local hp, mhp = GetHealth(player)
            info = "HP: " .. hp .. "/" .. mhp
        end
        if ESPConfig.ShowDistance then
            local lc = LocalPlayer.Character
            local lr = lc and lc:FindFirstChild("HumanoidRootPart")
            local er = char:FindFirstChild("HumanoidRootPart")
            if lr and er then
                local d = math.floor((lr.Position - er.Position).Magnitude)
                info = info .. (info ~= "" and "  " or "") .. d .. "m"
            end
        end

        data.InfoLbl.Text    = info
        data.InfoLbl.Visible = (ESPConfig.ShowHP or ESPConfig.ShowDistance) and info ~= ""
    end
end)
