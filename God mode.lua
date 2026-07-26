-- God Mode | Coconut | Mini Menu + Side Detect
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- // GOD CONFIG
-- ============================================================
local GodConfig = {
    Enabled = false,
    Mode    = "HealthLoop",
}

local function GetHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function SetGodMode(state)
    GodConfig.Enabled = state
    local hum = GetHum()
    if not state and hum then
        hum.Health = math.min(hum.MaxHealth, 100)
    end
end

RunService.Heartbeat:Connect(function()
    if not GodConfig.Enabled then return end
    local hum = GetHum()
    if not hum then return end
    if GodConfig.Mode == "HealthLoop" then
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    elseif GodConfig.Mode == "MaxHealthLock" then
        hum.MaxHealth = math.huge
        hum.Health    = math.huge
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    if GodConfig.Enabled and GodConfig.Mode == "MaxHealthLock" then
        hum.MaxHealth = math.huge
        hum.Health    = math.huge
    end
    hum.HealthChanged:Connect(function(health)
        if not GodConfig.Enabled then return end
        if health <= 0 then
            task.wait()
            hum.Health = hum.MaxHealth
        end
    end)
end)

-- ============================================================
-- // SERVER/CLIENT SIDE DETECT
-- ============================================================
local DetectResult = "Detecting..."
local DetectColor  = Color3.fromRGB(200, 180, 50)

local function DetectHealthSide()
    local hum = GetHum()
    if not hum then
        DetectResult = "No character found"
        DetectColor  = Color3.fromRGB(150, 150, 150)
        return
    end

    -- Doi humanoid on dinh
    task.wait(0.5)
    hum = GetHum()
    if not hum then return end

    local clientCount = 0
    local serverCount = 0

    -- Test 3 lan lay majority
    for i = 1, 3 do
        local originalHP = hum.Health
        if originalHP <= 0 then task.wait(0.2) continue end

        local testHP = originalHP > 10 and (originalHP - 1) or (originalHP + 1)

        hum.Health = testHP
        task.wait(0.25) -- doi du lau de server co the override

        local afterHP = hum.Health
        hum.Health = originalHP
        task.wait(0.1)

        if math.abs(afterHP - testHP) > 0.5 then
            serverCount = serverCount + 1
        else
            clientCount = clientCount + 1
        end
    end

    if serverCount > clientCount then
        DetectResult = "Server-side | Won't work"
        DetectColor  = Color3.fromRGB(220, 60, 60)
    else
        DetectResult = "Client-side | Will work"
        DetectColor  = Color3.fromRGB(60, 200, 80)
    end
end

-- ============================================================
-- // GUI
-- ============================================================
local CoreGui = game:GetService("CoreGui")

local Gui = Instance.new("ScreenGui")
Gui.Name           = "CoconutGod"
Gui.ResetOnSpawn   = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder   = 999
Gui.Parent         = CoreGui

local Menu = Instance.new("Frame")
Menu.Size             = UDim2.new(0, 148, 0, 148)
Menu.Position         = UDim2.new(0, 10, 0, 10)
Menu.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
Menu.BorderSizePixel  = 0
Menu.Active           = true
Menu.ZIndex           = 10
Menu.Parent           = Gui
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 10)

local MStroke = Instance.new("UIStroke")
MStroke.Color     = Color3.fromRGB(90, 35, 200)
MStroke.Thickness = 1.5
MStroke.Parent    = Menu

-- Title / drag
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size               = UDim2.new(1, 0, 0, 20)
TitleLbl.Position           = UDim2.new(0, 0, 0, 4)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text               = "GOD MODE"
TitleLbl.TextColor3         = Color3.fromRGB(140, 90, 220)
TitleLbl.Font               = Enum.Font.GothamBold
TitleLbl.TextSize           = 11
TitleLbl.ZIndex             = 11
TitleLbl.Parent             = Menu

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

local function MkBtn(text, x, y, w, h, col)
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

local function MkLbl(x, y, w, h, text, textColor, bgColor)
    local l = Instance.new("TextLabel")
    l.Size               = UDim2.new(0, w, 0, h)
    l.Position           = UDim2.new(0, x, 0, y)
    l.BackgroundColor3   = bgColor or Color3.fromRGB(18, 14, 32)
    l.BackgroundTransparency = 0
    l.Text               = text
    l.TextColor3         = textColor or Color3.fromRGB(235, 235, 235)
    l.Font               = Enum.Font.GothamBold
    l.TextSize           = 11
    l.BorderSizePixel    = 0
    l.ZIndex             = 12
    l.Parent             = Menu
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
    return l
end

-- Row 1: God ON/OFF
local GodBtn = MkBtn("GOD  OFF", 8, 26, 132, 30, Color3.fromRGB(35, 35, 55))

-- Row 2: Mode
local ModeBtn = MkBtn("Health Loop", 8, 62, 132, 26, Color3.fromRGB(60, 20, 140))

-- Row 3: HP
local HPLbl = MkLbl(8, 94, 132, 22, "HP: --", Color3.fromRGB(80, 220, 80))

-- Row 4: Detect
local DetectLbl = MkLbl(8, 120, 132, 22, "Detecting...", Color3.fromRGB(200, 180, 50))

-- ============================================================
-- // BUTTON LOGIC
-- ============================================================
local function UpdateGodBtn()
    GodBtn.Text             = GodConfig.Enabled and "GOD  ON" or "GOD  OFF"
    GodBtn.BackgroundColor3 = GodConfig.Enabled
        and Color3.fromRGB(35, 150, 35)
        or  Color3.fromRGB(35, 35, 55)
end

local function UpdateModeBtn()
    ModeBtn.Text = GodConfig.Mode == "HealthLoop"
        and "Health Loop"
        or  "Max Health Lock"
end

GodBtn.MouseButton1Click:Connect(function()
    SetGodMode(not GodConfig.Enabled)
    UpdateGodBtn()
end)

ModeBtn.MouseButton1Click:Connect(function()
    GodConfig.Mode = GodConfig.Mode == "HealthLoop"
        and "MaxHealthLock"
        or  "HealthLoop"
    UpdateModeBtn()
end)

RunService.Heartbeat:Connect(function()
    local hum = GetHum()
    if hum then
        local hp  = hum.Health
        local mhp = hum.MaxHealth
        HPLbl.Text = hp == math.huge
            and "HP: INF"
            or  "HP: " .. math.floor(hp) .. "/" .. math.floor(mhp)
    else
        HPLbl.Text = "HP: --"
    end
    DetectLbl.Text       = DetectResult
    DetectLbl.TextColor3 = DetectColor
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.G then
        SetGodMode(not GodConfig.Enabled)
        UpdateGodBtn()
    end
end)

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    char:WaitForChild("Humanoid", 10)
    task.wait(1)
    DetectHealthSide()
end)

LocalPlayer.CharacterAdded:Connect(function()
    DetectResult = "Detecting..."
    DetectColor  = Color3.fromRGB(200, 180, 50)
    task.wait(3)
    DetectHealthSide()
end)

print("[Coconut God] Loaded — G toggle | Auto detect server/client side")
