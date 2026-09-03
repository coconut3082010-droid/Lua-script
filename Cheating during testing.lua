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
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local CoreGui    = game:GetService("CoreGui")

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
    hl.FillColor = fillColor hl.OutlineColor = outlineColor
    hl.FillTransparency = 0.6 hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = adornee hl.Parent = adornee
    return hl
end

local function BuildBillboard(adornee, text, textColor)
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true bb.Size = UDim2.new(0,120,0,40)
    bb.StudsOffset = Vector3.new(0,3,0) bb.Adornee = adornee bb.Parent = CoreGui
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0) lbl.BackgroundTransparency = 1
    lbl.Text = text lbl.TextColor3 = textColor lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13 lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.new(0,0,0) lbl.Parent = bb
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
            if data.Highlight then data.Highlight.FillColor = color data.Highlight.OutlineColor = color end
            if data.NameLbl   then data.NameLbl.TextColor3  = color end
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
        ESPObjects["Teacher"] = { Highlight=hl, Billboard=bb, NameLbl=lbl, Type="Teacher" }
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
local playerAddedConn, playerRemovingConn = nil, nil

local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    local key = "Player_" .. player.UserId
    local function Attach(char)
        RemoveESP(key)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local hl = BuildHighlight(char, ESPConfig.PlayerColor, ESPConfig.PlayerColor)
        local bb, lbl = BuildBillboard(root, player.DisplayName, ESPConfig.PlayerColor)
        ESPObjects[key] = { Highlight=hl, Billboard=bb, NameLbl=lbl, Type="Player" }
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
        RemoveESP("Player_"..p.UserId)
    end)
end

local function StopPlayerESP()
    if playerAddedConn    then playerAddedConn:Disconnect()    playerAddedConn    = nil end
    if playerRemovingConn then playerRemovingConn:Disconnect() playerRemovingConn = nil end
    ClearESPByType("Player")
end

-- ============================================================
-- // FULLBRIGHT
-- ============================================================
local FullbrightEnabled = false
local savedAmbient, savedOutdoor, savedBrightness, savedFogEnd = nil, nil, nil, nil

local function StartFullbright()
    savedAmbient    = Lighting.Ambient
    savedOutdoor    = Lighting.OutdoorAmbient
    savedBrightness = Lighting.Brightness
    savedFogEnd     = Lighting.FogEnd
    Lighting.Ambient        = Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    Lighting.Brightness     = 2
    Lighting.FogEnd         = 100000
    for _, fx in ipairs(Lighting:GetChildren()) do
        if fx:IsA("BlurEffect") or fx:IsA("ColorCorrectionEffect")
            or fx:IsA("SunRaysEffect") or fx:IsA("DepthOfFieldEffect") then
            pcall(function() fx.Enabled = false end)
        end
    end
end

local function StopFullbright()
    if savedAmbient    then Lighting.Ambient        = savedAmbient    end
    if savedOutdoor    then Lighting.OutdoorAmbient = savedOutdoor    end
    if savedBrightness then Lighting.Brightness     = savedBrightness end
    if savedFogEnd     then Lighting.FogEnd         = savedFogEnd     end
    for _, fx in ipairs(Lighting:GetChildren()) do
        if fx:IsA("BlurEffect") or fx:IsA("ColorCorrectionEffect")
            or fx:IsA("SunRaysEffect") or fx:IsA("DepthOfFieldEffect") then
            pcall(function() fx.Enabled = true end)
        end
    end
end

-- ============================================================
-- // FIX LAG
-- ============================================================
local function FixLag()
    settings().Rendering.QualityLevel = 1
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ParticleEmitter") or p:IsA("Trail") or p:IsA("Beam") then
            pcall(function() p.Enabled = false end)
        end
    end
    Rayfield:Notify({ Title="Fix Lag", Content="Quality set to 1, particles disabled.", Duration=3 })
end

-- ============================================================
-- // THIRD PERSON
-- ============================================================
local ThirdPersonEnabled = false
local camConn, inputConn1, inputConn2, savedCamType = nil, nil, nil, nil
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
    local function D(p)
        for _, s in ipairs(p:GetDescendants()) do
            if s:IsA("LocalScript") or s:IsA("ModuleScript") then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then pcall(function() s.Disabled = true end) end
            end
        end
    end
    D(workspace)
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then D(ps) end
end

local function EnableGameCameraScripts()
    local function E(p)
        for _, s in ipairs(p:GetDescendants()) do
            if s:IsA("LocalScript") or s:IsA("ModuleScript") then
                local n = s.Name:lower()
                if n:find("camera") or n:find("cam") then pcall(function() s.Disabled = false end) end
            end
        end
    end
    E(workspace)
    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then E(ps) end
end

local function CreateMobileZoomButtons()
    if CamGui then CamGui:Destroy() end
    CamGui = Instance.new("ScreenGui")
    CamGui.Name="CoconutCamZoom" CamGui.ResetOnSpawn=false
    CamGui.IgnoreGuiInset=true CamGui.DisplayOrder=1 CamGui.Parent=CoreGui
    local function MkZ(txt, x)
        local b = Instance.new("TextButton")
        b.Size=UDim2.new(0,36,0,36) b.Position=UDim2.new(1,x,0,10)
        b.BackgroundColor3=Color3.fromRGB(30,20,60) b.BackgroundTransparency=0.3
        b.Text=txt b.TextColor3=Color3.fromRGB(255,255,255) b.Font=Enum.Font.GothamBold
        b.TextSize=18 b.BorderSizePixel=0 b.ZIndex=2 b.Parent=CamGui
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8) return b
    end
    local zi=MkZ("+", -80) local zo=MkZ("-", -40)
    zi.MouseButton1Click:Connect(function() distance=math.max(3,distance-2) end)
    zo.MouseButton1Click:Connect(function() distance=math.min(50,distance+2) end)
end

local function StartCamLoop()
    local cam = workspace.CurrentCamera
    local lastMousePos = nil
    if isMobile then
        inputConn1 = UIS.InputBegan:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType==Enum.UserInputType.Touch and activeTouchId==nil then
                activeTouchId=input lastTouchPos=Vector2.new(input.Position.X,input.Position.Y)
            end
        end)
        inputConn2 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType==Enum.UserInputType.Touch and input==activeTouchId then
                local cur=Vector2.new(input.Position.X,input.Position.Y)
                if lastTouchPos then
                    local dx,dy=cur.X-lastTouchPos.X,cur.Y-lastTouchPos.Y
                    if math.abs(dx)<60 and math.abs(dy)<60 then
                        angleX=angleX-dx*0.3 angleY=math.clamp(angleY-dy*0.3,-75,75)
                    end
                end
                lastTouchPos=cur
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch and input==activeTouchId then
                activeTouchId=nil lastTouchPos=nil
            end
        end)
    else
        inputConn1 = UIS.InputChanged:Connect(function(input)
            if not ThirdPersonEnabled then return end
            if input.UserInputType==Enum.UserInputType.MouseWheel then
                distance=math.clamp(distance-input.Position.Z*2,3,50)
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
                angleX=angleX-(mp.X-lastMousePos.X)*0.35
                angleY=math.clamp(angleY-(mp.Y-lastMousePos.Y)*0.35,-75,75)
            end
            lastMousePos=mp
        end
        cam.CFrame = CFrame.new(root.Position+Vector3.new(0,2,0))
            *CFrame.Angles(0,math.rad(angleX),0)
            *CFrame.Angles(math.rad(angleY),0,0)
            *CFrame.new(0,0,distance)
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=0 end
            end
        end
    end)
end

local function StopThirdPersonInternal()
    if camConn    then camConn:Disconnect()    camConn    = nil end
    if inputConn1 then inputConn1:Disconnect() inputConn1 = nil end
    if inputConn2 then inputConn2:Disconnect() inputConn2 = nil end
    if CamGui     then CamGui:Destroy()        CamGui     = nil end
    activeTouchId=nil lastTouchPos=nil
    EnableGameCameraScripts()
    if savedCamType then workspace.CurrentCamera.CameraType=savedCamType end
end

local function StartThirdPerson()
    savedCamType=workspace.CurrentCamera.CameraType
    angleX=0 angleY=20 distance=10
    DisableGameCameraScripts()
    if isMobile then CreateMobileZoomButtons() end
    StartCamLoop() UpdateQuickBtn(true)
end

local function StopThirdPerson()
    StopThirdPersonInternal() UpdateQuickBtn(false)
end

local function CreateQuickToggleBtn()
    DestroyQuickBtn()
    QuickBtnGui=Instance.new("ScreenGui")
    QuickBtnGui.Name="CoconutQuickTP" QuickBtnGui.ResetOnSpawn=false
    QuickBtnGui.IgnoreGuiInset=true QuickBtnGui.DisplayOrder=2 QuickBtnGui.Parent=CoreGui
    local Btn=Instance.new("TextButton")
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
        if ThirdPersonEnabled then if not camConn then pcall(StartThirdPerson) end
        else StopThirdPersonInternal() end
    end)
end

-- ============================================================
-- // PHONE SCREEN
-- ============================================================
local PhoneScreenEnabled = false
local PhoneDragEnabled   = false
local PhoneResizeEnabled = false
local TargetSizeX        = 50
local TargetSizeY        = 100

local PhoneScreenGui = Instance.new("ScreenGui")
PhoneScreenGui.Name="CoconutPhoneScreen" PhoneScreenGui.ResetOnSpawn=false
PhoneScreenGui.DisplayOrder=5 PhoneScreenGui.IgnoreGuiInset=true PhoneScreenGui.Parent=CoreGui

local PhoneFrame = Instance.new("Frame")
PhoneFrame.AnchorPoint=Vector2.new(1,0) PhoneFrame.Position=UDim2.new(1,-10,0,60)
PhoneFrame.Size=UDim2.new(0,TargetSizeX,0,TargetSizeY) PhoneFrame.BackgroundColor3=Color3.fromRGB(0,0,0)
PhoneFrame.BorderSizePixel=0 PhoneFrame.ClipsDescendants=true PhoneFrame.Visible=false PhoneFrame.Parent=PhoneScreenGui
Instance.new("UICorner",PhoneFrame).CornerRadius=UDim.new(0,6)
local PhoneStroke=Instance.new("UIStroke") PhoneStroke.Color=Color3.fromRGB(90,35,200) PhoneStroke.Thickness=2 PhoneStroke.Parent=PhoneFrame

local ContentContainer=Instance.new("Frame")
ContentContainer.Name="Content" ContentContainer.AnchorPoint=Vector2.new(0.5,0.5)
ContentContainer.Position=UDim2.new(0.5,0,0.5,0) ContentContainer.BackgroundColor3=Color3.fromRGB(0,0,0)
ContentContainer.BorderSizePixel=0 ContentContainer.ClipsDescendants=true ContentContainer.Parent=PhoneFrame

local PhoneScale=Instance.new("UIScale") PhoneScale.Parent=ContentContainer

local DragBar=Instance.new("TextButton")
DragBar.Size=UDim2.new(1,0,0,20) DragBar.Position=UDim2.new(0,0,0,0)
DragBar.BackgroundColor3=Color3.fromRGB(30,20,60) DragBar.BackgroundTransparency=0.3
DragBar.Text="drag" DragBar.TextColor3=Color3.fromRGB(180,180,180)
DragBar.Font=Enum.Font.Gotham DragBar.TextSize=10 DragBar.BorderSizePixel=0
DragBar.Visible=false DragBar.ZIndex=20 DragBar.Parent=PhoneFrame
Instance.new("UICorner",DragBar).CornerRadius=UDim.new(0,4)

local fDragging,fStart,fPos=false,nil,nil
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        fDragging=true fStart=Vector2.new(input.Position.X,input.Position.Y) fPos=PhoneFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if fDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=Vector2.new(input.Position.X,input.Position.Y)-fStart
        PhoneFrame.Position=UDim2.new(fPos.X.Scale,fPos.X.Offset+d.X,fPos.Y.Scale,fPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then fDragging=false end
end)

-- ============================================================
-- // RESIZE — FIX: dung AbsolutePosition luu truoc, khong cap nhat Position khi resize E/S
-- ============================================================
local activeResizer,rStartMouse,rStartSize,rStartPos=nil,nil,nil,nil
local resizeHandles={}

local handleDefs={
    {Name="Top",    Size=UDim2.new(1,-20,0,10), Pos=UDim2.new(0,10,0,0),  Anchor=Vector2.new(0,0), Action="N"},
    {Name="Bottom", Size=UDim2.new(1,-20,0,10), Pos=UDim2.new(0,10,1,-10),Anchor=Vector2.new(0,1), Action="S"},
    {Name="Left",   Size=UDim2.new(0,10,1,-20), Pos=UDim2.new(0,0,0,10),  Anchor=Vector2.new(0,0), Action="W"},
    {Name="Right",  Size=UDim2.new(0,10,1,-20), Pos=UDim2.new(1,-10,0,10),Anchor=Vector2.new(1,0), Action="E"},
    {Name="TL",     Size=UDim2.new(0,14,0,14),  Pos=UDim2.new(0,0,0,0),   Anchor=Vector2.new(0,0), Action="NW"},
    {Name="TR",     Size=UDim2.new(0,14,0,14),  Pos=UDim2.new(1,-14,0,0), Anchor=Vector2.new(0,0), Action="NE"},
    {Name="BL",     Size=UDim2.new(0,14,0,14),  Pos=UDim2.new(0,0,1,-14), Anchor=Vector2.new(0,0), Action="SW"},
    {Name="BR",     Size=UDim2.new(0,14,0,14),  Pos=UDim2.new(1,-14,1,-14),Anchor=Vector2.new(0,0),Action="SE"},
}

local function UpdatePhoneScale(surfaceGui)
    if not surfaceGui then return end
    local canvas=surfaceGui.CanvasSize
    if canvas and canvas.X>0 and canvas.Y>0 then
        ContentContainer.Size=UDim2.new(0,canvas.X,0,canvas.Y)
        local sx=PhoneFrame.AbsoluteSize.X/canvas.X
        local sy=PhoneFrame.AbsoluteSize.Y/canvas.Y
        PhoneScale.Scale=math.min(sx,sy)
    end
end

for _, def in ipairs(handleDefs) do
    local h=Instance.new("TextButton")
    h.Name=def.Name h.Size=def.Size h.Position=def.Pos h.AnchorPoint=def.Anchor
    h.BackgroundColor3=Color3.fromRGB(0,150,255) h.BackgroundTransparency=0.3
    h.Text="" h.ZIndex=21 h.Visible=false h.Parent=PhoneFrame
    table.insert(resizeHandles,h)

    h.InputBegan:Connect(function(input)
        if not PhoneResizeEnabled then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            activeResizer=def.Action
            rStartMouse=Vector2.new(input.Position.X,input.Position.Y)
            -- Luu AbsoluteSize va AbsolutePosition tai thoi diem bat dau resize
            rStartSize=Vector2.new(PhoneFrame.AbsoluteSize.X,PhoneFrame.AbsoluteSize.Y)
            rStartPos=Vector2.new(PhoneFrame.AbsolutePosition.X,PhoneFrame.AbsolutePosition.Y)
        end
    end)
end

UIS.InputChanged:Connect(function(input)
    if not activeResizer then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        local delta=Vector2.new(input.Position.X,input.Position.Y)-rStartMouse
        local nW=rStartSize.X
        local nH=rStartSize.Y
        local nX=rStartPos.X
        local nY=rStartPos.Y

        -- Tinh toan dung: chi thay doi size va pos theo huong keo
        if activeResizer=="E"  or activeResizer=="NE" or activeResizer=="SE" then nW=rStartSize.X+delta.X end
        if activeResizer=="W"  or activeResizer=="NW" or activeResizer=="SW" then
            nW=rStartSize.X-delta.X nX=rStartPos.X+delta.X
        end
        if activeResizer=="S"  or activeResizer=="SE" or activeResizer=="SW" then nH=rStartSize.Y+delta.Y end
        if activeResizer=="N"  or activeResizer=="NW" or activeResizer=="NE" then
            nH=rStartSize.Y-delta.Y nY=rStartPos.Y+delta.Y
        end

        nW=math.max(50,nW) nH=math.max(50,nH)

        -- Cap nhat Size luon
        PhoneFrame.Size=UDim2.new(0,nW,0,nH)

        -- Chi cap nhat Position khi can (W hoac N direction)
        if activeResizer=="W" or activeResizer=="NW" or activeResizer=="SW" or
           activeResizer=="N" or activeResizer=="NE" then
            PhoneFrame.Position=UDim2.new(0,nX,0,nY)
        end

        TargetSizeX=nW TargetSizeY=nH
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        activeResizer=nil
    end
end)

-- ============================================================
-- // PHONE MIRROR CORE
-- ============================================================
local syncConn=nil
local currentSurfaceGui=nil
local cloneMap={}

local function ClearMirror()
    for _,clone in pairs(cloneMap) do pcall(function() clone:Destroy() end) end
    cloneMap={}
end

local function DeepClone(inst)
    local ok,clone=pcall(function() return inst:Clone() end)
    if not ok or not clone then return nil end
    for _,d in ipairs(clone:GetDescendants()) do
        if d:IsA("LuaSourceContainer") then pcall(function() d:Destroy() end) end
    end
    return clone
end

local function SyncProperties(orig,clone)
    if not orig or not orig.Parent or not clone or not clone.Parent then return end
    pcall(function()
        if orig:IsA("GuiObject") then
            clone.Visible=orig.Visible clone.Position=orig.Position clone.Size=orig.Size
            clone.BackgroundColor3=orig.BackgroundColor3 clone.BackgroundTransparency=orig.BackgroundTransparency
            clone.AnchorPoint=orig.AnchorPoint clone.ZIndex=orig.ZIndex clone.Rotation=orig.Rotation
        end
        if orig:IsA("TextLabel") or orig:IsA("TextButton") or orig:IsA("TextBox") then
            clone.Text=orig.Text clone.TextColor3=orig.TextColor3 clone.TextTransparency=orig.TextTransparency
            clone.TextStrokeColor3=orig.TextStrokeColor3 clone.TextStrokeTransparency=orig.TextStrokeTransparency
            clone.TextSize=orig.TextSize clone.Font=orig.Font
        end
        if orig:IsA("ImageLabel") or orig:IsA("ImageButton") then
            clone.Image=orig.Image clone.ImageColor3=orig.ImageColor3 clone.ImageTransparency=orig.ImageTransparency
            clone.ImageRectOffset=orig.ImageRectOffset clone.ImageRectSize=orig.ImageRectSize
        end
        if orig:IsA("ScrollingFrame") then clone.CanvasPosition=orig.CanvasPosition clone.CanvasSize=orig.CanvasSize end
    end)
end

local function BuildMirror(surfaceGui)
    ClearMirror() UpdatePhoneScale(surfaceGui)
    for _,child in ipairs(surfaceGui:GetChildren()) do
        if not child:IsA("LuaSourceContainer") then
            local clone=DeepClone(child)
            if clone then
                clone.Parent=ContentContainer cloneMap[child]=clone
                local od=child:GetDescendants() local cd=clone:GetDescendants()
                for i,o in ipairs(od) do if cd[i] then cloneMap[o]=cd[i] end end
            end
        end
    end
end

local function StartMirrorSync(surfaceGui)
    if syncConn then syncConn:Disconnect() syncConn=nil end
    BuildMirror(surfaceGui)
    syncConn=RunService.Heartbeat:Connect(function()
        if not PhoneFrame.Visible or not surfaceGui or not surfaceGui.Parent then
            if syncConn then syncConn:Disconnect() syncConn=nil end return
        end
        UpdatePhoneScale(surfaceGui)
        for orig,clone in pairs(cloneMap) do
            if not orig.Parent or not clone.Parent then
                pcall(function() clone:Destroy() end) cloneMap[orig]=nil
            else SyncProperties(orig,clone) end
        end
        for _,child in ipairs(surfaceGui:GetDescendants()) do
            if not child:IsA("LuaSourceContainer") and not cloneMap[child] then
                local pc=cloneMap[child.Parent]
                if pc then
                    local clone=DeepClone(child)
                    if clone then clone.Parent=pc cloneMap[child]=clone end
                end
            end
        end
    end)
end

local function ShowPhoneScreen(tool)
    if not PhoneScreenEnabled then return end
    local sg=tool:FindFirstChildWhichIsA("SurfaceGui",true)
    if not sg then Rayfield:Notify({Title="Phone",Content="SurfaceGui not found in Phone1",Duration=3}) return end
    currentSurfaceGui=sg PhoneFrame.Visible=true StartMirrorSync(sg)
end

local function HidePhoneScreen()
    PhoneFrame.Visible=false
    if syncConn then syncConn:Disconnect() syncConn=nil end
    ClearMirror() currentSurfaceGui=nil
end

local function CheckAndShowPhone()
    local char=LocalPlayer.Character if not char then return end
    local phone=char:FindFirstChild("Phone1")
    if phone then task.wait(0.2) ShowPhoneScreen(phone) end
end

local function HookPhoneEvents(char)
    char.ChildAdded:Connect(function(child)
        if child.Name=="Phone1" then task.wait(0.2) if PhoneScreenEnabled then ShowPhoneScreen(child) end end
    end)
    char.ChildRemoved:Connect(function(child)
        if child.Name=="Phone1" then HidePhoneScreen() end
    end)
end

if LocalPlayer.Character then HookPhoneEvents(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char) HidePhoneScreen() HookPhoneEvents(char) end)

-- ============================================================
-- // RADAR
-- ============================================================
local RadarEnabled    = false
local radarConn       = nil
local RADAR_RADIUS    = 80  -- studs represented in radar
local RADAR_SIZE      = 110 -- px

local RadarGui = Instance.new("ScreenGui")
RadarGui.Name="CoconutRadar" RadarGui.ResetOnSpawn=false
RadarGui.IgnoreGuiInset=true RadarGui.DisplayOrder=8 RadarGui.Parent=CoreGui

-- Radar frame
local RadarFrame=Instance.new("Frame")
RadarFrame.Size=UDim2.new(0,RADAR_SIZE,0,RADAR_SIZE)
RadarFrame.Position=UDim2.new(0,10,1,-RADAR_SIZE-60)
RadarFrame.BackgroundColor3=Color3.fromRGB(15,15,25)
RadarFrame.BackgroundTransparency=0.3 RadarFrame.BorderSizePixel=0
RadarFrame.Visible=false RadarFrame.ZIndex=10 RadarFrame.Parent=RadarGui
Instance.new("UICorner",RadarFrame).CornerRadius=UDim.new(1,0)
local RadarStroke=Instance.new("UIStroke") RadarStroke.Color=Color3.fromRGB(60,60,120) RadarStroke.Thickness=1.5 RadarStroke.Parent=RadarFrame

-- Crosshair lines
local function MakeLine(isH)
    local l=Instance.new("Frame")
    l.BackgroundColor3=Color3.fromRGB(40,40,80) l.BorderSizePixel=0 l.ZIndex=11 l.Parent=RadarFrame
    if isH then l.Size=UDim2.new(1,0,0,1) l.Position=UDim2.new(0,0,0.5,0)
    else l.Size=UDim2.new(0,1,1,0) l.Position=UDim2.new(0.5,0,0,0) end
end
MakeLine(true) MakeLine(false)

-- Center arrow (player)
local CenterDot=Instance.new("TextLabel")
CenterDot.Size=UDim2.new(0,16,0,16) CenterDot.AnchorPoint=Vector2.new(0.5,0.5)
CenterDot.Position=UDim2.new(0.5,0,0.5,0) 
CenterDot.BackgroundTransparency=1
CenterDot.Text="▲" -- Biểu tượng mũi tên
CenterDot.TextColor3=Color3.fromRGB(100,200,255)
CenterDot.Font=Enum.Font.GothamBold CenterDot.TextSize=14
CenterDot.BorderSizePixel=0 CenterDot.ZIndex=14 CenterDot.Parent=RadarFrame

-- Teacher dot on radar
local TeacherDot=Instance.new("Frame")
TeacherDot.Size=UDim2.new(0,8,0,8) TeacherDot.AnchorPoint=Vector2.new(0.5,0.5)
TeacherDot.Position=UDim2.new(0.5,0,0.5,0) TeacherDot.BackgroundColor3=Color3.fromRGB(255,60,60)
TeacherDot.BorderSizePixel=0 TeacherDot.ZIndex=13 TeacherDot.Visible=false TeacherDot.Parent=RadarFrame
Instance.new("UICorner",TeacherDot).CornerRadius=UDim.new(1,0)

-- Warning label next to radar (Đã sửa cho đỡ chói mắt)
local WarningLabel=Instance.new("TextLabel")
WarningLabel.Size=UDim2.new(0,140,0,36)
WarningLabel.Position=UDim2.new(0,RADAR_SIZE+6,1,-RADAR_SIZE-60+RADAR_SIZE/2-18)
WarningLabel.BackgroundColor3=Color3.fromRGB(20,20,30) WarningLabel.BackgroundTransparency=0.2
WarningLabel.Text="SAFE" WarningLabel.TextColor3=Color3.fromRGB(100,255,100)
WarningLabel.Font=Enum.Font.GothamBold WarningLabel.TextSize=14
WarningLabel.BorderSizePixel=0 WarningLabel.ZIndex=10 WarningLabel.Visible=false
WarningLabel.Parent=RadarGui
Instance.new("UICorner",WarningLabel).CornerRadius=UDim.new(0,6)
-- Viền chữ màu đen giúp dễ đọc hơn, không bị lóe
local WStroke=Instance.new("UIStroke") WStroke.Color=Color3.fromRGB(0,0,0) WStroke.Thickness=1.2 WStroke.Parent=WarningLabel

-- Radar drag
local rDragging,rStart,rPos=false,nil,nil
RadarFrame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        rDragging=true rStart=Vector2.new(input.Position.X,input.Position.Y) rPos=RadarFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if rDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=Vector2.new(input.Position.X,input.Position.Y)-rStart
        local newPos=UDim2.new(rPos.X.Scale,rPos.X.Offset+d.X,rPos.Y.Scale,rPos.Y.Offset+d.Y)
        RadarFrame.Position=newPos
        -- Keep warning label next to radar
        WarningLabel.Position=UDim2.new(rPos.X.Scale,rPos.X.Offset+d.X+RADAR_SIZE+6,rPos.Y.Scale,rPos.Y.Offset+d.Y+RADAR_SIZE/2-18)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then rDragging=false end
end)

local function StartRadar()
    RadarFrame.Visible   = true
    WarningLabel.Visible = true

    radarConn = RunService.Heartbeat:Connect(function()
        if not RadarEnabled then return end

        local char = LocalPlayer.Character
        local localRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end

        local teacher = workspace:FindFirstChild("Teacher")
        local tRoot   = teacher and (teacher:FindFirstChild("HumanoidRootPart") or teacher:FindFirstChildWhichIsA("BasePart"))

        if not tRoot then
            TeacherDot.Visible = false
            WarningLabel.Text  = "? No Teacher"
            WarningLabel.TextColor3 = Color3.fromRGB(150,150,150)
            return
        end

        local pPos = localRoot.Position
        local tPos = tRoot.Position
        local diff = tPos - pPos
        local dist = diff.Magnitude

        -- 1. Xoay Mũi Tên Player
        -- Lấy góc quay Y của nhân vật và chuyển đổi sang dạng xoay của UI
        local _, yRot, _ = localRoot.CFrame:ToOrientation()
        CenterDot.Rotation = math.deg(-yRot)

        -- 2. Vị trí Teacher (Absolute Map)
        -- Trục X của game vào trục X của UI, Trục Z của game vào trục Y của UI
        local rx = math.clamp(diff.X / RADAR_RADIUS, -1, 1)
        local rz = math.clamp(diff.Z / RADAR_RADIUS, -1, 1)

        TeacherDot.Visible  = true
        TeacherDot.Position = UDim2.new(0.5 + rx*0.45, 0, 0.5 + rz*0.45, 0)

        -- 3. Khoảng cách (Cập nhật 1-10 Đỏ, 11-20 Vàng, 21+ Xanh)
        if dist >= 21 then
            WarningLabel.Text       = "SAFE  "..math.floor(dist).."st"
            WarningLabel.TextColor3 = Color3.fromRGB(100, 255, 100) -- Xanh dịu
            TeacherDot.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        elseif dist >= 11 then
            WarningLabel.Text       = "CAUTION  "..math.floor(dist).."st"
            WarningLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Vàng dịu
            TeacherDot.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        else
            WarningLabel.Text       = "DANGER!  "..math.floor(dist).."st"
            WarningLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Đỏ dịu
            TeacherDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

local function StopRadar()
    if radarConn then radarConn:Disconnect() radarConn=nil end
    RadarFrame.Visible   = false
    WarningLabel.Visible = false
end

-- ============================================================
-- // RAYFIELD TABS
-- ============================================================

-- GAME TAB
local GameTab = Window:CreateTab("Game", "gamepad")

GameTab:CreateToggle({
    Name="Show Phone Screen", CurrentValue=false, Flag="ShowPhoneScreen",
    Callback=function(val) PhoneScreenEnabled=val if val then CheckAndShowPhone() else HidePhoneScreen() end end,
})
GameTab:CreateToggle({
    Name="Drag Mode", CurrentValue=false, Flag="PhoneDragMode",
    Callback=function(val) PhoneDragEnabled=val DragBar.Visible=val end,
})
GameTab:CreateToggle({
    Name="Resize Mode", CurrentValue=false, Flag="PhoneResizeMode",
    Callback=function(val) PhoneResizeEnabled=val for _,h in ipairs(resizeHandles) do h.Visible=val end end,
})
GameTab:CreateInput({
    Name="Size (Width, Height)", PlaceholderText="e.g: 200, 400",
    RemoveTextAfterFocusLost=false,
    Callback=function(text)
        local x,y=text:match("(%d+)[^%d]+(%d+)")
        if x and y then
            TargetSizeX=tonumber(x) TargetSizeY=tonumber(y)
            PhoneFrame.Size=UDim2.new(0,TargetSizeX,0,TargetSizeY)
            if currentSurfaceGui then UpdatePhoneScale(currentSurfaceGui) end
        else Rayfield:Notify({Title="Error",Content="Enter as: 200, 400",Duration=3}) end
    end,
})

GameTab:CreateDivider()

GameTab:CreateToggle({
    Name="Teacher Radar", CurrentValue=false, Flag="TeacherRadar",
    Callback=function(val) RadarEnabled=val if val then StartRadar() else StopRadar() end end,
})

-- VISUAL TAB
local VisualTab = Window:CreateTab("Visual", "eye")

VisualTab:CreateToggle({
    Name="Teacher ESP", CurrentValue=false, Flag="TeacherESP",
    Callback=function(val) TeacherESPEnabled=val if val then StartTeacherESP() else StopTeacherESP() end end,
})
VisualTab:CreateColorPicker({
    Name="Teacher ESP Color", Color=ESPConfig.TeacherColor, Flag="TeacherColor",
    Callback=function(val) ESPConfig.TeacherColor=val UpdateESPColors("Teacher",val) end,
})
VisualTab:CreateDivider()
VisualTab:CreateToggle({
    Name="Player ESP", CurrentValue=false, Flag="PlayerESP",
    Callback=function(val) PlayerESPEnabled=val if val then StartPlayerESP() else StopPlayerESP() end end,
})
VisualTab:CreateColorPicker({
    Name="Player ESP Color", Color=ESPConfig.PlayerColor, Flag="PlayerColor",
    Callback=function(val) ESPConfig.PlayerColor=val UpdateESPColors("Player",val) end,
})
VisualTab:CreateDivider()
VisualTab:CreateToggle({
    Name="Fullbright", CurrentValue=false, Flag="Fullbright",
    Callback=function(val) FullbrightEnabled=val if val then StartFullbright() else StopFullbright() end end,
})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", "user")

PlayerTab:CreateToggle({
    Name="Third Person", CurrentValue=false, Flag="ThirdPerson",
    Callback=function(val) ThirdPersonEnabled=val if val then StartThirdPerson() else StopThirdPerson() end end,
})
PlayerTab:CreateToggle({
    Name="Show Button In Screen (Third Person)", CurrentValue=false, Flag="ShowTPBtn",
    Callback=function(val) if val then CreateQuickToggleBtn() else DestroyQuickBtn() end end,
})

-- SETTINGS TAB
local SettingTab = Window:CreateTab("Settings", "settings")

SettingTab:CreateButton({
    Name="Fix Lag",
    Callback=function() FixLag() end,
})

Rayfield:Notify({ Title="Coconut Hub", Content="Loaded successfully!", Duration=3 })
print("[Coconut Hub] Loaded")
