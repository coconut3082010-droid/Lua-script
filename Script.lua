getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===================== KHAI BÁO SERVICE DUY NHẤT (Tránh lỗi xung đột) =====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

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

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "0"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
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
        if amount then
            CashAmount = math.clamp(amount, 1, 9999)
        else
            Rayfield:Notify({
                Title = "error",
                Content = "please enter a valid number",
                Duration = 2
            })
        end
    end,
})

local CashButton = StatsTab:CreateButton({
    Name = "Confirm Money",
    Callback = function()
        local args = { CashAmount }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("CashEvent")
            :FireServer(unpack(args))

        Rayfield:Notify({
            Title = "success",
            Content = "gived " .. CashAmount .. " money",
            Duration = 2
        })
    end,
})

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
        if amount then
            boostAmount = math.clamp(amount, 1, 9999)
        else
            Rayfield:Notify({
                Title = "error",
                Content = "please enter a valid nunber",
                Duration = 2
            })
        end
    end,
})

local BoostButton = StatsTab:CreateButton({
    Name = "Confirm Boost",
    Callback = function()
        local args = { boostAmount }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("ApplyBoost")
            :FireServer(unpack(args))

        Rayfield:Notify({
            Title = "success",
            Content = "gived " .. boostAmount .. " boost",
            Duration = 3
        })
    end,
})

local RocketSection = StatsTab:CreateSection("get rocket")

local RocketButton = StatsTab:CreateButton({
    Name = "Get Rocket",
    Callback = function()
        local args = { 1 }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("AwardRocket")
            :FireServer(unpack(args))

        Rayfield:Notify({
            Title = "success",
            Content = "gived rocket",
            Duration = 3
        })
    end,
})

-- ===================== TAB: FREEGAMEPASS =====================
local FreegamepassTab = Window:CreateTab("freegamepass", "sparkles")

local RemoveScriptButton = FreegamepassTab:CreateButton({
    Name = "get free Golden Ski Poles gamepass",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = player.Backpack:FindFirstChild("Golden Ski Poles")
            or (player.Character and player.Character:FindFirstChild("Golden Ski Poles"))

        if tool then
            local script1 = tool:FindFirstChild("LocalScript")
            if script1 then
                script1:Destroy()
                Rayfield:Notify({
                    Title = "success",
                    Content = "you now can use Golden Ski Poles,gamepass will reset when you die",
                    Duration = 3
                })
            else
                Rayfield:Notify({
                    Title = "notification",
                    Content = "you already use free gamepass",
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "error",
                Content = "don't found Golden Ski Poles in your inventory",
                Duration = 3
            })
        end
    end,
})

-- ===================== TAB: LOCAL PLAYER =====================
local LocalPlayerTab = Window:CreateTab("local player", "user")

local SpeedSlider = LocalPlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

local InfinityJumpEnabled = false
local jumpConnection

local InfinityJumpToggle = LocalPlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        InfinityJumpEnabled = Value

        if InfinityJumpEnabled then
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end,
})

-- ===================== TAB: CREDIT =====================
local CreditTab = Window:CreateTab("credit", "info")

local CreatorInfo = CreditTab:CreateParagraph({
    Title = "creator",
    Content = "Coconut on discord"
})

local DiscordButton = CreditTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        local discordLink = "sorry ,discord server coming soon"

        if setclipboard then
            setclipboard(discordLink)
            Rayfield:Notify({
                Title = "Discord",
                Content = "Link discord copy to clipboard",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "error",
                Content = "Executor doest support copy link",
                Duration = 3
            })
        end
    end,
})

-- ===================== PHẦN 2: CREATOR JOIN POPUP =====================
local CREATOR_USERNAME = "rei123456rmrmrjmndf"

local function showCreatorPopup(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CreatorJoinPopup"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 12
    accentBar.Parent = card

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 14)
    accentCorner.Parent = accentBar

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

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badge

    local badgePadding = Instance.new("UIPadding")
    badgePadding.PaddingTop = UDim.new(0, 4)
    badgePadding.PaddingBottom = UDim.new(0, 4)
    badgePadding.PaddingLeft = UDim.new(0, 4)
    badgePadding.PaddingRight = UDim.new(0, 4)
    badgePadding.Parent = badge

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
    tpButton.AutoButtonColor = true
    tpButton.Parent = card

    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpButton

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
    closeButton.AutoButtonColor = true
    closeButton.Parent = card

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local function closePopup()
        local fadeOut = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        local strokeFade = TweenService:Create(cardStroke, TweenInfo.new(0.25), {Transparency = 1})
        local backdropFade = TweenService:Create(backdrop, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        fadeOut:Play()
        strokeFade:Play()
        backdropFade:Play()

        for _, obj in ipairs(card:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                TweenService:Create(obj, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end
        end

        task.wait(0.3)
        screenGui:Destroy()
    end

    closeButton.MouseButton1Click:Connect(closePopup)

    tpButton.MouseButton1Click:Connect(function()
        local localChar = Players.LocalPlayer.Character
        local creatorChar = player.Character

        if localChar and localChar:FindFirstChild("HumanoidRootPart")
           and creatorChar and creatorChar:FindFirstChild("HumanoidRootPart") then
            localChar.HumanoidRootPart.CFrame = creatorChar.HumanoidRootPart.CFrame
        end
        closePopup()
    end)

    card.Position = UDim2.new(0.5, 0, 0.5, 10)
    local fadeInCard = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.05, Position = UDim2.new(0.5, 0, 0.5, 0)})
    local fadeInBackdrop = TweenService:Create(backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 0.5})
    local fadeInStroke = TweenService:Create(cardStroke, TweenInfo.new(0.35), {Transparency = 0.3})
    fadeInCard:Play()
    fadeInBackdrop:Play()
    fadeInStroke:Play()

    for _, obj in ipairs({title, displayNameLabel, usernameLabel, tpButton, closeButton}) do
        TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    end
    TweenService:Create(badge, TweenInfo.new(0.4), {TextTransparency = 0, BackgroundTransparency = 0.85}):Play()
    TweenService:Create(tpButton, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
end

local function onPlayerAdded(player)
    if player.Name == CREATOR_USERNAME then
        task.wait(1)
        showCreatorPopup(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- ===================== PHẦN 3: CLIENT HEAD TAG =====================
local TARGET_USERNAME = "rei123456rmrmrjmndf"

local function attachTagToTarget(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end
    
    local head = character:WaitForChild("Head", 10)
    if not head then return end

    local oldTag = head:FindFirstChild("ClientCreatorTag")
    if oldTag then 
        oldTag:Destroy() 
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ClientCreatorTag"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(0, 350, 0, 90)
    billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.LightInfluence = 0
    billboardGui.MaxDistance = math.huge
    billboardGui.ResetOnSpawn = false
    billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "script creator"
    
    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    
    textLabel.Parent = billboardGui
end

local function setupTargetTracking(targetPlayer)
    if targetPlayer.Character then
        task.spawn(function()
            attachTagToTarget(targetPlayer)
        end)
    end
    
    targetPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        attachTagToTarget(targetPlayer)
    end)
end

local targetPlayer = Players:FindFirstChild(TARGET_USERNAME)
if targetPlayer then
    setupTargetTracking(targetPlayer)
end

Players.PlayerAdded:Connect(function(player)
    if player.Name == TARGET_USERNAME then
        setupTargetTracking(player)
    end
end)
