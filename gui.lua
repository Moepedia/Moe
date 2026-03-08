-- Moe V1.0 GUI (Simple Version)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ===== VARIABLES =====
local RF_Charge = nil
local RF_StartGame = nil
local RF_Complete = nil
local RE_EquipToolFromHotbar = nil
local RF_SellAllItems = nil
local RE_FavoriteItem = nil

-- State variables
local autoFishing = false
local autoSell = false
local autoSellDelay = 60
local flyEnabled = false
local speedEnabled = false
local flySpeed = 50
local walkspeed = 16
local jumppower = 50
local flyConnection = nil
local speedConnection = nil
local bodyGyro, bodyVel = nil, nil

-- Get remotes
local function GetRemote(name)
    local netFolder = ReplicatedStorage:FindFirstChild("Packages")
    if netFolder then
        local index = netFolder:FindFirstChild("_Index")
        if index then
            for _, folder in ipairs(index:GetChildren()) do
                if folder.Name:find("sleitnick_net") then
                    local net = folder:FindFirstChild("net")
                    if net then
                        return net:FindFirstChild(name)
                    end
                end
            end
        end
    end
    return nil
end

-- Initialize remotes
RF_Charge = GetRemote("RF/ChargeFishingRod")
RF_StartGame = GetRemote("RF/RequestFishingMinigameStarted")
RF_Complete = GetRemote("RF/CatchFishCompleted")
RE_EquipToolFromHotbar = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("EquipToolFromHotbar")
RF_SellAllItems = GetRemote("RF/SellAllItems")
RE_FavoriteItem = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("FavoriteItem")

-- ===== NOTIFY FUNCTION =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== KONFIRMASI DIALOG =====
local function showConfirmDialog(title, message, callback)
    local dialogFrame = Instance.new("Frame")
    dialogFrame.Size = UDim2.new(0, 300, 0, 150)
    dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    dialogFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    dialogFrame.BackgroundTransparency = 0.1
    dialogFrame.BorderSizePixel = 0
    dialogFrame.Parent = gui
    dialogFrame.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dialogFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = dialogFrame
    titleLabel.ZIndex = 1001
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.Parent = dialogFrame
    msgLabel.ZIndex = 1001
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -5, 0, 35)
    yesBtn.Position = UDim2.new(0.1, 0, 0, 95)
    yesBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = dialogFrame
    yesBtn.ZIndex = 1001
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -5, 0, 35)
    noBtn.Position = UDim2.new(0.5, 5, 0, 95)
    noBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = dialogFrame
    noBtn.ZIndex = 1001
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(true)
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(false)
    end)
end

-- ===== EXIT FUNCTION =====
local guiClosed = false

local function exitGUI()
    if guiClosed then return end
    
    showConfirmDialog("Exit GUI", "Are you sure you want to close?", function(confirmed)
        if confirmed then
            guiClosed = true
            task.wait(0.1)
            pcall(function() gui:Destroy() end)
        end
    end)
end

-- ===== HELPER FUNCTIONS =====
local function GetHRP()
    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    return Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    return Character:FindFirstChildOfClass("Humanoid")
end

-- ===== FISHING FUNCTIONS =====
local function CastRod()
    pcall(function() RE_EquipToolFromHotbar:FireServer(1) end)
    task.wait(0.1)
    
    if RF_Charge then
        pcall(function() RF_Charge:InvokeServer(1) end)
    end
    
    task.wait(2)
    
    if RF_StartGame then
        pcall(function() RF_StartGame:InvokeServer() end)
    end
    
    task.wait(1)
    
    if RF_Complete then
        pcall(function() RF_Complete:InvokeServer() end)
    end
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 1, 0)
title.Position = UDim2.new(0, 38, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

-- Minimize button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -60, 0.5, -12.5)
minButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = headerFrame
minButton.ZIndex = 5

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minButton

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame
closeBtn.ZIndex = 5

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(exitGUI)

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
floatingLogo.BackgroundTransparency = 0.2
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000
floatingLogo.Active = true
floatingLogo.Selectable = true

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 25)
floatCorner.Parent = floatingLogo

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, -10, 1, -10)
floatLogoImg.Position = UDim2.new(0, 5, 0, 5)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo
floatButton.ZIndex = 1001

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 130, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- ===== RIGHT CONTENT AREA =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer
contentArea.ClipsDescendants = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 25)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Moe Fish Hub"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 14
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== UI HELPER FUNCTIONS =====
local function createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = featuresContainer
end

local function createToggle(title, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleBtn
    
    local state = defaultValue
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        pcall(callback, state)
    end)
    
    return {
        Set = function(val)
            state = val
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        end
    }
end

local function createSlider(title, min, max, default, step, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 150, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(0, 1, 0)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sliderBg.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.Parent = sliderBg
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local dragging = false
    local currentValue = default
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize.X
            
            local percent = math.clamp((mousePos.X - absPos.X) / absSize, 0, 1)
            currentValue = min + (max - min) * percent
            currentValue = math.floor(currentValue / step + 0.5) * step
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderButton.Position = UDim2.new(percent, -6, 0.5, -6)
            valueLabel.Text = tostring(currentValue)
            
            pcall(callback, currentValue)
        end
    end)
    
    return {
        Set = function(val)
            currentValue = math.clamp(val, min, max)
            local percent = (currentValue - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderButton.Position = UDim2.new(percent, -6, 0.5, -6)
            valueLabel.Text = tostring(currentValue)
        end
    }
end

local function createInput(title, placeholder, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 25)
    inputBox.Position = UDim2.new(0, 10, 0, 25)
    inputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    inputBox.Text = default or ""
    inputBox.PlaceholderText = placeholder or ""
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    inputBox.TextSize = 13
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    inputBox.FocusLost:Connect(function()
        pcall(callback, inputBox.Text)
    end)
    
    return {
        Set = function(text) inputBox.Text = text end
    }
end

local function createButton(title, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    btn.Text = title
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        child:Destroy()
    end
end

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing"
    
    createLabel("Auto Fishing")
    
    local fishingThread = nil
    local fishingToggle = createToggle("Auto Fish", false, function(state)
        autoFishing = state
        if state then
            fishingThread = task.spawn(function()
                while autoFishing do
                    CastRod()
                    task.wait(5)
                end
            end)
            notify("Auto Fish", "Started", 2)
        else
            if fishingThread then task.cancel(fishingThread) end
            notify("Auto Fish", "Stopped", 2)
        end
    end)
    
    createButton("Cast Once", function()
        CastRod()
        notify("Casting", "Fishing rod casted", 1)
    end)
end

-- Auto Sell Menu
local function showAutoSell()
    clearFeatures()
    contentTitle.Text = "Auto Sell"
    
    createLabel("Auto Sell Settings")
    
    local delayInput = createInput("Sell Delay (seconds)", "60", "60", function(text)
        local num = tonumber(text)
        if num and num > 0 then
            autoSellDelay = num
        end
    end)
    
    local sellThread = nil
    local sellToggle = createToggle("Enable Auto Sell", false, function(state)
        autoSell = state
        if state then
            sellThread = task.spawn(function()
                while autoSell do
                    if RF_SellAllItems then
                        pcall(function() RF_SellAllItems:InvokeServer() end)
                        notify("Auto Sell", "Sold all items", 1)
                    end
                    task.wait(autoSellDelay)
                end
            end)
            notify("Auto Sell", "Started", 2)
        else
            if sellThread then task.cancel(sellThread) end
            notify("Auto Sell", "Stopped", 2)
        end
    end)
    
    createButton("Sell Now", function()
        if RF_SellAllItems then
            pcall(function() RF_SellAllItems:InvokeServer() end)
            notify("Sell", "Items sold", 1)
        end
    end)
end

-- Movement Menu
local function showMovement()
    clearFeatures()
    contentTitle.Text = "Movement"
    
    createLabel("Walkspeed")
    
    local speedSlider = createSlider("Speed", 16, 200, 16, 1, function(val)
        walkspeed = val
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = walkspeed
        end
    end)
    
    createLabel("Jump Power")
    
    local jumpSlider = createSlider("Jump", 50, 200, 50, 1, function(val)
        jumppower = val
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = jumppower
        end
    end)
    
    createButton("Reset", function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            speedSlider:Set(16)
            jumpSlider:Set(50)
        end
    end)
    
    createLabel("Fly Mode")
    
    local speedInput = createInput("Fly Speed", "50", "50", function(text)
        local num = tonumber(text)
        if num then flySpeed = num end
    end)
    
    local flyToggle = createToggle("Enable Fly", false, function(state)
        flyEnabled = state
        local character = LocalPlayer.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if state then
            if hrp and humanoid then
                humanoid.PlatformStand = true
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = hrp.CFrame
                bodyGyro.Parent = hrp
                
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.Velocity = Vector3.zero
                bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVel.Parent = hrp
                
                local camera = workspace.CurrentCamera
                
                flyConnection = RunService.RenderStepped:Connect(function()
                    if not flyEnabled or not hrp then return end
                    
                    bodyGyro.CFrame = camera.CFrame
                    
                    local moveDir = humanoid.MoveDirection
                    if moveDir.Magnitude > 0 then
                        bodyVel.Velocity = moveDir * flySpeed
                    else
                        bodyVel.Velocity = Vector3.zero
                    end
                end)
            end
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVel then bodyVel:Destroy() end
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel("Quick Teleports")
    
    local locations = {
        {"Spawn", Vector3.new(0, 10, 0)},
        {"Market", Vector3.new(100, 10, 50)},
        {"Island", Vector3.new(500, 20, 300)},
    }
    
    for _, loc in ipairs(locations) do
        createButton("Teleport to " .. loc[1], function()
            local hrp = GetHRP()
            if hrp then
                hrp.CFrame = CFrame.new(loc[2])
                notify("Teleport", "Moved to " .. loc[1], 1)
            end
        end)
    end
    
    createLabel("Player Teleport")
    
    local players = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    
    if #players > 0 then
        for i = 1, math.min(3, #players) do
            local playerName = players[i]
            createButton("TP to " .. playerName, function()
                local target = Players:FindFirstChild(playerName)
                local targetHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local hrp = GetHRP()
                
                if hrp and targetHRP then
                    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Moved to " .. playerName, 1)
                end
            end)
        end
    end
end

-- Misc Menu
local function showMisc()
    clearFeatures()
    contentTitle.Text = "Misc"
    
    createLabel("Character")
    
    createButton("Reset Character", function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.Health = 0
            notify("Reset", "Character respawning", 1)
        end
    end)
    
    createButton("Rejoin Game", function()
        notify("Rejoining", "Please wait...", 2)
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    
    createLabel("Anti AFK")
    
    local afkToggle = createToggle("Anti AFK", true, function(state)
        if state then
            local connection
            connection = LocalPlayer.Idled:Connect(function()
                LocalPlayer:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait(1)
            end)
            _G.afkConnection = connection
        else
            if _G.afkConnection then
                _G.afkConnection:Disconnect()
                _G.afkConnection = nil
            end
        end
    end)
    
    createLabel("Infinite Jump")
    
    local infJumpToggle = createToggle("Infinite Jump", false, function(state)
        if state then
            _G.infJump = UserInputService.JumpRequest:Connect(function()
                local humanoid = GetHumanoid()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if _G.infJump then
                _G.infJump:Disconnect()
                _G.infJump = nil
            end
        end
    end)
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Auto Sell", func = showAutoSell},
    {name = "Movement", func = showMovement},
    {name = "Teleport", func = showTeleport},
    {name = "Misc", func = showMisc},
}

local currentMenu = ""

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.1
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        currentMenu = btnData.name
        btnData.func()
    end)
end

-- Show Fishing menu by default
task.wait(0.1)
showFishing()

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

notify("Moe V1.0", "Simple Fish Hub loaded!", 3)
