-- Minhhuy98k14 Script X NgDaoMinNhat

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local speedStep = 5
local bodyVelocity = nil
local bodyGyro = nil
local moveDirection = Vector3.new(0, 0, 0)
local guiVisible = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI_Mobile"
screenGui.Parent = player:WaitForChild("PlayerGui")

local iconBtn = Instance.new("ImageButton")
iconBtn.Size = UDim2.new(0, 60, 0, 60)
iconBtn.Position = UDim2.new(0.85, -30, 0.85, -30)
iconBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
iconBtn.BackgroundTransparency = 0.2
iconBtn.BorderSizePixel = 0
iconBtn.Image = "rbxassetid://0"
iconBtn.ImageTransparency = 1
iconBtn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = iconBtn

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.Position = UDim2.new(0, 0, 0, 0)
iconLabel.Text = "✈"
iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
iconLabel.TextScaled = true
iconLabel.BackgroundTransparency = 1
iconLabel.Font = Enum.Font.SourceSansBold
iconLabel.Parent = iconBtn

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Visible = guiVisible
frame.Parent = screenGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 230, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -115, 0, 10)
toggleBtn.Text = "START FLIGHT"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 230, 0, 25)
speedLabel.Position = UDim2.new(0.5, -115, 0, 55)
speedLabel.Text = "Speed: " .. tostring(speed)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Parent = frame

local decBtn = Instance.new("TextButton")
decBtn.Size = UDim2.new(0, 70, 0, 35)
decBtn.Position = UDim2.new(0.5, -115, 0, 85)
decBtn.Text = "-" .. tostring(speedStep)
decBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
decBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decBtn.TextScaled = true
decBtn.Parent = frame

local incBtn = Instance.new("TextButton")
incBtn.Size = UDim2.new(0, 70, 0, 35)
incBtn.Position = UDim2.new(0.5, 45, 0, 85)
incBtn.Text = "+" .. tostring(speedStep)
incBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
incBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
incBtn.TextScaled = true
incBtn.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 70, 0, 30)
speedInput.Position = UDim2.new(0.5, -35, 0, 130)
speedInput.Text = tostring(speed)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.PlaceholderText = "Set"
speedInput.Parent = frame

local joystickArea = Instance.new("Frame")
joystickArea.Size = UDim2.new(0, 120, 0, 120)
joystickArea.Position = UDim2.new(0, 20, 1, -140)
joystickArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
joystickArea.BackgroundTransparency = 0.85
joystickArea.BorderSizePixel = 2
joystickArea.Parent = screenGui

local joystickKnob = Instance.new("Frame")
joystickKnob.Size = UDim2.new(0, 40, 0, 40)
joystickKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
joystickKnob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
joystickKnob.BorderSizePixel = 0
joystickKnob.Parent = joystickArea

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 50, 0, 50)
upBtn.Position = UDim2.new(0, 160, 1, -190)
upBtn.Text = "▲"
upBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.TextScaled = true
upBtn.Parent = screenGui

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 50, 0, 50)
downBtn.Position = UDim2.new(0, 160, 1, -130)
downBtn.Text = "▼"
downBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.TextScaled = true
downBtn.Parent = screenGui

local verticalDir = 0

local function toggleGUI()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
    joystickArea.Visible = guiVisible
    upBtn.Visible = guiVisible
    downBtn.Visible = guiVisible
    if guiVisible then
        iconBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        iconLabel.Text = "✈"
    else
        iconBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        iconLabel.Text = "✈"
    end
end

iconBtn.MouseButton1Click:Connect(toggleGUI)

local function startFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    flying = true
    toggleBtn.Text = "STOP FLIGHT"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    flying = false
    toggleBtn.Text = "START FLIGHT"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    moveDirection = Vector3.new(0, 0, 0)
end

local function toggleFly()
    if flying then stopFly() else startFly() end
end

local function changeSpeed(delta)
    speed = math.clamp(speed + delta, 1, 500)
    speedLabel.Text = "Speed: " .. tostring(speed)
    speedInput.Text = tostring(speed)
end

local joystickActive = false
local joystickTouch = nil

local function updateJoystick(input)
    local pos = input.Position
    local areaPos = joystickArea.AbsolutePosition
    local areaSize = joystickArea.AbsoluteSize
    local center = areaPos + areaSize / 2
    local delta = pos - center
    local maxDist = areaSize.X / 2 - 20
    local dist = delta.Magnitude
    if dist > maxDist then
        delta = delta.Unit * maxDist
    end
    joystickKnob.Position = UDim2.new(0, delta.X + areaSize.X/2 - 20, 0, delta.Y + areaSize.Y/2 - 20)
    local norm = delta / maxDist
    local camera = workspace.CurrentCamera
    local forward = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
    local right = camera.CFrame.RightVector * Vector3.new(1, 0, 1)
    moveDirection = (forward * -norm.Y + right * norm.X)
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end
end

joystickArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickTouch = input
        updateJoystick(input)
    end
end)

joystickArea.InputChanged:Connect(function(input)
    if input == joystickTouch and joystickActive then
        updateJoystick(input)
    end
end)

joystickArea.InputEnded:Connect(function(input)
    if input == joystickTouch then
        joystickActive = false
        joystickTouch = nil
        joystickKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
        moveDirection = Vector3.new(0, 0, 0)
    end
end)

upBtn.MouseButton1Down:Connect(function() verticalDir = 1 end)
upBtn.MouseButton1Up:Connect(function() verticalDir = 0 end)
downBtn.MouseButton1Down:Connect(function() verticalDir = -1 end)
downBtn.MouseButton1Up:Connect(function() verticalDir = 0 end)

local function updateFlight()
    if not flying or not rootPart or not bodyVelocity then return end
    local finalDir = moveDirection + Vector3.new(0, verticalDir, 0)
    if finalDir.Magnitude > 0 then
        finalDir = finalDir.Unit * speed
    else
        finalDir = Vector3.new(0, 0, 0)
    end
    bodyVelocity.Velocity = finalDir
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
end

toggleBtn.MouseButton1Click:Connect(toggleFly)
decBtn.MouseButton1Click:Connect(function() changeSpeed(-speedStep) end)
incBtn.MouseButton1Click:Connect(function() changeSpeed(speedStep) end)

speedInput.FocusLost:Connect(function()
    local ns = tonumber(speedInput.Text)
    if ns and ns > 0 then
        speed = math.clamp(ns, 1, 500)
        speedLabel.Text = "Speed: " .. tostring(speed)
        speedInput.Text = tostring(speed)
    else
        speedInput.Text = tostring(speed)
    end
end)

RunService.Heartbeat:Connect(updateFlight)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if flying then
        stopFly()
        wait(0.1)
        startFly()
    end
end)