-- =======================================================
-- CUSTOM JUNKIE KEY SYSTEM UI: COCONUT HUB (ULTRA PREMIUM)
-- Đã sửa lỗi mất chữ, lỗi icon vuông, animation cực mượt.
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

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

-- ==========================================
-- 2. THIẾT KẾ KHUNG CHÍNH
-- ==========================================

local MainBgColor = Color3.fromRGB(13, 15, 20) -- Màu đen ánh xanh (Dark Navy)
local AccentCyan = Color3.fromRGB(0, 200, 255)
local AccentPurple = Color3.fromRGB(150, 100, 255)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(0, 0) -- Bắt đầu từ 0
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = MainBgColor
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(1, 0) -- Khởi đầu là hình tròn

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = AccentCyan
UIStroke.Thickness = 0
UIStroke.Transparency = 0.5

-- ==========================================
-- 3. NỘI DUNG MENU (Chữ & Nút)
-- ==========================================

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.fromScale(1, 1)
ContentFrame.Position = UDim2.fromOffset(0, 30) -- Đặt thấp xuống để trượt lên
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = false 
ContentFrame.ZIndex = 3
ContentFrame.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel", ContentFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.fromOffset(0, 15)
Title.BackgroundTransparency = 1
Title.Text = "🥥 COCONUT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 4

-- Dòng chữ phụ
local Subtitle = Instance.new("TextLabel", ContentFrame)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.fromOffset(0, 42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Premium Key System • Secured by Junkie"
Subtitle.TextColor3 = Color3.fromRGB(150, 160, 175)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.ZIndex = 4

-- Đường kẻ phát sáng mờ (Glow Line) trang trí
local GlowLine = Instance.new("Frame", ContentFrame)
GlowLine.Size = UDim2.new(0.7, 0, 0, 1)
GlowLine.Position = UDim2.new(0.15, 0, 0, 72)
GlowLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlowLine.BorderSizePixel = 0
GlowLine.ZIndex = 4

local GlowGrad = Instance.new("UIGradient", GlowLine)
GlowGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, MainBgColor),
    ColorSequenceKeypoint.new(0.5, AccentCyan),
    ColorSequenceKeypoint.new(1, MainBgColor)
}

-- Nút X (Đóng Menu)
local CloseBtn = Instance.new("TextButton", ContentFrame)
CloseBtn.Size = UDim2.fromOffset(40, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 10) 
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(100, 110, 120)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 5

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 80, 80), Rotation = 90}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 110, 120), Rotation = 0}):Play()
end)

-- Ô nhập Key 
local KeyInput = Instance.new("TextBox", ContentFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
KeyInput.Position = UDim2.fromScale(0.5, 0.45)
KeyInput.AnchorPoint = Vector2.new(0.5, 0.5)
KeyInput.BackgroundColor3 = Color3.fromRGB(18, 22, 28) 
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Paste your valid key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(90, 100, 115)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 4

local InputCorner = Instance.new("UICorner", KeyInput)
InputCorner.CornerRadius = UDim.new(0, 6)
local InputStroke = Instance.new("UIStroke", KeyInput)
InputStroke.Color = Color3.fromRGB(45, 50, 65)
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputStroke.Thickness = 1.5

KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.4), {Color = AccentCyan}):Play()
end)
KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(45, 50, 65)}):Play()
end)

-- Thông báo trạng thái (Không dùng Unicode đặc biệt)
local StatusLabel = Instance.new("TextLabel", ContentFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.fromOffset(0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.ZIndex = 4

-- HÀM TẠO NÚT "GHOST BUTTON" (Chống lỗi mất chữ 100%)
local function CreateGhostButton(text, pos, themeColor)
    -- Frame làm nền
    local btnFrame = Instance.new("Frame", ContentFrame)
    btnFrame.Size = UDim2.new(0.4, 0, 0, 40)
    btnFrame.Position = pos
    btnFrame.BackgroundColor3 = themeColor
    btnFrame.BackgroundTransparency = 0.85 -- Trong suốt mờ
    btnFrame.ZIndex = 4
    
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = themeColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    
    -- Nút bấm tàng hình chứa chữ nằm đè lên Frame (Tránh xung đột màu)
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = themeColor:Lerp(Color3.new(1,1,1), 0.5) -- Trắng pha màu nhạt
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.ZIndex = 5
    
    -- Animation Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1), TextSize = 15}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = themeColor:Lerp(Color3.new(1,1,1), 0.5), TextSize = 14}):Play()
    end)
    
    return btn
end

-- Tạo 2 nút với màu dạ quang siêu xịn
local GetKeyBtn = CreateGhostButton("Get Key", UDim2.fromOffset(27, 175), AccentPurple)
local CheckKeyBtn = CreateGhostButton("Check Key", UDim2.fromOffset(187, 175), AccentCyan)

-- ==========================================
-- 4. ANIMATION MỞ MENU (CHẬM & SIÊU MƯỢT)
-- ==========================================

task.spawn(function()
    task.wait(0.3)
    
    -- Vòng tròn phóng to từ từ trong 1.5 giây (EasingStyle.Quint siêu mượt)
    local expandInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, expandInfo, {Size = UDim2.fromOffset(360, 240)}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(1.5), {Thickness = 1}):Play()
    
    -- Vuông góc từ từ
    TweenService:Create(UICorner, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CornerRadius = UDim.new(0, 12)}):Play()
    
    task.wait(0.8) -- Khi menu mở được một nửa thì bắt đầu lướt chữ lên
    
    ContentFrame.Visible = true
    -- Hiệu ứng lướt chữ từ dưới lên
    TweenService:Create(ContentFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()
end)

-- ==========================================
-- 5. HIỆU ỨNG DỪA RƠI
-- ==========================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(math.random(4, 8) / 10) 
        
        local Coconut = Instance.new("TextLabel")
        Coconut.Text = "🥥"
        Coconut.Size = UDim2.fromOffset(30, 30)
        Coconut.BackgroundTransparency = 1
        Coconut.TextSize = math.random(18, 26) 
        
        local startX = math.random()
        Coconut.Position = UDim2.new(startX, 0, -0.1, 0)
        Coconut.TextTransparency = math.random(3, 7) / 10 
        Coconut.ZIndex = 1
        Coconut.Parent = ParticleFrame

        local fallDuration = math.random(50, 80) / 10
        local tweenInfo = TweenInfo.new(fallDuration, Enum.EasingStyle.Linear)
        
        local endX = startX + (math.random(-15, 15) / 100)
        local targetPosition = UDim2.new(endX, 0, 1.2, 0)
        
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

-- ==========================================
-- 6. LOGIC JUNKIE VÀ NÚT BẤM (Không Icon Lỗi)
-- ==========================================

local function CloseMenu()
    ContentFrame.Visible = false
    TweenService:Create(UIStroke, TweenInfo.new(0.3), {Thickness = 0}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
    TweenService:Create(UICorner, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {CornerRadius = UDim.new(1, 0)}):Play()
    task.wait(1)
    ScreenGui:Destroy()
end

CloseBtn.MouseButton1Click:Connect(CloseMenu)

GetKeyBtn.MouseButton1Click:Connect(function()
    if Junkie and Junkie.get_key_link then
        local link = Junkie.get_key_link()
        if link then
            if setclipboard then
                setclipboard(link)
                StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 150)
                StatusLabel.Text = "[SUCCESS] Link copied to clipboard!"
            else
                StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                StatusLabel.Text = "[ERROR] Exploit doesn't support clipboard."
            end
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
            StatusLabel.Text = "[!] Wait 5 minutes for a new link."
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "[ERROR] Junkie API not found."
    end
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text:gsub("%s+", "")
    
    if #userKey > 0 then
        StatusLabel.TextColor3 = AccentCyan
        StatusLabel.Text = "Checking key..."
        
        task.wait(0.3)
        
        if Junkie and Junkie.check_key then
            local validation = Junkie.check_key(userKey)
            
            if validation.valid then
                StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 150)
                StatusLabel.Text = "[SUCCESS] Key valid! Loading script..."
                task.wait(0.5)
                CloseMenu()
            else
                StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                StatusLabel.Text = "[ERROR] " .. (validation.message or validation.error or "Invalid key!")
            end
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "[ERROR] Junkie API not found."
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
        StatusLabel.Text = "[!] Please enter a key first!"
    end
end)
