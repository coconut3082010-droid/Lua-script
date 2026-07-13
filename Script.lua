getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "draw a sleigh & slide downhill script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "draw a sleigh & slide dowhill script",
   LoadingSubtitle = "by Coconut",
   ShowText = "script", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "0"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

-- ===================== TAB: GET STATS =====================
local StatsTab = Window:CreateTab("get stats", "dollar-sign")

-- ---- Section: Get Money ----
local MoneySection = StatsTab:CreateSection("get money")

local CashAmount = 1 -- giá trị mặc định

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
            Content = "gived" .. CashAmount .. "money",
            Duration = 2
        })
    end,
})

-- ---- Section: Get Boost ----
local BoostSection = StatsTab:CreateSection("get boost")

local boostAmount = 1 -- giá trị mặc định

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
            Content = "gived" .. boostAmount .. " boost",
            Duration = 3
        })
    end,
})
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

-- ---- Speed Slider ----
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

-- ---- Infinity Jump Toggle ----
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
    Content = "Coconut on discord" -- thay bằng tên bạn muốn hiển thị
})

local DiscordButton = CreditTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        local discordLink = "sorry ,discord server coming soon" -- thay link discord thật của bạn

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
