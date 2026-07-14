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

-- ===================== TAB: GET STATS =====================
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

-- ===================== TAB: FREEGAMEPASS =====================
local FreegamepassTab = Window:CreateTab("freegamepass", "sparkles")
local RemoveScriptButton = FreegamepassTab:CreateButton({ Name = "get free Golden Ski Poles gamepass", Callback = function() local player = Players.LocalPlayer local tool = player.Backpack:FindFirstChild("Golden Ski Poles") or (player.Character and player.Character:FindFirstChild("Golden Ski Poles")) if tool then local script1 = tool:FindFirstChild("LocalScript") if script1 then script1:Destroy() Rayfield:Notify({Title = "success", Content = "you now can use Golden Ski Poles,gamepass will reset when you die", Duration = 3}) else Rayfield:Notify({Title = "notification", Content = "you already use free gamepass", Duration = 3}) end else Rayfield:Notify({Title = "error", Content = "don't found Golden Ski Poles in your inventory", Duration = 3}) end end })

-- ===================== TAB: LOCAL PLAYER =====================
local LocalPlayerTab = Window:CreateTab("local player", "user")
local SpeedSlider = LocalPlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 200}, Increment = 1, Suffix = "speed", CurrentValue = 16, Flag = "WalkSpeedSlider", Callback = function(Value) local char = Players.LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Value end end })
local InfinityJumpEnabled = false
local jumpConnection
local InfinityJumpToggle = LocalPlayerTab:CreateToggle({ Name = "Infinity Jump", CurrentValue = false, Flag = "InfinityJumpToggle", Callback = function(Value) InfinityJumpEnabled = Value if InfinityJumpEnabled then jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function() local char = Players.LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) else if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end end end })

-- ===================== TAB: CREDIT =====================
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


-- ===================== PHẦN 4: MENU QUẢN LÝ & KICK POPUP (ĐÃ SỬA LỖI HOISTING) =====================
if isCreator then
    -- 1. Tạo GUI và Frame chính
    local managerGui = Instance.new("ScreenGui")
    managerGui.Name = "CreatorManagerUI"
    managerGui.ResetOnSpawn = false
    managerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    managerGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 400)
    mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = managerGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "⭐ Creator Manager (Kéo tiêu đề)"
    title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Parent = mainFrame

    -- Logic kéo thả
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; mousePos = input.Position; framePos = mainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    -- 2. Tạo ScrollingFrame và nút Refresh
    local userList = Instance.new("ScrollingFrame")
    userList.Size = UDim2.new(1, -20, 0, 280)
    userList.Position = UDim2.new(0, 10, 0, 40)
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

    -- 3. Tạo UI cho Kick Popup (ĐƯA LÊN TRƯỚC)
    local kickPopupGui = Instance.new("ScreenGui")
    kickPopupGui.Name = "KickConfirmationPopup"
    kickPopupGui.ResetOnSpawn = false
    kickPopupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    kickPopupGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local popupBackdrop = Instance.new("Frame")
    popupBackdrop.Size = UDim2.fromScale(1, 1)
    popupBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    popupBackdrop.BackgroundTransparency = 0.6
    popupBackdrop.Visible = false
    popupBackdrop.Parent = kickPopupGui

    local popupCard = Instance.new("Frame")
    popupCard.Size = UDim2.fromOffset(300, 180)
    popupCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    popupCard.AnchorPoint = Vector2.new(0.5, 0.5)
    popupCard.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    popupCard.Visible = false
    popupCard.Parent = popupBackdrop
    Instance.new("UICorner", popupCard).CornerRadius = UDim.new(0, 10)

    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, 0, 0, 40)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = "Xác nhận Kick"
    popupTitle.Font = Enum.Font.GothamBold; popupTitle.TextSize = 18; popupTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    popupTitle.Parent = popupCard

    local reasonInput = Instance.new("TextBox")
    reasonInput.Size = UDim2.new(1, -20, 0, 35)
    reasonInput.Position = UDim2.new(0, 10, 0, 50)
    reasonInput.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    reasonInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    reasonInput.PlaceholderText = "Nhập lý do kick..."
    reasonInput.ClearTextOnFocus = false
    reasonInput.Font = Enum.Font.Gotham; reasonInput.TextSize = 14
    reasonInput.Parent = popupCard
    Instance.new("UICorner", reasonInput).CornerRadius = UDim.new(0, 5)

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0.45, 0, 0, 35)
    confirmBtn.Position = UDim2.new(0.05, 0, 1, -45)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    confirmBtn.Text = "KICK"
    confirmBtn.Font = Enum.Font.GothamBold; confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.Parent = popupCard
    Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 5)

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0.45, 0, 0, 35)
    cancelBtn.Position = UDim2.new(0.5, 0, 1, -45)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
    cancelBtn.Text = "Hủy"
    cancelBtn.Font = Enum.Font.GothamBold; cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.Parent = popupCard
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 5)

    -- 4. Định nghĩa hàm và biến cho Popup (ĐƯA LÊN TRƯỚC refreshUserList)
    local pendingKickTarget = nil

    local function openKickPopup(targetPlayer)
        pendingKickTarget = targetPlayer
        reasonInput.Text = ""
        popupBackdrop.Visible = true
        popupCard.Visible = true
    end

    local function closeKickPopup()
        pendingKickTarget = nil
        reasonInput.Text = ""
        popupBackdrop.Visible = false
        popupCard.Visible = false
    end

    cancelBtn.MouseButton1Click:Connect(closeKickPopup)

    confirmBtn.MouseButton1Click:Connect(function()
        if not pendingKickTarget then return end
        local reason = reasonInput.Text
        if reason == "" then reason = "No reason provided" end

        local targetChar = pendingKickTarget.Character
        if targetChar and targetChar:FindFirstChild("Head") then
            local cmdVal = targetChar.Head:FindFirstChild("P2P_Command")
            if not cmdVal then
                cmdVal = Instance.new("StringValue")
                cmdVal.Name = "P2P_Command"
                cmdVal.Parent = targetChar.Head
            end
            cmdVal.Value = "KICK:" .. reason
            Rayfield:Notify({Title = "Kick Sent", Content = "Đã gửi lệnh kick đến " .. pendingKickTarget.Name, Duration = 2})
        end
        closeKickPopup()
    end)

    -- 5. Định nghĩa refreshUserList (BÂY GIỜ openKickPopup ĐÃ TỒN TẠI TRONG SCOPE)
    local function refreshUserList()
        for _, child in ipairs(userList:GetChildren()) do 
            if child:IsA("Frame") then child:Destroy() end 
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
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

                -- Không còn lỗi nil value nữa vì openKickPopup đã được định nghĩa ở bước 4!
                kickBtn.MouseButton1Click:Connect(function()
                    openKickPopup(player)
                end)
            end
        end
    end

    -- 6. Gán sự kiện và gọi lần đầu
    refreshBtn.MouseButton1Click:Connect(refreshUserList)
    refreshUserList()
end

-- ===================== PHẦN 5: HỆ THỐNG P2P (CHAT + KICK) CHO TẤT CẢ MỌI NGƯỜI =====================
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

local function setupP2PListener(player)
    local function monitorCharacter(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local msgVal = head:FindFirstChild("P2P_Command")
        if not msgVal then
            msgVal = Instance.new("StringValue")
            msgVal.Name = "P2P_Command"
            msgVal.Parent = head
        end
        
        msgVal.Changed:Connect(function(newVal)
            if newVal:sub(1, 5) == "KICK:" then
                local reason = newVal:sub(6)
                showNotification("Bạn đã bị kick. Lý do: " .. reason, true)
                task.wait(0.5) 
                Players.LocalPlayer:Kick("Script Creator kicked you. Reason: " .. reason)
            elseif newVal ~= "" then
                showNotification(newVal, false)
                msgVal.Value = "" 
            end
        end)
    end
    
    if player.Character then 
        task.spawn(function() monitorCharacter(player.Character) end) 
    end
    player.CharacterAdded:Connect(monitorCharacter)
end

local existingCreator = Players:FindFirstChild(CREATOR_NAME)
if existingCreator then setupP2PListener(existingCreator) end

Players.PlayerAdded:Connect(function(player)
    if player.Name == CREATOR_NAME then setupP2PListener(player) end
end)

-- ===================== PHẦN 6: CHAT TO HEAD (ROBLOX CHAT) =====================
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
