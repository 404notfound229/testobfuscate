-- // Expiry Check //
local expiryDates = {
    FreeUser = os.time{year=2025, month=5, day=8},   -- Дата истечения для обычных пользователей
    Developer = os.time{year=2029, month=3, day=6}    -- Дата истечения для разработчиков
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local developers = {"DDQW3EWQD", "YOUCREATEDFORME"}
local isDeveloper = table.find(developers, player.Name) ~= nil

local currentTime = os.time()
local expireUnix = isDeveloper and expiryDates.Developer or expiryDates.FreeUser

if currentTime > expireUnix then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⛔ Access Expired",
        Text = isDeveloper and "Your developer access has expired!" or "Your free access has expired!",
        Duration = 6
    })
    
    return -- ❗ Полностью останавливает выполнение скрипта, если срок истёк
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = isDeveloper and "✅ Developer Access" or "✅ Free Access",
        Text = isDeveloper and "Welcome back, developer!" or "Hello,Free User Sexy!",
        Duration = 5
    })
end







-- Настройки:
local active = true
local trueActive = true
local reachType = "Sphere"
local dmgEnabled = true
local visualizerEnabled = false
local walkSpeedEnabled = false
local spinEnabled = false
local desiredSpeed = 80

-- Создание визуализатора
local visualizer = Instance.new("Part")
visualizer.BrickColor = BrickColor.Blue()
visualizer.Transparency = 0.6
visualizer.Anchored = true
visualizer.CanCollide = false
visualizer.Size = Vector3.new(0.5, 0.5, 0.5)
visualizer.BottomSurface = Enum.SurfaceType.Smooth
visualizer.TopSurface = Enum.SurfaceType.Smooth

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0, 0.5)
Frame.Position = UDim2.new(0, 10, 0.5, 0)
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.BorderSizePixel = 4

-- Перетаскивание
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Frame.Active = true
Frame.Selectable = true
Frame.Draggable = false

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function createLabel(text, pos)
	local label = Instance.new("TextLabel", Frame)
	label.Text = text
	label.Size = UDim2.new(0.6, 0, 0.1, 0)
	label.Position = pos
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Font = Enum.Font.SourceSans
	return label
end

local function createToggle(position, initialColor)
	local toggleFrame = Instance.new("Frame", Frame)
	toggleFrame.Position = position
	toggleFrame.Size = UDim2.new(0, 25, 0, 25)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(31,31,31)

	local fill = Instance.new("Frame", toggleFrame)
	fill.AnchorPoint = Vector2.new(0.5, 0.5)
	fill.Position = UDim2.new(0.5, 0, 0.5, 0)
	fill.Size = initialColor and UDim2.new(1, 0, 1, 0) or UDim2.new(0,0,0,0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	fill.BorderSizePixel = 0

	return toggleFrame, fill
end

-- Reach Value
createLabel("Reach:", UDim2.new(0, 0, 0.05, 0))
local TextBox = Instance.new("TextBox", Frame)
TextBox.Position = UDim2.new(0.6, 0, 0.05, 0)
TextBox.Size = UDim2.new(0.35, 0, 0.1, 0)
TextBox.Text = "3.5"
TextBox.TextScaled = true
TextBox.TextColor3 = Color3.fromRGB(0,0,255)
TextBox.BackgroundTransparency = 1
TextBox.Font = Enum.Font.SourceSans

-- Reach Type
createLabel("Shape:", UDim2.new(0, 0, 0.18, 0))
local ShapeBtn = Instance.new("TextButton", Frame)
ShapeBtn.Position = UDim2.new(0.6, 0, 0.18, 0)
ShapeBtn.Size = UDim2.new(0.35, 0, 0.1, 0)
ShapeBtn.Text = "Sphere"
ShapeBtn.TextColor3 = Color3.fromRGB(0,0,255)
ShapeBtn.BackgroundTransparency = 1
ShapeBtn.Font = Enum.Font.SourceSans
ShapeBtn.TextScaled = true

-- Toggles
createLabel("Damage:", UDim2.new(0, 0, 0.31, 0))
local dmgToggle, dmgFill = createToggle(UDim2.new(0.725, 0, 0.31, 0), dmgEnabled)

createLabel("Visualizer:", UDim2.new(0, 0, 0.44, 0))
local visToggle, visFill = createToggle(UDim2.new(0.725, 0, 0.44, 0), visualizerEnabled)

createLabel("WalkSpeed:", UDim2.new(0, 0, 0.57, 0))
local speedToggle, speedFill = createToggle(UDim2.new(0.725, 0, 0.57, 0), walkSpeedEnabled)

createLabel("Spin:", UDim2.new(0, 0, 0.70, 0))
local spinToggle, spinFill = createToggle(UDim2.new(0.725, 0, 0.70, 0), spinEnabled)


-- Close GUI
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Position = UDim2.new(0, 0, 0.85, 0)
CloseBtn.Size = UDim2.new(1, 0, 0.12, 0)
CloseBtn.Text = "Close GUI (R)"
CloseBtn.TextScaled = true
CloseBtn.TextColor3 = Color3.fromRGB(0, 0, 255)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold

-- Toggle Handlers
local plr = game.Players.LocalPlayer
local walkSpeedConn

local bv -- BodyVelocity
local moveConn

local function updateWalkSpeed()
	-- Очистка прошлых соединений и BV
	if moveConn then moveConn:Disconnect() moveConn = nil end
	if bv then bv:Destroy() bv = nil end

	local char = plr.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildWhichIsA("Humanoid")

	if walkSpeedEnabled then
		bv = Instance.new("BodyVelocity")
		bv.Name = "UndetectedSpeed"
		bv.MaxForce = Vector3.new(1e5, 0, 1e5)
		bv.Velocity = Vector3.zero
		bv.Parent = hrp

		moveConn = game:GetService("RunService").RenderStepped:Connect(function()
			if hum and hrp and bv and walkSpeedEnabled then
				local dir = hum.MoveDirection
				if dir.Magnitude > 0 then
					bv.Velocity = dir.Unit * desiredSpeed
				else
					bv.Velocity = Vector3.zero
				end
			end
		end)
	else
		if bv then bv:Destroy() bv = nil end
	end
end



dmgToggle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		dmgEnabled = not dmgEnabled
		local goal = dmgEnabled and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)
		game.TweenService:Create(dmgFill, TweenInfo.new(0.12), {Size = goal}):Play()
	end
end)

visToggle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		visualizerEnabled = not visualizerEnabled
		local goal = visualizerEnabled and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)
		game.TweenService:Create(visFill, TweenInfo.new(0.12), {Size = goal}):Play()
	end
end)

speedToggle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		walkSpeedEnabled = not walkSpeedEnabled
		local goal = walkSpeedEnabled and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)
		game.TweenService:Create(speedFill, TweenInfo.new(0.12), {Size = goal}):Play()
		updateWalkSpeed()
	end
end)


local bav -- BodyAngularVelocity
local spinConn

local function updateSpin()
	-- Очистка прошлых соединений и BAV
	if spinConn then spinConn:Disconnect() spinConn = nil end
	if bav then bav:Destroy() bav = nil end

	local char = plr.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if spinEnabled then
		bav = Instance.new("BodyAngularVelocity")
		bav.Name = "UndetectedSpin"
		bav.MaxTorque = Vector3.new(0, math.huge, 0)
		bav.AngularVelocity = Vector3.new(0, 5, 0) -- скорость вращения (можешь поменять на 10 или выше)
		bav.P = 1250
		bav.Parent = hrp

		spinConn = game:GetService("RunService").RenderStepped:Connect(function()
			if not spinEnabled or not bav then return end
			if not char or not hrp then return end
			bav.AngularVelocity = Vector3.new(0, 30, 0)
		end)
	else
		if bav then bav:Destroy() bav = nil end
	end
end


spinToggle.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		spinEnabled = not spinEnabled
		local goal = spinEnabled and UDim2.new(1,0,1,0) or UDim2.new(0,0,0,0)
		game.TweenService:Create(spinFill, TweenInfo.new(0.12), {Size = goal}):Play()
		updateSpin()
	end
end)


ShapeBtn.MouseButton1Click:Connect(function()
	reachType = reachType == "Sphere" and "Line" or "Sphere"
	ShapeBtn.Text = reachType
end)

CloseBtn.MouseButton1Click:Connect(function()
	trueActive = false
	if walkSpeedConn then walkSpeedConn:Disconnect() end
	ScreenGui:Destroy()
end)

game:GetService("UserInputService").InputBegan:Connect(function(inp,gpe)
	if gpe then return end
	if inp.KeyCode == Enum.KeyCode.R then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-- Core Logic
local function onHit(hit,handle)
    local victim = hit.Parent:FindFirstChildOfClass("Humanoid")
    if victim and victim.Parent.Name ~= plr.Name then
        if dmgEnabled then
            for _,v in pairs(hit.Parent:GetChildren()) do
                if v:IsA("Part") then
                    firetouchinterest(v,handle,0)
                    firetouchinterest(v,handle,1)
                end
            end
        else
            firetouchinterest(hit,handle,0)
            firetouchinterest(hit,handle,1)
        end
    end
end

local function getWhiteList()
    local wl = {}
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= plr then
            local char = v.Character
            if char then
                for _,q in pairs(char:GetChildren()) do
                    if q:IsA("Part") then
                        table.insert(wl,q)
                    end
                end
            end
        end
    end
    return wl
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not active or not trueActive then return end
	local char = plr.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if not tool then visualizer.Parent = nil return end

	local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
	if not handle then return end




	visualizer.Parent = visualizerEnabled and workspace or nil
	local reach = tonumber(TextBox.Text)
	if not reach then return end

	if reachType == "Sphere" then
		visualizer.Shape = Enum.PartType.Ball
		visualizer.Material = Enum.Material.ForceField
		visualizer.Size = Vector3.new(reach, reach, reach)
		visualizer.CFrame = handle.CFrame
		for _,v in pairs(game.Players:GetPlayers()) do
			local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
			if hrp and (hrp.Position - handle.Position).magnitude <= reach then
				onHit(hrp, handle)
			end
		end
	elseif reachType == "Line" then
		local origin = (handle.CFrame * CFrame.new(0, 0, -2)).p
		local ray = Ray.new(origin, handle.CFrame.lookVector * -reach)
		local p, _ = workspace:FindPartOnRayWithWhitelist(ray, getWhiteList())
		visualizer.Shape = Enum.PartType.Block
		visualizer.Size = Vector3.new(1, 0.8, reach)
		visualizer.CFrame = handle.CFrame * CFrame.new(0, 0, (reach / 2) + 2)
		if p then
			onHit(p, handle)
		else
			for _,v in pairs(handle:GetTouchingParts()) do
				onHit(v, handle)
			end
		end
	end
end)

-- Watermark GUI
local wmGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
wmGui.Name = "WatermarkGUI"
wmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
wmGui.ResetOnSpawn = false
wmGui.DisplayOrder = 999999998

local watermark = Instance.new("TextLabel")
watermark.Name = "Watermark"
watermark.Parent = wmGui
watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
watermark.BackgroundTransparency = 0.2
watermark.Position = UDim2.new(1, -260, 0, 10)
watermark.Size = UDim2.new(0, 250, 0, 30)
watermark.Font = Enum.Font.GothamBold
watermark.Text = "Euphoria.lol"
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.TextStrokeTransparency = 0.5
watermark.TextSize = 16
watermark.TextXAlignment = Enum.TextXAlignment.Center
watermark.TextYAlignment = Enum.TextYAlignment.Center

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = watermark








local expireDateTbl = os.date("*t", expireUnix)
local expireDate = string.format("%02d/%02d/%04d", expireDateTbl.day, expireDateTbl.month, expireDateTbl.year)


-- Водяной знак Expire Time
local bottomWm = Instance.new("Frame")
bottomWm.Name = "BottomWatermark"
bottomWm.Parent = wmGui
bottomWm.AnchorPoint = Vector2.new(0.5, 1)
bottomWm.Position = UDim2.new(0.5, 0, 1, -10)
bottomWm.Size = UDim2.new(0.1, 600, 0, 30)
bottomWm.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bottomWm.BackgroundTransparency = 0.3

local uiCorner = Instance.new("UICorner", bottomWm)
uiCorner.CornerRadius = UDim.new(0, 6)

local expireLabel = Instance.new("TextLabel")
expireLabel.Parent = bottomWm
expireLabel.BackgroundTransparency = 1
expireLabel.Size = UDim2.new(1, 0, 1, 0)
expireLabel.Font = Enum.Font.Gotham
expireLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
expireLabel.TextScaled = true
expireLabel.TextStrokeTransparency = 0.7
expireLabel.Text = "Loading..."

-- FPS счётчик
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local Heartbeat = RunService.Heartbeat
local lastTime = tick()
local frameCount = 0
local fps = 0

-- Пинг
local function getPing()
	local pingStat = StatsService:FindFirstChild("PerformanceStats")
	if pingStat then
		local ping = pingStat:FindFirstChild("Ping")
		if ping then
			return math.floor(ping:GetValue())
		end
	end
	return 0
end

-- Обновление надписи каждую секунду
task.spawn(function()
	while true do
		frameCount += 1
		local now = tick()
		if now - lastTime >= 1 then
			fps = frameCount
			frameCount = 0
			lastTime = now

			local plrName = plr.DisplayName or plr.Name
			local ping = getPing()
			local t = os.date("*t")
			local hour = t.hour
			local ampm = hour >= 12 and "PM" or "AM"
			hour = hour % 12
			if hour == 0 then hour = 12 end
			local timeStr = string.format("%02d:%02d %s", hour, t.min, ampm)
			local dateStr = string.format("%02d/%02d/%04d", t.day, t.month, t.year)

			expireLabel.Text = string.format("👤 %s  |  ⚡ %d ms  |  🎯 %d FPS  |  🕒 %s  |  📅 %s  |  ⌛ Expire: %s",
				plrName, ping, fps, timeStr, dateStr, expireDate)
		end
		Heartbeat:Wait()
	end
end)
