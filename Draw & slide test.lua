getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===================== KHAI BÁO SERVICE =====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService") 
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CREATOR_NAME = "rei123456rmrmrjmndf"
local isCreator = (Players.LocalPlayer.Name == CREATOR_NAME)

-- ===================== PHẦN 1: RAYFIELD UI HUB =====================
local Window = Rayfield:CreateWindow({
   Name = "draw a sleigh & slide downhill script",
   Icon = 0, LoadingTitle = "draw a sleigh & slide dowhill script", LoadingSubtitle = "by Coconut",
   ShowText = "script", Theme = "DarkBlue", ToggleUIKeybind = "K",
   DisableRayfieldPrompts = true, DisableBuildWarnings = false,
   ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "0" },
   Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
   KeySystem = false, KeySettings = { Title = "Untitled", Subtitle = "Key System", Note = "No method of obtaining the key is provided", FileName = "Key", SaveKey = true, GrabKeyFromSite = false, Key = {"Hello"} }
})

-- TAB: GET STATS
local StatsTab = Window:CreateTab("get stats", "dollar-sign")
local MoneySection = StatsTab:CreateSection("get money")
local CashAmount = 1
local CashInput = StatsTab:CreateInput({ Name = "Give Money", CurrentValue = "1", PlaceholderText = "how many cash you want (max:9999)", RemoveTextAfterFocusLost = true, Flag = "give money", Callback = function(Text) local amount = tonumber(Text) if amount then CashAmount = math.clamp(amount, 1, 9999) else Rayfield:Notify({Title = "error", Content = "please enter a valid number", Duration = 2}) end end })
local CashButton = StatsTab:CreateButton({ Name = "Confirm Money", Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CashEvent"):FireServer(CashAmount) Rayfield:Notify({Title = "success", Content = "gived " .. CashAmount .. " money", Duration = 2}) end })

local BoostSection = StatsTab:CreateSection("get boost")
local boostAmount = 1
local BoostInput = StatsTab:CreateInput({ Name = "get boost", CurrentValue = "1", PlaceholderText = "how many boost you want", RemoveTextAfterFocusLost = true, Flag = "give boost", Callback = function(Text) local amount = tonumber(Text) if amount then boostAmount = math.clamp(amount, 1, 9999) else Rayfield:Notify({Title = "error", Content = "please enter a valid nunber", Duration = 2}) end end })
local BoostButton = StatsTab:CreateButton({ Name = "Confirm Boost", Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ApplyBoost"):FireServer(boostAmount) Rayfield:Notify({Title = "success", Content = "gived " .. boostAmount .. " boost", Duration = 3}) end })

local RocketSection = StatsTab:CreateSection("get rocket")
local RocketButton = StatsTab:CreateButton({ Name = "Get Rocket", Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AwardRocket"):FireServer(1) Rayfield:Notify({Title = "success", Content = "gived rocket", Duration = 3}) end })

-- TAB: FREEGAMEPASS
local FreegamepassTab = Window:CreateTab("freegamepass", "sparkles")
local RemoveScriptButton = FreegamepassTab:CreateButton({ Name = "get free Golden Ski Poles gamepass", Callback = function() local player = Players.LocalPlayer local tool = player.Backpack:FindFirstChild("Golden Ski Poles") or (player.Character and player.Character:FindFirstChild("Golden Ski Poles")) if tool then local script1 = tool:FindFirstChild("LocalScript") if script1 then script1:Destroy() Rayfield:Notify({Title = "success", Content = "you now can use Golden Ski Poles,gamepass will reset when you die", Duration = 3}) else Rayfield:Notify({Title = "notification", Content = "you already use free gamepass", Duration = 3}) end else Rayfield:Notify({Title = "error", Content = "don't found Golden Ski Poles in your inventory", Duration = 3}) end end })

-- TAB: LOCAL PLAYER
local LocalPlayerTab = Window:CreateTab("local player", "user")
local SpeedSlider = LocalPlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 200}, Increment = 1, Suffix = "speed", CurrentValue = 16, Flag = "WalkSpeedSlider", Callback = function(Value) local char = Players.LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Value end end })
local InfinityJumpEnabled = false
local jumpConnection
local InfinityJumpToggle = LocalPlayerTab:CreateToggle({ Name = "Infinity Jump", CurrentValue = false, Flag = "InfinityJumpToggle", Callback = function(Value) InfinityJumpEnabled = Value if InfinityJumpEnabled then jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function() local char = Players.LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) else if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end end end })

-- TAB: CREDIT
local CreditTab = Window:CreateTab("credit", "info")
local CreatorInfo = CreditTab:CreateParagraph({ Title = "creator", Content = "Coconut on discord" })
local DiscordButton = CreditTab:CreateButton({ Name = "Copy Discord Link", Callback = function() local discordLink = "sorry ,discord server coming soon" if setclipboard then setclipboard(discordLink) Rayfield:Notify({Title = "Discord", Content = "Link discord copy to clipboard", Duration = 3}) else Rayfield:Notify({Title = "error", Content = "Executor doest support copy link", Duration = 3}) end end })

-- ===================== PHẦN 2: CREATOR JOIN POPUP =====================
local function showCreatorPopup(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CreatorJoinPopup"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.ZIndex = 10
    backdrop.Parent = screenGui
    
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(360, 220)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    card.BackgroundTransparency = 1
    card.ZIndex = 11
    card.Parent = screenGui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(70, 130, 255); cardStroke.Thickness = 1.5; cardStroke.Transparency = 1
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30); title.Position = UDim2.new(0.5, 0, 0, 54); title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1; title.Text = "Script creator joined your server"
    title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextWrapped = true; title.ZIndex = 12; title.TextTransparency = 1; title.Parent = card

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.8, 0, 0, 38); closeButton.Position = UDim2.new(0.1, 0, 1, -56)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 45, 65); closeButton.Text = "Close"
    closeButton.Font = Enum.Font.GothamBold; closeButton.TextSize = 14; closeButton.TextColor3 = Color3.fromRGB(200, 205, 220)
    closeButton.ZIndex = 12; closeButton.BackgroundTransparency = 1; closeButton.TextTransparency = 1; closeButton.Parent = card
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

    local function closePopup()
        TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end
    closeButton.MouseButton1Click:Connect(closePopup)

    card.Position = UDim2.new(0.5, 0, 0.5, 10)
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.4), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
end

local function onPlayerAdded(player) if player.Name == CREATOR_NAME then task.wait(1) showCreatorPopup(player) end end
for _, player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end
Players.PlayerAdded:Connect(onPlayerAdded)

-- ===================== PHẦN 3: CLIENT HEAD TAG =====================
local TARGET_USERNAME = "rei123456rmrmrjmndf"
local activeConnections = {} 

local function attachTagToTarget(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end
    local head = character:WaitForChild("Head", 10)
    if not head then return end
    
    local oldTag = head:FindFirstChild("ClientCreatorTag")
    if oldTag then oldTag:Destroy() end
    if activeConnections[targetPlayer] then activeConnections[targetPlayer]:Disconnect(); activeConnections[targetPlayer] = nil end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ClientCreatorTag"; billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 120, 0, 35); billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
    billboardGui.AlwaysOnTop = true; billboardGui.LightInfluence = 0; billboardGui.MaxDistance = math.huge
    billboardGui.ResetOnSpawn = false; billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1
    textLabel.Text = "⭐ script creator"; textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextStrokeTransparency = 0.5; textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold; textLabel.TextScaled = true; textLabel.Parent = billboardGui

    local function updateSize()
        if not billboardGui.Parent then return end
        local localChar = Players.LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("Head") then return end
        local targetHead = character:FindFirstChild("Head")
        if targetHead then
            local distance = (localChar.Head.Position - targetHead.Position).Magnitude
            local t = math.clamp(distance / 150, 0, 1)
            billboardGui.Size = UDim2.new(0, 120 + (160 * t), 0, 35 + (45 * t))
        end
    end
    activeConnections[targetPlayer] = RunService.RenderStepped:Connect(updateSize)
    character.Destroying:Connect(function() if activeConnections[targetPlayer] then activeConnections[targetPlayer]:Disconnect(); activeConnections[targetPlayer] = nil end end)
end

local function setupTargetTracking(targetPlayer)
    if targetPlayer.Character then task.spawn(function() attachTagToTarget(targetPlayer) end) end
    targetPlayer.CharacterAdded:Connect(function() task.wait(1) attachTagToTarget(targetPlayer) end)
end

local targetPlayer = Players:FindFirstChild(TARGET_USERNAME)
if targetPlayer then setupTargetTracking(targetPlayer) end
Players.PlayerAdded:Connect(function(player) if player.Name == TARGET_USERNAME then setupTargetTracking(player) end end)

-- ===================== PHẦN 4: HỆ THỐNG HEARTBEAT & P2P SIGNAL =====================
-- Cơ chế này giúp lọc đúng người dùng script và đảm bảo lệnh không bị miss
local function ensureSignalObject(head, name)
    local val = head:FindFirstChild(name)
    if not val then
        val = Instance.new("StringValue")
        val.Name = name
        val.Parent = head
    end
    return val
end

-- 1. Heartbeat: Mỗi người dùng script sẽ cập nhật thời gian vào đầu mình mỗi 3 giây
task.spawn(function()
    while true do
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local hb = ensureSignalObject(char.Head, "ScriptUser_Heartbeat")
            hb.Value = tostring(os.time())
        end
        task.wait(3)
    end
end)

-- 2. Hàm gửi lệnh P2P (Ghi vào đầu chính mình)
local function sendP2PSignal(payload)
    local myChar = Players.LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("Head") then return end
    local cmd = ensureSignalObject(myChar.Head, "P2P_Command")
    cmd.Value = ""
    task.wait(0.05)
    cmd.Value = payload
end

-- ===================== PHẦN 5: MENU GỘP (CHAT + DANH SÁCH) CHỈ DÀNH CHO CREATOR =====================
if isCreator then
    local managerGui = Instance.new("ScreenGui")
    managerGui.Name = "UnifiedCreatorManager"
    managerGui.ResetOnSpawn = false
    managerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    managerGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 340, 0, 450)
    mainFrame.Position = UDim2.new(0, 10, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = managerGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    -- === LOGIC KÉO THẢ ỔN ĐỊNH ===
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "⭐ Creator Manager (Kéo tiêu đề)"
    title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Parent = mainFrame

    local dragging = false
    local dragStart, startPos

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- A. KHUNG CHAT BROADCAST
    local chatFrame = Instance.new("Frame")
    chatFrame.Size = UDim2.new(1, -20, 0, 100)
    chatFrame.Position = UDim2.new(0, 10, 0, 40)
    chatFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    chatFrame.Parent = mainFrame
    Instance.new("UICorner", chatFrame).CornerRadius = UDim.new(0, 5)

    local broadcastInput = Instance.new("TextBox")
    broadcastInput.Size = UDim2.new(1, -10, 0, 30)
    broadcastInput.Position = UDim2.new(0, 5, 0, 35)
    broadcastInput.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    broadcastInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    broadcastInput.PlaceholderText = "Nhập tin nhắn..."
    broadcastInput.ClearTextOnFocus = false
    broadcastInput.Font = Enum.Font.Gotham; broadcastInput.TextSize = 14
    broadcastInput.Parent = chatFrame
    Instance.new("UICorner", broadcastInput).CornerRadius = UDim.new(0, 4)

    local sendChatBtn = Instance.new("TextButton")
    sendChatBtn.Size = UDim2.new(1, -10, 0, 30)
    sendChatBtn.Position = UDim2.new(0, 5, 1, -35)
    sendChatBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    sendChatBtn.Text = "Gửi Thông Báo"
    sendChatBtn.Font = Enum.Font.GothamBold; sendChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendChatBtn.Parent = chatFrame
    Instance.new("UICorner", sendChatBtn).CornerRadius = UDim.new(0, 4)

    -- B. DANH SÁCH NGƯỜI CHƠI (LỌC THEO HEARTBEAT)
    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, -20, 0, 25)
    listTitle.Position = UDim2.new(0, 10, 0, 150)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "Người đang dùng script:"
    listTitle.Font = Enum.Font.GothamBold; listTitle.TextSize = 14; listTitle.TextColor3 = Color3.fromRGB(200, 210, 230)
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.Parent = mainFrame

    local userList = Instance.new("ScrollingFrame")
    userList.Size = UDim2.new(1, -20, 0, 200)
    userList.Position = UDim2.new(0, 10, 0, 180)
    userList.BackgroundTransparency = 1
    userList.ScrollBarThickness = 6
    userList.CanvasSize = UDim2.new(0, 0, 0, 0)
    userList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    userList.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout", userList)
    listLayout.Padding = UDim.new(0, 5)

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, -20, 0, 30)
    refreshBtn.Position = UDim2.new(0, 10, 1, -40)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    refreshBtn.Text = "🔄 Refresh Danh Sách"
    refreshBtn.Font = Enum.Font.GothamBold; refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Parent = mainFrame
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 5)

    sendChatBtn.MouseButton1Click:Connect(function()
        local msg = broadcastInput.Text
        if msg == "" then return end
        sendP2PSignal("CHAT:" .. msg)
        broadcastInput.Text = ""
        Rayfield:Notify({Title = "Đã gửi", Content = "Thông báo đã được phát đi", Duration = 2})
    end)

    local function refreshUserList()
        for _, child in ipairs(userList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
        
        local currentTime = os.time()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                -- Kiểm tra Heartbeat: Chỉ hiện những người có tín hiệu trong 10 giây gần nhất
                local char = player.Character
                local hasScript = false
                if char and char:FindFirstChild("Head") then
                    local hb = char.Head:FindFirstChild("ScriptUser_Heartbeat")
                    if hb and tonumber(hb.Value) and (currentTime - tonumber(hb.Value) < 10) then
                        hasScript = true
                    end
                end

                if hasScript then
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 50)
                    row.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
                    row.Parent = userList
                    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

                    local avatar = Instance.new("ImageLabel")
                    avatar.Size = UDim2.new(0, 40, 0, 40); avatar.Position = UDim2.new(0, 5, 0, 5)
                    avatar.BackgroundTransparency = 1
                    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    avatar.Parent = row

                    local nameText = Instance.new("TextLabel")
                    nameText.Size = UDim2.new(1, -110, 0, 20); nameText.Position = UDim2.new(0, 50, 0, 5)
                    nameText.BackgroundTransparency = 1; nameText.Text = player.DisplayName
                    nameText.Font = Enum.Font.GothamBold; nameText.TextSize = 14; nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameText.TextXAlignment = Enum.TextXAlignment.Left; nameText.Parent = row

                    local userText = Instance.new("TextLabel")
                    userText.Size = UDim2.new(1, -110, 0, 20); userText.Position = UDim2.new(0, 50, 0, 25)
                    userText.BackgroundTransparency = 1; userText.Text = "@" .. player.Name
                    userText.Font = Enum.Font.Gotham; userText.TextSize = 12; userText.TextColor3 = Color3.fromRGB(150, 160, 185)
                    userText.TextXAlignment = Enum.TextXAlignment.Left; userText.Parent = row

                    local kickBtn = Instance.new("TextButton")
                    kickBtn.Size = UDim2.new(0, 50, 0, 30); kickBtn.Position = UDim2.new(1, -55, 0, 10)
                    kickBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); kickBtn.Text = "KICK"
                    kickBtn.Font = Enum.Font.GothamBold; kickBtn.TextSize = 12; kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    kickBtn.Parent = row
                    Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0, 5)

                    kickBtn.MouseButton1Click:Connect(function()
                        local reason = "Vi phạm quy định"
                        sendP2PSignal("KICK:" .. player.Name .. ":" .. reason)
                        Rayfield:Notify({Title = "Đã gửi lệnh", Content = "Đã yêu cầu " .. player.Name .. " tự kick.", Duration = 2})
                    end)
                end
            end
        end
    end
    refreshBtn.MouseButton1Click:Connect(refreshUserList)
    refreshUserList()
end

-- ===================== PHẦN 6: XỬ LÝ LỆNH P2P & CHAT CỦA NGƯỜI DÙNG THƯỜNG =====================
local function showNotification(message, isKick)
    local notiGui = Instance.new("ScreenGui")
    notiGui.Name = "P2P_Notification"
    notiGui.ResetOnSpawn = false
    notiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notiGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local notiFrame = Instance.new("Frame")
    notiFrame.Size = UDim2.new(0, 400, 0, isKick and 80 or 60)
    notiFrame.Position = UDim2.new(0.5, -200, 0, 20)
    notiFrame.BackgroundColor3 = isKick and Color3.fromRGB(50, 0, 0) or Color3.fromRGB(20, 24, 38)
    notiFrame.Parent = notiGui
    Instance.new("UICorner", notiFrame).CornerRadius = UDim.new(0, 10)
    
    local notiStroke = Instance.new("UIStroke", notiFrame)
    notiStroke.Color = isKick and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 215, 0)
    notiStroke.Thickness = 2

    local notiText = Instance.new("TextLabel")
    notiText.Size = UDim2.new(1, -20, 1, -10)
    notiText.Position = UDim2.new(0, 10, 0, 5)
    notiText.BackgroundTransparency = 1
    notiText.Text = isKick and "⚠️ " .. message or "⭐️script creator: " .. message
    notiText.Font = Enum.Font.GothamBold
    notiText.TextSize = isKick and 20 or 18
    notiText.TextColor3 = isKick and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 215, 0)
    notiText.TextWrapped = true
    notiText.TextStrokeTransparency = 0.5
    notiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    notiText.Parent = notiFrame

    task.delay(3, function() if notiGui.Parent then notiGui:Destroy() end end)
end

-- Vòng lặp Polling để đọc lệnh từ Creator (Ổn định hơn .Changed)
task.spawn(function()
    while true do
        local creator = Players:FindFirstChild(CREATOR_NAME)
        if creator and creator.Character and creator.Character:FindFirstChild("Head") then
            local cmd = creator.Character.Head:FindFirstChild("P2P_Command")
            if cmd and cmd.Value ~= "" then
                local val = cmd.Value
                cmd.Value = "" -- Xóa ngay sau khi đọc
                
                if val:sub(1, 5) == "KICK:" then
                    local parts = val:split(":")
                    local targetName = parts[2]
                    local reason = parts[3] or "No reason"
                    if targetName == Players.LocalPlayer.Name then
                        showNotification("Bạn đã bị kick. Lý do: " .. reason, true)
                        task.wait(0.5)
                        Players.LocalPlayer:Kick("Script Creator kicked you. Reason: " .. reason)
                    end
                elseif val:sub(1, 5) == "CHAT:" then
                    showNotification(val:sub(6), false)
                end
            end
        end
        task.wait(0.2) -- Kiểm tra mỗi 0.2 giây
    end
end)

-- ===================== PHẦN 7: CHAT CỦA NGƯỜI DÙNG THƯỜNG (HIỆN TRÊN ĐẦU) =====================
-- Menu chat nhỏ cho người dùng thường
if not isCreator then
    local userChatGui = Instance.new("ScreenGui")
    userChatGui.Name = "UserChatMenu"
    userChatGui.ResetOnSpawn = false
    userChatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    userChatGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local chatBox = Instance.new("Frame")
    chatBox.Size = UDim2.new(0, 250, 0, 80)
    chatBox.Position = UDim2.new(0, 10, 1, -100)
    chatBox.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    chatBox.BackgroundTransparency = 0.1
    chatBox.Parent = userChatGui
    Instance.new("UICorner", chatBox).CornerRadius = UDim.new(0, 8)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -10, 0, 30)
    input.Position = UDim2.new(0, 5, 0, 5)
    input.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Chat với người dùng script..."
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham; input.TextSize = 14
    input.Parent = chatBox
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)

    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.new(1, -10, 0, 30)
    sendBtn.Position = UDim2.new(0, 5, 0, 40)
    sendBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    sendBtn.Text = "Gửi"
    sendBtn.Font = Enum.Font.GothamBold; sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendBtn.Parent = chatBox
    Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 4)

    sendBtn.MouseButton1Click:Connect(function()
        local msg = input.Text
        if msg == "" then return end
        -- Ghi tin nhắn vào đầu chính mình để người khác đọc
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local chatVal = ensureSignalObject(char.Head, "UserChatMsg")
            chatVal.Value = msg
        end
        input.Text = ""
    end)
end

-- Vòng lặp đọc tin nhắn từ những người dùng script khác
task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Head") then
                    local chatVal = char.Head:FindFirstChild("UserChatMsg")
                    if chatVal and chatVal.Value ~= "" then
                        local msg = chatVal.Value
                        chatVal.Value = "" -- Xóa sau khi đọc
                        
                        -- Hiện bong bóng trên đầu người vừa chat
                        local head = char.Head
                        local bubble = Instance.new("BillboardGui")
                        bubble.Adornee = head
                        bubble.Size = UDim2.new(0, 250, 0, 60)
                        bubble.StudsOffset = Vector3.new(0, 4.5, 0)
                        bubble.AlwaysOnTop = true
                        bubble.LightInfluence = 0
                        bubble.MaxDistance = math.huge
                        bubble.ResetOnSpawn = false
                        bubble.Parent = head

                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = msg
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 16
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.TextStrokeTransparency = 0
                        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        txt.TextWrapped = true
                        txt.Parent = bubble

                        task.delay(3, function() if bubble.Parent then bubble:Destroy() end end)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- ===================== PHẦN 8: CHAT TO HEAD (ROBLOX CHAT GỐC) =====================
local function hookChat()
    local channels = TextChatService:FindFirstChild("TextChatChannels")
    if not channels then return end
    local generalChannel = channels:FindFirstChild("RBXGeneral")
    if not generalChannel then return end

    local oldHook = generalChannel.OnIncomingMessage
    generalChannel.OnIncomingMessage = function(message)
        task.spawn(function()
            local textSource = message.TextSource
            if textSource then
                local sender = Players:GetPlayerByUserId(textSource.UserId)
                if sender and sender.Character and sender.Character:FindFirstChild("Head") then
                    local head = sender.Character.Head
                    local chatBubble = Instance.new("BillboardGui")
                    chatBubble.Name = "ChatBubble_" .. tostring(tick())
                    chatBubble.Adornee = head
                    chatBubble.Size = UDim2.new(0, 250, 0, 60)
                    chatBubble.StudsOffset = Vector3.new(0, 4.5, 0) 
                    chatBubble.AlwaysOnTop = true
                    chatBubble.LightInfluence = 0
                    chatBubble.MaxDistance = math.huge
                    chatBubble.ResetOnSpawn = false
                    chatBubble.Parent = head

                    local bubbleText = Instance.new("TextLabel")
                    bubbleText.Size = UDim2.new(1, 0, 1, 0)
                    bubbleText.BackgroundTransparency = 1
                    bubbleText.Text = message.Text
                    bubbleText.Font = Enum.Font.GothamBold
                    bubbleText.TextSize = 16
                    bubbleText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    bubbleText.TextStrokeTransparency = 0
                    bubbleText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    bubbleText.TextWrapped = true
                    bubbleText.Parent = chatBubble

                    task.delay(3, function() if chatBubble.Parent then chatBubble:Destroy() end end)
                end
            end
        end)

        if oldHook then
            local success, result = pcall(function() return oldHook(message) end)
            if success then return result end
        end
        return message
    end
end

task.spawn(function()
    local channels = TextChatService:WaitForChild("TextChatChannels", 10)
    if channels then
        local generalChannel = channels:WaitForChild("RBXGeneral", 10)
        if generalChannel then hookChat() end
    end
end)
