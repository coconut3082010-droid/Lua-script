-- LocalScript (đặt trong StarterPlayerScripts)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- ============ GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JobIdTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Nút mở menu
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 48, 0, 48)
toggleButton.Position = UDim2.new(0, 15, 0.45, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
toggleButton.Text = "🌐"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.ZIndex = 10
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 120, 255)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleButton

-- Frame chính — Size cố định bằng Offset (không dùng Scale nữa, đơn giản & ổn định hơn)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 75, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
mainFrame.ClipsDescendants = false -- QUAN TRỌNG: false để nội dung không bị cắt mất
mainFrame.Visible = false
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 120, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Trên màn hình nhỏ (mobile), thu nhỏ khung một chút bằng script thay vì Scale
do
	local viewport = workspace.CurrentCamera.ViewportSize
	if viewport.X < 500 then
		mainFrame.Size = UDim2.new(0, 260, 0, 200)
	end
end

-- Thanh tiêu đề (tay cầm kéo)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.ZIndex = 11
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 11
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Server Teleport  ⠿"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 11
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.Position = UDim2.new(1, -5, 0.5, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.ZIndex = 12
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Nội dung
local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, -30, 0, 20)
descLabel.Position = UDim2.new(0, 15, 0, 50)
descLabel.BackgroundTransparency = 1
descLabel.Text = "Nhập Job ID của server:"
descLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
descLabel.Font = Enum.Font.Gotham
descLabel.TextSize = 13
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.ZIndex = 11
descLabel.Parent = mainFrame

local textBoxBG = Instance.new("Frame")
textBoxBG.Size = UDim2.new(1, -30, 0, 40)
textBoxBG.Position = UDim2.new(0, 15, 0, 72)
textBoxBG.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
textBoxBG.ZIndex = 11
textBoxBG.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = textBoxBG

local textBoxStroke = Instance.new("UIStroke")
textBoxStroke.Color = Color3.fromRGB(60, 60, 70)
textBoxStroke.Thickness = 1
textBoxStroke.Parent = textBoxBG

local jobIdBox = Instance.new("TextBox")
jobIdBox.Size = UDim2.new(1, -20, 1, 0)
jobIdBox.Position = UDim2.new(0, 10, 0, 0)
jobIdBox.BackgroundTransparency = 1
jobIdBox.PlaceholderText = "Dán Job ID vào đây..."
jobIdBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
jobIdBox.Text = ""
jobIdBox.TextColor3 = Color3.new(1, 1, 1)
jobIdBox.Font = Enum.Font.Gotham
jobIdBox.TextSize = 13
jobIdBox.ClearTextOnFocus = false
jobIdBox.TextXAlignment = Enum.TextXAlignment.Left
jobIdBox.ZIndex = 12
jobIdBox.Parent = textBoxBG

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 18)
statusLabel.Position = UDim2.new(0, 15, 0, 116)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextWrapped = true
statusLabel.ZIndex = 11
statusLabel.Parent = mainFrame

local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(1, -30, 0, 36)
joinButton.Position = UDim2.new(0, 15, 0, 145)
joinButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
joinButton.Text = "Join Server"
joinButton.TextColor3 = Color3.new(1, 1, 1)
joinButton.Font = Enum.Font.GothamBold
joinButton.TextSize = 14
joinButton.ZIndex = 11
joinButton.Parent = mainFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

-- ============ KÉO THẢ (đơn giản, mượt, không bay) ============
local function makeDraggable(dragHandle, target)
	local dragging = false
	local dragInput, mousePos, framePos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = target.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - mousePos
			target.Position = UDim2.new(
				framePos.X.Scale, framePos.X.Offset + delta.X,
				framePos.Y.Scale, framePos.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(titleBar, mainFrame)
makeDraggable(toggleButton, toggleButton)

-- ============ LOGIC ============
local isOpen = false

local function toggleMenu()
	isOpen = not isOpen
	mainFrame.Visible = isOpen
end

toggleButton.MouseButton1Click:Connect(toggleMenu)

closeButton.MouseButton1Click:Connect(function()
	isOpen = false
	mainFrame.Visible = false
end)

joinButton.MouseEnter:Connect(function()
	TweenService:Create(joinButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 140, 255)}):Play()
end)
joinButton.MouseLeave:Connect(function()
	TweenService:Create(joinButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}):Play()
end)

local isTeleporting = false

local function attemptTeleport()
	if isTeleporting then return end

	local jobId = jobIdBox.Text:gsub("%s+", "")

	if jobId == "" then
		statusLabel.Text = "Vui lòng nhập Job ID!"
		return
	end

	local pattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
	if not jobId:match(pattern) then
		statusLabel.Text = "Job ID không đúng định dạng!"
		return
	end

	isTeleporting = true
	statusLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
	statusLabel.Text = "Đang kết nối tới server..."
	joinButton.Text = "Đang tải..."
	joinButton.AutoButtonColor = false

	local success = pcall(function()
		TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
	end)

	if not success then
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		statusLabel.Text = "Lỗi: Server có thể đã đầy hoặc không tồn tại."
		joinButton.Text = "Join Server"
		joinButton.AutoButtonColor = true
		isTeleporting = false
	end
end

joinButton.MouseButton1Click:Connect(attemptTeleport)

jobIdBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		attemptTeleport()
	end
end)
