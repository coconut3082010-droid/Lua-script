-- Fly Script | Coconut | Mini Corner
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- // FLY LOGIC
-- ============================================================
local FlyConfig = { Enabled = false, Speed = 50 }
local flyConn, bodyVel, bodyGyro = nil, nil, nil
local verticalDir = 0

local function GetChar() return LocalPlayer.Character end
local function GetRoot()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function StopFly()
    FlyConfig.Enabled = false
    verticalDir = 0
    if flyConn  then flyConn:Disconnect()  flyConn  = nil end
    if bodyVel  then bodyVel:Destroy()     bodyVel  = nil end
    if bodyGyro then bodyGyro:Destroy()    bodyGyro = nil end
    local hum = GetHum()
    if hum then hum.PlatformStand = false end
end

local function StartFly()
    local root = GetRoot()
    local hum  = GetHum()
    if not root or not hum then return end
    FlyConfig.Enabled = true
    hum.PlatformStand = true

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Parent   = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P         = 1e4
    bodyGyro.CFrame    = root.CFrame
    bodyGyro.Parent    = root

    local cam = workspace.CurrentCamera
    flyConn = RunService.Heartbeat:Connect(function()
        if not FlyConfig.Enabled then return end
        local r = GetRoot()
        local h = GetHum()
        if not r or not h then StopFly() return end

        local moveDir = Vector3.zero
        local camCF   = cam.CFrame
        local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

        if isMobile then
            local md = h.MoveDirection
            if md.Magnitude > 0 then
                local flat = Vector3.new(md.X, 0, md.Z)
                if flat.Magnitude > 0 then moveDir = flat.Unit end
            end
        else
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(camCF.LookVector.X,  0, camCF.LookVector.Z)  end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Vector3.new(camCF.LookVector.X,  0, camCF.LookVector.Z)  end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z) end
            if UIS:IsKeyDown(Enum.KeyCode.Space)           then verticalDir =  1
            elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then verticalDir = -1
            else verticalDir = 0 end
        end

        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        bodyVel.Velocity = moveDir * FlyConfig.Speed + Vector3.new(0, verticalDir * FlyConfig.Speed, 0)
        bodyGyro.CFrame  = camCF
    end)
end

local function ToggleFly()
    if FlyConfig.Enabled then StopFly() else StartFly() end
end

LocalPlayer.CharacterAdded:Connect(StopFly)

-- ============================================================
-- // GUI — MINI CORNER
-- ============================================================
local CoreGui = game:GetService("CoreGui")

local Gui = Instance.new("ScreenGui")
Gui.Name           = "CoconutFly"
Gui.ResetOnSpawn   = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder   = 999
Gui.Parent         = CoreGui

-- Menu: góc trái trên, nhỏ gọn
local Menu = Instance.new("Frame")
Menu.Size             = UDim2.new(0, 148, 0, 130)
Menu.Position         = UDim2.new(0, 10, 0, 10)
Menu.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
Menu.BorderSizePixel  = 0
Menu.Active           = true
Menu.ZIndex           = 10
Menu.Parent           = Gui
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Menu).Color = Color3.fromRGB(90, 35, 200)

-- Label nho tren cung
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(1, 0, 0, 20)
TitleLbl.Position           = UDim2.new(0, 0, 0, 4)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "COCONUT FLY"
TitleLbl.TextColor3         = Color3.fromRGB(140, 90, 220)
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextSize           = 10
TitleLbl.ZIndex             = 11
TitleLbl.Parent             = Menu

-- Drag bang title
local dragging, dragStart, startPos = false, nil, nil
TitleLbl.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos  = Menu.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        Menu.Position = UDim2.new(
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

-- Helper tao nut
local function Btn(text, x, y, w, h, col)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, w, 0, h)
    b.Position         = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = col or Color3.fromRGB(50, 25, 110)
    b.Text             = text
    b.TextColor3       = Color3.fromRGB(235, 235, 235)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 11
    b.BorderSizePixel  = 0
    b.AutoButtonColor  = false
    b.ZIndex           = 12
    b.Parent           = Menu
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

-- Row 1: FLY ON/OFF (full width)
local FlyBtn = Btn("FLY  OFF", 8, 26, 132, 30, Color3.fromRGB(35, 35, 55))

-- Row 2: UP | DOWN
local UpBtn   = Btn("UP",   8,  62, 62, 28, Color3.fromRGB(35, 50, 110))
local DownBtn = Btn("DN",  78,  62, 62, 28, Color3.fromRGB(35, 50, 110))

-- Row 3: - | speed | +
local MinusBtn = Btn("-",  8, 96, 26, 26, Color3.fromRGB(70, 20, 150))
local PlusBtn  = Btn("+", 114, 96, 26, 26, Color3.fromRGB(70, 20, 150))

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size             = UDim2.new(0, 60, 0, 26)
SpeedBox.Position         = UDim2.new(0, 40, 0, 96)
SpeedBox.BackgroundColor3 = Color3.fromRGB(20, 14, 38)
SpeedBox.Text             = tostring(FlyConfig.Speed)
SpeedBox.TextColor3       = Color3.fromRGB(255, 255, 255)
SpeedBox.Font             = Enum.Font.GothamBold
SpeedBox.TextSize         = 12
SpeedBox.TextXAlignment   = Enum.TextXAlignment.Center
SpeedBox.BorderSizePixel  = 0
SpeedBox.ClearTextOnFocus = false
SpeedBox.ZIndex           = 12
SpeedBox.Parent           = Menu
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)
local SBStroke = Instance.new("UIStroke")
SBStroke.Color     = Color3.fromRGB(90, 35, 200)
SBStroke.Thickness = 1
SBStroke.Parent    = SpeedBox

-- ============================================================
-- // BUTTON LOGIC
-- ============================================================
local function UpdateFlyBtn()
    FlyBtn.Text             = FlyConfig.Enabled and "FLY  ON" or "FLY  OFF"
    FlyBtn.BackgroundColor3 = FlyConfig.Enabled
        and Color3.fromRGB(35, 150, 35)
        or  Color3.fromRGB(35, 35, 55)
end

local function UpdateSpeed()
    SpeedBox.Text = tostring(FlyConfig.Speed)
end

FlyBtn.MouseButton1Click:Connect(function()
    ToggleFly()
    UpdateFlyBtn()
end)

UpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        verticalDir = 1
    end
end)
UpBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if verticalDir == 1 then verticalDir = 0 end
    end
end)

DownBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        verticalDir = -1
    end
end)
DownBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if verticalDir == -1 then verticalDir = 0 end
    end
end)

MinusBtn.MouseButton1Click:Connect(function()
    FlyConfig.Speed = math.max(5, FlyConfig.Speed - 5)
    UpdateSpeed()
end)

PlusBtn.MouseButton1Click:Connect(function()
    FlyConfig.Speed = math.min(500, FlyConfig.Speed + 5)
    UpdateSpeed()
end)

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then FlyConfig.Speed = math.clamp(val, 5, 500) end
    UpdateSpeed()
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        ToggleFly()
        UpdateFlyBtn()
    end
end)

print("[Coconut Fly] Loaded — F toggle PC | WASD+Space/Ctrl PC | UP/DN button mobile")
