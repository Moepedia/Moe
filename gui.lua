-- Moe V1.0 GUI with VEL.lua Features (Optimized Version)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== SERVICES =====
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- ===== NOTIFY =====
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
    
    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 8)
    dialogCorner.Parent = dialogFrame
    
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

-- ===== GET REMOTE FUNCTION =====
local function GetRemote(name)
    local success, result = pcall(function()
        local Packages = ReplicatedStorage:FindFirstChild("Packages")
        if not Packages then return nil end
        local Index = Packages:FindFirstChild("_Index")
        if not Index then return nil end
        local NetFolder = Index:FindFirstChild("sleitnick_net@0.2.0")
        if not NetFolder then return nil end
        local Net = NetFolder:FindFirstChild("net")
        if not Net then return nil end
        return Net:FindFirstChild(name)
    end)
    return success and result or nil
end

-- ===== REMOTES =====
local Remote = {
    ChargeFishingRod = GetRemote("RF/e4017e43355f4661b1e07f77fe2bfe13b5a48f4eff9ba55b0398ec0ef3c66765"),
    RequestFishingMinigame = GetRemote("RF/4d6dc93c9ecb915a8ae6425c83c8bb597b015e0bc4f874181ea308dcc7ae5015"),
    CatchFishCompleted = GetRemote("RF/76a108e0c7fed0fe6174984ba5c748621c6d347466644a819a806ed594a344b4"),
    SellAllItems = GetRemote("RF/4417ef209575b73e441890816440faf3f5fa6a503ff1805d70afa5cf2b6d1453"),
}

-- ===== HELPER FUNCTIONS =====
local function GetHRP()
    local Character = player.Character
    if not Character then
        Character = player.CharacterAdded:Wait()
    end
    return Character:FindFirstChild("HumanoidRootPart")
end

-- ===== FISHING LOCATIONS =====
local FishingAreas = {
    ["Ancient Jungle"] = CFrame.new(1896.9, 8.4, -578.7),
    ["Coral Reefs"] = CFrame.new(-2935.1,4.8,2050.9),
    ["Crater Island"] = CFrame.new(1077.6, 2.8, 5080.9),
    ["Esoteric Deep"] = CFrame.new(3202.2, -1302.9, 1432.7),
    ["Kohana"] = CFrame.new(-367.8, 6.8, 521.9),
    ["Sacred Temple"] = CFrame.new(1466.6, -22.8, -618.8),
    ["Sisyphus Statue"] = CFrame.new(-3715.1, -136.8, -1010.6),
    ["Treasure Room"] = CFrame.new(-3604.2, -283.2, -1613.7),
    ["Tropical Grove"] = CFrame.new(-2173.3,53.5,3632.3),
    ["Underground Cellar"] = CFrame.new(2136.0, -91.2, -699.0)
}

local AreaNames = {}
for name, _ in pairs(FishingAreas) do
    table.insert(AreaNames, name)
end
table.sort(AreaNames)

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local autoSell = false
local autoEquip = false
local fishingConnection = nil
local sellConnection = nil

local Config = {
    FishDelay = 2.0,
    CatchDelay = 1.0,
    SellDelay = 60,
}

-- ===== AUTO FISHING FUNCTIONS =====
local function instantFish()
    if not Remote.ChargeFishingRod or not Remote.RequestFishingMinigame or not Remote.CatchFishCompleted then 
        return false 
    end
    
    local success = pcall(function()
        Remote.ChargeFishingRod:InvokeServer(1, 0.5)
        task.wait(0.1)
        Remote.RequestFishingMinigame:InvokeServer()
        task.wait(Config.CatchDelay)
        Remote.CatchFishCompleted:InvokeServer()
    end)
    return success
end

local function startAutoFishing()
    if autoFishing then return end
    autoFishing = true
    
    fishingConnection = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        instantFish()
        task.wait(Config.FishDelay)
    end)
    
    notify("Auto Fish", "Started!", 2)
end

local function stopAutoFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    notify("Auto Fish", "Stopped!", 2)
end

-- ===== AUTO SELL =====
local function sellAllItems()
    if Remote.SellAllItems then
        pcall(function() Remote.SellAllItems:InvokeServer() end)
        notify("Sell", "Items sold!", 1)
    end
end

local function startAutoSell()
    if autoSell then return end
    autoSell = true
    
    sellConnection = RunService.Heartbeat:Connect(function()
        if not autoSell then return end
        task.wait(Config.SellDelay)
        sellAllItems()
    end)
    
    notify("Auto Sell", "Started!", 2)
end

local function stopAutoSell()
    autoSell = false
    if sellConnection then
        sellConnection:Disconnect()
        sellConnection = nil
    end
    notify("Auto Sell", "Stopped!", 2)
end

-- ===== TELEPORT =====
local function teleportTo(locationName)
    local cframe = FishingAreas[locationName]
    if not cframe then return end
    
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = cframe
        notify("Teleport", "Teleported to " .. locationName, 1.5)
    end
end

-- ===== EXIT FUNCTION =====
local guiClosed = false
local activeDropdown = nil

local function exitGUI()
    if guiClosed then return end
    
    showConfirmDialog("Exit GUI", "Are you sure you want to close?", function(confirmed)
        if confirmed then
            guiClosed = true
            stopAutoFishing()
            stopAutoSell()
            if activeDropdown then
                activeDropdown.Visible = false
                activeDropdown = nil
            end
            task.wait(0.1)
            pcall(function() gui:Destroy() end)
        end
    end)
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 150, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0 - Full Features"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

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

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(exitGUI)

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

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 30)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Main Features"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 16
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
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
featuresLayout.Padding = UDim.new(0, 10)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENT CREATORS =====
local function createSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundTransparency = 1
    section.Parent = featuresContainer
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BackgroundTransparency = 0.7
    line.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(0.4, 0.8, 1)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
end

local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 50, 0, 25)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12.5)
    switchBg.BackgroundColor3 = default and Color3.new(0, 0.6, 0) or Color3.new(0.4, 0.4, 0.4)
    switchBg.Parent = frame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 15)
    switchCorner.Parent = switchBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 21, 0, 21)
    knob.Position = default and UDim2.new(1, -25, 0.5, -10.5) or UDim2.new(0, 4, 0.5, -10.5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = switchBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = switchBg
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        switchBg.BackgroundColor3 = state and Color3.new(0, 0.6, 0) or Color3.new(0.4, 0.4, 0.4)
        knob.Position = state and UDim2.new(1, -25, 0.5, -10.5) or UDim2.new(0, 4, 0.5, -10.5)
        callback(state)
    end)
end

local function createInput(label, default, callback, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = featuresContainer
    
    local labelObj = Instance.new("TextLabel")
    labelObj.Size = UDim2.new(0.4, 0, 0, 20)
    labelObj.Position = UDim2.new(0, 0, 0, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    labelObj.TextSize = 13
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 0, 30)
    input.Position = UDim2.new(0.5, 0, 0, 0)
    input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.PlaceholderText = placeholder or ""
    input.Font = Enum.Font.Gotham
    input.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text) or default
        input.Text = tostring(val)
        callback(val)
    end)
end

local function createDropdown(text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = featuresContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, 0, 0, 30)
    btn.Position = UDim2.new(0.5, 0, 0, 0)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = btn
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = gui
    dropdownFrame.ZIndex = 100
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local optionsScrolling = Instance.new("ScrollingFrame")
    optionsScrolling.Size = UDim2.new(1, 0, 1, 0)
    optionsScrolling.BackgroundTransparency = 1
    optionsScrolling.ScrollBarThickness = 4
    optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsScrolling.Parent = dropdownFrame
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = optionsScrolling
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = optionsContainer
        optBtn.BorderSizePixel = 0
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 4)
        optCorner.Parent = optBtn
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdownFrame.Visible = false
            activeDropdown = nil
            callback(opt)
        end)
    end
    
    local function updateDropdownPosition()
        if not frame or not frame:IsDescendantOf(gui) then return end
        local absPos = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        dropdownFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y)
        dropdownFrame.Size = UDim2.new(0, absSize.X, 0, math.min(#options * 32, 150))
    end
    
    btn.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown ~= dropdownFrame then
            activeDropdown.Visible = false
        end
        updateDropdownPosition()
        dropdownFrame.Visible = not dropdownFrame.Visible
        activeDropdown = dropdownFrame.Visible and dropdownFrame or nil
    end)
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====
local function showMain()
    clearFeatures()
    contentTitle.Text = "Main Features"
    
    createSection("Auto Fishing")
    createToggle("Enable Auto Fish", autoFishing, function(state)
        if state then startAutoFishing() else stopAutoFishing() end
    end)
    
    createInput("Fish Delay", Config.FishDelay, function(val) Config.FishDelay = val end, "2.0")
    createInput("Catch Delay", Config.CatchDelay, function(val) Config.CatchDelay = val end, "1.0")
    
    createSection("Auto Sell")
    createToggle("Enable Auto Sell", autoSell, function(state)
        if state then startAutoSell() else stopAutoSell() end
    end)
    
    createInput("Sell Delay (s)", Config.SellDelay, function(val) Config.SellDelay = val end, "60")
    createButton("Sell All Now", sellAllItems)
end

local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport Features"
    
    createSection("Teleport to Area")
    
    local selectedArea = AreaNames[1]
    createDropdown("Select Area", AreaNames, selectedArea, function(selected)
        selectedArea = selected
    end)
    
    createButton("Teleport Now", function()
        teleportTo(selectedArea)
    end)
end

local function showMisc()
    clearFeatures()
    contentTitle.Text = "Misc Features"
    
    createSection("Player Info")
    
    -- Remote status
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 80)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, -10)
    statusText.Position = UDim2.new(0, 5, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = string.format(
        "Charge Remote: %s\nRequest Remote: %s\nCatch Remote: %s\nSell Remote: %s",
        Remote.ChargeFishingRod and "✅" or "❌",
        Remote.RequestFishingMinigame and "✅" or "❌",
        Remote.CatchFishCompleted and "✅" or "❌",
        Remote.SellAllItems and "✅" or "❌"
    )
    statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextWrapped = true
    statusText.Parent = statusFrame
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Main", func = showMain},
    {name = "Teleport", func = showTeleport},
    {name = "Misc", func = showMisc},
}

local currentMenu = "Main"

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
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

-- Show Main menu by default
task.wait(0.1)
showMain()

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

notify("Moe V1.0", "Optimized version loaded!", 3)
