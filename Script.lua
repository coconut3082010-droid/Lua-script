getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===================== KHAI BÁO SERVICE DUY NHẤT =====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService") 
local UserInputService = game:GetService("UserInputService")

local CREATOR_NAME = "rei123456rmrmrjmndf"
local isCreator = (Players.LocalPlayer.Name == CREATOR_NAME)

-- ===================== PHẦN 1: RAYFIELD UI HUB =====================
local Window = Rayfield:CreateWindow({
   Name = "draw a sleigh & slide downhill script",
   Icon = 0,
   LoadingTitle = "draw a sleigh & slide dowhill script",
   LoadingSubtitle = "by Coconut",
   ShowText = "script",
   Theme = "DarkBlue",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
   ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "0" },
   Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
   KeySystem = false,
   KeySettings = { Title = "Untitled", Subtitle = "Key System", Note = "No method of obtaining the key is provided", FileName = "Key", SaveKey = true, GrabKeyFromSite = false, Key = {"Hello"} }
})

-- ===================== TAB: GET STATS =====================
local StatsTab = Window:CreateTab("get stats", "dollar-sign")
local MoneySection = StatsTab:CreateSection("get money")
local CashAmount = 1
local CashInput = StatsTab:CreateInput({ 
    Name = "Give Money", 
    CurrentValue = "1", 
    PlaceholderText = "how many cash you want (max:9999)", 
    RemoveTextAfterFocusLost = true, 
    Flag = "give money", 
    Callback = function(Text) 
        local amount = tonumber(Text) 
        if amount then CashAmount = math.clamp(amount, 1, 9999) 
        else Rayfield:Notify({Title = "error", Content = "please enter a valid number", Duration = 2}) end 
    end 
})
local CashButton = StatsTab:CreateButton({ Name = "Confirm Money", Callback = function() 
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CashEvent"):FireServer(CashAmount) 
    Rayfield:Notify({Title = "success", Content = "gived " .. CashAmount .. " money", Duration = 2}) 
end })

local BoostSection = StatsTab:CreateSection("get boost")
local boostAmount = 1
local BoostInput = StatsTab:CreateInput({ 
    Name = "get boost", 
    CurrentValue = "1", 
    PlaceholderText = "how many boost you want", 
    RemoveTextAfterFocusLost = true, 
    Flag = "give boost", 
    Callback = function(Text) 
        local amount = tonumber(Text) 
        if amount then boostAmount = math.clamp(amount, 1, 9999) 
        else Rayfield:Notify({Title = "error", Content = "please enter a valid nunber", Duration = 2}) end 
    end 
})
local BoostButton = StatsTab:CreateButton({ Name = "Confirm Boost", Callback = function() 
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ApplyBoost"):FireServer(boostAmount) 
    Rayfield:Notify({Title = "success", Content = "gived " .. boostAmount .. " boost", Duration = 3}) 
end })

local RocketSection = StatsTab:CreateSection("get rocket")
local RocketButton = StatsTab:CreateButton({ Name = "Get Rocket", Callback = function() 
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AwardRocket"):FireServer(1) 
    Rayfield:Notify({Title = "success", Content = "gived rocket", Duration = 3}) 
end })

-- ===================== TAB: FREEGAMEPASS =====================
local FreegamepassTab = Window:CreateTab("freegamepass", "sparkles")
local RemoveScriptButton = FreegamepassTab:CreateButton({ Name = "get free Golden Ski Poles gamepass", Callback = function() 
    local player = Players.LocalPlayer 
    local tool = player.Backpack:FindFirstChild("Golden Ski Poles") or (player.Character and player.Character:FindFirstChild("Golden Ski Poles")) 
    if tool then 
        local script1 = tool:FindFirstChild("LocalScript") 
        if script1 then 
            script1:Destroy() 
            Rayfield:Notify({Title = "success", Content = "you now can use Golden Ski Poles,gamepass will reset when you die", Duration = 3}) 
        else 
            Rayfield:Notify({Title = "notification", Content = "you already use free gamepass", Duration = 3}) 
        end 
    else 
        Rayfield:Notify({Title = "error", Content = "don't found Golden Ski Poles in your inventory", Duration = 3}) 
    end 
end })

-- ===================== TAB: LOCAL PLAYER =====================
local LocalPlayerTab = Window:CreateTab("local player", "user")
local SpeedSlider = LocalPlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 200}, Increment = 1, Suffix = "speed", CurrentValue = 16, Flag = "WalkSpeedSlider", Callback = function(Value) 
    local char = Players.LocalPlayer.Character 
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Value end 
end })

local InfinityJumpEnabled = false
local jumpConnection
local InfinityJumpToggle = LocalPlayerTab:CreateToggle({ Name = "Infinity Jump", CurrentValue = false, Flag = "InfinityJumpToggle", Callback = function(Value) 
    InfinityJumpEnabled = Value 
    if InfinityJumpEnabled then 
        jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function() 
            local char = Players.LocalPlayer.Character 
            if char and char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end 
        end) 
    else 
        if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end 
    end 
end })

-- ===================== TAB: CREDIT =====================
local CreditTab = Window:CreateTab("credit", "info")
local CreatorInfo = CreditTab:CreateParagraph({ Title = "creator", Content = "Coconut on discord" })
local DiscordButton = CreditTab:CreateButton({ Name = "Copy Discord Link", Callback = function() 
    local discordLink = "sorry ,discord server coming soon" 
    if setclipboard then 
        setclipboard(discordLink) 
        Rayfield:Notify({Title = "Discord", Content = "Link discord copy to clipboard", Duration = 3}) 
    else 
        Rayfield:Notify({Title = "error", Content = "Executor doest support copy link", Duration = 3}) 
    end 
end })

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

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(70, 130, 255)
    cardStroke.Thickness = 1.5
    cardStroke.Transparency = 1
    cardStroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(1, 0, 0, 4)
    accentBar.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 12
    accentBar.Parent = card

    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.fromOffset(0, 0)
    badge.AutomaticSize = Enum.AutomaticSize.XY
    badge.Position = UDim2.new(0.5, 0, 0, 22)
    badge.AnchorPoint = Vector2.new(0.5, 0)
    badge.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    badge.Text = "  ⭐ SCRIPT CREATOR  "
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 12
    badge.TextColor3 = Color3.fromRGB(140, 180, 255)
    badge.ZIndex = 12
    badge.TextTransparency = 1
    badge.BackgroundTransparency = 1
    badge.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0.5, 0, 0, 54)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "Script creator joined your server"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextWrapped = true
    title.ZIndex = 12
    title.TextTransparency = 1
    title.Parent = card

    local displayNameLabel = Instance.new("TextLabel")
    displayNameLabel.Size = UDim2.new(1, -40, 0, 20)
    displayNameLabel.Position = UDim2.new(0.5, 0, 0, 100)
    displayNameLabel.AnchorPoint = Vector2.new(0.5, 0)
    displayNameLabel.BackgroundTransparency = 1
    displayNameLabel.Text = "Display Name: " .. player.DisplayName
    displayNameLabel.Font = Enum.Font.Gotham
    displayNameLabel.TextSize = 14
    displayNameLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
    displayNameLabel.ZIndex = 12
    displayNameLabel.TextTransparency = 1
    displayNameLabel.Parent = card

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, -40, 0, 20)
    usernameLabel.Position = UDim2.new(0.5, 0, 0, 122)
    usernameLabel.AnchorPoint = Vector2.new(0.5, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = "Username: @" .. player.Name
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextSize = 14
    usernameLabel.TextColor3 = Color3.fromRGB(150, 160, 185)
    usernameLabel.ZIndex = 12
    usernameLabel.TextTransparency = 1
    usernameLabel.Parent = card

    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(0.44, 0, 0, 38)
    tpButton.Position = UDim2.new(0.03, 0, 1, -56)
    tpButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    tpButton.Text = "TP to Creator"
    tpButton.Font = Enum.Font.GothamBold
    tpButton.TextSize = 14
    tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpButton.ZIndex = 12
    tpButton.BackgroundTransparency = 1
    tpButton.TextTransparency = 1
    tpButton.Parent = card

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.44, 0, 0, 38)
    closeButton.Position = UDim2.new(0.53, 0, 1, -56)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    closeButton.Text = "Close"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = Color3.fromRGB(200, 205, 220)
    closeButton.ZIndex = 12
    closeButton.BackgroundTransparency = 1
    closeButton.TextTransparency = 1
    closeButton.Parent = card

    local function closePopup()
        local fadeOut = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        fadeOut:Play()
        TweenService:Create(backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        for _, obj in ipairs(card:GetDescendants()) do if obj:IsA("TextLabel") or obj:IsA("TextButton") then TweenService:Create(obj, TweenInfo.new(0.2), {TextTransparency = 1}):Play() end end
        task.wait(0.3)
        screenGui:Destroy()
    end

    closeButton.MouseButton1Click:Connect(closePopup)
    tpButton.MouseButton1Click:Connect(function()
        local localChar = Players.LocalPlayer.Character
        local creatorChar = player.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") and creatorChar and creatorChar:FindFirstChild("HumanoidRootPart") then
            localChar.HumanoidRootPart.CFrame = creatorChar.HumanoidRootPart.CFrame
        end
        closePopup()
    end)

    card.Position = UDim2.new(0.5, 0, 0.5, 10)
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    for _, obj in ipairs({title, displayNameLabel, usernameLabel, tpButton, closeButton}) do TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 0}):Play() end
    TweenService:Create(badge, TweenInfo.new(0.4), {TextTransparency = 0, BackgroundTransparency = 0.85}):Play()
    TweenService:Create(tpButton, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
end

local function onPlayerAdded(player)
    if player.Name == CREATOR_NAME then task.wait(1) showCreatorPopup(player) end
end
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

    if activeConnections[targetPlayer] then
        activeConnections[targetPlayer]:Disconnect()
        activeConnections[targetPlayer] = nil
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ClientCreatorTag"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 120, 0, 35)
    billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.LightInfluence = 0
    billboardGui.MaxDistance = math.huge
    billboardGui.ResetOnSpawn = false
    billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⭐ script creator"
    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.Parent = billboardGui

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
    
    activeConnections[targetPlayer] = game:GetService("RunService").RenderStepped:Connect(updateSize)
    
    character.Destroying:Connect(function()
        if activeConnections[targetPlayer] then
            activeConnections[targetPlayer]:Disconnect()
            activeConnections[targetPlayer] = nil
        end
    end)
end

local function setupTargetTracking(targetPlayer)
    if targetPlayer.Character then task.spawn(function() attachTagToTarget(targetPlayer) end) end
    targetPlayer.CharacterAdded:Connect(function() task.wait(1) attachTagToTarget(targetPlayer) end)
end

local targetPlayer = Players:FindFirstChild(TARGET_USERNAME)
if targetPlayer then setupTargetTracking(targetPlayer) end
Players.PlayerAdded:Connect(function(player) if player.Name == TARGET_USERNAME then setupTargetTracking(player) end end)

-- ===================== PHẦN 4: CREATOR CHAT MENU =====================
if isCreator then
    local creatorChatGui = Instance.new("ScreenGui")
    creatorChatGui.Name = "CreatorChatMenu"
    creatorChatGui.ResetOnSpawn = false
    creatorChatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    creatorChatGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local chatMenuFrame = Instance.new("Frame")
    chatMenuFrame.Size = UDim2.new(0, 300, 0, 100)
    chatMenuFrame.Position = UDim2.new(0, 10, 0.5, -50)
    chatMenuFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    chatMenuFrame.BackgroundTransparency = 0.1
    chatMenuFrame.Parent = creatorChatGui
    Instance.new("UICorner", chatMenuFrame).CornerRadius = UDim.new(0, 10)

    local menuTitle = Instance.new("TextLabel")
    menuTitle.Size = UDim2.new(1, 0, 0, 30)
    menuTitle.BackgroundTransparency = 1
    menuTitle.Text = "⭐ Creator Broadcast (Kéo tiêu đề này)"
    menuTitle.Font = Enum.Font.GothamBold
    menuTitle.TextSize = 16
    menuTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    menuTitle.Parent = chatMenuFrame

    local dragging = false
    local dragInput, mousePos, framePos

    menuTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = chatMenuFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    menuTitle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            chatMenuFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    local creatorInput = Instance.new("TextBox")
    creatorInput.Size = UDim2.new(1, -20, 0, 30)
    creatorInput.Position = UDim2.new(0, 10, 0, 35)
    creatorInput.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    creatorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    creatorInput.PlaceholderText = "Nhập tin nhắn broadcast..."
    creatorInput.ClearTextOnFocus = false
    creatorInput.Font = Enum.Font.Gotham
    creatorInput.TextSize = 14
    creatorInput.Parent = chatMenuFrame
    Instance.new("UICorner", creatorInput).CornerRadius = UDim.new(0, 5)

    local sendBroadcastBtn = Instance.new("TextButton")
    sendBroadcastBtn.Size = UDim2.new(1, -20, 0, 30)
    sendBroadcastBtn.Position = UDim2.new(0, 10, 1, -40)
    sendBroadcastBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sendBroadcastBtn.Text = "Gửi Tin Nhắn"
    sendBroadcastBtn.Font = Enum.Font.GothamBold
    sendBroadcastBtn.TextSize = 14
    sendBroadcastBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    sendBroadcastBtn.Parent = chatMenuFrame
    Instance.new("UICorner", sendBroadcastBtn).CornerRadius = UDim.new(0, 5)

    sendBroadcastBtn.MouseButton1Click:Connect(function()
        local msg = creatorInput.Text
        if msg == "" then return end
        
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local msgVal = char.Head:FindFirstChild("CreatorBroadcastMsg")
            if not msgVal then
                msgVal = Instance.new("StringValue")
                msgVal.Name = "CreatorBroadcastMsg"
                msgVal.Parent = char.Head
            end
            msgVal.Value = "" 
            task.wait()
            msgVal.Value = msg
        end
        creatorInput.Text = ""
    end)
end

-- ===================== PHẦN 5: NHẬN THÔNG BÁO BROADCAST (ĐÃ SỬA: HỖ TRỢ CREATOR JOIN MUỘN) =====================
local function showNotification(message)
    local notiGui = Instance.new("ScreenGui")
    notiGui.Name = "BroadcastNotification"
    notiGui.ResetOnSpawn = false
    notiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notiGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local notiFrame = Instance.new("Frame")
    notiFrame.Size = UDim2.new(0, 400, 0, 60)
    notiFrame.Position = UDim2.new(0.5, -200, 0, 20)
    notiFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    notiFrame.BackgroundTransparency = 0.1
    notiFrame.Parent = notiGui
    Instance.new("UICorner", notiFrame).CornerRadius = UDim.new(0, 10)
    
    local notiStroke = Instance.new("UIStroke", notiFrame)
    notiStroke.Color = Color3.fromRGB(255, 215, 0)
    notiStroke.Thickness = 2

    local notiText = Instance.new("TextLabel")
    notiText.Size = UDim2.new(1, -20, 1, -10)
    notiText.Position = UDim2.new(0, 10, 0, 5)
    notiText.BackgroundTransparency = 1
    notiText.Text = "⭐️script creator: " .. message
    notiText.Font = Enum.Font.GothamBold
    notiText.TextSize = 18
    notiText.TextColor3 = Color3.fromRGB(255, 215, 0)
    notiText.TextWrapped = true
    notiText.TextStrokeTransparency = 0.5
    notiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    notiText.Parent = notiFrame

    task.delay(3, function() if notiGui.Parent then notiGui:Destroy() end end)
end

local function setupBroadcastListener(creatorPlayer)
    local function monitorCharacter(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local msgVal = head:FindFirstChild("CreatorBroadcastMsg")
        if not msgVal then
            msgVal = Instance.new("StringValue")
            msgVal.Name = "CreatorBroadcastMsg"
            msgVal.Parent = head
        end
        
        msgVal.Changed:Connect(function(newVal)
            if newVal ~= "" then
                showNotification(newVal)
                msgVal.Value = "" 
            end
        end)
    end
    
    if creatorPlayer.Character then 
        task.spawn(function() monitorCharacter(creatorPlayer.Character) end) 
    end
    creatorPlayer.CharacterAdded:Connect(monitorCharacter)
end

-- Gọi ngay nếu creator đã có trong server
local existingCreator = Players:FindFirstChild(CREATOR_NAME)
if existingCreator then
    setupBroadcastListener(existingCreator)
end

-- Lắng nghe nếu creator join sau (ĐÃ SỬA: Xử lý edge case join muộn)
Players.PlayerAdded:Connect(function(player)
    if player.Name == CREATOR_NAME then
        setupBroadcastListener(player)
    end
end)

-- ===================== PHẦN 6: CHAT TO HEAD (ĐÃ SỬA: TÔN TRỌNG KẾT QUẢ TRẢ VỀ NIL CỦA OLDHOOK) =====================
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

        -- ĐÃ SỬA: Luôn trả về kết quả của oldHook (kể cả nil) để không vô tình bypass bộ lọc chat của game
        if oldHook then
            local success, result = pcall(function()
                return oldHook(message)
            end)
            if success then
                return result 
            end
        end
        
        -- Chỉ trả về message gốc nếu KHÔNG có oldHook nào tồn tại
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
