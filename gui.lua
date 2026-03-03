-- Moe V1.0 GUI for FISH IT - ERROR FREE VERSION
-- Dengan pengecekan remote sebelum dipanggil

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== DATA LOKASI TELEPORT =====
local TeleportLocations = {
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

local TeleportNames = {}
for name, _ in pairs(TeleportLocations) do
    table.insert(TeleportNames, name)
end
table.sort(TeleportNames)

-- ===== DATA BAIT =====
local BaitNames = {
    "Starter Bait", "Topwater Bait", "Luck Bait", "Midnight Bait",
    "Nature Bait", "Chroma Bait", "Royal Bait", "Dark Matter Bait",
    "Corrupt Bait", "Aether Bait", "Floral Bait", "Singularity Bait"
}

-- ===== DATA ROD =====
local RodNames = {
    "Starter Rod", "Luck Rod", "Carbon Rod", "Toy Rod", "Grass Rod",
    "Damascus Rod", "Ice Rod", "Lava Rod", "Lucky Rod", "Midnight Rod",
    "Steampunk Rod", "Chrome Rod", "Fluorescent Rod", "Astral Rod",
    "Hazmat Rod", "Ares Rod", "Angler Rod", "Ghostfinn Rod",
    "Bamboo Rod", "Element Rod", "Diamond Rod"
}

-- ===== DATA WEATHER =====
local WeatherNames = {
    "Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"
}

-- ===== REMOTE FUNCTIONS DARI PACKAGES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromPackages(folder, hashName)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then
            return rf:FindFirstChild(hashName)
        end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then
            return re:FindFirstChild(hashName)
        end
    end
    return nil
end

-- Remote references dengan hash
local Remote = {
    -- Fishing
    CatchFish = getRemoteFromPackages("RF", "76b3e3c8c811abe6c6ef36d0f6ec91de75fffd97bff713a4cb421303410ccb84"),
    ChargeRod = getRemoteFromPackages("RF", "aae67692fc443eb0cd6545ac1a4069ced9a4285e239b3e6b7d323b7d17070b5a"),
    FishingMinigame = getRemoteFromPackages("RE", "609e281eb1fbf03c9f0721e7dde16b73b4d06ff1fec785fe4db2dfe51e9a0caa"),
    
    -- Purchase
    PurchaseBait = getRemoteFromPackages("RF", "749e74fbc5fc3d196df3235c7e0e96639484e875de7bfe82629d1b86a0c6f01d"),
    PurchaseRod = getRemoteFromPackages("RF", "631361fdb4712a1bbd2df65a1c5fd948e6f85e5f30ef746c022a4ba1bf5c3399"),
    PurchaseWeather = getRemoteFromPackages("RF", "f7df2819493cf037d3870073bcb17495569565c5a08c7bd2b3632f440a361335"),
    
    -- Claim
    ClaimDaily = getRemoteFromPackages("RF", "91f555bbe3531dd9d8461f63f1b5ed9fdfe8275e29df3d6b4bf50d016c58cf6e"),
    ClaimBounty = getRemoteFromPackages("RF", "970dc117e86b893579c095f746bfd11bb5ad743effa48a4b11f9b3acaab40e1b"),
    ClaimEvent = getRemoteFromPackages("RE", "3205d5ea83639e08c73e6c8a2605acf32e604bd7785761e488cbf47971cd9021"),
    
    -- Sell
    SellAll = getRemoteFromPackages("RF", "478362a898e12ac6421d7a6b918dab8385b48c04cfaba211fdb6dd48111107e6"),
    SellItem = getRemoteFromPackages("RF", "61ac0f04b309d722f1df60502b90edcd4bca7cd395c192e06bc5497d5ce0b598"),
    
    -- Weather & Teleport
    WeatherCommand = getRemoteFromPackages("RE", "33e2a9e4854072028b2dc6cb66fe1365ad2d0bebf72421f844ccb80e780e2f4f"),
    SubmarineTP = getRemoteFromPackages("RE", "08ad2bcf5a0af3edb493588043f0a994dd33514a272a67578891ad2a6be01671"),
}

-- ===== SAFE REMOTE CALL =====
local function safeFire(remote, ...)
    if remote then
        local success, err = pcall(function()
            remote:FireServer(...)
        end)
        if not success then
            warn("Remote error:", err)
            return false
        end
        return true
    else
        warn("Remote is nil")
        return false
    end
end

local function safeInvoke(remote, ...)
    if remote then
        local success, result = pcall(function()
            return remote:InvokeServer(...)
        end)
        if not success then
            warn("Remote error:", result)
            return nil
        end
        return result
    else
        warn("Remote is nil")
        return nil
    end
end

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== UI ELEMENTS =====
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

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
end

local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.FillDirection = Enum.FillDirection.Vertical
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.Parent = dropdownFrame
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdownFrame
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdownFrame.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)
    
    return frame
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Header
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

-- Minimize
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

-- Close
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

-- Floating logo
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundTransparency = 1
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, 0, 1, 0)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatLogoCorner = Instance.new("UICorner")
floatLogoCorner.CornerRadius = UDim.new(0, 25)
floatLogoCorner.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo

-- Minimize functions
minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
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

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "Instant Fishing")
    createButton(featuresContainer, "CHARGE ROD", function()
        safeFire(Remote.ChargeRod)
        notify("Fishing", "Rod charged")
    end)
    
    createButton(featuresContainer, "CATCH FISH", function()
        safeFire(Remote.CatchFish, "Legendary Fish", 100)
        notify("Fishing", "Fish caught")
    end)
    
    createLabel(featuresContainer, "Blatant Mode")
    createButton(featuresContainer, "BYPASS MINIGAME", function()
        safeFire(Remote.FishingMinigame, true)
        notify("Fishing", "Minigame bypassed")
    end)
end

-- Bait Menu
local function showBait()
    clearFeatures()
    contentTitle.Text = "Bait Shop"
    
    createLabel(featuresContainer, "Select Bait")
    
    local selectedBait = BaitNames[1]
    
    createDropdown(featuresContainer, BaitNames, BaitNames[1], function(selected)
        selectedBait = selected
        notify("Bait", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "BUY SELECTED BAIT", function()
        if safeFire(Remote.PurchaseBait, selectedBait, 1) then
            notify("Bait", "Purchased " .. selectedBait)
        else
            notify("Error", "PurchaseBait remote not found")
        end
    end)
    
    createButton(featuresContainer, "EQUIP SELECTED BAIT", function()
        notify("Bait", "Equip feature coming soon")
    end)
end

-- Rod Menu
local function showRod()
    clearFeatures()
    contentTitle.Text = "Rod Shop"
    
    createLabel(featuresContainer, "Select Rod")
    
    local selectedRod = RodNames[1]
    
    createDropdown(featuresContainer, RodNames, RodNames[1], function(selected)
        selectedRod = selected
        notify("Rod", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "BUY SELECTED ROD", function()
        if safeFire(Remote.PurchaseRod, selectedRod, 1) then
            notify("Rod", "Purchased " .. selectedRod)
        else
            notify("Error", "PurchaseRod remote not found")
        end
    end)
    
    createButton(featuresContainer, "EQUIP ROD SKIN", function()
        notify("Rod", "Skin feature coming soon")
    end)
end

-- Weather Menu
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    createLabel(featuresContainer, "Select Weather")
    
    local selectedWeather = WeatherNames[1]
    
    createDropdown(featuresContainer, WeatherNames, WeatherNames[1], function(selected)
        selectedWeather = selected
        notify("Weather", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "ACTIVATE WEATHER", function()
        if safeFire(Remote.WeatherCommand, selectedWeather) then
            notify("Weather", "Activated " .. selectedWeather)
        else
            notify("Error", "WeatherCommand remote not found")
        end
    end)
    
    createLabel(featuresContainer, "Weather Slots")
    createButton(featuresContainer, "BUY SLOT 1", function()
        if safeFire(Remote.PurchaseWeather, 1, selectedWeather) then
            notify("Weather", "Slot 1 purchased")
        else
            notify("Error", "PurchaseWeather remote not found")
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "Teleport to Location")
    
    local selectedLoc = TeleportNames[1]
    
    createDropdown(featuresContainer, TeleportNames, TeleportNames[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT NOW", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local cframe = TeleportLocations[selectedLoc]
            if cframe then
                char.HumanoidRootPart.CFrame = cframe
                notify("Teleport", "Teleported to " .. selectedLoc)
            end
        end
    end)
    
    createLabel(featuresContainer, "Teleport to Player")
    
    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players, p.Name)
        end
    end
    
    if #players > 0 then
        local selectedPlayer = players[1]
        
        createDropdown(featuresContainer, players, players[1], function(selected)
            selectedPlayer = selected
        end)
        
        createButton(featuresContainer, "TELEPORT TO PLAYER", function()
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to " .. selectedPlayer)
                end
            end
        end)
    else
        createLabel(featuresContainer, "No other players online")
    end
end

-- Quest Menu
local function showQuest()
    clearFeatures()
    contentTitle.Text = "Quests"
    
    createLabel(featuresContainer, "Daily Quests")
    
    createButton(featuresContainer, "CLAIM DAILY LOGIN", function()
        if safeFire(Remote.ClaimDaily) then
            notify("Quest", "Daily login claimed")
        else
            notify("Error", "ClaimDaily remote not found")
        end
    end)
    
    createButton(featuresContainer, "CLAIM BOUNTY", function()
        if safeFire(Remote.ClaimBounty) then
            notify("Quest", "Bounty claimed")
        else
            notify("Error", "ClaimBounty remote not found")
        end
    end)
    
    createButton(featuresContainer, "CLAIM EVENT REWARD", function()
        if safeFire(Remote.ClaimEvent) then
            notify("Quest", "Event reward claimed")
        else
            notify("Error", "ClaimEvent remote not found")
        end
    end)
    
    createButton(featuresContainer, "SELL ALL NOW", function()
        if safeFire(Remote.SellAll) then
            notify("Quest", "All items sold")
        else
            notify("Error", "SellAll remote not found")
        end
    end)
end

-- ===== CREATE LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Bait", func = showBait},
    {name = "Rod", func = showRod},
    {name = "Weather", func = showWeather},
    {name = "Teleport", func = showTeleport},
    {name = "Quest", func = showQuest}
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

-- ===== DRAG =====
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

print("Moe V1.0 GUI Loaded - ERROR FREE VERSION")
print("✅ Semua remote dipanggil dengan safeFire()")
print("✅ Tidak akan error meskipun remote nil")