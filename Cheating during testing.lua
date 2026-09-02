-- Rayfield Hub | Coconut
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Coconut Hub",
    LoadingTitle = "Coconut Hub",
    LoadingSubtitle = "by Coconut",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

-- ============================================================
-- // SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ============================================================
-- // ESP CONFIG
-- ============================================================
local ESPConfig = {
    TeacherColor = Color3.fromRGB(255, 60, 60),
    PlayerColor  = Color3.fromRGB(60, 120, 255),
}

-- ============================================================
-- // ESP CORE
-- ============================================================
local ESPObjects = {}

local function BuildHighlight(adornee, fillColor, outlineColor)
    local hl = Instance.new("Highlight")
    hl.FillColor           = fillColor
    hl.OutlineColor        = outlineColor
    hl.FillTransparency    = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = adornee
    hl.Parent              = adornee
    return hl
end

local function BuildBillboard(adornee, text, textColor)
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size        = UDim2.new(0, 120, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Adornee     = adornee
    bb.Parent      = CoreGui

    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text
    lbl.TextColor3             = textColor
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 13
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
    lbl.Parent                 = bb
    return bb, lbl
end

local function RemoveESP(key)
    local data = ESPObjects[key]
    if not data then return end
    if data.Highlight then pcall(function() data.Highlight:Destroy() end) end
    if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
    ESPObjects[key] = nil
end

local function ClearESPByType(espType)
    for key, data in pairs(ESPObjects) do
        if data.Type == espType then RemoveESP(key) end
    end
end

local function UpdateESPColors(espType, color)
    for _, data in pairs(ESPObjects) do
        if data.Type == espType then
            if data.Highlight then
                data.Highlight.FillColor    = color
                data.Highlight.OutlineColor = color
            end
            if data.NameLbl then
                data.NameLbl.TextColor3 = color
            end
        end
    end
end

-- ============================================================
-- // TEACHER ESP
-- ============================================================
local TeacherESPEnabled = false
local teacherConn = nil

local function StartTeacherESP()
    local function AttachTeacher(tm)
        local key = "Teacher"
        if ESPObjects[key] then return end
        local hl = BuildHighlight(tm, ESPConfig.TeacherColor, ESPConfig.TeacherColor)
        local root = tm:FindFirstChild("HumanoidRootPart")
            or tm:FindFirstChildWhichIsA("BasePart")
        local bb, lbl = nil, nil
        if root then bb, lbl = BuildBillboard(root, "Teacher", ESPConfig.TeacherColor) end
        ESPObjects[key] = { Highlight = hl, Billboard = bb, NameLbl = lbl, Type = "Teacher" }
    end

    local tm = workspace:FindFirstChild("Teacher")
    if tm then AttachTeacher(tm) end

    teacherConn = RunService.Heartbeat:Connect(function()
        if not TeacherESPEnabled then return end
        local t = workspace:FindFirstChild("Teacher")
        if t and not ESPObjects["Teacher"] then
            AttachTeacher(t)
        elseif not t and ESPObjects["Teacher"] then
            RemoveESP("Teacher")
        end
    end)
end

local function StopTeacherESP()
    if teacherConn then teacherConn:Disconnect() teacherConn = nil end
    ClearESPByType("Teacher")
end

-- ============================================================
-- // PLAYER ESP
-- ============================================================
local PlayerESPEnabled = false
local playerAddedConn = nil
local playerRemovingConn = nil

local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    local key = "Player_" .. player.UserId

    local function Attach(char)
        RemoveESP(key)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local hl = BuildHighlight(char, ESPConfig.PlayerColor, ESPConfig.PlayerColor)
        local bb, lbl = BuildBillboard(root, player.DisplayName, ESPConfig.PlayerColor)
        ESPObjects[key] = { Highlight = hl, Billboard = bb, NameLbl = lbl, Type = "Player" }
    end

    if player.Character then task.spawn(Attach, player.Character) end
    player.CharacterAdded:Connect(function(char)
        if PlayerESPEnabled then task.spawn(Attach, char) end
    end)
end

local function StartPlayerESP()
    for _, p in ipairs(Players:GetPlayers()) do
        task.spawn(CreatePlayerESP, p)
    end
    playerAddedConn = Players.PlayerAdded:Connect(function(p)
        if PlayerESPEnabled then task.spawn(CreatePlayerESP, p) end
    end)
    playerRemovingConn = Players.PlayerRemoving:Connect(function(p)
        RemoveESP("Player_" .. p.UserId)
    end)
end

local function StopPlayerESP()
    if playerAddedConn    then playerAddedConn:Disconnect()    playerAddedConn    = nil end
    if playerRemovingConn then playerRemovingConn:Disconnect() playerRemovingConn = nil end
    ClearESPByType("Player")
end

-- ============================================================
-- // THIRD PERSON
-- ============================================================
local ThirdPersonEnabled = false
local camConn = nil
local inputConn1 = nil
local inputConn2 = nil
local savedCamType = nil
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local angleX   = 0
local angleY   = 20
local distance = 10

local activeTouchId = nil
local lastTouchPos  = nil
local CamGui = nil

-- ============================================================
-- // QUICK TOGGLE BUTTON ON SCREEN
-- ============================================================
local QuickBtnGui = nil
local QuickBtnVisible = false

local function UpdateQuickBtn(enabled)
    if not QuickBtnGui then return end
    local btn = QuickBtnGui:FindFirstChild("QuickBtn")
    if not btn then return end
    btn.Text             = enabled and "3RD\nON" or "3RD\nOFF"
    btn.BackgroundColor3 = enabled
        and Color3.fromRGB(35, 150, 35)
        or  Color3.fromRGB(35, 35, 80)
end

local function CreateQuickToggleBtn()
    if QuickBtnGui then QuickBtnGui:Destroy() end

    QuickBtnGui = Instance.new("ScreenGui")
    QuickBtnGui.Name           = "CoconutQuickTP"
    QuickBtnGui.ResetOnSpawn   = false
    QuickBtnGui.IgnoreGuiInset = true
    QuickBtnGui.DisplayOrder   = 2
    QuickBtnGui.Parent         = CoreGui

    local Btn = Instance.new("TextButton")
    Btn.Name             = "QuickBtn"
    Btn.Size             = UDim2.new(0, 54, 0, 54)
    Btn.Position         = UDim2.new(0, 10, 0, 10)
    Btn.BackgroundColor3 = ThirdPersonEnabled
        and Color3.fromRGB(35, 150, 35)
        or  Color3.fromRGB(35, 35, 80)
    Btn.Text             = ThirdPersonEnabled and "3RD\nON" or "3RD\nOFF"
    Btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    Btn.Font             = Enum.Font.GothamBold
    Btn.TextSize         = 11
    Btn.BorderSizePixel  = 0
    Btn.AutoButtonColor  = false
    Btn.ZIndex           = 10
    Btn.Parent           = QuickBtnGui
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color     = Color3.fromRGB(100, 60, 220)
    BtnStroke.Thickness = 2
    BtnStroke.Parent    = Btn

    -- Drag
    local dragging, moved, dragStart, startPos = false, false, nil, nil
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            moved     = false
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos  = Btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            if delta.Magnitude > 6 then moved = true end
            Btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    Btn.MouseButton1Click:Connect(function()
        if moved then moved = false return end
        ThirdPersonEnabled = not ThirdPersonEnabled
        UpdateQuickBtn(ThirdPersonEnabled)
        if ThirdPersonEnabled then
            -- Goi StartThirdPerson neu chua chay
            if not camConn then
                local ok, err = pcall(function()
                    local cam = workspace.CurrentCamera
                    savedCamType = cam.CameraType
                    angleX   = 0
                    angleY   = 20
                    distance = 10
                    DisableGameCameraScripts()
                    if isMobile then CreateMobileZoomButtons() end
                    StartCamLoop()
                end)
                if not ok then warn(err) end
            end
        else
            StopThirdPersonInternal()
        end
    end)
end

local function DestroyQuickBtn()
    if QuickBtnGui then
        QuickBtnGui:Destroy()
        QuickBtnGui = nil
    end
end

-- ============================================================
-- // CAMERA HELPERS
-- ============================================================
local function CreateMobileZoomButtons()
    -- Sudah ada di CamGui, skip jika sudah ada
    if CamGui then CamGui:Destroy() end

    CamGui = Instance.new("ScreenGui")
    CamGui.Name           = "CoconutCamZoom"
    CamGui.ResetOnSpawn   = false
    CamGui.IgnoreGuiInset = true
    CamGui.DisplayOrder   = 1
    CamGui.Parent         = CoreGui

    local ZoomIn = Instance.new("TextButton")
    ZoomIn.Size             = UDim2.new(0, 36, 0, 36)
    ZoomIn.Position         = UDim2.new(1, -80, 0, 10)
    ZoomIn.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
    ZoomIn.BackgroundTransparency = 0.3
    ZoomIn.Text             = "+"
    ZoomIn.TextColor3       = Color3.fromRGB(255, 255, 255)
    ZoomIn.Font             = Enum.Font.GothamBold
    ZoomIn.TextSize         = 18
    ZoomIn.BorderSizePixel  = 0
    ZoomIn.ZIndex           = 2
    ZoomIn.Parent           = CamGui
    Instance.new("UICorner", ZoomIn).CornerRadius = UDim.new(0, 8)

    local ZoomOut = Instance.new("TextButton")
    ZoomOut.Size             = UDim2.new(0, 36, 0, 36)
    ZoomOut.Position         = UDim2.new(1, -40, 0, 10)
    ZoomOut.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
    ZoomOut.BackgroundTransparency = 0.3
    ZoomOut.Text             = "-"
    ZoomOut.TextColor3       = Color3.fromRGB(255, 255, 255)
    ZoomOut.Font             = Enum.Font.GothamBold
    ZoomOut.TextSize         = 18
    ZoomOut.BorderSizePixel  = 0
    ZoomOut.ZIndex           = 2
    ZoomOut.Parent           = CamGui
    Instance.new("UICorner", ZoomOut).CornerRadius = UDim.new(0, 8)

    local HintLbl = Instance.new("TextLabel")
    HintLbl.Size               = UDim2.new(0, 160, 0, 18)
    HintLbl.Position           = UDim2.new(1, -168, 0, 52)
    HintLbl.BackgroundTransparency = 1
    HintLbl.Text               = "1 finger drag = rotate"
    HintLbl.TextColor3         = Color3.fromRGB(180, 180, 180)
    HintLbl.Font               = Enum.Font.Gotham
    HintLbl.TextSize           = 10
    HintLbl.TextXAlignment     = Enum.TextXAlignment.Right
    HintLbl.ZIndex             = 2
    HintLbl.Parent             = CamGui

    ZoomIn.MouseButton1Click:Connect(function()
        distance = math.max(3, distance - 2)
    end)
    ZoomOut.MouseButton1Click:Connect(function()
        distance = math.min(50, distance + 2)
    end)
end

local function DisableGameCameraScripts()
    local function DisableIn(parent)
        for _, s in ipairs(parent:GetDescendants()) do
            if s:IsA("LocalScript") or s:IsA("ModuleScript") then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then
                    pcall(function() s.Disabled = true end)
                end
            end
        end
    end
    DisableIn(workspace)
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then DisableIn(ps) end
end

local function EnableGameCameraScripts()
    local function EnableIn(parent)
        for _, s in ipairs(parent:GetDescendants()) do
            if s:IsA("LocalScript") or s:IsA("ModuleScript") then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then
                    pcall(function() s.Disabled = false end)
                end
            end
        end
    end
    EnableIn(workspace)
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then EnableIn(ps) end
end

local function StartCamLoop()
    local cam = workspace.CurrentCamera
    local lastMousePos = nil

    if isMobile then
        inputConn1 = UIS.InputBegan:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                if activeTouchId == nil then
                    activeTouchId = input
                    lastTouchPos  = Vector2.new(input.Position.X, input.Position.Y)
                end
            end
        end)

        inputConn2 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.Touch
                and input == activeTouchId then
                local cur = Vector2.new(input.Position.X, input.Position.Y)
                if lastTouchPos then
                    local dx = cur.X - lastTouchPos.X
                    local dy = cur.Y - lastTouchPos.Y
                    if math.abs(dx) < 60 and math.abs(dy) < 60 then
                        angleX = angleX - dx * 0.3
                        angleY = math.clamp(angleY - dy * 0.3, -75, 75)
                    end
                end
                lastTouchPos = cur
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
                and input == activeTouchId then
                activeTouchId = nil
                lastTouchPos  = nil
            end
        end)
    else
        inputConn1 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                distance = math.clamp(distance - input.Position.Z * 2, 3, 50)
            end
        end)
    end

    camConn = RunService.RenderStepped:Connect(function()
        if not ThirdPersonEnabled then return end

        local char = LocalPlayer.Character
        local root = char and (
            char:FindFirstChild("HumanoidRootPart") or
            char:FindFirstChildWhichIsA("BasePart")
        )
        if not root then return end

        cam.CameraType = Enum.CameraType.Scriptable

        if not isMobile then
            local mousePos = UIS:GetMouseLocation()
            if lastMousePos and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local dx = mousePos.X - lastMousePos.X
                local dy = mousePos.Y - lastMousePos.Y
                angleX = angleX - dx * 0.35
                angleY = math.clamp(angleY - dy * 0.35, -75, 75)
            end
            lastMousePos = mousePos
        end

        local rootPos = root.Position + Vector3.new(0, 2, 0)
        local cf = CFrame.new(rootPos)
            * CFrame.Angles(0, math.rad(angleX), 0)
            * CFrame.Angles(math.rad(angleY), 0, 0)
            * CFrame.new(0, 0, distance)

        cam.CFrame = cf

        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end)
end

local function StopThirdPersonInternal()
    if camConn    then camConn:Disconnect()    camConn    = nil end
    if inputConn1 then inputConn1:Disconnect() inputConn1 = nil end
    if inputConn2 then inputConn2:Disconnect() inputConn2 = nil end
    if CamGui     then CamGui:Destroy()        CamGui     = nil end
    activeTouchId = nil
    lastTouchPos  = nil
    EnableGameCameraScripts()
    local cam = workspace.CurrentCamera
    if savedCamType then cam.CameraType = savedCamType end
end

local function StartThirdPerson()
    local cam = workspace.CurrentCamera
    savedCamType = cam.CameraType
    angleX   = 0
    angleY   = 20
    distance = 10
    DisableGameCameraScripts()
    if isMobile then CreateMobileZoomButtons() end
    StartCamLoop()
    UpdateQuickBtn(true)
end

local function StopThirdPerson()
    StopThirdPersonInternal()
    UpdateQuickBtn(false)
end

-- ============================================================
-- // RAYFIELD TABS
-- ============================================================
local ESPTab = Window:CreateTab("ESP", "eye")

ESPTab:CreateToggle({
    Name         = "Teacher ESP",
    CurrentValue = false,
    Flag         = "TeacherESP",
    Callback     = function(val)
        TeacherESPEnabled = val
        if val then StartTeacherESP() else StopTeacherESP() end
    end,
})

ESPTab:CreateColorPicker({
    Name     = "Teacher ESP Color",
    Color    = ESPConfig.TeacherColor,
    Flag     = "TeacherColor",
    Callback = function(val)
        ESPConfig.TeacherColor = val
        UpdateESPColors("Teacher", val)
    end,
})

ESPTab:CreateDivider()

ESPTab:CreateToggle({
    Name         = "Player ESP",
    CurrentValue = false,
    Flag         = "PlayerESP",
    Callback     = function(val)
        PlayerESPEnabled = val
        if val then StartPlayerESP() else StopPlayerESP() end
    end,
})

ESPTab:CreateColorPicker({
    Name     = "Player ESP Color",
    Color    = ESPConfig.PlayerColor,
    Flag     = "PlayerColor",
    Callback = function(val)
        ESPConfig.PlayerColor = val
        UpdateESPColors("Player", val)
    end,
})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", "user")

PlayerTab:CreateToggle({
    Name         = "Third Person",
    CurrentValue = false,
    Flag         = "ThirdPerson",
    Callback     = function(val)
        ThirdPersonEnabled = val
        if val then StartThirdPerson() else StopThirdPerson() end
    end,
})

PlayerTab:CreateToggle({
    Name         = "Show Button In Screen (Third Person)",
    CurrentValue = false,
    Flag         = "ShowTPBtn",
    Callback     = function(val)
        QuickBtnVisible = val
        if val then
            CreateQuickToggleBtn()
        else
            DestroyQuickBtn()
        end
    end,
})

Rayfield:Notify({
    Title    = "Coconut Hub",
    Content  = "Loaded successfully",
    Duration = 3,
})

print("[Coconut Hub] Loaded")
