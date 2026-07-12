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

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

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
local Tab = Window:CreateTab("get money", "dollar-sign")
local Section = Tab:CreateSection("get money")
-- Biến lưu giá trị nhập
local CashAmount = 1 -- giá trị mặc định

-- Ô nhập chỉ để LƯU giá trị, không chạy chức năng
local Input = Tab:CreateInput({
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
                Title = "Lỗi",
                Content = "Vui lòng nhập một số hợp lệ",
                Duration = 3
            })
        end
    end,
})

-- Nút bấm mới CHẠY function, dùng giá trị đã lưu
local Button = Tab:CreateButton({
    Name = "Confirm",
    Callback = function()
        local args = { CashAmount }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("CashEvent")
            :FireServer(unpack(args))

        Rayfield:Notify({
            Title = "Thành công",
            Content = "Đã gửi yêu cầu " .. CashAmount .. " tiền",
            Duration = 3
        })
    end,
})
local Section2 = Tab:CreateSection("get boost")
local boostAmount = 1

local BoostInput = Tab:CreateInput({
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
                Title = "Lỗi",
                Content = "Vui lòng nhập một số hợp lệ",
                Duration = 3
            })
        end
    end,
})

local BoostButton = Tab:CreateButton({
    Name = "Confirm",
    Callback = function()
        local args = { boostAmount }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("ApplyBoost")
            :FireServer(unpack(args))

        Rayfield:Notify({
            Title = "Thành công",
            Content = "Đã gửi yêu cầu " .. boostAmount .. " boost",
            Duration = 3
        })
    end,
})
