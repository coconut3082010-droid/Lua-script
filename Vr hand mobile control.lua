local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileControls"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

----------------------------------------------------------------
-- JOYSTICK (WASD) - bottom left
----------------------------------------------------------------
local JoyBG = Instance.new("Frame")
JoyBG.Name = "JoystickBG"
JoyBG.Size = UDim2.new(0, 130, 0, 130)
JoyBG.Position = UDim2.new(0, 30, 1, -170)
JoyBG.AnchorPoint = Vector2.new(0, 0)
JoyBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JoyBG.BackgroundTransparency = 0.4
JoyBG.BorderSizePixel = 0
JoyBG.Active = true
JoyBG.Parent = ScreenGui

local JoyBGCorner = Instance.new("UICorner", JoyBG)
JoyBGCorner.CornerRadius = UDim.new(0.5, 0)

local JoyStroke = Instance.new("UIStroke", JoyBG)
JoyStroke.Color = Color3.fromRGB(255, 255, 255)
JoyStroke.Transparency = 0.6
JoyStroke.Thickness = 1.5

local JoyKnob = Instance.new("Frame")
JoyKnob.Name = "Knob"
JoyKnob.Size = UDim2.new(0, 55, 0, 55)
JoyKnob.AnchorPoint = Vector2.new(0.5, 0.5)
JoyKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
JoyKnob.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
JoyKnob.BorderSizePixel = 0
JoyKnob.Parent = JoyBG

local JoyKnobCorner = Instance.new("UICorner", JoyKnob)
JoyKnobCorner.CornerRadius = UDim.new(0.5, 0)

local heldKeys = {W = false, A = false, S = false, D = false}

local function setKey(key, state)
	if heldKeys[key] == state then return end
	heldKeys[key] = state
	local codeMap = {W = Enum.KeyCode.W, A = Enum.KeyCode.A, S = Enum.KeyCode.S, D = Enum.KeyCode.D}
	VIM:SendKeyEvent(state, codeMap[key].Name, false, game)
end

local dragging = false
local joyCenter = Vector2.new()
local maxDist = 45

local function updateJoystick(inputPos)
	local delta = Vector2.new(inputPos.X, inputPos.Y) - joyCenter
	local dist = math.min(delta.Magnitude, maxDist)
	local dir = (delta.Magnitude > 0) and delta.Unit or Vector2.new()
	local offset = dir * dist

	JoyKnob.Position = UDim2.new(0.5, offset.X, 0.5, offset.Y)

	local deadzone = 12
	local nx, ny = offset.X, offset.Y

	setKey("W", ny < -deadzone)
	setKey("S", ny > deadzone)
	setKey("A", nx < -deadzone)
	setKey("D", nx > deadzone)
end

local function resetJoystick()
	dragging = false
	JoyKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
	setKey("W", false)
	setKey("A", false)
	setKey("S", false)
	setKey("D", false)
end

JoyBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		local absPos = JoyBG.AbsolutePosition
		local absSize = JoyBG.AbsoluteSize
		joyCenter = Vector2.new(absPos.X + absSize.X / 2, absPos.Y + absSize.Y / 2)
		updateJoystick(input.Position)
	end
end)

JoyBG.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		updateJoystick(input.Position)
	end
end)

JoyBG.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		resetJoystick()
	end
end)

----------------------------------------------------------------
-- RIGHT SIDE BUTTONS: E, Q, LMB, RMB, Space, Shift, Alt, +, -
----------------------------------------------------------------
local RightContainer = Instance.new("Frame")
RightContainer.Name = "RightButtons"
RightContainer.Size = UDim2.new(0, 140, 0, 240)
RightContainer.Position = UDim2.new(1, -155, 1, -260)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = ScreenGui

local buttonDefs = {
	{text = "E",     row = 1, col = 1, type = "key",   code = Enum.KeyCode.E},
	{text = "Q",     row = 1, col = 2, type = "key",   code = Enum.KeyCode.Q},
	{text = "LMB",   row = 2, col = 1, type = "mouse", btn = 0},
	{text = "RMB",   row = 2, col = 2, type = "mouse", btn = 1},
	{text = "Space", row = 3, col = 1, type = "key",   code = Enum.KeyCode.Space},
	{text = "Shift", row = 3, col = 2, type = "key",   code = Enum.KeyCode.LeftShift},
	{text = "Alt",   row = 4, col = 1, type = "key",   code = Enum.KeyCode.LeftAlt},
	{text = "+",     row = 4, col = 2, type = "key",   code = Enum.KeyCode.Equals},
	{text = "-",     row = 5, col = 1, type = "key",   code = Enum.KeyCode.Minus},
}

local btnW, btnH, gap = 62, 40, 6
local LOCK_TIME = 3 -- giây giữ để khoá

local function createHoldButton(def)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, btnW, 0, btnH)
	btn.Position = UDim2.new(
		0, (def.col - 1) * (btnW + gap),
		0, (def.row - 1) * (btnH + gap)
	)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BackgroundTransparency = 0.55
	btn.AutoButtonColor = false
	btn.Text = def.text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextTransparency = 0.15
	btn.Active = true
	btn.Parent = RightContainer

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.75
	stroke.Thickness = 1

	local isLocked = false
	local holdStart = 0

	local function doPress()
		if def.type == "key" then
			VIM:SendKeyEvent(true, def.code.Name, false, game)
		elseif def.type == "mouse" then
			VIM:SendMouseButtonEvent(0, 0, def.btn, true, game, 1)
		end
	end

	local function doRelease()
		if def.type == "key" then
			VIM:SendKeyEvent(false, def.code.Name, false, game)
		elseif def.type == "mouse" then
			VIM:SendMouseButtonEvent(0, 0, def.btn, false, game, 1)
		end
	end

	local function setVisualHeld(held)
		if held then
			btn.BackgroundTransparency = 0.15
			stroke.Transparency = 0.3
		else
			btn.BackgroundTransparency = 0.55
			stroke.Transparency = 0.75
		end
	end

	local function setVisualLocked(locked)
		if locked then
			stroke.Color = Color3.fromRGB(255, 210, 60)
			stroke.Transparency = 0.1
			stroke.Thickness = 1.5
		else
			stroke.Color = Color3.fromRGB(255, 255, 255)
			stroke.Transparency = 0.75
			stroke.Thickness = 1
		end
	end

	-- GỘP LẠI THÀNH 1 INPUTBEGAN ĐỂ TRÁNH XUNG ĐỘT
	btn.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if isLocked then
			-- Nhấn lại để mở khoá (Unlock)
			isLocked = false
			setVisualLocked(false)
			setVisualHeld(false)
			doRelease()
			return
		end

		-- Bắt đầu giữ (Cập nhật lại thời gian để InputEnded không bị tính nhầm)
		holdStart = tick() 
		setVisualHeld(true)
		doPress()
	end)

	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if isLocked then
			return -- đang khoá, bỏ qua
		end

		local heldDuration = tick() - holdStart
		if heldDuration >= LOCK_TIME then
			-- Giữ đủ lâu -> Khoá (Lock), KHÔNG nhả phím
			isLocked = true
			setVisualLocked(true)
			setVisualHeld(true)
		else
			-- Giữ ngắn -> Nhả phím bình thường
			setVisualHeld(false)
			doRelease()
		end
	end)

	return btn
end

for _, def in ipairs(buttonDefs) do
	createHoldButton(def)
end

----------------------------------------------------------------
-- WHEEL SLIDER (vertical drag = scroll up/down)
----------------------------------------------------------------
local WheelBG = Instance.new("Frame")
WheelBG.Name = "WheelSlider"
WheelBG.Size = UDim2.new(0, 32, 0, 180)
WheelBG.Position = UDim2.new(1, -175, 1, -260)
WheelBG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WheelBG.BackgroundTransparency = 0.55
WheelBG.BorderSizePixel = 0
WheelBG.Active = true
WheelBG.Parent = ScreenGui

local WheelCorner = Instance.new("UICorner", WheelBG)
WheelCorner.CornerRadius = UDim.new(0, 12)

local WheelStroke = Instance.new("UIStroke", WheelBG)
WheelStroke.Color = Color3.fromRGB(255, 255, 255)
WheelStroke.Transparency = 0.75
WheelStroke.Thickness = 1

local WheelKnob = Instance.new("Frame")
WheelKnob.Name = "Knob"
WheelKnob.Size = UDim2.new(0, 26, 0, 26)
WheelKnob.AnchorPoint = Vector2.new(0.5, 0.5)
WheelKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
WheelKnob.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
WheelKnob.BackgroundTransparency = 0.2
WheelKnob.BorderSizePixel = 0
WheelKnob.Parent = WheelBG

local WheelKnobCorner = Instance.new("UICorner", WheelKnob)
WheelKnobCorner.CornerRadius = UDim.new(0.5, 0)

local wheelDragging = false
local wheelHalfHeight = 72
local lastScrollTick = 0
local scrollInterval = 0.05

local function sendScroll(amount)
	local mouse = player:GetMouse()
	VIM:SendMouseWheelEvent(mouse.X, mouse.Y, amount > 0, game)
end

local function updateWheel(inputPos, bgAbsPos, bgAbsSize)
	local centerY = bgAbsPos.Y + bgAbsSize.Y / 2
	local offsetY = inputPos.Y - centerY
	offsetY = math.clamp(offsetY, -wheelHalfHeight, wheelHalfHeight)

	WheelKnob.Position = UDim2.new(0.5, 0, 0.5, offsetY)

	local strength = -offsetY / wheelHalfHeight

	if math.abs(strength) > 0.15 then
		local now = tick()
		if now - lastScrollTick >= scrollInterval then
			lastScrollTick = now
			sendScroll(strength)
		end
	end
end

local function resetWheel()
	wheelDragging = false
	WheelKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
end

WheelBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		wheelDragging = true
		updateWheel(input.Position, WheelBG.AbsolutePosition, WheelBG.AbsoluteSize)
	end
end)

WheelBG.InputChanged:Connect(function(input)
	if wheelDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		updateWheel(input.Position, WheelBG.AbsolutePosition, WheelBG.AbsoluteSize)
	end
end)

WheelBG.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		resetWheel()
	end
end)
