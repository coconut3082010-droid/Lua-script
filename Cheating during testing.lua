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
            if data.NameLbl then data.NameLbl.TextColor3 = color end
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
        if t and not ESPObjects["Teacher"] then AttachTeacher(t)
        elseif not t and ESPObjects["Teacher"] then RemoveESP("Teacher") end
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
    for _, p in ipairs(Players:GetPlayers()) do task.spawn(CreatePlayerESP, p) end
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
local angleX, angleY, distance = 0, 20, 10
local activeTouchId, lastTouchPos = nil, nil
local CamGui, QuickBtnGui = nil, nil

local function UpdateQuickBtn(enabled)
    if not QuickBtnGui then return end
    local btn = QuickBtnGui:FindFirstChild("QuickBtn")
    if not btn then return end
    btn.Text             = enabled and "3RD\nON" or "3RD\nOFF"
    btn.BackgroundColor3 = enabled and Color3.fromRGB(35,150,35) or Color3.fromRGB(35,35,80)
end

local function DestroyQuickBtn()
    if QuickBtnGui then QuickBtnGui:Destroy() QuickBtnGui = nil end
end

local function DisableGameCameraScripts()
    local function DisableIn(p)
        for _, s in ipairs(p:GetDescendants()) do
            if (s:IsA("LocalScript") or s:IsA("ModuleScript")) then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then pcall(function() s.Disabled = true end) end
            end
        end
    end
    DisableIn(workspace)
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then DisableIn(ps) end
end

local function EnableGameCameraScripts()
    local function EnableIn(p)
        for _, s in ipairs(p:GetDescendants()) do
            if (s:IsA("LocalScript") or s:IsA("ModuleScript")) then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then pcall(function() s.Disabled = false end) end
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
    CamGui.Name = "CoconutCamZoom" CamGui.ResetOnSpawn = false
    CamGui.IgnoreGuiInset = true CamGui.DisplayOrder = 1 CamGui.Parent = CoreGui
    local function MkZBtn(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,36,0,36) b.Position = UDim2.new(1,x,0,10)
        b.BackgroundColor3 = Color3.fromRGB(30,20,60) b.BackgroundTransparency = 0.3
        b.Text = txt b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.GothamBold b.TextSize = 18 b.BorderSizePixel = 0 b.ZIndex = 2
        b.Parent = CamGui Instance.new("UICorner",b).CornerRadius = UDim.new(0,8) return b
    end
    local zi = MkZBtn("+", -80)
    local zo = MkZBtn("-", -40)
    zi.MouseButton1Click:Connect(function() distance = math.max(3, distance-2) end)
    zo.MouseButton1Click:Connect(function() distance = math.min(50, distance+2) end)
end

local function StartCamLoop()
    local cam = workspace.CurrentCamera
    local lastMousePos = nil
    if isMobile then
        inputConn1 = UIS.InputBegan:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.Touch and activeTouchId == nil then
                activeTouchId = input
                lastTouchPos  = Vector2.new(input.Position.X, input.Position.Y)
            end
        end)
        inputConn2 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.Touch and input == activeTouchId then
                local cur = Vector2.new(input.Position.X, input.Position.Y)
                if lastTouchPos then
                    local dx, dy = cur.X-lastTouchPos.X, cur.Y-lastTouchPos.Y
                    if math.abs(dx)<60 and math.abs(dy)<60 then
                        angleX = angleX - dx*0.3
                        angleY = math.clamp(angleY - dy*0.3, -75, 75)
                    end
                end
                lastTouchPos = cur
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and input == activeTouchId then
                activeTouchId = nil lastTouchPos = nil
            end
        end)
    else
        inputConn1 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                distance = math.clamp(distance - input.Position.Z*2, 3, 50)
            end
        end)
    end
    camConn = RunService.RenderStepped:Connect(function()
        if not ThirdPersonEnabled then return end
        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
        if not root then return end
        cam.CameraType = Enum.CameraType.Scriptable
        if not isMobile then
            local mp = UIS:GetMouseLocation()
            if lastMousePos and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                angleX = angleX - (mp.X-lastMousePos.X)*0.35
                angleY = math.clamp(angleY - (mp.Y-lastMousePos.Y)*0.35, -75, 75)
            end
            lastMousePos = mp
        end
        cam.CFrame = CFrame.new(root.Position+Vector3.new(0,2,0))
            * CFrame.Angles(0,math.rad(angleX),0)
            * CFrame.Angles(math.rad(angleY),0,0)
            * CFrame.new(0,0,distance)
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier = 0 end
            end
        end
    end)
end

local function StopThirdPersonInternal()
    if camConn    then camConn:Disconnect()    camConn    = nil end
    if inputConn1 then inputConn1:Disconnect() inputConn1 = nil end
    if inputConn2 then inputConn2:Disconnect() inputConn2 = nil end
    if CamGui     then CamGui:Destroy()        CamGui     = nil end
    activeTouchId = nil lastTouchPos = nil
    EnableGameCameraScripts()
    if savedCamType then workspace.CurrentCamera.CameraType = savedCamType end
end

local function StartThirdPerson()
    savedCamType = workspace.CurrentCamera.CameraType
    angleX=0 angleY=20 distance=10
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
    QuickBtnGui.Name="CoconutQuickTP" QuickBtnGui.ResetOnSpawn=false
    QuickBtnGui.IgnoreGuiInset=true QuickBtnGui.DisplayOrder=2 QuickBtnGui.Parent=CoreGui
    local Btn = Instance.new("TextButton")
    Btn.Name="QuickBtn" Btn.Size=UDim2.new(0,54,0,54) Btn.Position=UDim2.new(0,10,0,10)
    Btn.BackgroundColor3=ThirdPersonEnabled and Color3.fromRGB(35,150,35) or Color3.fromRGB(35,35,80)
    Btn.Text=ThirdPersonEnabled and "3RD\nON" or "3RD\nOFF"
    Btn.TextColor3=Color3.fromRGB(255,255,255) Btn.Font=Enum.Font.GothamBold
    Btn.TextSize=11 Btn.BorderSizePixel=0 Btn.AutoButtonColor=false Btn.ZIndex=10 Btn.Parent=QuickBtnGui
    Instance.new("UICorner",Btn).CornerRadius=UDim.new(1,0)
    local st=Instance.new("UIStroke") st.Color=Color3.fromRGB(100,60,220) st.Thickness=2 st.Parent=Btn
    local dragging,moved,dragStart,startPos=false,false,nil,nil
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true moved=false
            dragStart=Vector2.new(input.Position.X,input.Position.Y) startPos=Btn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local d=Vector2.new(input.Position.X,input.Position.Y)-dragStart
            if d.Magnitude>6 then moved=true end
            Btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    Btn.MouseButton1Click:Connect(function()
        if moved then moved=false return end
        ThirdPersonEnabled=not ThirdPersonEnabled
        UpdateQuickBtn(ThirdPersonEnabled)
        if ThirdPersonEnabled then
            if not camConn then pcall(StartThirdPerson) end
        else StopThirdPersonInternal() end
    end)
end

-- ============================================================
-- // PHONE SCREEN — REALTIME SCREENGUI MIRROR
-- ============================================================
local PhoneScreenEnabled = false
local PhoneDragEnabled   = false
local PhoneResizeEnabled = false
local TargetSizeX        = 50   -- default
local TargetSizeY        = 100  -- default

local PhoneScreenGui = Instance.new("ScreenGui")
PhoneScreenGui.Name           = "CoconutPhoneScreen"
PhoneScreenGui.ResetOnSpawn   = false
PhoneScreenGui.DisplayOrder   = 5
PhoneScreenGui.IgnoreGuiInset = true
PhoneScreenGui.Parent         = CoreGui

local PhoneFrame = Instance.new("Frame")
PhoneFrame.AnchorPoint      = Vector2.new(1, 0)
PhoneFrame.Position         = UDim2.new(1, -10, 0, 60)
PhoneFrame.Size             = UDim2.new(0, TargetSizeX, 0, TargetSizeY)
PhoneFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PhoneFrame.BorderSizePixel  = 0
PhoneFrame.ClipsDescendants = true
PhoneFrame.Visible          = false
PhoneFrame.Parent           = PhoneScreenGui
Instance.new("UICorner", PhoneFrame).CornerRadius = UDim.new(0, 6)

local PhoneStroke = Instance.new("UIStroke")
PhoneStroke.Color = Color3.fromRGB(90,35,200) PhoneStroke.Thickness = 2 PhoneStroke.Parent = PhoneFrame

-- ViewportFrame approach: mirror SurfaceGui content bang UIClone realtime
local ContentContainer = Instance.new("Frame")
ContentContainer.Name             = "Content"
ContentContainer.AnchorPoint      = Vector2.new(0.5, 0.5)
ContentContainer.Position         = UDim2.new(0.5, 0, 0.5, 0)
ContentContainer.BackgroundColor3 = Color3.fromRGB(0,0,0)
ContentContainer.BorderSizePixel  = 0
ContentContainer.ClipsDescendants = true
ContentContainer.Parent           = PhoneFrame

local PhoneScale = Instance.new("UIScale")
PhoneScale.Parent = ContentContainer

-- Drag bar
local DragBar = Instance.new("TextButton")
DragBar.Size              = UDim2.new(1,0,0,20)
DragBar.Position          = UDim2.new(0,0,0,0)
DragBar.BackgroundColor3  = Color3.fromRGB(30,20,60)
DragBar.BackgroundTransparency = 0.3
DragBar.Text              = "drag"
DragBar.TextColor3        = Color3.fromRGB(180,180,180)
DragBar.Font              = Enum.Font.Gotham
DragBar.TextSize          = 10
DragBar.BorderSizePixel   = 0
DragBar.Visible           = false
DragBar.ZIndex            = 20
DragBar.Parent            = PhoneFrame
Instance.new("UICorner", DragBar).CornerRadius = UDim.new(0,4)

local fDragging, fStart, fPos = false, nil, nil
DragBar.InputBegan:Connect(function(input)
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
        local d = Vector2.new(input.Position.X, input.Position.Y) - fStart
        PhoneFrame.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset+d.X, fPos.Y.Scale, fPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        fDragging = false
    end
end)

-- Resize handles — FIX: khong di chuyen frame khi tha tay
local activeResizer, rStartMouse, rStartSize, rStartPos = nil, nil, nil, nil

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

local resizeHandles = {}

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
    h.Name = def.Name h.Size = def.Size h.Position = def.Pos h.AnchorPoint = def.Anchor
    h.BackgroundColor3 = Color3.fromRGB(0,150,255) h.BackgroundTransparency = 0.4
    h.Text = "" h.ZIndex = 21 h.Visible = false h.Parent = PhoneFrame
    table.insert(resizeHandles, h)

    h.InputBegan:Connect(function(input)
        if not PhoneResizeEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            activeResizer = def.Action
            rStartMouse   = Vector2.new(input.Position.X, input.Position.Y)
            rStartSize    = PhoneFrame.AbsoluteSize
            rStartPos     = PhoneFrame.AbsolutePosition
        end
    end)
end

UIS.InputChanged:Connect(function(input)
    if not activeResizer then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - rStartMouse
        local nW, nH = rStartSize.X, rStartSize.Y
        local nX, nY = rStartPos.X,  rStartPos.Y
        if activeResizer:find("E")  then nW = rStartSize.X + delta.X end
        if activeResizer:find("S")  then nH = rStartSize.Y + delta.Y end
        if activeResizer:find("W")  then nW = rStartSize.X - delta.X nX = rStartPos.X + delta.X end
        if activeResizer:find("N")  then nH = rStartSize.Y - delta.Y nY = rStartPos.Y + delta.Y end
        nW = math.max(50, nW) nH = math.max(50, nH)
        PhoneFrame.Size     = UDim2.new(0, nW, 0, nH)
        -- FIX: chi cap nhat Position khi resize tu canh/goc co anh huong Position (W, N)
        -- khong di chuyen neu chi resize E hoac S
        if activeResizer:find("W") or activeResizer:find("N") then
            PhoneFrame.Position = UDim2.new(0, nX, 0, nY)
        end
        TargetSizeX = nW TargetSizeY = nH
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        -- FIX: khoa lai vi tri sau khi tha tay, khong co them code gi ca
        -- vi tri da duoc set trong InputChanged, no se giu nguyen sau khi InputEnded
        activeResizer = nil
    end
end)

-- ============================================================
-- // PHONE SCREEN CORE — REALTIME SCREENGUI MIRROR
-- ============================================================
local syncConn          = nil
local currentSurfaceGui = nil
local cloneMap          = {} -- {original = clone}

local function ClearMirror()
    for _, clone in pairs(cloneMap) do
        pcall(function() clone:Destroy() end)
    end
    cloneMap = {}
end

local function DeepClone(instance)
    local ok, clone = pcall(function() return instance:Clone() end)
    if not ok or not clone then return nil end
    -- Xoa LocalScript de tranh loi
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("LuaSourceContainer") then pcall(function() d:Destroy() end) end
    end
    return clone
end

local function SyncProperties(orig, clone)
    if not orig or not orig.Parent or not clone or not clone.Parent then return end
    pcall(function()
        if orig:IsA("GuiObject") then
            clone.Visible             = orig.Visible
            clone.Position            = orig.Position
            clone.Size                = orig.Size
            clone.BackgroundColor3    = orig.BackgroundColor3
            clone.BackgroundTransparency = orig.BackgroundTransparency
            clone.AnchorPoint         = orig.AnchorPoint
            clone.ZIndex              = orig.ZIndex
            clone.Rotation            = orig.Rotation
        end
        if orig:IsA("TextLabel") or orig:IsA("TextButton") or orig:IsA("TextBox") then
            clone.Text                    = orig.Text
            clone.TextColor3              = orig.TextColor3
            clone.TextTransparency        = orig.TextTransparency
            clone.TextStrokeColor3        = orig.TextStrokeColor3
            clone.TextStrokeTransparency  = orig.TextStrokeTransparency
            clone.TextSize                = orig.TextSize
            clone.Font                    = orig.Font
        end
        if orig:IsA("ImageLabel") or orig:IsA("ImageButton") then
            clone.Image               = orig.Image
            clone.ImageColor3         = orig.ImageColor3
            clone.ImageTransparency   = orig.ImageTransparency
            clone.ImageRectOffset     = orig.ImageRectOffset
            clone.ImageRectSize       = orig.ImageRectSize
        end
        if orig:IsA("ScrollingFrame") then
            clone.CanvasPosition = orig.CanvasPosition
            clone.CanvasSize     = orig.CanvasSize
        end
        if orig:IsA("Frame") then
            clone.BackgroundColor3       = orig.BackgroundColor3
            clone.BackgroundTransparency = orig.BackgroundTransparency
        end
    end)
end

local function BuildMirror(surfaceGui)
    ClearMirror()
    UpdatePhoneScale(surfaceGui)

    for _, child in ipairs(surfaceGui:GetChildren()) do
        if not child:IsA("LuaSourceContainer") then
            local clone = DeepClone(child)
            if clone then
                clone.Parent = ContentContainer
                cloneMap[child] = clone
                -- Map descendants
                local origDescs  = child:GetDescendants()
                local cloneDescs = clone:GetDescendants()
                for i, od in ipairs(origDescs) do
                    if cloneDescs[i] then
                        cloneMap[od] = cloneDescs[i]
                    end
                end
            end
        end
    end
end

local function StartMirrorSync(surfaceGui)
    if syncConn then syncConn:Disconnect() syncConn = nil end

    BuildMirror(surfaceGui)

    syncConn = RunService.Heartbeat:Connect(function()
        if not PhoneFrame.Visible or not surfaceGui or not surfaceGui.Parent then
            if syncConn then syncConn:Disconnect() syncConn = nil end
            return
        end

        UpdatePhoneScale(surfaceGui)

        -- Sync properties tung cap moi frame
        for orig, clone in pairs(cloneMap) do
            if not orig.Parent or not clone.Parent then
                -- Xoa cap bi mat
                pcall(function() clone:Destroy() end)
                cloneMap[orig] = nil
            else
                SyncProperties(orig, clone)
            end
        end

        -- Them clone cho instance moi xuat hien
        for _, child in ipairs(surfaceGui:GetDescendants()) do
            if not child:IsA("LuaSourceContainer") and not cloneMap[child] then
                -- Tim parent clone
                local parentClone = cloneMap[child.Parent]
                if parentClone then
                    local clone = DeepClone(child)
                    if clone then
                        clone.Parent = parentClone
                        cloneMap[child] = clone
                    end
                end
            end
        end
    end)
end

local function ShowPhoneScreen(tool)
    if not PhoneScreenEnabled then return end
    local surfaceGui = tool:FindFirstChildWhichIsA("SurfaceGui", true)
    if not surfaceGui then
        Rayfield:Notify({ Title="Phone", Content="Khong tim thay SurfaceGui trong Phone1", Duration=3 })
        return
    end
    currentSurfaceGui  = surfaceGui
    PhoneFrame.Visible = true
    StartMirrorSync(surfaceGui)
end

local function HidePhoneScreen()
    PhoneFrame.Visible = false
    if syncConn then syncConn:Disconnect() syncConn = nil end
    ClearMirror()
    currentSurfaceGui = nil
end

local function CheckAndShowPhone()
    local char = LocalPlayer.Character
    if not char then return end
    local phone = char:FindFirstChild("Phone1")
    if phone then task.wait(0.2) ShowPhoneScreen(phone) end
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
    Name="Show Phone Screen", CurrentValue=false, Flag="ShowPhoneScreen",
    Callback=function(val)
        PhoneScreenEnabled = val
        if val then CheckAndShowPhone() else HidePhoneScreen() end
    end,
})

GameTab:CreateToggle({
    Name="Drag Mode", CurrentValue=false, Flag="PhoneDragMode",
    Callback=function(val)
        PhoneDragEnabled   = val
        DragBar.Visible    = val
    end,
})

GameTab:CreateToggle({
    Name="Resize Mode", CurrentValue=false, Flag="PhoneResizeMode",
    Callback=function(val)
        PhoneResizeEnabled = val
        for _, h in ipairs(resizeHandles) do h.Visible = val end
    end,
})

GameTab:CreateInput({
    Name="Size (Width, Height)", PlaceholderText="VD: 200, 400",
    RemoveTextAfterFocusLost=false,
    Callback=function(text)
        local x, y = text:match("(%d+)[^%d]+(%d+)")
        if x and y then
            TargetSizeX = tonumber(x) TargetSizeY = tonumber(y)
            PhoneFrame.Size = UDim2.new(0, TargetSizeX, 0, TargetSizeY)
            if currentSurfaceGui then UpdatePhoneScale(currentSurfaceGui) end
        else
            Rayfield:Notify({ Title="Loi", Content="Nhap dang: 200, 400", Duration=3 })
        end
    end,
})

GameTab:CreateDivider()

GameTab:CreateToggle({
    Name="Teacher ESP", CurrentValue=false, Flag="TeacherESP",
    Callback=function(val)
        TeacherESPEnabled = val
        if val then StartTeacherESP() else StopTeacherESP() end
    end,
})

GameTab:CreateColorPicker({
    Name="Teacher ESP Color", Color=ESPConfig.TeacherColor, Flag="TeacherColor",
    Callback=function(val) ESPConfig.TeacherColor=val UpdateESPColors("Teacher",val) end,
})

GameTab:CreateDivider()

GameTab:CreateToggle({
    Name="Player ESP", CurrentValue=false, Flag="PlayerESP",
    Callback=function(val)
        PlayerESPEnabled = val
        if val then StartPlayerESP() else StopPlayerESP() end
    end,
})

GameTab:CreateColorPicker({
    Name="Player ESP Color", Color=ESPConfig.PlayerColor, Flag="PlayerColor",
    Callback=function(val) ESPConfig.PlayerColor=val UpdateESPColors("Player",val) end,
})

local PlayerTab = Window:CreateTab("Player", "user")

PlayerTab:CreateToggle({
    Name="Third Person", CurrentValue=false, Flag="ThirdPerson",
    Callback=function(val)
        ThirdPersonEnabled = val
        if val then StartThirdPerson() else StopThirdPerson() end
    end,
})

PlayerTab:CreateToggle({
    Name="Show Button In Screen (Third Person)", CurrentValue=false, Flag="ShowTPBtn",
    Callback=function(val)
        if val then CreateQuickToggleBtn() else DestroyQuickBtn() end
    end,
})

Rayfield:Notify({ Title="Coconut Hub", Content="Loaded successfully!", Duration=3 })
print("[Coconut Hub] Loaded")
