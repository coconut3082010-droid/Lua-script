-- =======================================================
-- CUSTOM JUNKIE KEY SYSTEM UI: COCONUT HUB (SOLID & CLEAR)
-- Dán mã này vào tab UI-Source trên trang quản trị Junkie
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Xóa UI cũ nếu đang chạy
if CoreGui:FindFirstChild("CoconutJunkieUI") then
    CoreGui.CoconutJunkieUI:Destroy()
end

-- 1. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoconutJunkieUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame Hiệu ứng dừa rơi
local ParticleFrame = Instance.new("Frame")
ParticleFrame.Size = UDim2.fromScale(1, 1)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.ZIndex = 1
ParticleFrame.Parent = ScreenGui

-- 2. Thiết kế Main Frame (Đã bỏ độ mờ, rõ nét 100%)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 240)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 28) -- Nền xám đen rõ nét
MainFrame.BackgroundTransparency = 0 -- Tắt độ mờ để nhìn rõ 100%
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 2
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 14)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(50, 55, 65)
UIStroke.Thickness = 1.5

-- Animation mở Menu (Pop-up)
MainFrame.Size = UDim2.fromOffset(0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(360, 240)}):Play()

-- Tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.fromOffset(0, 15)
Title.BackgroundTransparency = 1
Title.Text = "🥥 COCONUT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

-- Dòng chữ phụ
local Subtitle = Instance.new("TextLabel", MainFrame)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.fromOffset(0, 45)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter your key to bloom and explore"
Subtitle.TextColor3 = Color3.fromRGB(170, 180, 190)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.Gotham

-- Nút X (Đóng Menu)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10) -- Góc trên cùng bên phải
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(150, 160, 170)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold

-- Hiệu ứng Hover cho nút X (Sáng đỏ lên khi chỉ chuột vào)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 160, 170)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    -- Animation đóng mượt mà
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
    task.wait(0.4)
    ScreenGui:Destroy()
end)

-- Ô nhập Key (Solid, không mờ)
local KeyInput = Instance.new("TextBox", MainFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 42)
KeyInput.Position = UDim2.fromScale(0.5, 0.45)
KeyInput.AnchorPoint = Vector2.new(0.5, 0.5)
KeyInput.BackgroundColor3 = Color3.fromRGB(32, 36, 42) -- Nền TextBox sáng hơn một chút
KeyInput.BackgroundTransparency = 0
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Paste your key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 130, 140)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false

local InputCorner = Instance.new("UICorner", KeyInput)
InputCorner.CornerRadius = UDim.new(0, 8)
local InputStroke = Instance.new("UIStroke", KeyInput)
InputStroke.Color = Color3.fromRGB(70, 75, 85)
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Thông báo trạng thái 
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.fromOffset(0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium

-- Hàm tạo nút
local function CreateButton(text, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.4, 0, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    return btn
end

-- Tạo nút GET KEY và CHECK KEY
local GetKeyBtn = CreateButton("Get Key", UDim2.fromOffset(27, 175), Color3.fromRGB(70, 70, 90))
local CheckKeyBtn = CreateButton("Check Key", UDim2.fromOffset(187, 175), Color3.fromRGB(114, 137, 218))

-- 3. Hiệu ứng Dừa Rơi (Giữ nguyên)
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(math.random(5, 10) / 10) 
        
        local Coconut = Instance.new("TextLabel")
        Coconut.Text = "🥥"
        Coconut.Size = UDim2.fromOffset(30, 30)
        Coconut.BackgroundTransparency = 1
        Coconut.TextSize = math.random(16, 26) 
        Coconut.Position = UDim2.new(math.random(), 0, -0.1, 0)
        Coconut.TextTransparency = math.random(2, 6) / 10 
        Coconut.Parent = ParticleFrame

        local fallDuration = math.random(40, 70) / 10
        local tweenInfo = TweenInfo.new(fallDuration, Enum.EasingStyle.Linear)
        local targetPosition = UDim2.new(Coconut.Position.X.Scale, 0, 1.2, 0)
        
        local tween = TweenService:Create(Coconut, tweenInfo, {
            Position = targetPosition,
            Rotation = math.random(-360, 360) 
        })
        
        tween:Play()
        tween.Completed:Connect(function()
            Coconut:Destroy()
        end)
    end
end)

-- =======================================================
-- 4. TÍCH HỢP HÀM JUNKIE CALLBACKS
-- =======================================================

GetKeyBtn.MouseButton1Click:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.38, 0, 0, 36)}):Play()
    task.wait(0.1)
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.4, 0, 0, 38)}):Play()

    if Junkie and Junkie.get_key_link then
        local link = Junkie.get_key_link()
        if link then
            if setclipboard then
                setclipboard(link)
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                StatusLabel.Text = "Link copied to clipboard!"
            else
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                StatusLabel.Text = "Exploit doesn't support clipboard."
            end
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            StatusLabel.Text = "Wait 5 minutes for a new link."
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Junkie API not found. Contact Dev."
    end
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CheckKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.38, 0, 0, 36)}):Play()
    task.wait(0.1)
    TweenService:Create(CheckKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.4, 0, 0, 38)}):Play()

    local userKey = KeyInput.Text:gsub("%s+", "")
    
    if #userKey > 0 then
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        StatusLabel.Text = "Checking key..."
        
        task.wait(0.3)
        
        if Junkie and Junkie.check_key then
            local validation = Junkie.check_key(userKey)
            
            if validation.valid then
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                StatusLabel.Text = "Key valid! Loading script..."
                
                TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
                task.wait(0.5)
                ScreenGui:Destroy()
            else
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                StatusLabel.Text = validation.message or validation.error or "Invalid key!"
            end
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusLabel.Text = "Junkie API not found."
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Please enter a key first!"
    end
end)
