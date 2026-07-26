if _G.a then
    for _, connection in pairs(_G.a) do
        connection:Disconnect()
    end
    _G.a = nil
end

repeat task.wait() until game.Players.LocalPlayer
local LocalPlayer = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local IsInvisible = false
local VisibleParts = {}

local function SetupCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    VisibleParts = {}
    for _, descendant in pairs(Character:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency == 0 then
            table.insert(VisibleParts, descendant)
        end
    end
end

local function CreateGUI()
    -- Xoa GUI cu neu co
    local old = game:GetService("CoreGui"):FindFirstChild("InvisGui")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InvisGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    -- nut chinh toggle invisible
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 80, 0, 80)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -40)
    ToggleButton.Text = "INVIS\nOFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 13
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    ToggleButton.ZIndex = 10
    ToggleButton.Parent = ScreenGui
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    -- nut khoa
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0, 28, 0, 28)
    LockBtn.Position = UDim2.new(0, 72, 0.5, -68)
    LockBtn.Text = "🔓"
    LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextSize = 14
    LockBtn.BorderSizePixel = 0
    LockBtn.AutoButtonColor = false
    LockBtn.ZIndex = 11
    LockBtn.Parent = ScreenGui
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(1, 0)

    -- drag logic
    local DragLocked = false
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    local Moved = false

    local function UpdateLockBtn()
        LockBtn.Text = DragLocked and "🔒" or "🔓"
        LockBtn.BackgroundColor3 = DragLocked
            and Color3.fromRGB(180, 120, 0)
            or Color3.fromRGB(40, 40, 40)
    end

    LockBtn.MouseButton1Click:Connect(function()
        DragLocked = not DragLocked
        UpdateLockBtn()
    end)

    -- sync vi tri LockBtn theo ToggleButton
    game:GetService("RunService").RenderStepped:Connect(function()
        local pos = ToggleButton.Position
        LockBtn.Position = UDim2.new(
            pos.X.Scale, pos.X.Offset + 60,
            pos.Y.Scale, pos.Y.Offset - 10
        )
    end)

    ToggleButton.InputBegan:Connect(function(input)
        if DragLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Moved = false
            DragStart = Vector2.new(input.Position.X, input.Position.Y)
            StartPos = ToggleButton.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not Dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - DragStart
            if delta.Magnitude > 6 then Moved = true end
            ToggleButton.Position = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        if Moved then Moved = false return end
        IsInvisible = not IsInvisible
        local transparency = IsInvisible and 0.5 or 0
        for _, part in pairs(VisibleParts) do
            part.Transparency = transparency
        end
        ToggleButton.Text = IsInvisible and "INVIS\nON" or "INVIS\nOFF"
        ToggleButton.BackgroundColor3 = IsInvisible
            and Color3.fromRGB(40, 180, 40)
            or Color3.fromRGB(200, 40, 40)
    end)
end

SetupCharacter()
CreateGUI()

local Connections = {}

-- Giu nguyen KeyDown logic goc
Connections[1] = LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == "g" then
        IsInvisible = not IsInvisible
        local transparency = IsInvisible and 0.5 or 0
        for _, part in pairs(VisibleParts) do
            part.Transparency = transparency
        end
    end
end)

-- Giu nguyen teleport loop logic goc
Connections[2] = game:GetService("RunService").Heartbeat:Connect(function()
    if IsInvisible then
        local OriginalCFrame = HumanoidRootPart.CFrame
        local OriginalCameraOffset = Humanoid.CameraOffset

        local DownCFrame = OriginalCFrame * CFrame.new(0, -200000, 0)
        HumanoidRootPart.CFrame = DownCFrame
        Humanoid.CameraOffset = DownCFrame:ToObjectSpace(CFrame.new(OriginalCFrame.Position)).Position

        game:GetService("RunService").RenderStepped:Wait()

        HumanoidRootPart.CFrame = OriginalCFrame
        Humanoid.CameraOffset = OriginalCameraOffset
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    IsInvisible = false
    SetupCharacter()
    CreateGUI()
end)

_G.a = Connections
