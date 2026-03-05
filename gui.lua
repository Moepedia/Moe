-- Moe V1.0 GUI for FISH IT - FIXED DROPDOWN VERSION

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== VARIABLES =====
local autoFishing = false
local fishingConnection = nil
local autoSell = false
local autoEquip = false
local sellConnection = nil
local castDelay = 2
local catchDelay = 1
local sellDelay = 60
local spamCount = 5
local currentRod = nil
local activeDropdown = nil  -- Untuk melacak dropdown yang sedang terbuka

-- ===== DATA LOKASI TELEPORT =====
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439, -0.977613986, -1.77645827e-08, 0.210406482, -2.42338203e-08, 1, -2.81680421e-08, -0.210406482, -3.26364251e-08, -0.977613986),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

local TeleportLocations = {}
for loc, _ in pairs(LOCATIONS) do
    table.insert(TeleportLocations, loc)
end
table.sort(TeleportLocations)

-- ===== REMOTE FUNCTIONS =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

local Remote = {
    ChargeFishingRod = Net and Net["RF/ChargeFishingRod"],
    CancelFishingInputs = Net and Net["RF/CancelFishingInputs"],
    FishCaught = Net and Net["RE/FishCaught"],
    UpdateAutoFishingState = Net and Net["RF/UpdateAutoFishingState"],
    MarkAutoFishingUsed = Net and Net["RF/MarkAutoFishingUsed"],
    SellAllItems = Net and Net["RF/SellAllItems"],
    SellItem = Net and Net["RF/SellItem"]
}

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== CLOSE ALL DROPDOWNS =====
local function closeAllDropdowns()
    if activeDropdown then
        activeDropdown.Visible = false
        activeDropdown = nil
    end
end

-- Setup klik di luar dropdown
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        task.wait(0.1)
        -- Cek apakah yang diklik bukan dropdown
        local mousePos = userInputService:GetMouseLocation()
        local objects = gui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
        
        local clickedOnDropdown = false
        for _, obj in ipairs(objects) do
            if obj:IsA("Frame") and obj.Name == "DropdownFrame" then
                clickedOnDropdown = true
                break
            end
        end
        
        if not clickedOnDropdown then
            closeAllDropdowns()
        end
    end
end)

-- ===== EQUIP ROD =====
local function findFishingRods()
    local rods = {"any"}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            table.insert(rods, tool.Name)
        end
    end
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                table.insert(rods, tool.Name)
            end
        end
    end
    return rods
end

local function equipRod(rodName)
    if rodName == "any" then
        notify("Equip", "Auto equip active", 1)
        return true
    end
    
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == rodName then
            tool.Parent = player.Character
            currentRod = rodName
            notify("Equip", "Equipped: " .. rodName, 1)
            return true
        end
    end
    
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == rodName then
            currentRod = rodName
            notify("Equip", "Already equipped: " .. rodName, 1)
            return true
        end
    end
    
    notify("Equip", "Rod not found!", 1)
    return false
end

-- ===== ANTI-CHEAT BYPASS =====
local function disableAntiCheat()
    if Remote.UpdateAutoFishingState then
        pcall(function() Remote.UpdateAutoFishingState:InvokeServer(false) end)
    end
    if Remote.MarkAutoFishingUsed then
        pcall(function() Remote.MarkAutoFishingUsed:InvokeServer(0) end)
    end
end

-- ===== FISHING FUNCTIONS =====
local function castRod()
    if not Remote.ChargeFishingRod then 
        notify("Error", "ChargeFishingRod not found", 1)
        return false 
    end
    return pcall(function() Remote.ChargeFishingRod:InvokeServer() end)
end

local function catchFish()
    if not Remote.FishCaught then 
        notify("Error", "FishCaught not found", 1)
        return false 
    end
    for i = 1, spamCount do
        pcall(function() Remote.FishCaught:FireServer() end)
        task.wait(0.05)
    end
    return true
end

local function cancelFishing()
    if Remote.CancelFishingInputs then
        pcall(function() Remote.CancelFishingInputs:InvokeServer() end)
    end
end

-- ===== AUTO FISHING LOOP =====
local function startAutoFishing()
    if autoFishing then return end
    autoFishing = true
    notify("Auto Fishing", "Started!", 2)
    
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFishing then return end
        
        disableAntiCheat()
        cancelFishing()
        task.wait(0.2)
        castRod()
        task.wait(castDelay)
        catchFish()
        task.wait(catchDelay)
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    cancelFishing()
    notify("Auto Fishing", "Stopped!", 2)
end

-- ===== AUTO SELL LOOP =====
local function sellAllItems()
    if Remote.SellAllItems then
        local success = pcall(function() Remote.SellAllItems:InvokeServer() end)
        notify("Sell", success and "Items sold!" or "Sell failed", 2)
    else
        notify("Error", "SellAllItems not found", 1)
    end
end

local function startAutoSell()
    if autoSell then return end
    autoSell = true
    
    sellConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoSell then return end
        task.wait(sellDelay)
        sellAllItems()
    end)
end

local function stopAutoSell()
    autoSell = false
    if sellConnection then
        sellConnection:Disconnect()
        sellConnection = nil
    end
end

-- ===== TELEPORT =====
local function teleportTo(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then
        notify("Teleport", "Location not found!", 2)
        return
    end
    
    local character = player.Character
    if not character then
        notify("Teleport", "No character!", 2)
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        notify("Teleport", "No root part!", 2)
        return
    end
    
    rootPart.CFrame = cframe
    notify("Teleport", "Teleported to " .. locationName, 1.5)
end

function teleportToPlayer(targetPlayer)
    local target = targetPlayer
    if type(targetPlayer) == "string" then
        target = game.Players:FindFirstChild(targetPlayer)
    end
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            notify("Teleport", "Teleported to " .. target.Name, 1.5)
            return true
        end
    end
    notify("Teleport", "Failed!", 1)
    return false
end

-- ===== GUI SETUP =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 500)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
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

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    stopAutoFishing()
    stopAutoSell()
    gui:Destroy()
end)

-- Floating logo
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
floatingLogo.BackgroundTransparency = 0.2
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000

local floatFrameCorner = Instance.new("UICorner")
floatFrameCorner.CornerRadius = UDim.new(0, 25)
floatFrameCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.5
floatStroke.Parent = floatingLogo

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

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- Content container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Left menu
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 130, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- Right content area
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

-- Content title
local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 25)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Fishing Features"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 14
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

-- Features container
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

-- ===== UI FUNCTIONS =====
local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        local success, err = pcall(callback)
        if not success then
            notify("Error", tostring(err), 2)
        end
    end)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end)
    
    return btn
end

local function createToggle(parent, text, getState, setState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleBtn.Text = getState() and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn
    
    local function updateButton()
        toggleBtn.Text = getState() and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = getState() and Color3.new(0, 0.6, 0) or Color3.new(0.3, 0.3, 0.3)
    end
    
    updateButton()
    
    toggleBtn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        setState(not getState())
        updateButton()
    end)
    
    return frame
end

local function createInput(parent, labelText, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 0, 25)
    input.Position = UDim2.new(0.5, 0, 0.5, -12.5)
    input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input.Text = tostring(defaultValue)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        closeAllDropdowns()
        local val = tonumber(input.Text) or defaultValue
        callback(val)
    end)
    
    return frame
end

-- ===== DROPDOWN FUNCTION (FIXED) =====
local function createDropdown(parent, labelText, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 11
    
    local selectedText = Instance.new("TextLabel")
    selectedText.Size = UDim2.new(0, 200, 1, 0)
    selectedText.Position = UDim2.new(0, 90, 0, 0)
    selectedText.BackgroundTransparency = 1
    selectedText.Text = default
    selectedText.TextColor3 = Color3.new(0, 1, 0)
    selectedText.TextSize = 13
    selectedText.Font = Enum.Font.GothamBold
    selectedText.TextXAlignment = Enum.TextXAlignment.Left
    selectedText.Parent = frame
    selectedText.ZIndex = 11
    selectedText.ClipsDescendants = true
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = frame
    arrow.ZIndex = 11
    
    -- Dropdown options (hidden by default)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    dropdownFrame.BackgroundTransparency = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 20
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.4, 0.4, 0.4)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local optionsList = Instance.new("ScrollingFrame")
    optionsList.Size = UDim2.new(1, 0, 1, 0)
    optionsList.BackgroundTransparency = 1
    optionsList.BorderSizePixel = 0
    optionsList.ScrollBarThickness = 4
    optionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsList.Parent = dropdownFrame
    optionsList.ZIndex = 21
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = optionsList
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.ZIndex = 22
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    -- Create option buttons
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -10, 0, 28)
        optBtn.Position = UDim2.new(0, 5, 0, (i-1) * 30)
        optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        optBtn.BackgroundTransparency = 0
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = optionsContainer
        optBtn.ZIndex = 23
        optBtn.BorderSizePixel = 0
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 4)
        optCorner.Parent = optBtn
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            selectedText.Text = opt
            dropdownFrame.Visible = false
            frame.Size = UDim2.new(1, 0, 0, 35)
            activeDropdown = nil
            callback(opt)
        end)
    end
    
    -- Hitung tinggi dropdown
    local optionHeight = #options * 30 + 10
    dropdownFrame.Size = UDim2.new(1, 0, 0, math.min(optionHeight, 150))
    
    -- Toggle dropdown on click
    local function toggleDropdown()
        if activeDropdown and activeDropdown ~= dropdownFrame then
            activeDropdown.Visible = false
            activeDropdown.Parent.Size = UDim2.new(1, 0, 0, 35)
        end
        
        dropdownFrame.Visible = not dropdownFrame.Visible
        if dropdownFrame.Visible then
            frame.Size = UDim2.new(1, 0, 0, 35 + math.min(optionHeight, 150))
            activeDropdown = dropdownFrame
        else
            frame.Size = UDim2.new(1, 0, 0, 35)
            activeDropdown = nil
        end
    end
    
    -- Klik pada frame utama untuk toggle
    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(1, 0, 1, 0)
    mainButton.BackgroundTransparency = 1
    mainButton.Text = ""
    mainButton.Parent = frame
    mainButton.ZIndex = 15
    
    mainButton.MouseButton1Click:Connect(function()
        closeAllDropdowns() -- Tutup dropdown lain
        toggleDropdown()
    end)
    
    return frame
end

local function clearFeatures()
    closeAllDropdowns()
    for _, child in pairs(featuresContainer:GetChildren()) do
        child:Destroy()
    end
end

-- ===== PAGE FUNCTIONS =====
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "⚡ AUTO FISHING")
    
    createToggle(featuresContainer, "Auto Fish", 
        function() return autoFishing end,
        function(state) 
            if state then startAutoFishing() else stopAutoFishing() end
        end)
    
    createToggle(featuresContainer, "Auto Equip Rod", 
        function() return autoEquip end,
        function(state) 
            autoEquip = state
            if state then equipRod("any") end
        end)
    
    createLabel(featuresContainer, "⏱️ DELAY SETTINGS")
    
    createInput(featuresContainer, "Fish Delay (s)", castDelay, function(val)
        castDelay = val
        notify("Delay", "Fish delay: " .. val .. "s", 1)
    end)
    
    createInput(featuresContainer, "Catch Delay (s)", catchDelay, function(val)
        catchDelay = val
        notify("Delay", "Catch delay: " .. val .. "s", 1)
    end)
    
    createInput(featuresContainer, "Spam Count", spamCount, function(val)
        spamCount = val
        notify("Spam", "Spam count: " .. val, 1)
    end)
    
    createLabel(featuresContainer, "🎮 MANUAL CONTROLS")
    
    createButton(featuresContainer, "CAST ROD", function()
        disableAntiCheat()
        castRod()
        notify("Cast", "Rod casted", 1)
    end)
    
    createButton(featuresContainer, "CATCH FISH", function()
        catchFish()
    end)
    
    createButton(featuresContainer, "CANCEL FISHING", function()
        cancelFishing()
        notify("Cancel", "Fishing cancelled", 1)
    end)
    
    -- Rod Dropdown
    local rods = findFishingRods()
    if #rods > 1 then
        createDropdown(featuresContainer, "Select Rod", rods, rods[1], function(selected)
            equipRod(selected)
        end)
    else
        createLabel(featuresContainer, "No rods found!")
    end
end

local function showSell()
    clearFeatures()
    contentTitle.Text = "Sell Features"
    
    createLabel(featuresContainer, "💰 AUTO SELL")
    
    createToggle(featuresContainer, "Auto Sell", 
        function() return autoSell end,
        function(state)
            if state then startAutoSell() else stopAutoSell() end
        end)
    
    createInput(featuresContainer, "Sell Delay (s)", sellDelay, function(val)
        sellDelay = val
    end)
    
    createLabel(featuresContainer, "⚡ MANUAL SELL")
    
    createButton(featuresContainer, "SELL ALL ITEMS", function()
        sellAllItems()
    end)
    
    -- Status
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 40)
    statusFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 5, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌")
    statusText.TextColor3 = Color3.new(1, 1, 1)
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusFrame
end

local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport Features"
    
    createLabel(featuresContainer, "🌍 TELEPORT TO LOCATION")
    
    -- Location Dropdown
    createDropdown(featuresContainer, "Location", TeleportLocations, TeleportLocations[1], function(selected)
        teleportTo(selected)
    end)
    
    createLabel(featuresContainer, "👤 TELEPORT TO PLAYER")
    
    -- Player List
    local function getPlayerList()
        local players = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p.Name)
            end
        end
        return players
    end
    
    local playerList = getPlayerList()
    if #playerList > 0 then
        createDropdown(featuresContainer, "Player", playerList, playerList[1], function(selected)
            teleportToPlayer(selected)
        end)
    else
        createLabel(featuresContainer, "No other players online")
    end
    
    createButton(featuresContainer, "REFRESH PLAYER LIST", function()
        local newList = getPlayerList()
        if #newList > 0 then
            notify("Players", #newList .. " players online", 1)
        else
            notify("Players", "No other players", 1)
        end
        showTeleport() -- Refresh page
    end)
end

local function showStatus()
    clearFeatures()
    contentTitle.Text = "Status Features"
    
    local statusText = "📊 REMOTE STATUS:\n\n"
    statusText = statusText .. "🎣 FISHING:\n"
    statusText = statusText .. "  ChargeFishingRod: " .. (Remote.ChargeFishingRod and "✅" or "❌") .. "\n"
    statusText = statusText .. "  FishCaught: " .. (Remote.FishCaught and "✅" or "❌") .. "\n"
    statusText = statusText .. "  CancelFishing: " .. (Remote.CancelFishingInputs and "✅" or "❌") .. "\n\n"
    
    statusText = statusText .. "🛡️ ANTI-CHEAT:\n"
    statusText = statusText .. "  UpdateAutoFishing: " .. (Remote.UpdateAutoFishingState and "✅" or "❌") .. "\n"
    statusText = statusText .. "  MarkAutoFishing: " .. (Remote.MarkAutoFishingUsed and "✅" or "❌") .. "\n\n"
    
    statusText = statusText .. "💰 SELL:\n"
    statusText = statusText .. "  SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n"
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 200)
    statusFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 1, -10)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = statusText
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextWrapped = true
    statusLabel.Parent = statusFrame
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", color = Color3.new(0.3, 0.5, 0.8)},
    {name = "Sell", color = Color3.new(0.8, 0.5, 0.3)},
    {name = "Teleport", color = Color3.new(0.3, 0.8, 0.3)},
    {name = "Status", color = Color3.new(0.5, 0.5, 0.5)}
}

for i, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = btnData.color
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
        closeAllDropdowns()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        
        if btnData.name == "Fishing" then showFishing()
        elseif btnData.name == "Sell" then showSell()
        elseif btnData.name == "Teleport" then showTeleport()
        elseif btnData.name == "Status" then showStatus()
        end
    end)
end

-- Show fishing menu by default
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

-- Cleanup
gui.Destroying:Connect(function()
    stopAutoFishing()
    stopAutoSell()
    closeAllDropdowns()
end)

print("✅ Moe V1.0 - Dengan Dropdown yang Berfungsi!")
notify("Moe V1.0", "Dropdown fixed & working!", 3)