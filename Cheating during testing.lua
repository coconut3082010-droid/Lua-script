-- Rayfield Hub | Coconut
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Coconut Hub",
    LoadingTitle = "cheating during testing script",
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
-- // ESP CONFIG & CORE
-- ============================================================
local ESPConfig = {
    TeacherColor = Color3.fromRGB(255, 60, 60),
    PlayerColor  = Color3.fromRGB(60, 120, 255),
}
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
        if ESPObjects["Teacher"] then return end
        local hl = BuildHighlight(tm, ESPConfig.TeacherColor, ESPConfig.TeacherColor)
        local root = tm:FindFirstChild("HumanoidRootPart") or tm:FindFirstChildWhichIsA("BasePart")
        local bb, lbl = nil, nil
        if root then bb, lbl = BuildBillboard(root, "Teacher", ESPConfig.TeacherColor) end
        ESPObjects["Teacher"] = { Highlight = hl, Billboard = bb, NameLbl = lbl, Type = "Teacher" }
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

local angleX        = 0
local angleY        = 20
local distance      = 10
local activeTouchId = nil
local lastTouchPos  = nil
local CamGui        = nil
local QuickBtnGui   = nil
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

local function DestroyQuickBtn()
    if QuickBtnGui then QuickBtnGui:Destroy() QuickBtnGui = nil end
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

local function CreateMobileZoomButtons()
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
            if input.UserInputType == Enum.UserInputType.Touch and input == activeTouchId then
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
            if input.UserInputType == Enum.UserInputType.Touch and input == activeTouchId then
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
                angleX = angleX - (mousePos.X - lastMousePos.X) * 0.35
                angleY = math.clamp(angleY - (mousePos.Y - lastMousePos.Y) * 0.35, -75, 75)
            end
            lastMousePos = mousePos
        end

        local rootPos = root.Position + Vector3.new(0, 2, 0)
        cam.CFrame = CFrame.new(rootPos)
            * CFrame.Angles(0, math.rad(angleX), 0)
            * CFrame.Angles(math.rad(angleY), 0, 0)
            * CFrame.new(0, 0, distance)

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
    if savedCamType then workspace.CurrentCamera.CameraType = savedCamType end
end

local function StartThirdPerson()
    savedCamType = workspace.CurrentCamera.CameraType
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

local function CreateQuickToggleBtn()
    DestroyQuickBtn()
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
    Btn.BackgroundColor3 = ThirdPersonEnabled and Color3.fromRGB(35, 150, 35) or Color3.fromRGB(35, 35, 80)
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
            if not camConn then pcall(StartThirdPerson) end
        else
            StopThirdPersonInternal()
        end
    end)
end

-- ============================================================
-- // PHONE SCREEN
-- ============================================================
local PhoneScreenEnabled  = false
local PhoneDragEnabled    = false
local PhoneResizeEnabled  = false
local TargetSizeX         = 200
local TargetSizeY         = 400

local PhoneScreenGui = Instance.new("ScreenGui")
PhoneScreenGui.Name         = "CoconutPhoneScreen"
PhoneScreenGui.ResetOnSpawn = false
PhoneScreenGui.DisplayOrder = 5
PhoneScreenGui.IgnoreGuiInset = true
PhoneScreenGui.Parent       = CoreGui

local PhoneFrame = Instance.new("Frame")
PhoneFrame.AnchorPoint       = Vector2.new(1, 0)
PhoneFrame.Position          = UDim2.new(1, -10, 0, 60)
PhoneFrame.Size              = UDim2.new(0, TargetSizeX, 0, TargetSizeY)
PhoneFrame.BackgroundColor3  = Color3.fromRGB(0, 0, 0)
PhoneFrame.BorderSizePixel   = 0
PhoneFrame.ClipsDescendants  = true
PhoneFrame.Visible           = false
PhoneFrame.Parent            = PhoneScreenGui
Instance.new("UICorner", PhoneFrame).CornerRadius = UDim.new(0, 8)

local PhoneStroke = Instance.new("UIStroke")
PhoneStroke.Color     = Color3.fromRGB(90, 35, 200)
PhoneStroke.Thickness = 2
PhoneStroke.Parent    = PhoneFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Name              = "UIContainer"
ContentContainer.AnchorPoint       = Vector2.new(0.5, 0.5)
ContentContainer.Position          = UDim2.new(0.5, 0, 0.5, 0)
ContentContainer.BackgroundColor3  = Color3.fromRGB(0, 0, 0)
ContentContainer.BorderSizePixel   = 0
ContentContainer.ClipsDescendants  = true
ContentContainer.Parent            = PhoneFrame

local PhoneScale = Instance.new("UIScale")
PhoneScale.Parent = ContentContainer

-- Drag overlay
local DragOverlay = Instance.new("TextButton")
DragOverlay.Size                = UDim2.new(1, 0, 0, 24)
DragOverlay.Position            = UDim2.new(0, 0, 0, 0)
DragOverlay.BackgroundColor3    = Color3.fromRGB(30, 20, 60)
DragOverlay.BackgroundTransparency = 0.3
DragOverlay.Text                = "DRAG"
DragOverlay.TextColor3          = Color3.fromRGB(200, 200, 200)
DragOverlay.Font                = Enum.Font.GothamBold
DragOverlay.TextSize            = 11
DragOverlay.BorderSizePixel     = 0
DragOverlay.Visible             = false
DragOverlay.ZIndex              = 20
DragOverlay.Parent              = PhoneFrame
Instance.new("UICorner", DragOverlay).CornerRadius = UDim.new(0, 4)

local fDragging, fStart, fPos = false, nil, nil
DragOverlay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fStart    = Vector2.new(input.Position.X, input.Position.Y)
        fPos      = PhoneFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - fStart
        PhoneFrame.Position = UDim2.new(
            fPos.X.Scale, fPos.X.Offset + delta.X,
            fPos.Y.Scale, fPos.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = false
    end
end)

-- Resize handles
local ResizersFolder = Instance.new("Folder")
ResizersFolder.Parent = PhoneFrame
local activeResizer = nil
local rStartMouse, rStartSize, rStartPos = nil, nil, nil

local handleDefs = {
    {Name="Top",    Size=UDim2.new(1,-20,0,10), Pos=UDim2.new(0,10,0,0),  Anchor=Vector2.new(0,0), Action="N"},
    {Name="Bottom", Size=UDim2.new(1,-20,0,10), Pos=UDim2.new(0,10,1,0),  Anchor=Vector2.new(0,1), Action="S"},
    {Name="Left",   Size=UDim2.new(0,10,1,-20), Pos=UDim2.new(0,0,0,10),  Anchor=Vector2.new(0,0), Action="W"},
    {Name="Right",  Size=UDim2.new(0,10,1,-20), Pos=UDim2.new(1,0,0,10),  Anchor=Vector2.new(1,0), Action="E"},
    {Name="TL",     Size=UDim2.new(0,15,0,15),  Pos=UDim2.new(0,0,0,0),   Anchor=Vector2.new(0,0), Action="NW"},
    {Name="TR",     Size=UDim2.new(0,15,0,15),  Pos=UDim2.new(1,0,0,0),   Anchor=Vector2.new(1,0), Action="NE"},
    {Name="BL",     Size=UDim2.new(0,15,0,15),  Pos=UDim2.new(0,0,1,0),   Anchor=Vector2.new(0,1), Action="SW"},
    {Name="BR",     Size=UDim2.new(0,15,0,15),  Pos=UDim2.new(1,0,1,0),   Anchor=Vector2.new(1,1), Action="SE"},
}

local function UpdatePhoneScale(surfaceGui)
    if not surfaceGui then return end
    local canvas = surfaceGui.CanvasSize
    if canvas and canvas.X > 0 and canvas.Y > 0 then
        ContentContainer.Size = UDim2.new(0, canvas.X, 0, canvas.Y)
        local sx = PhoneFrame.AbsoluteSize.X / canvas.X
        local sy = PhoneFrame.AbsoluteSize.Y / canvas.Y
        PhoneScale.Scale = math.min(sx, sy)
    end
end

for _, def in ipairs(handleDefs) do
    local h = Instance.new("TextButton")
    h.Name             = def.Name
    h.Size             = def.Size
    h.Position         = def.Pos
    h.AnchorPoint      = def.Anchor
    h.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    h.BackgroundTransparency = 0.4
    h.Text             = ""
    h.ZIndex           = 21
    h.Visible          = false
    h.Parent           = PhoneFrame

    h.InputBegan:Connect(function(input)
        if PhoneResizeEnabled and (
            input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            activeResizer = def.Action
            rStartMouse   = Vector2.new(input.Position.X, input.Position.Y)
            rStartSize    = PhoneFrame.AbsoluteSize
            rStartPos     = PhoneFrame.AbsolutePosition
        end
    end)
end

UIS.InputChanged:Connect(function(input)
    if activeResizer and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - rStartMouse
        local nW, nH = rStartSize.X, rStartSize.Y
        local nX, nY = rStartPos.X,  rStartPos.Y

        if activeResizer:find("E")  then nW = rStartSize.X + delta.X end
        if activeResizer:find("S")  then nH = rStartSize.Y + delta.Y end
        if activeResizer:find("W")  then nW = rStartSize.X - delta.X nX = rStartPos.X + delta.X end
        if activeResizer:find("N")  then nH = rStartSize.Y - delta.Y nY = rStartPos.Y + delta.Y end

        nW = math.max(80, nW)
        nH = math.max(80, nH)

        PhoneFrame.Size     = UDim2.new(0, nW, 0, nH)
        PhoneFrame.Position = UDim2.new(0, nX, 0, nY)
        TargetSizeX = nW
        TargetSizeY = nH
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        activeResizer = nil
    end
end)

-- ============================================================
-- // PHONE SCREEN CORE — MOVE TRUC TIEP
-- ============================================================
local realTimeSyncConn = nil
local movedChildren    = {}
local currentSurfaceGui = nil

local function ClearPhoneContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if not child:IsA("UIScale") then
            pcall(function() child:Destroy() end)
        end
    end
end

local function RestoreToSurfaceGui(surfaceGui)
    for _, data in ipairs(movedChildren) do
        pcall(function()
            if data.child and data.child.Parent then
                data.child.Parent = surfaceGui
            end
        end)
    end
    movedChildren = {}
end

local function MoveChildrenToContent(surfaceGui)
    movedChildren = {}
    for _, child in ipairs(surfaceGui:GetChildren()) do
        if not child:IsA("LuaSourceContainer") then
            pcall(function()
                table.insert(movedChildren, { child = child })
                child.Parent = ContentContainer
            end)
        end
    end
end

local function ShowPhoneScreen(tool)
    if not PhoneScreenEnabled then return end
    local surfaceGui = tool:FindFirstChildWhichIsA("SurfaceGui", true)
    if not surfaceGui then
        Rayfield:Notify({ Title = "Phone", Content = "Khong tim thay SurfaceGui trong Phone1", Duration = 3 })
        return
    end

    if currentSurfaceGui then
        RestoreToSurfaceGui(currentSurfaceGui)
        ClearPhoneContent()
    end

    currentSurfaceGui = surfaceGui
    PhoneFrame.Visible = true
    UpdatePhoneScale(surfaceGui)
    MoveChildrenToContent(surfaceGui)

    if realTimeSyncConn then realTimeSyncConn:Disconnect() realTimeSyncConn = nil end

    realTimeSyncConn = RunService.Heartbeat:Connect(function()
        if not PhoneFrame.Visible then return end
        if not surfaceGui or not surfaceGui.Parent then
            if realTimeSyncConn then realTimeSyncConn:Disconnect() realTimeSyncConn = nil end
            return
        end

        UpdatePhoneScale(surfaceGui)

        -- Move bat ky child moi xuat hien trong SurfaceGui
        for _, child in ipairs(surfaceGui:GetChildren()) do
            if not child:IsA("LuaSourceContainer") and child.Parent == surfaceGui then
                pcall(function()
                    table.insert(movedChildren, { child = child })
                    child.Parent = ContentContainer
                end)
            end
        end
    end)
end

local function HidePhoneScreen()
    PhoneFrame.Visible = false
    if realTimeSyncConn then
        realTimeSyncConn:Disconnect()
        realTimeSyncConn = nil
    end
    if currentSurfaceGui then
        RestoreToSurfaceGui(currentSurfaceGui)
        currentSurfaceGui = nil
    end
    ClearPhoneContent()
end

local function CheckAndShowPhone()
    local char = LocalPlayer.Character
    if not char then return end
    local phone = char:FindFirstChild("Phone1")
    if phone then
        task.wait(0.2)
        ShowPhoneScreen(phone)
    end
end

local function HookPhoneEvents(char)
    char.ChildAdded:Connect(function(child)
        if child.Name == "Phone1" then
            task.wait(0.2)
            if PhoneScreenEnabled then ShowPhoneScreen(child) end
        end
    end)
    char.ChildRemoved:Connect(function(child)
        if child.Name == "Phone1" then HidePhoneScreen() end
    end)
end

if LocalPlayer.Character then HookPhoneEvents(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
    HidePhoneScreen()
    HookPhoneEvents(char)
end)

-- ============================================================
-- // RAYFIELD TABS
-- ============================================================
local GameTab = Window:CreateTab("Game", "gamepad")

GameTab:CreateToggle({
    Name         = "Show Phone Screen",
    CurrentValue = false,
    Flag         = "ShowPhoneScreen",
    Callback     = function(val)
        PhoneScreenEnabled = val
        if val then CheckAndShowPhone() else HidePhoneScreen() end
    end,
})

GameTab:CreateToggle({
    Name         = "Drag Mode",
    CurrentValue = false,
    Flag         = "PhoneDragMode",
    Callback     = function(val)
        PhoneDragEnabled    = val
        DragOverlay.Visible = val
    end,
})

GameTab:CreateToggle({
    Name         = "Resize Mode",
    CurrentValue = false,
    Flag         = "PhoneResizeMode",
    Callback     = function(val)
        PhoneResizeEnabled = val
        for _, h in ipairs(PhoneFrame:GetChildren()) do
            if h:IsA("TextButton") and h.Name ~= "DragOverlay" then
                pcall(function() h.Visible = val end)
            end
        end
        for _, h in ipairs(ResizersFolder:GetChildren()) do
            pcall(function() h.Visible = val end)
        end
    end,
})

GameTab:CreateInput({
    Name                 = "Size (Width, Height)",
    PlaceholderText      = "VD: 200, 400",
    RemoveTextAfterFocusLost = false,
    Callback             = function(text)
        local x, y = text:match("(%d+)[^%d]+(%d+)")
        if x and y then
            TargetSizeX        = tonumber(x)
            TargetSizeY        = tonumber(y)
            PhoneFrame.Size    = UDim2.new(0, TargetSizeX, 0, TargetSizeY)
            if currentSurfaceGui then UpdatePhoneScale(currentSurfaceGui) end
        else
            Rayfield:Notify({ Title = "Loi", Content = "Nhap dang: 200, 400", Duration = 3 })
        end
    end,
})

GameTab:CreateDivider()

GameTab:CreateToggle({
    Name         = "Teacher ESP",
    CurrentValue = false,
    Flag         = "TeacherESP",
    Callback     = function(val)
        TeacherESPEnabled = val
        if val then StartTeacherESP() else StopTeacherESP() end
    end,
})

GameTab:CreateColorPicker({
    Name     = "Teacher ESP Color",
    Color    = ESPConfig.TeacherColor,
    Flag     = "TeacherColor",
    Callback = function(val)
        ESPConfig.TeacherColor = val
        UpdateESPColors("Teacher", val)
    end,
})

GameTab:CreateDivider()

GameTab:CreateToggle({
    Name         = "Player ESP",
    CurrentValue = false,
    Flag         = "PlayerESP",
    Callback     = function(val)
        PlayerESPEnabled = val
        if val then StartPlayerESP() else StopPlayerESP() end
    end,
})

GameTab:CreateColorPicker({
    Name     = "Player ESP Color",
    Color    = ESPConfig.PlayerColor,
    Flag     = "PlayerColor",
    Callback = function(val)
        ESPConfig.PlayerColor = val
        UpdateESPColors("Player", val)
    end,
})

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
        if val then CreateQuickToggleBtn() else DestroyQuickBtn() end
    end,
})

Rayfield:Notify({
    Title    = "Coconut Hub",
    Content  = "Loaded successfully!",
    Duration = 3,
})

print("[Coconut Hub] Loaded")
