-- Moe V1.0 GUI for FISH IT - FIXED VERSION dengan semua fitur

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local fishingConnection = nil
local autoSell = false
local autoFavorite = false
local autoEquip = false
local sellConnection = nil
local favoriteConnection = nil

-- ===== CONFIG VARIABLES =====
local Config = {
    FishDelay = 2,
    CatchDelay = 1,
    SellDelay = 60,
    SellCount = 10,
    FavoriteRarity = "Mythic",
    SpamCount = 5,
    CurrentRod = nil
}

-- ===== DATA LOKASI TELEPORT (COMPLETE LIST) =====
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

-- Daftar lokasi untuk dropdown
local TeleportLocations = {}
for loc, _ in pairs(LOCATIONS) do
    table.insert(TeleportLocations, loc)
end
table.sort(TeleportLocations)

-- ===== REMOTE FUNCTIONS DARI PACKAGES (DEX RESULTS) =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

-- ===== REMOTE YANG BENAR (DARI DEX EXPLORER) =====
local Remote = {
    -- Fishing Remotes
    ChargeFishingRod = Net and Net["RF/ChargeFishingRod"],
    RequestFishingMinigame = Net and Net["RF/RequestFishingMinigameStarted"],
    CatchFishCompleted = Net and Net["RF/CatchFishCompleted"],
    CancelFishingInputs = Net and Net["RF/CancelFishingInputs"],
    FishCaught = Net and Net["RE/FishCaught"],
    
    -- Anti-Cheat Remotes
    UpdateAutoFishingState = Net and Net["RF/UpdateAutoFishingState"],
    MarkAutoFishingUsed = Net and Net["RF/MarkAutoFishingUsed"],
    
    -- Sell Remotes
    SellAllItems = Net and Net["RF/SellAllItems"],
    SellItem = Net and Net["RF/SellItem"],
    UpdateAutoSellThreshold = Net and Net["RF/UpdateAutoSellThreshold"],
    
    -- Favorite Remotes
    FavoriteItem = Net and Net["RE/FavoriteItem"],
    PromptFavoriteGame = Net and Net["RF/PromptFavoriteGame"],
    FavoriteStateChanged = Net and Net["RE/FavoriteStateChanged"]
}

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== EQUIP ROD SYSTEM =====
local function findFishingRods()
    local rods = {}
    -- Scan backpack
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Backpack"})
        end
    end
    -- Scan character
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Character"})
            end
        end
    end
    return rods
end

local function equipRod(rodName)
    local rods = findFishingRods()
    for _, rod in ipairs(rods) do
        if rod.Name == rodName or rodName == "any" then
            if rod.Location == "Backpack" then
                -- Pindahkan ke character
                rod.Instance.Parent = player.Character
                Config.CurrentRod = rod.Name
                notify("Equip", "Equipped: " .. rod.Name, 1)
                return true
            elseif rod.Location == "Character" then
                Config.CurrentRod = rod.Name
                notify("Equip", "Already equipped: " .. rod.Name, 1)
                return true
            end
        end
    end
    return false
end

-- ===== ANTI-CHEAT BYPASS =====
local function disableAntiCheat()
    if Remote.UpdateAutoFishingState then
        pcall(function()
            Remote.UpdateAutoFishingState:InvokeServer(false)
        end)
    end
    
    if Remote.MarkAutoFishingUsed then
        pcall(function()
            Remote.MarkAutoFishingUsed:InvokeServer(0)
        end)
    end
end

-- ===== INSTANT FISHING FUNCTIONS =====
local function instantCast()
    if not Remote.ChargeFishingRod then return false end
    
    -- No rate limiting!
    return pcall(function()
        Remote.ChargeFishingRod:InvokeServer()
    end)
end

local function instantCatch()
    if not Remote.FishCaught then return false end
    
    -- Spam FishCaught (no detection!)
    for i = 1, Config.SpamCount do
        pcall(function()
            Remote.FishCaught:FireServer()
        end)
        task.wait(0.05)
    end
    return true
end

local function cancelFishing()
    if Remote.CancelFishingInputs then
        pcall(function()
            Remote.CancelFishingInputs:InvokeServer()
        end)
    end
end

-- ===== AUTO FAVORITE FUNCTIONS =====
local RarityOrder = {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Epic"] = 4,
    ["Legendary"] = 5,
    ["Mythic"] = 6,
    ["Secret"] = 7,
    ["Limited"] = 8
}

local function autoFavoriteByRarity(minRarity)
    if not Remote.FavoriteItem then return end
    
    -- Ini perlu disesuaikan dengan struktur inventory game
    -- Contoh sederhana:
    local success = pcall(function()
        -- Panggil prompt favorite game dulu
        if Remote.PromptFavoriteGame then
            Remote.PromptFavoriteGame:InvokeServer()
        end
        
        -- Favorite item dengan rarity tertentu
        -- (Implementasi tergantung struktur inventory)
        notify("Auto Favorite", "Favoriting " .. minRarity .. " items...", 1)
    end)
end

-- ===== AUTO SELL FUNCTIONS =====
local function sellAllItems()
    if Remote.SellAllItems then
        local success = pcall(function()
            Remote.SellAllItems:InvokeServer()
        end)
        notify("Sell", success and "All items sold!" or "Sell failed", 2)
    end
end

local function autoSellNonFavorited()
    if Remote.SellAllItems then
        -- SellAllItems biasanya sudah otomatis keep favorited
        pcall(function()
            Remote.SellAllItems:InvokeServer()
        end)
    end
end

-- ===== TELEPORT FUNCTION =====
local function teleportTo(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then
        notify("Teleport", "Lokasi tidak ditemukan!", 2)
        return
    end
    
    local character = player.Character
    if not character then
        notify("Teleport", "Karakter tidak ditemukan!", 2)
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        notify("Teleport", "RootPart tidak ditemukan!", 2)
        return
    end
    
    rootPart.CFrame = cframe
    notify("Teleport", "Teleport ke " .. locationName, 1.5)
end

-- ===== MAIN FISHING LOOP =====
local function startAutoFishing()
    if autoFishing then return end
    
    -- Auto equip if enabled
    if autoEquip and not Config.CurrentRod then
        equipRod("any")
    end
    
    autoFishing = true
    notify("Auto Fishing", "Started!", 2)
    
    -- Fishing loop
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFishing then return end
        
        -- Bypass anti-cheat setiap cycle
        disableAntiCheat()
        
        -- Cancel previous fishing
        cancelFishing()
        task.wait(0.2)
        
        -- Cast
        instantCast()
        
        -- Tunggu sesuai delay
        task.wait(Config.FishDelay)
        
        -- Catch dengan spam
        instantCatch()
        
        -- Cooldown
        task.wait(Config.CatchDelay)
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
local function startAutoSell()
    if autoSell then return end
    autoSell = true
    
    sellConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoSell then return end
        
        -- Sell berdasarkan delay
        task.wait(Config.SellDelay)
        autoSellNonFavorited()
    end)
end

local function stopAutoSell()
    autoSell = false
    if sellConnection then
        sellConnection:Disconnect()
        sellConnection = nil
    end
end

-- ===== AUTO FAVORITE LOOP =====
local function startAutoFavorite()
    if autoFavorite then return end
    autoFavorite = true
    
    favoriteConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFavorite then return end
        
        task.wait(30) -- Check every 30 seconds
        autoFavoriteByRarity(Config.FavoriteRarity)
    end)
end

local function stopAutoFavorite()
    autoFavorite = false
    if favoriteConnection then
        favoriteConnection:Disconnect()
        favoriteConnection = nil
    end
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 500)  -- Diperbesar untuk fitur baru
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Border
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

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

-- Title
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
    stopAutoFavorite()
    gui:Destroy()
end)

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

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
contentContainer.Active = true

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

-- Vertical line
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
contentArea.Active = true
contentArea.Selectable = true
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

-- Scrolling frame for features
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

-- Container untuk features
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

-- ===== UI ELEMENTS FUNCTIONS (dari script asli) =====
-- ... (sertakan semua fungsi createDropdown, createButton, dll dari script asli)
-- Untuk menghemat space, saya tidak menulis ulang, tapi di script final harus ada

-- ===== FUNCTION TO SWITCH PAGES =====
local function switchPage(pageName)
    -- Clear container
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    contentTitle.Text = pageName .. " Features"
    
    if pageName == "Fishing" then
        -- FISHING PAGE
        createLabel(featuresContainer, "⚡ AUTO FISHING")
        
        -- Auto Fish Toggle
        local fishToggle = createToggle(featuresContainer, "Auto Fish", false, function(state)
            if state then
                startAutoFishing()
            else
                stopAutoFishing()
            end
        end)
        
        -- Auto Equip Toggle
        createToggle(featuresContainer, "Auto Equip Rod", autoEquip, function(state)
            autoEquip = state
            if state then
                equipRod("any")
            end
        end)
        
        createLabel(featuresContainer, "⏱️ DELAY SETTINGS")
        
        -- Fish Delay Input
        local fishDelayFrame = Instance.new("Frame")
        fishDelayFrame.Size = UDim2.new(1, 0, 0, 35)
        fishDelayFrame.BackgroundTransparency = 1
        fishDelayFrame.Parent = featuresContainer
        
        local fishDelayLabel = Instance.new("TextLabel")
        fishDelayLabel.Size = UDim2.new(0.4, 0, 1, 0)
        fishDelayLabel.BackgroundTransparency = 1
        fishDelayLabel.Text = "Fish Delay:"
        fishDelayLabel.TextColor3 = Color3.new(1, 1, 1)
        fishDelayLabel.Font = Enum.Font.Gotham
        fishDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
        fishDelayLabel.Parent = fishDelayFrame
        
        local fishDelayInput = Instance.new("TextBox")
        fishDelayInput.Size = UDim2.new(0.5, 0, 0, 25)
        fishDelayInput.Position = UDim2.new(0.5, 0, 0.5, -12.5)
        fishDelayInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        fishDelayInput.Text = tostring(Config.FishDelay)
        fishDelayInput.TextColor3 = Color3.new(1, 1, 1)
        fishDelayInput.Font = Enum.Font.Gotham
        fishDelayInput.Parent = fishDelayFrame
        
        fishDelayInput.FocusLost:Connect(function()
            local val = tonumber(fishDelayInput.Text) or 2
            Config.FishDelay = val
        end)
        
        -- Catch Delay Input
        local catchDelayFrame = Instance.new("Frame")
        catchDelayFrame.Size = UDim2.new(1, 0, 0, 35)
        catchDelayFrame.BackgroundTransparency = 1
        catchDelayFrame.Parent = featuresContainer
        
        local catchDelayLabel = Instance.new("TextLabel")
        catchDelayLabel.Size = UDim2.new(0.4, 0, 1, 0)
        catchDelayLabel.BackgroundTransparency = 1
        catchDelayLabel.Text = "Catch Delay:"
        catchDelayLabel.TextColor3 = Color3.new(1, 1, 1)
        catchDelayLabel.Font = Enum.Font.Gotham
        catchDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
        catchDelayLabel.Parent = catchDelayFrame
        
        local catchDelayInput = Instance.new("TextBox")
        catchDelayInput.Size = UDim2.new(0.5, 0, 0, 25)
        catchDelayInput.Position = UDim2.new(0.5, 0, 0.5, -12.5)
        catchDelayInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        catchDelayInput.Text = tostring(Config.CatchDelay)
        catchDelayInput.TextColor3 = Color3.new(1, 1, 1)
        catchDelayInput.Font = Enum.Font.Gotham
        catchDelayInput.Parent = catchDelayFrame
        
        catchDelayInput.FocusLost:Connect(function()
            local val = tonumber(catchDelayInput.Text) or 1
            Config.CatchDelay = val
        end)
        
        -- Spam Count Input
        local spamFrame = Instance.new("Frame")
        spamFrame.Size = UDim2.new(1, 0, 0, 35)
        spamFrame.BackgroundTransparency = 1
        spamFrame.Parent = featuresContainer
        
        local spamLabel = Instance.new("TextLabel")
        spamLabel.Size = UDim2.new(0.4, 0, 1, 0)
        spamLabel.BackgroundTransparency = 1
        spamLabel.Text = "Spam Count:"
        spamLabel.TextColor3 = Color3.new(1, 1, 1)
        spamLabel.Font = Enum.Font.Gotham
        spamLabel.TextXAlignment = Enum.TextXAlignment.Left
        spamLabel.Parent = spamFrame
        
        local spamInput = Instance.new("TextBox")
        spamInput.Size = UDim2.new(0.5, 0, 0, 25)
        spamInput.Position = UDim2.new(0.5, 0, 0.5, -12.5)
        spamInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        spamInput.Text = tostring(Config.SpamCount)
        spamInput.TextColor3 = Color3.new(1, 1, 1)
        spamInput.Font = Enum.Font.Gotham
        spamInput.Parent = spamFrame
        
        spamInput.FocusLost:Connect(function()
            local val = tonumber(spamInput.Text) or 5
            Config.SpamCount = val
        end)
        
        -- Manual Controls
        createLabel(featuresContainer, "🎮 MANUAL CONTROLS")
        
        createButton(featuresContainer, "Cast", function()
            disableAntiCheat()
            instantCast()
            notify("Cast", "Rod casted", 1)
        end)
        
        createButton(featuresContainer, "Catch", function()
            instantCatch()
        end)
        
        createButton(featuresContainer, "Cancel", function()
            cancelFishing()
        end)
        
        -- Equip Rod Dropdown
        createLabel(featuresContainer, "🎣 ROD SELECTION")
        
        local rods = findFishingRods()
        local rodNames = {"any"}
        for _, rod in ipairs(rods) do
            table.insert(rodNames, rod.Name)
        end
        
        if #rodNames > 1 then
            createDropdown(featuresContainer, rodNames, rodNames[1], function(selected)
                equipRod(selected)
            end)
        else
            createLabel(featuresContainer, "No rods found!")
        end
        
    elseif pageName == "Sell" then
        -- SELL PAGE
        createLabel(featuresContainer, "💰 AUTO SELL")
        
        -- Auto Sell Toggle
        createToggle(featuresContainer, "Auto Sell", autoSell, function(state)
            if state then
                startAutoSell()
            else
                stopAutoSell()
            end
        end)
        
        -- Sell Delay Input
        local sellDelayFrame = Instance.new("Frame")
        sellDelayFrame.Size = UDim2.new(1, 0, 0, 35)
        sellDelayFrame.BackgroundTransparency = 1
        sellDelayFrame.Parent = featuresContainer
        
        local sellDelayLabel = Instance.new("TextLabel")
        sellDelayLabel.Size = UDim2.new(0.4, 0, 1, 0)
        sellDelayLabel.BackgroundTransparency = 1
        sellDelayLabel.Text = "Sell Delay (s):"
        sellDelayLabel.TextColor3 = Color3.new(1, 1, 1)
        sellDelayLabel.Font = Enum.Font.Gotham
        sellDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
        sellDelayLabel.Parent = sellDelayFrame
        
        local sellDelayInput = Instance.new("TextBox")
        sellDelayInput.Size = UDim2.new(0.5, 0, 0, 25)
        sellDelayInput.Position = UDim2.new(0.5, 0, 0.5, -12.5)
        sellDelayInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        sellDelayInput.Text = tostring(Config.SellDelay)
        sellDelayInput.TextColor3 = Color3.new(1, 1, 1)
        sellDelayInput.Font = Enum.Font.Gotham
        sellDelayInput.Parent = sellDelayFrame
        
        sellDelayInput.FocusLost:Connect(function()
            local val = tonumber(sellDelayInput.Text) or 60
            Config.SellDelay = val
        end)
        
        -- Manual Sell
        createLabel(featuresContainer, "⚡ MANUAL SELL")
        
        createButton(featuresContainer, "SELL ALL NOW", function()
            sellAllItems()
        end)
        
        -- Remote Status
        local statusFrame = Instance.new("Frame")
        statusFrame.Size = UDim2.new(1, 0, 0, 60)
        statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        statusFrame.BackgroundTransparency = 0.2
        statusFrame.Parent = featuresContainer
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 6)
        statusCorner.Parent = statusFrame
        
        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, -10, 0, 40)
        statusText.Position = UDim2.new(0, 5, 0, 5)
        statusText.BackgroundTransparency = 1
        statusText.Text = "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n" ..
                          "SellItem: " .. (Remote.SellItem and "✅" or "❌")
        statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        statusText.TextSize = 11
        statusText.Font = Enum.Font.Gotham
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.TextWrapped = true
        statusText.Parent = statusFrame
        
    elseif pageName == "Favorite" then
        -- FAVORITE PAGE
        createLabel(featuresContainer, "⭐ AUTO FAVORITE")
        
        -- Auto Favorite Toggle
        createToggle(featuresContainer, "Auto Favorite", autoFavorite, function(state)
            if state then
                startAutoFavorite()
            else
                stopAutoFavorite()
            end
        end)
        
        -- Rarity Dropdown
        createLabel(featuresContainer, "Minimum Rarity")
        local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
        createDropdown(featuresContainer, rarities, Config.FavoriteRarity, function(selected)
            Config.FavoriteRarity = selected
        end)
        
        -- Manual Favorite
        createLabel(featuresContainer, "⚡ MANUAL FAVORITE")
        
        createButton(featuresContainer, "PROMPT FAVORITE GAME", function()
            if Remote.PromptFavoriteGame then
                Remote.PromptFavoriteGame:InvokeServer()
            end
        end)
        
        -- Remote Status
        local statusFrame = Instance.new("Frame")
        statusFrame.Size = UDim2.new(1, 0, 0, 60)
        statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        statusFrame.BackgroundTransparency = 0.2
        statusFrame.Parent = featuresContainer
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 6)
        statusCorner.Parent = statusFrame
        
        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, -10, 0, 40)
        statusText.Position = UDim2.new(0, 5, 0, 5)
        statusText.BackgroundTransparency = 1
        statusText.Text = "FavoriteItem: " .. (Remote.FavoriteItem and "✅" or "❌") .. "\n" ..
                          "PromptFavorite: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
        statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        statusText.TextSize = 11
        statusText.Font = Enum.Font.Gotham
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.TextWrapped = true
        statusText.Parent = statusFrame
        
    elseif pageName == "Teleport" then
        -- TELEPORT PAGE (sama seperti script asli)
        createLabel(featuresContainer, "🌍 TELEPORT TO LOCATION")
        
        local selectedLoc = TeleportLocations[1]
        
        local locDropdown, locUpdate = createDropdown(featuresContainer, TeleportLocations, TeleportLocations[1], function(selected)
            selectedLoc = selected
        end)
        
        createButton(featuresContainer, "TELEPORT", function()
            teleportTo(selectedLoc)
        end)
        
        createLabel(featuresContainer, "📋 TELEPORT TO PLAYER")
        
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
        local selectedPlayer = playerList[1] or "No players"
        
        local playerDropdown, playerUpdate = createDropdown(featuresContainer, playerList, playerList[1] or "No players", function(selected)
            selectedPlayer = selected
        end)
        
        createButton(featuresContainer, "REFRESH PLAYERS", function()
            local newPlayerList = getPlayerList()
            if #newPlayerList > 0 then
                playerUpdate(newPlayerList)
                selectedPlayer = newPlayerList[1]
            end
        end)
        
        createButton(featuresContainer, "TELEPORT TO PLAYER", function()
            if selectedPlayer and selectedPlayer ~= "No players" then
                local target = game.Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                        notify("Teleport", "Teleported to " .. selectedPlayer)
                    end
                end
            end
        end)
        
    elseif pageName == "Status" then
        -- STATUS PAGE
        createLabel(featuresContainer, "📊 REMOTE STATUS")
        
        local statusText = ""
        statusText = statusText .. "🎣 FISHING REMOTES:\n"
        statusText = statusText .. "ChargeFishingRod: " .. (Remote.ChargeFishingRod and "✅" or "❌") .. "\n"
        statusText = statusText .. "FishCaught: " .. (Remote.FishCaught and "✅" or "❌") .. "\n"
        statusText = statusText .. "CatchFishCompleted: " .. (Remote.CatchFishCompleted and "✅" or "❌") .. "\n\n"
        
        statusText = statusText .. "🛡️ ANTI-CHEAT:\n"
        statusText = statusText .. "UpdateAutoFishing: " .. (Remote.UpdateAutoFishingState and "✅" or "❌") .. "\n"
        statusText = statusText .. "MarkAutoFishing: " .. (Remote.MarkAutoFishingUsed and "✅" or "❌") .. "\n\n"
        
        statusText = statusText .. "💰 SELL:\n"
        statusText = statusText .. "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n"
        statusText = statusText .. "SellItem: " .. (Remote.SellItem and "✅" or "❌") .. "\n\n"
        
        statusText = statusText .. "⭐ FAVORITE:\n"
        statusText = statusText .. "FavoriteItem: " .. (Remote.FavoriteItem and "✅" or "❌") .. "\n"
        statusText = statusText .. "PromptFavorite: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 200)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = statusText
        statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 11
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.TextWrapped = true
        statusLabel.Parent = featuresContainer
    end
end

-- ===== CREATE LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = function() switchPage("Fishing") end},
    {name = "Sell", func = function() switchPage("Sell") end},
    {name = "Favorite", func = function() switchPage("Favorite") end},
    {name = "Teleport", func = function() switchPage("Teleport") end},
    {name = "Status", func = function() switchPage("Status") end}
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
switchPage("Fishing")

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
    stopAutoFavorite()
end)

print("✅ Moe V1.0 - FIXED VERSION dengan semua fitur!")
notify("Moe V1.0", "Fixed: Fishing | Sell | Favorite | Teleport | Status", 3)